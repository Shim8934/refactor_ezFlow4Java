<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezBoard.t1003'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript">
	        var ImageCount = "${imageCount}";
	        var BoardID = "<c:out value='${boardID}'/>";
			var ItemID = "<c:out value='${itemID}'/>";
			var isAllGroupBoard = "<c:out value='${isAllGroupBoard}'/>";
	        var ImageID = "";
	        var DelCount = 0;
	        var ImageFilePath = "";
	
	        window.onload = function () {
	        	document.getElementById("allImageList").addEventListener("click", click_image);
	        };
	
	        function btn_Delete_Onclick() {
	            for (var i = 0; i < ImageCount; i++) {
	
	                if (document.getElementById("check" + i).checked) {
	                    DelCount = DelCount + 1;
	                    ImageID += document.getElementById("check" + i).value + ";";
	                    ImageFilePath += decodeURI(document.getElementById("image" + i).src);
	                }
	            }
	
	            if (DelCount == 0) {
	                alert("<spring:message code='ezBoard.t1017'/>");
	                DelCount = 0;
	
	                ImageID = "";
	                ImageFilePath = "";
	                return;
	            }
	
	            if (DelCount == ImageCount) {
	                alert("<spring:message code='ezBoard.t1018'/>");
	                DelCount = 0;
	
	                ImageID = "";
	                ImageFilePath = "";
	                return;
	            }
	
	            DelCount = 0;
				var resultText = "";
	            $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/deleteImageItem.do",
					data : { mod       : "Del", 
							 boardID   : BoardID,
							 imageIDs  : ImageID
						   },
					success: function(result){
						resultText = result;
					}        			
				});
	
	            if (resultText == "OK") {
	                alert("<spring:message code='ezBoard.t1019'/>");
	                
	                sendBoardAlert("modify", BoardID, ItemID, isAllGroupBoard);
	                
	                /* 2019-01-15 홍승비 - 사진삭제 후 DB에 게시물 수정일자 업데이트 */
                    $.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezBoard/modUpdateDate.do",
						data : {
							itemID  : ItemID
						},
						success : function(result) {
							window.opener.page_reload();
							window.close();
						}
					});
	            }
	            else
	                alert("<spring:message code='ezBoard.t1020'/>");
	        }
	
	        function btn_AllCheck_Onclick() {
	
	            if (document.getElementById("maincheck").checked == false) 
	            {
	                document.getElementById("maincheck").checked = true;
	
	                for (var i = 0; i < ImageCount; i++) 
	                {
	                    if(document.getElementById("check" + i).getAttribute("flag") != "Y" )
	                        document.getElementById("check" + i).checked = true;
	                }
	            }
	            else 
	            {
	                document.getElementById("maincheck").checked = false;
	
	                for (var i = 0; i < ImageCount; i++) 
	                {
	                    document.getElementById("check" + i).checked = false;
	                }
	            }
	        }
	
	        function checkMainFg(inputEle) {
	            if (inputEle.getAttribute("flag") == "Y") {
	                alert("<spring:message code='ezBoard.t1024'/>");
	                inputEle.checked = false;
	            }
	        }
	        
	        function click_image(event) {
	        	var imageElem = event.target;
	        	
	        	if(imageElem.nodeName == "IMG") {
		        	var checkboxElem = imageElem.previousElementSibling;
		        	
		        	checkboxElem.checked = !checkboxElem.checked;
		        	
		        	checkMainFg(checkboxElem);
	        	}
	        }
	        
	        /* 2021-06-22 홍승비 - 게시판 메일알림 함수 추가, 비동기로 백그라운드 동작 */
	        function sendBoardAlert(pMode, pBoardID, pItemID, pIsAllGroupBoard) {
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezBoard/sendBoardAlert.do",
					data : {
						mode : pMode,
						boardID : pBoardID,
						itemID : pItemID,
						isAllGroupBoard : pIsAllGroupBoard
					}
				});
	        }
	        
	    </script>
	</head>
	<body class="popup">
	    <table class="layout">
	         <tr>
	            <td style="height:20px">
	                <div id="menu">
	                    <ul>
	                    <li ID='btn_Delete'><span onclick="btn_Delete_Onclick()"><spring:message code='ezBoard.t89'/></span> </li>
	                    <li ID='CheckImage' ><span onclick='btn_AllCheck_Onclick()'><div class="custom_checkbox"><input type="checkbox" id="maincheck" style="display:none;"/></div><spring:message code='ezBoard.t1011'/></span></li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li ><span onclick="window.close()"></span></li>
	                    </ul>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <th style="font-size:13px;"><spring:message code='ezBoard.t1023'/></th>
	        </tr>
	        <tr>
	            <td>
	                <div class="layout" style="padding-top:10px;padding-bottom:5px;overflow-y:auto;height:410px;" id="allImageList">
	                	<c:set var="result" value="${fn:split(listImages, '|')}"/>
	                	<c:set var="imageID" value="${fn:split(imageID, ';')}"/>
	                	<c:set var="content" value="${fn:split(imageContent, ';')}"/>
	                	<c:set var="flag" value="${fn:split(mainFg, ';')}"/>
	                	<c:set var="resultCount" value="${fn:length(result)}"/>
	                	<c:forEach begin="1" end="${resultCount}" step="1" varStatus="vs">
		                    <div style="display:inline-block">
		                    	<div class="custom_checkbox">
			                    	<input type="checkbox" value="${imageID[vs.count-1]}" id="check${vs.count - 1}" flag="${flag[vs.count-1]}" onclick="checkMainFg(this)" style="vertical-align: top; position: relative; z-index: 1; left:12px; top: 8px;"/>
		                    		<img src='${result[vs.count-1]}' width='100px' height ='100px' title='${content[vs.count-1]}' id="image${vs.count - 1}" name='zb_target_resize' style='cursor:pointer; position: relative; right: 13px'/>
								</div>
		                    </div>
	                	</c:forEach>
	                </div>
	            </td>
	        </tr>
	    </table>
	</body>
</html>