<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link href="/css/theme01.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApproval/lang/ezApproval.js"></script>
		<script type="text/javascript">
			var xmlhttp = createXMLHttpRequest();
	        var strLang1 = "<spring:message code='main.t00026'/>";
	
	        window.onload = function () {
	            getMail();
	
	            try { top.onresize() } catch (e) { }
	        }
	
	        function getMail() {
	            var xmlpara = createXmlDom();
	
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "PARAMETER");
	            createNodeAndInsertText(xmlpara, objNode, "pMailType", "1");
	
	            xmlhttp = null;
	            xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/ezEmail/getPortletMailList.do", true);
	            xmlhttp.onreadystatechange = getMailList_after;
	            xmlhttp.send(xmlpara);
	        }
	        function getMailList_after() {
	            if (xmlhttp == null || xmlhttp.readyState != 4) return;
	            try {
	                document.getElementById("mail_list").innerHTML = "";
	
	                var listHTML = "";
	                var xmldom = xmlhttp.responseXML;
	                if (xmldom.getElementsByTagName("NODE").length > 0) {
	                    for (var i = 0; i < 5; i++) {
	                        if (i == xmldom.getElementsByTagName("NODE").length) break;
	                        listHTML += "<li  style='cursor: pointer;' onclick=\"open_mail('" + getNodeText(xmldom.getElementsByTagName("HREF").item(i)) + "')\"><span class='title'>"
	                        listHTML += "<img src='/images/kr/theme01/main/icon_dotMailOn.gif' alt='' />";
	                        listHTML += getNodeText(xmldom.getElementsByTagName("SUBJECT").item(i));
	                        listHTML += "</span><span class='name'>";
	                        listHTML += getNodeText(xmldom.getElementsByTagName("SENDER").item(i));
	                        listHTML += "</span><span class='day'>";
	                        listHTML += getNodeText(xmldom.getElementsByTagName("DATE").item(i));
	                        listHTML += "</span></li>";
	                    }
	                }
	                else {
	                    listHTML = "<div class='nodata_w'>";
	                    listHTML += "<p><img src='/images/kr/theme01/main/nodata_gray.png'></p>";
	                    listHTML += "<p>" + strLang1 + "</p>";
	                    listHTML += "</div>";
	                }
	                document.getElementById("mail_list").innerHTML = listHTML;
	            }
	            catch (e) {
	            }
	        }
	        function open_mail(url) {
	            var pheight = window.screen.availHeight;
	            var conHeight = pheight * 0.8;
	            var pwidth = window.screen.availWidth;
	            var conWidth = pwidth * 0.8;
	            if (conWidth > 890)
	                conWidth = 890;
	            var pTop = (pheight - conHeight) / 2;
	            var pLeft = (pwidth - 890) / 2;
	
	            var newwin;
	            var pURI;
	            if (navigator.userAgent.indexOf("MSIE") > -1) {
	                pURI = "/ezEmail/mailRead.do?URL=" + encodeURIComponent(url) + "&PNFlag=N&CONTENTCLASS=";
	            }
	            else {
	                pURI = "/ezEmail/mailRead.do?URL=" + encodeURIComponent(url) + "&PNFlag=N&CONTENTCLASS=";
	            }
	
	            newwin = window.open(pURI, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
	            newwin.focus();
	            getMail();
	        }
	        function Mailmore_btnClick() {
	            window.open("/ezEmail/mailMain.do", "main");
	        }
		</script>
	</head>
	<body>
		<div class="content_mail">
        	<dl class="content_title01">
            	<dt><spring:message code='main.t00038'/></dt>
            	<dd onclick="Mailmore_btnClick()"><spring:message code='main.t1008'/></dd>
        	</dl>
        	<ul class="content_list01" id="mail_list">
        	</ul>
    	</div>
	</body>
</html>