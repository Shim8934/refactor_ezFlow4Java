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
    <h3 class="contents_title">메일확인</h3>
	<h4 class="sub_title">수신한 메일은 받은편지함에 저장됩니다. </h4>

    <!--내용시작 -->
	<h2> 메일보기 </h2>
	<h3 class="sub_content"> 분류설정이 되어 있는 경우에는 지정한 편지함으로 자동분류되어 저장됩니다.<br>(환경설정>메일환경설정>자동분류) </h3>
	<ol class="content">
		<li>좌측 메뉴에서 받은편지함을 클릭합니다. </li>
		<li>받은편지함의 메일 목록에서 메일을 더블클릭하거나 미리보기로 내용을 확인합니다. </li>
		<li>보낸사람, 보낸날짜를 확인합니다. 보낸사람이름 클릭시 발송자에게 회신하기 창으로 전환됩니다. </li>
		<li>받는사람/참조자가 여러명인 경우 (총 ##명)으로 표시됩니다. 화살표를 클릭하면 받는사람/참조자가 모두 표시됩니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/view.png" alt="메일보기" title="메일보기" />
	
	<h2> 주소록에 추가 </h2>
	<h3 class="sub_content"> 메일의 보낸사람을 주소록에 추가 합니다. </h3>
	<ol class="content">
		<li>메일읽기 창에서 <b>[주소록에추가]</b> 버튼을 클릭합니다. </li>
		<li>주소함관리창에서 추가할 주소함을 선택후 상단의 <b>[확인]</b> 버튼을 클릭합니다. </li>
	</ol>
	<h4 class="explan"> ※ 주소함선택 창에서 주소함을 추가/수정할 수 있습니다. </h4>
	<img src="../../images/ezNewPortal/help/mail/add_to_address.png" alt="주소록에 추가" title="추소록에 추가" />
	
	<h2> 수신거부 </h2>
	<h3 class="sub_content"> 메일 보낸사람을 수신거부로 추가하여 이후부터 보내온 메일은 수신거부 처리합니다. </h3>
	<ol class="content">
		<li>메일읽기 창에서 <b>[수신거부]</b> 버튼을 클릭합니다.</li>
		<li>수신거부확인창에서 메일주소를 확인 후 <b>[확인]</b> 버튼을 클릭합니다.</li>
	</ol>
	<h4 class="explan"> ※ 수신거부된 주소를 해제하려면 환경설정>메일환경설정>자동분류에서 등록한 설정을 삭제합니다.</h4>
	<img src="../../images/ezNewPortal/help/mail/block_sender.png" alt="수신거부" title="수신거부" />
	
	<h2> 첨부파일 확인 및 다운로드 </h2>
	<h3 class="sub_content"> 첨부가 있는 메일은 메일목록보기 시 첨부아이콘이 표시됩니다. 메일읽기나 미리보기시 첨부목록에 첨부파일명이 표시되어 다운로드 할 수 있습니다.  </h3>
	<ol class="content">
		<li>메일읽기창에서 다운로드할 첨부제목을 클릭합니다. </li>
		<li>바로확인하려면 <b>[열기]</b> 버튼을 클릭하여 확인합니다. </li>
		<li>저장하려면 <b>[저장]</b> 버튼을 클릭하여 저장할 위치를 선택합니다. </li>
		<li><b>[모두저장]</b> 버튼을 클릭하면 폴더선택 후 <b>[확인]</b>버튼 클릭합니다. </li>
		<li>첨부리스트<b>[X]</b> 버튼을 클릭하면 메일에서 해당 첨부파일이 삭제됩니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/view_attached.png" alt="첨부확인" title="첨부확인" />
	
	<h2> 회신 </h2>
	<h3 class="sub_content"> 메일에 대한 회신을 보낼경우 사용합니다. </h3>
	<ol class="content">
		<li>메일읽기 창 상단의 <b>[회신]</b> 버튼을 클릭합니다. </li>
		<li>보낸사람이 수신자에 표시되며 제목앞에 <b>[회신:]</b>이 자동으로 표시됩니다. </li>
		<li>회신내용을 입력 후 상단 <b>[발송]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/reply.png" alt="회신" title="회신" />
	
	<h2> 전체회신 </h2>
	<h3 class="sub_content">  </h3>
	<ol class="content">
		<li>메일읽기 창 상단의 <b>[전체회신]</b> 버튼을 클릭합니다. </li>
		<li>보낸사람 및 참조자가 수신자에 표시되며 제목앞에 <b>[회신:]</b>이 자동으로 표시됩니다. </li>
		<li>회신내용을 입력 후 상단 <b>[발송]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/reply_all.png" alt="전체회신" title="전체회신" />
	
	<h2> 전달 </h2>
	<h3 class="sub_content"> 메일을 다른사람에게 전달합니다. </h3>
	<ol class="content">
		<li>메일읽기 창 상단의 <b>[전달]</b> 버튼을 클릭합니다.</li>
		<li>제목앞에 <b>[전달:]</b> 이 자동으로 표시되며 전달시 첨부문서도 포함됩니다.</li>
		<li>받는사람을 수신자 설정으로 지정합니다.</li>
		<li>전달내용을 입력 후 상단 <b>[발송]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/forward.png" alt="전달" title="전달" />
	
	<h2> 인쇄 </h2>
	<h3 class="sub_content"> 메일을 인쇄할 수 있습니다. </h3>
	<ol class="content">
		<li>메일읽기 창에서 <b>[인쇄]</b> 버튼을 클릭합니다.</li>
		<li>인쇄미리보기 화면을 확인하고 프린터를 선택 후 인쇄합니다.</li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/print.png" alt="인쇄" title="인쇄" />
	
	<h2> 이동/복사 </h2>
	<h3 class="sub_content"> 메일을 다른 편지함으로 이동/복사합니다. </h3>
	<ol class="content">
		<li>메일읽기 창에서 <b>[이동/복사]</b> 버튼을 클릭합니다.</li>
		<li>이동: 이동/복사 창에서 편지함을 선택 후 <b>[이동]</b> 버튼을 클릭합니다.</li>
		<li>복사: 이동/복사 창에서 편지함을 선택 후 <b>[복사]</b> 버튼을 클립합니다.</li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/copy_move.png" alt="이동/복사" title="이동/복사" />
	
	<h2> 삭제 </h2>
	<h3 class="sub_content"> 메일이 삭제됩니다. </h3>
	<ol class="content">
		<li>메일읽기 창에서 <b>[삭제]</b> 버튼을 클릭합니다. </li>
		<li>"이 메일을 삭제하시겠습니까?” 안내 메시지 창에서 <b>[확인]</b> 버튼을 클릭합니다. </li>
	</ol>
	<h4 class="explan"> ※ 삭제된 편지는 지운편지함으로 이동됩니다. </h4>
	<img src="../../images/ezNewPortal/help/mail/delete.png" alt="삭제" title="삭제" />
	
	<h2> 게시 </h2>
	<h3 class="sub_content"> 메일을 게시판에 게시합니다 </h3>
	<ol class="content">
		<li>메일읽기 창에서 <b>[게시]</b> 버튼을 클릭합니다. </li>
		<li>대상게시판선택 창에서 게시판을 지정 후 <b>[선택]</b> 버튼을 클릭합니다.</li>
		<li>게시글작성 창으로 전환되며 제목에 메일게시: 제목이 자동으로 표시되며 본문에 <b>[메일내용]</b>이 표시됩니다. <br> 첨부가 있는경우 첨부가 자동등록됩니다. </li>
		<li>게시내용을 작성 후 <b>[등록]</b> 버튼을 클릭합니다.</li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/post.png" alt="게시" title="게시" />
	
	<h2> 이전/다음 </h2>
	<h3 class="sub_content"> 메일 이전/다음 메일을 확인합니다.  </h3>
	<ol class="content">
		<li>메일읽기 창에서 <b>[화살표]</b> 버튼을 클릭하여 이전 메일을 확인합니다. </li>
		<li>메일읽기 창에서 <b>[화살표]</b> 버튼을 클릭하여 다음 메일을 확인합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/before_next.png" alt="이전/다음" title="이전/다음" />
    

    <!--내용끝 -->
</body>
</html>