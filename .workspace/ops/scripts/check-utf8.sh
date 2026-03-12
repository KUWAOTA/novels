#!/usr/bin/env bash

set -euo pipefail

root="${1:-.}"
status=0

while IFS= read -r path; do
  info="$(file "$path")"
  case "$info" in
    *"UTF-16"*|*"UTF-32"*|*"UTF-8 (with BOM)"*)
      printf 'encoding issue: %s\n' "$path"
      printf '  %s\n' "$info"
      status=1
      ;;
  esac
done < <(find "$root" -path '*/.git' -prune -o -type f -print)

exit "$status"
