(module
  (func $fmod
    (param $x f64)
    (param $y f64)
    (result f64)
    get_local $x
    get_local $y
    get_local $x
    get_local $y
    f64.div
    f64.trunc
    f64.mul
    f64.sub
  )
  (export "fmod" (func $fmod))

  (func
    (export "rgb2hsv")
    (param $r f32)
    (param $g f32)
    (param $b f32)
    (result f32 f32 f32)
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
        f64.promote/f32
        f64.const 6.0
        call $fmod
        f32.demote/f64
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
    ;; return
    get_local $h
    get_local $s
    get_local $v
  )

  (func
    (export "hsv2rgb")
    (param $h f32)
    (param $s f32)
    (param $v f32)
    (result f32 f32 f32)
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
    f64.promote/f32
    f64.const 2.0
    call $fmod
    f32.demote/f64
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
    get_local $r
    get_local $g
    get_local $b
  )
)

;; test fmod
(assert_return (invoke "fmod" (f64.const 1.0) (f64.const 1.0)) (f64.const 0.0))
(assert_return (invoke "fmod" (f64.const 2.5) (f64.const 1.0)) (f64.const 0.5))

;; test rgb2hsv
(assert_return
  (invoke "rgb2hsv" (f32.const 0.0) (f32.const 0.0) (f32.const 0.0))
  (f32.const 0.0) (f32.const 0.0) (f32.const 0.0)
)
(assert_return
  (invoke "rgb2hsv" (f32.const 255.0) (f32.const 255.0) (f32.const 255.0))
  (f32.const 0.0) (f32.const 0.0) (f32.const 1.0)
)
(assert_return
  (invoke "rgb2hsv" (f32.const 255.0) (f32.const 0.0) (f32.const 0.0))
  (f32.const 0.0) (f32.const 1.0) (f32.const 1.0)
)
(assert_return
  (invoke "rgb2hsv" (f32.const 0.0) (f32.const 255.0) (f32.const 0.0))
  (f32.const 120.0) (f32.const 1.0) (f32.const 1.0)
)
(assert_return
  (invoke "rgb2hsv" (f32.const 0.0) (f32.const 0.0) (f32.const 255.0))
  (f32.const 240.0) (f32.const 1.0) (f32.const 1.0)
)
(assert_return
  (invoke "rgb2hsv" (f32.const 191.25) (f32.const 191.25) (f32.const 191.25))
  (f32.const 0.0) (f32.const 0.0) (f32.const 0.75)
)

;; test hsv2rgb
(assert_return
  (invoke "hsv2rgb" (f32.const 0.0) (f32.const 0.0) (f32.const 0.0))
  (f32.const 0.0) (f32.const 0.0) (f32.const 0.0)
)
(assert_return
  (invoke "hsv2rgb" (f32.const 0.0) (f32.const 0.0) (f32.const 1.0))
  (f32.const 255.0) (f32.const 255.0) (f32.const 255.0)
)
(assert_return
  (invoke "hsv2rgb" (f32.const 0.0) (f32.const 1.0) (f32.const 1.0))
  (f32.const 255.0) (f32.const 0.0) (f32.const 0.0)
)
(assert_return
  (invoke "hsv2rgb" (f32.const 120.0) (f32.const 1.0) (f32.const 1.0))
  (f32.const 0.0) (f32.const 255.0) (f32.const 0.0)
)
(assert_return
  (invoke "hsv2rgb" (f32.const 240.0) (f32.const 1.0) (f32.const 1.0))
  (f32.const 0.0) (f32.const 0.0) (f32.const 255.0)
)
(assert_return
  (invoke "hsv2rgb" (f32.const 0.0) (f32.const 0.0) (f32.const 0.75))
  (f32.const 191.25) (f32.const 191.25) (f32.const 191.25)
)
