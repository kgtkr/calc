(use util.match)
(use srfi-1)
(define parser-error 'parser-error)
(define (raise-parser-error)
    (raise parser-error))
(define (parser-error? x)
    (eq? parser-error x))
(define (parser-error-guard f1 f2)
    (guard (ex [(parser-error? ex) (f2)])
        (f1)
    )
)

; 文字リスト,...引数
; (文字リスト . 値)

(define (parser-peak s)
    (match s
        [(x . _)
            (cons s x)
        ]
        [()
            (raise-parser-error)
        ])
    )

(define (parser-next s)
    (match (parser-peak s)
        [((_ . xs) . x)
            (cons xs x)
        ])
)

(define (parser-expect s f)
    (match (parser-next s)
        [(s . x)
            (if (f x)
                (cons s x)
                (raise-parser-error)
            )
        ])
)

(define (parser-char s c)
    (parser-expect s (lambda (x) (eq? x c)))
)

(define (parser-number s)
    (match (parser-error-guard
            (lambda ()
                (match (parser-char s #\-)
                    [(s . _)
                        (cons s -1)
                    ])
            )
            (lambda () (cons s 1))
        )
        [(s . g)
            (define (f s)
                (parser-error-guard
                    (lambda () (match (parser-expect s is-digit)
                        [(s . x)
                            (match (f s)
                                [(s . x2) (cons s (cons x x2))]
                            )
                        ]
                    ))
                    (lambda () (cons s ()))
                )
            )
            (match (f s)
                [(s . ns)
                    (if (and (= (length ns) 1) (= (car ns) #\0))
                        (raise-parser-error)
                        (let v (string->number (list->string ns))
                            (if v
                                (make-rational (* v g) 1)
                                (raise-parser-error)
                            )
                        )
                    )
                ]
            )
        ]
    )
)

(define (parser-eof s)
    (if (null? s)
        (cons s ())
        (raise-parser-error)
    )
)


(define (is-digit c)
    (and (char<=? #\0 c) (char<=? c #\9))
)

(print (parser-number (string->list "1234a5")))

