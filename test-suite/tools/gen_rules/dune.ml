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
      ; deps = [file1; file2]
      ; action = Format.asprintf "(diff %s %s)" file1 file2
      ; alias = Some "runtest"
      } in
      Rule.pp fmt rule_diff

  let run ~run ~out ?log_file ?(targets=[]) ?(deps=[]) () =
    match log_file with
    | Some log_file ->
      let rule = Rule.{
        targets = log_file :: targets
        ; deps = deps
        ; action = Format.asprintf "(with-outputs-to %s (run %s))" log_file run
        ; alias = Some "runtest"
        } in
      Rule.pp out rule
    | None ->
      let rule = Rule.{
        targets = targets
        ; deps = deps
        ; action = Format.asprintf "(run %s)" run
        ; alias = Some "runtest"
        } in
      Rule.pp out rule

  let bash ~run ~out ?log_file ?(targets=[]) ?(deps=[]) () =
    match log_file with
    | Some log_file ->
      let rule = Rule.{
        targets = log_file :: targets
        ; deps = deps
        ; action = Format.asprintf "(with-outputs-to %s (bash %s))" log_file run
        ; alias = Some "runtest"
        } in
      Rule.pp out rule
    | None ->
      let rule = Rule.{
        targets = targets
        ; deps = deps
        ; action = Format.asprintf "(bash %s)" run
        ; alias = Some "runtest"
        } in
      Rule.pp out rule

  let in_subdir dir out ~f =
    (* The thunking here is important for order of execution *)
    Format.fprintf out "(subdir %s@\n @[" dir;
    (* We catch and reraise exceptions in order to balance the stanza correctly *)
    let () = try f () with exn -> Format.fprintf out "@])@\n"; raise exn in
    Format.fprintf out "@])@\n";
    ()
end
