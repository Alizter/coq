
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

let exit_codes_to_string = function
  | [] -> "0"
  | l -> Printf.sprintf "(or %s)" @@ String.concat " " (List.map string_of_int l)

(** coqc rule no vo targets, no log *)
let _coqc_rule ~fmt ~exit_codes ~args ~deps vfile =
  let open Dune.Rule in
  let rule =
    { targets = []
    ; deps
    ; action = Format.asprintf
        "(with-accepted-exit-codes %s (run coqc %s %s))"
        (exit_codes_to_string exit_codes) args vfile
    ; alias = Some "runtest"
    }
  in
  pp fmt rule

(** coqc rule vo target, no log *)
let coqc_vo_rule ~fmt ~exit_codes ~args ~deps vfile =
  let open Dune.Rule in
  let rule =
    { targets = [vfile ^ "o"]
    ; deps
    ; action = Format.asprintf
        "(with-accepted-exit-codes %s (run coqc %s %s))"
        (exit_codes_to_string exit_codes) args vfile
    ; alias = Some "runtest"
    }
  in
  pp fmt rule

(** coqc rule no vo target, log *)
let coqc_log_rule ~fmt ~exit_codes ~args ~deps ?(log_ext=".log") vfile =
  let open Dune.Rule in
  let rule =
    { targets = [vfile ^ log_ext]
    ; deps
    ; action = Format.asprintf
    "(with-outputs-to %s (with-accepted-exit-codes %s (run coqc %s %s)))"
    (vfile ^ log_ext) (exit_codes_to_string exit_codes) args vfile
    ; alias = Some "runtest"
    }
  in
  pp fmt rule

(** coqc rule vo and log targets *)
let coqc_vo_log_rule ~fmt ~exit_codes ~args ~deps ?(log_ext=".log") vfile =
  let open Dune.Rule in
  let filename = Filename.chop_extension vfile in
  let vofile = filename ^ ".vo" in
  let vlogfile = vfile ^ log_ext in
  let globfile = filename ^ ".glob" in
  let auxfile = "." ^ filename ^ ".aux" in
  let rule =
    { targets = [vofile; vlogfile; globfile; auxfile]
    ; deps
    ; action = Format.asprintf
        "(with-outputs-to %s (with-accepted-exit-codes %s (run coqc %s %s)))"
        (vfile ^ log_ext) (exit_codes_to_string exit_codes) args vfile
    ; alias = Some "runtest"
    }
  in
  pp fmt rule

(* TODO: works but vos needed for stdlib *)
let coqc_vos_log_rule ~fmt ~exit_codes ~args ~deps ?(log_ext="os.log") vfile =
  let open Dune.Rule in
  let vosify deps = deps
    |> List.filter_map (Filename.chop_suffix_opt ~suffix:".vo")
    |> List.map (fun x -> x ^ ".vos")
  in
  let rule =
    { targets = [vfile ^ "os"; vfile ^ log_ext]
    (* TODO: get rid of deps? Do we need to depend on vo? *)
    ; deps = deps @ vosify deps
    ; action = Format.asprintf
        "(with-outputs-to %s (with-accepted-exit-codes %s (run coqc %s -vos %s)))"
        (vfile ^ log_ext) (exit_codes_to_string exit_codes) args vfile
    ; alias = Some "runtest"
    }
  in
  pp fmt rule

(* TODO: works but vos needed for stdlib *)
let coqc_vok_log_rule ~fmt ~exit_codes ~args ~deps ?(log_ext="ok.log") vfile =
  let open Dune.Rule in
  let vosify deps = deps
    |> List.filter_map (Filename.chop_suffix_opt ~suffix:".vo")
    |> List.map (fun x -> x ^ ".vos")
  in
  let rule =
    { targets = [vfile ^ "ok"; vfile ^ log_ext]
    ; deps = deps @ vosify deps
    ; action = Format.asprintf
        "(with-outputs-to %s (with-accepted-exit-codes %s (run coqc %s -vok %s)))"
        (vfile ^ log_ext) (exit_codes_to_string exit_codes) args vfile
    ; alias = Some "runtest"
    }
  in
  pp fmt rule

let coqchk_log_rule ~fmt ~exit_codes ~chk_args ~deps ?(log_ext=".chk.log") vfile =
  let open Dune.Rule in
  let vofile = vfile ^ "o" in
  let rule =
    { targets = [vfile ^ log_ext]
    ; deps = vofile :: deps
    ; action = Format.asprintf
        "(with-outputs-to %s (with-accepted-exit-codes %s (run coqchk -silent -o %s -norec %s)))"
        (vfile ^ log_ext) (exit_codes_to_string exit_codes) chk_args vofile
    ; alias = Some "runtest"
    }
  in
  pp fmt rule

(* TODO: coqnative works but cmxs needed for stdlib *)
let _coqnative_log_rule ~fmt ~exit_codes ~args ~deps ?(log_ext=".cmxs.log") vfile =
  let open Dune.Rule in
  (* We need to also require .cmxs files for each .vo file *)
  let cmxsify deps = deps
    |> List.filter_map (Filename.chop_suffix_opt ~suffix:".vo")
    |> List.map (fun x -> x ^ ".cmxs")
  in
  let vofile = vfile ^ "o" in
  let cmxsfile = Filename.chop_extension vfile ^ ".cmxs" in
  let rule =
    { targets = [cmxsfile; vfile ^ log_ext]
    ; deps = vofile :: deps @ cmxsify deps
    ; action = Format.asprintf
        "(with-outputs-to %s (with-accepted-exit-codes %s (run coqnative %s %s)))"
        (vfile ^ log_ext) (exit_codes_to_string exit_codes) args vofile
    ; alias = Some "runtest"
    }
  in
  pp fmt rule

let coqc_vio_log_rule ~fmt ~exit_codes ~args ~deps ?(log_ext="io.log") vfile =
  let open Dune.Rule in
  let rule =
    (* TODO: do we want .vio versions of deps here? (prob need stdlib vio first) *)
    { targets = [vfile ^ "io"; vfile ^ log_ext]
    ; deps
    ; action = Format.asprintf
        "(with-outputs-to %s (with-accepted-exit-codes %s (run coqc %s -vio %s)))"
        (vfile ^ log_ext) (exit_codes_to_string exit_codes) args vfile
    ; alias = Some "runtest"
    }
  in
  pp fmt rule

let coqc_vio2vo_log_rule ~fmt ~exit_codes ~args ~deps ?(log_ext="io2vo.log") vfile =
  let open Dune.Rule in
  let _vioify deps = deps
    |> List.filter_map (Filename.chop_suffix_opt ~suffix:".vo")
    |> List.map (fun x -> x ^ ".vio")
  in
  let rule =
    { targets = [vfile ^ "o"; vfile ^ log_ext]
    (* ; deps = deps @ vioify deps *)
    ; deps = deps @ [vfile ^ "io"]
    ; action = Format.asprintf
        "(with-outputs-to %s (with-accepted-exit-codes %s (run coqc %s -vio2vo %s)))"
        (vfile ^ log_ext) (exit_codes_to_string exit_codes) args (vfile ^ "io")
    ; alias = Some "runtest"
    }
  in
  pp fmt rule

let coqtop_log_rule ~fmt ~exit_codes ~args ~deps ?(log_ext=".log") vfile =
  let open Dune.Rule in
  let vlogfile = vfile ^ log_ext in
  let rule =
    { targets = [vlogfile]
    ; deps
    ; action = Format.asprintf
        "(with-outputs-to %s (with-accepted-exit-codes %s (with-stdin-from %s (run coqtop %s))))"
        (vfile ^ log_ext) (exit_codes_to_string exit_codes) vfile args
    ; alias = Some "runtest"
    }
  in
  pp fmt rule

(* Preprocessing for output log *)
let with_outputs_to_rule ~fmt vfile =
  let open Dune.Rule in
  let action = Format.asprintf "(with-outputs-to %s (run ../tools/amend-output-log.sh %s))" (vfile ^ ".log") (vfile ^ ".log.pre") in
  let rule_log =
    { targets = [vfile ^ ".log"]
    ; deps = (*extra_deps @*) [vfile ^ ".log.pre"]
    ; action
    ; alias = None
    }
  in
  pp fmt rule_log

let diff_rule ~fmt ?(out_ext=".out") ?(log_ext=".log") vfile =
  Dune.Rules.diff fmt (Filename.remove_extension vfile ^ out_ext) (vfile ^ log_ext)

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

let generate_build_rule ~fmt ~exit_codes ~args ~deps ~chk_args ~success ~output ~kind ~coqchk vfile =
  let open Compilation in
  (* Override kind depending on args *)
  let kind =
    if List.mem "-vio2vo" args then Kind.Vio2vo
    else if List.mem "-vio" args then Kind.Vio
    else if List.mem "-vos" args then Kind.Vos
    else if List.mem "-vok" args then Kind.Vok
    else kind
  in
  let args = String.concat " " args in
  let chk_args = String.concat " " chk_args in

  (* TODO: output rules should be tailored to other flags*)
  match success, output, kind with
  (* vio *)
  | true, Output.None, Kind.Vio ->
    coqc_vio_log_rule ~fmt ~exit_codes ~args ~deps vfile
  | true, Output.MainJob, Kind.Vio ->
    coqc_vio_log_rule ~fmt ~exit_codes ~args ~deps ~log_ext:".log.pre" vfile;
    with_outputs_to_rule ~fmt vfile;
    diff_rule ~fmt vfile;
    ()
  (* vio2vo *)
  | true, Output.None, Kind.Vio2vo ->
    coqc_vio2vo_log_rule ~fmt ~exit_codes ~args ~deps vfile;
    if coqchk then coqchk_log_rule ~fmt ~exit_codes ~chk_args ~deps vfile;
    ()
  (* vos *)
  | true, Output.None, Kind.Vos ->
    coqc_vos_log_rule ~fmt ~exit_codes ~args ~deps vfile
  | true, Output.MainJob, Kind.Vos ->
    coqc_vos_log_rule ~fmt ~exit_codes ~args ~deps ~log_ext:".log.pre" vfile;
    with_outputs_to_rule ~fmt vfile;
    diff_rule ~fmt vfile;
    ()
  (* vok *)
  | true, Output.None, Kind.Vok ->
    coqc_vok_log_rule ~fmt ~exit_codes ~args ~deps vfile
  (* vo *)
  | true, Output.None, Kind.Vo ->
    coqc_vo_log_rule ~fmt ~exit_codes ~args ~deps vfile;
    if coqchk then coqchk_log_rule ~fmt ~exit_codes ~chk_args ~deps vfile;
    ()
  (* failing vo *)
  | false, Output.None, Kind.Vo ->
    coqc_log_rule ~fmt ~exit_codes ~args ~deps vfile
  (* output rule *)
  | true, Output.MainJob, Kind.Vo ->
    coqc_vo_log_rule ~fmt ~exit_codes ~args ~deps ~log_ext:".log.pre" vfile;
    with_outputs_to_rule ~fmt vfile;
    diff_rule ~fmt vfile;
    if coqchk then coqchk_log_rule ~fmt ~exit_codes ~chk_args ~deps vfile;
    ()
  (* checking output of coqchk *)
  | true, Output.CheckJob, Kind.Vo ->
    coqc_vo_rule ~fmt ~exit_codes ~args ~deps vfile;
    coqchk_log_rule ~fmt ~exit_codes ~chk_args ~deps ~log_ext:".log.pre" vfile;
    (* TODO are these right? *)
    with_outputs_to_rule ~fmt vfile;
    diff_rule ~fmt vfile;
    ()
  (* failing output rule *)
  | false, Output.MainJob, Kind.Vo ->
    coqc_log_rule ~fmt ~exit_codes ~args ~deps ~log_ext:".log.pre" vfile;
    with_outputs_to_rule ~fmt vfile;
    diff_rule ~fmt vfile;
    ()
  (* coqtop rule *)
  | true, Output.None, Kind.Coqtop ->
    coqtop_log_rule ~fmt ~exit_codes ~args ~deps vfile;
    ()
  | true, Output.MainJob, Kind.Coqtop ->
    coqtop_log_rule ~fmt ~exit_codes ~args ~deps ~log_ext:".log.pre" vfile;
    Dune.Rules.run_pipe ~out:fmt
      ~runs:
        [ Printf.sprintf "grep -v \"Welcome to Coq\" %s" (vfile ^ ".log.pre")
        ; "grep -v \"Loading ML file\""
        ; "grep -v \"Skipping rcfile loading\""
        ; "grep -v \"^<W>\"" ]
      ~log_file:(vfile ^ ".log") ();
    diff_rule ~fmt vfile;
    ()
  | arguments -> error_unsupported_build_rule arguments ()


let generate_rule ~fmt ~cctx ~dir ~lvl ~args ~base_deps ~exit_codes ~output ~kind ~coqchk
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
  let deps = extra_deps args @ base_deps @ vfile_deps |> List.map (fun x -> lvl ^ "/" ^ x) in
  let args = cctx @ args in
  let chk_args = chk_filter args in
  let success =
    match exit_codes with
    | [] -> true
    | l -> List.exists (fun x -> 0 = x) l
  in
  generate_build_rule ~fmt ~exit_codes ~args ~chk_args ~deps ~success ~output ~kind ~coqchk vfile

let check_dir ~cctx ?(args=[]) ?(base_deps=[]) ?(exit_codes=[])
  ?(output=Compilation.Output.None) ?(kind=Compilation.Kind.Vo) ?(coqchk=true) dir fmt =
  (* Scan for all .v files in directory *)
  let vfiles = Dir.scan_files_by_ext ".v" dir in
  (* Run coqdep to get deps *)
  let deps = coqdep_files ~cctx:(cctx ".") ~dir vfiles () in
  (* The lvl can be computed from the dir *)
  let lvl = Dir.back_to_root dir in
  Dune.Rules.in_subdir dir fmt ~f:(fun () ->
    List.iter (generate_rule ~cctx:(cctx lvl) ~lvl ~args ~base_deps ~output ~kind ~coqchk ~exit_codes ~fmt ~dir) deps)
