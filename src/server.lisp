(in-package :cl-pokedex)

(defvar *acceptor* nil)

(defun stop ()
  (when *acceptor*
    (hunchentoot:stop *acceptor*)
    (setf *acceptor* nil)))

(defun start (&key (port 8000))
  (stop)
  (let ((new-acceptor (make-instance 'hunchentoot:easy-acceptor :port port)))
    (hunchentoot:start new-acceptor)
    (setf *acceptor* new-acceptor)))

(hunchentoot:define-easy-handler (index :uri "/") ()
  (setf (hunchentoot:content-type*) "text/html")
  (cl-who:with-html-output-to-string (s nil :indent t
                                            :prologue t)
    (:html
     (:head
      (:title "Index"))
     (:body
      (:h2 "Hi there!")
      (:ul
       (dolist (i '(1 2 3 4 5))
         (cl-who:htm
          (:li (cl-who:fmt "~A" i)))))))))
