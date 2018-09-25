(print (if (= (length *argv*) 0)
"Error"
(parser-error-guard
    (lambda () (rational->string (parse (string->list (list-ref *argv* 0)))))
    (lambda () "Error")
)
))