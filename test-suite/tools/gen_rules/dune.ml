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
  let diff ~out ?(alias=Some "runtest") file1 file2 =
    let rule_diff =
      Rule.{ targets = []
      ; deps = [file1; file2]
      ; action = Format.asprintf "(diff %s %s)" file1 file2
      ; alias
      } in
      Rule.pp out rule_diff

    let exit_codes_to_string = function
      | [] -> "0"
      | l -> Printf.sprintf "(or %s)" @@ String.concat " " (List.map string_of_int l)

  let run ~run ~out ?log_file ?in_file ?(alias=Some "runtest") ?(envs=[]) ?(exit_codes=[]) ?(targets=[]) ?(deps=[]) () =
    let rec flatten_env envs dsl = match envs with
      | (envvar, envval) :: envs -> Format.asprintf "(setenv %s %s %s)" envvar envval @@ flatten_env envs dsl
      | [] -> dsl
    in
    let with_outputs_to log_file dsl = match log_file with
      | Some log_file -> Format.asprintf "(with-outputs-to %s %s)" log_file dsl
      | None -> dsl
    in
    let targets = function
      | Some log_file -> log_file :: targets
      | None -> targets
    in
    let with_exit_codes exit_codes dsl = match exit_codes with
      | [] -> dsl
      | exit_codes -> Format.asprintf "(with-accepted-exit-codes %s %s)" (exit_codes_to_string exit_codes) dsl
    in
    let with_stdin_from in_file dsl = match in_file with
      | Some in_file -> Format.asprintf "(with-stdin-from %s %s)" in_file dsl
      | None -> dsl
    in
    let rule = Rule.{
      targets = targets log_file
      ; deps = deps
      ; action = flatten_env envs
        @@ with_outputs_to log_file
        @@ with_exit_codes exit_codes
        @@ with_stdin_from in_file
        @@ Format.asprintf "(run %s)"  run
      ; alias
      } in
    Rule.pp out rule

  let in_subdir dir out ~f =
    (* The thunking here is important for order of execution *)
    Format.fprintf out "(subdir %s@\n @[" dir;
    (* We catch and reraise exceptions in order to balance the stanza correctly *)
    let () = try f () with exn -> Format.fprintf out "@])@\n"; raise exn in
    Format.fprintf out "@])@\n";
    ()

  (* TODO: share more with run *)
  let run_pipe ~runs ~out ?log_file ?(targets=[]) ?(deps=[]) () =
    match log_file with
    | Some log_file ->
      let rule = Rule.{
        targets = log_file :: targets
        ; deps = deps
        ; action = runs
        |> List.map (Printf.sprintf "(run %s)")
        |> String.concat " "
        |> Format.asprintf "(with-outputs-to %s (pipe-outputs %s))" log_file
        ; alias = Some "runtest"
        } in
      Rule.pp out rule
    | None ->
      let rule = Rule.{
        targets = targets
        ; deps = deps
        (* Should it be pipe-outputs or pipe-stdout? *)
        ; action = runs
          |> List.map (Printf.sprintf "(run %s)")
          |> String.concat " "
          |> Format.asprintf "(pipe-stdout %s)"
        ; alias = Some "runtest"
        } in
      Rule.pp out rule
end
