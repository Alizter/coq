Testing compatability with STM and color arguments when passed to coqtop.

With no async arguments, the color argument is working:

  $ coqtop -noinit -color on | sed -e '1d'
  
  Coq < 

With some async arguments, the color argument no longer works:

  $ coqtop -noinit -color on -async-proofs on | sed -e '1d'
  Don't know what to do with -color on
  See -help for the list of supported options
  Handshake with proof:0 failed: End_of_file
