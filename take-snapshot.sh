#!/usr/bin/env bash

# Take an EBS snapshot

set -eufo pipefail

SNAPSHOT_CREATE_MAIN=${SNAPSHOT_CREATE_MAIN:-true}

if [ "${SNAPSHOT_CREATE_MAIN}" == "true" ]; then
  aws_region=$(/opt/get-aws-region.sh)
  [ -z "${aws_region}" ] && echo >&2 "Error getting AWS region" && exit 1

  volume_id=$(/opt/get-volume-id.sh main)
  [ -z "${volume_id}" ] && echo >&2 "Error getting volume-id" && exit 1

  aws ec2 create-snapshot --volume-id ${volume_id} --description "Automatic snapshot by ${HOSTNAME}" --region ${aws_region}
fi
