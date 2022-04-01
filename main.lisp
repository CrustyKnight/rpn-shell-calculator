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
  (.<! numbers "h" 0)
  (.<! numbers "t" 1)
  (.<! numbers "n" 2)
  (.<! numbers "s" 3))


(define func_symbols '(
                       '("add" "min"  "mul" "div"  "pow"  "sqrt"  "sqr"  "inv")
                       '("sin" "cos"  "tan" "_NIL" "asin" "acos" "atan" "_NIL")
                       '("log" "10xp" "ln"  "exp"  "fac"  "_NIL" "_NIL" "_NIL")))
(defun factorial (n) (cond
                       [(<= n 0) 1]
                       [true (* n (factorial (- n 1)))]))
(define symbol_funcs! :mutable {})
(progn
  (.<! symbol_funcs! "add"   (lambda (s) (push! s
                                                   (+ (pop-last! s)
                                                      (pop-last! s)))))
  (.<! symbol_funcs! "min"   (lambda (s) (let [(b (pop-last! s)) (a (pop-last! s))] (push! s (- a b)))))
  (.<! symbol_funcs! "mul"   (lambda (s) (push! s
                                                   (* (pop-last! s)
                                                      (pop-last! s)))))
  (.<! symbol_funcs! "div"   (lambda (s) (let ((b (pop-last! s)) (a (pop-last! s))) (push! s (/ a b)))))
  (.<! symbol_funcs! "pow"   (lambda (s) (let ((b (pop-last! s)) (a (pop-last! s))) (push! s (expt a b)))))
  (.<! symbol_funcs! "sqrt"  (lambda (s) (push! s
                                                   (math/sqrt (pop-last! s)))))
  (.<! symbol_funcs! "sqr"   (lambda (s) (push! s
                                                   (expt (pop-last! s) 2))))
  (.<! symbol_funcs! "inv"   (lambda (s) (push! s
                                                   (/ 1 (pop-last! s)))))
  (.<! symbol_funcs! "sin"   (lambda (s) (push! s
                                                   (math/sin (pop-last! s)))))
  (.<! symbol_funcs! "cos"   (lambda (s) (push! s
                                                   (math/cos (pop-last! s)))))
  (.<! symbol_funcs! "tan"   (lambda (s) (push! s
                                                   (math/tan (pop-last! s)))))
  (.<! symbol_funcs! "asin"  (lambda (s) (push! s
                                                   (math/asin (pop-last! s)))))
  (.<! symbol_funcs! "acos"  (lambda (s) (push! s
                                                   (math/acos (pop-last! s)))))
  (.<! symbol_funcs! "atan"  (lambda (s) (push! s
                                                   (math/atan (pop-last! s)))))
  (.<! symbol_funcs! "log10" (lambda (s) (push! s
                                                   (math/log (pop-last! s) 10))))
  (.<! symbol_funcs! "10xp"  (lambda (s) (push! s
                                                   (expt 10 (pop-last! s)))))
  (.<! symbol_funcs! "ln"    (lambda (s) (push! s
                                                   (math/log (pop-last! s)))))
  (.<! symbol_funcs! "exp"   (lambda (s) (push! s
                                                   (math/exp (pop-last! s)))))
  (.<! symbol_funcs! "fac"   (lambda (s) (push! s
                                                   (factorial (pop-last! s)))))
  (.<! symbol_funcs! "_NIL"  (lambda (s) nil)))



; stack is just a list. end of the list is the top of the stack
; area is a list with for values: '(x y width height)
;; x and y are the coordinates of the top character
;; units for x,y,w,h are in characters
; note: width limit is 54
(defun print_stack (s area)
  ; basically, print the list straight down from the top, but start with end - height + 1
  (let* ((x (nth area 1))
         (y (nth area 2))
         (w (nth area 3))
         (h (nth area 4)))
    (with (start (- (+ 1 (n s)) h))
          (for i start (n s) 1
               (ps x (- i start) (string/sub (tostring (nth s i)) 1 w))))))
(defun print_nstack_r (s area)
  (let* ((x (nth area 1))
         (y (nth area 2))
         (w (nth area 3))
         (h (nth area 4)))
    (with (start (- (n s) h))
          (for i start (n s) 1
               (if (< (string/len (tostring (nth s i))) w)
                   (ps x (+ y (- i start))
                       (string/format (.. "%" w "d") (nth s i)))
                   (ps x (+ y (- i start))
                       (string/format (.. "%1." (- w 7) "e") (nth s i)))

                   )))))

;returns a digit
;; basically, the first four characters (a o e u) are the first base 4 digit, and the second four (h t n s) are the second digit
(defun number_entry ()
  (ps 3 3   "[a] 16")
  (ps 3 4   "[o] 12")
  (ps 3 5   "[e] 08")
  (ps 3 6   "[u] 04")
  (ps 10 3  "[h] 00")
  (ps 10 4  "[t] 01")
  (ps 10 5  "[n] 02")
  (ps 10 6  "[s] 03")
  (ps 31 15 "   ")
  (sc 31 15)
  (with (str (io/read :*l))
        (let [
          (a (string/sub str 1 1))
          (b (string/sub str 2 2))]
          (print! a b)
          (+ (.> numbers a) (.> numbers b)))
        ))

(defun symbol_entry (l s)
  (ps 3 3   (.. "[a] " (nth (nth func_symbols l) 1)))
  (ps 3 4   (.. "[o] " (nth (nth func_symbols l) 2)))
  (ps 3 5   (.. "[e] " (nth (nth func_symbols l) 3)))
  (ps 3 6   (.. "[u] " (nth (nth func_symbols l) 4)))
  (ps 12 3  (.. "[h] " (nth (nth func_symbols l) 5)))
  (ps 12 4  (.. "[t] " (nth (nth func_symbols l) 6)))
  (ps 12 5  (.. "[n] " (nth (nth func_symbols l) 7)))
  (ps 12 6  (.. "[s] " (nth (nth func_symbols l) 8)))
  (ps 7 7   (.. "[ ] " "Next"))
  (with (str (io/read "*l"))
        (cond
          [(= str "a") ((.> symbol_funcs! (nth (nth func_symbols l) 1)) s)]
          [(= str "o") ((.> symbol_funcs! (nth (nth func_symbols l) 2)) s)]
          [(= str "e") ((.> symbol_funcs! (nth (nth func_symbols l) 3)) s)]
          [(= str "u") ((.> symbol_funcs! (nth (nth func_symbols l) 4)) s)]
          [(= str "h") ((.> symbol_funcs! (nth (nth func_symbols l) 5)) s)]
          [(= str "t") ((.> symbol_funcs! (nth (nth func_symbols l) 6)) s)]
          [(= str "n") ((.> symbol_funcs! (nth (nth func_symbols l) 7)) s)]
          [(= str "s") ((.> symbol_funcs! (nth (nth func_symbols l) 8)) s)]
          [(= str " ") (symbol_entry)]
          ))
  nil)


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
     (lambda () (symbol_entry 1)))
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
