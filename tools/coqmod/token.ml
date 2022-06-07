(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

module Loc = struct
  type t = {start : Lexing.position; finish : Lexing.position}

  let to_string ?(sep = ", ") ?(range_sep = "-") ?(line = "Ln ")
      ?(lines = "Ln ") ?(char = "Col ") ?(chars = "Col ") t =
    (* Configurable printing of locations *)
    let line1 = t.start.Lexing.pos_lnum in
    let line2 = t.finish.Lexing.pos_lnum in
    let col1 = t.start.Lexing.pos_cnum - t.start.Lexing.pos_bol + 1 in
    let col2 = t.finish.Lexing.pos_cnum - t.finish.Lexing.pos_bol + 1 in
    let line_range =
      if Int.equal line1 line2 then line ^ string_of_int line1
      else lines ^ string_of_int line1 ^ range_sep ^ string_of_int line2
    in
    let col_range =
      if Int.equal col1 col2 then char ^ string_of_int col1
      else chars ^ string_of_int col1 ^ range_sep ^ string_of_int col2
    in
    line_range ^ sep ^ col_range

  let dummy = {start = Lexing.dummy_pos; finish = Lexing.dummy_pos}

  let of_lexbuf lexbuf =
    Lexing.{start = lexeme_start_p lexbuf; finish = lexeme_end_p lexbuf}

  let pos_to_sexp pos =
    let open Csexp in
    List
      [
        Atom "Pos";
        List [Atom "Ln"; Atom (string_of_int pos.Lexing.pos_lnum)];
        List
          [
            Atom "Col";
            Atom (string_of_int (pos.Lexing.pos_cnum - pos.Lexing.pos_bol + 1));
          ];
      ]

  let to_sexp t =
    let open Csexp in
    List [Atom "Loc"; pos_to_sexp t.start; pos_to_sexp t.finish]
end

module Module = struct
  type t = {loc : Loc.t; logical_name : string}

  let to_string t = t.logical_name

  let to_sexp t =
    let open Csexp in
    List [Atom "Module"; Loc.to_sexp t.loc; Atom t.logical_name]

  let to_sexp_as_prefix t =
    let open Csexp in
    List [Atom "Prefix"; Loc.to_sexp t.loc; Atom t.logical_name]
end

module Require = struct
  type t = {loc : Loc.t; from : Module.t option; modules : Module.t list}

  let to_string t =
    let from =
      match t.from with
      | None -> ""
      | Some prefix -> " From " ^ Module.to_string prefix
    in
    Loc.to_string t.loc ^ from ^ " Require "
    ^ String.concat " " (List.map Module.to_string t.modules)

  let to_sexp t =
    let open Csexp in
    match t.from with
    | None ->
        List
          ( Atom "Require" :: Loc.to_sexp t.loc
          :: List.map Module.to_sexp t.modules )
    | Some from ->
        List
          ( Atom "From" :: Loc.to_sexp t.loc
          :: Module.to_sexp_as_prefix from
          :: List.map Module.to_sexp t.modules )
end

module Declare = struct
  type t = {loc : Loc.t; ml_modules : Module.t list}

  let to_string t =
    let f m =
      Loc.to_string m.Module.loc ^ " Declare ML Module " ^ Module.to_string m
    in
    List.map f t.ml_modules |> String.concat "\n"

  let to_sexp t =
    let open Csexp in
    List
      ( Atom "Declare" :: Loc.to_sexp t.loc
      :: List.map Module.to_sexp t.ml_modules )
end

module Load = struct
  type load_type = Logical of Module.t | Physical of string

  type t = {loc : Loc.t; load : load_type}

  let load_type_to_string = function
    | Logical m -> "Logical " ^ Module.to_string m
    | Physical path -> "Physical " ^ "\"" ^ path ^ "\""

  let to_string t = Loc.to_string t.loc ^ " " ^ load_type_to_string t.load

  let to_sexp t =
    let open Csexp in
    match t.load with
    | Logical m -> List [Atom "Logical"; Loc.to_sexp t.loc; Module.to_sexp m]
    | Physical path -> List [Atom "Physical"; Loc.to_sexp t.loc; Atom path]
end

module ExtraDep = struct
  type t = {loc : Loc.t; from : Module.t; file : string}

  let to_string t =
    Loc.to_string t.loc ^ " From " ^ Module.to_string t.from
    ^ " Extra Dependency " ^ "\"" ^ t.file ^ "\""

  let to_sexp t =
    let open Csexp in
    List
      [
        Atom "ExtraDep";
        Loc.to_sexp t.loc;
        Module.to_sexp_as_prefix t.from;
        Atom t.file;
      ]
end

type t =
  | Require of Require.t
  | Declare of Declare.t
  | Load of Load.t
  | ExtraDep of ExtraDep.t
  | Document of t list

let rec to_string = function
  | Require t -> Require.to_string t
  | Declare t -> Declare.to_string t
  | Load t -> Load.to_string t
  | ExtraDep t -> ExtraDep.to_string t
  | Document ts ->
      ["Begin Document"] @ List.map to_string ts @ ["End Document"]
      |> String.concat "\n"

let rec to_sexp = function
  | Require t -> Require.to_sexp t
  | Declare t -> Declare.to_sexp t
  | Load t -> Load.to_sexp t
  | ExtraDep t -> ExtraDep.to_sexp t
  | Document ts ->
      let open Csexp in
      List (Atom "Document" :: List.map to_sexp ts)

module Sexp = struct
  open Csexp

  let rec pp fmt =
    let pp_list = Format.pp_print_list pp ~pp_sep:Format.pp_print_space in
    function
    | Atom s -> Format.pp_print_string fmt s
    | List (Atom "Ln" :: ts) -> Format.fprintf fmt "@[<h1>(Ln %a@])" pp_list ts
    | List (Atom "Col" :: ts) ->
        Format.fprintf fmt "@[<h1>(Col %a@])" pp_list ts
    | List (Atom "Loc" :: ts) ->
        Format.fprintf fmt "@[<h1>(Loc@ %a@])" pp_list ts
    | List (Atom "Pos" :: ts) ->
        Format.fprintf fmt "@[<h1>(Pos %a@])" pp_list ts
    | List (Atom "Logical" :: ts) ->
        Format.fprintf fmt "@[<v1>(Logical@ %a@])" pp_list ts
    | List (Atom "Physical" :: ts) ->
        Format.fprintf fmt "@[<v1>(Physical@ %a@])" pp_list ts
    | List (Atom "ExtraDep" :: ts) ->
        Format.fprintf fmt "@[<v1>(ExtraDep@ %a@])" pp_list ts
    | List (Atom "Module" :: ts) ->
        Format.fprintf fmt "@[<v1>(Module@ %a@])" pp_list ts
    | List (Atom "Prefix" :: ts) ->
        Format.fprintf fmt "@[<v1>(Prefix@ %a@])" pp_list ts
    | List (Atom "Declare" :: ts) ->
        Format.fprintf fmt "@[<v1>(Declare@ %a@])" pp_list ts
    | List (Atom "Require" :: ts) ->
        Format.fprintf fmt "@[<v1>(Require@ %a@])" pp_list ts
    | List (Atom "From" :: ts) ->
        Format.fprintf fmt "@[<v1>(From@ %a@])" pp_list ts
    | List (Atom "Document" :: ts) ->
        Format.fprintf fmt "@[<v1>(Document@ %a@])" pp_list ts
    | List ts ->
        Format.fprintf fmt "@[<h1>(%a)@]"
          (Format.pp_print_list pp ~pp_sep:Format.pp_print_space)
          ts
end
