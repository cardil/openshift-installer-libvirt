#!/usr/bin/env bash

include checkout.bash
include logger.bash
include exec/executor.bash
include exec/package.bash
include facts/ocp.bash

function build {
  validate.golang-version
  local version release gobuilddir builddir
  builddir="build"
  version="${OCP_VERSION:?}"
  release=$(__calculate_release "${version}")
  logger.info "Checkout of Openshift Installer - ${release}"
  checkout.installer "${release}"

  logger.info "Installing prerequisites"
  package.install 'libvirt-dev'

  logger.info "Building installer for ${version}"
  gobuilddir="${GOPATH}/src/github.com/openshift/installer"
  logger.debug "Build dir: ${gobuilddir}"
  pushd "${gobuilddir}" || exit
  executor.stream "RELEASE_IMAGE=quay.io/openshift-release-dev/ocp-release:${version} TAGS=libvirt hack/build.sh"
  popd || exit
  executor.stream "mkdir -p ${builddir}"
  executor.stream "cp -v ${gobuilddir}/bin/openshift-install ${builddir}/openshift-install"
}

function __calculate_release {
  local version
  version="${1}"
  major=$(echo "${version}" | cut -d '.' -f 1)
  minor=$(echo "${version}" | cut -d '.' -f 2)
  echo "release-${major}.${minor}"
}
