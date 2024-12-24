#!/usr/bin/env bash

#
# Set a new message in log history.
#
# @param string $1
# Message to be stored.
#
# @return void
shellNS_log_write() {
  if [ "${1}" != "" ]; then
    SHELLNS_LOG_HISTORY+=("${1}")

    if [ "${#SHELLNS_LOG_HISTORY[@]}" -gt "${SHELLNS_LOG_MAXLENGTH}" ]; then
      local i="0"
      local -a arrNewHistory=()
      for i in "${!SHELLNS_LOG_HISTORY[@]}"; do
        if [ "${i}" -ge "${SHELLNS_LOG_RECYCLE_LENGTH}" ]; then
          arrNewHistory+=("${SHELLNS_LOG_HISTORY[${i}]}")
        fi
      done

      SHELLNS_LOG_HISTORY=("${arrNewHistory[@]}")
    fi
  fi
}