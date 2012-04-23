#!/bin/bash

#core.sh

CmdAdd() {
  CmdFunc[$CmdNum]="$1"
  shift
  CmdHelp[$CmdNum]="$1"
  shift
  CmdName[$CmdNum]="$@"

  #Debug "Adding CMD #$CmdNum: ${CmdFunc[$CmdNum]} || ${CmdHelp[$CmdNum]} || ${CmdName[$CmdNum]}"
  CmdNum=$((CmdNum+1))
}

FindCommand() {
  for CmdNum in $(seq 0 "${#CmdName}")
  do
    for Alias in ${CmdName[$CmdNum]}
    do
      if [[ "$1" = "$Alias" ]]
        then
          if [[ "$#" -eq "1" ]] || [[ "$2" = "Func" ]]
          then
            echo "${CmdFunc[$CmdNum]}"
            return 0
          elif [[ "$2" -eq "Help" ]]
          then
            echo "${CmdHelp[$CmdNum]}"
            return 0
          else
            Debug 'Шо мне делать, а?'
            return 42
          fi
      fi
    done
  done
  return 1
}

CmdProcess() {
  if [[ -z "$@" ]]
    then return
  fi
  Command=$(FindCommand "$1")
  if [[ -n "$Command" ]]
    then
      shift
      eval "$Command" $@
    else
      echo "LORA: $1: Команда не найдена"
  fi
  unset Found
}

CmdCheckEnv() {
  if [[ -n "$TermsCols" ]] && (("$TermCols" < 80 ))
    then
      Com_upsolid
      Com_textline "Ваш терминал должен иметь как минимум 80 символов в ширину"
      Com_downsolid
      exit 1
  fi
}
