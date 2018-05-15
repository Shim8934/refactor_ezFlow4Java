<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/ezPMS/default/style.min.css" type="text/css" />
<link rel="stylesheet" href="/css/default_kr.css" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezPMS/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
</head>
<body>
	<div id="divList">
		<table class="mainlist" width="100%">
			<thead>
				<tr>
					<th><input type="checkbox"></th>
					<th>No</th>
					<th><img src="/images/newAttach.gif"></th>
					<th>제목</th>
					<th>작업이름</th>
					<th>부서</th>
					<th>게시자</th>
					<th>게시일</th>
					<th>조회수</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${data}" var="projectBoardVO">	
				<tr>
					<td><input type="checkbox"></td>
					<td>${projectBoardVO.itemId}</td>
					<td>파일</td>
					<td>${projectBoardVO.title}</td>
					<td>${projectBoardVO.taskId}</td>
					<td>${projectBoardVO.writerDeptName}</td>
					<td>${projectBoardVO.writerName}</td>
					<td>${projectBoardVO.writeDate}</td>
					<td>${projectBoardVO.readCount}</td>
				</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</body>
</html>