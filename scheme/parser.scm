(define parser-error 'parser-error)
(define (parser-error? x)
    (eq? parser-error x))

;(文字リスト . 結果)|'parser-error
;x<-f()

(define (parser-peak s)
    (if (null? s)
        parser-error
        (cons s (car s))))

(call/cc (lambda (k)  (k 1)))