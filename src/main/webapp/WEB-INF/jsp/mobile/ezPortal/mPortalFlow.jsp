<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezFlow Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width"/>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery.mobile/jquery.mobile-1.4.5.min.css')}" />		
    	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mobile/mobile.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery.mobile/jquery.mobile-1.4.5.min.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/mobile/mobile.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mobile/mBoard.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mobile/mEMail.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		<style>
			.ui-li-divider {
				background-color: transparent;
				color: rgb(31, 63, 105);
				border-color: rgb(220, 220, 220);				
			}
			.ui-grid-a .ui-block-a input {
				height:40px;
			}
			.ui-grid-a .ui-block-b .ui-icon-search {
				height:40px;
				width:100%;
				-webkit-border-radius: .3125em;
    			border-radius: .3125em;
			}
		</style>
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
						<!-- <div class="ui-navbar" role="navigation" data-role="navbar">
							<ul class="ui-grid-a">								
								<li class="ui-block-a"><a class="ui-btn" href="javascript:goMail();"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;<span style="font-size:15px">자원관리</span></a></li>
								<li class="ui-block-b"><a class="ui-btn" href="javascript:goMail();"><i class="fa fa-users" style="font-size:15px"></i>&nbsp;&nbsp;<span style="font-size:15px">직원목록</span></a></li>																			
							</ul>
						</div>	 -->											
						<ul data-role="listview" data-theme="a" data-divider-theme="a" data-inset="false">						        	
				            <li data-role="list-divider" style="background-image: url('/images/mobile/second.jpg')">결재할문서 <span class="ui-li-count">6</span></li>
				            <li>
				            	<a href="index.html">
				            		<i class="fa fa-pencil-square-o" style="font-size:15px"></i>&nbsp;&nbsp;2017년 6월 9일 장진혁 휴가원
				            	</a>
				            </li>
				            <li>
				            	<a href="index.html">
				            		<i class="fa fa-pencil-square-o" style="font-size:15px"></i>&nbsp;&nbsp;2017년 6월 9일 김길동 휴가원
				            	</a>
				            </li>
				            <li>
				            	<a href="index.html">
				            		<i class="fa fa-pencil-square-o" style="font-size:15px"></i>&nbsp;&nbsp;지출결의서 상신합니다.
				            	</a>
				            </li>
				            <li>
				            	<a href="index.html">
				            		<i class="fa fa-pencil-square-o" style="font-size:15px"></i>&nbsp;&nbsp;기안문 상신합니다.
				            	</a>
				            </li>
				            <li>
				            	<a href="index.html">
				            		<i class="fa fa-pencil-square-o" style="font-size:15px"></i>&nbsp;&nbsp;2017년 6월 출장신청서
				            	</a>
				            </li>
				            <li>
				            	<a href="index.html">
				            		<i class="fa fa-pencil-square-o" style="font-size:15px"></i>&nbsp;&nbsp;인력충원요청서 상신합니다.
				            	</a>
				            </li>
				            <li data-icon="false">
				            	<a href="/mobile/sample/sampleList.do?type=mailReceive" style="text-align:center">
				            		<i class="fa fa-caret-down " style="font-size:15px"></i>
				            	</a>
				            </li>
				            <li data-role="list-divider" style="background-image: url('/images/mobile/first.jpg');">받은편지함 <span class="ui-li-count">6</span></li>
				            <li>
				            	<a href="/mobile/sample/sampleDetail.do?type=mailRead">
				            		<i class="fa fa-envelope" style="font-size:15px"></i>&nbsp;&nbsp;오픈솔루션팀 차장 장진혁입니다.
				            	</a>
				            </li>
				            <li>
				            	<a href="index.html">
				            		<i class="fa fa-envelope" style="font-size:15px"></i>&nbsp;&nbsp;안녕하십니까? 개발팀에 새로 입사한 박창현입니다.
				            	</a>
				            </li>
				            <li>
				            	<a href="index.html">
				            		<i class="fa fa-envelope" style="font-size:15px"></i>&nbsp;&nbsp;Maven 공부내용 정리입니다.
				            	</a>
				            </li>
				            <li>
				            	<a href="index.html">
				            		<i class="fa fa-envelope" style="font-size:15px"></i>&nbsp;&nbsp;[알림]회신: [영어연구회] 다음 기사
				            	</a>
				            </li>
				            <li>
				            	<a href="index.html">
				            		<i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;6월 13일자 인사/동정/부음
				            	</a>
				            </li>
				            <li>
				            	<a href="index.html">
				            		<i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;[공지] 백업CS제출 안내
				            	</a>
				            </li>
				            <li data-icon="false">
				            	<a href="/mobile/sample/sampleList.do?type=mailReceive" style="text-align:center">
				            		<i class="fa fa-caret-down " style="font-size:15px"></i>
				            	</a>
				            </li>
				            <li data-role="list-divider" style="background-image: url('/images/mobile/forth.jpg')">오늘의일정 <span class="ui-li-count">2</span></li>
				            <li>						            	
				            	<a href="index.html">
				            		<i class="fa fa-calendar-check-o" style="font-size:15px"></i>
				                	오픈솔루션 개발 세미나<br/>
				                	<span style="font-weight: normal;margin-left:20px;margin-top:3px">15:30 ~ 16:30</span>						                    
				            	</a>
				            </li>
				            <li>
				            	<a href="index.html">
				            		<i class="fa fa-calendar-check-o" style="font-size:15px"></i>
				                	디자인팀과 오후 미팅<br/>
				                	<span style="font-weight: normal;margin-left:20px;margin-top:3px">09:30 ~ 11:00</span>
				            	</a>
				            </li>
				            <li data-icon="false">
				            	<a href="/mobile/sample/sampleList.do?type=mailReceive" style="text-align:center">
				            		<i class="fa fa-caret-down " style="font-size:15px"></i>
				            	</a>
				            </li>
				            <li data-role="list-divider" style="background-image: url('/images/mobile/third.jpg')">새게시물<span class="ui-li-count">5</span></li>
				            <li>
				            	<a href="index.html">
				            		<i class="fa fa-book " style="font-size:15px"></i>&nbsp;&nbsp;[공지] 6월 월례보고 자료
				            	</a>
				            </li>
				            <li>
				            	<a href="index.html">
				            		<i class="fa fa-book " style="font-size:15px"></i>&nbsp;&nbsp;[공지] 연차 발생 조견표
				            	</a>
				            </li>
				            <li>
				            	<a href="index.html">
				            		<i class="fa fa-book " style="font-size:15px"></i>&nbsp;&nbsp;2017년 적용 최저임금 고시
				            	</a>
				            </li>
				            <li>
				            	<a href="index.html">
				            		<i class="fa fa-book " style="font-size:15px"></i>&nbsp;&nbsp;[안내] 건강보험 피부양자 등록사항 조회 및 등록 방법
				            	</a>
				            </li>
				            <li>
				            	<a href="index.html">
				            		<i class="fa fa-book " style="font-size:15px"></i>&nbsp;&nbsp;부서(팀) 단위 월간 회식지침
				            	</a>
				            </li>
				            <li data-icon="false">
				            	<a href="/mobile/sample/sampleList.do?type=mailReceive" style="text-align:center">
				            		<i class="fa fa-caret-down " style="font-size:15px"></i>
				            	</a>
				            </li>				           					            						          					            
				        </ul>
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