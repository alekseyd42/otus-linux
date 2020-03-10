FROM alpine:latest

RUN apk add php php-fpm php-zip php-tokenizer php-dom php-fileinfo \
    php-xmlwriter php-xml composer php-session && \
    sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/' /etc/php7/php.ini && \
    ln -sf /dev/stderr /var/log/php7/error.log && \
    sed -i 's/listen = 127.0.0.1:9000/listen = 9000/' /etc/php7/php-fpm.d/www.conf && \
    composer global require laravel/installer && \
    sed -i 's/export PATH=\/usr\/local\/sbin:\/usr\/local\/bin:\/usr\/sbin:\/usr\/bin:\/sbin:\/bin/export PATH=\/usr\/local\/sbin:\/usr\/local\/bin:\/usr\/sbin:\/usr\/bin:\/sbin:\/bin:$HOME\/.composer\/vendor\/bin/' /etc/profile 
    #&& \
    #source /etc/profile
COPY [ "Start.sh", "Start.sh" ]

CMD [ "./Start.sh" ]