if (!window._cal) {
    _cal = {
        render_calendar : function(target_id, id, style, day) {
            $.ajax({
                url: 'http://0.0.0.0:3000/calendars/' + id + '/' + style,
                type: 'GET',
                data: {
                    'day' : day,
                    'target_id' : target_id
                },
                dataType: 'jsonp',
                success: function(res) {
                    $('#' + target_id).html(res);
                }
            });
        }
    }
}