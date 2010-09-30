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
    if (window.jQuery == undefined || jQuery().qtip == undefined) {
        load_javascript(server + 'jquery/jquery.qtip-1.0.0-rc3.js');
    }
    if (window.addthis == undefined) {
        load_javascript('http://s7.addthis.com/js/250/addthis_widget.js#username=xa-4ca2e698028f31e3');
    }
    load_css(server + 'public.css?_version=1');


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
                addthis.toolbox(this, {}, share_config);
//                addthis.button(this, {}, share_config);
            });

            root.find('div.guide-tip-body').each(function() {
                $(this).qtip({
                    content: $(this).find('.full_tip').html(),
                    hide: {
                        delay: 500,
                        fixed: true
                    },
                    style:  {
                        width: {
                            max: 500,
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
    _guiderer.server = server;


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

