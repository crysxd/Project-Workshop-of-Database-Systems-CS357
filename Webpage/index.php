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

  <title>my-burger.com | Home</title>

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
  <link href="css/index.css" rel="stylesheet">
</head>
<body>
  
  <!-- Menus and overlays -->
  <?php  include('shared/header.html'); ?>
  
  <!-- Additional Overlays -->
  <div id="address-picker" class="overlay">
    <div class="overlay-content">
      <div class="scroll">
        <h4>Select the Address</h4>
        <div id="address-list" class="narrow">
          <template>
            <address class="address btn btn-default btn-block">
              <p class="road">Undefined</p>
              <p class="suburb"></p>
              <p><span class="postcode"></span> <span class="city"></span></p>
              <p class="county"></p>
              <p class="state"></p>
              <p class="country"></p>
            </address>
          </template>
          <button class="btn btn-danger btn-cancel btn-block">Cancel</button>
        </div>
      </div>
    </div>
  </div>
  
  <div id="main-content">
    <!-- Splash screen and search bar -->
    <section id="splash-screen">
      <div class="splash-center">
        <div class="input-group search-box">
          <input type="text" class="form-control" placeholder="Street, Number, City..." value="Dongchuan Road 800 Shanghai">
          <span class="input-group-btn">
            <button class="btn btn-default" type="button"></button>
          </span>
        </div>
      </div>
      <div id="splash-footer">
        <p>SCROLL DOWN</p>
        <div id="arrow"></div>
      </div>
    </section>

    <!-- About us and other text -->
    <section id="how-to">
      <div class="row equalheights">
        <div class="col-xs-12"><h2><center>Order your meal online in a few steps!</center></h2></div>
        <div class="col-md-3 col-sm-6 col-xs-12">
          <div class="how-to-column">
            <div class="circle-number">1</div>
            <h4>Select your favorite food online</h4>
            <p>Search on my-burger.com for your favorite restaurant close to you and 
              select your meals and drinks.</p>
          </div>
        </div>
        <div class="col-md-3 col-sm-6 col-xs-12">
          <div class="how-to-column">
            <div class="circle-number">2</div>
            <h4>Login using your mobile number</h4>
            <p>Login simply using your mobile number and your name. 
              No online payment information are required as you pay on arrival.</p>
          </div>
        </div>
        <div class="col-md-3 col-sm-6 col-xs-12">
          <div class="how-to-column">
            <div class="circle-number">3</div>
            <h4>Wait for the courier to deliver your food</h4>
            <p>After  you placed your order you will be informed as soon as the 
              courier is on his way to you including his ETA.</p>
          </div>
        </div>
        <div class="col-md-3 col-sm-6 col-xs-12">
          <div class="how-to-column">
            <div class="circle-number">4</div>
            <h4>Pay on arrival and enjoy your meal!</h4>
            <p>The courier will call you as soon as he is on your address, 
              receive your food and pay him.</p>
            <p>Enjoy your meal!</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <?php include('shared/footer.html'); ?>
    
  </div>
  
  <!-- Load Scripts at the end to optimize site loading time -->
  <script src="js/jquery-2.1.0.min.js"></script>
  <script src="bootstrap/js/bootstrap.min.js"></script>
  <script src="js/main.js"></script>
  <script src="js/api.js"></script>
  <script src="js/index.js"></script>
</body>
</html>