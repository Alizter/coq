(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

(** * N-ary numbers *)

Require Import Datatypes Specif Decimal.

Module Type Digits.
 (** A generic type of base. *)
  Parameter (N : Type).

  (** The zero element of the base. *)
  Parameter (N_0 : N).

  (** The top element of the base (e.g. 9 for base 10) *)
  Parameter (N_top : N).

  (** Successor element taking elements less than the top element to next. *)
  Parameter (N_S : forall (_ : N), N).

    (** Boolean equality for base. *)
  Parameter (eq_N : forall (_ : N) (_ : N), bool).
End Digits.

Module Base (N : Digits).
  Import N.

  (** Scheme Boolean Equality doesn't support non-inductive types and it's not like we have a lot of lemmas about lists at this point anyway. *)
  Inductive uint := Nil | D (_ : N) (_ : uint).

  Notation zero := (D N_0 Nil).

  Variant signed_int := Pos (d : uint) | Neg (d : uint).
  Notation int := signed_int.

  (* TODO: do we want decimal or nary exponents? *)
  Variant nary :=
  | Nary (i : int) (f : uint)
  | NaryExp (i : int) (f : uint) (e : Decimal.int).

(*   Set Debug "backtrace". *)
  (* TODO: these fail badly, why? prob related to #15527 *)
  Fail Scheme Equality for uint.
  Fail Scheme Equality for int.
  Fail Scheme Equality for nary.
  Scheme Boolean Equality for uint.
  Scheme Boolean Equality for int.
  Scheme Boolean Equality for nary.

  (* TODO: prob register some stuff for ml at this point *)

  (** Number of digits *)
  Fixpoint nb_digits d :=
    match d with
    | Nil => O
    | D n d => S (nb_digits d)
    end.

  (** [nzhead] removes all head zero digits *)
  Fixpoint nzhead d :=
    match d with
    | D n d => if eq_N N_0 n then nzhead d else d
    | _ => d
    end.

  (** [unorm] : normalization of unsigned integers *)
  Definition unorm d :=
    match nzhead d with
    | Nil => zero
    | d => d
    end.

  (** [norm] : normalization of signed integers *)
  Definition norm d :=
    match d with
    | Pos d => Pos (unorm d)
    | Neg d =>
      match nzhead d with
      | Nil => Pos zero
      | d => Neg d
      end
    end.

  (** A few easy operations. For more advanced computations, use the conversions
      with other Coq numeral datatypes (e.g. Z) and the operations on them. *)

  Definition opp (d:int) :=
    match d with
    | Pos d => Neg d
    | Neg d => Pos d
    end.

  Definition abs (d:int) : uint :=
    match d with
    | Pos d => d
    | Neg d => d
    end.

  (** For conversions with binary numbers, it is easier to operate
      on little-endian numbers. *)

  Fixpoint revapp (d d' : uint) :=
    match d with
    | Nil => d'
    | D n d => revapp d (D n d')
    end.

  Definition rev d := revapp d Nil.

  Definition app d d' := revapp (rev d) d'.

  Definition app_int d1 d2 :=
    match d1 with
    | Pos d1 => Pos (app d1 d2)
    | Neg d1 => Neg (app d1 d2)
    end.

  (** [nztail] removes all trailing zero digits and return both the
      result and the number of removed digits. *)
  Definition nztail d :=
    let fix aux d_rev :=
      match d_rev with
      | D n d_rev =>
        if eq_N N_0 n then
          let (r, n) := aux d_rev in pair r (S n)
        else
          pair d_rev O
      | _ => pair d_rev O
      end in
    let (r, n) := aux (rev d) in pair (rev r) n.

  Definition nztail_int d :=
    match d with
    | Pos d => let (r, n) := nztail d in pair (Pos r) n
    | Neg d => let (r, n) := nztail d in pair (Neg r) n
    end.

  (** [del_head n d] removes [n] digits at beginning of [d]
      or returns [zero] if [d] has less than [n] digits. *)
  Fixpoint del_head n d :=
    match n with
    | O => d
    | S m =>
      match d with
      | Nil => zero
      | D _ d => del_head m d
      end
    end.

  Definition del_head_int n d :=
    match d with
    | Pos d => del_head n d
    | Neg d => del_head n d
    end.

  (** [del_tail n d] removes [n] digits at end of [d]
      or returns [zero] if [d] has less than [n] digits. *)
  Definition del_tail n d := rev (del_head n (rev d)).

  Definition del_tail_int n d :=
    match d with
    | Pos d => Pos (del_tail n d)
    | Neg d => Neg (del_tail n d)
    end.

  Module Little.

    (** Successor of little-endian numbers *)

    Fixpoint succ d :=
      match d with
      (** Morally this should be [succ (D N_0 Nil)] but Coq's fixpoint checker
          doesn't like this. Quite rightly too however since in the case
          [N_top = N_0] (unary) this would never terminate. *)
      | Nil => D (N_S N_0) Nil
      | D n d =>
        if eq_N N_top n then
          D N_0 (succ d)
        else
          D (N_S n) d
      end.

    (** Doubling little-endian numbers *)
    (* TODO: How to do this generically? *)
(* 
    Fixpoint double d :=
      match d with
      | Nil => Nil
      | D0 d => D0 (double d)
      | D1 d => D2 (double d)
      | D2 d => D4 (double d)
      | D3 d => D6 (double d)
      | D4 d => D8 (double d)
      | D5 d => D0 (succ_double d)
      | D6 d => D2 (succ_double d)
      | D7 d => D4 (succ_double d)
      | D8 d => D6 (succ_double d)
      | D9 d => D8 (succ_double d)
      end

    with succ_double d :=
      match d with
      | Nil => D1 Nil
      | D0 d => D1 (double d)
      | D1 d => D3 (double d)
      | D2 d => D5 (double d)
      | D3 d => D7 (double d)
      | D4 d => D9 (double d)
      | D5 d => D1 (succ_double d)
      | D6 d => D3 (succ_double d)
      | D7 d => D5 (succ_double d)
      | D8 d => D7 (succ_double d)
      | D9 d => D9 (succ_double d)
      end. *)

  End Little.

End Base.
