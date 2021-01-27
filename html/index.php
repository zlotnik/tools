<?php include("includes/a_config.php");?>
<!DOCTYPE html>
<html>
<head>
	<?php include("includes/head-tag-contents.php");?>
</head>
<body>
	<header>
		<?php include("includes/navigation.php");?>
	</header>
	<section id="intro">
	<div class="container">
                
	        <div >
                        <h3>Surebet (miraclebets, sports arbitrage, betting arbitrage) - in bookmakers bets a situation when stakes for a bet are high enough to guarantee profit regardless of the result of the sport event.</h3>
	  		
                </div>
		<div class="row">
			<div class="span6">
	  			<h2><strong>The surebets <span class="highlight primary">list</span></strong></h2>
	  			<p class="lead">
				<?php include("includes/surebet_table.php");
				generateSurebetTable('/var/www/data/last_surebets');
				?>
         			</p>
          			<ul class="list list-ok strong bigger">
            				<li>Scanning all soccer bets around the world</li>
            				<li>1X2 bets</li>
          				<li>Free access</li>
          				<li>No adds</li>

          			</ul>

        </div>
    </div>

  </section>


<?php include("includes/footer.php");?>

</body>
</html>
