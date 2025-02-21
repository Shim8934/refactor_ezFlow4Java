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
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>			
	</head>
	<body class="loginbody">
		<section id="sampleList" data-role="page">
			<!-- header import -->
     		<c:import url="/WEB-INF/jsp/mobile/sample/sampleTop.jsp" />
     		<!-- header import -->
     		
     		<!-- body start -->
			<div class="content" data-role="content">				
				<ul data-role="listview" data-inset="false" data-theme="a">
					<c:if test="${type == 'mailReceive' }">
					<li>				    					    	
				    	<a href="/mobile/sample/sampleDetail.do?type=mailRead">					    		
    						<h2 style="font-size:12px"><i class="fa fa-envelope" style="font-size:12px;"></i>&nbsp;&nbsp;장진혁</h2>
    						<p class="ui-li-aside">06:24</p>
				    		<p>오픈솔루션팀 차장 장진혁입니다.</p>
				    	</a>
				    </li>
				    <li>
				    	<a href="index.html">					    		
					    	<h2 style="font-size:12px"><i class="fa fa-envelope" style="font-size:12px;"></i>&nbsp;&nbsp;정지혜</h2>
					    	<p class="ui-li-aside">06:24</p>
					    	<p>전자정부 표준프레임워크 호환성 관련 메일입니다.</p>						    	
				    	</a>
				    </li>
				    <li>
				    	<a href="index.html">					    		
					    	<h2 style="font-size:12px"><i class="fa fa-envelope" style="font-size:12px;"></i>&nbsp;&nbsp;이종립/클라우드센터</h2>
					    	<p class="ui-li-aside">06:24</p>			    		
					    	<p>클라우드센터에서 메일보냅니다.</p>						    						    		
				    	</a>
				    </li>
				    <li>
				    	<a href="index.html">					    		
					    	<h2 style="font-size:12px"><i class="fa fa-envelope" style="font-size:12px;"></i>&nbsp;&nbsp;이동호</h2>
					    	<p class="ui-li-aside">06:24</p>					    		
					    	<p>회신: [애경그룹] 폼빌더 수정 진행 사항 확인 요청</p>						    						    		
				    	</a>
				    </li>
				    <li>
				    	<a href="index.html">					    		
					    	<h2 style="font-size:12px"><i class="fa fa-envelope-o" style="font-size:12px;"></i>&nbsp;&nbsp;이효민</h2>
					    	<p class="ui-li-aside">06:24</p>					    		
					    	<p>[알림] 영어연구회 영어회화 스크립트</p>						    						    		
				    	</a>
				    </li>
				    <li>
				    	<a href="index.html">					    		
					    	<h2 style="font-size:12px"><i class="fa fa-envelope-o" style="font-size:12px;"></i>&nbsp;&nbsp;홍용빈</h2>
					    	<p class="ui-li-aside">06:24</p>					    		
					    	<p>[공지] 악성코드 탐지내역 2017.06.10</p>						    						    		
				    	</a>
				    </li>
				    <li>
				    	<a href="index.html">					    		
					    	<h2 style="font-size:12px"><i class="fa fa-envelope-o" style="font-size:12px;"></i>&nbsp;&nbsp;박종균</h2>
					    	<p class="ui-li-aside">06:24</p>					    		
					    	<p>SQLMAP 관련 내용입니다.</p>						    						    		
				    	</a>
				    </li>
				    <li>
				    	<a href="index.html">					    		
					    	<h2 style="font-size:12px"><i class="fa fa-envelope-o" style="font-size:12px;"></i>&nbsp;&nbsp;김유진</h2>
					    	<p class="ui-li-aside">06:24</p>					    		
					    	<p>[Spring] context-dataSource.xml</p>						    						    		
				    	</a>
				    </li>
				    <li>
				    	<a href="index.html">					    		
					    	<h2 style="font-size:12px"><i class="fa fa-envelope-o" style="font-size:12px;"></i>&nbsp;&nbsp;테스트</h2>
					    	<p class="ui-li-aside">06:24</p>					    		
					    	<p>테스트 메일입니다.</p>						    						    		
				    	</a>
				    </li>
				    </c:if>
				    <c:if test="${type == 'mailSend' }">
				    <li>
				    	<a href="index.html">					    		
					    	<h2 style="font-size:12px"><i class="fa fa-paper-plane-o" style="font-size:12px;"></i>&nbsp;&nbsp;김유진</h2>
					    	<p class="ui-li-aside">06:24</p>					    		
					    	<p>[Spring] context-dataSource.xml</p>						    						    		
				    	</a>
				    </li>
				    <li>
				    	<a href="index.html">					    		
					    	<h2 style="font-size:12px"><i class="fa fa-paper-plane-o" style="font-size:12px;"></i>&nbsp;&nbsp;테스트</h2>
					    	<p class="ui-li-aside">06:24</p>					    		
					    	<p>테스트 메일입니다.</p>						    						    		
				    	</a>
				    </li>
				    </c:if>
				    <li style="background-color: transparent;text-align:center">
						P A G I N G
					</li>					
				</ul>
				<div class="writeButton" onclick="alert('write!')" style="display:none"></div>				
     		</div>     		
     		<!-- body end -->

     		<!-- footer import -->
     		<c:import url="/WEB-INF/jsp/mobile/sample/sampleFooter.jsp" />
     		<!-- footer import -->
     		
     		<!-- layer Popup import -->
     		<c:import url="/WEB-INF/jsp/mobile/sample/samplePopup.jsp" />
     		<!-- layer Popup import -->
     		
     		<div id="test" class="ui-content" style="min-width: 255px; max-width: 285px; text-align:center" data-role="popup" data-overlay-theme="b" data-transition="slidedown">
		    <a href="#" data-rel="back" data-role="button" data-theme="b" data-icon="delete" data-iconpos="notext" class="ui-btn-right">Close</a>
		    <div>		    	
				<input name="search-1" id="search-1" type="search" placeholder="search mail..">
				<a class="ui-btn" href="#">검 색</a>
			</div>			
		</div>
     	</section>
	</body>	
</html>