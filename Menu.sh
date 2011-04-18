#!/bin/bash
#
#   __     __)                    __     __)                          
#  (, /|  /|              /)     (, /|  /|       ,             /)   , 
#    / | / |  _   __   _ (/_       / | / |  _       _  __  _  (/_     
# ) /  |/  |_(_(_/ (__(/_/(__   ) /  |/  |_(_(_ /__(/_/ (_/_)_/(___(_ 
#(_/   '                       (_/   '       .-/                      
#                                           (_/        
#

function SetFile
{
	tmpFile=tmp_File
	backup=backup_File
}

function Menu
{
	dialog --title "Okno menu" \
	--backtitle "Tester ver. 1.0" \
	--menu "Wybierz opcję" 15 60 4 \
	1 "Uruchom skrypt testujący" \
	2 "Pomoc" \
	3 "Usuwanie Folderu testowego"\
	4 "Zakończ" 2>$tmpFile
	selectOption=`cat tmp_File`

	case $selectOption in
	1) Generate ;;
	2) Help ;;
	3) Delete ;;
	3) Finish ;;
	esac	

	clear	
}

function Generate
{
	setFile

	#pobieranie do zmiennej fileValue ilosci plików od użytkownika
	dialog --title "Podaj ilosc plikow" \
	--backtitle "Tester ver. 1.0" \
	--inputbox "Pobieranie danych od uzytkownika" 8 60 2>$tmpFile
	fileValue=`cat tmp_File`
	


	#pobieranie rozmiaruplików do zmiennej fileSize
	dialog --title "Podaj rozmiar pojedynczego pliku" \
	--backtitle "Tester ver. 1.0" \
	--inputbox "Pobieranie danych od użytkownika" 8 60 2>$tmpFile
	fileSize=`cat tmp_File`

	
	pathAddress="test"
	
	/usr/bin/time -p ./CreateFile.sh $fileValue $fileSize $pathAddress 2>$tmpFile
	workingTimeFinish=`cat tmp_File`
	echo $workingTimeFinish >> $backup


	#wrzucam wynik do skryptu generującego html
	./Results.sh $workingTimeFinish $fileValue $fileSize


	dialog --title "Wykonano" --backtitle "Tester ver. 1.0" \
	--msgbox "$workingTimeFinish" 9 50


	Menu
}



function Help
{
	dialog --title "Pomoc" \
	--backtitle "Tester ver. 1.0" \
	--msgbox "Program został napisany w jezyku skryptowym BASH. 
	Aplikacja zapisuje pliki o wielkościach i ilościach podanych przez urzytkownika.
	Aby aplikacja działała poprawnie niezbędne jest doinstalowanie biblioteki dialog,
	która zajmuje się wyświetlaniem interfejsu okienkowego.
	TO DO:
	aplikacja w wersji 2.0 będzie miała możliwość tworzenia partcji, 
	które będą zapisywane automatycznie do listy testującej. " 22 55
	echo $selectOption
	Menu
}

function Delete
{
	dialog --title "Usuwanie" \
	--backtitle "Tester ver. 1.0" \
	--msgbox "Wykonano" 22 55
	echo $selectOption
	rm -rf Test
	Menu
}

function Finish
{
	dialog --title "Zakonczenie programu" \
	--backtitle "Tester ver. 1.0" \
	--yesno "Wybierz tak lub nie." 10 60
	selectOption=$?
		case $selectOption in
		0) clear exit 0 ;;
		1) Menu ;;
		255) echo "[ESCAPE] key pressed" ;;
		esac
		
	
	echo "   __     __)                    __     __)                          	"
	echo "  (, /|  /|              /)     (, /|  /|       ,             /)   , 	"
	echo "    / | / |  _   __   _ (/_       / | / |  _       _  __  _  (/_     	"
	echo " ) /  |/  |_(_(_/ (__(/_/(__   ) /  |/  |_(_(_ /__(/_/ (_/_)_/(___(_ 	"
	echo "(_/   '                       (_/   '       .-/                      	"

}

SetFile
Menu










