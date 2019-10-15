#!/usr/bin/env bash

include logger.bash
include exec/executor.bash
include facts/ocp.bash

function test.installer {
  local builddir imagename
  builddir="${GOPATH}/src/github.com/openshift/installer"
  pushd "${builddir}" || exit
  imagename="$(executor.capture "bin/openshift-installer | grep "release image" | grep \"${OCP_VERSION}\"")"
  if [ -z "${imagename}" ]; then
    logger.error "Build binary should contain OCP version ${OCP_VERSION}!"
    exit 3
  fi
}
