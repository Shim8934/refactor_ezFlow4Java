<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<style type="text/css">
.textInput {
	width : 100%;
}
</style>
<script>
 $(function(){
	$("#daysBeforeAlam").change(function(){
		var state = $("#daysBeforeAlam option:selected").val();
		if(state == "write") {
			$("#daysBeforeAlam").css("display", "none");
			$("#write").css("display", "");
		}
	});
 });
</script>
</head>
<body class="popup">
	<h1>New Project</h1>
	<div id="main_body">
		<table class="content" style="width:100%;">
			<tr>
				<th>프로젝트명</th>
				<td colspan="3">
					<input type="text" id="projectName" class="textInput">
				</td>
			</tr>
			<tr>
				<th>등록자</th>
				<td style="width:45%">${userName }</td>
				<th>가중치 설정</th>
				<td><form><input type="radio" name="weightInput" value="autoCalc" style="vertical-align:left" checked>자동 계산  <input type="radio" name="weightInput" value="writeCalc">직접입력</form></td>
			</tr>
			<tr>
				<th>시작일</th>
				<td style="width:45%"><input type="text"></td>
				<th>종료일</th>
				<td><input type="text"></td>
			</tr>
			<tr>
				<th><a class="imgbtn"><span>담당자</span></a></th>
				<td colspan="3" style="height:70px">
			</td>
			<tr>
				<th><a class="imgbtn"><span>참여자</span></a></th>
				<td colspan="3" style="height:70px">
			</td>
			<tr>
				<th><a class="imgbtn"><span>조회자</span></a></th>
				<td colspan="3" style="height:70px">
			</td>
			<tr>
				<th>개요</th>
				<td colspan="3"><textarea style="height:100px; width:98.5%; margin-top:2px; resize:none;"></textarea></td>
			</tr>
			
			<tr>
				<th>종료알림</th>
				<td style="width:45%"><input type="checkbox" name="endAlam" value="endAlam">프로젝트 작업 종료 알림메일 발송</td>
				<th>알림일</th>
				<td><select name="daysBeforeAlam" id="daysBeforeAlam">
						<option value="1" selected>1</option>
						<option value="3">3</option>
						<option value="5">5</option>
						<option value="10">10</option>
						<option value="write">직접입력</option>
					</select><input type="text" id="write" style="display:none;"> 일 전
				</td>
			</tr>
		</table>
		<table style="margin-top : 10px; margin-left:auto; margin-right:auto; border-spacing:10px 0; border-collapse: separate;">
			<tr>
				<td><a class="imgbtn"><span>등록</span></a></td>
				<td></td>
				<td><a class="imgbtn"><span>취소</span></a></td>
			</tr>
		</table>
	</div>
</body>
</html>