#!/bin/bash

printf "\nWelcome to Bash-Translator\n"

first="$1"

function main(){

	printf "\nEnter a word:\n"
	#variable $1 added
	var_word=$first

	#read var_word
	
	word_HEX=$(printf $var_word| xxd -p -u -i| sed 's/ 0X/%/g; s/%0A//; s/,//g'| tr -d "[:space:]")

	tildaP="\e[93m~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\e[0m"

	resultP="\e[93mResult|Резултат\e[0m"

	egP="\e[93mExamples|Примери\e[0m"

	#ENG
	if [[ $var_word = [A-z]* ]];
	then
		curl -s https://bg.glosbe.com/en/bg/$var_word > $HOME/.Bash-Translator-temp

		# Results	
		printf "\n $resultP\n"
		
		# With sed command
		grep -m 3 'data-translation=' $HOME/.Bash-Translator-temp| grep -o -E '"[А-я]*"'| sed '/"phrase"/d; s/"//g'

		# Examples
		printf "\n $egP\n"

		grep -A 1 -m 3 '<p lang="en" >' $HOME/.Bash-Translator-temp| sed 's|<p lang="en" >|EN - |; s|<p class="ml-4 " >|BG - |; s|<strong>||g; s|</strong>||g; s|</p>||; s|&#39;|`|g'
		
		printf $tildaP

	#BG
	elif [[ $var_word != [A-z]* ]];
	then
		# Without File
		#curl -s https://bg.glosbe.com/bg/en/$word_HEX| grep '<p >'
		
		# With File
		curl -s https://bg.glosbe.com/bg/en/$word_HEX > $HOME/.Bash-Translator-temp

		# Results
		printf "\n $resultP\n"
		
		# With sed command
		grep -m 3 'data-translation=' $HOME/.Bash-Translator-temp| grep -o -E '"[a-z]*"'| sed '/"phrase"/d; s/"//g'

		# With tr command
		#grep -m 3 'data-translation=' $HOME/.Bash-Translator-temp| grep -o -E '"[a-z]*"'| sed '/"phrase"/d'| tr -d /\"/
		# Examples
		printf "\n $egP\n"
		
		grep -A 1 -m 3 '<p >' $HOME/.Bash-Translator-temp | sed 's|<p class="ml-4 " lang="en" >|EN - |; s|<p >|BG - |; s|<strong>||g; s|</strong>||g; s|</p>||; s|&#39;|`|g'

		printf $tildaP
	fi
	
	options
}

function otherSource() {
	
	curl -s https://www.ezikov.com/translate/$var_word > $HOME/.Bash-Translator-temp

		# Results	
		printf "\n $resultP\n"
		
		# With sed command
		grep "<li>" $HOME/.Bash-Translator-temp| grep -v "<li><a" | sed -E "s:<li>|<\/li>.*::g; s:<i>|<\/i>::g"

		printf $tildaP

		printf "\n\e[1;101m*Advise: Don't use s (save word) while using o (search with other source)\e[0m"

		options
}

function options(){

	printf "\n\nType \e[1;93mn\e[0m (\e[1;93mnew word\e[0m) | \e[1;92ms\e[0m (\e[1;92msave word\e[0m) | \e[1;95mo\e[0m (\e[1;95msearch with other source\e[0m) | \e[1;91mq\e[0m (\e[1;91mquit\e[0m)\n"

	read option

	if [ $option = q ]; 
	then
		exit

	#Save words option for Anki
	elif [ $option = s ]; 
	then
		if [[ $var_word = [A-z]* ]]
		then
			echo $(echo -n $var_word":" && grep -m 3 'data-translation=' $HOME/.Bash-Translator-temp| grep -o -E '"[А-я]*"'| sed '/"phrase"/d; s/"//g'| tr '\n' ' ') >> Eng-Words.txt

		printf "\nWord has been \e[1;92msaved\e[0m in Eng-Words.txt (PATH:\$HOME)\n"

		elif [[ $var_word != [A-z]* ]]	
		then
			echo $(echo -n $var_word":" && grep -m 3 'data-translation=' $HOME/.Bash-Translator-temp| grep -o -E '"[A-z]*"'| sed '/"phrase"/d; s/"//g'| tr '\n' ' ') >> Bg-Words.txt

		printf "\nWord has been \e[1;92msaved\e[0m in Bg-Words.txt (PATH:\$HOME)\n"
		fi

		options

	elif [ $option = n ]; 
	then
		main

	elif [ $option = o ];
	then
		otherSource
	fi
}
main
options

