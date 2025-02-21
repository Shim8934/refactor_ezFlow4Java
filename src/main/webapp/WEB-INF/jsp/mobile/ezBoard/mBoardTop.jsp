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
			<h1>${mBoardInfo.boardName}</h1>
			<a class="ui-btn ui-icon-bars ui-btn-icon-notext ui-btn-b ui-btn-inline" href="#menu-panel">menu</a>
			<a class="ui-btn-right ui-btn ui-icon-gear ui-btn-icon-notext ui-btn-b ui-btn-inline" href="#option-panel">option</a>
			<ul data-role="listview" data-inset="false" data-theme="a">
				<li data-position="fixed" style="height:25px">
					<div style="margin-left:5px;float:left;font-size:15px;padding-top:2px"> 
						<c:choose>
							<c:when test="${mBoardInfo.type == 'newBoardItemList'}">
								<i class="fa fa-envelope" style="font-size:16px;"></i>&nbsp;<strong>${listSize}</strong>
							</c:when>
							<c:when test="${mBoardInfo.type == 'boardItemList'}">
								<i class="fa fa-envelope" style="font-size:16px;"></i>&nbsp;<strong>${listSize}</strong>
							</c:when>
							<c:when test="${mBoardInfo.type == 'boardItem'}">
								<i class="fa fa-envelope" style="font-size:16px;"></i>&nbsp;<strong>뒤로가기아이콘</strong>
							</c:when>
						</c:choose>
					</div>
					<div style="margin-left:5px;float:right;font-size:15px;padding-top:2px">
						<c:choose>
							<c:when test="${mBoardInfo.type == 'newBoardItemList'}">
		<!-- 						기간 -->
								<i class="fa fa-search" style="font-size:24px;cursor: pointer;margin-left:20px" onclick="javascript:searchBoardItem();"></i>
		<!-- 						검색 -->
								<i class="fa fa-search" style="font-size:24px;cursor: pointer;margin-left:20px" onclick="javascript:searchBoardItem();"></i>
							</c:when>
							<c:when test="${mBoardInfo.type == 'boardItemList'}">
		<!-- 						즐겨찾기 -->
								<i class="fa fa-star" style="font-size:24px;cursor: pointer;margin-left:20px" onclick="javascript:searchBoardItem();"></i>
		<!-- 						기간 -->
								<!-- <i class="fa fa-search" style="font-size:24px;cursor: pointer;margin-left:20px" onclick="javascript:searchBoardItem();"></i> -->
		<!-- 						검색 -->
								<i class="fa fa-search" style="font-size:24px;cursor: pointer;margin-left:20px" onclick="javascript:searchBoardItem();"></i>
							</c:when>
							<c:when test="${mBoardInfo.type == 'boardItem'}">
							
							</c:when>
						</c:choose>
					</div>
				</li>
			</ul>
		</header>
		
		<!-- 왼쪽메뉴 panel -->
		<div id="menu-panel" data-role="panel" data-theme="a" data-display="overlay" data-position="left" style="overflow: hidden;">
			<div>	    	
				<div style="font-size:16px;text-align:center;background-color: rgb(31, 63, 105);color:white;height:33px;padding-top:10px"><b>메뉴선택</b></div>		    	
				<ul data-role="listview" style="margin-top:10px">
					<li data-icon="carat-r"><a href="javascript:goHome();"><i class="fa fa-home" style="font-size:18px"></i>&nbsp;&nbsp;홈</a></li>
					<li data-icon="carat-r"><a onclick="boardItemList(this)" type = newboardItemList boardID = "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;새게시물</a></li>
					<li data-icon="carat-r"><a onclick="newBoardList(this)" type = "boardList"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;즐찾슬라이드</a></li>
					<li data-icon="carat-r"><a onclick="boardItemList(this)" type = "boardItemList" boardID = "{6d7b50a2-4777-96a3-4b3a-a670dcd703f1}"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;게시판바로가기1</a></li>
					<li data-icon="carat-r"><a onclick="boardItemList(this)" type = "boardItemList" boardID = "{66c95ea2-d205-85e6-cd53-2801f4c98560}"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;게시판바로가기2</a></li>
					<li data-icon="carat-r"><a onclick="boardList(this)" type = "boardList" boardID = "#"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;대분류슬라이드</a></li>
					<li data-icon="carat-r"><a onclick="boardList(this)" type = "boardList" boardID = "#"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;대분류슬라이드</a></li>
					<li data-icon="carat-r"><a onclick="boardList(this)" type = "boardList" boardID = "#"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;대분류슬라이드</a></li>
					<li data-icon="carat-r"><a onclick="boardList(this)" type = "boardList" boardID = "#"><i class="fa fa-envelope-o" style="font-size:15px"></i>&nbsp;&nbsp;대분류슬라이드</a></li>
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
	</body>
</html>