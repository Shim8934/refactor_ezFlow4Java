<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<c:if test="${type eq 'NEW'}"><title>공유 추가</title></c:if>
		<c:if test="${type ne 'NEW'}"><title>공유 수정</title></c:if>
		<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"              ></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"           ></script>
		<script type="text/javascript" src="/js/ezWebFolder/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/TreeView.js"     ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js" ></script>
		<script type="text/javascript" src="/js/ezWebFolder/organJson.js"    ></script>
		<script type="text/javascript">
			var pCompanyID        = "<c:out value='${userInfo.companyID}'/>";
			var primary           = "<c:out value='${userInfo.primary}'/>";
			var arrSubFolder   = [];
			var selectedDept      = "";
			var selectedUser      = "";
			var strErrMsg         = "<spring:message code='ezWebFolder.t134'/>";
			var strDataNotFound   = "<spring:message code='ezWebFolder.t144'/>";
			var strAlreadyAdd     = "<spring:message code='ezWebFolder.t169'/>";
			var strAlertMsg       = "<spring:message code='ezWebFolder.t171'/>";
			var strSearchError    = "<spring:message code='ezWebFolder.t232'/>";
			var strSearchNotFound = "<spring:message code='ezWebFolder.t172'/>";
			var folderFileId      = "<c:out value='${folderFileId}'/>";
			var folderFileType    = "<c:out value='${folderFileType}'/>";
			window.onload = function () {
				preProcess();
			}
			
			function addShare() {
				var deptList = document.getElementById("DListView");
				var userList = document.getElementById("MListView");
				var shareSub = document.getElementById("shareSub");
				
				if (deptList.rows.length + userList.rows.length <= 2) {
					alert(strDataNotFound);
					return;
				}
				
				var requestArray = [];
				
				if (deptList.rows.length > 1) {
					for (var i = 1; i < deptList.rows.length; i++) {
						var obj = {
							"id" : deptList.rows[i].getAttribute("nodeId"),
							"type" : "D",
							"subStatus" : deptList.rows[i].getAttribute("shareSub")
						};
						
						requestArray.push(obj);
					}
				}
				
				if (userList.rows.length > 1) {
					for (var i = 1; i < userList.rows.length; i++) {
						var obj = {
							"id" : userList.rows[i].getAttribute("nodeId"),
							"type" : "U",
							"subStatus" : userList.rows[i].getAttribute("shareSub")
						};
						
						requestArray.push(obj);
					}
				}
				
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/addShare.do",
					contentType: 'application/json',
					data: JSON.stringify({
						"folderFileId" : folderFileId,
						"folderFileType" : folderFileType,
						"userList" : requestArray
					}),
					dataType: "JSON",
					async: false,
					success : function(data) {
						if (data.status == "ok") {
							alert("공유를 추가헸습니다.");
							
							try {
								window.opener.refreshView();
							} catch(e) {}
							
			                window.close();
						} else {
							alert(strErrMsg + " code: " + data.code);
						}
					},
					error : function(error) {
						alert(strErrMsg);
					}
				});
			}
			
		</script>
		<style>
			.mainlist tr th {border-top:0px}
		</style>
	</head>
	<body class="popup">
		<c:if test="${type eq 'NEW'}"><h1>공유 추가</h1></c:if>
		<c:if test="${type ne 'NEW'}"><h1>공유 수정</h1></c:if>
		<table> 
			<tr> 
				<td width="195" valign="top">
					<h2><spring:message code='ezWebFolder.t177' /></h2>
					<div style="overflow:auto; width:280px; height:270px; background-color:#ffffff; white-space: nowrap; padding:0;" id="TreeView" class="box"></div>
				</td>
				<td width="30" align="center" valign="middle"> 
					<div><img src="/images/arr_right.gif" width="16" height="16" vspace="3" onclick="add_dept();" style="cursor:pointer"></div>
					<div><img src="/images/arr_left.gif" width="16" height="16" vspace="3" onclick="unselect_dept();" style="cursor:pointer"></div>
				</td>
				<td valign="top">
					<h2><spring:message code='ezWebFolder.t178' /></h2>
					<div class="listview" style="margin-bottom:5px">
						<div id="DeptListView" style="overflow:auto;width:280px;height:270px;border:0">
							<table id="DListView" class="mainlist" style="width:100%;">
								<tr>
									<th style="text-align:center; width:60%;"><spring:message code='ezWebFolder.t142'/></th>
									<th style="text-align:center; width:40%;">하위폴더공유</th>
								</tr>
							</table>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td valign="top">
					<h2 style="display: inline-block;"><spring:message code='ezWebFolder.t179' /></h2>
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
					<h2><spring:message code='ezWebFolder.t180' /></h2>
					<div class="listview" style="margin-top:5px;margin-bottom:5px">
						<div id="MemberListView" style="overflow:auto; width:280px; height:240px;border:0">
							<table id="MListView" class="mainlist" style="width:100%;">
								<tr>
									<th style="text-align:center; width:60%;"><spring:message code='ezWebFolder.t175'/></th>
									<th style="text-align:center; width:40%;">하위폴더공유</th>
								</tr>
							</table>
						</div>
					</div>
				</td> 
			</tr>
			<tr style="height:35px;">
				<td>
					<input id="cnkeyword" onkeypress="cnsearch_press(event)" style="width:120px;">
					<a class="imgbtn btnSearch" id="cnkeybtn" onclick="cnsearch_click()"><span>검색</span></a>
					<input id="shareSub" type="checkbox" style="margin-top:3px;margin-left:10px;vertical-align:middle;" checked /><label for="shareSub">하위폴더 공유</label>
				</td>
				<td></td>
				<td>
					<div class="btnposition" style="margin-top:0px;padding-top:0px">
						<a class="imgbtn btnSave"   name="Submit"  onClick="addShare();"     ><span><spring:message code='ezWebFolder.t116' /></span></a>
						<a class="imgbtn btnCancel" name="Submit2" onClick="close_onclick();" ><span><spring:message code='ezWebFolder.t112' /></span></a>
					</div>
				</td>
			</tr>
		</table> 
	</body>
</html>