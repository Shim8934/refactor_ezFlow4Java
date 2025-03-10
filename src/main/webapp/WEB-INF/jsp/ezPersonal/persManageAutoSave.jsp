<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>자동임시저장</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<%--  		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />--%>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			var UserID = "<c:out value='${userInfo.id}'/>";
			var autoSaveFlag = "<c:out value='${autoSaveFlag}'/>";
			
			window.onload = function (){
				
				var selectBox = document.getElementById("listcount");
				if (autoSaveFlag == "") {
					selectBox.value = "0"; 
				} else if (autoSaveFlag == "60") {
					selectBox.value = "60"; 
				} else if (autoSaveFlag == "120") {
					selectBox.value = "120"; 
				} else if (autoSaveFlag == "180") {
					selectBox.value = "180"; 
				} else if (autoSaveFlag == "240") {
					selectBox.value = "240"; 
				} else if (autoSaveFlag == "300") {
					selectBox.value = "300"; 
				}
			
			}
			function addAutoSave_onclick(){
				var autoSaveTime = document.getElementById("listcount").value;

				$.ajax({
					url : '/ezPersonal/addAutoSave.do',
					method : 'POST',
					dataType : 'text',
					data : {
						autoSaveTime : autoSaveTime
					},
					success : function(req) {
						if(req == "OK"){
							alert("<spring:message code='ezApprovalG.t1581'/>");
						}
					},
					error : function() {
							alert("<spring:message code='ezApprovalG.t1296'/>");
					}
				})
			}	
			
		</script>
	</head>
	<body>
		<br>
		<table class="content" style="width: 623px;margin-top:5px">
			<tr>
				<th><spring:message code="ezApprovalG.kmh08" /></th>
				<td>
					<select id="listcount" name="pListCount" style="WIDTH: 100px">
						<option value='0'  ><spring:message code="ezApproval.t505" /></option>
						<option value='60'  >1</option>
						<option value='120' >2</option>
						<option value='180' >3</option>
						<option value='240' >4</option>
						<option value='300' >5</option>
					</select>
					<spring:message code="ezApprovalG.t978" />
				</td>
			</tr>
		</table>
	    <div class="btnpositionJsp" style="width: 623px;">
	    	<a class="imgbtn" onclick="addAutoSave_onclick()"><span><spring:message code='ezPersonal.t34'/></span></a>
	    </div>    
	</body>
</html>