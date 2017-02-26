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
				<h1>전자결재 G</h1>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_01" target="right"><span>메인화면</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_02" target="right"><span>기안하기</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_03" target="right"><span>기안문서회수</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_04" target="right"><span>반송문서 처리</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_05" target="right"><span>결재하기</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_06" target="right"><span>결재진행상태 확인</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_07" target="right"><span>결재문서 대외발송</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_08" target="right"><span>수신문서처리</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_09" target="right"><span>검색</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_10" target="right"><span>목록내보내기</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_11" target="right"><span>기록물 관리</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_12" target="right"><span>기록물철 등록 및 관리</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_13" target="right"><span>기록물 등록 및 관리</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_14" target="right"><span>편철확정</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_15" target="right"><span>단위업무관리</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_16" target="right"><span>기록물 인계</span></a></h2>
				<ul>
				</ul>
			</c:when>
			<c:otherwise>
				<h1>電子決裁G</h1>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_jp_01" target="right"><span>メイン画面</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_jp_02" target="right"><span>起案</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_jp_03" target="right"><span>起案文書の回収</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_jp_04" target="right"><span>返送文書の処理</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_jp_05" target="right"><span>決裁</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_jp_06" target="right"><span>決裁進捗状態の確認</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_jp_07" target="right"><span>決裁文書対外発送</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_jp_08" target="right"><span>受信文書の処理</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_jp_09" target="right"><span>検索</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_jp_10" target="right"><span>リストのダウンロード</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_jp_11" target="right"><span>記録物の管理</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_jp_12" target="right"><span>記録文綴じの登録及び管理</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_jp_13" target="right"><span>記録物の登録及び管理</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_jp_14" target="right"><span>編綴確定</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_jp_15" target="right"><span>単位業務の管理</span></a></h2>
				<ul>
				</ul>
				<h2><a style="width:100%; display:inline-block" href="/ezPortal/help/main.do?id=apprG/apprG_jp_16" target="right"><span>記録物綴じの引継ぎ</span></a></h2>
				<ul>
				</ul>
			</c:otherwise>
		</c:choose>
		
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>