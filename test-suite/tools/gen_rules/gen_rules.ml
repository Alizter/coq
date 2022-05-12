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

let test_ide ~out ~deps =
  let dir = "ide" in
  let lvl = ".." in
  let args file = [
    "-q" ;
    "-async-proofs" ; "on" ;
    "-async-proofs-tactic-error-resilience" ; "off";
    "-async-proofs-command-error-resilience" ; "off";
    "-boot";
    "-I"; Filename.concat lvl "../../install/default/lib";
    "-R"; Filename.concat lvl "../theories" ; "Coq";
    "-R"; Filename.concat lvl "prerequisite"; "TestSuite";
    "-Q"; Filename.concat lvl "../user-contrib/Ltac2"; "Ltac2";
    ] @ CoqRules.vfile_header ~dir file
    |> String.concat " "
  in
  (* NOTE: it is very important for the arguments to be quoted, so args will have to be flattened *)
  let run = fun file -> ["fake_ide"; "%{bin:coqidetop.opt}"; file; "\"" ^ args file ^ "\""] in
  (* TODO: test output *)
  test_in_subdir dir ~out ~run ~ext:".fake" ~deps

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

let test_tool ?(envs=[]) ?(deps=[]) ~out ?(ignore=[]) dir =
  Dune.Rules.in_subdir out dir ~f:(fun out () ->
    let dirs = Dir.scan_dirs dir ~ignore in
    let per_dir subdir =
      Dune.Rules.in_subdir out subdir ~f:(fun out () ->
        Dune.Rules.run ~run:["./run.sh"] ~out ~log_file:(subdir ^ ".log")
          ~deps:(["run.sh"; "(source_tree .)"] @ deps)
          ~envs
        ())
    in
    List.iter per_dir dirs)

let test_misc ~out ?(ignore=[]) dir =
  in_subdir_foreach_ext ~out ~ext:".sh" ~ignore (fun file ->
    let log_file = file ^ ".log" in
    Dune.Rules.run ~out ~run:["./" ^ file] ~log_file
      ~deps:[
        file;
        (* We need all files in misc as deps *)
        (* These could be finer, but at this point its better to just rereun them all *)
        "(source_tree .)";
        "../../config/coq_config.py";
        "../prerequisite/ssr_mini_mathcomp.vo";
        "(package coq-core)";
        "(source_tree deps)";
        (* This is needed because of universe.v *)
        (* We could probably do a lot better (stdlib tests?) *)
        "(package coq-stdlib)";
        "%{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}";
        (* printers.sh deps *)
        "../../dev/incdir_dune";
        "../../dev/base_include";
        "../../dev/inc_ltac_dune";
        "../../dev/include_printers";
        "../../dev/include";
        "../../dev/top_printers.ml";
        "../../dev/vm_printers.ml";
        (* coqtop_print-mod-uid.sh deps *)
        "../prerequisite/admit.vo";
      ] ();
    ()) dir

  let test_complexity ~out dir =
    (* TODO: Complexity tests *)
    (* 1. Fetch bogomips value *)
    (* 2. parse test file for expected time *)
    (* 3. run test file and record actual time  *)
    (* 4. caclulate time acceptance *)
    ()

(* TODO: check coqc interactive mode - there is a coqc interactive mode which
    runs coqc with different parameters, make sure that those are used in the
    correct tests
*)

let output_rules out =
  let open CoqRules.Compilation.Kind in
  let open CoqRules.Compilation.Output in
  (* Common context - This will be passed to coqdep and coqc *)
  let cctx lvl = [
    "-boot";
    "-I"; Filename.concat lvl "../../install/default/lib";
    "-R"; Filename.concat lvl "../theories" ; "Coq";
    "-R"; Filename.concat lvl "prerequisite"; "TestSuite";
    "-Q"; Filename.concat lvl "../user-contrib/Ltac2"; "Ltac2";
    ] in
  (* Including this argument will allow .csdp.cache to be copied into that test
  directory in a writable state. *)
  let copy_csdp_cache = ".csdp.cache.test-suite" in
  (* Some standard deps to pass to test rules *)
  (* TODO: refine these *)
  let deps = [
    (* "(sandbox always)"; *)
    "(glob_files %{project_root}/test-suite/prerequisite/*.vo)";
    "(file %{project_root}/user-contrib/Ltac2/Ltac2.vo)";
    "(file %{project_root}/theories/Init/Prelude.vo)";
    "(package coq-core)";
    ]
  in
  (* We set COQLIB here *)
  let envs = [
    "COQLIB", "%{project_root}";
    ] in
  (* let base_deps = ["../theories/Init/Prelude.vo"; "(package coq-core)"] in *)

  (* TODO: output-modulo-time *)

  CoqRules.check_dir ~out ~cctx ~deps "bugs" ~copy_csdp_cache
    (* coqchk will fail on bug_12138.v see coq/coq#15930 *)
    (* coqdep cannot parse bug_12138.v *)
    ~ignore:["bug_2923.v"; "bug_12138.v"];
  CoqRules.check_dir ~out ~cctx ~deps ~envs "coqchk" ~copy_csdp_cache;
  CoqRules.check_dir ~out ~cctx ~deps ~envs "failure";
  CoqRules.check_dir ~out ~cctx ~deps ~envs "interactive" ~kind:Coqtop;
  CoqRules.check_dir ~out ~cctx ~deps ~envs "ltac2";
  CoqRules.check_dir ~out ~cctx ~deps ~envs "micromega" ~copy_csdp_cache;
  (* We override cctx here in order to pass these arguments to coqdep uniformly *)
  CoqRules.check_dir ~out ~cctx:(fun lvl -> ["-R"; lvl; "Mods"]) ~envs ~deps "modules";
  (* TODO: Broken *)
  CoqRules.check_dir ~out ~cctx ~envs "output" ~output:MainJob ~copy_csdp_cache
    (* Needed by output/Partac.v, for some reason the env stanza doesn't supply this bin :( *)
    ~deps:("%{bin:coqtacticworker.opt}" :: deps)
    ~args:["-test-mode"; "-async-proofs-cache"; "force"]
    (* Load.v is broken because we call coqdep in one directory and run coqc in another. *)
    (* bug_12138.v cannot be parsed by coqdep *)
    ~ignore:["Load.v"];
  CoqRules.check_dir ~out ~cctx ~deps ~envs "output-coqchk" ~output:CheckJob;
  CoqRules.check_dir ~out ~cctx ~deps ~envs "output-coqtop" ~output:MainJob ~kind:Coqtop;
  CoqRules.check_dir ~out ~cctx ~deps ~envs "output-failure" ~output:MainJob ~args:["-test-mode"; "-async-proofs-cache"; "force"] ~exit_codes:[1];
  CoqRules.check_dir ~out ~cctx ~deps ~envs "primitive/arrays";
  CoqRules.check_dir ~out ~cctx ~deps ~envs "primitive/float";
  CoqRules.check_dir ~out ~cctx ~deps ~envs "primitive/sint63";
  CoqRules.check_dir ~out ~cctx ~deps ~envs "primitive/uint63";
  CoqRules.check_dir ~out ~cctx ~deps ~envs "ssr";
  CoqRules.check_dir ~out ~cctx ~envs "stm" ~args:["-async-proofs"; "on"]
    ~deps:("%{bin:coqproofworker.opt}" :: deps);
  CoqRules.check_dir ~out ~cctx ~envs "success"
    ~deps:("%{bin:coqtacticworker.opt}" :: deps)
    (* Ignore due to coq/coq#16010 *)
    ~ignore:["PartialImport.v"; "ImportCat.v"];
  CoqRules.check_dir ~out ~cctx ~deps ~envs "vio" ~kind:Vio;
  CoqRules.check_dir ~out ~cctx ~deps ~envs "vio" ~kind:Vio2vo;

  (* Other tests *)

  test_complexity ~out "complexity";

  test_in_subdir ~out "coqwc" ~run:(fun file -> ["coqwc"; file]);

  test_ide ~out ~deps:[
    "(source_tree %{project_root}/test-suite/output/load)";
    "%{project_root}/theories/Init/Prelude.vo";
    "%{project_root}/theories/Lists/List.vo";
    "%{project_root}/theories/extraction/Extraction.vo";
    "%{project_root}/user-contrib/Ltac2/Ltac2.vo";
    "(package coq-core)";
    ];

  CoqRules.check_dir ~out ~cctx ~deps ~envs "coqdoc" ~args:["-Q"; "coqdoc"; "Coqdoc"];

  test_coqdoc ~out "coqdoc";

  test_tool ~out "coq-makefile" ~ignore:["template"]
    ~deps:[
      "%{bin:coq_makefile}";
      "%{project_root}/tools/CoqMakefile.in";
      "%{project_root}/theories/Init/Prelude.vo";
      "%{project_root}/theories/Lists/List.vo";
      "%{project_root}/theories/ZArith/ZArith.vo";
      "(source_tree ../template)";
      "(package coq-core)";
      ]
    ~envs:[
      "CoqMakefile_in", "%{project_root}/tools/CoqMakefile.in";
      "TTOOLSDIR", "%{project_root}/tools";
      ];

  test_tool ~out "tools" ~ignore:["gen_rules"]
    ~deps:[
      "(source_tree %{project_root}/theories/Compat)";
      "%{project_root}/test-suite/success/CompatOldOldFlag.v";
      "%{project_root}/sysinit/coqargs.ml";
      "%{project_root}/tools/configure/configure.ml";
      "%{project_root}/dev/tools/update-compat.py";
      "%{project_root}/dev/header.ml";
      "%{project_root}/doc/stdlib/index-list.html.template";
      ];

  test_misc ~out "misc";
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
    Format.eprintf "%s@\n%s@\n%!" exn bt;
    let exception Gen_rules_Anomaly in
    raise Gen_rules_Anomaly
