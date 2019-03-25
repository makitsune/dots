#!/bin/bash

echo Recording...
ffmpeg -y -loglevel panic -s 1920x1080 -framerate 30 -f x11grab -i :0.0+0,0 /tmp/video.mp4

video_url=$(curl --silent -F token='' -F files=@/tmp/video.mp4 'https://cutelab.space/api/upload' | cut -c 3- | rev | cut -c 3- | rev)
echo "Uploaded!"

echo $video_url
echo $video_url | xclip -selection clipboard