#!/bin/bash

  set -e

  SUFFIX=$(head /dev/urandom | tr -dc a-z0-9 | head -c 8)

  CRON_EXPRESSION=$1
  NAMESPACE=$2
  if [[ -n ${CRON_EXPRESSION} ]] && [[ -n ${NAMESPACE} ]]; then

    JOB_NAME=sas-scheduled-backup-job-$SUFFIX
    COMPONENT_NAME=sas-backup-job-$SUFFIX

    SOURCE_CRONJOB="sas-scheduled-backup-job"

    # Export existing CronJob YAML
    kubectl get cronjob "$SOURCE_CRONJOB" -n "$NAMESPACE" -o yaml > "${JOB_NAME}".yaml

    # Remove unnecessary metadata lines
    sed -i '/^  uid:/d' "${JOB_NAME}".yaml
    sed -i '/^  resourceVersion:/d' "${JOB_NAME}".yaml
    sed -i '/^  creationTimestamp:/d' "${JOB_NAME}".yaml
    sed -i '/^  generation:/d' "${JOB_NAME}".yaml
    sed -i '/^status:/,/^[^ ]/d' "${JOB_NAME}".yaml
    sed -i -E '/^[[:space:]]*imagePullSecrets:/{
N
s/^[[:space:]]*imagePullSecrets:\n[[:space:]]*- name: .*/          imagePullSecrets: []/
}' "${JOB_NAME}.yaml"

    # Updates component name to avoid applying the base TLS transformers
    sed -i -E "s/^([[:space:]]*)sas\.com\/component-name: .*/\1sas.com\/component-name: ${COMPONENT_NAME}/" "${JOB_NAME}".yaml


    # Replace name and schedule
    sed -i "s/^  name: .*/  name: \"${JOB_NAME}\"/" "${JOB_NAME}".yaml
    sed -i "s/^  schedule: .*/  schedule: \"$CRON_EXPRESSION\"/" "${JOB_NAME}".yaml

    echo "Successfully cloned '$SOURCE_CRONJOB' to '$JOB_NAME' with schedule '$CRON_EXPRESSION' in namespace '$NAMESPACE'."



  else

    echo 'ERROR: Invalid command!'
    echo 'Allowed commands:'
    echo './generate-backup-job.sh "<cron expression>" <namespace>'
    exit 1

  fi
  echo "Manifest file ${JOB_NAME}.yaml generated."
