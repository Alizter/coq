(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *   INRIA, CNRS and contributors - Copyright 1999-2019       *)
(* <O___,, *       (see CREDITS file for the list of authors)           *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)
(*                                                                      *)
(* Micromega: A reflexive tactic using the Positivstellensatz           *)
(*                                                                      *)
(*  Frédéric Besson (Irisa/Inria)      2013-2016                        *)
(*                                                                      *)
(************************************************************************)

Require Import ZMicromega.
Require Import ZArith.
Require Import RingMicromega.
Require Import VarMap.
Require Import DeclConstant.
Require Coq.micromega.Tauto.
Declare ML Module "micromega_plugin".


Ltac zchange checker :=
  intros __wit __varmap __ff ;
  change (@Tauto.eval_bf _ (Zeval_formula (@find Z Z0 __varmap)) __ff) ;
  apply (checker __ff __wit).

Ltac zchecker_no_abstract checker :=
  zchange checker ; vm_compute ; reflexivity.

Ltac zchecker_abstract checker :=
  abstract (zchange checker ; vm_cast_no_check (eq_refl true)).

Ltac zchecker := zchecker_no_abstract ZTautoChecker_sound.

(*Ltac zchecker_ext := zchecker_no_abstract ZTautoCheckerExt_sound.*)

Ltac zchecker_ext :=
  intros __wit __varmap __ff ;
  exact (ZTautoCheckerExt_sound __ff __wit
                                (@eq_refl bool true <: @eq bool (ZTautoCheckerExt __ff __wit) true)
                                (@find Z Z0 __varmap)).

Ltac lia := zify; xlia zchecker_ext.
               
Ltac nia := zify; xnlia zchecker.


(* Local Variables: *)
(* coding: utf-8 *)
(* End: *)