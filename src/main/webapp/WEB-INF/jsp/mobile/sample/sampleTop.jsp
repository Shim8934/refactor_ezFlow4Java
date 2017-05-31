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
			<ul data-role="listview" data-inset="false" data-theme="a">
				<c:if test="${type != 'mailRead' }">
					<li data-position="fixed" style="height:25px">							
						<div style="margin-left:5px;float:left;font-size:15px;padding-top:2px">
							<i class="fa fa-envelope" style="font-size:16px;"></i>&nbsp;<strong>${type == 'mailReceive' ? '받은편지함 : 17' : '보낸편지함 : 25'}</strong>
						</div>
						<div style="float:right;padding-top:1px">
							<c:if test="${type == 'mailReceive'}">
								<i id="editBtn" class="fa fa-pencil-square-o" style="font-size:24px;cursor: pointer;"></i>
							</c:if>									
						</div>
					</li>
					<li style="display:none" id="editDisplay">
						<div style="margin-left:5px;">
							<i class="fa fa-check-square-o" style="font-size:24px;cursor: pointer;" onclick="javascript:checkAll();"></i>							
							<i class="fa fa-trash" style="font-size:24px;cursor: pointer;margin-left:20px"></i>
							<i class="fa fa-arrows" style="font-size:24px;cursor: pointer;margin-left:20px" onclick="javascript:moveMail();"></i>
							<i class="fa fa-search" style="font-size:24px;cursor: pointer;margin-left:20px" onclick="javascript:searchMail();"></i>
						</div>							
					</li>
				</c:if>
			</ul>			
		</header>
		
		<!-- 왼쪽메뉴 panel -->
	    <div id="menu-panel" data-role="panel" data-theme="a" data-display="overlay" data-position="left">
	    	<div style="font-size:16px"><b>메뉴선택</b></div>		    	
	        <ul data-role="listview" style="margin-top:10px">
	        	<li data-icon="carat-r"><a href="javascript:goHome();"><i class="fa fa-home" style="font-size:18px"></i>&nbsp;&nbsp;홈</a></li>
                <li data-icon="carat-r"><a href="javascript:goMail();"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;받은편지함</a></li>
                <li data-icon="carat-r"><a href="javascript:goSendMail();"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;보낸편지함</a></li>
                <li data-icon="carat-r"><a href="#panel-fixed-page2"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;임시보관함</a></li>
                <li data-icon="carat-r"><a href="#panel-fixed-page2"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;지운편지함</a></li>
                <li data-icon="carat-r"><a href="#panel-fixed-page2"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;개인편지함</a></li>
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