#!/bin/sh

# Need the -Djava.library.path=./ if the lib files have not been installed into the system on Linux
java -d32 -Djava.library.path=./ -jar A4S.jar $@
