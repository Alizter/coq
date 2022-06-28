(subdir lib
 (executables
  (names pp_big_vect
 coqProject)
  (libraries coq_utest coq-core.lib))
 
 (rule
  (targets pp_big_vect.ml.log)
  (action (with-accepted-exit-codes 0 (run ./pp_big_vect.exe))))
 (rule
  (targets coqProject.ml.log)
  (action (with-accepted-exit-codes 0 (run ./coqProject.exe))))
 
 (alias
  (name runtest) (deps (glob_files *.ml.log))))

(subdir clib
 (executables
  (names unicode_tests
 inteq)
  (libraries coq_utest coq-core.clib))
 
 (rule
  (targets unicode_tests.ml.log)
  (action (with-accepted-exit-codes 0 (run ./unicode_tests.exe))))
 (rule
  (targets inteq.ml.log)
  (action (with-accepted-exit-codes 0 (run ./inteq.exe))))
 
 (alias
  (name runtest) (deps (glob_files *.ml.log))))

(subdir printing
 (executables
  (names proof_diffs_test)
  (libraries coq_utest coq-core.printing))
 
 (rule
  (targets proof_diffs_test.ml.log)
  (action (with-accepted-exit-codes 0 (run ./proof_diffs_test.exe))))
 
 (alias
  (name runtest) (deps (glob_files *.ml.log))))

