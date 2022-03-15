Axioms P Q : nat -> Prop.

Axiom f : forall n, P n.

Goal Q 0.
  Fail apply f.
  (* Used to be: *)
  (* Unable to unify "P ?M150" with "Q 0". *)
Abort.
