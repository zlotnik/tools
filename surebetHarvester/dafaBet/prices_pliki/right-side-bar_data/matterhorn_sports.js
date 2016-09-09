(function($) {

Drupal.behaviors.matterhorn_sports = {
	attach: function (context, settings) {

        if($('.sports-nav', context).length > 0 && $('.i18n-en-gb', context).length > 0) {
            $('.sports-nav', context).find('a[href*="sports-betting?sport=150"]').parent().remove();
        }
		
		if($('#betframe').length > 0) {
            var frame = $('#betframe'),
                src = frame.attr('src'),
                frameUrl = src +"#"+ encodeURIComponent(document.location.href);

            /* Update the frame url */
            frame.attr('src', frameUrl);
            var iseuro = src.match(/iseuro=1/);

            var loc = window.location.href;
                loc = loc.split("#");

                var obj = {};
                obj.parentUrl = loc[0];

                if(typeof(loc[1]) !== 'undefined') {
                    loc[1] = loc[1].match(/frameHeight=|minHeight=|iseuro=1/);
                    if(loc[1] !== null) { window.location.hash = ""; }
                }

            var fDomain_switch = 0;
            var voyager_probe = function(f, o) {
                var frameDomain = '';
                if(fDomain_switch == 0) {
                    frameDomain = settings.sports_frame_urls.no_trans+f;
                    fDomain_switch = 1;
                } else {
                    frameDomain = settings.sports_frame_urls.with_trans+f;
                    fDomain_switch = 0;
                }
                /* This will probe the iframe to give the current url */
                $.postMessage(o, frameDomain, frame.get(0).contentWindow);
            };

            /* For EU Fluidity */
            if(iseuro !== null) {
                if(loc[0].indexOf('sports-betting') !== -1) {
                    var q = window.location.search;
                    obj.sport = 'sport=all';
                    if(q != '') {
                        obj.sport = q.substr(1);
                    }
                }
                var frame_uri = 'EuroSite/Euro_index.aspx';
                var probe = setInterval(function() {
                    voyager_probe(frame_uri, obj);
                }, 800);

            } else if($('.msie7,.msie8,.safari5').length > 0 && settings.logged_in) {
                var frame_uri = 'main.aspx';
                var probe = setInterval(function(){
                    voyager_probe(frame_uri,obj);
                }, 800);
            }
        }

        /* Retain values for this fields */
        $.each($('input[data-userval]'), function(i,e) {
            $(e).val($(e).attr('data-userval'));
			data = $(e).attr('data-userval');
				if (data != '') {
					$(this).css('borderColor', '').after('<span class="check"></span>');
				} else {
					$(this).css('borderColor', 'red').after('<span class="error"></span>');
				}
        });
		
		$.each($('input[data-submitted], select[data-submitted]'), function(i,e) {
			data = $(e).attr('data-submitted');
				if (data != '') {
					$(this).css('borderColor', '').after('<span class="check"></span>');
				} else {
					$(this).css('borderColor', 'red').after('<span class="error"></span>');
				}
		});

        if(typeof($.receiveMessage) !== 'undefined') {
        	/* Recieve from child frame */
	        $.receiveMessage(function(e) {
	            
	            // Parse the query string.
	            var res = Drupal.behaviors.QStringToObj(e.data);
	            
	            // Check if the betframe exists
	            if(typeof(frame) !== 'undefined') {

	                if(typeof(res.frameHeight) !== 'undefined' && res.frameHeight > 0) {

	                    if(typeof(res.minHeight) !== 'undefined' && res.minHeight > 0) {
	                        frame.css('min-height', res.minHeight+"px");
	                    } else {
	                        frame.css('min-height', (iseuro !== null) ? "820px":"870px");
	                    }

                        frame.height(res.frameHeight + "px");
	                }
	            }

	            if(typeof(probe) !== 'undefined' && probe != "fluid_on") {
                    if(typeof(res.fluid) !== 'undefined' && res.fluid == "1") {
                        /* Clear interval of the probe */
                        clearInterval(probe);
                        probe = "fluid_on";
                    }
	            }
	        });
        }
		
		/** Change-password */
        $('#sports-new-password, #sports-confirm-password').blur(function(e) {
            var value = $(this).val();
            if (value == '') {
                $(this).siblings('span.check').remove();
                $(this).after('<span class="error"></span>');
                $(this).css('borderColor', 'red');
                return false;
            } else {
                $(this).siblings('span.error').remove();
                $(this).after('<span class="check"></span>');
                $(this).css('borderColor', '');
            }
        });

        var forgot_submitted = false;
        $('#sports-change-password-form').on('submit',function(e) {
            if(forgot_submitted == true) {
                e.preventDefault();
            } else {
                forgot_submitted = true;
            }
        });
	}
};
		
})(jQuery);