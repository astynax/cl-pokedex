(in-package :cl-pokedex)

;; lifetime

(defvar *acceptor* nil)

(defun stop ()
  (when *acceptor*
    (hunchentoot:stop *acceptor*)
    (setf *acceptor* nil)))

(defun start (&key (port 8000))
  (stop)
  (hunchentoot:start
   (setf *acceptor*
         (make-instance 'hunchentoot:easy-acceptor :port port))))

;; handlers

(hunchentoot:define-easy-handler (index :uri "/") ()
  (page "Index"
    (:main
     (:h2 "Hi there!")
     (:ul
      (dolist (i '(1 2 3 4 5))
        (cl-who:htm
         (:li :class "fixed block"
              (cl-who:fmt "~A" i)
              (:button :class "inline block"
                       "+"))))))))
