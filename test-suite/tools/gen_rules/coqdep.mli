module Vodep : sig
  type t =
    { target : string
    ; deps : string list
    }
end

val parse_coqdep_line : string -> (string list * Vodep.t) option
