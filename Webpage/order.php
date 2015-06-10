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

  <title>my-meal.com | Check out</title>

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
  <link href="css/order.css" rel="stylesheet">
</head>
<body>
  
  <!-- Menus and overlays -->
  <?php  include('shared/header.html'); ?>
  
  <div id="main-content">
    <h1>Your Order</h1>
    <div class="row">
      <div class="col-sm-4 col-md-4 col-lg-3">
        
        <!-- Adress -->
        <section class="panel panel-default delivery-address">
          <div class="panel-heading">
            <h3 class="panel-title"><span class="glyphicon glyphicon-home"></span> Delivery Address</h3>
          </div>
          <div class="panel-body">
            <address>
              <strong><span class="address-street">undefined</span></strong><br>
              <span class="address-postal-code">undefined</span>
              <span class="address-city">undefined</span><br>
              <span class="address-country">undefined</span><br>
            </address>
          </div>
        </section>

        <!-- Information -->
        <section class="panel panel-default restaurant-infromation">
          <div class="panel-heading">
            <h3 class="panel-title"><span class="glyphicon glyphicon-info-sign"></span> Restaurant</h3>
          </div>
          <div class="panel-body">
            <strong><span class="restaurant-name">undefined</span></strong><br>
            Phone: <span class="restaurant-phone">undefined</span><br>
          </div>
        </section>
        
      </div>

      <div class="col-sm-8 col-md-8 col-lg-9">
        <!-- Shopping cart -->
        <section class="panel panel-default">
          <div class="panel-heading">
            <h3 class="panel-title"><span class="glyphicon glyphicon-shopping-cart"></span> Shopping Cart</h3>
          </div>
          <table class="table table-responsive table-order">
            <thead>
              <tr><th>Meal</th><th>Price</th><th>Amount</th><th>Total Price</th></tr>
            </thead>
            <tbody>
              <template>
                <tr class="item">
                  <td class="item-name">undefined</td>
                  <td><span class="item-price">undefined</span>&nbsp;元</td>
                  <td class="item-amount">undefined</td>
                  <td><span class="item-total-price">undefined</span>&nbsp;元</td>
                </tr>
              </template>
              <tr class="shipping-costs-row">
                <td>Shipping costs</td>
                <td></td>
                <td></td>
                <td><span class="restaurant-shipping-cost">undefined</span>&nbsp;元</td>
              </tr>
              <tr class="order-value-row">
                <td>Order value</td>
                <td></td>
                <td></td>
                <td><span class="order-value">undefined</span>&nbsp;元</td>
              </tr>
            </tbody>
          </table>
        </section>

        <button class="btn btn-block btn-success btn-complete-order">
          Order now (ETA: <span class="restaurant-eta">undefined</span> minutes)
        </button>
      </div>
    </div>
    <!-- Footer -->
    <?php include('shared/footer.html'); ?>
    
  </div>
  
  
  <!-- success overlay -->
  <nav id="success-overlay" class="overlay">
    <div class="overlay-content">
      <div class="narrow">
        <h4><span class="title">Success</span></h4>
        <p class="message">Your order was successfully placed</p>
        <a class="btn btn-default btn-block" href="profile.php">OK</a>
      </div>
    </div>
  </nav>

  
  <!-- Load Scripts at the end to optimize site loading time -->
  <script src="js/jquery-2.1.0.min.js"></script>
  <script src="bootstrap/js/bootstrap.min.js"></script>
  <script src="js/api.js"></script>
  <script src="js/main.js"></script>
  <script src="js/cart.js"></script>
  <script src="js/order.js"></script>
</body>
</html>