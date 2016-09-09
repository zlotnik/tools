var page = require('webpage').create();
page.onError = function(msg, trace) {
  //prevent js errors from showing in page.content
  return;
};
page.open('http://www.interia.pl', function () {
    console.log(page.content); //page source
    phantom.exit();
});