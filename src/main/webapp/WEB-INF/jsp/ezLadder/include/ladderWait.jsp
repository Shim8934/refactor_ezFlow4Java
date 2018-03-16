<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
ladderWait.jsp 페이지입니다<br>
<ul>
<c:forEach items="${list }" var="people">	
	<li><span id="userName">${people.userName }</span></li>	
</c:forEach>
</ul>
<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
<ul>
<c:forEach items="${list }" var="people">	
	<li><span id="userItem">${people.item }</span></li>	
</c:forEach>
</ul>
