#!/usr/bin/env bash
# Builds one ZIP per exercise containing only the files that exercise adds.
# All ZIPs share the top-level folder "checkout-service-incident/", so participants
# can unzip each one into the same place and the files add up.
#
# Usage: build-bundles.sh <exercises-dir> <files-dir> <sourcecode-dir> <out-dir>
set -euo pipefail

EXERCISES_DIR=$(cd "$1" && pwd)
FILES_DIR=$(cd "$2" && pwd)
SOURCE_DIR=$(cd "$3" && pwd)
mkdir -p "$4"
OUT_DIR=$(cd "$4" && pwd)
PYTHON=${PYTHON:-python3}

ROOT=checkout-service-incident
FILES=checkout-service-incident-files
SOURCE=checkout-service-incident-sourcecode

# Every top-level directory in the files repo must belong to an exercise.
ASSIGNED="topdesk-incident payload-and-log-excerpts metrics-and-deploy-history runbook topdesk-problem problem-evidence request-for-change"
for dir in "$FILES_DIR"/*/; do
  name=$(basename "$dir")
  if [[ " $ASSIGNED " != *" $name "* ]]; then
    echo "error: '$FILES/$name' is not assigned to any exercise bundle" >&2
    exit 1
  fi
done

STAGING=$(mktemp -d)
trap 'rm -rf "$STAGING"' EXIT

# copy <src> <dest relative to bundle root>
copy() {
  mkdir -p "$(dirname "$BUNDLE/$2")"
  cp -R "$1" "$BUNDLE/$2"
}

new_bundle() {
  BUNDLE="$STAGING/$1/$ROOT"
  mkdir -p "$BUNDLE"
}

finish_bundle() {
  rm -f "$OUT_DIR/$1.zip"
  (cd "$STAGING/$1" && "$PYTHON" -m zipfile -c "$OUT_DIR/$1.zip" "$ROOT")
  echo "built $OUT_DIR/$1.zip"
}

new_bundle exercise-1
copy "$EXERCISES_DIR/scenario" scenario
copy "$FILES_DIR/topdesk-incident" "$FILES/topdesk-incident"
copy "$FILES_DIR/payload-and-log-excerpts" "$FILES/payload-and-log-excerpts"
finish_bundle exercise-1

new_bundle exercise-2
copy "$FILES_DIR/metrics-and-deploy-history" "$FILES/metrics-and-deploy-history"
copy "$FILES_DIR/runbook" "$FILES/runbook"
copy "$FILES_DIR/topdesk-problem" "$FILES/topdesk-problem"
finish_bundle exercise-2

new_bundle exercise-3
copy "$FILES_DIR/problem-evidence" "$FILES/problem-evidence"
copy "$FILES_DIR/request-for-change" "$FILES/request-for-change"
finish_bundle exercise-3

new_bundle exercise-4
copy "$SOURCE_DIR" "$SOURCE"
rm -rf "$BUNDLE/$SOURCE/.git" "$BUNDLE/$SOURCE/.github"
finish_bundle exercise-4
