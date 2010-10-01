if (!window.tips) var tips = {
    saveTab: function(formId, after) {
//        var root = $('#' + formId);
//
//        var toDelete = [];
//        root.find('div.edit-tip-root').each(function() {
//            var el = $(this);
//            if (!el.hasClass('new-tip-root')) {
//                var name = el.find('input.tip_name').val();
//            }
//        });

        tips.save(formId, null, after);
    },

    save: function(formId, calendarId, after) {
        common.clearValidationErrors();
        common.setLoadingGlobal('Saving..');
        $('#' + formId).ajaxSubmit({
            type: 'POST',
            cache: false,
            iframe: true,
            dataType: "json",
//            async: false,
            success: function(r) {
                common.stopLoadingGlobal();
                if (common.validationErrors(r.errors)) {
                    return;
                }
                if (after) {
                    after(r);
                }
            }
        });
    },

    save_overlay: function(current) {
        var form = $(current).parents('form');

        common.clearValidationErrors();
        common.setLoadingGlobal();
        form.ajaxSubmit({
            type: 'POST',
            cache: false,
            iframe: true,
            dataType: "json",
            success: function(r) {
                common.stopLoadingGlobal();

                if (common.validationErrors(r.errors)) {
                    return;
                }

                var tile = form.parents('.tip-tile,.no-tip-tile');
                tile.find('.edit-tip,.create-tip').data('overlay').close();
                if (r.new_tip_id != null) {
//                    alert(r.new_tip_id);
                    tile.attr('place_id', r.new_tip_id);
                }
                calendar.updateTile(tile);
            }
        });
    },


    create: function(root, conditionId, weekdayId, result) {
//        root = $(root).find('.tip-edit');
        $("#new_tip_name").val("");
        $("#new_tip").dialog({
            buttons: {
                "Create": function() {
                    if ($('#new_tip_name').val() == '') {
                        return;
                    }
                    $(this).dialog("close");
                    common.setLoading(root);
                    $('#new_tip_form').ajaxSubmit({
                        type: 'POST',
                        cache: false,
                        data: {
                            condition_id: conditionId,
                            weekday_id: weekdayId,
                            result: result
                        },
                        dataType: "html",
                        success: function(r) {
                            $(root).html('').html(r);
                            tips.init(root);
                            if ($(root).prev().hasClass('no-tip-tab')) {
                                // when we're on edit page
                                var header = $(root).prev();
                                header.removeClass('no-tip-tab').addClass('tip-tab').click();
                                header.find('.accordion-header-right').html($(root).find('.tip_name').val());
                            }
                        }
                    });
                },
                "Cancel": function() {
                    $(this).dialog("close");
                }
            },
            draggable: false,
            modal: true,
            resizable: false,
            title: 'enter tip name',
            width: 230
        });
    },



    drawSearchResults: function(searcher, root) {
        var container = $(root).find('.google-image-choices');
        container.html('');
        if (searcher.results && searcher.results.length > 0) {
            container.append('<input type="hidden" class="tip_image_url" name="' + $(root).attr('form_prefix') + '[image_url]">');

            var scrollable = $('<div></div>').addClass('scrollable');
            var items = $('<div></div>').addClass('items');
            var n = searcher.results.length;
            var groupSize = 3;
            for (var p = 0; p < (n + groupSize - 1) / groupSize; ++p) {
                var page = $('<div></div>');
                for (var i = 0; i < groupSize && p * groupSize + i < n; ++i) {
                    var result = searcher.results[p * groupSize + i];
                    var html = "" +
                               "<div class='full-image' full_url='" + result.url + "'>" +
                               "<img class='google_image' src='" + result.tbUrl +
                               "' onclick='javascript:tips.selectGoogleImage(this, \"" + result.url + "\");' >" +
                               "</div>";
                    page.append(html);
                }
                items.append(page);
            }
            scrollable.append(items);

            container.append('<a class="prev browse left"></a>');
            container.append(scrollable);
            container.append('<a class="next browse right"></a>');
            scrollable.scrollable();
        } else {
            container.html('no results found');
        }
        common.imageHelper(container);
    },

    selectGoogleImage: function(img, url) {
        var row = $(img).parents('.edit-tip-root')[0];
        if ($(img).parent().hasClass('selected')) {
            $(row).find('.google-image-choices div').removeClass('selected');
            $(row).find('.tip_image_url').val('');
        } else {
            $(row).find('.google-image-choices div').removeClass('selected');
            $(img).parent().addClass('selected');
            $(row).find('.tip_image_url').val(url);
        }
    },

    processLocalSearchResults: function(searcher, root) {
        var container = $(root).find('.local-search-container');
        container.html('');
        if (searcher.results && searcher.results.length > 0) {
            container.append('Click to select result<br/>');
            var list = $('<ul></ul>');
            container.append(list);
            for (var i = 0; i < searcher.results.length; i++) {
                var result = searcher.results[i];
                var e = $('<li>'
                + ' <a href="javascript:" onclick="tips.selectLocalResult(this);">'
                + result.titleNoFormatting + '<br/>'
                + '<span class="local_result_address">' + result.streetAddress + '</span><br/>'
                + '<span class="local_result_lat">' + result.lat + '</span>'
                + '<span class="local_result_lng">' + result.lng + '</span>'
                + '</a></li>');
                list.append(e);

                var a = e.find('a');
                a.data('result_url', result.url);
                if (result.phoneNumbers && result.phoneNumbers.length > 0) {
                    a.data('result_phone', result.phoneNumbers[0].number);
                }
                a.data('title', result.titleNoFormatting);
                //titleNoFormatting
//                e.find('a').data('static_map_url', result.staticMapUrl);
//                for (k in result) {
//                    console.log(k + " : " + result[k]);
//                }
            }
        } else {
            container.append('no results found');
        }
    },

    selectLocalResult: function(result) {
        result = $(result);
        var row = result.parents('.edit-tip-root')[0];
        var container = result.parents('.local-search-container');
        var addr = result.find('.local_result_address').html();
        var lat = result.find('.local_result_lat').html();
        var lng = result.find('.local_result_lng').html();
        var google_url = result.data('result_url');
        var phone = result.data('result_phone');
        if (phone != null && phone.startsWith('(0xx)')) {
            phone = phone.substring('(0xx)'.length);
        }
        var title = result.data('title');

//        var ajax_form = $('#fetch_remote_content_form');
//        ajax_form.attr('action', url);
//        $(row).find('.local-search-launch').click();
        container.html('');

        // fetch website url
        common.setLoading(container);
        $.ajax({
            url: '/fetch_gmaps_data',
            data: {'url' : google_url},
            type: 'GET',
            cache: false,
            dataType: "html",
            success: function(r) {
                r = $(r);
//                var url = r.find('.pp-authority-page a').html();
                var url = r.find('.pp-authority-page a').attr('href');
                if (url == null) {
                    url = google_url;
                } else {
                    var re = new RegExp("q=[^&]+&");
                    url = re.exec(url).toString();
                    url = url.substr(2, url.length - 3);
                }
//                alert(url);
                r.remove();

                $(row).find('.local-search-launch').click();
                container.html('');

                $(row).find('.tip_address_street').val(addr);
                $(row).find('.tip_address_lat').val(lat);
                $(row).find('.tip_address_lng').val(lng);
                $(row).find('.tip_url').val(url);
                $(row).find('.tip_phone').val(phone);
                $(row).find('.tip_name').val(title);
//                $(row).find('.map_url').val(google_url);

            },
            error: function(a, b, c) {
//                alert('error ' + a + ' | ' + b + ' | ' + c);
            }
        });
//        alert(23);
    },

    /**
     * Loads local suggestions (address, url, phone) from google. 
     */
    loadLocalSuggestions: function(anchor) {
        var container = $(anchor).next();
        if (container.css('display') == 'none') {
            common.setLoading(container);

            var root = $(anchor).parents('.edit-tip-root')[0];
            var name = $(root).find('.tip_name').val();
            if (common.trim(name) == '') {
                return;
            }
            var ls = new google.search.LocalSearch();
            ls.setCenterPoint($(root).attr('city'));
            ls.setResultSetSize(8);
            ls.setSearchCompleteCallback(anchor, tips.processLocalSearchResults, [ls, root]);
            ls.execute(name);
        }
        container.toggle();
    },

    init: function(root) {
        root = $(root);

        // image suggestions
        $(root).find('.upload_image').tabs();
        $(root).find('.tip_name').blur(function() {
            if (common.trim($(this).val()) != '') {
                var row = $(this).parents('.edit-tip-root')[0];
                var imageSearch = new google.search.ImageSearch();
                imageSearch.setResultSetSize(8);
                imageSearch.setSearchCompleteCallback(this, tips.drawSearchResults, [imageSearch, row]);
                imageSearch.execute($(this).val() + ' ' + $(row).attr('city'));
            }
        });
        $(root).find('.tip_name').blur();


        common.imageHelper(root);

        // disable tip inputs if name isn't present
        // not used currently
        /*
        $(root).find('div.edit-tip-root').each(function() {
            var current = $(this);
            var nameInput = current.find('input.tip_name');

            function set_disabled(val) {
                nameInput.toggleClass('disabled-tip');
                current.find('input,textarea').each(function() {
                    var input = $(this);
                    if (!input.hasClass('tip_name')) {
                        input.attr('disabled', val);
                    }
                });
            }
            function toggle() {
                if (nameInput.hasClass('disabled-tip')) {
                    if (common.trim(nameInput.val()) != '') {
                        set_disabled(false);
                    }
                } else {
                    if (common.trim(nameInput.val()) == '') {
                        set_disabled(true);
                    }
                }
            }
            nameInput.keyup(toggle);
            toggle();
        });
*/



        // tips view page
        if ($('#view_tips').length > 0) {

            // remove tip handler
            root.find('div.tip-tile a.delete-tip').click(function() {
                var root = $(this).parents('.tip-tile');
                var place_id = root.attr('place_id');
                var calendar_id = root.attr('calendar_id');
                common.confirm('Are you sure you want to delete this tip?', function() {
                    common.setLoading(root);
                    $.ajax({
                        url: '/occurrences/' + place_id + '/unbind',
                        cache: false,
                        dataType: "html",
                        success: function(r) {
                            var parent = root.parent();
                            root.replaceWith(r);
                            tips.init(parent);
                        }
                    });
                });
            });

            // drag'n'drop
            // workaround for the case when editing is not accessible
            if (root.find('a.move-tip').length > 0) {
                root.find('div.tip-tile').draggable({
                    handle: 'a.move-tip',
                    revert: 'invalid'
                });
            }
            root.find('div.tip-tile').droppable({
                hoverClass: 'droppable-active',
                drop: function(event, ui) {
                    var container_from = ui.draggable.parent();
                    var container_to = $(this).parent();

                    var place_id = ui.draggable.attr('place_id');
                    var target_id = $(this).attr('place_id');

                    // TODO move elements slowly
                    ui.draggable.appendTo(container_to);
                    $(this).appendTo(container_from);
                    ui.draggable.css('left', 0).css('top', 0);

                    common.setLoadingGlobal();
                    $.ajax({
                        url: '/occurrences/' + place_id + '/switch',
                        data: {'target_id' : target_id},
                        cache: false,
                        dataType: "text",
                        success: function() {
                            common.stopLoadingGlobal();
                        }
                    });
                }
            });
            root.find('div.no-tip-tile').droppable({
                hoverClass: 'droppable-active',
                drop: function(event, ui) {
                    var container_from = ui.draggable.parent();
                    var container_to = $(this).parent();

                    var place_id = ui.draggable.attr('place_id');
                    var condition_id = container_to.attr('condition_id');
                    var day_id = container_to.attr('day_id');

                    // TODO move elements slowly
                    ui.draggable.appendTo(container_to);
                    $(this).appendTo(container_from);
                    ui.draggable.css('left', 0).css('top', 0);

                    common.setLoadingGlobal();
                    $.ajax({
                        url: '/occurrences/' + place_id + '/move',
                        data: {'condition_id' : condition_id, 'weekday_id' : day_id},
                        cache: false,
                        dataType: "text",
                        success: function() {
                            common.stopLoadingGlobal();
                        }
                    });
                }
            });

            $(root).find('a.view-tip').overlay({
//                effect: 'apple',
                closeOnClick: true,
                closeOnEsc: true,
                onLoad: function() {
                    var wrap = this.getOverlay().find('.content');
                    common.setLoading(wrap);
                    $.ajax({
                        url: this.getTrigger().attr("href"),
                        cache: false,
                        dataType: "html",
                        success: function(r) {
                            wrap.html(r);
                        }
                    });
                }
            });


            $(root).find('div.view-tip-hover').each(function() {
                var tile = $(this).parents('div.tip-tile');
                var place_id = tile.attr('place_id');
                tile.qtip({
                    content: {
                        url: '/tips/' + place_id
                    },
                    hide: {
                        delay: 500,
                        fixed: true
                    },
                    position: {
                        adjust: {
                            screen: true
                        }
                    },
                    style: {
                        width: {
                            max: 600,
                            min: 200
                        }
                    }
                });
            });



            $(root).find('a.edit-tip,a.create-tip').overlay({
                mask: {
                    color: 'grey',
                    loadSpeed: 200,
                    opacity: 0.5
                },
//                effect: 'apple',
                closeOnClick: false,
                closeOnEsc: false,
                onLoad: function() {
                    var wrap = this.getOverlay().find('.content');
                    common.setLoading(wrap);
                    $.ajax({
                        url: this.getTrigger().attr("href"),
                        cache: false,
                        dataType: "html",
                        success: function(r) {
                            wrap.html(r);
                            tips.init(wrap);
                        }
                    });
                }
            });



        }

    }
};


google.load('search', '1');
google.load('maps', '3', {'other_params' : 'sensor=false'});

$(document).ready(function() {
    tips.init(document);
});

