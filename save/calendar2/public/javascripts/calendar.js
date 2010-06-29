if (!window.calendar) var calendar = {
};


$(document).ready(function() {
    $("#edit_calendar_by_weekday").tabs({
        ajaxOptions: {
            error: function(xhr, status, index, anchor) {
                $(anchor.hash).html("Couldn't load this tab. We'll try to fix this as soon as possible. If this wouldn't be a demo.");
            }
        },
        load: function(event, ui) {
            $('.ui-tabs-hide').html('');
            tips.init(ui.panel);
        },
        select: function(event, ui) {
            common.setLoading(ui.panel);
        },
        show: function(event, ui) {
            window.location.hash = ui.tab.hash;
        }
    });
});
