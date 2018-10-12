var helpPortletLoadFunc = function () {

	var helpDetail = function () {
		var height = window.screen.availHeight;
		var width = window.screen.availWidth;
		var top = (height - 750) / 2;
		var left = (width - 1000) / 2;
		var url = '/ezPortal/help/help.do';
		var option = 'height=700px,width=1000px,top=' + top + ',left = ' + left + 'status = no, toolbar=no, menubar=no, location=no, resizable=0';
		
		window.open(url, "", option);
	}
		
	/* 이벤트 추가 */
	document.getElementById("helpDetail").addEventListener('click', helpDetail );	
}
