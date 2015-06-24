/* Create a cart object */
var cart = new Object();

/* Initialises the cart database */
cart.initCart = function() {
  /* Open database*/
  cart.db = openDatabase('cart', '1.0', 'Shopping Cart', 2 * 1024 * 1024);
  
  /* Init */
  cart.db.transaction(function (tx) {
    tx.executeSql('CREATE TABLE IF NOT EXISTS cart (id primary key, amount, restaurant, price, data)');
    
  });
}

/* Gets the amount of the given meal. The result is passed to onsuccess as parameter */
cart.getAmount = function(restaurantId, meal, onsuccess) {
  /* Query for the id */
  cart.db.transaction(function (tx) {
    tx.executeSql(
      'SELECT amount FROM cart WHERE id = ?', 
      [meal.meal_id],
      function(tx, results) {
        if(results.rows.length > 0) {
          onsuccess(results.rows[0].amount);

        } else {
          onsuccess(0);
          
        }
    });
  });
}

/* Increments the amount of the given meal. The new amount is  passed to onsuccess as parameter */
cart.increaseAmount = function(restaurantId, meal, onsuccess) {
  cart.alterAmount(restaurantId, meal, 1, onsuccess);
  
}

/* Decrements the amount of the given meal. The new amount is  passed to onsuccess as parameter */
cart.decreaseAmount = function(restaurantId, meal, onsuccess) {
  cart.alterAmount(restaurantId, meal, -1, onsuccess);
  
}

/* Alters the amount of the given meal. The new amount is the old amount plus the difference (positive or negative).
   The new amount is  passed to onsuccess as parameter */
cart.alterAmount = function(restaurantId, meal, difference, onsuccess) {
  /* Select amount from cart */
  cart.getAmount(restaurantId, meal, function (amount) {    
    /* Calc new amount */
    amount += difference;

    /* Check if negative and set to zero */
    if(amount < 0) {
      amount = 0;
    }

    /* Set new amount, will add the meal to the cart or update it */
    cart.setAmount(restaurantId, meal, amount,onsuccess);
  });
}

/* Sets the amount of the given meal to the given value. The new amount is  passed to onsuccess as parameter */
cart.setAmount = function(restaurantId, meal, amount, onsuccess) {
  /* If amount is not a number, cancel and pass onsuccess to getAmount to return the current amount */
  if(isNaN(parseInt(amount))) {
    cart.getAmount(restaurantId, meal, onsuccess);
    return;
    
  }
  
  /* If the amount is negative, delte item from cart */
  if(amount <= 0) {
    /* Insert in cart if not in cart yet, will do nothing if the meal is already in the cart */
    cart.db.transaction(function (tx) {
      tx.executeSql(
        'DELETE FROM cart WHERE restaurant = ? AND id = ?',
        [restaurantId, meal.meal_id],
        function(tx, results) {
          cart.getAmount(restaurant, meal, onsuccess);

        }
      );
    });
  }
  
  /* If the amount is positive*/
  else {
    /* Insert in cart if not in cart yet, will do nothing if the meal is already in the cart */
    cart.db.transaction(function (tx) {
      tx.executeSql(
        'INSERT OR REPLACE INTO cart(id, amount, restaurant, price, data) VALUES(?, ?, ?, ?, ?)',
        [meal.meal_id, amount, restaurantId, meal.price, JSON.stringify(meal)],
        function(tx, results) {
          cart.getAmount(restaurant, meal, onsuccess);

        }
      );
    }); 
  }
}

/* Querys the number of different items in the cart. The number is passed to onsuccess as parameter */
cart.getCartItemCount = function(restaurantId, onsuccess) {
  /* Query for the number of items */
  cart.db.transaction(function (tx) {
    tx.executeSql(
      'SELECT SUM(amount) as count FROM cart WHERE restaurant = ?', 
      [restaurantId],
      function(tx, results) {
        onsuccess(results.rows[0].count);
        
    });
  });  
}

/* Querys the cart value. The value is passed to onsuccess as parameter */
cart.getCartValue = function(restaurantId, onsuccess) {
  /* Query for the number of items */
  cart.db.transaction(function (tx) {
    tx.executeSql(
      'SELECT SUM(amount * price) AS value FROM cart WHERE restaurant = ?', 
      [restaurantId],
      function(tx, results) {
        onsuccess(results.rows[0].value);
        
    });
  });  
}
  
/* Querys an overview over the entire cart for the given restaurant */
cart.getOverview = function(restaurantId, onsuccess) {
  /* Query for the number of items */
  cart.db.transaction(function (tx) {
    tx.executeSql(
      'SELECT * FROM cart WHERE restaurant = ? ORDER BY id DESC', 
      [restaurantId],
      function(tx, results) {
        onsuccess(results);
        
    });
  });  
}

/* Deletes all items for the given restaurant */
cart.deleteRestaurant = function(restaurantId) {
  console.log('delete');
  /* Delete all items from one restaurant */
  cart.db.transaction(function (tx) {
    tx.executeSql(
      'DELETE FROM cart WHERE restaurant = ?',
      [restaurantId],
      function(tx, results) {
        console.log(tx);
        console.log(results);
      }
    );
  });
}