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

let _debug_rules out =
  let cctx lvl = [
    "-boot";
    "-I"; lvl ^ "/../../install/default/lib";
    "-R"; lvl ^ "/../theories" ; "Coq";
    "-R"; lvl ^ "/prerequisite"; "TestSuite";
    "-Q"; lvl ^ "/../user-contrib/Ltac2"; "Ltac2" ]
  in
  (* TODO: these are still borken *)
  CoqRules.check_dir "micromega" out ~base_deps:[".csdp.cache"] ~cctx;
  CoqRules.check_dir "output" out ~cctx ~output:CoqRules.Output.Coqc ~args:["-test-mode"; "-async-proofs-cache"; "force"];
  CoqRules.check_dir "success" out ~cctx;
  ()

let _output_rules out =
  (* Common context - This will be passed to coqdep and coqc *)
  let cctx lvl = [
    "-boot";
    "-I"; lvl ^ "/../../install/default/lib";
    "-R"; lvl ^ "/../theories" ; "Coq";
    "-R"; lvl ^ "/prerequisite"; "TestSuite";
    "-Q"; lvl ^ "/../user-contrib/Ltac2"; "Ltac2" ]
  in
  (* We disable coqchk for bugs due to anomalies present (coqchk was not run for bugs before) *)
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
  CoqRules.check_dir "output" out ~cctx ~output:CoqRules.Output.Coqc ~args:["-test-mode"; "-async-proofs-cache"; "force"];
  CoqRules.check_dir "output-coqchk" out ~cctx ~output:CoqRules.Output.Check;
  CoqRules.check_dir "output-failure" out ~cctx ~output:CoqRules.Output.Coqc ~args:["-test-mode"; "-async-proofs-cache"; "force"] ~exit_codes:[1];
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
