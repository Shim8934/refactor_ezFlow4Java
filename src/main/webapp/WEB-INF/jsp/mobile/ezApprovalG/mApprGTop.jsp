<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezFlow Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/font-awesome-4.7.0/css/font-awesome.min.css')}" />
	</head>
	<body>
		<header data-role="header" data-position="fixed">
			<c:if test="${type == 'DO'}">
				<h1>결재할문서</h1>
			</c:if>
			<c:if test="${type == 'END'}">
				<h1>결재한문서</h1>
			</c:if>
			<c:if test="${type == 'ING'}">
				<h1>결재진행문서</h1>
			</c:if>
			<c:if test="${type == 'DRAFT'}">
				<h1>기안한문서</h1>
			</c:if>
			<c:if test="${type == ''}">
				<h1>결재할문서</h1>
			</c:if>
			<a class="ui-btn ui-icon-bars ui-btn-icon-notext ui-btn-b ui-btn-inline" href="#menu-panel">menu</a>
			<a class="ui-btn-right ui-btn ui-icon-gear ui-btn-icon-notext ui-btn-b ui-btn-inline" href="#option-panel">option</a>
			<ul style="background-color: white;color:black">
				<li style="height:40px;border-bottom:1px solid #f2f2f2">							
					<div style="margin-left:20px;float:left;padding-top:10px">
						<i class="fa fa-pencil-square" style="font-size:13px;"></i>&nbsp;<strong style="font-size:13px;" id="listCount">(${listCount})</strong>
					</div>
					<div style="margin-right:6px;float:right;padding-top:8px">
						<i class="fa fa-search" style="font-size:24px;cursor: pointer;margin-left:20px" onclick="searchApprove()"></i>
					</div>
				</li>
				<li style="height:60px;border-bottom:1px solid #f2f2f2;display:none" id="searchApprove">
					<div style="padding-left:20px">
						<div class="searchArea">
							<input type="text" data-wrapper-class="controlgroup-textinput ui-btn" id="searchApprroveInput">
							<a class="ui-btn ui-icon-search ui-btn-icon-notext ui-btn-inline" href="javascript:searchApproveList()">No text</a>
						</div>
					</div>
				</li>
			</ul>	
		</header>
		
		<!-- 왼쪽메뉴 panel -->
	    <div id="menu-panel" data-role="panel" data-theme="a" data-display="overlay" data-position="left">
	    	<div style="font-size:16px"><b>메뉴선택</b></div>		    	
	        <ul data-role="listview" style="margin-top:10px">
	        	<li data-icon="carat-r"><a href="javascript:goHome();"><i class="fa fa-home" style="font-size:18px"></i>&nbsp;&nbsp;홈</a></li>
                <li data-icon="carat-r"><a href="javascript:goApproveList('DO');"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;결재할문서</a></li>
                <li data-icon="carat-r"><a href="javascript:goApproveList('ING');"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;결재진행문서</a></li>
                <li data-icon="carat-r"><a href="javascript:goApproveList('DRAFT');"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;기안한문서</a></li>
                <li data-icon="carat-r"><a href="javascript:goApproveList('END');"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;결재한문서</a></li>
	        </ul>
	        <div style="margin-top:45px">
	        	<a type="button" class="ui-btn ui-shadow ui-corner-all ui-btn-icon-left ui-icon-delete ui-btn-b" data-rel="close">CLOSE MENU</a>
	        </div>
	    </div>
	    <!-- 왼쪽메뉴 panel -->		
		
		<!-- 환경설정 panel -->
	    <div id="option-panel" data-role="panel" data-theme="a" data-display="overlay" data-position="right">
	    	<div style="font-size:16px"><b>환경설정</b></div>	    	
	        <ul data-role="listview" style="margin-top:10px">		            
                <li data-icon="carat-r"><a href="#panel-fixed-page2"><i class="fa fa-cog" style="font-size:18px"></i>&nbsp;&nbsp;언어설정</a></li>
                <li data-icon="carat-r"><a href="javascript:logout()"><i class="fa fa-power-off" style="font-size:18px"></i>&nbsp;&nbsp;로그아웃</a></li>	                		               
	        </ul>
	        <div style="margin-top:45px">
	        	<a type="button" class="ui-btn ui-shadow ui-corner-all ui-btn-icon-left ui-icon-delete ui-btn-b" data-rel="close">CLOSE MENU</a>
	        </div>	        
	    </div>
	    <!-- 환경설정 panel -->	    	    
	</body>	
</html>