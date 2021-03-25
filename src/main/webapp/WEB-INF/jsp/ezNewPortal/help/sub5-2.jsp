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
    <h3 class="contents_title"> 일정보기 </h3>
	<h4 class="sub_title"> 일정은 개인일정, 부서일정, 회사일정, 그룹일정으로 구분되며 일보기, 주보기, 월보기 형태로 확인할 수 있습니다. </h4>

    <!--내용시작 -->
	<h2> 일보기 </h2>
	<h3 class="sub_content"> 등록된 일정이 일단위 기준으로 화면에 표시됩니다. 24시간을 기준으로 타임별 등록된 일정을 조회할 수 있습니다.  </h3>
	<ol class="content">
		<li> 일정관리 상단 <b>[일보기]</b> 버튼을 클릭합니다. </li>
		<li> 다른 날짜의 일정을 조회하려면 좌측 상단의 달력에서 날짜를 클릭하거나 일보기화면 상단의 <b>[&lt;]</b>, <b>[&gt;]</b> 버튼으로 이동하여 조회합니다. </li>
		<li> 일정이 없는 시간대를 더블클릭하면 해당시간이 표시된 일정작성 창이 나타납니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/schedule/day.png" alt="일보기" title="일보기" />
    
	<h2> 주보기 </h2>
	<h3 class="sub_content"> 등록된 일정이 주단위 기준으로 화면에 표시됩니다. 일주일을 기준으로 등록된 일정을 조회할 수 있습니다. </h3>
	<ol class="content">
		<li> 일정관리 상단 <b>[주보기]</b> 버튼을 클릭합니다. </li>
		<li> 다른 주간의 일정을 조회하려면 좌측 상단의 달력에서 해당 주를 클릭하거나 주보기화면 상단의 <b>[&lt;]</b>, <b>[&gt;]</b> 버튼으로 이동하여 조회합니다. </li>
		<li> 일정이 없는 시간대를 더블클릭하면 해당시간이 표시된 일정작성 창이 나타납니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/schedule/week.png" alt="주보기" title="주보기" />
	
	<h2> 월보기 </h2>
	<h3 class="sub_content"> 등록된 일정이 월단위 기준으로 화면에 표시됩니다. 한달을 기준으로 등록된 일정을 조회할 수 있습니다. </h3>
	<ol class="content">
		<li> 일정관리 상단 <b>[월보기]</b> 버튼을 클릭합니다. </li>
		<li> 다른 월간의 일정을 조회하려면 좌측 상단의 달력에서 해당 월을 선택하거나 월보기 화면 상단의 상단의 <b>[&lt;]</b>, <b>[&gt;]</b> 버튼으로 이동하여 조회합니다. </li>
		<li> 일정이 없는 날짜를 더블클릭하면 해당시간이 표시된 일정작성 창이 나타납니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/schedule/month.png" alt="월보기" title="월보기" />
	
	<h2> 참석자초대 수락/거절하기 </h2>
	<h3 class="sub_content"> 다른 사용자가 초대한 일정은 일정관리 메뉴를 클릭할 경우 팝업 창으로 표시됩니다. </h3>
	<ol class="content">
		<li> 일정관리 메뉴를 클릭합니다. </li>
		<li> 초대일정이 있으면 참석자초대 창이 나타나며 <br> 참석요청에 응답하려면 참석자초대 창에서 초대일정의 박스에 체크한 후 수락 또는 거절 메뉴를 클릭합니다. </li>
	</ol>
	<h4 class="explan"> ※ 수락한 초대일정은 사용자의 일정에 자동으로 추가됩니다. </h4>
	<img src="../../images/ezNewPortal/help/schedule/received_attendee.png" alt="" title="" />
	
    <!--내용끝 -->
</body>
</html>