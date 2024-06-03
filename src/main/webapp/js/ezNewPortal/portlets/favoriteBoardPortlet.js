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

const favoriteBoardPageMaxCnt = 21; 

function initFavoritePortlet(portletId) {
	var newObj = {};
	newObj.portletCode = "favoriteboard";
	newObj.activeTabId = "";
	newObj.tabIdList = [];
	newObj.paging = {};
    portletInfoMap["portlet" + portletId] = newObj;
    favoriteObj.portletId = portletId;
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

function getTabList() {
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
    		
    		var portletId = favoriteObj.portletId;
		    var favoritePortletObj = portletInfoMap["portlet" + portletId];
		    var perCount = getFavoriteBoardPagePerCount(portletId);
		    
    		if (tabCnt > 0) {
    		    if (tabCnt > 3)
    		    	tabCnt = 3;
    		    
    		    var listHTML = "";
    		    var plusHTML = "";
    		    var classon = "class='on'";
    		    
    		    for (var i = 0; i < tabCnt; i++) {
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
    	                listHTML += "<dt id='Board" + i + "' onclick='boardChangeTab(this)' data1='" + boardId + "'" + classon + " data2='" + guBun + "'><span> " + BoardName + " </span></dt>";
    	                boardType = guBun;
    	                favoritePortletObj.activeTabId = boardId;
    	            } else {
    		            listHTML += "<dt id='Board" + i + "' onclick='boardChangeTab(this)' data1='" + boardId + "' data2='" + guBun + "'><span> " + BoardName + " </span></dt>";
    		        }
    	            
    	            favoritePortletObj.tabIdList.push(boardId);
    	            
    		    	var favoriteBoardPage = new Paging().init(perCount);
    		    	
    		    	favoriteBoardPage.getPagePerCount = function () {
    		    		return getFavoriteBoardPagePerCount(portletId);
    		    	}
    		    	
    		    	favoritePortletObj.paging[boardId] = favoriteBoardPage;
    		    	
    		    }
    		    
		        // 2023-06-22 황인경 - 디자인 개선 > 즐겨찾기 포틀릿 > '+' 더보기 태그 위치 변경
		        plusHTML += "<dd class='portletPlus' onclick='Boardmore_NewBoardSTD_btnClick()'><img src='/images/ezNewPortal/portlet_Plus" + usedTheme + ".png'></dd>";
		        document.getElementById("BoardTabPlus").innerHTML = plusHTML;
				document.getElementById("BoardTab").innerHTML = listHTML;
		        favoriteBoardId = $('#Board0').attr('data1');
		        
		        getBoardList_NewBoardSTD();
		        
    		} else {
    			var listHTML = "";
    			listHTML += "<dl class='nodata'>";
    	    	listHTML += "<dt><img src='/images/kr/main/noData_sIcon.png'></dt>";
    	    	listHTML += '<dd>' + strLang1_NewBoardSTD + '</dd>';
    	    	listHTML += "</dl>";
    	    	
    	    	document.getElementById("BoardList").innerHTML = listHTML;
    		}
    		
       },
       error:function(request,status,error){
    	   }
	});	
}

function getBoardList_NewBoardSTD() {
    $.ajax({
    	type : "GET",
    	dataType : "json",
    	url : "/ezNewPortal/getFavoriteBoardList.do",
    	data : {
				boardId 	 : favoriteBoardId 
    	},
    	success : function(result){
		var title = "";
        var startDate = "";
   		var writerName = "";
   		var boardType = "";
   		var itemId = "";
		var RowCnt = result.length;
		var listHTML = "";
		var today = new Date();
		var date = today.getDate();
		today.setDate(date - 1);
		
		var totalCnt = 0;
    	
        if (RowCnt > 0) {
            for (var i = 0; i < RowCnt; i++) {
            title = result[i].title;
           	startDate = result[i].startDate;
           	writerName = result[i].writerName;
           	boardType = result[i].gubun;
           	boardId = result[i].boardId;
           	itemId = result[i].itemId;
            	
             listHTML += "<li onclick=\"openDoc_section4_Type('" + itemId + "','" + boardType + "', '" + boardId + "')\" >";			                        
             
             var writeDate = new Date(startDate);
     		
             // 2024-05-27 조수빈 - 새로운 시안에 N 표시가 삭제되어 주석 처리
//     		 if (today < writeDate) {
//     			listHTML += "<span class='boardNew'>N</span>";
//     		 }
             
             listHTML += "<span class='txt'>" + ConvertCharToEntityReference(title) + "</span>";
             listHTML += "<span class='date'>" + startDate.substring(5,16).replace(/-/g, ".") + "</span>";
             listHTML += "<span class='name'>" + writerName + "</span>";
             listHTML += "</li>";
            }
            
            document.getElementById("BoardList").innerHTML = listHTML;
            
            totalCnt = RowCnt < favoriteBoardPageMaxCnt ? RowCnt : favoriteBoardPageMaxCnt;
            
        } else {
            
        	var listHTML = "";
			listHTML += "<dl class='nodata'>";
        	listHTML += "<dt><img src='/images/kr/main/noData_sIcon.png'></dt>";
        	listHTML += '<dd>' + strLang1_NewBoardSTD + '</dd>';
        	listHTML += "</dl>";
        	
        	document.getElementById("BoardList").innerHTML = listHTML;
        }
        var portletId = favoriteObj.portletId;
        resetPortletList(portletId, totalCnt, favoriteBoardId);
	},
    	error : function(error){
    		console.log("<spring:message code='ezBoard.t22'/>wpNewBoardSTD" + error);	
    	}
    });
}

function openDoc_section4_Type(pItemID, pType, oBoardID) {
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
