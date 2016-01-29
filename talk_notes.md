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
