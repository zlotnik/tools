function parseUri(a){var b=parseUri.options,c=b.parser[b.strictMode?'strict':'loose'].exec(a),d={},e=14;while(e--)d[b.key[e]]=c[e]||'';d[b.q.name]={};d[b.key[12]].replace(b.q.parser,function(a,c,e){if(c)d[b.q.name][c]=e});return d}parseUri.options={strictMode:false,key:['source','protocol','authority','userInfo','user','password','host','port','relative','path','directory','file','query','anchor'],q:{name:'queryKey',parser:/(?:^|&)([^&=]*)=?([^&]*)/g},parser:{strict:/^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/,loose:/^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/}};function contains(p, v){ if(p==undefined) return false; else { var regex = new RegExp(v,'i'); if(p.search(regex) < 0) return false; else return true;}}var url = parseUri(document.URL);var refurl = parseUri(document.referrer); var urlparam = url.queryKey; var refurlparam = refurl.queryKey;var newdiv = document.createElement('div');
newdiv.setAttribute('style','display:inline;');
var kv_pairs='';
if(!(typeof ae_parms_kv === 'undefined')){
for (key in ae_parms_kv){
if(!(typeof key === 'undefined')){
if (ae_parms_kv[key] instanceof Array) {
kv_pairs = kv_pairs+'&' + key+'='+encodeURIComponent(ae_parms_kv[key].join(','));
} else{
kv_pairs = kv_pairs+'&' + key+'='+encodeURIComponent(ae_parms_kv[key]);
}
if(kv_pairs.length > 2000)break;
}}
}
function makeFrame(e) {
	ifrm = document.createElement("IFRAME"), ifrm.setAttribute("src", e), ifrm.style.width = "0px", ifrm.style.height = "0px", document.body.appendChild(ifrm)
}
var host = ("https:" == document.location.protocol) ? "https://" : "http://";var rt_url = host + "sc.adelement.com/setRT_adelement_cookie.php?ae_rt=68b6d5bdc9e20db6e1aa8b0d8ae420a1&_ae_ref="+escape(document.referrer)+kv_pairs;newdiv.innerHTML = '<img height = "1" width = "1" style = "border-style:none;" alt = "" src="'+rt_url+'"/>';
document.getElementsByTagName('head')[0].appendChild(newdiv);
try{
  makeFrame(host + "d313lzv9559yp9.cloudfront.net/dafabetRt.html")
}catch(e){}

try{
    if(ae_parms_kv.hasOwnProperty('depth') && (ae_parms_kv['depth'] == '4' || ae_parms_kv['depth'] == '5')){
      var ae_r = Math.floor(Math.random()*99999999999);
      var ae_u = (location.protocol=='https:'?'https://ads.adelement.com/www/delivery_dev/ti.php':'http://ads.adelement.com/www/delivery_dev/ti.php');

      var newdiv = document.createElement('div');
      newdiv.setAttribute('style','display:inline;');
      var rt_url = ae_u+"?trackerid=285&amp;cb="+ae_r+kv_pairs;
      newdiv.innerHTML = '<img height = "1" width = "1" style = "border-style:none;" alt = "" src="'+rt_url+'"/>';
      document.getElementsByTagName('head')[0].appendChild(newdiv);
      try{
      	makeFrame(host + "d313lzv9559yp9.cloudfront.net/dafabetConv.html")
      }catch(e){}
    }
}catch(err){}
var newdiv = document.createElement('div');
newdiv.setAttribute('style','display:inline;');
newdiv.innerHTML='<img src="https://secure.adnxs.com/seg?add=4735086&t=2" width="1" height="1" />';
document.getElementsByTagName('head')[0].appendChild(newdiv);
var newdiv = document.createElement('div');
newdiv.setAttribute('style','display:inline;');
newdiv.innerHTML='<img src="//pixel.mathtag.com/event/img?mt_id=936394&mt_adid=158625&v1=&v2=&v3=&s1=&s2=&s3=" width="1" height="1" />';
document.getElementsByTagName('head')[0].appendChild(newdiv);
