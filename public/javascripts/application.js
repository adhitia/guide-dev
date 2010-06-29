$(document).ready(function() {
    $('input.watermark').each(function(i) {
        $(this).Watermark($(this).attr('title'));
    });
});


