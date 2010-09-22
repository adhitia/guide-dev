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

    selectPrevious: function() {
        var current = $('#edit_calendar_tabs').tabs('option', 'selected');
        $('#edit_calendar_tabs').tabs('select', current - 1);
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

    updateAccessType: function(target) {
        var public = $(target)[0].checked;
        
        var form = $('#view_tips form.update-guide-form');
        form.find('.param_access_type').val(public);
        common.setLoadingGlobal('Saving...');

        $(target).button('disable');
        form.ajaxSubmit({
            success: function() {
                common.stopLoadingGlobal();
                $(target).parent().find('.current-access-type').html(public ? 'Public' : 'Private');
                $(target).button('enable');
            }
        });
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
                alert('!');
                var url = $.data(ui.tab, 'load.tabs');
                if (url == 'toggle-tabs') {
                    // disabled for now
                    var name = $(ui.tab).attr('target');
                    calendar.selectTab(name);
                    return false;
                }
                tips.saveTab('edit_tips_form', null);
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
});
