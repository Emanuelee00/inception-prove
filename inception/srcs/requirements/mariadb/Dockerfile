FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends mariadb-server && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 3306

COPY conf/my.cnf /etc/mysql/mariadb.conf.d/60-server.cnf

ENTRYPOINT ["/init.sh"]
