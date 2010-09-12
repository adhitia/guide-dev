/*

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
*/


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
            if (target == undefined) {
                throw "Target element must be passed into render.";
            }
            if (!day) {
                day = 0;
            }

//            alert(target);
            target = $(target);
            if (!target.hasClass('guiderer')) {
                target = target.parents('.guiderer');
            }
            if (target.length == 0) {
                throw "Can't find adequate target.";
            }

            var id = target.attr('guide_id');
            var style = target.attr('guide_style');
            if (!id || !style) {
                throw "Guide id or style isn't set.";
            }

            if (jQuery().qtip) {
                target.find('td.tip').qtip("destroy");
            }

            $.ajax({
                url: '/guides/' + id + '/' + style,
                type: 'GET',
                data: {
                    'day' : day//,
//                    'target_id' : target_id
                },
                dataType: 'jsonp',
                success: function(res) {
                    var el = $(res);
                    target.html('');
                    target.append(el);
                    _guiderer.init(el);
                },
                error: function(r, s, e) {
                    target.html('error has occurred');
                }
            });
        },

        init: function(root) {
            root.find('div.guide-tip-body').each(function() {
                $(this).qtip({
                    content: $(this).find('.full_tip').html(),
                    hide: {
                        delay: 500,
                        fixed: true
                    },
                    style:  {
                        width: {
                            max: 600,
                            min: 200
                        }
                    },
                    position: {
                        adjust: {
                            screen: true // Keep the tooltip on-screen at all times
                        }
                    }
                });
            });
            root.find('div.guide-info > div.qtip-content').each(function() {
//                alert('!' + $(this).parent().find('div.guiderer-logo').length);
                $(this).parent().find('div.guiderer-logo').qtip({
                    content: $(this).html(),
                    hide: {
                        delay: 500,
                        fixed: true
                    },
                    position: {
                        adjust: {
                            screen: true // Keep the tooltip on-screen at all times
                        }
                    }
                });
            });
        },


        vote: function(el) {
            var root = $(el).parents('.guiderer')[0];
            var id = $(root).attr('guide_id');
            if (!id) {
                throw "No guide id found in root element.";
            }
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

    // initialize guides
    $(document).ready(function() {
        $('div.guiderer').each(function() {
            _guiderer.init($(this));
        });
    });
}

