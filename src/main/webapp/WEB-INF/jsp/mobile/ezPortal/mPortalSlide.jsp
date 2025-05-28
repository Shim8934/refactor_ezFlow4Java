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
		<script type="text/javascript" src="${util.addVer('/js/jquery.bxslider/jquery.bxslider.min.js')}"></script>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery.bxslider/jquery.bxslider.min.css')}" />
		<script>
			var slider;			
			
			$(document).ready(function(){		            
				slider = $('.bxslider').bxSlider({
				  	controls : false,
				  	adaptiveHeight : true,
				  	touchEnabled : false,
				  	
				  	onSlideAfter : function() {
				  		var now = slider.getCurrentSlide();
				  		
				  		if (now == 0) {
				  			$("#b1").css("color","rgb(31, 63, 105)");
			    			$("#b2").css("color","#999999");
			    			$("#b3").css("color","#999999");
			    			$("#b4").css("color","#999999");
				  		} else if (now == 1) {
				  			$("#b1").css("color","#999999");
			    			$("#b2").css("color","rgb(31, 63, 105)");
			    			$("#b3").css("color","#999999");
			    			$("#b4").css("color","#999999");
				  		} else if (now == 2) {
				  			$("#b1").css("color","#999999");
			    			$("#b2").css("color","#999999");
			    			$("#b3").css("color","rgb(31, 63, 105)");
			    			$("#b4").css("color","#999999");
				  		} else {
				  			$("#b1").css("color","#999999");
			    			$("#b2").css("color","#999999");
			    			$("#b3").css("color","#999999");
			    			$("#b4").css("color","rgb(31, 63, 105)");
				  		}
				  	}
			  	});
				
				$(".bxsliderLi").bind("swipeleft", function(){
					goTop();
					slider.goToNextSlide();
				});

		        $(".bxsliderLi").bind("swiperight", function(){
		        	goTop();
	            	slider.goToPrevSlide();
	            });				
			});

			function goTop() {				
				$('html, body').scrollTop(0);				
		
			}			
		</script>
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
			
			.ui-content {
				margin:-1em;		
			}
			
			.bx-wrapper {
				border : 0px;
				box-shadow : none;
				background-color: transparent;				
			}
			
			.ui-grid-a a {
				height : 24px;
				padding-top : 14px;
			}
			
			.ui-listview .ui-li-has-thumb > p:first-child, .ui-listview .ui-li-has-thumb > .ui-btn > p:first-child, .ui-listview .ui-li-has-thumb .ui-li-thumb {
				position : absolute;
				left:10px;
				top:10px;
				max-height:5em;
				max-width:5em;
			}
			
			.ui-listview > .ui-li-has-thumb > .ui-btn, .ui-listview > .ui-li-has-thumb.ui-li-static {
				padding-left : 4em;	
			}
		</style>
	</head>
	<body class="loginbody">
		<section id="mainSlide" data-role="page" class="loginbody">
			<!-- header import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezPortal/mPortalTop.jsp" />
     		<!-- header import --> 		
     		
     		<!-- body start -->
			<div class="content" data-role="content">
				<div class="ui-navbar" role="navigation" data-role="navbar">
					<ul class="ui-grid-a">
						<!-- <li class="ui-block-a"><a class="ui-btn" href="page-b.html" style="background-color: white;border:0px"><i id="b1" class="fa fa-thumbs-up" style="font-size:24px;color:red"></i></a></li>					
						<li class="ui-block-b"><a class="ui-btn" href="javascript:goMail();" style="background-color: white;border:0px"><i id="b2" class="fa fa-envelope-o" style="font-size:24px"></i></a></li>					
						<li class="ui-block-c"><a class="ui-btn" href="page-c.html" style="background-color: white;border:0px"><i id="b3" class="fa fa-calendar" style="font-size:24px"></i></a></li>
						<li class="ui-block-d"><a class="ui-btn" href="page-d.html" style="background-color: white;border:0px"><i id="b4" class="fa fa-file-text-o" style="font-size:24px"></i></a></li> -->
						<li class="ui-block-a"><a class="ui-btn" href="page-b.html" style="background-color: #e5e5e5;border:0px;color:rgb(31, 63, 105);"><span id="b1">결재할문서</span></a></li>					
						<li class="ui-block-b"><a class="ui-btn" href="javascript:goMail();" style="background-color:#e5e5e5;border:0px;color:#999999"><span id="b2">받은편지함</span></a></li>					
						<li class="ui-block-c"><a class="ui-btn" href="page-c.html" style="background-color: #e5e5e5;border:0px;color:#999999"><span id="b3">오늘의일정</span></a></li>
						<li class="ui-block-d"><a class="ui-btn" href="page-d.html" style="background-color: #e5e5e5;border:0px;color:#999999"><span id="b4">새게시물</span></a></li>
					</ul>
				</div>				
				<ul class="bxslider" style="">
					<li class="bxsliderLi">																
						<ul class="listview" data-role="listview" data-theme="a" data-divider-theme="a" data-inset="false" style="margin:0px">						        	
				            <li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-pencil-square-o" style="font-size:42px"></i></p>
								    <h2>2017년 6월 9일 장진혁 휴가원입니다.휴가예요</h2>
								    <p>장진혁&nbsp;&nbsp;11:30</p>
								</a>
							</li>
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-pencil-square-o" style="font-size:42px"></i></p>
								    <h2>2017년 6월 9일 김길동 휴가원</h2>
								    <p>김길동&nbsp;&nbsp;10:20</p>
								</a>
							</li>
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-pencil-square-o" style="font-size:42px"></i></p>
								    <h2>지출결의서 상신합니다.</h2>
								    <p>이효민&nbsp;&nbsp;10:00</p>
								</a>
							</li>
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-pencil-square-o" style="font-size:42px"></i></p>
								    <h2>기안문 상신합니다.</h2>
								    <p>장진혁&nbsp;&nbsp;09:30</p>
								</a>
							</li>										            
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-pencil-square-o" style="font-size:42px"></i></p>
								    <h2>2017년 6월 출장신청서</h2>
								    <p>이동호&nbsp;&nbsp;09:00</p>
								</a>
							</li>										            
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-pencil-square-o" style="font-size:42px"></i></p>
								    <h2>인력충원요청서 상신합니다.</h2>
								    <p>테스트&nbsp;&nbsp;08:30</p>
								</a>
							</li>										            
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-pencil-square-o" style="font-size:42px"></i></p>
								    <h2>기안문 상신합니다.</h2>
								    <p>장진혁&nbsp;&nbsp;06-22</p>
								</a>
							</li>										            
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-pencil-square-o" style="font-size:42px"></i></p>
								    <h2>기안문 상신합니다.</h2>
								    <p>박정진&nbsp;&nbsp;06-22</p>
								</a>
							</li>										            
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-pencil-square-o" style="font-size:42px"></i></p>
								    <h2>기안문 상신합니다.</h2>
								    <p>장진혁&nbsp;&nbsp;06-22</p>
								</a>
							</li>				            
				            <li data-icon="false">
				            	<a href="javascript:goTop()" style="text-align:center">
				            		<i class="fa fa-caret-down " style="font-size:15px"></i>
				            	</a>
				            </li>				            			           					            						          					            
				        </ul>
					</li>
					<li class="bxsliderLi">
						<ul class="listview" data-role="listview" data-theme="a" data-divider-theme="a" data-inset="true" style="margin:0px">															        	
				            <li class="ui-li-has-thumb">
				            	<a href="/mobile/sample/sampleDetail.do?type=mailRead">
							        <p><i class="fa fa-envelope" style="font-size:38px"></i></p>
								    <h2>오픈솔루션팀 차장 장진혁입니다.</h2>
								    <p>장진혁&nbsp;&nbsp;11:30</p>
								</a>
							</li>
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-envelope" style="font-size:38px"></i></p>
								    <h2>안녕하십니까? 개발팀에 새로 입사한 박창현입니다.</h2>
								    <p>박창현&nbsp;&nbsp;10:30</p>
								</a>
							</li>
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-envelope" style="font-size:38px"></i></p>
								    <h2>Maven 공부내용 정리입니다.</h2>
								    <p>김유진&nbsp;&nbsp;09:30</p>
								</a>
							</li>
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-envelope" style="font-size:38px"></i></p>
								    <h2>[알림]회신: [영어연구회] 다음 기사</h2>
								    <p>황윤진&nbsp;&nbsp;06-22</p>
								</a>
							</li>
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-envelope" style="font-size:38px"></i></p>
								    <h2>6월 13일자 인사/동정/부음</h2>
								    <p>장진혁&nbsp;&nbsp;06-22</p>
								</a>
							</li>
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-envelope" style="font-size:38px"></i></p>
								    <h2>[공지] 백업CS제출 안내</h2>
								    <p>장진혁</p>
								</a>
							</li>				            						            
				            <li data-icon="false">
				            	<a href="/mobile/sample/sampleList.do?type=mailReceive" style="text-align:center">
				            		<i class="fa fa-caret-down " style="font-size:15px"></i>
				            	</a>
				            </li>							            			            			           					            						          					            
				        </ul>
					</li>
					<li class="bxsliderLi">
						<ul class="listview" data-role="listview" data-theme="a" data-divider-theme="a" data-inset="true" style="margin:0px">															        	
				           	<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-calendar-check-o" style="font-size:38px"></i></p>
								    <h2>오픈솔루션 개발 세미나</h2>
								    <p>15:30 ~ 16:30</p>
								</a>
							</li>
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-calendar-check-o" style="font-size:38px"></i></p>
								    <h2>디자인팀과 오후 미팅</h2>
								    <p>09:30 ~ 11:00</p>
								</a>
							</li>
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-calendar-check-o" style="font-size:38px"></i></p>
								    <h2>6월 13일자 인사/동정/부음</h2>
								    <p>09:00 ~ 09:30</p>
								</a>
							</li>										            
				            <li data-icon="false">
				            	<a href="/mobile/sample/sampleList.do?type=mailReceive" style="text-align:center">
				            		<i class="fa fa-caret-down " style="font-size:15px"></i>
				            	</a>
				            </li>							            			            			           					            						          					            
				        </ul>
					</li>
					<li class="bxsliderLi">
						<ul class="listview" data-role="listview" data-theme="a" data-divider-theme="a" data-inset="true" style="margin:0px">															        	
				            <li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-book" style="font-size:38px"></i></p>
								    <h2>[공지] 6월 월례보고 자료</h2>
								    <p>장진혁&nbsp;&nbsp;12:30</p>
								</a>
							</li>
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-book" style="font-size:38px"></i></p>
								    <h2>[공지] 연차 발생 조견표</h2>
								    <p>장진혁&nbsp;&nbsp;11:20</p>
								</a>
							</li>
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-book" style="font-size:38px"></i></p>
								    <h2>2017년 적용 최저임금 고시</h2>
								    <p>장진혁&nbsp;&nbsp;10:00</p>
								</a>
							</li>
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-book" style="font-size:38px"></i></p>
								    <h2>[안내] 건강보험 피부양자 등록사항 조회 및 등록 방법</h2>
								    <p>장진혁&nbsp;&nbsp;09:30</p>
								</a>
							</li>
							<li class="ui-li-has-thumb">
				            	<a href="#">
							        <p><i class="fa fa-book" style="font-size:38px"></i></p>
								    <h2>부서(팀) 단위 월간 회식지침</h2>
								    <p>장진혁&nbsp;&nbsp;09:00</p>
								</a>
							</li>							
				            <li data-icon="false">
				            	<a href="/mobile/sample/sampleList.do?type=mailReceive" style="text-align:center">
				            		<i class="fa fa-caret-down " style="font-size:15px"></i>
				            	</a>
				            </li>							            			            			           					            						          					            
				        </ul>
					</li>								
				</ul>
     		</div>
     		<!-- body end -->
     		     		     		
     		<!-- footer import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezPortal/mPortalFooter.jsp" />
     		<!-- footer import -->     		     		
     	</section>	
	</body>	
</html>