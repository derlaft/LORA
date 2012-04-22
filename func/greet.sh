#!/bin/bash

#greet

CmdAdd 'Com_greet' 'greet' 'motd'
Com_greet()
{
  Com_upsolid
  Com_textline "Добро пожаловать в систему консольного доступа “LORA” v. 0.1"
  Com_downsolid
}

