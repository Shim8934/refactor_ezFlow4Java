<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="<spring:message code='ezCircular.c1' />" type="text/css" />
        <script type="text/javascript" src="/js/mouseeffect.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>        
        <script type="text/javascript" src="/js/ezSchedule/ListView_list.js"></script>
		<title><spring:message code='ezCircular.t67'/></title>
		<script>
		    window.onload = function () {
		        
		    }
	
		    function cancel_onClick() {
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
		    }
		</script>
	</head>	
	<body class="popup"> 
		<object style="display:none" classid="clsid:F8E93A35-2D04-4E2C-A04D-87947594C674" id="ListViewBehave" height="0px" width="0px" VIEWASTEXT> </object> 
		<h1><spring:message code='ezCircular.t67' /></h1>
		<div class="listview" style="height:190px; overflow:auto;">
			<table id="List" class="mainlist" style="width:100%">
				<thead id="List_THEAD">
					<tr>
						<th id="TH_0" style="width:5%">NO</th>
						<th id="TH_1" style="width:15%">회사</th>
						<th id="TH_2" style="width:17%">부서</th>
						<th id="TH_3" style="width:12%">직급</th>
						<th id="TH_4" style="width:13%">이름</th>
						<th id="TH_5" style="width:38%">E-MAIL</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="list" items="${list}" varStatus="seq">
						<tr>
							<td id="TD_0" style="width:5%">${seq.count}</td>
							<td id="TD_1" style="width:15%">${list.company}</td>
							<td id="TD_2" style="width:17%">${list.description}</td>
							<td id="TD_3" style="width:12%">${list.title}</td>
							<td id="TD_4" style="width:13%">${list.memberId}</td>
							<td id="TD_5" style="width:38%">${list.mail}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		<div class="btnposition">
		    <a class="imgbtn" name="button2" onClick="change_onClick()" ><span><spring:message code='ezCircular.t65' /></span></a>
		    <a class="imgbtn" name="button3" onClick="cancel_onClick()" ><span><spring:message code='ezCircular.t66' /></span></a>
		</div>
	</body>
</html>