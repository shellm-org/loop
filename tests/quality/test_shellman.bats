load data

_has_tag() {
  local script status=${success}
  local checked_tag="$1"
  shift
  for script in "$@"; do
    if ! doc --get "${checked_tag}" "${script}" >/dev/null; then
      echo "${script}: missing tag ${checked_tag}"
      status=${failure}
    fi
  done
  return ${status}
}

_usage_matches_script_name() {
  local script usage usages status=${success}
  for script in "$@"; do
    if usages=$(doc --get "usage" "${script}" | cut -d' ' -f1); then
      for usage in ${usages}; do
        if [ "${usage}" != "$(basename "${script}")" ]; then
          echo "${script}: usage '${usage}' does not match script name"
          status=${failure}
        fi
      done
    fi
  done
  return ${status}
}

@test "scripts have usage tag" {
  _has_tag "usage" ${scripts}
}

@test "scripts have brief tag" {
  _has_tag "brief" ${scripts}
}

@test "scripts usages match names" {
  _usage_matches_script_name ${scripts}
}

@test "shellman on scripts" {
  skip "- no check option in shellman"
  _shellman ${scripts}
}

@test "shellman on libraries" {
  skip "- no check option in shellman"
  _shellman ${libs}
}
