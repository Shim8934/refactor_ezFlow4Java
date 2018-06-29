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
<link rel="stylesheet" href="/css/ezPMS/pms.css"
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
			htmlStr = "<span class='situation_progress' style='background-color:" + progressColor + ";'><spring:message code='ezPMS.t15' /></span>";
		} else if (projectList[i].status == "C") {
			htmlStr = "<span class='situation_complete' style='background-color:" + completeColor + ";'><spring:message code='ezPMS.t17' /></span>";
		} else if (projectList[i].status == "S") {
			htmlStr = "<span class='situation_delay' style='background-color:" + holdColor + ";'><spring:message code='ezPMS.t19' /></span>";
		} else if (projectList[i].status == "L") {
			htmlStr = "<span class='situation_hold' style='background-color:" + overdueColor + ";'><spring:message code='ezPMS.t18' /></span>";
		} else if (projectList[i].status == "W") {
			htmlStr = "<span class='situation_standby' style='background-color:" + waitColor + ";'><spring:message code='ezPMS.t16' /></span>";
		} else if (projectList[i].status == "D") {
			htmlStr = "<span class='situation_delet' style='background-color:" + deleteColor + ";'><spring:message code='ezPMS.t11' /></span>";
		}
		
		$("li[id='" + projectList[i].projectId + "']").find(".projectNameArea").find("span").prepend(htmlStr);
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
		$("#memoStyle").attr("src", "/images/kr/cm/btn_cardframe_on.png");
		document.getElementById("memoStyleDiv").style.height = (CurrentHeight - 50) + "px";
	} else {
		$("#MailListRayer").css("display", "inline-block");
		$("#boardStyle").attr("src", "/images/kr/cm/btn_listframe_on");
		
		document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
		document.getElementById("divList").style.height = (CurrentHeight - 50) + "px";
	}
	
	if (projectList.length >= 20) {
		$(".project_mainlist").last().append("<div class='moreBtn' onclick='moreProjectList()'><span><spring:message code='ezPMS.t276' /></span></div>");
	}

});

</script>
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
		<div class="project_mainlist">
		<ul class="project_mainlistUL">
		<c:forEach items="${projectList }" var="project">
			<li id="${project.projectId }"  ondblclick="goProjectDetails(this)">
				<div class="project_list" >
					<table>
						<tr>
							<th width="42"><input type="checkbox" name="memoCheckbox" onchange="checkedCheckboxMemo(this);"></th>
							<th class="projectNameArea">
								<span><c:out value="${project.projectName }"/></span>
							</th>
							<th width="42"><c:choose>
							<c:when test="${project.isFavorite eq 0}">
								<img class="star" draggable="false" src="/images/ImgIcon/view-flag.gif"
								onclick="addFavoriteMemo(${project.projectId })">
							</c:when>
							<c:otherwise>
								<img class="star" draggable="false" src="/images/ImgIcon/icon-flag.gif"
								onclick="deleteFavoriteMemo(${project.projectId })">
							</c:otherwise>
							</c:choose>
							</th>
						</tr>
					</table>
					<div class="listBox" onclick="selectedMemoTR(this);">
                    <ul class="contentlayout">
                        <li class="contentlayout_left">
                        	<p class="project_Dday">D <span class="point_red"><c:choose>
								<c:when test="${project.restDueday ge 0 }">- <c:out value="${project.restDueday }" /></c:when> <c:otherwise>+ <c:out value="${-project.restDueday }" /></c:otherwise>
								</c:choose></span>
							</p>
						</li>
                        <li class="contentlayout_none date">
                            <p><span class="startBox">START</span><c:out value="${project.planStartDate }"/></p>
                            <p><span class="endBox">END</span><c:out value="${project.planEndDate }"/></p>
                        </li>
                    </ul>
                    <dl class="listBox_graph">
                    	<dt><spring:message code='ezPMS.t32' /></dt>
                    	<dd><c:out value="${project.headManagerName }" /></dd>
                    	<dt><spring:message code='ezPMS.t33' /></dt>
                    	<dd><div name="${project.projectId }"></div>
                    		&nbsp;<div style="display: inline-block;">
							&nbsp;<fmt:formatNumber value="${project.progress }" pattern="0.0" />
							</div>
                    	</dd>
                    	<dt><spring:message code='ezPMS.t34' /></dt>
                    	<dd>
                    		<div complete="${project.projectId }"></div>&nbsp;
							<div style="display: inline-block;">
							<c:out value="${project.completeTaskCount }" /> / <c:out value="${project.totalTaskCount }"/>
							</div>
						</dd>
						<dt><spring:message code='ezPMS.t35' /></dt>
						<dd>
							<div overdue="${project.projectId }"></div>&nbsp;
							<div style="display: inline-block;">
							<c:out value="${project.lateTaskCount }" /> / <c:out value="${project.totalTaskCount }"/>
							</div>
						</dd>
                    </dl>
				</div>
				</div>
			</li>
		</c:forEach>
		</ul>
		</div>
	</c:otherwise>
	</c:choose>
</body>
</html>