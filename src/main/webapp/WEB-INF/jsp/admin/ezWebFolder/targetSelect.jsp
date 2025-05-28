<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezWebFolder.t165' /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/organJson.js')}"></script>
		<script type="text/javascript">
			var pCompanyID        = "<c:out value='${pCompanyID}'/>";
			var primary           = "<c:out value='${primary}'/>";
			var arrSubFolder      = [];
			var selectedDept      = "";
			var selectedUser      = "";
			var strErrMsg         = "<spring:message code='ezWebFolder.t134'/>";
			var strDataNotFound   = "<spring:message code='ezWebFolder.t144'/>";
			var strAlreadyAdd     = "<spring:message code='ezWebFolder.t169'/>";
			var strAlertMsg       = "<spring:message code='ezWebFolder.t171'/>";
			var strSearchError    = "<spring:message code='ezWebFolder.t232'/>";
			var strSearchNotFound = "<spring:message code='ezWebFolder.t172'/>";
			
			window.onload = function () {
				preProcess();
			}
			
		</script>
		<style>
			.mainlist tr th {border-top:0px}
		</style>
	</head>
	<body class="popup">
		<h1><spring:message code='ezWebFolder.t165' /></h1>
		<div id="close">
            <ul>
                <li><span name="Submit2" onClick="close_onclick();"></span></li>
            </ul>
        </div>
		<table> 
			<tr> 
				<td width="195" valign="top">
					<h2><spring:message code='ezWebFolder.t205' /></h2>
					<div style="overflow:auto; width:280px; height:270px; background-color:#ffffff; white-space: nowrap;" id="TreeView" class="box"></div>
				</td>
				<td width="30" align="center" valign="middle"> 
					<div><img src="/images/arr_right.gif" width="16" height="16" vspace="3" onclick="add_dept();" style="cursor:pointer"></div>
					<div><img src="/images/arr_left.gif" width="16" height="16" vspace="3" onclick="unselect_dept();" style="cursor:pointer"></div>
				</td>
				<td valign="top">
					<h2><spring:message code='ezWebFolder.t178' /></h2>
					<div class="listview" style="margin-bottom:5px">
						<div id="DeptListView" style="OVERFLOW:auto;WIDTH:220px;HEIGHT:270px;border:0">
							<table id="DListView" class="mainlist" style="width:100%;">
								<tr><th style="text-align:center; width:100%;"><spring:message code='ezWebFolder.t142'/></th></tr>
							</table>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td valign="top">
					<h2 style="display: inline-block;"><spring:message code='ezWebFolder.t516'/></h2>
					<span style="float:right;padding-top:3px">
						<input id="cnkeyword" onkeypress="cnsearch_press(event)" style="width:120px;height:20px" />
						<a class="imgbtn imgbck btnSearch" id="cnkeybtn" onclick="cnsearch_click()" style="vertical-align: top"><span><spring:message code='ezWebFolder.t123' /></span></a>
					</span>
					<div class="listview" style="margin-top:5px;margin-bottom:5px">
						<div id="OrganListView" style="OVERFLOW:auto;WIDTH:280px;HEIGHT:240px;border:0">
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
						<div id="MemberListView" style="OVERFLOW:auto;WIDTH:220px;HEIGHT:240px;border:0">
							<table id="MListView" class="mainlist" style="width:100%;">
								<tr><th style="text-align:center; width:100%;"><spring:message code='ezWebFolder.t175'/></th></tr>
							</table>
						</div>
					</div>
				</td> 
			</tr>
			<tr>
				<td colspan="3">
					<div class="btnposition btnpositionNew">
						<a class="imgbtn btnSave"   name="Submit"  onclick="set_range();"><span><spring:message code='ezWebFolder.t116'/></span></a>
					</div>
				</td>
			</tr>
		</table> 
	</body>
</html>