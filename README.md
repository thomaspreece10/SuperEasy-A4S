# A4S (Arduino For Scratch)

A4S is an experimental extension for [Scratch 2](http://scratch.mit.edu) that allows it to communicate with [Arduino](http://www.arduino.cc) boards using [Firmata](http://firmata.org/). It consists of a Java server that Scratch connects to over HTTP and which communicates with an Arduino board over (USB) serial and a helper application to avoid using the command line and the Arduino software. The original A4S was developed by [David Mellis](https://github.com/damellis/A4S/), based on documentation and code from the Scratch team. The modified version is developed by Thomas Preece.

##Requirements

You need to have Java installed on your system.

## Instructions

For instructions on how to download, install and use please visit my personal webpage: [http://thomaspreece.com](http://thomaspreece.com/resources.php)

##Modifying The Code

The A4S code is in Java. It relies on a native serial library which is either 64 or 32 bit and platform dependant.
The A4S-Helper is coded in [BlitzMax](http://www.blitzmax.com/) and requires BlitzMax to compile. It is also dependant on [wxmax](https://code.google.com/p/wxmax/), a module for Blitzmax.
The ArduinoUploader program that is used for the Windows version is coded in C and can be found [here] (https://github.com/thomaspreece10/ArduinoUploader)

##Build.sh
This script brings together all the required files for each specific build. It automatically builds the correct Java file too. It does NOT however build the BlitzMax code and expects it to be prebuilt before the script is run. It takes 2 arguments.

The first is either '32' or '64' and designates whether build should be compatible with 32bit Java Virtual Machine(JVM) or 64bit JVM.
The second is either '1', '2' or '3'. 1 designates a Windows build, 2 a Mac OSX build and 3 a Linux build.

After it has finished you should have all the required files assembled in a folder within the Releases folder.

##A note about using Build.sh on Windows
Build.sh is a BASH script. Windows doesn't ship with a BASH shell so you will have to download one. Simply renaming it to .bat will not work. The simplest method to get a bash shell would be to install git as it comes with a program called 'git Bash' will can execute the script fine.

##I tried to translate the A4S.s2e file but it changes nothing…
A4S.s2e does nothing as it is already combined with the ImportBlocks.sb2, EsploraBlocks_Empty.sb2 and EsploraBlocks_Example.sb2 files. When you load these files it also loads an embedded version of A4S.s2e contained in the sb2 files so changing the external A4S.s2e does nothing.
To change the embedded version you need to download the offline version of Scratch 2.0. Open up the sb2 file. Goto ‘More Blocks’. Next to A4S click the down arrow and click ‘Remove Extension Blocks’. Now hold the Shift key and click the ‘File’ menu. You should now see the hidden option ‘Import experimental Scratch Extension’. Click it. A dialog pops up, navigate to A4S.s2e and open it. Save sb2 file again. You have now embedded your new version of A4S.s2e into the sb2 file. 
