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
;old(defun get-key () (with (a (io/read 1)) (io/read 1) a)); the extra io/read is to get rid of the newline
(defun get-key () (io/read :*l))
(defun sc (x y) (io/write (string/format "[%d;%df" y x)))
(defun cls () (io/write "[2J"))
(defun do_menu (title options) (print! "working on menu"))

(define v_line  :mutable "|")
(define h_line1 :mutable "+----------------------------+---------+")
(define h_line2 :mutable "+----------------------------+---------+")
(define h_line3 :mutable "+----------------------------+---------+")

(if (= (.> *arguments* 1) "-u")
    (progn
      (set! v_line "│" )
      (set! h_line1 "┌────────────────────────────┬─────────┐")
      (set! h_line2 "├────────────────────────────┼─────────┤")
      (set! h_line3 "└────────────────────────────┴─────────┘"))
    nil)

;{{{ buttons table
(define buttons :mutable {})
(progn
  (.<! buttons :EXIT "e")
  (.<! buttons :NUM  "a")
  (.<! buttons :SYM  "s")
  (.<! buttons :MENU "h")
  (.<! buttons 1 "a")
  (.<! buttons 2 "o")
  (.<! buttons 3 "e")
  (.<! buttons 4 "u")
  (.<! buttons 5 "h")
  (.<! buttons 6 "t")
  (.<! buttons 7 "n")
  (.<! buttons 8 "s")
  (.<! buttons :ENTER " "))

(define numbers :mutable {})
(progn
  (.<! numbers "a" 16)
  (.<! numbers "o" 12)
  (.<! numbers "e" 8)
  (.<! numbers "u" 4)
  (.<! numbers "h" 1)
  (.<! numbers "t" 2)
  (.<! numbers "n" 3)
  (.<! numbers "s" 4))

;}}}

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
    ;(with (start (- (+ 1 (n stack)) h))
    (with (start (- (n stack) h))
          (for i start (n stack) 1
               (if (< (string/len (tostring (nth stack i))) w)
                   (ps x (+ y (- i start))
                       (string/format (.. "%" w "d") (nth stack i)))
                   (ps x (+ y (- i start))
                       (string/format (.. "%1." (- w 7) "e") (nth stack i)))

                   )))))

;returns a digit
;; basically, the first four characters (a o e u) are the first base 4 digit, and the second four (h t n s) are the second digit
(defun number_entry ()
  (with (str (io/read :*l))
        (let [
          (a (string/sub str 1 1))
          (b (string/sub str 2 2))]
          (print! a b)
          (+ (.> numbers a) (.> numbers b)))
        ))



(define stack :mutable '())
(progn
  (push! stack 0)
  (push! stack 0)
  (push! stack 0)
  (push! stack 0)
  (push! stack 0)
  (push! stack 0)
  (push! stack 0)
  (push! stack 0)
  (push! stack 0)
  (push! stack 0)
  (push! stack 0)
  (push! stack 0)
  (push! stack 0))

(define entry-number :mutable "0")

(define home {})
(.<! home (.> buttons :SYM)
     (lambda () nil))
(.<! home (.> buttons :NUM)
     (lambda () (set! entry-number (.. entry-number (tostring (number_entry))))))
(.<! home (.> buttons :ENTER)
     (lambda () (push! stack (tonumber entry-number)) (set! entry-number "0")))
(.<! home :draw
     (lambda () (progn
                  ;(ps x y msg)
                  (cls)
                  (for i 1 15 1 (ps 0 i v_line))
                  (for i 1 15 1 (ps 30 i v_line))
                  (for i 1 15 1 (ps 40 i v_line))
                  (ps 0 0  h_line1)
                  (ps 0 14 h_line2)
                  (ps 0 16 h_line3)
                  (print_nstack_r stack '(31 2 9 11))
                  (ps 2 15 (string/format "%27d" (tonumber entry-number)))
                  (sc 31 15))))



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



((.> mode :draw))
(while-true
 (let* [(action (get-key))]
   (cond
     ((= action (.> buttons :EXIT)) ((.> (require :os) :exit)))
     ((= action (.> buttons :MENU)) (print! "still working on menu :)"))
     ((.> mode action) ((.> mode action)))
     (true nil))
   ((.> mode :draw))))
