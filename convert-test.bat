echo off

echo this bat file converts the jot test file into an html file 
echo warnings about using XSLT 1.0 can be ignored

".\jot2xml\Debug\jot2xml.exe" "test-files\test.jot"
"C:\Apps\Saxonica\SaxonHE9.3N\bin\Transform.exe" "test-files\test.jot.xml" jotxml2html.xsl   > "test.html"
pause
