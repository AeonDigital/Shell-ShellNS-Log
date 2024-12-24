#!/usr/bin/env bash

#
# Package Config


#
# Picklist for sort type.
unset SHELLNS_PROMPT_OPTION_SORT_TYPE
declare -gA SHELLNS_PROMPT_OPTION_SORT_TYPE=(
  ["a"]="asc"
  ["d"]="desc"
)


#
# Register log history
unset SHELLNS_LOG_HISTORY
declare -ga SHELLNS_LOG_HISTORY=()


#
# Determine the max log messages to be stored
# It is recommended that this amount is not too large.
# A limit of 512 records seems appropriate.
SHELLNS_LOG_MAXLENGTH="20"


#
# If the maximum number of items recorded in the history
# exceeds the maximum allowed, this value will be deleted
# from records to make room for future insertions.
SHELLNS_LOG_RECYCLE_LENGTH="5"