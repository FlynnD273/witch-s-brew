#!/usr/bin/env bash

find . -name "*.dtl" -exec sed 's/…/[lspeed=0.1]...[lspeed] /g' -i {} \;
