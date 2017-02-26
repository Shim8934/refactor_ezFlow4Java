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
				<h1>주소록</h1>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/addr_01" target="right">메인화면</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=addr/addr_02" target="right">주소등록</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=addr/addr_03" target="right">주소보기</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=addr/addr_04" target="right">주소록관리</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=addr/addr_05" target="right">주소함관리</a></span> </h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=addr/addr_06" target="right">주소록검색</a></span> </h2>
				<ul>
				</ul>
			</c:when>
			<c:otherwise>
				<h1>アドレス帳</h1>
					<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=addr/addr_jp_01" target="right">メイン画面</a></span></h2>
					<ul>
					</ul>
					<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=addr/addr_jp_02" target="right">アドレス登録</a></span></h2>
					<ul>
					</ul>
					<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=addr/addr_jp_03" target="right">アドレス帳閲覧</a></span></h2>
					<ul>
					</ul>
					<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=addr/addr_jp_04" target="right">アドレス帳管理</a></span></h2>
					<ul>
					</ul>
					<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=addr/addr_jp_05" target="right">アドレス帳管理</a></span> </h2>
					<ul>
					</ul>
					<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=addr/addr_jp_06" target="right">アドレス帳検索</a></span> </h2>
					<ul>
					</ul>
			</c:otherwise>
		</c:choose>
		
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>