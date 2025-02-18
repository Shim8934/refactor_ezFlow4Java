<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript">
		var listCnt = "<c:out value="${wfListConfig.envValue}"/>";
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
			document.getElementById("listcount").value = listCnt;
		}
		
		function Change_Click() {
			var listCount = document.getElementById("listcount").value;
			
			$.ajax({
				url : '/ezWebFolder/saveGeneralList.do',
				method : 'POST',
				dataType : 'JSON',
				data : {
					"listCount" : listCount
				} ,
				success : function(data, textStatus, jqXHR) {
					var code = data.code;
					
					switch(code) {
						case 0: 
							alert('<spring:message code="ezWebFolder.t182"/>');
							listCnt = listCount;
							break;
						case 1:
							alert("<spring:message code='ezWebFolder.t306'/>");
							break;
						case 2:
							alert("<spring:message code='ezWebFolder.t305'/>");
							break;
						case 3:
							alert("<spring:message code='ezWebFolder.t300' />");
							break;
					}
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
	<%-- <h2><spring:message code="ezWebFolder.t238" /></h2> --%>
	<span class="txt"><spring:message code="ezWebFolder.t240"/></span>
	<br />
	<table class="content" style="width: 623px;margin-top:5px">
		<tr>
			<th><spring:message code="ezWebFolder.t241" /></th>
			<td>
				<select id="listcount" name="pListCount" style="WIDTH: 100px">
					<option value='10' ${wfListConfig.envValue eq '10'? 'selected' : ''}>10</option>
					<option value='20' ${wfListConfig.envValue eq '20'? 'selected' : ''}>20</option>
					<option value='30' ${wfListConfig.envValue eq '30'? 'selected' : ''}>30</option>
					<option value='40' ${wfListConfig.envValue eq '40'? 'selected' : ''}>40</option>
					<option value='50' ${wfListConfig.envValue eq '50'? 'selected' : ''}>50</option>
				</select>
				<spring:message code="ezWebFolder.t138" />
			</td>
		</tr>
	</table>
	<div style="width:609px;" class="btnpositionJsp">      
		<a class="imgbtn" onclick="Change_Click()"><span><spring:message code="ezWebFolder.t133" /></span></a>
		<a class="imgbtn" onclick="Cancel_Click()"><span><spring:message code="ezWebFolder.t112" /></span></a>
	</div>
</body>
</html>