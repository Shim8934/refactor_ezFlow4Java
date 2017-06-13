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
		
		<script type="text/javascript">
			$(document).ready(function () {
				getBoardItemList();
			})
		</script>			
	</head>
	<body class="loginbody">
		<div id="boardList" data-role="page">
			<!-- header import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezBoard/mBoardTop.jsp" />
     		<!-- header import -->
     		
     		<!-- body start -->
			<div class="ui-content" data-role="content">				
				<ul data-role="listview" data-inset="false" data-theme="a">
				    <li>
				    	<a href="/mobile/sample/sampleDetail.do?type=mailRead">
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
				    <li>				    					    	
				    	<a href="/mobile/sample/sampleDetail.do?type=mailRead">
				    		<input name="checkbox" id="checkbox-4" type="checkbox">
    						<label for="checkbox-4">
    							<h2 style="font-size:12px">장진혁</h2>
    							<p class="ui-li-aside">06:24</p>
				    			<p>안녕하세요. 오픈솔루션팀 장진혁 차장입니다.</p>
    						</label>				    						    						    						        	
				    	</a>
				    </li>
				    <li>
				    	<a href="index.html">
				    		<input name="checkbox" id="checkbox-5" type="checkbox">
    						<label for="checkbox-5">
					    		<h2 style="font-size:12px">정지혜</h2>
					    		<p class="ui-li-aside">06:24</p>
					    		<p>전자정부 표준프레임워크 호환성 관련 메일입니다.</p>
					    	</label>
				    	</a>
				    </li>
				    <li>
				    	<a href="index.html">
				    		<input name="checkbox" id="checkbox-6" type="checkbox">
    						<label for="checkbox-6">
					    		<h2 style="font-size:12px">이종립/클라우드센터</h2>
					    		<p class="ui-li-aside">06:24</p>
					    		<p>클라우드센터에서 메일보냅니다.</p>
					    	</label>					    		
				    	</a>
				    </li>
				    <li>
				    	<a href="index.html">
				    		<input name="checkbox" id="checkbox-7" type="checkbox">
    						<label for="checkbox-7">
					    		<h2 style="font-size:12px">테스트</h2>
					    		<p class="ui-li-aside">06:24</p>
					    		<p>테스트 메일입니다.</p>
					    	</label>					    		
				    	</a>
				    </li>
				    <li style="background-color: transparent;text-align:center">
						P A G I N G
					</li>
				</ul>
     		</div>
     		<!-- body end -->

     		<!-- footer import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezBoard/mBoardFooter.jsp" />
     		<!-- footer import -->
     		
     		<!-- layer Popup import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezBoard/mBoardPopup.jsp" />
     		<!-- layer Popup import -->
     		
     		<div id="test" class="ui-content" style="min-width: 255px; max-width: 285px; text-align:center" data-role="popup" data-overlay-theme="b" data-transition="slidedown">
		    	<a href="#" data-rel="back" data-role="button" data-theme="b" data-icon="delete" data-iconpos="notext" class="ui-btn-right">Close</a>
		    	<div>
					<input name="search-1" id="search-1" type="search" placeholder="search mail..">
					<a class="ui-btn" href="#">검 색</a>
				</div>
			</div>
     	</div>
	</body>	
</html>