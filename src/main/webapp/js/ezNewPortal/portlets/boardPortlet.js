// board가 한 페이지에 여러개 존재할수 있으므로 객체 안에서 관리
if (typeof boardOb === "undefined") {
	var boardOb = {};
}

var BTN_NEXT = "nextBtn"
var BTN_PREV = "preBtn"
var boardPortletLang = "";

function makeBoardList(portletId, fileName, count, type, currentPage) {
    var boardHTML = "";
	$.ajax({
		type: "GET",
		dataType: "json",
		data: {
			"portletId": portletId,
			"fileName": fileName,
			"currentPage" : currentPage,
			"count": count
		},
		url: "/ezNewPortal/getCustomBoardInfo.do",
		success: function (result) {
			var access = result.access;
			var listViewFg = result.listViewFg;
			var boardList = result.boardList;
			var boardListTotalCnt = result.boardListTotalCnt;
			var currentPage = result.currentPage;
            boardPortletLang = result.boardPortletLang;
            
			if (access == "true") {
				if (listViewFg == true) {
					if ("a" === type) {
						getBoardListAType(result.boardList, portletId);
					} else if ("b" === type) {
						getBoardListBType(result.boardList, portletId);
					} else {
						getBoardList(result.boardList, portletId);
					}
				} else {
					boardHTML += '<dl class="nodata"><dt><img src="/images/kr/main/noData_sIcon.png"></dt><dd>' + messages.strLangnbh001 + '</dd></dl>'
					$("#customBoardList" + portletId).html(boardHTML);
					boardListTotalCnt = 0; //리스트보기 권한이 없을때 네비게이션버튼 없에기위해
				}
			} else {
                boardHTML += '<dl class="nodata"><dt><img src="/images/kr/main/noData_sIcon.png"></dt><dd>' + messages.strLang14 + '</dd></dl>'
                $("#customBoardList" + portletId).html(boardHTML);
			}
			resetPortletPaging(portletId, boardListTotalCnt, currentPage, "");
		},
		error: function(e) {
			boardHTML += '<dl class="nodata"><dt><img src="/images/kr/main/noData_sIcon.png"></dt><dd>' + messages.strLang2 + '</dd></dl>'
            $("#customBoardList" + portletId).html(boardHTML);
			console.log(e);
		}
	})
}

/**
 * 포틀릿 사이즈와 타입에따라 갯수가 달라짐
 */
function initBoardPortletInfo(portletId, type, fileName) {
	var newOb = {};
	newOb.id = portletId;
	newOb.fileName = fileName;
	newOb.type = type;
	boardOb[portletId] = newOb;
	newOb.portletCode = type != "" ? type + "Board" : "listBoard";

	var count = getCurrentCount(portletId);
	newOb.page = new Paging().setPageStart(1).init(count);
	newOb.page.getPagePerCount = function () {
		return getCurrentCount(portletId);
	}
	newOb.getPortletList = function () {
		var boardPortletPagingCnt = getCurrentCount(portletId);
		makeBoardList(portletId, newOb.fileName, boardPortletPagingCnt, newOb.type, newOb.page.getPage());
	}
	
	portletInfoMap["portlet" + portletId] = newOb;
	makeBoardList(portletId, fileName, count, type, 1);
}

function refreshBordPortletInfo(portletId) {
	var ob = boardOb[portletId];
	var count = getCurrentCount(portletId);
	makeBoardList(portletId, ob.fileName, count, ob.type, ob.page.getPage());
}

function getBoardList(data, portletId) {
	var boardList = data;
	var boardCount = boardList.length;
	var boardHTML = "";
	var today = new Date();
	var date = today.getDate();
	today.setDate(date - 1);
	//chkPageBtns(portletId, boardCount);
	//var currentCount = getCurrentCount(portletId);
	//boardCount = boardCount > currentCount ? currentCount : boardCount;
	
	if (boardCount > 0) {
		for (var i = 0; i < boardCount; i++) {
			var item = boardList[i];
			var publicFlag = item.publicFlag;
			var boardType = item.guBun;
			
			if (publicFlag === 'N' && boardType === '2') {
				boardHTML += "<li onclick='openAnonymousModal(\"" + portletId + "\", \"" + item.itemID + "\", \"" + item.guBun + "\", \"" + item.boardID + "\",openDoc_section3_Type)'>";
			}else{
				boardHTML += "<li onclick='openDoc_section3_Type(\"" + item.itemID + "\", \"" + item.guBun + "\", \"" + item.boardID + "\")'>";
			}
			
			var startDate = item.startDate;
			startDate = startDate.replace("-","/");
			var writeDate = new Date(startDate);

			if (today < writeDate) {
				boardHTML += "<span class='boardNew'>N</span>";
			}

			boardHTML += "<span class='txt'>" + MakeXMLString(item.title);
			if (publicFlag == 'N') {
				boardHTML += " <div class='board_private'></div>";
			}
			boardHTML += "</span>";
			boardHTML += "<span class='date'>" + startDate.substring(5, 16).replace("-",".") + "</span>";
			if(typeof boardPortletLang != "undefined" && boardPortletLang != "1" && boardPortletLang != ""){
				boardHTML += "<span class='name'>" + item.writerName2 + "</span>";
			}else{
				boardHTML += "<span class='name'>" + item.writerName + "</span>";
			}
			boardHTML += "</li>";
		}
	} else {
		boardHTML += '<dl class="nodata"><dt><img src="/images/kr/main/noData_sIcon.png"></dt><dd>' + messages.strLang1 + '</dd></dl>'
	}

	$("#customBoardList" + portletId).html(boardHTML);
}

function getBoardListAType(data, portletId) {
	var boardList = data;
	var boardCount = boardList.length;
	var jPortlet = $("#customBoardList" + portletId);
	//chkPageBtns(portletId, boardCount);
	//var currentCount = getCurrentCount(portletId);
	//boardCount = boardCount > currentCount ? currentCount : boardCount;
	
	jPortlet.empty();

	if (boardCount > 0) {
		for (var i = 0; i < boardCount; i++) {
			var item = boardList[i];
			var id = item.itemID;
			var guBun = item.guBun;
			var boardID = item.boardID;
			var SPLIT_DATE = ".";
			var DEFAULT_THUMBNAIL = '/images/portal/noti_nodata.png';
			var publicFlag = item.publicFlag;

			var listEle = document.createElement('li');
			(function(id, guBun, boardID) {
				listEle.addEventListener('click', function() {
					openDoc_section3_Type(id, guBun, boardID);
				});
			})(id, guBun, boardID);
			var dlEle = document.createElement('dl');
			listEle.appendChild(dlEle);
			var dt = document.createElement('dt');
			dlEle.appendChild(dt);
			var img = document.createElement('img');
			img.setAttribute('src', !!item.thumbnail ? item.thumbnail : DEFAULT_THUMBNAIL);
			dt.appendChild(img);
			var dd = document.createElement('dd');
			dlEle.appendChild(dd);
			var spanTitle = document.createElement('span');
			spanTitle.classList.add('title');
			dd.appendChild(spanTitle);
			textNode = document.createTextNode(item.title);
			spanTitle.appendChild(textNode);
			if (publicFlag === 'N') {
				var privateIcon = document.createElement('span');
				privateIcon.className = 'board_private'
				spanTitle.append(privateIcon);
			}
			var spanCont = document.createElement('span');
			spanCont.classList.add('cont');
			dd.appendChild(spanCont);
			textNode = document.createTextNode(!!item.content ? item.content : '');
			spanCont.appendChild(textNode);
			var contSub = document.createElement('span');
			contSub.classList.add('cont_sub');
			dd.appendChild(contSub);
			var spanName = document.createElement('span');
			spanName.classList.add('name');
			contSub.appendChild(spanName);
			if(typeof boardPortletLang != "undefined" && boardPortletLang != "1" && boardPortletLang != ""){
				textNode = document.createTextNode(!!item.writerName2 ? item.writerName2 : '');
			}else{
				textNode = document.createTextNode(!!item.writerName ? item.writerName : '');
			}
			spanName.appendChild(textNode);
			var spanDay = document.createElement('span');
			spanDay.classList.add('day');
			contSub.appendChild(spanDay);
			var date = new Date(item.startDate);
			// format : 2024.04.09
			var dateMonth = date.getMonth() + 1;
            var dateDay = date.getDate();
            
            dateMonth = tenMin(dateMonth);
            dateDay = tenMin(dateDay);
            
			textNode = document.createTextNode(date.getFullYear() + SPLIT_DATE + dateMonth + SPLIT_DATE + dateDay);
			spanDay.appendChild(textNode);
			$('#' + portletId + 'Portlet').find('.box_shadow').addClass('board_Atype');
			jPortlet.append(listEle);
		}
	} else {
		var dlEl = document.createElement('dl');
		dlEl.className = 'nodata';

		var dtEl = document.createElement('dt');

		var imgEl = document.createElement('img');
		imgEl.src = '/images/kr/main/noData_sIcon.png';

		var ddEl = document.createElement('dd');
		ddEl.innerHTML = messages.strLang1;

		dtEl.appendChild(imgEl);

		dlEl.appendChild(dtEl);
		dlEl.appendChild(ddEl);

		jPortlet.append(dlEl);
	}

}

function getBoardListBType(data, portletId) {
	var boardList = data;
	var boardCount = boardList.length;
	var jPortlet = $("#customBoardList" + portletId);

	//chkPageBtns(portletId, boardCount);
	//var currentCount = getCurrentCount(portletId);
	//boardCount = boardCount > currentCount ? currentCount : boardCount;

	jPortlet.empty();
    
	if (boardCount > 0) {
		for (var i = 0; i < boardCount; i++) {
			var item = boardList[i];
			var id = item.itemID;
			var guBun = item.guBun;
			var boardID = item.boardID;
			var SPLIT_DATE = ".";
			var publicFlag = item.publicFlag;

			var listEle = document.createElement('li');
			listEle.className = 'notiLI';
			(function(id, guBun, boardID) {
				listEle.addEventListener('click', function() {
					openDoc_section3_Type(id, guBun, boardID);
				});
			})(id, guBun, boardID);
			var dlEle = document.createElement('dl');
			listEle.appendChild(dlEle);
			if (!!item.thumbnail) {
				dlEle.style.background = "url('" + item.thumbnail + "')";
				dlEle.style.backgroundSize = "100% 100%";
			} else {
                dlEle.style.setProperty('background', 'url(/images/portal/noti_nodata.png) no-repeat 0 0 / 100% 100%', 'important');
			}
			// var dt = document.createElement('dt');
			// dlEle.appendChild(dt);
			// dt.className = 'noti_num';
			// dt.innerText = i + 1;
			var dd = document.createElement('dd');
			dlEle.appendChild(dd);
			dd.className = 'noti_text';
			var spanTitle = document.createElement('span');
			spanTitle.classList.add('title');
			dd.appendChild(spanTitle);
			textNode = document.createTextNode(item.title);
			spanTitle.appendChild(textNode);
			if (publicFlag === 'N') {
				var privateIcon = document.createElement('span');
				privateIcon.className = 'board_private'
				spanTitle.append(privateIcon);
			}
			var spanCont = document.createElement('span');
			spanCont.classList.add('cont');
			dd.appendChild(spanCont);
			textNode = document.createTextNode(!!item.content ? item.content : '');
			spanCont.appendChild(textNode);
			var contSub = document.createElement('span');
			contSub.classList.add('cont_sub');
			dd.appendChild(contSub);
			var spanName = document.createElement('span');
			spanName.classList.add('name');
			contSub.appendChild(spanName);
			if(typeof boardPortletLang != "undefined" && boardPortletLang != "1" && boardPortletLang != ""){
				textNode = document.createTextNode(!!item.writerName2 ? item.writerName2 : '');
			}else{
				textNode = document.createTextNode(!!item.writerName ? item.writerName : '');
			}
			spanName.appendChild(textNode);
			var spanDay = document.createElement('span');
			spanDay.classList.add('day');
			contSub.appendChild(spanDay);
			var date = new Date(item.startDate);
			// format : 2024.04.09
			var dateMonth = date.getMonth() + 1;
            var dateDay = date.getDate();
            var dateHour = date.getHours();
            var dateMinute = date.getMinutes();
                        
            dateMonth = tenMin(dateMonth);
            dateDay = tenMin(dateDay);
            dateHour = tenMin(dateHour);
            dateMinute = tenMin(dateMinute);
            
            var dateTime = document.createTextNode(dateHour + ":" + dateMinute);
            var br = document.createElement("br");
            
            textNode = document.createTextNode(date.getFullYear() + SPLIT_DATE + dateMonth + SPLIT_DATE + dateDay);
            spanDay.appendChild(textNode);
            spanDay.appendChild(br);
            // spanDay.appendChild(dateTime);
            
			$('#' + portletId + 'Portlet').find('.box_shadow').addClass('board_Btype');
			$('#customBoardList' + portletId).removeClass('portlet_list').addClass('noti_portlet_list');
			jPortlet.append(listEle);
            
		}
        
        var currentCnt = getCurrentCount(portletId);
        if (boardCount % currentCnt != 0) {
            for(var i = 0; i < currentCnt - boardCount; i++) {
                var nodataNotiLI = document.createElement('li');
                nodataNotiLI.className = 'notiLI';
                var nodataNotiDL = document.createElement('dl');
                nodataNotiDL.className = 'noti_nodata';
                nodataNotiLI.append(nodataNotiDL);
                jPortlet.append(nodataNotiLI)
            }
        }
	}
	else {
		var dlEl = document.createElement('dl');
		dlEl.className = 'nodata';

		var dtEl = document.createElement('dt');

		var imgEl = document.createElement('img');
		imgEl.src = '/images/kr/main/noData_sIcon.png';

		var ddEl = document.createElement('dd');
		ddEl.innerHTML = messages.strLang1;

		dtEl.appendChild(imgEl);

		dlEl.appendChild(dtEl);
		dlEl.appendChild(ddEl);

		jPortlet.append(dlEl);
	}
}

function openDoc_section3_Type(pItemID, pType, oBoardID, password) {
	openBoard(pItemID, pType, oBoardID, password);
}

function customBoardBtnClick() {
	var boardId = $(this).attr("data1");
    window.open("/ezBoard/boardMainRedirect.do?boardID=" + encodeURIComponent(boardId), "main", "");
}

// 0페이지면 뒤로 버튼 숨김
function chkPrevBtn(portletId) {
	var ob = boardOb[portletId];
	var preBtn = $('#' + portletId + 'Portlet').find('.' + BTN_PREV)[0];
	if (ob.page.getPage() === ob.page.getStartPage()) {
		preBtn.classList.add('disable');
	} else {
		preBtn.classList.remove('disable');
	}
}

// 다음 항목이 없으면 다음 버튼 숨김
function chkNextBtn(portletId, returnCnt) {
	var ob = boardOb[portletId];
	var nextBtn = $('#' + portletId + 'Portlet').find('.' + BTN_NEXT)[0];
	if (ob.page.getCountPerPage() < returnCnt) {
		nextBtn.classList.remove('disable');
	} else {
		nextBtn.classList.add('disable');
	}
}

function chkPageBtns(portletId, returnCnt) {
	chkPrevBtn(portletId);
	chkNextBtn(portletId, returnCnt);
}

function getCurrentCount(portletId) {
	var portletSize = getPortletSize(portletId);
	var count = 5;
	var type = boardOb[portletId].type;

	if (type === "a") {
		if (portletSize === GridSize.TWO_BY_ONE || portletSize === GridSize.TWO_BY_TWO) {
			count = 5;
		} else {
			count = 2;
		}
	} else if (type === "b") {
		if (portletSize === GridSize.TWO_BY_ONE || portletSize === GridSize.TWO_BY_TWO) {
			count = 6;
		} else {
			count = 3;
		}
	} else {
		if (portletSize === GridSize.TWO_BY_ONE || portletSize === GridSize.TWO_BY_TWO) {
			count = 7;
		} else {
			count = 3;
		}
	}

	return count;
}

function nextPageBoardPortlet(portletId) {
	var ob = boardOb[portletId];
	ob.page.next();
	refreshBordPortletInfo(portletId);
}

function prePageBoardPortlet(portletId) {
	var ob = boardOb[portletId];
	ob.page.previous();
	refreshBordPortletInfo(portletId);
}

function changeBoardViewCount(portletId) {
	var ob = boardOb[portletId];
	ob.page.changeCount(getCurrentCount(portletId));
	refreshBordPortletInfo(portletId);
}

function tenMin (tResult) {
    if (tResult < 10) {
        tResult = "0" + tResult;
    }
    return tResult;
}