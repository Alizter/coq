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

let in_subdir_foreach_ext ~out ?(ext=".v") ?(ignore=[]) f dir =
  Dune.Rules.in_subdir out dir ~f:(fun _ () ->
    let files = Dir.scan_files_by_ext ~ext ~ignore dir in
    List.iter f files)

let test_in_subdir ~out ?ext ?out_file_ext ?(log_file_ext=".log") ?(targets=[]) ?(deps=[]) ~run dir =
  (* log file extension is appended, out file extension is replaced *)
  in_subdir_foreach_ext ~out ?ext (fun file ->
    let log_file = file ^ log_file_ext in
    Dune.Rules.run ~run:(run file) ~out ~log_file ~targets ~deps:(file :: deps) ();
    match out_file_ext with
    | Some out_file_ext ->
      let out_file = Filename.chop_extension file ^ out_file_ext in
      Dune.Rules.diff ~out out_file log_file
    | None -> ()) dir

let test_ide ~out =
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
  (* NOTE: it is very important for the arguments to be quoted, so args will have to be flattened *)
  let run = fun file -> ["fake_ide"; "%{bin:coqidetop.opt}"; file; "\"" ^ args file ^ "\""] in
  (* TODO: test output *)
  test_in_subdir dir ~out ~run ~ext:".fake"

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
  let run = "%{bin:coqdoc}" :: args @ [file] in
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
  Dune.Rules.run ~out ~run:("%{bin:coqdoc}" :: args @ [file])
    ~log_file ~targets:[doc_file] ~deps:[file; vofile; globfile] ();
  (* We need to scrub the .tex file of comments begining %% *)
  Dune.Rules.run ~out ~run:["grep"; "-v"; "\"^%%\""; doc_file]
    ~log_file:doc_file_scrub ~deps:[doc_file] ();
  Dune.Rules.diff ~out out_file doc_file_scrub

let test_coqdoc ~out dir =
  in_subdir_foreach_ext ~out (fun file ->
    coqdoc_html_with_diff_rule ~dir ~out file;
    coqdoc_latex_with_diff_rule ~dir ~out file;
    ()) dir

let test_tool ~out ?(ignore=[]) dir =
  Dune.Rules.in_subdir out dir ~f:(fun out () ->
    let dirs = Dir.scan_dirs dir ~ignore in
    let per_dir subdir =
      Dune.Rules.in_subdir out subdir ~f:(fun out () ->
        Dune.Rules.run ~run:["./run.sh"] ~out ~log_file:(subdir ^ ".log")
          ~deps:
            [ "run.sh" ]
        ())
    in
    List.iter per_dir dirs)

let test_misc ~out ~deps ?(ignore=[]) dir =
  in_subdir_foreach_ext ~out ~ext:".sh" ~ignore (fun file ->
    let log_file = file ^ ".log" in
    Dune.Rules.run ~out ~run:["./" ^ file] ~log_file ~deps:(file :: deps)
      ~envs:[
        "coqdep", "%{bin:coqdep}";
        "coqc", "%{bin:coqc}";
        "coqtop", "%{bin:coqtop}";
        "coq_makefile", "%{bin:coq_makefile}";
        "coqtop_byte", "%{bin:coqtop.byte}";
        "votour", "%{bin:votour}";
        "coqchk", "%{bin:coqchk}";
        ] ();
    ()) dir

let _debug_rules out =
  ()

let _output_rules out =

  let open CoqRules.Compilation.Kind in
  let open CoqRules.Compilation.Output in
  (* We disable coqchk for bugs due to anomalies present (coqchk was not run for bugs before) *)
  (* TODO: that should be mostly fixed soon *)
  CoqRules.check_dir ~out ~cctx "bugs" ~coqchk:false;
  CoqRules.check_dir ~out ~cctx "coqchk";
  CoqRules.check_dir ~out ~cctx "failure";
  CoqRules.check_dir ~out ~cctx "interactive" ~kind:Coqtop;
  CoqRules.check_dir ~out ~cctx "ltac2";
  (* For micromega we implicitly copy a cache, we could copy this in other directories too *)
  CoqRules.check_dir ~out ~cctx "micromega" ~deps:["(alias csdp-cache)"];
  (* We override cctx here in order to pass these arguments to coqdep uniformly *)
  CoqRules.check_dir ~out ~cctx:(fun lvl -> ["-R"; lvl; "Mods"]) "modules";
  (* TODO: Broken *)
  CoqRules.check_dir ~out ~cctx "output" ~output:MainJob ~args:["-test-mode"; "-async-proofs-cache"; "force"]
    (* Load.v is broken because we call coqdep in one directory and run coqc in another. *)
    ~ignore:["Load.v"];
  CoqRules.check_dir ~out ~cctx "output-coqchk" ~output:CheckJob;
  CoqRules.check_dir ~out ~cctx "output-coqtop" ~kind:Coqtop ~output:MainJob;
  CoqRules.check_dir ~out ~cctx "output-failure" ~output:MainJob ~args:["-test-mode"; "-async-proofs-cache"; "force"] ~exit_codes:[1];
  CoqRules.check_dir ~out ~cctx "primitive/arrays";
  CoqRules.check_dir ~out ~cctx "primitive/float";
  CoqRules.check_dir ~out ~cctx "primitive/sint63";
  CoqRules.check_dir ~out ~cctx "primitive/uint63";
  CoqRules.check_dir ~out ~cctx "ssr";
  CoqRules.check_dir ~out ~cctx "stm" ~args:["-async-proofs"; "on"];
  CoqRules.check_dir ~out ~cctx "success";
  CoqRules.check_dir ~out ~cctx "vio" ~kind:Vio;
  CoqRules.check_dir ~out ~cctx "vio" ~kind:Vio2vo;
  (* Other tests *)
  test_in_subdir ~out "coqwc" ~run:(fun file -> ["coqwc"; file]);
  test_ide ~out;
  CoqRules.check_dir ~out ~cctx "coqdoc" ~args:["-Q"; "coqdoc"; "Coqdoc"];
  test_coqdoc ~out "coqdoc";
  (* TODO: Broken *)
  test_tool ~out "coq-makefile"
    ~ignore:[
      "template";
      (* We need directory independent dependencies for the python deps but for
      now we ignore the timing folder *)
      "timing";
      ];
  test_tool ~out "tools" ~ignore:["gen_rules"];
  (* TODO: mostly broken *)
  test_misc ~out "misc"
    ~deps:[
      "../../config/coq_config.py";
      "../prerequisite/ssr_mini_mathcomp.vo";
      "(package coq-stdlib)";
    ]
    (* The following tests don't work and need to be fixed *)
    ~ignore:[
      "coq_environment.sh";
      "coqtop_print-mod-uid.sh";
      "printers.sh";
    ];
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
