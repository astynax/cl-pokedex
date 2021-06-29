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

(hunchentoot:define-easy-handler (index :uri "/") (name)
  (setf (hunchentoot:content-type*) "text/html")
  (if name
      (let ((p (pokemon name)))
        (page name
          (:div.card.fixed.block
           (:h2 (:a :href "/" "..") " / " name)
           (:p
            (dolist (type (at p :types))
              (:span.inline.round.fixed.accent.block type)))
           (:p
            (iter (for (alt . url) in (at p :sprites))
              (:span.fixed.wrapper.block
               (:img :src url
                     :alt alt)))))))
      (page "Pokemons"
        (:main
         (:h1 "Pokemons")
         (:ul
          (dolist (pokemon (list-pokemon))
            (let ((name (jsown:val pokemon "name")))
              (:li (:a :href (format nil "/?name=~A" name)
                       name)))))))))
