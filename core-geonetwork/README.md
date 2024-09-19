# GeoNetwork Open-source

# Build Health

[![Build Status](https://github.com/geonetwork/core-geonetwork/actions/workflows/linux.yml/badge.svg?branch=main)](https://github.com/geonetwork/core-geonetwork/actions/workflows/linux.yml?query=branch%3Amain)

This repository is a cloned copy of the repository https://github.com/geonetwork/core-geonetwork on the tag 4.2.8
Source: https://github.com/geonetwork/core-geonetwork/commit/e669c78201896f0b5ff3504195be7c799cff227c

This is a Java project that uses JDK 1.8, and Spring version 5.3.30
The project is built in Maven.

# How to run the project locally:

1. To open the project for development it is best to have Intellij Community Edition:  
https://www.jetbrains.com/idea/download/download-thanks.html?platform=macM1&code=IIC  


2. Load the project by loading the pom.xml file, and select Open as project.  


3. In the terminal you will have to execute the following commands:
git submodule init   
git submodule update  
git submodule update --init  


4. Make sure the project is executing with Java 8, so File -> Project Structure -> SDK: Coretto 1.8 


5. Change the Maven configurations for install: 
In the Panel on the right side click on the big letter M,   
to open the maven configurations.  
Choose GeoNetwork opensource -> Lifecycle -> right click on "install" -> Modify run configurations ...  
In the field Run, replace the contents with this: clean install -DskipTests -DschemasCopy=true -T 2C -f pom.xml  
Apply, close. Now your modified configuration will be available to execute from:  
GeoNetwork opensource -> Run Configurations -> geonetwork[install]

  
6. Change the Maven configurations for running locally:  
In the Panel on the right side click on the big letter M, to open the maven configurations.  
Choose GeoNetwork opensource -> GeoNetwork Web Module -> Plugins -> jetty -> right click on "jetty:run" -> Modify run configurations ...  
In the field Run, replace the contents with this: jetty:run -Penv-dev -f pom.xml  
Apply, close. Now your modified configuration will be available to execute from:  
GeoNetwork opensource -> GeoNetwork Web Module -> Run Configurations -> gn-web-app[jetty:run]    


7. To run the project locally you have to first build the project, with the first run configuration you created  
geonetwork[install]. After this finishes successfully, click on the second run configuration you created gn-web-app[jetty:run]

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

