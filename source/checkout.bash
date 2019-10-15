#!/usr/bin/env bash

include validation/golang.bash
include exec/executor.bash

function checkout.installer {
  local version
  version="$1"
  validate.golang-version
  executor.stream "rm -rf ${GOPATH}/src/github.com/openshift/installer"
  executor.stream "git clone https://github.com/openshift/installer.git ${GOPATH}/src/github.com/openshift/installer --branch ${version}"
}
