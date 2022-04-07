module Rule :
  sig
    type t = {
      targets : string list;
      deps : string list;
      action : string;
      alias : string option;
    }
    val ppl : Format.formatter -> string list -> unit
    val pp_alias : Format.formatter -> string option -> unit
    val pp : Format.formatter -> t -> unit
  end
