# Distributed encoding script by Tuomas Eerola 2011
# www.iki.fi/eerola
# Syntax ffmpegwrapper.sh <infile> <ffmpeg_quality> <len_of_chunks_in_sec>

#!/bin/sh

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FFMPEGDIR=""
QUALITY=$2


mkdir $SCRIPTDIR/temp

touch $SCRIPTDIR/temp/quality.ini
echo $QUALITY > $SCRIPTDIR/temp/quality.ini

# Line for file size-based splitting
CHUNK_LEN="$3m"

sh $SCRIPTDIR/chunk.sh $1 $SCRIPTDIR/temp $CHUNK_LEN

#HOST='localhost'
#USER='FTPUsername'
#PASSWD='FTPPassword'

#ftp -n $HOST <<END_SCRIPT
#quote USER $USER
#quote PASS $PASSWD
#lcd $SCRIPTDIR/temp
#prompt off
#bin
#mput *.tmp
#ascii
#mput *.ini
#lcd ..
#quit
#END_SCRIPT

mv  $SCRIPTDIR/temp/*.tmp ~/
mv  $SCRIPTDIR/temp/quality.ini ~/

NUM_CHUNKS=$(cat $SCRIPTDIR/temp/num_chunks.txt)

let "NUM_CHUNKS = $NUM_CHUNKS - 1"

sed "s/\NUMBER_OF_CHUNKS/$NUM_CHUNKS/g" $SCRIPTDIR/runonworkers.ini > $SCRIPTDIR/temp/runonworkers_tmp.ini

sed "s|FFMPEG_DIR|$FFMPEGDIR|g" $SCRIPTDIR/temp/runonworkers_tmp.ini > $SCRIPTDIR/temp/runonworkers_temp.ini

sed "s|SCRIPT_DIR|$SCRIPTDIR|g" $SCRIPTDIR/temp/runonworkers_temp.ini > $SCRIPTDIR/temp/runonworkers.ini

# Hack to work around job input file path bug in
# Techila GMK Library 2011-09-07

cd ~/gmk/examples/CLI/ffmpeg

java -jar ~/gmk/grid/gridmgmt.jar read < $SCRIPTDIR/temp/runonworkers.ini

rm $SCRIPTDIR/output/*

mv ~/result_* $SCRIPTDIR/output/

cat $SCRIPTDIR/output/result_* > $SCRIPTDIR/temp/results.avi

$SCRIPTDIR/ffmpeg -i $SCRIPTDIR/temp/results.avi $1.avi

#NUM_CHUNKS=$(cat $SCRIPTDIR/temp/num_chunks.txt)

rm $SCRIPTDIR/output/*

rmdir $SCRIPTDIR/output

rm $SCRIPTDIR/temp/*

rmdir $SCRIPTDIR/temp

#HOST='localhost'
#USER='FTPUsername'
#PASSWD='FTPassword'
#
#while [ $NUM_CHUNKS -gt 0 ] ; do
#
#ftp -n $HOST <<END_SCRIPT
#quote USER $USER
#quote PASS $PASSWD
#prompt off
#delete $NUM_CHUNKS.mpg
#quit
#END_SCRIPT
#
#let NUM_CHUNKS=NUM_CHUNKS-1
#
#wait
#
#ftp -n $HOST <<END_SCRIPT
#quote USER $USER
#quote PASS $PASSWD
#prompt off
#delete quality.ini
#quit
#END_SCRIPT

rm  ~/*.tmp
rm  ~/*.ini
