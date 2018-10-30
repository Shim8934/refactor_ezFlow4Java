<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>게시판 설정</title>
<link rel="stylesheet"  href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css">
<style type="text/css">
#boardTreeArea {border:1px solid #ddd;padding:1px 0px 1px 1px; background-color:#fff;height:485px;overflow-x:hidden;overflow-y:auto;word-break:break-all}
#TopBoards tr:first-child h2 {border-top:0px;}
#TopBoards {width:100%;}
</style>
</head>
<body class="popup">
	<h1>게시판 설정</h1>
	<div id="close"><ul><li><span></span></ul></div>
	<div id="boardTreeArea">
		<table id="TopBoards">
		<c:forEach items="${boardList }" var="board">
			<tr>
				<td>
					<h2 class="boardTop" id="${board.id}"><span><c:out value="${board.text }"/></span></h2>
				</td>
			</tr>
			<tr>
				<td>
					<div class="boardSub"></div>
				<td>
			</tr>
		</c:forEach>
		</table>
	</div>
	<div class="btnposition btnpositionNew"><a class="imgbtn"><span>선택</span></a></div>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript">
$(function(){
	$("#close").on("click", function(){
		window.close();
	});
	
	eventSetting();
});

var eventSetting = function() {
	var boardIdList = $(".boardTop");
	var boardIdListCount = boardIdList.length;
	
	for (var i = 0; i < boardIdListCount; i++) {
		var boardId = boardIdList[i].id;
		
		$("#" + boardId).on("click", {"boardId" : boardId}, getSubBoards)
	}
}

var getSubBoards = function(event) {
	$(".boardSub").html("");
	
	var boardId = event.data.boardId;
	var companiesObj = document.getElementById("ListCompany");
	var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
	
	var request = new XMLHttpRequest();
	request.open('POST', '/admin/ezNewPortal/getSubBoards.do', false);
	request.setRequestHeader('content-type', 'application/json');
	
	request.onload = function() {
		if (request.status >= 200 && request.status < 400) {
			var result = JSON.parse(request.responseText);
			
		}
	}
	
	request.onerror = function() {}
	
	var data = JSON.stringify({
		menuId : menuId,
		companyId : companyValue,
		menuNames : menuNameList,
		menuInfo : menuInfo
	});
	 
	request.send(data);
}
</script>
</body>
</html>