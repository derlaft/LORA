#!/bin/bash

#debug 

Debug() {
  if [ -n "$DEBUG" ]
    then
      echo -e "$@" | sed -e 's/^/[DEBUG] /'
  fi
}
