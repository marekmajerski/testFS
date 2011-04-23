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
	location=location_File
	backup=backup_Archive
	user=user_File
	log=log_File
	mountDev=mountDev_File
	mountDir=mountDir_File
	setFS=setFS_File
	fsTable=fsTable_File
	dirTable=dirTable_File
}

function Menu
{
	dialog --title "Okno menu" \
	--backtitle "Tester ver. 1.0" \
	--menu "Wybierz opcję" 17 60 8 \
	1 "Przygotuj folder do testow" \
	2 "Montowanie partycji" \
	3 "Uruchom skrypt testujący" \
	4 "Usuwanie Folderu testowego"\
	5 "Czyszczenie plikow tymczasowych"\
	6 "Odmontowywanie partycji"\
	7 "Zakończ" 2>$tmpFile
	selectOption=`cat tmp_File`

	case $selectOption in
	1) MakeDir ;;
	2) MountDir ;;
	3) Generate ;;
	4) DeleteDir ;;
	5) DeleteFiles ;;
	6) UnmountDir ;;
	7) Finish ;;
	esac	

	clear	
}


function MountDir
{
	diskList=`cat fsTable_File`	
	dialog --title "Pobieranie danych od uzytkownika" \
	--backtitle "Tester ver. 1.0" \
	--inputbox "podaj nazwe urządzenia do zamontowania:
	$diskList" 15 60 2>$mountDev
	devLocation=`cat mountDev_File`
	
	ls -R /home/$userPath/ | grep ":$" > $dirTable
	dirList=`cat dirTable_File`
	dialog --title "Pobieranie danych od uzytkownika" \
	--backtitle "Tester ver. 1.0" \
	--inputbox "podaj nazwe folderu do zamontowania: 
	$dirList" 15 60 2>$mountDir
	dirLocation=`cat mountDir_File`

	dialog --title "Pobieranie danych od użytkownika" \
	--backtitle "Tester ver. 1.0" \
	--inputbox "podaj system plikow w jakim ma byc zamontowana partycja" 8 60 2>$setFS
	typeFS=`cat setFS_File`

	sudo mount -t $typeFS /$devLocation /$dirLocation
	
	dialog --title "Tworzenie folderu" \
	--backtitle "Tester ver. 1.0" \
	--msgbox "zamontowano urzadzenia $devLocation do 
	folderu $dirLocation w systemie plikow $typeFS." 15 35
	echo $selectOption
	
	Menu
}

function UnmountDir
{
	
	ls -R /home/$userPath/ | grep ":$" > $dirTable
	dirList=`cat dirTable_File`
	dialog --title "Pobieranie danych od uzytkownika" \
	--backtitle "Tester ver. 1.0" \
	--inputbox "podaj nazwe folderu do odmontowania:
	dostępne foldery 
	$dirList" 15 60 2>$mountDir
	dirLocation=`cat mountDir_File`

	sudo umount /$dirLocation
	
	dialog --title "Tworzenie folderu" \
	--backtitle "Tester ver. 1.0" \
	--msgbox "odmontowano folder $dirLocation" 15 35
	echo $selectOption
	
	Menu
}

function MakeDir
{
	SetFile
	#pobieranie ścieżki do montowania
	dialog --title "Pobieranie danych od uzytkownika" \
	--backtitle "Tester ver. 1.0" \
	--inputbox "Podaj nazwe folderu do zapisu testowych plikow:" 9 60 2>$location
	
	
	locationPath=`cat location_File`
	userPath=`cat user_File`
	sudo mkdir -p /home/$userPath/$locationPath
	
	#dialog --title "Tworzenie folderu" \
	#--backtitle "Tester ver. 1.0" \
	#--msgbox "Wykonano" 5 15
	#echo $selectOption
	
	Menu
	
}

function DeleteFiles
{
		if [ -e tmp_File ]; then
		rm -f *_File
		
		dialog --title "Usuwanie" \
		--backtitle "Tester ver. 1.0" \
		--msgbox "Wykonano" 15 20
		echo $selectOption
	else
		error = `cat tmp_File`	
		dialog --title "Usuwanie" \
		--backtitle "Tester ver. 1.0" \
		--msgbox "Wystapil blad $error" 15 20
		echo $selectOption
	fi
	Menu
}

function Generate
{
	SetFile

	#pobieranie do zmiennej fileValue ilosci plików od użytkownika
	dialog --title "Pobieranie danych od uzytkownika" \
	--backtitle "Tester ver. 1.0" \
	--inputbox "Podaj ilosc plikow:" 8 60 2>$tmpFile
	fileValue=`cat tmp_File`
	


	#pobieranie rozmiaruplików do zmiennej fileSize
	dialog --title "Pobieranie danych od użytkownika" \
	--backtitle "Tester ver. 1.0" \
	--inputbox "Podaj rozmiar pojedynczego pliku" 8 60 2>$tmpFile
	fileSize=`cat tmp_File`
	dirLocation=`cat mountDir_File`
	
	sudo /usr/bin/time -p ./CreateFile.sh $fileValue $fileSize $dirLocation 2>$tmpFile
	workingTimeFinish=`cat tmp_File`
	echo $workingTimeFinish >> $backup


	#wrzucam wynik do skryptu generującego html
	./Results.sh $workingTimeFinish $fileValue $fileSize


	dialog --title "Wykonano" --backtitle "Tester ver. 1.0" \
	--msgbox "$workingTimeFinish" 9 50


	Menu
}

function DeleteDir
{
	SetFile
	userPath=`cat user_File`
	ls -R /home/$userPath/ | grep ":$" > $dirTable
	dirList=`cat dirTable_File`
	
	dialog --title "Pobieranie danych od uzytkownika" \
	--backtitle "Tester ver. 1.0" \
	--inputbox "Podaj nazwe folderu do usuniecia 
	$dirList" 17 60 2>$location
	
	locationPath=`cat location_File`
	userPath=`cat user_File`
	
	if [ -s /location_File ]; then
		
		sudo rm -rf /home/$userPath/$locationPath/
		
		dialog --title "Usuwanie" \
		--backtitle "Tester ver. 1.0" \
		--msgbox "Wykonano" 15 20
		echo $selectOption
	else
		error=`cat tmp_File`
		dialog --title "Usuwanie" \
		--backtitle "Tester ver. 1.0" \
		--msgbox "Wystapil blad 
		$error" 15 20
		echo $selectOption
	fi
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
	whoami > $user
	userPath=`cat user_File`
	ls -R /home/$userPath/ | grep ":$" > $dirTable
	sudo fdisk -l | grep /dev > $fsTable	
Menu











