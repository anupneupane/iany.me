---
updated_at: <2011-12-08 06:27:20>
created_at: <2011-12-03 03:40:47>
title: Solr
tags: search, Java
---

Solr development using Maven
----------------------------

Create a war project and add `org.apache.solr.solr` as a dependency. And add
Jetty plugin to start Solr using `mvn jetty:run-exploded`. Configuration file
should be placed in `solr/conf` in the top project directory.

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.example</groupId>
  <artifactId>my-solr</artifactId>
  <packaging>war</packaging>
  <version>1.0-SNAPSHOT</version>
  <name>New Solr War</name>

  <dependencies>
    <dependency>
      <groupId>org.apache.solr</groupId>
      <artifactId>solr</artifactId>
      <version>3.1.0</version>
      <type>war</type>
    </dependency>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>3.8.1</version>
      <scope>test</scope>
    </dependency>
  </dependencies>

  <build>
    <finalName>my-solr</finalName>

    <plugins>
     <plugin>
       <groupId>org.mortbay.jetty</groupId>
       <artifactId>maven-jetty-plugin</artifactId>
       <version>6.1.24</version>
     </plugin>
     <plugin>
       <artifactId>maven-assembly-plugin</artifactId>
       <version>2.2.1</version>
       <configuration>
         <descriptors>
           <descriptor>src/main/assembly/release.xml</descriptor>
         </descriptors>
       </configuration>
       <executions>
         <execution>
           <id>make-assembly</id> <!-- this is used for inheritance merges -->
           <phase>package</phase> <!-- bind to the packaging phase -->
           <goals>
             <goal>single</goal>
           </goals>
         </execution>
       </executions>
     </plugin>
   </plugins>
  </build>
</project>
```

The following assembly descriptor builds a package ready for deployment.

```xml
<assembly xmlns="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.0" 
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.0 http://maven.apache.org/xsd/assembly-1.1.0.xsd">
  <id>release</id>
  <formats>
    <format>tar.gz</format>
    <format>tar.bz2</format>
    <format>zip</format>
  </formats>
  <fileSets>
    <fileSet>
      <directory>${project.basedir}/solr</directory>
      <outputDirectory>/</outputDirectory>
      <includes>
        <include>conf/*</include>
      </includes>
    </fileSet>
    <fileSet>
      <directory>${project.build.directory}</directory>
      <outputDirectory>/webapps</outputDirectory>
      <includes>
        <include>*.war</include>
      </includes>
    </fileSet>
  </fileSets>
</assembly>
```