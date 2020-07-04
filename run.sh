#!/bin/sh
# build and test functions
wast2json ./color.wast -o ./color.json
spectest-interp ./color.json
