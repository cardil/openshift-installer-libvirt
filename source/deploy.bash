#!/usr/bin/env bash

include logger.bash
include exec/executor.bash
include facts/ocp.bash

function deploy.create-manifest {
  local builddir now
  builddir="build"
  pushd "${builddir}" || exit
  logger.info "Creating deployment descriptor for Bintray"
  now=$(date +%Y-%m-%d)
  cat > bintray.json <<EOF
{
  "package": {
    "name": "openshift-installer",
    "repo": "openshift-installer-libvirt",
    "subject": "wavesoftware",
    "desc": "A automated build artifact for libvirt capable openshift installer",
    "website_url": "https://github.com/cardil/openshift-installer-libvirt",
    "issue_tracker_url": "https://github.com/cardil/openshift-installer-libvirt/issues",
    "vcs_url": "https://github.com/cardil/openshift-installer-libvirt.git",
    "github_use_tag_release_notes": false,
    "licenses": ["Apache-2.0"],
    "labels": ["openshift", "installer", "libvirt"],
    "public_download_numbers": true,
    "public_stats": true
  },

  "version": {
      "name": "${OCP_VERSION}",
      "released": "${now}",
      "gpgSign": false
  },

  "files": [
    {
      "includePattern": "build/openshift-install",
      "uploadPattern": "openshift-install",
      "matrixParams": { "override": 1 }
    }
  ],
  "publish": true
}
EOF
  popd || exit
  if [ -f "${builddir}/bintray.json" ]; then
    executor.stream "stat \"${builddir}/bintray.json\""
    logger.success "Deployment descriptor created"
  else
    logger.error 'Deployment descriptor not found!'
    exit 4
  fi
}
