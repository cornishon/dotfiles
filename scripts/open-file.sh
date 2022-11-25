#!/bin/sh
# Launches files based on their mimetypes
# Dependencies: file

if [ $# -lt 1 ]; then
  echo "Usage: $0 [FILE...]" >&2
  exit 1
fi

case $(file --mime-type "$@" -bL) in
  video/* | audio/* | image/gif)
    devour mpv "$@" ;;
  image/*)
    devour sxiv "$@" ;;
  application/pdf | application/postscript)
    devour zathura "$@" ;;
  text/html)
    firefox "$@" ;;
  text/*)
    devour alacritty --title="$(basename "$1")" -e nvim "$@" ;;
  *) exit 1 ;;
esac
