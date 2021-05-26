#!/usr/bin/env bash
echo ::group::scanner_output
go-earlybird  -show-solutions -suppress -config=/.go-earlybird/  -ignorefile=/.ge_ignore -path=/github/workspace/${INPUT_SCANDIR} ${INPUT_ARGS}
go-earlybird  -show-solutions -suppress -config=/.go-earlybird/  -ignorefile=/.ge_ignore -path=/github/workspace/${INPUT_SCANDIR} -format=json -file=/tmp/sample-scanner.json ${INPUT_ARGS}
python3 /annotate.py 
echo "::endgroup::"