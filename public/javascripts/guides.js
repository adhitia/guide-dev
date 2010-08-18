if (!window.calendar) var calendar = {
    toggleTabs: function() {
        $("#edit_calendar_tabs .ui-tabs-nav li").each(function() {
            $(this).toggleClass('hidden');
        });
    },

    selectTab: function(name) {
        var a = $('#edit_calendar_tabs .ui-tabs-nav a[title="' + name.replace(/_/g, ' ') + '"]');
        if (a.parent().hasClass('hidden')) {
            calendar.toggleTabs();
        }
        a.click();
    },

    selectNext: function() {
        var current = $('#edit_calendar_tabs').tabs('option', 'selected');
        $('#edit_calendar_tabs').tabs('select', current + 1);
    },

    updateTile: function(tile) {
        $.ajax({
            url: '/occurrences/' + tile.attr('place_id') + '/tile',
            cache: false,
            dataType: "html",
            success: function(r) {
                var parent = tile.parent();
                tile.replaceWith(r);
                tips.init(parent);
            }
        });
    },

    editGuideLocation: function(root) {
        $(root).find('.view-area').hide();
        $(root).find('.edit-area').show();
    },

    resetGuideLocation: function(root) {
        $(root).find('.view-area').show();
        $(root).find('.edit-area').hide();
    },

    locationInput: function(input, callback) {
        input = $(input);
        input.autocomplete({
            source: function(term, callback) {
                common.setLoading($('.location-loading'), 'Loading...');
                $.ajax({
                    url: '/check_location',
                    data: term,
                    cache: false,
                    dataType: "json",
                    success: function(r) {
                        $('.param_location_code').val('');
                        common.stopLoading($('.location-loading'));
                        if (r.length == 0) {
                            r = [{
                                label : "No result found. <br/>" +
                                          "Please ensure that full word is entered, <br/>" +
                                          "like <b>New</b> or <b>New York</b>, but not <b>New Yo</b>.",
                                id : 'no_result'
                            }];
                        }
                        callback(r);
                    }
                });
            },
            delay: 1000,
            focus: function(event, ui) {
                return ui.item.id != 'no_result';
            },
            change: function(event, ui) {
                callback(input, null);
            },
            select: function(event, ui) {
                if (ui.item.id == 'no_result') {
                    callback(input, null);
                    return false;
                }

                callback(input, ui.item);
            },

            minLength: 2
        });


//        input.autocomplete('/check_location', {
//            delay: 1000,
//            minChars: 3,
//            mustMatch: true,
//            cacheLength: 1,
//            matchSubset: false
//        });
//        input.result(function(event, data, formatted) {
//            alert(data[0] + " : " + data[1]);
//            calendar.resetGuideLocation(input);
//        });
    }
};


$(document).ready(function() {
    // show tabs on edit calendars page
    if ($("#edit_calendar_tabs").length > 0) {
        $("#edit_calendar_tabs").tabs({
            ajaxOptions: {
                //            error: function(xhr, status, index, anchor) {
                //            }
            },
            load: function(event, ui) {
                $('.ui-tabs-hide').html('');
                tips.init(ui.panel);
            },
            select: function(event, ui) {
                var url = $.data(ui.tab, 'load.tabs');
                if (url == 'toggle-tabs') {
                    var name = $(ui.tab).attr('target');
                    calendar.selectTab(name);
                    return false;
                }
                common.setLoading(ui.panel);
            },
            show: function(event, ui) {
                window.location.hash = ui.tab.hash;
            }
        });

        $('#edit_calendar_tabs .edit-calendar-tabs-conditions li').each(function() {
            $(this).addClass('hidden');
        });
        calendar.selectTab(common.getHash());
    }

    // initialize autocomplete for locations
//    $('.location-input').each(function(i, e) {calendar.locationInput(e);});

    // tips view page
//    tips.init($('#view_tips'));
    /*
    if ($('#view_tips').length > 0) {

        // remove tip handler
        $('#view_tips .tip-tile .delete-tip').click(function() {
            var root = $(this).parents('.tip-tile');
            var place_id = root.attr('place_id');
            var calendar_id = root.attr('calendar_id');
            common.confirm('Are you sure you want to delete this tip?', function() {
                common.setLoading(root[0]);
                $.ajax({
                    url: '/occurrences/' + place_id + '/unbind',
                    cache: false,
                    dataType: "text",
                    success: function() {
                        root.replaceWith('<div class="no-tip">no tip</div>');
                    }
                });
            });
        });

        // drag'n'drop
        // workaround for the case when editing is not accessible
        if ($('.move-tip').length > 0) {
            $('#view_tips .tip-tile').draggable({
                handle: '.move-tip',
                revert: 'invalid'
            });
        }
        $("#view_tips .tip-tile").droppable({
            hoverClass: 'droppable-active',
            drop: function(event, ui) {
                var container_from = ui.draggable.parent();
                var container_to = $(this).parent();

                var place_id = ui.draggable.attr('place_id');
                var target_id = $(this).attr('place_id');

                // TODO move elements slowly
                ui.draggable.appendTo(container_to);
                $(this).appendTo(container_from);
                ui.draggable.css('left', 0).css('top', 0);

                common.setLoadingGlobal();
                $.ajax({
                    url: '/occurrences/' + place_id + '/switch',
                    data: {'target_id' : target_id},
                    cache: false,
                    dataType: "text",
                    success: function() {
                        common.stopLoadingGlobal();
                    }
                });
			}
        });
        $("#view_tips .no-tip").droppable({
            hoverClass: 'droppable-active',
            drop: function(event, ui) {
                var container_from = ui.draggable.parent();
                var container_to = $(this).parent();

                var place_id = ui.draggable.attr('place_id');
                var condition_id = container_to.attr('condition_id');
                var day_id = container_to.attr('day_id');

                // TODO move elements slowly
                ui.draggable.appendTo(container_to);
                $(this).appendTo(container_from);
                ui.draggable.css('left', 0).css('top', 0);

                common.setLoadingGlobal();
                $.ajax({
                    url: '/occurrences/' + place_id + '/move',
                    data: {'condition_id' : condition_id, 'weekday_id' : day_id},
                    cache: false,
                    dataType: "text",
                    success: function() {
                        common.stopLoadingGlobal();
                    }
                });
			}
        });

        $('#view_tips .view-tip').overlay({
            effect: 'apple',
            closeOnClick: true,
            closeOnEsc: true,
            onLoad: function() {
                var wrap = this.getOverlay().find('.content');
                common.setLoading(wrap);
                $.ajax({
                    url: this.getTrigger().attr("href"),
                    cache: false,
                    dataType: "html",
                    success: function(r) {
                        wrap.html(r);
                    }
                });
            }
        });
        $('#view_tips .edit-tip').overlay({
            mask: {
                color: 'grey',
                loadSpeed: 200,
                opacity: 0.5
            },
            effect: 'apple',
            closeOnClick: false,
            closeOnEsc: false,
            onLoad: function() {
                var wrap = this.getOverlay().find('.content');
                common.setLoading(wrap);
                $.ajax({
                    url: this.getTrigger().attr("href"),
                    cache: false,
                    dataType: "html",
                    success: function(r) {
                        wrap.html(r);
                        tips.init(wrap);
                    }
                });
            }
        });
    }*/
});
