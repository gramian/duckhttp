#!/bin/sh

SCRIPT=""

./duckdb -json -batch | while IFS= read -r line; do
  if [ "$line" = "[{\"eof\":true}]" ] ; then
    echo "[$SCRIPT]" | base64 ;
    SCRIPT=""
  elif [ "$SCRIPT" = "" ]; then
    SCRIPT="$line"
  else
    SCRIPT="$SCRIPT,$line"
  fi
done
