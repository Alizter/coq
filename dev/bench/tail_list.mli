val map : ('a -> 'b) -> 'a list -> 'b list
(** Tail-recursive map *)

val map2 : ('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list
(** Tail-recursive map2 *)

val append : 'a list -> 'a list -> 'a list
(** Tail-recursive append *)

val flatten :  'a list list -> 'a list
(** Tail recursive flatten *)
