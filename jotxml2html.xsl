<?xml version="1.0" encoding="UTF-8"?>
<!-- TODO: CONVERT <TITLE> tag if exists to web page title -->
<!-- TODO: complete "variant case=spla|..." processing -->
<!-- TODO: add #ids to headings automatically -->
<!-- TODO: add +/- code optionally -->
	
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:v2="http://zanox.com/productdata/exportservice/v2">
	
<!-- xsl:output method="text" omit-xml-declaration="yes"/ -->
<xsl:output method="xhtml" 
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" 
	doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
	omit-xml-declaration="yes"  indent="no"
	exclude-result-prefixes="#all" />  
<!-- dont do indent="yes" bcit puts whitespace around inline tags like CODE-->
<xsl:strip-space elements="*"/>	
		
	<xsl:param name = "choose" select="DEFAULT_VALUE" />
	
	<xsl:template name="replace_special">
		<xsl:param name="str" />
		<!--xsl:choose>
		<xsl:when test="substring($str, 1, 1) = ' '">_</xsl:when>		
		<xsl:otherwise><xsl:value-of select="substring($str, 1, 1)" /></xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="replace_spaces">
		<xsl:with-param name="str" select="substring($str, 2)" />
		</xsl:call-template -->
		<!-- keep lengths the same, so no chars delted, try to keep unique -->
		<xsl:value-of select='translate($str, " #?!&#38;&#39;.(&#60;&#61;&#62;","___________")'/>		 
	</xsl:template>	
			
	<xsl:template name="str_to_id">
		<xsl:call-template name="replace_special">
			<xsl:with-param name="str" select="normalize-space(substring(text()[1], 1,20))" />
		</xsl:call-template>
	</xsl:template>
		
	<xsl:template name="pad">
		<xsl:param name="padCount" select="0"/> 
		<xsl:text>&#9;</xsl:text> 
			<xsl:if  test="$padCount&gt;1">
			<xsl:call-template name="pad">
				<xsl:with-param name="padCount" select="number($padCount) - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="indent">
		<xsl:param name="level" />
		<xsl:text>&#10;</xsl:text><!--xsl:value-of select="$level"/-->
		<xsl:call-template name="pad">
			<xsl:with-param name="padCount" select="$level"/>
		</xsl:call-template>
	</xsl:template>
	
<xsl:template name="autoIndent">
		<xsl:variable name="level"><xsl:value-of select="count(ancestor::*)"/></xsl:variable>
		<xsl:text>&#10;</xsl:text><!--xsl:value-of select="$level"/-->
		<xsl:call-template name="pad">
			<xsl:with-param name="padCount" select="$level"/>
		</xsl:call-template>
	</xsl:template>
	


	<xsl:template match="/">
		
		<HTML><xsl:text>&#10;</xsl:text>
		<HEAD><xsl:text>&#10;</xsl:text>
	<META charset="UTF-8"/>
		<TITLE><xsl:value-of select="/xml/p[1]"/></TITLE><xsl:text>&#10;</xsl:text>
		<xsl:for-each select="//*/p/tags">
			<meta name="keywords" content="{.}" />
		</xsl:for-each>
		<!-- xsl:for-each select="/xml/link[@rel=stylesheet]"-->
		<xsl:for-each select="/xml/link">
			<LINK><xsl:apply-templates/></LINK>
		</xsl:for-each>
		<!-- link rel="stylesheet" type="text/css" href="jot.css" ></link>
		<script type="text/javascript" src="jot.js" ></script -->
		
		<STYLE>
	/* 
colours are from  https://paletton.com/#uid=53S0u0kllllaFw0g0qFqFg0w0aF 

.color-primary-0 { color: #303C74 }	/* Main Primary color * /
.color-primary-1 { color: #7B84AE }
.color-primary-2 { color: #515D91 }
.color-primary-3 { color: #172357 }
.color-primary-4 { color: #07103A }

.color-secondary-1-0 { color: #452F74 }	
.color-secondary-1-1 { color: #8B7AAE }
.color-secondary-1-2 { color: #655091 }
.color-secondary-1-3 { color: #2B1657 }
.color-secondary-1-4 { color: #17063A }

.color-secondary-2-0 { color: #26596A }	
.color-secondary-2-1 { color: #6C939F }
.color-secondary-2-2 { color: #457585 }
.color-secondary-2-3 { color: #104050 }
.color-secondary-2-4 { color: #022835 }
*/

*{ 	 line-height:1em;  font-family:  sans-serif;}

html {
	background-color: #2B1657;
	margin: 1em;
}
body {
	background-color: white;
	margin: 0 auto;
	color: #17063A;
	border: 1pt solid #17063A;
	padding: 1em;
}
h3{ color: #303C74 }
h4{ color: #7B84AE }
h5{ color: #515D91 }
h2{ color: #172357 }
h1 { color: #07103A }



/* headings */
h1,
h2,
h3,
h4,
h5,
h6 { 	font-weight: 700; }

h1,
h2,
h3,
h4,
h5,
h6 { font-weight: 700; }

h1 { font-size: 2.8em; }

h2 { font-size: 2.4em; }

h3 { font-size: 1.8em; }

h4 { font-size: 1.4em; }

h5 { font-size: 1.3em; }

h6 { font-size: 1.15em; }

code {
	margin:0.5em;
	padding:0.1em 0.5em 0.1em 0.5em;
	color:white;
	background-color:#07103A ;  
}

code p{
	color:white;
	background-color:#07103A ;
	margin:0;
	padding:0;
}

pre{
	margin: 1em;
	padding:0.5em;
	font-weight: normal;
	font-family: monospace, serif,courier;
	font-size:0.8em;	
	white-space: pre-wrap;
	word-wrap: break-word;
	border: 1pt solid #8B7AAE;	
	box-shadow: 5pt 5pt 8pt #8B7AAE;
}

pre.inline{
	margin: 0em;
	padding:0.1em 0.5em 0.1em 0.5em;
	display:inline;
	box-shadow: none;
	border: 1pt solid #8B7AAE;
}


a:focus {outline: thin dotted;}
a:active,a:hover {outline: 0;}
a {color: #452F74;}
a:visited {color: #655091;}
a:hover {color: #8B7AAE;}

.caption {		
	text-align: center;
	display: block;
	margin-left: auto;
	margin-right: auto;		
}

.tooltip {
	position: relative;
	display: inline-block;
	border-bottom: 1px dotted black; /* show has tooltip */
}

.inline { 
	display: inline;
	border: none;
} 

.attr{
	font-style:italic;
	color: #452F74;
	font-size:0.8em;	
	text-align: center;
}

blockquote { font-family:monospace; }

img {
	display: block;
	margin:0.5em;
	margin-left: auto;
	margin-right: auto;
	border: 1px dotted #452F74;
}

li { margin:0.5em; }

table tr:nth-child(odd){	background:#6C939F; }

th {
	color:white;
	background: #457585;
	padding :0.5em; 	
}

td{	padding :0.2em 1em 0.2em 1em; color:#022835; }

.alert{background:#8B7AAE;}	
.level5{line-height:0em;}
.level5 p{ font-size:1em; line-height:0.2em; 	}
	

		</STYLE><xsl:text>&#10;</xsl:text>	
			<xsl:if 	test="//gtag">
					<!-- Global site tag (gtag.js) - Google Analytics -->
<script async="async" src="https://www.googletagmanager.com/gtag/js?id={//gtag/p}"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', '<xsl:value-of select="//gtag/p"/>');
</script>
				</xsl:if>
		</HEAD><xsl:text>&#10;</xsl:text>		
		<BODY><xsl:text>&#10;</xsl:text>
		<xsl:comment> DO NOT EDIT THIS HTML FILE DIRECTLY, THIS FILE IS GENERATED FROM A .JOT SOURCE FILE, AND WILL BE OVERWRITTEN. TO CHANGE THE HTML OUTPUT, EITHER CHANGE THE .JOT SOURCE FILE OR JOTXML2HTML.XSL</xsl:comment><xsl:text>&#10;</xsl:text>


		<ARTICLE>
			<xsl:apply-templates /><xsl:text>&#10;</xsl:text>
		</ARTICLE><xsl:text>&#10;</xsl:text>		
		<xsl:call-template name="footnotes"/>
		<P CLASS="attr"> This web page created by the <A HREF="https://github.com/t-d-k/jot">jot</A> markup language</P>
		</BODY><xsl:text>&#10;</xsl:text>
		
		</HTML>
		
	</xsl:template>
	
	<xsl:template name="footnotes">
		<xsl:if 	test="//footnote">
			<H2>Footnotes</H2>
			<xsl:for-each select="//footnote">
				<xsl:variable name="n"><xsl:number level="any" format="1"/></xsl:variable>
				<DIV><xsl:attribute name="ID">footnote-<xsl:value-of select="$n"/></xsl:attribute><xsl:value-of select="$n"/>. <xsl:apply-templates /></DIV><xsl:text>&#10;</xsl:text>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="//citation">
			<H2>Citations</H2>
			<xsl:for-each select="//citation">
				<xsl:variable name="n"><xsl:number level="any" format="1"/></xsl:variable>
				<DIV>
				<xsl:attribute name="ID">citation-<xsl:value-of select="$n"/></xsl:attribute>
				<xsl:value-of select="$n"/>. 			
				<xsl:choose>
					<xsl:when test="link">
						<A><xsl:attribute name="HREF"><xsl:apply-templates /></xsl:attribute><xsl:apply-templates /></A>		
					</xsl:when>		
					<xsl:otherwise><xsl:apply-templates /></xsl:otherwise>
				</xsl:choose>
				</DIV><xsl:text>&#10;</xsl:text>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
		
	
	<!-- todo| is some better way of doing this - so dont have to do for every html tag?-->
	<xsl:template match="pre">	<PRE><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></PRE></xsl:template>
	<xsl:template match="i">		<I>			<xsl:apply-templates /></I>			</xsl:template>
	<xsl:template match="b">		<STRONG><xsl:apply-templates /></STRONG></xsl:template>
	<xsl:template match="quote">
<xsl:if test="(not(p/when) and not(when)) or(p/when and contains($choose,normalize-space(p/when))) or (when and contains($choose,normalize-space(when))) ">
		<BLOCKQUOTE>		
		<xsl:call-template name="common_attibutes"/>
		<xsl:apply-templates />
		</BLOCKQUOTE>
	</xsl:if>
	</xsl:template>
	<!-- if just use templates, get errors about "cant create attributes after children" better way to fix? -->
	<xsl:template name="common_attibutes_no_id">
		<xsl:if test="class">
			<xsl:attribute name="CLASS"><xsl:value-of select="class"/></xsl:attribute>
		</xsl:if>		
		<xsl:if test="alt">
			<xsl:attribute name="ALT"><xsl:value-of select="alt"/></xsl:attribute>
		</xsl:if>		
		<xsl:if test="lang">
			<xsl:attribute name="LANG"><xsl:value-of select="lang"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="dir">
			<xsl:attribute name="DIR"><xsl:value-of select="dir"/></xsl:attribute>
		</xsl:if>	
		<xsl:if test="title">
			<xsl:attribute name="TITLE"><xsl:value-of select="title"/></xsl:attribute>
		</xsl:if>			
		<xsl:if test="border">
			<xsl:attribute name="BORDER"><xsl:value-of select="border"/></xsl:attribute>
		</xsl:if>	
		<xsl:if test="height"><xsl:attribute name="HEIGHT"><xsl:value-of select="height"/></xsl:attribute></xsl:if>
		<xsl:if test="width"><xsl:attribute name="WIDTH"><xsl:value-of select="width"/></xsl:attribute></xsl:if>
	</xsl:template>
	

	<!-- add attributes, create id from text if doesnt exist -->
	<xsl:template name="common_attibutes">
	<xsl:call-template name="common_attibutes_no_id"/>
		<xsl:attribute name="ID">
		<xsl:choose>
         <xsl:when test="id">
           <xsl:value-of select="id"/>
         </xsl:when>
         <xsl:otherwise>
          <xsl:call-template 	name="str_to_id"></xsl:call-template>
         </xsl:otherwise>
       </xsl:choose>
      </xsl:attribute>
	</xsl:template>
	<!-- add attributes, only add id if given by user -->
	
		<xsl:template name="common_attibutes_lite">
	<xsl:call-template name="common_attibutes_no_id"/>
		
         <xsl:if test="id">
           <xsl:attribute name="ID"><xsl:value-of select="id"/></xsl:attribute>
         </xsl:if>   
      
	</xsl:template>
	
	<xsl:template match="p">
		<xsl:variable name="n">
			<xsl:number/>  
		</xsl:variable>
    <xsl:variable name="level"><xsl:value-of select="count(ancestor::*)"/></xsl:variable>
		<xsl:if 	test="not(ancestor-or-self::pre) ">
		<xsl:call-template name="indent"><xsl:with-param name="level" select="$level"/></xsl:call-template >
   </xsl:if>
   
		<xsl:if 	test="not(ancestor-or-self::*/when)    	   or           	contains($choose,normalize-space(ancestor-or-self::*/when)) ">
		<xsl:choose>
			<xsl:when 	test="parent::pre" >	
						<xsl:call-template name="common_attibutes"/>
						<!-- \r\n --> <xsl:text>&#xa;&#xd;</xsl:text><xsl:apply-templates />
			</xsl:when>	
						<xsl:when test="parent::list or parent::ol or parent::ul" >	
				<LI> 
				<xsl:call-template name="common_attibutes_lite"/>
				<xsl:apply-templates />
				</LI>
			</xsl:when>
			<xsl:when test="row or parent::header" >
			<xsl:apply-templates />
			</xsl:when>
			<xsl:when test="parent::xml and $n = 1" >	
				<H1  CLASS="title" ><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></H1>
			</xsl:when>
					<xsl:when test="($level = 1) or parent::xml" >
				<H1><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></H1>
			</xsl:when>
					<xsl:when test="$level = 2" >	
				<H2><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></H2>
			</xsl:when>
					<xsl:when test="$level = 3" >	
				<H3><xsl:call-template  	name="common_attibutes"/><xsl:apply-templates /></H3>
			</xsl:when>
					<xsl:when test="$level = 4" >	
				<H4><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></H4>
					</xsl:when>					
					<xsl:when test="$level = 5" >	
				<DIV><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></DIV>
			</xsl:when>
						<xsl:when test="$level > 5" >	
				<SPAN class="level5"><P><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></P></SPAN>
			</xsl:when>	
			<xsl:otherwise>
				<P>              
				<xsl:call-template name="common_attibutes"/>			
				<xsl:apply-templates />
				</P>
			</xsl:otherwise>
		</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="img">	

		<xsl:if test="not(ancestor-or-self::*/when) or contains($choose,normalize-space(ancestor-or-self::*/when)) ">
		<!-- normalize-space trims, but also reduces internal whitespace, shouldn't normally be a problem - https://stackoverflow.com/questions/16573215/xslt-remove-leading-and-trailing-whitespace-of-all-attributes -->
		<IMG>
				<xsl:call-template name="common_attibutes"/>			
				<xsl:attribute name="SRC"><xsl:value-of select="normalize-space(text())"/></xsl:attribute>
				<xsl:if test="p">
					<xsl:attribute name="SRC"><xsl:value-of select="normalize-space(p/text())"/></xsl:attribute>				
				</xsl:if>
			<xsl:if test="alt">
				<xsl:attribute name="ALT"><xsl:value-of select="alt"/></xsl:attribute>
			</xsl:if>	
				<xsl:if test="p/alt">
					<xsl:attribute name="ALT"><xsl:value-of select="p/alt"/></xsl:attribute>
				</xsl:if>
					<xsl:if test="p/width">
					<xsl:attribute name="WIDTH"><xsl:value-of select="p/width"/></xsl:attribute>
			</xsl:if>
					<xsl:if test="p/height">
				<xsl:attribute name="HEIGHT"><xsl:value-of select="p/height"/></xsl:attribute>
			</xsl:if>
					<xsl:if test="p/class">
				<xsl:attribute name="CLASS"><xsl:value-of select="p/class"/></xsl:attribute>
				</xsl:if>
				<!--xsl:apply-templates /--> 
			</IMG>
			</xsl:if>
</xsl:template>
	
	<!-- templates for simple pass-through output -->
	<xsl:template match="code"><CODE><xsl:apply-templates /></CODE></xsl:template>
	<xsl:template match="em"> 				<EM>	      <xsl:apply-templates /> </EM>			  </xsl:template>
	<xsl:template match="strong"> 		<STRONG>	  <xsl:apply-templates /> </STRONG>		</xsl:template>
	<xsl:template match="q">	  			<Q>	        <xsl:apply-templates /> </Q>			  </xsl:template>
	<xsl:template match="cite">				<CITE>      <xsl:apply-templates /> </CITE>		    </xsl:template>
	<xsl:template match="blockquote"> <BLOCKQUOTE><xsl:apply-templates /> </BLOCKQUOTE>	</xsl:template>
	<!--xsl:template match="a">					<A>         <xsl:apply-templates /> </A>			    </xsl:template-->
	
	<!--  last resort escape sequence for square brackets -->
	<xsl:template match="brackets">[<xsl:apply-templates />]</xsl:template>
	
	<xsl:template match="footnote">
		<xsl:variable name="n"><xsl:number level="any" format="1"/></xsl:variable>
		<A CLASS="tooltip"><xsl:attribute name="HREF">#footnote-<xsl:value-of select="$n"/></xsl:attribute>
		<xsl:attribute name="TITLE"><xsl:apply-templates /></xsl:attribute>Note <xsl:value-of select="$n"/></A>
	</xsl:template>
	
	<xsl:template match="citation">
		<xsl:variable name="n"><xsl:number level="any" format="1"/></xsl:variable>
		<!--[<a class="tooltip"><xsl:attribute name="title"><xsl:apply-templates /></xsl:attribute> -->
		[<A style="position: relative;display: inline-block;border-bottom: 1px dotted black;"><xsl:attribute name="TITLE"><xsl:apply-templates /></xsl:attribute>
		<xsl:attribute name="HREF">#citation-<xsl:value-of select="$n"/></xsl:attribute>
		<xsl:value-of select="$n"/>
		</A>]
	</xsl:template>
	
		<!--xsl:template match="cite-link">				
		<span class="tooltip"><xsl:attribute name="title"<xsl:value-of select="."/></xsl:attribute>[<A><xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute><xsl:number level="any" format="1"/></A>]
		<span class="tooltiptext"><A><xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute><xsl:apply-templates /></A></span>
		</span>
	</xsl:template--> 
	
	<xsl:template match="script"><SCRIPT>
		<xsl:attribute name="SRC"><xsl:value-of select="src"/></xsl:attribute>
		<xsl:attribute name="CHARSET"><xsl:value-of select="charset"/></xsl:attribute>
		<xsl:apply-templates /></SCRIPT>
	</xsl:template>
	

	<xsl:template match="tags">	<!-- suppress except in head --></xsl:template>
	<xsl:template match="gtag">	<!-- suppress except in head --></xsl:template>
	
	<xsl:template match="comment"><!-- suppress --></xsl:template>
	<xsl:template match="link"><!-- suppress except in head --></xsl:template>
	<xsl:template match="c"><!-- suppress --></xsl:template>
	<xsl:template match="alt"><!-- suppress --></xsl:template>
		
	<xsl:template match="todo"><H1 style="color:red">TODO: <xsl:value-of select="."/></H1></xsl:template>
	
	<xsl:template match="class"></xsl:template>
	<xsl:template match="lang"></xsl:template>
	<xsl:template match="dir"></xsl:template>	
	<xsl:template match="charset"></xsl:template>
	
	<!-- conditional output - xsl parameters choose what to output. is checked on processing parent -->
	<xsl:template match="when"><!-- suppress --></xsl:template>

		<xsl:template match="r"></xsl:template>
	
	<xsl:template match="border">
		<xsl:attribute name="BORDER"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>	
	
	<xsl:template match="width">
		<xsl:attribute name="WIDTH"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
	<xsl:template match="height">
		<xsl:attribute name="HEIGHT"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>	
	
	<xsl:template match="id"></xsl:template>
	
	<xsl:template match="rel">
		<xsl:attribute name="REL"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
				
	<xsl:template match="target">
		<xsl:attribute name="TARGET"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>

		<xsl:template match="dld">
		<xsl:attribute name="DLD"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
	
		<xsl:template match="method">
		<xsl:attribute name="METHOD"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>	
	
		<xsl:template match="action">
		<xsl:attribute name="ACTION"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
	
	<xsl:template match="type">
		<xsl:attribute name="TYPE"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
	
	<xsl:template match="src">
		<xsl:attribute name="SRC"><xsl:value-of select="normalize-space(.)"/></xsl:attribute>
	</xsl:template>
	
	<xsl:template match="title">
		<xsl:attribute name="TITLE"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>

	<xsl:template match="source">
		<SOURCE><xsl:apply-templates/></SOURCE>
	</xsl:template>
	
	<xsl:template match="caption">
		<CAPTION><xsl:value-of select="."/></CAPTION>
	</xsl:template>		
	
		<xsl:template match="form">
		<FORM>
		<xsl:apply-templates />
		</FORM>		
	</xsl:template>
	
	<xsl:template match="video">
	<xsl:call-template name="autoIndent"></xsl:call-template>	
		<VIDEO CONTROLS="">
		<xsl:call-template name="common_attibutes" />
		<source src="{text()}" type="video/mp4" />
		Your browser does not support the video tag.
		</VIDEO>
	</xsl:template>
	
	<xsl:template                       	match="a">
		<A>
		<xsl:attribute name="HREF">		
			<xsl:value-of select="normalize-space(r)"/>	
		<xsl:if test="p/r"><xsl:value-of select="normalize-space(p/r)"/></xsl:if>
			</xsl:attribute>
		<xsl:call-template name="common_attibutes"/>
		<xsl:apply-templates/></A>
	</xsl:template>

	<!-- l (local) is like <a> but contents is node and text (fragment id)-->
	<xsl:template    	match="l">
		<A HREF="#{normalize-space(.)}"><xsl:apply-templates/></A>
	</xsl:template>
	
		<!-- h (http) is like <a> but contents is node and text (nonfragment id)-->
	<xsl:template    	match="h">
		<A HREF="https://{normalize-space(.)}"><xsl:apply-templates/></A>
	</xsl:template>
	
	<xsl:template match="num">
		<!-- suppress except in <list> -->
		<xsl:choose>
    <xsl:when test="normalize-space(text()) ='numbered' or normalize-space(text()) ='ol' or normalize-space(text()) ='ul' or normalize-space(text()) =''">
    </xsl:when>
    <xsl:otherwise>
      <H1  STYLE="color:red">ERROR!:Invalid num value "<xsl:value-of select="."/>"</H1>
    </xsl:otherwise>
  </xsl:choose>
	</xsl:template>
		

	<xsl:template match="list">	
	<xsl:if test="(not(p/when) and not(when)) or (p/when and contains($choose,normalize-space(p/when))) or (when and contains($choose,normalize-space(when))) ">
	<xsl:call-template name="autoIndent"></xsl:call-template>
		<xsl:choose>
	    <xsl:when test="normalize-space(num) ='numbered' or normalize-space(num) ='ol' or normalize-space(num) =''">
  	 		<OL >
			<xsl:apply-templates/><xsl:call-template name="autoIndent"></xsl:call-template>
  	 		</OL>	
  	 	</xsl:when>
  	 	<xsl:otherwise>
  	 	<UL >
			<xsl:apply-templates/><xsl:call-template name="autoIndent"></xsl:call-template>
  	 	</UL>	
  	 	</xsl:otherwise>
   	</xsl:choose>	
   	</xsl:if>
	</xsl:template>
	
	<xsl:template match="ol">	
	<xsl:call-template name="autoIndent"></xsl:call-template>
		<OL >
		<xsl:apply-templates/>
	<xsl:call-template name="autoIndent"></xsl:call-template></OL>		
	</xsl:template>
	
	<xsl:template match="ul">
	<xsl:call-template name="autoIndent"></xsl:call-template>
		<UL >
		<xsl:apply-templates/>
	<xsl:call-template name="autoIndent"></xsl:call-template></UL>		
	</xsl:template>
	
	<xsl:template match="table">	
	<xsl:call-template name="autoIndent"></xsl:call-template>
		<TABLE >
		<xsl:call-template name="common_attibutes"/>		
		<xsl:apply-templates/>
	<xsl:call-template name="autoIndent"></xsl:call-template>
		</TABLE>		
	</xsl:template>
	
	<xsl:template match="header">	
	<xsl:call-template name="autoIndent"></xsl:call-template>

	<xsl:call-template name="autoIndent"></xsl:call-template>
		<TR>
		<xsl:call-template name="common_attibutes"/>
		<xsl:apply-templates/>
		</TR>
	<xsl:call-template name="autoIndent"></xsl:call-template>	
	</xsl:template>
		
	<xsl:template match="row">	
		<TR>
		<xsl:call-template name="common_attibutes"/>
		<xsl:apply-templates/>
		</TR>		
	</xsl:template>
				
	<xsl:template match="cell">	
		<xsl:choose>
			<xsl:when test="ancestor::header">
				<TH>
				<xsl:call-template name="common_attibutes"/>
				<xsl:apply-templates/>
				</TH>	
			</xsl:when>
			<xsl:otherwise>
				<TD>
				<xsl:call-template name="common_attibutes"/>
				<xsl:apply-templates/>
				</TD>		
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="li">
		<LI><xsl:apply-templates/></LI>				
	</xsl:template>
	
	<xsl:template match="input">
		<INPUT><xsl:apply-templates/></INPUT>				
	</xsl:template>

	<xsl:template match="LEV">
		<!-- todo set id xsl:call-template name="str_to_id">
		<xsl:with-param name="str" select="p[1]/text()[1]" />
		</xsl:call-template-->
		
		<xsl:if test="(not(p/when) and not(when)) or(p/when and contains($choose,normalize-space(p/when))) or (when and contains($choose,normalize-space(when))) ">
			<!-- WHEN:"<xsl:value-of select="ancestor-or-self::*/when"/>"<br/>
			WHEN2:"<xsl:value-of select="normalize-space(ancestor-or-self::*/when)"/>"<br/>
			WHEN3:"<xsl:value-of select="ancestor-or-self::*/when/text()"/>"<br/>
			WHEN4:"<xsl:value-of select="when"/>"<br/>
			WHEN5:"<xsl:value-of select="*/when"/>"<br/>
			CHOOSE:"<xsl:value-of select="$choose"/><br/ --> 
		
			<xsl:choose>

				<xsl:when test="not(*)">
									<xsl:variable name="level"><xsl:value-of select="count(ancestor::*)"/></xsl:variable>
					<xsl:call-template name="indent"><xsl:with-param name="level" select="$level"/></xsl:call-template>
					<xsl:choose>
						<xsl:when test="parent::xml" >	
							<H1 CLASS="title" ><xsl:attribute name="id"><xsl:call-template name="str_to_id"></xsl:call-template></xsl:attribute>
							<xsl:call-template name="common_attibutes"/><xsl:apply-templates /></H1>
						</xsl:when>
						<xsl:when test="($level = 1) or parent::xml" >	
							<H1 CLASS="title" ><xsl:attribute name="id"></xsl:attribute>
							<xsl:call-template name="common_attibutes"/><xsl:apply-templates /></H1>
						</xsl:when>
						<xsl:when test="$level = 2" >	
							<H2><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></H2>
						</xsl:when>
						<xsl:when test="$level = 3" >	
							<H3><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></H3>
						</xsl:when>
						<xsl:when test="$level = 4" >	
						<H4><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></H4>
						</xsl:when>					
						<xsl:when test="$level = 5" >	
						<DIV><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></DIV>
						</xsl:when>			
						<xsl:when test="$level > 5" >	
						<SPAN class="level5"><P><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></P></SPAN>
						</xsl:when>	
						
						<xsl:otherwise>
						<xsl:call-template name="autoIndent"></xsl:call-template>
							<P><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></P>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when> <!--xsl:when test="not(*)"-->
				<xsl:otherwise>
					<span><xsl:call-template name="common_attibutes"/><xsl:apply-templates/></span>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	
	</xsl:template><!-- LEV -->
	
	<!-- 'case' node is identical to LEV, except must have 'when' subnode-->
	<xsl:template match="case">
			<xsl:if test="not(when) and not(p/when)">					
      <H1  STYLE="color:red">ERROR!:'case' requires 'when'</H1>  			
		</xsl:if>
		<xsl:if test="(p/when and contains($choose,normalize-space(p/when))) or (when and contains($choose,normalize-space(when))) ">
					<xsl:apply-templates/>
  </xsl:if>
	</xsl:template>	

</xsl:stylesheet>



