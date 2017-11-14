#!/usr/bin/env bash

timeout 1m curl --silent http://169.254.169.254/latest/meta-data/placement/availability-zone/ | sed 's/[a-z]\+$//'
