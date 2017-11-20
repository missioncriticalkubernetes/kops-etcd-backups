#!/usr/bin/env bash

# Take an EBS snapshot
echo "Starting $0..."

set -eufo pipefail
source /opt/aws.creds

SNAPSHOT_CREATE_MAIN=${SNAPSHOT_CREATE_MAIN:-true}

if [ "${SNAPSHOT_CREATE_MAIN}" == "true" ]; then
  aws_region=$(/opt/get-aws-region.sh)
  [ -z "${aws_region}" ] && echo >&2 "Error getting AWS region" && exit 1

  volume_id=$(/opt/get-volume-id.sh main)
  [ -z "${volume_id}" ] && echo >&2 "Error getting volume-id" && exit 1

  echo "$0: Creating snapshot of '${volume_id}'"
  snapshot_id=$(aws ec2 create-snapshot --volume-id ${volume_id} --description "Automatic snapshot by ${HOSTNAME}" --region ${aws_region} | jq -r .SnapshotId)

  echo "$0: Tagging snapshot '${snapshot_id}'"
  aws ec2 describe-tags --filters "Name=resource-id,Values=${volume_id}" --output json --region ${aws_region} | jq '[.Tags[] | {"Key": .Key, "Value": .Value}] | {"DryRun": false, "Resources": ["'${snapshot_id}'"], "Tags": .}' > /tmp/tags.json
  aws ec2 create-tags --region=${aws_region} --cli-input-json file:///tmp/tags.json

  rm -f /tmp/tags.json || true
fi
