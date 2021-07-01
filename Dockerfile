FROM clfoundation/sbcl:2.1.5 AS fat

ENV QUICKLISP_ADD_TO_INIT_FILE=true
ENV QUICKLISP_CLIENT_VERSION=2021-02-13
ENV QUICKLISP_DIST_VERSION=2021-06-30

RUN /usr/local/bin/install-quicklisp

WORKDIR /usr/src/app

COPY docker/preload.lisp .
RUN sbcl --load preload.lisp

FROM clfoundation/sbcl:2.1.5-slim AS slim

RUN apt-get update
RUN apt-get install libssl1.1 libsqlite3-0

FROM slim

ENV PORT=8000

COPY --from=fat /root/.sbclrc /root/
COPY --from=fat /root/quicklisp /root/quicklisp

RUN mkdir -p /root/.local/share

WORKDIR /root/quicklisp/local-projects/cl-pokedex

COPY . .
RUN sbcl --disable-debugger --load docker/build.lisp /root/cl-pokedex.core

CMD sbcl --noinform --disable-ldb --lose-on-corruption \
    --core /root/cl-pokedex.core \
    --end-runtime-options \
    --disable-debugger --end-toplevel-options
