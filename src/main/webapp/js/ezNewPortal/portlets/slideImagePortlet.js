/**
 * 김보미
 */
function imageSizeControl() {
	$("#roll_featured").parent("div.orbit-wrapper").css({"width":"100%", "height":"100%"});
	$("#roll_featured").css({"width":"100%", "height":"100%"});
	
	$("#roll_featured img").each(function(){
		$(this).css({"width":"100%", "height":"100%"});
	})
}