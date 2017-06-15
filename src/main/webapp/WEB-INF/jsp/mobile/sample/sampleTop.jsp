<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezEKP Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
		<link rel="stylesheet" type="text/css" href="/css/font-awesome-4.7.0/css/font-awesome.min.css" />
	</head>
	<body>		
		<header data-role="header" data-position="fixed">
			<h1>${title}</h1>			
			<a class="ui-btn ui-icon-bars ui-btn-icon-notext ui-btn-b ui-btn-inline" href="#menu-panel">menu</a>							
			<a class="ui-btn-right ui-btn ui-icon-gear ui-btn-icon-notext ui-btn-b ui-btn-inline" href="#option-panel">option</a>			
			<ul style="background-color: white;color:black">				
				<li style="height:40px;border-bottom:1px solid #f2f2f2">							
					<div style="margin-left:16px;float:left;padding-top:10px">
						<c:if test="${type != 'mailRead'}">
							<i class="fa fa-envelope" style="font-size:18px;"></i>&nbsp;<strong style="font-size:18px;">${type == 'mailReceive' ? '4' : '2'}</strong>
						</c:if>
						<c:if test="${type == 'mailRead'}">
							<a href="/mobile/sample/sampleList.do?type=mailReceive"><i class="fa fa-step-backward" style="font-size:20px;"></i></a>
						</c:if>													
					</div>
					<div style="margin-right:6px;float:right;padding-top:8px">							
						<c:if test="${type == 'mailReceive'}">								
							<i class="fa fa-search" style="font-size:22px;cursor: pointer;margin-left:20px;margin-right:5px" onclick="javascript:showDisplay(1);"></i>
						</c:if>									
					</div>
				</li>
				<li style="height:40px;border-bottom:1px solid #f2f2f2;display:none" id="editDisplay">
					<div style="padding-left:20px;padding-top:8px">
						<i class="fa fa-check-square-o" style="font-size:24px;cursor: pointer;" onclick="javascript:checkAll();"></i>							
						<i class="fa fa-trash" style="font-size:24px;cursor: pointer;margin-left:20px"></i>
						<i class="fa fa-arrows" style="font-size:24px;cursor: pointer;margin-left:20px" onclick="javascript:moveMail();"></i>
						<i class="fa fa-search" style="font-size:24px;cursor: pointer;margin-left:20px" onclick="javascript:showDisplay(1);"></i>							
					</div>													
				</li>
				<li style="height:60px;border-bottom:1px solid #f2f2f2;display:none" id="editDisplay1">
					<div style="padding-left:20px">
						<!-- <div data-role="controlgroup" data-type="horizontal">
						    <input id="search-control-group" type="text" data-wrapper-class="controlgroup-textinput ui-btn">
						    <button class="searchIcon" data-icon="search" data-iconpos="notext">Search</button>
						</div> -->
						<div class="searchArea">
							<input type="text" data-wrapper-class="controlgroup-textinput ui-btn" placeholder="search Text..">
							<a class="ui-btn ui-icon-search ui-btn-icon-notext ui-btn-inline" href="#">No text</a>																
						</div>
					</div>
				</li>				
			</ul>			
		</header>
		
		<!-- 왼쪽메뉴 panel -->
	    <div id="menu-panel" data-role="panel" data-theme="a" data-display="overlay" data-position="left" style="overflow: hidden;">
	    	<div>	    	
		    	<div style="font-size:16px;text-align:center;background-color: rgb(31, 63, 105);color:white;height:33px;padding-top:10px"><b>메일</b></div>		    	
		        <ul data-role="listview" style="margin-top:10px">
		        	<li data-icon="carat-r"><a href="javascript:goHome();"><i class="fa fa-home" style="font-size:18px"></i>&nbsp;&nbsp;홈</a></li>
	                <li data-icon="carat-r"><a href="javascript:goMail();"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;받은편지함</a></li>
	                <li data-icon="carat-r"><a href="javascript:goSendMail();"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;보낸편지함</a></li>
	                <li data-icon="carat-r"><a href="#panel-fixed-page2"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;임시보관함</a></li>
	                <li data-icon="carat-r"><a href="#panel-fixed-page2"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;지운편지함</a></li>
	                <li data-icon="carat-r"><a href="#panel-fixed-page2"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;개인편지함</a></li>                
		        </ul>
		        <div style="margin-top:25px;padding:1em">	        	
		        	<a type="button" class="ui-btn ui-shadow ui-corner-all ui-btn-icon-left ui-icon-delete ui-btn-b" data-rel="close">CLOSE MENU</a>
		        </div>
			</div>
		</div>
		
		<!-- 환경설정 panel -->
	    <div id="option-panel" data-role="panel" data-theme="a" data-display="overlay" data-position="right">
	    	<div>		    	
		    	<div style="font-size:16px;text-align:center;background-color: rgb(31, 63, 105);color:white;height:33px;padding-top:10px"><b>OPTION</b></div>	
		        <ul data-role="listview" style="margin-top:10px">		            
	                <li data-icon="carat-r"><a href="#panel-fixed-page2"><i class="fa fa-cog" style="font-size:18px"></i>&nbsp;&nbsp;환경설정</a></li>
	                <li data-icon="carat-r"><a href="javascript:logout()"><i class="fa fa-power-off" style="font-size:18px"></i>&nbsp;&nbsp;로그아웃</a></li>	                		               
		        </ul>
		        <div style="margin-top:25px;padding:1em">
		        	<a type="button" class="ui-btn ui-shadow ui-corner-all ui-btn-icon-left ui-icon-delete ui-btn-b" data-rel="close">CLOSE MENU</a>
		        </div>
			</div>
	    </div>
	    <!-- 환경설정 panel -->	    	    
	</body>	
</html>