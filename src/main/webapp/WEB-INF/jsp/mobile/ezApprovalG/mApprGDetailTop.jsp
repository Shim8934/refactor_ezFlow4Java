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
			<h1>문서보기</h1>
			<a class="ui-btn ui-icon-bars ui-btn-icon-notext ui-btn-b ui-btn-inline" href="#menu-panel">menu</a>
			<a class="ui-btn-right ui-btn ui-icon-gear ui-btn-icon-notext ui-btn-b ui-btn-inline" href="#option-panel">option</a>
			<ul style="background-color: white;color:black">
				<li style="height:40px;border-bottom:1px solid #f2f2f2">							
					<div style="margin-left:20px;float:left;padding-top:10px">
						<i class="fa fa-long-arrow-left" style="font-size:24px; cursor: pointer;" onclick="backApproveList()"></i>
					</div>
					<div style="margin-right:6px;float:right;padding-top:8px">
						<i class="fa fa-comment-o" style="font-size:24px;cursor: pointer;margin-left:20px" onclick="showComment('${docID}', 1)">${opinionCount}</i>
					</div>
					<div style="margin-right:6px;float:right;padding-top:8px">
						<i class="fa fa-file-text-o" style="font-size:24px;cursor: pointer;margin-left:20px" onclick="showOriginal()"></i>
					</div>
					<div style="margin-right:6px;float:right;padding-top:8px">
						<i class="fa fa-pencil" style="font-size:24px;cursor: pointer;margin-left:20px" onclick="approveList()"></i>
					</div>
				</li>
				<li style="height:40px;border-bottom:1px solid #f2f2f2;display:none" id="approveList">
					<div style="padding-left:20px">
						<c:if test="${(docState == '001' || docState == '012') && type == 'APR'}">
							<i class="fa fa-thumbs-o-up" style="font-size:24px; cursor: pointer; padding-top: 5px" onclick="doApprove('${docID}', 'APR')"></i>&nbsp;&nbsp;
							<i class="fa fa-thumbs-o-down" style="font-size:24px; cursor: pointer;" onclick="doApprove('${docID}', 'BAN')"></i>&nbsp;&nbsp;
							<i class="fa fa-hand-rock-o" style="font-size:24px; cursor: pointer;" onclick="doApprove('${docID}', 'BO')"></i>&nbsp;&nbsp;
						</c:if>
						<c:if test="${docState == '017' && type == 'APR'}">
							<i class="fa fa-check-square-o" style="font-size:24px; cursor: pointer;" onclick="doApprove('${docID}', 'CHECK')"></i>&nbsp;&nbsp;
						</c:if>
						<c:if test="${callBackYN == 'Y' && (type == 'ING' || type == 'DRAFT')}">
							<i class="fa fa-history" style="font-size:24px; cursor: pointer;" onclick="doApprove('${docID}', 'HWE')"></i>&nbsp;&nbsp;
						</c:if>
					</div>
				</li>
			</ul>
		</header>
		
<!-- 		<div class="ui-content" id="popupComment" style="min-width: 255px; max-width: 285px; height:200px; text-align:center;" data-role="popup" data-overlay-theme="b" data-transition="pop"> -->
		<div data-role="popup" id="popupComment" data-overlay-theme="b" data-theme="a" data-transition="pop" style="max-width:255px; min-width: 255px; height: 300px;">
		    <div data-role="header" data-theme="a">
				<h1>의견보기</h1>
			</div>
		    <a href="#" data-rel="back" data-role="button" data-theme="b" data-icon="delete" data-iconpos="notext" class="ui-btn-right">Close</a>
			<div style="height: 260px; overflow: auto">
			    <div data-role="collapsibleset" data-content-theme="a" data-iconpos="right" id="popupCommentSet">
			    </div>
			</div>
		</div>
		
		<div data-role="popup" id="popupWriteComment" data-overlay-theme="b" data-theme="a" data-transition="pop" style="max-width:255px; min-width: 255px; height: 300px;">
		    <div data-role="header" data-theme="a">
				<h1>의견쓰기</h1>
				<a class="ui-btn ui-btn-icon-left ui-btn-b ui-btn-inline" href="javascript:commentSave('${docID}')">save</a>
			</div>
		    <a href="#" data-rel="back" data-role="button" data-theme="b" data-icon="delete" data-iconpos="notext" class="ui-btn-right">Close</a>
			<div style="height: 260px; overflow: auto">
				<form>
					<textarea name="writeComment" id="writeComment" placeholder="의견을 작성해주세요."></textarea>
				</form>
			</div>
		</div>
		
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