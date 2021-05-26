#!/usr/bin/env bash
set -e
export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo ::group::scanner_output
go-earlybird  -show-solutions -suppress -config=/.go-earlybird/  -ignorefile=/.ge_ignore -path=/github/workspace/${INPUT_WORKDIR} ${INPUT_ARGS}
echo "::endgroup::"
echo ::group::reviewdog_output

go-earlybird  -show-solutions -suppress -config=/.go-earlybird/  -ignorefile=/.ge_ignore -path=/github/workspace/${INPUT_WORKDIR} -format=json \
    ${INPUT_ARGS} \    
    | python3 /annotate.py \
    | reviewdog -f=rdjson  \
      -name="linter-name (addonfactory-sample-scanner)" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}

echo "::endgroup::"
