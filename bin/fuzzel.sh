#!/bin/bash

args="$@"
fuzzel --font 'JetBrains Mono:size=10' \
       --background-color     111111ff \
       --text-color           ddddddff \
       --selection-color      285577ff \
       --selection-text-color ddddddff \
       --border-color         285577ff \
       --terminal footclient \
       $args
