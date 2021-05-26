FROM registry.access.redhat.com/ubi8:8.4-199

RUN dnf install go git wget python3.8 -y
ENV REVIEWDOG_VERSION=v0.11.0
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

COPY earlybird/binaries/go-earlybird-linux /bin/go-earlybird
COPY earlybird/.ge_ignore /
COPY earlybird/config /.go-earlybird
COPY config /.go-earlybird

COPY entrypoint.sh /entrypoint.sh
COPY annotate.py /

ENTRYPOINT ["/entrypoint.sh"]