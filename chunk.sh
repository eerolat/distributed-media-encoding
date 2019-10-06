# by Tuomas Eerola 2011
# www.iki.fi/eerola

#!/bin/bash

IN_FILE="$1"
OUT_DIR="$2"
CHUNK_LEN="$3"

OUT_FILE=$(printf "$OUT_DIR/tmp_")

split -a 1 -b $3 $1 "$OUT_FILE"

k=1
for i in $( ls $OUT_FILE* )
do
mv -f $i $OUT_DIR/$k.tmp
echo $k  > $OUT_DIR/num_chunks.txt
((k++))
done 


