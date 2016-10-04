<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
	    <link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript">
	        var ImageCount = "${imageCount}";
	        var BoardID = "${boardID}";
	
	        var ImageID = "";
	        var DelCount = 0;
	        var ImageFilePath = "";
	
	        window.onload = function ()
	        {
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
	                window.opener.page_reload();
	                window.close();
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
	    </script>
	</head>
	<body class="popup">
	    <table class="layout">
	         <tr>
	            <td style="height:20px">
	                <div id="menu">
	                    <ul>
	                    <li ID='btn_Delete'><span onclick="btn_Delete_Onclick()"><spring:message code='ezBoard.t89'/></span> </li>
	                    <li ID='CheckImage' ><span onclick='btn_AllCheck_Onclick()'><input type="checkbox" id="maincheck" style="display:none;"/><spring:message code='ezBoard.t1011'/></span></li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li ><span onclick="window.close()">
	                            <spring:message code='ezBoard.t12'/></span></li>
	                    </ul>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezBoard.t1023'/></th>
	        </tr>
	        <tr>
	            <td>
	                <div style="padding-top:10px;padding-bottom:10px;overflow-y:scroll;">
	                	<c:set var="result" value="${fn:split(listImages, ';')}"/>
	                	<c:set var="imageID" value="${fn:split(imageID, ';')}"/>
	                	<c:set var="content" value="${fn:split(imageContent, ';')}"/>
	                	<c:set var="flag" value="${fn:split(mainFg, ';')}"/>
	                	<c:set var="resultCount" value="${fn:length(result)}"/>
	                	<c:forEach begin="1" end="${resultCount}" step="1" varStatus="vs">
		                    <span><input type="checkbox" value="${imageID[vs.count-1]}" id="check${vs.count - 1}" flag="${flag[vs.count-1]}" onclick="checkMainFg(this)" /><img src='${result[vs.count-1]}' width='70px' height ='70px' title='${content[vs.count-1]}' id="image${vs.count - 1}" name='zb_target_resize' style='cursor:pointer;'/></span>
	                	</c:forEach>
	                </div>
	            </td>
	        </tr>
	    </table>
	</body>
</html>