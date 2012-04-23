#!/bin/bash

#help

CmdAdd 'Com_help' 'Показать список команд' 'help' 'h' '?'
Com_help()
{
  if [[ "$#" -eq "0" ]]
  then
    echo "Для справки по определенной команде введите 'help команда'"
    echo "Доступные команды:"

    #Сделано очень аццки, надеюсь, что будет более хороший вариант
    #Так пойдет? //Al. 
    #Переделал. Всё равно получилось не очень, но лучше, намного лучше //der
  
    Cmds=$(for CmdNum in $(seq 0 "${#CmdName}")
    do
      for Alias in ${CmdName[$CmdNum]}
      do
        echo "$Alias "
      done
    done)
    echo $Cmds

  elif [[ "$#" -eq "1" ]]
  then
    echo -n "Команда $1: "
    Help=$(FindCommand "$1" "Help")
    if [[ -z "$Help" ]]; then
      echo "Не найдена"
    else
      echo "$Help"
    fi
  fi
}
