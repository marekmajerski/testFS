#!/bin/bash
#
#   __     __)                    __     __)                          
#  (, /|  /|              /)     (, /|  /|       ,             /)   , 
#    / | / |  _   __   _ (/_       / | / |  _       _  __  _  (/_     
# ) /  |/  |_(_(_/ (__(/_/(__   ) /  |/  |_(_(_ /__(/_/ (_/_)_/(___(_ 
#(_/   '                       (_/   '       .-/                      
#                                           (_/        
#
#Funkcja CreateFile tworzy od i=0 do $1 (podanego przez uzytkownika) pliki
#na dysku (podanego przez usera)


mkdir -p /media/test/marek/$3

for (( i=0; $i < $1; ++i )) 
do
	#TODO zapisywanie do lokalizacj okreslonej przez usera
	#do określonego dysku,folderu zmienna $3 wejdzie zamiast folderu test	
	dd if=/dev/urandom of=$3/f$i bs=$2 count=1 2>/dev/null
done
exit 0



