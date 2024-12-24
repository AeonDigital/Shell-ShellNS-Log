#!/usr/bin/env bash

#
# Get path to the manuals directory.
SHELLNS_TMP_PATH_TO_DIR_MANUALS="$(tmpPath=$(dirname "${BASH_SOURCE[0]}"); realpath "${tmpPath}/src-manuals/${SHELLNS_CONFIG_INTERFACE_LOCALE}")"


#
# Mapp function to manual.
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_log_clear"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/log/clear.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_log_read"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/log/read.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_log_write"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/log/write.man"


#
# Mapp namespace to function.
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["log.clear"]="shellNS_log_clear"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["log.read"]="shellNS_log_read"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["log.write"]="shellNS_log_write"





unset SHELLNS_TMP_PATH_TO_DIR_MANUALS