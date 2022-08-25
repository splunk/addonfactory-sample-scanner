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

echo "GITHUB_JOB = $GITHUB_JOB"
echo "GITHUB_REF = $GITHUB_REF"
echo "GITHUB_SHA = $GITHUB_SHA"
echo "GITHUB_REPOSITORY = $GITHUB_REPOSITORY"
echo "GITHUB_REPOSITORY_OWNER = $GITHUB_REPOSITORY_OWNER"
echo "GITHUB_RUN_ID = $GITHUB_RUN_ID"
echo "GITHUB_RUN_NUMBER = $GITHUB_RUN_NUMBER"
echo "GITHUB_RETENTION_DAYS = $GITHUB_RETENTION_DAYS"
echo "GITHUB_RUN_ATTEMPT = $GITHUB_RUN_ATTEMPT"
echo "GITHUB_ACTOR = $GITHUB_ACTOR"
echo "GITHUB_TRIGGERING_ACTOR = $GITHUB_TRIGGERING_ACTOR"
echo "GITHUB_WORKFLOW = $GITHUB_WORKFLOW"
echo "GITHUB_HEAD_REF = $GITHUB_HEAD_REF"
echo "GITHUB_BASE_REF = $GITHUB_BASE_REF"
echo "GITHUB_EVENT_NAME = $GITHUB_EVENT_NAME"
echo "GITHUB_SERVER_URL = $GITHUB_SERVER_URL"
echo "GITHUB_API_URL = $GITHUB_API_URL"
echo "GITHUB_GRAPHQL_URL = $GITHUB_GRAPHQL_URL"
echo "GITHUB_REF_NAME = $GITHUB_REF_NAME"
echo "GITHUB_REF_PROTECTED = $GITHUB_REF_PROTECTED"
echo "GITHUB_REF_TYPE = $GITHUB_REF_TYPE"
echo "GITHUB_WORKSPACE = $GITHUB_WORKSPACE"
echo "GITHUB_ACTION = $GITHUB_ACTION"
echo "GITHUB_EVENT_PATH = $GITHUB_EVENT_PATH"
echo "GITHUB_ACTION_REPOSITORY = $GITHUB_ACTION_REPOSITORY"
echo "GITHUB_ACTION_REF = $GITHUB_ACTION_REF"
echo "GITHUB_PATH = $GITHUB_PATH"
echo "GITHUB_ENV = $GITHUB_ENV"
echo "GITHUB_STEP_SUMMARY = $GITHUB_STEP_SUMMARY"

echo "event name: $GITHUB_EVENT_NAME"
echo "INPUT REPORTER: $INPUT_REPORTER"

if [ -z ${INPUT_REPORTER+x} ];
then
    if [ $GITHUB_EVENT_NAME = "schedule" ]
    then
        echo "local"
        export REPORTER=local
    elif [ -z ${GITHUB_BASE_REF+x} ];
    then
        echo "github-pr-review"
        export REPORTER=github-pr-review
    else
        echo "github-check"
        export REPORTER=github-check
    fi
else
    export REPORTER=$INPUT_REPORTER
fi

echo "reporter: $REPORTER"
export REPORTER="github-check"
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
