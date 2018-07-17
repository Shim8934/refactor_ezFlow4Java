<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/dist/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
		<link rel="stylesheet" href="/css/ezPMS/pms.css" type="text/css">
<title><spring:message code='ezPMS.t290' /></title>
<script type="text/javascript">
var memberList = '${memberList}';
var memberScheduleList = JSON.parse('${memberScheduleList}');
var planStartDate = '${planStartDate}';
var planEndDate = '${planEndDate}';
var dateList = [];

$(function() {
	setMemberSchedule();
});

function setMemberSchedule() {
	for (var i = 0; i < memberScheduleList.length; i++) {
		var memberId = memberScheduleList[i].userId;
		var assignedDate = memberScheduleList[i].assignedDate;
		$("tr[userId='" + memberId + "']").find("td[date='" + assignedDate + "']").html("<div class='circle' onclick='getTaskNameList(this)'></div>");	
	}
}

function getTaskNameList(elem) {
	var clickedDate = $(elem).parent().attr("date");
	var clickedUser = $(elem).parent().parent().attr("userId");
	var projectId = "<c:out value='${projectId}'/>";
	
	$.ajax({
		type : "post",
		url : "/ezPMS/getDateTaskList.do",
		data : {
			"projectId" : projectId, 
			"selectedDate" : clickedDate, 
			"selectedUserId" : clickedUser
		},
		success : function(result) {
			if (result.length != 0) {
				var infoHTML = "<div class='tooltipTitle'>" + clickedDate + " <spring:message code='ezPMS.t137' /></div>";
				infoHTML += "<div class='tooltipText'>";
				
				for (var i = 0; i < result.length; i++) {
					infoHTML += "&gt; " + result[i] + "<br>";
				}
				
				infoHTML += "</div>";
				
				$(".tooltipBox").html(infoHTML);
			    $('.tooltipBox').show();
			} 
		},
		error : function(request, status, error) {
		}
	});
	
}

window.onload = function() {
	//툴팁 위치 지정
	var positionTooltip = function(event) {
		var tPosX = event.pageX - 5;
		var tPosY = event.pageY + 15;
		$(".tooltipBox").css({top:tPosY, left : tPosX});
	};
	
	$(document).on("click", ".circle", function(event) {
		//마우스 오버했을 때 툴팁위치 위치 지정해줌
		positionTooltip(event);
	});
	
	$("html").click(function(event) {
		if (!$(event.target).hasClass("circle")) {
			$(".tooltipBox").hide();
		}
	});
}
</script>
<style type="text/css">
.circle {
	width : 17px;
	height : 17px;
	border : 1px solid #d1d1d1;
	display : inline-block;
	margin-top : 1px;
	border-radius : 50%;
	background-color : #d1d1d1;
	cursor : pointer;
}
#memberTable {
	margin-left : 15px;
	margin-top : 50px;
	display : inline-block;
	width : 98%;
	overflow : auto;
	height : 568px;
	float : left;
}

#calendar {
	width : 84%;
	display : inline-block;
	height : 100%;
}

#mainmenu {
	margin : 13px;;
}

#memberList {
	width : 16%;
	float : left;
	overflow-x : hidden;
}

.tooltipBox {
	position:absolute;
	width:200px;
	border:1px solid #4e4e46;
}
		  
.tooltipBox .tooltipTitle { 
	height: 33px; 
	line-height: 33px; 
	padding: 0px 10px; 
	background: #f0f6ff; 
	border: 1px solid #d1ddec; 
	font-size:14px; 
	white-space: nowrap; 
	text-overflow: ellipsis; 
	overflow: hidden; 
}

.tooltipBox .tooltipText {
	padding:10px; 
	background:#fff; 
	font-size:12px; 
	line-height:22px;
}
</style>
</head>
<body>
<div id="close" style="float:right">
	<ul>
		<li>
			<span id="cancel" onclick="parent.DivMemberSchedulePopUpHidden()"></span>
		</li>
	</ul>
</div>
<div id="memberTable">
<div>
	<div>
	<table id="memberList" class="content">
	<tr>
		<th><spring:message code='ezPMS.t137' /> <spring:message code='ezPMS.t63' /></th>
		<th><spring:message code='ezPMS.t115' /></th>
	</tr>
	<c:forEach items="${memberList }" var="member">
	<tr id="${member.userId }">
		<td style="width:50%">${member.userName }</td>
		<td>${member.userDeptname }</td>
	</tr>
	</c:forEach>
	</table>
	</div>
	<div id="calendar">
	<table id="workSchedule" class="content">
	<tr>
	<c:forEach items="${dateList }" var="dateVO">
		<c:choose>
			<c:when test="${dateVO.holidayOrNot eq true}">
				<th style="background-color: rgba(236, 195, 176, 0.40);">${dateVO.date}</th>
			</c:when>
			<c:otherwise>
				<th>${dateVO.date}</th>
			</c:otherwise>
		</c:choose>
	</c:forEach>
	</tr>
	<c:forEach items="${memberList}" var="member">
	<tr userId="${member.userId }">
	<c:forEach items="${dateList}" var="dateVO">
		<c:choose>
			<c:when test="${dateVO.holidayOrNot eq true}">
				<td date="${dateVO.date}" style="text-align:center; background-color: #FFFAF2;">&nbsp;</td>
			</c:when>
			<c:otherwise>
				<td date="${dateVO.date}" style="text-align:center">&nbsp;</td>
			</c:otherwise>
		</c:choose>
		
	</c:forEach>
	</tr>
	</c:forEach>
	</table>
	</div>
</div>
</div>
<div class="tooltipBox" style="display : none;"></div>
</body>
</html>