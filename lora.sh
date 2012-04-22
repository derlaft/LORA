#!/bin/bash

# LORA v.0.0.1

ConfigsPath="$HOME/.LORA"
ProgramPath="/LORA"
PagesPath="/pages"

LorAddress="https://www.linux.org.ru/"
TrackerAddress="tracker/"
LoginAddress="login.jsp"

Login=""
Password=""
Anonymous=0

TermCols=$(stty size | cut -d " " -f 2)
TermRows=$(stty size | cut -d " " -f 1)

mkdir "$ConfigsPath" 2> /dev/null

# Блок функций

Com_upsolid()
{
  i=2
  
  echo -n "┍"
  
  while [ "$i" != "$TermCols" ]
  do
    echo -n "━"
    
    i=$(($i+1))
  done
  
  echo "┑"
}

Com_uptracker()
{
 echo -n
 # Работаю над этим
}

Com_downsolid()
{
  i=2
  
  echo -n "┕"
  
  while [ "$i" != "$TermCols" ]
  do
    echo -n "━"
    
    i=$(($i+1))
  done
  
  echo "┙"
}

Com_textline()
{
  Text=$1
  NeedCols=$(($TermCols-4))
  Text="${Text::${NeedCols}}"
  
  while [ ${#Text} != $NeedCols ]
  do
    Text="$Text "
  done
  
  echo "│ $Text │"
}

Com_greet()
{
  Com_upsolid
  
  Com_textline "Добро пожаловать в систему консольного доступа “LORA” v. 0.1"
  
  Com_downsolid
}

Com_exit()
{
  echo "Помните, anonymous любит вас."
  exit 0
}

Com_login()
{
  # Запрос логина
  
  Com_upsolid
  
  Com_textline "Введите ваши логин и пароль для авторизации."
  Com_textline "вы можете оставить поле пустым для анонимного входа и"
  Com_textline "использовать команду “login” для авторизации позже."
  
  Com_downsolid
  
  read -p "Логин: " Login
  
  # Опрос пользователя.

  if [[ $Login = "" ]]
    then
      echo "Активирован анонимный вход."
      Anonymous=1
    else
      read -p "Пароль: " -s Password
      if [[ $Password = "" ]]
        then
          echo "Активирован анонимный вход."
          Anonymous=1
        fi
    #Получаем файл с куками
    wget -qO/dev/null --post-data="nick=$Login&passwd=$Password" --save-cookies="$ConfigsPath/cookies.txt" "$LorAddress$LoginAddress"
    if cat "$ConfigsPath/cookies.txt" | grep password > /dev/null
      then
        echo
        echo "Успешный вход"
      else
        echo
        echo "Не удалось войти, активирован анонимный вход"
        Anonymous=1
      fi
    echo
  fi
}


Com_tracker()
{
  if [[ $2 = "" ]]
    then
      Count=20
    else
      if [[ $2 -gt 20 ]]
        then
          Count=20
        else
          Count=$2
      fi
  fi
  
  ForumPattern="<div class=forum>"
  TopicPattern="<tbody>"

  tracker_html=$(wget -q $LorAddress$TrackerAddress -O-)
  # echo "┍━ Индекс ━ Группа ━━━━━━━━ Заголовок ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┑"
  # echo "│ 7668145  Web-development Как пропатчить KDE под FreeBSD?                    │"
  # echo "┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┙"
  
  # sed:
  # удалить все <tr>: s/<tr>//g
  # удалить все </tr>: s/<\/tr>//g
  # удалить все </a>: s/<\/a>//g
  # удалить все </td>: s/<\/td>//g
  # удалить все </td>: s/<td>//g
  # удалить строки из пробелов: s/ *$//
  # удалить пустые строки: /^$/d
  # удалить строки до начала форумного дива: 1,/$ForumPattern/d
  # удалить строки до начала форумной таблицы: 1,/$TopicPattern/d
  cleared=$(echo -e "$tracker_html" | sed -e "s/<tr>//g;s/<\/tr>//g;s/<\/a>//g;s/<\/td>//g;s/<td>//g;s/ *$//;/^$/d;1,/$ForumPattern/d;1,/$TopicPattern/d")
  
  # Номера тредов
  Numbers=$(echo -e "$cleared" | grep -oE --regexp="/[0-9]{7}" | sed -e "s/\///g")
  
  # sed
  # удалить теги: s/<[^>]*>//g
  # удалить пробелы в начале строк: s/^[ \t]*//
  # удалить пустые строки: /^$/d
  cleared2=$(echo -e "$cleared" | sed -e "s/<[^>]*>//g;s/^[ \t]*//;/^$/d;")
  
  echo "┍━ Индекс ━ Группа ━━━━━━━━ Заголовок ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┑"
  
  i=1
  while [ $i -le $Count ]
  do
    echo -n "│ "
    
    # sed
    # вывести i-ю строку: ${i}p
    
    # Индекс топика
    echo -n "$Numbers" | sed -n "${i}p" | tr -d '\012'
    echo -n "  "
    
    # Имя раздела
    Group=$(echo -e "$cleared2" | sed -n "1p")
    Group=$(echo -n "$Group" | sed -e "s/, не подтверждено//")
    Group="${Group::15}"
    
    while [ ${#Group} != "16" ]
    do
      Group="$Group "
    done
    
    echo -n "$Group"
    Signal=$(echo -e "$cleared2" | sed -n "2p" | tr -d '\012')
    
    
    while [ "${Signal::1}" != '(' ]
    do
      #sed
      #удаляем строку: 1d
      cleared2=$(echo -e "$cleared2" | sed -e "1d")
      Signal=$(echo -e "$cleared2" | sed -n "2p" | tr -d '\012')
    done
    
    TopicName=$(echo -e "$cleared2" | sed -n "1p")
    TopicName="${TopicName::50}"
    
    while [ ${#TopicName} != "50" ]
    do
      TopicName="$TopicName "
    done
    
    echo -n "$TopicName"
    
    #sed
    #удалить 4 строки: 1,4d
    cleared2=$(echo -e "$cleared2" | sed -e "1,4d")
    
    i=$((i+1))
    echo " │"
  done
  echo "┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┙"
}

# Еще команды:
# thread - показывает тред. thread xxxxxxxx
# info - показывает информацию о треде. info xxxxxxxxxx
# profile - показывает информацию о пользователе. profile xxxxxxxxxx
# answer - ответить на сообщение answer xxxxxxxx
# history - показать историю запросов с возможностью выбора повторной отправки

Com_greet

Com_login

while [ "$Command" != "exit" ]
do
  
  read -p "LORA>" Command
  
  case "$Command" in
    "tracker"*) Com_tracker $Command;;
    "login") Com_login;;
    
    # TODO Добавить комментарий после 2-й ф-ии: http://www.linux.org.ru/forum/talks/7671922?cid=7672261
  esac
  
done

Com_exit