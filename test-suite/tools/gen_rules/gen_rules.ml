(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *   INRIA, CNRS and contributors - Copyright 1999-2019       *)
(* <O___,, *       (see CREDITS file for the list of authors)           *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

(* gen_rules: generate dune build rules for Coq's test-suite            *)
(* It is desirable that this file can be bootstrapped alone             *)

open Util

let option_default dft = function None -> dft | Some txt -> txt

let back_to_root dir =
  let rec back_to_root_aux = function
  | [] -> []
  | l :: ls -> ".." :: back_to_root_aux ls
  in
  Str.split (Str.regexp "/") dir
  |> back_to_root_aux
  |> String.concat "/"

let scan_vfiles dir =
  Sys.readdir dir
  |> Array.to_list
  |> List.filter (fun f -> Filename.check_suffix f ".v")

module Dune = struct
  module Rule = struct
    type t =
      { targets : string list
      ; deps : string list
      ; action : string
      ; alias : string option
      }

    let ppl = pp_list Format.pp_print_string sep
    let pp_alias fmt = function
      | None -> ()
      | Some alias -> Format.fprintf fmt "(alias %s)@\n" alias

    let pp fmt { alias; targets; deps; action } =
      Format.fprintf fmt
        "@[(rule@\n @[%a(targets @[%a@])@\n(deps @[%a@])@\n(action @[%a@])@])@]@\n"
        pp_alias alias ppl targets ppl deps Format.pp_print_string action
  end
end

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

let vfile_header ~dir vfile =
  let vfile = Filename.concat dir vfile in
  let inc = open_in vfile in
  let line = try
      input_line inc
    with End_of_file ->
      Format.eprintf "error parsing header: %s@\n%!" vfile;
      ""
  in
  close_in inc;
  if Str.string_match (Str.regexp ".*coq-prog-args: (\\([^)]*\\)).*") line 0 then
    begin
      (* These arguments are surrounded by quotes so we need to unquote them *)
      let pargs =
        Str.matched_group 1 line
        |> Str.split (Str.regexp " ")
        |> List.map strip_quotes
        |> String.concat " "
      in
      Some pargs
    end
  else
    None

let flatten_args args =
  args
  (* |> List.map (fun x -> "\"" ^ x ^ "\"") *)
  |> String.concat " "

let extra_deps s =
  match s with
  | "\"-compat\" \"8.11\"" -> ["../../theories/Compat/Coq811.vo"]
  | "\"-compat\" \"8.12\"" -> ["../../theories/Compat/Coq812.vo"]
  | "\"-compat\" \"8.13\"" -> ["../../theories/Compat/Coq813.vo"]
  | "\"-compat\" \"8.14\"" -> ["../../theories/Compat/Coq814.vo"]
  | _ -> []

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
let _coqc_vo_rule ~fmt ~exit_codes ~args ~deps vfile =
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
  let rule =
    { targets = [vfile ^ "o"; vfile ^ log_ext]
    ; deps
    ; action = Format.asprintf
        "(with-outputs-to %s (with-accepted-exit-codes %s (run coqc %s %s)))"
        (vfile ^ log_ext) (exit_codes_to_string exit_codes) args vfile
    ; alias = Some "runtest"
    }
  in
  pp fmt rule

(* TODO: works but vos needed for stdlib *)
let _coqc_vos_log_rule ~fmt ~exit_codes ~args ~deps ?(log_ext=".vos.log") vfile =
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
let _coqc_vok_log_rule ~fmt ~exit_codes ~args ~deps ?(log_ext=".vok.log") vfile =
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

let _coqchk_log_rule ~fmt ~exit_codes ~args ~deps ?(log_ext=".chk.log") vfile =
  let open Dune.Rule in
  let vofile = vfile ^ "o" in
  let rule =
    { targets = [vfile ^ log_ext]
    ; deps = vofile :: deps
    ; action = Format.asprintf
        "(with-outputs-to %s (with-accepted-exit-codes %s (run coqchk %s -norec %s)))"
        (vfile ^ log_ext) (exit_codes_to_string exit_codes) args vofile
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

let _coqc_vio_log_rule ~fmt ~exit_codes ~args ~deps ?(log_ext=".vio.log") vfile =
  let open Dune.Rule in
  let vioify deps = deps
    |> List.filter_map (Filename.chop_suffix_opt ~suffix:".vo")
    |> List.map (fun x -> x ^ ".vio")
  in
  let rule =
    { targets = [vfile ^ "io"; vfile ^ log_ext]
    ; deps = deps @ vioify deps
    ; action = Format.asprintf
        "(with-outputs-to %s (with-accepted-exit-codes %s (run coqc %s -vio %s)))"
        (vfile ^ log_ext) (exit_codes_to_string exit_codes) args vfile
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
  let open Dune.Rule in
  let rule_diff =
    { targets = []
    ; deps = []
    ; action = Format.asprintf "(diff %s %s)" (Filename.remove_extension vfile ^ out_ext) (vfile ^ log_ext)
    ; alias = Some "runtest"
    } in
  pp fmt rule_diff

let error_unsupported_build_rule (success, output, vio, vio2vo, vok, vos) () =
  Printf.eprintf
    "Combination of arguments:\n + success=%b\n + output%b\n + vio=%b\n + vio2vo=%b\n + vok=%b\n + vos=%b: has chosen a build rule that is not supported."
    success output vio vio2vo vok vos

let generate_build_rule ~fmt ~exit_codes ~args ~deps ?(chk_args="") ?(output=false) vfile =
  (* TODO: determination of what to do here needs to be more complicated vio, vos cmxs etc. *)
  (* We only generate vo files if coqc exits in success *)
  let success =
    match exit_codes with
    | [] -> true
    | l -> List.exists (fun x -> 0 = x) l
  in
  let vio = Str.string_match (Str.regexp ".*-vio") args 0 in
  let vio2vo = Str.string_match (Str.regexp ".*-vio2vo") args 0 in
  let vok = Str.string_match (Str.regexp ".*-vok") args 0 in
  let vos = Str.string_match (Str.regexp ".*-vos") args 0 in
  (* TODO: detect native *)

  (* TODO: output rules should be tailored to other flags*)

  match success, output, vio, vio2vo, vok, vos with
  (* Compilation flags - Only one should be true at a time TODO: perhaps not so strictly tho*)
  | true, false, true, false, false, false -> (* vio *)
    _coqc_vio_log_rule ~fmt ~exit_codes ~args ~deps vfile

  | true, false, false, true, false, false -> () (* vio2vo *)


  (* | true, false, false, false, true, false -> () vok *)
  | true, false, false, false, false, true ->
    _coqc_vos_log_rule ~fmt ~exit_codes ~args ~deps vfile

  | true, false, false, false, false, false ->
    coqc_vo_log_rule ~fmt ~exit_codes ~args ~deps vfile;
    ()

  | false, false, false, false, false, false ->
    coqc_log_rule ~fmt ~exit_codes ~args ~deps vfile;
    ()

  | _, true, _, _, _, _ ->
    (* output rule *)
    coqc_vo_log_rule ~fmt ~exit_codes ~args ~deps ~log_ext:".log.pre" vfile;
    with_outputs_to_rule ~fmt vfile;
    diff_rule ~fmt vfile;
    ()
  | arguments -> error_unsupported_build_rule arguments ()


let generate_rule
  (* Formatter *)
  ~fmt
  (* Common context - arguments passed both to coqdep and coqc*)
  ~cctx
  (* Root directory - e.g. bugs/ *)
  ~dir
  (* Lvl - The correction given to files in the directory - e.g. ../ *)
  ~lvl
  (* Arguments to pass to coqc *)
  ~args
  (* Base dependencies of rule *)
  ~base_deps
  (* Accpted exit codes *)
  ~exit_codes
  (* Should the output of the test be checked? *)
  ~output
  (* The dependency output of coqdep *)
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
        (* Printf.printf "vfile: %s META: %s\n" vfile s; *)
        Dep.Other (Str.replace_first (Str.regexp ".*/lib/coq-core") "../../install/default/lib/coq-core" s)
    in
    List.map f vfile_dep_info.Dep_info.deps
  in
  (* Dependencies are the .vo files given by coqdep *)
  let vfile_deps = List.map (Dep.to_string ~suffix:".vo") vfile_deps in
  (* We also add the original .v file *)
  let vfile_deps = vfile_long :: vfile_deps in
  (* lvl adjustment done here *)
  let vfile_deps = List.map ((^) (lvl ^ "/")) vfile_deps in
  (* parse the header of the .v file for extra arguments *)
  let extra_args = option_default "" (vfile_header ~dir vfile) ^ " " ^ flatten_args args in
  let extra_deps = extra_deps extra_args @ base_deps in

  generate_build_rule ~fmt ~exit_codes ~args:((flatten_args cctx) ^ " " ^ extra_args) ~deps:(extra_deps @ vfile_deps) ~output vfile

let check_dir ~cctx ?lvl ?(args=[]) ?(base_deps=[]) ?(exit_codes=[]) ?(output=false) dir fmt =
  (* Scan for all .v files in directory *)
  let vfiles = scan_vfiles dir in
  (* Run coqdep to get deps *)
  let deps = coqdep_files ~cctx:(cctx ".") ~dir vfiles () in
  (* The lvl can be computed from the dir *)
  let lvl = match lvl with
    | Some l -> l
    | None -> back_to_root dir
  in
  (* Begin prinitng subdir stanza *)
  Format.fprintf fmt "(subdir %s@\n @[" dir;
  let () =
    try
      (* Generate rule for each set of dependencies  *)
      List.iter (generate_rule ~cctx:(cctx lvl) ~lvl ~args ~base_deps ~output ~exit_codes ~fmt ~dir) deps
    (* Make sure we gracefully balance the file before throwing an excpetion *)
    with exn -> Format.fprintf fmt "@])@\n"; raise exn
  in
  Format.fprintf fmt "@])@\n";
  ()

let output_rules out =

  (* Common context - This will be passed to coqdep and coqc *)
  let cctx lvl = [
    "-boot";
    "-I"; lvl ^ "/../../install/default/lib";
    "-R"; lvl ^ "/../theories" ; "Coq";
    "-R"; lvl ^ "/prerequisite"; "TestSuite";
    "-Q"; lvl ^ "/../user-contrib/Ltac2"; "Ltac2" ]
  in
  (* Working! *)
  check_dir "bugs" out ~cctx;

  (* TODO: complexity *)

  (* TODO: coq-makefile *)

  (* TODO: coqchk *)

  (* TODO: coqdoc *)

  (* TODO: coqwc *)

  (* Working! *)
  check_dir "failure" out ~cctx;

  (* TODO: ide *)

  (* TODO: interactive *)

  (* Working! *)
  check_dir "ltac2" out ~cctx;

  (* !! Something is broken here: *)
  (* TODO: not working *)
  (* check_dir "micromega" out ~base_deps:[".csdp.cache"] ~cctx; *)

  (* TODO: make cram *)
  (* check_dir "misc" out ~cctx; *)

  (* TODO: make cram? *)
  (* check_dir "modules" out ~cctx:(fun lvl -> ["-R"; lvl; "Mods"] @ cctx lvl); *)

  (* !! Something is broken here: *)
  check_dir "output" out ~cctx ~output:true ~args:["-test-mode"; "-async-proofs-cache"; "force"];

  (* TODO: output-coqchk *)

  (* TODO: output-coqtop *)

  (* TODO: output-modulo-time *)

  (* Working! *)
  check_dir "primitive/arrays" out ~cctx;
  check_dir "primitive/float" out ~cctx;
  check_dir "primitive/sint63" out ~cctx;
  check_dir "primitive/uint63" out ~cctx;
  (* Working! *)
  check_dir "ssr" out ~cctx;
  (* Working! *)
  check_dir "stm" out ~cctx ~args:["-async-proofs"; "on"];

  (* TODO: not working *)
  (* check_dir "success" out ~cctx; *)

  (* TODO: vio, cram? *)
  ()

let main () =
  let out = open_out "test_suite_rules.sexp" in
  let fmt = Format.formatter_of_out_channel out in
  output_rules fmt;
  Format.pp_print_flush fmt ();
  close_out out

let () =
  Printexc.record_backtrace true;
  try main ()
  with exn ->
    let bt = Printexc.get_backtrace () in
    let exn = Printexc.to_string exn in
    Format.eprintf "%s@\n%s@\n%!" exn bt

(* output output-coqtop output-modulo-time $(INTERACTIVE) $(COMPLEXITY)
   stm coqdoc ssr primitive ltac2
   ide vio coqchk output-coqchk coqwc coq-makefile tools $(UNIT_TESTS)
*)
