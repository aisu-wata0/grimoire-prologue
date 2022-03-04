#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
# system requirement
    * python 2.7

# install
    $ brew install ffmpeg --with-tools
    $ pip install eyed3==0.7.8
"""

import argparse
import eyed3
from eyed3.id3.frames import ImageFrame
from os import getcwd, path, system, remove
import sys

FFMPEG_MP42MP3_CMD = (
    u'ffmpeg'
    u' -y'
    u' -loglevel warning'
    u' -i "{src_file}"'
    u' -acodec libmp3lame'
    u' -ab 256k'
    u' "{dest_file}"'
)
FFMPEG_THUMBNAIL_CMD = (
    u'ffmpeg'
    u' -y'
    u' -loglevel warning'
    u' -i "{src_file}"'
    u' -ss 5'
    u' -vframes 1'
    u' -f image2'
    u' "{dest_file}"'
)


def rename_filename_ext(src_file, rename_ext, dest_directory):
    name, ext = path.splitext(path.basename(src_file))
    return (name, path.join(dest_directory, name + rename_ext))


def main(src_files, dest_directory):
    for src_file in src_files:
        src_file = path.abspath(src_file)
        dest = path.abspath(dest_directory)
        try:
            src_file = src_file.decode('utf-8')
        except:
            pass
        try:
            dest = dest.decode('utf-8')
        except:
            pass


        title, dest_mp3_file = rename_filename_ext(src_file, u'.mp3', dest)
        title, dest_png_file = rename_filename_ext(src_file, u'.png', dest)

        # mp4 -> mp3 encode
        ffmpeg_cmd = FFMPEG_MP42MP3_CMD.format(
            src_file=src_file,
            dest_file=dest_mp3_file
        )
        print(u'{0} -> {1}'.format(src_file, dest_mp3_file))
        system(ffmpeg_cmd)

        #Cut out thumbnail image from mp4
        ffmpeg_cmd = FFMPEG_THUMBNAIL_CMD.format(
            src_file=src_file,
            dest_file=dest_png_file
        )
        system(ffmpeg_cmd)

        #Embed thumbnail images in mp3 files
        f = eyed3.load(dest_mp3_file)
        if f.tag is None:
            f.initTag()
        f.tag.title = title
        with open(dest_png_file, 'rb') as dest_png:
            f.tag.images.set(
                ImageFrame.FRONT_COVER,
                dest_png.read(),
                'image/png'
            )
        f.tag.save(encoding='utf-8')

        if path.exists(dest_png_file):
            remove(dest_png_file)


def parse_args():
    parser = argparse.ArgumentParser(
        description=u'Convert mp4 to mp3 with ffmpeg(Thumbnail embedded version)'
    )
    parser.add_argument(
        'source_files',
        metavar='source_file',
        nargs='+',
        help='source files'
    )
    parser.add_argument(
        '--dest',
        metavar='destination_directory',
        nargs='?',
        default=getcwd(),
        help='destination directory (default: current directory)'
    )
    return parser.parse_args()


if __name__ == '__main__':
    args = parse_args()
    main(args.source_files, args.dest)
