// 2020-12-04 탭 게시판 포틀릿 - 박기범
var tabBoardId="";
var portletLang = ""; 
var tabBoardIdArr = new Array();

var getTabBoard = function () {
    var request = new XMLHttpRequest();
    request.open('GET', '/ezNewPortal/getTabBoardPortlet.do', true);
    request.setRequestHeader('Content-Type', 'application/json');

    request.onload = function () {
        if (request.status >= 200 && request.status < 400) {
            var result = JSON.parse(request.responseText);
            portletLang = result.portletLang;
            var docsHTML = "";
            var subDocsHTML = "";

            if (result.existence == "true") {
                allDisplayNone('#notexistence');
                allDisplayNone('#tabBoard .portletText');
                loadTabBoard(result.tabBoardId3, result.tabBoard3, result.tabBoardName3, 3);
                loadTabBoard(result.tabBoardId2, result.tabBoard2, result.tabBoardName2, 2);
                loadTabBoard(result.tabBoardId1, result.tabBoard1, result.tabBoardName1, 1);
            }

            document.getElementById('tabBoardPortletName').style.border = "none";
            giveTooltipTitle("#tabBoard .txt");
        } else {
            // We reached our target server, but it returned an error
        }
    };

    request.onerror = function () {
        // There was a connection error of some sort
    };
    request.send();
}
// 게시판 활성(스트링, 데이터, 스트링, 정수)
function loadTabBoard(rtabBoardId, tabBoard, tabBoardName, tabId) {
    if (typeof tabBoard != "undefined" && tabBoard != null) {
        var tabDocsHTML = "";

        tabBoard.forEach(function (item, index) {
            tabDocsHTML += dataAssemblerTabBoard(item);
        });

        if (tabDocsHTML == "") {
            tabDocsHTML += "<dl class='nodata'>";
			tabDocsHTML += "<dt><img src='/images/kr/main/noData_sIcon.png'></dt>";
			tabDocsHTML += "<dd>" + messages.strLang1 + "</dd>";
			tabDocsHTML += "</dl>";
        }

        document.getElementById('tabBoardList' + tabId).innerHTML = tabDocsHTML;
        var tabNode = document.getElementById('tabBoardList' + tabId + 'Tab');
        tabNode.firstChild.innerHTML = tabBoardName;
        tabNode.style.display = "";
        tabBoardIdArr[tabId] = rtabBoardId; // plus 버튼을 위한 변수 저장. tapBoardChangeTab위에 있어야 함
        tapBoardChangeTab(tabNode);
    }
}
// 게시글 한줄 생성(데이터)
var dataAssemblerTabBoard = function(object) {
	var today = new Date();
	var writeDate = new Date(object.writeDate);
	var date = today.getDate();
	today.setDate(date - 1);
	
	var str = "";
	str += "<li onclick='openDoc_section3_Type(\"" + object.itemID + "\", \"" + object.guBun + "\", \"" + object.boardID + "\")'>";
    str += "<span class='txt'>" + MakeXMLString(object.title) + "</span>";

	str += "<span class='date'>" + object.startDate.substring(5, 16).replace(/-/g, ".") + "</span>";

	// 2023-07-31 황인경 - 포탈 > 탭게시판 포틀릿 > 게시글 작성자 다국어 처리 
	if (portletLang == "2") {
		str += "<span class='name'>" + object.writerName2 + "</span>";
	} else {
		str += "<span class='name'>" + object.writerName + "</span>";
	}

	str += "</li>";
	return str;
}
// 탭변경(노드)
function tapBoardChangeTab(obj) {
    var className = obj.className;

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