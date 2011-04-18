#!/bin/bash

tmpFile=tmp_File

dialog --title "Pobieranie danych od użytkownika" \
--backtitle "Tester ver. 1.0" \
--inputbox "Podaj typ systemu plikow" 8 60 2>$tmpFile
selectOption=`cat tmp_File`
	
#echo `mkfs -T $selectOption /dev/sdb1 -F`>$tmpFile
#fsFormatResult=`cat tmp_File`
fdisk /dev/sdb <<EOF\
c
m
d
w
EOF>$tmpFile

fdisk /dev/sdb <<EOF
m
n
p
1


w
EOF>>$tmpFile
fdiskMenu=`cat tmp_File`
	
	

dialog --title "Wykonano" --backtitle "Tester ver. 1.0" \
--msgbox "$fdiskMenu" 40 100
