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

(* Common context - This will be passed to coqdep and coqc *)
let cctx lvl = [
  "-boot";
  "-I"; lvl ^ "/../../install/default/lib";
  "-R"; lvl ^ "/../theories" ; "Coq";
  "-R"; lvl ^ "/prerequisite"; "TestSuite";
  "-Q"; lvl ^ "/../user-contrib/Ltac2"; "Ltac2" ]

let test bin dir out =
  (* TODO: generalize past .v case *)
  let vfiles = Dir.scan_files_by_ext ".v" dir in
  let generate_rule vfile =
    let out_file = Filename.chop_extension vfile ^ ".out" in
    let log_file = vfile ^ ".log" in
    let coqwc_rule = Dune.Rule.{
      targets = [log_file]
      ; deps = [vfile]
      ; action = Format.asprintf "(with-outputs-to %s (run %s %s))" log_file bin vfile
      ; alias = Some "runtest"
      } in
    Dune.Rule.pp out coqwc_rule;
    Dune.Rules.diff out out_file log_file
  in
  Format.fprintf out "(subdir %s@\n @[" dir;
  let () =
    try
      (* Generate rule for each set of dependencies  *)
      List.iter generate_rule vfiles
    (* Make sure we gracefully balance the file before throwing an excpetion *)
    with exn -> Format.fprintf out "@])@\n"; raise exn
  in
  Format.fprintf out "@])@\n";
  ()

let _debug_rules out =
  (* let open CoqRules.Compilation.Output in *)
  (* TODO: these are still borken *)
  (* test "coqwc" "coqwc" out; *)

  (* CoqRules.check_dir "micromega" out ~base_deps:[".csdp.cache"] ~cctx; *)
  (* CoqRules.check_dir "output" out ~cctx ~output:Coqc ~args:["-test-mode"; "-async-proofs-cache"; "force"]; *)
  (* CoqRules.check_dir "success" out ~cctx; *)
  ()

let _output_rules out =
  let open CoqRules.Compilation.Output in
  (* We disable coqchk for bugs due to anomalies present (coqchk was not run for bugs before) *)
  (* TODO: that should be mostly fixed soon *)
  CoqRules.check_dir "bugs" out ~cctx ~coqchk:false;
  CoqRules.check_dir "coqchk" out ~cctx;
  CoqRules.check_dir "failure" out ~cctx;
  CoqRules.check_dir "ltac2" out ~cctx;
  (* !! Something is broken here: *)
  (* qexample.v *)
  (* example.v *)
  (* bertot.v *)
  (* rexample.v *)
  CoqRules.check_dir "micromega" out ~base_deps:[".csdp.cache"] ~cctx;
  CoqRules.check_dir "modules" out ~cctx:(fun lvl -> ["-R"; lvl; "Mods"]);
  (* !! Something is broken here: *)
  (* Load.v *)
  CoqRules.check_dir "output" out ~cctx ~output:Coqc ~args:["-test-mode"; "-async-proofs-cache"; "force"];
  CoqRules.check_dir "output-coqchk" out ~cctx ~output:Check;
  CoqRules.check_dir "output-failure" out ~cctx ~output:Coqc ~args:["-test-mode"; "-async-proofs-cache"; "force"] ~exit_codes:[1];
  CoqRules.check_dir "primitive/arrays" out ~cctx;
  CoqRules.check_dir "primitive/float" out ~cctx;
  CoqRules.check_dir "primitive/sint63" out ~cctx;
  CoqRules.check_dir "primitive/uint63" out ~cctx;
  CoqRules.check_dir "ssr" out ~cctx;
  CoqRules.check_dir "stm" out ~cctx ~args:["-async-proofs"; "on"];
  (* !! Something is broken here: *)
  (* extra_dep.v *)
  CoqRules.check_dir "success" out ~cctx;
  CoqRules.check_dir "vio" out ~cctx ~args:["-vio"];
  CoqRules.check_dir "vio" out ~cctx ~vio2vo:true;

  (* Other tests *)
  test "coqwc" "coqwc" out;

  ()

let main () =
  let out = open_out "test_suite_rules.sexp" in
  let fmt = Format.formatter_of_out_channel out in
  _output_rules fmt;
  (* _debug_rules fmt; *)
  Format.pp_print_flush fmt ();
  close_out out

let () =
  Printexc.record_backtrace true;
  try main ()
  with exn ->
    let bt = Printexc.get_backtrace () in
    let exn = Printexc.to_string exn in
    Format.eprintf "%s@\n%s@\n%!" exn bt

(* TODOS:
(* ADD: linter - check theere is a rule for every test *)
(* ADD: Rule to update output tests (prob a promote rule) *)
(* FIX: Cannot run test-suite directly from clean build *)
(* TODO: complexity *)
(* TODO: coq-makefile *)
(* TODO: coqdoc *)
(* TODO: coqwc *)
(* TODO: ide *)
(* TODO: interactive *)
(* TODO: misc, make cram *)
(* TODO: output-coqtop *)
(* TODO: output-modulo-time *)
*)
