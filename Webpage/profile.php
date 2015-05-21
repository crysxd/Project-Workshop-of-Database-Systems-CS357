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

  <title>my-burger.com | Informations</title>

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
  <link href="css/profile.css" rel="stylesheet">
</head>
<body>
  
  <!-- Menus and overlays -->
  <?php  include('shared/header.html'); ?>
  
  <div id="main-content">
  
    <h1><span class="user-name">Test</span>'s Profile</h1>
    
    <!-- User informations -->
    <section class="panel panel-default panel-collapse">
      <div class="panel-heading noselect">
        <span class="pull-right collapse-trigger glyphicon"></span>
        <h3 class="panel-title"><span class="glyphicon glyphicon-user"></span> User Information</h3>
      </div>
      <div class="panel-body">
      </div>
    </section>

    <!-- Ratable meals -->
    <section class="panel panel-default panel-collapse panel-collapsed">
      <div class="panel-heading noselect">
        <span class="pull-right collapse-trigger glyphicon"></span>
        <h3 class="panel-title"><span class="glyphicon glyphicon-star"></span> Unrated Meals</h3>
      </div>
      <div class="panel-body">
        
      </div>
    </section>
    
    <!-- Old orders -->
    <section class="panel panel-default panel-collapse panel-collapsed">
      <div class="panel-heading noselect">
        <span class="pull-right collapse-trigger glyphicon"></span>
        <h3 class="panel-title"><span class="glyphicon glyphicon-time"></span> Delivery History</h3>
      </div>
      <div class="panel-body">
        
      </div>
    </section>
    
    <!-- Footer -->
    <?php include('shared/footer.html'); ?>
    
  </div>
  
  <!-- Load Scripts at the end to optimize site loading time -->
  <script src="js/jquery-2.1.0.min.js"></script>
  <script src="bootstrap/js/bootstrap.min.js"></script>
  <script src="js/main.js"></script>
  <script src="js/profile.js"></script>
</body>
</html>