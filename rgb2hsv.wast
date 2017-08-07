;; wast2wasm --spec ./rgb2hsv.wast -o ./rgb2hsv.json
;; wasm-interp --spec ./rgb2hsv.json
(module
  (memory 1)
  (func $rgb2hsv
    (param $r f32)
    (param $g f32)
    (param $b f32)
    (local $M f32)
    (local $m f32)
    (local $rr f32)
    (local $gg f32)
    (local $bb f32)
    (local $c f32)
    (local $t f32)
    (local $h f32)
    (local $hh f32)
    (local $s f32)
    (local $v f32)
    get_local $r
    f32.const 255.0
    f32.div
    set_local $rr
    get_local $g
    f32.const 255.0
    f32.div
    set_local $gg
    get_local $b
    f32.const 255.0
    f32.div
    set_local $bb
    ;; find max and min
    get_local $rr
    get_local $gg
    get_local $bb
    f32.max
    f32.max
    set_local $M
    get_local $rr
    get_local $gg
    get_local $bb
    f32.min
    f32.min
    set_local $m
    ;; delta
    get_local $M
    get_local $m
    f32.sub
    set_local $c
    block
      ;; $c is 0.0
      f32.const 0.0
      get_local $c
      f32.eq
      if
        get_local $c
        set_local $hh
        br 1
      end
      ;; $M is $rr
      get_local $M
      get_local $rr
      f32.eq
      if
        get_local $gg
        get_local $bb
        f32.sub
        get_local $c
        f32.div
        set_local $t
        ;; modulo
        get_local $t
        get_local $t
        f32.const 6.0
        f32.div
        f32.floor
        f32.const 6.0
        f32.mul
        f32.sub
        set_local $hh
        br 1
      end
      ;; $M is $gg
      get_local $M
      get_local $gg
      f32.eq
      if
        get_local $bb
        get_local $rr
        f32.sub
        get_local $c
        f32.div
        f32.const 2.0
        f32.add
        set_local $hh
        br 1
      end
      get_local $rr
      get_local $gg
      f32.sub
      get_local $c
      f32.div
      f32.const 4.0
      f32.add
      set_local $hh
    end
    get_local $hh
    f32.const 60.0
    f32.mul
    set_local $h
    get_local $M
    set_local $v
    get_local $v
    f32.const 0.0
    f32.eq
    if
      f32.const 0.0
      set_local $s
    else
      get_local $c
      get_local $v
      f32.div
      set_local $s
    end
    ;; update multi-values
    i32.const 0
    get_local $h
    f32.store
    i32.const 4
    get_local $s
    f32.store
    i32.const 8
    get_local $v
    f32.store
  )
  (func $getH
    (result f32)
    i32.const 0
    f32.load
  )
  (func $getS
    (result f32)
    i32.const 4
    f32.load
  )
  (func $getV
    (result f32)
    i32.const 8
    f32.load
  )
  (export "rgb2hsv" (func $rgb2hsv))
  (export "getH" (func $getH))
  (export "getS" (func $getS))
  (export "getV" (func $getV))
)

;; test 0
(invoke "rgb2hsv" (f32.const 0.0) (f32.const 0.0) (f32.const 0.0))
(assert_return (invoke "getH") (f32.const 0.0))
(assert_return (invoke "getS") (f32.const 0.0))
(assert_return (invoke "getV") (f32.const 0.0))
;; test 1
(invoke "rgb2hsv" (f32.const 255.0) (f32.const 255.0) (f32.const 255.0))
(assert_return (invoke "getH") (f32.const 0.0))
(assert_return (invoke "getS") (f32.const 0.0))
(assert_return (invoke "getV") (f32.const 1.0))
;; test 2
(invoke "rgb2hsv" (f32.const 255.0) (f32.const 0.0) (f32.const 0.0))
(assert_return (invoke "getH") (f32.const 0.0))
(assert_return (invoke "getS") (f32.const 1.0))
(assert_return (invoke "getV") (f32.const 1.0))
;; test 3
(invoke "rgb2hsv" (f32.const 0.0) (f32.const 255.0) (f32.const 0.0))
(assert_return (invoke "getH") (f32.const 120.0))
(assert_return (invoke "getS") (f32.const 1.0))
(assert_return (invoke "getV") (f32.const 1.0))
;; test 4
(invoke "rgb2hsv" (f32.const 0.0) (f32.const 0.0) (f32.const 255.0))
(assert_return (invoke "getH") (f32.const 240.0))
(assert_return (invoke "getS") (f32.const 1.0))
(assert_return (invoke "getV") (f32.const 1.0))
;; test 5 -- fail to do floating point arithmetics right
(invoke "rgb2hsv" (f32.const 192.0) (f32.const 192.0) (f32.const 192.0))
(assert_return (invoke "getH") (f32.const 0.0))
(assert_return (invoke "getS") (f32.const 0.0))
(assert_return (invoke "getV") (f32.const 0.75))
