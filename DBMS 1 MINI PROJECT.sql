## DBMS 1 MINI PROJECT ##
use ipl;

# 1. Show the percentage of wins of each bidder in the order of highest to lowest percentage.
Select ip_bd.bidder_id, ip_bd.bidder_name, round((ip_bd_won.wins/no_of_bids)*100,2) as Wins_Percentage
From ipl_bidder_details ip_bd inner join ipl_bidder_points ip_bp
On ip_bd.bidder_id = ip_bp.bidder_id 
inner join (Select bidder_id, count(bid_status) as Wins
From ipl_bidding_details 
where bid_status = 'won'
group by bidder_id) as ip_bd_won
on ip_bp.bidder_id = ip_bd_won.bidder_id 
group by ip_bd.bidder_id, ip_bd.bidder_name
order by Wins_Percentage desc;


# 2. Display the number of matches conducted at each stadium with stadium name, city from the database.
select a.stadium_id,count(a.stadium_id) `matches conducted`, b.stadium_name from ipl_match_schedule a join ipl_stadium b 
on a.stadium_id = b.stadium_id
group by a.stadium_id order by a.stadium_id;

# 3. In a given stadium, what is the percentage of wins by a team which has won the toss?
select ip_s.stadium_name,
(sum(case 
when Toss_winner = Match_winner 
then 1 else 0 
end)/count(*) )*100 as Wins_Percentage
from ipl_stadium ip_s inner join ipl_match_schedule ip_ms 
on ip_s.stadium_id = ip_ms.stadium_id 
inner join ipl_match ip_m
on ip_m.match_id = ip_ms.match_id
where ip_ms.status = 'Completed'
group by ip_s.stadium_name;

# 4. Show the total bids along with bid team and team name.
select bid_team,team_name, sum(no_of_bids) from ipl_bidding_details a join ipl_bidder_points b
on a.bidder_id = b.bidder_id
join ipl_team c
on a.bid_team = c.team_id
group by bid_team order by bid_team ;

# 5. Show the team id who won the match as per the win details.
select MATCH_ID, TEAM_ID1, TEAM_ID2, MATCH_WINNER, case
when MATCH_WINNER = 1 then TEAM_ID1
else TEAM_ID2
end WINNING_TEAM_ID, WIN_DETAILS
from ipl_match;

# 6. Display total matches played, total matches won and total matches lost by team along with its team name.
select b.team_name,a.team_id,sum(matches_played) `total matches played`,sum(matches_won) `total matches won`,sum(matches_lost) `total matches lost`
from ipl_team_standings a join ipl_team b
on a.team_id = b.team_id
group by team_id;

# 7. Display the bowlers for Mumbai Indians team.
select team_id, player_id, player_role from ipl_team_players
where team_id in (select team_id from ipl_team where team_name='Mumbai Indians') and player_role like 'bowler';

# 8. How many all-rounders are there in each team, Display the teams with more than 4 all-rounder in descending order.
select team_name,count(player_role) `Total All Rounders` from ipl_team_players a join ipl_team b
on a.team_id=b.team_id
where player_role = 'all-rounder'
group by team_name 
having count(player_role)>4
order by count(player_role) desc;