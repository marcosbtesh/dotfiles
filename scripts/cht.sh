#!/bin/bash

QUERY=$(printf "/%s" "$@")

curl -s "https://cheat.sh${QUERY}"