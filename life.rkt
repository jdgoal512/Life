#lang racket

; Rules
(define D 0)  ; Die
(define S 1)  ; Stay the Same
(define G 2)  ; New cell grows
(define RULES '(D D S G D D D D D))

(define WIDTH 20)
(define HEIGHT 10)
(define grid (for/list ([y (in-range HEIGHT)])
                       (for/list ([x (in-range WIDTH)]) #f)))

(define (get x y)
  (if (and (< -1 x WIDTH) (< -1 y HEIGHT))
      (list-ref (list-ref grid y) x)
      #f))

(define (set x_pos y_pos value)
  (set! grid (for/list ([y (in-range HEIGHT)])
                       (for/list ([x (in-range WIDTH)])
                                 (if (and (equal? x_pos x) (equal? y_pos y))
                                     value
                                     (list-ref (list-ref grid y) x))))))

(define (get-neighbors x y)
    (define neighbors 0)
    (for ([x-offset '(-1 0 1)])
        (for ([y-offset '(-1 0 1)])
            (when (get (+ x x-offset) (+ y y-offset))
              ; Don't count the offset 0, 0
              (unless (and (equal? x-offset 0) (equal? y-offset 0))
                (set! neighbors (+ neighbors 1))))))
    neighbors)

(define (print-grid)
   (display (string-append "+" (make-string WIDTH #\-) "+\n"))
  (for ([row grid])
       (display "|")
       (for ([cell row])
            (if cell
                 (display "0")
                 (display " ")))
       (display "|\n"))
   (display (string-append "+" (make-string WIDTH #\-) "+\n")))

(define (next-generation)
  (set! grid
    (for/list ([y (in-range HEIGHT)])
              (for/list ([x (in-range WIDTH)])
                        (define neighbors (get-neighbors x y))
                        (define next-state (list-ref RULES neighbors))
                        (if (equal? next-state 'S)
                            (get x y)
                            (if (equal? next-state 'G) #t #f))))))

(define (add-figure points [x 5] [y 5])
  (for ([p points])
       (set (+ x (list-ref p 0)) (+ y (list-ref p 1)) #t)))

(define RPENTOMINO '((1 0) (2 0) (0 1) (1 1) (1 2)))
(define BLOCK '((0 0) (1 0) (0 1) (1 1)))
(define BLINKER '((1 0) (1 1) (1 2)))
(define BEACON '((0 0) (0 1) (1 0) (2 3) (3 2) (3 3)))

(add-figure RPENTOMINO 4 4)
; (add-figure BLOCK 2 7)
; (add-figure BLINKER 15 1)
; (add-figure BEACON 2 1)

(for ([i (in-naturals)])
     (display "Generation ")
     (display i)
     (display "\n")
     (print-grid)
     (next-generation)
     (sleep 1))
