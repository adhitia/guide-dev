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
                    after();
                }
            }
        });
    },


    create: function(row, conditionId, weekdayId) {
        $("#new_tip_name").val("");
        $("#new_tip").dialog({
            buttons: {
                "Create": function() {
                    if ($('#new_tip_name').val() == '') {
                        return;
                    }
                    $(this).dialog("close");
                    common.setLoading($(row).find('td')[0]);
                    $('#new_tip_form').ajaxSubmit({
                        type: 'POST',
                        cache: false,
                        data: {
                            condition_id: conditionId,
                            weekday_id: weekdayId
                        },
                        dataType: "html",
                        success: function(r) {
                            var el = $(r);
                            $(row).replaceWith(el);
                            tips.init(el);
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
                var html = "<div class='full-image' full_url='" + result.url + "'>" +
                           "<img align='left' style='max-width:98px;max-height:98px' class='google_image' src='" + result.tbUrl + "' onclick='javascript:tips.selectGoogleImage(this, \"" + result.url + "\");' >" +
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
            }
        } else {
            container.append('no results found');
        }
    },

    selectLocalResult: function(result) {
        var row = $(result).parents('.tipRoot')[0];
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
//        alert($(row).find('.tip_url')[0].id + '   ' + url);
        $(row).find('.tip_url').val(url);
        $(row).find('.tip_phone').val(phone);
        $(row).find('.local-search-launch').click();
    },

    loadLocalSuggestions: function(anchor) {
        var container = $(anchor).next();
        if (container.css('display') == 'none') {
            common.setLoading(container);

            var row = $(anchor).parents('.tipRoot')[0];
            var ls = new google.search.LocalSearch();
            ls.setCenterPoint($(row).attr('city'));
            ls.setSearchCompleteCallback(anchor, tips.processLocalSearchResults, [ls, row]);
            ls.execute($(row).find('.tip_name').val());
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
    }
};


google.load('search', '1');
google.load('maps', '3', {'other_params' : 'sensor=false'});

$(document).ready(function() {
    tips.init(document);
});

