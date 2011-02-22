if (!window.guide) var guide = {
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
    },

    closeTip: function() {
        var root = $(this).closest('div.edit-tip-root');
        if (root.hasClass('new-tip-container')) {
            var edit_area = root.find('div.edit-area');
            edit_area.slideUp(500, function() {
                root.removeClass('full');
            });
        } else {
            var edit_form = root.closest('form');
            edit_form.slideUp(300, function() {
                $('#global-overlay').hide();
            });
        }
        common.clearValidationErrors();
    },

    createTip: function() {
        var root = $(this).closest('div.edit-tip-root');
        root.removeClass('stage-3');
        var edit_area = root.find('div.edit-area');

        $.Watermark.HideAll();
        var errors = {};
        if (root.find('input.tip-name').val().blank()) {
            errors[root.find('input.tip-name').attr('name')] = 'required field';
            common.validationErrors(errors, root);
            $.Watermark.ShowAll();
            return;
        }
        $.Watermark.ShowAll();

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
                root.removeClass('stage-3');
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
                root.find('input[type=text]').val('');
                root.find('textarea').val('');
                $.Watermark.ShowAll();

                // show tooltip to suggest that tip is draggable
                if ($('#tips-matrix div.edit-tip-tile').length <= 2) {
                    setTimeout(function() {
                        response.qtip({
                            content: 'Try dragging this tip around to change its location.',
                            show: { ready: true },
                            hide: { when: { event: 'click' } }
                        });
                        response.qtip("show");
                        setTimeout(function() {
                            response.qtip("hide");
                            response.qtip("disable");
                        }, 5000);
                    }, 600);
                }
            }
        });
    },

    updateTip: function() {
        var form = $(this).closest('.tip-form');
        var edit_area = form.find('div.edit-area');
//        var tile = form.data('origin-tip');
        var tile = form.closest('.edit-tip-tile');
        var overlay = $('#global-overlay');
//        var container = $('#edit-tip-container');

        var errors = {};
        if (form.find('input.tip-name').val().blank()) {
            errors[form.find('input.tip-name').attr('name')] = 'required field';
            common.validationErrors(errors, form);
            return;
        }

        tile.data('state', 'saving');
        var view = tile.find('div.view');
        view.html('');
        var img = $('<img>').attr('src', '/images/loading-indicator.gif').addClass('tip-icon').attr('align', 'left');
        view.append(img).append('<i>Saving...</i>');

        form.ajaxSubmit({
            type: 'POST',
            cache: false,
            iframe: true,
            success: function(result) {
                result = $(result);
                tile.replaceWith(result);
                tips.init(result);
            }
        });
        form.slideUp(300, function() {
            overlay.hide();
//            form.appendTo(tile);
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
        root.find('.image-selection-area').css('display', '').css('visibility', '');

        if (root.hasClass('new-tip-container') && !root.hasClass('stage-2') && !root.hasClass('stage-3')) {
            root.addClass('stage-1');
//            root.removeClass('stage-2');
//            root.removeClass('stage-3');
        }

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
        ls.setNoHtmlGeneration();
        ls.execute(name);

        var is = new google.search.ImageSearch();
        is.setResultSetSize(8);
        is.setSearchCompleteCallback(this, guide.processImageSearchResults, [is, root]);
        ls.setNoHtmlGeneration();
        is.execute(name + ' ' + city);
    },

    processLocalSearchResults: function(searcher, root) {
        var container = root.find('div.autosuggestions');
        var name = $.trim(root.find('input.tip-name').val());

        common.stopLoading(container);
        container.html('');

        if (searcher.results && searcher.results.length > 0) {
            var body = $('<div></div>').addClass('autosuggestions-body');
            body.append('Choose correct POI<br/>');
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

                // remove random data from google url, leave only place's id
                var url = result.url;
                var index = url.indexOf('&cid=');
                if (index >= 0) {
                    url = 'http://www.google.com/maps/place?cid=' + url.substring(index + 5);
                }
//                console.log(url);

                a.data('result_url', url);

                if (result.phoneNumbers && result.phoneNumbers.length > 0) {
                    a.data('result_phone', result.phoneNumbers[0].number);
                }
                a.data('title', result.titleNoFormatting);
                a.data('local_result_address', result.streetAddress);
                a.data('local_result_lat', result.lat);
                a.data('local_result_lng', result.lng);
            }
            var skip = $('<a>').attr('href', 'javascript:').text('or skip this step').addClass('skip');
            skip.click(function() {
                root = $(this).closest('div.edit-tip-root');
                root.removeClass('stage-1');
                root.addClass('stage-2');
            });

            body.append(skip);
        } else {
            if (root.hasClass('stage-1')) {
                var skip = $('<a>').attr('href', 'javascript:').text('skip this step');
                skip.click(function() {
                    if (root.hasClass('stage-1')) {
                        root = $(this).closest('div.edit-tip-root');
                        root.removeClass('stage-1');
                        root.addClass('stage-2');
                    }
                });
                container.append('No results found. Try different name or ').append(skip);
            } else {
                container.append('No results found. <a target="_blank" href="http://www.google.com/search?q=' + name + '">Try searching Google</a>');
            }
        }
    },

    selectLocalResult: function() {
        var result = $(this);
        var root = result.closest('div.edit-tip-root');
        var container = result.closest('div.autosuggestions');

        result.closest('ul').find('a').removeClass('selected');
        result.addClass('selected');

        if (root.hasClass('stage-1')) {
            root.removeClass('stage-1');
            root.addClass('stage-2');
        }


        var addr = result.data('local_result_address');
        var lat = result.data('local_result_lat');
        var lng = result.data('local_result_lng');
        var google_url = result.data('result_url');
        var phone = result.data('result_phone');
        if (phone != null && phone.startsWith('(0xx)')) {
            phone = phone.substring('(0xx)'.length);
        }
        var title = result.data('title');


        root.find('input.tip_address').val(addr);
//        console.log(addr + '    ' + root.find('input.tip_address').length);
        root.find('input.tip_lat').val(lat);
        root.find('input.tip_lng').val(lng);
        root.find('input.tip_phone').val(phone);
        root.find('input.tip_google_url').val(google_url);
        common.set_value($(root).find('input.tip-name'), title);

//        root.find('input.tip_url').val('loading...');
        root.find('input.tip_url').attr('disabled', true).val('loading...');
//        root.find('button.tip-save').attr('disabled', true);
//        root.find('button.tip-cancel').attr('disabled', true);

        guide.loadTipSuggestions(root);


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
        if (searcher.results && searcher.results.length > 0) {
            var cursor = searcher.cursor;
//            console.log(cursor.currentPageIndex + '   ' + cursor.pages.length);

            if (cursor.currentPageIndex == 0) {
                container.html('');

                container.append('<input type="hidden" class="tip_image_url" name="tip[image_url]">');
                var scrollable = $('<div></div>').addClass('scrollable');
                var items = $('<div></div>').addClass('items');

                var page = $('<div></div>');
                items.append(page);
                guide.renderGoogleImages(page, searcher);
                items.append('<div></div>');

                scrollable.append(items);
                container.append('<a class="prev left browse"></a>');
                container.append(scrollable);
                container.append('<a class="next right browse"></a>');

                scrollable.scrollable({
                    onSeek: function(event, index) {
                        var page = $(this.getItems()[index]);
                        if (page.find('div').length == 0) {
                            common.setLoading(container, 'Loading more images...', container.closest('div.edit-area'));
                            searcher.gotoPage(searcher.cursor.currentPageIndex + 1);
                        }
                    }
                });
            } else {
                var page = root.find('.scrollable .items > div:last');
                guide.renderGoogleImages(page, searcher);
                if (cursor.currentPageIndex < cursor.pages.length - 1) {
                    var api = page.closest('.scrollable').data('scrollable');
                    api.addItem($('<div></div>'));

                    // fix scrollable bug, de-disable button manually
                    api.getNaviButtons().filter('.right').removeClass('disabled');
                }
            }
        } else {
            container.html('');
//            container.html('No results found, check spelling.');
        }
        common.imageHelper(container);
    },

    renderGoogleImages: function(page, searcher) {
        var n = searcher.results.length;
        for (var i = 0; i < n; ++i) {
            var result = searcher.results[i];
            var img = $('<img/>').addClass('google_image').attr('src', result.tbUrl);
            img.bind('click', {url: result.url}, function(event) {
                guide.selectGoogleImage($(this), event.data.url);
            });
            var element = $('<div></div>').addClass('full-image').attr('full_url', result.url).append(img);
            page.append(element);
        }
//        if (searcher.cursor.currentPageIndex < searcher.cursor.pages.length - 1) {
//            page.closest('.scrollable').data('scrollable').addItem($('<div></div>'));
//        }
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
        var upload = root.closest('.image-selection-area').find('.current-image .file-upload');
        upload.find('.file-name').html('');
        upload.find('input').val('');
        upload.fadeOut();
    },

    init_location_input: function(root) {
        var input_name = root.find('input[name=location_name]');
        var input_code = root.find('input[name=location_code]');
        input_name.data('last', input_name.val());

        input_name.focus(function() {
            this.select();
        });
        input_name.autocomplete({
            source: function(term, callback) {
                var loading = root.find('.location-loading');
                common.setLoading(loading, 'Loading...');
                $.ajax({
                    url: '/check_location',
                    data: term,
                    cache: false,
                    dataType: "json",
                    success: function(r) {
                        $('.param_location_code').val('');
                        common.stopLoading(loading);
                        if (r.length == 0) {
                            r = [{
                                label: "No result found. <br/>" +
                                          "Please ensure that full word is entered, <br/>" +
                                          "like <b>New</b> or <b>New York</b>, but not <b>New Yo</b>.",
                                id: 'no_result'
                            }];
                        }
                        callback(r);
                    }
                });
            },
            delay: 1000,
            focus: function(event, ui) {
//                console.log('focus');
                return ui.item.id != 'no_result';
            },
            change: function(event, ui) {
//                callback(input, null);
//                console.log('change');
                input_name.val(input_name.data('last'));
            },
            select: function(event, ui) {
                if (ui.item.id == 'no_result') {
                    input_name.val(input_name.data('last'));
//                    console.log('select none');
//                    callback(input, null);
                    return false;
                }

//                console.log('select ' + ui.item.label);
                input_name.data('last', ui.item.label);
                input_code.val(ui.item.id);
//                callback(input, ui.item);
            },

            close: function(event, ui) {
//                console.log('close');
                input_name.val(input_name.data('last'));
            },

            minLength: 2
        });
    },

    init_edit_area: function(root) {
        var form = root.find('form');
        var edit_area = root.find('.edit-area');

        // show/hide form when title link is clicked
        root.find('.edit-link').click(function() {
            if (edit_area.is(':hidden')) {
                edit_area.show('slow');
            } else {
                edit_area.hide('slow');
            }
        });

        guide.init_location_input(root.find('.location-input'));

        // how to submit form properly
        form.submit(function() {
            common.setLoading(root, 'Saving changes');

            form.ajaxSubmit({
                success: function(result) {
                    if (result == 'error') {
                        common.setLocation('/error');
                        return;
                    }

                    common.stopLoading(root);
                    if (common.validationErrors(result)) {
                        return;
                    }
//                    if (result.startsWith('{')) {//{"errors":
//                        var errors = eval('(' + result + ')').errors;
//                        common.validationErrors(errors);
//                        return;
//                    }
                    result = $(result);

                    root.replaceWith(result);
                    edit_area = result.find('.edit-area');
                    edit_area.show();
                    guide.init_edit_area(result);

                    edit_area.hide('slow');
                }
            });

            return false;
        });

        // reset button ignores hidden input elements by default, let's fix it
        root.find('button.discard').click(function() {
            root.find('input[type=hidden]').val(function() {
                return $(this).data('original-value') || $(this).val();
            });
            common.clearValidationErrors();
            root.find('.edit-link').click();
            return true;
        });
    },

    order_book: function() {
        guide.save_book(function() {
            $('#BB_BuyButtonForm').submit();
        });
        return false;
    },

    preview_book: function() {
        guide.save_book(function() {
            var id = $('#BB_BuyButtonForm .book-id').val();
            window.location = '/books/' + id + '/print';
        });
        return false;
    },

    save_book: function(callback) {
        common.setLoadingGlobal('Saving guide...');

        var checkout_form = $('#BB_BuyButtonForm');
        checkout_form.find('input.submit').attr('disabled', 'disabled');
        $('#book-preview').ajaxSubmit({
            success: function(r) {
                common.stopLoadingGlobal();
                checkout_form.find('input.submit').removeAttr('disabled');
                if (callback) {
                    callback(r);
                }
            }
        });

    },

    init_book_preview: function() {
        $('#book-preview .tips-data .tip .image .container img').each(function() {
            $(this).draggable({
                containment: $(this).parents('.container'),
                scroll: false,
                stop: function(event, ui) {
                    var img = $(this);
                    var container = img.parent();
                    var window = container.parent();

                    var offset_x = 0;
                    var offset_y = 0;
                    if (container.hasClass('scroll-x')) {
                        offset_x = (container.width() - window.width())/2 - ui.position.left;
                    } else {
                        offset_y = (container.height() - window.height())/2 - ui.position.top;
                    }
                    var k = window.data('original-width') / img.width();
                    offset_x *= k;
                    offset_y *= k;
                    window.find('input.offset-top').val(Math.round(offset_y));
                    window.find('input.offset-left').val(Math.round(offset_x));
                }
            });
        });

        $('#book-preview .tips-order').sortable({
            update: function(event, ui) {
                var rank = 0;
                $('#book-preview .tips-order .tip').each(function() {
                    $(this).find('input.rank').val(rank++);
                    var tipId = $(this).data('tip-id');
                    var largeTip = $('#book-preview .tips-data .tip[data-tip-id=' + tipId + ']');
                    $('#book-preview .tips-data').append(largeTip);
                });
            }
        });
        $('#book-preview .input-widget .label').click(function() {
            var label = $(this);
            var widget = label.closest('.input-widget');
            var input = widget.find(':input');
            var original = widget.find('.original').html();

            label.hide();
            input.show().focus();
            if (!widget.hasClass('redefined')) {
                input.val(original).select();
            }
        });
        $('#book-preview .input-widget :input').blur(function() {
            var input = $(this);
            var widget = input.closest('.input-widget');
            var label = widget.find('.label');
            var original = widget.find('.original').html();

            input.hide();
            label.show();

            var new_value = input.val();
            if (new_value.blank() || new_value == original) {
                label.find('.content').html(widget.find('.original').html());
                widget.removeClass('redefined');
                input.val('');
            } else {
                widget.addClass('redefined');
                label.find('.content').html(new_value);
            }
        });
        $('#book-preview .input-widget :input').blur();
        $('#book-preview .input-widget :input').keypress(function(e) {
            if (e.which == 13) {
                $(this).blur();
            }
        });
        $('#book-preview .input-widget .undo').click(function(e) {
            var widget = $(this).closest('.input-widget');
            widget.find(':input').val('').blur();
            return false;
        });
    },

    init_user_edit: function() {
        $('#user-edit .input-row .view:empty').each(function() {
            if (!$(this).is('img')) {
                $(this).addClass('no-value').html('none');
            }
        });


        $('#user-edit .file-upload > input').change(function() {
            var value = $(this).val();
            if (value.indexOf('\\') >= 0) {
                value = value.substring(value.lastIndexOf('\\') + 1, value.length);
            }
            $(this).parent().find('.file-name').html(value);
        });

        $('#user-edit .button.edit').click(function() {
            if ($('#user-edit').hasClass('view-mode')) {
                $('#user-edit').removeClass('view-mode').addClass('edit-mode');
            }
        });

        $('#user-edit .button-panel .cancel').click(function() {
            $('#user-edit').addClass('view-mode').removeClass('edit-mode');

            // do not reset, for now
//        $('#user-edit')[0].reset();
//        $('.file-upload .label .file-name').html('');
            return false;
        });
        $('#user-edit .button-panel .submit').click(function() {
            common.clearValidationErrors();
            common.setLoadingGlobal('Saving..');
            $('#user-edit').ajaxSubmit({
                type: 'POST',
                cache: false,
                iframe: true,
                dataType: "text",
                success: function(result) {
                    common.stopLoadingGlobal();

                    if (result.startsWith('{')) {
                        // errors in json form returned
                        var errors = eval('(' + result + ')').errors;
                        common.validationErrors(errors);
                        return;
                    }

                    $('#user-edit').replaceWith(result);
                    guides.init_user_edit();
                }
            });
            return false;
        });
    },

    init: function(root) {
    }
};

// have some 'aliases' for old code
window.calendar = window.guide;
window.guides = window.guide;

$(document).ready(function() {
    guide.init_edit_area($('div.guide-details'));
    if ($('#book-preview').length > 0) {
        guide.init_book_preview();
    }
    if ($('#user-edit').length > 0) {
        guide.init_user_edit();
    }
});
