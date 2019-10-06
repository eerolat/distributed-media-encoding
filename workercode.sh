#!/bin/sh

chmod a+x ./ffmpeg

# use ffmpeg in the current working directory to encode inputcontent
# (in mpg format) to output.avi

#a=$1
#b="ftp://NNN.NNN.NNN.NNN/$a"
#file="$b.tmp"
#echo "$file"

#wget --user=USERNAME --password=PASSWORD "$file"

HOST='NNN.NNN.NNN.NNN'
USER='USERNAME'
PASSWD='PASSWORD'
FILE="$1.tmp"
QUALITYFILE="quality.ini"

ftp -n $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
bin
get "$FILE"
ascii
get "$QUALITYFILE"
quit
END_SCRIPT

QUALITY=$(cat ./$QUALITYFILE)

ffmpeg -async 2 -qscale "$QUALITY" -i "$FILE" -vtag DIVX -f avi -vcodec mpeg4 -aspect 16:9 -s 640x352 -acodec libmp3lame -ab 96000 -ar 44100 -ac 2 output.avi


mv output.avi result_$1.avi

ftp -n $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
bin
put "result_$1.avi"
quit
END_SCRIPT
