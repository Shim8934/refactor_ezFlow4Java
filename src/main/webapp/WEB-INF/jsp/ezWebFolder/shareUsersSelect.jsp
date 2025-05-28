<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<c:if test="${type eq 'NEW'}"><title><spring:message code='ezWebFolder.t323' /></title></c:if>
		<c:if test="${type ne 'NEW'}"><title><spring:message code='ezWebFolder.t217' /></title></c:if>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/share.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/organJson.js')}"></script>
		<style>
			.spanName {
				width:auto;text-overflow:inherit;
			}
		</style>
		<script type="text/javascript">
			var type = "<c:out value='${type}'/>";
			var pDeptID = "<c:out value='${userInfo.deptID}'/>";
			var pCompanyID = "<c:out value='${userInfo.companyID}'/>";
			var primary = "<c:out value='${userInfo.primary}'/>";
			var arrSubFolder = [];
			var selectedDept = "";
			var selectedUser = "";
			var strErrMsg = messages.strLang7;
			var strDataNotFound = messages.strLang31;
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
					if (type == "NEW") {
						alert(strDataNotFound);
						return;
					} else {
						var files = [];
						var folders = [];
						
						if (folderFileType == "F") {
							files.push(folderFileId);
						} else {
							folders.push(folderFileId);
						}
						
						shareContext.deleteShareConfirm(type, files, folders);
					}
				} else {
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
			
			function deleteShareSuccess() {
				DivPopUpHidden();
				
				alert(messages.strLang33);
				
				try {
					opener.refreshView();
				} catch (e) {}
				
				window.close();
			}
			
			function closeAllPopup() {
				DivPopUpHidden();
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
					<div><img src="/images/kr/cm/arr_right.gif" vspace="3" onclick="add_dept();" style="cursor:pointer"></div>
					<div><img src="/images/kr/cm/arr_left.gif" vspace="3" onclick="unselect_dept();" style="cursor:pointer"></div>
				</td>
				<td valign="top">
					<h2><spring:message code='ezWebFolder.t520'/></h2>
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
					<h2 style="display: inline-block;"><spring:message code='ezWebFolder.t517'/></h2>
					<span style="float:right;">
						<input id="cnkeyword" type="text" onkeypress="cnsearch_press(event)" style="width:120px;">
						<a class="imgbtn imgbck" id="cnkeybtn" onclick="cnsearch_click()" style="vertical-align: top; margin-top: 0px !important; height: 25px;"><span><spring:message code='ezWebFolder.t521' /></span></a>
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
					<div><img src="/images/kr/cm/arr_right.gif" vspace="3" onclick="add_member();" style="cursor:pointer"></div>
					<div><img src="/images/kr/cm/arr_left.gif"  vspace="3" onclick="unselect_member();" style="cursor:pointer"></div>
				</td> 
				<td valign="top">
					<h2><spring:message code='ezWebFolder.t319' /></h2>
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
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>