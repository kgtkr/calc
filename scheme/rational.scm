(define rational
    (lambda (n d)
        (if (equal? d 0)
            ()
            (let ((g (gcd (abs n) (abs d))))
                (let ((g (if (< d 0) (- g) g)))
                    (list (/ n g) (/ d g)))))))