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
IFS=',' read -ra FUNCTION_NAMES <<< "${FUNCTION_NAME:?'FUNCTION_NAME variable missing.'}"
ENTRY_POINT=${ENTRY_POINT:?'ENTRY_POINT variable missing.'}
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

if [ ! -z "${ENTRY_POINT}" ]; then
  ARGS_STRING="${ARGS_STRING} --entry-point=${ENTRY_POINT} "
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

info "Starting deployment GCP Cloud Function..."

for FUNCTION_NAME in "${FUNCTION_NAMES[@]}"; do
  info "Wdrażanie funkcji: $FUNCTION_NAME"
  run gcloud functions deploy ${FUNCTION_NAME}" $ARGS_STRING ${EXTRA_ARGS} ${gcloud_debug_args}
done
