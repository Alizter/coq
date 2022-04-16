#!/usr/bin/env bash

set -e

export PATH=$BIN:$PATH
export OCAMLRUNPARAM=s=1

${coqc#"$BIN"} aux11170.v
