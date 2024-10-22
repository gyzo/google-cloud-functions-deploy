#!/usr/bin/env bash

# Deploy to GCP Cloud Functions, https://cloud.google.com/functions/
#
# Required globals:
#   KEY_FILE
#   PROJECT
#   FUNCTION_NAME
#   ENTRY_POINT
#   RUNTIME
#   REGION
#
# Optional globals:
#   MEMORY
#   TIMEOUT
#   EXTRA_ARGS
#   DEBUG
#   SOURCE
#   TRIGGER
#   ALLOW_UNAUTHENTICATED

source "$(dirname "$0")/common.sh"
enable_debug

# mandatory parameters
KEY_FILE=${KEY_FILE:?'KEY_FILE variable missing.'}
PROJECT=${PROJECT:?'PROJECT variable missing.'}
FUNCTION_NAME_COUNT=${FUNCTION_NAME_COUNT:?'FUNCTION_NAME_COUNT variable missing.'}
for i in $(seq 0 $((FUNCTION_NAME_COUNT - 1))); do
  eval "FUNCTION_NAME_${i}=\${FUNCTION_NAME_${i}:?'FUNCTION_NAME_${i} variable missing.'}"
done
for i in $(seq 0 $((ENTRY_POINT_COUNT - 1))); do
  eval "ENTRY_POINT_${i}=\${ENTRY_POINT_${i}:?'ENTRY_POINT_${i} variable missing.'}"
done
RUNTIME=${RUNTIME:?'RUNTIME variable missing.'}
REGION=${REGION:?'REGION variable missing.'}

info "Setting up environment".

run 'echo "${KEY_FILE}" | base64 -d >> /tmp/key-file.json'
run gcloud auth activate-service-account --key-file /tmp/key-file.json --quiet ${gcloud_debug_args}
run gcloud config set project $PROJECT --quiet ${gcloud_debug_args}

ARGS_STRING=""

if [ ! -z "${PROJECT}" ]; then
  ARGS_STRING="${ARGS_STRING} --project=${PROJECT}"
fi

if [ ! -z "${RUNTIME}" ]; then
  ARGS_STRING="${ARGS_STRING} --runtime=${RUNTIME} "
fi

if [ ! -z "${REGION}" ]; then
  ARGS_STRING="${ARGS_STRING} --region=${REGION} "
fi

if [ ! -z "${MEMORY}" ]; then
  ARGS_STRING="${ARGS_STRING} --memory=${MEMORY} "
fi

if [ ! -z "${TIMEOUT}" ]; then
  ARGS_STRING="${ARGS_STRING} --timeout=${TIMEOUT} "
fi

if [ ! -z "${SOURCE}" ]; then
  ARGS_STRING="${ARGS_STRING} --source=${SOURCE} "
else
  ARGS_STRING="${ARGS_STRING} --source . "
fi

if [ ! -z "${TRIGGER}" ]; then
  ARGS_STRING="${ARGS_STRING} ${TRIGGER} "
else
  ARGS_STRING="${ARGS_STRING} --trigger-http "
fi

if [ ! -z "${ALLOW_UNAUTHENTICATED}" ]; then
  ARGS_STRING="${ARGS_STRING} --allow-unauthenticated "
fi

info "Rozpoczynam wdrażanie funkcji GCP Cloud..."

for i in $(seq 0 $((FUNCTION_NAME_COUNT - 1))); do
  eval "current_function=\${FUNCTION_NAME_${i}}"
  eval "current_entry_point=\${ENTRY_POINT_${i}}"
  
  CURRENT_ARGS_STRING="${ARGS_STRING} --entry-point=${current_entry_point}"

  info "Wdrażanie funkcji: ${current_function}"
  run gcloud functions deploy ${current_function} ${CURRENT_ARGS_STRING} ${EXTRA_ARGS} ${gcloud_debug_args}

  if [ "${status}" -eq 0 ]; then
    success "Wdrożenie funkcji ${current_function} zakończone sukcesem."
  else
    fail "Wdrożenie funkcji ${current_function} nie powiodło się."
  fi
done

success "Wszystkie wdrożenia zakończone."
