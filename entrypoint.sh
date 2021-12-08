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

git clone https://github.com/americanexpress/earlybird.git
cd earlybird
./build.sh
cp binaries/go-earlybird-linux /bin/go-earlybird
cd ..
pwd

cp earlybird/.ge_ignore .
cp -r earlybird/config .go-earlybird

if [ -d ".go-earlybird" ]; then
 cp -f -r .go-earlybird/* /.go-earlybird/
fi

ls -la /.go-earlybird/
cat /.go-earlybird/false-positives.json

echo ::group::scanner_output
go-earlybird  -show-solutions -suppress -config=/.go-earlybird/  -ignorefile=/.ge_ignore -path=/github/workspace/${INPUT_WORKDIR} ${INPUT_ARGS} || true
echo "::endgroup::"
echo ::group::reviewdog_output

if [ -z ${INPUT_REPORTER+x} ];
then
    if [ -z ${GITHUB_BASE_REF+x} ];
    then
        export REPORTER=github-pr-review
    else
        export REPORTER=github-check
    fi
else
    export REPORTER=$INPUT_REPORTER
fi

go-earlybird  -show-solutions -suppress -config=/.go-earlybird/  -ignorefile=/.ge_ignore \
    -path=/github/workspace/${INPUT_WORKDIR} -format=json ${INPUT_ARGS} \
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
