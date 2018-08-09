<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t192' /></title>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/jquery/jquery-1.11.3.min.js")%>"></script>
<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/XmlHttpRequest.js")%>"></script>
<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/mouseeffect.js")%>"></script>
<script type="text/javascript">
var selProjectId = "";
var selProjectName = "";

function popupClose() {
	parent.DivPopUpHidden();
 }
 
function selectProjectName(elem) {
	
	if ($(elem).parent().parent().attr("id") === "projectNameList") {
		$("#projectNameList tr").removeClass("selectTR");
	}
	
	$(elem).addClass("selectTR");
	selProjectId = $(elem).attr("id");
	selProjectName = $(elem).find("a").text();
}

function sendProjectName() {
	console.log(selProjectName);
	parent.$("#searchByProjectName").val(selProjectName);
	popupClose();
}
</script>
<style>
tr.hover:not (.selectTR ):hover {
	background: #eee;
	color: #fff;
}

.selectTR {
	background-color: rgb(233, 241, 255);
}

#List_TBODY2 tr {
	cursor: pointer;
}

#List_TBODY tr {
	cursor: pointer;
}
</style>
</head>
<body class = "popup" id="mainbody" style="overflow: hidden;">
		<form method = "POST">
			<div id="normalScreen" style="overflow: hidden;">
			    <div id="menu1" style="float: left; display: block; width:100%; text-align:left; padding-left:5px;">
					<h1 style="display: inline-block;"><spring:message code='ezPMS.t192' />
						<div id="close" style="float:right">
							<ul>
								<li>
									<span id="cancel" onclick="popupClose()"></span>
								</li>
							</ul>
					</div></h1>
			    </div>					
			</div>
			<div style="height:203px; overflow-y: auto; overflow-x: hidden;" id="divTbl">
				<table border=1 style="width : 100%; border-color: grey;" id="projectNameList">
					<c:forEach items="${projectNameList }" var="project">
						<tr class='white hover' style='border: 1px solid #ddd; cursor:pointer;' id="${project.projectId }" onclick="selectProjectName(this)">
							<td style='border-right:none; max-width: 200px; width: 190px;'>
								<a style='cursor:pointer; display:inline-block; padding: 0px 10px 0px 10px; float: left; line-height: 40px; overflow: hidden; text-overflow: ellipsis; max-width:120px; white-space: nowrap;'>${project.projectName }</a>
							</td>
						</tr>
					</c:forEach>
				</table>				
			</div>
			<table style="margin-top : 10px; margin-left:auto; margin-right:auto; border-spacing:10px 0; border-collapse: separate;">
			<tr>
				<td><a class="imgbtn" id="submit" onclick="sendProjectName()"><span><spring:message code='ezPMS.t43' /></span></a></td>
			</tr>
		</table>
		</form>
	</body>
</html>