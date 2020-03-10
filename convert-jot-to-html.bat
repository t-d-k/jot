echo off

echo this bat file converts jot files into html files using the appropriate xslt file
echo warnings about using XSLT 1.0 can be ignored


".\jot2xml\Debug\jot2xml.exe" %* -o "%~pn1.xml"
"C:\Apps\Saxonica\SaxonHE9.3N\bin\Transform.exe" "%~pn1.xml" "jotxml2html.xsl"   > "%~pn1.html"
pause
