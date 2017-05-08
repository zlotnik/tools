var page = require('webpage').create();
//console.log('The default user agent is ' + page.settings.userAgent);
//console.log('s' + a);
page.settings.userAgent = 'SpecialAgent';
page.open('http://www.betexplorer.com/soccer/Poland/ekstraklasa/legia-termalica-b-b/d47sRXQr/', function(status) {
  if (status !== 'success') {
    console.log('Unable to access network');
  } else {
    var ua = page.evaluate(function() {
      return document.getElementById('odds-all').textContent;
    });
    console.log(ua);
  }
  phantom.exit();
});
