# About
This is the project for the course "Project Workshop of Database Systems" (CS357, SS2015) of 
- Saulo Ribeiro de Andrade – 7120309033 (sauloandradegames)
- Alexander Goscinski – 7120309027 (agoscinski)
- Christan Würthner (crysxd)

The aim for the project was to create a food-delivery system equal to the Chinese webpage ele.me. A customer should be able to find restaurants close to his location, select the dishes he wants and then place the order. The restaurant is informed about new orders with the state "pending"  in an admin panel. The restaurant can change the state of the delivery to "processing", "in delivery" and "completed". The user can see the progess of his orders on his profile page.

The system consist up of a backend including a webserver hosting the webpage and a REST interface written in PHP as well as a MySQL database storing all informations and a webpage as frontend. The webpage is devided into the section for customers and a admin panel for restaurants.

# Install the System
To install the system on the local machine, at first a Apache Webserver and a MySQL database as well as PHP must be installed. The contents of the directory "Webpage" must be placed into the "www" (may be named "htdocs" in some cases) directory of the Apache server. The SQL script "mymeal_database.sql" in the directory "Database" must be executed on the MySQL server. It will create necessary databases, tables, users, views, constraints and triggers. The webpage can now be accessed over "http://localhost" and the admin panel over "http://localhost/control".

# Register users
To register a new user the "Register/Login" button in the upper right corner can be used. In the login dialog, choose "New here? Register now!" at the bottom and enter the data. Please use only latin characters as user name as chinese letters may cause some problems although they basically work. The phone number is completely parsed into a region code (+86) and a national number, therefore the input must be consistent. A valid phone number for testing purpose is 0086 13062845608.

A already existing user login is "poet", password 123456.

# Use the admin panel
To enter the admin panel the url "http://localhost/control" must be used. You can either create a new restaurant (please note that only restaurants within the delivery range and with at leat one meal are shown in the search results) or use one of the already existing ones:
- KFC: id 7, password 123456
- PizzaHut Worldwide: id 15, password 123456
- Others: id from 0 - 16 (some ids in this range may not be used), password always 123456

In the admin panel you cann process orders placed by customers, edit the restaurant's information such as name, address and icon, as well as add, delete and edit the meals.

# Product Showcase
![alt text](https://raw.githubusercontent.com/crysxd/Project-Workshop-of-Database-Systems-CS357/images/Place_to_7-2-2015%2011-03-27%20AM.jpg?token=AFlnnLajqjWYGZk-KbhPAWd8tgEXUz9pks5Vn0kswA%3D%3D)
![alt text](https://github.com/crysxd/Project-Workshop-of-Database-Systems-CS357/raw/images/Place_to_7-2-2015%2011-04-45%20AM.jpg)
![alt text](https://github.com/crysxd/Project-Workshop-of-Database-Systems-CS357/raw/images/Place_to_7-2-2015%2011-07-56%20AM.jpg)
![alt text](https://github.com/crysxd/Project-Workshop-of-Database-Systems-CS357/raw/images/mockDrop_ONEPLUS%20ONE%20%3D%202.jpg)
![alt text](https://raw.githubusercontent.com/crysxd/Project-Workshop-of-Database-Systems-CS357/images/Place_to_7-2-2015%207-57-43%20AM.jpg?token=AFlnnGo-gKVmSXzc9-UsH2ynYwHAApZzks5Vn0sZwA%3D%3D)
![alt text](https://raw.githubusercontent.com/crysxd/Project-Workshop-of-Database-Systems-CS357/images/Screen%20Shot%202015-11-24%20at%207.33.12%20PM.png)
![alt text](https://raw.githubusercontent.com/crysxd/Project-Workshop-of-Database-Systems-CS357/images/Screen%20Shot%202015-11-24%20at%207.33.17%20PM.png)
![alt text](https://raw.githubusercontent.com/crysxd/Project-Workshop-of-Database-Systems-CS357/images/Screen%20Shot%202015-11-24%20at%207.33.24%20PM.png)
![alt text](https://raw.githubusercontent.com/crysxd/Project-Workshop-of-Database-Systems-CS357/images/Screen%20Shot%202015-11-24%20at%207.33.30%20PM.png)
