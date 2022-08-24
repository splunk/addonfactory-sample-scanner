#!/usr/bin/env bash
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
#   ######################################################################## export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

WORKSPACE_DIR=/github/workspace
FALSE_POSITIVE_FILE="${WORKSPACE_DIR}/.false-positives.yaml"
CUSTOM_IGNORE_FILE="${WORKSPACE_DIR}/.ge_ignore"
IGNORE_FILE="/.ge_ignore"

if [ -d ".go-earlybird" ]; then
    cp -f .go-earlybird/* /.go-earlybird/
fi

if [ -f "${FALSE_POSITIVE_FILE}" ]; then
    echo "Adding exceptions from ${FALSE_POSITIVE_FILE} file"
    cp "${FALSE_POSITIVE_FILE}" /.go-earlybird/falsepositives
fi

if [ -f "${CUSTOM_IGNORE_FILE}" ]; then
    echo "Adding files from custom ignorefile to ${IGNORE_FILE}"
    cat "${CUSTOM_IGNORE_FILE}" >> "${IGNORE_FILE}"
fi

echo ::group::scanner_output
go-earlybird  -show-solutions -suppress -config=/.go-earlybird/ -ignorefile="${IGNORE_FILE}" \
    -path=${WORKSPACE_DIR}/${INPUT_WORKDIR} ${INPUT_ARGS} || true
echo "::endgroup::"
echo ::group::reviewdog_output

echo "event name: $GITHUB_EVENT_NAME"

if [ -z ${INPUT_REPORTER+x} ];
then
    if [ $GITHUB_EVENT_NAME = "schedule" ]
    then
        export REPORTER=local
    elif [ -z ${GITHUB_BASE_REF+x} ];
    then
        export REPORTER=github-pr-review
    else
        export REPORTER=github-check
    fi
else
    export REPORTER=$INPUT_REPORTER
fi

echo "reporter: $REPORTER"
go-earlybird  -show-solutions -suppress -config=/.go-earlybird/ -ignorefile="${IGNORE_FILE}" \
    -path=${WORKSPACE_DIR}/${INPUT_WORKDIR} -format=json ${INPUT_ARGS} \
    | python3 /annotate.py \
    | reviewdog -f=rdjson  \
      -name="addonfactory-sample-scanner" \
      -reporter="${REPORTER:-github-check}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS} ; exitCode=$?

echo "::endgroup::"

exit $exitCode
