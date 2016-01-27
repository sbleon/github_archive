-- Most active users

explain
select users.username, count(events.user_id)
from users
  inner join events on events.user_id = users.id
group by username
order by count(events.id) desc
limit 10;

                                           QUERY PLAN
-------------------------------------------------------------------------------------------------
 Limit  (cost=90630.80..90630.82 rows=10 width=21)
   ->  Sort  (cost=90630.80..90827.73 rows=78773 width=21)
         Sort Key: (count(events.id)) DESC
         ->  GroupAggregate  (cost=84552.28..88928.54 rows=78773 width=21)
               Group Key: users.username
               ->  Sort  (cost=84552.28..85449.42 rows=358853 width=21)
                     Sort Key: users.username
                     ->  Hash Join  (cost=3611.39..44082.15 rows=358853 width=21)
                           Hash Cond: (events.user_id = users.id)
                           ->  Seq Scan on events  (cost=0.00..31645.53 rows=358853 width=12)
                           ->  Hash  (cost=2241.73..2241.73 rows=78773 width=13)
                                 ->  Seq Scan on users  (cost=0.00..2241.73 rows=78773 width=13)

explain
select username, count(id)
from fast_event_reports
group by username
order by count(id) desc
limit 10;
                                          QUERY PLAN
----------------------------------------------------------------------------------------------
 Limit  (cost=41093.49..41093.51 rows=10 width=18)
   ->  Sort  (cost=41093.49..41170.50 rows=30805 width=18)
         Sort Key: (count(id)) DESC
         ->  HashAggregate  (cost=40119.76..40427.81 rows=30805 width=18)
               Group Key: username
               ->  Seq Scan on fast_event_reports  (cost=0.00..38314.17 rows=361117 width=18)
(6 rows)

-- First PRs of the year

select users.username, repos.name, events.created_at
from events
  inner join users on users.id = events.user_id
  inner join repos on repos.id = events.repo_id
where events.type = 'PullRequestEvent'
order by events.created_at asc
limit 10;

                                        QUERY PLAN
-------------------------------------------------------------------------------------------
 Limit  (cost=42423.59..42423.62 rows=10 width=40)
   ->  Sort  (cost=42423.59..42459.30 rows=14282 width=40)
         Sort Key: events.created_at
         ->  Hash Join  (cost=7843.55..42114.97 rows=14282 width=40)
               Hash Cond: (events.repo_id = repos.id)
               ->  Hash Join  (cost=3611.39..36875.43 rows=14282 width=21)
                     Hash Cond: (events.user_id = users.id)
                     ->  Seq Scan on events  (cost=0.00..32542.66 rows=14282 width=16)
                           Filter: ((type)::text = 'PullRequestEvent'::text)
                     ->  Hash  (cost=2241.73..2241.73 rows=78773 width=13)
                           ->  Seq Scan on users  (cost=0.00..2241.73 rows=78773 width=13)
               ->  Hash  (cost=2415.18..2415.18 rows=93918 width=27)
                     ->  Seq Scan on repos  (cost=0.00..2415.18 rows=93918 width=27)


explain
select username, repo_name, created_at
from fast_event_reports
where type = 'PullRequestEvent'
order by created_at asc
limit 10;

                                        QUERY PLAN
--------------------------------------------------------------------------------------------
 Limit  (cost=0.42..105.65 rows=10 width=41)
   ->  Index Scan using index_fast_event_reports_on_created_at on fast_event_reports  (cost=0.42..150849.34 rows=14336 width=41)
         Filter: ((type)::text = 'PullRequestEvent'::text)
(3 rows)
