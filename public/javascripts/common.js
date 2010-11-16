
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
            console.log('test');
            alert("error " + event.status);
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

        setLoading: function(target, text, container) {
            if (text == null || text == undefined) {
                text = '';
            }
            if (container == undefined) {
                container = $('body');
            }

            var img = $('<img>').attr('src', '/images/loading-indicator.gif');
            var caption = $('<span></span>').append(img).append('<br/>').append(text).css({
                width: '150px'
            });
            caption.css({
                top: (target.height() - 100)/2,
                left: (target.width() - 150)/2
            });

            var e = $('<span></span>').addClass('loading-indicator').append(caption);
            e.css({
                top: target.offset().top - container.offset().top,
                left: target.offset().left - container.offset().left,
                width: target.width(),
                height: target.height()
            });

            target.addClass('loading-element');
            container.append(e);
            target.data('loading-indicator', e);
        },

        stopLoading: function(container) {
            container = $(container);
            if (container.data('loading-indicator') != null) {
                container.data('loading-indicator').remove();
                container.data('loading-indicator', null);
                container.removeClass('loading-element');
            }
//            $(container).show();
//            $(container).html('');
        },

        /**
         * Provides overlay with full image to view.
         */
        imageHelper: function(root) {
            $(root).find('.full-image').each(function() {
                var tooltip = $('<div class="image-tooltip"><img style="max-width:230px;max-height:230px;" src="' + $(this).attr('full_url') + '" alt="Image is not accessible." /></div>');
//                tooltip.hide().appendTo($(this));
                tooltip.hide().appendTo($('body'));
                common.tooltip($(this), tooltip, {});

                /*$(this).qtip({
                    content: '<div style="width:230px;height:230px;"><img style="max-width:230px;max-height:230px;" src="' + $(this).attr('full_url') + '" alt="Loading..." /></div>',
                    position: {
                        adjust: {
                            screen: true // Keep the tooltip on-screen at all times
                        }
                    },
                    width: {
                        max: 500
                    }
                });*/
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
//            return s == null || common.trim(s) == '';
            return s == null || /^\s*$/.test(s);
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

        validationErrors: function(errors, root) {
            if (!root) {
                root = $(document);
            }
            var errorsFound = false;
            if (errors != null) {
                if (typeof errors == "string") {
                    // when response is string, check if it's in JSON format and has errors data
                    if (!errors.startsWith('{')) {
                        return false;
                    }
                    errors = eval('(' + errors + ')').errors;
                    if (!errors) {
                        return false;
                    }
                }

                var focused = false;
                for (var key in errors) {
                    var message = errors[key];
                    if (message == null) {
                        continue;
                    }
                    errorsFound = true;

                    // highlight corresponding input field
                    var searchKey = key.replace(/\[/g, '\\[').replace(/\]/g, '\\]');
                    var e = root.find('input[name=' + searchKey + '],textarea[name=' + searchKey + ']');
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
                        var error_class = searchKey + '_error';
                        if (root.find('span.' + error_class).length == 0) {
                            $('<br/><span class="validation-error ' + error_class + '">' + message + '</span>').insertAfter(e);
                        } else {
                            root.find('span.' + error_class).html(message);
                        }
                    }
                }
            }
            return errorsFound;
        },


        init: function(root) {
            root = $(root);
            root.find('input.watermark').each(function() {
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

        runOnDelay: function(input, delay, callback) {
            input.keyup(function() {
                if (input.data('search-delay')) {
                    clearTimeout(input.data('search-delay'));
                }
                var t = setTimeout(function() {
                    input.data('search-delay', null);
                    callback(input);
                }, delay);
                input.data('search-delay', t);
            });
        },


        // creates a tooltip when trigger element is hovered
        // currently supported options: on_before_show, on_show, hide_delay
        tooltip: function(trigger, tooltip, options) {
            if (!options) options = {};
            if (!options.hide_delay) {
                // hide tooltip immediately when mouse left by default
                options.hide_delay = 0;
            }

            var position_tooltip = function(trigger, tip) {
                // x and y positions relative to window
                var window_x = trigger.offset().left - $(window).scrollLeft();
                var window_y = trigger.offset().top - $(window).scrollTop();

                // how much space we have in each direction
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
                    if (x > trigger.width()) {
                        x = trigger.width();
                    } else if (x < -tip.width()) {
                        x = -tip.width();
                    }
                }

                tip.css({
                    position: 'absolute',
                    top: y + trigger.offset().top,
                    left: x + trigger.offset().left
                });
            };

            // setup tooltip for each particular tip
            trigger.hover(function() {
                // remove closing timer, if necessary
                if (tooltip.data('hover-timeout-var') != null) {
                    clearTimeout(tooltip.data('hover-timeout-var'));
                    tooltip.data('hover-timeout-var', null);
                }

                position_tooltip(trigger, tooltip);

                if (options.on_before_show) {
                    options.on_before_show(trigger, tooltip);
                }

                tooltip.show();

                if (options.on_show) {
                    options.on_show(trigger, tooltip);
                }
            },
            function() {
                var t = setTimeout(function() {
                    tooltip.hide();
                    tooltip.data('hover-timeout-var', null);
                }, options.hide_delay);
                tooltip.data('hover-timeout-var', t);
            });
        }
    };


    String.prototype.startsWith = function(str) {
        return this.indexOf(str) === 0;
    };

    String.prototype.endsWith = function(str) {
        return this.match(str + "$") == str;
    };

    String.prototype.blank = function() {
        return common.empty(this);
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

