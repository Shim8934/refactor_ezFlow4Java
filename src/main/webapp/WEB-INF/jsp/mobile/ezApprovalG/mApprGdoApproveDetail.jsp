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
    	<link rel="stylesheet" type="text/css" href="/css/mobile/mApprovalG.css" />
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery.mobile/jquery.mobile-1.4.5.min.js"></script>
		<script type="text/javascript" src="/js/mobile/mobile.js"></script>
		<script type="text/javascript" src="/js/mobile/mApprovalG.js"></script>
		<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
		<script type="text/javascript" src="/js/rsa/rsa.js"></script>
		<script type="text/javascript" src="/js/rsa/prng4.js"></script>
		<script type="text/javascript" src="/js/rsa/rng.js"></script>			
	</head>
	<body class="loginbody">
		<section id="doApproveDetail" data-role="page">
			<!-- header import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezApprovalG/mApprGDetailTop.jsp" />
     		<!-- header import -->
     		
     		<!-- body start -->
			<div class="content" data-role="content">
		      	<div class="ui-body ui-body-a ui-corner-all">
		      		<div data-role="fieldcontain">
		        		<h1>야근수당</h1>
		        		<br/>
		        		<h5>지정석 사원(오픈솔루션팀)</h5>
		        	</div>
		        	<c:forEach var="aprLineList" items="${aprLineList}" varStatus="status">
			        	<div data-role="fieldcontain">
			        		<div style="float:left;">
				        		<img src="/images/OrganTree/porson_noimg.gif">
			        		</div>
			        		<div style="padding-top:12px; float:left;">
				        		<h4>${aprLineList.aprMemberName} ${aprLineList.aprMemberJobTitle}(${aprLineList.aprMemberDeptName})</h4><br/>
				        		<h4>${aprLineList.receivedDate}</h4>
				        	</div>
			        		<div style="padding-top:30px; float:right;">
			        			<c:if test="${aprLineList.aprState == '001'}">
			        				대기
			        			</c:if>
			        			<c:if test="${aprLineList.aprState == '002'}">
			        				진행
			        			</c:if>
			        			<c:if test="${aprLineList.aprState == '003'}">
			        				결재
			        			</c:if>
				        		
				        	</div>
			        	</div>	
		        	</c:forEach>
		        	<br/><br/><br/><br/>
		        	<div data-role="fieldcontain">
		        		<h1 style="text-align: center">본문</h1>
		        	</div>
		      	</div>	
		      	<div class="writeButton" onclick="alert('write!')"></div>										
     		</div>
     		<!-- body end -->

     		<!-- footer import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezApprovalG/mApprGFooter.jsp" />
     		<!-- footer import -->
     		
     		<!-- layer Popup import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezApprovalG/mApprGPopup.jsp" />
     		<!-- layer Popup import -->
     	</section>
	</body>	
</html>