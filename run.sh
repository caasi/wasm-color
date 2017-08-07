#!/bin/sh
wast2wasm --spec ./rgb2hsv.wast -o ./rgb2hsv.json
wasm-interp --spec ./rgb2hsv.json
wast2wasm --spec ./hsv2rgb.wast -o ./hsv2rgb.json
wasm-interp --spec ./hsv2rgb.json
