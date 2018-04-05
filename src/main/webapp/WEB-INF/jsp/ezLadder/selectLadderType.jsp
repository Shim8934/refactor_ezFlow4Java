<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code="ezLadder.t009" /></title>
		<link rel="stylesheet" href="<spring:message code='ezLadder.e2' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			function selectLadType(type) {
				window.location.href = "/ezLadder/setLadder.do?type="+type;
			}
			$(function() {
			
				ladder_main_resize();
				$(window).resize(function() {
					ladder_main_resize();
				});
			});
			// 윈도우 창 조절
			function ladder_main_resize() {
				var win_width = $(window).width();
				var win_height = $(window).height();
				$("#ladderGame").css("margin-top", win_height/25 + "px");
				$("#ladderGameCard").css("margin-top", win_height/12 + "px");
				$(".effect img").css("width", win_width/5 + "px");
				$(".effect img").css("height", win_height/2 + "px");
			}
		</script>
		<style type="text/css">
			ul {
			    list-style:none;
			    margin:0;
			    padding:0;
			    text-align: center;
			}
			
			li {
			    border : 2px solid grey;
			    display:inline-block;
			    margin-left:15px;
			    border-radius:20px;
			}
			
			h2 {
				font-size:20px;
				font-family: 'Gulim', 'arial', 'verdana';
				color: #393939;
				text-decoration: none;
				ime-mode:active;
			}
			
		</style>
	</head>
	<body>
		<div id="ladderGame" align="center">
			<h3><spring:message code='ezLadder.t100' /></h3>
		</div>
		<div id="ladderGameCard">
			<ul>
				<li onClick='selectLadType(0)'><div class="effect"><img src ='/images/ezLadder/img_bomb.png' /></div>
					<h2><spring:message code='ezLadder.t101' /></h2><br>
					<h3><spring:message code='ezLadder.t113' /></h3><h3><spring:message code='ezLadder.t114' /></h3><br></li>
				<li onClick='selectLadType(1)'><div class="effect"><img src ='/images/ezLadder/img_money.png' /></div>
					<h2><spring:message code='ezLadder.t102' /></h2><br>
					<h3><spring:message code='ezLadder.t115' /></h3><h3><spring:message code='ezLadder.t116' /></h3><br></li>
				<li onClick='selectLadType(2)'><div class="effect"><img src ='/images/ezLadder/img_order.png' /></div>
					<h2><spring:message code='ezLadder.t103' /></h2><br>
					<h3><spring:message code='ezLadder.t117' /></h3><h3><spring:message code='ezLadder.t118' /></h3><br></li>
				<li onClick='selectLadType(3)'><div class="effect"><img src ='/images/ezLadder/img_handwork.png' /></div>
					<h2><spring:message code='ezLadder.t104' /></h2><br>
					<h3><spring:message code='ezLadder.t119' /></h3><h3><spring:message code='ezLadder.t120' /></h3><br></li>
			</ul>
		</div>
	</body>
</html>