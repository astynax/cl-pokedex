(in-package :cl-pokedex)

(defmacro page (title &body body)
  `(progn
     (setf (hunchentoot:content-type*) "text/html")
     (cl-who:with-html-output-to-string (s nil :indent t :prologue t)
       (:html
        :lang "en"
        (:head
         (:meta :charset "UTF-8")
         (:meta :name "viewport"
                :content "width=device-width, initial-scale=1")
         (:link :rel "stylesheet"
                :href "https://unpkg.com/blocks.css/dist/blocks.min.css"
                :media "screen")
         (:title ,title))
        (:body
         ,@body)))))
