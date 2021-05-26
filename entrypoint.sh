#!/usr/bin/env bash
export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

if [-d ".go-earlybird" ]; then
 cp -f .go-earlybird/* /.go-earlybird/
fi

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