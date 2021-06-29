(in-package :cl-pokedex)

(defmacro page (title &body body)
  `(spinneret:with-html-string
     (:doctype)
     (:html
      :lang "en"
      (:head
       (:meta :name "viewport"
              :content "width=device-width, initial-scale=1")
       (:link :rel "stylesheet"
              :href "https://unpkg.com/blocks.css/dist/blocks.min.css"
              :media "screen")
       (:title ,title " (CL-Pokedex)"))
      (:body ,@body))))
