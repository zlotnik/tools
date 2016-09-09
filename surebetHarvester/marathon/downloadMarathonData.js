
var page = require('webpage').create();
//console.log('The default user agent is ' + page.settings.userAgent);
//console.log('s' + a);
page.settings.userAgent = 'Mozilla/8.0';
page.open('https://www.marathonbet.com/pl/betting/Football/Argentina/Cup/', function(status) {
  if (status !== 'success') {
    console.log('Unable to access network');
  } else {
    var ua = page.evaluate(function() {
		
		
    });
    console.log(ua);
  }
  phantom.exit();
});



 
 