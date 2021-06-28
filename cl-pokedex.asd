(asdf:defsystem :cl-pokedex
  :description "A simple Web-app that works with data from the PokeAPI"
  :version "0.1.0"
  :author "astynax"
  :license "MIT"
  :depends-on ("hunchentoot"
               "cl-who"
               "dbi")
  :serial t
  :components ((:file "package")
               (:module "src"
                :serial t
                :components ((:file "db")
                             (:file "pokeapi")
                             (:file "markup")
                             (:file "server")
                             (:file "main")))))
