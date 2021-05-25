#!/usr/bin/env bash

go-earlybird  -show-solutions -suppress -config=/.go-earlybird/  -ignorefile=/.ge_ignore -path=$(pwd)/${INPUT_SCANDIR} ${INPUT_ARGS}