(in-package :cl-pokedex)

(defun exit-cleanly ()
  "Shutdown and quit."
  (stop)
  (uiop:quit 0))

(defun exit-with-backtrace (c)
  "Print the backtrace and exit."
  (stop)
  (uiop:print-condition-backtrace c :count 15)
  (uiop:quit 1))

(defun handle-conditions (c)
  "On Ctrl-C, exit. Otherwise print backtrace and exit."
  (typecase c
    (sb-sys:interactive-interrupt (exit-cleanly))
    (t (exit-with-backtrace c))))

(defun stop ()
  (stop-server)
  (stop-db))

(defun start (&key (port 8000))
  (start-db)
  (start-server :port port))

(defun main ()
  "Entry point for command-line execution."
  (declare (ignore argv))
  (handler-bind
      ((serious-condition #'handle-conditions))
    (start)
    (format t "Ctrl-C to exit.~%")
    (loop (sleep 1))))
