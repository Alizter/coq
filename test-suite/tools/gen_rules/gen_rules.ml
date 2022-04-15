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
  "-I"; Filename.concat lvl "../../install/default/lib";
  "-R"; Filename.concat lvl "../theories" ; "Coq";
  "-R"; Filename.concat lvl "prerequisite"; "TestSuite";
  "-Q"; Filename.concat lvl "../user-contrib/Ltac2"; "Ltac2" ]

let in_subdir_foreach_ext ?(ext=".v") f dir out =
  Dune.Rules.in_subdir dir out ~f:(fun out () ->
    let files = Dir.scan_files_by_ext ~ext dir in
    List.iter f files)

let test_in_subdir ?ext ?out_file_ext ?(log_file_ext=".log") ?(targets=[]) ?(deps=[]) ~run dir out =
  (* log file extension is appended, out file extension is replaced *)
  in_subdir_foreach_ext ?ext (fun file ->
    let log_file = file ^ log_file_ext in
    Dune.Rules.run ~run:(run file) ~out ~log_file ~targets ~deps:(file :: deps) ();
    match out_file_ext with
    | Some out_file_ext ->
      let out_file = Filename.chop_extension file ^ out_file_ext in
      Dune.Rules.diff ~out out_file log_file
    | None -> ()) dir out

let test_ide out =
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
  in
  let run = fun file -> ["fake_ide"; "%%{bin:coqidetop.opt}"; file] @ args file in
  (* TODO: test output *)
  test_in_subdir dir out ~run ~ext:".fake"

let coqdoc_html_with_diff_rule ~dir ~out file  =
  let filename = Filename.chop_extension file in
  let doc_file = filename ^ ".html" in
  let log_file = filename ^ ".html.log" in
  let out_file = filename ^ ".html.out" in
  let vofile = filename ^ ".vo" in
  let globfile = filename ^ ".glob" in
  let args = [
    "-utf8";
    "-coqlib_url"; "http://coq.inria.fr/stdlib";
    "--html";
    ]
    (* Get extra args under "coqdoc-prog-args" in file *)
    @ CoqRules.vfile_header ~dir ~name:"coqdoc-prog-args" file
  in
  let run = "%%{bin:coqdoc}" :: args @ [file] in
  Dune.Rules.run ~run ~out ~log_file ~targets:[doc_file] ~deps:[file; vofile; globfile] ();
  Dune.Rules.diff ~out out_file doc_file

let coqdoc_latex_with_diff_rule ~dir ~out file  =
  let filename = Filename.chop_extension file in
  let doc_file = filename ^ ".tex" in
  let doc_file_scrub = filename ^ ".tex.scrub" in
  let log_file = filename ^ ".tex.log" in
  let out_file = filename ^ ".tex.out" in
  let vofile = filename ^ ".vo" in
  let globfile = filename ^ ".glob" in
  let args = [
    "-utf8";
    "-coqlib_url"; "http://coq.inria.fr/stdlib";
    "--latex";

    ]
    (* Get extra args under "coqdoc-prog-args" in file *)
    @ CoqRules.vfile_header ~dir ~name:"coqdoc-prog-args" file
  in
  Dune.Rules.run  ~out ~run:("%%{bin:coqdoc}" :: args @ [file])
    ~log_file ~targets:[doc_file] ~deps:[file; vofile; globfile] ();
  (* We need to scrub the .tex file of comments begining %% *)
  Dune.Rules.run ~out ~run:["grep"; "-v"; "\"^%%%%\""; file]
    ~log_file:doc_file_scrub ~deps:[doc_file] ();
  Dune.Rules.diff ~out out_file doc_file_scrub

let test_coqdoc dir out =
  in_subdir_foreach_ext (fun file ->
    coqdoc_html_with_diff_rule ~dir ~out file;
    coqdoc_latex_with_diff_rule ~dir ~out file;
    ()) dir out

let test_tool ?(ignore=[]) dir out =
  let sf = Printf.sprintf in
  Dune.Rules.in_subdir dir out ~f:(fun out () ->
    let dirs = Dir.scan_dirs dir in
    let per_dir subdir =
      (* We ignore the template directory *)
      if List.mem subdir ignore then () else
        Dune.Rules.in_subdir subdir out ~f:(fun out () ->
          Dune.Rules.run ~run:["./run.sh"] ~out ~log_file:(sf "%s.log" subdir)
            ~deps:
              [ "run.sh" ]
          ())
    in
    List.iter per_dir dirs)

let test_misc dir out =
  let deps = ["%{bin:coqdep}"; "%{bin:coqc}"; "%{bin:coqtop.byte}"] in
  in_subdir_foreach_ext ~ext:".sh" (fun file ->
    let log_file = file ^ ".log" in
    Dune.Rules.run ~run:["./" ^ file] ~out ~log_file ~deps:(file :: deps)
      ~envs:
        [ "coqdep", "%{bin:coqdep}"
        ; "coqc", "%{bin:coqc}"
        ; "coqtop", "%{bin:coqtop}"
        ; "coq_makefile", "%{bin:coq_makefile}"
        ; "coqtop_byte", "%{bin:coqtop.byte}"] ();
    ()) dir out

let _debug_rules out =
  (* let open CoqRules.Compilation.Kind in *)
  (* let open CoqRules.Compilation.Output in *)



  (* !! Something is broken here: *)
  (* Load.v *)
  (* CoqRules.check_dir "output" out ~cctx ~output:MainJob ~args:["-test-mode"; "-async-proofs-cache"; "force"]; *)

  (* TODO: fix python stuff here *)
  (* test_tool "coq-makefile" out ~ignore:["template"]; *)

  (* TODO: mostly broken *)
  (* test_misc "misc" out; *)
  ()

let _output_rules out =

  let open CoqRules.Compilation.Kind in
  let open CoqRules.Compilation.Output in
  (* We disable coqchk for bugs due to anomalies present (coqchk was not run for bugs before) *)
  (* TODO: that should be mostly fixed soon *)
  CoqRules.check_dir "bugs" out ~cctx ~coqchk:false;
  CoqRules.check_dir "coqchk" out ~cctx;
  CoqRules.check_dir "failure" out ~cctx;
  CoqRules.check_dir "interactive" out ~cctx ~kind:Coqtop;
  CoqRules.check_dir "ltac2" out ~cctx;
  (* For micromega we implicitly copy a cache, we could copy this in other directories too *)
  (* TODO: make sure cache rule is called before *)
  CoqRules.check_dir "micromega" out ~cctx;
  CoqRules.check_dir "modules" out ~cctx:(fun lvl -> ["-R"; lvl; "Mods"]);
  (* !! Something is broken here: *)
  (* Load.v *)
  CoqRules.check_dir "output" out ~cctx ~output:MainJob ~args:["-test-mode"; "-async-proofs-cache"; "force"];
  CoqRules.check_dir "output-coqchk" out ~cctx ~output:CheckJob;
  CoqRules.check_dir "output-coqtop" out ~cctx ~kind:Coqtop ~output:MainJob;
  CoqRules.check_dir "output-failure" out ~cctx ~output:MainJob ~args:["-test-mode"; "-async-proofs-cache"; "force"] ~exit_codes:[1];
  CoqRules.check_dir "primitive/arrays" out ~cctx;
  CoqRules.check_dir "primitive/float" out ~cctx;
  CoqRules.check_dir "primitive/sint63" out ~cctx;
  CoqRules.check_dir "primitive/uint63" out ~cctx;
  CoqRules.check_dir "ssr" out ~cctx;
  CoqRules.check_dir "stm" out ~cctx ~args:["-async-proofs"; "on"];
  CoqRules.check_dir "success" out ~cctx;
  CoqRules.check_dir "vio" out ~cctx ~kind:Vio;
  CoqRules.check_dir "vio" out ~cctx ~kind:Vio2vo;
  (* Other tests *)
  test_in_subdir "coqwc" out ~run:(fun file -> ["coqwc"; file]);
  test_ide out;
  CoqRules.check_dir "coqdoc" out ~cctx ~args:["-Q"; "coqdoc"; "Coqdoc"];
  test_coqdoc "coqdoc" out;
  (* TODO: We need directory independent dependencies for the python deps *)
  test_tool "coq-makefile" out ~ignore:["template"];
  test_tool "tools" out ~ignore:["gen_rules"];
  (* TODO: mostly broken *)
  test_misc "misc" out;
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
    Format.eprintf "%s@\n%s@\n%!" exn bt;
    let exception Gen_rules_Anomaly in
    raise Gen_rules_Anomaly

(* TODOS:
(* ADD: linter - check theere is a rule for every test *)
(* ADD: Rule to update output tests (prob a promote rule) *)
(* FIX: Cannot run test-suite directly from clean build *)
(* TODO: complexity *)
(* TODO: output-modulo-time *)
*)
