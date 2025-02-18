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
				<h1>일정관리</h1>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/schedule_01" target="right">메인화면</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/schedule_02" target="right">일정등록</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/schedule_03" target="right">일정보기</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/schedule_04" target="right">일정관리</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/schedule_05" target="right">일정그룹관리</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/schedule_06" target="right">일정검색</a></span> </h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/schedule_07" target="right">공개일정검색</a></span> </h2>
				<ul>
				</ul>
			</c:when>
			<c:otherwise>
				<h1>スケジュール</h1>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/schedule_jp_01" target="right">メイン画面</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/schedule_jp_02" target="right">日程の登録</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/schedule_jp_03" target="right">日程の表示</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/schedule_jp_04" target="right">日程の管理</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/schedule_jp_05" target="right">日程グループの管理</a></span></h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/schedule_jp_06" target="right">日程の検索</a></span> </h2>
				<ul>
				</ul>
				<h2><span><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/schedule_jp_07" target="right">公開日程の検索</a></span> </h2>
				<ul>
				</ul>
			</c:otherwise>
		</c:choose>
		
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>