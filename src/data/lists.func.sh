list-add-item() {
  local LIST_VAR="${1}"; shift
  while (( $# > 0 )); do
    local ITEM
    ITEM="${1}"; shift
    # TODO: enforce no newlines in item

    if [[ -n "$ITEM" ]]; then
      if [[ -z "${!LIST_VAR:-}" ]]; then
        eval $LIST_VAR='"$ITEM"'
      else
        # echo $LIST_VAR='"${!LIST_VAR}"$'"'"'\n'"'"'"${ITEM}"'
        eval $LIST_VAR='"${!LIST_VAR}"$'"'"'\n'"'"'"${ITEM}"'
      fi
    fi
  done
}

list-rm-item() {
  local LIST_VAR="${1}"; shift
  while (( $# > 0 )); do
    local ITEM NEW_ITEMS
    ITEM="${1}"; shift
    NEW_ITEMS="$(echo "${!LIST_VAR}" | sed -e "/^$ITEM\$/d")"
    eval $LIST_VAR='"'"$NEW_ITEMS"'"'
  done
}

list-get-index() {
  local LIST_VAR="${1}"
  local TEST="${2}"

  local ITEM
  local INDEX=0
  while read -r ITEM; do
    if [[ "${ITEM}" == "${TEST}" ]]; then
      echo $INDEX
      return
    fi
    INDEX=$(($INDEX + 1))
  done <<< "${!LIST_VAR}"
}

list-get-item() {
  local LIST_VAR="${1}"
  local INDEX="${2}"

  local CURR_INDEX=0
  local ITEM
  while read -r ITEM; do
    if (( $CURR_INDEX == $INDEX )) ; then
      echo -n "${ITEM%\\n}"
      return
    fi
    CURR_INDEX=$(($CURR_INDEX + 1))
  done <<< "${!LIST_VAR}"
}
