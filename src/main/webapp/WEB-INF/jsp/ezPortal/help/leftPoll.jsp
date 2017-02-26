<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	</head>
	<link href="/css/help.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<body  id="left">
		<c:choose>
			<c:when test="${userInfo.lang != '3'}">
				<h1>전자설문</h1>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=poll/poll_01" target="right">메인화면</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=poll/poll_02" target="right">설문생성</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=poll/poll_03" target="right">설문관리</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=poll/poll_04" target="right">설문참여</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=poll/poll_05" target="right">설문결과확인</a></span> </h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=poll/poll_06" target="right">설문검색</a></span> </h2>
				<ul>
				</ul>
			</c:when>
			<c:otherwise>
				<h1>アンケート</h1>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=poll/poll_jp_01" target="right">メイン画面</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=poll/poll_jp_02" target="right">アンケート登録</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=poll/poll_jp_03" target="right">アンケート管理</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=poll/poll_jp_04" target="right">アンケートへの参加</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=poll/poll_jp_05" target="right">アンケート結果の確認</a></span> </h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=poll/poll_jp_06" target="right">アンケートの検索</a></span> </h2>
				<ul>
				</ul>
			</c:otherwise>
		</c:choose>
		
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>