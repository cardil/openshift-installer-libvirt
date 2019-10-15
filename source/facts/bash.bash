#!/usr/bin/env bash

BASH_VERSION=$(LANG=C bash --version | grep 'GNU bash' | awk '{print $4}')
BASH_MAJOR_VERSION=$(echo "${BASH_VERSION}" | cut -d '.' -f 1)
BASH_MINOR_VERSION=$(echo "${BASH_VERSION}" | cut -d '.' -f 2)

export BASH_VERSION BASH_MAJOR_VERSION BASH_MINOR_VERSION
