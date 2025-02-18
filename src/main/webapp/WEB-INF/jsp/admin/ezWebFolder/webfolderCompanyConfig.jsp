<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var currentCompanyLimit = "";
			var currentDepartmentLimit = "";
			var currentUserLimit = "";
			var currUploadLimit   = "";
			
			window.onload = function () {
				closePanel();
				change();

				document.getElementById("uploadLimit").addEventListener('blur', function() {
				    var floatValue = parseFloat(this.value);
				    this.value = isNaN(floatValue) ? '0' : floatValue;
				});

				document.getElementById("departmentLimit").addEventListener('blur', function() {
				    var floatValue = parseFloat(this.value);
				    this.value = isNaN(floatValue) ? '0' : floatValue;
				});

				document.getElementById("userLimit").addEventListener('blur', function() {
				    var floatValue = parseFloat(this.value);
				    this.value = isNaN(floatValue) ? '0' : floatValue;
				});

				if (selectedCompany === "*") {
					document.getElementById("companyLimit").addEventListener('blur', function() {
					    var floatValue = parseFloat(this.value);
					    this.value = isNaN(floatValue) ? '0' : floatValue;
					});
				}
			};
			
			function closePanel() {
				var leftFrame = window.parent.frames["left"].document;
				var blockLeft = leftFrame.getElementById("bnkBlockLeft");
				leftFrame.body.style.overflow = "auto";
				blockLeft.style.height        = "100%";
				blockLeft.style.display       = "none";
			}
			
			function change() {
				var selectCompanyValue = document.getElementById("companyList").value;
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/getConfig.do",
					data: {
						"companyId" : <c:if test="${isAdminMode}">selectCompanyValue == "*" ? null : </c:if>selectCompanyValue
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var code = data.code;
						
						switch(code) {
							case 0: 
								var result = data.config;
								
								if (result) {
									currentCompanyLimit = result["companyTotalLimit"];
									currentDepartmentLimit = result["departmentTotalLimit"];
									currentUserLimit = result["userTotalLimit"];
									currUploadLimit = result["uploadLimit"];
								} else {
									currentCompanyLimit = "";
									currentDepartmentLimit = "";
									currentUserLimit = "";
									currUploadLimit = "";
								}
								
								if (selectCompanyValue == "*") {
									document.getElementById("companyLimitTr").style.display = "";
								} else {
									document.getElementById("companyLimitTr").style.display = "none";
								}
								
								document.getElementById("uploadLimit").value = currUploadLimit;
								document.getElementById("companyLimit").value = currentCompanyLimit;
								document.getElementById("departmentLimit").value = currentDepartmentLimit;
								document.getElementById("userLimit").value = currentUserLimit;
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
				var selectedCompany = document.getElementById("companyList").value;
				var inputList = ["uploadLimit", "departmentLimit", "userLimit"];
				
				let departmentLimit = parseFloat(document.getElementById("departmentLimit").value);
				let userLimit = parseFloat(document.getElementById("userLimit").value);
				let uploadLimit = parseFloat(document.getElementById("uploadLimit").value);

				if (selectedCompany === "*") {
					inputList.push("companyLimit");
				}
				var notValid = inputList.some(function(name) {
					var element = document.getElementById(name);
					
					if (isValid(element.value)) {
						return false;
					} else {
						alert("<spring:message code='ezWebFolder.t183'/>");
						element.focus();
						return true;
					}
					
				});
				
				if (notValid) {
					return;
				}

				if (uploadLimit <= departmentLimit && uploadLimit <= userLimit){
					var param = {
						"departmentLimit" : departmentLimit,
						"userLimit" : userLimit,
						"uploadLimit" : uploadLimit,
						"companyId" : document.getElementById("companyList").value
					}
				} else {
					alert("<spring:message code='ezWebFolder.khj01'/>");
					return;
				}
				
				if (selectedCompany === "*") {
					param.companyLimit = document.getElementById("companyLimit").value;
				}
				
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/saveConfig.do",
					data: param,
					dataType: "JSON",
					async: true,
					success : function(data) {
						var code = data.code;
						switch(Number(code)) {
							case 0: 
								alert("<spring:message code='ezWebFolder.t182'/>");
								currentCompanyLimit = document.getElementById("companyLimit").value;
								currentDepartmentLimit = departmentLimit;
								currentUserLimit = userLimit;
								currUploadLimit = uploadLimit;
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
							case 4:
								alert("<spring:message code='ezWebFolder.khj01' />");
								break;
						}
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>" + error);
					}
				});
			}
			
			function cancel() {
				document.getElementById("uploadLimit").value = currUploadLimit;
				document.getElementById("companyLimit").value = currentCompanyLimit;
				document.getElementById("departmentLimit").value = currentDepartmentLimit;
				document.getElementById("userLimit").value = currentUserLimit;
			}
			
			function isValid(value) {
				if (!isNaN(value) && parseFloat(value) >= 0) {
					return true;
				}
				else {
					return false;
				}
			}
			
		</script>
	</head>
	<body class="mainbody">
		<h1>
			<spring:message code='ezWebFolder.t102'/>
			<span class="title_bar"><img src="/images/name_bar.gif"></span>
			<select id="companyList" class="companySelect" onchange="change();">
				<c:if test = "${isAdminMode}">
					<option value="*"><spring:message code='ezWebFolder.select.company.all'/></option>
				</c:if>
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
			</select>
		</h1>
		<div style="margin-left:5px">
			<div id="mainSetting" style="margin: 10px 0px;">
				<table class="content" style="width:400px">
					<tr style="height: 40px;">
						<th style="width:25%"><spring:message code='ezWebFolder.t130'/></th>
						<th style="background : #ffff;">
							<input id="uploadLimit" type="text" style="height: 30px; padding: 0px 5px;" />
							<span><spring:message code='ezWebFolder.t132' /></span>
						</th>
					</tr>
					<tr id="companyLimitTr" style="height: 40px; display: none;">
						<th><spring:message code='ezWebFolder.t131.1'/></th>
						<th style="background : #ffff;">
							<input id="companyLimit" type="text" style="height: 30px; padding: 0px 5px;" />
							<span><spring:message code='ezWebFolder.t132' /></span>
						</th>
					</tr>
					<tr style="height: 40px;">
						<th><spring:message code='ezWebFolder.t131.2'/></th>
						<th style="background : #ffff;">
							<input id="departmentLimit" type="text" style="height: 30px; padding: 0px 5px;" />
							<span><spring:message code='ezWebFolder.t132' /></span>
						</th>
					</tr>
					<tr style="height: 40px;">
						<th><spring:message code='ezWebFolder.t131.3'/></th>
						<th style="background : #ffff;">
							<input id="userLimit" type="text" style="height: 30px; padding: 0px 5px;" />
							<span><spring:message code='ezWebFolder.t132' /></span>
						</th>
					</tr>
				</table>
			</div>
			<div class="wfcompstdiv">
				<a class="imgbtn"><span onclick="save();" ><spring:message code='ezWebFolder.t133'/></span></a>
				<a class="imgbtn"><span onclick="cancel();"><spring:message code='ezWebFolder.t112'/></span></a>
			</div>
		</div>	
	</body>
</html>
