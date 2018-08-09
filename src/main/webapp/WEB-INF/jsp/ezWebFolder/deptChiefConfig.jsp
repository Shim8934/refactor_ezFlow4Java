<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	<link rel="stylesheet" href="<%=CommonUtil.addVer(application, "/css/Tab.css")%>" type="text/css"/>
	<link rel="stylesheet" href="<%=CommonUtil.addVer(application, "/css/ezWebFolder/webfolder.css")%>" type="text/css">
	<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/jquery/jquery-1.11.3.min.js")%>"></script>
	<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/ezWebFolder/organJson.js")%>"   ></script>
	<script type="text/javascript">
		//var listCnt = "<c:out value="${wfListConfig.envValue}"/>";
		var userDept        = null;
		var arrSubFolder    = [];
		var selectedDept    = "";
		var strErrMsg       = "<spring:message code='ezWebFolder.t134'/>";
		var strDataNotFound = "<spring:message code='ezWebFolder.t144'/>";
		var strAlreadyAdd   = "<spring:message code='ezWebFolder.t169'/>";
		document.onselectstart = function () { return false; };
		
		window.onload = function () {
			if (navigator.userAgent.indexOf('Firefox') != -1) {
				document.body.style.MozUserSelect    = 'none';
				document.body.style.WebkitUserSelect = 'none';
				document.body.style.khtmlUserSelect  = 'none';
				document.body.style.oUserSelect      = 'none';
				document.body.style.UserSelect       = 'none';
			}
			
			getDataForChief();
		}
		
		function cancel_Click() {
			getSelectedDeptsForChief();
		}
		
		function changeClick() {
			var jsonData = getJsonSelectedDepts();
			
			$.ajax({
				url : '/ezWebFolder/saveSelectedDeptsForChief.do',
				method : 'POST',
				dataType : 'JSON',
				data : {
					"deptList" : jsonData.toString()
				},
				success : function(data, textStatus, jqXHR) {
					var result = data.resultValue;
					if (result == "ok") {
						alert('<spring:message code="ezWebFolder.t182"/>');
					}
					else {
						alert('<spring:message code="ezWebFolder.t134"/>');
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
	<h2><spring:message code="ezWebFolder.t239"/></h2>
	<span class="txt">▒<spring:message code="ezWebFolder.t242"/></span>
	<br />
	<table class="content" style="width: 650px;margin-top:5px; border: none;">
		<tr>
			<td style="min-width: 350px;">
				<div id="deptList" style="height: 350px; width: 100%; overflow: auto;">
				</div>
			</td>
			<td style="min-width: 60px; border-top: none; border-bottom: none;">
				<div style="text-align: center;"><img src="/images/arr_right.gif" width="16" height="16" vspace="3" onclick="add_dept2();" style="cursor:pointer"></div>
				<div style="text-align: center;"><img src="/images/arr_left.gif"  width="16" height="16" vspace="3" onclick="unselect_dept2();" style="cursor:pointer"></div>
			</td>
			<td style="min-width: 240px; padding: 0px;">
				<div id="selectedDepts" style="width: 100%; height: 350px; overflow: auto;">
				</div>
			</td>
		</tr>
	
	</table>
 	<br/>
	<div style="width:623px;text-align:center;">      
		<a class="webfolderBttn" onclick="changeClick()"><span><spring:message code="ezWebFolder.t133" /></span></a>
		<a class="webfolderBttn" onclick="cancel_Click()"><span><spring:message code="ezWebFolder.t112" /></span></a>
	</div>
</body>
</html>