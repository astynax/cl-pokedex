(in-package :cl-pokedex)

;; lifetime

(defvar *acceptor* nil)

(defun stop-server ()
  (when *acceptor*
    (hunchentoot:stop *acceptor*)
    (setq *acceptor* nil)))

(defun start-server (&key port)
  (stop-server)
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
            (dolist (type (@ p :types))
              (:span.inline.round.fixed.accent.block type)))
           (:p
            (iter (for (alt . url) in (@ p :sprites))
              (:span.fixed.wrapper.block
               (:img :src url
                     :alt alt)))))))
      (page "Pokemons"
        (:main
         (:h1 "Pokemons")
         (:ul
          (dolist (p (list-pokemon))
            (let ((name (@ p "name")))
              (:li (:a :href (format nil "/?name=~A" name)
                       name)))))))))
