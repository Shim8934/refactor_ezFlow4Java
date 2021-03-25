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
    <!-- breadcrumb -->
    <ul class="breadcrumb">
        <li><a href="javascript:history.go(-1)">< 뒤로</a></li>
        <li><a href="/ezNewPortal/help/sub1-1.do">&#8226; 맨앞으로 돌아가기</a></li>
        <li class="btn_print "><a href="javascript: window.print();">인쇄</a></li>
    </ul>
    <!-- title -->
    <h3 class="contents_title">메일 작성하기</h3>
	<h4 class="sub_title"> 우측 메일 툴바에서 <b>[메일쓰기]</b> 버튼을 클릭하거나, 좌측 <b>[메일쓰기]</b> 버튼을 클릭합니다. </h4>
	
    <!-- 내용시작 -->
	<h2> 수신자 선택 </h2>
	<h3 class="sub_content"> 수신자지정은 조직도, 주소록, 공용그룹, 간편주소록에서 지정할 수 있습니다. 또한 내게쓰기를 통해 자신을 지정할 수 있습니다. </h3>
	<ol class="content">
		<li>메일쓰기창에서 <b>[받는사람]</b>(또는 <b>[참조]</b>, <b>[숨은참조]</b>)버튼을 클릭합니다.</li>
		<li>수신자설정>조직도 탭을 선택한 후, 조직도에서 지정할 사용자가 포함된 부서를 선택한 후 부서원리스트에서 사용자를 선택한 후, 더블클릭하거나, <b>[&#9654;]</b> 버튼을 클릭합니다.</li>
	</ol>
	<h4 class="explan"> ※ 주소록, 직접입력으로도 추가할 수 있습니다.</h4>
	<img src="../../images/ezNewPortal/help/mail/write.png" alt="메일작성창" title="메일작성창" />
	
	<h2> 메일저장 </h2>
	<h3 class="sub_content"> 작성중인 메일을 임시보관함에 저장하여 나중에 다시 작성하여 발송할 수 있습니다.  </h3>
	<ol class="content">
		<li>메일쓰기 창에서 상단의 <b>[저장]</b> 버튼을 클릭합니다.</li>
		<li>메일작성중 일정시간 작성하지 않을 경우, 메일은 자동으로 임시보관함에 저장됩니다. </li>
	</ol>
	<h4 class="explan">※ 환경설정>기본환경설정>자동임시저장에서 임시저장할 시간(초)을 “사용안함, 60(초), 90(초), 120(초)”중에서 설정할 수 있습니다. </h4>
	<img src="../../images/ezNewPortal/help/mail/save.png" alt="메일저장" title="메일저장" />
	
	<h2> 이름확인 </h2>
	<h3 class="sub_content"> 메일작성시 수신자의 이름 일부만 입력하거나 전체이름을 입력하고 보낼 수 있는 이름(주소)인지를 확인합니다. </h3>
	<ol class="content">
		<li>메일쓰기 창에서 받는사람/참조/숨은참조 수신인 입력창에 이름을 입력한 후 상단의 <b>[이름확인]</b> 버튼을 클릭하거나 키보드의 Enter키를 입력합니다. 이름확인이 된 경우 하단에 밑줄이 표시됩니다.</li>
		<li>동일한 조건이 1개 이상일 경우 이름확인 팝업창에 목록이 표시됩니다. 지정할 이름을 선택 후 <b>[확인]</b> 버튼을 클릭합니다.</li>
		<li>이름확인 팝업창에 지정할 이름이 없다면 <b>[삭제]</b> 버튼을 클릭하여 수신자에서 제외시킵니다.</li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/name_check.png" alt="이름확인" title="이름확인" />
	
	<h2> 메일옵션 </h2>
	<h3 class="sub_content"> 중요도, 본문형태, 메시지추적설정, 예약발송의 메일옵션설정을 지정하여 발송할 수 있습니다. </h3>
	<ol class="content">
		<li>메일쓰기 창에서 <b>[메일옵션]</b> 버튼을 클릭합니다.</li>
		<li>추적설정에서 "이 메시지를 읽으면 알림(수신확인으로 확인) 내부용" 선택 시 수신확인한 시간을 확인할 수 있습니다.(보낸편지함>수신확인)</li>
		<li>예약발송설정에서 "예약발송 체크 후 발송날짜, 시간"을 설정 시 해당 시간에 메일이 예약발송됩니다.</li>
		<li>개별적으로 발신하려면 개별발신을 선택합니다.</li>
		<li>옵션설정이 완료되면 <b>[확인]</b> 버튼을 클릭합니다.</li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/option.png" alt="메일옵션" title="메일옵션" />
	
	<h2> 중요도 </h2>
	<h3 class="sub_content">작성중인 메일의 중요도를 선택할 수 있습니다.</h3>
	<ol class="content">
		<li>메일쓰기창 상단의 중요도에서 “낮음, 보통, 높음”중 선택합니다. 기본값은 “보통”으로 선택되어 있습니다.</li>
		<li>중요도를 낮음이나 높음으로 선택한 경우, 메일목록에 낮음, 높음 아이콘이 표시됩니다.</li>
	</ol>
	<img src="../../images/ezNewPortal/help/mail/importance_1.png" alt="메일작성창" title="메일작성창" /><br>
	<img src="../../images/ezNewPortal/help/mail/importance_2.png" alt="메일작성창" title="메일작성창" />
	
	<h2> 서명선택 </h2>
	<h3 class="sub_content">작성중인 메일에 서명을 넣는 기능입니다.</h3>
	<ol class="content">
		<li>메일쓰기 창 상단에 서명선택 매뉴에서 서명선택안함, 서명1, 서명2, 서명3중 사용할 서명을 선택합니다.</li>
	</ol>
	<h4 class="explan">※ 환경설정>서명관리에서 서명을 3개까지 등록할수 있으며 사용설정해 놓은 서명이 기본으로 나타납니다. </h4>
	<img src="../../images/ezNewPortal/help/mail/sign.png" alt="서명" title="서명" />
	
	<h2> 보내는사람이름 </h2>
	<h3 class="sub_content">메일을 외부로 발송시 수신자의 메일함에 보이는 “보내는사람이름”을 변경하여 발송할 수 있습니다.</h3>
	<ol class="content">
		<li>메일쓰기 창 상단에 보내는사람이름 선택 매뉴에서 사용할 이름을 선택합니다.</li>
	</ol>
	<h4 class="explan">※ 환경설정>기본환경설정>보내는사람이름에서 이름을 추가할 수 있으며, 설정해놓은 이름이 기본으로 나타납니다. </h4>
	<img src="../../images/ezNewPortal/help/mail/name.png" alt="보내는사람이름" title="보내는사람이름" />
	
	<h2> 제목 </h2>
	<h3 class="sub_content">메일의 제목을 입력합니다.</h3>
	
	<h2> 본문 </h2>
	<h3 class="sub_content">메일의 본문을 작성합니다. 편집기를 이용하여 본문 텍스트 편집, 이미지 추가, 표 삽입을 할 수 있습니다.</h3>
	<img src="../../images/ezNewPortal/help/mail/content.png" alt="본문" title="본문" />
	
	<h2> 첨부 </h2>
	<h3 class="sub_content">메일에 파일을 추가하여 발송할 수 있습니다.</h3>
	<ol class="content">
		<li>메일쓰기 창에서 <b>[파일추가]</b> 버튼을 클릭합니다.</li>
		<li>파일선택화면에서 파일을 선택한 후 <b>[열기]</b> 버튼을 클릭하여 추가합니다.<br>(Ctrl, Shift키를 이용하여 복수개의 파일을 선택하여 추가할 수 있음)</li>
		<li>첨부파일을 Drag&Drop하여 첨부파일영역에 추가할 수 있습니다.</li>
		<li>삭제는 첨부앞에 있는 박스에 체크후 <b>[파일삭제]</b> 버튼을 클릭합니다.</li>
	</ol>
	<h4 class="explan">※ 첨부되는 파일은 사이즈에 따라 첨부와 대용량첨부로 구분합니다.<br>대용량첨부로 구분되는 사이즈는 시스템관리자가 설정합니다.<br>파일의 사이즈가 대용량으로 지정된 파일보다 큰 경우 자동으로 대용량첨부로 전환됩니다. </h4>
	<img src="../../images/ezNewPortal/help/mail/attached_1.png" alt="일반첨부" title="일반첨부" /><br>
	<img src="../../images/ezNewPortal/help/mail/attached_2.png" alt="일반첨부" title="일반첨부" />
	
	<h2> 대용량첨부 </h2>
	<h3 class="sub_content"></h3>
	<ol class="content">
		<li>메일쓰기 창에서 <b>[대용량첨부]</b> 버튼을 클릭합니다.</li>
		<li>파일선택화면에서 파일을 선택한 후 <b>[열기]</b> 버튼을 클릭하여 추가합니다.<br>(Ctrl, Shift키를 이용하여 복수개의 파일을 선택하여 추가할 수 있음).</li>
		<li>첨부파일을 Drag&Drop하여 첨부파일영역에 추가할 수 있습니다.</li>
		<li>대용량첨부는 첨부목록 우측에 <b>[대용량]</b>으로 표시됩니다.</li>
		<li>삭제는 첨부앞에 있는 박스에 체크후, <b>[파일삭제]</b> 버튼을 클릭합니다.</li>
	</ol>
	<h4 class="explan">※ 대용량첨부파일은 직접 첨부가 아닌 링크형식으로 첨부됩니다. <br> 또한 표시된 기간 동안에만 다운로드 가능합니다. </h4>
	<img src="../../images/ezNewPortal/help/mail/high_capacity_attachment.png" alt="대용량첨부" title="대용량첨부" />
	
	<h2> 발송 </h2>
	<h3 class="sub_content">수신자설정, 제목, 본문, 파일첨부를 이용하여 메일작성이 완료되었으면 <br> 메일쓰기 상단의 <b>[발송]</b> 버튼을 눌러 발송합니다.</h3>
	<img src="../../images/ezNewPortal/help/mail/send.png" alt="메일발송" title="메일발송" />

    <!-- 내용끝 -->
</body>
</html>