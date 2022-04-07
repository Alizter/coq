module Rule = struct
  type t =
    { targets : string list
    ; deps : string list
    ; action : string
    ; alias : string option
    }

  let rec pp_list pp sep fmt l = match l with
    | []  -> ()
    | [l] -> Format.fprintf fmt "%a" pp l
    | x::xs -> Format.fprintf fmt "%a%a%a" pp x sep () (pp_list pp sep) xs

  let sep fmt () = Format.fprintf fmt "@;"

  let ppl = pp_list Format.pp_print_string sep
  let pp_alias fmt = function
    | None -> ()
    | Some alias -> Format.fprintf fmt "(alias %s)@\n" alias

  let pp fmt { alias; targets; deps; action } =
    Format.fprintf fmt
      "@[(rule@\n @[%a(targets @[%a@])@\n(deps @[%a@])@\n(action @[%a@])@])@]@\n"
      pp_alias alias ppl targets ppl deps Format.pp_print_string action
end

module Rules = struct
  let diff fmt file1 file2 =
    let rule_diff =
      Rule.{ targets = []
      ; deps = []
      ; action = Format.asprintf "(diff %s %s)" file1 file2
      ; alias = Some "runtest"
      } in
      Rule.pp fmt rule_diff
end
