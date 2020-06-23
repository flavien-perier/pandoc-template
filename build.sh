#!/bin/bash
# Flavien PERIER <perier@flavien.io>
# Build pandoc files

LOGFILE=./debug.log
DELETE_LOGFILE=1
CREATEION_DATE=`date +"%Y-%m-%d"`

mkdir -p build
mkdir -p resources/style

if [ ! -f ./resources/style/eisvogel.latex ]
then
	echo "Import eisvogel"
	curl https://raw.githubusercontent.com/Wandmalfarbe/pandoc-latex-template/master/eisvogel.tex > ./resources/style/eisvogel.latex
fi

if [ ! -f ./resources/style/multiple-sclerosis-journal.csl ]
then
	echo "Import multiple-sclerosis-journal"
	curl https://raw.githubusercontent.com/citation-style-language/styles/master/multiple-sclerosis-journal.csl > ./resources/style/multiple-sclerosis-journal.csl
fi

echo -e "Logs: $CREATEION_DATE\n" > `echo $LOGFILE`

for FILE in `ls ./documents/*.md | rev | cut -f1 -d / | rev`
do
	FILE_PATH="./documents/$FILE"
	NBR_CHARACTERS=`cat $FILE_PATH | wc -c`
	NBR_PAGES=`expr $NBR_CHARACTERS / 2250`
	PDF_FILE_NAME=`echo $FILE | sed s/.md$/.pdf/`

	echo "$FILE: $NBR_PAGES pages"
	echo "$FILE" >> `echo $LOGFILE`
	cat ./resources/annotations/*.md | sed "1i\\\n\n" | cat $FILE_PATH - | pandoc \
		--from markdown \
		--standalone \
		-o "./build/$PDF_FILE_NAME" \
		--filter "pandoc-citeproc" \
		--template "./resources/style/eisvogel.latex" \
		--csl "./resources/style/multiple-sclerosis-journal.csl" \
		--bibliography "./resources/bibliography/document.bib" \
		2>>`echo $LOGFILE`
	if [ $? -eq 0 ]
	then
		echo -e "\t- [OK]"
	else
		echo -e "\t- [ERROR]"
		DELETE_LOGFILE=0
	fi
	echo -e "\n" >> `echo $LOGFILE`
done

if [ $DELETE_LOGFILE -eq 0 ]
then
	exit 1
fi

rm $LOGFILE
exit 0
