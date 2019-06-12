/**
 * 김보미
 */
function imageSizeControl() { //이미지 사이즈 조절
	$("#roll_featured").parent("div.orbit-wrapper").css({"width":"100%", "height":"100%"});
	$("#roll_featured").css({"width":"100%", "height":"100%"});
	
	$("#roll_featured img").each(function(){
		$(this).css({"width":"100%", "height":"100%"});
	})
}

function portletWindowOpen(url) {
	if (url != "") {
		if (url.substring(0, 4) === 'http') {
			window.open(url);
		} else {
			window.open("http://" + url);
		}
	}
}