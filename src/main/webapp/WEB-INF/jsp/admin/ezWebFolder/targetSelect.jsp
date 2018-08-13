<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezWebFolder.t165' /></title>
		<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezOrgan.e3'/>" type="text/css">
		<link rel="stylesheet" href="<%=CommonUtil.addVer(application, "/css/ezWebFolder/webfolder.css")%>" type="text/css">
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/mouseeffect.js")%>"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/XmlHttpRequest.js")%>"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/ezWebFolder/ListView_list.js")%>"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/ezWebFolder/TreeView.js")%>"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/jquery/jquery-1.11.3.min.js")%>"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/ezWebFolder/organJson.js")%>"></script>
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
					<h2><spring:message code='ezWebFolder.t177' /></h2>
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
					<h2><spring:message code='ezWebFolder.t179' /></h2>
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
				<td>
					<input id="cnkeyword" onkeypress="cnsearch_press(event)" style="WIDTH:130px" />
					<a class="imgbtn btnSearch" id="cnkeybtn" onclick="cnsearch_click()" ><span><spring:message code='ezWebFolder.t123' /></span></a>
				</td>
				<td></td>
				<td>
					<div class="btnposition" style="margin-top:0px;padding-top:0px">
						<a class="imgbtn btnSave"   name="Submit"  onClick="set_range();"     ><span><spring:message code='ezWebFolder.t116' /></span></a>
					</div>
				</td>
			</tr>
		</table> 
	</body>
</html>