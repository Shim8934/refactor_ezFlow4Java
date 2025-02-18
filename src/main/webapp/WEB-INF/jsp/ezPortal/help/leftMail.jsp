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
				<h1>메일</h1>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_01" target="right"><span>메인화면</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_02" target="right"><span>메일쓰기</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_03" target="right"><span>발송메일</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_04" target="right"><span>받은메일</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_05" target="right"><span>편지함관리</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_06" target="right"><span>메일 이동/복사</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_07" target="right"><span>메일 삭제</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_08" target="right"><span>메일검색</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_09" target="right"><span>외부메일확인</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_10" target="right"><span>메일내보내기/가져오기</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_11" target="right"><span>예약발송관리</span></a></h2>
				<ul>
				</ul>
			</c:when>
			<c:otherwise>
				<h1>電子メール</h1>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_jp_01" target="right"><span>メイン画面</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_jp_02" target="right"><span>メールの作成</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_jp_03" target="right"><span>送信メール</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_jp_04" target="right"><span>受信メール</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_jp_05" target="right"><span>メールフォルダの管理</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_jp_06" target="right"><span>メールの移動・コピー</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_jp_07" target="right"><span>メールの削除、永久削除</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_jp_08" target="right"><span>削除メールの管理</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_jp_09" target="right"><span>メールの検索</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_jp_10" target="right"><span>外部メールの確認</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_jp_11" target="right"><span>メールをPCに保存</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/mail_jp_12" target="right"><span>予約送信管理</span></a></h2>
				<ul>
				</ul>
			</c:otherwise>
		</c:choose>
		
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>