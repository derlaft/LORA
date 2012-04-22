#!/bin/bash

#help

CmdAdd 'Com_help' 'Показать список комманд' 'help' 'h' '?'

Com_help()
{
  #Сделано очень аццки, надеюсь, что будет более хороший вариант
  Help=$(echo -e "$CMDS" | sed -e 's/^.*SHELP//;s/EHELP.*//g')
  Line=1
  echo -e "$Help" | while read HelpInfo
    do
      for alias in $(echo -ne "$CMDS" | sed -n "${Line}p" | sed -e 's/ /\n/g' | grep '|' | sed -e 's/|/ /g')
      do
        echo -ne "$alias, "
      done
      echo -e "\b\b: $HelpInfo"
      Line=$((Line+1))
    done
}
