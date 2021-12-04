;; -*- geiser-scheme-implementation: guile -*-

(define-module (c01))
(use-modules (ice-9 rdelim))
(use-modules (ice-9 textual-ports))
(use-modules (ice-9 peg))
(use-modules (ice-9 pretty-print))
(use-modules (ice-9 vlist))
(use-modules (srfi srfi-1))
(use-modules (oop goops))

(define-peg-pattern NL none "\n")
(define-peg-pattern EOF none (not-followed-by peg-any))

;; Any sequence of numbers that ends with new line or end of file, ignoring newlines in the beginning
(define-peg-pattern measurement all (and (ignore (* NL)) (* (range #\0 #\9)) (or NL EOF)))
;; All measurements until the end of file
(define-peg-pattern data body (and (* measurement) EOF))

(define-public (read-input filename)
  (call-with-input-file filename get-string-all))

(define-public (parse-input filename)
  (map string->number
       (map cadr
            (peg:tree (match-pattern data (read-input filename))))))

(define-public (part coll)
  (map (lambda (. items) (apply cons items))
       (drop-right coll 1) (drop coll 1)))

(define-public (inc-dec coll)
  (map (lambda (x) (if (< (car x) (cdr x)) #:inc #:dec))
       (part coll)))

(define-public (count-increases coll)
  (length (filter (lambda (x) (equal? x #:inc))
                  (inc-dec coll))))

(display "Challenge 1 solution:\n")
(display (count-increases (parse-input "input.txt")))

(define-public (3-part coll)
  (map (lambda (. items) (apply list items))
       (drop-right coll 2) (drop (drop-right coll 1) 1) (drop coll 2)))

(display "\nChallenge 2 solution:\n")
(display (count-increases (map (lambda (x) (apply + x)) (3-part (parse-input "input.txt")))))
