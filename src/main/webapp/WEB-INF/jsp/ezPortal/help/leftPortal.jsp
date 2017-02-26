<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	</head>
	<link href="/css/help.css" rel="stylesheet" type="text/css">
	<script src="/js/help/mouseeffect.js" type="text/javascript" ></script>
	<script type="text/javascript">
    	window.resizeTo("1200", "800");
	</script>
	<body  id="left">
		<c:choose>
			<c:when test="${userInfo.lang != '3'}">
				<h1>포탈</h1>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/portal_01" target="right">메인화면</a></span></h2>
				<ul></ul>
			</c:when>
			<c:otherwise>
				<h1>ポータル</h1>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/portal_jp_01" target="right">メイン画面</a></span></h2>
				<ul></ul>	
			</c:otherwise>
		</c:choose>
		
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>