<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0"/> <!--320-->
  <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
  <meta name="description" content="">
  <meta name="author" content="">
  <link rel="icon" href="favicon.ico">

  <title>my-meal.com | Meals</title>

  <!-- Bootstrap core CSS -->
  <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">

  <!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
  <!--[if lt IE 9]><script src="../../assets/js/ie8-responsive-file-warning.js"></script><![endif]-->
  <script src="assets/js/ie-emulation-modes-warning.js"></script>

  <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
  <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->

  <!-- Custom styles for this template -->
  <link href="css/main.css" rel="stylesheet">
  <link href="css/meals.css" rel="stylesheet">
</head>
<body>
  
  <!-- Menus and overlays -->
  <?php  include('shared/header.html'); ?>
    
  <!-- Toast to inform the user that he can choose the amount in the next step -->
  <div class="alert alert-success toast" role="alert" style="display:none">
    <strong>Item added to cart!</strong> You can choose the amount in the next step
  </div>
  
  <section id="main-content">  
    <!-- meals list -->
    <div id="splash-screen">
      <div class="splash-container">
        <!-- Title -->
        <h1>Meals of <span class="restaurant-name">undefined</span></h1>
        <div class="splash-container-scroller">
          
          <!-- Info box -->
          <div id="restaurant-info">
            <img src="imgs/placeholder.png" class="pull-left restaurant-icon" alt>
            <h4 class="restaurant-name">undefined</h4>
            <p><span class="restaurant-rating-stars">☆☆☆☆☆</span>&nbsp;(<span class="restaurant-rating-count">undefined</span>)</p>
            <p>Minimum order value:&nbsp;<span class="restaurant-min-order-value">undefined</span>元</p>
            <p>Shipping costs:&nbsp;<span class="restaurant-shipping-costs">undefined</span>元</p>
            <p class="restaurant-description">undefined</p>
          </div>
          
          <div id="meals-list">
            <!-- Meals table -->
            <table class="table table-hover">
              <!-- Table header -->
              <thead>
                <tr>
                  <th>Meal</th>
                  <th>Price</th>
                  <th class="center"><span class="glyphicon glyphicon-shopping-cart"></span></th>
                </tr>
              </thead>
              
              <!-- Table body -->
              <tbody>
                <template>
                  <tr class="meal">
                    <td>
                      <p>
                        <span class="meal-name">undefined</span>&nbsp;
                        <span class="meal-spiciness chilli">&nbsp;</span>
                      </p>
                      <p>
                        <span class="meal-rating-stars">☆☆☆☆☆</span>&nbsp;
                        (<span class="meal-rating-count">undefined</span>)&nbsp;
                        <span class="meal-tags"></span>
                      </p>
                    </td>
                    <td><span class="meal-price">undefined</span>元</td>
                    <td>
                      <span class="input-group">
                        <span class="input-group-btn">
                          <div class="btn btn-default meal-cart-minus">-</div>
                        </span>
                        <input type="text" class="form-control meal-cart-amount" value="0">
                        <span class="input-group-btn meal-cart-plus">
                          <div class="btn btn-default">+</div>
                        </span>
                      </span>
                    </td>
                  </tr>
                  
                </template>
              </tbody>
            </table>
          </div>
        </div>
                        
        <!-- Footer -->
        <?php include('shared/footer.html'); ?>
        
      </div>
    </section><!-- Main content -->
    
    <!-- Bottom Toolbar -->
    <section id="toolbar" class="form-inline pull-right">
      
      <!-- Order by -->
      <div class="form-group hidden-xs">
        <label for="meals-order-column">Order by</label>
        <select id="meals-order-column" class="form-control">
          <option value="avg_rating;DESC">Raiting</option>
          <option value="price;ASC">Price</option>
          <option value="price;DESC">Price &#9662;</option>
          <option value="spiciness;ASC">Spiciness</option>
          <option value="spiciness;DESC">Spiciness &#9662;</option>
          <option value="name;ASC">Name</option>
        </select>
      </div>
      
      <!-- Search and Checkout -->
      <div class="form-group">
        <div class="input-group">
          <input type="text" placeholder="Search meal..." id="meals-search" class="form-control">
          <span class="input-group-btn">
            <a id="meals-search-complete" class="btn btn-default">
              &nbsp;<span class="glyphicon glyphicon-search"></span>&nbsp;
            </a>
            <a class="btn btn-success btn-checkout">
              Check out&nbsp;<span class="badge"><span class="cart-value"></span>元</span>
            </a>          
          </span>
        </div>
      </div>

    </section>
    
  </div>
  
  <!-- Load Scripts at the end to optimize site loading time -->
  <script src="js/jquery-2.1.0.min.js"></script>
  <script src="bootstrap/js/bootstrap.min.js"></script>
  <script src="js/api.js"></script>
  <script src="js/main.js"></script>
  <script src="js/cart.js"></script>
  <script src="js/meals.js"></script>
</body>
</html>