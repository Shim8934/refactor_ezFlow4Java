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
<link rel="stylesheet" href="/css/ezPMS/default/style.min.css" type="text/css" />
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/dist/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>


<script>
var writerId = "${writerId}";
var writerName = "${writerName}";
var writerDeptName = "${writerDeptName}";
var writeType = null;
var projectId = "${projectId}"
var groupId = "${groupId}";
var taskId = "${taskId}";

function addBoard() {

	var title = $("#title").val().trim();
	var writeContent = message.GetEditorContent();
	var writeOverview = $("#writeOverview").val().trim();
	
	// 긴급 게시 / 공지 사항 여부
	if($("#emergency").is(":checked") == true) {
		if($("#notice").is(":checked") == true) {
			writeType = 1;
		} else {
			writeType = 2;
		}
	} else {
		if($("#notice").is(":checked") == true) {
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
		writerId : writerId,
		writerName : writerName,
		writerDeptName : writerDeptName,
		title : title,
		writeContent : writeContent,
		writeType : writeType,
		groupId : groupId,
		taskId : taskId,
		writeOverview : writeOverview
	}
	
	console.log(writerId);
	console.log(writerName);
	console.log(writerDeptName);
	console.log(title);
	console.log(writeContent);
	console.log(writeType);
	console.log(groupId);
	console.log(taskId);
	console.log(writeOverview);
	
	$.ajax({
		type : "POST",
		url : "/ezPMS/addBoard.do",
		dataType : "json",
		contentType : "application/json; charset=UTF-8",
		data : JSON.stringify(data),
		success : function(result) {
			alert("성공");
			parent.location.reload();
			window.close();
		},
		error : function() {
			alert("실패");
		}
	})
}

function getTaskSelectionTree() {
	DivPopUpShow(320, 320, "/ezPMS/getTaskSelectionTree.do?projectId="+projectId);
}

</script>
</head>
<body class="popup">
	<div id="menu">
		<ul>
			<li><span onclick="addBoard()">등록</span></li>
			<li style="float: right;"><span onclick="window.close()">닫기</span></li>
		</ul>
	</div>
	<div id="main_body" style="margin-top: 15px;">
		<table class="content" style="width:100%;">
			<tr>
				<th>프로젝트명</th>
				<td style="width: 50%">${projectName}</td>
				<th>게시종류</th>
				<td><input type="checkbox" id="emergency"/> 긴급게시 <input type="checkbox" id="notice"/> 공지사항</td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="getTaskSelectionTree()" style="margin-top: 2px;"><span>작업이름</span></a></th>
				<td style="width: 50%" id="taskName">${taskName}</td>
				<th>등록자</th>
				<td>${writerName}(${writerDeptName})</td>
			</tr>
			<tr>
				<th>제목</th>
				<td colspan="3"><input type="text" id="title" style="width: 100%;"/></td>
			</tr>
			<tr>
				<th>게시 개요</th>
				<td colspan="3"><input type="text" id="writeOverview" style="width: 100%;"/></td>
			</tr>
			 <tr>
	            <td colspan="4" style="vertical-align: top; height: 455px">
	                <iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding: 0; height: 98%; width: 100%; overflow: auto; margin-top:-1px"></iframe>
	            </td>
	        </tr>
		</table>
	</div>
	
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>