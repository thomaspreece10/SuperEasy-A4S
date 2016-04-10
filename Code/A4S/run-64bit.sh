#!/bin/sh

# Need the -Djava.library.path=./ if the lib files have not been installed into the system on Linux
java -Djava.library.path=./ -jar A4S.jar $@
