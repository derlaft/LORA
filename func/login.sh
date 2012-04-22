#!/bin/bash

#login

Com_IsLoggedIn() {
  if cat "$ConfigsPath/cookies.txt" | grep password > /dev/null
    then
      echo "Привет, $(cat ~/.LORA/cookies.txt |grep profile|awk '{print $7}')"
    else
      return 1
  fi
}

CmdAdd 'Com_login' 'Логин на лоре' 'login'
Com_login()
{
  # Запрос логина
  
  Com_upsolid
  
  Com_textline "Введите ваши логин и пароль для авторизации."
  Com_textline "вы можете оставить поле пустым для анонимного входа и"
  Com_textline "использовать команду “login” для авторизации позже."
  
  Com_downsolid
  if Com_IsLoggedIn
    then return
  fi

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
    if [ ! $(Com_IsLoggedIn) ]
      then
        echo "Не удалось войти, активирован анонимный вход"
        Anonymous=1
      fi
    echo
  fi
}
