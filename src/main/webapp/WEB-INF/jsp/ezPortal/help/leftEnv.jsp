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
				<h1>환경설정</h1>
				<c:choose>
					<c:when test="${packageType == 'mail'}">
						<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_02" target="right"><span>개인정보관리</span></a></h2>
						<ul></ul>
						<c:if test="${isMailUsed == 'Y'}">
							<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_03" target="right"><span>메일환경설정</span></a></h2>
							<ul></ul>
						</c:if>
						<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_07" target="right"><span>언어및표준시간대설정</span></a></h2>
						<ul>
						</ul>
					</c:when>				
					<c:when test="${packageType == 'basic'}">
						<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_02" target="right"><span>개인정보관리</span></a></h2>
						<ul></ul>
						<c:if test="${isMailUsed == 'Y'}">
							<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_03" target="right"><span>메일환경설정</span></a></h2>
							<ul></ul>
						</c:if>
						<c:if test="${isScheduleUsed == 'Y'}">
							<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_04" target="right"><span>일정관리환경설정</span></a></h2>
							<ul></ul>
						</c:if>
						<c:if test="${isBoardUsed == 'Y'}">
							<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_06" target="right"><span>게시판환경설정</span></a></h2>
							<ul></ul>
						</c:if>
						<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_07" target="right"><span>언어및표준시간대설정</span></a></h2>
						<ul>
						</ul>
					</c:when>
					<c:otherwise>
						<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_01" target="right"><span>마이포탈설정</span></a></h2>
						<ul>
						</ul>
						<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_02" target="right"><span>개인정보관리</span></a></h2>
						<ul>
						</ul>
						<c:if test="${isMailUsed == 'Y'}">
							<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_03" target="right"><span>메일환경설정</span></a></h2>
							<ul></ul>
						</c:if>
						<c:if test="${isScheduleUsed == 'Y'}">
							<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_04" target="right"><span>일정관리환경설정</span></a></h2>
							<ul></ul>
						</c:if>
						<c:if test="${isApprUsed == 'Y'}">
							<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_05" target="right"><span>결재환경설정</span></a></h2>
							<ul></ul>
						</c:if>
						<c:if test="${isBoardUsed == 'Y'}">
							<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_06" target="right"><span>게시판환경설정</span></a></h2>
							<ul></ul>
						</c:if>
						<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_07" target="right"><span>언어및표준시간대설정</span></a></h2>
						<ul>
						</ul>
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<h1>環境設定</h1>
				<c:choose>
					<c:when test="${packageType == 'basic'}">
						<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_jp_02" target="right"><span>個人情報の管理</span></a></h2>
						<ul>
						</ul>
						<c:if test="${isMailUsed == 'Y'}">
							<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_03" target="right"><span>メールの環境設定</span></a></h2>
							<ul></ul>
						</c:if>
						<c:if test="${isScheduleUsed == 'Y'}">
							<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_04" target="right"><span>スケジュールの環境設定</span></a></h2>
							<ul></ul>
						</c:if>
						<c:if test="${isBoardUsed == 'Y'}">
							<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_06" target="right"><span>掲示板の環境設定</span></a></h2>
							<ul></ul>
						</c:if>
						<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_jp_07" target="right"><span>言語及び標準時の設定</span></a></h2>
						<ul>
						</ul>
					</c:when>
					<c:otherwise>
						<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_jp_01" target="right"><span>マイポータルページの設定</span></a></h2>
						<ul>
						</ul>
						<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_jp_02" target="right"><span>個人情報の管理</span></a></h2>
						<ul>
						</ul>
						<c:if test="${isMailUsed == 'Y'}">
							<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_03" target="right"><span>メールの環境設定</span></a></h2>
							<ul></ul>
						</c:if>
						<c:if test="${isScheduleUsed == 'Y'}">
							<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_04" target="right"><span>スケジュールの環境設定</span></a></h2>
							<ul></ul>
						</c:if>
						<c:if test="${isApprUsed == 'Y'}">
							<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_05" target="right"><span>決裁の環境設定</span></a></h2>
							<ul></ul>
						</c:if>
						<c:if test="${isBoardUsed == 'Y'}">
							<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_06" target="right"><span>掲示板の環境設定</span></a></h2>
							<ul></ul>
						</c:if>
						<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_jp_07" target="right"><span>回覧板の環境設定</span></a></h2>
						<ul>
						</ul>
						<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/env_jp_08" target="right"><span>言語及び標準時の設定</span></a></h2>
						<ul>
						</ul>
					</c:otherwise>
				</c:choose>
				
			</c:otherwise>
		</c:choose>
		
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>