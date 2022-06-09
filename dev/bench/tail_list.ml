
let map f l = Stdlib.List.rev (Stdlib.List.rev_map f l)
let map2 f l1 l2 = Stdlib.List.rev (Stdlib.List.rev_map2 f l1 l2)

let append l1 l2 = Stdlib.List.rev (Stdlib.List.rev_append l1 l2)

let flatten l =
  let rec loop res = function
    | [] -> Stdlib.List.rev res
    | h::t -> loop (Stdlib.List.rev_append h res) t
  in
  loop [] l
