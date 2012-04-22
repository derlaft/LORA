#!/bin/bash

# LORA v.0.0.1

ConfigsPath="$HOME/.LORA"
ProgramPath="/LORA";
PagesPath="/pages";
TrackerFileName="/tracker.html";
VarTmpPath="/var/tmp";
TempFileName="/temp";
TempFileName2="/temp2";

LorAddress="https://www.linux.org.ru";
TrackerAddress="/tracker/";

Login="";
Password="";
Anonymous=0;

TermCols=$(stty size | cut -d " " -f 2);
TermRows=$(stty size | cut -d " " -f 1);

mkdir $VarTmpPath$ProgramPath 2> /dev/null;
mkdir $VarTmpPath$ProgramPath$PagesPath  2> /dev/null;
mkdir "$ConfigsPath" 2> /dev/null

# Блок функций

Com_upsolid()
{
	i=2;
	
	echo -n "┍";
	
	while [ "$i" != "$TermCols" ]
	do
		echo -n "━";
		
		i=$(($i+1));
	done;
	
	echo "┑";
}

Com_uptracker()
{
 echo -n;
 # Работаю над этим
}

Com_downsolid()
{
	i=2;
	
	echo -n "┕";
	
	while [ "$i" != "$TermCols" ]
	do
		echo -n "━";
		
		i=$(($i+1));
	done;
	
	echo "┙";
}

Com_textline()
{
	Text=$1;
	NeedCols=$(($TermCols-4));
	Text="${Text::${NeedCols}}";
	
	while [ ${#Text} != $NeedCols ]
	do
		Text="$Text ";
	done;
	
	echo "│ $Text │";
}

Com_greet()
{
	Com_upsolid;
	
	Com_textline "Добро пожаловать в систему консольного доступа “LORA” v. 0.1";
	
	Com_downsolid;
}

Com_exit()
{
	echo "Помните, anonymous любит вас.";
	exit 0;
}

Com_login()
{
	# Запрос логина
	
	Com_upsolid;
	
	Com_textline "Введите ваши логин и пароль для авторизации.";
	Com_textline "вы можете оставить поле пустым для анонимного входа и";
	Com_textline "использовать команду “login” для авторизации позже.";
	
	Com_downsolid;
	
	echo -n "Логин:";
	
	read Login;
	
        # Опрос пользователя.

        if [[ $Login = "" ]]
                then
                        echo "Активирован анонимный вход.";
                        Anonymous=1;
                else
                        read -p "Пароль: " -s Password;
                        if [[ $Password = "" ]]
                                then
                                        echo "Активирован анонимный вход.";
                                        Anonymous=1;
                        fi;
                        #Получаем файл с куками
                        wget -qO/dev/null --post-data="nick=$Login&passwd=$Password" --save-cookies="$ConfigsPath/cookies.txt" http://www.linux.org.ru/login.jsp
                        if cat "$ConfigsPath/cookies.txt" | grep password > /dev/null
                                then
                                        echo "Успешный вход"
                                else
                                        echo "Не удалось войти, активирован анонимный вход"
                                        Anonymous=1;
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
			if [[ $2 -gt 20 ]]
				then
					Count=20;
				else
					Count=$2;
			fi;
	fi;
	
	ForumPattern="<div class=forum>";
	TopicPattern="<tbody>";
	
	rm $VarTmpPath$ProgramPath$PagesPath$TrackerFileName 2> /dev/null;
	wget -q $LorAddress$TrackerAddress -O $VarTmpPath$ProgramPath$PagesPath$TrackerFileName;
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
	sed -e "s/<tr>//g;s/<\/tr>//g;s/<\/a>//g;s/<\/td>//g;s/<td>//g;s/ *$//;/^$/d;1,/$ForumPattern/d;1,/$TopicPattern/d" $VarTmpPath$ProgramPath$PagesPath$TrackerFileName > $VarTmpPath$ProgramPath$PagesPath$TempFileName;
	
	# Номера тредов
	Numbers=$(grep -oE --regexp="/[0-9]{7}" $VarTmpPath$ProgramPath$PagesPath$TempFileName | sed -e "s/\///g");
	
	# sed
	# удалить теги: s/<[^>]*>//g;
	# удалить пробелы в начале строк: s/^[ \t]*//;
	# удалить пустые строки: /^$/d;
	sed -e "s/<[^>]*>//g;s/^[ \t]*//;/^$/d;" $VarTmpPath$ProgramPath$PagesPath$TempFileName > $VarTmpPath$ProgramPath$PagesPath$TempFileName2
	
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
		Group=$(sed -n "1p" $VarTmpPath$ProgramPath$PagesPath$TempFileName2);
		
		Group=$(echo -n "$Group" | sed -e "s/, не подтверждено//");
		
		Group="${Group::15}";
		
		while [ ${#Group} != "16" ]
		do
			Group="$Group ";
		done;
		
		echo -n "$Group";
		
		Signal=$(sed -n "2p" $VarTmpPath$ProgramPath$PagesPath$TempFileName2 | tr -d '\012');
		
		
		while [ "${Signal::1}" != '(' ]
		do
			#sed
			#удаляем строку: 1d;
			sed -e "1d" $VarTmpPath$ProgramPath$PagesPath$TempFileName2 > $VarTmpPath$ProgramPath$PagesPath$TempFileName;
			
			rm -f $VarTmpPath$ProgramPath$PagesPath$TempFileName2;
			mv -f $VarTmpPath$ProgramPath$PagesPath$TempFileName $VarTmpPath$ProgramPath$PagesPath$TempFileName2;
			
			Signal=$(sed -n "2p" $VarTmpPath$ProgramPath$PagesPath$TempFileName2 | tr -d '\012');
		done;
		
		TopicName=$(sed -n "1p" $VarTmpPath$ProgramPath$PagesPath$TempFileName2);
		
		TopicName="${TopicName::50}";
		
		while [ ${#TopicName} != "50" ]
		do
			TopicName="$TopicName ";
		done;
		
		echo -n "$TopicName";
		
		#sed
		#удалить 4 строки: 1,4d;
		sed -e "1,4d" $VarTmpPath$ProgramPath$PagesPath$TempFileName2 > $VarTmpPath$ProgramPath$PagesPath$TempFileName;
		
		rm -f $VarTmpPath$ProgramPath$PagesPath$TempFileName2;
		mv -f $VarTmpPath$ProgramPath$PagesPath$TempFileName $VarTmpPath$ProgramPath$PagesPath$TempFileName2;
		
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

Com_greet;

Com_login;

while [ "$Command" != "exit" ];
do
	
	echo -n "LORA>";
	read Command;
	
	case "$Command" in
		"tracker"*) Com_tracker $Command;;
		
		# TODO Добавить комментарий после 2-й ф-ии: http://www.linux.org.ru/forum/talks/7671922?cid=7672261
	esac;
	
done;

Com_exit;
