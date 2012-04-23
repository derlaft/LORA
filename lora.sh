#!/bin/bash

# LORA v.0.0.1

ConfigsPath="$HOME/.LORA"
FuncDir="./" #костыль, нужно придумать что-нибудь умнее
PagesPath="/pages"

LorAddress="https://www.linux.org.ru/"
TrackerAddress="tracker/"
LoginAddress="login.jsp"

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

CmdAdd() {
  if [ -n "$CMDS" ]
    then
      CMDS="$CMDS\n"
  fi
  CmdName="$1"
  CmdDesc="$2"
  shift; shift
  CMDS="$CMDS$CmdName SHELP${CmdDesc}EHELP "
  for cmd in $@
  do
    CMDS="$CMDS|$cmd|"
  done
}

CmdProcess() {
  if [[ -z "$@" ]]
    then return
  fi
  NumOfCmd=$(echo -e "$CMDS" | grep -n "|$1|" | awk 'BEGIN{FS=":"};{print $1}')
  if [ -z "$NumOfCmd" ]
    then
      echo "LORA: $1: Команда не найдена" #КоМанда - с одной М!
    else
      CmdName=$(echo -e "$CMDS" | sed -n "${NumOfCmd}p" | awk '{print $1}')
      shift
      eval "$CmdName $@"
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
    exit 0
fi
Debug "$CMDS"

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

  #TODO Добавить комментарий после 2-й ф-ии: http://www.linux.org.ru/forum/talks/7671922?cid=7672261 (Да, я злопамятный)
  
done
