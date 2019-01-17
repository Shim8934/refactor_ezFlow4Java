var helpPortletLoadFunc = function () {

	var helpDetail = function () {
		var height = window.screen.availHeight;
		var width = window.screen.availWidth;
		var top = (height - 800) / 2;
		var left = (width - 1560) / 2;
		var url = '/ezNewPortal/help/index.do';
		var option = 'height=800px,width=1560px,top=' + top + ',left = ' + left + 'status = no, toolbar=no, menubar=no, location=no, resizable=0';
		
		window.open(url, "", option);
	}
		
	/* 이벤트 추가 */
	document.getElementById("helpDetail").addEventListener('click', helpDetail );	
}
