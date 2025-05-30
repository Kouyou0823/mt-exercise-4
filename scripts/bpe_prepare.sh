#!/usr/bin/env bash
# bpe_prepare_final.sh  it en 100000 2000
set -euo pipefail

SRC=${1:-it}
TRG=${2:-en}
N=${3:-100000}
K=${4:-2000}

D=data               

[[ -f $D/train.${SRC}-${TRG}.${SRC} && -f $D/train.${SRC}-${TRG}.${TRG} ]] \
  || { echo "original file unexit"; exit 1; }

head -n $N  $D/train.${SRC}-${TRG}.${SRC} > $D/train${N}.${SRC}
head -n $N  $D/train.${SRC}-${TRG}.${TRG} > $D/train${N}.${TRG}

cat $D/train${N}.${SRC} $D/train${N}.${TRG} > $D/train${N}.joint
subword-nmt learn-bpe -s $K --total-symbols < $D/train${N}.joint > $D/codes.bpe

for L in $SRC $TRG; do
  subword-nmt apply-bpe -c $D/codes.bpe < $D/train${N}.${L} > $D/train${N}.bpe.${L}
done

cat $D/train${N}.bpe.${SRC} $D/train${N}.bpe.${TRG} \
  | subword-nmt get-vocab | cut -f1 > $D/vocab.bpe.txt
