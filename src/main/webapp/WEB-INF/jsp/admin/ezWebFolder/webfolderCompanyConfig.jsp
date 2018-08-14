<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezOrgan.e3'/>" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
		<link rel="stylesheet" href="<%=CommonUtil.addVer(application, "/css/ezWebFolder/webfolder.css")%>" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var currPersonalLimit = "";
			var currUploadLimit   = "";
			
			window.onload = function () {
				closePanel();
				change();
			};
			
			function closePanel() {
				var leftFrame = window.parent.frames["left"].document;
				var blockLeft = leftFrame.getElementById("bnkBlockLeft");
				leftFrame.body.style.overflow = "auto";
				blockLeft.style.height        = "100%";
				blockLeft.style.display       = "none";
			}
			
			function change() {
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/getConfig.do",
					data: {
						"companyId" : document.getElementById("companyList").value
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var code = data.code;
						
						switch(code) {
							case 0: 
								var result = data.config;
								
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

				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/saveConfig.do",
					data: {
						"pLimitVal" : personalLimitVal,
						"uLimitVal" : uploadLimitVal,
						"companyId" : document.getElementById("companyList").value
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var code = data.code;
						switch(code) {
							case 0: 
								alert("<spring:message code='ezWebFolder.t182'/>");
								currPersonalLimit = personalLimitVal;
								currUploadLimit   = uploadLimitVal;
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
		<div style="margin-left:5px">
			<div id="companySelect" style="margin: 10px 0px;">
				<span style="font-size: 12px; display:inline-block; vertical-align: middle;"><b><spring:message code='ezWebFolder.t129'/></b></span>
				<select id="companyList" style="font-size: 12px; height: 20px; display:inline-block;" onchange="change();">
					<c:forEach var="item" items="${list}">
						<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
					</c:forEach>
				</select>
			</div>
			
			<div id="mainSetting" style="margin: 10px 0px;">
				<table class="content" style="width:400px">
					<tr style="height: 40px;">
						<th style="width:25%"><spring:message code='ezWebFolder.t130'/></th>
						<th style="background : #ffff;">
							<input id="uploadLimit" type="text" style="height: 30px; padding: 0px 5px;" value="<c:out value='${upLimit}'/>" />
							<span><spring:message code='ezWebFolder.t132' /></span>
						</th>
					</tr>
					<tr style="height: 40px;">
						<th><spring:message code='ezWebFolder.t131'/></th>
						<th style="background : #ffff;">
							<input id="personalLimit" type="text" style="height: 30px; padding: 0px 5px;" value="<c:out value='${persLimit}'/>" />
							<span><spring:message code='ezWebFolder.t132' /></span>
						</th>
					</tr>
				</table>
			</div>
			<div style="width:400px;text-align: center">
				<a class="imgbtn"><span onclick="save();" ><spring:message code='ezWebFolder.t133'/></span></a>
				<a class="imgbtn"><span onclick="cancel();"><spring:message code='ezWebFolder.t112'/></span></a>
			</div>
		</div>	
	</body>
</html>
