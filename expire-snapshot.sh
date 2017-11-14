#!/usr/bin/env bash

# Expire EBS snapshots

set -eufo pipefail

SNAPSHOT_EXPIRE_MAIN=${SNAPSHOT_EXPIRE_MAIN:-true}

if [ "${SNAPSHOT_EXPIRE_MAIN}" == "true" ]; then
  aws_region=$(/opt/get-aws-region.sh)
  [ -z "${aws_region}" ] && echo >&2 "Error getting AWS region" && exit 1

  volume_id=$(/opt/get-volume-id.sh main)
  [ -z "${volume_id}" ] && echo >&2 "Error getting volume-id" && exit 1

   ec2-expire-snapshots    \
    --keep-most-recent 1   \
    --keep-first-hourly 24 \
    --keep-first-daily 7   \
    --keep-first-weekly 4  \
    ${volume_id}
fi
