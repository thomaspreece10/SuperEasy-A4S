# A4S (Arduino For Scratch)

A4S is an experimental extension for [Scratch 2](http://scratch.mit.edu) that allows it to communicate with [Arduino](http://www.arduino.cc) boards using [Firmata](http://firmata.org/). It consists of a Java server that Scratch connects to over HTTP and which communicates with an Arduino board over (USB) serial and a helper application to avoid using the commandline. The original A4S was developed by David Mellis <https://github.com/damellis/A4S/>, based on documentation and code from the Scratch team. The modified version is developed by Thomas Preece.

##Requirements

You need to have Java installed on your system.

## Instructions

1. Install the [Scratch 2 offline editor](http://scratch.mit.edu/scratch2download/) or use [Scratch 2 online editor](http://scratch.mit.edu/projects/editor/). 
2. Install the [Arduino software](http://arduino.cc/en/Main/Software). Instructions: [Windows](http://arduino.cc/en/Guide/Windows), [Mac OS X](http://arduino.cc/en/Guide/MacOSX).
3. Upload the StandardFirmata firmware to your Arduino board. (It's in "Examples > Firmata".)
4. [Download the A4S code](https://github.com/thomaspreece10/A4S/archive/master.zip) from GitHub and unzip it.
5. Launch the A4S server using the "main.exe" file. Select the serial port corresponding to your Arduino board from the list and click the start button. Wait for the program to tell you server is ready.
6. Run the Scratch 2 offline editor or open Scratch 2 online editor.
7. If using Scratch 2 online editor click "File" menu and click "upload from computer". If using Scratch 2 offline editor click "File" menu and click "open". Select ImportBlocks.sb2 from the examples folder.
9. You should see the A4S extension and blocks appear in the "More Blocks" category in the Scratch editor. If the A4S server is running, there will be a green dot next to the "A4S" title. 

##Modifying The Code

Most of the code is in Java. 
The HelperApp (main.exe/main.bmx) is coded in [BlitzMax](http://www.blitzmax.com/) and requires BlitzMax to compile. It is also dependant on [wxmax](https://code.google.com/p/wxmax/), a module for Blitzmax.