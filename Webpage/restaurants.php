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

  <title>my-burger.com | Restaurants</title>

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
  <link href="css/restaurants.css" rel="stylesheet">
</head>
<body>
  
  <!-- Menus and overlays -->
  <?php  include('shared/header.html'); ?>
  
  <div id="main-content">
    
    <!-- Restaurants list -->
    <section id="splash-screen">
      <div class="splash-container">
        <h1>Restaurants close to you</h1>
        <div id="restaurants" class="row">
          <?php for($i=0; $i<11; $i++) { ?>
            <a class="item col-lg-3 col-md-4 col-sm-6 col-xs-12">
              <div class="row">
                <div class="col-xs-5 data">
                  <img src="imgs/icon.png" alt>
                </div>
                <div class="col-xs-7 data">
                  <h4 class="restaurant-name">El Davido</h4>
                  <p><span class="rating-stars">☆☆☆☆☆</span>&nbsp;<span class="rating-count">395</span></p>
                  <p>From: <span class="min-order-value">30¥</span></p>
                  <p>Shipping: <span class="shipping-costs">Free</span></p>
                  <p>ETA: <span class="eta">30min</span></p>
                </div>
              </div>
            </a>
          <?php } ?>
          <a class="load-more-item col-lg-3 col-md-4 col-sm-6 col-xs-12">
            <div class="data">
              <div class="reload-icon"></div>
              <h4>Load more</h4> 
            </div>
          </a>
        </div>
      </div>
    <!-- Footer -->
    <?php include('shared/footer.html'); ?>
    </section>
    
  </div>
  
  <!-- Load Scripts at the end to optimize site loading time -->
  <script src="js/jquery-2.1.0.min.js"></script>
  <script src="bootstrap/js/bootstrap.min.js"></script>
  <script src="js/main.js"></script>
  <script src="js/restaurants.js"></script>
</body>
</html>