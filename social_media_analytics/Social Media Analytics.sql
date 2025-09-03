CREATE DATABASE social_analytics;
USE social_analytics;
#User Table
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
#Posts Table
CREATE TABLE Posts (
    post_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    like_count INT DEFAULT 0
);
#Likes Table
CREATE TABLE Likes (
    like_id SERIAL PRIMARY KEY,
    post_id INT REFERENCES Posts(post_id),
    user_id INT REFERENCES Users(user_id),
    liked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(post_id, user_id) -- prevent duplicate likes
);
#Comments Table
CREATE TABLE Comments (
    comment_id SERIAL PRIMARY KEY,
    post_id INT REFERENCES Posts(post_id),
    user_id INT REFERENCES Users(user_id),
    comment_text TEXT NOT NULL,
    commented_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
#Users Data
INSERT INTO Users (username) VALUES 
('sakshi'), ('amit'), ('priya'), ('rahul');
#Posts Data
INSERT INTO Posts (user_id, content) VALUES
(1, 'Hello World!'),
(2, 'Learning PostgreSQL is fun!'),
(3, 'SQL Analytics Project!');
#Likes Data
INSERT INTO Likes (post_id, user_id) VALUES
(1, 2), (1, 3), (2, 1), (3, 2), (3, 4);
#Comments Data
INSERT INTO Comments (post_id, user_id, comment_text) VALUES
(1, 2, 'Nice post!'),
(2, 3, 'Agreed!'),
(3, 1, 'Great project idea!');

#Top Posts by Likes & Comments
CREATE VIEW TopPosts AS
SELECT p.post_id, p.content, p.user_id,
       COUNT(DISTINCT l.like_id) AS total_likes,
       COUNT(DISTINCT c.comment_id) AS total_comments
FROM Posts p
LEFT JOIN Likes l ON p.post_id = l.post_id
LEFT JOIN Comments c ON p.post_id = c.post_id
GROUP BY p.post_id, p.content, p.user_id
ORDER BY total_likes DESC, total_comments DESC;
SELECT * FROM TopPosts;

#window functions for rankings
SELECT p.post_id, p.content, 
       COUNT(l.like_id) AS like_count,
       RANK() OVER (ORDER BY COUNT(l.like_id) DESC) AS `rank`
FROM Posts p
LEFT JOIN Likes l ON p.post_id = l.post_id
GROUP BY p.post_id, p.content;
# triggers to update like counts.
DELIMITER $$
CREATE TRIGGER increment_like_count
AFTER INSERT ON Likes
FOR EACH ROW
BEGIN
    UPDATE Posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END$$

DELIMITER ;
SELECT p.post_id, p.content, p.like_count
FROM Posts p
ORDER BY p.like_count DESC;
#Export engagement reports.
COPY (SELECT * FROM TopPosts) 
TO '/tmp/top_posts_report.csv' 
DELIMITER ',' CSV HEADER;

