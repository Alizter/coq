# coqmod

`coqmod` outputs Coq modules and OCaml libraries that a `.v` file depends on.

It is intended to be a minimalistic replacement to `coqdep` for use by `dune`.

Unlike `coqdep`, it does not scan directories making it lightweight in
comparison.

It has 3 `--format` modes:
- `csexp` - canonical serial expresion (default)
- `read` - human readable output
- `sexp` - pretty printed serial expression

When a single `.v` file is passed to `coqmod`, it will output the tokens
corresponding to dependencies in the specified format.

Here is the output for an `example.v` file:

```coq
  From A.B.C Require Import R.X L.Y.G Z.W.

  Load X.
  Load "A/b/c".

  Declare ML Module "foo.bar.baz".

  Require A B C.

  Require Import AI BI CI.
```

<details>

<summary><code>$ coqmod example.v</code></summary>


  ```lisp
    (8:Document(4:From(3:Loc(3:Pos(2:Ln1:1)(3:Col1:1))(3:Pos(2:Ln1:1)(3:Col2:40)))(6:Prefix(3:Loc(3:Pos(2:Ln1:1)(3:Col1:6))(3:Pos(2:Ln1:1)(3:Col2:11)))5:A.B.C)(6:Module(3:Loc(3:Pos(2:Ln1:1)(3:Col2:27))(3:Pos(2:Ln1:1)(3:Col2:30)))3:R.X)(6:Module(3:Loc(3:Pos(2:Ln1:1)(3:Col2:31))(3:Pos(2:Ln1:1)(3:Col2:36)))5:L.Y.G)(6:Module(3:Loc(3:Pos(2:Ln1:1)(3:Col2:37))(3:Pos(2:Ln1:1)(3:Col2:40)))3:Z.W))(7:Logical(3:Loc(3:Pos(2:Ln1:3)(3:Col1:6))(3:Pos(2:Ln1:3)(3:Col1:7)))(6:Module(3:Loc(3:Pos(2:Ln1:3)(3:Col1:6))(3:Pos(2:Ln1:3)(3:Col1:7)))1:X))(8:Physical(3:Loc(3:Pos(2:Ln1:4)(3:Col1:6))(3:Pos(2:Ln1:4)(3:Col2:13)))5:A/b/c)(7:Declare(3:Loc(3:Pos(2:Ln1:6)(3:Col1:1))(3:Pos(2:Ln1:6)(3:Col2:32)))(6:Module(3:Loc(3:Pos(2:Ln1:6)(3:Col2:20))(3:Pos(2:Ln1:6)(3:Col2:31)))11:foo.bar.baz))(7:Require(3:Loc(3:Pos(2:Ln1:8)(3:Col1:1))(3:Pos(2:Ln1:8)(3:Col2:14)))(6:Module(3:Loc(3:Pos(2:Ln1:8)(3:Col1:9))(3:Pos(2:Ln1:8)(3:Col2:10)))1:A)(6:Module(3:Loc(3:Pos(2:Ln1:8)(3:Col2:11))(3:Pos(2:Ln1:8)(3:Col2:12)))1:B)(6:Module(3:Loc(3:Pos(2:Ln1:8)(3:Col2:13))(3:Pos(2:Ln1:8)(3:Col2:14)))1:C))(7:Require(3:Loc(3:Pos(2:Ln2:10)(3:Col1:1))(3:Pos(2:Ln2:10)(3:Col2:24)))(6:Module(3:Loc(3:Pos(2:Ln2:10)(3:Col2:16))(3:Pos(2:Ln2:10)(3:Col2:18)))2:AI)(6:Module(3:Loc(3:Pos(2:Ln2:10)(3:Col2:19))(3:Pos(2:Ln2:10)(3:Col2:21)))2:BI)(6:Module(3:Loc(3:Pos(2:Ln2:10)(3:Col2:22))(3:Pos(2:Ln2:10)(3:Col2:24)))2:CI)))
  ```

</details>

<details>

<summary><code>$ coqmod example.v --format=read</code></summary>

```coq
  Begin Document
  Ln 1, Col 1-40 From A.B.C Require R.X L.Y.G Z.W
  Ln 3, Col 6-7 Logical X
  Ln 4, Col 6-13 Physical "A/b/c"
  Ln 6, Col 20-31 Declare ML Module foo.bar.baz
  Ln 8, Col 1-14 Require A B C
  Ln 10, Col 1-24 Require AI BI CI
  End Document
```

</details>

<details>

<summary><code>$ coqmod example.v --format=sexp</code></summary>

```lisp
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
```

</details>


## Testing

There is a cram test for `coqmod` in `tools/coqmod/test-coqmod.t/`.

To run it do:
```
dune build @test-coqmod
```

You can also use watch mode `-w` to get a continuous build and `--auto-promote`
to get the output of the cram test updated on each save.

## Specification

`coqmod` tokenizes Coq and OCaml module names and groups them in various
s-expressions detailed as follows. All parsed files are wrapped in the
`(Document ...)` s-exp. Here are the corresponding s-exp for Coq vernac commands
that add dependencies:

### Require
```lisp
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
```

### From
```lisp
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
```

### Declare
```lisp
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
```
### Load logical
```lisp
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
```

### Load physical
```lisp
  $ cat > LoadPhysical.v << EOF
  > Load "a/b/c".
  > EOF
  $ coqmod LoadPhysical.v --format=sexp
  (Document
   (Physical
    (Loc (Pos (Ln 1) (Col 6)) (Pos (Ln 1) (Col 13)))
    a/b/c))
```

### Extra Dependency
```lisp
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
```
