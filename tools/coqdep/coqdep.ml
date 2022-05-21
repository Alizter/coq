(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

(** The basic parts of coqdep are in [Common]. *)
open Coqdeplib

let coqdep args =
  (* let args = Args.make () in *)
  let open Common in
  (* Initialize coqdep, add files to dependency computation *)
  let v_files = args.Args.files in
  let st = init args in
  let lst = Common.State.loadpath st in
  List.iter treat_file_command_line v_files;
  (* XXX: All the code below is just setting loadpaths, refactor to
     Common coq.boot library *)
  (* Add current dir with empty logical path if not set by options above. *)
  (try ignore (Loadpath.find_dir_logpath (Sys.getcwd()))
   with Not_found -> Loadpath.add_norec_dir_import (Loadpath.add_known lst) "." []);
  (* We don't setup any loadpath if the -boot is passed *)
  if not !Options.boot then begin
    let env = Boot.Env.init () in
    let stdlib = Boot.Env.(stdlib env |> Path.to_string) in
    let plugins = Boot.Env.(plugins env |> Path.to_string) in
    let user_contrib = Boot.Env.(user_contrib env |> Path.to_string) in
    Loadpath.add_rec_dir_import (Loadpath.add_coqlib_known lst) stdlib ["Coq"];
    Loadpath.add_rec_dir_import (Loadpath.add_coqlib_known lst) plugins ["Coq"];
    if Sys.file_exists user_contrib
    then Loadpath.add_rec_dir_no_import (Loadpath.add_coqlib_known lst) user_contrib [];
    List.iter (fun s -> Loadpath.add_rec_dir_no_import (Loadpath.add_coqlib_known lst) s [])
      (Envars.xdg_dirs ~warn:(fun x -> Warning.give "%s" x));
    List.iter (fun s -> Loadpath.add_rec_dir_no_import (Loadpath.add_coqlib_known lst) s []) Envars.coqpath;
  end;
  if !Options.sort then
    sort st
  else
    compute_deps st |> List.iter (Dep_info.print Format.std_formatter)

open Cmdliner

let make' boot sort vos noglob noinit coqproject ml_path =
  let open Args in {
    (init ()) with
      boot
    ; sort
    ; vos
    ; noglob
    ; noinit
    ; coqproject
    ; ml_path
  }

let boot =
  let doc = "For Coq developers, prints dependencies over Coq library files (omitted by default)." in
  Arg.(value & flag & info ["boot"] ~doc)

let sort =
  let doc = "Output the given file name ordered by dependencies." in
  Arg.(value & flag & info ["sort"] ~doc)

let vos =
  let doc = "Also output dependencies about .vos files." in
  Arg.(value & flag & info ["vos"] ~doc)

let noglob =
  let doc = "TODO" in
  Arg.(value & flag & info ["noglob"; "no-glob"] ~doc)

let noinit =
  let doc = "Currently no effect." in
  Arg.(value & flag & info ["noinit"] ~doc)

let coqproject =
  (* TODO: instead of [Arg.string] use [Arg.file] *)
  let doc = "Read command line arguments -I, -Q, -R and \
             filenames from a _CoqProject file." in
  let docv = "_CoqProject" in
  Arg.(value & opt (some string) None & info ["f"] ~doc ~docv)

let ml_path =
  let doc = "Add (non-recursively) dir to OCaml path." in
  let docv = "dir" in
  Arg.(value & opt_all string [] & info ["I"] ~doc ~docv)

let cmd =
  let doc = "compute inter-module dependencies for Coq programs" in
  let man_xrefs =
    (* TODO *)
    [ `Tool "mv"; `Tool "scp"; `Page ("umask", 2); `Page ("symlink", 7) ]
  in
  (* TODO: exit codes are wrong 127 not 125 is unexpected internal error*)
  let man =
    [ `S Manpage.s_bugs;
      `P "Please report any bugs to:";
      `P "https://github.com/coq/coq/issues"; ]
  in
  let version = Printf.sprintf "%s %s" Coq_config.version Coq_config.caml_version in
  let info = Cmd.info "coqdep" ~version ~doc ~man ~man_xrefs in
  Cmd.v info Term.(
    const coqdep
    $ (const make'
      $ boot
      $ sort
      $ vos
      $ noglob
      $ noinit
      $ coqproject
      $ ml_path))

let () =
  (* Preprocess args to allow for "-arg" *)
  let argv = Cmdliner_compat.process_args () in
  Cmd.(exit @@ eval ~argv cmd)
