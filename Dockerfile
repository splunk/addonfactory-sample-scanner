#   ########################################################################
#   Copyright 2021 Splunk Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#   ######################################################################## 
FROM registry.access.redhat.com/ubi8:8.4-199

RUN dnf install go git wget python3.8 -y
ENV REVIEWDOG_VERSION=v0.11.0
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

COPY earlybird/binaries/go-earlybird-linux /bin/go-earlybird
COPY earlybird/.ge_ignore /
COPY earlybird/config /.go-earlybird
COPY config/default-false-positives.yaml /.go-earlybird/falsepositives

COPY entrypoint.sh /entrypoint.sh
COPY annotate.py /

ENTRYPOINT ["/entrypoint.sh"]
