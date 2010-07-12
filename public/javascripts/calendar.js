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
    } 
};


$(document).ready(function() {
    $("#edit_calendar_tabs").tabs({
        ajaxOptions: {
            error: function(xhr, status, index, anchor) {
            }
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
});
