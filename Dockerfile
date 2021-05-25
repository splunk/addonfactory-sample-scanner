FROM registry.access.redhat.com/ubi8:8.4-199

COPY earlybird/binaries/go-earlybird-linux /bin/go-earlybird
COPY earlybird/.ge_ignore /
COPY earlybird/config /.go-earlybird
COPY config /.go-earlybird

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]