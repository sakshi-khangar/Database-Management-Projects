# social_media_analytics

## Description
SQL-based backend system to track social media posts, likes, comments, and engagement scores.
The system uses dynamic views, ranking functions, and triggers to manage post engagement automatically. 
Reports can be exported for further analysis and visualization.

## Tools Used
- **Database:** MySQL  
- **Management Tool:** MySQL Workbench

## Database Schema
### Tables
1. **Users** – stores user information  
2. **Posts** – stores posts created by users  
3. **Likes** – tracks likes on posts  
4. **Comments** – tracks comments on posts  
### Relationships
- One user can create multiple posts  
- Each post can have multiple likes and comments  
- Likes and comments are linked to both posts and users

## Conclusion
This project demonstrates a backend system for social media analytics using SQL. It efficiently tracks posts, likes, comments, and generates engagement reports.
The system can be scaled for larger datasets and extended with additional features like shares, hashtags, and timelines.
