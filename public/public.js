if (!window._guiderer) {

    _guiderer = {};

    // initialize
    _guiderer.setup_library = function($) {
        _guiderer.render_all = function(root) {
            $(root).find('.guiderer').each(function(index) {
                _guiderer.render(this);
            })
        };

        _guiderer.render = function(target, day) {
            if (target == undefined) {
                throw "Target element must be passed into render.";
            }
            if (!day) {
                day = 0;
            }

            target = $(target);
            if (!target.hasClass('guiderer')) {
                target = target.closest('.guiderer');
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
        };

        _guiderer.init = function(root) {
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

            // setup tooltip for each particular tip
            root.find('div.guide-tip-body').each(function() {
                var trigger = $(this);
                var tooltip = $(this).find('.full_tip');
                _guiderer.tooltip(trigger, tooltip, {
                    hide_delay : 500,
                    on_before_show: function(trigger, tooltip) {
                        // hide all other tooltips
                        $('div.guiderer div.full_tip').hide();
                        $('div.guiderer div.guide-info .tooltip-content').hide();

                        tooltip.find('.twits').each(function() {
                            var twit_area = $(this);
                            if (!twit_area.data('twit_state')) {
                                twit_area.data('twit_state', 'loading');
                                $.ajax({
                                    url: 'http://search.twitter.com/search.json',
                                    data: {
                                        //'result_type': 'popular',
                                        lang: 'en',
                                        'q' : twit_area.attr('data-query')
                                    },
                                    dataType: 'jsonp',
                                    success: function(data) {
                                        twit_area.data('twit_state', 'loaded');
                                        if (data.results.length == 0) {
                                            twit_area.html('no twits');
                                            return;
                                        }

                                        var ul = $('<ul></ul>');
                                        for (var i = 0; i < Math.min(data.results.length, 3); ++i) {
                                            var twit = data.results[i];

                                            // replace urls with links in the text
                                            var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
                                            var text = twit.text.replace(exp, "<a href='$1' target='_blank'>$1</a>");

                                            var user_element = $('<span></span>').addClass('twit-user').text(twit.from_user).append(': ');
                                            var text_element = $('<span></span>').addClass('twit-text').html(text);
                                            ul.append($('<li></li>').append(user_element).append(text_element));
                                        }
                                        twit_area.html(ul);
                                    },
                                    error: function(r, s, e) {
                                        twit_area.html('Failed to load twits.');
                                    }
                                });
                            }
                        });
                    }
                });
            });

            // setup guide info tooltip
            root.find('div.guide-info div.guiderer-logo').each(function() {
                var trigger = $(this);
                var tooltip = $(this).find('.tooltip-content');
                _guiderer.tooltip(trigger, tooltip, {
                    hide_delay : 500,
                    on_before_show: function() {
                        $('div.guiderer div.full_tip').hide();
                        $('div.guiderer div.guide-info .tooltip-content').hide();
                    },

                    on_show: function() {
                        // build map only after tooltip is shown

                        var map_container = tooltip.find('.guide-map');
                        if (!map_container.data('map-state')) {
                            map_container.data('map-state', 'loading');


                            var markers = [];
                            var bounds = new google.maps.LatLngBounds();
                            root.find('.guiderer-data .guiderer-tip-data').each(function() {
                                var el = $(this);
                                var lat = el.attr('data-lat');
                                var lng = el.attr('data-lng');
                                if (lat != '0.0' && !lat.blank()) {
                                    var name = el.attr('data-name');
                                    var point = new google.maps.LatLng(lat, lng);
                                    var marker = new google.maps.Marker({
                                        position: point,
                                        title: name
                                    });
                                    markers.push(marker);
                                    bounds.extend(point);
                                }
                            });

                            if (markers.length == 0) {
                                map_container.hide();
                                return;
                            }
                            map_container.show();
                            var map = new google.maps.Map(map_container[0], {
                                zoom: 11,
                                mapTypeId: google.maps.MapTypeId.ROADMAP
                            });
                            map.fitBounds(bounds);

                            var click_handler = function() {
                                window.location = _guiderer.server + 'guides/' + root.attr('guide_id') + '/map';
                            };

                            for (var i = 0; i < markers.length; ++i) {
                                markers[i].setMap(map);
                                google.maps.event.addListener(markers[i], 'click', click_handler);
                            }
                            google.maps.event.addListener(map, 'click', click_handler);
                        }
                    }
                });
            });
        };


        _guiderer.vote = function(el) {
            var root = $(el).closest('.guiderer');
            var id = root.attr('guide_id');
            if (!id) {
                throw "No guide id found in root element.";
            }
            var server = root.attr('server');
            var vote = $(el).attr('title');

            $.ajax({
                url: server + '/guides/' + id + '/vote/' + vote,
                type: 'GET',
                dataType: 'jsonp',
                cache: false,
                success: function() {
                    root.find('.inner').addClass('voted').css('width', vote * 20);
                },
                error: function(r, s, e) {
                }
            });
        };

        // creates a tooltip when trigger element is hovered 
        // currently supported options: on_before_show, on_show, hide_delay
        _guiderer.tooltip = function(trigger, tooltip, options) {
            if (!options) options = {};
            if (!options.hide_delay) {
                // hide tooltip immediately when mouse left by default 
                options.hide_delay = 0;
            }

            var position_tooltip = function(trigger, tip) {
                // x and y positions relative to window
                var window_x = trigger.offset().left - $(window).scrollLeft();
                var window_y = trigger.offset().top - $(window).scrollTop();

                // how much space we have in each direction
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

            // setup tooltip for each particular tip
            trigger.hover(function() {
                // remove closing timer, if necessary
                if (tooltip.data('hover-timeout-var') != null) {
                    clearTimeout(tooltip.data('hover-timeout-var'));
                    tooltip.data('hover-timeout-var', null);
                }

                position_tooltip(trigger, tooltip);

                if (options.on_before_show) {
                    options.on_before_show(trigger, tooltip);
                }

                tooltip.show();

                if (options.on_show) {
                    options.on_show(trigger, tooltip);
                }
            },
            function() {
                var t = setTimeout(function() {
                    tooltip.hide();
                    tooltip.data('hover-timeout-var', null);
                }, options.hide_delay);
                tooltip.data('hover-timeout-var', t);
            });
        };
    };


    _guiderer.addEvent = function(elm, evType, fn, useCapture) {
        //Credit: Function written by Scott Andrews
        //(slightly modified)
        var ret = 0;

        if (elm.addEventListener) {
            ret = elm.addEventListener(evType, fn, useCapture);
        } else if (elm.attachEvent) {
            ret = elm.attachEvent('on' + evType, fn);
        } else {
            elm['on' + evType] = fn;
        }

        return ret;
    };

    // render all guides once page is loaded
    _guiderer.addEvent(window, "load", function() {
        // fetch location of guiderer server from script tag
        var server = null;
        var scripts = document.getElementsByTagName("script");
        for (var i = 0; i < scripts.length; i++) {
            if (scripts[i].className == 'guiderer-script') {
                server = scripts[i].src.match(/http:\/\/.+\//);
                break;
            }
        }
        if (server == null) {
            server = 'http://guiderer.com/';
        }
        _guiderer.server = server;


        // each 'script' tag will have onload event
        // _guiderer object will be initialized only when last library is loaded
        var left_to_load = 0;
        function init() {
            --left_to_load;
            if (left_to_load > 0) {
                return;
            }

            addthis.init();
            _guiderer.setup_library(jQuery);
            _guiderer.render_all(document);
        }

        // load necessary resources first
        function load_javascript(src, callback) {
            var a = document.createElement('script');
            a.type = 'text/javascript';
            a.src = src;
            var s = document.getElementsByTagName('script')[0];
            s.parentNode.insertBefore(a, s);

            ++left_to_load;
            _guiderer.addEvent(a, 'load', callback, false);
        }

        function load_css(src) {
            var a = document.createElement('link');
            a.rel = 'stylesheet';
            a.type = 'text/css';
            a.href = src;
            document.getElementsByTagName("head")[0].appendChild(a);
        }

        var load_google_apis = function() {
            if (window.google.maps == undefined) {
                ++left_to_load;
                google.load("maps", "3", {'callback': init, 'other_params' : 'sensor=false'});
            }
        };
        if (window.google == undefined) {
            load_javascript('http://www.google.com/jsapi', function() {load_google_apis(); init();});
        } else {
            load_google_apis();
        }
        if (window.jQuery == undefined) {
            load_javascript('http://ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.min.js', init);
        }
        if (window.addthis == undefined) {
            load_javascript('http://s7.addthis.com/js/250/addthis_widget.js#username=guiderer&domready=1', init);
        }
        load_css(server + 'public.css?_version=9');

    }, false);


    // configure addthis globally
//    var addthis_config = {
//        data_track_clickback: false,
//        data_track_linkback: false
//    };
}

