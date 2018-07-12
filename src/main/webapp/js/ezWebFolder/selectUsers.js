var g_windowReference = null;

function menu_SelectRange(companyId) {
	if (CrossYN()) {
		var szUrl = "/admin/ezWebFolder/targetSelect.do?company=" + companyId;
		var _MSIE = 'MSIE';
		var useragentstr = navigator.userAgent;
		
		if (useragentstr.indexOf(_MSIE) != -1) {
			var szParam = "dialogHeight:705px;dialogWidth:562px;edge:sunken;status:no;resizable:no;help:no;center:yes;scroll:no" + GetShowModalPosition(562, 705);
			var rv = window.showModalDialog(szUrl, document.getElementById("rangeStr").value, szParam);
			
			if (rv[0] == "OK") {
				document.getElementById("rangeStr").value = rv[1];
			} 
			else if (rv[0] == "NO") {
				document.getElementById("rangeStr").value = "";
			}
		}
		else {
			if ((g_windowReference == null) || (g_windowReference.closed == true)) {
				if (window.navigator.userAgent.indexOf("Safari") > 0 && window.navigator.userAgent.indexOf("Chrome") == -1) {
					var feature = GetOpenPosition(560, 730);
					g_windowReference = window.open(szUrl, "SelectRange", "height=730,width=560,resizable=no,center=yes" + feature);
				}
				else {
					var feature = GetOpenPosition(730, 700);
					g_windowReference = window.open(szUrl, "SelectRange", "height=700,width=560,resizable=no,center=yes" + feature);
				}
			}
			
			g_windowReference.focus();
		}
	}
	else {
		menu_SelectRange_IE(companyId);
	}
}

function menu_SelectRange_IE(companyId) {
	var szUrl = "/admin/ezWebFolder/targetSelect.do?company=" + companyId;
	
	if ((g_windowReference == null) || (g_windowReference.closed == true)) {
		if (window.navigator.userAgent.indexOf("Safari") > 0 && window.navigator.userAgent.indexOf("Chrome") == -1) {
			var feature = GetOpenPosition(560, 630);
			g_windowReference = window.open(szUrl, "SelectRange", "height=630,width=560,resizable=no,center=yes" + feature);
		}
		else {
			var feature = GetOpenPosition(560, 700);
			g_windowReference = window.open(szUrl, "SelectRange", "height=700,width=560,resizable=no,center=yes" + feature);
		}
	}
	
	g_windowReference.focus();
}

function GetRangeValue() {
	return document.getElementById("rangeStr").value;
}

function updateParent(_element, _value, _Type) {
	var elementRef = document.getElementsByName(_element);
	
	if (elementRef.length > 0) {
		switch (_Type) {
			case "selectedIndex":
				elementRef[0].selectedIndex = _value;
				break;
			case "value":
				elementRef[0].value = _value;
				break;
		}
	}
}

function updateTarget(listOfTarget) {
	var newTargetDiv = document.getElementById("newTargetDiv");
	
	if (newTargetDiv == null) {
		return;
	}
	
	newTargetDiv.textContent = listOfTarget;
	newTargetDiv.setAttribute("title", listOfTarget);
	newTargetDiv.style.display = "";
}

function closeWindow() {
	if ((g_windowReference != null) && (g_windowReference.closed == false)) {
		g_windowReference.close();
		g_windowReference = null;
	}
}

function getJsonData(initData) {
	var jsonData = null;
	try {
		jsonData = JSON.parse(initData);
	}
	catch (e) { return {};}
	
	var jsonObj  = {};
	var deptData = jsonData["dept"];
	var userData = jsonData["user"];
	
	if (deptData != null) {
		var deptLen   = deptData.length;
		var deptArray = [];
		
		for (var i = 0; i < deptLen; i++) {
			deptArray.push(deptData[i]["deptId"]);
		}
		jsonObj["dept"] = deptArray;
	}
	
	if (userData != null) {
		var userLen   = userData.length;
		var userArray = [];
		
		for (var i = 0; i < userLen; i++) {
			userArray.push(userData[i]["userId"]);
		}
		
		jsonObj["user"] = userArray;
	}
	
	return jsonObj;
}

function MakeUNXMLString(str) {
	str = ReplaceText(str, "&amp;", "&");
	str = ReplaceText(str, "&lt;", "<");
	str = ReplaceText(str, "&gt;", ">");
	str = ReplaceText(str, "&#039;", "'");
	return str;
}

function MakeXMLString(str) {
	str = ReplaceText(str, "&", "&amp;");
	str = ReplaceText(str, "<", "&lt;");
	str = ReplaceText(str, ">", "&gt;");
	str = ReplaceText(str, "'", "&#039;");
	str = ReplaceText(str, "\"", "&quot;");
	return str;
}

//CrossBrowser적용
function CrossYN() {
	var ua     = navigator.userAgent;
	var result = true;

	// 크로스 브라우저 IE9이하:false IE외: true
	if (/msie 10/i.test(ua))      {result = true; }
	else if (/msie/i.test(ua))    {result = false;}
	else if (/firefox/i.test(ua)) {result = true; }
	else if (/chrome/i.test(ua))  {result = true; }
	else if (/safari/i.test(ua))  {result = true; }
	else if (/opera/i.test(ua))   {result = true; }
	else if (/trident/i.test(ua)) {result = true; }
	
	return result;
}

function GetOpenPosition(popUpW, popUpH) {
	//2011.07.28 FireFox는 ShowModalDialog() 호출시 화면 중앙에 뜨지 않아 top, left를 지정해 줘야한다.
	var heigth   = window.screen.availHeight;
	var width    = window.screen.availWidth;
	var left     = 0;
	var top      = 0;
	var pleftpos = parseInt(width) - popUpW;
	heigth       = parseInt(heigth) - popUpH;
	width        = parseInt(width) - pleftpos;
	
	left = pleftpos / 2;
	top  = heigth / 2;
	
	var feature = ",left=" + left + ",top=" + top;
	
	return feature;
}