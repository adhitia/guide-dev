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
                guide.updateTile(tile);
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
                    var img = $('<img/>').addClass('google_image').attr('src', result.tbUrl);
                    img.bind('click', {url: result.url}, function(event) {
                        tips.selectGoogleImage(this, event.data.url);
                    });
                    var element = $('<div></div>').addClass('full-image').attr('full_url', result.url).append(img);
                    page.append(element);
                }
                items.append(page);
            }
            scrollable.append(items);

            container.append('<a class="prev browse left"></a>');
            container.append(scrollable);
            container.append('<a class="next browse right"></a>');
            scrollable.scrollable();
        } else {
            container.html('No results found, check spelling.');
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

    /*init_all: function(root) {
        if (root.hasClass('edit-tip-tile')) {
            tips.init(root);
            return;
        }
        root.find('div.edit-tip-tile').each(function() {
            tips.init($(this));
        });
    },*/

    init: function(root) {
        root = $(root);

        common.init(root);

        // image suggestions
//        $(root).find('.upload_image').tabs();
        /*$(root).find('.tip_name').blur(function() {
            var input = $(this);
            var value = input.val();
            var pastValue = input.data('pastValue-imageSearch');
            if (!common.empty(value) && value != pastValue) {
                var row = input.parents('.edit-tip-root')[0];
                var imageSearch = new google.search.ImageSearch();
                imageSearch.setResultSetSize(8);
                imageSearch.setSearchCompleteCallback(this, tips.drawSearchResults, [imageSearch, row]);
                imageSearch.execute(value + ' ' + $(row).attr('city'));
                input.data('pastValue-imageSearch', value);
            }
        });
        $(root).find('.tip_name').blur();*/

        /*$(root).find('a.local-search-launch').tooltip({
            onShow: function() {
                var root = this.getTrigger().parents('.edit-tip-root');
                var input = root.find('input.tip_name');
                var value = input.val();
                var pastValue = input.data('pastValue');

                input.data('pastValue', value);
                if (value.length < 2) {
                    this.getTip().html('Enter tip name and use this button to suggest address, phone and url.');
                    return;
                }

                if (pastValue == value) {
                    return;
                }

                common.setLoading(this.getTip(), 'Searching...');

                var ls = new google.search.LocalSearch();
                ls.setCenterPoint(root.attr('city'));
                ls.setResultSetSize(8);
                ls.setSearchCompleteCallback(this.getTrigger()[0], tips.processLocalSearchResults, [ls, root, value]);
                ls.execute(value);

                input.blur();
            },
            onBeforeHide: function() {
                if (this.state == 'fetching url') {
                    return false;
                }
            },
//            events: {
//                def: 'click, blur',
//                tooltip: 'click, blur'
//            },
            relative: true,
//            tip: '.local-search-container',
            delay: 500,
            predelay: 100,
            position: 'bottom center'
        });*/


//        common.imageHelper(root);

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



        // tips edit page
        if ($('#edit_tips').length > 0) {
            var tips = root.hasClass('edit-tip-tile') ? root : root.find('div.edit-tip-tile');

            var new_tip = root.find('div.new-tip-container');
//            if (root.find('div.new-tip-container').length > 0) {
//                tips = tips.add(root.find('div.new-tip-container')[0]);
//            }



            // remove tip handler
            tips.find('a.delete-tip').click(function() {
                var root = $(this).closest('.edit-tip-tile');
                var id = root.data('id');
//                var guide_id = root.data('guide-id');

                common.confirm('Are you sure you want to delete this tip?', function() {
//                    common.setLoading(root);
                    root.remove();
                    $.ajax({
                        url: '/tips/' + id + '/delete',
                        cache: false,
                        dataType: "html",
                        success: function(r) {
//                            var parent = root.parent();
//                            root.replaceWith(r);
//                            tips.init(parent);
                        }
                    });
                    guide.saveMatrix();
                });
                return false;
            });



            // view tip contents
            tips.each(function() {
                var trigger = $(this).find('.tip-icon');
                var tip = $(this).find('.tooltip-content');
                trigger.qtip({
                    content: tip.html(),
                    show: {
                        delay: 300
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
                            max: 250,
                            min: 200
                        }
                    }
                });
            });


            /*$(root).find('a.edit-tip,a.create-tip').overlay({
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
            });*/


            // make tips draggable
            var condition_groups = root.hasClass('condition-group') ? root : $(root).find('.condition-group');
            condition_groups.sortable({
                placeholder: 'edit-tip-tile edit-tip-tile-placeholder',
                cancel: 'form.tip-form',
                forceHelperSize: true,
                forcePlaceholderSize: true,
                connectWith: '.condition-group',
                delay: 100,
                distance: 5,
//                handle: 'a.move-tip',
                start: function(event, ui) {
                    var tooltips = $('div.edit-tip-tile > .tip-icon');
                    tooltips.qtip("hide");
                    tooltips.qtip("disable");
                },
                stop: function(event, ui) {
                    var tooltips = $('div.edit-tip-tile > .tip-icon');
                    tooltips.qtip("enable");

                    ui.item.data('last-drag-time', new Date().getTime());
                },
                update: function(event, ui) {
//                    console.log('update ' + ui.item.data('id') + '  ' + (ui.sender ? ui.sender.data('condition') : ' null '));
                    if (ui.sender == null) {
                        guides.saveMatrix();
                    }
                }
            });
//            .disableSelection()



            // open edit 'tab' on click
            tips.find('.edit-tip').click(function() {
                var root = $(this).closest('.edit-tip-tile');

                if ($(this).data('state') == 'saving') {
                    return;
                }
                var lastDrag = $(this).data('last-drag-time');
                if (lastDrag && new Date().getTime() - lastDrag < 10) {
                    return;
                }

//                var edit_area = root.find('div.edit-area');
                var edit_form = root.find('form.tip-form');

                var overlay = $('#global-overlay').css('height', ($('body').height() + 2) + 'px').show();
                var position_y = root.offset().top + root.height() - $('#edit_tips').offset().top;
//                var container = $('#edit-tip-container').css('top', position_y + 'px');
//                container.html('');
//                container.append(edit_form);
                edit_form.find('div.edit-area').show();

                edit_form.data('origin-tip', root);

                edit_form.slideDown(500, function() {
                    guides.loadTipSuggestions(edit_form.find('div.edit-tip-root'));
                });
                overlay.click(function() {
                    guides.closeTip.apply(edit_form.find('div.edit-tip-root'));
                });
            });


            tips.add(new_tip).find('.tip-update').click(guide.updateTip);
            tips.add(new_tip).find('button.load-info').click(function() {
                guide.loadTipSuggestions($(this));
                return false;
            });
            tips.add(new_tip).find('input.tip-name').keypress(function(e) {
                if (e.which == 13) {
                    guide.loadTipSuggestions(this);
                    return false;
                }
            });
//            tips.add(new_tip).find('form').keyup(function(e) {
            tips.add(new_tip).find('form').keyup(function(e) {
                if (e.which == 27) {
                    guides.closeTip.apply($(this).find('div.edit-tip-root'));
                }
            });


            /*
            tips.add(new_tip).find('.image-selection-area .file-upload > input').change(function() {
                var value = $(this).val();
                if (value.indexOf('\\') >= 0) {
                    value = value.substring(value.lastIndexOf('\\') + 1, value.length);
                }
//                alert('test change ' + value + ' ?');
                $(this).parent().find('.file-name').html(value);
                var google_images = $(this).closest('.image-selection-area').find('div.google-suggestions div.content');
                google_images.find('div').removeClass('selected');
                google_images.find('.tip_image_url').val('');
            });
            tips.add(new_tip).find('.image-selection-area .current-image').hover(function() {
                var e = $(this).find('.file-upload');
                if (e.find('input').val().blank()) {
                    e.fadeIn();
                }
            },
            function() {
                var e = $(this).find('.file-upload');
                if (e.find('input').val().blank()) {
                    e.fadeOut();
                }
            });
            tips.add(new_tip).find('.image-selection-area .file-upload').hide();
//            tips.add(new_tip).find('input.tip-name').each(function() {
//                common.runOnDelay($(this), 1000, guide.loadTipSuggestions);
//            });
            */

            // show tip ideas suggestions only when tip name is in the focus
            new_tip.find('input.tip-name').focus(function() {
                $(this).closest('.edit-tip-root').find('div.tip-ideas').fadeIn();
            });
            new_tip.find('input.tip-name').blur(function() {
                $(this).closest('.edit-tip-root').find('div.tip-ideas').fadeOut();
            });

            new_tip.find('div.tip-ideas').hover(function() {
                $(this).children('.content').slideDown();
            },
            function() {
                $(this).children('.content').slideUp();
            });

            new_tip.find('div.tip-ideas .type').click(function() {
                $.Watermark.HideAll();
                var name = $(this).text();
                $.Watermark.ShowAll();

                var root = $(this).closest('.edit-tip-root');
                root.find('div.tip-name-area .tip-name').val(name);
                guide.loadTipSuggestions(root);

                $(this).closest('div.tip-ideas').children('.content').slideUp();
            });
        }

    }
};

google.load('search', '1');
google.load('maps', '3', {'other_params' : 'sensor=false'});

$(document).ready(function() {
    tips.init(document);
});

