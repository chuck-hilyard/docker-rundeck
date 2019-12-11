#!/usr/bin/env bash

set -e

echo "retrieving vault token"

token=$(curl -s -X GET http://consul.base.dev.usa.media.reachlocalservices.com:8500/v1/kv/rundeck/vault_config/token?raw)
export SPRING_APPLICATION_JSON="{\"spring\":{\"cloud\":{\"config\":{\"token\": \"$token\"}}}}"

exec "$@"
