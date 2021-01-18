ffmpeg -i video.mp4 -i thumbnail.png -b:a 256k -map_metadata 0 -map 0:1 -map 1 output.mp3
