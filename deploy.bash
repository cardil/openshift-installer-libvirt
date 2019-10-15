#!/usr/bin/env bash
#
# by Chris Suszynski, ksuszyns@redhat.com

set -Eeo pipefail

REPODIR="$( dirname "${BASH_SOURCE[0]}" )"
# shellcheck source=source/loader.bash
source "${REPODIR}/source/loader.bash"

loader_flag "${BASH_SOURCE[0]}"
loader_addpath "${REPODIR}/source"

include ui/welcome.bash
include deploy.bash

loader_finish

set -u

deploy.create-manifest
