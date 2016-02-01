# Outline
- Show of hands
  - Who has built a relational database- backed web app?
  - Who has written SQL?
  - Who has created a database view?
  - Who has created a trigger?
    - You know what you need to know so you can leave now ;-)

- Have you ever had slow database queries slow down your application? If you haven't, you will someday. It's a kind of digital decay: dbs will slow down over time as the size grows.
- You have several options for dealing with this:
  - optimize your queries (change SQL, change indexes, etc)
  - throw money at it (more hardware)
  - sharding, replication, etc (complex to code and manage)
- Sometimes this slowness is caused by expensive joins (typically when merging large datasets from multiple tables). If this is your problem, materialized views may be the answer.
- Materialized View = A query stored like a table.
  - Instead of joining all those rows every time you query, join them once, store the joined columns, and update it when necessary.
  - A materialized view is like a view in that it is composed of data from tables (which can includes joins, filters, aggregates, etc). However, unlike a view, it is stored on disk, like a table.

- Your database engine may have some support for materialized views. Eg Postgres has them, but there's one big pitfall. They must be regenerated all at once, instead of updating individual rows only when necessary. So for this talk, we will not be using that feature of Postgres.



# Random notes
- Data from https://www.githubarchive.org/
- All events from 2016-01-01 - 2016-01-03
- 370MB compressed with gzip
- 1.3M events, 200k users, 250k repos

- Show original event structure?
- Show relational data model
- Need to use structure.sql to store triggers, etc
- What kinds of queries can benefit?
  - Those that join multiple large tables
  - Those that select from multiple tables
  - Those with an order clause
- SQL code is relatively difficult to maintain.
  - E.g. adding a column is a lot of work!
    - It needs to be added to multiple tables and views
    - Triggers must be updated
- Show pattern for getting all rows into mview
- Using some features of postgres 9.5
