;; -*- geiser-scheme-implementation: guile -*-

(define-module (c03))
(use-modules (ice-9 rdelim))
(use-modules (ice-9 textual-ports))
(use-modules (ice-9 peg))
(use-modules (ice-9 match))
(use-modules (srfi srfi-1))

(define-peg-pattern NL none "\n")
(define-peg-pattern EOF none (not-followed-by peg-any))
(define-peg-pattern bitstring body (* (range #\0 #\1)))
(define-peg-pattern byte all (and (ignore (* NL)) bitstring (or NL EOF)))
(define-peg-pattern data body (and (* byte) EOF))

(define-public (read-input filename)
  (call-with-input-file filename get-string-all))

(define-public (parse-input filename)
  (map cadr (peg:tree (match-pattern data (read-input filename)))))

(define-public (bit-plus-minus ch)
  (if (equal? ch #\1) 1 -1))

(define-public (byte-plus-minus bitstring)
  (map bit-plus-minus (string->list bitstring)))

(define-public (sum-sequences seq1 seq2)
  (map + seq1 seq2))

(define-public (sum-all-sequences seq-of-seq)
  (reduce sum-sequences '() seq-of-seq))

(define-public (sign->bitch n)
  (if (> n 0) #\1 #\0))

(define-public (gamma bitstrings)
  (map sign->bitch
   (sum-all-sequences
    (map byte-plus-minus bitstrings))))

(define-public (epsilon gammabits)
  (map (lambda (b) (if (equal? #\1 b) #\0 #\1)) gammabits))

(define-public (bitchseq->number bitchseq)
  (string->number (list->string bitchseq) 2))

(define-public (solution)
  (let* ((g (gamma (parse-input "input.txt")))
         (e (epsilon g)))
    (* (bitchseq->number g) (bitchseq->number e))))
