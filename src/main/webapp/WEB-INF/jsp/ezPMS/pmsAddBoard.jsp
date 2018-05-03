<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/dist/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
<script>
var projectId = "${projectId}";
var projectName = null;
var writerId = "${writerId}";
var writerName = "${writerName}";
var writerDeptName = "${writerDeptName}";
var weight = null;
var projectStartDate = "${projectStartDate}";
var projectEndDate = "${projectEndDate}";
var planStartDate = "${planStartDate}";
var planEndDate = "${planEndDate}";
var managerList = null;
var overview = null;
var headManagerId = null;
var groupId = "";
var groupName = "";
var remainingWeight = "${remainingWeight}";
var weightInput = "${weightInput}";
</script>
</head>
<body class="popup">
	<h1>새 글 추가</h1>
	<div id="main_body">
		<table class="content" style="width:100%;">
			<tr>
				<th>업무명</th>
				<td colspan="3">
					<input type="text" id="taskName" class="textInput">
				</td>
			</tr>
			<tr>
				<th>등록자</th>
				<td colspan="3">${writerName}(${writerDeptName})</td>
			</tr>
			<tr>
				<th>계획시작일</th>
				<td style="width:50%"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"></td>
				<th>계획종료일</th>
				<td><input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"></td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openMemberList()"><span>담당자</span></a></th>
				<td colspan="3" style="height:70px" id="managers"></td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openGroupTree()"><span>상위그룹</span></a></th>
				<td colspan="3" style="height:70px;" id="upperGroup"></td>
			</tr>
			<tr>
				<th>가중치</th>
				<c:choose>
      				<c:when test="${weightInput == 0}">
						<td colspan="3">
						가중치 자동 계산
						</td>
					</c:when>
      				<c:when test="${weightInput == 1}">
						<td colspan="3">
						<input type="text" id="weight" value="0" style="width:40px;text-align:center"> %  &nbsp; 프로젝트 잔여 가중치 ${remainingWeight} % 
						</td>
					</c:when>
   				</c:choose>
			</tr>
			<tr>
				<th>업무개요</th>
				<td colspan="3"><textarea id="overview" style="height:100px; width:98.5%; margin-top:2px; resize:none;"></textarea></td>
			</tr>
		</table>
		<table style="margin-top : 10px; margin-left:auto; margin-right:auto; border-spacing:10px 0; border-collapse: separate;">
			<tr>
				<td><a class="imgbtn" id="submit" onclick="addTask()"><span>등록</span></a></td>
				<td></td>
				<td><a class="imgbtn" id="cancel" onclick="popupClose()"><span>취소</span></a></td>
			</tr>
		</table>
	</div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
	
</body>
</html>