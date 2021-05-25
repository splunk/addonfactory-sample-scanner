FROM registry.access.redhat.com/ubi8:8.4-199

COPY earlybird/binaries/go-earlybird-linux /bin/go-earlybird
COPY earlybird/.ge_ignore /root/.ge_ignore
COPY earlybird/config /root/.go-earlybird
COPY config /root/.go-earlybird

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]