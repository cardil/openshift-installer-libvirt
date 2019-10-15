#!/usr/bin/env bash

GOLANG_VERSION=$(LANG=C go version | awk '{print $3}')
GOLANG_VERSION="${GOLANG_VERSION:2}"

export GOLANG_VERSION
