from alpine:3.8 as builder
RUN apk add --no-cache \
        git make
RUN mkdir -p /web/oidc-playground /web/kapi-playground
RUN git clone https://stash.kopano.io/scm/~seisenmann/oidc-playground.git
RUN mv oidc-playground/www/* /web/oidc-playground
RUN git clone https://stash.kopano.io/scm/kc/kapi.git
RUN mv kapi/examples/* /web/kapi-playground
WORKDIR /web/kapi-playground
RUN rm Makefile && ln -s oidc-client-example.html index.html

from halverneus/static-file-server:v1.5.2
env PORT 8888
COPY --from=builder /web /web
