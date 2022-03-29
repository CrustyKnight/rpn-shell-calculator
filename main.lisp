;; probably gonna have a main loop
;; (loop [
;;      ;; where vars I might want to define go
;;      ]
;;      [nil nil]
;;      (print! "hi!"))
(defmacro while-true (&body)
  `(while true (progn ,@body)))

(define wrapper
  :hidden
  (require "wrapper"))
(define _G (.> wrapper :_G))

(import lua/string string)
(import lua/io io)


(define mode :mutable nil)
(defun switch-mode (nmode)
  (set! mode (.> _G nmode)))

(defun ps (x y msg) (io/write (string/format "[%d;%df%s" y x msg)))
(defun get-key () (io/read 1))
(defun do_menu (title options) (print! "working on menu"))

(define buttons :mutable {})
(.<! buttons :EXIT "e")
(.<! buttons :NUM  "a")
(.<! buttons :SYM  "s")
(.<! buttons :MENU "h")

; stack is just a list. end of the list is the top of the stack
; area is a list with for values: '(x y width height)
;; x and y are the coordinates of the top character
;; units for x,y,w,h are in characters
; note: width limit is 54
(defun print_stack (stack area)
  ; basically, print the list straight down from the top, but start with end - height + 1
  (let* ((x (nth area 1))
         (y (nth area 2))
         (w (nth area 3))
         (h (nth area 4)))
    (with (start (- (+ 1 (n stack)) h))
          (for i start (n stack) 1
               (ps x (- i start) (string/sub (tostring (nth stack i)) 1 w))))))
(defun print_nstack_r (stack area)
  (let* ((x (nth area 1))
         (y (nth area 2))
         (w (nth area 3))
         (h (nth area 4)))
    (with (start (- (+ 1 (n stack)) h))
          (for i start (n stack) 1
               (if (> (string/len (tostring (nth stack i))) w)
                   (ps x (- i start)
                       (string/format (.. "%" w "d") (nth stack i)))
                   (ps x (- i start)
                       (string/format (.. "%1." (- w 7) "e") (nth stack i)))

                   )))))

(define stack :mutable '())
(push! stack 1)
(push! stack 2)
(push! stack 3)
(push! stack 4)
(push! stack 5)
(push! stack 6)
(push! stack 7)
(push! stack 8)
(push! stack 9)
(push! stack 10)

(define home {})
(.<! home (.> buttons :SYM)
     (lambda () (print!  :symbol)))
(.<! home (.> buttons :NUM)
     (lambda () (print! :number)))
(.<! home :draw
     (lambda () (progn
                  ;(ps x y msg)
                  (for i 1 15 1 (ps 0 i "│"))
                  (for i 1 15 1 (ps 29 i "│"))
                  (for i 1 15 1 (ps 39 i "│"))
                  (ps 0 0  "┌────────────────────────────┬─────────┐")
                  (ps 0 14 "├────────────────────────────┼─────────┤")
                  (ps 0 16 "└────────────────────────────┴─────────┘"))))

(set! mode home)

(defun menu ()
  (let* [(options (list->struct '( "cancel" "clear entry" "reset" "quit")))
         (choice (do_menu "RPN-Ipod menu" options))
    ]
    (cond
      [(= choice 1) (switch-mode :home)]
      [(= choice 2) nil]
      [(= choice 3) nil]
      [(= choice 4) ((.> (require :os) :exit))])))



(while-true
 (let* [(action (get-key))]
   (cond
     ((= action (.> buttons :EXIT)) ((.> (require :os) :exit)))
     ;;((= action (.> buttons :CANCEL)) (menu))
     ((= action (.> buttons :MENU)) (print! "still working on menu :)"))
     ((.> mode action) ((.> mode action)))
     (true nil))
   ((.> mode :draw))))
