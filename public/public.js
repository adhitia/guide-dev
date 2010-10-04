if (!window._guiderer) {
    // fetch location of guiderer server from script tag
    var server = null;
    var scripts = document.getElementsByTagName("script");
    for (var i = 0; i < scripts.length; i++) {
        if (scripts[i].className == 'guiderer-script') {
            server = scripts[i].src.match(/http:\/\/.+\//);
        }
    }
    if (server == null) {
//        alert(null);
        server = 'http://guiderer.com/';
    }

    // load necessary resources first
    function load_javascript(src) {
        var a = document.createElement('script');
        a.type = 'text/javascript';
        a.src = src;
        var s = document.getElementsByTagName('script')[0];
        s.parentNode.insertBefore(a, s);
    }

    function load_css(src) {
        var a = document.createElement('link');
        a.rel = 'stylesheet';
        a.type = 'text/css';
        a.href = src;
        document.getElementsByTagName("head")[0].appendChild(a);
    }

    if (window.jQuery == undefined) {
        load_javascript('http://ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.min.js');
    }
//    if (window.jQuery == undefined || jQuery().qtip == undefined) {
//        load_javascript(server + 'jquery/jquery.qtip-1.0.0-rc3.js');
//    }
    if (window.addthis == undefined) {
        load_javascript('http://s7.addthis.com/js/250/addthis_widget.js#username=guiderer');
    }
    load_css(server + 'public.css?_version=2');


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
                throw "Guide id or style or server isn't set.";
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
                    target.html('');
                    target.append(res);
                    _guiderer.init(target);
                },
                error: function(r, s, e) {
                    target.html('error has occurred');
                }
            });
        },

        init: function(root) {
            root.find('div.addthis-guide').each(function() {
                var current = $(this);
                var share_config = {};
                share_config.url = current.attr('url');
                share_config.title = current.attr('title');
                if (current.attr('description') != null) {
                    share_config.description = current.attr('description');
                }

                var ui_config = {
                    data_track_clickback: false,
                    data_track_linkback: false
                };

                addthis.toolbox(this, ui_config, share_config);
            });

            var position_tooltip = function(trigger, tip) {
                var window_x = trigger.offset().left - $(window).scrollLeft();
                var window_y = trigger.offset().top - $(window).scrollTop();

                var available_left = window_x;
                var available_right = $(window).width() - window_x - trigger.width();
                var available_top = window_y;
                var available_bottom = $(window).height() - window_y - trigger.height();

                var x, y;
                var margin = 20;
                // now, find the best side to present content
                if (Math.max(available_left, available_right) * tip.height()
                        > Math.max(available_top, available_bottom) * tip.width()) {
                    if (available_left > available_right) {
                        x = -tip.width() - margin;
                    } else {
                        x = trigger.width() + margin;
                    }
                    y = ($(window).height() - tip.height()) / 2.0 - window_y;
                    if (y > trigger.height()) {
                        y = trigger.height();
                    } else if (y < -tip.height()) {
                        y = -tip.height();
                    }
                } else {
                    if (available_top > available_bottom) {
                        y = -tip.height() - margin;
                    } else {
                        y = trigger.height() + margin;
                    }
                    x = ($(window).width() - tip.width()) / 2.0 - window_x;
                    if (x > trigger.width()) {
                        x = trigger.width();
                    } else if (x < -tip.width()) {
                        x = -tip.width();
                    }
                }

                tip.css({
                    position: 'absolute',
                    top: y,
                    left: x
                });
            };

            var show_tooltip = function(trigger, tip) {
                // remove closing timer, if necessary
                if (tip.data('timeout-var') != null) {
                    clearTimeout(tip.data('timeout-var'));
                    tip.data('timeout-var', null);
                }

                position_tooltip(trigger, tip);

                // close all other tips
                $('div.guiderer div.full_tip').hide();

                tip.show();
            };

            var hide_tooltip = function(tip) {
                var t = setTimeout(function() {
                    tip.hide();
                    tip.data('timeout-var', null);
                }, 500);
                tip.data('timeout-var', t);
            };

            // setup tooltip for each particular tip
            root.find('div.guide-tip-body').hover(function() {
                var trigger = $(this);
                var tip = $(this).find('.full_tip');
                show_tooltip(trigger, tip);
            },
            function() {
                var tip = $(this).find('.full_tip');
                hide_tooltip(tip);
            });

            // setup guide info tooltip
            root.find('div.guide-info div.guiderer-logo').hover(function() {
                var trigger = $(this);
                var tip = $(this).find('.tooltip-content');
                show_tooltip(trigger, tip);
            },
            function() {
                var tip = $(this).find('.tooltip-content');
                hide_tooltip(tip);
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
        },

        display_tip: function(trigger, tip) {
            tip.css({'po' : ''});
        }
    };
    _guiderer.server = server;

    var addthis_config = {
        data_track_clickback: false,
        data_track_linkback: false
    };


    function addEvent(elm, evType, fn, useCapture) {
        //Credit: Function written by Scott Andrews
        //(slightly modified)
        var ret = 0;

        if (elm.addEventListener)
            ret = elm.addEventListener(evType, fn, useCapture);
        else if (elm.attachEvent)
            ret = elm.attachEvent('on' + evType, fn);
        else
            elm['on' + evType] = fn;

        return ret;
    }

    // render all guides once page is loaded
    addEvent(window, "load", function() {_guiderer.render_all(document);});


//    $(document).ready(function() {
//         _guiderer.render_all(document);
//    });
}

