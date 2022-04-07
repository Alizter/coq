let back_to_root dir =
  let rec back_to_root_aux = function
  | [] -> []
  | l :: ls -> ".." :: back_to_root_aux ls
  in
  Str.split (Str.regexp "/") dir
  |> back_to_root_aux
  |> String.concat "/"

let scan_files_by_ext ext dir =
  Sys.readdir dir
  |> Array.to_list
  |> List.filter (fun f -> Filename.check_suffix f ext)
