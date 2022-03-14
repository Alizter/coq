(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

Require Import Arith Lia.
Require Import BaseN.
Require Vectors.Fin.

(** * Testing N-ary numbers *)

(** Base 10 *)

Notation "t $ r" := (t r)
  (at level 65, right associativity, only parsing).

Module Ten : Digits.
  Definition N := {n : nat | n < 10}.
  Program Definition N_0 : N := 0.
  Program Definition N_top : N := 9.
  Program Definition N_S : N -> N := fun x => (S x) mod 10.
  Program Definition eq_N : N -> N -> bool := Nat.eqb.
  
  Next Obligation. lia. Qed.
  Next Obligation.
    refine (Nat.mod_upper_bound (S _) 10 _).
    lia.
  Qed.

End Ten.

Module Dec := Base Ten.



