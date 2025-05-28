/**
 * 
 */
var strLang1_NewBoardSTD = messages.strLang1;
var ParentBoardName = "";
var BoardType = "";
var favoriteBoardId = "";
var tabCnt = 0;
var usedTheme = $('#usedTheme').val();

var favoriteObj = {}

function initFavoritePortlet(portletId) {
	var newObj = {};
	newObj.portletCode = "favoriteboard";
	newObj.activeTabId = "";
	newObj.tabIdList = [];
	newObj.tabBoardIdList = [];
	newObj.tabBoardNameList = [];
	newObj.paging = {};
    portletInfoMap["portlet" + portletId] = newObj;
    favoriteObj.portletId = portletId;
    newObj.page = new Paging().setPageStart(1).init(getFavoriteBoardPagePerCount(portletId));
    newObj.page.getPagePerCount = function () {
		return getFavoriteBoardPagePerCount(portletId);
	}
    newObj.getPortletList = function () {
    	var activeTabId = newObj.activeTabId;
    	var activeTabIndex = newObj.tabIdList.indexOf(activeTabId);
    	var activeBoardId = newObj.tabBoardIdList[activeTabIndex];
    	var activeBoardName = newObj.tabBoardNameList[activeTabIndex];
    	
		getBoardList_NewBoardSTD();
	}
    
    document.getElementById(portletId + "Portlet").querySelector('.favoriteBoardPorlet').value = portletId;
    getTabList(portletId);
}

function getFavoriteBoardPagePerCount() {
	var portletSize = getPortletSize(favoriteObj.portletId);
	var count = 0;
	
	if (portletSize === GridSize.TWO_BY_ONE || portletSize === GridSize.TWO_BY_TWO) {
		count = 7;
	} else {
		count = 3;
	}

	return count;
}

function getTabList(portletId) {
	var resultList;	
	var mode = "USE";
   	
   	$.ajax ({
	   url : '/ezNewPortal/favoriteBoardPortletList.do',
	   type : 'GET',
       dataType : 'json',
       data : { 
    	   "mode" : mode
       },
       cache: false,
       success: function(result) {
    		tabCnt = result.length;
    		
		    var favoritePortletObj = portletInfoMap["portlet" + portletId];
		    var perCount = getFavoriteBoardPagePerCount(portletId);
    		if (tabCnt > 0) {
    		    if (tabCnt > 3)
    		    	tabCnt = 3;
    		    
    		    var listHTML = "";
    		    var plusHTML = "";
    		    var classon = "class='on'";
    		    
    		    for (var i = 0; i < tabCnt; i++) {
    		    	
    		    	var tabBoardPage = new Paging().setPageStart(1).init(perCount);
                	tabBoardPage.getPagePerCount = function () {
                		return getFavoriteBoardPagePerCount(portletId);
                	}
                	
    		        var BoardName = "";
    		        var boardId = "";
    		        var guBun = "";
    		        
    		        boardId = result[i].boardId;
    		        guBun = result[i].guBun;
    		        BoardName = result[i].boardName;
    		        
    		        if (boardId == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
    		        	BoardName = messages.strLang23;
    		        }
    		        
    	            if (i == 0) {
    	                listHTML += "<dt id='Board" + i + "' onclick='boardChangeTab(this)' data1='" + boardId + "'" + classon + " data2='" + guBun + "'><span class='longTitle'> " + BoardName + " </span></dt>";
    	                boardType = guBun;
    	                favoritePortletObj.activeTabId = boardId;
    	            } else {
                        listHTML += "<dt id='Board" + i + "' onclick='boardChangeTab(this)' data1='" + boardId + "' data2='" + guBun + "'><span class='longTitle'> " + BoardName + " </span></dt>";
    		        }
    	            
    	            favoritePortletObj.tabIdList.push(boardId);
    	            
    		    	var favoriteBoardPage = new Paging().setPageStart(1).init(perCount);
    		    	
    		    	favoriteBoardPage.getPagePerCount = function () {
    		    		return getFavoriteBoardPagePerCount(portletId);
    		    	}
    		    	
    		    	favoritePortletObj.paging[boardId] = favoriteBoardPage;
    		    	
    		    }
    		    
		        // 2023-06-22 황인경 - 디자인 개선 > 즐겨찾기 포틀릿 > '+' 더보기 태그 위치 변경
		        // plusHTML += "<dd class='portletPlus' onclick='Boardmore_NewBoardSTD_btnClick()'><img src='/images/ezNewPortal/portlet_Plus" + usedTheme + ".png'></dd>";

				// img태그 > 백그라운드처리(css) (uiux팀 - 조기완)
				plusHTML += "<dd class='portletPlus plus' onclick='Boardmore_NewBoardSTD_btnClick()'></dd>";
		        document.getElementById("BoardTabPlus").innerHTML = plusHTML;
				document.getElementById("BoardTab").innerHTML = listHTML;
		        favoriteBoardId = $('#Board0').attr('data1');
		        
		        getBoardList_NewBoardSTD();
		        
    		} else {
    			var portletTitle = "<dt><span>" + messages.strLangFavorPortlet + "</span></dt>";
    			document.getElementById("BoardTab").innerHTML = portletTitle;
    			var listHTML = "";
    			listHTML += "<dl class='nodata'>";
    	    	listHTML += "<dt><img src='/images/kr/main/noData_sIcon.png'></dt>";
    	    	listHTML += '<dd>' + messages.strLang17 + '</dd>';
    	    	listHTML += "</dl>";
    	    	
    	    	document.getElementById("BoardList").innerHTML = listHTML;
    	    	document.getElementById(portletId + "Portlet").querySelector(".portletPageNav").style.display = "none";
    		}
    		
       },
       error:function(request,status,error){
    	   var portletTitle = "<dt><span>" + messages.strLangFavorPortlet + "</span></dt>";
		   document.getElementById("BoardTab").innerHTML = portletTitle;
    	   var listHTML = "";
		   listHTML += "<dl class='nodata'>";
	       listHTML += "<dt><img src='/images/kr/main/noData_sIcon.png'></dt>";
	       listHTML += '<dd>' + messages.strLang2 + '</dd>';
	       listHTML += "</dl>";
	    	
	       document.getElementById("BoardList").innerHTML = listHTML;
	       document.getElementById(portletId + "Portlet").querySelector(".portletPageNav").style.display = "none";
       }
	});	
}

function getBoardList_NewBoardSTD() {
	var favorPortletInfo = portletInfoMap["portlet" + favoriteObj.portletId];
	var activeTabId = favorPortletInfo.activeTabId;
	var favoriteBoardPage = favorPortletInfo.paging[activeTabId];
	
    $.ajax({
    	type : "GET",
    	dataType : "json",
    	url : "/ezNewPortal/getFavoriteBoardList.do",
    	data : {
				boardId 	 : favoriteBoardId,
				currentPage : favoriteBoardPage.getPage(),
				listCnt : getFavoriteBoardPagePerCount(favoriteObj.portletId)
    	},
    	success : function(result) {
	    	var favList = result.favList;
			var title = "";
	        var startDate = "";
	   		var writerName = "";
	   		var boardType = "";
	   		var itemId = "";
			var RowCnt = favList.length;
			var listHTML = "";
			var today = new Date();
			var date = today.getDate();
			today.setDate(date - 1);
			var currentPage = result.currentPage;
			var totalCnt = result.totalCnt;
	    	
	        if (RowCnt > 0) {
	            for (var i = 0; i < RowCnt; i++) {
					title = favList[i].title;
					startDate = favList[i].startDate;
					writerName = favList[i].writerName;
					boardType = favList[i].gubun;
					boardId = favList[i].boardId;
					itemId = favList[i].itemId;
					var publicFlag = favList[i].publicFlag;
				
					if (publicFlag === 'N' && boardType === '2') {
							listHTML += "<li onclick=\"openAnonymousModal('" + favoriteObj.portletId + "','" + itemId + "','" + boardType + "', '" + boardId + "',openDoc_section4_Type)\" >";
					} else {
						listHTML += "<li onclick=\"openDoc_section4_Type('" + itemId + "','" + boardType + "', '" + boardId + "')\" >";
					}

	             var writeDate = new Date(startDate);
	     		
	     		 if (today < writeDate) {
	     			listHTML += "<span class='boardNew'>N</span>";
	     		 }
	             
	             listHTML += "<span class='txt'>" + ConvertCharToEntityReference(title);
				  if (publicFlag === 'N') {
	             	listHTML += " <div class='board_private'></div>";
				  }
				  listHTML += "</span>";
	             listHTML += "<span class='date'>" + startDate.substring(5,16).replace(/-/g, ".") + "</span>";
	             listHTML += "<span class='name'>" + writerName + "</span>";
	             listHTML += "</li>";
	            }
	            
	            document.getElementById("BoardList").innerHTML = listHTML;
	            
	        } else {
	        	var listHTML = "";
				listHTML += "<dl class='nodata'>";
	        	listHTML += "<dt><img src='/images/kr/main/noData_sIcon.png'></dt>";
	        	listHTML += '<dd>' + strLang1_NewBoardSTD + '</dd>';
	        	listHTML += "</dl>";
	        	
	        	document.getElementById("BoardList").innerHTML = listHTML;
	        }
	        var portletId = favoriteObj.portletId;
	        resetPortletPaging(portletId, totalCnt, currentPage, favoriteBoardId);
		},
    	error : function(error) {
			var listHTML = "";
			listHTML += "<dl class='nodata'>";
			listHTML += "<dt><img src='/images/kr/main/noData_sIcon.png'></dt>";
			listHTML += '<dd>' + messages.strLang2 + '</dd>';
			listHTML += "</dl>";
			document.getElementById("BoardList").innerHTML = listHTML;
			resetPortletPaging(favoriteObj.portletId, 0, 1, favoriteBoardId);
    	}
    });
}

function openDoc_section4_Type(pItemID, pType, oBoardID, password) {
    openBoard(pItemID, pType, oBoardID, password);
}

function boardChangeTab(obj) {
    switch (obj.id) {
        case "Board0":
            document.getElementById("Board0").className = "on";
            for (var i = 1; i < tabCnt; i++) {
                document.getElementById("Board" + i).className = "";
            }
            break;

        case "Board1":

            document.getElementById("Board0").className = "";
            document.getElementById("Board1").className = "on";
            if (tabCnt == 3)
                document.getElementById("Board2").className = "";
            break;

        case "Board2":

            document.getElementById("Board0").className = "";
            document.getElementById("Board1").className = "";
            document.getElementById("Board2").className = "on";
            break;
    }
    
    favoriteBoardId = document.getElementById(obj.id).getAttribute("data1");
    var portletId = favoriteObj.portletId;
    portletInfoMap["portlet" + portletId].activeTabId = favoriteBoardId;
    getBoardList_NewBoardSTD();
}

function Boardmore_NewBoardSTD_btnClick() {
    window.open("/ezBoard/boardMainRedirect.do?boardID=" + encodeURIComponent(favoriteBoardId), "main", "");
}
    
function refresh_onclick() {
    if (document.getElementById("Board0").className == "on") {
        favoriteBoardId = document.getElementById("Board0").getAttribute("data1");
        getBoardList_NewBoardSTD();
    }
    else if (document.getElementById("Board1").className == "on") {
        favoriteBoardId = document.getElementById("Board1").getAttribute("data1");
        getBoardList_NewBoardSTD();
    }
    else {
        favoriteBoardId = document.getElementById("Board2").getAttribute("data1");
        getBoardList_NewBoardSTD();
    }
}
