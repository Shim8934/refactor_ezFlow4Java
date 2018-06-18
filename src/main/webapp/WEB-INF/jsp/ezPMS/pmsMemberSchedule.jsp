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
		$("tr[userId='" + memberId + "']").find("td[date='" + assignedDate + "']").text("O");
	}
}
</script>
<style type="text/css">
#memberTable {
	margin-left : 5px;
	display : inline-block;
	width : 30%;
	overflow : auto;
	height : 100%;
}

#calendar {
	width : 68%;
	overflow : auto;
	display : inline-block;
	height : 100%;
}

#mainmenue {
	margin : 5px 5px;
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
	<table class="content" style="width : 100%">
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
		<td date="${date }">X</td>
	</c:forEach>
	</tr>
	</c:forEach>
	</table>
</div>
</body>
</html>