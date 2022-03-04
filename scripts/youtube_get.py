#! python

import argparse
import subprocess
import os
import sys
import urllib.request
import shutil

import Grimoire

youtube_dl_name = "yt-dlp"

if __name__ == "__main__":
	## Instantiate the parser
	parser = argparse.ArgumentParser(
				description='Downloads a video link into mp3 or video if --video is passed (auto-updates)\n'
            'py ' + __file__ + ' <link>',
						formatter_class=argparse.RawTextHelpFormatter)
	parser.add_argument('link',
							help='link to the video')
	parser.add_argument('pathOutDir', nargs='?',
							help='path to the output directory')
	parser.add_argument('-v', action='store_true',
							help='verbose')
	parser.add_argument('--video', action='store_true',
							help='download video, not only mp3')
	parser.add_argument('--help_dl', action='store_true',
							help='downloader help.')
	parser.add_argument('remainder_args', nargs=argparse.REMAINDER)

	## Parse arguments
	args = parser.parse_args()

	if not args.pathOutDir:
		args.pathOutDir = './output/'
		print(f'output in {args.pathOutDir}', flush=True)

	if not shutil.which(youtube_dl_name):

		# update
		print("Youtube downloader not found, installing " + youtube_dl_name)
		bashCommand = "pip install -U " + youtube_dl_name
		print(bashCommand, flush=True)
		process = subprocess.call(bashCommand)

	# youtube-dl is installed

	Grimoire.ensure_dir(args.pathOutDir)

	bashCommand = youtube_dl_name + ' '
	if not args.video:
		bashCommand = bashCommand + ' -x --audio-format "mp3" --audio-quality 320K --embed-thumbnail '
	if args.help_dl:
		bashCommand = bashCommand + ' --help '
	else:
		outputCom = f' --output "{args.pathOutDir}%(title)s - %(uploader)s %(id)s.%(ext)s" '
		# https://github.com/ytdl-org/youtube-dl/issues/698
		defaultArgs = " -i "

		bashCommand += args.link + defaultArgs + outputCom
		bashCommand += ' ' + ' '.join(args.remainder_args)

	print(bashCommand, flush=True)
	try:
		process = subprocess.call(bashCommand)
	except Exception as err:
		print(err)
		exit(1)
	else:
		if process != 0:
			print("Try updating youtube-dl:")
			print("conda upgrade youtube-dl")
			print("pip install -U youtube-dl")
			print("if you don't know conda use the pip command")
		exit(process)
