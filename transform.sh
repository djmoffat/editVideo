#!/bin/bash

FILES=/Volumes/Internal/Documents/editVideo/video/*.avi
for f in $FILES
do
  echo "Processing $f file..."
  # echo  "-i $f"
  f2=${f%.*}.mp4
  # echo  "-o $f2"
  ffmpeg -i $f -b:a 128k -vcodec mpeg4 -b:v 1200k -flags +aic+mv4 $f2
  # HandBrakeCLI -i $f -o $f2 

done