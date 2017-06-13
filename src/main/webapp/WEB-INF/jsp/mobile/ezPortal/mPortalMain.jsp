<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezEKP Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
		<link rel="stylesheet" type="text/css" href="/js/jquery.mobile/jquery.mobile-1.4.5.min.css" />
    	<link rel="stylesheet" type="text/css" href="/css/mobile/mobile.css" />
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery.mobile/jquery.mobile-1.4.5.min.js"></script>
		<script type="text/javascript" src="/js/mobile/mobile.js"></script>
		<script type="text/javascript" src="/js/mobile/mBoard.js"></script>
		<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
		<script type="text/javascript" src="/js/rsa/rsa.js"></script>
		<script type="text/javascript" src="/js/rsa/prng4.js"></script>
		<script type="text/javascript" src="/js/rsa/rng.js"></script>
	</head>
	<body class="loginbody">
		<section id="main" data-role="page">
			<!-- header import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezPortal/mPortalTop.jsp" />
     		<!-- header import -->
     		
     		<!-- body start -->
			<div class="content" data-role="content">
				<form id="mainForm" name="mainForm" method="post">					
					<div>
						<div data-role="collapsibleset" data-theme="a" data-inset="false">
						    <div data-role="collapsible" class="animateMe" style="background-image: url('/images/mobile/first.jpg');" data-iconpos="right">
						    	<h2>메일&nbsp;&nbsp;<img src="/images/mobile/new2.png"/></h2>
						        <ul data-role="listview" data-inset="true" >
						            <li><a href="/mobile/sample/sampleList.do?type=mailReceive"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;받은편지함 <span class="ui-li-count">12</span></a></li>
						            <li><a href="/mobile/sample/sampleList.do?type=mailSend"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;보낸편지함 <span class="ui-li-count">0</span></a></li>
						            <li><a href="index.html"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;임시보관함 <span class="ui-li-count">4</span></a></li>
						            <li><a href="index.html"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;지운편지함<span class="ui-li-count">328</span></a></li>
						            <li><a href="index.html"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;개인편지함 <span class="ui-li-count">62</span></a></li>
						        </ul>
						    </div>
						    <div data-role="collapsible" class="animateMe" style="background-image: url('/images/mobile/second.jpg')" data-iconpos="right">
						    	<h2>전자결재&nbsp;&nbsp;<img src="/images/mobile/new2.png"/></h2>
						        <ul data-role="listview" data-inset="true">
						            <li><a href="/mobile/ezApprovalG/doApproveList.do"><i class="fa fa-pencil" style="font-size:15px"></i>&nbsp;&nbsp;결재할문서 <span class="ui-li-count">12</span></a></li>
						            <li><a href="index.html"><i class="fa fa-pencil" style="font-size:15px"></i>&nbsp;&nbsp;결재진행문서 <span class="ui-li-count">0</span></a></li>
						            <li><a href="index.html"><i class="fa fa-pencil" style="font-size:15px"></i>&nbsp;&nbsp;결재한문서 <span class="ui-li-count">4</span></a></li>
						            <li><a href="index.html"><i class="fa fa-pencil" style="font-size:15px"></i>&nbsp;&nbsp;기안한문서 <span class="ui-li-count">328</span></a></li>
						            <li><a href="index.html"><i class="fa fa-pencil" style="font-size:15px"></i>&nbsp;&nbsp;부재자설정</a></li>
						        </ul>
						    </div>
						    <div data-role="collapsible" class="animateMe" style="background-image: url('/images/mobile/forth.jpg')" data-iconpos="right">
						    	<h2>일정관리</h2>
						        <ul data-role="listview" data-theme="a" data-divider-theme="b" data-inset="true">
						        	<li><a href="index.html"><i class="fa fa-calendar" style="font-size:15px"></i>&nbsp;&nbsp;일정보기</a></li>
						            <li data-role="list-divider">2017년 5월 30일 <span class="ui-li-count">2</span></li>
						            <li>
						            	<a href="index.html">
						                	<h3>장진혁</h3>
						                	<p><strong>디자인팀과 오후 미팅</strong></p>						                	
						                    <p class="ui-li-aside"><strong>15:00</strong></p>
						            	</a>
						            </li>
						            <li>
						            	<a href="index.html">
						                	<h3>강민석</h3>
						            		<p><strong>이메일 관련 세미나</strong></p>						            		
						                	<p class="ui-li-aside"><strong>10:30</strong></p>
						            	</a>
						            </li>						          					            
						        </ul>
						    </div>
						    <div data-role="collapsible" class="animateMe" style="background-image: url('/images/mobile/third.jpg')" data-iconpos="right">
						   		<h2>게시판&nbsp;&nbsp;<img src="/images/mobile/new2.png"/></h2>
						   		<div data-role="collapsibleset" data-theme="a" data-inset="true">	
							   		<div data-role="collapsible" class="animateMe1" style="" data-iconpos="right">
								   		<h2>공지사항</h2>
								        <ul data-role="listview" data-inset="true">
								            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;공지사항 <span class="ui-li-count">12</span></a></li>
								            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;노사협의회 회의록 <span class="ui-li-count">0</span></a></li>								            
								        </ul>	
								    </div>
								    <div data-role="collapsible" class="animateMe1" style="" data-iconpos="right">
								   		<h2>업무생활가이드</h2>
								        <ul data-role="listview" data-inset="true">
								            <li><a href="#" onclick="boardItemList(this)" boardID = "{6d7b50a2-4777-96a3-4b3a-a670dcd703f1}"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;규정 및 지침 <span class="ui-li-count">12</span></a></li>
								            <li><a href="#"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;비상연락망및내선번호 <span class="ui-li-count">0</span></a></li>
								            <li><a href="#"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;배포서식 <span class="ui-li-count">4</span></a></li>
								            <li><a href="#"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;회사제품매뉴얼및자료 <span class="ui-li-count">328</span></a></li>
								            <li><a href="#"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;공용장비 드라이버<span class="ui-li-count">62</span></a></li>
								            <li><a href="#"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;전사교육 교악<span class="ui-li-count">62</span></a></li>
								            <li><a href="#"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;세미나관련<span class="ui-li-count">62</span></a></li>
								        </ul>	
								    </div>
								    <div data-role="collapsible" class="animateMe1" style="" data-iconpos="right">
								   		<h2>유지보수현황</h2>
								        <ul data-role="listview" data-inset="true">
								            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;유지보수현황 <span class="ui-li-count">12</span></a></li>								            
								        </ul>	
								    </div>
								    <div data-role="collapsible" class="animateMe1" style="" data-iconpos="right">
								   		<h2>::패치모듈::</h2>
								        <ul data-role="listview" data-inset="true">
								            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;표준모듈 <span class="ui-li-count">12</span></a></li>
								            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;폼프로세서2016<span class="ui-li-count">12</span></a></li>
								            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;폼프로세서2015<span class="ui-li-count">12</span></a></li>
								            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;ezRendition<span class="ui-li-count">12</span></a></li>								            
								        </ul>	
								    </div>
								    <div data-role="collapsible" class="animateMe1" style="" data-iconpos="right">
								   		<h2>개선 및 버그게시판</h2>
								        <ul data-role="listview" data-inset="true">
								            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;속도개선 <span class="ui-li-count">12</span></a></li>
								            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;포탈<span class="ui-li-count">12</span></a></li>
								            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;메일<span class="ui-li-count">12</span></a></li>
								            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;PIMS<span class="ui-li-count">12</span></a></li>
								            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;게시판/설문<span class="ui-li-count">12</span></a></li>
								            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;전자결재<span class="ui-li-count">12</span></a></li>
								            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;Cop<span class="ui-li-count">12</span></a></li>
								            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;자원관리<span class="ui-li-count">12</span></a></li>
								            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;지식관리/문서관리<span class="ui-li-count">12</span></a></li>
								            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;기타<span class="ui-li-count">12</span></a></li>								            
								        </ul>	
								    </div>
								</div>
								 
						        <!-- <ul data-role="listview" data-inset="true">
						            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;마이게시판 <span class="ui-li-count">12</span></a></li>
						            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;공지사항 <span class="ui-li-count">0</span></a></li>
						            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;업무생활가이드 <span class="ui-li-count">4</span></a></li>
						            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;유지보수현황 <span class="ui-li-count">328</span></a></li>
						            <li><a href="index.html"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;포토게시판<span class="ui-li-count">62</span></a></li>
						        </ul> -->		
						    </div>						    
						    <div data-role="collapsible" class="animateMe" style="background-image: url('/images/mobile/fifth.jpg')" data-iconpos="right">
						    	<h2>자원관리</h2>
						        <ul data-role="listview" data-inset="true">
						            <li><a href="index.html"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;회의실<span class="ui-li-count">4</span></a></li>
						            <li><a href="index.html"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;빔프로젝터<span class="ui-li-count">4</span></a></li>
						            <li><a href="index.html"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;공용차량 <span class="ui-li-count">4</span></a></li>
						            <li><a href="index.html"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;모바일기기 <span class="ui-li-count">328</span></a></li>
						            <li><a href="index.html"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;콘도회원권<span class="ui-li-count">62</span></a></li>
						        </ul>
						    </div>
						    <div data-role="collapsible" class="animateMe" style="background-image: url('/images/mobile/fifth.jpg')" data-iconpos="right">
						    	<h2>직원조회</h2>
						        <ul data-role="listview" data-inset="true">
						            <li><a href="index.html">회의실<span class="ui-li-count">4</span></a></li>
						            <li><a href="index.html">빔프로젝터<span class="ui-li-count">4</span></a></li>
						            <li><a href="index.html">공용차량 <span class="ui-li-count">4</span></a></li>
						            <li><a href="index.html">모바일기기 <span class="ui-li-count">328</span></a></li>
						            <li><a href="index.html">콘도회원권<span class="ui-li-count">62</span></a></li>
						        </ul>
						    </div>						    						    					    
						</div>
					</div>
				</form>
     		</div>
     		<!-- body end -->
     		     		     		
     		<!-- footer import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezPortal/mPortalFooter.jsp" />
     		<!-- footer import -->     		     		
     	</section>	
	</body>	
</html>