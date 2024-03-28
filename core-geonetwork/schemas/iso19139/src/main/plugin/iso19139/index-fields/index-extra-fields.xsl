<?xml version="1.0" encoding="UTF-8" ?>
<!--
  ~ Copyright (C) 2001-2016 Food and Agriculture Organization of the
  ~ United Nations (FAO-UN), United Nations World Food Programme (WFP)
  ~ and United Nations Environment Programme (UNEP)
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or (at
  ~ your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful, but
  ~ WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
  ~
  ~ Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
  ~ Rome - Italy. email: geonetwork@osgeo.org
  -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gmi="http://www.isotc211.org/2005/gmi"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:gml320="http://www.opengis.net/gml"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gn-fn-index="http://geonetwork-opensource.org/xsl/functions/index"
                xmlns:index="java:org.fao.geonet.kernel.search.EsSearchManager"
                xmlns:util="java:org.fao.geonet.util.XslUtil"
                xmlns:date-util="java:org.fao.geonet.utils.DateUtil"
                version="2.0">
  <!--IMPORTS-->
  <xsl:import href="common/index-utils.xsl"/>

  <!--PARAMETERS-->
  <xsl:param name="id"/>
  <xsl:param name="uuid"/>
  <xsl:param name="title"/>

  <!--VARIABLES-->
  <xsl:variable name="isMultilingual" select="count(distinct-values(*//gmd:LocalisedCharacterString/@locale)) > 0"/>
  <xsl:variable name="mainLanguage" as="xs:string?" select="util:getLanguage()"/>
  <xsl:variable name="otherLanguages" select="distinct-values(//gmd:LocalisedCharacterString/@locale)"/>
  <xsl:variable name="allLanguages">
    <lang id="default" value="{$mainLanguage}"/>
    <xsl:for-each select="$otherLanguages">
      <lang id="{substring(., 2, 2)}" value="{util:threeCharLangCode(substring(., 2, 2))}"/>
    </xsl:for-each>
  </xsl:variable>

  <!-- Extra Fields indexing -->
  <xsl:template mode="index-extra-fields" match="*">
	<xsl:for-each select="gmd:identificationInfo">
		<xsl:for-each select="gmd:MD_DataIdentification">
			
			<!-- characterSet -->
			<xsl:for-each select="gmd:characterSet/*[@codeListValue != '']">
				<OrgCharacterSet type="object">
					{
						"characterSetCodeDesc":"<xsl:value-of select="."/>",
						"test":"ffffffffff"
					}
				</OrgCharacterSet>
			</xsl:for-each>


			<!-- SpatialResolution -->
			<xsl:for-each select="gmd:spatialResolution/gmd:MD_Resolution">
			  <xsl:for-each
				select="gmd:equivalentScale/gmd:MD_RepresentativeFraction/gmd:denominator/gco:Integer[. castable as xs:decimal]">
				<OrgResolutionScaleDenominator>
				  <xsl:value-of select="."/>
				</OrgResolutionScaleDenominator>
			  </xsl:for-each>

			  <xsl:for-each select="gmd:distance/gco:Distance[. != '']">
				<OrgResolutionDistance type="object">
					{
						"distance":"<xsl:value-of select="."/>",
						"uom":"<xsl:value-of select="@uom"/>"
					}
				  <xsl:value-of select="concat(., ' ', @uom)"/>
				</OrgResolutionDistance>
			  </xsl:for-each>
			</xsl:for-each>
			
			<!-- VerticalExtent -->
			<xsl:for-each select="*/gmd:EX_Extent">
				<xsl:for-each select=".//gmd:verticalElement/*">
					<xsl:variable name="min" select="gmd:minimumValue/*/text()"/>
					<xsl:variable name="max" select="gmd:maximumValue/*/text()"/>

					<xsl:if test="$min castable as xs:double">
					  <OrgResourceVerticalRange type="object">{
						"gte": <xsl:value-of select="normalize-space($min)"/>
						<xsl:if test="$max castable as xs:double
									  and xs:double($min) &lt; xs:double($max)">
						  ,"lte": <xsl:value-of select="normalize-space($max)"/>
						</xsl:if>
						}</OrgResourceVerticalRange>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>
			
			<!-- Additional Information -->
			<xsl:copy-of select="gn-fn-index:add-multilingual-field('OrgSupplementalInformation', gmd:supplementalInformation, $allLanguages)"/>
			
			
			<!-- Citation Props -->
			<xsl:for-each select="gmd:citation/gmd:CI_Citation">
				<xsl:copy-of select="gn-fn-index:add-multilingual-field('OrgResourceTitle', gmd:title, $allLanguages)"/>
				<xsl:copy-of select="gn-fn-index:add-multilingual-field('OrgResourceAltTitle', gmd:alternateTitle, $allLanguages)"/>

				<xsl:for-each select="gmd:date/gmd:CI_Date[gn-fn-index:is-isoDate(gmd:date/*/text())]">
					<xsl:variable name="dateType" select="gmd:dateType[1]/gmd:CI_DateTypeCode/@codeListValue" as="xs:string?"/>
					<xsl:variable name="date" select="string(gmd:date[1]/gco:Date|gmd:date[1]/gco:DateTime)"/>

					<xsl:variable name="zuluDateTime" as="xs:string?">
					  <xsl:if test="$date != '' and gn-fn-index:is-isoDate($date)">
						<xsl:value-of select="date-util:convertToISOZuluDateTime(normalize-space($date))"/>
					  </xsl:if>
					</xsl:variable>

					<xsl:choose>
					  <xsl:when test="$zuluDateTime != ''">
						<xsl:element name="{$dateType}DateForResource">
						  <xsl:value-of select="$zuluDateTime"/>
						</xsl:element>
						<xsl:element name="{$dateType}YearForResource">
						  <xsl:value-of select="substring($zuluDateTime, 0, 5)"/>
						</xsl:element>
						<xsl:element name="{$dateType}MonthForResource">
						  <xsl:value-of select="substring($zuluDateTime, 0, 8)"/>
						</xsl:element>
					  </xsl:when>
					  <xsl:otherwise>
						<indexingErrorMsg>Warning / Date <xsl:value-of select="$dateType"/> with value '<xsl:value-of select="$date"/>' was not a valid date format.</indexingErrorMsg>
					  </xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>

				<!-- <xsl:for-each select="gmd:date/gmd:CI_Date[gn-fn-index:is-isoDate(gmd:date/*/text())]"> -->
					<!-- <OrgResourceDate type="object"> -->
						<!-- <xsl:variable name="dateType" select="gmd:dateType[1]/gmd:CI_DateTypeCode/@codeListValue" as="xs:string?"/> -->
						<!-- <xsl:variable name="date" select="string(gmd:date[1]/gco:Date|gmd:date[1]/gco:DateTime)"/> -->
						<!-- <xsl:variable name="zuluDate" select="date-util:convertToISOZuluDateTime($date)"/> -->
						
						<!-- <xsl:if test="$zuluDate != '' and $dateType != ''">					   -->
						<!-- { -->
							<!-- "type": "<xsl:value-of select="$dateType"/>" -->
							<!-- ,"date": "<xsl:value-of select="$zuluDate"/>" -->
						<!-- }					   -->
						<!-- </xsl:if> -->
					<!-- </OrgResourceDate> -->
				<!-- </xsl:for-each> -->

				<!-- <xsl:if test="$useDateAsTemporalExtent"> -->
					<!-- <xsl:for-each-group select="gmd:date/gmd:CI_Date[gn-fn-index:is-isoDate(gmd:date/*/text())]/gmd:date/*/text()" group-by="."> -->
					  <!-- <xsl:variable name="zuluDate" select="date-util:convertToISOZuluDateTime(.)"/> -->
					  <!-- <xsl:if test="$zuluDate != ''"> -->
						<!-- <OrgResourceTemporalDateRange type="object"> -->
						<!-- { -->
						  <!-- "gte": "<xsl:value-of select="$zuluDate"/>", -->
						  <!-- "lte": "<xsl:value-of select="$zuluDate"/>" -->
						<!-- } -->
						<!-- </OrgResourceTemporalDateRange> -->
					  <!-- </xsl:if> -->
					<!-- </xsl:for-each-group> -->
				<!-- </xsl:if> -->

				<xsl:for-each select="gmd:identifier/*[string(gmd:code/*)]">
					<OrgResourceIdentifier type="object">{
					  "code": "<xsl:value-of select="util:escapeForJson(gmd:code/(gco:CharacterString|gmx:Anchor))"/>",
					  "codeSpace": "<xsl:value-of select="gmd:codeSpace/(gco:CharacterString|gmx:Anchor)"/>",
					  "link": "<xsl:value-of select="gmd:code/gmx:Anchor/@xlink:href"/>"
					  }
					</OrgResourceIdentifier>
				</xsl:for-each>

				<xsl:for-each select="gmd:edition/*">
					<xsl:copy-of select="gn-fn-index:add-field('resourceEdition', .)"/>
				</xsl:for-each>
			</xsl:for-each>
		
		</xsl:for-each>
		
		
		<!-- ServiceType -->
		<xsl:for-each select="srv:SV_ServiceIdentification">
			<xsl:for-each select="srv:serviceType/gco:LocalName[string(text())]">
				<OrgServiceType>
					<xsl:value-of select="text()"/>
				</OrgServiceType>
			</xsl:for-each>
		</xsl:for-each>
						
	</xsl:for-each>	
  </xsl:template>
  
  
  
  
  
  
</xsl:stylesheet>