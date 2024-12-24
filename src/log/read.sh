#!/usr/bin/env bash

#
# Prints the log messages recorded in the history.
#
# @param ?int $1
# ::
#   - default: "1"
# ::
# Number of records to be printed.
#
# If **0** will print the entire log.
# If it is not indicated, or, if it is not a numeral, it will print the
# last record.
#
# @param ?bool $2
# ::
#   - default : "0"
#   - list    : SHELLNS_PROMPT_OPTION_BOOL
# ::
# Use **1** to enter the index of the message.
#
# @param ?string $3
# ::
#   - default : "d"
#   - list    : SHELLNS_PROMPT_OPTION_SORT_TYPE
# ::
# Print order.
#
# @return string
shellNS_log_read() {
  local intPrintMaxLength="${1}"
  local boolPrintPosition="${2}"
  local strPrintOrderBy="${3,,}"

  if [ "${intPrintMaxLength}" == "" ] || ! [[ "${intPrintMaxLength}" =~ ^[0-9]+$ ]]; then
    intPrintMaxLength="1"
  fi
  if [ "${intPrintMaxLength}" -le "0" ]; then
    intPrintMaxLength="${#SHELLNS_LOG_HISTORY[@]}"
  fi
  if [ "${boolPrintPosition}" != "0" ] && [ "${boolPrintPosition}" != "1" ]; then
    boolPrintPosition="0"
  fi
  if [ "${strPrintOrderBy}" != "a" ] && [ "${strPrintOrderBy}" != "d" ]; then
    strPrintOrderBy="d"
  fi

  local i="0"
  local -a arrSelectedIndex=()
  local intLastIndex="${#SHELLNS_LOG_HISTORY[@]}"
  ((intLastIndex--))


  if [ "${strPrintOrderBy}" == "d" ]; then
    for ((i=intLastIndex; i>=0; i--)); do
      arrSelectedIndex+=("${i}")
      if [ "${#arrSelectedIndex[@]}" -ge "${intPrintMaxLength}" ]; then
        break
      fi
    done
  else
    for ((i=0; i<=intLastIndex; i++)); do
      arrSelectedIndex+=("${i}")
      if [ "${#arrSelectedIndex[@]}" -ge "${intPrintMaxLength}" ]; then
        break
      fi
    done
  fi


  local strLogLine=""
  for i in "${arrSelectedIndex[@]}"; do
    strLogLine=""
    if [ "${boolPrintPosition}" == "1" ]; then
      strLogLine+="[ ${i} ] "
    fi
    strLogLine+="${SHELLNS_LOG_HISTORY[${i}]}"

    echo "${strLogLine}"
  done
  return 0
}