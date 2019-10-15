#!/bin/bash

include lang/version.bash
include facts/golang.bash
include logger.bash

function validate.golang-version {
  local matching
  matching=$(version.match "${GOLANG_VERSION}" "gt" "1.12")
  if [ "$matching" == "false" ]; then
    logger.error "Go version >= 1.13 is required, running on ${GOLANG_VERSION}"
    exit 2
  fi
  if [ -z "$GOPATH" ]; then
    logger.error "Go path must be set!"
  fi
}
