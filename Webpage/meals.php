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

  <title>my-burger.com | Meals</title>

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
  
  <div id="main-content">
    
    <!-- meals list -->
    <section id="splash-screen">
      <div class="splash-container">
        <h1>Meals of <span class="restaurant-name">a Restaurant</span></h1>
        <div class="splash-container-scroller">
          <div id="restaurant-info">
            <img src="imgs/icon.png" class="pull-left" alt>
            <h4 class="restaurant-name">A Restaurant</h4>
            <p><span class="restaurant-rating-stars">☆☆☆☆☆</span>&nbsp;(<span class="restaurant-rating-count">395</span>)</p>
            <p class="restaurant-description">A super cool restaurant close to you. Choose a cool meal to be cool.</p>
          </div>
          <div id="meals-list">
            <table class="table table-hover">
              <thead>
                <tr>
                  <th>Meal</th>
                  <th>Rating</th>
                  <th>Price</th>
                  <th>Order</th>
                  <th><span class="glyphicon glyphicon-shopping-cart"></span></th>
                </tr>
              </thead>
              <tbody>
                <?php for($i=0; $i<20; $i++) {?>
                  <tr>
                    <td class="meal-name">A cool meal</td>
                    <td class="meal-rating">
                      <span class="meal-rating-stars">☆☆☆☆☆ </span>
                      (<span class="meal-rating-count">395</span>)
                    </td>
                    <td class="meal-price">32€</td>
                    <td class="meal-options">
                      <div class="btn-group">
                        <button class="btn btn-default"><span class="glyphicon glyphicon-minus"></span></button>
                        <button class="btn btn-default"><span class="glyphicon glyphicon-plus"></span></button>
                      </div>
                    </td>
                    <td class="meal-amount">3</td>
                  </tr>
                <?php } ?>
              </tbody>
            </table>
          </div>
        </div>
      </div>
      
      <!-- Footer -->
      <?php include('shared/footer.html'); ?>
      
          
      <!-- Overlay to display meal informations -->
      <section id="meal-info-overlay" class="overlay overlay-modal">
        <div class="overlay-close-button menu-toggle menu-toggle-open">
          <div class="bar"></div>
          <div class="bar"></div>
          <div class="bar"></div>
        </div>
        
        <h4 class="meal-name">A cool meal</h4>
        
        <div class="banner">
          <img src="imgs/splash-01.jpg" alt>        
        </div>
      </section>
      
    </section>
    
  </div>
  
  <!-- Load Scripts at the end to optimize site loading time -->
  <script src="js/jquery-2.1.0.min.js"></script>
  <script src="bootstrap/js/bootstrap.min.js"></script>
  <script src="js/main.js"></script>
  <script src="js/meals.js"></script>
</body>
</html>