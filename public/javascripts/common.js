
if (!window.common) {
    $.ajaxSetup({
        beforeSend: function(request) {
//            alert(this.url);
//            common.parseParameters();
//
//            if (this.type == 'GET' && common.params.userId)
//                request.open(this.type, this.url + (this.url.indexOf('?') < 0 ? '?' : '&') + "userId=" + common.params.userId, this.async);

        },
        error: function(event, request, options, error) {
//            alert(event.status);
            switch (event.status) {
//                case 503: common.setLocation('maintenance'); break;
//                case 404: common.setLocation('not-found'); break;
                case 401: common.setLocation('/unauthenticated'); break;
                case 403: common.setLocation('/unauthorized'); break;
                case 500: common.setLocation('/error'); break;
            }
        }
    });



    var common = {
        setLocation: function (location) {
            if (window.location.href.indexOf(location) < 0)
                window.location.replace(location);
        },

        setLoading: function(container, text) {
//            $(container).html('<!--<div style="text-align:center;"><img src="/images/loading-indicator.gif"></div>-->');
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
                    content: '<img style="max-width:230px;max-height:230px" src="' + $(this).attr('full_url') + '" alt="Loading..." />',
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

        setLoadingGlobal: function() {
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
        }
    };


    String.prototype.startsWith = function(str) {
        return this.indexOf(str) === 0;
    };

    String.prototype.endsWith = function(str) {
        return this.match(str + "$") == str;
    };

    $(document).ready(function() {
//        alert(validation_errors);
        $('.validation-error').html();
        
        if (validation_errors != null) {
            for (var key in validation_errors) {
                var message = validation_errors[key];
                if (message == null) {
                    continue;
                }

                // highlight corresponding input field
                var e = $('input[name=' + key.replace(/\[/g, '\\[').replace(/\]/g, '\\]') + ']');
                if (e.length != 1) {
                    throw "1One input element has to be present for parameter [" + key + "], while " + e.length + " found.";
                }
                e.addClass("invalid");

                if (message != '') {
                    var label_id = key + "_error";
                    if ($('#' + label_id).length == 0) {
                        $('<br/><span id="' + label_id + '" class="validation-error">' + message + '</span>').insertAfter(e);
                    } else {
                        $('#' + label_id).html(message);
                    }
                }
            }
        }
    });


    $(document).ready(function() {
        $('input.watermark').each(function(i) {
            $(this).Watermark($(this).attr('title'));
        });
    });

}

