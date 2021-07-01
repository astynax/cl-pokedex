(ql:quickload :cl-pokedex)

(let ((target (car (uiop/image:command-line-arguments))))
  (unless target
    (uiop:die 1 "Provide a file name!"))
  (sb-ext:save-lisp-and-die
    target
    :purify t
    :toplevel 'cl-pokedex:main
    :executable t))
