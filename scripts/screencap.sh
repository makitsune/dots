#!/bin/bash

echo Selecting...
scrot -s /tmp/video.png
video_width=$(identify -format "%w" /tmp/video.png)
video_height=$(identify -format "%h" /tmp/video.png) 
mouse_x=$(xdotool getmouselocation | grep -o -P "(?<=x:).*(?=\ y)")
mouse_y=$(xdotool getmouselocation | grep -o -P "(?<=y:).*(?=\ s)")

echo Recording...
ffmpeg -y -loglevel panic -s $(echo $video_width)x$(echo $video_height) -framerate 30 -f x11grab -i :0.0+$(expr $mouse_x - $video_width),$(expr $mouse_y - $video_height) /tmp/video.mp4

video_url=$(curl --silent -F token='' -F files=@/tmp/video.mp4 'https://cutelab.space/api/upload' | cut -c 3- | rev | cut -c 3- | rev)
echo "Uploaded!"

echo $video_url
echo $video_url | xclip -selection clipboard