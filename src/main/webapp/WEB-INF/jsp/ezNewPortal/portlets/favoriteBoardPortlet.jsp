<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<link href="${util.addVer('main.e6', 'msg')}" rel="stylesheet" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript">
var strLang1_NewBoardSTD = "<spring:message code='main.t00026' />";

var ParentBoardName = "";
var BoardType = "";
var favoriteBoardId = "";

document.onselectstart = function () { return false; };

window.onload = function() {
    if (navigator.userAgent.indexOf('Firefox') != -1) {
        document.body.style.MozUserSelect = 'none';
        document.body.style.WebkitUserSelect = 'none';
        document.body.style.khtmlUserSelect = 'none';
        document.body.style.oUserSelect = 'none';
        document.body.style.UserSelect = 'none';
    }
    getTabList();
}

function getTabList() {
	var resultList = GetMyBoardItem();
	var tabCnt = 0;
	
	tabCnt = resultList.size();
	
	if (tabCnt > 0) {
	    if (tabCnt > 3)
	    	tabCnt = 3;
	    
	    var listHTML = "";
	    var classon = "class='on'";
	
	    for (var i = 0; i < resultList; i++) {
	        var BoardName = "";
	        var boardId = "";
	        var guBun = "";
	        
	        boardId = resultList.boardId;
	        guBun = resultList.guBun;
	        
	        if ("${userInfo.primary}" == "1")
	                BoardName = resultList.boardName;
	            else
	                BoardName = resultList.boardName2;
	            if (i == 0) {
	                listHTML += "<dt id='Board" + i + "' onclick='boardChangeTab(this)' data1='" + boardId + "'" + classon + " data2='" + guBun + "'><span> " + BoardName + " </span></dt>";
	                boardType = guBun;
	            }
	            else
	                listHTML += "<dt id='Board" + i + "data1='" + boardId + "' data2='" + guBun + "'><span> " + BoardName + " </span></dt>";
	        }
	
	        listHTML += "<dd class='portletPlus' onclick='Boardmore_NewBoardSTD_btnClick()'><img src='/images/kr/main/portlet_Plus.png'></dd>";		                
	
	        document.getElementById("BoardTab").innerHTML = listHTML;
	        favoriteBoardId = $('#Board0').attr('DATA1');
	        getBoardList_NewBoardSTD();
	    } else {
	    	
	    }
}

function GetMyBoardItem() {
   	var resultList;
   	var mode = "USE";
   	
   	$.ajax ({
	   	url : '/ezNewPortal/favoriteBoardPortletList.do',
	   	type : 'POST',
       dataType : 'json',
       data : { 
       },
       cache: false,
       success: function(result) {
       resultList = result["resultList"];
       },
       error : function() {
           	
       }
	});
   	
	return resultList;
}

function getBoardList_NewBoardSTD() {
    $.ajax({
    	type : "POST",
    	dataType : "text",
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

        if (RowCnt > 0) {
	        if (RowCnt > 5) {
        		RowCnt = 5;
	        }

            for (var i = 0; i < RowCnt; i++) {
            title = result[i].title;
           	startDate = result[i].startDate;
           	writerName = result[i].writerName;
           	boardType = result[i].
            	
             listHTML += "<li onclick=\"openDoc_section4_Type('" + itemId + "','" + boardType + "', '" + boardId + "')\" >";			                        
             
             listHTML += "<span class='txt'>" + title + "</span>";
             listHTML += "<span class='date'>" + startDate.substring(5,16) + "</span>";
             listHTML += "<span class='name'>" + writerName + "</span>";
            }
            
            listHTML += "</ul>";
            document.getElementById("BoardList").innerHTML = listHTML;
                
        } else {
            
        	var listHTML = "";
			listHTML += "<dl class='nodata'>";
        	listHTML += "<dt><img src='/images/kr/main/nodata.png'></dt>";
        	listHTML += '<dd>"' + strLang1_NewBoardSTD + '"</dd>';
        	listHTML += "</dl>";
        	
        	document.getElementById("BoardList").innerHTML = listHTML;
        }
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
		pLeft = (pwidth - 764) / 2;

       window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + oBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height + ",width=764,top=" + pTop + ",left=" + pLeft, "");
   } else {
       if (CrossYN()) {
           window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + oBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
       } else {
           window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + oBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
       }
   }
}



function boardChangeTab(obj) {
    switch (obj.id) {
        case "Board0":
            document.getElementById("Board0").className = "on";
            for (var i = 1; i < BoardCnt_NewBoardSTD; i++) {
                document.getElementById("Board" + i).className = "";
            }
            break;

        case "Board1":

            document.getElementById("Board0").className = "";
            document.getElementById("Board1").className = "on";
            if (BoardCnt_NewBoardSTD == 3)
                document.getElementById("Board2").className = "";
            break;

        case "Board2":

            document.getElementById("Board0").className = "";
            document.getElementById("Board1").className = "";
            document.getElementById("Board2").className = "on";
            break;
    }
    
    pBoardID_NewBoardSTD = document.getElementById(obj.id).getAttribute("data1");
    pBoardType_NewBoardSTD = document.getElementById(obj.id).getAttribute("data2");
    getBoardList_NewBoardSTD();
}

function Boardmore_NewBoardSTD_btnClick() {
    window.open("/ezBoard/boardMainRedirect.do?boardID=" + pBoardID_NewBoardSTD, "main", "");
}
    
function refresh_onclick() {
    if (document.getElementById("Board0").className == "on") {
        pBoardID_NewBoardSTD = document.getElementById("Board0").getAttribute("data1");
        getBoardList_NewBoardSTD();
    }
    else if (document.getElementById("Board1").className == "on") {
        pBoardID_NewBoardSTD = document.getElementById("Board1").getAttribute("data1");
        getBoardList_NewBoardSTD();
    }
    else {
        pBoardID_NewBoardSTD = document.getElementById("Board2").getAttribute("data1");
        getBoardList_NewBoardSTD();
    }
}		        
</script>
</head>
<body>
	<div class="layDIV">
           <dl class="portlet_tab" id="BoardTab"></dl>
           <ul class="portlet_list" id="BoardList"></ul>
       </div>		
</body>
</html>