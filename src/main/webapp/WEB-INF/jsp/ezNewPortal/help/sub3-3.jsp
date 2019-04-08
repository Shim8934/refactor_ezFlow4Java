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
    <h3 class="contents_title">결재환경설정</h3>
	<h4 class="sub_title"> 포탈, 유틸메뉴에서 환경설정 아이콘 클릭 후 좌측 <b>결재환경설정</b> 매뉴를 클릭합니다. </h4>

    <!--내용시작 -->
    <h2> 암호사용설정 </h2>
	<h3 class="sub_content"> 결재 승인시 암호입력 사용여부를 설정할 수 있습니다.  </h3>
	<ol class="content">
		<li>우측 <b>/암호사용설정/</b> 탭을 클릭합니다.</li>
		<li>사용여부의 사용/사용안함중 선택합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/password_set.png" alt="암호사용설정" title="암호사용설정" />
	
	<h2> 부재자설정 </h2>
	<ol class="content">
		<li>우측 <b>/부재자설정/</b> 탭을 클릭합니다.</li>
		<li>부재설정기간의 시작일, 종료일을 달력, 시간리스트에서 선택합니다. </li>
		<li>대리결재자의 <b>[지정]</b> 버튼을 클릭합니다. </li>
		<li>대리결재자선택 창에서 지정할 사용자를 선택 후 <b>[확인]</b> 버튼을 클릭합니다. </li>
		<li>대리결재자 지정한 것을 해제시 <b>[해제]</b> 버튼을 클릭합니다. </li>
		<li>부재자설정을 마치면 <b>[저장]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/absentee_set.png" alt="부재자설정" title="부재자설정" />
	
	<h2> 알림메일설정 </h2>
	<h3 class="sub_content"> 사용으로 설정한 메일을 본인이 받게됩니다. </h3>
	<ol class="content">
		<li>우측 <b>/알림메일설정/</b> 탭을 클릭합니다.</li>
		<li>결재문서 도착 알림메일을 받으려면 결재문서 도착 알림메일 사용에 체크합니다. </li>
		<li>결재문서 완료 알림메일을 받으려면 결재문서 완료 알림메일 사용에 체크합니다. </li>
		<li>결재문서 반송 알림메일을 받으려면 결재문서 반송 알림메일 사용에 체크합니다. </li>
		<li>결재문서 회수 알림메일을 받으려면 결재문서 회수 알림메일 사용에 체크합니다. </li>
		<li>결재문서 회송 알림메일을 받으려면 결재문서 회송 알림메일 사용에 체크합니다. </li>
		<li>알림메세지를 보낸편지함에 저장하지 않을경우 보낸편지함에 저장하지 않기에 체크합니다.</li>
		<li>설정을 마치면 <b>[확인]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/noticemail_set.png" alt="알림메일설정" title="알림메일설정" />
	
	<h2> 서명등록 </h2>
	<h3 class="sub_content"> 결재시 사용할 서명을 등록합니다. 등록된 서명은 50*50 사이즈로 보여지게 됩니다. </h3>
	<ol class="content">
		<li>우측 <b>/서명등록/</b> 탭을 클릭합니다. </li>
		<li><b>[추가]</b> 버튼을 클릭합니다. </li>
		<li>파일선택창에서 추가할 파일을 선택 후 <b>[열기]</b> 버튼을 클릭합니다. </li>
		<li>등록된 서명을 보려면 서명목록에서 서명을 선택합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/approval/sign_set.png" alt="서명등록" title="서명등록" />
	

    <!--내용끝 -->
</body>
</html>