var page = require('webpage').create();
page.settings.resourceTimeout = 5000; 
page.settings.userAgent = 'SpecialAgent';

page.open('__URL_TO_FILL__', 
            function(status) 
            {
          
                var idx = 0;
                var tryLimit = 5;
                
                do
                {
                  idx++;
                  console.log('Unable to access network trying again ', idx , '/', tryLimit );
                  
                }
                while( status !== 'success' && idx < tryLimit)

                if (status !== 'success') 
                {
                  console.log('Unable to access network');
                } 
                else 
                {
                  var ua = page.evaluate(function() {
                    return document.getElementById('odds-all').innerHTML;
                  });
                  console.log(ua);
                }
                phantom.exit();
            }
        );
