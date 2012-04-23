#!/bin/bash

# LORA v.0.0.1

ConfigsPath="$HOME/.LORA"
PrDir="./" #костыль, нужно придумать что-нибудь умнее
PagesPath="/pages"

LorAddress="https://www.linux.org.ru/"
TrackerAddress="tracker/"
LoginAddress="login.jsp"
CookiesFile="$ConfigsPath/cookies.txt"

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

mkdir "$ConfigsPath" 2> /dev/null

if [ -d "$PrDir/system/" ] 
  then
    for module in $PrDir/system/*
    do
      Debug "Soursing $module module"
      source "$module"
    done
  else
    echo "Тоска и печаль. Я не знаю, где мои системные функции."
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
