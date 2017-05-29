<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
        <script type="text/javascript" src="/js/mouseeffect.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>        
        <script type="text/javascript" src="/js/ezSchedule/ListView_list.js"></script>
		<title><spring:message code='ezSchedule.t53'/></title>
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
		<h1><spring:message code='ezSchedule.t53' /></h1>
<!-- 		<div class="listview" style="overflow:auto;"> -->
<!-- 			<div id="ListViewid" STYLE="Width:570px; Height:195px; border:0px;overflow:auto"></div> -->
<%-- 			<c:forEach items="${list}" var="list" varStatus=""> --%>
<%-- 				${seq.index }<br/>${list.memberName} <br/> --%>
<%-- 			</c:forEach> --%>
<!-- 		</div> -->
		<div class="listview">
			<table style="width:100%">
				<thead id="list_thead">
					<tr>
						<th>NO</th>
						<th>회사</th>
						<th>부서</th>
						<th>직급</th>
						<th>이름</th>
						<th>E-MAIL</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="list" items="${list}" varStatus="seq">
						<tr>
							<td>${seq.count}</td>
							<td>${list.company}</td>
							<td>${list.description}</td>
							<td>${list.title}</td>
							<td>${list.memberId}</td>
							<td>${list.mail}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		<div class="btnposition">
		    <a class="imgbtn" name="button2" onClick="change_onClick()" ><span><spring:message code='ezSchedule.t4' /></span></a>
		    <a class="imgbtn" name="button3" onClick="cancel_onClick()" ><span><spring:message code='ezSchedule.t5' /></span></a>
		</div>
	</body>
</html>