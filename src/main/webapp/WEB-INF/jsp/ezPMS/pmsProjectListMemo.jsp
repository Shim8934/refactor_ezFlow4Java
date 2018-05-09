<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>프로젝트 목록</title>
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
var progressColor = "${progressColor}";
var completeColor = "${completeColor}";
var overdueColor = "${overdueColor}";
var holdColor = "${holdColor}";

$(function(){
	var projectList = new Array();
	
	<c:forEach items="${projectList}" var="project">
		var json = new Object();
		json.projectId = "${project.projectId}";
		json.progress = "${project.progress}";
		projectList.push(json);
	</c:forEach>
	
	for (var i = 0; i < projectList.length; i++) {
		$("div[name=" + projectList[i].projectId+"]").LineProgressbar({
			percentage : projectList[i].progress,
			fillBackgroundColor : progressColor,
			height : '15px',
			radius : '15px',
			width : '80%'
		});
		
		$("div[complete=" + projectList[i].projectId+"]").LineProgressbar({
			percentage : projectList[i].progress,
			fillBackgroundColor : completeColor,
			height : '15px',
			radius : '15px',
			width : '80%'
		});
		
		$("div[overdue=" + projectList[i].projectId+"]").LineProgressbar({
			percentage : projectList[i].progress,
			fillBackgroundColor : overdueColor,
			height : '15px',
			radius : '15px',
			width : '80%'
		});
	}
	
	if(viewType == 0) {
		$("#memoStyleDiv").css("display", "");
		$("#memoStyle").attr("src", "/images/kr/cm/btn_onnoframe.gif");
		document.getElementById("memoStyleDiv").style.height = (CurrentHeight - 50) + "px";
	} else {
		$("#MailListRayer").css("display", "inline-block");
		$("#boardStyle").attr("src", "/images/kr/cm/btn_onbottomframe.gif");
		
		document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
		document.getElementById("divList").style.height = (CurrentHeight - 50) + "px";

	}

});

</script>
<body>
	<div id="memoStyleDiv" style="height: 80%; width: 100%; overflow: auto; display: none;">
		<c:choose>
			<c:when test="${empty projectList}">
				<table style="width:100%; height:100%">
					<tr>
						<td style="text-align:center; font-size:15px;">프로젝트가 없습니다.</td>
					</tr>
				</table>
			</c:when>
			<c:otherwise>
			<c:forEach items="${projectList }" var="project">
			<table id="${project.projectId }" class="projectList" style="margin: 10px 20px; float: left; position: relative; border: solid 1px gray; clear: none; width: 360px; left: 2%; cursor:pointer;" ondblclick="goProjectDetails(this)">
				<tr>
					<th colspan="2" style="height: 30px; font-size: 15px;">
						<input type="checkbox" onchange="checkedCheckboxMemo(this);" name="memoCheckbox" style="margin: 0px; padding: 0px; width: 13px; height: 13px; cursor: pointer; float: left">
							<c:out value="${project.projectName }" />
							<c:choose>
								<c:when test="${project.isFavorite eq 0}">
									<img class="star" style="cursor: pointer; float: right;" draggable="false" src="/images/ImgIcon/view-flag.gif"
									onclick="addFavoriteMemo(${project.projectId })">
								</c:when>
								<c:otherwise>
									<img class="star" style="cursor: pointer; float: right;" draggable="false" src="/images/ImgIcon/icon-flag.gif"
									onclick="deleteFavoriteMemo(${project.projectId })">
								</c:otherwise>
							</c:choose>
					</th>
				</tr>
				<tr onclick="selectedMemoTR(this);">
					<td colspan="2">&nbsp;&nbsp;<c:out value="${project.status }" /></td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
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
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr onclick="selectedMemoTR(this);">
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr onclick="selectedMemoTR(this);">
					<td class="memoTd">&nbsp;&nbsp;총괄 담당자</td>
					<td><c:out value="${project.headManagerName }" /></td>
				</tr>
				<tr onclick="selectedMemoTR(this);">
					<td class="memoTd">&nbsp;&nbsp;전체 진행률</td>
					<td><div name="${project.projectId }" style="margin-right: 2px;"></div>&nbsp;<div style="margin-top: 5px; display: inline-block;">
						<c:out value="${project.progress }" /></div>
					</td>
				</tr>
				<tr onclick="selectedMemoTR(this);">
					<td class="memoTd">&nbsp;&nbsp;완료된 업무</td>
					<td><div complete="${project.projectId }" style="margin-right: 2px;"></div>&nbsp;
						<div style="margin-top: 5px; display: inline-block;">
						<c:out value="${project.progress }" />
						</div>
					</td>
				</tr>
				<tr onclick="selectedMemoTR(this);">
					<td class="memoTd">&nbsp;&nbsp;지연된 업무</td>
					<td><div overdue="${project.projectId }" style="margin-right: 2px;"></div>&nbsp;
						<div style="margin-top: 5px; display: inline-block;">
						<c:out value="${project.progress }" />
						</div>
					</td>
				</tr>
			</table>
		</c:forEach>
	</c:otherwise>
	</c:choose>
	</div>
</body>
</html>