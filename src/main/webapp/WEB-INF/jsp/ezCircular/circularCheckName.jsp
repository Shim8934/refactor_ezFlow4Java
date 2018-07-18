<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCircular.t82'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="<spring:message code='ezCircular.c1' />" type="text/css" />
	    <style>
	    	.mainlist tr th {border-top:0px}
	    </style>
	    <script type="text/javascript" src="<spring:message code='ezCircular.e1' />"></script>
        <script type="text/javascript" src="/js/mouseeffect.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		<script>
		    /* function cancel_onClick() {
		        if (ReturnFunction != null) {
		            var returnvalue = new Array();
		            returnvalue["recipientTDData"] = "dontprocess";
		            returnvalue["name"] = "";
	
		            ReturnFunction(returnvalue);
		            parent.DivPopUpHidden();
		        }
		        else {
		            dialogArguments["recipientTDData"] = "dontprocess";
		            window.close();
		        }
		    } */
		    //2018-02-14 김보미 - 닫기
			function closing() {
	          	window.close();
			}
		</script>
	</head>	
	<body class="popup"> 
		<h1><spring:message code='ezCircular.t82' /></h1>
		<!-- 2018-02-14 김보미 - 닫기 -->
		<div id="close">
			<ul>
				<li><span onclick="closing();"></span></li>
			</ul>
		</div>
		<div class="listview" style="height:220px; overflow:auto;">
			<table id="List" class="mainlist" style="width:100%">
				<thead id="List_THEAD">
					<tr>
						<th id="TH_0" style="width:5%"><spring:message code='ezCircular.t31' /></th>
						<th id="TH_1" style="width:15%"><spring:message code='ezCircular.t76' /></th>
						<th id="TH_2" style="width:17%"><spring:message code='ezCircular.t78' /></th>
						<th id="TH_3" style="width:12%"><spring:message code='ezCircular.t79' /></th>
						<th id="TH_4" style="width:13%"><spring:message code='ezCircular.t80' /></th>
						<th id="TH_5" style="width:38%"><spring:message code='ezCircular.t81' /></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="list" items="${list}" varStatus="seq">
						<tr>
							<td id="TD_0" style="width:5%">${seq.count}</td>
							<td id="TD_1" style="width:15%">${list.company}</td>
							<td id="TD_2" style="width:17%">${list.description}</td>
							<td id="TD_3" style="width:12%">${list.title}</td>
							<td id="TD_4" style="width:13%">${list.memberName}</td>
							<td id="TD_5" style="width:38%">${list.mail}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</body>
</html>