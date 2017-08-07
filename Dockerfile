FROM alpine:3.6 as build

RUN apk --update add curl

ARG HUGO_VERSION
ENV HUGO_DL https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz
RUN curl -fsSL ${HUGO_DL} | tar xvz -C /usr/local/bin

FROM scratch
COPY --from=build /usr/local/bin/hugo /hugo
EXPOSE 1313
ENTRYPOINT ["/hugo"]
