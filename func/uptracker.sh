#!/bin/bash

#uptracker

Com_uptracker()
{
  j=40
  echo -n "┍━ Индекс ━ Группа ━━━━━━━━ Заголовок ━━"
  while [ $j != $(($TermCols-1)) ]
  do
    echo -n "━"
    j=$(($j+1))
  done
  echo "┑";
}
