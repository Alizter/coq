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

let test ~run ~out ~log_file file=
  (* TODO: move to dune module *)
  (* TODO: generalize past .out *)
  let rule = Dune.Rule.{
    targets = [log_file]
    ; deps = [file]
    ; action = Format.asprintf "(with-outputs-to %s (run %s))" log_file (run file)
    ; alias = Some "runtest"
    } in
  Dune.Rule.pp out rule

let in_subdir ?(ext=".v") f dir out =
  (* TODO: generalize past .v case *)
  let vfiles = Dir.scan_files_by_ext ext dir in
  Format.fprintf out "(subdir %s@\n @[" dir;
  let () =
    try
      (* Generate rule for each set of dependencies  *)
      List.iter f vfiles
    (* Make sure we gracefully balance the file before throwing an excpetion *)
    with exn -> Format.fprintf out "@])@\n"; raise exn
  in
  Format.fprintf out "@])@\n";
  ()

let test_in_subdir ?ext ?out_file_ext ~run dir out =
  in_subdir ?ext (fun file ->
    let log_file = file ^ ".log" in
    match out_file_ext with
    | Some out_file_ext ->
      let out_file = Filename.chop_extension file ^ out_file_ext in
      test ~run ~out ~log_file file;
      Dune.Rules.diff out out_file log_file
    | None -> test ~run ~out ~log_file file
  ) dir out

let test_ide out =
  let sf = Printf.sprintf in
  let dir = "ide" in
  let lvl = ".." in
  let args file = [
    "-q" ;
    "-async-proofs" ; "on" ;
    "-async-proofs-tactic-error-resilience" ; "off";
    "-async-proofs-command-error-resilience" ; "off"
      ]
    @ CoqRules.vfile_header ~dir file
    @ cctx lvl
    |> String.concat " "
  in
  let run = fun file -> sf "fake_ide %%{bin:coqidetop.opt} %s \"%s\"" file (args file) in
  (* TODO: test output *)
  test_in_subdir dir out ~run ~ext:".fake"

let _debug_rules out =
  (* let open CoqRules.Compilation.Output in *)
  (* TODO: these are still borken *)
  (* test "coqwc" "coqwc" out; *)

  test_ide out;
  (* CoqRules.check_dir "micromega" out ~base_deps:[".csdp.cache"] ~cctx; *)
  (* CoqRules.check_dir "output" out ~cctx ~output:Coqc ~args:["-test-mode"; "-async-proofs-cache"; "force"]; *)
  (* CoqRules.check_dir "success" out ~cctx; *)
  ()

let _output_rules out =
  let sf = Printf.sprintf in

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
  test_in_subdir "coqwc" out ~run:(sf "coqwc %s");
  (* test_in_subdir "ide" out ~run:(sf "fake_ide coqidetop.byte %s") ~ext:".fake" ~read_args:true; *)
  test_ide out;

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
(* TODO: ide *)
(* TODO: interactive *)
(* TODO: misc, make cram *)
(* TODO: output-coqtop *)
(* TODO: output-modulo-time *)
*)
