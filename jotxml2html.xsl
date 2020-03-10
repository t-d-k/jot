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
		<xsl:param name="str" />
		<xsl:call-template name="replace_special">
			<xsl:with-param name="str" select="substring($str, 1,20)" />
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
			colours are from the light tomorrow theme https://github.com/chriskempson/tomorrow-theme 
		
			#ffffff Background
			#efefef Current Line
			#d6d6d6 Selection
			#4d4d4c Foreground
			#8e908c Comment
			#c82829 Red
			#f5871f Orange
			#eab700 Yellow
			#718c00 Green
			#3e999f Aqua
			#4271ae Blue
			#8959a8 Purple
		
		*/
		/* also in jot.css  */
		*{ 	color:#4d4d4c; line-height:1.2em;  font-family:  sans-serif;}
		
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
			color:#efefef;
			background-color:#4d4d4c ;  
		}
		
		code p{
			color:#efefef;
			background-color:#4d4d4c ;
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
			border: 1pt solid #8e908c;	
			box-shadow: 5pt 5pt 8pt #8e908c;
		}
		
		pre.inline{
			margin: 0em;
			padding:0.1em 0.5em 0.1em 0.5em;
			display:inline;
			box-shadow: none;
			border: 1pt solid #8e908c;
		}
		
		a{ color:#4271ae; }
		
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
		
		blockquote { font-family:monospace; }
		
		img {
			display: block;
			margin:0.5em;
			margin-left: auto;
			margin-right: auto;
			border: 1px dotted #4d4d4c;
		}
		
		li { margin:0.5em; }
		
		table tr:nth-child(odd){	background:#efefef; }
		
		th {
			background: #d6d6d6;
			padding :0.5em; 	
		}
		
		td{	padding :0.2em 1em 0.2em 1em; }
		
		.alert{background:#f5871f;}		

		</STYLE><xsl:text>&#10;</xsl:text>	
		</HEAD><xsl:text>&#10;</xsl:text>		
		<BODY><xsl:text>&#10;</xsl:text>
		<!-- TODO: fix js + css so this works div class="jot_header">Click the '+' or '-' next to each item to expand or collapse that node</div -->
		<ARTICLE>
			<xsl:apply-templates /><xsl:text>&#10;</xsl:text>
		</ARTICLE><xsl:text>&#10;</xsl:text>		
		<xsl:call-template name="footnotes"/>
		<!-- 'nothing' is necesary because otherwise xsl collpases into single tag and browsers dont like it with 'strict'-->
		<!-- jot.js requires general.js -->
		<!-- script src="../../../slash_site/wwwroot/sites/all/themes/tdktheme/js/general.js?10" type="text/javascript"> /*nothing*/ </script>
		<script src="../../../slash_site/wwwroot/sites/all/themes/tdktheme/js/jotv2.js?10" type="text/javascript"> /*nothing*/ </script -->
		</BODY><xsl:text>&#10;</xsl:text>
		
		</HTML>
		
	</xsl:template>
	
	<xsl:template name="footnotes">
		<xsl:if test="//footnote">
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
		
	<!-- xsl:template match="line"></xsl:template -->
	
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
	<xsl:template name="common_attibutes">
		<xsl:if test="class">
			<xsl:attribute name="CLASS"><xsl:value-of select="class"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="id">
			<xsl:attribute name="ID"><xsl:value-of select="id"/></xsl:attribute>
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
				<xsl:call-template name="common_attibutes"/>
				<xsl:apply-templates />
				</LI>
			</xsl:when>
			<xsl:when test="row or parent::header" >
			<xsl:apply-templates />
			</xsl:when>
			<xsl:when test="parent::xml and $n = 1" >	
						<H1 CLASS="title"><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></H1>
			</xsl:when>
					<xsl:when test="($level = 1) or parent::xml" >	
				<H1><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></H1>
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
				<SPAN style="font-size=-1"><P><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></P></SPAN>
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
	
	<xsl:template match="a">
		<A>
		<xsl:attribute name="HREF">		
			<xsl:value-of select="normalize-space(r)"/>	
		<xsl:if test="p/r"><xsl:value-of select="normalize-space(p/r)"/></xsl:if>
			</xsl:attribute>
		<xsl:call-template name="common_attibutes"/>
	<xsl:apply-templates/></A>
</xsl:template>

<!-- L is like a but contents is node and text-->
<xsl:template match="L">
	<A HREF="#{normalize-space(.)}">
		<xsl:apply-templates/></A>
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
  	 		<OL ID="{generate-id(.)}">
			<xsl:apply-templates/><xsl:call-template name="autoIndent"></xsl:call-template>
  	 		</OL>	
  	 	</xsl:when>
  	 	<xsl:otherwise>
  	 	<UL ID="{generate-id(.)}">
			<xsl:apply-templates/><xsl:call-template name="autoIndent"></xsl:call-template>
  	 	</UL>	
  	 	</xsl:otherwise>
   	</xsl:choose>	
   	</xsl:if>
	</xsl:template>
	
	<xsl:template match="ol">	
	<xsl:call-template name="autoIndent"></xsl:call-template>
		<OL ID="{generate-id(.)}">
		<xsl:apply-templates/>
	<xsl:call-template name="autoIndent"></xsl:call-template></OL>		
	</xsl:template>
	
	<xsl:template match="ul">
	<xsl:call-template name="autoIndent"></xsl:call-template>
		<UL ID="{generate-id(.)}">
		<xsl:apply-templates/>
	<xsl:call-template name="autoIndent"></xsl:call-template></UL>		
	</xsl:template>
	
	<xsl:template match="table">	
	<xsl:call-template name="autoIndent"></xsl:call-template>
		<TABLE ID="{generate-id(.)}">
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
							<H1 CLASS="title"><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></H1>
						</xsl:when>
						<xsl:when test="($level = 1) or parent::xml" >	
							<H1><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></H1>
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
						<SPAN style="font-size=-1"><P><xsl:call-template name="common_attibutes"/><xsl:apply-templates /></P></SPAN>
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



