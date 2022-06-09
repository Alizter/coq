(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

let rec read_buffer buf acc =
  match Lexer.parse_coq buf with
  | line -> read_buffer buf (line :: acc)
  | exception Lexer.End_of_file -> Token.Document (List.rev acc)

let find_dependencies ~format f =
  let chan = try open_in f with Sys_error msg -> Error.cannot_open f msg in
  let zero_pos =
    Lexing.{pos_fname = f; pos_lnum = 1; pos_bol = 0; pos_cnum = 0}
  in
  let buf = Lexing.from_channel ~with_positions:true chan in
  let () = Lexing.(buf.lex_curr_p <- zero_pos) in
  let print tok =
    match !format with
    | "csexp" -> Printf.printf "%s" (Token.to_sexp tok |> Csexp.to_string)
    | "read" -> Printf.printf "%s\n" (Token.to_string tok)
    | "sexp" -> Token.to_sexp tok |> Token.Sexp.pp Format.std_formatter
    | f -> Error.unknwon_output_format f
  in
  let toks = read_buffer buf [] in
  close_in chan; print toks

let main () =
  let usage_msg = "coqmod - A simple module lexer for Coq" in
  let format = ref "csexp" in
  let files = ref [] in
  let anon_fun f = files := f :: !files in
  let speclist =
    [
      ("--format", Arg.Set_string format, "Set output format [csexp|sexp|read]");
      ("--debug", Arg.Set Error.debug_mode, "Output debugging information");
    ]
  in
  let () = Arg.parse speclist anon_fun usage_msg in
  match !files with
  | [] -> Error.no_file_provided ()
  | [file] -> find_dependencies ~format file
  | files -> Error.too_many_files_provided ()

let () =
  try main ()
  with exn ->
    Format.eprintf "@[%a@]@\n%!" Pp.pp_with (CErrors.print exn);
    exit 1
