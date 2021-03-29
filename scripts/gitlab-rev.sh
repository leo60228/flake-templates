#!/usr/bin/env bash
curl -s "https://gitlab.com/api/v4/projects/$1%2F$2%2F$3/repository/commits/master" | jq -r .id
