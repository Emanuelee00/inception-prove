FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends\
    php-fpm php-mysql wget curl mariadb-client \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/setup.sh /setup.sh
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY cosmos-landing.html /cosmos-landing.html

RUN chmod +x /setup.sh

EXPOSE 9000

ENTRYPOINT ["/setup.sh"]
