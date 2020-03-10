FROM alpine:latest

RUN apk add python3 uwsgi uwsgi-python3 curl iproute2 && pip3 install django

COPY [ "entrypoint.sh" , "entrypoint.sh" ]

CMD [ "./entrypoint.sh" ]