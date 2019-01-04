<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/ezNewPortal/webguide.css')}">
<title><spring:message code='main.t00037' /></title>
</head>
<body class="main_frame" id="top_main">
    <div class="btn_top"><a href="#" title="top">TOP</a></div>
    <!--breadcrumb -->
    <ul class="breadcrumb">
        <li><a href="javascript:history.go(-1)">< 뒤로</a></li>
        <li><a href="/ezNewPortal/help/sub1-1.do">&#8226; 맨앞으로 돌아가기</a></li>
        <li class="btn_print "><a href="javascript: window.print();">인쇄</a></li>
    </ul>
    <!--title -->
    <h3 class="contents_title"> 게시읽기 </h3>
	<h4 class="sub_title"></h4>

    <!--내용시작 -->
    <h2> 게시읽기 </h2>
	<ol class="content">
		<li>좌측 게시판그룹/게시판 에서 게시글을 열람할 게시판을 선택합니다.</li>
		<li>우측 게시목록 중 열람할 게시글을 선택 후, 더블클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/read.png" alt="게시읽기" title="게시읽기" />
	
	<h2> 답변 </h2>
	<h3 class="sub_content"> 관리자가 게시판관리>권한설정>답변: 허용을 체크하여 권한설정한 게시판의경우 사용자는 해당 게시판에 게시글읽기시 답변을 작성할 수 있습니다. </h3>
	<ol class="content">
		<li>게시물읽기 창에서 상단 <b>[답변]</b> 버튼을 클릭합니다. </li>
		<li>게시물답변창으로 전환되며 본문에 원문내용이 표시됩니다. </li>
		<li>본문에 답변내용을 입력 후 상단 <b>[등록]</b> 버튼을 클릭합니다. </li>
		<li>답변한게시글은 원 게시글 하위에 <b>[답변]</b> 아이콘이 제목앞에 표시됩니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/reply.png" alt="답변" title="답변" />
	
	<h2> 댓글 </h2>
	<h3 class="sub_content"> 관리자가 게시판관리>일반설정>댓글: 사용에 선택하여 게시판을 생성한경우 사용자는 해당 게시판에 게시글읽기시 댓글을 작성할 수 있습니다. </h3>
	<ol class="content">
		<li>게시물읽기 창에서 상단 <b>[댓글]</b> 버튼을 클릭합니다. </li>
		<li>작성자, 작성일시, 답변내용이 게시글본문 하단에 표시됩니다.</li>
		<li>한줄답변 삭제시 답변글 옆 <b>[X]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/comment.png" alt="한줄답변" title="한줄답변" />
	
	<h2> 수정 </h2>
	<h3 class="sub_content"> 사용자가 게시한 게시글에 대해 수정할 수 있습니다. </h3>
	<ol class="content">
		<li>게시물읽기 창에서 상단 <b>[수정]</b> 버튼을 클릭합니다. </li>
		<li>각 항목에 대하여 수정을 마치면 <b>[저장]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/modify.png" alt="수정" title="수정" />
	
	<h2> 삭제 </h2>
	<h3 class="sub_content"> 관리자가 게시판관리>권한설정>자신의 게시물 삭제: 허용을 체크하여 권한설정한 게시판의경우 사용자는 해당 게시판에 게시글작성 후 삭제할 수 있습니다. </h3>
	<ol class="content">
		<li>게시물읽기 창에서 상단 <b>[삭제]</b> 버튼을 클릭합니다. </li>
		<li>삭제안내 메시지를 확인 후 <b>[확인]</b> 버튼을 클릭합니다. </li>
		<li>게시목록에서 해당 글이 삭제됩니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/delete.png" alt="삭제" title="삭제" />
	
	<h2> 복사 </h2>
	<h3 class="sub_content"> 게시글을 다른 게시판에 복사할 수 있습니다. <br> 단, 복사하려는 게시판에 쓰기권한이 허용으로 설정되어 있어야 합니다. <br> (관리자>게시판관리>권한설정>쓰기: 허용) </h3>
	<ol class="content">
		<li>게시물읽기 창에서 상단 <b>[복사]</b> 버튼을 클릭합니다. </li>
		<li>대상 게시판 선택 창에서 복사할 게시판을 클릭 후 하단 <b>[선택]</b> 버튼을 클릭합니다. </li>
		<li>복사완료 메시지를 확인 후 <b>[확인]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/copy.png" alt="복사" title="복사" />
	
	<h2> 이동 </h2>
	<h3 class="sub_content"> 게시글을 다른 게시판에 이동할 수 있습니다. <br> 단, 이동하려는 게시판에 쓰기권한이 허용으로 설정되어 있어야 합니다. <br> (관리자>게시판관리>권한설정>쓰기: 허용) </h3>
	<ol class="content">
		<li>게시물읽기 창에서 상단 <b>[이동]</b> 버튼을 클릭합니다. </li>
		<li>대상 게시판 선택 창에서 복사할 게시판을 클릭 후 하단 <b>[선택]</b> 버튼을 클릭합니다. </li>
		<li>이동완료 메시지를 확인 후 <b>[확인]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/move.png" alt="이동" title="이동" />
	
	<h2> 메일로 발송 </h2>
	<h3 class="sub_content"> 게시글을 메일로 발송할 수 있습니다. </h3>
	<ol class="content">
		<li>게시물읽기 창에서 상단 <b>[메일로발송]</b> 버튼을 클릭합니다. </li>
		<li>메일쓰기 창이 팝업창으로 나타나며 메일제목란에 게시발송: 게시글제목이 표시됩니다. </li>
		<li>메일본문에는 게시글본문내용이 표시됩니다. </li>
		<li>첨부가 있을시 메일첨부란에 해당 첨부가 표시됩니다. </li>
		<li>수신자를 설정 후 <b>[발송]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/post.png" alt="메일로발송" title="메일로발송" />
	
	<h2> 조회자 정보 </h2>
	<h3 class="sub_content"> 해당 게시글의 사용자정보를 조회할 수 있습니다. 조회자정보는 최근 50명 까지만 표시됩니다. </h3>
	<ol class="content">
		<li>게시물읽기 창에서 상단 <b>[조회자정보]</b> 버튼을 클릭합니다. </li>
		<li>조회자정보 창에서 조회시간, 조회자명(ID), 부서명, 이름을 확인합니다. </li>
		<li>조회자의 상세정보를 확인하려면, 조회자명 클릭시 사원정보보기창이 팝업으로 나타납니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/viewer.png" alt="조회자정보" title="조회자정보" />
	
	<h2> 인쇄 </h2>
	<h3 class="sub_content"> 열람한 게시글을 인쇄할 수 있습니다. </h3>
	<ol class="content">
		<li>게시물읽기 창에서 상단 <b>[인쇄]</b> 버튼을 클릭합니다. </li>
		<li>인쇄항목 선택 창에서 문서하단에 함께 인쇄할 첨부정보 항목을 선택합니다. 선택을 마치면 <b>[선택인쇄]</b> 버튼을 클릭합니다.</li>
		<li>모두 인쇄할 경우 <b>[모두인쇄]</b> 버튼을 클릭합니다. </li>
		<li>문서만 인쇄할 경우 <b>[문서만인쇄]</b> 버튼을 클릭합니다.</li>
		<li>인쇄미리보기 화면을 확인한 후 프린터를 선택 후 인쇄합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/read_print.png" alt="인쇄" title="인쇄" />
	
	<h2> 재전송 </h2>
	<h3 class="sub_content"> 열람한 게시글을 재전송할 수 있습니다. </h3>
	<ol class="content">
		<li>게시물읽기 창에서 상단 <b>[재전송]</b> 버튼을 클릭합니다. </li>
		<li>재전송 창에서 게시물본문으로게시, 게시물첨부로게시, 우편본문으로 발송, 우편첨부로 발송 중 선택합니다. </li>
	</ol>
	<h4 class="explan"> 게시물 본문으로 전송 </h4>
	<ul class="explan_list">
		<li>새 게시물 작성 창이 실행되며 열람한 게시글의 본문이 본문에 자동으로 표시되어 새로작성 할 수 있습니다. </li>
	</ul>
	<h4 class="explan"> 게시물 첨부로 전송 </h4>
	<ul class="explan_list">
		<li>새 게시물 작성 창이 실행되며 열람한 게시글의 본문이 첨부파일로 자동으로 첨부되어 새로작성 할 수 있습니다. </li>
	</ul>
	<h4 class="explan"> 우편 본문으로 전송 </h4>
	<ul class="explan_list">
		<li>메일쓰기 창이 실행되며 열람한 게시글의 본문이 메일쓰기 본문에 자동으로 표시되어 메일발송 할 수 있습니다. </li>
	</ul>
	<h4 class="explan"> 우편 첨부로 전송 </h4>
	<ul class="explan_list">
		<li>메일쓰기 창이 실행되며 열람한 게시글의 본문이 첨부파일로 자동으로 첨부되어 메일발송 할 수 있습니다. </li>
	</ul>
	<img src="../../images/ezNewPortal/help/board/retransmission.png" alt="재전송" title="재전송" />

    <!--내용끝 -->
</body>
</html>
