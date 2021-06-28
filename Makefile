bin/cl-pokedex: bin *.asd *.lisp src/*.lisp
	sbcl --non-interactive --load build.lisp

bin:
	mkdir bin
