#!/usr/bin/env bash

set -e

export PATH=$BIN:$PATH

${coqc#"$BIN"} aux7704.v
