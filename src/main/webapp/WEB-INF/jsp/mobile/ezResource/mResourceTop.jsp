<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezFlow Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width"/>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/font-awesome-4.7.0/css/font-awesome.min.css')}" />
	</head>
	<body>		
		<header data-role="header" data-position="fixed">
			<h1>${title}</h1>			
			<a class="ui-btn ui-icon-bars ui-btn-icon-notext ui-btn-b ui-btn-inline" href="#menu-panel">menu</a>							
			<a class="ui-btn-right ui-btn ui-icon-gear ui-btn-icon-notext ui-btn-b ui-btn-inline" href="#option-panel">option</a>			
			<ul style="background-color: white;color:black">
				<c:if test="${type != 'mailRead' }">
					<li style="border-bottom:1px solid #f2f2f2">						
						<div style="margin-right:6px;float:right;padding-top:12px;height:32px">
							<c:if test="${type == 'mailReceive'}">								
								<i class="fa fa-pencil-square-o" style="font-size:25px;cursor: pointer;" onclick="javascript:showDisplay(0);"></i>
							</c:if>									
						</div>						
						<div style="margin-left:16px;float:left;padding-top:12px;height:32px">
							<i class="fa fa-desktop" style="font-size:18px;"></i>&nbsp;<strong style="font-size:18px;">17</strong>												
						</div>
						<div style="clear:both;height:0px">&nbsp;</div>
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
								<input type="text" data-wrapper-class="controlgroup-textinput ui-btn">
								<a class="ui-btn ui-icon-search ui-btn-icon-notext ui-btn-inline" href="#">No text</a>																
							</div>
						</div>
					</li>	
				</c:if>
			</ul>			
		</header>
		
		<!-- 왼쪽메뉴 panel -->
	    <div id="menu-panel" data-role="panel" data-theme="a" data-display="overlay" data-position="left" style="overflow: hidden;">	    
	        <div id="firstPanel" class="leftPanel" style="width:238px;height:100%;position:absolute;">
		        <div style="font-size:16px;text-align:center;background-color: rgb(31, 63, 105);color:white;height:33px;padding-top:10px"><b>자원관리</b></div>
		        <ul data-role="listview" style="margin-top:30px;">
		        	<li data-icon="carat-r"><a href="javascript:goHome();"><i class="fa fa-home" style="font-size:18px"></i>&nbsp;&nbsp;홈</a></li>
		        	<li data-icon="forward"><a href="javascript:goTest(1);"><i class="fa fa-folder" style="font-size:15px"></i>&nbsp;&nbsp;회의실</a></li>
		        	<li data-icon="forward"><a href="javascript:goTest(2);"><i class="fa fa-folder" style="font-size:15px"></i>&nbsp;&nbsp;빔프로젝터</a></li>
		        	<li data-icon="forward"><a href="#"><i class="fa fa-folder" style="font-size:15px"></i>&nbsp;&nbsp;공용차량</a></li>
		        	<li data-icon="forward"><a href="#"><i class="fa fa-folder" style="font-size:15px"></i>&nbsp;&nbsp;모바일기기</a></li>
		        	<li data-icon="forward"><a href="#"><i class="fa fa-folder" style="font-size:15px"></i>&nbsp;&nbsp;콘도회원권</a></li>		        	
		        </ul>
		        <div style="margin-top:10px;padding:1em">	        	
		        	<a type="button" class="ui-btn ui-shadow ui-corner-all ui-btn-icon-left ui-icon-delete ui-btn-b" data-rel="close">CLOSE MENU</a>
		        </div>
	        </div>
	        <div id="secondPanel" class="leftPanel" style="width:238px;height:100%;margin-left:238px;position:absolute;z-index: 10;">
	        	<div style="font-size:16px;text-align:center;background-color: rgb(31, 63, 105);color:white;height:33px;padding-top:10px"><b id="testTile">회의실</b></div>		        
		        <ul id="testListView" data-role="listview" style="margin-top:30px;">	        	
	                <li data-icon="carat-r"><a href="#"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;3층 소회의실</a></li>
	                <li data-icon="carat-r"><a href="#"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;3층 대회의실</a></li>
	                <li data-icon="carat-r"><a href="#"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;5층 소회의실</a></li>
	                <li data-icon="carat-r"><a href="#"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;5층 대회의실</a></li>                              
		        </ul>
		        <div style="margin-top:10px;padding:1em">
		        	<a href="javascript:goTestBack();" type="button" class="ui-btn ui-shadow ui-corner-all ui-btn-icon-left ui-icon-back ui-btn-b">BACK</a>
		        	<a type="button" class="ui-btn ui-shadow ui-corner-all ui-btn-icon-left ui-icon-delete ui-btn-b" data-rel="close">CLOSE MENU</a>
		        </div>
		    </div>	        	        
	    </div>
	    <!-- 왼쪽메뉴 panel -->		   
	    
	    <div id="menu-panel2" class="leftPanel" data-role="panel" data-theme="a" data-display="overlay" data-position="left" style="overflow: hidden;">
	    	<div style="font-size:16px"><b><i class="fa fa-folder" style="font-size:15px"></i>&nbsp;&nbsp;빔프로젝터</b></div>		    	
	        <ul data-role="listview" style="margin-top:10px">	        	
                <li data-icon="carat-r"><a href="#"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;빔프로젝트1 (경지실보관)</a></li>
                <li data-icon="carat-r"><a href="#"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;빔프로젝트2 (3층회의실)</a></li>                                
	        </ul>
	        <div style="margin-top:45px">
	        	<a href="#menu-panel" type="button" class="ui-btn ui-shadow ui-corner-all ui-btn-icon-left ui-icon-back ui-btn-b">BACK</a>
	        	<a type="button" class="ui-btn ui-shadow ui-corner-all ui-btn-icon-left ui-icon-delete ui-btn-b" data-rel="close">CLOSE MENU</a>
	        </div>
	    </div>
	    
	    <div id="menu-panel3" class="leftPanel" data-role="panel" data-theme="a" data-display="overlay" data-position="left">
	    	<div style="font-size:16px"><b><i class="fa fa-folder" style="font-size:15px"></i>&nbsp;&nbsp;공용차량</b></div>		    	
	        <ul data-role="listview" style="margin-top:10px">	        	
                <li data-icon="carat-r"><a href="#"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;58하3101 아반테</a></li>                                
	        </ul>
	        <div style="margin-top:45px">
	        	<a href="#menu-panel" type="button" class="ui-btn ui-shadow ui-corner-all ui-btn-icon-left ui-icon-back ui-btn-b">BACK</a>
	        	<a type="button" class="ui-btn ui-shadow ui-corner-all ui-btn-icon-left ui-icon-delete ui-btn-b" data-rel="close">CLOSE MENU</a>
	        </div>
	    </div>
		
		<!-- 환경설정 panel -->
	    <div id="option-panel" class="leftPanel" data-role="panel" data-theme="a" data-display="overlay" data-position="right">
	    	<div>		    	
		    	<div style="font-size:16px;text-align:center;background-color: rgb(31, 63, 105);color:white;height:33px;padding-top:10px"><b>OPTION</b></div>	
		        <ul data-role="listview" style="margin-top:30px">		            
	                <li data-icon="carat-r"><a href="#panel-fixed-page2"><i class="fa fa-cog" style="font-size:18px"></i>&nbsp;&nbsp;환경설정</a></li>
	                <li data-icon="carat-r"><a href="javascript:logout()"><i class="fa fa-power-off" style="font-size:18px"></i>&nbsp;&nbsp;로그아웃</a></li>	                		               
		        </ul>
		        <div style="margin-top:10px;padding:1em">
		        	<a type="button" class="ui-btn ui-shadow ui-corner-all ui-btn-icon-left ui-icon-delete ui-btn-b" data-rel="close">CLOSE MENU</a>
		        </div>
			</div>
	    </div>
	    <!-- 환경설정 panel -->	    	    
	</body>	
</html>