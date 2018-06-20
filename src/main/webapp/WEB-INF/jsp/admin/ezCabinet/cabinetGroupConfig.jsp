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
		<h1><spring:message code='ezCabinet.t12'/></h1>
		<div class="cabiMain">
			<div class="compSelect" id="companySelect">
				<span><b><spring:message code='ezCabinet.t13'/></b></span>
				<select id="companyList">
					<c:forEach var="item" items="${list}">
						<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
					</c:forEach>
				</select>
			</div>
			
			<div class="cabGroupDiv">
				<div class="compOrg">
					<div class="deptPart">
						<div id="deptTree"></div>
					</div>
					<div class="usersPart"></div>
				</div>
				<div class="selectBttns">
					<div><img src="/images/arr_right.gif"></div>
					<div><img src="/images/arr_left.gif" ></div>
				</div>
				<div class="userDiv">
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
				var deptTree = new CabinetTree();
				window.addEventListener("load", function(e) {initBttns();}, false);
				
				function initBttns() {
					deptTree.setTreeInfo({
						treeId     : "deptTree",
						initialUrl : "/ezCabinet/getCompanyTree.do",
						extendUrl  : "/ezCabinet/getSubNodes.do",
						click      : getDeptMember,
						dblClick   : null,
						companyId  : document.getElementById("companyList").value
					});
					
					deptTree.makeTree();
					
					var selectCompBox      = document.getElementById("companyList");
					selectCompBox.onchange = function(e) {};
				}
				
				function getDeptMember() {
					var ajaxUrl      = "/ezCabinet/getDeptMembers.do";
					var selectedElmt = document.getElementsByClassName("selectedNode")[0];
					var data         = {"deptId" : selectedElmt.getAttribute("name")};
					
					makeAjaxCall( data, "GET", ajaxUrl, processUsersList, null, true);
				}
				
				function processUsersList(data) {
					var userList = data.listMembers;
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
