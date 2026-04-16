FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    php-fpm php-mysql wget curl mariadb-client \
    && rm -rf /var/lib/apt/lists/*

COPY ./tools/setup.sh /setup.sh
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN chmod +x /setup.sh

EXPOSE 9000

ENTRYPOINT ["/setup.sh"]
