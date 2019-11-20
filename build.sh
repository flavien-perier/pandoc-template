#!/bin/bash

mkdir build 2>/dev/null

cd documents
ls *.md | while read FILE
do
	NBR_LINES=`cat $FILE | wc -c`
	PDF_FILE_NAME=`echo $FILE | sed s/.md$/.pdf/`

	echo "$FILE: $(expr $NBR_LINES / 2250) pages"
	cat $FILE ../resources/annotations.md | pandoc --from markdown -o "../build/$PDF_FILE_NAME" --template "../resources/style/eisvogel.latex" --listings -N 2>/dev/null
	if [ $? -eq 0 ]
	then
		echo -e "\t- [OK]"
	else
		echo -e "\t- [ERROR]"
	fi
done
