#!/bin/bash

# by Tuomas Eerola 2011# www.iki.fi/eerola
 
function usage {
        echo "Usage : chunk.sh input.file out-dir chunk-duration"
}
 
IN_FILE="$1"
OUT_DIR="$2"
typeset -i CHUNK_LEN
CHUNK_LEN="$3"
 
DURATION_HMS=$(/Library/Application\ Support/ffmpeg/ffmpeg -i "$IN_FILE" 2>&1 | grep Duration | cut -f 4 -d ' ')

DURATION_M=$(echo "$DURATION_HMS" | cut -d ':' -f 1 | sed 's/0*//')
DURATION_S=$(echo "$DURATION_HMS" | cut -d ':' -f 2 | sed 's/0*//')
DURATION=$[DURATION_M * 60 + DURATION_S + 1]

if [ "$DURATION" = '0' ] ; then
        echo "Invalid input video"
        usage
        exit 1
fi
 
if [ "$CHUNK_LEN" = "0" ] ; then
        echo "Invalid chunk size"
        usage
        exit 2
fi
 
if [ -z "$OUT_FILE_FORMAT" ] ; then
        FILE_EXT=$(echo "$IN_FILE"|awk -F . '{print $NF}')
        #FILE_EXT=$(echo "$IN_FILE" | sed 's/^.*\.\([a-zA-Z0-9]\+\)$/\1/')
        #OUT_FILE_FORMAT="%01d.${FILE_EXT}"
        OUT_FILE_FORMAT="${FILE_EXT}"

fi

N='0'
OFFSET='0'

FILESIZE=1

while [ $FILESIZE -gt 0 ] ; do
        let N=N+1
        OUT_FILE=$(printf "$OUT_DIR/$N.$OUT_FILE_FORMAT")
        /Library/Application\ Support/ffmpeg/ffmpeg -i "$IN_FILE" -vcodec copy -acodec copy -ss "$OFFSET" -t "$CHUNK_LEN" "$OUT_FILE"
        
	let FILESIZE=$(du -k "$OUT_FILE")

        let OFFSET=OFFSET+CHUNK_LEN
wait

echo $N  > $OUT_DIR/num_chunks.txt

done
