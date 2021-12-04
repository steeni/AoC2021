;; -*- geiser-scheme-implementation: guile -*-
(use-modules (srfi srfi-64)
             (c01))

(define input-data-reference
  '(199
    200
    208
    210
    200
    207
    240
    269
    260
    263))

(test-begin "challenge-1")

(test-equal input-data-reference (parse-input "test-input.txt"))
(test-equal input-data-reference (parse-input "test-input-garbled.txt"))

;; ---------------------------------

(test-equal '((1 . 2) (2 . 3) (3 . 4)) (part '(1 2 3 4)))

;; Not staying same is now a decrease
(test-equal '(#:inc #:inc #:dec #:inc #:dec #:dec) (inc-dec '(123 213 943 439 500 45 45)))

(test-equal (count-increases (parse-input "test-input.txt")) 7)

(test-equal (3-part (list 1 2 3 4 5)) (list '(1 2 3) '(2 3 4) '(3 4 5)))
(test-end "challenge-1")
