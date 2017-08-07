(module
  (memory 1)
  (func $hsv2rgb
    (param $h f32)
    (param $s f32)
    (param $v f32)
    (local $r f32)
    (local $g f32)
    (local $b f32)
    (local $c f32)
    (local $m f32)
    (local $hh f32)
    (local $x f32)
    get_local $s
    get_local $v
    f32.mul
    set_local $c
    get_local $v
    get_local $c
    f32.sub
    set_local $m
    get_local $h
    f32.const 60.0
    f32.div
    set_local $hh
    ;; x = c * (1 - abs(hh % 2 - 1))
    get_local $c
    f32.const 1.0
    ;; modulo
    get_local $hh
    get_local $hh
    f32.const 2.0
    f32.div
    f32.floor
    f32.const 2.0
    f32.mul
    f32.sub
    ;; end of modulo
    f32.const 1.0
    f32.sub
    f32.abs
    f32.sub
    f32.mul
    set_local $x
    block
      get_local $hh
      f32.const 1.0
      f32.lt
      if
        get_local $c
        set_local $r
        get_local $x
        set_local $g
        f32.const 0.0
        set_local $b
        br 1
      end
      get_local $hh
      f32.const 2.0
      f32.lt
      if
        get_local $x
        set_local $r
        get_local $c
        set_local $g
        f32.const 0.0
        set_local $b
        br 1
      end
      get_local $hh
      f32.const 3.0
      f32.lt
      if
        f32.const 0.0
        set_local $r
        get_local $c
        set_local $g
        get_local $x
        set_local $b
        br 1
      end
      get_local $hh
      f32.const 4.0
      f32.lt
      if
        f32.const 0.0
        set_local $r
        get_local $x
        set_local $g
        get_local $c
        set_local $b
        br 1
      end
      get_local $hh
      f32.const 5.0
      f32.lt
      if
        get_local $x
        set_local $r
        f32.const 0.0
        set_local $g
        get_local $c
        set_local $b
        br 1
      end
      get_local $c
      set_local $r
      f32.const 0.0
      set_local $g
      get_local $x
      set_local $b
    end
    get_local $m
    get_local $r
    f32.add
    f32.const 255.0
    f32.mul
    set_local $r
    get_local $m
    get_local $g
    f32.add
    f32.const 255.0
    f32.mul
    set_local $g
    get_local $m
    get_local $b
    f32.add
    f32.const 255.0
    f32.mul
    set_local $b
    ;; return
    i32.const 0
    get_local $r
    f32.store
    i32.const 4
    get_local $g
    f32.store
    i32.const 8
    get_local $b
    f32.store
  )
  (func $getR
    (result f32)
    i32.const 0
    f32.load
  )
  (func $getG
    (result f32)
    i32.const 4
    f32.load
  )
  (func $getB
    (result f32)
    i32.const 8
    f32.load
  )
  (export "hsv2rgb" (func $hsv2rgb))
  (export "getR" (func $getR))
  (export "getG" (func $getG))
  (export "getB" (func $getB))
)

;; test 0
(invoke "hsv2rgb" (f32.const 0.0) (f32.const 0.0) (f32.const 0.0))
(assert_return (invoke "getR") (f32.const 0.0))
(assert_return (invoke "getG") (f32.const 0.0))
(assert_return (invoke "getB") (f32.const 0.0))
;; test 1
(invoke "hsv2rgb" (f32.const 0.0) (f32.const 0.0) (f32.const 1.0))
(assert_return (invoke "getR") (f32.const 255.0))
(assert_return (invoke "getG") (f32.const 255.0))
(assert_return (invoke "getB") (f32.const 255.0))
;; test 2
(invoke "hsv2rgb" (f32.const 0.0) (f32.const 1.0) (f32.const 1.0))
(assert_return (invoke "getR") (f32.const 255.0))
(assert_return (invoke "getG") (f32.const 0.0))
(assert_return (invoke "getB") (f32.const 0.0))
;; test 3
(invoke "hsv2rgb" (f32.const 120.0) (f32.const 1.0) (f32.const 1.0))
(assert_return (invoke "getR") (f32.const 0.0))
(assert_return (invoke "getG") (f32.const 255.0))
(assert_return (invoke "getB") (f32.const 0.0))
;; test 4
(invoke "hsv2rgb" (f32.const 240.0) (f32.const 1.0) (f32.const 1.0))
(assert_return (invoke "getR") (f32.const 0.0))
(assert_return (invoke "getG") (f32.const 0.0))
(assert_return (invoke "getB") (f32.const 255.0))
;; test 5 -- should not be 191.25
(invoke "hsv2rgb" (f32.const 0.0) (f32.const 0.0) (f32.const 0.75))
(assert_return (invoke "getR") (f32.const 192.0))
(assert_return (invoke "getG") (f32.const 192.0))
(assert_return (invoke "getB") (f32.const 192.0))
