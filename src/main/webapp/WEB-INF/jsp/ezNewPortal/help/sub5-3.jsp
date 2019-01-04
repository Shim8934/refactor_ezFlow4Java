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
    <h3 class="contents_title">일정관리환경설정</h3>
	<h4 class="sub_title"> 포탈, 유틸메뉴에서 환경설정 아이콘 클릭 후 좌측 <b>일정관리환경설정</b> 매뉴를 클릭합니다. </h3>

    <!--내용시작 -->
    <h2> 일정관리 </h2>
	<ol class="content">
		<li>기본화면에서 일보기, 주보기, 월보기 중에서 선택합니다. </li>
		<li>한주시작요일 설정에서 일, 월 중에서 선택합니다. </li>
		<li>하루 일정시간설정을 시간리스트에서 선택합니다. </li>
		<li>개인비서를 지정하려면 <b>[비서지정]</b> 버튼을 클릭합니다. </li>
		<li>비서목록 창에서 비서로지정할 사용자를 선택 후 더블클릭하거나 <b>[&#9654;]</b> 버튼을 클릭합니다. </li>
		<li>비서설정을 마치면 <b>[확인]</b> 버튼을 클릭합니다. </li>
		<li>일정관리설정을 마치면 <b>[저장]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/schedule/schedule_set.png" alt="일정환경설정" title="일정환경설정" />
	

    <!--내용끝 -->
</body>
</html>