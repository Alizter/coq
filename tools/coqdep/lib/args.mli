(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

type t =
  { boot : bool
  ; sort : bool
  ; vos : bool
  ; noglob : bool
  ; noinit : bool
  ; coqproject : string option
  ; ml_path : string list
  ; vo_path : (bool * string * string) list
  ; dyndep : Options.Dynlink.t
  ; meta_files : string list
  ; files : string list
  }

  val make : bool ->
    bool ->
    bool ->
    bool ->
    bool ->
    string option ->
    string list ->
    (bool * string * string) list ->
    Options.Dynlink.t -> string list -> string list -> t
val init : unit -> t
val usage : unit -> 'a
val parse : t -> string list -> t
