#!/usr/bin/env bash
set -e

SCRIPT="$(readlink -f $0)"
SCRIPTPATH="$(dirname $SCRIPT)"

RELEASE_URL='https://api.github.com/repos/hlandau/acme/releases/latest'
VERSION=$(curl -sL ${RELEASE_URL} | fgrep '"tag_name"' | cut -d\" -f4 | cut -c 2-)

sed -ri $'s/^(.* ACMETOOL_VERSION=\')[^\']+(\'.*)$/\\1'${VERSION}$'\\2/' ${SCRIPTPATH}/Dockerfile
