<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	</head>
	<link href="${util.addVer('/css/help.css')}" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<body  id="left">
		<c:choose>
			<c:when test="${userInfo.lang != '3'}">
				<h1>자원관리</h1>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/resource_01" target="right">메인화면</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/resource_02" target="right">자원예약</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/resource_03" target="right">자원예약취소</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/resource_04" target="right">자원예약승인</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/resource_05" target="right">양식등록</a></span></h2>
				<ul>
				</ul>
			</c:when>
			<c:otherwise>
				<h1>設備管理</h1>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/resource_jp_01" target="right">メイン画面</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/resource_jp_02" target="right">設備予約</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/resource_jp_03" target="right">設備予約の削除</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/resource_jp_04" target="right">設備予約の承認</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/resource_jp_05" target="right">様式の登録</a></span></h2>
				<ul>
				</ul>
<!-- 				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/resource_jp_06" target="right">承認待ち</a></span></h2> -->
<!-- 				<ul> -->
<!-- 				</ul> -->
			</c:otherwise>
		</c:choose>
		
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>