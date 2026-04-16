FROM debian:bullseye

RUN apt-get update && apt-get install -y --no-install-recommends nginx openssl\
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 \
-newkey rsa:2048 \
-keyout /etc/nginx/ssl/nginx.key \
-out /etc/nginx/ssl/nginx.crt \
-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=localhost"

COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
