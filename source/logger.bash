#!/bin/bash

include lang/array.bash
include ui/colors.bash

LOG_LEVEL=${LOG_LEVEL:-INFO}

function logger.__should-print {
  local level
  level="$1"
  local log_levels
  log_levels=('DEBUG' 'INFO' 'WARN' 'ERROR')
  declare -A log_level_values=( ['DEBUG']=1 ['INFO']=2 ['WARN']=3 ['ERROR']=4 )

  if ! array.contains "$LOG_LEVEL" "${log_levels[@]}"; then
    echo "Given invalid log level: ${LOG_LEVEL}, possible values are: ${log_levels[*]}" 1>&2
    exit 1
  fi
  local int_level
  int_level=${log_level_values[$level]}
  local int_displaying
  int_displaying=${log_level_values[$LOG_LEVEL]}
  (( int_level >= int_displaying ))
}

function logger.debug {
  local message
  message="$*"
  if logger.__should-print 'DEBUG'; then
    echo -e "${COLOR_LIGHT_BLUE}DEBUG: ${message}${COLOR_NC}" 1>&2
  fi
}

function logger.info {
  local message
  message="$*"
  if logger.__should-print 'INFO'; then
    echo -e "${COLOR_GREEN}INFO: ${message}${COLOR_NC}" 1>&2
  fi
}

function logger.success {
  local message
  message="$*"
  if logger.__should-print 'INFO'; then
    echo -e "${COLOR_LIGHT_GREEN}${message}${COLOR_NC}" 1>&2
  fi
}

function logger.warn {
  local message
  message="$*"
  if logger.__should-print 'WARN'; then
    echo -e "${COLOR_YELLOW}WARN: ${message}${COLOR_NC}" 1>&2
  fi
}

function logger.error {
  local message
  message="$*"
  if logger.__should-print 'ERROR'; then
    echo -e "${COLOR_RED}ERROR: ${message}${COLOR_NC}" 1>&2
  fi
}
