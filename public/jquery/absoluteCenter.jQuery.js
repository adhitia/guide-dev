/***
@title:
Absolute Center

@version:
1.1

@author:
David Tang

@date:
2010-06-17

@url
www.david-tang.net

@copyright:
2010 David Tang

@requires:
jquery

@does:
This plugin centers an element on the page using absolute positioning and keeps the element centered 
if you scroll horizontally or vertically.

@howto:
jQuery('#my-element').absoluteCenter(); would center the element with ID 'my-element' using absolute positioning 

*/

jQuery.fn.absoluteCenter = function(){
	return this.each(function(){
        alert('!!');
		var element = jQuery(this);
		centerElement();
		jQuery(window).bind('resize',function(){
			centerElement();
		});
			
		function centerElement(){
			var elementWidth = jQuery(element).outerWidth();
			var elementHeight = jQuery(element).outerHeight();
			var windowWidth = jQuery(window).width();
			var windowHeight = jQuery(window).height();	
			
			if(jQuery.browser.msie){
				var X1 = document.body.scrollLeft;
				var Y1 = document.body.scrollTop;
			}
			else {
				var X1 = window.pageXOffset;
				var Y1 = window.pageYOffset;
			}
			
			var X2 = windowWidth/2 - elementWidth/2;
			var Y2 = windowHeight/2 - elementHeight/2;
//            alert(elementWidth + "   " + elementHeight);
//            alert(X2 + "   " + Y2);

			jQuery(element).css({
				'left':X2,
				'top':Y2,
				'position':'fixed'
			});						
		} //end of centerElement function
					
	}); //end of return this.each
}