#!/usr/bin/env bash

include logger.bash
include facts/bash.bash

if (( BASH_MAJOR_VERSION >= 5 )) || (( BASH_MINOR_VERSION >= 2 )); then
  declare -gA __facts_facts
fi
export __facts_facts_names
__facts_facts_names=()

function facts.set {
  if (( BASH_MAJOR_VERSION >= 5 )) || (( BASH_MINOR_VERSION >= 2 )); then
    facts.modern.set "$1" "$2"
  else
    facts.legacy.set "$1" "$2"
  fi
}

function facts.get {
  if (( BASH_MAJOR_VERSION >= 5 )) || (( BASH_MINOR_VERSION >= 2 )); then
    facts.modern.get "$1"
  else
    facts.legacy.get "$1"
  fi
}

function facts.modern.set {
  local key
  key="$1"
  local value
  value="$2"
  __facts_facts[$key]="${value}"
  __facts_facts_names+=($key)
}

function facts.modern.get {
  local key
  key="$1"
  local value
  value=${__facts_facts[$key]}
  if [[ "${value}-X" == "-X" ]]; then
    logger.error "Fact ${key} is not known!"
    exit 166
  fi
  echo "${value}"
}

function facts.legacy.set {
  local key="$1"
  local value="$2"

  eval "export __facts_facts_${key} && __facts_facts_${key}='${value}'"
  __facts_facts_names+=($key)
}

function facts.legacy.get {
  local key
  key="$1"
  local fact_value_name
  fact_value_name="__facts_facts_${key}"

  local value

  value="${!fact_value_name}"
  if [[ "${value}-X" == "-X" ]]; then
    logger.error "Fact ${key} is not known!"
    exit 166
  fi
  echo "${value}"
}

function facts.list.known {
  echo "${__facts_facts_names[@]}"
}

include facts/os.bash
