CREATE DATABASE SportsTournamentDB;
USE SportsTournamentDB;
# Teams table
CREATE TABLE Teams (team_id INT PRIMARY KEY AUTO_INCREMENT,team_name VARCHAR(50) NOT NULL);
# Players table
CREATE TABLE Players (player_id INT PRIMARY KEY AUTO_INCREMENT,player_name VARCHAR(50) NOT NULL,team_id INT,FOREIGN KEY (team_id) REFERENCES Teams(team_id));
# Matches table
CREATE TABLE Matches (match_id INT PRIMARY KEY AUTO_INCREMENT,team1_id INT,team2_id INT,match_date DATE,team1_score INT,
team2_score INT,FOREIGN KEY (team1_id) REFERENCES Teams(team_id),FOREIGN KEY (team2_id) REFERENCES Teams(team_id));
# Stats table 
CREATE TABLE Stats (stat_id INT PRIMARY KEY AUTO_INCREMENT,match_id INT,player_id INT,points_scored INT,assists INT,rebounds INT,
FOREIGN KEY (match_id) REFERENCES Matches(match_id),FOREIGN KEY (player_id) REFERENCES Players(player_id));

# Teams Data
INSERT INTO Teams (team_name) VALUES ('Sharks'), ('Eagles'), ('Tigers');
# Players Data
INSERT INTO Players (player_name, team_id) VALUES ('Alice', 1), ('Bob', 1), ('Charlie', 2), ('David', 2), ('Eve', 3), ('Frank', 3);
# Matches Data
INSERT INTO Matches (team1_id, team2_id, match_date, team1_score, team2_score) VALUES(1, 2, '2025-09-01', 80, 75),
(2, 3, '2025-09-02', 65, 70),(1, 3, '2025-09-03', 90, 85);
# Stats Data
INSERT INTO Stats (match_id, player_id, points_scored, assists, rebounds) VALUES(1, 1, 25, 5, 7), (1, 2, 20, 7, 4),
(1, 3, 30, 6, 5), (1, 4, 25, 4, 6),(2, 3, 15, 3, 5), (2, 4, 20, 2, 4),(2, 5, 35, 6, 8), (2, 6, 35, 5, 7),
(3, 1, 30, 6, 5), (3, 2, 25, 5, 6),(3, 5, 20, 4, 7), (3, 6, 25, 6, 5);

#Match results
SELECT m.match_id, t1.team_name AS Team1, t2.team_name AS Team2, m.team1_score, m.team2_score, m.match_date
FROM Matches m JOIN Teams t1 ON m.team1_id = t1.team_id JOIN Teams t2 ON m.team2_id = t2.team_id;
# Player scores
SELECT p.player_name, t.team_name, SUM(s.points_scored) AS total_points FROM Stats s JOIN Players p ON s.player_id = p.player_id
JOIN Teams t ON p.team_id = t.team_id GROUP BY p.player_id;
#total points scored by team
SELECT t.team_name, SUM(s.points_scored) AS total_points FROM Stats s JOIN Players p ON s.player_id = p.player_id
JOIN Teams t ON p.team_id = t.team_id GROUP BY t.team_id ORDER BY total_points DESC;
#Views - Player Leaderboard 
CREATE VIEW Player_Leaderboard AS SELECT p.player_name, t.team_name, SUM(s.points_scored) AS total_points
FROM Stats s JOIN Players p ON s.player_id = p.player_id JOIN Teams t ON p.team_id = t.team_id GROUP BY p.player_id ORDER BY total_points DESC;
SELECT * FROM Player_Leaderboard;
#Team Points Table
CREATE VIEW Team_Points AS SELECT t.team_name, SUM(s.points_scored) AS total_points FROM Stats s
JOIN Players p ON s.player_id = p.player_id JOIN Teams t ON p.team_id = t.team_id GROUP BY t.team_id ORDER BY total_points DESC;
SELECT * FROM Team_Points;
#Using CTE for Average Player Performance
WITH Player_Avg AS (
    SELECT p.player_name, AVG(s.points_scored) AS avg_points
    FROM Stats s
    JOIN Players p ON s.player_id = p.player_id
    GROUP BY p.player_id
)
SELECT * FROM Player_Avg
ORDER BY avg_points DESC;