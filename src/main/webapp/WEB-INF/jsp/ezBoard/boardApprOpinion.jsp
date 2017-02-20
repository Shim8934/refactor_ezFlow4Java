<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    <script type="text/javascript">
        var pMod = "${mode}";
        var ItemList = "${itemList}";
        function btn_OK() {
            if (trim_Cross(txt_OpinionContent.value) == "") {
                alert("<spring:message code='ezBoard.t999067'/>");
                return;
            }

            var xmlhttpAppr = createXMLHttpRequest();
            xmlhttpAppr.open("POST", "/ezBoard/apprBoardItem.do?itemList=" + ItemList + "&mode=" + pMod, false);
            xmlhttpAppr.send();

            if (xmlhttpAppr.responseText == "OK") {
            	$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/sendReturnNoticeMail.do",
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
            }
        }
        function btn_close() {
            window.close();
        }
    </script>
</head>
<body class="popup">
    <h1><spring:message code='ezBoard.t999010'/></h1>
    <h2><spring:message code='ezBoard.t999011'/></h2>
    <textarea id="txt_OpinionContent" name="txt_OpinionContent" class="textarea" style="Width: 100%; Height: 150px; box-sizing: border-box; -moz-box-sizing: border-box;"></textarea>
    <div class="btnposition">
        <a class="imgbtn" ><span onclick="btn_OK()"><spring:message code='ezBoard.t14'/></span></a>
        <a class="imgbtn" ><span onclick="btn_close()"><spring:message code='ezBoard.t12'/></span></a>
    </div>
</body>
</html>