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
    <h3 class="contents_title">게시판환경설정</h3>
	<h4 class="sub_title"> 포탈, 유틸메뉴에서 환경설정 아이콘 클릭 후 좌측 <b>게시판환경설정</b> 매뉴를 클릭합니다. </h4>

    <!--내용시작 -->
    <h2> 기본환경설정 </h2>
	<ol class="content">
		<li>우측 <b>/게시판/</b> 탭을 클릭합니다. </li>
		<li>미리보기위치의 사이즈를 조정하려면, 리스트영역, 미리보기영역의 사이즈를 선택합니다. </li>
		<li>설정을 마치면 <b>[저장]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/board_set.png" alt="기본환경설정" title="기본환경설정" />
	
	<h2> 즐겨찾기 </h2>
	<ol class="content">
		<li>우측 <b>/즐겨찾기/</b> 탭을 클릭합니다. </li>
		<li>즐겨찾기 목록에서 순서조정할 탭을 선택 후 위로, 아래로 버튼을 클릭하여 순서를 조정합니다. </li>
		<li>즐겨찾기 목록에서 삭제할 탭을 선택 후 상단 <b>[삭제]</b> 버튼을 클릭합니다. </li>
	</ol>
	<img src="../../images/ezNewPortal/help/board/bookmark.png" alt="즐겨찾기" title="즐겨찾기" />
	

    <!--내용끝 -->
</body>
</html>