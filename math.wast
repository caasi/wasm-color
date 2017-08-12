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
)

(assert_return (invoke "fmod" (f64.const 1.0) (f64.const 1.0)) (f64.const 0.0))
(assert_return (invoke "fmod" (f64.const 2.5) (f64.const 1.0)) (f64.const 0.5))
