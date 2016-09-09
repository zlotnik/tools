var page = require('webpage').create();
//console.log('The default user agent is ' + page.settings.userAgent);
//console.log('s' + a);
page.settings.userAgent = 'SpecialAgent';
//page.open('http://sportsbook.dafabet.com/pl', function(status) 
//page.open('http://prices.dafabet.com/', function(status) 
page.open('http://prices.dafabet.com/', function(status) 
//page.open('https://www.google.pl/', function(status) 
 {
  if (status !== 'success') {
    console.log('Unable to access network');
  } else {
    var ua = page.evaluate(function() {
      //return document.getElementById('f3-style').textContent;
      //return document.getElementById('skip-link').textContent;
      //return document.getElementById('matterhorn-username').textContent;
      //return document.getElementById('matterhorn-username');
	  
      //return document.getElementById('body-section').textContent;
      //return document.getElementById('block-matterhorn-account-account').textContent;
      //return document.getElementById('T_18X');
	  return document.head;
    });
    console.log(ua);
  }
  phantom.exit();
});

page.onError = function (msg, trace) {
    console.log(msg);
    trace.forEach(function(item) {
        console.log('  ', item.file, ':', item.line);
    });
};

page.onResourceRequested = function (request) {
    //console.log('Request ' + JSON.stringify(request, undefined, 4));
};

page.onResourceReceived = function(response) {
  //console.log('Receive ' + JSON.stringify(response, undefined, 4));
};