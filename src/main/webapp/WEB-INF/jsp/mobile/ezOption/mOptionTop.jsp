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
			<h1>환경설정</h1>			
			<a class="ui-btn-right ui-btn ui-icon-gear ui-btn-icon-notext ui-btn-b ui-btn-inline" href="#option-panel">option</a>						
		</header>
		
		<!-- 왼쪽메뉴 panel -->
	    <div id="menu-panel" data-role="panel" data-theme="a" data-display="overlay" data-position="left">
	    	<div style="font-size:16px"><b>메뉴선택</b></div>		    	
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