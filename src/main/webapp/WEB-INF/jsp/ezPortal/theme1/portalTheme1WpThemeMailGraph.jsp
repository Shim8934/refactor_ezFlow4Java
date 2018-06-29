<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link href="/css/theme01.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/raphael.2.1.0.min.js"></script>
		<script type="text/javascript" src="/js/jquery/justgage.1.0.1.min.js"></script>
		<script type="text/javascript">
			//메일용량 관련
	        var MailQuater;
	        var xmlMailhttp;
	        window.onload = function () {
	            MailQuater = new JustGage({
	                id: "mailquatersize",
	                value: 0,
	                min: 0,
	                max: 100,
	                showInnerShadow: true,
	                levelColorsGradient: true
	            });
	
	            xmlMailhttp = createXMLHttpRequest();
	            xmlMailhttp.open("POST", "/ezEmail/mailGetUse.do", true);
	            xmlMailhttp.onreadystatechange = detailbox_after;
	            xmlMailhttp.send();
	
	            try { top.onresize() } catch (e) { }
	        }
	
	        function detailbox_after() {
	            if (xmlMailhttp == null || xmlMailhttp.readyState != 4) return;
	            var result = xmlMailhttp.responseXML;
	
	            if (CrossYN()) {
	                var resultvalue2 = "<spring:message code='main.t252' />" + GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[0].textContent + "<spring:message code='main.t253' />";
	                resultvalue2 += GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[1].textContent + "(" + GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[2].textContent + "%)<spring:message code='main.t254' />";
	                MailQuater.refresh(parseInt(GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[2].textContent))
	                MailQuater.refreshtitle(resultvalue2);
	            } else {
	                var resultvalue2 = "<spring:message code='main.t252' />" + GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[0].text + "<spring:message code='main.t253' />";
	                resultvalue2 += GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[1].text + "(" + GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[2].text + "%)<spring:message code='main.t254' />";
	                MailQuater.refresh(parseInt(GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[2].text))
	                MailQuater.refreshtitle(resultvalue2);
	            }
	        }
		</script>
	</head>
	<body>
			<!-- mailgraph -->
		<div class="content_graph">
			<dl class="content_title02">
		    	<dt><spring:message code='main.t00045' /></dt>
	 	   </dl>
	    	<div id="mailquatersize" style="width:158px; height:130px;display: inline-block;"></div>
		</div>
		<!-- //mailgraph -->
	</body>
</html>