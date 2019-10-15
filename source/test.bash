#!/usr/bin/env bash

include logger.bash
include exec/executor.bash
include facts/ocp.bash

function test.installer {
  local builddir imagename
  builddir="build"
  pushd "${builddir}" || exit
  logger.info "Testing version of build binary"
  imagename="$(executor.capture "./openshift-install | grep "release image" | grep \"${OCP_VERSION}\"")"
  if [ -z "${imagename}" ]; then
    logger.error "Build binary should contain OCP version ${OCP_VERSION}!"
    exit 3
  fi
  popd || exit
  logger.success "Proper version found: ${OCP_VERSION}"
  logger.debug "Version: ${imagename}"
}
