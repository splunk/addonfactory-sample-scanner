#!/usr/bin/env bash
echo ScanDir=$ScanDir
go-earlybird  -show-solutions -suppress -config=/.go-earlybird/  -ignorefile=/.ge_ignore -path=${INPUT_PATH}/${INPUT_SCANDIR} ${INPUT_ARGS}