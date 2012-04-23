#!/bin/bash

#tracker

CmdAdd 'Com_tracker' 'Показать трекер' 'tracker'
Com_tracker()
{
  Count="$1"
  if [[ "$Count" = "" ]] || [[ "$Count" -gt 20 ]]
    then
      Count=20
    else
      case $1 in
        *[!0-9]*|"")
          Com_upsolid
          Com_textline "W: Введено некорректное количество тем."
          Com_textline "   Используется значение по умолчанию."
          Com_downsolid
          Count=20;
        ;;
      esac
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
  
 # echo "┍━ Индекс ━ Группа ━━━━━━━━ Заголовок ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┑"
  
  Com_uptracker
  
  i=1
  while [ $i -le $Count ]
  do
    
    # sed
    # вывести i-ю строку: ${i}p
    
    # Индекс топика
    Index=$(echo -n "$Numbers" | sed -n "${i}p" | tr -d '\012') # + 2 пробела
    
    # Имя раздела
    Group=$(echo -e "$cleared2" | sed -n "1p")
    Group=$(echo -n "$Group" | sed -e "s/, не подтверждено//")
    Group="${Group::15}"
    
    while [ ${#Group} != "16" ]
    do
      Group="$Group "
    done
    
    Signal=$(echo -e "$cleared2" | sed -n "2p" | tr -d '\012')
    
    
    while [ "${Signal::1}" != '(' ]
    do
      #sed
      #удаляем строку: 1d
      cleared2=$(echo -e "$cleared2" | sed -e "1d")
      Signal=$(echo -e "$cleared2" | sed -n "2p" | tr -d '\012')
    done
    
    TopicName=$(echo -e "$cleared2" | sed -n "1p")
    TopicNameLimit=$(($TermCols-30));
    TopicName="${TopicName::$TopicNameLimit}"
    
    while [ ${#TopicName} != "$TopicNameLimit" ]
    do
      TopicName="$TopicName "
    done
    
    Com_textline "$Index  $Group$TopicName"
    
    #sed
    #удалить 4 строки: 1,4d
    cleared2=$(echo -e "$cleared2" | sed -e "1,4d")
    
    i=$((i+1))
  done
  
  Com_downsolid
}
