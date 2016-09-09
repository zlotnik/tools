var page = require('webpage').create();
//console.log('The default user agent is ' + page.settings.userAgent);
//console.log('s' + a);
page.settings.userAgent = 'Mozilla/8.0';
page.open('http://www.pinnaclesports.com/pl/odds/match/soccer/australia/australia-a-league', function(status) {
  if (status !== 'success') {
    console.log('Unable to access network');
  } else {
    var ua = page.evaluate(function() {
      return document.body.innerHTML;
    });
    console.log(ua);
  }
  phantom.exit();
});
