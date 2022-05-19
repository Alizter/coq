
let process ?(warn_all=false) ?(warn_fatal=false) ?(warn_args=[]) arg =
  (* First filter out existing "--arg" *)
  if not @@ Str.string_match (Str.regexp "--") arg 0
    (* Next filter remaining "-arg" *)
    && Str.string_match (Str.regexp "-") arg 0
    (* From these filter out those of length 2: -a *)
    && not @@ Int.equal (String.length arg) 2
  then
    (* If warnings are enabled, print them *)
    let () = if warn_all || List.mem arg warn_args then
      if not warn_fatal then
        Printf.eprintf "*** Warning: Command line argument %s is deprecated, please use -%s instead" arg arg
      else
        Printf.eprintf "*** Error: Command line argument %s is deprecated, please use -%s instead" arg arg; exit 1
      in "-" ^ arg
  else arg

let process_args ?(warn_all=false) ?(warn_fatal=false) ?(warn_args=[]) () =
  Array.map process Sys.argv
