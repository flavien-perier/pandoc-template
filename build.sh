#!/bin/bash
# Flavien PERIER <perier@flavien.cc>
# Build pandoc files

LOGFILE=../debug.log
DELETE_LOGFILE=1
CREATEION_DATE=`date +"%Y-%m-%d"`

mkdir -p build
mkdir -p resources/style

if [ ! -f ./resources/style/eisvogel.latex ]
then
	echo "Import eisvogel"
	cd /tmp
	git clone https://github.com/Wandmalfarbe/pandoc-latex-template.git
	cd -

	cp /tmp/pandoc-latex-template/eisvogel.tex ./resources/style/eisvogel.latex
	rm -Rf /tmp/pandoc-latex-template/
fi

cd documents

echo -e "Logs: $CREATEION_DATE\n" > `echo $LOGFILE`

ls *.md | while read FILE
do
	NBR_LINES=`cat $FILE | wc -c`
	NBR_PAGES=`expr $NBR_LINES / 2250`
	PDF_FILE_NAME=`echo $FILE | sed s/.md$/.pdf/`

	echo "$FILE: $NBR_PAGES pages"
	echo "$FILE" >> `echo $LOGFILE`
	cat $FILE ../resources/annotations.md | pandoc --from markdown -o "../build/$PDF_FILE_NAME" --template "../resources/style/eisvogel.latex" --listings -N 2>>`echo $LOGFILE`
	if [ $? -eq 0 ]
	then
		echo -e "\t- [OK]"
	else
		echo -e "\t- [ERROR]"
		DELETE_LOGFILE=0
	fi
	echo -e "\n" >> `echo $LOGFILE`
done

if [ $DELETE_LOGFILE -eq 1 ]
then
	rm $LOGFILE
	exit 1
fi

exit 0