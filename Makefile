bin/cl-pokedex: bin cl-pokedex.asd package.lisp src/*.lisp
	sbcl --noinform --disable-ldb --lose-on-corruption --end-runtime-options \
		--non-interactive --load build.lisp \
		bin/cl-pokedex

bin:
	mkdir bin

.PHONY: image
image:
	podman build -t cl-pokedex:latest .
