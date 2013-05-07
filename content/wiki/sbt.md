---
title: sbt build tool
created_at: <2013-05-07 19:03:17>
updated_at: <2013-05-07 19:03:42>
tags: [java, build, scala]
---

File `build.sbt` contains expressions separated by empty lines.

```scala
name := "Hello"

version := "1.0"
```

Where `name` and `version` are sbt Key objects.

Dependencies compatible with Maven.

```scala
libraryDependencies += "org.apache.derby" % "derby" % "10.4.1.3" 

libraryDependencies += "org.apache.derby" % "derby" % "10.4.1.3" % "test"
```

Scope:

-   Project scope (default to current project)

-   Config scope (default to Global in build.sbt)

-   InTask scope (default to Global in build.sbt)

`{<build-uri>}/<project-id>/config:intask::key`, `*` for Global scope.
