#!/bin/bash
scrot -s /tmp/screenshot.png
screenshot_url=$(curl --silent -F token='' -F files=@/tmp/screenshot.png 'https://maki.cat/api/upload' | cut -c 3- | rev | cut -c 3- | rev)
echo $screenshot_url
echo $screenshot_url | xclip -selection clipboard
#xclip -selection clipboard -target image/png -i /tmp/screenshot.png