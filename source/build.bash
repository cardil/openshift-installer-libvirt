#!/usr/bin/env bash

include checkout.bash
include logger.bash
include exec/executor.bash
include facts/ocp.bash

function build {
  validate.golang-version
  local version release builddir
  version="${OCP_VERSION:?}"
  release=$(__calculate_release "${version}")
  logger.info "Checkout of Openshift Installer - ${release}"
  checkout.installer "${release}"

  logger.info "Building installer for ${version}"
  builddir="${GOPATH}/src/github.com/openshift/installer"
  logger.debug "Build dir: ${builddir}"
  pushd "${builddir}" || exit
  executor.stream "RELEASE_IMAGE=quay.io/openshift-release-dev/ocp-release:${version} TAGS=libvirt hack/build.sh"
}

function __calculate_release {
  local version
  version="${1}"
  major=$(echo "${version}" | cut -d '.' -f 1)
  minor=$(echo "${version}" | cut -d '.' -f 2)
  echo "release-${major}.${minor}"
}
