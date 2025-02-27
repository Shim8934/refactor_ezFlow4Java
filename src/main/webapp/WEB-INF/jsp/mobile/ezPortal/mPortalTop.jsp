<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezFlow Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="user-scalable=yes, initial-scale=1.0, maximum-scale=2.0, minimum-scale=1.0"/>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/font-awesome-4.7.0/css/font-awesome.min.css')}" />
		
		<script type="text/javascript">
			function mOption() {
				$.mobile.changePage("/mobile/ezOption/ezOptionMain.do", {
					type: "post",
					transition: "pop",
					changeHash: true
				});
			}
		</script>
		<style>
			#topSearchArea {				
				padding-left:5px;
				padding-right:5px;
			}
			
			#topSearchArea .ui-input-search {
				margin-top:0px;
			}
		</style>
	</head>
	<body>		
		<header data-role="header" data-position="fixed">
			<a class="ui-btn ui-icon-bars ui-btn-icon-notext ui-btn-b ui-btn-inline" href="#menu-panel">menu</a>
			<h1>KAONI</h1>							
			<a class="ui-btn-right ui-btn ui-icon-gear ui-btn-icon-notext ui-btn-b ui-btn-inline" href="#option-panel">option</a>
			<div id="topSearchArea">
				<input name="search-5" id="search-5" type="search" placeholder="직원검색" value="" onKeyPress="if(event.keyCode==13) alert('직원검색!');">
			</div>
		</header>
		
		<!-- 왼쪽메뉴 panel -->
	    <div id="menu-panel" class="leftPanel" data-role="panel" data-theme="a" data-display="overlay" data-position="left" style="overflow: hidden;">
	    	<div id="firstPanel" class="leftPanel" style="width:238px;height:100%;position:absolute;">    	
		    	<div style="font-size:16px;text-align:center;background-color: rgb(31, 63, 105);color:white;height:33px;padding-top:10px"><b>홈</b></div>		    	
		        <ul data-role="listview" style="margin-top:30px">		        	
	                <li data-icon="carat-r"><a href="javascript:goMail();"><i class="fa fa-thumbs-up" style="font-size:15px"></i>&nbsp;&nbsp;결재할문서</a></li>
	                <li data-icon="carat-r"><a href="javascript:goSendMail();"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;받은편지함</a></li>
	                <li data-icon="carat-r"><a href="#panel-fixed-page2"><i class="fa fa-calendar" style="font-size:15px"></i>&nbsp;&nbsp;오늘의일정</a></li>
	                <li data-icon="carat-r"><a href="#panel-fixed-page2"><i class="fa fa-file-text-o" style="font-size:15px"></i>&nbsp;&nbsp;새게시물</a></li>
	                <li data-icon="forward"><a href="javascript:goTest(1);"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;자원관리</a></li>
	                <li data-icon="carat-r"><a href="#panel-fixed-page2"><i class="fa fa-users" style="font-size:15px"></i>&nbsp;&nbsp;직원목록</a></li>	                        
		        </ul>
		        <ul data-role="listview" style="margin-top:30px">
		        	<li><a rel="external" class="ui-btn" href="/mobile/ezPortal/portalMain.do?mainOption=F"><i class="fa fa-plane" style="font-size:15px"></i>&nbsp;&nbsp;기본 타입 </a></li>
		        	<li><a rel="external" class="ui-btn" href="/mobile/ezPortal/portalMain.do"><i class="fa fa-plane" style="font-size:15px"></i>&nbsp;&nbsp;폴더 타입</a></li>
					<li><a rel="external" class="ui-btn" href="/mobile/ezPortal/portalMain.do?mainOption=S"><i class="fa fa-plane" style="font-size:15px"></i>&nbsp;&nbsp;포탈 타입 </a></li>
					<li><a rel="external" class="ui-btn" href="/mobile/ezPortal/portalMain.do?mainOption=T"><i class="fa fa-plane" style="font-size:15px"></i>&nbsp;&nbsp;타임라인 타입 </a></li>					
		        </ul>
		        <div style="margin-top:10px;padding:1em">	        	
		        	<a type="button" class="ui-btn ui-shadow ui-corner-all ui-btn-icon-left ui-icon-delete ui-btn-b" data-rel="close">CLOSE MENU</a>
		        </div>		        
			</div>
			<div id="secondPanel" class="leftPanel" style="width:238px;height:100%;margin-left:238px;position:absolute;">
		        <div style="font-size:16px;text-align:center;background-color: rgb(31, 63, 105);color:white;height:33px;padding-top:10px"><b>자원관리</b></div>
		        <ul data-role="listview" style="margin-top:30px;">
		        	<li data-icon="forward"><a href="javascript:goTestBack();" type="button" class="ui-btn ui-shadow ui-btn-icon-left ui-icon-back ui-btn-b">BACK</a></li>  		        	
		        	<li data-icon="forward"><a href="javascript:goTest(3);"><i class="fa fa-folder" style="font-size:15px"></i>&nbsp;&nbsp;회의실</a></li>
		        	<li data-icon="forward"><a href="#"><i class="fa fa-folder" style="font-size:15px"></i>&nbsp;&nbsp;빔프로젝터</a></li>
		        	<li data-icon="forward"><a href="#"><i class="fa fa-folder" style="font-size:15px"></i>&nbsp;&nbsp;공용차량</a></li>
		        	<li data-icon="forward"><a href="#"><i class="fa fa-folder" style="font-size:15px"></i>&nbsp;&nbsp;모바일기기</a></li>
		        	<li data-icon="forward"><a href="#"><i class="fa fa-folder" style="font-size:15px"></i>&nbsp;&nbsp;콘도회원권</a></li>		        	
		        </ul>
		        <div style="margin-top:10px;padding:1em">		        	     	
		        	<a type="button" class="ui-btn ui-shadow ui-corner-all ui-btn-icon-left ui-icon-delete ui-btn-b" data-rel="close">CLOSE MENU</a>
		        </div>
	        </div>
	        <div id="thirdPanel" class="leftPanel" style="width:238px;height:100%;margin-left:238px;position:absolute;">
	        	<div style="font-size:16px;text-align:center;background-color: rgb(31, 63, 105);color:white;height:33px;padding-top:10px"><b id="testTile">회의실</b></div>		        
		        <ul data-role="listview" style="margin-top:30px;">
		        	<li data-icon="forward"><a href="javascript:goTestMainBack();" type="button" class="ui-btn ui-shadow ui-btn-icon-left ui-icon-back ui-btn-b">BACK</a></li>
	                <li data-icon="carat-r"><a href="#"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;3층 소회의실</a></li>
	                <li data-icon="carat-r"><a href="#"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;3층 대회의실</a></li>
	                <li data-icon="carat-r"><a href="#"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;5층 소회의실</a></li>
	                <li data-icon="carat-r"><a href="#"><i class="fa fa-desktop" style="font-size:15px"></i>&nbsp;&nbsp;5층 대회의실</a></li>                              
		        </ul>
		        <div style="margin-top:10px;padding:1em">		        	
		        	<a type="button" class="ui-btn ui-shadow ui-corner-all ui-btn-icon-left ui-icon-delete ui-btn-b" data-rel="close">CLOSE MENU</a>
		        </div>
		    </div>
		</div>		
		
		<!-- 환경설정 panel -->
	    <div id="option-panel" class="leftPanel" data-role="panel" data-theme="a" data-display="overlay" data-position="right">
	    	<div>		    	
		    	<div style="font-size:16px;text-align:center;background-color: rgb(31, 63, 105);color:white;height:33px;padding-top:10px"><b>OPTION</b></div>	
		        <ul data-role="listview" style="margin-top:30px">		            
	                <li data-icon="carat-r"><a href="javascript:mOption()"><i class="fa fa-cog" style="font-size:18px"></i>&nbsp;&nbsp;환경설정</a></li>
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