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
		<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
		<script type="text/javascript" src="/js/rsa/rsa.js"></script>
		<script type="text/javascript" src="/js/rsa/prng4.js"></script>
		<script type="text/javascript" src="/js/rsa/rng.js"></script>			
	</head>
	<body class="loginbody">
		<section id="sampleList" data-role="page">
			<!-- header import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezPortal/mPortalTop.jsp" />
     		<!-- header import -->
     		
     		<!-- body start -->
			<div class="content" data-role="content">				
				<ul data-role="listview" data-inset="false" data-theme="a">
					<c:if test="${type == 'mailReceive'}">
						<li style="background-color: transparent;">
							<i class="fa fa-check-square-o" style="font-size:24px;cursor: pointer;" onclick="javascript:checkAll();"></i>
							<i class="fa fa-pencil-square-o" style="font-size:24px;cursor: pointer;margin-left:20px"></i>
							<i class="fa fa-trash" style="font-size:24px;cursor: pointer;margin-left:20px"></i>
							<i class="fa fa-arrows" style="font-size:24px;cursor: pointer;margin-left:20px" onclick="javascript:moveMail();"></i>
							<i class="fa fa-search" style="font-size:24px;cursor: pointer;margin-left:20px" onclick="javascript:searchMail();"></i>
						</li>						
					    <li>				    					    	
					    	<a href="/mobile/ezPortal/sampleDetail.do?type=mailRead">
					    		<input name="checkbox" id="checkbox-0" type="checkbox">
	    						<label for="checkbox-0">
	    							<h2 style="font-size:12px">장진혁</h2>
	    							<p class="ui-li-aside">06:24</p>				    		
					    			<p>안녕하세요. 오픈솔루션팀 장진혁 차장입니다.</p>
	    						</label>				    						    						    						        	
					    	</a>
					    </li>
					    <li>
					    	<a href="index.html">
					    		<input name="checkbox" id="checkbox-1" type="checkbox">
	    						<label for="checkbox-1">
						    		<h2 style="font-size:12px">정지혜</h2>
						    		<p class="ui-li-aside">06:24</p>
						    		<p>전자정부 표준프레임워크 호환성 관련 메일입니다.</p>
						    	</label>
					    	</a>
					    </li>
					    <li>
					    	<a href="index.html">
					    		<input name="checkbox" id="checkbox-2" type="checkbox">
	    						<label for="checkbox-2">
						    		<h2 style="font-size:12px">이종립/클라우드센터</h2>
						    		<p class="ui-li-aside">06:24</p>			    		
						    		<p>클라우드센터에서 메일보냅니다.</p>
						    	</label>					    		
					    	</a>
					    </li>
					    <li>
					    	<a href="index.html">
					    		<input name="checkbox" id="checkbox-3" type="checkbox">
	    						<label for="checkbox-3">
						    		<h2 style="font-size:12px">테스트</h2>
						    		<p class="ui-li-aside">06:24</p>					    		
						    		<p>테스트 메일입니다.</p>
						    	</label>					    		
					    	</a>
					    </li>				   
					    <li style="background-color: transparent;text-align:center">
							P A G I N G
						</li>
					</c:if>
					<c:if test="${type == 'mailSend'}">
						<li>				    					    	
					    	<a href="/mobile/ezPortal/sampleDetail.do?type=mailRead">					    		
	    						<h2 style="font-size:12px">장진혁</h2>
	    						<p class="ui-li-aside">06:24</p>				    		
					    		<p>안녕하세요. 오픈솔루션팀 장진혁 차장입니다.</p>	    										    						    						    						        	
					    	</a>
					    </li>
					    <li>
					    	<a href="index.html">					    		
						    	<h2 style="font-size:12px">정지혜</h2>
						    	<p class="ui-li-aside">06:24</p>
						    	<p>전자정부 표준프레임워크 호환성 관련 메일입니다.</p>						    	
					    	</a>
					    </li>
					    <li>
					    	<a href="index.html">					    		
						    	<h2 style="font-size:12px">이종립/클라우드센터</h2>
						    	<p class="ui-li-aside">06:24</p>			    		
						    	<p>클라우드센터에서 메일보냅니다.</p>						    						    		
					    	</a>
					    </li>
					    <li>
					    	<a href="index.html">					    		
						    	<h2 style="font-size:12px">테스트</h2>
						    	<p class="ui-li-aside">06:24</p>					    		
						    	<p>테스트 메일입니다.</p>						    						    		
					    	</a>
					    </li>
					    <li>
					    	<a href="index.html">					    		
						    	<h2 style="font-size:12px">테스트</h2>
						    	<p class="ui-li-aside">06:24</p>					    		
						    	<p>테스트 메일입니다.</p>						    						    		
					    	</a>
					    </li>
					    <li>
					    	<a href="index.html">					    		
						    	<h2 style="font-size:12px">테스트</h2>
						    	<p class="ui-li-aside">06:24</p>					    		
						    	<p>테스트 메일입니다.</p>						    						    		
					    	</a>
					    </li>
					    <li>
					    	<a href="index.html">					    		
						    	<h2 style="font-size:12px">테스트</h2>
						    	<p class="ui-li-aside">06:24</p>					    		
						    	<p>테스트 메일입니다.</p>						    						    		
					    	</a>
					    </li>
					    <li>
					    	<a href="index.html">					    		
						    	<h2 style="font-size:12px">테스트</h2>
						    	<p class="ui-li-aside">06:24</p>					    		
						    	<p>테스트 메일입니다.</p>						    						    		
					    	</a>
					    </li>
					    <li>
					    	<a href="index.html">					    		
						    	<h2 style="font-size:12px">테스트</h2>
						    	<p class="ui-li-aside">06:24</p>					    		
						    	<p>테스트 메일입니다.</p>						    						    		
					    	</a>
					    </li>				   
					    <li style="background-color: transparent;text-align:center">
							P A G I N G
						</li>
					</c:if>
				</ul>				
     		</div>     		
     		<!-- body end -->

     		<!-- footer import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezPortal/mPortalFooter.jsp" />
     		<!-- footer import -->
     		
     		<!-- layer Popup import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezPortal/samplePopup.jsp" />
     		<!-- layer Popup import -->
     	</section>
	</body>	
</html>