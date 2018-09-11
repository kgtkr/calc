(define (make-rational n d)
  (if (equal? d 0)
    ()
    (let ((g (gcd (abs n) (abs d))))
      (let ((g (if (< d 0) (- g) g)))
        (vector (/ n g) (/ d g))))))

(define (rational->string x)
  (if (null? x)
    "NaN"
    (if (equal? (vector-ref x 1) 1)
      (number->string (vector-ref x 0))
      (string-append (number->string (vector-ref x 0)) "/" (number->string (vector-ref x 1))))))

(define (rational+ x y)
  (if (or (null? x) (null? y))
    ()
    (make-rational
      (+
        (* (vector-ref x 0) (vector-ref y 1))
        (* (vector-ref y 0) (vector-ref x 1)))
      (*
        (vector-ref x 1)
        (vector-ref y 1)))))