#!/usr/bin/env bash

if [[ "$(declare -p "SHELLNS_STANDALONE_LOAD_STATUS" 2> /dev/null)" != "declare -A"* ]]; then
  declare -gA SHELLNS_STANDALONE_LOAD_STATUS
fi
SHELLNS_STANDALONE_LOAD_STATUS["shellns_log_standalone.sh"]="ready"
unset SHELLNS_STANDALONE_DEPENDENCIES
declare -gA SHELLNS_STANDALONE_DEPENDENCIES
shellNS_standalone_install_set_dependency() {
  local strDownloadFileName="shellns_${2,,}_standalone.sh"
  local strPkgStandaloneURL="https://raw.githubusercontent.com/AeonDigital/${1}/refs/heads/main/standalone/package.sh"
  SHELLNS_STANDALONE_DEPENDENCIES["${strDownloadFileName}"]="${strPkgStandaloneURL}"
}
declare -gA SHELLNS_DIALOG_TYPE_COLOR=(
  ["raw"]=""
  ["info"]="\e[1;34m"
  ["warning"]="\e[0;93m"
  ["error"]="\e[1;31m"
  ["question"]="\e[1;35m"
  ["input"]="\e[1;36m"
  ["ok"]="\e[20;49;32m"
  ["fail"]="\e[20;49;31m"
)
declare -gA SHELLNS_DIALOG_TYPE_PREFIX=(
  ["raw"]=" - "
  ["info"]="inf"
  ["warning"]="war"
  ["error"]="err"
  ["question"]=" ? "
  ["input"]=" < "
  ["ok"]=" v "
  ["fail"]=" x "
)
declare -g SHELLNS_DIALOG_PROMPT_INPUT=""
shellNS_standalone_install_dialog() {
  local strDialogType="${1}"
  local strDialogMessage="${2}"
  local boolDialogWithPrompt="${3}"
  local codeColorPrefix="${SHELLNS_DIALOG_TYPE_COLOR["${strDialogType}"]}"
  local strMessagePrefix="${SHELLNS_DIALOG_TYPE_PREFIX[${strDialogType}]}"
  if [ "${strDialogMessage}" != "" ] && [ "${codeColorPrefix}" != "" ] && [ "${strMessagePrefix}" != "" ]; then
    local strIndent="        "
    local strPromptPrefix="      > "
    local codeColorNone="\e[0m"
    local codeColorText="\e[0;49m"
    local codeColorHighlight="\e[1;49m"
    local tmpCount="0"
    while [[ "${strDialogMessage}" =~ "**" ]]; do
      ((tmpCount++))
      if (( tmpCount % 2 != 0 )); then
        strDialogMessage="${strDialogMessage/\*\*/${codeColorHighlight}}"
      else
        strDialogMessage="${strDialogMessage/\*\*/${codeColorNone}}"
      fi
    done
    local codeNL=$'\n'
    strDialogMessage=$(echo -ne "${strDialogMessage}")
    strDialogMessage="${strDialogMessage//${codeNL}/${codeNL}${strIndent}}"
    local strShowMessage=""
    strShowMessage+="[ ${codeColorPrefix}${strMessagePrefix}${codeColorNone} ] "
    strShowMessage+="${codeColorText}${strDialogMessage}${codeColorNone}\n"
    echo -ne "${strShowMessage}"
    if [ "${boolDialogWithPrompt}" == "1" ]; then
      SHELLNS_DIALOG_PROMPT_INPUT=""
      read -r -p "${strPromptPrefix}" SHELLNS_DIALOG_PROMPT_INPUT
    fi
  fi
  return 0
}
shellNS_standalone_install_dependencies() {
  if [[ "$(declare -p "SHELLNS_STANDALONE_DEPENDENCIES" 2> /dev/null)" != "declare -A"* ]]; then
    return 0
  fi
  if [ "${#SHELLNS_STANDALONE_DEPENDENCIES[@]}" == "0" ]; then
    return 0
  fi
  local pkgFileName=""
  local pkgSourceURL=""
  local pgkLoadStatus=""
  for pkgFileName in "${!SHELLNS_STANDALONE_DEPENDENCIES[@]}"; do
    pgkLoadStatus="${SHELLNS_STANDALONE_LOAD_STATUS[${pkgFileName}]}"
    if [ "${pgkLoadStatus}" == "" ]; then pgkLoadStatus="0"; fi
    if [ "${pgkLoadStatus}" == "ready" ] || [ "${pgkLoadStatus}" -ge "1" ]; then
      continue
    fi
    if [ ! -f "${pkgFileName}" ]; then
      pkgSourceURL="${SHELLNS_STANDALONE_DEPENDENCIES[${pkgFileName}]}"
      curl -o "${pkgFileName}" "${pkgSourceURL}"
      if [ ! -f "${pkgFileName}" ]; then
        local strMsg=""
        strMsg+="An error occurred while downloading a dependency.\n"
        strMsg+="URL: **${pkgSourceURL}**\n\n"
        strMsg+="This execution was aborted."
        shellNS_standalone_install_dialog "error" "${strMsg}"
        return 1
      fi
    fi
    chmod +x "${pkgFileName}"
    if [ "$?" != "0" ]; then
      local strMsg=""
      strMsg+="Could not give execute permission to script:\n"
      strMsg+="FILE: **${pkgFileName}**\n\n"
      strMsg+="This execution was aborted."
      shellNS_standalone_install_dialog "error" "${strMsg}"
      return 1
    fi
    SHELLNS_STANDALONE_LOAD_STATUS["${pkgFileName}"]="1"
  done
  if [ "${1}" == "1" ]; then
    for pkgFileName in "${!SHELLNS_STANDALONE_DEPENDENCIES[@]}"; do
      pgkLoadStatus="${SHELLNS_STANDALONE_LOAD_STATUS[${pkgFileName}]}"
      if [ "${pgkLoadStatus}" == "ready" ]; then
        continue
      fi
      . "${pkgFileName}"
      if [ "$?" != "0" ]; then
        local strMsg=""
        strMsg+="An unexpected error occurred while load script:\n"
        strMsg+="FILE: **${pkgFileName}**\n\n"
        strMsg+="This execution was aborted."
        shellNS_standalone_install_dialog "error" "${strMsg}"
        return 1
      fi
      SHELLNS_STANDALONE_LOAD_STATUS["${pkgFileName}"]="ready"
    done
  fi
}
shellNS_standalone_install_dependencies "1"
unset shellNS_standalone_install_set_dependency
unset shellNS_standalone_install_dependencies
unset shellNS_standalone_install_dialog
unset SHELLNS_STANDALONE_DEPENDENCIES
unset SHELLNS_PROMPT_OPTION_SORT_TYPE
declare -gA SHELLNS_PROMPT_OPTION_SORT_TYPE=(
  ["a"]="asc"
  ["d"]="desc"
)
unset SHELLNS_LOG_HISTORY
declare -ga SHELLNS_LOG_HISTORY=()
SHELLNS_LOG_MAXLENGTH="20"
SHELLNS_LOG_RECYCLE_LENGTH="5"
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
shellNS_log_clear() {
  SHELLNS_LOG_HISTORY=()
}
SHELLNS_TMP_PATH_TO_DIR_MANUALS="$(tmpPath=$(dirname "${BASH_SOURCE[0]}"); realpath "${tmpPath}/src-manuals/${SHELLNS_CONFIG_INTERFACE_LOCALE}")"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_log_clear"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/log/clear.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_log_read"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/log/read.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_log_write"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/log/write.man"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["log.clear"]="shellNS_log_clear"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["log.read"]="shellNS_log_read"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["log.write"]="shellNS_log_write"
unset SHELLNS_TMP_PATH_TO_DIR_MANUALS
