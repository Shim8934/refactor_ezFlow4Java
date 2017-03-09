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
				<h1>전자결재</h1>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_01" target="right"><span>메인화면</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_02" target="right"><span>기안하기</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_03" target="right"><span>기안문서회수</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_04" target="right"><span>반송문서재기안</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_05" target="right"><span>결재하기</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_06" target="right"><span>결재진행상태</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_07" target="right"><span>수신문서처리</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_08" target="right"><span>결재한문서 확인</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_09" target="right"><span>결재문서함</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_10" target="right"><span>문서재발송</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_11" target="right"><span>결재문서 목록 내보내기</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_12" target="right"><span>분류코드별문서함</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_13" target="right"><span>개인및부서문서함</span></a></h2>
				<ul>
				</ul>
			</c:when>
			<c:otherwise>
				<h1>電子決裁</h1>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_jp_01" target="right"><span>メイン画面</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_jp_02" target="right"><span>起案</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_jp_03" target="right"><span>起案文書の回収</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_jp_04" target="right"><span>返送文書の再起案</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_jp_05" target="right"><span>決裁</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_jp_06" target="right"><span>決裁進捗状況</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_jp_07" target="right"><span>受信文書の処理</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_jp_08" target="right"><span>決裁した文書</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_jp_09" target="right"><span>決裁文書フォルダ</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_jp_10" target="right"><span>再発送</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=/images/help/appr_jp_11" target="right"><span>個人及び部署文書フォルダ</span></a></h2>
				<ul>
				</ul>
			</c:otherwise>
		</c:choose>
		
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>