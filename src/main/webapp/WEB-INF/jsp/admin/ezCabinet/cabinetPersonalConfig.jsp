<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezCabinet.t11'/></h1>
		<div class="cabiMain">
			<div class="compSelect" id="companySelect">
				<span><b><spring:message code='ezCabinet.t13'/></b></span>
				<select id="companyList">
					<c:forEach var="item" items="${list}">
						<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
					</c:forEach>
				</select>
			</div>
			
			<div class="cabPersonalDiv">
				<div class="compOrg">
					<div id="compTree"></div>
				</div>
				<div class="deptOrg">
					<div>
						<table class="mainlist" style="width: 100%;">
							<tr>
								<th class="inputTh"><input type="checkbox"></th>
								<th class="nameTh"><spring:message code="ezCabinet.t18"/></th>
								<th class="deptTh"><spring:message code="ezCabinet.t19"/></th>
								<th class="valueTh"><spring:message code="ezCabinet.t20"/></th>
								<th class="limitTh"><spring:message code="ezCabinet.t21"/></th>
							</tr>
							<tr>
								<td><input type="checkbox"></td>
								<td>응웬바오</td>
								<td>오픈소루션</td>
								<td class="valueTd"><input type="text" value="500"><span>MB</span></td>
								<td>
									<select>
										<option>제한</option>
										<option>무제한</option>
									</select>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
			<div class="cabBttnDiv">
				<a class="imgbtn"><span><spring:message code='ezCabinet.t14'/></span></a>
				<a class="imgbtn"><span><spring:message code='ezCabinet.t15'/></span></a>
			</div>
		</div>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetTree.js"           ></script>
		<script type="text/javascript">
			(function() {
				var companyTree = new CabinetTree();
				window.addEventListener("load", function(e) {initBttns();}, false);
				
				function initBttns() {
					companyTree.setTreeInfo({
						treeId     : "compTree",
						initialUrl : "/ezCabinet/getCompanyTree.do",
						extendUrl  : "/ezCabinet/getSubNodes.do",
						click      : null,
						dblClick   : null,
						companyId  : document.getElementById("companyList").value
					});
					
					companyTree.makeTree();
					
					var selectCompBox      = document.getElementById("companyList");
					selectCompBox.onchange = function(e) {};
				}
				
				function makeAjaxCall(ajaxData, ajaxType, ajaxUrl, handleSuccess, handleError, asyncMode) {
					$.ajax({
						type: ajaxType,
						url: ajaxUrl,
						data: ajaxData,
						dataType: "JSON",
						async: asyncMode != false ? true : false,
						success : function(data) {
							handleSuccess(data);
						},
						error : function(error) {
							if (handleError != null) {
								handleError();
							}
							
							alert(CabinetMessages.strError);
						}
					});
				}
			})();
		</script>
	</body>
</html>
