
let coqdep_files ~dir files ~cctx () =
  let files = List.map (Filename.concat dir) files in
  let args = List.concat [cctx; files] in
  let open Coqdeplib in
  let v_files,state  = Common.init args in
  List.iter Common.treat_file_command_line v_files;
  let deps = Common.compute_deps state in
  deps

let strip_quotes str =
  if Str.string_match (Str.regexp "\"\\(.*\\)\"") str 0 then
    Str.matched_group 1 str
  else
    str

let vfile_header ~dir ?(name="coq-prog-args") vfile =
  let sf = Printf.sprintf in
  let vfile = Filename.concat dir vfile in
  let inc = open_in vfile in
  let line =
    try input_line inc
    with End_of_file -> Format.eprintf "error parsing header: %s@\n%!" vfile; ""
  in
  close_in inc;
  if Str.string_match (Str.regexp (sf ".*%s: (\\([^)]*\\)).*" name)) line 0 then
    (* These arguments are surrounded by quotes so we need to unquote them *)
    Str.matched_group 1 line
    |> Str.split (Str.regexp " ")
    |> List.map strip_quotes
  else []

let rec extra_deps = function
  | "-compat" :: "8.11" :: s -> ["../theories/Compat/Coq811.vo"] @ extra_deps s
  | "-compat" :: "8.12" :: s -> ["../theories/Compat/Coq812.vo"] @ extra_deps s
  | "-compat" :: "8.13" :: s -> ["../theories/Compat/Coq813.vo"] @ extra_deps s
  | "-compat" :: "8.14" :: s -> ["../theories/Compat/Coq814.vo"] @ extra_deps s
  | _ :: s -> extra_deps s
  | [] -> []

let rec chk_filter = function
  (* Arguments that coqchk understands *)
  | "-R" :: dir :: name :: l -> "-R" :: dir :: name :: chk_filter l
  | "-Q" :: dir :: name :: l -> "-Q" :: dir :: name :: chk_filter l
  | "-impredicative-set" :: l -> "-impredicative-set" :: chk_filter l
  | "-indices-matter" :: l -> "-indices-matter" :: chk_filter l
  | _ :: l -> chk_filter l
  | [] -> []

(** coqc rule no vo targets, no log *)
let _coqc_rule ~out ~envs ~exit_codes ~args ~deps vfile =
  let run = "%{bin:coqc}" :: args @ [vfile] in
  Dune.Rules.run ~out ~run ~envs ~exit_codes ~deps ()

(** coqc rule vo target, no log *)
let coqc_vo_rule ~out ~envs ~exit_codes ~args ~deps vfile =
  let run = "%{bin:coqc}" :: args @ [vfile] in
  let targets = [vfile ^ "o"] in
  Dune.Rules.run ~out ~run ~envs ~exit_codes ~deps ~targets ()

(** coqc rule no vo target, log *)
let coqc_log_rule ~out ~envs ~exit_codes ~args ~deps ?(log_ext=".log") vfile =
  let run = "%{bin:coqc}" :: args @ [vfile]  in
  let log_file = vfile ^ log_ext in
  let targets = [log_file] in
  Dune.Rules.run ~out ~run ~envs ~exit_codes ~deps ~targets ~log_file ()

(** coqc rule vo and log targets *)
let coqc_vo_log_rule ~out ~envs ~exit_codes ~args ~deps ?(log_ext=".log") vfile =
  let filename = Filename.chop_extension vfile in
  let vofile = filename ^ ".vo" in
  let log_file = vfile ^ log_ext in
  let globfile = filename ^ ".glob" in
  let auxfile = "." ^ filename ^ ".aux" in
  let run = "%{bin:coqc}" :: args @ [vfile] in
  let targets = [auxfile; vofile; globfile; log_file] in
  Dune.Rules.run ~out ~run ~exit_codes ~deps ~targets ~log_file ()

(* TODO: works but vos needed for stdlib *)
let coqc_vos_log_rule ~out ~envs ~exit_codes ~args ~deps ?(log_ext="os.log") vfile =
  let vosify deps = deps
    |> List.filter_map (Filename.chop_suffix_opt ~suffix:".vo")
    |> List.map (fun x -> x ^ ".vos")
  in
  let deps = deps @ vosify deps in
  let log_file = vfile ^ log_ext in
  let vos_file = vfile ^ "os" in
  let targets = [vos_file; log_file] in
  let run = "%{bin:coqc}" :: args @ ["-vos"; vfile] in
  Dune.Rules.run ~out ~run ~exit_codes ~deps ~targets ~log_file ()

(* TODO: works but vos needed for stdlib *)
let coqc_vok_log_rule ~out ~envs ~exit_codes ~args ~deps ?(log_ext="ok.log") vfile =
  let vosify deps = deps
    |> List.filter_map (Filename.chop_suffix_opt ~suffix:".vo")
    |> List.map (fun x -> x ^ ".vos")
  in
  let deps = deps @ vosify deps in
  let log_file = vfile ^ log_ext in
  let vok_file = vfile ^ "ok" in
  let targets = [vok_file; log_file] in
  let run = "%{bin:coqc}" :: args @ ["-vok"; vfile] in
  Dune.Rules.run ~out ~run ~exit_codes ~deps ~targets ~log_file ()

let coqchk_log_rule ~out ~envs ~exit_codes ~chk_args ~deps ?(log_ext=".chk.log") vfile =
  let vofile = vfile ^ "o" in
  let log_file = vfile ^ log_ext in
  let targets = [log_file] in
  let deps = vofile :: deps in
  let run = ["%{bin:coqchk}"; "-silent"; "-o"] @ chk_args @ ["-norec"; vofile] in
  Dune.Rules.run ~out ~run ~exit_codes ~deps ~targets ~log_file ()

(* TODO: coqnative works but cmxs needed for stdlib *)
let _coqnative_log_rule ~out ~envs ~exit_codes ~args ~deps ?(log_ext=".cmxs.log") vfile =
  (* We need to also require .cmxs files for each .vo file *)
  let cmxsify deps = deps
    |> List.filter_map (Filename.chop_suffix_opt ~suffix:".vo")
    |> List.map (fun x -> x ^ ".cmxs")
  in
  let vofile = vfile ^ "o" in
  let cmxsfile = Filename.chop_extension vfile ^ ".cmxs" in
  let log_file = vfile ^ log_ext in
  let targets = [cmxsfile; log_file] in
  let deps = vofile :: deps @ cmxsify deps in
  let run = "%{bin:coqnative}" :: args @ [vofile] in
  Dune.Rules.run ~out ~run ~exit_codes ~deps ~targets ~log_file ()

let coqc_vio_log_rule ~out ~envs ~exit_codes ~args ~deps ?(log_ext="io.log") vfile =
  let vio_file = vfile ^ "io" in
  let log_file = vfile ^ log_ext in
  let targets = [vio_file; log_file] in
  let run = "%{bin:coqc}" :: args @ ["-vio"; vfile] in
  Dune.Rules.run ~out ~run ~exit_codes ~deps ~targets ~log_file ()

let coqc_vio2vo_log_rule ~out ~envs ~exit_codes ~args ~deps ?(log_ext="io2vo.log") vfile =
  let vofile = vfile ^ "o" in
  let log_file = vfile ^ log_ext in
  let viofile = vfile ^ "io" in
  let targets = [vofile; log_file] in
  let deps = viofile :: deps in
  let run = "%{bin:coqc}" :: args @ ["-vio2vo"; viofile] in
  Dune.Rules.run ~out ~run ~exit_codes ~deps ~targets ~log_file ()

let coqtop_log_rule ~out ~envs ~exit_codes ~args ~deps ?(log_ext=".log") vfile =
  let log_file = vfile ^ log_ext in
  let targets = [log_file] in
  let run = "%{bin:coqtop}" :: args in
  Dune.Rules.run ~out ~run ~exit_codes ~deps ~targets ~log_file ~in_file:vfile ()

(* Preprocessing for output log *)
let with_outputs_to_rule ~out vfile =
  let log_file = vfile ^ ".log" in
  let log_pre_file = vfile ^ ".log.pre" in
  let targets = [log_file] in
  let deps = [log_pre_file] in
  let run = ["../tools/amend-output-log.sh"; log_pre_file] in
  Dune.Rules.run ~out ~run ~deps ~targets ~log_file ~in_file:vfile ()

let diff_rule ~out ?(out_ext=".out") ?(log_ext=".log") vfile =
  Dune.Rules.diff ~out (Filename.remove_extension vfile ^ out_ext) (vfile ^ log_ext)

module Compilation = struct
  module Output = struct
    (* The type of output - dictates which logs we will diff *)
    type t = None | MainJob | CheckJob
    let to_string = function
      | None -> "None"
      | MainJob -> "MainJob"
      | CheckJob -> "CheckJob"
  end

  module Kind = struct
    type t =
    | Vo
    | Vos
    | Vok
    | Vio
    | Vio2vo
    | Coqtop

    let to_string = function
      | Vo -> "vo"
      | Vos -> "vos"
      | Vok -> "vok"
      | Vio -> "vio"
      | Vio2vo -> "vio2vo"
      | Coqtop -> "coqtop"
  end
end

let error_unsupported_build_rule (success, output, kind) () =
  let open Compilation in
  Printf.eprintf
    "*** Error: Combination of arguments:\n + success = %b\n + output = %s\n + kind = %s\nHas chosen a build rule that is not supported.\n"
    success (Output.to_string output) (Kind.to_string kind)

let generate_build_rule ~out ~envs ~exit_codes ~args ~deps ~chk_args ~success ~output ~kind ~coqchk vfile =
  let open Compilation in
  (* Override kind depending on args *)
  let kind =
    if List.mem "-vio2vo" args then Kind.Vio2vo
    else if List.mem "-vio" args then Kind.Vio
    else if List.mem "-vos" args then Kind.Vos
    else if List.mem "-vok" args then Kind.Vok
    else kind
  in

  (* TODO: output rules should be tailored to other flags*)
  match success, output, kind with
  (* vio *)
  | true, Output.None, Kind.Vio ->
    coqc_vio_log_rule ~out ~envs ~exit_codes ~args ~deps vfile
  | true, Output.MainJob, Kind.Vio ->
    coqc_vio_log_rule ~out ~envs ~exit_codes ~args ~deps ~log_ext:".log.pre" vfile;
    with_outputs_to_rule ~out vfile;
    diff_rule ~out vfile;
    ()
  (* vio2vo *)
  | true, Output.None, Kind.Vio2vo ->
    coqc_vio2vo_log_rule ~out ~envs ~exit_codes ~args ~deps vfile;
    if coqchk then coqchk_log_rule ~out ~envs ~exit_codes ~chk_args ~deps vfile;
    ()
  (* vos *)
  | true, Output.None, Kind.Vos ->
    coqc_vos_log_rule ~out ~envs ~exit_codes ~args ~deps vfile
  | true, Output.MainJob, Kind.Vos ->
    coqc_vos_log_rule ~out ~envs ~exit_codes ~args ~deps ~log_ext:".log.pre" vfile;
    with_outputs_to_rule ~out vfile;
    diff_rule ~out vfile;
    ()
  (* vok *)
  | true, Output.None, Kind.Vok ->
    coqc_vok_log_rule ~out ~envs ~exit_codes ~args ~deps vfile
  (* vo *)
  | true, Output.None, Kind.Vo ->
    coqc_vo_log_rule ~out ~envs ~exit_codes ~args ~deps vfile;
    if coqchk then coqchk_log_rule ~out ~envs ~exit_codes ~chk_args ~deps vfile;
    ()
  (* failing vo *)
  | false, Output.None, Kind.Vo ->
    coqc_log_rule ~out ~envs ~exit_codes ~args ~deps vfile
  (* output rule *)
  | true, Output.MainJob, Kind.Vo ->
    coqc_vo_log_rule ~out ~envs ~exit_codes ~args ~deps ~log_ext:".log.pre" vfile;
    with_outputs_to_rule ~out vfile;
    diff_rule ~out vfile;
    if coqchk then coqchk_log_rule ~out ~envs ~exit_codes ~chk_args ~deps vfile;
    ()
  (* checking output of coqchk *)
  | true, Output.CheckJob, Kind.Vo ->
    coqc_vo_rule ~out ~envs ~exit_codes ~args ~deps vfile;
    coqchk_log_rule ~out ~envs ~exit_codes ~chk_args ~deps ~log_ext:".log.pre" vfile;
    (* TODO are these right? *)
    with_outputs_to_rule ~out vfile;
    diff_rule ~out vfile;
    ()
  (* failing output rule *)
  | false, Output.MainJob, Kind.Vo ->
    coqc_log_rule ~out ~envs ~exit_codes ~args ~deps ~log_ext:".log.pre" vfile;
    with_outputs_to_rule ~out vfile;
    diff_rule ~out vfile;
    ()
  (* coqtop rule *)
  | true, Output.None, Kind.Coqtop ->
    coqtop_log_rule ~out ~envs ~exit_codes ~args ~deps vfile;
    ()
  | true, Output.MainJob, Kind.Coqtop ->
    coqtop_log_rule ~out ~envs ~exit_codes ~args ~deps ~log_ext:".log.pre" vfile;
    Dune.Rules.run_pipe ~out:out
      ~runs:
        [ ["grep"; "-v"; "\"Welcome to Coq\""; vfile ^ ".log.pre"]
        ; ["grep"; "-v"; "\"Loading ML file\""]
        ; ["grep"; "-v"; "\"Skipping rcfile loading\""]
        ; ["grep"; "-v"; "\"^<W>\""] ]
      ~log_file:(vfile ^ ".log") ();
    diff_rule ~out vfile;
    ()
  | arguments -> error_unsupported_build_rule arguments ()


let generate_rule ~out ~cctx ~dir ~lvl ~args ~base_deps ~deps ~envs ~exit_codes ~output ~kind ~coqchk
  (vfile_dep_info : Coqdeplib.Common.Dep_info.t) =

  let open Coqdeplib.Common in
  let vfile_long =  vfile_dep_info.Dep_info.name ^ ".v" in
  let vfile =
    let regex = Str.regexp (Str.quote @@ dir ^ "/") in
    Str.global_replace regex "" vfile_long
  in
  (* Adjust paths to META *)
  let vfile_deps =
    let f = function
    | Dep.Require s -> Dep.Require s
    | Dep.Other s ->
        (* TODO: not just META *)
        (* Printf.printf "vfile: %s META: %s\n" vfile s; *)
        Dep.Other (Str.replace_first (Str.regexp ".*/lib/coq-core") "../../install/default/lib/coq-core" s)
    in
    List.map f vfile_dep_info.Dep_info.deps
  in
  (* Dependencies are the .vo files given by coqdep and the original .v file *)
  let vfile_deps = vfile_long :: List.map (Dep.to_string ~suffix:".vo") vfile_deps in
  (* parse the header of the .v file for extra arguments *)
  let args = vfile_header ~dir vfile @ args in
  (* lvl adjustment done here *)
  let deps = deps @ (base_deps @ extra_deps args @ vfile_deps |> List.map (fun x -> lvl ^ "/" ^ x)) in
  let args = cctx @ args in
  let chk_args = chk_filter args in
  let success =
    match exit_codes with
    | [] -> true
    | l -> List.exists (fun x -> 0 = x) l
  in
  generate_build_rule ~out ~envs:(envs vfile) ~exit_codes ~args ~chk_args ~deps ~success ~output ~kind ~coqchk vfile

let check_dir ~out ~cctx ?(ignore=[]) ?copy_csdp_cache
  ?(args=[]) ?(base_deps=[]) ?(deps=[]) ?(envs=fun _ -> []) ?(exit_codes=[])
  ?(output=Compilation.Output.None) ?(kind=Compilation.Kind.Vo) ?(coqchk=true) dir =
  (* Scan for all .v files in directory ignoring as necessary *)
  let vfiles = Dir.scan_files_by_ext ~ext:".v" ~ignore dir in
  (* Run coqdep to get deps *)
  let coq_deps = coqdep_files ~cctx:(cctx ".") ~dir vfiles () in
  (* The lvl can be computed from the dir *)
  let lvl = Dir.back_to_root dir in
  (* If the csdp cache copy is set then we add the special alias as a dep *)
  let deps = match copy_csdp_cache with None -> deps | Some _ -> "(alias csdp-cache)" :: deps in
  Dune.Rules.in_subdir out dir ~f:(fun out () ->
    List.iter (generate_rule ~cctx:(cctx lvl) ~lvl ~args ~base_deps ~deps ~output ~kind ~coqchk ~envs ~exit_codes ~out ~dir) coq_deps;
    match copy_csdp_cache with
    | None -> ()
    | Some copy_csdp_cache ->
      let copy_csdp_cache = Filename.concat lvl copy_csdp_cache in
      (* Add rule for copying .csdp.cache *)
      let action =
        let open Dune.Action in
        Progn [
          No_infer (Copy (copy_csdp_cache, ".csdp.cache"));
          Run ["chmod"; "+w"; ".csdp.cache"];
        ]
      in
      let rule = Dune.Rule.{
        targets = [];
        deps = ["(universe)"; copy_csdp_cache];
        action ;
        alias = Some "csdp-cache";
      } in
      Dune.Rule.pp out rule)
