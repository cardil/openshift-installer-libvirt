#!/usr/bin/env bash

include facts.bash
include logger.bash

function facts.os.resolve {
  if [ -f /etc/redhat-release ]; then
    facts.set 'osfamily' 'RedHat'
    facts.os.redhat.resolve
  elif [ -f /etc/debian_version ]; then
    facts.set 'osfamily' 'Debian'
    facts.os.debian.resolve
  else
    logger.error 'Unsupported OS Family. Supported families are: RedHat and Debian'
    exit 5
  fi
  local major
  major=$(facts.get 'operatingsystemrelease' | cut -d '.' -f 1)
  facts.set 'operatingsystemmajrelease' $major
}

function facts.os.debian.resolve {
  if [ -f /etc/lsb-release ]; then
    source /etc/lsb-release
    facts.set 'operatingsystem' $DISTRIB_ID
    facts.set 'operatingsystemrelease' $DISTRIB_RELEASE
  else
    facts.set 'operatingsystem' 'Debian'
    facts.set 'operatingsystemrelease' $(cat /etc/debian_version)
  fi
}

function facts.os.redhat.resolve {
  # https://regex101.com/r/Uvm9bs/3
  local RHEL_SED_VERSION_PARSE
  RHEL_SED_VERSION_PARSE='s/^[^0-9]+([0-9]+(\.[0-9]+)?).*$/\1/'
  local version
  if [ -f /etc/oracle-release ]; then
    facts.set 'operatingsystem' 'OracleLinux'
    version=$(cat /etc/oracle-release | sed -E $RHEL_SED_VERSION_PARSE)
  elif [ -f /etc/centos-release ]; then
    facts.set 'operatingsystem' 'CentOS'
    version=$(cat /etc/centos-release | sed -E $RHEL_SED_VERSION_PARSE)
  elif [ -f /etc/fedora-release ]; then
    facts.set 'operatingsystem' 'Fedora'
    version=$(cat /etc/fedora-release | sed -E $RHEL_SED_VERSION_PARSE)
  else
    facts.set 'operatingsystem' 'RedHat'
    version=$(cat /etc/redhat-release | sed -E $RHEL_SED_VERSION_PARSE)
  fi
  facts.set 'operatingsystemrelease' $version
}

facts.os.resolve
