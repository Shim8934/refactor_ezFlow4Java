<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t155' /></title>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript"
	src="/js/ezTask/jquery.lineProgressbar.js"></script>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />"
	type="text/css">
<link href="/css/previewmail.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="/css/jquery.lineProgressbar.css"
	type="text/css">
<script type="text/javascript" src="/js/ezBoard/ListView_list.js"></script>
<script type="text/javascript">
var CurrentHeight = document.documentElement.clientHeight - 110;
setTotalCount("${projectListCount}");

$(function(){
	var projectList = new Array();
	var json;
	
	<c:forEach items="${projectList}" var="project">
		json = {};
		json.projectId = "${project.projectId}";
		json.progress = "${project.progress}";
		json.totalTaskCount = "${project.totalTaskCount}";
		json.completeTaskCount = "${project.completeTaskCount}";
		json.lateTaskCount = "${project.lateTaskCount}";
		json.status = "${project.status}";
		projectList.push(json);
	</c:forEach>
	
	for (var i = 0; i < projectList.length; i++) {
		var htmlStr = "";
		
		if (projectList[i].status == "P") {
			htmlStr = "<span class='statusSpan' style='background-color:" + progressColor + ";'><spring:message code='ezPMS.t15' /></span>";
		} else if (projectList[i].status == "C") {
			htmlStr = "<span class='statusSpan' style='background-color:" + completeColor + ";'><spring:message code='ezPMS.t17' /></span>";
		} else if (projectList[i].status == "S") {
			htmlStr = "<span class='statusSpan' style='background-color:" + holdColor + ";'><spring:message code='ezPMS.t19' /></span>";
		} else if (projectList[i].status == "L") {
			htmlStr = "<span class='statusSpan' style='background-color:" + overdueColor + ";'><spring:message code='ezPMS.t18' /></span>";
		} else {
			htmlStr = "<span class='statusSpan' style='background-color:#d1d1d1;'><spring:message code='ezPMS.t16' /></span>";
		}
		
		$("table#" + projectList[i].projectId + " td.status")[0].innerHTML = htmlStr;
		var completeTaskPercent = (projectList[i].completeTaskCount / projectList[i].totalTaskCount) * 100;
		var lateTaskPercent = (projectList[i].lateTaskCount / projectList[i].totalTaskCount) * 100;
		
		if (isNaN(completeTaskPercent)) {
			completeTaskPercent = 0;
		}
		
		if (isNaN(lateTaskPercent)) {
			lateTaskPercent = 0;
		}
		
		$("div[name=" + projectList[i].projectId+"]").LineProgressbar({
			percentage : projectList[i].progress,
			fillBackgroundColor : progressColor,
			height : '15px',
			radius : '15px',
			width : '80%'
		});
		
		$("div[complete=" + projectList[i].projectId+"]").LineProgressbar({
			percentage : completeTaskPercent,
			fillBackgroundColor : completeColor,
			height : '15px',
			radius : '15px',
			width : '80%'
		});
		
		$("div[overdue=" + projectList[i].projectId+"]").LineProgressbar({
			percentage : lateTaskPercent,
			fillBackgroundColor : overdueColor,
			height : '15px',
			radius : '15px',
			width : '80%'
		});
	}
	
	if (viewType == 0) {
		$("#memoStyleDiv").css("display", "");
		$("#memoStyle").attr("src", "/images/kr/cm/btn_onnoframe.gif");
		document.getElementById("memoStyleDiv").style.height = (CurrentHeight - 50) + "px";
	} else {
		$("#MailListRayer").css("display", "inline-block");
		$("#boardStyle").attr("src", "/images/kr/cm/btn_onbottomframe.gif");
		
		document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
		document.getElementById("divList").style.height = (CurrentHeight - 50) + "px";
	}
	
	if (projectList.length >= 20) {
		$("#memoStyleDiv").append("<div class='moreBtn' onclick='moreProjectList()' style='border:1px solid #d1d1d1; background-color:white; text-align:center; clear:both; cursor:pointer; height:33px; margin-left:3%; line-height:30px;'><span><spring:message code='ezPMS.t276' /></span></div>");
	}

});

</script>
<style type="text/css">
.projectList tr th span {
	width : 280px;
	text-overflow : ellipsis;
	overflow : hidden;
	display : inline-block;
	white-space : nowrap;
	font-size : 13px;
}

.statusSpan{
	font-size: 13px;
    padding: 4px;
    margin-left: 10px;
}
</style>
<body>
	<c:choose>
		<c:when test="${empty projectList}">
			<table style="width:100%; height:100%">
				<tr>
					<td style="text-align:center; font-size:15px;"><spring:message code='ezPMS.t30' /></td>
				</tr>
			</table>
		</c:when>
		<c:otherwise>
		<c:forEach items="${projectList }" var="project">
		<table id="${project.projectId }" class="projectList" style="margin: 10px 20px; float: left; position: relative; border: solid 1px #d1d1d1; clear: none; width: 360px; left: 2%; cursor:pointer;" ondblclick="goProjectDetails(this)">
			<tr>
				<th colspan="2" style="height: 30px; font-size: 15px;">
					<input type="checkbox" onchange="checkedCheckboxMemo(this);" name="memoCheckbox" style="margin-top: 7px; padding: 0px; width: 13px; height: 13px; cursor: pointer; float: left">
						<span style="margin-top:7px;"><c:out value="${project.projectName }" /></span>
						<c:choose>
							<c:when test="${project.isFavorite eq 0}">
								<img class="star" style="cursor: pointer; float: right; margin-top:7px;" draggable="false" src="/images/ImgIcon/view-flag.gif"
								onclick="addFavoriteMemo(${project.projectId })">
							</c:when>
							<c:otherwise>
								<img class="star" style="cursor: pointer; float: right; margin-top:7px;" draggable="false" src="/images/ImgIcon/icon-flag.gif"
								onclick="deleteFavoriteMemo(${project.projectId })">
							</c:otherwise>
						</c:choose>
				</th>
			</tr>
			<tr onclick="selectedMemoTR(this);">
				<td class="status" colspan="2" style="height:29px;">
				</td>
			</tr>
			<tr onclick="selectedMemoTR(this);">
				<td colspan="2" style="text-align: center; font-size: 20px;" class="restDueday">D 
				<c:choose>
						<c:when test="${project.restDueday ge 0 }">- <c:out value="${project.restDueday }" /></c:when> <c:otherwise>+ <c:out value="${-project.restDueday }" /></c:otherwise>
				</c:choose>
				</td>
			</tr>
			<tr onclick="selectedMemoTR(this);">
				<td colspan="2" style="text-align: center">(<c:out value="${project.planStartDate }" /> ~ <c:out value="${project.planEndDate }" />)</td>
			</tr>
			<tr onclick="selectedMemoTR(this);">
				<td colspan="2" style="height:22px;">&nbsp;</td>
			</tr>
			<tr onclick="selectedMemoTR(this);">
				<td class="memoTd">&nbsp;&nbsp;<spring:message code='ezPMS.t32' /></td>
				<td><c:out value="${project.headManagerName }" /></td>
				</tr>
			<tr onclick="selectedMemoTR(this);">
			<td class="memoTd">&nbsp;&nbsp;<spring:message code='ezPMS.t33' /></td>
					<td><div name="${project.projectId }" style="margin-right: 2px;"></div>&nbsp;<div style="margin-top: 5px; display: inline-block;">
					&nbsp;<fmt:formatNumber value="${project.progress }" pattern="0.0" /></div>
				</td>
			</tr>
			<tr onclick="selectedMemoTR(this);">
				<td class="memoTd">&nbsp;&nbsp;<spring:message code='ezPMS.t34' /></td>
				<td><div complete="${project.projectId }" style="margin-right: 2px;"></div>&nbsp;
					<div style="margin-top: 5px; display: inline-block;">
					<c:out value="${project.completeTaskCount }" /> / <c:out value="${project.totalTaskCount }"/>
					</div>
				</td>
			</tr>
			<tr onclick="selectedMemoTR(this);">
				<td class="memoTd">&nbsp;&nbsp;<spring:message code='ezPMS.t35' /></td>
					<td><div overdue="${project.projectId }" style="margin-right: 2px;"></div>&nbsp;
					<div style="margin-top: 5px; display: inline-block;">
					<c:out value="${project.lateTaskCount }" /> / <c:out value="${project.totalTaskCount }"/>
					</div>
				</td>
			</tr>
		</table>
		</c:forEach>
	</c:otherwise>
	</c:choose>
</body>
</html>