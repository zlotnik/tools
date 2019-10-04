
(function () {
    var frosmo = window.frosmo = window.frosmo || {},
        _frosmo = window._frosmo = window._frosmo || {},
        _config = {"thirdParty":true,"anchorEnabled":0,"segments":[{"name":"sgmt_7845","timelimit":30,"autoexit":true,"enter":["or",["matchDevice","desktop"]],"leave":null,"group":1028},{"name":"sgmt_7846","timelimit":30,"autoexit":true,"enter":["or",["matchDevice","android"],["matchDevice","ios"],["matchDevice","windowsphone"],["matchDevice","othermobile"]],"leave":null,"group":1028},{"name":"sgmt_7847","timelimit":30,"autoexit":true,"enter":["or",["matchDevice","androidtablet"],["matchDevice","ipad"],["matchDevice","windowstablet"],["matchDevice","othertablet"]],"leave":null,"group":1028},{"name":"sgmt_7848","timelimit":7,"autoexit":true,"enter":["gte",["siteVisitCount"],2],"leave":null,"group":1154},{"name":"sgmt_7849","timelimit":30,"autoexit":true,"enter":["gte",["siteVisitCount"],2],"leave":null,"group":1154},{"name":"sgmt_7850","timelimit":30,"autoexit":true,"enter":["newUser"],"leave":["or",["inSegment","sgmt_7848"],["inSegment","sgmt_7849"]],"group":1154},{"name":"sgmt_8760","timelimit":60,"autoexit":true,"enter":["gte",["sum",["pathVisits","94d3b08fd4a85042"]],2],"leave":null,"group":1155},{"name":"sgmt_8761","timelimit":60,"autoexit":true,"enter":["gte",["sum",["pathVisits","5bb6b6324547aa87"]],2],"leave":null,"group":1175},{"name":"sgmt_8768","timelimit":60,"autoexit":true,"enter":["gte",["sum",["pathVisits","94d3b08fd4a85042"]],2],"leave":null,"group":1175},{"name":"sgmt_8769","timelimit":60,"autoexit":true,"enter":["gte",["sum",["pathVisits","94d3b08fd4a85042"]],2],"leave":null,"group":1175},{"name":"sgmt_8770","timelimit":60,"autoexit":true,"enter":["gte",["sum",["pathVisits","94d3b08fd4a85042"]],2],"leave":null,"group":1175},{"name":"sgmt_8771","timelimit":60,"autoexit":true,"enter":["gte",["sum",["pathVisits","3cce8a833b1c8db8"]],2],"leave":null,"group":1155},{"name":"sgmt_8772","timelimit":60,"autoexit":true,"enter":["gte",["sum",["pathVisits","770c6c1a7c5e4d32"]],2],"leave":null,"group":1155},{"name":"sgmt_8773","timelimit":60,"autoexit":true,"enter":["gte",["sum",["pathVisits","190c1d3d946d446d"]],2],"leave":null,"group":1155},{"name":"sgmt_8774","timelimit":60,"autoexit":true,"enter":["gte",["sum",["pathVisits","b4819b597c5bf2f8"]],2],"leave":null,"group":1155},{"name":"sgmt_8775","timelimit":60,"autoexit":true,"enter":["gte",["sum",["pathVisits","6fd27a1bbd4ce101"]],2],"leave":null,"group":1155},{"name":"sgmt_8776","timelimit":60,"autoexit":true,"enter":["gte",["sum",["pathVisits","ee1fd1a2f91486bd"]],2],"leave":null,"group":1183},{"name":"sgmt_8798","timelimit":60,"autoexit":true,"enter":["gte",["sum",["pathVisits","ee1fd1a2f91486bd"]],2],"leave":null,"group":1155},{"name":"sgmt_8799","timelimit":60,"autoexit":true,"enter":["gte",["sum",["pathVisits","ee1fd1a2f91486bd"]],2],"leave":null,"group":1183},{"name":"sgmt_8800","timelimit":60,"autoexit":true,"enter":["gte",["sum",["pathVisits","ee1fd1a2f91486bd"]],2],"leave":null,"group":1183},{"name":"sgmt_10335","timelimit":365,"autoexit":false,"enter":["customAction","rzefiq.5v","1"],"leave":null},{"name":"sgmt_10336","timelimit":365,"autoexit":false,"enter":["newUser"],"leave":["enterSegment","sgmt_10335"]},{"name":"sgmt_10342","timelimit":1,"autoexit":true,"enter":["gte",["sum",["pathVisits","49a66228a3b29e94"]],1],"leave":null,"group":1524},{"name":"sgmt_10433","timelimit":30,"autoexit":true,"enter":["customAction","i54l54.6h","1"],"leave":null,"group":1512},{"name":"sgmt_10509","timelimit":30,"autoexit":true,"enter":["gte",["sum",["pathVisits","fd3db29cfa7072a3"]],2],"leave":null,"group":1524},{"name":"sgmt_18232","timelimit":30,"autoexit":true,"enter":["or",["customAction","cz39a8.pu","1"],["customAction","mcn8h1.gp","1"]],"leave":null,"group":1512},{"name":"sgmt_19839","timelimit":30,"autoexit":true,"enter":["or",["gte",["sum",["pathVisits","26673c26cd19c7fa"]],1],["gte",["sum",["pathVisits","0a82c2c07c226f61"]],1],["gte",["sum",["pathVisits","f13c7b8d62ccf343"]],1],["gte",["sum",["pathVisits","681bf971150eabaf"]],1],["gte",["sum",["pathVisits","94cb17d0d613224a"]],1],["gte",["sum",["pathVisits","e07511a3b7731e2b"]],1]],"leave":null},{"name":"sgmt_29491","timelimit":30,"autoexit":true,"enter":["or",["matchRefererUrl","matchBegins"," http:\/\/en.dafaesports.com\/"],["matchReferer","en.dafaesports.com"]],"leave":null},{"name":"sgmt_29667","timelimit":365,"autoexit":true,"enter":["or",["gte",["sum",["pathVisits","f39b801edc189dd7"]],1],["gte",["sum",["pathVisits","0a82c2c07c226f61"]],1],["gte",["sum",["pathVisits","94cb17d0d613224a"]],1],["gte",["sum",["pathVisits","e07511a3b7731e2b"]],1]],"leave":null},{"name":"sgmt_33082","timelimit":14,"autoexit":true,"enter":["customAction","6l6yxl.j7","1"],"leave":null,"group":4255},{"name":"sgmt_33083","timelimit":14,"autoexit":true,"enter":["customAction","qp33le.qy","1"],"leave":null,"group":4255},{"name":"sgmt_33084","timelimit":14,"autoexit":true,"enter":["customAction","3g5w1h.2u","1"],"leave":null,"group":4255},{"name":"sgmt_33085","timelimit":14,"autoexit":true,"enter":["customAction","5sxyla.px","1"],"leave":null,"group":4255},{"name":"sgmt_33086","timelimit":14,"autoexit":true,"enter":["customAction","3catvw.ew","1"],"leave":null,"group":4255},{"name":"sgmt_33087","timelimit":14,"autoexit":true,"enter":["customAction","6qe50.8qv","1"],"leave":null,"group":4255},{"name":"sgmt_33088","timelimit":14,"autoexit":true,"enter":["customAction","fpej53.gl","1"],"leave":null,"group":4255},{"name":"sgmt_33089","timelimit":14,"autoexit":true,"enter":["customAction","9huyrv.eu","1"],"leave":null,"group":4255},{"name":"sgmt_33090","timelimit":14,"autoexit":true,"enter":["customAction","zmcfnn.av","1"],"leave":null,"group":4255},{"name":"sgmt_33091","timelimit":14,"autoexit":true,"enter":["customAction","se49ga.ya","1"],"leave":null,"group":4255},{"name":"sgmt_33096","timelimit":14,"autoexit":true,"enter":["customAction","d4iri.9hs","1"],"leave":null,"group":4255},{"name":"sgmt_33097","timelimit":14,"autoexit":true,"enter":["customAction","z5dnup.3f","1"],"leave":null,"group":4255},{"name":"sgmt_33136","timelimit":14,"autoexit":true,"enter":["gte",["sum",["pathVisits","a9f5469372b548bf"]],1],"leave":null,"group":4261},{"name":"sgmt_33137","timelimit":14,"autoexit":true,"enter":["gte",["sum",["pathVisits","4c74a6ece539dacf"]],1],"leave":null,"group":4261},{"name":"sgmt_33138","timelimit":14,"autoexit":true,"enter":["gte",["sum",["pathVisits","2eeb0f54b73ec8e4"]],1],"leave":null,"group":4261},{"name":"sgmt_33139","timelimit":14,"autoexit":true,"enter":["gte",["sum",["pathVisits","7fc164104e5b74f1"]],1],"leave":null,"group":4261},{"name":"sgmt_33140","timelimit":14,"autoexit":true,"enter":["gte",["sum",["pathVisits","439b4ef75ebc695b"]],1],"leave":null,"group":4261},{"name":"sgmt_33141","timelimit":14,"autoexit":true,"enter":["gte",["sum",["pathVisits","a9f49e1c6dd3b403"]],1],"leave":null,"group":4261},{"name":"sgmt_33142","timelimit":14,"autoexit":true,"enter":["gte",["sum",["pathVisits","06a558ea155fb24a"]],1],"leave":null,"group":4261},{"name":"sgmt_33143","timelimit":14,"autoexit":true,"enter":["gte",["sum",["pathVisits","a590d8f53a5c70fa"]],1],"leave":null,"group":4261},{"name":"sgmt_33144","timelimit":14,"autoexit":true,"enter":["gte",["sum",["pathVisits","84a4c2606fdbebc3"]],1],"leave":null,"group":4261},{"name":"sgmt_33145","timelimit":14,"autoexit":true,"enter":["gte",["sum",["pathVisits","991c70eddefd8980"]],1],"leave":null,"group":4261},{"name":"sgmt_33146","timelimit":14,"autoexit":true,"enter":["gte",["sum",["pathVisits","f7a59439f788d4f8"]],1],"leave":null,"group":4261},{"name":"sgmt_33147","timelimit":14,"autoexit":true,"enter":["gte",["sum",["pathVisits","131ce1da3abb5d2e"]],1],"leave":null,"group":4261},{"name":"sgmt_33256","timelimit":14,"autoexit":true,"enter":["customAction","fgz9el.5x","1"],"leave":null,"group":4281},{"name":"sgmt_33257","timelimit":14,"autoexit":true,"enter":["customAction","znwonb.6z","1"],"leave":null,"group":4281},{"name":"sgmt_34567","timelimit":14,"autoexit":true,"enter":["gte",["sum",["pathVisits","0e2c0ba7f45ec66c"]],1],"leave":null}],"api":{"domain":"\/\/inpref.com\/","origin":"sportsbook_dafabet_com"},"pages":{"94d3b08fd4a85042":["matchBegins","http:\/\/sportsbook.dafabet.com\/en\/getting-started.html",{},{},""],"5bb6b6324547aa87":["matchBegins","http:\/\/sportsbook.dafabet.com\/en\/how-to-reg.html",{},{},""],"3cce8a833b1c8db8":["matchBegins","http:\/\/sportsbook.dafabet.com\/en\/faq.html",{},{},""],"770c6c1a7c5e4d32":["matchBegins","http:\/\/sportsbook.dafabet.com\/en\/contact-us.html",{},{},""],"190c1d3d946d446d":["matchBegins","http:\/\/sportsbook.dafabet.com\/en\/about-us.html",{},{},""],"b4819b597c5bf2f8":["matchBegins","http:\/\/sportsbook.dafabet.com\/en\/terms-of-use.html",{},{},""],"6fd27a1bbd4ce101":["matchBegins","http:\/\/sportsbook.dafabet.com\/en\/rules-and-regulations.html",{},{},""],"ee1fd1a2f91486bd":["matchBegins","http:\/\/sportsbook.dafabet.com\/en\/wager-types.html",{},{},""],"49a66228a3b29e94":["matchBegins","http:\/\/sportsbook.dafabet.com\/",{"frosmo":["matchExact","test"]},{},""],"fd3db29cfa7072a3":["matchBegins","sportsbook.dafabet.com",{},{},""],"26673c26cd19c7fa":["matchBegins","\/",{"trackingId":["matchBegins","TRK"]},{},""],"0a82c2c07c226f61":["matchBegins","\/",{"btag":["matchRegex",".*"]},{},""],"f13c7b8d62ccf343":["matchBegins","\/",{"trackingId":["matchBegins","trk"]},{},""],"681bf971150eabaf":["matchRegex","(TRK|btag)",{},{},""],"94cb17d0d613224a":["matchBegins","\/",{"m":["matchRegex",".*"]},{},""],"e07511a3b7731e2b":["matchBegins","\/",{"member":["matchRegex",".*"]},{},""],"f39b801edc189dd7":["matchBegins","\/",{"trackingId":["matchRegex",".*"]},{},""],"a9f5469372b548bf":["matchBegins","\/en",{},{},""],"4c74a6ece539dacf":["matchBegins","\/eu",{},{},""],"2eeb0f54b73ec8e4":["matchBegins","\/sc",{},{},""],"7fc164104e5b74f1":["matchBegins","\/ch",{},{},""],"439b4ef75ebc695b":["matchBegins","\/th",{},{},""],"a9f49e1c6dd3b403":["matchBegins","\/vn",{},{},""],"06a558ea155fb24a":["matchBegins","\/id",{},{},""],"a590d8f53a5c70fa":["matchBegins","\/jp",{},{},""],"84a4c2606fdbebc3":["matchBegins","\/kr",{},{},""],"991c70eddefd8980":["matchBegins","\/in",{},{},""],"f7a59439f788d4f8":["matchBegins","\/gr",{},{},""],"131ce1da3abb5d2e":["matchBegins","\/pl",{},{},""],"0e2c0ba7f45ec66c":["matchBegins","\/",{"btag":["matchExact","654492_SUNDULRegdspID111600400"]},{},""]},"forms":[],"links":[],"landingPages":[],"meta":[],"campaigns":[],"targetGroups":true,"campaignElements":[],"survey":[],"sharedContext":1,"requestMessages":false,"messagesBeforeContext":0,"dataLayer":0,"fallbackUrl":null,"contextConversionDictionary":{"pages":{"feac77dd7af542fa":["94d3b08fd4a85042"],"7d399980035005b7":["5bb6b6324547aa87"],"b5d39ad7064ee655":["3cce8a833b1c8db8"],"b4c6aab0a30017f0":["770c6c1a7c5e4d32"],"8539a84d925524b2":["190c1d3d946d446d"],"953185424d3c2993":["b4819b597c5bf2f8"],"72ea4fdaf9c75532":["6fd27a1bbd4ce101"],"94fcf1b9a4e7c0be":["ee1fd1a2f91486bd"],"98d8392ba54146bf":["49a66228a3b29e94"],"2b991806ecede6b5":["fd3db29cfa7072a3"],"a292fb035c8d7295":["26673c26cd19c7fa"],"0990aa37c9c78455":["0a82c2c07c226f61"],"8974bad42456788c":["f13c7b8d62ccf343"],"ce9937eee8de5dfa":["681bf971150eabaf"],"4dbdcc4869d2546d":["94cb17d0d613224a"],"53bc67bf386c1315":["e07511a3b7731e2b"],"603aa3a8f4aa2304":["f39b801edc189dd7"],"500552425e528ba0":["a9f5469372b548bf"],"960591bb7083f5dc":["4c74a6ece539dacf"],"654f88df68485b8c":["2eeb0f54b73ec8e4"],"3dcaef34ce35e1d0":["7fc164104e5b74f1"],"d7847f92a6b2a972":["439b4ef75ebc695b"],"a39a6b6715395fb5":["a9f49e1c6dd3b403"],"ece35e06baefd0ea":["06a558ea155fb24a"],"dc49417883eec231":["a590d8f53a5c70fa"],"220e9158108625c2":["84a4c2606fdbebc3"],"bb4dee5b33695798":["991c70eddefd8980"],"ecbcce62e46b09dd":["f7a59439f788d4f8"],"3cc77fae0a2fb566":["131ce1da3abb5d2e"],"b140f109887b94ae":["0e2c0ba7f45ec66c"]}},"segmentGroups":{"sggp_4255":{"segments":["sgmt_33082","sgmt_33083","sgmt_33084","sgmt_33085","sgmt_33086","sgmt_33087","sgmt_33088","sgmt_33089","sgmt_33090","sgmt_33091","sgmt_33096","sgmt_33097"],"mode":"radio"},"sggp_4261":{"segments":["sgmt_33136","sgmt_33137","sgmt_33138","sgmt_33139","sgmt_33140","sgmt_33141","sgmt_33142","sgmt_33143","sgmt_33144","sgmt_33145","sgmt_33146","sgmt_33147"],"mode":"radio"},"sggp_4281":{"segments":["sgmt_33256","sgmt_33257"],"mode":"radio"}},"conversions":[],"baseUrl":"\/\/inpref.s3.amazonaws.com\/","templates":[],"positions":[{"position":969,"elementId":"popup","name":"Pop up - English Site","method":"replace","urlMatch":[["matchExact","http:\/\/sportsbook.dafabet.com\/en\/",{},{}]]},{"position":2370,"elementId":"#block-system-main","name":"test","method":"replace","urlMatch":[["matchExact","http:\/\/resources.dafabet.com\/en\/rotating-banner",{},{}]]},{"position":2848,"elementId":"popup","name":"Pop up - Thai Site","method":"replace","urlMatch":[["matchExact","http:\/\/sportsbook.dafabet.com\/th",{},{}]]},{"position":2896,"elementId":"popup","name":"Pop up - Vietnamese site","method":"replace","urlMatch":[["matchExact","http:\/\/sportsbook.dafabet.com\/vn",{},{}]]},{"position":2898,"elementId":"popup","name":"Pop up - Korean site","method":"replace","urlMatch":[["matchExact","http:\/\/sportsbook.dafabet.com\/kr",{},{}]]},{"position":3009,"elementId":"popup","name":"Pop up - Japanese site","method":"replace","urlMatch":[["matchExact","http:\/\/sportsbook.dafabet.com\/jp",{},{}]]},{"position":3012,"elementId":"popup","name":"Pop up - Indian site","method":"replace","urlMatch":[["matchExact","http:\/\/sportsbook.dafabet.com\/in",{},{}]]},{"position":3013,"elementId":"popup","name":"Pop up - Indonesian site","method":"replace","urlMatch":[["matchExact","http:\/\/sportsbook.dafabet.com\/id",{},{}]]},{"position":3014,"elementId":"popup","name":"Pop up - Simplified Chinese sites","method":"replace","urlMatch":[["matchExact","http:\/\/sportsbook.dafabet.com\/sc",{},{}]]},{"position":3015,"elementId":"popup","name":"Pop up - Traditional Chinese site","method":"replace","urlMatch":[["matchExact","http:\/\/sportsbook.dafabet.com\/ch",{},{}]]},{"position":3016,"elementId":"popup","name":"Pop up - Polish site","method":"replace","urlMatch":[["matchExact","http:\/\/sportsbook.dafabet.com\/pl",{},{}]]},{"position":3017,"elementId":"popup","name":"Pop up - English (Europe) site","method":"replace","urlMatch":[["matchExact","http:\/\/sportsbook.dafabet.com\/eu",{},{}]]},{"position":3227,"elementId":"popup","name":"popup test","method":"replace","urlMatch":[["matchBegins","sportsbook.dafabet.com",{},{}]]},{"position":3585,"elementId":"popup","name":"Pop up - Greek Site","method":"replace","urlMatch":[["matchExact","http:\/\/sportsbook.dafabet.com\/gr",{},{}]]},{"position":5890,"elementId":"popup","name":"popup-1","method":"replace"},{"position":6141,"elementId":"$body","name":"Session Once Popup","method":"append","renderer":"sessionOncePopup"},{"position":6046,"elementId":"$body","name":"After body content","method":"append"},{"position":5448,"elementId":"$body","name":"Post login popup","method":"append","urlMatch":[["matchBegins","\/",{},{}]],"renderer":"postloginPopup"},{"position":5073,"elementId":"body-section","name":"Page background","method":"append","urlMatch":[["matchExact","\/en",{},{}],["matchExact","\/en\/esports",{},{}]]},{"position":6231,"elementId":"$.fields-content .text-center .popup-btn","name":"Step 2: Make Deposit page","method":"after","urlMatch":[["matchRegex","make-deposit",{},{}]],"renderer":"stepTwoReg"},{"position":6232,"elementId":"$.start-playing .text-center .btn-xlarge","name":"Step 3: Start Playing page","method":"after","urlMatch":[["matchRegex","start-playing",{},{}]],"renderer":"stepThreeReg"},{"position":6261,"elementId":"$.start-playing-thumbs > div.left:eq(0)","name":"Step 3-1: Banner block","method":"replace","urlMatch":[["matchRegex","start-playing",{},{}]],"renderer":"stepThreeBanner"},{"position":6262,"elementId":"$.start-playing-thumbs > div.left:eq(1)","name":"Step 3-2: Banner block","method":"replace","urlMatch":[["matchRegex","start-playing",{},{}]],"renderer":"stepThreeBanner"},{"position":6263,"elementId":"$.start-playing-thumbs > div.left:eq(2)","name":"Step 3-3: Banner block","method":"replace","urlMatch":[["matchRegex","start-playing",{},{}]],"renderer":"stepThreeBanner"}],"hiddenMessageClickTracking":false,"customActions":{"segments":{"rzefiq.5v":{"name":"userLoggedIn","values":["true"]},"i54l54.6h":{"name":"userCountry","values":["China","Hong Kong","Philippines"]},"cz39a8.pu":{"name":"userCountry","values":["Philippines"]},"mcn8h1.gp":{"name":"geolocationPhilippines","values":["philippines"]},"6l6yxl.j7":{"name":"userCurrency","values":["EUR"]},"qp33le.qy":{"name":"userCurrency","values":["IDR"]},"3g5w1h.2u":{"name":"userCurrency","values":["INR"]},"5sxyla.px":{"name":"userCurrency","values":["KRW"]},"3catvw.ew":{"name":"userCurrency","values":["MYR"]},"6qe50.8qv":{"name":"userCurrency","values":["PLN"]},"fpej53.gl":{"name":"userCurrency","values":["RMB"]},"9huyrv.eu":{"name":"userCurrency","values":["THB"]},"zmcfnn.av":{"name":"userCurrency","values":["USD"]},"se49ga.ya":{"name":"userCurrency","values":["VND"]},"d4iri.9hs":{"name":"userCurrency","values":["GBP"]},"z5dnup.3f":{"name":"userCurrency","values":["RUB"]},"fgz9el.5x":{"name":"userLoggedIn","values":["true"]},"znwonb.6z":{"name":"userLoggedIn","values":["false"]}},"states":["geolocationPhilippines","sessionOnce"],"rules":[{"name":"geolocationPhilippines","type":"geolocation","rules":{"philippines":[6.8609856065605,124.56298822962,400]}}]},"googleAnalytics":[],"quickMessages":[],"triggers":[]};

    _frosmo.initFunction = function () {

        frosmo.easy.api.init(_config.api.domain, _config.api.origin);

        if (frosmo.easy.versionAtLeast && frosmo.easy.versionAtLeast('6.7', frosmo.easy.VERSION)) {
            frosmo.easy.VERSION_RULES = 3.6;
            
            

            "822935f4958580dd235b4ffc52acd75a6a956f14";
(function() {
  var a = this.frosmo = this.frosmo || {}, m = a.easy = a.easy || {}, a = a.geo = {}, h = {}, d = function(b) {
    return parseFloat(b, 10) * (Math.PI / 180)
  }, k = function(b) {
    b = b.replace(/\s/g, "").split(",");
    var c = {};
    c.lat = parseFloat(b[0], 10);
    c.lon = parseFloat(b[1], 10);
    b[2] && (c.radius = parseFloat(b[2], 10));
    return c
  }, l = function(b, c) {
    var a = d(c.lat - b.lat), e = d(c.lon - b.lon), f = d(b.lat), g = d(c.lat), a = Math.sin(a / 2) * Math.sin(a / 2) + Math.sin(e / 2) * Math.sin(e / 2) * Math.cos(f) * Math.cos(g);
    return 6371 * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  };
  a.getCities = function(b) {
    var a = [], d = {}, e = {}, f, g, d = k(b);
    for(f in h) {
      h.hasOwnProperty(f) && (e = k(h[f]), b = l(d, e), g = f.replace(/\d/g, ""), b <= e.radius && !m.utils.inArray(a, g) && a.push(g))
    }
    return a
  };
  a.getCircleDistance = l;
  a.init = function(a) {
    h = a.maps
  };
  a.parseCoordinates = k
})();


            
            if (frosmo.easy.VERSION <= 6.7) {
                frosmo.easy.main.onInitSuccess(
                    frosmo.easy.addExceptionHandling(function () {
                        frosmo.easy.message.init({positions: _config.positions, fallbackUrl: '//inpref.s3.amazonaws.com/fallback/sportsbook_dafabet_com.json'}, document.location.href);
                    })
                );
            }
            "ddf28ef1c22b57acdfb0deadecaa12517912a9ec";
(function(){var l=window,a=(l.frosmo=l.frosmo||{}).easy||{},b=a.getSite();a.config=a.config||{};b.config={customApiUrl:"//dafabet_api.frosmo.com/"};b.config=b.config||{};(function(){var g=b.customActions=b.customActions||{},d={CN:"China",HK:"Hong Kong",PH:"Philippines"};g.evaluateGeoLocation=function(b){"undefined"!==typeof b&&null!==b.country2&&d[b.country2]&&a.addExceptionHandling(a.customAction.trigger("userCountry",d[b.country2]))};g.evaluateUserStatus=function(){Drupal&&(b.utils.isUserLoggedIn()?
a.addExceptionHandling(a.customAction.trigger("userLoggedIn","true")):a.addExceptionHandling(a.customAction.trigger("userLoggedIn","false")))};g.evaluateUserCurrency=function(){var d=b.utils.getUserCurrency();d&&a.addExceptionHandling(a.customAction.trigger("userCurrency",d))}})();(function(){var g=b.utils=b.utils||{};g.isUserLoggedIn=function(){return Drupal.settings.logged_in};g.getUserCurrency=function(){var b=document.querySelector(".available-balance .user-balance"),e;b&&(b=b.textContent||b.innerText,
(e=b.match(/^[a-zA-Z]+/))&&(e=e[0]));return e?(a.context.site.userCurrency=e,a.context.save(),e):a.context.site.userCurrency||!1}})();b.conversions=function(){var b=function(){if(!a.context.site.is_member&&jQuery(".account-created").length&&document.location.href.match(/make-deposit$/)){var b=jQuery(".username").text();b&&(a.conversions.push({conversion_type:"new_user",conversion_value:0,conversion_id:"new_user",conversion_name:"new_user",conversion_quantity:1,transaction_id:"new_user_"+b}),a.conversion.handleConversionArray(),
a.context.site.is_member=!0,a.context.save())}},d=function(){jQuery(".header .btn-banking, .floating-action.deposit, .make-deposit-blurb ~ div .popup-btn").click(a.addExceptionHandling(function(){a.store.set("initialBalance",e())}));jQuery(document).on("ajaxSuccess",function(a,c,b){/refresh\/balance/.test(b.url)&&(h(),k())});a.setTimeout(function(){h();k()},2E3)},e=function(){var b=jQuery(".available-balance .user-balance").text(),c=a.utils.getTimestamp();return b?(b=parseFloat(b.replace(/[^0-9\.\-]/g,
"")),{balance:b,timestamp:c}):{}},h=function(){var b=a.store.get("initialBalance"),c=jQuery(".available-balance .user-balance").text(),f=a.utils.getTimestamp();a.utils.isObject(b)&&c&&(3600>f-b.timestamp?(c=parseFloat(c.replace(/[^0-9\.\-]/g,"")),c>b.balance&&(a.conversions.push({conversion_type:"new_deposit",conversion_value:1,conversion_id:"new_deposit",conversion_name:"new_deposit",conversion_quantity:1}),a.conversion.handleConversionArray(),a.store.remove("initialBalance"))):a.store.remove("initialBalance"))},
k=function(){var b=a.context.site.afterRegTest;if(b&&!(0>=e().balance)){var c=b.timestamp3||b.timestamp2||0,c=a.utils.getTimestamp()-c,f;2===b.lastView&&!b.lastClick?f="deposit_now_view":2===b.lastClick?f="deposit_now_click":3===b.lastView&&!b.lastClick?f="play_now_view":3===b.lastView&&3===b.lastClick&&(f="play_now_click");b.hidden&&(f+=" (original)");f&&600>c&&(a.conversions.push({conversion_type:"reg_deposit",conversion_value:0,conversion_id:f,conversion_name:f,conversion_quantity:1}),a.conversion.handleConversionArray(),
a.context.site.afterRegTest=void 0,a.context.save())}};return{init:function(){a.utils.waitFor(100,1E3,function(){if("undefined"!==typeof jQuery)return a.addExceptionHandling(b)(),a.addExceptionHandling(d)(),!0})}}}();(function(){b.init=function(){window.self===window.top&&(b.renderer.init(),a.domEvents.ready(function(){a.utils.waitFor(100,5E3,function(){if(window.jQuery)return b.utils.checkVip(),b.customActions.evaluateUserStatus(),b.customActions.evaluateUserCurrency(),b.conversions.init(),a.events.on("location",
b.customActions.evaluateGeoLocation),a.message.requestMessages(),!0})}))}})();(function(){var g=function(d,c,f,e){d=b.utils.getUsername();f=b.utils.getBalance();d&&!(1<=f||"1"===a.cookies.get("msg_postlogin"))&&a.utils.waitFor(500,5E3,function(){if(b.config.isVip)return a.popup.show(c.content),a.api.showMessage(null,c.id,c.revision),a.messageTrueDisplay.logInstantly(c.id,c.revision),a.cookies.set("msg_postlogin","1",365),!0})},d=function(b,c,f,d){window.sessionStorage["sessionOnceMessages_"+c.id]||
(window.sessionStorage["sessionOnceMessages_"+c.id]=!0,a.popup.show(c.content),a.api.showMessage(null,c.id,c.revision),a.messageTrueDisplay.logInstantly(c.id,c.revision),jQuery("#frosmoPopup a").on("click",function(){a.api.clickMessage(null,c.id,c.revision);a.events.trigger(a.EVENT_MESSAGE_CLICK,c)}))},e=function(b,c,d,e){"hidden"!==c.revisionType&&(a.messageShow.insertHtml(d,c.content),a.messageTrueDisplay.logInstantly(c.id,c.revision));a.api.showMessage(null,c.id,c.revision);a.context.site.afterRegTest=
{lastView:2,lastClick:null,timestamp2:a.utils.getTimestamp()};"hidden"===c.revisionType&&(a.context.site.afterRegTest.hidden=!0);a.context.save();jQuery(".fields-content .text-center .popup-btn").on("click",function(){a.api.clickMessage(null,c.id,c.revision);a.events.trigger(a.EVENT_MESSAGE_CLICK,c);a.context.site.afterRegTest.lastClick=2;a.context.save()})},h=function(b,c,d,e){"hidden"!==c.revisionType&&(a.messageShow.insertHtml(d,c.content),a.messageTrueDisplay.logInstantly(c.id,c.revision));a.api.showMessage(null,
c.id,c.revision);a.context.site.afterRegTest=a.context.site.afterRegTest||{};a.context.site.afterRegTest.lastView=3;a.context.site.afterRegTest.timestamp3=a.utils.getTimestamp();"hidden"===c.revisionType&&(a.context.site.afterRegTest.hidden=!0);a.context.save();a.context.site.afterRegTest.lastClick&&window.setInterval(function(){jQuery(".header .refresh-balance").click()},1E4);jQuery(".start-playing .text-center .btn-xlarge").on("click",function(){a.api.clickMessage(null,c.id,c.revision);a.events.trigger(a.EVENT_MESSAGE_CLICK,
c);a.context.site.afterRegTest&&(a.context.site.afterRegTest.lastClick=3,a.context.save())})},k=function(b,c,d,e){"hidden"!==c.revisionType&&(a.utils.addClassName(d,"frosmo_inline"),a.messageShow.insertHtml(d,c.content));a.api.showMessage(null,c.id,c.revision);a.messageTrueDisplay.start(c,b,d);jQuery(d).find("a").on("click",function(){a.api.clickMessage(null,c.id,c.revision);a.events.trigger(a.EVENT_MESSAGE_CLICK,c);a.messageTrueDisplay.logInstantly(c.id,c.revision)})};(b.renderer=b.renderer||{}).init=
function(){a.messageShow.addCustomRenderer("postloginPopup",g);a.messageShow.addCustomRenderer("sessionOncePopup",d);a.messageShow.addCustomRenderer("stepTwoReg",e);a.messageShow.addCustomRenderer("stepTwoReg.hidden",e);a.messageShow.addCustomRenderer("stepThreeReg",h);a.messageShow.addCustomRenderer("stepThreeReg.hidden",h);a.messageShow.addCustomRenderer("stepThreeBanner",k);a.messageShow.addCustomRenderer("stepThreeBanner.hidden",k)}})();b.styles="";b.config&&!b.config.doNotAddStyles&&a.domElements.addStyles(b.styles);
(function(){var g=b.utils=b.utils||{};g.getUsername=function(){var a=document.querySelector(".matterhorn-account-logged-in .username");return a?a.textContent||a.innerText:!1};g.getBalance=function(){var a=document.querySelector(".matterhorn-account-logged-in .user-balance"),b;a&&(b=a.textContent||a.innerText);return b?Number(b.replace(/[^\d\.]/g,"")):!1};g.checkVip=function(){var d=a.cookies.get("frvps"),e=b.utils.getUsername();e&&(d?"1"===d&&(b.config.isVip=!0):jQuery.getJSON(b.config.customApiUrl+
"?method=checkVip&username="+e).done(function(d){d.isVip?(a.cookies.set("frvps","1",1/24),b.config.isVip=!0):a.cookies.set("frvps","0",1/24)}))}})();a.main.onInitSuccess(a.addExceptionHandling(function(){b.init()},{code:a.ERROR_SITE_UNKNOWN}))})();


            frosmo.easy.addExceptionHandling(function () {
                frosmo.easy.init(_config);
            }, {code: frosmo.easy.ERROR_INIT})();

            
            
        }
        else {
            frosmo.easy.api.error('version difference 3.6|6.7|' + frosmo.easy.VERSION, frosmo.easy.ERROR_VERSION_DIFF || 1008);
        }
    }

    if (frosmo.easy && !_frosmo.initialized) {
        frosmo.easy.addExceptionHandling(_frosmo.initFunction)();
        _frosmo.initialized = true;
    }

}());