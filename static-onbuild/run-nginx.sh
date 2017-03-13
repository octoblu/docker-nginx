#!/bin/bash

VERSION_PATH="/usr/src/app/.PKG_VERSION"

download_index() {
  local cdn="$1"
  local version="$2"
  local index_uri="$cdn/$version/index.html"
  local exit_code
  echo "downloading $index_uri"
  curl --fail -sSl "$index_uri" -o /usr/share/nginx/html/index.html
  exit_code=$?
  if [ "$exit_code" != "0" ]; then
    echo "Unable to download index.html, exiting."
    exit 1
  fi
}

start_nginx() {
  nginx -g 'daemon off;'
}

main() {
  if [ -z "$CDN" ]; then
    echo 'Missing CDN env'
    exit 1
  fi

  if [ ! -f "$VERSION_PATH" ]; then
    echo "Missing ${VERSION_PATH} file"
    exit 1
  fi
  local version="v$(cat $VERSION_PATH)"
  download_index "$CDN" "$version" && \
    start_nginx
}

main "$@"
