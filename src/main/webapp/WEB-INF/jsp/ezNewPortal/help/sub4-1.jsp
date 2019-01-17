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
    <h3 class="contents_title">게시등록</h3>
	<h4 class="sub_title"></h4>

    <!--내용시작 -->
    <h2> 게시등록 </h2>
	<h3 class="sub_content"> 사용자는 게시권한이 부여된 게시판에 게시물을 등록할 수 있습니다. <br>게시등록은 각 게시판 구분에 따라 다양하게 등록할 수 있습니다. </h3>
	<ol class="content">
		<li>좌측 게시판그룹/게시판 에서 게시글을 등록할 게시판을 선택합니다.</li>
		<li>우측 상단 <b>[등록]</b> 버튼을 클릭합니다.</li>
		<li>게시작성 창에서 <b>/등록/</b> 탭을 선택 합니다.(기본적으로 등록탭이 선택되어 있습니다.)</li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/write.png" alt="게시등록" title="게시등록" />
	
	<h2> 긴급게시 </h2>
	<h3 class="sub_content">긴급하게 게시글을 등록하여 전사 공유하여야 하는경우 긴급게시글을 작성할 수 있습니다.</h3>
	<ol class="content">
		<li>게시작성 창에서 게시종류의 긴급게시를 체크합니다.</li>
		<li>게시시 게시글목록에 제목이 빨간색으로 표시되며, 제목글앞에 긴급게시아이콘 <b>!</b> 이 표시됩니다.</li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/emergency.png" alt="긴급게시" title="긴급게시" />
	
	<h2> 공지사항 </h2>
	<h3 class="sub_content">전사적으로 공지하여 게시글을 등록해야 하는경우 공지사항게시글을 작성할 수 있습니다. </h3>
	<ol class="content">
		<li>게시작성 창에서 게시종류의 공지사항을 체크합니다.</li>
		<li>게시시 게시글목록 최상단에 게시되며, 제목글앞에 공지게시아이콘 <b>noti</b>가 표시됩니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/notice.png" alt="공지사항" title="공지사항" />
	
	<h2> 예약게시 </h2>
	<h3 class="sub_content">게시글작성시 해당 게시글이 게시될 시간을 예약해두어 지정한 예약시간에 게시되도록 작성할 수 있습니다. </h3>
	<ol class="content">
		<li>게시작성 창에서 <b>/일반설정/</b> 탭을 선택합니다.</li>
		<li>예약게시일: 예약게시에 체크합니다. </li>
		<li>게시글이 게시된 날짜를 달력에서 선택하고, 시간선택창에서 게시될 시간을 선택합니다. </li>
		<li>날짜를 다시 지정하려면, <b>[날짜초기화]</b> 버튼을 클릭합니다.</li>
		<li>게시시 예약게시일시 안내 메시지창이 나타나며, <b>[확인]</b> 버튼을 클릭합니다.</li>
		<li>게시목록 상단 <b>[예약게시]</b> 버튼을 클릭하면, 예약게시물목록을 조회할 수 있습니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/reservation.png" alt="예약게시" title="예약게시" />
	
	<h2> 게시만료일지정 </h2>
	<h3 class="sub_content">게시글작성시 게시만료일을 지정하여 게시하면 만료일까지만 게시글이 표시됩니다. </h3>
	<ol class="content">
		<li>게시작성 창에서 <b>/일반설정/</b> 탭을 선택합니다.</li>
		<li>게시만료일 날짜를 달력에서 선택합니다.  </li>
		<li>영구게시하려면, 영구게시에 체크합니다.  </li>
		<li>관리자가 해당 게시판에 게시만료일을 미리 지정해둔 경우에는 관리자가 셋팅한 날짜가 디폴트로 표시됩니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/expire_date.png" alt="게시만료일지정" title="게시만료일지정" />
	
	<h2> 게시요약 </h2>
	<h3 class="sub_content">게시글작성시 게시요약내용을 입력하면 게시글을 열람하지않고 게시글제목에 마우스오버시 요약내용을 툴팁으로 확인할 수 있습니다.</h3>
	<ol class="content">
		<li>게시작성 창에서 <b>/일반설정/</b> 탭을 선택합니다.</li>
		<li>게시요약란에 요약내용을 입력합니다. </li>
		<li>게시후, 게시글 목록에서 해당 게시글에 마우스오버시 툴팁으로 요약메세지가 표시됩니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/summary.png" alt="게시요약" title="게시요약" />
	
	<h2> 배경이미지 </h2>
	<h3 class="sub_content">관리자가 게시판관리>일반설정>배경이미지:사용함을 체크하여 게시판을 생성한경우 사용자는 해당 게시판에 게시글작성시 배경이미지를 선택하여 작성할 수 있습니다. </h3>
	<ol class="content">
		<li>게시작성 창에서 <b>/일반설정/</b> 탭을 선택합니다.</li>
		<li>배경이미지 선택란에서 관리자가 등록한 배경이미지를 선택합니다. </li>
		<li>선택한 이미지가 게시글작성 본문에 표시됩니다. </li>
	</ol>
	<h4 class="explan"> ※ 이미지추가 </h4>
	<ul class="explan_list">
		<li>사용자가 이미지를 추가하여 게시할경우 <b>[이미지추가]</b> 버튼을 클릭합니다.</li>
		<li>배경이미지등록 창에서 <b>[이미지등록]</b> 버튼을 클릭합니다.</li>
		<li>이미지의 사이즈를 변경시에는 하단 가로(px), 세로(px) 란에 사이즈를 입력합니다.</li>
		<li>파일찾아보기창에서 이미지로 등록할 파일을 선택 후 <b>[열기]</b> 버튼을 클릭합니다.</li>
		<li>배경이미지등록을 마치면 <b>[저장]</b> 버튼을 클릭합니다.</li>
		<li>선택한 이미지가 게시글작성 본문에 표시됩니다.</li>
	</ul>
	<img src="../../images/ezNewPortal/help/board/background_image.png" alt="배경이미지" title="배경이미지" />
	
	<h2> 확장컬럼 </h2>
	<h3 class="sub_content">관리자가 게시판관리>일반설정>확장컬럼>확장컬럼설정을 구성하여 게시판을 생성한경우 사용자는 해당 게시판에 게시글작성시 항목에 내용을 입력 또는 선택 후 작성할 수 있습니다. </h3>
	<ul class="explan">
		<li>Text Box: 문자입력박스</li>
		<li>Radio Button: 라디오선택버튼</li>
		<li>Check Box: 체크선택버튼</li>
	</ul>
	<ol class="content">
		<li>게시작성 창에서 <b>/등록/</b> 탭을 선택합니다. </li>
		<li>관리자가 등록한 항목을 확인 후 내용을 입력 또는 선택합니다. </li>
		<li>필수인 항목이 있으면 내용을 입력하지 않고 게시글 작성시 입력(선택) 안내메세지창이 나타납니다.</li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/expansion_column.png" alt="확장컬림" title="확장컬럼" />
	
	<h2> 익명게시등록 </h2>
	<h3 class="sub_content">관리자가 게시판관리>일반설정>게시판구분: 익명게시판을 선택하여 게시판을 생성한경우 사용자는 해당 게시판에 게시글작성시 익명으로 게시할 수 있습니다. </h3>
	<ol class="content">
		<li>게시작성 창에서 <b>/등록/</b> 탭을 선택합니다.</li>
		<li>게시암호 란에 암호를 입력합니다. <br>(게시암호는 게시물을 삭제하거나, 수정할때 필요합니다.)</li>
		<li>게시작성 창에서 <b>/일반설정/</b> 탭을 선택합니다. </li>
		<li>표시이름 란에 표시이름을 입력합니다.<br>(게시자명에 표시되며 입력하지않고 게시시 “홍길동” 으로 표시됩니다.)</li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/anonymous.png" alt="익명게시등록" title="익명게시등록" />
	
	<h2> 제목 </h2>
	<h3 class="sub_content">게시글의 제목을 입력합니다.</h3>
	
	<h2> 본문 </h2>
	<h3 class="sub_content">게시글의 본문을 작성합니다. 에디터 툴바를 이용하여 본문 텍스트 편집 이미지 추가 표삽입을 할 수 있습니다.<h3>
	<img src="../../images/ezNewPortal/help/board/content.png" alt="본문" title="본문" />
	
	<h2> 첨부 </h2>
	<h3 class="sub_content">게시글에 관련된 첨부가 있는경우 추가하여 발송할수 있습니다. </h3>
	<ol class="content">
		<li>게시작성 창에서 <b>[파일추가]</b> 버튼을 클릭합니다. </li>
		<li>파일선택화면에서 추가할 파일을 선택한 후 <b>[열기]</b> 버튼을 클릭하여 추가합니다.<br>파일선택시 Drag로 멀티선택할수 있으며 Ctrl, Shift키를 이용하여 여러 개 추가할수 있습니다.</li>
		<li>첨부파일을 Drag&Drop하여 첨부파일영역에 추가할 수 있습니다.</li>
		<li>삭제할 첨부앞에 체크박스에 체크후 <b>[파일삭제]</b> 버튼 클릭시 삭제됩니다.</li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/attached_1.png" alt="첨부" title="첨부" /> <br>
	<img src="../../images/ezNewPortal/help/board/attached_2.png" alt="첨부" title="첨부" />
	
	<h2> 임시저장 </h2>
	<h3 class="sub_content">작성중인 게시글을 임시보관함으로 이동하여, 작성한 내용을 저장할 수 있습니다.</h3>
	<ol class="content">
		<li>게시작성 창에서 <b>[임시저장]</b> 버튼을 클릭합니다. </li>
		<li>임시저장한 게시글은 마이게시판>임시보관함 에서 저장한 문서를 더블클릭하여 다시 작성할 수 있습니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/save.png" alt="임시저장" title="임시저장" />
	
	<h2> 등록(포토/썸네일게시판) </h2>
	<h3 class="sub_content">관리자가 게시판관리>일반설정>게시판구분: 포토게시판 또는 썸네일게시판을 선택하여 게시판을 생성한경우 사용자는 해당 게시판에 게시글작성시 사진을추가하여 게시할 수 있습니다.</h3>
	<ol class="content">
		<li>게시작성 창에 제목, 앨범소개를 입력합니다. </li>
		<li>상단 <b>[사진추가]</b> 버튼을 클릭합니다. </li>
		<li>파일 선택 창에서 추가할 파일을 선택 후, <b>[열기]</b> 버튼을 클릭합니다. </li>
		<li>사진소개리스트에 선택한 사진이 표시되며 사진소개란에 소개내용을 입력합니다. </li>
		<li>메인으로 표시할 사진인경우 메인 선택버튼에 선택합니다. </li>
		<li>추가된 사진을 삭제할경우 사진앞에 체크 후 상단 <b>[사진삭제]</b> 버튼을 클릭합니다. </li>
		<li>작성중인 게시글을 임시저장할경우, 상단 <b>[임시저장]</b> 버튼을 클릭합니다. </li>
		<li>게시글작성을 마치면 상단 <b>[저장]</b> 버튼을 클릭합니다.</li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/photo_board.png" alt="포토/썸네일게시판" title="포토/썸네일게시판" />

    <!--내용끝 -->
</body>
</html>
