<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
	사다리
	<div align="center">
		<table border="1" cellspacing="0" width="700">
			<tr>
				<td>사다리 번호</td>
				<td>제목</td>
				<td>상태</td>
				<td>공개 여부</td>
				<td>작성자</td>
				<td>부서</td>
			</tr>
		<c:forEach items="${list }" var="vo">
			<tr>
				<td>${vo.ladderId }</td>
				<td>${vo.title }</td>
				<td>${vo.status }</td>
				<td>${vo.secretFlag }</td>
				<td>${vo.writerName }</td>
				<td>${vo.deptName }</td>
			</tr>
		</c:forEach>
		</table>
	</div>
</body>
</html>