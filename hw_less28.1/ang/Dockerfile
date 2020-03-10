FROM alpine:latest
RUN apk add nodejs npm && npm install -g @angular/cli                                                                                                   
COPY [ "entrypoint.sh","entrypoint.sh" ]                                                                                                                    
CMD [ "./entrypoint.sh" ]                                                                                                                                   
