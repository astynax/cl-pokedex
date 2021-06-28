(ql:quickload :cl-pokedex)

(sb-ext:save-lisp-and-die
 "bin/cl-pokedex"
 :toplevel 'cl-pokedex:main
 :executable t)
