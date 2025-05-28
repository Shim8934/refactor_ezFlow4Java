// 2024-07-18 한태훈 > 연계 포틀릿 js

// 연계포틀릿 템플릿
var connectPortletTemplate = {
	'list' : '<li onclick="openWindow(\'${linkUrl}\', \'${width}\', \'${height}\')"><span class="txt">${title}</span><span class="date">${date}</span><span class="name">${writer}</span></li>'
}

function initConnectionPortlet(connectPortletId) {
	var newObj = (function() {
		var portletId = connectPortletId;
		var perCount = getConnectPagePerCount(portletId); 
		var obj = {};
		obj.page = new Paging().setPageStart(1).init(perCount);
		obj.page.getPagePerCount = function () {
			return getConnectPagePerCount(portletId);
		}
		obj.portletCode = "connectPortlet";
		obj.getPortletList = function () {
			if (obj.page.paging == "noLimit") {
				var currentPage = obj.page.getPage();
				getConnectList(currentPage, portletId);
			} else {
				getConnectList(1, portletId);
			}
		}
		
		return obj;
	})();
	
	portletInfoMap["portlet" + connectPortletId] = newObj;
	
	getConnectList(1, connectPortletId);
}

function getConnectPagePerCount(connectPortletId) {
	var portletSize = getPortletSize(connectPortletId);
	var count = 0;
	
	if (portletSize === GridSize.TWO_BY_ONE || portletSize === GridSize.TWO_BY_TWO) {
		count = 7;
	} else {
		count = 3;
	}

	return count;
}

function getConnectList(currentPage, portletId) {
	var listCnt = getConnectPagePerCount(portletId);
	$.ajax({
		type: "GET",
		url: "/ezNewPortal/getConnectList.do",
		data: {
			portletId : portletId,
			currentPage : currentPage,
			listCnt : listCnt
		},
		dataType: "JSON",
		success : function(data) {
			if (data.portletType == "standard") {
				try {
					makeStandardConnectPortlet(data, portletId);
				} catch (e) {
					makeMessageContent(messages.strLang2, document.getElementById(portletId + "Portlet").querySelector('.portletPagingArea'));
				}
			}
		},
		error : function(error) {
			makeMessageContent(messages.strLang2, document.getElementById(portletId + "Portlet").querySelector('.portletPagingArea'));
		}
	});
}

function makeStandardConnectPortlet(data, portletId) {
	var dataResultType = data.dataResultType.toLowerCase();
	var dataResultFormat = JSON.parse(data.dataResultFormat);
	var rootPath = dataResultFormat.rootPath;
	var dataInfo = dataResultFormat.dataInfo;
	var connectListDiv = document.getElementById('connectionPortlet' + portletId);
	var connectPortletPaging = portletInfoMap["portlet" + portletId].page; 
	var currentPage = connectPortletPaging.getPage();
	var totalCnt = 0;
	var resultStr = "";
	var usedTheme =  document.getElementById("usedTheme" + portletId).value;
	var dataList = null;
	var paging = data.paging;
	var width = data.width;
	var height = data.height;
	connectPortletPaging.paging = paging;
	makePlusBtn(portletId, usedTheme, data.linkUrl, width, height);
	
	while(connectListDiv.firstChild) {
		connectListDiv.removeChild(connectListDiv.firstChild);
	}
	
	if (dataResultType == "json") {
		var dataObj = JSON.parse(data.portletDataStr);
		dataList = getJsonDataByPath(dataObj, rootPath);
		for (var i = 0 ; i < dataList.length; i++) {
			resultStr += replaceTemplateLiterals(connectPortletTemplate[data.viewType], dataInfo, dataList[i], dataResultType);
		}
		
		if (paging == "noLimit") {
			totalCnt = getJsonDataByPath(dataObj, dataResultFormat.totalCnt);
		} else if (paging == "limit") {
			totalCnt = dataList.length;
		}
		
	} else if (dataResultType == "xml") {
		dataList = getXMLDataByPath(data.portletDataStr, rootPath);
		for (var j = 0 ; j < dataList.length; j++) {
			resultStr += replaceTemplateLiterals(connectPortletTemplate[data.viewType], dataInfo, dataList[j], dataResultType);
		}
		
		if (paging == "noLimit") {
			totalCnt = getXMLDataByPath(data.portletDataStr, dataResultFormat.totalCnt)[0].textContent;
		} else if (paging == "limit") {
			totalCnt = dataList.length;
		}
		
	} else if (dataResultType == "html") {
		
	}
	
	resetPortletPaging(portletId, totalCnt, currentPage, "");
	
	if (totalCnt == 0) {
		makeMessageContent(messages.strLang1, connectListDiv);
		return;
	} else {
		connectListDiv.insertAdjacentHTML('beforeend', resultStr);
	}
	
	if (paging == "limit") {
		var portletArea = document.getElementById(portletId + "Portlet").querySelector('.portletPagingArea');
		var listElems = portletArea.children;
		var startRow = connectPortletPaging.getStart();
		var endRow = startRow + connectPortletPaging.getPagePerCount();
		
		for (var j = 0; j < listElems.length; j++) {
			if (j >= startRow && j < endRow) {
				listElems[j].style.display = "block";
			} else {
				listElems[j].style.display = "none";
			}
		}
	}
	
}

function makeMessageContent(message, element) {
	var dlEl = document.createElement('dl');
	dlEl.className = 'nodata';
	
	var dtEl = document.createElement('dt');
	
	var imgEl = document.createElement('img');
	imgEl.src = '/images/kr/main/noData_sIcon.png';
	
	var ddEl = document.createElement('dd');
	ddEl.textContent = message;
	
	dtEl.appendChild(imgEl);
	
	dlEl.appendChild(dtEl);
	dlEl.appendChild(ddEl);
	
	element.appendChild(dlEl);
}

function getJsonDataByPath(jsonObj, path) {
	if (path == "") {
		return jsonObj;
	}
	
	var pathOrder = path.split(";;");
	var dataObj = jsonObj;
	for (var i = 0; i < pathOrder.length; i++) {
		var path = pathOrder[i];
		dataObj = dataObj[path];
	}
	return dataObj;
}

function getXMLDataByPath(dataStr, rootPath) {
	var parser = new DOMParser();
	var xmlDoc = parser.parseFromString(dataStr, 'text/xml');
	
	var pathOrder = rootPath.split(";;");
	var resultDom = xmlDoc;
	for (var i = 0; i < pathOrder.length; i++) {
		var path = pathOrder[i];
		if (i < pathOrder.length - 1) {
			resultDom = resultDom.getElementsByTagName(path)[0];
		} else {
			resultDom = resultDom.getElementsByTagName(path);
		}
	}
	
	return resultDom;
	
}

function replaceTemplateLiterals(template, dataInfo, dataObj, type) {
    var regex = /\${(.*?)}/g;

    var replacedString = template.replace(regex, function(match, group) {
        var key = group.trim();
        var result = "";
        
        if (key == "width" || key == "height") {
        	result = dataInfo[key];
        	return result;
        } 
        
        if (type == "json") {
        	result = dataObj[dataInfo[key]];
        }
        if (type == "xml") {
        	var dataValue = dataObj.getElementsByTagName(dataInfo[key]);
        	if (dataValue != null && dataValue.length > 0) {
        		result = dataValue[0].textContent;
        	}
        }
        
        if (key == "date") {
        	result = result.substr(5,2) + "." + result.substr(8,8)
        }
        
        return result || "";
    });

    return replacedString;
}

function openWindow(url, viewWidth, viewHeight) {
	var popupHeight = viewHeight;
    var popupWidth = viewWidth;
    var pheight = window.screen.availHeight;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - popupHeight) / 2;
    var pLeft = (pwidth - popupWidth) / 2;

    var dualScreenTop = window.screenY;
    var dualScreenLeft = window.screenX;
    
    pTop += dualScreenTop;
    pLeft += dualScreenLeft;
    var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + popupHeight + ",width=" + popupWidth + ",top=" + pTop + ",left=" + pLeft;
    
    var newWindow = window.open(url, "", feature, "");
    
    if (/MSIE|Trident/.test(window.navigator.userAgent)) {
        newWindow.moveTo(pLeft, pTop);
    }
}

function makePlusBtn(portletId, usedTheme, linkUrl, pWidth, pHeight) {
	if (document.getElementById(portletId + "Portlet").querySelector('#portletPlus' + portletId)) {
		return;
	}
	var str = '<dd id="portletPlus' + portletId + '" class="portletPlus plus" onclick="openWindow(\''+ linkUrl +'\', '+ pWidth + ', ' + pHeight +')"></dd>';
	document.getElementById(portletId + "Portlet").getElementsByClassName('portlet_title')[0].insertAdjacentHTML('beforeend', str);
}
