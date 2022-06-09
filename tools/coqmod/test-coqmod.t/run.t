Testing the output of coqmod


No file error
  $ coqmod
  Error: No file provided. Please provide a file.
  [1]

Too many files error
  $ coqmod A.v B.v
  Error: Too many files provided. Please provide only a single file.
  [1]

Syntax error
  $ coqmod Syntax.v
  File "Syntax.v", line 1, characters 14-15: 
  Error: Syntax error during lexing.
  Description: Unable to parse: "{".
  [1]
  $ coqmod Syntax.v --debug
  File "Syntax.v", line 1, characters 14-15: 
  Error: Syntax error during lexing.
  Description: Unable to parse: "{".
  Internal info: parse_from_require_or_extradep.
  [1]

Invalid format
  $ coqmod --format=foo B.v
  Error: Unkown output format: foo
  [1]

Help screen
  $ coqmod --help
  coqmod - A simple module lexer for Coq
    --format Set output format [csexp|sexp|read]
    --debug Output debugging information
    -help  Display this list of options
    --help  Display this list of options

Empty file
  $ coqmod A.v
  (8:Document)

README.md example
  $ cat > example.v << EOF
  > From A.B.C Require Import R.X L.Y.G Z.W.
  > 
  > Load X.
  > Load "A/b/c".
  > 
  > Declare ML Module "foo.bar.baz".
  > 
  > Require A B C.
  > 
  > Require Import AI BI CI.
  > EOF

  $ coqmod example.v
  (8:Document(4:From(3:Loc(3:Pos(2:Ln1:1)(3:Col1:1))(3:Pos(2:Ln1:1)(3:Col2:40)))(6:Prefix(3:Loc(3:Pos(2:Ln1:1)(3:Col1:6))(3:Pos(2:Ln1:1)(3:Col2:11)))5:A.B.C)(6:Module(3:Loc(3:Pos(2:Ln1:1)(3:Col2:27))(3:Pos(2:Ln1:1)(3:Col2:30)))3:R.X)(6:Module(3:Loc(3:Pos(2:Ln1:1)(3:Col2:31))(3:Pos(2:Ln1:1)(3:Col2:36)))5:L.Y.G)(6:Module(3:Loc(3:Pos(2:Ln1:1)(3:Col2:37))(3:Pos(2:Ln1:1)(3:Col2:40)))3:Z.W))(7:Logical(3:Loc(3:Pos(2:Ln1:3)(3:Col1:6))(3:Pos(2:Ln1:3)(3:Col1:7)))(6:Module(3:Loc(3:Pos(2:Ln1:3)(3:Col1:6))(3:Pos(2:Ln1:3)(3:Col1:7)))1:X))(8:Physical(3:Loc(3:Pos(2:Ln1:4)(3:Col1:6))(3:Pos(2:Ln1:4)(3:Col2:13)))5:A/b/c)(7:Declare(3:Loc(3:Pos(2:Ln1:6)(3:Col1:1))(3:Pos(2:Ln1:6)(3:Col2:32)))(6:Module(3:Loc(3:Pos(2:Ln1:6)(3:Col2:20))(3:Pos(2:Ln1:6)(3:Col2:31)))11:foo.bar.baz))(7:Require(3:Loc(3:Pos(2:Ln1:8)(3:Col1:1))(3:Pos(2:Ln1:8)(3:Col2:14)))(6:Module(3:Loc(3:Pos(2:Ln1:8)(3:Col1:9))(3:Pos(2:Ln1:8)(3:Col2:10)))1:A)(6:Module(3:Loc(3:Pos(2:Ln1:8)(3:Col2:11))(3:Pos(2:Ln1:8)(3:Col2:12)))1:B)(6:Module(3:Loc(3:Pos(2:Ln1:8)(3:Col2:13))(3:Pos(2:Ln1:8)(3:Col2:14)))1:C))(7:Require(3:Loc(3:Pos(2:Ln2:10)(3:Col1:1))(3:Pos(2:Ln2:10)(3:Col2:24)))(6:Module(3:Loc(3:Pos(2:Ln2:10)(3:Col2:16))(3:Pos(2:Ln2:10)(3:Col2:18)))2:AI)(6:Module(3:Loc(3:Pos(2:Ln2:10)(3:Col2:19))(3:Pos(2:Ln2:10)(3:Col2:21)))2:BI)(6:Module(3:Loc(3:Pos(2:Ln2:10)(3:Col2:22))(3:Pos(2:Ln2:10)(3:Col2:24)))2:CI)))
  $ coqmod example.v --format=read
  Begin Document
  Ln 1, Col 1-40 From A.B.C Require R.X L.Y.G Z.W
  Ln 3, Col 6-7 Logical X
  Ln 4, Col 6-13 Physical "A/b/c"
  Ln 6, Col 20-31 Declare ML Module foo.bar.baz
  Ln 8, Col 1-14 Require A B C
  Ln 10, Col 1-24 Require AI BI CI
  End Document
  $ coqmod example.v --format=sexp
  (Document
   (From
    (Loc (Pos (Ln 1) (Col 1)) (Pos (Ln 1) (Col 40)))
    (Prefix
     (Loc (Pos (Ln 1) (Col 6)) (Pos (Ln 1) (Col 11)))
     A.B.C)
    (Module
     (Loc (Pos (Ln 1) (Col 27)) (Pos (Ln 1) (Col 30)))
     R.X)
    (Module
     (Loc (Pos (Ln 1) (Col 31)) (Pos (Ln 1) (Col 36)))
     L.Y.G)
    (Module
     (Loc (Pos (Ln 1) (Col 37)) (Pos (Ln 1) (Col 40)))
     Z.W))
   (Logical
    (Loc (Pos (Ln 3) (Col 6)) (Pos (Ln 3) (Col 7)))
    (Module
     (Loc (Pos (Ln 3) (Col 6)) (Pos (Ln 3) (Col 7)))
     X))
   (Physical
    (Loc (Pos (Ln 4) (Col 6)) (Pos (Ln 4) (Col 13)))
    A/b/c)
   (Declare
    (Loc (Pos (Ln 6) (Col 1)) (Pos (Ln 6) (Col 32)))
    (Module
     (Loc (Pos (Ln 6) (Col 20)) (Pos (Ln 6) (Col 31)))
     foo.bar.baz))
   (Require
    (Loc (Pos (Ln 8) (Col 1)) (Pos (Ln 8) (Col 14)))
    (Module
     (Loc (Pos (Ln 8) (Col 9)) (Pos (Ln 8) (Col 10)))
     A)
    (Module
     (Loc (Pos (Ln 8) (Col 11)) (Pos (Ln 8) (Col 12)))
     B)
    (Module
     (Loc (Pos (Ln 8) (Col 13)) (Pos (Ln 8) (Col 14)))
     C))
   (Require
    (Loc (Pos (Ln 10) (Col 1)) (Pos (Ln 10) (Col 24)))
    (Module
     (Loc (Pos (Ln 10) (Col 16)) (Pos (Ln 10) (Col 18)))
     AI)
    (Module
     (Loc (Pos (Ln 10) (Col 19)) (Pos (Ln 10) (Col 21)))
     BI)
    (Module
     (Loc (Pos (Ln 10) (Col 22)) (Pos (Ln 10) (Col 24)))
     CI)))

Simple Require
  $ coqmod B.v
  (8:Document(7:Require(3:Loc(3:Pos(2:Ln1:1)(3:Col1:1))(3:Pos(2:Ln1:1)(3:Col2:17)))(6:Module(3:Loc(3:Pos(2:Ln1:1)(3:Col2:16))(3:Pos(2:Ln1:1)(3:Col2:17)))1:A)))
  $ coqmod --format=read B.v
  Begin Document
  Ln 1, Col 1-17 Require A
  End Document
  $ coqmod --format=sexp B.v
  (Document
   (Require
    (Loc (Pos (Ln 1) (Col 1)) (Pos (Ln 1) (Col 17)))
    (Module
     (Loc (Pos (Ln 1) (Col 16)) (Pos (Ln 1) (Col 17)))
     A)))

Specification:

Require
  $ cat > Require.v << EOF
  > Require A B.
  > EOF
  $ coqmod Require.v --format=sexp
  (Document
   (Require
    (Loc (Pos (Ln 1) (Col 1)) (Pos (Ln 1) (Col 12)))
    (Module
     (Loc (Pos (Ln 1) (Col 9)) (Pos (Ln 1) (Col 10)))
     A)
    (Module
     (Loc (Pos (Ln 1) (Col 11)) (Pos (Ln 1) (Col 12)))
     B)))
From
  $ cat > From.v << EOF
  > From A Require B C.
  > EOF
  $ coqmod From.v --format=sexp
  (Document
   (From
    (Loc (Pos (Ln 1) (Col 1)) (Pos (Ln 1) (Col 19)))
    (Prefix
     (Loc (Pos (Ln 1) (Col 6)) (Pos (Ln 1) (Col 7)))
     A)
    (Module
     (Loc (Pos (Ln 1) (Col 16)) (Pos (Ln 1) (Col 17)))
     B)
    (Module
     (Loc (Pos (Ln 1) (Col 18)) (Pos (Ln 1) (Col 19)))
     C)))
Declare
  $ cat > Declare.v << EOF
  > Declare ML Module "foo" "bar.baz".
  > EOF
  $ coqmod Declare.v --format=sexp
  (Document
   (Declare
    (Loc (Pos (Ln 1) (Col 1)) (Pos (Ln 1) (Col 34)))
    (Module
     (Loc (Pos (Ln 1) (Col 20)) (Pos (Ln 1) (Col 23)))
     foo)
    (Module
     (Loc (Pos (Ln 1) (Col 26)) (Pos (Ln 1) (Col 33)))
     bar.baz)))
Load logical
  $ cat > LoadLogical.v << EOF
  > Load A.B.
  > EOF
  $ coqmod LoadLogical.v --format=sexp
  (Document
   (Logical
    (Loc (Pos (Ln 1) (Col 6)) (Pos (Ln 1) (Col 9)))
    (Module
     (Loc (Pos (Ln 1) (Col 6)) (Pos (Ln 1) (Col 9)))
     A.B)))
Load physical
  $ cat > LoadPhysical.v << EOF
  > Load "a/b/c".
  > EOF
  $ coqmod LoadPhysical.v --format=sexp
  (Document
   (Physical
    (Loc (Pos (Ln 1) (Col 6)) (Pos (Ln 1) (Col 13)))
    a/b/c))
Extra Dependency
  $ cat > ExtraDependency.v << EOF
  > From A Extra Dependency "b/c/d".
  > EOF
  $ coqmod ExtraDependency.v --format=sexp
  (Document
   (ExtraDep
    (Loc (Pos (Ln 1) (Col 1)) (Pos (Ln 1) (Col 32)))
    (Prefix
     (Loc (Pos (Ln 1) (Col 6)) (Pos (Ln 1) (Col 7)))
     A)
    b/c/d))

End specification

Various mixed dep commands
  $ coqmod TestAll.v --debug
  (8:Document(4:From(3:Loc(3:Pos(2:Ln1:1)(3:Col1:1))(3:Pos(2:Ln1:1)(3:Col2:40)))(6:Prefix(3:Loc(3:Pos(2:Ln1:1)(3:Col1:6))(3:Pos(2:Ln1:1)(3:Col2:11)))5:A.B.C)(6:Module(3:Loc(3:Pos(2:Ln1:1)(3:Col2:27))(3:Pos(2:Ln1:1)(3:Col2:30)))3:R.X)(6:Module(3:Loc(3:Pos(2:Ln1:1)(3:Col2:31))(3:Pos(2:Ln1:1)(3:Col2:36)))5:L.Y.G)(6:Module(3:Loc(3:Pos(2:Ln1:1)(3:Col2:37))(3:Pos(2:Ln1:1)(3:Col2:40)))3:Z.W))(4:From(3:Loc(3:Pos(2:Ln1:3)(3:Col1:1))(3:Pos(2:Ln2:13)(3:Col1:9)))(6:Prefix(3:Loc(3:Pos(2:Ln1:6)(3:Col1:5))(3:Pos(2:Ln1:6)(3:Col2:10)))5:A.B.C)(6:Module(3:Loc(3:Pos(2:Ln2:11)(3:Col2:13))(3:Pos(2:Ln2:11)(3:Col2:16)))3:R.X)(6:Module(3:Loc(3:Pos(2:Ln2:11)(3:Col2:17))(3:Pos(2:Ln2:11)(3:Col2:22)))5:L.Y.G)(6:Module(3:Loc(3:Pos(2:Ln2:13)(3:Col1:6))(3:Pos(2:Ln2:13)(3:Col1:9)))3:Z.W))(7:Logical(3:Loc(3:Pos(2:Ln2:23)(3:Col1:6))(3:Pos(2:Ln2:23)(3:Col1:7)))(6:Module(3:Loc(3:Pos(2:Ln2:23)(3:Col1:6))(3:Pos(2:Ln2:23)(3:Col1:7)))1:X))(8:Physical(3:Loc(3:Pos(2:Ln2:24)(3:Col1:6))(3:Pos(2:Ln2:24)(3:Col2:13)))5:A/b/c)(7:Require(3:Loc(3:Pos(2:Ln2:26)(3:Col1:6))(3:Pos(2:Ln2:26)(3:Col2:26)))(6:Module(3:Loc(3:Pos(2:Ln2:26)(3:Col2:21))(3:Pos(2:Ln2:26)(3:Col2:26)))5:timed))(7:Declare(3:Loc(3:Pos(2:Ln2:30)(3:Col1:1))(3:Pos(2:Ln2:31)(3:Col2:21)))(6:Module(3:Loc(3:Pos(2:Ln2:31)(3:Col1:9))(3:Pos(2:Ln2:31)(3:Col2:20)))11:foo.bar.baz))(7:Declare(3:Loc(3:Pos(2:Ln2:34)(3:Col1:1))(3:Pos(2:Ln2:43)(3:Col1:8)))(6:Module(3:Loc(3:Pos(2:Ln2:39)(3:Col1:2))(3:Pos(2:Ln2:39)(3:Col1:5)))3:foo)(6:Module(3:Loc(3:Pos(2:Ln2:41)(3:Col1:8))(3:Pos(2:Ln2:41)(3:Col2:15)))7:bar.baz)(6:Module(3:Loc(3:Pos(2:Ln2:43)(3:Col1:4))(3:Pos(2:Ln2:43)(3:Col1:7)))3:tar))(7:Require(3:Loc(3:Pos(2:Ln2:46)(3:Col1:1))(3:Pos(2:Ln2:50)(3:Col1:1)))(6:Module(3:Loc(3:Pos(2:Ln2:46)(3:Col1:9))(3:Pos(2:Ln2:46)(3:Col2:10)))1:A)(6:Module(3:Loc(3:Pos(2:Ln2:46)(3:Col2:11))(3:Pos(2:Ln2:46)(3:Col2:12)))1:B)(6:Module(3:Loc(3:Pos(2:Ln2:48)(3:Col1:1))(3:Pos(2:Ln2:48)(3:Col1:2)))1:C))(7:Require(3:Loc(3:Pos(2:Ln2:52)(3:Col1:1))(3:Pos(2:Ln2:52)(3:Col2:24)))(6:Module(3:Loc(3:Pos(2:Ln2:52)(3:Col2:16))(3:Pos(2:Ln2:52)(3:Col2:18)))2:AI)(6:Module(3:Loc(3:Pos(2:Ln2:52)(3:Col2:19))(3:Pos(2:Ln2:52)(3:Col2:21)))2:BI)(6:Module(3:Loc(3:Pos(2:Ln2:52)(3:Col2:22))(3:Pos(2:Ln2:52)(3:Col2:24)))2:CI))(7:Declare(3:Loc(3:Pos(2:Ln2:54)(3:Col2:15))(3:Pos(2:Ln2:54)(3:Col2:36)))(6:Module(3:Loc(3:Pos(2:Ln2:54)(3:Col2:34))(3:Pos(2:Ln2:54)(3:Col2:35)))1:a))(7:Logical(3:Loc(3:Pos(2:Ln2:56)(3:Col2:22))(3:Pos(2:Ln2:56)(3:Col2:35)))(6:Module(3:Loc(3:Pos(2:Ln2:56)(3:Col2:22))(3:Pos(2:Ln2:56)(3:Col2:35)))13:here.or.there))(8:ExtraDep(3:Loc(3:Pos(2:Ln2:58)(3:Col1:1))(3:Pos(2:Ln2:58)(3:Col2:37)))(6:Prefix(3:Loc(3:Pos(2:Ln2:58)(3:Col1:6))(3:Pos(2:Ln2:58)(3:Col1:9)))3:foo)8:bar/file)(8:ExtraDep(3:Loc(3:Pos(2:Ln2:59)(3:Col2:10))(3:Pos(2:Ln2:59)(3:Col2:46)))(6:Prefix(3:Loc(3:Pos(2:Ln2:59)(3:Col2:15))(3:Pos(2:Ln2:59)(3:Col2:18)))3:foz)8:baz/file)(7:Require(3:Loc(3:Pos(2:Ln2:63)(3:Col1:1))(3:Pos(2:Ln2:63)(3:Col2:40)))(6:Module(3:Loc(3:Pos(2:Ln2:63)(3:Col2:29))(3:Pos(2:Ln2:63)(3:Col2:32)))3:baz))(7:Require(3:Loc(3:Pos(2:Ln2:64)(3:Col1:1))(3:Pos(2:Ln2:64)(3:Col2:41)))(6:Module(3:Loc(3:Pos(2:Ln2:64)(3:Col2:30))(3:Pos(2:Ln2:64)(3:Col2:33)))3:baz))(7:Require(3:Loc(3:Pos(2:Ln2:65)(3:Col1:1))(3:Pos(2:Ln2:65)(3:Col2:31)))(6:Module(3:Loc(3:Pos(2:Ln2:65)(3:Col2:28))(3:Pos(2:Ln2:65)(3:Col2:31)))3:baz))(7:Require(3:Loc(3:Pos(2:Ln2:66)(3:Col1:1))(3:Pos(2:Ln2:66)(3:Col2:44)))(6:Module(3:Loc(3:Pos(2:Ln2:66)(3:Col2:33))(3:Pos(2:Ln2:66)(3:Col2:36)))3:baz))(7:Require(3:Loc(3:Pos(2:Ln2:67)(3:Col1:1))(3:Pos(2:Ln2:67)(3:Col2:35)))(6:Module(3:Loc(3:Pos(2:Ln2:67)(3:Col2:32))(3:Pos(2:Ln2:67)(3:Col2:35)))3:baz))(7:Require(3:Loc(3:Pos(2:Ln2:68)(3:Col1:1))(3:Pos(2:Ln2:68)(3:Col2:40)))(6:Module(3:Loc(3:Pos(2:Ln2:68)(3:Col2:29))(3:Pos(2:Ln2:68)(3:Col2:32)))3:baz))(7:Require(3:Loc(3:Pos(2:Ln2:69)(3:Col1:1))(3:Pos(2:Ln2:69)(3:Col2:31)))(6:Module(3:Loc(3:Pos(2:Ln2:69)(3:Col2:28))(3:Pos(2:Ln2:69)(3:Col2:31)))3:baz))(7:Require(3:Loc(3:Pos(2:Ln2:70)(3:Col1:1))(3:Pos(2:Ln2:70)(3:Col2:44)))(6:Module(3:Loc(3:Pos(2:Ln2:70)(3:Col2:33))(3:Pos(2:Ln2:70)(3:Col2:36)))3:baz))(7:Require(3:Loc(3:Pos(2:Ln2:71)(3:Col1:1))(3:Pos(2:Ln2:71)(3:Col2:35)))(6:Module(3:Loc(3:Pos(2:Ln2:71)(3:Col2:32))(3:Pos(2:Ln2:71)(3:Col2:35)))3:baz))(7:Require(3:Loc(3:Pos(2:Ln2:74)(3:Col1:1))(3:Pos(2:Ln2:74)(3:Col2:30)))(6:Module(3:Loc(3:Pos(2:Ln2:74)(3:Col2:16))(3:Pos(2:Ln2:74)(3:Col2:19)))3:baz))(7:Require(3:Loc(3:Pos(2:Ln2:81)(3:Col1:1))(3:Pos(2:Ln2:81)(3:Col2:34)))(6:Module(3:Loc(3:Pos(2:Ln2:81)(3:Col2:16))(3:Pos(2:Ln2:81)(3:Col2:34)))18:Category.Notations))(7:Require(3:Loc(3:Pos(2:Ln2:84)(3:Col1:1))(3:Pos(2:Ln2:84)(3:Col2:22)))(6:Module(3:Loc(3:Pos(2:Ln2:84)(3:Col1:9))(3:Pos(2:Ln2:84)(3:Col2:22)))13:Category.Core))(7:Require(3:Loc(3:Pos(2:Ln2:86)(3:Col1:1))(3:Pos(2:Ln2:86)(3:Col2:22)))(6:Module(3:Loc(3:Pos(2:Ln2:86)(3:Col1:9))(3:Pos(2:Ln2:86)(3:Col2:22)))13:Category.Dual))(7:Require(3:Loc(3:Pos(2:Ln2:88)(3:Col1:1))(3:Pos(2:Ln2:88)(3:Col2:27)))(6:Module(3:Loc(3:Pos(2:Ln2:88)(3:Col1:9))(3:Pos(2:Ln2:88)(3:Col2:27)))18:Category.Morphisms))(7:Require(3:Loc(3:Pos(2:Ln2:90)(3:Col1:1))(3:Pos(2:Ln2:90)(3:Col2:23)))(6:Module(3:Loc(3:Pos(2:Ln2:90)(3:Col1:9))(3:Pos(2:Ln2:90)(3:Col2:23)))14:Category.Paths))(7:Require(3:Loc(3:Pos(2:Ln2:92)(3:Col1:1))(3:Pos(2:Ln2:92)(3:Col2:25)))(6:Module(3:Loc(3:Pos(2:Ln2:92)(3:Col1:9))(3:Pos(2:Ln2:92)(3:Col2:25)))16:Category.Objects))(7:Require(3:Loc(3:Pos(2:Ln2:94)(3:Col1:1))(3:Pos(2:Ln2:94)(3:Col2:22)))(6:Module(3:Loc(3:Pos(2:Ln2:94)(3:Col1:9))(3:Pos(2:Ln2:94)(3:Col2:22)))13:Category.Prod))(7:Require(3:Loc(3:Pos(2:Ln2:96)(3:Col1:1))(3:Pos(2:Ln2:96)(3:Col2:20)))(6:Module(3:Loc(3:Pos(2:Ln2:96)(3:Col1:9))(3:Pos(2:Ln2:96)(3:Col2:20)))11:Category.Pi))(7:Require(3:Loc(3:Pos(2:Ln2:98)(3:Col1:1))(3:Pos(2:Ln2:98)(3:Col2:23)))(6:Module(3:Loc(3:Pos(2:Ln2:98)(3:Col1:9))(3:Pos(2:Ln2:98)(3:Col2:23)))14:Category.Sigma))(7:Require(3:Loc(3:Pos(2:Ln3:100)(3:Col1:1))(3:Pos(2:Ln3:100)(3:Col2:24)))(6:Module(3:Loc(3:Pos(2:Ln3:100)(3:Col1:9))(3:Pos(2:Ln3:100)(3:Col2:24)))15:Category.Strict))(7:Require(3:Loc(3:Pos(2:Ln3:102)(3:Col1:1))(3:Pos(2:Ln3:102)(3:Col2:21)))(6:Module(3:Loc(3:Pos(2:Ln3:102)(3:Col1:9))(3:Pos(2:Ln3:102)(3:Col2:21)))12:Category.Sum))(7:Require(3:Loc(3:Pos(2:Ln3:104)(3:Col1:1))(3:Pos(2:Ln3:104)(3:Col2:27)))(6:Module(3:Loc(3:Pos(2:Ln3:104)(3:Col1:9))(3:Pos(2:Ln3:104)(3:Col2:27)))18:Category.Univalent))(7:Require(3:Loc(3:Pos(2:Ln3:123)(3:Col1:1))(3:Pos(2:Ln3:123)(3:Col2:29)))(6:Module(3:Loc(3:Pos(2:Ln3:123)(3:Col1:9))(3:Pos(2:Ln3:123)(3:Col2:29)))20:Category.Subcategory))(7:Require(3:Loc(3:Pos(2:Ln3:136)(3:Col1:1))(3:Pos(2:Ln3:136)(3:Col2:25)))(6:Module(3:Loc(3:Pos(2:Ln3:136)(3:Col2:16))(3:Pos(2:Ln3:136)(3:Col2:25)))9:Notations))(7:Require(3:Loc(3:Pos(2:Ln3:137)(3:Col1:1))(3:Pos(2:Ln3:137)(3:Col2:21)))(6:Module(3:Loc(3:Pos(2:Ln3:137)(3:Col2:16))(3:Pos(2:Ln3:137)(3:Col2:21)))5:Logic))(7:Require(3:Loc(3:Pos(2:Ln3:138)(3:Col1:1))(3:Pos(2:Ln3:138)(3:Col2:25)))(6:Module(3:Loc(3:Pos(2:Ln3:138)(3:Col2:16))(3:Pos(2:Ln3:138)(3:Col2:25)))9:Datatypes))(7:Require(3:Loc(3:Pos(2:Ln3:139)(3:Col1:1))(3:Pos(2:Ln3:139)(3:Col2:22)))(6:Module(3:Loc(3:Pos(2:Ln3:139)(3:Col2:16))(3:Pos(2:Ln3:139)(3:Col2:22)))6:Specif))(7:Require(3:Loc(3:Pos(2:Ln3:140)(3:Col1:1))(3:Pos(2:Ln3:140)(3:Col2:22)))(6:Module(3:Loc(3:Pos(2:Ln3:140)(3:Col1:9))(3:Pos(2:Ln3:140)(3:Col2:22)))13:Coq.Init.Byte))(7:Require(3:Loc(3:Pos(2:Ln3:141)(3:Col1:1))(3:Pos(2:Ln3:141)(3:Col2:25)))(6:Module(3:Loc(3:Pos(2:Ln3:141)(3:Col1:9))(3:Pos(2:Ln3:141)(3:Col2:25)))16:Coq.Init.Decimal))(7:Require(3:Loc(3:Pos(2:Ln3:142)(3:Col1:1))(3:Pos(2:Ln3:142)(3:Col2:29)))(6:Module(3:Loc(3:Pos(2:Ln3:142)(3:Col1:9))(3:Pos(2:Ln3:142)(3:Col2:29)))20:Coq.Init.Hexadecimal))(7:Require(3:Loc(3:Pos(2:Ln3:143)(3:Col1:1))(3:Pos(2:Ln3:143)(3:Col2:24)))(6:Module(3:Loc(3:Pos(2:Ln3:143)(3:Col1:9))(3:Pos(2:Ln3:143)(3:Col2:24)))15:Coq.Init.Number))(7:Require(3:Loc(3:Pos(2:Ln3:144)(3:Col1:1))(3:Pos(2:Ln3:144)(3:Col2:21)))(6:Module(3:Loc(3:Pos(2:Ln3:144)(3:Col1:9))(3:Pos(2:Ln3:144)(3:Col2:21)))12:Coq.Init.Nat))(7:Require(3:Loc(3:Pos(2:Ln3:145)(3:Col1:1))(3:Pos(2:Ln3:145)(3:Col2:21)))(6:Module(3:Loc(3:Pos(2:Ln3:145)(3:Col2:16))(3:Pos(2:Ln3:145)(3:Col2:21)))5:Peano))(7:Require(3:Loc(3:Pos(2:Ln3:146)(3:Col1:1))(3:Pos(2:Ln3:146)(3:Col2:27)))(6:Module(3:Loc(3:Pos(2:Ln3:146)(3:Col2:16))(3:Pos(2:Ln3:146)(3:Col2:27)))11:Coq.Init.Wf))(7:Require(3:Loc(3:Pos(2:Ln3:147)(3:Col1:1))(3:Pos(2:Ln3:147)(3:Col2:29)))(6:Module(3:Loc(3:Pos(2:Ln3:147)(3:Col2:16))(3:Pos(2:Ln3:147)(3:Col2:29)))13:Coq.Init.Ltac))(7:Require(3:Loc(3:Pos(2:Ln3:148)(3:Col1:1))(3:Pos(2:Ln3:148)(3:Col2:32)))(6:Module(3:Loc(3:Pos(2:Ln3:148)(3:Col2:16))(3:Pos(2:Ln3:148)(3:Col2:32)))16:Coq.Init.Tactics))(7:Require(3:Loc(3:Pos(2:Ln3:149)(3:Col1:1))(3:Pos(2:Ln3:149)(3:Col2:30)))(6:Module(3:Loc(3:Pos(2:Ln3:149)(3:Col2:16))(3:Pos(2:Ln3:149)(3:Col2:30)))14:Coq.Init.Tauto))(7:Declare(3:Loc(3:Pos(2:Ln3:154)(3:Col1:1))(3:Pos(2:Ln3:154)(3:Col2:30)))(6:Module(3:Loc(3:Pos(2:Ln3:154)(3:Col2:20))(3:Pos(2:Ln3:154)(3:Col2:29)))9:cc_plugin))(7:Declare(3:Loc(3:Pos(2:Ln3:155)(3:Col1:1))(3:Pos(2:Ln3:155)(3:Col2:38)))(6:Module(3:Loc(3:Pos(2:Ln3:155)(3:Col2:20))(3:Pos(2:Ln3:155)(3:Col2:37)))17:firstorder_plugin)))
  $ coqmod TestAll.v --format=read
  Begin Document
  Ln 1, Col 1-40 From A.B.C Require R.X L.Y.G Z.W
  Ln 3-13, Col 1-9 From A.B.C Require R.X L.Y.G Z.W
  Ln 23, Col 6-7 Logical X
  Ln 24, Col 6-13 Physical "A/b/c"
  Ln 26, Col 6-26 Require timed
  Ln 31, Col 9-20 Declare ML Module foo.bar.baz
  Ln 39, Col 2-5 Declare ML Module foo
  Ln 41, Col 8-15 Declare ML Module bar.baz
  Ln 43, Col 4-7 Declare ML Module tar
  Ln 46-50, Col 1 Require A B C
  Ln 52, Col 1-24 Require AI BI CI
  Ln 54, Col 34-35 Declare ML Module a
  Ln 56, Col 22-35 Logical here.or.there
  Ln 58, Col 1-37 From foo Extra Dependency "bar/file"
  Ln 59, Col 10-46 From foz Extra Dependency "baz/file"
  Ln 63, Col 1-40 Require baz
  Ln 64, Col 1-41 Require baz
  Ln 65, Col 1-31 Require baz
  Ln 66, Col 1-44 Require baz
  Ln 67, Col 1-35 Require baz
  Ln 68, Col 1-40 Require baz
  Ln 69, Col 1-31 Require baz
  Ln 70, Col 1-44 Require baz
  Ln 71, Col 1-35 Require baz
  Ln 74, Col 1-30 Require baz
  Ln 81, Col 1-34 Require Category.Notations
  Ln 84, Col 1-22 Require Category.Core
  Ln 86, Col 1-22 Require Category.Dual
  Ln 88, Col 1-27 Require Category.Morphisms
  Ln 90, Col 1-23 Require Category.Paths
  Ln 92, Col 1-25 Require Category.Objects
  Ln 94, Col 1-22 Require Category.Prod
  Ln 96, Col 1-20 Require Category.Pi
  Ln 98, Col 1-23 Require Category.Sigma
  Ln 100, Col 1-24 Require Category.Strict
  Ln 102, Col 1-21 Require Category.Sum
  Ln 104, Col 1-27 Require Category.Univalent
  Ln 123, Col 1-29 Require Category.Subcategory
  Ln 136, Col 1-25 Require Notations
  Ln 137, Col 1-21 Require Logic
  Ln 138, Col 1-25 Require Datatypes
  Ln 139, Col 1-22 Require Specif
  Ln 140, Col 1-22 Require Coq.Init.Byte
  Ln 141, Col 1-25 Require Coq.Init.Decimal
  Ln 142, Col 1-29 Require Coq.Init.Hexadecimal
  Ln 143, Col 1-24 Require Coq.Init.Number
  Ln 144, Col 1-21 Require Coq.Init.Nat
  Ln 145, Col 1-21 Require Peano
  Ln 146, Col 1-27 Require Coq.Init.Wf
  Ln 147, Col 1-29 Require Coq.Init.Ltac
  Ln 148, Col 1-32 Require Coq.Init.Tactics
  Ln 149, Col 1-30 Require Coq.Init.Tauto
  Ln 154, Col 20-29 Declare ML Module cc_plugin
  Ln 155, Col 20-37 Declare ML Module firstorder_plugin
  End Document
  $ coqmod TestAll.v --format=sexp
  (Document
   (From
    (Loc (Pos (Ln 1) (Col 1)) (Pos (Ln 1) (Col 40)))
    (Prefix
     (Loc (Pos (Ln 1) (Col 6)) (Pos (Ln 1) (Col 11)))
     A.B.C)
    (Module
     (Loc (Pos (Ln 1) (Col 27)) (Pos (Ln 1) (Col 30)))
     R.X)
    (Module
     (Loc (Pos (Ln 1) (Col 31)) (Pos (Ln 1) (Col 36)))
     L.Y.G)
    (Module
     (Loc (Pos (Ln 1) (Col 37)) (Pos (Ln 1) (Col 40)))
     Z.W))
   (From
    (Loc (Pos (Ln 3) (Col 1)) (Pos (Ln 13) (Col 9)))
    (Prefix
     (Loc (Pos (Ln 6) (Col 5)) (Pos (Ln 6) (Col 10)))
     A.B.C)
    (Module
     (Loc (Pos (Ln 11) (Col 13)) (Pos (Ln 11) (Col 16)))
     R.X)
    (Module
     (Loc (Pos (Ln 11) (Col 17)) (Pos (Ln 11) (Col 22)))
     L.Y.G)
    (Module
     (Loc (Pos (Ln 13) (Col 6)) (Pos (Ln 13) (Col 9)))
     Z.W))
   (Logical
    (Loc (Pos (Ln 23) (Col 6)) (Pos (Ln 23) (Col 7)))
    (Module
     (Loc (Pos (Ln 23) (Col 6)) (Pos (Ln 23) (Col 7)))
     X))
   (Physical
    (Loc (Pos (Ln 24) (Col 6)) (Pos (Ln 24) (Col 13)))
    A/b/c)
   (Require
    (Loc (Pos (Ln 26) (Col 6)) (Pos (Ln 26) (Col 26)))
    (Module
     (Loc (Pos (Ln 26) (Col 21)) (Pos (Ln 26) (Col 26)))
     timed))
   (Declare
    (Loc (Pos (Ln 30) (Col 1)) (Pos (Ln 31) (Col 21)))
    (Module
     (Loc (Pos (Ln 31) (Col 9)) (Pos (Ln 31) (Col 20)))
     foo.bar.baz))
   (Declare
    (Loc (Pos (Ln 34) (Col 1)) (Pos (Ln 43) (Col 8)))
    (Module
     (Loc (Pos (Ln 39) (Col 2)) (Pos (Ln 39) (Col 5)))
     foo)
    (Module
     (Loc (Pos (Ln 41) (Col 8)) (Pos (Ln 41) (Col 15)))
     bar.baz)
    (Module
     (Loc (Pos (Ln 43) (Col 4)) (Pos (Ln 43) (Col 7)))
     tar))
   (Require
    (Loc (Pos (Ln 46) (Col 1)) (Pos (Ln 50) (Col 1)))
    (Module
     (Loc (Pos (Ln 46) (Col 9)) (Pos (Ln 46) (Col 10)))
     A)
    (Module
     (Loc (Pos (Ln 46) (Col 11)) (Pos (Ln 46) (Col 12)))
     B)
    (Module
     (Loc (Pos (Ln 48) (Col 1)) (Pos (Ln 48) (Col 2)))
     C))
   (Require
    (Loc (Pos (Ln 52) (Col 1)) (Pos (Ln 52) (Col 24)))
    (Module
     (Loc (Pos (Ln 52) (Col 16)) (Pos (Ln 52) (Col 18)))
     AI)
    (Module
     (Loc (Pos (Ln 52) (Col 19)) (Pos (Ln 52) (Col 21)))
     BI)
    (Module
     (Loc (Pos (Ln 52) (Col 22)) (Pos (Ln 52) (Col 24)))
     CI))
   (Declare
    (Loc (Pos (Ln 54) (Col 15)) (Pos (Ln 54) (Col 36)))
    (Module
     (Loc (Pos (Ln 54) (Col 34)) (Pos (Ln 54) (Col 35)))
     a))
   (Logical
    (Loc (Pos (Ln 56) (Col 22)) (Pos (Ln 56) (Col 35)))
    (Module
     (Loc (Pos (Ln 56) (Col 22)) (Pos (Ln 56) (Col 35)))
     here.or.there))
   (ExtraDep
    (Loc (Pos (Ln 58) (Col 1)) (Pos (Ln 58) (Col 37)))
    (Prefix
     (Loc (Pos (Ln 58) (Col 6)) (Pos (Ln 58) (Col 9)))
     foo)
    bar/file)
   (ExtraDep
    (Loc (Pos (Ln 59) (Col 10)) (Pos (Ln 59) (Col 46)))
    (Prefix
     (Loc (Pos (Ln 59) (Col 15)) (Pos (Ln 59) (Col 18)))
     foz)
    baz/file)
   (Require
    (Loc (Pos (Ln 63) (Col 1)) (Pos (Ln 63) (Col 40)))
    (Module
     (Loc (Pos (Ln 63) (Col 29)) (Pos (Ln 63) (Col 32)))
     baz))
   (Require
    (Loc (Pos (Ln 64) (Col 1)) (Pos (Ln 64) (Col 41)))
    (Module
     (Loc (Pos (Ln 64) (Col 30)) (Pos (Ln 64) (Col 33)))
     baz))
   (Require
    (Loc (Pos (Ln 65) (Col 1)) (Pos (Ln 65) (Col 31)))
    (Module
     (Loc (Pos (Ln 65) (Col 28)) (Pos (Ln 65) (Col 31)))
     baz))
   (Require
    (Loc (Pos (Ln 66) (Col 1)) (Pos (Ln 66) (Col 44)))
    (Module
     (Loc (Pos (Ln 66) (Col 33)) (Pos (Ln 66) (Col 36)))
     baz))
   (Require
    (Loc (Pos (Ln 67) (Col 1)) (Pos (Ln 67) (Col 35)))
    (Module
     (Loc (Pos (Ln 67) (Col 32)) (Pos (Ln 67) (Col 35)))
     baz))
   (Require
    (Loc (Pos (Ln 68) (Col 1)) (Pos (Ln 68) (Col 40)))
    (Module
     (Loc (Pos (Ln 68) (Col 29)) (Pos (Ln 68) (Col 32)))
     baz))
   (Require
    (Loc (Pos (Ln 69) (Col 1)) (Pos (Ln 69) (Col 31)))
    (Module
     (Loc (Pos (Ln 69) (Col 28)) (Pos (Ln 69) (Col 31)))
     baz))
   (Require
    (Loc (Pos (Ln 70) (Col 1)) (Pos (Ln 70) (Col 44)))
    (Module
     (Loc (Pos (Ln 70) (Col 33)) (Pos (Ln 70) (Col 36)))
     baz))
   (Require
    (Loc (Pos (Ln 71) (Col 1)) (Pos (Ln 71) (Col 35)))
    (Module
     (Loc (Pos (Ln 71) (Col 32)) (Pos (Ln 71) (Col 35)))
     baz))
   (Require
    (Loc (Pos (Ln 74) (Col 1)) (Pos (Ln 74) (Col 30)))
    (Module
     (Loc (Pos (Ln 74) (Col 16)) (Pos (Ln 74) (Col 19)))
     baz))
   (Require
    (Loc (Pos (Ln 81) (Col 1)) (Pos (Ln 81) (Col 34)))
    (Module
     (Loc (Pos (Ln 81) (Col 16)) (Pos (Ln 81) (Col 34)))
     Category.Notations))
   (Require
    (Loc (Pos (Ln 84) (Col 1)) (Pos (Ln 84) (Col 22)))
    (Module
     (Loc (Pos (Ln 84) (Col 9)) (Pos (Ln 84) (Col 22)))
     Category.Core))
   (Require
    (Loc (Pos (Ln 86) (Col 1)) (Pos (Ln 86) (Col 22)))
    (Module
     (Loc (Pos (Ln 86) (Col 9)) (Pos (Ln 86) (Col 22)))
     Category.Dual))
   (Require
    (Loc (Pos (Ln 88) (Col 1)) (Pos (Ln 88) (Col 27)))
    (Module
     (Loc (Pos (Ln 88) (Col 9)) (Pos (Ln 88) (Col 27)))
     Category.Morphisms))
   (Require
    (Loc (Pos (Ln 90) (Col 1)) (Pos (Ln 90) (Col 23)))
    (Module
     (Loc (Pos (Ln 90) (Col 9)) (Pos (Ln 90) (Col 23)))
     Category.Paths))
   (Require
    (Loc (Pos (Ln 92) (Col 1)) (Pos (Ln 92) (Col 25)))
    (Module
     (Loc (Pos (Ln 92) (Col 9)) (Pos (Ln 92) (Col 25)))
     Category.Objects))
   (Require
    (Loc (Pos (Ln 94) (Col 1)) (Pos (Ln 94) (Col 22)))
    (Module
     (Loc (Pos (Ln 94) (Col 9)) (Pos (Ln 94) (Col 22)))
     Category.Prod))
   (Require
    (Loc (Pos (Ln 96) (Col 1)) (Pos (Ln 96) (Col 20)))
    (Module
     (Loc (Pos (Ln 96) (Col 9)) (Pos (Ln 96) (Col 20)))
     Category.Pi))
   (Require
    (Loc (Pos (Ln 98) (Col 1)) (Pos (Ln 98) (Col 23)))
    (Module
     (Loc (Pos (Ln 98) (Col 9)) (Pos (Ln 98) (Col 23)))
     Category.Sigma))
   (Require
    (Loc (Pos (Ln 100) (Col 1)) (Pos (Ln 100) (Col 24)))
    (Module
     (Loc (Pos (Ln 100) (Col 9)) (Pos (Ln 100) (Col 24)))
     Category.Strict))
   (Require
    (Loc (Pos (Ln 102) (Col 1)) (Pos (Ln 102) (Col 21)))
    (Module
     (Loc (Pos (Ln 102) (Col 9)) (Pos (Ln 102) (Col 21)))
     Category.Sum))
   (Require
    (Loc (Pos (Ln 104) (Col 1)) (Pos (Ln 104) (Col 27)))
    (Module
     (Loc (Pos (Ln 104) (Col 9)) (Pos (Ln 104) (Col 27)))
     Category.Univalent))
   (Require
    (Loc (Pos (Ln 123) (Col 1)) (Pos (Ln 123) (Col 29)))
    (Module
     (Loc (Pos (Ln 123) (Col 9)) (Pos (Ln 123) (Col 29)))
     Category.Subcategory))
   (Require
    (Loc (Pos (Ln 136) (Col 1)) (Pos (Ln 136) (Col 25)))
    (Module
     (Loc (Pos (Ln 136) (Col 16)) (Pos (Ln 136) (Col 25)))
     Notations))
   (Require
    (Loc (Pos (Ln 137) (Col 1)) (Pos (Ln 137) (Col 21)))
    (Module
     (Loc (Pos (Ln 137) (Col 16)) (Pos (Ln 137) (Col 21)))
     Logic))
   (Require
    (Loc (Pos (Ln 138) (Col 1)) (Pos (Ln 138) (Col 25)))
    (Module
     (Loc (Pos (Ln 138) (Col 16)) (Pos (Ln 138) (Col 25)))
     Datatypes))
   (Require
    (Loc (Pos (Ln 139) (Col 1)) (Pos (Ln 139) (Col 22)))
    (Module
     (Loc (Pos (Ln 139) (Col 16)) (Pos (Ln 139) (Col 22)))
     Specif))
   (Require
    (Loc (Pos (Ln 140) (Col 1)) (Pos (Ln 140) (Col 22)))
    (Module
     (Loc (Pos (Ln 140) (Col 9)) (Pos (Ln 140) (Col 22)))
     Coq.Init.Byte))
   (Require
    (Loc (Pos (Ln 141) (Col 1)) (Pos (Ln 141) (Col 25)))
    (Module
     (Loc (Pos (Ln 141) (Col 9)) (Pos (Ln 141) (Col 25)))
     Coq.Init.Decimal))
   (Require
    (Loc (Pos (Ln 142) (Col 1)) (Pos (Ln 142) (Col 29)))
    (Module
     (Loc (Pos (Ln 142) (Col 9)) (Pos (Ln 142) (Col 29)))
     Coq.Init.Hexadecimal))
   (Require
    (Loc (Pos (Ln 143) (Col 1)) (Pos (Ln 143) (Col 24)))
    (Module
     (Loc (Pos (Ln 143) (Col 9)) (Pos (Ln 143) (Col 24)))
     Coq.Init.Number))
   (Require
    (Loc (Pos (Ln 144) (Col 1)) (Pos (Ln 144) (Col 21)))
    (Module
     (Loc (Pos (Ln 144) (Col 9)) (Pos (Ln 144) (Col 21)))
     Coq.Init.Nat))
   (Require
    (Loc (Pos (Ln 145) (Col 1)) (Pos (Ln 145) (Col 21)))
    (Module
     (Loc (Pos (Ln 145) (Col 16)) (Pos (Ln 145) (Col 21)))
     Peano))
   (Require
    (Loc (Pos (Ln 146) (Col 1)) (Pos (Ln 146) (Col 27)))
    (Module
     (Loc (Pos (Ln 146) (Col 16)) (Pos (Ln 146) (Col 27)))
     Coq.Init.Wf))
   (Require
    (Loc (Pos (Ln 147) (Col 1)) (Pos (Ln 147) (Col 29)))
    (Module
     (Loc (Pos (Ln 147) (Col 16)) (Pos (Ln 147) (Col 29)))
     Coq.Init.Ltac))
   (Require
    (Loc (Pos (Ln 148) (Col 1)) (Pos (Ln 148) (Col 32)))
    (Module
     (Loc (Pos (Ln 148) (Col 16)) (Pos (Ln 148) (Col 32)))
     Coq.Init.Tactics))
   (Require
    (Loc (Pos (Ln 149) (Col 1)) (Pos (Ln 149) (Col 30)))
    (Module
     (Loc (Pos (Ln 149) (Col 16)) (Pos (Ln 149) (Col 30)))
     Coq.Init.Tauto))
   (Declare
    (Loc (Pos (Ln 154) (Col 1)) (Pos (Ln 154) (Col 30)))
    (Module
     (Loc (Pos (Ln 154) (Col 20)) (Pos (Ln 154) (Col 29)))
     cc_plugin))
   (Declare
    (Loc (Pos (Ln 155) (Col 1)) (Pos (Ln 155) (Col 38)))
    (Module
     (Loc (Pos (Ln 155) (Col 20)) (Pos (Ln 155) (Col 37)))
     firstorder_plugin)))
