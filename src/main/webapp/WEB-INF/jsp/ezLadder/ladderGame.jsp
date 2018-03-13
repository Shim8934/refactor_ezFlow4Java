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
</script>
</head>
<body>
	<h3>
	* 프론트 꾸며야 됨.<br>
	* 웹소켓 - 참여자 바꾸기, 채팅
	</h3>
	<h2>${vo.title }</h2>
	사다리 번호  : ${vo.ladderId }<br>
	사다리 제목 : ${vo.type }<br>
	사다리 상태 : ${vo.status }<br>
	사다리 공개 : ${vo.secretFlag }<br>
	<c:choose>
		<c:when test="${id eq vo.writerId }">
			사다리 삭제 가능 :  <a href="#" onclick="deleteLadder(${vo.ladderId})"><img src ='/images/ezLadder/trash.png' width='30' height ='30'/></a><br>
		</c:when>
		<c:otherwise>
			사다리 삭제 불가 : <img src ='/images/ezLadder/trash.png' width='30' height ='30'/><br>
		</c:otherwise>
	</c:choose>
</body>
</html>