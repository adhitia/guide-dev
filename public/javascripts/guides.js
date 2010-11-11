if (!window.guide) var guide = {
    /*updateTile: function(tile) {
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
    },*/

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
        
        var form = $('#edit_tips form.update-guide-form');
        form.find('.param_access_type').val(public);
        common.setLoadingGlobal('Saving...');

        $(target).button('disable');
        form.ajaxSubmit({
            success: function() {
                common.stopLoadingGlobal();
                $(target).parent().find('.current-access-type').html(public ? 'Public' : 'Private');
                $('#guide_active').button('option', 'label', 'Make this guide ' + (public ? 'private' : 'public'));
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
    },

    closeTip: function() {
        var root = $(this).closest('div.edit-tip-root');
        if (root.hasClass('new-tip-container')) {
            var edit_area = root.find('div.edit-area');
            edit_area.slideUp(500, function() {
                root.removeClass('full');
            });
        } else {
            var edit_form = root.find('form.tip-form');
            $('#edit-tip-container').slideUp(300, function() {
                $('#global-overlay').hide();
                edit_form.appendTo(root);
            });
        }
    },

    createTip: function() {
        var root = $(this).closest('div.edit-tip-root');
        var edit_area = root.find('div.edit-area');

        common.setLoading(root, 'Creating tip...');

        root.find('form').ajaxSubmit({
            type: 'POST',
            cache: false,
            iframe: true,
            dataType: "html",
            success: function(response) {
                response = $(response);
                var target = $('#tips-matrix' +
                               ' div.day-group[data-day=' + response.data('day') + ']' +
                               ' div.condition-group[data-condition=' + response.data('condition-id') + ']');
//                console.log(response.hasClass('edit-tip-tile'));
                common.stopLoading(root);
                guides.closeTip.apply(root);

                target.append(response);
                tips.init(response);

                response.css('background-color', 'yellow');
                setTimeout(function() {
                    response.animate({backgroundColor: '#7fffd4'}, 2000);
                }, 3000);
                guide.saveMatrix();

                $.Watermark.HideAll();
                root.find('input.tip-name').val('');
                $.Watermark.ShowAll();
            }
        });
    },

    updateTip: function() {
        var form = $(this).closest('.tip-form');
        var edit_area = form.find('div.edit-area');
        var tile = form.data('origin-tip');
        var overlay = $('#global-overlay');
        var container = $('#edit-tip-container');

        tile.data('state', 'saving');
        var view = tile.find('div.view');
        view.html('');
        var img = $('<img>').attr('src', '/images/loading-indicator.gif').addClass('tip-icon').attr('align', 'left');
        view.append(img).append('<i>Saving...</i>');

        form.ajaxSubmit({
            type: 'POST',
            cache: false,
            iframe: true,
            dataType: "html",
            success: function(result) {
                result = $(result);
                tile.replaceWith(result);
//                result.data('state', 'ready');
                tips.init(result);
//                result.css('background-color', 'gold');
                //#4E1402
            }
        });
        container.slideUp(300, function() {
            overlay.hide();
            form.appendTo(tile);
        });
    },


    // saves current position of all tips, adding or removing columns if necessary
    saveMatrix: function() {

        var process = function() {
            --to_delete;
            if (to_delete > 0) {
                return;
            }

            // add another column, if the last one isn't empty
            $('#tips-matrix div.day-group:last').each(function() {
                var last = $(this);
                var day = last.data('day');
                if ($('#tips-matrix div.day-group').length < 5 && last.find('div.edit-tip-tile').length > 0) {
                    var new_day = last.clone(false);
                    new_day.find('div.edit-tip-tile').remove();
                    new_day.hide().appendTo($('#tips-matrix')).fadeIn(1000);
                    tips.init(new_day);
                }
            });

            // 'fix' column numbering
            $('#tips-matrix div.day-group').each(function(i) {
                $(this).data('day', i);
                $(this).attr('data-day', i);
                $(this).find('div.day-header').text('Day ' + (i + 1));
            });

            // send matrix data to the server
            var data = {};
            $('#tips-matrix').find('div.edit-tip-tile').each(function() {
                var tile = $(this);
                var day = tile.closest('.day-group').data('day');
                var condition = tile.closest('.condition-group').data('condition');
                if (data[day] == undefined) {
                    data[day] = {};
                }
                if (data[day][condition] == undefined) {
                    data[day][condition] = [];
                }
                data[day][condition].push(tile.data('id'));
            });

            $.ajax({
                url: '/guides/' + $('#edit_tips').data('id') + '/update_matrix',
                data: {data: data},
                cache: false
            });
        };



        // finish 'visually' deleting empty columns first,
        // then call 'process' for main logic 
        var to_delete = 0;
        $('#tips-matrix div.day-group:not(:last)').each(function() {
            var e = $(this);
            if (e.find('div.edit-tip-tile').length == 0) {
                ++to_delete;
                e.fadeOut(500, function() {
                    e.remove();
                    process();
                });
            }
        });
        if (to_delete == 0) {
            process();
        }
    },

    loadTipSuggestions: function(root) {
        root = $(root).closest('div.edit-tip-root');
        var edit_area = root.find('div.edit-area');

        $.Watermark.HideAll();
        var name_element = root.find('input.tip-name');
        var name = $.trim(name_element.val());
        $.Watermark.ShowAll();

        var target_local = root.find('div.autosuggestions');
        var target_images = root.find('div.image-selection-area div.google-suggestions > div.content');
        if (common.empty(name)) {
            return;
        }

        if (!root.hasClass('full')) {
            // here we actually close edit area
            root.addClass('full');
            edit_area.slideDown(500, function() {});
        }

        if ($.trim(name_element.data('last-search')) == name) {
            return;
        }
        name_element.data('last-search', name);

        common.setLoading(target_local, 'Loading suggestions...', edit_area);
        common.setLoading(target_images, 'Loading image suggestions...', edit_area);

        var city = $('#edit_tips').attr('data-city');
        var ls = new google.search.LocalSearch();
        ls.setCenterPoint(city);
        ls.setResultSetSize(8);
        ls.setSearchCompleteCallback(root, guide.processLocalSearchResults, [ls, root]);
        ls.execute(name);

        var is = new google.search.ImageSearch();
        is.setResultSetSize(7);
        is.setSearchCompleteCallback(this, guide.processImageSearchResults, [is, root]);
        is.execute(name + ' ' + city);
    },

    processLocalSearchResults: function(searcher, root) {
        var container = root.find('div.autosuggestions');
        common.stopLoading(container);
        container.html('');
        if (searcher.results && searcher.results.length > 0) {
            var body = $('<div></div>').addClass('autosuggestions-body');
            body.append('Select to prefill other fields<br/>');
            var list = $('<ul></ul>');
            container.append(body);
            body.append(list);
            for (var i = 0; i < searcher.results.length; i++) {
                var result = searcher.results[i];
                var a = $('<a></a>').attr('href', 'javascript:')
                        .text(result.titleNoFormatting)
                        .append($('<span></span>').addClass('address').text(' - ' + result.streetAddress))
                        .attr('title', result.streetAddress)
                        .click(guides.selectLocalResult);
                list.append($('<li></li>').append(a));

                a.data('result_url', result.url);
                if (result.phoneNumbers && result.phoneNumbers.length > 0) {
                    a.data('result_phone', result.phoneNumbers[0].number);
                }
                a.data('title', result.titleNoFormatting);
                a.data('local_result_address', result.streetAddress);
                a.data('local_result_lat', result.lat);
                a.data('local_result_lng', result.lng);
            }
//            for (x in searcher.results[0]) {
//                console.log(x + ' :  ' + searcher.results[0][x]);
//            }
//            console.log('html :  ' + $(searcher.results[0].html).html());
//            $('#map-test').append(searcher.results[0].html);
        } else {
            container.append('no results found');
        }
    },

    selectLocalResult: function() {
        var result = $(this);
        var root = result.closest('div.edit-tip-root');
        var container = result.closest('div.autosuggestions');

        var addr = result.data('local_result_address');
        var lat = result.data('local_result_lat');
        var lng = result.data('local_result_lng');
        var google_url = result.data('result_url');
        var phone = result.data('result_phone');
        if (phone != null && phone.startsWith('(0xx)')) {
            phone = phone.substring('(0xx)'.length);
        }
        var title = result.data('title');


        root.find('input.tip_address_street').val(addr);
        root.find('input.tip_address_lat').val(lat);
        root.find('input.tip_address_lng').val(lng);
        root.find('input.tip_phone').val(phone);
        common.set_value($(root).find('input.tip-name'), title);

//        root.find('input.tip_url').val('loading...');
        root.find('input.tip_url').attr('disabled', true).val('loading...');
//        root.find('button.tip-save').attr('disabled', true);
//        root.find('button.tip-cancel').attr('disabled', true);


        // fetch website url
//        common.setLoading(container, 'Loading...');
        $.ajax({
            url: '/fetch_gmaps_data',
            data: {'url' : google_url},
            type: 'GET',
            cache: false,
            dataType: "html",
            success: function(r) {
                root.find('input.tip_url').attr('disabled', false);
//                root.find('button.tip-save').attr('disabled', false);
//                root.find('button.tip-cancel').attr('disabled', false);

                r = $(r);
//                console.log(r[0]);
//                console.log($('.pp-authority-page a').length);
//                console.log(r.find('title'));
//                console.log(r.find('body'));
                var url = r.find('.pp-authority-page a').attr('href');
                if (url == null) {
                    url = google_url;
                } else {
                    var re = new RegExp("q=[^&]+&");
                    url = re.exec(url).toString();
                    url = url.substr(2, url.length - 3);
                }
                r.remove();

                root.find('input.tip_url').val(url);
            },
            error: function(a, b, c) {
                root.find('input.tip_url').attr('disabled', false).val('');
//                root.find('button.tip-save').attr('disabled', false);
//                root.find('button.tip-cancel').attr('disabled', false);
            }
        });
    },

    processImageSearchResults: function(searcher, root) {
        var container = $(root).find('div.google-suggestions > div.content');
        common.stopLoading(container);
        container.html('');
        if (searcher.results && searcher.results.length > 0) {
            container.append('<input type="hidden" class="tip_image_url" name="tip[image_url]">');

            var n = searcher.results.length;
            for (var i = 0; i < n; ++i) {
                var result = searcher.results[i];
                var img = $('<img/>').addClass('google_image').attr('src', result.tbUrl);
                img.bind('click', {url: result.url}, function(event) {
                    guide.selectGoogleImage($(this), event.data.url);
                });
                var element = $('<div></div>').addClass('full-image').attr('full_url', result.url).append(img);
                container.append(element);
            }
        } else {
            container.html('No results found, check spelling.');
        }
        common.imageHelper(container);
    },

    selectGoogleImage: function(img, url) {
        var root = img.closest('div.google-suggestions').find('div.content');
        if (img.parent().hasClass('selected')) {
            root.find('div').removeClass('selected');
            root.find('.tip_image_url').val('');
        } else {
            root.find('div').removeClass('selected');
            img.parent().addClass('selected');
            root.find('.tip_image_url').val(url);
        }
    }/*,

    init: function(root) {
        // tips edit page
        if ($('#edit_tips').length > 0) {
        }
    }*/
};

// have some 'aliases' for old code
window.calendar = window.guide;
window.guides = window.guide;

$(document).ready(function() {
    // show tabs on edit calendars page
    if ($("#edit_calendar_tabs").length > 0) {
        /*
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
                var url = $.data(ui.tab, 'load.tabs');
                var current = $('#edit_calendar_tabs').tabs('option', 'selected');
//                if (url == 'toggle-tabs') {
                    // disabled for now
//                    var name = $(ui.tab).attr('target');
//                    calendar.selectTab(name);
//                    return false;
//                }
                if (!$(ui.tab).data('saved')) {
                    $(ui.tab).data('saved', true);
                    tips.saveTab('edit_tips_form', function() {
                        common.setLoading(ui.panel);
//                        $(ui.tab).data('saved', false);
                    });
                }
            },
            show: function(event, ui) {
                window.location.hash = ui.tab.hash;
            }
        });

        $('#edit_calendar_tabs .edit-calendar-tabs-conditions li').each(function() {
            $(this).addClass('hidden');
        });
        calendar.selectTab(common.getHash());
*/
        //
        /*$("#edit_calendar_tabs > ul").fpTabs("div.tab-content", {
//            history: true,
            onClick: function(event, tabIndex) {
                tips.init($('div.tab-content'));
                window.location.hash = this.getCurrentTab().attr('title');
            },
            onBeforeClick: function(event, tabIndex) {
                var form = $('#edit_tips_form');
                if (form.length > 0 && !form.data('saved')) {
//                    alert('saving...');
                    form.data('saved', true);
                    var tabs = this;
                    tips.saveTab('edit_tips_form', function() {
                        tabs.click(tabIndex);
                    });

                    return false;
                }
            },
            effect: 'ajax'
        });
        guide.selectTab(common.getHash());*/
    }
});
