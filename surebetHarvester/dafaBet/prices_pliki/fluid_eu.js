 /*
 * jQuery postMessage - v0.5 - 9/11/2009
 * http://benalman.com/projects/jquery-postmessage-plugin/
 * 
 * Copyright (c) 2009 "Cowboy" Ben Alman
 * Dual licensed under the MIT and GPL licenses.
 * http://benalman.com/about/license/
 */
(function($){var g,d,j=1,a,b=this,f=!1,h="postMessage",e="addEventListener",c,i=b[h]/*&&!$.browser.opera*/;$[h]=function(k,l,m){if(!l){return}k=typeof k==="string"?k:$.param(k);m=m||parent;if(i){m[h](k,l.replace(/([^:]+:\/\/[^\/]+).*/,"$1"))}else{if(l){m.location=l.replace(/#.*$/,"")+"#"+(+new Date)+(j++)+"&"+k}}};$.receiveMessage=c=function(l,m,k){if(i){if(l){a&&c();a=function(n){if((typeof m==="string"&&n.origin!==m)||($.isFunction(m)&&m(n.origin)===f)){return f}l(n)}}if(b[e]){b[l?e:"removeEventListener"]("message",a,f)}else{b[l?"attachEvent":"detachEvent"]("onmessage",a)}}else{g&&clearInterval(g);g=null;if(l){k=typeof m==="number"?m:typeof k==="number"?k:100;g=setInterval(function(){var o=document.location.hash,n=/^#?\d+&/;if(o!==d&&n.test(o)){d=o;l({data:o.replace(n,"")})}},k)}}}})(jQuery);
jQuery(document).ready(function(){
    var script = document.createElement("script");
    script.type = "text/javascript";
    //script.src = "http://cdn.js.dfzuqiu.org/prd/fluid.core.eu.js";
    document.getElementsByTagName('head')[0].appendChild(script);
});

jQuery(document).ready(function($) {
  var e = window.location.pathname;
  e = e.match(/Euro_index|Euro_Index/);
  var t = {
    parentUrl: "",
    checkHeightTimer: 0,
    fluidEuCss: "http://cdn.media.dfzuqiu.org/prd/fluid.eu.css",
    timer: 800,
    triggerSport_triggered: false,
    QStringToObj: function(e) {
      var t = [],
        n = {};
      if (e.indexOf("?") === -1) {
        t = e.split("&")
      } else {
        var r = e.indexOf("?") + 1;
        t = e.slice(r).split("&")
      }
      $.each(t, function(e, t) {
        var r = t.split("=");
        n[r[0]] = r[1]
      });
      return n
    },
    getParamByName: function(e, t) {
      e = e.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
      var n = new RegExp("[\\?&]" + e + "=([^&#]*)"),
        r = typeof t === "string" ? n.exec(t) : n.exec(t.search);
      return r === null ? "" : decodeURIComponent(r[1].replace(/\+/g, " "))
    }
  };
  t.init = function() {
    this.addCSS();
    this.fixRightSideBar();
    this.checkHeightTimer = setInterval(t.checkHeight, 2e3)
  };
  t.checkHeight = function() {
    var e = {
      frameHeight: 850,
      minHeight: 850
    };
    var n = Math.max($(".ContainerLeft").height(), $(".ContainerMain").height(), $(".ContainerRight").height());
    e.frameHeight = n;
    e.minHeight = n;
    if (t.parentUrl != "") {
      e.fluid = 1;
      $.postMessage(e, t.parentUrl, parent)
    }
    e = null
  };
  t.fixRightSideBar = function() {
    var e = $(".ContainerRight iframe").last();
    $(e[0]).height("940px")
  };
  t.addCSS = function() {
    if (IsLogin) {
      $("body").addClass("post-logged-in")
    } else {
      $("body").addClass("pre-logged-in")
    }
    setTimeout(function() {
      var e = document.createElement("link");
      e.rel = "stylesheet";
      e.type = "text/css";
      e.href = t.fluidEuCss;
      document.getElementsByTagName("head")[0].appendChild(e)
    }, 500)
  };
  t.triggerSport = function(e) {
    if (this.triggerSport_triggered == true) {
      return
    } else {
      this.triggerSport_triggered = true
    }
    var t = setInterval(function() {
      var n = $(".nav,.navnone");
      if (n.length > 0 && $("#DivMainOdds center").length == 0) {
        if (e == "all") {
          SwitchSport("T", "1")
        } else if (e == "inplay") {
          SwitchMarket("L", false);
          setMenuTypeChangeOddsDisplay("l")
        } else {
          if (e == "OT") {
            SwitchOutright("T", e)
          } else {
            if (e == "150") {
              e = "151"
            }
            SwitchSport("T", e)
          }
        }
        clearInterval(t)
      }
    }, 800)
  };
  if (e !== null) {
    t.init()
  }
  $.receiveMessage(function(e) {
    var n = t.QStringToObj(e.data);
    if (typeof n.sport !== "undefined") {
      var r = decodeURIComponent(n.sport);
      r = r.split("=");
      if (typeof r[1] !== "undefined") {
        r = r[1];
        t.triggerSport(r)
      }
      

    }
    if (typeof n.parentUrl !== "undefined") {
      t.parentUrl = decodeURIComponent(n.parentUrl)
    }

    //for esports
    sports_path = t.parentUrl;
    esports_path = sports_path.match(/esports/);
    if(typeof esports_path != "undefined" || esports_path !== null) {
        esports_id = 43;
        t.triggerSport(esports_id);
    }
  })
});
