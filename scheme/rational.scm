(define (rational-n x)
  (vector-ref x 0))

(define (rational-d x)
  (vector-ref x 1))

(define (make-rational n d)
  (if (equal? d 0)
    ()
    (let ((g (gcd (abs n) (abs d))))
      (let ((g (if (< d 0) (- g) g)))
        (vector (/ n g) (/ d g))))))

(define (rational->string x)
  (if (null? x)
    "NaN"
    (if (equal? (rational-d x) 1)
      (number->string (rational-n x))
      (string-append
        (number->string (rational-n x))
        "/"
        (number->string (rational-d x))))))

(define (rational+ x y)
  (if (or (null? x) (null? y))
    ()
    (make-rational
      (+
        (* (rational-n x) (vector-ref y 1))
        (* (vector-ref y 0) (rational-d x)))
      (*
        (rational-d x)
        (vector-ref y 1)))))

(define (rational- x y)
  (if (or (null? x) (null? y))
    ()
    (make-rational
      (-
        (* (rational-n x) (vector-ref y 1))
        (* (vector-ref y 0) (rational-d x)))
      (*
        (rational-d x)
        (vector-ref y 1)))))

(define (rational* x y)
  (if (or (null? x) (null? y))
    ()
    (make-rational
      (*
        (rational-n x)
        (vector-ref y 0))
      (*
        (rational-d x)
        (vector-ref y 1)))))

(define (rational/ x y)
  (if (or (null? x) (null? y))
    ()
    (make-rational
      (*
        (rational-n x)
        (vector-ref y 1))
      (*
        (rational-d x)
        (vector-ref y 0)))))