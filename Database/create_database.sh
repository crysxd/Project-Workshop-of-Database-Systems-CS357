echo > mymeal_database.sql

# Schema
cat ./schema/mymeal_schema.sql >> mymeal_database.sql

# Users
cat ./users/mymeal_admin.sql >> mymeal_database.sql

# Functions
cat ./functions/distance.sql >> mymeal_database.sql

# Tables
cat ./tables/Tag.sql >> mymeal_database.sql
cat ./tables/Meal_Category.sql >> mymeal_database.sql
cat ./tables/Restaurant.sql >> mymeal_database.sql
cat ./tables/Customer.sql >> mymeal_database.sql
cat ./tables/Meal.sql >> mymeal_database.sql
cat ./tables/Rating.sql >> mymeal_database.sql

