(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

{

  open Token

  module Metadata = struct
    type t = {
      hint : string option;
      who : string;
      desc : string option;
      loc : Token.Loc.t;
      file : string
    }
  end

  exception End_of_file
  exception Syntax_error of Metadata.t

  let unquote_string s =
    String.sub s 1 (String.length s - 2)

  let unquote_vfile_string s =
    let f = unquote_string s in
    if Filename.check_suffix f ".v" then Filename.chop_suffix f ".v" else f

  let backtrack lexbuf =
    let open Lexing in
    lexbuf.lex_curr_pos <- lexbuf.lex_start_pos;
    lexbuf.lex_curr_p <- lexbuf.lex_start_p

  let syntax_error ~who ?desc ?hint lexbuf =
    let loc = Loc.of_lexbuf lexbuf in
    let file = loc.Loc.start.Lexing.pos_fname in
    raise (Syntax_error Metadata.{hint; who; desc; loc; file})

  let get_module lexbuf =
    Module.{loc = Loc.of_lexbuf lexbuf; logical_name = Lexing.lexeme lexbuf}

  (* Some standard error descriptions *)
  let msg_eof = "File ended unexpectedly."
  let msg_unable lexbuf =
    Printf.sprintf "Unable to parse: \"%s\"." (Lexing.lexeme lexbuf)

  let hint_eof_term = "Did you forget a \".\"?"

}

let whitespace = [' ' '\t' '\r']
let newline = '\n'
let quoted = '"' [^ '"']* '"'

let coq_ident_start_char = ['A'-'Z' 'a'-'z' '_' '\128'-'\255']
let coq_ident_char = ['A'-'Z' 'a'-'z' '_' '\'' '0'-'9' '\128'-'\255']
let coq_ident = coq_ident_start_char coq_ident_char*
let coq_field = '.' coq_ident
let coq_qualid = coq_ident coq_field*

let locality = "Local" | "Global" | "#[local]" | "#[global]"

let comment_begin = "(*"
let comment_end = "*)"

rule parse_coq = parse
  (* All newlines must be manually processed in order to have good locations *)
  | newline       { Lexing.new_line lexbuf; parse_coq lexbuf }
  | whitespace+   { parse_coq lexbuf }
  | comment_begin { parse_comment lexbuf; parse_coq lexbuf }
  | eof           { raise End_of_file }
  (* Noops - These are ignored on purpose *)
  | locality      { parse_coq lexbuf }
  | "Time"        { parse_coq lexbuf }
  | "Timeout"     { parse_timeout lexbuf }
  | "Comments"    { parse_vernac_comments lexbuf }
  (* Entry points to more sophisticated parsing *)
  | "Declare"     { parse_declare (Lexing.lexeme_start_p lexbuf) lexbuf }
  | "Load"        { parse_load lexbuf }
  | "Require"     { parse_require_modifiers (Lexing.lexeme_start_p lexbuf) None lexbuf }
  | "From"        { parse_from (Lexing.lexeme_start_p lexbuf) lexbuf }
  (* Everything else *)
  | _             { skip_to_dot lexbuf; parse_coq lexbuf }

(* Parsing comments *)
and parse_comment = parse
  | '\n'          { Lexing.new_line lexbuf; parse_comment lexbuf }
  | comment_begin { parse_comment lexbuf; parse_comment lexbuf }
  | comment_end   { () }
  | eof           { raise End_of_file }
  | _             { parse_comment lexbuf }

(* Rule for fast forwarding to a dot, skipping most things. *)
and skip_to_dot = parse
  | newline                   { Lexing.new_line lexbuf; skip_to_dot lexbuf }
  | comment_begin             { parse_comment lexbuf; skip_to_dot lexbuf }
  | "." ( newline )           { Lexing.new_line lexbuf }
  | '.' ( whitespace+ | eof)  { () }
  | eof                       { syntax_error lexbuf ~who:"skip_to_dot" ~desc:msg_eof ~hint:hint_eof_term }
  | _                         { skip_to_dot lexbuf }

(* Parser for [Declare ML Module "mod.ule1" "mod.ule2"] *)
and parse_declare start = parse
  | newline       { Lexing.new_line lexbuf; parse_declare start lexbuf }
  | whitespace+   { parse_declare start lexbuf }
  | comment_begin { parse_comment lexbuf; parse_declare start lexbuf }
  | "ML"          { parse_declare_ml start lexbuf }
  | _             { syntax_error lexbuf ~who:"parse_declare" ~desc:(msg_unable lexbuf) }
and parse_declare_ml start = parse
  | newline       { Lexing.new_line lexbuf; parse_declare_ml start lexbuf }
  | whitespace+   { parse_declare_ml start lexbuf }
  | comment_begin { parse_comment lexbuf; parse_declare_ml start lexbuf }
  | "Module"      { parse_ml_modules start [] lexbuf }
  | _             { syntax_error lexbuf ~who:"parse_declare_ml" ~desc:(msg_unable lexbuf) }
and parse_ml_modules start modules = parse
  | newline       { Lexing.new_line lexbuf; parse_ml_modules start modules lexbuf }
  | whitespace+   { parse_ml_modules start modules lexbuf }
  | comment_begin { parse_comment lexbuf; parse_ml_modules start modules lexbuf }
  | '"'           { let modules =
                      let start = Lexing.lexeme_end_p lexbuf in
                      parse_quoted_ml_module start lexbuf :: modules
                    in
                    parse_ml_modules start modules lexbuf }
  | '.'           { let loc = Loc.{start; finish = Lexing.lexeme_start_p lexbuf} in
                    if List.length modules = 0 then syntax_error lexbuf ~who:"parse_ml_modules";
                    Declare Declare.{loc; ml_modules = List.rev modules } }
  | eof           { syntax_error lexbuf ~who:"parse_ml_modules" ~desc:msg_eof ~hint:hint_eof_term }
  | _             { syntax_error lexbuf ~who:"parse_ml_modules" ~desc:(msg_unable lexbuf) }
and parse_quoted_ml_module start = parse
  (* We reuse the Coq module name regex even though this is an OCaml name *)
  | coq_qualid    { let loc = Loc.{start; finish = Lexing.lexeme_end_p lexbuf} in
                    let logical_name = Lexing.lexeme lexbuf in
                    parse_quote lexbuf;
                    Module.{loc; logical_name} }
  | _             { syntax_error lexbuf ~who:"parse_quoted_ml_module" ~desc:(msg_unable lexbuf) }
and parse_quote = parse
  | '"'           { () }
  | _             { syntax_error lexbuf ~who:"parse_quote" ~desc:"Expected a '\"'." }

(* The Timeout 1234 command is a no op for us, but requires parsing an extra token *)
and parse_timeout = parse
  | newline       { Lexing.new_line lexbuf; parse_timeout lexbuf }
  | whitespace+   { parse_timeout lexbuf }
  | comment_begin { parse_comment lexbuf; parse_timeout lexbuf }
  | ['0'-'9']+    { parse_coq lexbuf }
  | eof           { syntax_error lexbuf ~who:"parse_timeout" ~desc:msg_eof }
  | _             { syntax_error lexbuf ~who:"parse_timeout" ~desc:(msg_unable lexbuf) }

(** Parser for Require with modifiers *)
and parse_require_modifiers start from = parse
  | newline       { Lexing.new_line lexbuf; parse_require_modifiers start from lexbuf }
  | whitespace    { parse_require_modifiers start from lexbuf }
  | comment_begin { parse_comment lexbuf; parse_require_modifiers start from lexbuf }
  | "Import"      { parse_require_modifiers start from lexbuf }
  | "Export"      { parse_require_modifiers start from lexbuf }
  | "-"           { parse_require_modifiers start from lexbuf }
  | "("           { skip_parenthesized lexbuf; parse_require_modifiers start from lexbuf }
  | eof           { syntax_error lexbuf ~who:"parse_require_modifers" ~desc:msg_eof }
  | _             { backtrack lexbuf; parse_require start from [] lexbuf }
(** Utility for skipping parenthesized items (used for import categories) *)
and skip_parenthesized = parse
  | newline       { Lexing.new_line lexbuf; skip_parenthesized lexbuf }
  | whitespace    { skip_parenthesized lexbuf }
  | comment_begin { parse_comment lexbuf; skip_parenthesized lexbuf }
  | "("           { skip_parenthesized lexbuf; skip_parenthesized lexbuf }
  | ")"           { () }
  | eof           { raise End_of_file }
  | _             { skip_parenthesized lexbuf }
(* Parser for Require + modules *)
and parse_require start from modules = parse
  | newline       { Lexing.new_line lexbuf; parse_require start from modules lexbuf }
  | whitespace    { parse_require start from modules lexbuf }
  | comment_begin { parse_comment lexbuf; parse_require start from modules lexbuf }
  | "("           { skip_parenthesized lexbuf; parse_require start from modules lexbuf }
  | coq_qualid    { let loc = Loc.of_lexbuf lexbuf in
                    let logical_name = Lexing.lexeme lexbuf in
                    let modules = Module.{loc; logical_name} :: modules in
                    parse_require start from modules lexbuf }
  | '.'           { let loc = Loc.{start; finish = Lexing.lexeme_start_p lexbuf} in
                    Require Require.{loc; from; modules = List.rev modules } }
  | eof           { syntax_error lexbuf ~who:"parse_require" ~desc:msg_eof ~hint:hint_eof_term }
  | _             { syntax_error lexbuf ~who:"parse_require" ~desc:(msg_unable lexbuf) }

(* From ... Require Import parsing rules *)
and parse_from start = parse
  | newline       { Lexing.new_line lexbuf; parse_from start lexbuf }
  | comment_begin { parse_comment lexbuf; parse_from start lexbuf }
  | whitespace    { parse_from start lexbuf }
  | coq_qualid    { let from = get_module lexbuf in
                    parse_from_require_or_extradep start from lexbuf }
  | eof           { syntax_error lexbuf ~who:"parse_from" ~desc:msg_eof }
  | _             { syntax_error lexbuf ~who:"parse_from" ~desc:(msg_unable lexbuf) }
and parse_from_require_or_extradep start from = parse
  | newline       { Lexing.new_line lexbuf; parse_from_require_or_extradep start from lexbuf }
  | comment_begin { parse_comment lexbuf; parse_from_require_or_extradep start from lexbuf }
  | whitespace    { parse_from_require_or_extradep start from lexbuf }
  | "Require"     { parse_require_modifiers start (Some from) lexbuf }
  | "Extra"       { parse_dependency start from lexbuf }
  | eof           { syntax_error lexbuf ~who:"parse_from_require_or_extradep" ~desc:msg_eof }
  | _             { syntax_error lexbuf ~who:"parse_from_require_or_extradep" ~desc:(msg_unable lexbuf) }

(* From ... Extra Dependency ... as ... parsing rules *)
and parse_dependency start from = parse
  | newline       { Lexing.new_line lexbuf; parse_dependency start from lexbuf }
  | comment_begin { parse_comment lexbuf; parse_dependency start from lexbuf }
  | whitespace    { parse_dependency start from lexbuf }
  | "Dependency"  { parse_dependency_file start from lexbuf }
  | eof           { syntax_error lexbuf ~who:"parse_dependency" ~desc:msg_eof }
  | _             { syntax_error lexbuf ~who:"parse_dependency" ~desc:(msg_unable lexbuf) }
and parse_dependency_file start from = parse
  | newline       { Lexing.new_line lexbuf; parse_dependency_file start from lexbuf }
  | comment_begin { parse_comment lexbuf; parse_dependency_file start from lexbuf }
  | whitespace    { parse_dependency_file start from lexbuf }
  | quoted        { let open ExtraDep in
                    let loc = Loc.{start; finish = Lexing.lexeme_end_p lexbuf} in
                    let file = unquote_vfile_string (Lexing.lexeme lexbuf) in
                    skip_to_dot lexbuf; ExtraDep {loc;from;file} }
  | eof           { syntax_error lexbuf ~who:"parse_dependency_file" ~desc:msg_eof }
  | _             { syntax_error lexbuf ~who:"parse_dependency_file" ~desc:(msg_unable lexbuf) }

(* Parsing load file *)
and parse_load = parse
  | newline       { Lexing.new_line lexbuf; parse_load lexbuf }
  | comment_begin { parse_comment lexbuf; parse_load lexbuf }
  | whitespace    { parse_load lexbuf }
  | quoted        { let open Load in
                    let loc = Loc.of_lexbuf lexbuf in
                    let load = Physical (unquote_vfile_string (Lexing.lexeme lexbuf)) in
                    skip_to_dot lexbuf; Load {loc;load} }
  | coq_qualid    { let open Load in
                    let loc = Loc.of_lexbuf lexbuf in
                    let load = Logical (get_module lexbuf) in
                    skip_to_dot lexbuf; Load {loc;load} }
  | eof           { syntax_error lexbuf ~who:"parse_load" ~desc:msg_eof }
  | _             { syntax_error lexbuf ~who:"parse_load" ~desc:(msg_unable lexbuf) }

(* Vernac Commments parser *)
and parse_vernac_comments = parse
  | newline       { Lexing.new_line lexbuf; parse_vernac_comments lexbuf }
  (* This is a backwards compatible way of declaring extra dependencies. *)
  | "From"        { parse_from (Lexing.lexeme_start_p lexbuf) lexbuf }
  | '.'           { parse_coq lexbuf }
  | eof           { syntax_error lexbuf ~who:"parse_vernac_comments" ~desc:msg_eof ~hint:hint_eof_term }
  | _             { parse_vernac_comments lexbuf }

{

  let print_syntax_error Metadata.{who; loc; file = s; desc; hint} =
    let open Pp in
    strbrk "File \"" ++ str s ++ strbrk "\", "
      ++ strbrk (Token.Loc.to_string ~line:"line " ~lines:"lines "
        ~char:"character " ~chars:"characters " loc )
      ++ strbrk ":" ++ spc () ++ fnl ()
    ++ strbrk "Error: Syntax error during lexing."
    ++ pr_opt_no_spc (fun x -> fnl () ++ strbrk "Description: " ++ strbrk x) desc
    ++ pr_opt_no_spc (fun x -> fnl () ++ strbrk "Hint: " ++ strbrk x ++ str ".") hint
    ++
      if !Error.debug_mode then
        fnl () ++ strbrk "Internal info: " ++ strbrk who ++ str "."
      else str ""

  let _ = CErrors.register_handler @@ function
    | Syntax_error meta -> Some (print_syntax_error meta)
    | _ -> None

}
