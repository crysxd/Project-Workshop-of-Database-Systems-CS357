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

  <title>my-meal.com | Informations</title>

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
    
    <div class="row">
      
      <div class="col-lg-3 col-md-4 col-sm-4 cl-xs-12">
        <!-- Ongoing deliveries -->
        <section class="panel panel-default" id="order-list-ongoing">
          <div class="panel-heading noselect">
            <h3 class="panel-title"><span class="glyphicon glyphicon-send"></span> Ongoing Deliveries</h3>
          </div>
          <ul class="list-group">
            <?php for($i=0; $i<4; $i++) { ?>
              <li class="list-group-item order">
                <p class="title">A cool Meal</p>
                <p class="detail">12:04: Processing</p>
              </li>
            <?php } ?>
          </ul>
        </section>
      </div>
    
      <div class="col-lg-9 col-md-8 col-sm-8 cl-xs-12">
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
        <section class="panel panel-default panel-collapse panel-collapsed" id="meal-list-ratable">
          <div class="panel-heading noselect">
            <span class="pull-right collapse-trigger glyphicon"></span>
            <h3 class="panel-title"><span class="glyphicon glyphicon-star"></span> Unrated Meals</h3>
          </div>
          <ul class="list-group">
            <?php for($i=0; $i<4; $i++) { ?>
              <li class="list-group-item meal">
                <p class="title">A cool Meal</p>
                <p class="detail">A cool Restaurant - 23.5.3334</p>
              </li>
            <?php } ?>
          </ul>
        </section>

        <!-- Old orders -->
        <section class="panel panel-default panel-collapse panel-collapsed" id="order-list-history">
          <div class="panel-heading noselect">
            <span class="pull-right collapse-trigger glyphicon"></span>
            <h3 class="panel-title"><span class="glyphicon glyphicon-time"></span> Delivery History</h3>
          </div>
          <ul class="list-group">
            <?php for($i=0; $i<4; $i++) { ?>
              <li class="list-group-item order">
                <p class="title">A cool Restaurant</p>
                <p class="detail">23.5.3334</p>
              </li>
            <?php } ?>
          </ul>
        </section>
      </div>
      
    </div><!-- row -->

    <!-- Logout button -->
    <button id="btn-logout" class="btn btn-danger btn-block">Log out</button>
    
    <!-- Footer -->
    <?php include('shared/footer.html'); ?>
    
    <!-- Dialog for rating meals -->
     <div id="rate-modal" class="modal fade">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
            <h4 class="modal-title">Rate <span class="meal-name"> A cool meal</span></h4>
          </div>
          <div class="modal-body">
            
            <div class="modal-body-loading">
              <img src="../imgs/loader.gif" alt="Loading...">
            </div>
            
            <div class="modal-body-content">     
              <div class="form-group">
                <label>Rating</label>
                <p class="form-contro">★★★★★</p>
              </div>
              <div class="form-group">
                <label>Comment</label>
                <textarea class="form-control"></textarea>
              </div>
              <div class="modal-footer">
                <div id="meal-modal-cancel" class="btn btn-default" data-dismiss="modal">Cancel</div>
                <div id="meal-modal-save" class="btn btn-primary">Save</div>
              </div>
            </div>
            
          </div>
        </div>
      </div>
    </div><!-- rate dialog-->
    
    <!-- Dialog for displaying deliveries -->
    <div id="order-modal" class="modal fade">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
            <h4 class="modal-title">Order <span class="order-id">324342</span></h4>
          </div>
          <div class="modal-body">
            
            <div class="modal-body-loading">
              <img src="../imgs/loader.gif" alt="Loading...">
            </div>
            
            <div class="modal-body-content">            
              <h4>Information</h4>
              <table class="table table-striped table-bordered">
                <thead>
                  <tr><th>Position</th><th>Value</th></tr>
                </thead>
                <tbody>
                  <tr><td>Restaurant</td><td>A cool Restaurant</td></tr>
                  <tr><td>Shipping costs</td><td>23</td></tr>
                  <tr><td>Order value</td><td>324</td></tr>
                  <tr><td>Contact phone</td><td>130 2342 2342</td></tr>
                  <tr>
                    <td>Address</td>
                    <td>
                      <address>
                        Christian Würthner<br>
                        800 Dongchuan Lu<br>
                        Minhang Qu<br>
                        20123 Shanghai Shi
                      </address>
                    </td>
                  </tr>
                </tbody>
              </table>
              
              <h4>Items</h4>
              <table class="table table-striped table-bordered">
                <thead>
                  <tr><th>#</th><th>Name</th><th>Price</th><th>Amount</th></tr>
                </thead>
                <tbody>
                  <tr><td>32423</td><td>A cool meal</td><td>34</td><td>1</td></tr>
                </tbody>
              </table>
              
              <h4>Log</h4>
              <table class="table table-striped table-bordered">
                <thead>
                  <tr><th>Position</th><th>Value</th></tr>
                </thead>
                <tbody>
                  <tr><td>2015-05-29 12:50</td><td>Pending</td></tr>
                  <tr><td>2015-05-29 13:03</td><td>Processing</td></tr>
                  <tr><td>2015-05-29 13:12</td><td>On Road</td></tr>
                  <tr><td>2015-05-29 13:21</td><td>Delivered</td></tr>
                </tbody>
              </table>
            </div>
            
          </div>
        </div>
      </div>
    </div><!-- order dialog-->
    
  </div>
  
  <!-- Load Scripts at the end to optimize site loading time -->
  <script src="js/jquery-2.1.0.min.js"></script>
  <script src="bootstrap/js/bootstrap.min.js"></script>
  <script src="js/api.js"></script>
  <script src="js/main.js"></script>
  <script src="js/profile.js"></script>
</body>
</html>