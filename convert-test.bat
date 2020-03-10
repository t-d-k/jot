echo off

echo this bat file converts the jot test file into an html file 
echo warnings about using XSLT 1.0 can be ignored

".\jot2xml\Debug\jot2xml.exe" "test convert.jot"
"C:\Apps\Saxonica\SaxonHE9.3N\bin\Transform.exe" "test convert.jot.xml" jotxml2html.xsl   > "test convert.html"
rem msxsl.exe "test_convert.xml" jotxml2html.xsl  -o "test convert.html"
pause
