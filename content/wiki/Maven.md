---
updated_at: <2013-05-02 05:47:18>
created_at: <2011-12-03 03:41:28>
title: Maven
tags: [java, maven]
---

## Archetype

-   scala, see `scala-archetype-simple` in [doitian/maven-archetype](https://github.com/doitian/maven-archetype).

-   web, `maven-archetype-webapp`.

## Plugins

### jetty

Run servlet container: `mvn jetty:run`

```xml
<project>
  [...]
  <build>
    <finalName>simple-webapp</finalName>
    <plugins>
      <plugin>
        <groupId>org.mortbay.jetty</groupId>
        <artifactId>maven-jetty-plugin</artifactId>
      </plugins>
    </plugins>
  </build>
  [...]
</project>
```

### Assembly

`maven-assembly-plugin`

```xml
<project>
  [...]
  <build>
    <plugins>
      <plugin>
        <artifactId>maven-assembly-plugin</artifactId>
        <configuration>
          <descriptorRefs>
            <descriptorRef>jar-with-dependencies</descriptorRef>
          </descriptorRefs>
        </configuration>
      </plugin>
    </plugins>
  </build>
  [...]
</project>
```

## POM

### snapshot version

```xml
<repositories>
  <repository>
    <id>central</id> 
    <name>Maven Repository Switchboard</name>
    <layout>default</layout>
    <url>http://repo1.maven.org/maven2</url>
    <snapshots>
      <enabled>false</enabled>
    </snapshots>
  </repository>
</repositories>

<pluginRepositories>
  <pluginRepository>
    <id>central</id> 
    <name>Maven Plugin Repository</name>
    <url>http://repo1.maven.org/maven2</url>
    <layout>default</layout>
    <snapshots>
      <enabled>false</enabled>
    </snapshots>
    <releases>
      <updatePolicy>never</updatePolicy>
    </releases>
  </pluginRepository>
</pluginRepositories>
```

### Dependencies

#### scope

compile, provided, runtime, test, system.

`system` dependency must specify `systemPath`.

#### optional dependencies

Optional dependencies are not added as transitive dependencies.

#### Dependency Version Ranges

`(,)` exclusive quantifiers, `[,]` inclusive quantifiers.

```xml
<dependency>
  <groupId>junit</groupId>
  <artifactId>junit</artifactId>
  <version>[3.8,4.0)</version>
  <scope>test</scope>
</dependency>
```

#### J2EE dependencies

Use [packages](https://oss.sonatype.org/index.html#nexus-search;quick~geronimo) from Geronimo project and add scope `provided`.

```xml
<project>
  [...]
  <dependencies>
    [...]
    <dependency>
      <groupId>org.apache.geronimo.specs</groupId>
      <artifactId>geronimo-servlet_2.4_spec</artifactId>
      <version>1.1.1</version>
      <scope>provided</scope>
    </dependency>
  </dependencies>
  [...]
</project>
```

#### Exclude dependencies

```xml
<dependency>
  <groupId>org.hibernate</groupId>
  <artifactId>hibernate</artifactId>
  <version>3.2.5.ga</version>
  <exclusions>
    <exclusion>
      <groupId>javax.transaction</groupId>
      <artifactId>jta</artifactId>
    </exclusion>
  </exclusions>
</dependency>
```

#### Multi modules dependency management

```xml
<dependencyManagement>
  <dependencies>
    [...]
  </dependencies>
</dependencyManagement>
```

Then child modules can omit the version.

Use `${project.version}` and `${project.groupId}` do declare sibling project dependencies.

Use `build>pluginManagement>plugins` to declare shared plugins configurations in child modules.

Use `mvn dependency:analyze` to scan referenced dependencies in code.


### Resources

Filtering

```xml
<build>
  <filters>
    <filter>src/main/filters/default.properties</filter>
  </filters>
  <resources>
    <resource>
      <directory>src/main/resources</directory>
      <filtering>true</filtering>
    </resource>
  </resources>
</build>
```

### Profile

```xml
<profiles>
    <profile>
      <id>production</id>
      <build>
       [...]
```

Activation

```xml
<project>
  ...
  <profiles>
    <profile>
      <id>dev</id>
      <activation>
        <activeByDefault>false</activeByDefault>
        <jdk>1.5</jdk>
        <os>
          <name>Windows XP</name>
          <family>Windows</family>
          <arch>x86</arch>
          <version>5.1.2600</version>
        </os>
        <property>
          <name>mavenVersion</name>
          <value>2.0.5</value>
        </property>
        <file>
          <exists>file2.properties</exists>
          <missing>file1.properties</missing>
        </file>
      </activation>
      ...
    </profile>
  </profiles>
</project>
```

## Site

## Repository

Configuring Maven settings for Nexus (`~/.m2/settings.xml`)

```xml
<?xml version="1.0"?>
<settings>
  ...
  <mirrors>
    <mirror>
      <id>Nexus</id>
      <name>Nexus Public Mirror</name>
      <url>http://localhost:8081/nexus/content/groups/public</url>
      <mirrorOf>central</mirrorOf>
    </mirror>
  </mirrors>
  ...
</settings>
```

Deploy

```xml
<project>
  ...
  <distributionManagement>
    ...
    <repository>
      <id>releases</id>
      <name>Internal Releases</name>
      <url>http://localhost:8081/nexus/content/repositories/releases</url>
    </repository>
    ...
  </distributionManagement>
  ...
</project>
```

Deploy snapshot

```xml
<project>
  ...
  <distributionManagement>
    ...
    <snapshotRepository>
      <id>snapshots</id>
      <name>Internal Snapshots</name>
      <url>http://localhost:8081/nexus/content/repositories/snapshots</url>
    </snapshotRepository>
    ...
  </distributionManagement>
  ...
</project>
```

Deploy 3rdparty artifacts:

```
$ mvn deploy:deploy-file -DgroupId=com.oracle -DartifactId=ojdbc14 \
> -Dversion=10.2.0.3.0 -Dpackaging=jar -Dfile=ojdbc.jar \
> -Durl=http://localhost:8081/nexus/content/repositories/thirdparty \
> -DrepositoryId=thirdparty
...
```
