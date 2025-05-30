#!/bin/bash

CONFIG="configs/bpe2k.yaml"
REF="data/test.it-en.en"
SRC="data/test.it-en.it"
OUT_DIR="beam_results"
mkdir -p $OUT_DIR

echo -e "beam\tbleu\ttime" > $OUT_DIR/beam_bleu_time.csv

for beam in {1..10}; do
    OUT="$OUT_DIR/hyp.beam$beam.txt"
    echo "⏳ Translating with beam size = $beam ..."

    start_time=$(python3 -c 'import time; print(time.time())')

    python -m joeynmt translate $CONFIG -c best -b $beam > $OUT

    end_time=$(python3 -c 'import time; print(time.time())')
    duration=$(python3 -c "print(round($end_time - $start_time, 3))")

    bleu=$(cat $OUT | sacrebleu $REF -lc | grep -oP 'BLEU = \K[0-9.]+')

    echo -e "$beam\t$bleu\t$duration"
    echo -e "$beam\t$bleu\t$duration" >> $OUT_DIR/beam_bleu_time.csv
done

