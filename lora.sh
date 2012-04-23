#!/bin/bash

# LORA v.0.0.1

ConfigsPath="$HOME/.LORA"
FuncDir="./" #костыль, нужно придумать что-нибудь умнее
PagesPath="/pages"

LorAddress="https://www.linux.org.ru/"
TrackerAddress="tracker/"
LoginAddress="login.jsp"
CookiesFile="/cookies.txt"

Login=""
Password=""
Anonymous=0

TermCols=$(stty size | cut -d " " -f 2)
TermRows=$(stty size | cut -d " " -f 1)

Debug() {
  if [ -n "$DEBUG" ]
    then
      echo -e "$@" | sed -e 's/^/[DEBUG] /'
  fi
}

CmdNum=0
#CmdFunc - функции
#CmdName - команда
#CmdHelp - описание

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
  if [[ (($TermCols -le 80 )) ]]
    then
      echo $TermCols
      Com_upsolid
      Com_textline "Ваш терминал должен иметь как минимум 80 символов в ширину"
      Com_downsolid
      exit 1
  fi
}

mkdir "$ConfigsPath" 2> /dev/null

if [ -d "./func/" ]
  then
    for module in func/*
    do
      Debug "Soursing $module module"
      source "$module"
    done
  else
    echo "Тоска и печаль. Я не знаю, где наши функции."
    exit 1
fi
Debug "$CMDS"

# Для функции Com_uptracker мне нужен терминал не менее 80 символов в ширину.
CmdCheckEnv


# Еще команды:
# thread - показывает тред. thread xxxxxxxx
# info - показывает информацию о треде. info xxxxxxxxxx
# profile - показывает информацию о пользователе. profile xxxxxxxxxx // ПЕРВООЧЕРЕДНАЯ ЦЕЛЬ
# answer - ответить на сообщение answer xxxxxxxx
# history - показать историю запросов с возможностью выбора повторной отправки



CmdProcess 'greet'
CmdProcess 'login'

while true
do
  
  read -p "LORA> " Command
  CmdProcess $Command

  #TODO Добавить комментарий после 2-го milestone: http://www.linux.org.ru/forum/talks/7671922?cid=7672261 (Да, я злопамятный)
  
done
