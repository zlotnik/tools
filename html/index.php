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
		<div class="row">
			<div class="span6">
	  			<h2><strong>The surebets <span class="highlight primary">list</span></strong></h2>
	  			<p class="lead">
				<?php include("includes/surebet_table.php");
				generateSurebetTable('/var/www/data/last_surebets');
				?>
         			</p>
          			<ul class="list list-ok strong bigger">
            				<li>100% Compatible with twitter bootstrap</li>
            				<li>Valid HTML5 code and well structured</li>
          				<li>Really updatable and easy to customize</li>
          			</ul>

        </div>
    </div>

  </section>


<?php include("includes/footer.php");?>

</body>
</html>
