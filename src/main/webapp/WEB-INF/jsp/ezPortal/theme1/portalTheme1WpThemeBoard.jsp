<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<link href="/css/theme01.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApproval/lang/ezApproval.js"></script>
		<script type="text/javascript">
		 	var xmlhttp = createXMLHttpRequest();
	        var pBoardType = "${pBoardType}";
	        var Read_FG = "true";
	        var strlang = "${userInfo.lang}";
	        var strLang1 = "<spring:message code='main.t00026'/>";

	        window.onload = function () {
	            getNewBoardList();

	            try { top.onresize() } catch (e) { }
	        }

	        function getNewBoardList() {
	            $.ajax({
    	        	type : "POST",
    	        	dataType : "text",
    	        	url : "/ezBoard/getBoardList.do",
    	        	data : {
    	        		boardType   : "N", 
					 	boardId 	 : "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}", 
					    pageNum 	 : "1", 
						orderCell 	 : "", 
						orderOption : ""
    	        	},
    	        	success : function(xml){
    	        		getBoardList_after(loadXMLString(xml));
    	        	},
    	        	error : function(error){
    	        		console.log("<spring:message code='ezBoard.t22'/>portalWpNewBoard" + error);	
    	        	}
    	        	});
	            
	        }
	        function getBoardList_after(xml) {
	        	if (xml == null) return;

	            document.getElementById("newboard_list").innerHTML = "";
	            var xmldom = xml;
	            var listHTML = "";
	            for (var i = 0; i < 5; i++) {
	                if (i == xmldom.getElementsByTagName("ROW").length) break;
	                listHTML += "<li onclick='ItemReadNewBoard_onclick(this)' style='cursor:pointer;'";
	                if (CrossYN()) {
	                    for (var j = 3; j < GetElementsByTagName(GetElementsByTagName(xmldom, "ROW")[i], "CELL")[0].childNodes.length; j++) {
	                        listHTML += " data" + Math.floor(j / 2) + "='" + getNodeText(GetElementsByTagName(GetElementsByTagName(xmldom, "ROW")[i], "CELL")[0].childNodes[j]) + "'";
	                        j++
	                    }
	                }
	                else {
	                    for (var j = 1; j < GetElementsByTagName(GetElementsByTagName(xmldom, "ROW")[i], "CELL")[0].childNodes.length; j++) {
	                        listHTML += " data" + j + "='" + getNodeText(GetElementsByTagName(GetElementsByTagName(xmldom, "ROW")[i], "CELL")[0].childNodes[j]) + "'";
	                    }
	                }
	                listHTML += "><span class='title'><strong>[" + getNodeText(GetElementsByTagName(GetElementsByTagName(xmldom, "ROW")[i], "CELL")[2]);
	                listHTML += "]</strong> " + getNodeText(GetElementsByTagName(GetElementsByTagName(xmldom, "ROW")[i], "CELL")[3]);
	                listHTML += " </span><span class='name'>" + getNodeText(GetElementsByTagName(GetElementsByTagName(xmldom, "ROW")[i], "CELL")[5]);
	                listHTML += "</span><span class='day'>" + getNodeText(GetElementsByTagName(GetElementsByTagName(xmldom, "ROW")[i], "CELL")[6]) + "</span></li>"
	            }
	            if (xmldom.getElementsByTagName("ROW").length == 0) {
	                listHTML = "<div class='nodata_w'>";
	                listHTML += "<p><img src='/images/kr/theme01/main/nodata_gray.png'></p>";
	                listHTML += "<p>" + strLang1 + "</p>";
	                listHTML += "</div>";
	            }
	            document.getElementById("newboard_list").innerHTML += listHTML;
	        }
	        function ItemReadNewBoard_onclick(obj) {
	            if (Read_FG != "true") {
	                alert("<spring:message code='ezBoard.t194' />");
	                return;
	            }

	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 720) / 2;
	            var pLeft = (pwidth - 765) / 2;

	            if (obj.getAttribute("DATA10") == "3" || obj.getAttribute("DATA10") == "4") {
	                window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=&itemID=" + obj.getAttribute("DATA2") + "&boardID=" + obj.getAttribute("DATA1"), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=770,width=765,top=" + pTop + ",left=" + pLeft, "");
	            }
	            else {
	                if (CrossYN())
	                    window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=&itemID=" + obj.getAttribute("DATA2") + "&boardID=" + obj.getAttribute("DATA1"), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
	                else
	                    window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=&itemID=" + obj.getAttribute("DATA2") + "&boardID=" + obj.getAttribute("DATA1"), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
	            }
	            getNewBoardList();
	        }
	        function NewBoardmore_btnClick() {
	            parent.location.href = "/ezBoard/boardMainRedirect.do";
	            if (CrossYN())
	                parent.frames["right"].location.href = "/myoffice/ezBoardSTD/BoardItemList_Photo.aspx?BoardID={FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}&BoardName=" + escape("<spring:message code='ezBoard.t480'/>") + "&BoardType=N";
	        }
		</script>
	</head>
	<body>
		<div class="content_board">
        	<dl class="content_title01">
            	<dt><spring:message code='main.t00047' /></dt>
            	<dd onclick="NewBoardmore_btnClick()"><spring:message code='main.t1008' /></dd>
        	</dl>
        	<ul class="content_list01" id="newboard_list">
        	</ul>
    	</div>
	</body>
</html>