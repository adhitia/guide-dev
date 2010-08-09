if (!window.tips) var tips = {
    save: function(formId, calendarId, after) {
        common.setLoadingGlobal();
        $('#' + formId).ajaxSubmit({
            type: 'POST',
            cache: false,
            iframe: true,
            dataType: "html",
            async: false,
            success: function(r) {
                common.stopLoadingGlobal();
                if (after) {
                    after(r);
                }
            }
        });
    },

    save_overlay: function(formId, calendarId) {
        common.setLoadingGlobal();
        $('#' + formId).ajaxSubmit({
            type: 'POST',
            cache: false,
            iframe: true,
            dataType: "html",
            async: false,
            success: function() {
                common.stopLoadingGlobal();
                var tile = $('#' + formId).parents('.tip-tile');
                tile.find('.edit-tip').data('overlay').close();
                calendar.updateTile(tile);
            }
        });
    },


    create: function(root, conditionId, weekdayId, result) {
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
            for (var i = 0; i < searcher.results.length; i++) {
                var result = searcher.results[i];
                var html = "" +
                           "<div class='full-image' full_url='" + result.url + "'>" +
                           "<img class='google_image' src='" + result.tbUrl + "' onclick='javascript:tips.selectGoogleImage(this, \"" + result.url + "\");' >" +
                           "</div>";
                container.append(html);
            }
        } else {
            container.html('no results found');
        }
        common.imageHelper(container);
    },

    selectGoogleImage: function(img, url) {
        var row = $(img).parents('.tipRoot')[0];
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
                e.find('a').data('result_url', result.url);
                if (result.phoneNumbers && result.phoneNumbers.length > 0) {
                    e.find('a').data('result_phone', result.phoneNumbers[0].number);
                }
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
        var row = $(result).parents('.tipRoot')[0];
        var container = $(result).parents('.local-search-container');
        var addr = $(result).find('.local_result_address').html();
        var lat = $(result).find('.local_result_lat').html();
        var lng = $(result).find('.local_result_lng').html();
        var url = $(result).data('result_url');
        var phone = $(result).data('result_phone');
        if (phone.startsWith('(0xx)')) {
            phone = phone.substring('(0xx)'.length);
        }
        $(row).find('.tip_address_street').val(addr);
        $(row).find('.tip_address_lat').val(lat);
        $(row).find('.tip_address_lng').val(lng);
        $(row).find('.tip_url').val(url);
        $(row).find('.tip_phone').val(phone);

        var ajax_form = $('#fetch_remote_content_form');
        ajax_form.attr('action', url);
        $(row).find('.local-search-launch').click();
        container.html('');

//        common.setLoading(container);
//        ajax_form.ajaxSubmit({
//            type: 'GET',
//            cache: false,
//            iframe: true,
//            dataType: "html",
//            async: false,
//            success: function(r) {
//                alert(1);
//                console.log(r);
//                alert(r);
//                $(row).find('.local-search-launch').click();
//                container.html('');
//            },
//            error: function(a, b, c) {
//                alert('error ' + a + ' | ' + b + ' | ' + c);
//            }
//        });
//        alert(23);
    },

    /**
     * Loads local suggestions (address, url, phone) from google. 
     */
    loadLocalSuggestions: function(anchor) {
        var container = $(anchor).next();
        if (container.css('display') == 'none') {
            common.setLoading(container);

            var root = $(anchor).parents('.tipRoot')[0];
            var ls = new google.search.LocalSearch();
            ls.setCenterPoint($(root).attr('city'));
            ls.setSearchCompleteCallback(anchor, tips.processLocalSearchResults, [ls, root]);
            ls.execute($(root).find('.tip_name').val());
        }
        container.toggle();
    },

    init: function(root) {
        // image suggestions
        $(root).find('.upload_image').tabs();
        $(root).find('.tip_name').blur(function() {
            var row = $(this).parents('.tipRoot')[0];
            var imageSearch = new google.search.ImageSearch();
            imageSearch.setSearchCompleteCallback(this, tips.drawSearchResults, [imageSearch, row]);
            imageSearch.execute($(this).val() + ' ' + $(row).attr('city'));
        });
        $(root).find('.tip_name').blur();


        common.imageHelper(root);





        // tips view page
        if ($('#view_tips').length > 0) {

            // remove tip handler
            $(root).find('.tip-tile .delete-tip').click(function() {
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
            if ($('.move-tip').length > 0) {
                $(root).find('.tip-tile').draggable({
                    handle: '.move-tip',
                    revert: 'invalid'
                });
            }
            $(root).find('.tip-tile').droppable({
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
//            alert('! ' + $(root).find('.tip-tile').length);
            $(root).find('.no-tip-tile').droppable({
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

            $(root).find('.view-tip').overlay({
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
            $(root).find('.edit-tip').overlay({
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

