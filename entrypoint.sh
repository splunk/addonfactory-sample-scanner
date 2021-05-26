#!/usr/bin/env bash
echo ScanDir=$ScanDir
go-earlybird  -show-solutions -suppress -config=/.go-earlybird/  -ignorefile=/.ge_ignore -path=/github/workspace/${INPUT_SCANDIR} ${INPUT_ARGS}