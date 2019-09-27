
var page = require('webpage').create();
//console.log('The default user agent is ' + page.settings.userAgent);
//console.log('s' + a);
page.settings.userAgent = 'Mozilla/8.0';
var pg = page.open('https://www.marathonbet.com/pl/betting/Football/Argentina/Cup/', function(status) {
	if (status !== 'success') {
    console.log('Unable to access network');
  }
  page.includeJs("http://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js", function() {
    var ua = page.evaluate(function() {
      return $("div").click()[0]innerHTML;
	   //return document.getElementsByTagName('html')[0].innerHTML;
    });
	console.log(ua)	;
    phantom.exit()
  });
});


 
 