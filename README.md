# A4S (Arduino For Scratch)

A4S is an experimental extension for [Scratch 2](http://scratch.mit.edu) that allows it to communicate with [Arduino](http://www.arduino.cc) boards using [Firmata](http://firmata.org/). It consists of a Java server that Scratch connects to over HTTP and which communicates with an Arduino board over (USB) serial and a helper application to avoid using the command line and the Arduino software. The original A4S was developed by [David Mellis](https://github.com/damellis/A4S/), based on documentation and code from the Scratch team. The modified version is developed by Thomas Preece.

##Requirements

You need to have Java installed on your system.

## Instructions

For instructions on how to download, install and use please visit my personal webpage: [http://thomaspreece.com](http://thomaspreece.com/resources.php)

##Modifying The Code

Most of the code is in Java. 
The HelperApp (main.exe/main.bmx) is coded in [BlitzMax](http://www.blitzmax.com/) and requires BlitzMax to compile. It is also dependant on [wxmax](https://code.google.com/p/wxmax/), a module for Blitzmax.
