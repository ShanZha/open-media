#!/bin/bash

echo "before your do this, make sure you have built faac, x264, and ffmpeg"

echo "remove all old stuffs"
rm -rf openmedia/*
echo "copying libs & includes"
cp -vrf ../../../output/faac/android openmedia/faac
cp -vrf ../../../output/x264/android openmedia/x264
cp -vrf ../../../output/ffmpeg/android openmedia/ffmpeg
#./lsopenmedia.sh
