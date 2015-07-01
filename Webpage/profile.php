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
  
    <h1><span class="user-nick">undefined</span>'s Profile</h1>
    
    <div class="row">
      
      <div class="col-lg-3 col-md-4 col-sm-4 cl-xs-12">
        <!-- Ongoing deliveries -->
        <section class="panel panel-default" id="order-list-ongoing">
          <div class="panel-heading noselect">
            <h3 class="panel-title"><span class="glyphicon glyphicon-send"></span> Ongoing Deliveries</h3>
          </div>
          <ul class="list-group">
            <template>
              <li class="list-group-item">
                <p class="title">undefined</p>
                <p class="detail">undefined</p>
              </li>
            </template>
            <li class="list-group-item">
                <p class="title">No ongoing deliveries</p>
            </li>
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
            <dl>
              <dt>First Name</dt>
              <dd class="user-first-name">undefined</dd>
              <dt>Sur Name</dt>
              <dd class="user-sure-name">undefined</dd>
              <dt>Nick Name</dt>
              <dd class="user-nick">undefined</dd>
              <dt>Phone</dt>
              <dd class="user-phone">undefined</dd>
              <dt>Email</dt>
              <dd class="user-email">undefined</dd>
            </dl>
          </div>
        </section>

        <!-- Ratable meals -->
        <section class="panel panel-default panel-collapse panel-collapsed" id="meal-list-ratable">
          <div class="panel-heading noselect">
            <span class="pull-right collapse-trigger glyphicon"></span>
            <h3 class="panel-title"><span class="glyphicon glyphicon-star"></span> Unrated Meals</h3>
          </div>
          <ul class="list-group">
            <template>
              <li class="list-group-item meal">
                <p class="title">undefined</p>
                <p class="detail">undefined</p>
              </li>
            </template>
            <li class="list-group-item meal">
              <p class="title">No ratable meals</p>
            </li>
          </ul>
        </section>

        <!-- Old orders -->
        <section class="panel panel-default panel-collapse panel-collapsed" id="order-list-history">
          <div class="panel-heading noselect">
            <span class="pull-right collapse-trigger glyphicon"></span>
            <h3 class="panel-title"><span class="glyphicon glyphicon-time"></span> Delivery History</h3>
          </div>
          <ul class="list-group">
            <template>
              <li class="list-group-item">
                <p class="title">undefined</p>
                <p class="detail">undefined</p>
              </li>
            </template>
            <li class="list-group-item">
                <p class="title">No completed deliveries</p>
            </li>
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
            <h4 class="modal-title">Rate <span class="meal-name">undefined</span></h4>
          </div>
          <div class="modal-body">
            
            <div class="modal-body-loading">
              <img src="../imgs/loader.gif" alt="Loading...">
            </div>
            
            <div class="modal-body-content">     
              <div class="form-group">
                <label>Rating</label>
                <div class="rating-input" value="0">
                  <span rating="1">★</span>
                  <span rating="2">☆</span>
                  <span rating="3">☆</span>
                  <span rating="4">☆</span>
                  <span rating="5">☆</span>
                </div>
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
    <div id="delivery-modal" class="modal fade">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
            <h4 class="modal-title">Order #<span class="delivery-id">undefined</span></h4>
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
                  <tr><td>Restaurant</td><td class="delivery-restaurant">undefined</td></tr>
                  <tr><td>Shipping costs</td><td><span class="delivery-shipping-cost">undefined</span>元</td></tr>
                  <tr><td>Order value</td><td><span class="delivery-value">undefined</span>元</td></tr>
                  <tr><td>Contact phone</td><td class="delivery-phone">undefined</td></tr>
                  <tr>
                    <td>Address</td>
                    <td>
                      <address>
                        <span class="delivery-name">undefined</span><br>
                        <span class="delivery-street">undefined</span><br>
                        <span class="delivery-postal-code">undefined</span>&nbsp;
                        <span class="delivery-city">undefined</span><br>
                        <span class="delivery-country">undefined</span>
                      </address>
                    </td>
                  </tr>
                </tbody>
              </table>
              
              <h4>Items</h4>
              <table id="delivery-meal-list" class="table table-striped table-bordered">
                <thead>
                  <tr><th>#</th><th>Name</th><th>Price</th><th>Amount</th></tr>
                </thead>
                <tbody>
                  <template>
                    <tr class="meal">
                      <td class="meal-id">undefined</td>
                      <td class="meal-name">undefined</td>
                      <td><span class="meal-price">undefined</span>元</td>
                      <td class="meal-amount">undefined</td>
                    </tr>
                  </template>
                </tbody>
              </table>
              
              <h4>Log</h4>
              <table id="delivery-state-list" class="table table-striped table-bordered">
                <thead>
                  <tr><th>Position</th><th>Value</th></tr>
                </thead>
                <tbody>
                  <template>
                    <tr class="state">
                      <td class="state-date">undefined</td>
                      <td class="state-state">undefined</td>
                    </tr>
                  </template>
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