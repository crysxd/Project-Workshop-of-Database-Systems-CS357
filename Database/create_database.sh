echo > mymeal_database.sql

# Schema
cat ./schema/mymeal_schema.sql >> mymeal_database.sql

# Users
cat ./users/mymeal_admin.sql >> mymeal_database.sql
cat ./users/mymeal_user.sql >> mymeal_database.sql

# Functions
cat ./functions/distance.sql >> mymeal_database.sql

# Tables
cat ./tables/Tag.sql >> mymeal_database.sql
cat ./tables/Delivery_State_Type.sql >> mymeal_database.sql

cat ./tables/Restaurant.sql >> mymeal_database.sql
cat ./tables/Customer.sql >> mymeal_database.sql
cat ./tables/Meal.sql >> mymeal_database.sql
cat ./tables/Meal_Tag_Map.sql >> mymeal_database.sql
cat ./tables/Delivery.sql >> mymeal_database.sql
cat ./tables/Delivery_State.sql >> mymeal_database.sql
cat ./tables/Delivery_Meal_Map.sql >> mymeal_database.sql
cat ./tables/Rating.sql >> mymeal_database.sql

# Views
cat ./views/delivery_views.sql >> mymeal_database.sql

# Constraints/Triggers >> mymeal_database.sql
cat ./constraints/delivery_meal_map_constraints.sql >> mymeal_database.sql
cat ./constraints/restaurant_constraints.sql >> mymeal_database.sql
cat ./constraints/meal_constraints.sql >> mymeal_database.sql
cat ./constraints/rating_constraints.sql >> mymeal_database.sql

