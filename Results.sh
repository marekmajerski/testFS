#!/bin/bash
#Funkcja tworząca plik html z wynikami <początki awk>
#funkcja ta przyjmuje informacje o wielkości pliku, ich ilości a także o wyniku
function MainTable
	{
	echo " <html> " >> tab.html
	echo " <title> Wyniki tworzenia plików <title>" >> tab.html
	echo " <body> " >> tab.html
	}
function ResultTable
	{
	echo " <b> Wynik tworzenia " $7 " plikow o wielkosci " $8 " bajtow dla systemu plików</b><br><br>" >> tab.html
	echo " <table border=1> " >> tab.html 
	echo " <tr><td>"$1"</td>" "<td>"$2"</td></tr>" "<tr><td>"$5"</td>" "<td>"$6"</td></tr> " >> tab.html
	echo " <br><br> "

MainTable
ResultTable
