
val process_args :
  ?warn_all:bool ->
  ?warn_fatal:bool ->
  ?warn_args:'a list ->
  unit ->
  string array
(** * Return an array having preprocessed [Sys.argv] by changing ["-arg"] into
      ["--arg"] but preserving ["-a"] and other arguments.
      - [?warn_all] throws a warning when this change happens.
      - [?warn_args] is a list of args to warn about.
      - [?warn_fatal] turns the warnings into errors.
*)
