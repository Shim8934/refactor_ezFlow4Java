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
<title>인력관리</title>
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
		console.log(memberId,assignedDate);
		$("tr[userId='" + memberId + "']").find("td[date='" + assignedDate + "']").html("<div class='circle'></div>");	}
}
</script>
<style type="text/css">
.circle {
	width : 17px;
	height : 17px;
	border : 1px solid black;
	display : inline-block;
	margin-top : 1px;
	border-radius : 50%;
}
#memberTable {
	margin-left : 15px;
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
	overflow-x : auto;
}

#mainmenu {
	margin : 13px;;
}

#memberList {
	width : 16%;
	float : left;
	overflow-x : hidden;
}
</style>
</head>
<body>
<div id="mainmenu">
<ul>
	<li><span onclick="popupClose()">뒤로</span></li>
</ul>
</div>
<div id="memberTable">
<div>
	<div>
	<table id="memberList" class="content">
	<tr>
		<th>이름</th>
		<th>부서</th>
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
	<c:forEach items="${dateList }" var="date">
		<th>${date }</th>
	</c:forEach>
	</tr>
	<c:forEach items="${memberList }" var="member">
	<tr userId="${member.userId }">
	<c:forEach items="${dateList }" var="date">
		<td date="${date }" style="text-align:center">&nbsp;</td>
	</c:forEach>
	</tr>
	</c:forEach>
	</table>
	</div>
</div>
</div>
</body>
</html>