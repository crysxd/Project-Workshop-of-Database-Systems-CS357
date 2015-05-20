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

  <title>my-burger.com | Complete your order</title>

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
  
  <!-- Modal Dialog to change the delivery address -->
  <div class="modal fade" id="change-address-modal">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
          <h4 class="modal-title">Change delivery address</h4>
        </div>
        <div class="modal-body">
          <form class="form-horizontal">
            <div class="form-group">
              <label for="address-name" class="col-sm-4 control-label">Name</label>
              <div class="col-sm-8">
                <input type="text" class="form-control" id="address-name" placeholder="Enter your name" required="true">
              </div>
            </div>
            <div class="form-group">
              <label for="address-street" class="col-sm-4 control-label">Street and Number</label>
              <div class="col-sm-8">
                <input type="text" class="form-control" id="address-street" placeholder="Enter your street and number">
              </div>
            </div>
            <div class="form-group">
              <label for="address-aditional" class="col-sm-4 control-label">Additional</label>
              <div class="col-sm-8">
                <input type="text" class="form-control" id="address-aditional" placeholder="Enter appartment/building">
              </div>
            </div>
            <div class="form-group">
              <label for="address-city" class="col-sm-4 control-label">City</label>
              <div class="col-sm-8">
                <input type="text" class="form-control" id="address-city" placeholder="Enter your city">
              </div>
            </div>
            <div class="form-group">
              <label for="address-postal-code" class="col-sm-4 control-label">Postal Code</label>
              <div class="col-sm-8">
                <input type="text" class="form-control" id="address-postal-code" placeholder="Enter your postal code">
              </div>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          <button type="button" class="btn btn-success" id="btn-change-address">Save changes</button>
        </div>
      </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
  </div><!-- /.modal -->
  
  <div id="main-content">
    <h1>Your Order</h1>
    <div class="row">
      <div class="col-sm-12 col-md-4 col-lg-2">
        
        <!-- Adress -->
        <section class="panel panel-default">
          <div class="panel-heading">
            <h3 class="panel-title"><span class="glyphicon glyphicon-home"></span> Delivery Address</h3>
          </div>
          <div class="panel-body">
            <address>
              <strong>Mike Miller</strong><br>
              500 Dongchuan Rd.<br>
              App. 402<br>
              Shanghai, 94107<br>
            </address>
            <a data-toggle="modal" data-target="#change-address-modal">
              Change address
            </a>
          </div>
        </section>

        <!-- Information -->
        <section class="panel panel-default">
          <div class="panel-heading">
            <h3 class="panel-title"><span class="glyphicon glyphicon-info-sign"></span> General Information</h3>
          </div>
          <div class="panel-body">

          </div>
        </section>
      </div>

      <div class="col-sm-12 col-md-8 col-lg-10">
        <!-- Shopping cart -->
        <section class="panel panel-default">
          <div class="panel-heading">
            <h3 class="panel-title"><span class="glyphicon glyphicon-shopping-cart"></span> Shopping Cart</h3>
          </div>
          <table class="table table-responsive table-order">
            <thead>
              <tr><th>Meal</th><th>Amount</th><th></th></tr>
            </thead>
            <tbody>
              <?php for($i=0; $i<20; $i++) { ?>
                <tr class="item">
                  <td class="item-name">
                    A cool meal
                  </td>
                  <td>
                    <div class="input-group amount-input">
                      <span class="input-group-btn">
                        <button class="btn btn-default" type="button">-</button>
                      </span>
                      <input type="text" class="form-control item-amount" value="0">
                      <span class="input-group-btn">
                        <button class="btn btn-default" type="button">+</button>
                      </span>
                    </div>
                  </td>
                  <td>
                    <span class="item-costs">3</span>&nbsp;元
                  </td>
                </tr>
              <?php } ?>
                <tr class="shipping-costs-row">
                  <td>Shipping costs</td>
                  <td></td>
                  <td><span class="shipping-costs">3</span>&nbsp;元</td>
                </tr>
               <tr class="order-value-row">
                  <td>Order value</td>
                  <td></td>
                  <td><span class="order-value">4</span>&nbsp;元</td>
                </tr>
            </tbody>
          </table>
        </section>

        <button class="btn btn-block btn-success">Order now (ETA: <span class="eta">42</span> minutes)</button>
      </div>
    </div>
    <!-- Footer -->
    <?php include('shared/footer.html'); ?>
    
  </div>
  
  <!-- Load Scripts at the end to optimize site loading time -->
  <script src="js/jquery-2.1.0.min.js"></script>
  <script src="bootstrap/js/bootstrap.min.js"></script>
  <script src="js/main.js"></script>
  <script src="js/order.js"></script>
</body>
</html>