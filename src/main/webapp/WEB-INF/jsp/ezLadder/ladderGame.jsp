<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">

	var id = "${id}";
	var searchSelect = "${searchSelect}";
	var searchInput =  "${searchInput}";
	var mode = "${mode}";
	var currPage = "${currPage}";
	var back = "back";
	var allData = [];
	
	function deleteLadder(idx) {
	
		allData = [idx, searchSelect, searchInput, mode, currPage, back ];	
	
		if (confirm('삭제 하시겠습니까?')) {
			window.location.href= '/ezLadder/deleteLadder.do?allData=' + allData;
		} 
	}
	
	function reuse(idx) {
		/*
			재사용 추가 해야 됨
		*/
		if (confirm('재사용하시겠습니까?')) {
			window.location.href= '/ezLadder/setLadder.do?type=reuse';
			alert("ok");
		}
	}
</script>
</head>
<body style="min-width: 750px;">
	<h3>
	* 프론트 꾸며야 됨.<br>
	* 웹소켓 - 참여자 바꾸기, 채팅
	</h3>
	<div id="ladderInfo" style="margin-left: 30px; margin-right: 30px;">
		<h2>${vo.title }
			<span style="float: right; font-weight:normal;color:black;">
				종류 : ${vo.type }, 상태 : ${vo.status }, 공개 : ${vo.secretFlag } | 작성자 ${vo.writerName }, 부서 ${vo.deptName }, 
				<a href="#" onclick="reuse(${vo.ladderId})"><img src ='/images/ezLadder/reuse.png' width='30' height ='30'/></a>,
				<c:choose>
					<c:when test="${id eq vo.writerId }">
						<a href="#" onclick="deleteLadder(${vo.ladderId})"><img src ='/images/ezLadder/trash.png' width='30' height ='30'/></a><br>
					</c:when>
					<c:otherwise>
						<img src ='/images/ezLadder/trash.png' width='30' height ='30'/><br>
					</c:otherwise>
				</c:choose>
			</span> 
		</h2>
	</div>
	<div id="ladderGame" align="center">
		<br><br><br><br>
		상태가 대기이면 ladderWait.jsp 호출<br>
		상태가 완료이면 ladderComplete.jsp 호출<br><br><br>
		<c:forEach items="${list }" var="people">
			<span id="userName">[${people.userName },</span>&nbsp;&nbsp;&nbsp;
			<span id="userName">${people.resultUserName }]</span>&nbsp;&nbsp;&nbsp;
		</c:forEach>
		<br><br><br><br><br><br><br><br><br><br><br><br><br>
	</div>
	
	<div id="chat" align="center">
		ladderChat.jsp 호출
	</div>
</body>
</html>