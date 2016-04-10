#!/bin/bash

version="1.6.0.0" 

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

if [ $1 -eq 64 ]; then 
	if [ $2 -eq 1 ] || [ $2 -eq 3 ] ; then 
		echo "64bit java no longer supported on this platform"
		exit 0
	fi 	
fi 

releasename=$platform-$bits

#Build Java First
cd Code/A4S/
echo "Building Java"
./buildJava.sh $1 $2
cd ../../

mkdir -p Releases

##Create release folder##
if [ -d Releases/$releasename ]; then
	echo "Release folder Releases/$releasename already exists. Updating..."
else
	echo "No release folder Releases/$releasename found. Creating..."
	mkdir Releases/$releasename
fi

if [ $2 -eq 1 ]; then 
	#Building For Windows
	
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
	cp -ur Other/drivers/* Releases/$releasename/drivers

	##Add examples##
	echo "Copying/Updating Examples folder"
	mkdir -p Releases/$releasename/examples
	cp -ur Code/Scratch\ Examples/* Releases/$releasename/examples

	##Copy A4S-Helper##
	echo "Copying A4S-Helper"
	cp -f Code/A4S-Helper/A4S-$1.exe Releases/$releasename/
	cp -f Code/A4S-Helper/LanguageFile.blf Releases/$releasename/
	cp -f Code/A4S-Helper/Tabs.txt Releases/$releasename/
	cd Releases/$releasename/
	mv A4S-$1.exe Main.exe		
	cd ../../
	
	cp Code/A4S-Helper/{libgcc_s_dw2-1.dll,libgcc_s_sjlj-1.dll,libstdc++-6.dll} Releases/$releasename/

	mkdir -p Releases/$releasename/Resources
	cp -ur Code/A4S-Helper/Resources/* Releases/$releasename/Resources

	##Copy A4S##
	echo "Copying A4S"
	cp -f Code/A4S/A4S.s2e Releases/$releasename/
	cp -f Code/A4S/A4S.jar Releases/$releasename/
	cp -u RxTx_Libraries/$bits/$platform/* Releases/$releasename/
	
	##Copy Other bits##
	cp -f Other/Help.txt Releases/$releasename/
	cp -f Other/License.txt Releases/$releasename/
	
	##Copy JRE
	echo "Copying JRE"
	if [ -d Releases/$releasename/JRE ]; then
		echo "JRE already found, NOT overwriting due to size"
	else
		#Copy ArduinoUploader if platform is windows
		echo "Copying JRE folder"
		mkdir -p Releases/$releasename/JRE
		for d in Java_Runtime/$bits/$platform/*/ ; do
			echo "cp -r $d Releases/$releasename/JRE"
			cp -r $d* Releases/$releasename/JRE
			break
		done
	fi
	

		
	##Echo Version##
	echo "$releasename $version" > Releases/$releasename/Version.txt 
elif [ $2 -eq 2 ]; then 
	#Building for Mac
	
	##Check A4S-Helper Compiled##
	if [ ! -d Code/A4S-Helper/A4S-$1.app/Contents/Resources/ ]; then
		echo "Please compile A4S-Helper (Cannot find A4S-$1.app)"
		exit 1
	fi	
	
	##Copy A4S-Helper
	echo "Copying A4S-Helper"
	if [ -d Releases/$releasename/A4S-$1.app/ ]; then
		rm -r Releases/$releasename/A4S-$1.app
	fi
	cp -r Code/A4S-Helper/A4S-$1.app/ Releases/$releasename/A4S-$1.app/
	cp -f Code/A4S-Helper/A4S.icns Releases/$releasename/A4S-$1.app/Contents/Resources/A4S-$1.icns
	cp -f Code/A4S-Helper/microcontroller.ico Releases/$releasename/A4S-$1.app/Contents/Resources/microcontroller.ico
	cp -f Code/A4S-Helper/LanguageFile.blf Releases/$releasename/A4S-$1.app/Contents/Resources/LanguageFile.blf
	cp -f Code/A4S-Helper/Tabs.txt Releases/$releasename/A4S-$1.app/Contents/Resources/Tabs.txt
	
	#No Need to add full ArduinoUploader or drivers
	##Add Firmata Code##
	echo "Copying Firmata code"
	mkdir -p Releases/$releasename/A4S-$1.app/Contents/Resources/ArduinoUploader/StandardFirmataTemplate/
	cp -f Code/ArduinoUploader/StandardFirmataTemplate/StandardFirmataTemplate.ino Releases/$releasename/A4S-$1.app/Contents/Resources/ArduinoUploader/StandardFirmataTemplate/

	##Add examples##
	echo "Copying/Updating Examples folder"
	mkdir -p Releases/$releasename/A4S-$1.app/Contents/Resources/examples
	cp -fr Code/Scratch\ Examples/* Releases/$releasename/A4S-$1.app/Contents/Resources/examples

	##Copy A4S##
	echo "Copying A4S"
	cp -f Code/A4S/A4S.s2e Releases/$releasename/A4S-$1.app/Contents/Resources/
	cp -f Code/A4S/A4S.jar Releases/$releasename/A4S-$1.app/Contents/Resources/
	cp -fr RxTx_Libraries/$bits/$platform/* Releases/$releasename/A4S-$1.app/Contents/Resources/	

	##Echo Version##
	echo "$releasename $version" > Releases/$releasename/A4S-$1.app/Contents/Resources/Version.txt 	
elif [ $2 -eq 3 ]; then 
	#Building For Linux
	
	##Check A4S-Helper Compiled##
	if [ ! -f Code/A4S-Helper/A4S-$1 ]; then
		echo "Please compile A4S-Helper (Cannot find A4S-$1)"
		exit 1
	fi
	
	##Add examples##
	echo "Copying/Updating Examples folder"
	mkdir -p Releases/$releasename/examples
	cp -ur Code/Scratch\ Examples/* Releases/$releasename/examples

	##Copy A4S-Helper##
	echo "Copying A4S-Helper"
	cp -f Code/A4S-Helper/A4S-$1 Releases/$releasename/
	cp -f Code/A4S-Helper/LanguageFile.blf Releases/$releasename/
	cp -f Code/A4S-Helper/Tabs.txt Releases/$releasename/

	cd Releases/$releasename/
	mv A4S-$1 Main		
	cd ../../
	
	mkdir -p Releases/$releasename/Resources
	cp -ur Code/A4S-Helper/Resources/* Releases/$releasename/Resources

	#No Need to add full ArduinoUploader or drivers
	##Add Firmata Code##
	echo "Copying Firmata code"
	mkdir -p Releases/$releasename/ArduinoUploader/StandardFirmataTemplate/
	cp -f Code/ArduinoUploader/StandardFirmataTemplate/StandardFirmataTemplate.ino Releases/$releasename/ArduinoUploader/StandardFirmataTemplate/

	##Copy A4S##
	echo "Copying A4S"
	cp -f Code/A4S/A4S.s2e Releases/$releasename/
	cp -f Code/A4S/A4S.jar Releases/$releasename/
	cp -u RxTx_Libraries/$bits/$platform/* Releases/$releasename/
	
	##Copy Other bits##
	cp -f Other/Help.txt Releases/$releasename/
	cp -f Other/License.txt Releases/$releasename/
	
	##Copy JRE
	echo "Copying JRE"
	if [ -d Releases/$releasename/JRE ]; then
		echo "JRE already found, NOT overwriting due to size"
	else
		#Copy ArduinoUploader if platform is windows
		echo "Copying JRE folder"
		mkdir -p Releases/$releasename/JRE
		for d in Java_Runtime/$bits/$platform/*/ ; do
			echo "cp -r $d Releases/$releasename/JRE"
			cp -r $d* Releases/$releasename/JRE
			break
		done
	fi
	

		
	##Echo Version##
	echo "$releasename $version" > Releases/$releasename/Version.txt 
fi
