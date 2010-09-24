
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
            return s.replace(/^\s+|\s+$/g, '');
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

            root.find('input.text-limit').keyup(function() {
                var text = $(this).val();
                var limit = $(this).attr('textLimit');
                if (text.length > limit) {
                    text = text.substring(0, limit);
                    $(this).val(text);
                }
            });

            // remove watermarks before form is submitted
            root.find('form.with-watermark').submit(function (){
                $.Watermark.HideAll();
                return true;
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
        common.clearValidationErrors();
        common.validationErrors(validation_errors);
    });


    $(document).ready(function() {
        common.init(document);
    });
}

