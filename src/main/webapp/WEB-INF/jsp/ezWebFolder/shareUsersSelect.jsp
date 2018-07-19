<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<c:if test="${type eq 'NEW'}"><title><spring:message code='ezWebFolder.t323' /></title></c:if>
		<c:if test="${type ne 'NEW'}"><title><spring:message code='ezWebFolder.t217' /></title></c:if>
		<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1' />" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezWebFolder.e1'/>"></script>
		<link rel="stylesheet" href="<spring:message code='ezOrgan.e3'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/TreeView.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/context/share.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/organJson.js"></script>
		<script type="text/javascript">
			var type = "<c:out value='${type}'/>";
			var pDeptID = "<c:out value='${userInfo.deptID}'/>";
			var pCompanyID = "<c:out value='${userInfo.companyID}'/>";
			var primary = "<c:out value='${userInfo.primary}'/>";
			var arrSubFolder = [];
			var selectedDept = "";
			var selectedUser = "";
			var strErrMsg = messages.strLang7;
			var strDataNotFound = messages.strLang12;
			var strAlreadyAdd = "<spring:message code='ezWebFolder.t169'/>";
			var strAlertMsg = "<spring:message code='ezWebFolder.t171'/>";
			var strSearchError = "<spring:message code='ezWebFolder.t232'/>";
			var strSearchNotFound = "<spring:message code='ezWebFolder.t172'/>";
			var folderFileId = "<c:out value='${folderFileId}'/>";
			var folderFileType = "<c:out value='${folderFileType}'/>";
			
			window.onload = function () {
				preProcess();
			}
			
			function preProcess() {
				document.onselectstart = function() {
					return false;
				}
				
				getData(pDeptID, pCompanyID);
				
				if (type == "EDIT") {
					$.ajax({
						type: "POST",
						url: "/ezWebFolder/getShareUserList.do",
						data: {
							"folderFileId": folderFileId,
							"folderFileType": folderFileType
						},
						dataType: "JSON",
						async: false,
						success: function(data) {
							if (data.status == "ok") {
								initRangeData(data.data.userList);
							} else {
								alert(messages.strLang7 + " code: " + data.code);
							}
						},
						error: function(error) {
							alert(messages.strLang7);
						}
					});
				}
			}
			
			function addShare() {
				var deptList = document.getElementById("DListView");
				var userList = document.getElementById("MListView");
				
				if (deptList.rows.length + userList.rows.length <= 2) {
					alert(strDataNotFound);
					return;
				}
				
				var users = [], depts = [];
				
				if (deptList.rows.length > 1) {
					for (var i = 1; i < deptList.rows.length; i++) {
						depts.push(deptList.rows[i].getAttribute("nodeId"));
					}
				}
				
				if (userList.rows.length > 1) {
					for (var i = 1; i < userList.rows.length; i++) {
						users.push(userList.rows[i].getAttribute("nodeId"));
					}
				}
				
				shareContext.addShare(folderFileId, folderFileType, depts, users, false, addShareSuccess);
			}
			
			function addShareSuccess() {
				if (type == "NEW") {
					alert(messages.strLang28);
				} else {
					alert(messages.strLang29);
				}
				
				try {
					window.opener.refreshView();
				} catch(e) {}
				
                window.close();
			}
		</script>
		<style>
			.mainlist tr th {border-top:0px}
		</style>
	</head>
	<body class="popup">
		<c:if test="${type eq 'NEW'}"><h1><spring:message code='ezWebFolder.t323' /></h1></c:if>
		<c:if test="${type ne 'NEW'}"><h1><spring:message code='ezWebFolder.t217' /></h1></c:if>
		<div id="close">
            <ul>
                <li><span onclick="close_onclick()"></span></li>
            </ul>
        </div>
		<table>
			<tr>
				<td width="195" valign="top">
					<h2><spring:message code='ezWebFolder.t205' /></h2>
					<div style="overflow:auto; width:280px; height:270px; background-color:#ffffff; white-space: nowrap; padding:0;" id="TreeView" class="box"></div>
				</td>
				<td width="30" align="center" valign="middle">
					<div><img src="/images/arr_right.gif" width="16" height="16" vspace="3" onclick="add_dept();" style="cursor:pointer"></div>
					<div><img src="/images/arr_left.gif" width="16" height="16" vspace="3" onclick="unselect_dept();" style="cursor:pointer"></div>
				</td>
				<td valign="top">
					<h2><spring:message code='ezSchedule.t1004'/></h2>
					<div class="listview" style="margin-bottom:5px">
						<div id="DeptListView" style="overflow:auto;width:280px;height:270px;border:0">
							<table id="DListView" class="mainlist" style="width:100%;">
								<tr>
									<th style="text-align:center;"><spring:message code='ezWebFolder.t142'/></th>
								</tr>
							</table>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td valign="top">
					<h2 style="display: inline-block;"><spring:message code='ezWebFolder.t179'/></h2>
					<span style="float:right;padding-top:3px">
						<input id="cnkeyword" onkeypress="cnsearch_press(event)" style="width:120px;height:20px">
						<a class="imgbtn imgbck btnSearch" id="cnkeybtn" onclick="cnsearch_click()" style="vertical-align: top"><span><spring:message code='ezTask.t183' /></span></a>
					</span>
					<div class="listview" style="margin-top:3px;margin-bottom:5px">
						<div id="OrganListView" style="overflow:auto; width:280px; height:240px;border:0">
							<table id="Organ" class="mainlist" style="width: 100%;">
								<tr id="Organ_TH" style="">
									<th id="Organ_TH_0" class="h4_center" width="50px"><spring:message code='ezWebFolder.t175'/></th>
									<th id="Organ_TH_1" class="h5_center" width="70px"><spring:message code='ezWebFolder.t176'/></th>
									<th id="Organ_TH_2" class="h5_center" width="60px"><spring:message code='ezWebFolder.t142'/></th>
								</tr>
							</table>
						</div>
					</div>
				</td>
				<td width="30" align="center" valign="middle">
					<div><img src="/images/arr_right.gif" width="16" height="16" vspace="3" onclick="add_member();" style="cursor:pointer"></div>
					<div><img src="/images/arr_left.gif"  width="16" height="16" vspace="3" onclick="unselect_member();" style="cursor:pointer"></div>
				</td> 
				<td valign="top">
					<h2><spring:message code='ezTask.t137' /></h2>
					<div class="listview" style="margin-top:5px;margin-bottom:0px">
						<div id="MemberListView" style="overflow:auto; width:280px; height:240px;border:0">
							<table id="MListView" class="mainlist" style="width:100%;">
								<tr>
									<th style="text-align:center;"><spring:message code='ezWebFolder.t175'/></th>
								</tr>
							</table>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<div class="btnposition btnpositionNew">
						<a class="imgbtn btnSave"   name="Submit"  onclick="addShare();"><span><spring:message code='ezWebFolder.t116'/></span></a>
					</div>
				</td>
			</tr>
		</table> 
	</body>
</html>