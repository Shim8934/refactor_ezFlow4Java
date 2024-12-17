<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code="ezLadder.t001" /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
			function selectLadType(type) {
				window.location.href = "/ezLadder/setLadder.do?type="+type;
			}
		</script>
		<style type="text/css">
			.gameType_wrap{margin:0px; padding:0px;}
			.gameType_wrap h2{margin:38px 0px; padding:0px; text-align:center; font-size:24px; color:#323333; font-family: Malgun Gothic, Meiryo UI;}
			.gameType_wrap ul{overflow:hidden; list-style:none; width:968px; margin:0px auto; padding:0px;}
			.gameType_wrap ul li{float:left; margin:0px 10px 0px 0px; padding:0px; width:230px; height:378px; border-radius:5px; background:#f3f3f3; border:1px solid #d5d5d5; cursor:pointer;}
			.gameType_wrap ul li dl{margin:230px 0px 0px 0px; padding:0px; text-align:center;}
			.gameType_wrap ul li dl dt{margin:0px 0px 20px 0px; padding:0px; font-size:18px; color:#313333; font-family:Malgun Gothic, Meiryo UI}
			.gameType_wrap ul li dl dd{margin:0px; padding:0px; font-size:12px; color:#313333; line-height:22px; font-family:Malgun Gothic, Meiryo UI}
						
			.gameType_wrap ul li.gameType0{background:url(/images/ezLadder/img_bomb.png) #f3f3f3 center 40px no-repeat;}
			.gameType_wrap ul li.gameType1{background:url(/images/ezLadder/img_money.png) #f3f3f3 center 40px no-repeat;}
			.gameType_wrap ul li.gameType2{background:url(/images/ezLadder/img_order.png) #f3f3f3 center 40px no-repeat;}
			.gameType_wrap ul li.gameType3{background:url(/images/ezLadder/img_handwork.png) #f3f3f3 center 40px no-repeat;}
			
			.gameType_wrap ul li:hover{background:#e5f0fa; border:1px solid #afd3f0;}
			.gameType_wrap ul li.gameType0:hover{background:url(/images/ezLadder/img_bomb.png) #e5f0fa center 40px no-repeat;}
			.gameType_wrap ul li.gameType1:hover{background:url(/images/ezLadder/img_money.png) #e5f0fa center 40px no-repeat;}
			.gameType_wrap ul li.gameType2:hover{background:url(/images/ezLadder/img_order.png) #e5f0fa center 40px no-repeat;}
			.gameType_wrap ul li.gameType3:hover{background:url(/images/ezLadder/img_handwork.png) #e5f0fa center 40px no-repeat;}
			
		</style>
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezLadder.t018" /></h1>
		<div class="gameType_wrap">
		    <h2><spring:message code='ezLadder.t001' /></h2>
		    <ul>
		    	<li class="gameType0" onClick='selectLadType(0)'>
		        	<dl>
		            	<dt><spring:message code='ezLadder.t101' /></dt>
		                <dd><spring:message code='ezLadder.t088' /><br><spring:message code='ezLadder.t089' /></dd>
		            </dl>
		        </li>
		        <li class="gameType1" onClick='selectLadType(1)'>
		        	<dl>
		            	<dt><spring:message code='ezLadder.t102' /></dt>
		                <dd><spring:message code='ezLadder.t090' /><br><spring:message code='ezLadder.t091' /></dd>
		            </dl>
		        </li>
		        <li class="gameType2" onClick='selectLadType(2)'>
		        	<dl>
		            	<dt><spring:message code='ezLadder.t103' /></dt>
		                <dd><spring:message code='ezLadder.t092' /><br><spring:message code='ezLadder.t093' /></dd>
		            </dl>
		        </li>
		        <li class="gameType3" onClick='selectLadType(3)'>
		        	<dl>
		            	<dt><spring:message code='ezLadder.t104' /></dt>
		                <dd><spring:message code='ezLadder.t094' /><br><spring:message code='ezLadder.t095' /></dd>
		            </dl>
		        </li>
		    </ul>
		</div>
	</body>
</html>