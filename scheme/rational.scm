(define my-gcd (lambda (a b) (if (equal? b 0) a (my-gcd b (mod a b)))))