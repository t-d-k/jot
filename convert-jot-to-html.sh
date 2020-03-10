# this script converts a jot file into an html file
#!/bin/bash
basename=$1
filename="${basename%.*}"

"./jot2xml/jot2xml" "$1"
saxonb-xslt -s:"$1.xml" -xsl:"jotxml2html.xsl" -o:"$filename.html" 

 


