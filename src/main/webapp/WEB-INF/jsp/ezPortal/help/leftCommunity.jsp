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
				<h1>커뮤니티</h1>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/community_01" target="right">메인화면</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/community_02" target="right">알림마당</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/community_03" target="right">커뮤니티 만들기</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/community_04" target="right">Today Community</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/community_05" target="right">우수/신규 커뮤니티</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/community_06" target="right">My 커뮤니티 새글</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/community_07" target="right">카테고리별 커뮤니티</a></span></h2>
				<ul>
				</ul>
				 <h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/community_08" target="right">My 커뮤니티</a></span></h2>
				<ul>
				</ul>
				 <h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/community_09" target="right">커뮤니티 관리</a></span></h2>
				<ul>
				</ul>	
			</c:when>
			<c:otherwise>
				<h1>コミュニティー</h1>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/community_jp_01" target="right">メイン画面</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/community_jp_02" target="right">お知らせ広場</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/community_jp_03" target="right">コミュニティー作り</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/community_jp_04" target="right">Today Community</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/community_jp_05" target="right">優秀／新規コミュニティー</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/community_jp_06" target="right">My コミュニティーの新着情報</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/community_jp_07" target="right">カテゴリー別のコミュニティー</a></span></h2>
				<ul>
				</ul>
				 <h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/community_jp_08" target="right">My コミュニティー</a></span></h2>
				<ul>
				</ul>
				 <h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/community_jp_09" target="right">コミュニティー管理</a></span></h2>
				<ul>
				</ul>
			</c:otherwise>
		</c:choose>
		
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>