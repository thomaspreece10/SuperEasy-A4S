#A4S Base 
Based on https://github.com/damellis/A4S

##What does it do?
This is a HTTP server that communicates with the Arduino over serial port while at the same time responding to Scratch's queries about the status of the Arduino. Its the middleman between the Arduino and Scratch and handles all communication between them. If you want to add a new feature this is more than likely the code you need to change.

##Language?
Java

##Building?
Use the buildJava.sh file to build A4S.jar 

##A4S.patch
Patch file used to update the A4S version by damellis to be compatable with A4S-Helper

patch < A4S.patch

