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
var projectName = "${project.projectName}";
var writerId = "${writerId}";
var writerName = "${writerName}";
var writerDeptName = "${writerDeptName}";
var writeType = null;

function addBoard() {

	var title = $("#title").val().trim();
	var writeContent = $("#writeContent").val().trim();
	
	// 긴급 게시 / 공지 사항 여부
	if($("#emergency").is("checked")) {
		if($("#notice").is("checked")) {
			writeType = 1;
		} else {
			writeType = 2;
		}
	} else {
		if($("#notice").is("checked")) {
			writeType = 3;
		} else {
			writeType = 4;
		}
	}
	
	if(title == "") {
		alert("제목을 입력해주세요.");
		return;
	}
	
	if(writeContent == "") {
		alert("내용을 입력해주세요.");
		return;
	}
	
	data = {
		projectId : projectId,
		projectName : projectName,
		writerId : writerId,
		writerName : writerName,
		writerDeptName : writerDeptName,
		title : title,
		writeContent : writeContent,
		writeType : writeType
	}
	
	console.log(projectId);
	console.log(projectName);
	console.log(writerId);
	console.log(writerName);
	console.log(writerDeptName);
	console.log(title);
	console.log(writeContent);
	console.log(writeType);
	
	$.ajax({
		type : "POST",
		url : "/ezPMS/addBoard.do",
		dataType : "json",
		contentType : "application/json; charset=UTF-8",
		data : JSON.stringify(data),
		success : function(result) {
			alert("성공");
			parent.location.reload();
			popupClose();
		},
		error : function() {
			alert("실패");
		}
	})
}
</script>
</head>
<body class="popup">
	<h1>새 글 추가</h1>
	<div id="main_body">
		<table class="content" style="width:100%;">
			<tr>
				<th>프로젝트명</th>
				<td>${project.projectName}(${projectId})</td>
				<th>게시종류</th>
				<td><input type="checkbox" id="emergency"/> 긴급게시 <input type="checkbox" id="notice"/> 공지사항</td>
			</tr>
			<tr>
				<th>작업이름</th>
				<td>${taskName}</td>
				<th>등록자</th>
				<td>${writerName}(${writerDeptName})</td>
			</tr>
			<tr>
				<th>제목</th>
				<td colspan="3"><input type="text" id="title" style="width: 100%;"/></td>
			</tr>
			<tr>
				<th>내용</th>
				<td colspan="3"><textarea id="writeContent" style="height:100px; width:98.5%; margin-top:2px; resize:none;"></textarea></td>
			</tr>
		</table>
		<table style="margin-top : 10px; margin-left:auto; margin-right:auto; border-spacing:10px 0; border-collapse: separate;">
			<tr>
				<td><a class="imgbtn" id="submit" onclick="addBoard()"><span>등록</span></a></td>
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