// board가 한 페이지에 여러개 존재할수 있으므로 객체 안에서 관리
if (typeof boardOb === "undefined") {
	var boardOb = {};
}

var BTN_NEXT = "nextBtn"
var BTN_PREV = "preBtn"

function makeBoardList(portletId, fileName, count, type, startRow) {
	count++; // 다음페이지 확인 용

	$.ajax({
		type: "GET",
		dataType: "json",
		data: {
			"portletId": portletId,
			"fileName": fileName,
			"startRow": startRow,
			"count": count
		},
		url: "/ezNewPortal/getCustomBoardInfo.do",
		success: function (result) {
			if ("a" === type) {
				getBoardListAType(result, portletId);
			} else if ("b" === type) {
				getBoardListBType(result, portletId);
			} else {
				getBoardList(result, portletId);
			}
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

	var count = getCurrentCount(portletId);
	newOb.page = new Paging().init(count);

	makeBoardList(portletId, fileName, count, type, 0);
}

function refreshBordPortletInfo(portletId) {
	var ob = boardOb[portletId];
	var count = getCurrentCount(portletId);
	makeBoardList(portletId, ob.fileName, count, ob.type, ob.page.getStart());
}

function getBoardList(data, portletId) {
	var boardList = data;
	var boardCount = boardList.length;
	var boardHTML = "";
	var today = new Date();
	var date = today.getDate();
	today.setDate(date - 1);
	chkPageBtns(portletId, boardCount);
	var currentCount = getCurrentCount(portletId);
	boardCount = boardCount > currentCount ? currentCount : boardCount;
	
	for (var i = 0; i < boardCount; i++) {
		var item = boardList[i];
		boardHTML += "<li onclick='openDoc_section3_Type(\"" + item.itemID + "\", \"" + item.guBun + "\", \"" + item.boardID + "\")'>";
		var startDate = item.startDate;
		startDate = startDate.replace("-","/");
		var writeDate = new Date(startDate);
		
		if (today < writeDate) {
			boardHTML += "<span class='boardNew'>N</span>";
		}
		
		boardHTML += "<span class='txt'>" + MakeXMLString(item.title) + "</span>";
		boardHTML += "<span class='date'>" + startDate.substring(5, 16) + "</span>";
		boardHTML += "<span class='name'>" + item.writerName + "</span>";
		boardHTML += "</li>";
	}
	$("#customBoardList" + portletId).html(boardHTML);
}

function getBoardListAType(data, portletId) {
	var boardList = data;
	var boardCount = boardList.length;
	var jPortlet = $("#customBoardList" + portletId);
	chkPageBtns(portletId, boardCount);
	var currentCount = getCurrentCount(portletId);
	boardCount = boardCount > currentCount ? currentCount : boardCount;

	jPortlet.empty();
	for (var i = 0; i < boardCount; i++) {
		var item = boardList[i];
		var id = item.itemID;
		var guBun = item.guBun;
		var boardID = item.boardID;
		var SPLIT_DATE = ".";
		var DEFAULT_THUMBNAIL = '/images/portal/photo_sample.png';

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
		textNode = document.createTextNode(!!item.writerName ? item.writerName : '');
		spanName.appendChild(textNode);
		var spanDay = document.createElement('span');
		spanDay.classList.add('day');
		contSub.appendChild(spanDay);
		var date = new Date(item.startDate);
		// format : 2024.04.09
		textNode = document.createTextNode(date.getFullYear() + SPLIT_DATE + (date.getMonth() + 1) + SPLIT_DATE + date.getDate());
		spanDay.appendChild(textNode);
		$('#' + portletId + 'Portlet').find('.box_shadow').addClass('board_Atype');
		jPortlet.append(listEle);
	}
}

function getBoardListBType(data, portletId) {
	var boardList = data;
	var boardCount = boardList.length;
	var jPortlet = $("#customBoardList" + portletId);

	chkPageBtns(portletId, boardCount);
	var currentCount = getCurrentCount(portletId);
	boardCount = boardCount > currentCount ? currentCount : boardCount;

	jPortlet.empty();
	for (var i = 0; i < boardCount; i++) {
		var item = boardList[i];
		var id = item.itemID;
		var guBun = item.guBun;
		var boardID = item.boardID;
		var SPLIT_DATE = ".";
		var DEFAULT_THUMBNAIL = '/images/portal/photo_sample.png';

		var listEle = document.createElement('li');
		listEle.className = 'notiLI';
		(function(id, guBun, boardID) {
			listEle.addEventListener('click', function() {
				openDoc_section3_Type(id, guBun, boardID);
			});
		})(id, guBun, boardID);
		var dlEle = document.createElement('dl');
		listEle.appendChild(dlEle);
		var dt = document.createElement('dt');
		dlEle.appendChild(dt);
		dt.className = 'noti_num';
		dt.innerText = i + 1;
		var dd = document.createElement('dd');
		dlEle.appendChild(dd);
		dd.className = 'noti_text';
		var spanTitle = document.createElement('span');
		spanTitle.classList.add('title');
		dd.appendChild(spanTitle);
		textNode = document.createTextNode(item.title);
		spanTitle.appendChild(textNode);
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
		textNode = document.createTextNode(!!item.writerName ? item.writerName : '');
		spanName.appendChild(textNode);
		var spanDay = document.createElement('span');
		spanDay.classList.add('day');
		contSub.appendChild(spanDay);
		var date = new Date(item.startDate);
		// format : 2024.04.09
		textNode = document.createTextNode(date.getFullYear() + SPLIT_DATE + (date.getMonth() + 1) + SPLIT_DATE + date.getDate());
		spanDay.appendChild(textNode);
		var bar = document.createElement('br');
		dd.appendChild(bar);
		textNode = document.createTextNode(date.getHours() + ':' + date.getMinutes());
		$('#' + portletId + 'Portlet').find('.box_shadow').addClass('board_Btype');
		$('#customBoardList' + portletId).removeClass('portlet_list').addClass('noti_portlet_list');
		jPortlet.append(listEle);
	}
}

function openDoc_section3_Type(pItemID, pType, oBoardID) {
    var pheight = window.screen.availHeight;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - 720) / 2;
    var pLeft = (pwidth - 765) / 2;

    /* 2018-09-19 홍승비 - 포탈 포틀릿에서 포토/썸네일게시물 보기 시 창 크기 수정 */
    if (pType == "3" || pType == "4") {
	    if (navigator.userAgent.toLowerCase().indexOf("chrome") != -1) {
			var height = 789;
		} else {
			var height = 785;
		}
	    
		pTop = (pheight - 789) / 2;
		pLeft = (pwidth - 790) / 2;

       window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=&itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(oBoardID), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height + ",width=790,top=" + pTop + ",left=" + pLeft, "");
   } else if (pType == "7") {
	   var height = 679;
	   pTop = (pheight - 679) / 2;
	   pLeft = (pwidth - 764) / 2;

      window.open("/ezBoard/boardItemViewMovie.do?showAdjacent=&itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(oBoardID), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height + ",width=764,top=" + pTop + ",left=" + pLeft, "");
   } else {
       if (CrossYN()) {
           window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(oBoardID), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
       } else {
           window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(oBoardID), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
       }
   }
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
			count = 8;
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