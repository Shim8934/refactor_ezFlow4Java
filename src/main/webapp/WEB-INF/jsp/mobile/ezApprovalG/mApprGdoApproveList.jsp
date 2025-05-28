<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezFlow Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />				
		<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery.mobile/jquery.mobile-1.4.5.min.css')}" />
    	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mobile/mobile.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery.mobile/jquery.mobile-1.4.5.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mobile/mobile.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mobile/mApprovalG.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>	
		<script type="text/javascript">
			$(document).ready(function() {
				getApproveList("${type}");
				getApproveListCount("${type}");
	
				$.searchApprove = function() {
					alert("Search!");
				}
			});
		</script>		
	</head>
	<body class="loginbody">
		<section id="doApproveList" data-role="page">
			<!-- header import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezApprovalG/mApprGTop.jsp" />
     		<!-- header import -->
     		
     		<!-- body start -->
			<div class="content" data-role="content">				
				<ul data-role="listview" data-inset="false" data-theme="a" id="apprList"></ul>
     		</div>     		
     		<!-- body end -->

     		<!-- footer import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezApprovalG/mApprGFooter.jsp" />
     		<!-- footer import -->
     		
     		<!-- layer Popup import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezApprovalG/mApprGPopup.jsp" />
     		<!-- layer Popup import -->
     		
     		<div id="test" class="ui-content" style="min-width: 255px; max-width: 285px; text-align:center" data-role="popup" data-overlay-theme="b" data-transition="slidedown">
		    <a href="#" data-rel="back" data-role="button" data-theme="b" data-icon="delete" data-iconpos="notext" class="ui-btn-right">Close</a>
		    <div>		    	
				<input name="search-1" id="search-1" type="search" placeholder="search approve..">
				<a class="ui-btn" href="#">검 색</a>
			</div>			
		</div>
     	</section>
	</body>	
</html>