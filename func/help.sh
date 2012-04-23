#!/bin/bash

#help

Com_helptitle()
{
  j=12
  echo -n "┍━ Справка ━"
  while [ $j != $(($TermCols-1)) ]
  do
    echo -n "━"
    j=$(($j+1))
  done
  echo "┑";
}

CmdAdd 'Com_help' 'Показать список команд' 'help' 'h' '?'
Com_help()
{
  Com_helptitle

  #Сделано очень аццки, надеюсь, что будет более хороший вариант
  #Так пойдет? //Al.
  Help=$(echo -e "$CMDS" | sed -e 's/^.*SHELP//;s/EHELP.*//g')
  Line=1
  
  echo -e "$Help" | while read HelpInfo
    do
      Names=""
      for alias in $(echo -ne "$CMDS" | sed -n "${Line}p" | sed -e 's/ /\n/g' | grep '|' | sed -e 's/|/ /g')
      do
        Names=$Names$(echo -ne "$alias ")
      done
      
      while [ ${#Names} != "20" ]
      do
        Names="$Names "
      done
      
      Com_textline "$Names: $HelpInfo"
      
      Line=$((Line+1))
    done
  
  Com_downsolid
}
