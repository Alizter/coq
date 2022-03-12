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

open Format
open Util

let option_default dft = function None -> dft | Some txt -> txt

module Options = struct

  type flag = {
    enabled : bool;
    cmd : string;
  }

  let all_opts =
  [ { enabled = false; cmd = "-debug"; }
  ; { enabled = false; cmd = "-native_compiler"; }
  ; { enabled = true; cmd = "-w +default"; }
  ]

  let build_coq_flags () =
    let popt o = if o.enabled then Some o.cmd else None in
    String.concat " " @@ pmap popt all_opts
end

(* type ddir = Coqdep.Vodep.t list DirMap.t *)

(* We could have coqdep to output dune files directly *)

let gen_sub n =
  (* Move to List.init once we can depend on OCaml >= 4.06.0 *)
  bpath @@ Legacy.list_init n (fun _ -> "..")

let pp_rule fmt targets deps action =
  (* Special printing of the first rule *)
  let ppl = pp_list pp_print_string sep in
  let pp_deps fmt l = match l with
    | [] ->
      ()
    | x :: xs ->
      fprintf fmt "(:pp-file %s)%a" x sep ();
      pp_list pp_print_string sep fmt xs
  in
  fprintf fmt
    "@[(rule@\n @[(targets @[%a@])@\n(deps @[%a@])@\n(action @[%a@])@])@]@\n"
    ppl targets pp_deps deps pp_print_string action

let gen_coqc_targets vo =
  let open Coqdep.Vodep in
  [ vo.target
  ; replace_ext ~file:vo.target ~newext:".glob"
  ; replace_ext ~file:vo.target ~newext:".vos"
  ; "." ^ replace_ext ~file:vo.target ~newext:".aux"]

(* Generate the dune rule: *)
let pp_vo_dep dir fmt vo =
  let open Coqdep.Vodep in
  let depth = List.length dir in
  let sdir = gen_sub depth in
  (* All files except those in Init implicitly depend on the Prelude, we account for it here. *)
  let eflag, edep = if List.tl dir = ["Init"] then "-noinit -R theories Coq", [] else "", [bpath ["theories";"Init";"Prelude.vo"]] in
  (* Coq flags *)
  let cflag = Options.build_coq_flags () in
  (* Correct path from global to local "theories/Init/Decimal.vo" -> "../../theories/Init/Decimal.vo" *)
  let deps = List.map (fun s -> bpath [sdir;s]) (edep @ vo.deps) in
  (* The source file is also corrected as we will call coqtop from the top dir *)
  let source = bpath (dir @ [replace_ext ~file:vo.target ~newext:".v"]) in
  (* We explicitly include the location of coqlib to avoid tricky issues with coqlib location *)
  let libflag = "-coqlib %{project_root}" in
  (* The final build rule *)
  let action = sprintf "(chdir %%{project_root} (run coqc -q %s %s %s %s))" libflag eflag cflag source in
  let all_targets = gen_coqc_targets vo in
  pp_rule fmt all_targets deps action

let _pp_mlg_dep _dir fmt ml =
  fprintf fmt "@[(coq.pp (modules %s))@]@\n" (Filename.remove_extension ml)

let pp_dep dir fmt oo =
  pp_vo_dep dir fmt oo
  (* let open Coqdep in *)
  (* match oo with
   * | VO vo -> pp_vo_dep dir fmt vo
   * | MLG f -> pp_mlg_dep dir fmt f *)

let out_install fmt dir ff =
  (* let open Coqdep in *)
  let itarget = String.concat "/" dir in
  (* let ff = List.concat @@ pmap (function | VO vo -> Some (gen_coqc_targets vo) | _ -> None) ff in *)
  let ff = List.concat @@ List.map gen_coqc_targets ff in
  let pp_ispec fmt tg = fprintf fmt "(%s as coq/%s)" tg (bpath [itarget;tg]) in
  fprintf fmt "(install@\n @[(section lib_root)@\n(package coq)@\n(files @[%a@])@])@\n"
    (pp_list pp_ispec sep) ff

(* For each directory, we must record two things, the build rules and
   the install specification. *)
let record_dune d ff =
  let sd = bpath d in
  if Sys.file_exists sd && Sys.is_directory sd then
    let out = open_out (bpath [sd;"dune"]) in
    let fmt = formatter_of_out_channel out in
    if List.nth d 0 = "plugins" || List.nth d 0 = "user-contrib" then
      fprintf fmt "(include plugin_base.dune)@\n";
    out_install fmt d ff;
    List.iter (pp_dep d fmt) ff;
    fprintf fmt "%!";
    close_out out
  else
    eprintf "error in coq_dune, a directory disappeared: %s@\n%!" sd

(* File Scanning *)
(*
let scan_mlg ~root m d =
  let open Coqdep in
  let dir = [root; d] in
  let m = DirMap.add dir [] m in
  let mlg = Sys.(List.filter (fun f -> Filename.(check_suffix f ".mlg"))
                   Array.(to_list @@ readdir (bpath dir))) in
  List.fold_left (fun m f -> add_map_list [root; d] (MLG f) m) m mlg

let scan_dir ~root m =
  let is_plugin_directory dir = Sys.(is_directory dir && file_exists (bpath [dir;"plugin_base.dune"])) in
  let dirs = Sys.(List.filter (fun f -> is_plugin_directory @@ bpath [root;f]) Array.(to_list @@ readdir root)) in
  List.fold_left (scan_mlg ~root) m dirs

let scan_plugins m = scan_dir ~root:"plugins" m
let scan_usercontrib m = scan_dir ~root:"user-contrib" m
*)

let rec _read_vfiles ic map =
  match
    try Some (Coqdep.parse_coqdep_line (input_line ic))
    with End_of_file -> None
  with
  | None -> map
  | Some rule ->
    (* Add vo_entry to its corresponding map entry *)
    let map = option_cata map (fun (dir, vo) -> add_map_list dir vo map) rule in
    _read_vfiles ic map

let _out_map map =
  DirMap.iter record_dune map

let _exec_ifile f =
  match Array.length Sys.argv with
  | 1 -> f stdin
  | 2 ->
    let in_file = Sys.argv.(1) in
    begin try
      let ic = open_in in_file in
      (try f ic
       with _ -> eprintf "Error: exec_ifile@\n%!"; close_in ic)
      with _ -> eprintf "Error: cannot open input file %s@\n%!" in_file
    end
  | _ -> eprintf "Error: wrong number of arguments@\n%!"; exit 1

(*
let _ =
  exec_ifile (fun ic ->
      let map = scan_plugins DirMap.empty in
      let map = scan_usercontrib map in
      let map = read_vfiles ic map in
      out_map map)
*)

let scan_vfiles dir =
  Sys.readdir dir
  |> Array.to_list
  |> List.filter (fun f -> Filename.check_suffix f ".v")

let in_subdir fmt dir f =
  let vfiles = scan_vfiles dir in
  Format.fprintf fmt "(subdir %s@\n @[" dir;
  (try List.iter (fun vfile -> f ~fmt ~dir ~vfile) vfiles
  with exn -> Format.fprintf fmt "@])@\n"; raise exn);
  Format.fprintf fmt "@])@\n";
  ()

module Dune = struct
  module Rule = struct
    type t =
      { targets : string list
      ; deps : string list
      ; action : string
      ; alias : string option
      }

    let ppl = pp_list pp_print_string sep
    let pp_alias fmt = function
      | None -> ()
      | Some alias -> fprintf fmt "(alias %s)@\n" alias

    let pp fmt { alias; targets; deps; action } =
      fprintf fmt
        "@[(rule@\n @[%a(targets @[%a@])@\n(deps @[%a@])@\n(action @[%a@])@])@]@\n"
        pp_alias alias ppl targets ppl deps pp_print_string action
  end
end

let cctx =
  [| "-I"; "../../install/default/lib"
   ; "-R"; "../theories" ; "Coq"
   ; "-R"; "prerequisite"; "TestSuite"
   ; "-Q"; "../user-contrib/Ltac2"; "Ltac2" |]

(* Soon we will be able to delegate this call to dune itself, using (read) *)
let coqdep_path = "../tools/coqdep/coqdep.exe"

let call_coqdep ~dir file =
  let file = Filename.concat dir file in
  let args = Array.concat [ [|coqdep_path; "-boot"|]; cctx; [|file|]] in
  (* Format.eprintf "call: @[%a@]@\n" (pp_print_list ~pp_sep:pp_print_space pp_print_string) (Array.to_list args); *)
  let in_c = Unix.open_process_args_in coqdep_path args in
  let res = input_line in_c in
  let _ = Unix.close_process_in in_c in
  res

let coqdep_file ~dir ~lvl file =
  let coqdep_line = call_coqdep ~dir file in
  Coqdep.parse_coqdep_line coqdep_line |> Option.get |> fun (target, deps) ->
  (* Split deps and META deps *)
  let  metas, deps = List.partition (fun x -> Str.string_match (Str.regexp ".*/META") x 0) deps.Coqdep.Vodep.deps in
  (* Due to a limitation of coqdep we have relativize the META file(s) *)
  (* We just replace everything before lib/coq-core with ../../install/default/lib/coq-core *)
  let metas = metas |> List.map @@ Str.replace_first (Str.regexp ".*/lib/coq-core") "../../install/default/lib/coq-core" in
  target, List.map (fun f -> lvl ^ f) (List.append deps metas)

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
    (let pargs = Str.matched_group 1 line in
     (* Format.eprintf "pargs: %s@\n%!" pargs; *)
     Some pargs)
  else
    None

let flatten_args args =
  List.map (fun x -> "\"" ^ x ^ "\"") args
  |> String.concat " "

let extra_deps s =
  match s with
  | "\"-compat\" \"8.11\"" -> ["../../theories/Compat/Coq811.vo"]
  | "\"-compat\" \"8.12\"" -> ["../../theories/Compat/Coq812.vo"]
  | "\"-compat\" \"8.13\"" -> ["../../theories/Compat/Coq813.vo"]
  | "\"-compat\" \"8.14\"" -> ["../../theories/Compat/Coq814.vo"]
  | _ -> []

let expect_rule ~fmt ~dir ~lvl ~allow_fail ~cconfig ~vfile ~args ~base_deps =
  let open Dune.Rule in
  let _votarget, vfile_deps = coqdep_file ~dir ~lvl vfile in
  let vfile_deps = [lvl ^ "../theories/Init/Prelude.vo"] @ vfile_deps in
  let extra_args = option_default "" (vfile_header ~dir vfile) ^ " " ^ flatten_args args in
  let extra_deps = extra_deps extra_args @ base_deps in
  (* TODO: Do we want more fine control on exit codes *)
  let exit_codes = if allow_fail then "(or 0 1 129)" else "0" in
  (* sadly we don't capture the log if the call to coqc fails :S ,
     we'll have to use our custom script so the file is still written
  *)
  let action = Format.asprintf
      "(with-outputs-to %%{targets} (with-accepted-exit-codes %s (run coqc %s %s %s)))" exit_codes cconfig extra_args vfile in
  let rule =
    { targets = [vfile ^ ".log"]
    ; deps = extra_deps @ vfile_deps
    ; action
    ; alias = Some "runtest"
    }
  in
  pp fmt rule

let output_rule ~fmt ~dir ~lvl ~allow_fail ~cconfig ~vfile ~args ~base_deps =
  let _votarget, vfile_deps = coqdep_file ~dir ~lvl vfile in
  let vfile_deps = [lvl ^ "../theories/Init/Prelude.vo"] @ vfile_deps in
  (* For output tests we also accept failure :/ *)
  (* Do we? Also we prob want better control for exit codes *)
  let exit_codes = if allow_fail then "(or 0 1 129)" else "0" in
  let extra_args = option_default "" (vfile_header ~dir vfile) ^ " " ^ flatten_args args in
  let extra_deps = extra_deps extra_args @ base_deps in
  (* Output-specific args *)
  let extra_args = "-test-mode -async-proofs-cache force " ^ extra_args in
  let action = Format.asprintf
      "(with-outputs-to %%{targets} (with-accepted-exit-codes %s (run coqc %s %s %s)))" exit_codes cconfig extra_args vfile in
  let open Dune.Rule in
  let rule_log =
    { targets = [vfile ^ ".log.pre"]
    ; deps = vfile_deps
    ; action
    ; alias = None
    }
  in
  pp fmt rule_log;
  (* Rule to amend output test, should drop once makefile goes away *)
  let action = Format.asprintf "(with-outputs-to %%{targets} (run ../tools/amend-output-log.sh %s))" (vfile^".log.pre") in
  let rule_log =
    { targets = [vfile ^ ".log"]
    ; deps = extra_deps @ [vfile ^ ".log.pre"]
    ; action
    ; alias = None
    }
  in
  pp fmt rule_log;
  let action = Format.asprintf "(diff %s %s)" (Filename.remove_extension vfile^".out") (vfile^".log") in
  let rule_diff =
    { targets = []
    ; deps = []
    ; action
    ; alias = Some "runtest"
    } in
  pp fmt rule_diff

(* Fix this cconfig stuff *)
let cconfig = "-coqlib ../.. -R ../prerequisite TestSuite"
let check_dir ?(allow_fail=false) ?(args=[]) ?(base_deps=[]) dir fmt =
  in_subdir fmt dir (expect_rule ~allow_fail ~lvl:"../" ~cconfig ~args ~base_deps)

let check_dir_output ?(allow_fail=false) ?(args=[]) ?(base_deps=[]) dir fmt =
  in_subdir fmt dir (output_rule ~allow_fail ~lvl:"../" ~cconfig ~args ~base_deps)

let output_rules out =
  check_dir "bugs" out;
  (* TODO: complexity *)
  (* TODO: coq-makefile *)
  (* TODO: coqchk *)
  (* TODO: coqdoc *)
  (* TODO: coqwc *)
  check_dir "failure" out;
  (* TODO: ide *)
  (* TODO: interactive *)
  check_dir "ltac2" out;
   (* !! Something is broken here: *)
  check_dir "micromega" ~base_deps:[".csdp.cache"] ~allow_fail:true out;
   (* ?? unused? some of these tests no longer work *)
  (* check_dir "misc" out; *)
   (* ?? unused? *)
  (* check_dir "modules" out; *)
   (* !! Something is broken here: *)
  check_dir_output "output" ~allow_fail:true out;
  (* TODO: output-coqchk *)
  (* TODO: output-coqtop *)
  (* TODO: output-modulo-time *)
  (* TODO: primitive *)
  check_dir "ssr" out;
  check_dir "stm" ~args:["-async-proofs"; "on"] out;
  check_dir "success" out;
  (* TODO: vio *)
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

(* TODO:
  - coqdep 1 call per dir
  - output
  - coqchk [with pattern]
 *)

(* output output-coqtop output-modulo-time $(INTERACTIVE) $(COMPLEXITY)
   stm coqdoc ssr primitive ltac2
   ide vio coqchk output-coqchk coqwc coq-makefile tools $(UNIT_TESTS)
*)
