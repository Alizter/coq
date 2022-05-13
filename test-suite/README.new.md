# Coq Test Suite

The test suite can be run from the Coq root directory by
`make -f Makefile.dune test`. This does two things:
  1. Run `dune build @test-gen` to generate the rules for the test-suite.
  2. Run `dune test` to build all the testing targets.

The test-suite is incremental meaning that you do not have to build the rest of
the repository in order to run it. You may also run it after hacking on some
files and dune will rebuild only what is necessery.

## Quality of life suggestions

Here are a few quality of life suggestions:
  + We suggest passing `--display=short` to dune (or `DUNEOPT="--display=short"`
    for make). This will display every target that dune is building at a give
    time.
  + The option `--always-show-command-line` is also very useful since dune will
    dump a subshell command that you can run to reproduce the failing test. (You might need to add a `$` before running it in your terminal.


## Adding a test
TODO

## Fixing output tests
TODO

## Rule generation
TODO

## Cram tests
TODO
