/**
 * 
 */
var strLang1_NewBoardSTD = messages.strLang1;
var ParentBoardName = "";
var BoardType = "";
var favoriteBoardId = "";
var tabCnt = 0;
var usedTheme = $('#usedTheme').val();

function getTabList() {
	var resultList;	
	var mode = "USE";
   	
   	$.ajax ({
	   url : '/ezNewPortal/favoriteBoardPortletList.do',
	   type : 'POST',
       dataType : 'json',
       data : { 
    	   "mode" : mode
       },
       cache: false,
       success: function(result) {
    		
    		tabCnt = result.length;
    		
    		if (tabCnt > 0) {
    		    if (tabCnt > 3)
    		    	tabCnt = 3;
    		    
    		    var listHTML = "";
    		    var classon = "class='on'";
    		
    		    for (var i = 0; i < tabCnt; i++) {
    		        var BoardName = "";
    		        var boardId = "";
    		        var guBun = "";
    		        
    		        boardId = result[i].boardId;
    		        guBun = result[i].guBun;
    		        BoardName = result[i].boardName;
    		        
    	            if (i == 0) {
    	                listHTML += "<dt id='Board" + i + "' onclick='boardChangeTab(this)' data1='" + boardId + "'" + classon + " data2='" + guBun + "'><span> " + BoardName + " </span></dt>";
    	                boardType = guBun;
    	            } else {
    		            listHTML += "<dt id='Board" + i + "' onclick='boardChangeTab(this)' data1='" + boardId + "' data2='" + guBun + "'><span> " + BoardName + " </span></dt>";
    		        }
    		    }
    		        listHTML += "<dd class='portletPlus' onclick='Boardmore_NewBoardSTD_btnClick()'><img src='/images/ezNewPortal/portlet_Plus"+usedTheme+".png'></dd>";		                
    		
    		        document.getElementById("BoardTab").innerHTML = listHTML;
    		        favoriteBoardId = $('#Board0').attr('data1');
    		        getBoardList_NewBoardSTD();
    		    } else {
    			var listHTML = "";
    			listHTML += "<dl class='nodata'>";
    	    	listHTML += "<dt><img src='/images/kr/main/nodata.png'></dt>";
    	    	listHTML += '<dd>"' + strLang1_NewBoardSTD + '"</dd>';
    	    	listHTML += "</dl>";
    	    	
    	    	document.getElementById("BoardList").innerHTML = listHTML;
    		}
       },
       error:function(request,status,error){
    	    alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
    	   }
	});	
}

function getBoardList_NewBoardSTD() {
    $.ajax({
    	type : "POST",
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

        if (RowCnt > 0) {
	        if (RowCnt > 5) {
        		RowCnt = 5;
	        }

            for (var i = 0; i < RowCnt; i++) {
            title = result[i].title;
           	startDate = result[i].startDate;
           	writerName = result[i].writerName;
           	boardType = result[i].gubun;
           	boardId = result[i].boardId;
           	itemId = result[i].itemId;
            	
             listHTML += "<li onclick=\"openDoc_section4_Type('" + itemId + "','" + boardType + "', '" + boardId + "')\" >";			                        
             
             listHTML += "<span class='txt'>" + title + "</span>";
             listHTML += "<span class='date'>" + startDate.substring(5,16) + "</span>";
             listHTML += "<span class='name'>" + writerName + "</span>";
             listHTML += "</li>";
            }
            
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
   } else if (pType == "7") {
	   var height = 679;
	   pTop = (pheight - 679) / 2;
	   pLeft = (pwidth - 764) / 2;

      window.open("/ezBoard/boardItemViewMovie.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + oBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height + ",width=764,top=" + pTop + ",left=" + pLeft, "");
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
    getBoardList_NewBoardSTD();
}

function Boardmore_NewBoardSTD_btnClick() {
    window.open("/ezBoard/boardMainRedirect.do?boardID=" + favoriteBoardId, "main", "");
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