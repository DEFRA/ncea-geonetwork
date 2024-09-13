# GeoNetwork Open-source

# Build Health

[![Build Status](https://github.com/geonetwork/core-geonetwork/actions/workflows/linux.yml/badge.svg?branch=main)](https://github.com/geonetwork/core-geonetwork/actions/workflows/linux.yml?query=branch%3Amain)

# Build Source code

* If you only wish to quickly build the GeoNetwork code, execute the following:

`cd core-geonetwork
mvn clean install -DskipTests`

* Generated "geonetwork.war" file and referred it in docker file for deployment.

* Documentation is managed at [Geonetwork Build Documentation](https://docs.geonetwork-opensource.org/4.2/install-guide/installing-from-source-code/#tools)

# Creating MDC schema

* Created a folder folder for MDC schema files under below location
  `core-geonetwork\web\src\main\webapp\WEB-INF\data\data\resources\xml\schemas\iso19139\schema2007\MDC`
* Created 3 Schema files under MDC directory.
  `MDC.xsd
   identifiers.xsd
   classifiers.xsd`
* Added referrence to identifiers and Classifiers nodes in schema file 
  schema file:
  `ncea-geonetwork\core-geonetwork\web\src\main\webapp\WEB-INF\data\data\resources\xml\schemas\iso19139\schema2007\gmd\metadataEntity.xsd.`
  
   Code change:
   `<xs:element name="nceaClassifierInfo" type="mdc:NC_Classifiers_PropertyType" minOccurs="0" maxOccurs="unbounded"/>
   <xs:element name="nceaIdentifiers" type="mdc:NC_Identifiers_Type" minOccurs="0" maxOccurs="unbounded"/>`

# Indexing customization
* Created a xsl file for custom indexing "index-extra-fields.xsl" and referred it in index.xsl
  `core-geonetwork\schemas\iso19139\src\main\plugin\iso19139\index-fields\index.xsl`
* Added all custom indexing inside "index-extra-fields.xsl"

# Features

* Immediate search access to local and distributed geospatial catalogues
* Uploading and downloading of data, graphics, documents, pdf files and any other content type
* An interactive Web Map Viewer to combine Web Map Services from distributed servers around the world
* Online editing of metadata with a powerful template system
* Scheduled harvesting and synchronization of metadata between distributed catalogs
* Support for OGC-CSW 2.0.2 ISO Profile, OAI-PMH, SRU protocols
* Fine-grained access control with group and user management
* Multi-lingual user interface

# Documentation

User documentation is managed in the [geonetwork/doc](https://github.com/geonetwork/doc) repository covering all releases of GeoNetwork.

The `docs` folder includes [geonetwork/doc](https://github.com/geonetwork/doc) as a git submodule. This documentation is compiled into html pages during a release for publishing on the [geonetwork-opensource.org](https://www.geonetwork-opensource.org) website.

Developer documentation located in README.md files in the code-base:

* General documentation for the project as a whole is in this README.md
* [Software Development Documentation](/software_development/) provides instructions for setting up a development environment, building GeoNetwork, compiling user documentation, and making a releases
* Module specific documentation can be found in each module (assuming there is module specific documentation required)

