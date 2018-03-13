<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/TreeView.js"></script>
		<script type="text/javascript">
			var currPersonalLimit = "";
			var currUploadLimit   = "";
			
			window.onload = function () {
				change();
			};
			
			function change() {
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/getConfig.do",
					data: {
						"companyId" : document.getElementById("companyList").value
					},
					dataType: "JSON",
					async: false,
					success : function(data) {
						var result = data.webfolderConfig;
						
						if (!result) {
							currPersonalLimit = "";
							currUploadLimit   = "";
						}
						else {
							currPersonalLimit = result["totalLimit"];
							currUploadLimit   = result["uploadLimit"];
						}
						
						document.getElementById("uploadLimit").value   = currUploadLimit;
						document.getElementById("personalLimit").value = currPersonalLimit;
						
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>" + error);
					}
				});
			}
			
			function save() {
				var uploadLimitVal = document.getElementById("uploadLimit").value;
				
				if (!isValid(uploadLimitVal)) {
					alert("<spring:message code='ezWebFolder.t183'/>");
					document.getElementById("uploadLimit").focus();
					return;
				}
				
				var personalLimitVal = document.getElementById("personalLimit").value;
				
				if (!isValid(personalLimitVal)) {
					alert("<spring:message code='ezWebFolder.t183'/>");
					document.getElementById("personalLimit").focus();
					return;
				}
				
				if (parseInt(uploadLimitVal) > parseInt(personalLimitVal)) {
					alert("<spring:message code='ezWebFolder.t185'/>");
					return;
				}
				
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/saveConfig.do",
					data: {
						"pLimitVal" : personalLimitVal,
						"uLimitVal" : uploadLimitVal,
						"companyId" : document.getElementById("companyList").value
					},
					dataType: "text",
					async: true,
					success : function(data) {
						alert("spring:message code='ezWebFolder.t182'/>");
						currPersonalLimit = personalLimitVal;
						currUploadLimit   = uploadLimitVal;
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>" + error);
					}
				});
			}
			
			function cancel() {
				document.getElementById("uploadLimit").value   = currUploadLimit;
				document.getElementById("personalLimit").value = currPersonalLimit;
			}
			
			function isValid(value) {
				if (!isNaN(value) && parseFloat(value) > 0) {
					return true;
				}
				else {
					return false;
				}
			}
			
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezWebFolder.t102'/></h1>
		<div id="companySelect" style="margin: 10px 0px;">
			<span style="font-size: 16px; display:inline-block; height: 21px; vertical-align: middle;"><b><spring:message code='ezWebFolder.t129'/></b></span>
			<select id="companyList" style="font-size: 13px; border-radius: 3px; height: 25px; display:inline-block;" onchange="change();">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
			</select>
		</div>
		
		<div id="mainSetting" style="margin: 10px 0px;">
			<table class="content">
				<tr style="height: 40px;">
					<th><spring:message code='ezWebFolder.t130'/></th>
					<th>
						<input id="uploadLimit" type="text" style="height: 30px; padding: 0px 5px;" value="<c:out value='${upLimit}'/>" />
						<span><spring:message code='ezWebFolder.t132' /></span>
					</th>
				</tr>
				<tr style="height: 40px;">
					<th><spring:message code='ezWebFolder.t131'/></th>
					<th>
						<input id="personalLimit" type="text" style="height: 30px; padding: 0px 5px;" value="<c:out value='${persLimit}'/>" />
						<span><spring:message code='ezWebFolder.t132' /></span>
					</th>
				</tr>
			</table>
		</div>
		<div style="margin: 10px 70px;">
			<a class="webfolderBttn"><span onclick="save();"  ><spring:message code='ezWebFolder.t133'/></span></a>
			<a class="webfolderBttn"><span onclick="cancel();"><spring:message code='ezWebFolder.t112'/></span></a>
		</div>
	</body>
</html>