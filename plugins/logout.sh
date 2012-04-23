#!/bin/bash

#logout

CmdAdd 'Com_logout' 'Разлогиниться' 'logout'
Com_logout()
{
  rm -f "$ConfigsPath$CookiesFile" 2> /dev/null
  Anonymous=1;
  
  Com_upsolid
  Com_textline "Теперь ты anonymous, %username%"
  Com_downsolid
}
