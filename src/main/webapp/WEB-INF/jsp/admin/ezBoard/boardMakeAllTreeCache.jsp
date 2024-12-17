<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.HSBAt001" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" language="javascript">
			var isIng = false;
			
	    	function makeAllTreeCache() {
	    		// 일괄생성 동작 완료 전까지 중복 클릭 방지
	    		if (isIng == true) {
	    			return;
	    		}
	    		
	    		var ret = confirm("<spring:message code='ezBoard.HSBAt004'/>");
	    		
	    		if (ret) {
	    			isIng = true;
	    			
	    			// 진행상황 갱신 (없음 -> 진행중)
	    			document.getElementById("processTxt").innerHTML = "<spring:message code='ezBoard.HSBAt008'/>";
	    			
	    			$.ajax({
	    				type : "POST",
	    				dataType : "text",
	    				url : "/admin/ezBoard/makeAllTreeCache.do",
	    				data : {},
	    				success : function (result) {
	    					isIng = false;
	    					
	    					if (result == "TRUE") {
	    						// 진행상황 갱신 (진행중 -> 완료)
		    					document.getElementById("processTxt").innerHTML = "<spring:message code='ezBoard.HSBAt009'/>";
		    					alert("<spring:message code='ezBoard.HSBAt005'/>");
	    					} else {
	    						// 진행상황 갱신 (진행중 -> 중단, 오류 발생)
		    					document.getElementById("processTxt").innerHTML = "<spring:message code='ezBoard.HSBAt011'/>";
		    					alert("<spring:message code='ezBoard.HSBAt010'/>");
	    					}
	    				},
	    				error : function() {
	    					isIng = false;
	    					
	    					// 진행상황 갱신 (진행중 -> 중단, 오류 발생)
	    					document.getElementById("processTxt").innerHTML = "<spring:message code='ezBoard.HSBAt011'/>";
	    					alert("<spring:message code='ezBoard.HSBAt010'/>");
	    				}
	    			});
	    		}
	    		return;
	    	}
	    </script>
	</head>
	<body class="mainbody">	
		<h1><spring:message code="ezBoard.HSBAt001"/></h1>
		<div style="max-width:800px;">			
			<div class="box" style="padding:10px" >
			  	<spring:message code="ezBoard.HSBAt002"/><br>
			  	<spring:message code="ezBoard.HSBAt003"/>
			</div>
			<br>
			<div class="box" style="padding:10px" >
			  	<spring:message code="ezBoard.HSBAt006"/> <span id="processTxt"><spring:message code="ezBoard.HSBAt007"/></span>
			  	<br>
			  	<spring:message code="ezBoard.HSBAt006_1"/>
			</div>			
			<div class="btnpositionJsp">
			    <a class="imgbtn"><span onclick="makeAllTreeCache()" ><spring:message code="ezBoard.HSBAt001"/></span></a>
			</div>
		</div>
	</body>
</html>