#!/bin/sh
lpass show --password "$1" | xclip -selection c
