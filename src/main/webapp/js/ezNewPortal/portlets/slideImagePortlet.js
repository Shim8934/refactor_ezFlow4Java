/**
 * 김보미
 */
function imageSizeControl() { //임시 함수! 이미지 사이즈 조절
	$("#roll_featured").parent("div.orbit2-wrapper").css({"width":"100%", "height":"100%"});
	$("#roll_featured").css({"width":"100%", "height":"100%"});
	
	$("#roll_featured img").each(function(){
		$(this).css({"width":"100%", "height":"100%"});
	})
}