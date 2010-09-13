$(document).ready(function() {
//    $(document).load(function(){
    alert('!');
        _guiderer.render_all(document);
//    });
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
            var server = target.attr('server');
            if (!id || !style || !server) {
                alert(server);
                throw "Guide id or style or server isn't set.";
            }

            if (jQuery().qtip) {
                target.find('td.tip').qtip("destroy");
            }

            $.ajax({
                url: server + '/guides/' + id + '/' + style,
                type: 'GET',
                data: {
                    'day' : day
                },
                dataType: 'jsonp',
                cache: false,
                success: function(res) {
                    var el = $(res);
                    target.html('');
                    target.append(el);
                    el.load(function() {
                        _guiderer.init(el);
                    });
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
                            screen: true
                        }
                    }
                });
            });
            root.find('div.guide-info > div.qtip-content').each(function() {
                $(this).parent().find('div.guiderer-logo').qtip({
                    content: $(this).html(),
                    hide: {
                        delay: 500,
                        fixed: true
                    },
                    position: {
                        adjust: {
                            screen: true
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
            var server = $(root).attr('server');
            var vote = $(el).attr('title');

            $.ajax({
                url: server + '/guides/' + id + '/vote/' + vote,
                type: 'GET',
                dataType: 'jsonp',
                cache: false,
                success: function() {
                    $(root).find('.inner').addClass('voted').css('width', vote * 20);
                },
                error: function(r, s, e) {
                }
            });
        }
    };

    // initialize guides
//    $(document).ready(function() {
//        $('div.guiderer').each(function() {
//            _guiderer.init($(this));
//        });
//    });
}

