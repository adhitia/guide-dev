if (!window._cal) {
    _cal = {
        render_calendar: function(target_id, id, style, day) {
            if (jQuery().qtip) {
                $('#' + target_id + ' td.tip').qtip("destroy");
            }
            $('#' + target_id).html('');

            $.ajax({
                url: '/guides/' + id + '/' + style,
                type: 'GET',
                data: {
                    'day' : day,
                    'target_id' : target_id
                },
                dataType: 'jsonp',
                success: function(res) {
                    $('#' + target_id).html(res);
                },
                error: function(r, s, e) {
                    $('#' + target_id).html('error has occurred');
                }
            });
        },


        vote: function(el) {
            var root = $(el).parents('.guiderer')[0];
            var id = $(root).attr('cal_id');
            var vote = $(el).attr('title');

            $.ajax({
                url: '/guides/' + id + '/vote/' + vote,
                type: 'GET',
                dataType: 'jsonp',
                success: function() {
                    $(root).find('.inner').addClass('voted').css('width', vote * 20);
                },
                error: function(r, s, e) {
                }
            });
        }
    }
}


$(document).ready(function() {
    $(window).load(function(){
        _guiderer.render_all(document);
    });
});


if (!window._guiderer) {
    _guiderer = {
        render_all: function(root) {
            $(root).find('.guiderer').each(function(index) {
                _guiderer.render(this);
            })
        },

        render: function(target, day) {
            target = $(target);
            if (!target.hasClass('guiderer')) {
                target = target.parent('.guiderer');
            }

            var id = target.attr('guide_id');
            var style = target.attr('guide_style');

            if (jQuery().qtip) {
                target.find('td.tip').qtip("destroy");
            }
//            target.html('');

            $.ajax({
                url: '/guides/' + id + '/' + style,
                type: 'GET',
                data: {
                    'day' : day//,
//                    'target_id' : target_id
                },
                dataType: 'jsonp',
                success: function(res) {
                    target.html(res);
                },
                error: function(r, s, e) {
                    target.html('error has occurred');
                }
            });
        },


        vote: function(el) {
            var root = $(el).parents('.guiderer')[0];
            var id = $(root).attr('cal_id');
            var vote = $(el).attr('title');

            $.ajax({
                url: '/guides/' + id + '/vote/' + vote,
                type: 'GET',
                dataType: 'jsonp',
                success: function() {
                    $(root).find('.inner').addClass('voted').css('width', vote * 20);
                },
                error: function(r, s, e) {
                }
            });
        }
    };
}