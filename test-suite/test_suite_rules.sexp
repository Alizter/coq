(subdir bugs
 (rule
  (alias csdp-cache)
  (deps (universe)
        ../.csdp.cache.test-suite)
  (action
   (progn (no-infer (copy ../.csdp.cache.test-suite .csdp.cache))
    (run chmod +w .csdp.cache))))
 )
(subdir coqchk
 (rule
  (alias csdp-cache)
  (deps (universe)
        ../.csdp.cache.test-suite)
  (action
   (progn (no-infer (copy ../.csdp.cache.test-suite .csdp.cache))
    (run chmod +w .csdp.cache))))
 )(subdir failure)(subdir interactive)(subdir ltac2)
(subdir micromega
 (rule
  (alias csdp-cache)
  (deps (universe)
        ../.csdp.cache.test-suite)
  (action
   (progn (no-infer (copy ../.csdp.cache.test-suite .csdp.cache))
    (run chmod +w .csdp.cache))))
 )(subdir modules)
(subdir output
 (rule
  (alias csdp-cache)
  (deps (universe)
        ../.csdp.cache.test-suite)
  (action
   (progn (no-infer (copy ../.csdp.cache.test-suite .csdp.cache))
    (run chmod +w .csdp.cache))))
 )(subdir output-coqchk)(subdir output-coqtop)(subdir output-failure)
(subdir output-modulo-time)(subdir primitive/arrays)(subdir primitive/float)
(subdir primitive/sint63)(subdir primitive/uint63)(subdir ssr)(subdir stm)
(subdir success)(subdir vio)(subdir vio)(subdir complexity)
(subdir complexity
 (rule
  (alias runtest)
  (deps bug4076.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh bug4076.v bug4076.v.log))))
 (rule
  (alias runtest)
  (deps bug4076bis.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh bug4076bis.v bug4076bis.v.log))))
 (rule
  (alias runtest)
  (deps bug_13227_1.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh bug_13227_1.v bug_13227_1.v.log))))
 (rule
  (alias runtest)
  (deps bug_13227_2.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh bug_13227_2.v bug_13227_2.v.log))))
 (rule
  (alias runtest)
  (deps bug_13227_3.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh bug_13227_3.v bug_13227_3.v.log))))
 (rule
  (alias runtest)
  (deps bug_13227_4.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh bug_13227_4.v bug_13227_4.v.log))))
 (rule
  (alias runtest)
  (deps bug_13227_5.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh bug_13227_5.v bug_13227_5.v.log))))
 (rule
  (alias runtest)
  (deps bug_13227_6.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh bug_13227_6.v bug_13227_6.v.log))))
 (rule
  (alias runtest)
  (deps bug_5548.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh bug_5548.v bug_5548.v.log))))
 (rule
  (alias runtest)
  (deps bug_5702_guard.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh bug_5702_guard.v bug_5702_guard.v.log))))
 (rule
  (alias runtest)
  (deps ConstructiveCauchyRealsPerformance.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh ConstructiveCauchyRealsPerformance.v
    ConstructiveCauchyRealsPerformance.v.log))))
 (rule
  (alias runtest)
  (deps constructor.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh constructor.v constructor.v.log))))
 (rule
  (alias runtest)
  (deps evar_instance.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh evar_instance.v evar_instance.v.log))))
 (rule
  (alias runtest)
  (deps f_equal.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh f_equal.v f_equal.v.log))))
 (rule
  (alias runtest)
  (deps guard.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224 (run ../tools/complexity.sh guard.v guard.v.log))))
 (rule
  (alias runtest)
  (deps guard_illegal_call.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh guard_illegal_call.v guard_illegal_call.v.log))))
 (rule
  (alias runtest)
  (deps guard_return_predicate.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh guard_return_predicate.v
    guard_return_predicate.v.log))))
 (rule
  (alias runtest)
  (deps impargs.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh impargs.v impargs.v.log))))
 (rule
  (alias runtest)
  (deps injection.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh injection.v injection.v.log))))
 (rule
  (alias runtest)
  (deps lettuple.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh lettuple.v lettuple.v.log))))
 (rule
  (alias runtest)
  (deps Notations.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh Notations.v Notations.v.log))))
 (rule
  (alias runtest)
  (deps pattern.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh pattern.v pattern.v.log))))
 (rule
  (alias runtest)
  (deps patternmatching.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh patternmatching.v patternmatching.v.log))))
 (rule
  (alias runtest)
  (deps ring.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224 (run ../tools/complexity.sh ring.v ring.v.log))))
 (rule
  (alias runtest)
  (deps ring2.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224 (run ../tools/complexity.sh ring2.v ring2.v.log))))
 (rule
  (alias runtest)
  (deps setoid_rewrite.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh setoid_rewrite.v setoid_rewrite.v.log))))
 (rule
  (alias runtest)
  (deps unification.vo
        ../tools/complexity.sh)
  (action
   (setenv BOGOMIPS 4224
   (run ../tools/complexity.sh unification.v unification.v.log))))
 )
(subdir coqwc
 (rule
  (alias runtest)
  (deps BZ5637.v)
  (action
   (with-outputs-to BZ5637.v.log (run coqwc BZ5637.v))))
 (rule
  (alias runtest)
  (deps BZ5756.v)
  (action
   (with-outputs-to BZ5756.v.log (run coqwc BZ5756.v))))
 (rule
  (alias runtest)
  (deps false.v)
  (action
   (with-outputs-to false.v.log (run coqwc false.v))))
 (rule
  (alias runtest)
  (deps next-obligation.v)
  (action
   (with-outputs-to next-obligation.v.log (run coqwc next-obligation.v))))
 (rule
  (alias runtest)
  (deps theorem.v)
  (action
   (with-outputs-to theorem.v.log (run coqwc theorem.v))))
 )
(subdir ide
 (rule
  (alias runtest)
  (deps blocking-futures.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to blocking-futures.fake.log
    (run fake_ide %{bin:coqidetop.opt} blocking-futures.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps bug14981.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to bug14981.fake.log
    (run fake_ide %{bin:coqidetop.opt} bug14981.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2 -async-proofs-command-error-resilience on"))))
 (rule
  (alias runtest)
  (deps bug4246.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to bug4246.fake.log
    (run fake_ide %{bin:coqidetop.opt} bug4246.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps bug4249.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to bug4249.fake.log
    (run fake_ide %{bin:coqidetop.opt} bug4249.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps bug7088.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to bug7088.fake.log
    (run fake_ide %{bin:coqidetop.opt} bug7088.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps debug_ltac.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to debug_ltac.fake.log
    (run fake_ide %{bin:coqidetop.opt} debug_ltac.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps join-idem.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to join-idem.fake.log
    (run fake_ide %{bin:coqidetop.opt} join-idem.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps join-module1.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to join-module1.fake.log
    (run fake_ide %{bin:coqidetop.opt} join-module1.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps join-module2.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to join-module2.fake.log
    (run fake_ide %{bin:coqidetop.opt} join-module2.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps join-sync.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to join-sync.fake.log
    (run fake_ide %{bin:coqidetop.opt} join-sync.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps join.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to join.fake.log
    (run fake_ide %{bin:coqidetop.opt} join.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps load.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to load.fake.log
    (run fake_ide %{bin:coqidetop.opt} load.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps proof-diffs.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to proof-diffs.fake.log
    (run fake_ide %{bin:coqidetop.opt} proof-diffs.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps reopen.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to reopen.fake.log
    (run fake_ide %{bin:coqidetop.opt} reopen.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps reopen1.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to reopen1.fake.log
    (run fake_ide %{bin:coqidetop.opt} reopen1.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo001.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo001.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo001.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo002.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo002.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo002.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo003.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo003.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo003.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo004.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo004.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo004.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo005.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo005.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo005.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo006.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo006.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo006.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo008.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo008.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo008.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo009.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo009.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo009.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo010.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo010.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo010.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo012.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo012.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo012.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo013.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo013.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo013.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo014.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo014.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo014.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo015.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo015.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo015.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo016.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo016.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo016.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo017.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo017.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo017.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo018.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo018.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo018.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo019.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo019.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo019.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo020.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo020.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo020.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo021.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo021.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo021.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps undo022.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to undo022.fake.log
    (run fake_ide %{bin:coqidetop.opt} undo022.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 (rule
  (alias runtest)
  (deps univ.fake
        (source_tree %{project_root}/test-suite/output/load)
        %{project_root}/theories/Init/Prelude.vo
        %{project_root}/theories/Lists/List.vo
        %{project_root}/theories/extraction/Extraction.vo
        %{project_root}/user-contrib/Ltac2/Ltac2.vo
        (package coq-core))
  (action
   (with-outputs-to univ.fake.log
    (run fake_ide %{bin:coqidetop.opt} univ.fake
     "-q -async-proofs on -async-proofs-tactic-error-resilience off -async-proofs-command-error-resilience off -boot -I ../../../install/default/lib -R ../../theories Coq -R ../prerequisite TestSuite -Q ../../user-contrib/Ltac2 Ltac2"))))
 )(subdir coqdoc)
(subdir coqdoc
 (rule
  (alias runtest)
  (targets binder.html)
  (deps binder.v
        binder.vo
        binder.glob
        (package coq-core))
  (action
   (with-outputs-to binder.html.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --html
     binder.v))))
 (rule
  (alias runtest)
  (deps binder.html.out
        binder.html)
  (action
   (diff binder.html.out binder.html)))
 (rule
  (alias runtest)
  (targets binder.tex)
  (deps binder.v
        binder.vo
        binder.glob
        (package coq-core))
  (action
   (with-outputs-to binder.tex.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --latex
     binder.v))))
 (rule
  (alias runtest)
  (deps binder.tex)
  (action
   (with-outputs-to binder.tex.scrub (run grep -v "^%%" binder.tex))))
 (rule
  (alias runtest)
  (deps binder.tex.out
        binder.tex.scrub)
  (action
   (diff binder.tex.out binder.tex.scrub)))
 (rule
  (alias runtest)
  (targets bug11194.html)
  (deps bug11194.v
        bug11194.vo
        bug11194.glob
        (package coq-core))
  (action
   (with-outputs-to bug11194.html.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --html
     bug11194.v))))
 (rule
  (alias runtest)
  (deps bug11194.html.out
        bug11194.html)
  (action
   (diff bug11194.html.out bug11194.html)))
 (rule
  (alias runtest)
  (targets bug11194.tex)
  (deps bug11194.v
        bug11194.vo
        bug11194.glob
        (package coq-core))
  (action
   (with-outputs-to bug11194.tex.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --latex
     bug11194.v))))
 (rule
  (alias runtest)
  (deps bug11194.tex)
  (action
   (with-outputs-to bug11194.tex.scrub (run grep -v "^%%" bug11194.tex))))
 (rule
  (alias runtest)
  (deps bug11194.tex.out
        bug11194.tex.scrub)
  (action
   (diff bug11194.tex.out bug11194.tex.scrub)))
 (rule
  (alias runtest)
  (targets bug11353.html)
  (deps bug11353.v
        bug11353.vo
        bug11353.glob
        (package coq-core))
  (action
   (with-outputs-to bug11353.html.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --html -g
     bug11353.v))))
 (rule
  (alias runtest)
  (deps bug11353.html.out
        bug11353.html)
  (action
   (diff bug11353.html.out bug11353.html)))
 (rule
  (alias runtest)
  (targets bug11353.tex)
  (deps bug11353.v
        bug11353.vo
        bug11353.glob
        (package coq-core))
  (action
   (with-outputs-to bug11353.tex.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --latex
     -g bug11353.v))))
 (rule
  (alias runtest)
  (deps bug11353.tex)
  (action
   (with-outputs-to bug11353.tex.scrub (run grep -v "^%%" bug11353.tex))))
 (rule
  (alias runtest)
  (deps bug11353.tex.out
        bug11353.tex.scrub)
  (action
   (diff bug11353.tex.out bug11353.tex.scrub)))
 (rule
  (alias runtest)
  (targets bug12742.html)
  (deps bug12742.v
        bug12742.vo
        bug12742.glob
        (package coq-core))
  (action
   (with-outputs-to bug12742.html.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --html
     bug12742.v))))
 (rule
  (alias runtest)
  (deps bug12742.html.out
        bug12742.html)
  (action
   (diff bug12742.html.out bug12742.html)))
 (rule
  (alias runtest)
  (targets bug12742.tex)
  (deps bug12742.v
        bug12742.vo
        bug12742.glob
        (package coq-core))
  (action
   (with-outputs-to bug12742.tex.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --latex
     bug12742.v))))
 (rule
  (alias runtest)
  (deps bug12742.tex)
  (action
   (with-outputs-to bug12742.tex.scrub (run grep -v "^%%" bug12742.tex))))
 (rule
  (alias runtest)
  (deps bug12742.tex.out
        bug12742.tex.scrub)
  (action
   (diff bug12742.tex.out bug12742.tex.scrub)))
 (rule
  (alias runtest)
  (targets bug5648.html)
  (deps bug5648.v
        bug5648.vo
        bug5648.glob
        (package coq-core))
  (action
   (with-outputs-to bug5648.html.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --html
     bug5648.v))))
 (rule
  (alias runtest)
  (deps bug5648.html.out
        bug5648.html)
  (action
   (diff bug5648.html.out bug5648.html)))
 (rule
  (alias runtest)
  (targets bug5648.tex)
  (deps bug5648.v
        bug5648.vo
        bug5648.glob
        (package coq-core))
  (action
   (with-outputs-to bug5648.tex.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --latex
     bug5648.v))))
 (rule
  (alias runtest)
  (deps bug5648.tex)
  (action
   (with-outputs-to bug5648.tex.scrub (run grep -v "^%%" bug5648.tex))))
 (rule
  (alias runtest)
  (deps bug5648.tex.out
        bug5648.tex.scrub)
  (action
   (diff bug5648.tex.out bug5648.tex.scrub)))
 (rule
  (alias runtest)
  (targets bug5700.html)
  (deps bug5700.v
        bug5700.vo
        bug5700.glob
        (package coq-core))
  (action
   (with-outputs-to bug5700.html.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --html
     bug5700.v))))
 (rule
  (alias runtest)
  (deps bug5700.html.out
        bug5700.html)
  (action
   (diff bug5700.html.out bug5700.html)))
 (rule
  (alias runtest)
  (targets bug5700.tex)
  (deps bug5700.v
        bug5700.vo
        bug5700.glob
        (package coq-core))
  (action
   (with-outputs-to bug5700.tex.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --latex
     bug5700.v))))
 (rule
  (alias runtest)
  (deps bug5700.tex)
  (action
   (with-outputs-to bug5700.tex.scrub (run grep -v "^%%" bug5700.tex))))
 (rule
  (alias runtest)
  (deps bug5700.tex.out
        bug5700.tex.scrub)
  (action
   (diff bug5700.tex.out bug5700.tex.scrub)))
 (rule
  (alias runtest)
  (targets details.html)
  (deps details.v
        details.vo
        details.glob
        (package coq-core))
  (action
   (with-outputs-to details.html.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --html
     details.v))))
 (rule
  (alias runtest)
  (deps details.html.out
        details.html)
  (action
   (diff details.html.out details.html)))
 (rule
  (alias runtest)
  (targets details.tex)
  (deps details.v
        details.vo
        details.glob
        (package coq-core))
  (action
   (with-outputs-to details.tex.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --latex
     details.v))))
 (rule
  (alias runtest)
  (deps details.tex)
  (action
   (with-outputs-to details.tex.scrub (run grep -v "^%%" details.tex))))
 (rule
  (alias runtest)
  (deps details.tex.out
        details.tex.scrub)
  (action
   (diff details.tex.out details.tex.scrub)))
 (rule
  (alias runtest)
  (targets links.html)
  (deps links.v
        links.vo
        links.glob
        (package coq-core))
  (action
   (with-outputs-to links.html.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --html
     links.v))))
 (rule
  (alias runtest)
  (deps links.html.out
        links.html)
  (action
   (diff links.html.out links.html)))
 (rule
  (alias runtest)
  (targets links.tex)
  (deps links.v
        links.vo
        links.glob
        (package coq-core))
  (action
   (with-outputs-to links.tex.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --latex
     links.v))))
 (rule
  (alias runtest)
  (deps links.tex)
  (action
   (with-outputs-to links.tex.scrub (run grep -v "^%%" links.tex))))
 (rule
  (alias runtest)
  (deps links.tex.out
        links.tex.scrub)
  (action
   (diff links.tex.out links.tex.scrub)))
 (rule
  (alias runtest)
  (targets Record.html)
  (deps Record.v
        Record.vo
        Record.glob
        (package coq-core))
  (action
   (with-outputs-to Record.html.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --html
     Record.v))))
 (rule
  (alias runtest)
  (deps Record.html.out
        Record.html)
  (action
   (diff Record.html.out Record.html)))
 (rule
  (alias runtest)
  (targets Record.tex)
  (deps Record.v
        Record.vo
        Record.glob
        (package coq-core))
  (action
   (with-outputs-to Record.tex.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --latex
     Record.v))))
 (rule
  (alias runtest)
  (deps Record.tex)
  (action
   (with-outputs-to Record.tex.scrub (run grep -v "^%%" Record.tex))))
 (rule
  (alias runtest)
  (deps Record.tex.out
        Record.tex.scrub)
  (action
   (diff Record.tex.out Record.tex.scrub)))
 (rule
  (alias runtest)
  (targets verbatim.html)
  (deps verbatim.v
        verbatim.vo
        verbatim.glob
        (package coq-core))
  (action
   (with-outputs-to verbatim.html.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --html
     verbatim.v))))
 (rule
  (alias runtest)
  (deps verbatim.html.out
        verbatim.html)
  (action
   (diff verbatim.html.out verbatim.html)))
 (rule
  (alias runtest)
  (targets verbatim.tex)
  (deps verbatim.v
        verbatim.vo
        verbatim.glob
        (package coq-core))
  (action
   (with-outputs-to verbatim.tex.log
    (run %{bin:coqdoc} -utf8 -coqlib_url http://coq.inria.fr/stdlib --latex
     verbatim.v))))
 (rule
  (alias runtest)
  (deps verbatim.tex)
  (action
   (with-outputs-to verbatim.tex.scrub (run grep -v "^%%" verbatim.tex))))
 (rule
  (alias runtest)
  (deps verbatim.tex.out
        verbatim.tex.scrub)
  (action
   (diff verbatim.tex.out verbatim.tex.scrub)))
 )
(subdir coq-makefile
 (subdir arg
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to arg.log (run ./run.sh))))))
  )
 (subdir camldep
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to camldep.log (run ./run.sh))))))
  )
 (subdir coqdoc1
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to coqdoc1.log (run ./run.sh))))))
  )
 (subdir coqdoc2
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to coqdoc2.log (run ./run.sh))))))
  )
 (subdir emptyprefix
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to emptyprefix.log (run ./run.sh))))))
  )
 (subdir extend-subdirs
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to extend-subdirs.log (run ./run.sh))))))
  )
 (subdir findlib-package
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to findlib-package.log (run ./run.sh))))))
  )
 (subdir findlib-package-unpacked
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to findlib-package-unpacked.log (run ./run.sh))))))
  )
 (subdir gen-v-during-make
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to gen-v-during-make.log (run ./run.sh))))))
  )
 (subdir latex1
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to latex1.log (run ./run.sh))))))
  )
 (subdir local-late-extension
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to local-late-extension.log (run ./run.sh))))))
  )
 (subdir merlin1
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to merlin1.log (run ./run.sh))))))
  )
 (subdir missing-included
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to missing-included.log (run ./run.sh))))))
  )
 (subdir missing-install
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to missing-install.log (run ./run.sh))))))
  )
 (subdir missing-required
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to missing-required.log (run ./run.sh))))))
  )
 (subdir mlpack1
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to mlpack1.log (run ./run.sh))))))
  )
 (subdir mlpack2
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to mlpack2.log (run ./run.sh))))))
  )
 (subdir multiroot
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to multiroot.log (run ./run.sh))))))
  )
 (subdir native1
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to native1.log (run ./run.sh))))))
  )
 (subdir native2
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to native2.log (run ./run.sh))))))
  )
 (subdir native3
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to native3.log (run ./run.sh))))))
  )
 (subdir native4
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to native4.log (run ./run.sh))))))
  )
 (subdir only
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to only.log (run ./run.sh))))))
  )
 (subdir plugin1
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to plugin1.log (run ./run.sh))))))
  )
 (subdir plugin2
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to plugin2.log (run ./run.sh))))))
  )
 (subdir plugin3
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to plugin3.log (run ./run.sh))))))
  )
 (subdir quick2vo
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to quick2vo.log (run ./run.sh))))))
  )
 (subdir timing
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to timing.log (run ./run.sh))))))
  )
 (subdir uninstall1
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to uninstall1.log (run ./run.sh))))))
  )
 (subdir uninstall2
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to uninstall2.log (run ./run.sh))))))
  )
 (subdir validate1
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to validate1.log (run ./run.sh))))))
  )
 (subdir vio2vo
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to vio2vo.log (run ./run.sh))))))
  )
 (subdir vos
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         %{bin:coq_makefile}
         %{project_root}/tools/CoqMakefile.in
         (source_tree ../template)
         (package coq-core)
         (package coq-stdlib))
   (action
    (setenv CoqMakefile_in %{project_root}/tools/CoqMakefile.in
    (setenv TTOOLSDIR %{project_root}/tools
    (with-outputs-to vos.log (run ./run.sh))))))
  )
 )
(subdir tools
 (subdir update-compat
  (rule
   (alias runtest)
   (deps run.sh
         (source_tree .)
         (source_tree %{project_root}/theories/Compat)
         %{project_root}/test-suite/success/CompatOldOldFlag.v
         %{project_root}/sysinit/coqargs.ml
         %{project_root}/tools/configure/configure.ml
         %{project_root}/dev/tools/update-compat.py
         %{project_root}/dev/header.ml
         %{project_root}/doc/stdlib/index-list.html.template)
   (action
    (with-outputs-to update-compat.log (run ./run.sh))))
  )
 )
(subdir misc
 (rule
  (alias runtest)
  (deps 11170.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to 11170.sh.log (run ./11170.sh))))
 (rule
  (alias runtest)
  (deps 13330.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to 13330.sh.log (run ./13330.sh))))
 (rule
  (alias runtest)
  (deps 4722.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to 4722.sh.log (run ./4722.sh))))
 (rule
  (alias runtest)
  (deps 7393.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to 7393.sh.log (run ./7393.sh))))
 (rule
  (alias runtest)
  (deps 7595.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to 7595.sh.log (run ./7595.sh))))
 (rule
  (alias runtest)
  (deps 7704.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to 7704.sh.log (run ./7704.sh))))
 (rule
  (alias runtest)
  (deps bug_14550.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to bug_14550.sh.log (run ./bug_14550.sh))))
 (rule
  (alias runtest)
  (deps changelog.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to changelog.sh.log (run ./changelog.sh))))
 (rule
  (alias runtest)
  (deps coqc_dash_o.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to coqc_dash_o.sh.log (run ./coqc_dash_o.sh))))
 (rule
  (alias runtest)
  (deps coqc_dash_vok.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to coqc_dash_vok.sh.log (run ./coqc_dash_vok.sh))))
 (rule
  (alias runtest)
  (deps coqdep-require-filter-categories.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to coqdep-require-filter-categories.sh.log
    (run ./coqdep-require-filter-categories.sh))))
 (rule
  (alias runtest)
  (deps coqtop_print-mod-uid.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to coqtop_print-mod-uid.sh.log
    (run ./coqtop_print-mod-uid.sh))))
 (rule
  (alias runtest)
  (deps coq_environment.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to coq_environment.sh.log (run ./coq_environment.sh))))
 (rule
  (alias runtest)
  (deps coq_makefile_destination_of.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to coq_makefile_destination_of.sh.log
    (run ./coq_makefile_destination_of.sh))))
 (rule
  (alias runtest)
  (deps deps-checksum.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to deps-checksum.sh.log (run ./deps-checksum.sh))))
 (rule
  (alias runtest)
  (deps deps-order-distinct-root.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to deps-order-distinct-root.sh.log
    (run ./deps-order-distinct-root.sh))))
 (rule
  (alias runtest)
  (deps deps-order-from.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to deps-order-from.sh.log (run ./deps-order-from.sh))))
 (rule
  (alias runtest)
  (deps deps-order-subdir1-file.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to deps-order-subdir1-file.sh.log
    (run ./deps-order-subdir1-file.sh))))
 (rule
  (alias runtest)
  (deps deps-order-subdir2-file.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to deps-order-subdir2-file.sh.log
    (run ./deps-order-subdir2-file.sh))))
 (rule
  (alias runtest)
  (deps deps-order-subdir3-file.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to deps-order-subdir3-file.sh.log
    (run ./deps-order-subdir3-file.sh))))
 (rule
  (alias runtest)
  (deps deps-order.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to deps-order.sh.log (run ./deps-order.sh))))
 (rule
  (alias runtest)
  (deps deps-utf8.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to deps-utf8.sh.log (run ./deps-utf8.sh))))
 (rule
  (alias runtest)
  (deps exitstatus.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to exitstatus.sh.log (run ./exitstatus.sh))))
 (rule
  (alias runtest)
  (deps external-deps.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to external-deps.sh.log (run ./external-deps.sh))))
 (rule
  (alias runtest)
  (deps non-marshalable-state.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to non-marshalable-state.sh.log
    (run ./non-marshalable-state.sh))))
 (rule
  (alias runtest)
  (deps poly-capture-global-univs.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to poly-capture-global-univs.sh.log
    (run ./poly-capture-global-univs.sh))))
 (rule
  (alias runtest)
  (deps print-assumptions-vok.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to print-assumptions-vok.sh.log
    (run ./print-assumptions-vok.sh))))
 (rule
  (alias runtest)
  (deps printers.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to printers.sh.log (run ./printers.sh))))
 (rule
  (alias runtest)
  (deps quick-include.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to quick-include.sh.log (run ./quick-include.sh))))
 (rule
  (alias runtest)
  (deps quotation_token.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to quotation_token.sh.log (run ./quotation_token.sh))))
 (rule
  (alias runtest)
  (deps redirect_printing.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to redirect_printing.sh.log (run ./redirect_printing.sh))))
 (rule
  (alias runtest)
  (deps side-eff-leak-univs.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to side-eff-leak-univs.sh.log
    (run ./side-eff-leak-univs.sh))))
 (rule
  (alias runtest)
  (deps universes.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to universes.sh.log (run ./universes.sh))))
 (rule
  (alias runtest)
  (deps vio_checking.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to vio_checking.sh.log (run ./vio_checking.sh))))
 (rule
  (alias runtest)
  (deps votour.sh
        (source_tree .)
        ../../config/coq_config.py
        ../prerequisite/ssr_mini_mathcomp.vo
        (package coq-core)
        (source_tree deps)
        (package coq-stdlib)
        %{lib:coq-core.vm:../../stublibs/dllcoqrun_stubs.so}
        ../../dev/incdir_dune
        ../../dev/base_include
        ../../dev/inc_ltac_dune
        ../../dev/include_printers
        ../../dev/include
        ../../dev/top_printers.ml
        ../../dev/vm_printers.ml
        ../prerequisite/admit.vo)
  (action
   (with-outputs-to votour.sh.log (run ./votour.sh))))
 )
