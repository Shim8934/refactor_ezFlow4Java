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

<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezTask/jquery.lineProgressbar.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list.js')}"></script>

<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/pms.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/jquery.lineProgressbar.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/previewmail.css')}" type="text/css" />

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
		json.restDueday = "${project.restDueday}";
		projectList.push(json);
	</c:forEach>
	
	var projectListCount = projectList.length;
	
	for (var i = 0; i < projectListCount; i++) {
		var htmlStr = "";
		var project = projectList[i];
		
		if (project.status == "P") {
			htmlStr = "<span class='situation_progress' style='background-color:" + progressColor + ";'><spring:message code='ezPMS.t15' /></span>";
		} else if (projectList[i].status == "C") {
//			if (projectList[i].restDueday >= 0) {
				htmlStr = "<span class='situation_complete' style='background-color:" + completeColor + ";'><spring:message code='ezPMS.t17' /></span>";
/* 			} else if (projectList[i].restDueday < 0) {
				htmlStr = "<span class='situation_complete' style='background-color:" + completeColor + ";'><spring:message code='ezPMS.t17' /></span><span class='situation_delay' style='background-color:" + overdueColor + ";'><spring:message code='ezPMS.t18' /></span>";
			} */
		} else if (project.status == "S") {
			htmlStr = "<span class='situation_hold' style='background-color:" + holdColor + ";'><spring:message code='ezPMS.t19' /></span>";
		} else if (project.status == "L") {
			htmlStr = "<span class='situation_progress' style='background-color:" + progressColor + ";'><spring:message code='ezPMS.t15' /></span><span class='situation_delay' style='background-color:" + overdueColor + ";'><spring:message code='ezPMS.t18' /></span>";
		} else if (project.status == "W") {
			htmlStr = "<span class='situation_standby' style='background-color:" + waitColor + ";'><spring:message code='ezPMS.t16' /></span>";
		} else if (project.status == "D") {
			htmlStr = "<span class='situation_delet' style='background-color:" + deleteColor + ";'><spring:message code='ezPMS.t11' /></span>";
		}
		
		$("li[id='" + project.projectId + "']").find(".projectNameArea").find("span").prepend(htmlStr);
		var completeTaskPercent = (project.completeTaskCount / project.totalTaskCount) * 100;
		var lateTaskPercent = (project.lateTaskCount / project.totalTaskCount) * 100;
		
		if (isNaN(completeTaskPercent)) {
			completeTaskPercent = 0;
		}
		
		if (isNaN(lateTaskPercent)) {
			lateTaskPercent = 0;
		}
		
		$("div[name=" + project.projectId+"]").LineProgressbar({
			percentage : project.progress,
			fillBackgroundColor : progressColor,
			duration : 0,
			height : '15px',
			radius : '15px',
			width : '74%'
		});
		
		$("div[complete=" + project.projectId+"]").LineProgressbar({
			percentage : completeTaskPercent,
			fillBackgroundColor : completeColor,
			duration : 0,
			height : '15px',
			radius : '15px',
			width : '74%'
		});
		
		$("div[overdue=" + project.projectId+"]").LineProgressbar({
			percentage : lateTaskPercent,
			fillBackgroundColor : overdueColor,
			duration : 0,
			height : '15px',
			radius : '15px',
			width : '74%'
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
	
	if (projectListCount >= 20) {
		if ($("#totalCount").text() != projectListCount) {
			$(".project_mainlist").last().append("<div class='moreBtn' onclick='moreProjectList()'><span><spring:message code='ezPMS.t276' /></span></div>");
		}
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
			<li id="${project.projectId }" data-groupId="${project.groupId}" data-headmanagerid="${project.headManagerId}" ondblclick="goProjectDetails(this)">
				<div class="project_list" >
					<table>
						<tr>
							<th width="42"><input type="checkbox" name="memoCheckbox" onchange="checkedCheckboxMemo(this);"></th>
							<th class="projectNameArea"><span class="projectName"><c:out value="${project.projectName }"/></span></th>
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
                        	<p class="project_Dday">D <span class="point_red"><c:out value="${project.restDueday - 1 < 0 ? '+ '.concat(-(project.restDueday - 1)) : '- '.concat(project.restDueday - 1) }"/></span>
							</p>
						</li>
                        <li class="contentlayout_none date">
                            <p><span class="startBox">START</span><c:out value="${project.planStartDate }"/></p>
                            <p><span class="endBox">END</span><c:out value="${project.planEndDate }"/></p>
                        </li>
                    </ul>
                    <dl class="listBox_graph">
                    	<dt><spring:message code='ezPMS.t330' /></dt>
                    	<dd><c:out value="${project.headManagerName }" /></dd>
                    	<dt><spring:message code='ezPMS.t33' /></dt>
                    	<dd><div name="${project.projectId }"></div>
                    		<div style="display: inline-block; float:right;">
							<fmt:formatNumber value="${project.progress }" pattern="0.0" />%
							</div>
                    	</dd>
                    	<dt><spring:message code='ezPMS.t34' /></dt>
                    	<dd>
                    		<div complete="${project.projectId }"></div>
							<div style="display: inline-block; float:right;">
							<c:out value="${project.completeTaskCount }" /> / <c:out value="${project.totalTaskCount }"/>
							</div>
						</dd>
						<dt><spring:message code='ezPMS.t35' /></dt>
						<dd>
							<div overdue="${project.projectId }"></div>
							<div style="display: inline-block; float:right;">
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