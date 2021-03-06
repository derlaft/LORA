#!/bin/bash

#login

Com_IsLoggedIn() {
  if [ -f "$CookiesFile" ]
    then
      if cat "$CookiesFile" | grep password > /dev/null
        then
          User=$(cat "$CookiesFile" | grep profile | awk '{print $7}')
          Com_upsolid
          Com_textline "LORA приветствует тебя, $User."
          Com_downsolid
        else
          return 1
      fi
    else
      return 1
  fi;
}

CmdAdd 'Com_login' 'Логин на ЛОРе' 'login'
Com_login()
{
  # Запрос логина
  
  if Com_IsLoggedIn
    then return
  fi
  
  Com_helptitle
  
  Com_textline "Введите ваши логин и пароль для авторизации."
  Com_textline "вы можете оставить поле пустым для анонимного входа и"
  Com_textline "использовать команду “login” для авторизации позже."
  
  Com_downsolid
  
  read -p "Логин: " Login
  
  # Опрос пользователя.

  if [[ $Login = "" ]]
    then
      Com_upsolid
      Com_textline "Активирован анонимный вход."
      Com_downsolid
      Anonymous=1
    else
      read -p "Пароль: " -s Password
      if [[ $Password = "" ]]
        then
          echo
          Com_upsolid
          Com_textline "Активирован анонимный вход."
          Com_downsolid
          Anonymous=1
          return
        fi
    #Получаем файл с куками
    wget -qO/dev/null --post-data="nick=$Login&passwd=$Password" --save-cookies="$CookiesFile" "$LorAddress$LoginAddress"
    if [[ ! $(Com_IsLoggedIn) ]]
      then
        echo
        Com_upsolid
        Com_textline "Не удалось авторизоваться, активирован анонимный вход."
        Com_downsolid
        Anonymous=1
      else
        echo
        Com_upsolid
        Com_textline "Успешная авторизация пользователем $Login."
        Com_downsolid
        Anonymous=0
    fi
  fi
}
