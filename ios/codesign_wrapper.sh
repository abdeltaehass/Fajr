#!/bin/sh
for arg in "$@"; do
  case "$arg" in
    /*)
      if [ -e "$arg" ]; then
        /usr/bin/xattr -cr "$arg" 2>/dev/null || true
      fi
      ;;
  esac
done
exec /usr/bin/codesign "$@"
