if (!window.common) {
    $.ajaxSetup({
//        error: function(event, request, options, error) {
//            switch (event.status) {
//                case 503: common.setLocation('maintenance.shtml'); break;
//                case 404: common.setLocation('error.shtml'); break;
//                case 401: common.setLocation('unauthenticated.shtml'); break;
//                case 403: common.setLocation('unauthorized.shtml'); break;
//                case 500: common.setLocation('oops.shtml'); break;
//            }
//        }
    });



    var common = {
        setLoading: function(container) {
            $(container).html('<div style="text-align:center;"><img src="/images/loading-indicator.gif"></div>');
        },

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
    });

}