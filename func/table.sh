#!/bin/bash

#table functions

Com_downsolid()
{
  i=2
  
  echo -n "┕"
  
  while [ "$i" != "$TermCols" ]
  do
    echo -n "━"
    i=$((i+1))
  done
  
  echo "┙"
}

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

Com_textline()
{
  Text=$1
  NeedCols=$((TermCols-4))
  Text="${Text::${NeedCols}}"
  
  while [ ${#Text} != $NeedCols ]
  do
    Text="$Text "
  done
  
  echo "│ $Text │"
}


