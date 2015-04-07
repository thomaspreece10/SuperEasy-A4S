#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Needs more arguments"
	echo "buildJava.sh [32|64] [1|2|3]"
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
	echo "Invalid first argument. Run buildJava.sh to see argument descriptions."
	exit 0
fi

if [ $2 -eq 1 ]; then
	platform="Windows"
elif [ $2 -eq 2 ]; then
	platform="MacOSX"
elif [ $2 -eq 3 ]; then
	platform="Linux"
else
	echo "Invalid second argument. Run buildJava.sh to see argument descriptions."
	exit 0
fi

classpath="../../RxTx_Libraries/$bits/$platform/RXTXcomm.jar"
echo "Building Java Library for $bits $platform"
echo "Using native library: $classpath"

javac -classpath $classpath A4S.java processing/src/Firmata.java
mkdir -p org/firmata
cp processing/src/*.class org/firmata/
jar -cfm A4S.jar manifest.mf *.class org/firmata/*.class
rm *.class org/firmata/*.class

echo "Finished Building Java"