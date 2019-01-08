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
    <h3 class="contents_title">자원예약</h3>
	<h4 class="sub_title">좌측 메뉴에서 예약하려는 공유자원을 선택한후 우측 상단 툴바에서 <b>[자원예약]</b> 버튼을 클릭합니다.</h4>

    <!--내용시작 -->
    <h2> 자원예약 </h2>
	<ol class="content">
		<li>자원예약 창에서 예약정보를 입력한 후 상단 <b>[저장]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/resource/new.png" alt="자원예약" title="자원예약" />
	<h4 class="explan"> ※ 참고</h4>
	<ul class="explan_list">
		<li>자원담당자의 사용승인이 필요한 자원의 경우 비허가 상태로 등록됩니다. </li>
		<li>자원예약 시 동시예약을 할 경우 <b>[자원선택]</b> 버튼을 클릭하여 여러 자원을 동시에 예약할 수 있습니다. </li>
		<li>좌측 자원구분을 클릭하여 공유자원전체현황 보기화면에서 공유자원명을 클릭하여 자원예약할 수도 있습니다. </li>
		<li><b>[저장]</b>버튼 클릭시 이미 예약된 신청이 있다면 중복 안내 팝업창이 나타납니다. </li>
	</ul>
	<img src="../../images/ezNewPortal/help/resource/overlap.png" alt="중복" title="중복" />
	
	<h2> 자원 반복 예약 </h2>
	<ol class="content">
		<li>자원예약반복설정 팝업창에서 예약시간, 반복주기 설정을 한 후 하단 <b>[확인]</b>버튼을 클릭합니다. </li>
	</ol>
	<h4 class="explan"> ※ 참고</h4>
	<ul class="explan_list">
		<li>예약시간: 약속의 시작시간과 종료시간 지정</li>
		<li>반복주기: 매일, 매주, 매월, 매년 또는 주단위로 요일마다 반복여부 지정</li>
		<li>반복주기 설정범위<br>&emsp; 시작: 반복 시작날짜 지정<br>&emsp; 종료일 지정 안함: 해당 일정 무한대 반복<br>&emsp; 다음횟수 반복 후 종료: 반복횟수 지정, 지정횟수 이후 해당일정 종료<br>&emsp; 끝날짜: 반복 끝날짜 지정 </li>
		<li><b>[예약반복제거]</b> 버튼을 클릭 시 자원예약 반복설정에서 설정한 설정값이 삭제됩니다. </li>
	</ul>
	<img src="../../images/ezNewPortal/help/resource/repetition.png" alt="게시등록" title="게시등록" />

    <!--내용끝 -->
</body>
</html>