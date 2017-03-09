<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezPortal.i2'/>" type="text/css" />
	</head>
	<link href="/css/help.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<body  id="left">
		<c:choose>
			<c:when test="${userInfo.lang != '3'}">
				<h1>게시판</h1>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/board_01" target="right">메인화면</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/board_02" target="right">게시물등록</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/board_03" target="right">게시물보기</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/board_04" target="right">마이게시판</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/board_05" target="right">게시물승인</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/board_06" target="right">게시물관리</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/board_07" target="right">게시물검색</a></span></h2>
				<ul>
				</ul>
			</c:when>
			<c:otherwise>
				<h1>掲示板</h1>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/board_jp_01" target="right">メイン画面</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/board_jp_02" target="right">掲示文登録</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/board_jp_03" target="right">掲示文閲覧</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/board_jp_04" target="right">マイ掲示板</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/board_jp_05" target="right">掲示文管理</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/board_jp_06" target="right">掲示文の検索</a></span></h2>
				<ul>
				</ul>
			</c:otherwise>
		</c:choose>
		
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>