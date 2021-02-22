FROM postgres:10.5-alpine

COPY postgres/entrypoint.sh /
COPY postgres/setup-master.sh /docker-entrypoint-initdb.d/setup-master.sh

RUN chmod +x /docker-entrypoint-initdb.d/setup-master.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["postgres"]
