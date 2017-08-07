FROM alpine:3.6 as build

RUN apk --update add curl

ENV HUGO_VERSION 0.25.1
ENV HUGO_DL https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz
RUN curl -fsSL ${HUGO_DL} | tar xvz -C /usr/local/bin

FROM scratch
COPY --from=build /usr/local/bin/hugo /hugo
ENTRYPOINT ["/hugo"]
