FROM alpine:latest

RUN apk add nginx && \
    mkdir /run/nginx && \
    chown nginx:nginx /run/nginx && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

ENTRYPOINT [ "nginx" ]

CMD [ "-g daemon off;" ]
