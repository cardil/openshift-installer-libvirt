#!/bin/bash

include facts/bash.bash
include logger.bash

function validate.bash-version {
  if (( BASH_MAJOR_VERSION < 4 )); then
    logger.error "BASH version >= 4 is required, running on ${BASH_VERSION}"
    exit 1
  fi
}
