// 2020-12-04 탭 게시판 포틀릿 - 박기범
var tabBoardId="";
var portletLang = ""; 
var tabBoardIdArr = new Array();
var tabBoardPortletObj = {};
const tabBoardPageMaxCnt = 21; // 톺이가 1일 때 3, 톺이가 2일 때 7 개 표출
function initTabPortletInfo(portletId) {
	var tabBoardObj = {};
    tabBoardObj.portletCode = "tabBoard";
    tabBoardObj.activeTabId = "";
    tabBoardObj.tabIdList = [];
    tabBoardObj.tabBoardIdList = [];
    tabBoardObj.tabBoardNameList = [];
    tabBoardObj.paging = {};
    portletInfoMap["portlet" + portletId] = tabBoardObj;
    tabBoardObj.page = new Paging().setPageStart(1).init(getTabBoardPagePerCount(portletId));
    tabBoardObj.page.getPagePerCount = function () {
		return getTabBoardPagePerCount(portletId);
	}
    tabBoardObj.getPortletList = function () {
    	var activeTabId = tabBoardObj.activeTabId;
    	var activeTabIndex = tabBoardObj.tabIdList.indexOf(activeTabId);
    	var activeBoardId = tabBoardObj.tabBoardIdList[activeTabIndex];
    	var activeBoardName = tabBoardObj.tabBoardNameList[activeTabIndex];
    	
    	activeTabId = activeTabId.replace("tabBoardList", "");
    	getTabBoardList(activeTabId, activeBoardId, activeBoardName);
    }
    tabBoardPortletObj.portletId = portletId;
    
    document.getElementById(portletId + "Portlet").querySelector('.tabBoardPorlet').value = portletId;
    getTabBoard(portletId);
    
}

function getTabBoardPagePerCount(portletId) {
	var portletSize = getPortletSize(portletId);
	var count = 0;
	
	if (portletSize === GridSize.TWO_BY_ONE || portletSize === GridSize.TWO_BY_TWO) {
		count = 7;
	} else {
		count = 3;
	}

	return count;
}

var getTabBoard = function (portletId) {
    var request = new XMLHttpRequest();
    request.open('GET', '/ezNewPortal/getTabBoardPortlet.do', true);
    request.setRequestHeader('Content-Type', 'application/json');
    request.onload = function () {
        if (request.status >= 200 && request.status < 400) {
            var result = JSON.parse(request.responseText);
            portletLang = result.portletLang;
            var docsHTML = "";
            var subDocsHTML = "";
            var tabList = result.tabList;
            if (result.existence == "true" && tabList && tabList.length > 0) {
                allDisplayNone('#notexistence');
                allDisplayNone('#tabBoard .portletText');
                
                var perCount = getTabBoardPagePerCount(portletId);
                var tabNode = null;
                for (var i = 0; i < tabList.length; i++) {
                	var tabBoardPage = new Paging().setPageStart(1).init(perCount);
                	tabBoardPage.getPagePerCount = function () {
                		return getTabBoardPagePerCount(portletId);
                	}
                	
                	var tabId = tabList[i]["TABID"];
                	var boardId = tabList[i]["BOARDID"];
                	var boardName = tabList[i]["BOARDNAME"];
                	portletInfoMap["portlet" + portletId].paging["tabBoardList" + tabId] = tabBoardPage;
                	portletInfoMap["portlet" + portletId].tabBoardIdList.push(boardId);
                	portletInfoMap["portlet" + portletId].tabBoardNameList.push(boardName);
                	portletInfoMap["portlet" + portletId].tabIdList.push("tabBoardList" + tabId);
                	
                	tabNode = document.getElementById("tabBoardList" + tabId + 'Tab');
                	tabNode.addEventListener("click", tapBoardChangeTab.bind(null, tabNode, tabId, boardId, boardName));
                			
    		        tabNode.firstChild.innerHTML = boardName;
    		        tabNode.style.display = "";
                }
                
                var tabNode = document.getElementById("tabBoardList" + tabList[0]["TABID"] + 'Tab');
                tapBoardChangeTab(tabNode, tabList[0]["TABID"], tabList[0]["BOARDID"], tabList[0]["BOARDNAME"]);
                
            } else {
            	var notExistenceElemes = document.getElementById(portletId + "Portlet").querySelectorAll('#notexistence');
            	for (var i = 0; i < notExistenceElemes.length; i++) {
            		notExistenceElemes[i].style.display = "block";
            	}
            	document.getElementById('tabBoardBtnDiv').style.display = "none";
            }
            
            document.getElementById('tabBoardPortletName').style.border = "none";
        } else {
            // We reached our target server, but it returned an error
        }
    };

    request.onerror = function () {
        // There was a connection error of some sort
    };
    request.send();
}

function getTabBoardList(tabId, boardId, tabBoardName) {
	var portletId = tabBoardPortletObj.portletId;
	var tabBoardListId = "tabBoardList" + tabId;
	var currentPage = portletInfoMap["portlet" + portletId].paging[tabBoardListId].getPage();
	var listCnt = getTabBoardPagePerCount(tabBoardPortletObj.portletId);
	$.ajax({
		type: "GET",
		url: "/ezNewPortal/getBoardList.do",
		data: {
			boardId : boardId,
			currentPage : currentPage,
			listCnt : listCnt
		},
		dataType: "JSON",
		async: false,
		cache: false,
		success : function(data) {
			var totalCnt = data.totalCnt;
			var currentPage = data.currentPage;
			var boardList = data.boardList;
			var listViewFg = data.listViewFg;
			
			if (typeof boardList != "undefined") {
		        var tabDocsHTML = "";
				
				if (boardList != null) {
					boardList.forEach(function (item, index) {
						tabDocsHTML += dataAssemblerTabBoard(item);
					});	
				}
		        
		        if (tabDocsHTML == "") {
					var setStrLang = listViewFg ? messages.strLang1 : messages.strLangnbh001;
		            tabDocsHTML += "<dl class='nodata'>";
					tabDocsHTML += "<dt><img src='/images/kr/main/noData_sIcon.png'></dt>";
					tabDocsHTML += "<dd>" + setStrLang + "</dd>";
					tabDocsHTML += "</dl>";
		        }
		        
		        document.getElementById(tabBoardListId).innerHTML = tabDocsHTML;
		        tabBoardIdArr[tabId] = boardId; // plus 버튼을 위한 변수 저장. tapBoardChangeTab위에 있어야 함
		        
		    }
		    resetPortletPaging(portletId, totalCnt, currentPage, tabBoardListId);
		},
		error: function (jqXHR, textStatus, errorThrown) {
	        console.error('Error:', textStatus, errorThrown);
	        console.error('Status:', jqXHR.status);
	        console.error('Response Text:', jqXHR.responseText);
	    }
	});
	
}

function refreshTab () {
	var portletId = tabBoardPortletObj.portletId;
	portletInfoMap["portlet" + portletId].getPortletList();
}

// 게시글 한줄 생성(데이터)
var dataAssemblerTabBoard = function(object) {
	var today = new Date();
	var writeDate = new Date(object.writeDate);
	var date = today.getDate();
	today.setDate(date - 1);
	var portletId = tabBoardPortletObj.portletId;

	var startDate = object.startDate;
	startDate = startDate.replace("-","/");
	var writeDate = new Date(startDate);
	
	var str = "";
	if (object.publicFlag === 'N' && object.guBun === '2') {
		str += "<li onclick=\"openAnonymousModal('" + portletId + "','" + object.itemID + "','" + object.guBun + "', '" + object.boardID + "',openDoc_section3_Type)\" >";
	} else {
		str += "<li onclick='openDoc_section3_Type(\"" + object.itemID + "\", \"" + object.guBun + "\", \"" + object.boardID + "\")'>";
	}

	if (today < writeDate) {
		str += "<span class='boardNew'>N</span>";
	}
	
    str += "<span class='txt' title='" + MakeXMLString(object.title) + "' >" + MakeXMLString(object.title);
	if (object.publicFlag === 'N') {
		str +=  " <div class='board_private'></div>";
	}
    str += "</span>";

	str += "<span class='date'>" + object.startDate.substring(5, 16).replace(/-/g, ".") + "</span>";

	// 2023-07-31 황인경 - 포탈 > 탭게시판 포틀릿 > 게시글 작성자 다국어 처리 
	if (portletLang != "1") {
		str += "<span class='name'>" + object.writerName2 + "</span>";
	} else {
		str += "<span class='name'>" + object.writerName + "</span>";
	}

	str += "</li>";
	return str;
}
// 탭변경(노드)
function tapBoardChangeTab(obj, tabId, boardId, tabBoardName) {
	getTabBoardList(tabId, boardId, tabBoardName);
	
	var tabBoardListId = "tabBoardList" + tabId;
	var portletId = tabBoardPortletObj.portletId;
	portletInfoMap["portlet" + portletId].activeTabId = tabBoardListId;
    var className = obj.className;

    var portletPageNav = document.getElementById(portletId + "Portlet").querySelector(".portletPageNav");
    
    var nodataArea = document.getElementById(tabBoardListId).querySelector(".nodata");
	if (nodataArea) {
		portletPageNav.style.display = "none";
	} else {
		portletPageNav.style.display = "block";
	}
	
	if (usePaging != '1') {
		portletPageNav.style.display = "none";
	}
    
    if (className.indexOf("on") > -1) {
        return;
    }

    var nodes = document.getElementsByClassName(className);
    
	Array.prototype.forEach.call(nodes, function(e, i){
		e.className = className.replace("on", "");
    });
    
    obj.className = "on " + obj.className;
    
    // tabBoardlist 변경
    try {
        allDisplayNone("#tabBoard .portlet_list");
        // tabBoardPlus 변경
        var object_ul = document.getElementById(obj.id.slice(0, -3));
        object_ul.style.display = "";
        tabBoardId = tabBoardIdArr[obj.id.slice(0, -3).slice(-1)]
    } catch (error) {}
}


function allDisplayNone(querySelector) {
    var nodes = document.querySelectorAll(querySelector);
    
	Array.prototype.forEach.call(nodes, function(e, i){
		e.style.display = "none";
	});
}

function openDoc_section3_Type(pItemID, pType, oBoardID, password) {
	openBoard(pItemID, pType, oBoardID, password);
}

function tabBoardPlus() {
    if (typeof tabBoardId != "undefined" && tabBoardId != "") {
        window.open("/ezBoard/boardMainRedirect.do?boardID=" + encodeURIComponent(tabBoardId), "main", "");
    }
}

function giveTooltipTitle(querySelector) {
    var nodes = document.querySelectorAll(querySelector);
    
	Array.prototype.forEach.call(nodes, function(e, i){
		e.setAttribute('title', e.innerText);
	});
}