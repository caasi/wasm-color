# Color functions in WebAssembly text format

## Development

* build [WABT](https://github.com/WebAssembly/wabt)
* run `./run.sh`

## ToDo

  * [x] implement `fmod`
    * port [`fmod`](https://git.musl-libc.org/cgit/musl/tree/src/math/fmod.c)
  * [ ] better `rgb2hsv`, `hsv2rgb`, check https://github.com/tmpvar/hsv2rgb

## References

### Introductions

  * [Understanding WebAssembly text format - MDN](https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format)
  * [WABT: The WebAssembly Binary Toolkitを使ってみる](http://qiita.com/ukyo/items/909d5132ae049c672755)
  * [webassemblyの薄い本](https://ukyo.github.io/wasm-usui-book/)

### Specs

  * [Semantics - WebAssembly](http://webassembly.org/docs/semantics/)
  * [WebAssembly Reference Manual](https://github.com/sunfishcode/wasm-reference-manual)

### Examples

  * [ukyo/wast-small-starter](https://github.com/ukyo/wast-small-starter)
  * [Amalgamated WebAssembly Test Suite](https://github.com/webassembly/testsuite)
  * [joshuawarner32/rust-wasm/test](https://github.com/joshuawarner32/rust-wasm/tree/master/test)
