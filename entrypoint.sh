#!/usr/bin/env bash

go-earlybird  -show-solutions -suppress -config=/.go-earlybird/  -ignorefile=/.ge_ignore -path=$GITHUB_WORKSPACE/${INPUT_SCANDIR} ${INPUT_ARGS}