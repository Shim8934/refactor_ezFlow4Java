<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	<link rel="stylesheet" href="/css/Tab.css" type="text/css"/>
	<script type="text/javascript">
		document.onselectstart = function () { return false; };
		
		window.onload = function () {
			if (navigator.userAgent.indexOf('Firefox') != -1) {
				document.body.style.MozUserSelect    = 'none';
				document.body.style.WebkitUserSelect = 'none';
				document.body.style.khtmlUserSelect  = 'none';
				document.body.style.oUserSelect      = 'none';
				document.body.style.UserSelect       = 'none';
			}
		}
		
		function Cancel_Click() {
			document.getElementById("listcount").value = "${wfListConfig.envValue}";
		}
		
		function Change_Click() {
			var listCount = document.getElementById("listcount").value;
			var userId    = "<c:out value="${wfListConfig.cn}"/>";
			
			$.ajax({
				url : '',
				method : 'POST',
				dataType : 'JSON',
				data : {
					"userId"    : userId,
					"listCount" : listCount
				} ,
				success : function(data, textStatus, jqXHR) {
					alert('<spring:message code="ezWebFolder.t182"/>');
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert('Error : ' + jqXHR.status + ", " + textStatus);
				}
			});
		}
	</script>
</head>
<body style="margin-left: 10px; margin-right: 10px;">
	<br/>
	<h2><spring:message code="ezBoard.t0006" /></h2>
	<span class="txt">▒ <spring:message code="ezBoard.t0007" /></span>
	<br />    
	<table class="content" style="width: 623px;margin-top:5px">
		<tr>
			<th><spring:message code="ezBoard.t10021" /></th>
			<td>
				<select id="listcount" name="pListCount" style="WIDTH: 100px">
					<option value='10' selected="${boardListConfig.listCount eq '10'? 'selected' : ''}">10</option>
					<option value='20' selected="${boardListConfig.listCount eq '20'? 'selected' : ''}">20</option>
					<option value='30' selected="${boardListConfig.listCount eq '30'? 'selected' : ''}">30</option>
					<option value='40' selected="${boardListConfig.listCount eq '40'? 'selected' : ''}">40</option>
					<option value='50' selected="${boardListConfig.listCount eq '50'? 'selected' : ''}">50</option>
				</select>
				<spring:message code="ezBoard.t00019" />
			</td>
		</tr>
	   	
	</table>
 	<br />
	<div style="width:623px;text-align:center;">      
		<a class="imgbtn" onclick="Change_Click()"><span><spring:message code="ezWebFolder.t133" /></span></a>
		<a class="imgbtn" onclick="Cancel_Click()"><span><spring:message code="ezWebFolder.t112" /></span></a>
	</div>
</body>
</html>