
let deprecated ?(warn_fatal=false) arg =
  let msg = Printf.sprintf "Command line argument %s is deprecated, please use -%s instead" arg arg in
  if not warn_fatal then
    Printf.eprintf "*** Warning: %s" msg
  else
    Printf.eprintf "*** Error: %s" msg; exit 1

let process ~warn_all ~warn_fatal ~warn_args arg =
  (* First filter out existing "--arg" *)
  if not @@ Str.string_match (Str.regexp "--") arg 0
    (* Next filter remaining "-arg" *)
    && Str.string_match (Str.regexp "-") arg 0
    (* From these filter out those of length 2: -a *)
    && not @@ Int.equal (String.length arg) 2
  then
    (* If warnings are enabled, print them *)
    let () =
      if warn_all || List.mem arg warn_args then deprecated ~warn_fatal arg;
    in "-" ^ arg
  else arg

let process_args ?(warn_all=false) ?(warn_fatal=false) ?(warn_args=[]) () =
  Array.map (process ~warn_all ~warn_fatal ~warn_args) Sys.argv
