#!/bin/bash

#exit

CmdAdd 'Com_exit' 'Выход' 'exit' 'end'
Com_exit()
{
  Com_upsolid
  Com_textline "Помните, anonymous любит вас."
  Com_downsolid
  exit 0
}
