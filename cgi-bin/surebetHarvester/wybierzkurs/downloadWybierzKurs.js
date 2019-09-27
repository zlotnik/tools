var page=require('webpage').create();
page.onLoadFinished=function(status) {
    if(status=='success') {
        console.log(page.plainText);
    }
}
page.load('http://stackoverflow.com');