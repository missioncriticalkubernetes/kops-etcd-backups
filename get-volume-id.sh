#!/usr/bin/env bash

set -eufo pipefail

volume=${1:-main}
case $volume in
  main)   export device="/dev/xvdu";;
  events) export device="/dev/xvdv";;
  *)      echo >&2 "First argument must be 'main' or 'events'"; exit 1;;
esac

aws_region=$(/opt/get-aws-region.sh)
instance_id=$(timeout 1m curl --silent http://169.254.169.254/latest/meta-data/instance-id)
volume_id=$(aws ec2 describe-instances --instance=${instance_id} --region ${aws_region} | jq -r '.Reservations[0].Instances[0].BlockDeviceMappings[] | select(.DeviceName == "'${device}'") | .Ebs.VolumeId')

[ -z "${volume_id}" ] && echo >&2 "No volume-id found" && exit 1
echo ${volume_id}
