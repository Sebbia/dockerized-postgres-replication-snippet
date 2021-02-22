# Snippet of dockerized PostgreSQL with replication

This is a snippet of dockerized PostgreSQL with support for many databases in a single instance and replication to slave.

Replication can be helpfull for easy backup creation without stopping of master.

The source article about dockerized PostgreSQL with replication is [here](https://medium.com/@2hamed/replicating-postgres-inside-docker-the-how-to-3244dc2305be).

List of defined databases is presented in the environment section in the variable `DATABASES`.

```
environment:
    - DATABASES=db1,db2
```

New databases can be added later to this list.

Databases will be created with an user and password same as database name.