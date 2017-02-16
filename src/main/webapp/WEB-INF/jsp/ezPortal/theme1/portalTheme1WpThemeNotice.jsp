<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link href="/css/theme01.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
			var xmlNoticehttp = createXMLHttpRequest();
	        var userLang = "${userInfo.lang}";
	        var strLang1 = "<spring:message code="main.t00026"/>";
	        
	        window.onload = function () {
	            getNoticeList();
	            try { top.onresize() } catch (e) { }
	        }
	        
	        function getNoticeList() {
	            xmlNoticehttp = null;
	            xmlNoticehttp = createXMLHttpRequest();
	            xmlNoticehttp.open("POST", "/ezPersonal/getNoticeList.do", true);
	            xmlNoticehttp.onreadystatechange = getNoticeList_after;
	            xmlNoticehttp.send();
	        }
	        
	        function getNoticeList_after() {
	            if (xmlNoticehttp == null || xmlNoticehttp.readyState != 4) return;
	            try {
	                var xmldom = createXmlDom();
	                xmldom = xmlNoticehttp.responseXML;
	
	                var RowCnt = xmldom.getElementsByTagName("ROW").length;
	                for (var i = 0; i < RowCnt; i++) {
	                    var _li = document.createElement("li");
	
	                    _li.style.cursor = "pointer";
	
	                    var _span = document.createElement("span");
	                    _span.onclick = new Function("open_notice('" + SelectSingleNodeValue(SelectNodes(xmldom, "ROW")[i], "ITEMSEQ") + "')");
	                    if (userLang != "1")
	                        _span.innerHTML = SelectSingleNodeValue(SelectNodes(xmldom, "ROW")[i], "TITLE2");
	                    else
	                        _span.innerHTML = SelectSingleNodeValue(SelectNodes(xmldom, "ROW")[i], "TITLE");
	
	                    _li.appendChild(_span);
	                    document.getElementById("content_Noticelist").appendChild(_li);
	                }
	
	                if (RowCnt <= 0) {
	                    var _div = document.createElement("DIV");
	                    _div.className = "nodata_h";
	
	                    var _p = document.createElement("P");
	                    var _p2 = document.createElement("P");
	                    _p2.innerHTML = strLang1;
	
	                    var _image = document.createElement("img");
	                    _image.src = "/images/kr/theme01/main/nodata_gray.png";
	                    _p.appendChild(_image);
	
	                    _div.appendChild(_p);
	                    _div.appendChild(_p2);
	                    document.getElementById("content_Noticelist").appendChild(_div);
	                }
	            } catch (e) { }
	        }
	        
	        function open_notice(itemseq) {
	            if (itemseq == "0")
	                return;
	            window.open("/ezPersonal/showNotice.do?itemSeq=" + itemseq, "", "height=570px,width=570px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
	        }
	        
	        function openNoticeList() {
	            var heigth = window.screen.availHeight;
	            var width = window.screen.availWidth;
	
	            var left = (width - 455) / 2;
	            var top = (heigth - 400) / 2;
	
	            window.open("/ezPersonal/noticeList.do", "", "height=530px,width=620, status = no, toolbar=no, menubar=no,location=no, resizable=0,top=" + top + ",left = " + left);
	        }
		</script>
	</head>
	<body>
		<!-- notice -->
		<div class="content_notice">
			<dl class="content_title02">
    			<dt><spring:message code="main.t65"/></dt>
        		<dd onclick="openNoticeList()"><spring:message code="main.t1008"/></dd>
    		</dl>
    		<ul class="content_list02" id="content_Noticelist"></ul>
		</div>
		<!-- //notice -->
	</body>
</html>