/**
 * 
 */
var photoBoardObj = {}

function initPhotoBoardPortlet(portletId) {
	var newObj = {};
	var perCount = getPhotoPagePerCount(portletId);
	newObj.page = new Paging().setPageStart(1).init(perCount);
	newObj.page.getPagePerCount = function () {
		return getPhotoPagePerCount(portletId);
	}
	newObj.portletCode = "photoboard";
	
	newObj.getPortletList = function () {
		var currentPage = portletInfoMap["portlet" + portletId].page.getPage();
		getPhotoPortletList(currentPage);
	}

	portletInfoMap["portlet" + portletId] = newObj;
	
	photoBoardObj.portletId = portletId;
	
	var photoPortletListCnt = document.getElementById('photoPortletListCnt').value;
	var totalCnt = photoPortletListCnt;
	
	var nodataArea = document.getElementById(portletId + "Portlet").querySelector(".nodata");
	if (nodataArea) {
		document.getElementById(portletId + "Portlet").querySelector(".portletPageNav").style.display = "none";
	}

	var listViewOff = document.getElementById(portletId + "Portlet").querySelector(".listViewOff");
	if (listViewOff) {
		totalCnt = 0;
	}
	
	var currentPage = 1;
	resetPortletPaging(portletId, totalCnt, currentPage, "");
}

function getPhotoPagePerCount(portletId) {
	var portletSize = getPortletSize(portletId);
	var count = 0;
	
	if (portletSize === GridSize.TWO_BY_ONE || portletSize === GridSize.TWO_BY_TWO) {
		count = 6;
	} else {
		count = 3;
	}
	
	return count;
}

function reloadPhotoPortlet() {
	var portletId = photoBoardObj.portletId;
	var newObj = {};
	var perCount = getPhotoPagePerCount(portletId);
	newObj.page = new Paging().setPageStart(1).init(perCount);
	newObj.page.getPagePerCount = function () {
		return getPhotoPagePerCount(portletId);
	}
	newObj.portletCode = "photoboard";
	
	newObj.getPortletList = function () {
		var currentPage = portletInfoMap["portlet" + portletId].page.getPage();
		getPhotoPortletList(currentPage);
	}

	portletInfoMap["portlet" + portletId] = newObj;
	
	getPhotoPortletList(1);
}

function reloadPhotoPage() {
	portletInfoMap["portlet" + photoBoardObj.portletId].getPortletList();
}

function getPhotoPortletList(currentPage) {
	var listSize = getPhotoPagePerCount(photoBoardObj.portletId);
	
	var boardId = $(".photo_portlet").find(".portletText").attr("data1");
	var portletId = $(".photo_portlet").parent().attr("id");
	portletId = portletId.substring(0, portletId.indexOf("P"));

	$.ajax({
		type : "GET",
		dataType : "json",
		url : "/ezNewPortal/getPhotoItemList.do",
		data : {"boardId" : boardId, "page" : currentPage, "photoCount" : listSize, "portletId" : portletId},
		success : function(result) {
			var photoBoardList = result.photoBoardList;
			var totalCnt = result.totalCnt;
			var currentPage = result.currentPage;
			$("#photoul").html("");
			if (result.access == "true") {
				if (photoBoardList.length > 0) {
					var resultCount = photoBoardList.length;
					var strHTML = "";

					for (var i = 0; i < resultCount; i++) {
						strHTML += "<li>";
						strHTML += "<img src='" + photoBoardList[i].filePath + "', data1='" + photoBoardList[i].boardID + "' data2='" + photoBoardList[i].itemID + "' onclick='photoItemRead(this)'>";
						strHTML += "<span>" + MakeXMLString(photoBoardList[i].title) + "</span>";
						strHTML += "</li>";

					}

					$("#photoul").html(strHTML);
				} else {
					var dl = document.createElement("dl");
					dl.classList.add("nodata");
					var dt = document.createElement("dt");
					var img = document.createElement("img");
					img.setAttribute("src", "/images/kr/main/noData_sIcon.png");
					dt.appendChild(img);
					dl.appendChild(dt);
					var dd = document.createElement("dd");
					dd.textContent = messages.strLang1;
					dl.appendChild(dd);
					document.getElementById("photoul").appendChild(dl);
					document.getElementById("photoul").style.display ="block";
				}
			} else {
				var dl = document.createElement("dl");
				dl.classList.add("nodata");
				var dt = document.createElement("dt");
				var img = document.createElement("img");
				img.setAttribute("src", "/images/kr/main/noData_sIcon.png");
				dt.appendChild(img);
				dl.appendChild(dt);
				var dd = document.createElement("dd");
				dd.textContent = messages.strLang14;
				dl.appendChild(dd);
				document.getElementById("photoul").appendChild(dl);
				document.getElementById("photoul").style.display ="block";
			}
			
			resetPortletPaging(portletId, totalCnt, currentPage, "");
		}
	})
}

/*
function photoBoardMovePage(event) {
	var isNext = false;
	
	if (event != null) {
		isNext = event.data.isNext;
	}
	
	if (isNext === true) {
		photoBoardPage += 1;
	} else {
		if (event != null) {
			if (photoBoardPage == 1) {
				return;
			} else {
				photoBoardPage -= 1;
			}
		}
	}
	
	var boardId = $(".photo_portlet").find(".portletText").attr("data1");
	var portletId = $(".photo_portlet").parent().attr("id");
	portletId = portletId.substring(0, portletId.indexOf("P"));

	$.ajax({
		type : "GET",
		dataType : "json",
		url : "/ezNewPortal/getPhotoItemList.do",
		data : {"boardId" : boardId, "page" : photoBoardPage, "photoCount" : photoCount, "portletId" : portletId},
		success : function(result) {
			if (result.length > 0) {
				var resultCount = result.length;
				var strHTML = "";

				for (var i = 0; i < resultCount; i++) {
					strHTML += "<li>";
					strHTML += "<img src='" + result[i].filePath + "', data1='" + result[i].boardID + "' data2='" + result[i].itemID + "' onclick='photoItemRead(this)'>";
					strHTML += "<span>" + MakeXMLString(result[i].title) + "</span>";
					strHTML += "</li>";

				}

				$("#photoul").html(strHTML);
			} else {
				photoBoardPage = photoBoardPage - 1;
			}
		}
	})
}
*/

function viewPhotoBoardList() {
	var boardId = $(".photo_board").find(".portletText").attr("data1");
	window.open("/ezBoard/boardMainRedirect.do?boardID=" + encodeURIComponent(boardId), "main", "");
}

function photoItemRead(elem) {
	var ShowAdjacent = "";
	var pheight = window.screen.availHeight;
	var pwidth = window.screen.availWidth;
	var pTop = (pheight - 789) / 2;
	var pLeft = (pwidth - 790) / 2;

	if (navigator.userAgent.toLowerCase().indexOf("chrome") != -1) {
		var height = 789;
	} else {
		var height = 785;
	}

	var boardId = $(".photo_portlet").find(".portletText").attr("data1");
	var portletId = $(".photo_portlet").parent().attr("id");
	portletId = portletId.substring(0, portletId.indexOf("P"));
	
	window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(elem.getAttribute("data2")) + "&boardID=" + encodeURIComponent(elem.getAttribute("data1")) + "&portletId=" + portletId, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height + ",width=790,top=" + pTop + ",left=" + pLeft, "");
}