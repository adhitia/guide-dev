
if (!window.common) {
    $.ajaxSetup({
//        data: {'X-Requested-With' : 'XMLHttpRequest'},
        beforeSend: function(request) {
//            alert('beforeSend ' + data);
//            request.setRequestHeader("X-Requested-With","XMLHttpRequest");
//            alert(this.url);
//            common.parseParameters();
//
//            if (this.type == 'GET' && common.params.userId)
//                request.open(this.type, this.url + (this.url.indexOf('?') < 0 ? '?' : '&') + "userId=" + common.params.userId, this.async);

        },
        error: function(event, request, options, error) {
//            alert("error " + event.status);
            switch (event.status) {
//                case 503: common.setLocation('maintenance'); break;
//                case 404: common.setLocation('not-found'); break;
                case 401: common.setLocation('/unauthenticated'); break;
                case 403: common.setLocation('/unauthorized'); break;
            // zero is from post requests
                case 500, 404, 0: common.setLocation('/error'); break;
            }
        }
    });



    var common = {
        setLocation: function (location) {
//            if (window.location.href.indexOf(location) < 0)
                window.location.replace(location);
        },

        setLoading: function(container, text) {
            if (text == null || text == undefined) {
                text = '';
            }
            $(container).html('<span style="text-align:center;"><img src="/images/loading-indicator.gif">' + text + '</span>');
        },

        stopLoading: function(container) {
            $(container).html('');
        },

        /**
         * Provides overlay with full image to view.
         */
        imageHelper: function(root) {
            $(root).find('.full-image').each(function() {
                $(this).qtip({
                    content: '<img style="max-width:230px;max-height:230px;" src="' + $(this).attr('full_url') + '" alt="Loading..." />',
                    position: {
                        adjust: {
                            screen: true // Keep the tooltip on-screen at all times
                        }
                    },
                    width: {
                        max: 500
                    }
                });
            });
        },

        setLoadingGlobal: function(text) {
            if (text == null || text == undefined) {
                text = '';
            }
            $('#global-loading-indicator > span').html(text);
            $('#global-loading-indicator').show();
        },

        stopLoadingGlobal: function() {
            $('#global-loading-indicator').hide();
        },

        getHash: function() {
            return window.location.hash.substring(1);
        },

        confirm: function(message, successHandler) {
            $("#dialog_box").html(message);
            $("#dialog_box").dialog({
                buttons: {
                    "Ok": function() {
                        $(this).dialog("close");
                        successHandler();
                    },
                    "Cancel": function() {
                        $(this).dialog("close");
                    }
                },
                draggable: false,
                modal: true,
                resizable: false,
                title: 'Please confirm',
                width: 230
            });
        },

        trim: function(s) {
            return (s + '').replace(/^\s+|\s+$/g, '');
        },

        empty: function(s) {
//            alert(typeof s);
            return s == null || common.trim(s) == '';
        },

        // sets input value, truncating it if it's longer than allowed
        set_value: function(input, value) {
            input = $(input);
            var maxlength = input.attr('maxlength');
            if (maxlength != null) {
                if (value.length > maxlength) {
                    value = value.substr(0, maxlength);
                }
            }
            input.val(value);
        },

        clearValidationErrors: function() {
            $('.validation-error').html('');
            $('input.invalid,textarea.invalid').removeClass('invalid');
        },

        validationErrors: function(errors) {
            var errorsFound = false;
            if (errors != null) {
                var focused = false;
                for (var key in errors) {
                    var message = errors[key];
                    if (message == null) {
                        continue;
                    }
                    errorsFound = true;

                    // highlight corresponding input field
                    var searchKey = key.replace(/\[/g, '\\[').replace(/\]/g, '\\]');
                    var e = $('input[name=' + searchKey + '],textarea[name=' + searchKey + ']');
                    if (!focused) {
                        e.focus();
                        focused = true;
                    }
                    if (e.length != 1) {
                        throw "One input element has to be present for parameter [" + key + "], while " + e.length + " found.";
                    }
                    e.addClass("invalid");

                    if (message != '') {
//                        var label_id = key + "_error";
                        if ($('#' + searchKey + "_error").length == 0) {
                            $('<br/><span id="' + key + "_error" + '" class="validation-error">' + message + '</span>').insertAfter(e);
                        } else {
                            $('#' + searchKey + "_error").html(message);
                        }
                    }
                }
            }
            return errorsFound;
        },


        init: function(root) {
            root = $(root);
            root.find('input.watermark').each(function(i) {
                $(this).Watermark($(this).attr('title'));
            });

//            root.find('input.text-limit').keyup(function() {
//                var text = $(this).val();
//                var limit = $(this).attr('textLimit');
//                if (text.length > limit) {
//                    text = text.substring(0, limit);
//                    $(this).val(text);
//                }
//            });

            // remove watermarks before form is submitted
            root.find('form.with-watermark').submit(function (){
                $.Watermark.HideAll();
                return true;
            });
        },

        position_tooltip: function(trigger, tip) {
            var window_x = trigger.offset().left - $(window).scrollLeft();
            var window_y = trigger.offset().top - $(window).scrollTop();

            var available_left = window_x;
            var available_right = $(window).width() - window_x - trigger.width();
            var available_top = window_y;
            var available_bottom = $(window).height() - window_y - trigger.height();

            var x, y;
            var margin = 20;
            // now, find the best side to present content
            if (Math.max(available_left, available_right) * tip.height()
                    > Math.max(available_top, available_bottom) * tip.width()) {
                if (available_left > available_right) {
                    x = -tip.width() - margin;
                } else {
                    x = trigger.width() + margin;
                }
                y = ($(window).height() - tip.height()) / 2.0 - window_y;
//                console.log('do x, y : ' + y);
                if (y > trigger.height()) {
                    y = trigger.height();
                } else if (y < -tip.height()) {
                    y = -tip.height();
                }
            } else {
                if (available_top > available_bottom) {
                    y = -tip.height() - margin;
                } else {
                    y = trigger.height() + margin;
                }
                x = ($(window).width() - tip.width()) / 2.0 - window_x;
//                console.log('do y, x : ' + x);
                if (x > trigger.width()) {
                    x = trigger.width();
                } else if (x < -tip.width()) {
                    x = -tip.width();
                }
            }

//            console.log(x + '   ' + y + '  ---  ' + trigger.width() + ' ' + trigger.height() + '  ---  ' + tip.width() + ' ' + tip.height());
            tip.css({
                position: 'absolute',
                top: y,
                left: x
            });
        },

        show_tooltip: function(trigger, tip) {
            // remove closing timer, if necessary
            if (tip.data('timeout-var') != null) {
                clearTimeout(tip.data('timeout-var'));
                tip.data('timeout-var', null);
            }

//            common.position_tooltip(trigger, tip);

            // close all other tips
            $('div.tooltip-content').hide();

            tip.show();
            common.position_tooltip(trigger, tip);
        },

        hide_tooltip: function(tip) {
            var t = setTimeout(function() {
                tip.hide();
                tip.data('timeout-var', null);
            }, 500);
            tip.data('timeout-var', t);
        }
    };


    String.prototype.startsWith = function(str) {
        return this.indexOf(str) === 0;
    };

    String.prototype.endsWith = function(str) {
        return this.match(str + "$") == str;
    };

    $(document).ready(function() {
        common.clearValidationErrors();
        common.validationErrors(validation_errors);
    });


    $(document).ready(function() {
        common.init(document);
    });

    jQuery.fn.dataTableExt.oSort['percent-asc']  = function(a,b) {
        var x = (a == "-") ? 0 : a.replace( /%/, "" );
        var y = (b == "-") ? 0 : b.replace( /%/, "" );
        x = parseFloat( x );
        y = parseFloat( y );
        return ((x < y) ? -1 : ((x > y) ?  1 : 0));
    };

    jQuery.fn.dataTableExt.oSort['percent-desc'] = function(a,b) {
        var x = (a == "-") ? 0 : a.replace( /%/, "" );
        var y = (b == "-") ? 0 : b.replace( /%/, "" );
        x = parseFloat( x );
        y = parseFloat( y );
        return ((x < y) ?  1 : ((x > y) ? -1 : 0));
    };
}

