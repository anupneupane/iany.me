---
updated_at: <2013-05-29 13:14:53>
created_at: <2012-12-25 11:41:35>
title: PostgreSQL
tags: [database]
---

## Commands

-  switch database: `\connect dbname`
-  create database: `psql -d postgres -U postgres -c 'CREATE DATABASE xxx'`

## Backup & Restore

```sh
pg_restore  --clean --verbose --no-acl --no-owner \
  -h localhost -U myuser -d mydb mydb.dump
PGPASSWORD=mypassword pg_dump -Fc --no-acl --no-owner \
  -h localhost -U myuser mydb > mydb.dump
```


