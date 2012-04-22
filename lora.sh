#!/bin/bash

# LORA v.0.0.1

echo "Добро пожаловать в систему консольного доступа \"LORA\" v. 0.1";
echo "_____________________________________________________";

ProgramPath=$HOME"/.LORA";
PagesPath="/pages";
TrackerFileName="/tracker.html";
TempFileName="/temp";
TempFileName2="/temp2";

LorAddress="https://www.linux.org.ru";
TrackerAddress="/tracker/";

Login="";
Password="";
Anonimous=0;

mkdir $PagePath 2> /dev/null;
mkdir $PagePath$PagesPath  2> /dev/null;

# Блок функций

Com_exit()
{
	echo "Спасибо за пользование программой";
	exit 0;
}

Com_login()
{
	# Запрос логина
	
	echo "Введите ваш логин для авторизации или оставьте поле пустым для";
	echo "анонимного использования (в этом случае вы сможете авторизоваться";
	echo "позже при помощи команды \"login\")";
	echo "-----------------------------------------------------";
	
	echo -n "Логин:";
	
	read Login;
	
	# Опрос пользователя.
	
	if [[ $Login = "" ]]
		then
			echo "Активирован анонимный вход.";
			Anonimous=1;
		else
			echo -n "Пароль:";
			read -s Password;
			if [[ $Password = "" ]]
				then
					echo "Активирован анонимный вход.";
					Anonimous=1;
			fi;
			echo;
	fi;
}

Com_tracker()
{
	if [[ $2 = "" ]]
		then
			Count=20
		else
			Count=$2;
	fi;
	
	ForumPattern="<div class=forum>";
	TopicPattern="<tbody>";
	
	rm $ProgramPath$PagesPath$TrackerFileName 2> /dev/null;
	wget -q $LorAddress$TrackerAddress -O $ProgramPath$PagesPath$TrackerFileName;
	# echo "┍━ Индекс ━ Группа ━━━━━━━━ Заголовок ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┑"
	# echo "│ 7668145  Web-development Как пропатчить KDE под FreeBSD?                    │";
	# echo "┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┙";
	
	# sed:
	# удалить все <tr>: s/<tr>//g;
	# удалить все </tr>: s/<\/tr>//g;
	# удалить все </a>: s/<\/a>//g;
	# удалить все </td>: s/<\/td>//g;
	# удалить все </td>: s/<td>//g;
	# удалить строки из пробелов: s/ *$//;
	# удалить пустые строки: /^$/d;
	# удалить строки до начала форумного дива: 1,/$ForumPattern/d;
	# удалить строки до начала форумной таблицы: 1,/$TopicPattern/d;
	sed -e "s/<tr>//g;s/<\/tr>//g;s/<\/a>//g;s/<\/td>//g;s/<td>//g;s/ *$//;/^$/d;1,/$ForumPattern/d;1,/$TopicPattern/d" $ProgramPath$PagesPath$TrackerFileName > $ProgramPath$PagesPath$TempFileName;
	
	# Номера тредов
	Numbers=$(grep -oE --regexp="/[0-9]{7}" $ProgramPath$PagesPath$TempFileName | sed -e "s/\///g");
	
	# sed
	# удалить теги: s/<[^>]*>//g;
	# удалить пробелы в начале строк: s/^[ \t]*//;
	# удалить пустые строки: /^$/d;
	sed -e "s/<[^>]*>//g;s/^[ \t]*//;/^$/d;" $ProgramPath$PagesPath$TempFileName > $ProgramPath$PagesPath$TempFileName2
	
	echo "┍━ Индекс ━ Группа ━━━━━━━━ Заголовок ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┑";
	
	i=1;
	while [ $i -le $Count ]
	do
		echo -n "│ "
		
		# sed
		# вывести i-ю строку: ${i}p;
		
		# Индекс топика
		echo -n "$Numbers" | sed -n "${i}p" | tr -d '\012';
		
		echo -n "  ";
		
		# Имя раздела
		Group=$(sed -n "1p" $ProgramPath$PagesPath$TempFileName2);
		
		Group=$(echo -n "$Group" | sed -e "s/, не подтверждено//");
		
		Group="${Group::15}";
		
		while [ ${#Group} != "16" ]
		do
			Group="$Group ";
		done;
		
		echo -n "$Group";
		
		Signal=$(sed -n "2p" $ProgramPath$PagesPath$TempFileName2 | tr -d '\012');
		
		
		while [ "${Signal::1}" != "(" ]
		do
			#sed
			#удаляем строку: 1d;
			sed -e "1d" $ProgramPath$PagesPath$TempFileName2 > $ProgramPath$PagesPath$TempFileName;
			
			rm -f $ProgramPath$PagesPath$TempFileName2;
			mv -f $ProgramPath$PagesPath$TempFileName $ProgramPath$PagesPath$TempFileName2;
			
			Signal=$(sed -n "2p" $ProgramPath$PagesPath$TempFileName2 | tr -d '\012');
		done;
		
		TopicName=$(sed -n "1p" $ProgramPath$PagesPath$TempFileName2);
		
		TopicName="${TopicName::50}";
		
		while [ ${#TopicName} != "50" ]
		do
			TopicName="$TopicName ";
		done;
		
		echo -n "$TopicName";
		
		#sed
		#удалить 4 строки: 1,4d;
		sed -e "1,4d" $ProgramPath$PagesPath$TempFileName2 > $ProgramPath$PagesPath$TempFileName;
		
		rm -f $ProgramPath$PagesPath$TempFileName2;
		mv -f $ProgramPath$PagesPath$TempFileName $ProgramPath$PagesPath$TempFileName2;
		
		i=$(($i+1));
		echo " │";
	done;
	echo "┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┙";
}

# Еще команды:
# thread - показывает тред. thread xxxxxxxx
# info - показывает информацию о треде. info xxxxxxxxxx
# profile - показывает информацию о пользователе. profile xxxxxxxxxx
# answer - ответить на сообщение answer xxxxxxxx
# history - показать историю запросов с возможностью выбора повторной отправки

Com_login;

while [ "$Command" != "exit" ];
do
	
	echo -n "LORA>";
	read Command;
	
	case "$Command" in
		"tracker"*) Com_tracker $Command;;
	esac;
	
done;

Com_exit;
