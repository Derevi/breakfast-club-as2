#!/bin/bash

# Original line provided
#java  -Xms256M -Xmx1024M -jar lseditor-7.3.13.jar c488_UnderstandFileDependency.con.ta

# Edited line, the first argument is the .ta file you want to load
java  -Xms256M -Xmx1024M -jar lseditor-7.3.13.jar $1
