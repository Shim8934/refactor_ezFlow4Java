<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezFlow Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />		
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
				background-color: white;				
				color: rgb(31, 63, 105);
				border-color: rgb(220, 220, 220);				
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
						<div data-role="collapsibleset" data-theme="a" data-inset="false">						    
						    <div data-role="collapsible" class="animateMe" style="background-image: url('/images/mobile/second.jpg')" data-iconpos="right">
						    	<h2>전자결재<span class="ui-li-count" style="margin-right:30px;background-color: white">6</span></h2>
						        <!-- <ul data-role="listview" data-inset="true">
						            <li><a href="/mobile/ezApprovalG/doApproveList.do"><i class="fa fa-pencil" style="font-size:15px"></i>&nbsp;&nbsp;결재할문서 <span class="ui-li-count">12</span></a></li>
						            <li><a href="index.html"><i class="fa fa-pencil" style="font-size:15px"></i>&nbsp;&nbsp;결재진행문서 <span class="ui-li-count">0</span></a></li>
						            <li><a href="index.html"><i class="fa fa-pencil" style="font-size:15px"></i>&nbsp;&nbsp;결재한문서 <span class="ui-li-count">4</span></a></li>
						            <li><a href="index.html"><i class="fa fa-pencil" style="font-size:15px"></i>&nbsp;&nbsp;기안한문서 <span class="ui-li-count">328</span></a></li>
						            <li><a href="index.html"><i class="fa fa-pencil" style="font-size:15px"></i>&nbsp;&nbsp;부재자설정</a></li>
						        </ul> -->
						        <ul data-role="listview" data-theme="a" data-divider-theme="a" data-inset="true">						        	
						            <li data-role="list-divider">결재할문서</li>
						            <li>
						            	<a href="index.html">
						            		<i class="fa fa-pencil-square-o" style="font-size:15px"></i>&nbsp;&nbsp;2017년 6월 9일 장진혁 휴가원입니다.휴가예요2017년 6월 9일 장진혁 휴가원입니다.휴가예요2017년 6월 9일 장진혁 휴가원입니다.휴가예요
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
						            	<a href="/mobile/ezApprovalG/mApproveList.do" style="text-align:center">
						            		<i class="fa fa-caret-down " style="font-size:15px"></i>
						            	</a>
						            </li>						            						          					            
						        </ul>
						    </div>
						    <div data-role="collapsible" class="animateMe" style="background-image: url('/images/mobile/first.jpg');" data-iconpos="right">
						    	<h2>메일<span class="ui-li-count" style="margin-right:30px;background-color: white">9</span></h2>
						        <ul data-role="listview" data-theme="a" data-divider-theme="a" data-inset="true">						        	
						            <li data-role="list-divider">받은편지함</li>
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
						            <li>
						            	<a href="index.html">
						            		<i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;[공지] 악성코드 탐지내역 2017.06.14
						            	</a>
						            </li>
						            <li>
						            	<a href="index.html">
						            		<i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;개발 및 프로젝트 시 소스 형상관리 툴 사용 건
						            	</a>
						            </li>
						            <li>
						            	<a href="index.html">
						            		<i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;[FYI] 유니코드의 UCS와 UTF
						            	</a>
						            </li>
						            <li data-icon="false">
						            	<a href="/mobile/sample/sampleList.do?type=mailReceive" style="text-align:center">
						            		<i class="fa fa-caret-down " style="font-size:15px"></i>
						            	</a>
						            </li>						            						          					            
						        </ul>
						    </div>
						    <div data-role="collapsible" class="animateMe" style="background-image: url('/images/mobile/forth.jpg')" data-iconpos="right">
						    	<h2>일정관리<span class="ui-li-count" style="margin-right:30px;background-color: white">2</span></h2>
						        <ul data-role="listview" data-theme="a" data-divider-theme="a" data-inset="true">						        	
						            <li data-role="list-divider">오늘의일정 </li>
						            <li>						            	
						            	<a href="/mobile/ezSchedule/testList.do">
						            		<i class="fa fa-calendar-check-o" style="font-size:15px"></i>
						                	오픈솔루션 개발 세미나<br/>
						                	<span style="font-weight: normal;margin-left:20px;margin-top:3px">15:30 ~ 16:30</span>						                    
						            	</a>
						            </li>
						            <li>
						            	<a href="javascript:mScheduleInsert();">
						            		<i class="fa fa-calendar-check-o" style="font-size:15px"></i>
						                	스케쥴 등록<br/>
						                	<span style="font-weight: normal;margin-left:20px;margin-top:3px">09:30 ~ 11:00</span>
						            	</a>
						            </li>
						            <li>
						            	<a href="javascript:mScheduleDetail();">
						            		<i class="fa fa-calendar-check-o" style="font-size:15px"></i>
						                	스케쥴 상세<br/>
						                	<span style="font-weight: normal;margin-left:20px;margin-top:3px">09:30 ~ 11:00</span>
						            	</a>
						            </li>
						            <li>
						            	<a href="javascript:mScheduleUpdate();">
						            		<i class="fa fa-calendar-check-o" style="font-size:15px"></i>
						                	스케쥴 수정<br/>
						                	<span style="font-weight: normal;margin-left:20px;margin-top:3px">09:30 ~ 11:00</span>
						            	</a>
						            </li>
						            <li>
						            	<a href="javascript:mScheduleDelete();">
						            		<i class="fa fa-calendar-check-o" style="font-size:15px"></i>
						                	스케쥴 삭제<br/>
						                	<span style="font-weight: normal;margin-left:20px;margin-top:3px">09:30 ~ 11:00</span>
						            	</a>
						            </li>
						            <li>
						            	<a href="javascript:mScheduleInsertForm();">
						            		<i class="fa fa-calendar-check-o" style="font-size:15px"></i>
						                	스케쥴 등록화면<br/>
						                	<span style="font-weight: normal;margin-left:20px;margin-top:3px">09:30 ~ 11:00</span>
						            	</a>
						            </li>
						            <li data-icon="false">
						            	<a href="javascript:mScheduleList();" style="text-align:center">
						            		<i class="fa fa-caret-down " style="font-size:15px"></i>
						            	</a>
						            </li>						          					            
						        </ul>
						    </div>
						    <div data-role="collapsible" class="animateMe" style="background-image: url('/images/mobile/third.jpg')" data-iconpos="right">
						   		<h2>게시판<span class="ui-li-count" style="margin-right:30px;background-color: white">5</span></h2>
						   		<ul data-role="listview" data-theme="a" data-divider-theme="a" data-inset="true">						        	
						            <li data-role="list-divider">새게시물</li>
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
						            	<a href="#" onclick="boardItemList(this)" type = "favoriteBoardItemList" boardID = "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}" style="text-align:center">
						            		<i class="fa fa-caret-down " style="font-size:15px"></i>
						            	</a>
						            </li>						            						          					            
						        </ul>		
						    </div>						    
						    <div data-role="collapsible" class="animateMe" style="background-image: url('/images/mobile/third.jpg')" data-iconpos="right">
						   		<h2>자원관리</h2>
						   		<div data-role="collapsibleset" data-theme="a" data-inset="true">
							   		<div data-role="collapsible" class="animateMe1" style="" data-iconpos="right">
								   		<h2>회의실</h2>
								        <ul data-role="listview" data-inset="true">
								            <li><a href="/mobile/sample/sampleResourceList.do"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;3층 소회의실</a></li>
								            <li><a href="index.html"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;3층 대회의실</a></li>
								            <li><a href="index.html"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;5층 소회의실</a></li>
								            <li><a href="index.html"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;5층 대회의실</a></li>
								        </ul>	
								    </div>
								    <div data-role="collapsible" class="animateMe1" style="" data-iconpos="right">
								   		<h2>빔프로젝터</h2>
								        <ul data-role="listview" data-inset="true">
								            <li><a href="index.html"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;빔프로젝트1 (경지실보관)</a></li>
								            <li><a href="index.html"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;빔프로젝트2 (3층회의실)</a></li>
								        </ul>	
								    </div>
								    <div data-role="collapsible" class="animateMe1" style="" data-iconpos="right">
								   		<h2>공용차량</h2>
								        <ul data-role="listview" data-inset="true">
								            <li><a href="index.html"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;58하3101 아반테</a></li>								            
								        </ul>	
								    </div>
								    <div data-role="collapsible" class="animateMe1" style="" data-iconpos="right">
								   		<h2>모바일기기</h2>
								        <ul data-role="listview" data-inset="true">
								            <li><a href="index.html"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;에그1번 (CP041)</a></li>
								            <li><a href="index.html"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;에그2번 (CP048)</a></li>
								            <li><a href="index.html"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;에그3번 (CP050)</a></li>								            
								        </ul>	
								    </div>
								    <div data-role="collapsible" class="animateMe1" style="" data-iconpos="right">
								   		<h2>콘도회원권</h2>
								        <ul data-role="listview" data-inset="true">
								            <li><a href="index.html"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;067477</a></li>
								            <li><a href="index.html"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;067478</a></li>
								            <li><a href="index.html"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;067479</a></li>
								            <li><a href="index.html"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;067480</a></li>							            
								        </ul>	
								    </div>
								</div>										
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