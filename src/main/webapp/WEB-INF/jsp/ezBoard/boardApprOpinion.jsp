<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title><spring:message code='ezBoard.t999010'/></title>
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript">
        var pMod = "<c:out value='${mode}'/>";
        var ItemList = "<c:out value='${itemList}'/>";
        
        function btn_OK() {
            if (trim_Cross(txt_OpinionContent.value) == "") {
                alert("<spring:message code='ezBoard.t999067'/>");
                return;
            }

            var xmlhttpAppr = createXMLHttpRequest();
            xmlhttpAppr.open("POST", "/ezBoard/apprBoardItem.do?itemList=" + encodeURIComponent(ItemList) + "&mode=" + pMod, false);
            xmlhttpAppr.send();

            if (xmlhttpAppr.responseText == "OK") {
            	$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/sendReturnNotice.do",
					data : { 
							 content   : document.getElementById("txt_OpinionContent").value,
							 itemID    : ItemList
						   },
					success: function(result) {
						alert("<spring:message code='ezBoard.t999009'/>");
					}        			
				});
                
                try {
                    window.opener.refresh_onclick();
                    window.close();
                } catch (e) {

                }
                
		        var applyCount = "0";
		        
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/getApplyCount.do",
					success: function(text){
						applyCount = text;
					}     			
				});
		        
		       	$(window.opener.parent.frames['left'].document.getElementById("applyCount")).text(" " + applyCount);
                
            }
        }
        function btn_close() {
            window.close();
        }
    </script>
</head>
<body class="popup">
    <h1><spring:message code='ezBoard.t999010'/></h1>
    <div id="close">
        <ul>
            <li><span onclick="btn_close()"></span></li>
        </ul>
    </div>
    <h2 style="font-weight: normal">▒&nbsp;<spring:message code='ezBoard.t999011'/></h2>
    <textarea id="txt_OpinionContent" name="txt_OpinionContent" class="textarea" style="Width: 100%; Height: 150px; box-sizing: border-box; -moz-box-sizing: border-box; resize:none;"></textarea>
    <div class="btnposition btnpositionNew">
        <a class="imgbtn" ><span onclick="btn_OK()"><spring:message code='ezBoard.t14'/></span></a>
    </div>
</body>
</html>