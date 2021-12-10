;; -*- geiser-scheme-implementation: guile -*-

(define-module (c02))
(use-modules (ice-9 rdelim))
(use-modules (ice-9 textual-ports))
(use-modules (ice-9 peg))
(use-modules (ice-9 match))
(use-modules (srfi srfi-1))

(define-peg-pattern NL none "\n")
(define-peg-pattern EOF none (not-followed-by peg-any))
(define-peg-pattern forward all "forward")
(define-peg-pattern down all "down")
(define-peg-pattern up all "up")
(define-peg-pattern direction body (or forward down up))
(define-peg-pattern move-amount body (* (range #\0 #\9)))
(define-peg-pattern movement body (and (ignore (* NL)) direction (ignore " ") move-amount (or NL EOF)))
(define-peg-pattern data body (and (* movement) EOF))

(define-public (read-input filename)
  (call-with-input-file filename get-string-all))

(define-public (parse-input filename)
  (peg:tree (match-pattern data (read-input filename))))

;;  Challenge 1
(define-public (move directions)
  (fold (lambda (item acc)
          (match-let ((((dkey dval) mval) item)
                      ((depth forw) acc))
            (let ((mov (string->number mval)))
              (case dkey
                ((forward) (list depth (+ mov forw)))
                ((down) (list (+ depth mov) forw))
                ((up) (list (- depth mov) forw))))))
        (list 0 0)
        directions))

(display "Challenge 1:\n")
(display (apply * (move (parse-input "input.txt"))))

;; Challenge 2
(define-public (aim directions)
  (fold (lambda (item acc)
          (match-let ((((dkey dval) mval) item)
                      ((depth forw aim) acc))
            (let ((val (string->number mval)))
              (case dkey
                ((forward) (list (+ depth (* aim val)) (+ forw val) aim))
                ((down) (list depth forw (+ aim val)))
                ((up) (list depth forw (- aim val)))))))
        (list 0 0 0)
        directions))

(display "\nChallenge 2:\n")
(display (apply * (take (aim (parse-input "input.txt")) 2)))
