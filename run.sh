#!/bin/sh
# build and test math functions
wast2wasm --spec ./math.wast -o ./math.json
spectest-interp ./math.json

# rgb2hsv
wast2wasm --spec ./rgb2hsv.wast -o ./rgb2hsv.json
# link and overwrite the output wasm
wasm-link ./math.0.wasm ./rgb2hsv.0.wasm -o ./rgb2hsv.0.wasm
spectest-interp ./rgb2hsv.json

# hsv2rgb
wast2wasm --spec ./hsv2rgb.wast -o ./hsv2rgb.json
wasm-link ./math.0.wasm ./hsv2rgb.0.wasm -o ./hsv2rgb.0.wasm
spectest-interp ./hsv2rgb.json
