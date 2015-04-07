#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Program handles building of SuperEasy-A4S"
	echo "!!Note that the BlitzMax code (A4S-Helper folder) should already be built!!"
	echo "Takes two arguments: Build.sh [32|64] [1|2|3]"
	echo "Argument 1:"
	echo "32 - 32bit java, 64 - 64 bit java"
	echo "Argument 2:"
	echo "1 - Windows, 2 - Mac, 3 - Linux"
	exit 0
fi

if [ $1 -eq 32 ]; then
	bits="32bit"
elif [ $1 -eq 64 ]; then
	bits="64bit"
else
	echo "Invalid first argument. Run Build.sh to see argument descriptions."
	exit 0
fi

if [ $2 -eq 1 ]; then
	platform="Windows"
elif [ $2 -eq 2 ]; then
	platform="MacOSX"
elif [ $2 -eq 3 ]; then
	platform="Linux"
else
	echo "Invalid second argument. Run Build.sh to see argument descriptions."
	exit 0
fi

#Linux and Mac are not supported yet, exit with error
if [ $platform == "MacOSX" ] || [ $platform == "Linux" ]; then
	echo "Not supported yet"
	exit 0
fi

releasename=$platform-$bits

#Build Java First
cd Code/A4S/
echo "Building Java"
./buildJava.sh $1 $2


cd ../../

##Create release folder##
if [ -d Releases/$releasename ]; then
	echo "Release folder Releases/$releasename already exists. Updating..."
else
	echo "No release folder Releases/$releasename found. Creating..."
	mkdir Releases/$releasename
fi

if [ $2 -eq 1 ]; then 
	##Check A4S-Helper Compiled##
	if [ ! -f Code/A4S-Helper/A4S-$1.exe ]; then
		echo "Please compile A4S-Helper (Cannot find A4S-$1.exe)"
		exit 1
	fi
	
	##Add ArduinoUploader##
	if [ -d Releases/$releasename/ArduinoUploader ]; then
		echo "ArduinoUploader already found, NOT overwriting due to size"
	else
		#Copy ArduinoUploader if platform is windows
		echo "Copying ArduinoUploader folder"
		cp -r Code/ArduinoUploader Releases/$releasename/ArduinoUploader
	fi

	##Add Drivers##
	echo "Copying/Updating Drivers folder"
	mkdir -p Releases/$releasename/drivers
	#cp -ur Other/drivers/* Releases/$releasename/drivers

	##Add examples##
	echo "Copying/Updating Examples folder"
	mkdir -p Releases/$releasename/examples
	#cp -ur Code/Scratch\ Examples/* Releases/$releasename/examples

	##Copy A4S-Helper##
	echo "Copying A4S-Helper"
	

	cp Code/A4S-Helper/A4S-$1.exe Releases/$releasename/
	cd Releases/$releasename/
	mv A4S-$1.exe Main.exe		
	cd ../../
	
	cp Code/A4S-Helper/{libgcc_s_dw2-1.dll,libgcc_s_sjlj-1.dll,libstdc++-6.dll,LanguageFile.txt} Releases/$releasename/

	mkdir -p Releases/$releasename/Resources
	cp -ur Code/A4S-Helper/Resources/* Releases/$releasename/Resources

	##Copy A4S##
	echo "Copying A4S"
	cp Code/A4S/{A4S.jar,A4S.s2e} Releases/$releasename/
	cp RxTx_Libraries/$bits/$platform/* Releases/$releasename/
	
	##Copy Other bits##
	cp Other/{Help.txt,License.txt} Releases/$releasename/
fi
