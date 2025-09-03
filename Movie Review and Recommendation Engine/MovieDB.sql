CREATE DATABASE MovieDB;
USE MovieDB;
# Users table
CREATE TABLE Users (user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,username VARCHAR(50) NOT NULL,email VARCHAR(100) UNIQUE NOT NULL) ENGINE=InnoDB;
# Movies table
CREATE TABLE Movies (movie_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,title VARCHAR(100) NOT NULL,genre VARCHAR(50),release_year INT) ENGINE=InnoDB;
# Ratings table
CREATE TABLE Ratings (rating_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,user_id INT UNSIGNED NOT NULL,movie_id INT UNSIGNED NOT NULL,
rating INT NOT NULL,rating_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,FOREIGN KEY (user_id) REFERENCES Users(user_id),FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)) ENGINE=InnoDB;
# Reviews table
CREATE TABLE Reviews (review_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,user_id INT UNSIGNED NOT NULL,movie_id INT UNSIGNED NOT NULL,
review_text TEXT,review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,FOREIGN KEY (user_id) REFERENCES Users(user_id),FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)) ENGINE=InnoDB;

# Users Data
INSERT INTO Users (username, email) VALUES ('Alice', 'alice@example.com'),('Bob', 'bob@example.com'),('Charlie', 'charlie@example.com');
# Movies Data
INSERT INTO Movies (title, genre, release_year) VALUES ('Inception', 'Sci-Fi', 2010),('The Dark Knight', 'Action', 2008),
('Interstellar', 'Sci-Fi', 2014),('The Godfather', 'Crime', 1972);
# Ratings Data
INSERT INTO Ratings (user_id, movie_id, rating) VALUES(1, 1, 9),(2, 1, 8),(3, 1, 10),(1, 2, 10),(2, 2, 9),(1, 4, 10);
# Reviews Data
INSERT INTO Reviews (user_id, movie_id, review_text) VALUES(1, 1, 'Mind-bending and amazing!'),(2, 1, 'Great visuals and story.'),(3, 2, 'Best Batman movie ever!');

# Average rating per movie
SELECT m.title, ROUND(AVG(r.rating), 2) AS avg_rating, COUNT(r.rating_id) AS total_ratings FROM Movies m
JOIN Ratings r ON m.movie_id = r.movie_id GROUP BY m.title ORDER BY avg_rating DESC;
# Ranking movies by average rating
SELECT title,avg_rating,RANK() OVER (ORDER BY avg_rating DESC) AS rating_rank FROM (SELECT m.title, AVG(r.rating) AS avg_rating FROM Movies m
JOIN Ratings r ON m.movie_id = r.movie_id GROUP BY m.title) AS movie_avg;

# View for top-rated movies
CREATE OR REPLACE VIEW Top_Rated_Movies AS SELECT m.movie_id,m.title,AVG(r.rating) AS avg_rating,COUNT(r.rating_id) AS total_ratings FROM Movies m
JOIN Ratings r ON m.movie_id = r.movie_id GROUP BY m.movie_id, m.title HAVING COUNT(r.rating_id) >= 2 ORDER BY avg_rating DESC;
SELECT * FROM Top_Rated_Movies;

# Top 3 movies overall
SELECT title,avg_rating,RANK() OVER (ORDER BY avg_rating DESC) AS `rank` FROM Top_Rated_Movies LIMIT 3;

