# this script converts a jot file into an html file
#!/bin/bash

"./jot2xml/jot2xml" "test-files/test.jot" -s "default.schema.jot"
saxonb-xslt -s:"test-files/test.jot.xml" -xsl:"jotxml2html.xsl" -o:"test-files/test.html" 

 


