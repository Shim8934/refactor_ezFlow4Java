<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
	<head>
	    <title><spring:message code='ezBoard.t1005'/></title>
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
		    var pBoardID = "";
		    var pItemID = "";
		    var pTitle = "";
		    var pContent = "";
		    var pMode = "";
		    var ReturnFunction;
		    window.onload = function () {
		        try {
		            ReturnFunction = parent.photoalbumedit_dialogArguments[1];
		            pBoardID = parent.photoalbumedit_dialogArguments[0][0];
		            pItemID = parent.photoalbumedit_dialogArguments[0][1];
		            pTitle = parent.photoalbumedit_dialogArguments[0][2];
		            pContent = parent.photoalbumedit_dialogArguments[0][3];
		            pMode = parent.photoalbumedit_dialogArguments[0][4];
		        } catch (e) {
		            pBoardID = dialogArguments[0];
		            pItemID = dialogArguments[1];
		            pTitle = dialogArguments[2];
		            pContent = dialogArguments[3];
		            pMode = dialogArguments[4];
		        }
		
		        try {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                var input = document.getElementsByTagName("input");
		                for (var i = 0; i < input.length; i++) {
		                    if (input[i].getAttribute("type") == "text")
		                        KeEventControl(input[i]);
		                }
		            }
		        }
		        catch (e)
		        { }
		
		        if (pMode != "temp") pMode = "add";
		        document.getElementById("title").value = pTitle;
		        document.getElementById("content").value = pContent;
		
		
		    };
		    function updatealbum() {
		        var pTitle = document.getElementById("title").value;
		        var pContent = document.getElementById("content").value;
		
		        var xmlhttp = createXMLHttpRequest();
		        var xmldom = createXmlDom();
		
		        var strXML = "";
		        strXML = "<DATA>";
		        strXML += "<NODE>";
		        strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
		        strXML += "<ITEMID>" + pItemID + "</ITEMID>";
		        strXML += "<TITLE><![CDATA[" + pTitle + "]]></TITLE>";
		        strXML += "<CONTENT><![CDATA[" + pContent + "]]></CONTENT>";
		        strXML += "</NODE>";
		        strXML += "</DATA>";
		
		        xmldom.async = false;
		        xmldom.preserveWhiteSpace = true;
		        xmldom = loadXMLString(strXML);
		        
		        xmlhttp.open("POST", "/ezBoard/deleteImageItem.do?mod=" + pMode, false);
		        xmlhttp.send(xmldom);
		        
		        if (xmlhttp.responseText == "OK") {
		            alert("<spring:message code='ezBoard.t1015'/>");
		            if (CrossYN())
		                ReturnFunction(xmlhttp.responseText);
		            else {
		                window.returnValue = xmlhttp.responseText;
		                window.close();
		            }
		        }
		        else {
		            alert("<spring:message code='ezBoard.t1016'/>");
		        }
		    }
		    function wclose() {
		        if(CrossYN())
		            parent.DivPopUpHidden();
		        else
		            window.close();
		    }
		
		</script>
	</head>
	<body class="popup">
	    <table class="layout">
	        <tr style="height:50px">
	            <td style="vertical-align:top" >
	                <div id="menu">
	                    <ul>
	                        <li ID='btn_Modify' ><span onclick="updatealbum()"><spring:message code='ezBoard.t316'/></span></li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li ><span onclick="wclose()"><spring:message code='ezBoard.t12'/></span></li>
	                    </ul>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td style="vertical-align:top">
	                <table class="content">
	                    <tr>
	                        <th style="width:80px"><spring:message code='ezBoard.t1014'/></th>
	                        <td style="width:100%"><input type="text" id="title" value="" style="width:100%;"/></td>
	                    </tr>
	                    <tr>
	                        <th style="width:80px"><spring:message code='ezBoard.t1008'/></th>
	                        <td style="width:100%;"><textarea id="content" style="height:100px;"></textarea></td>                        
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	</body>
</html>