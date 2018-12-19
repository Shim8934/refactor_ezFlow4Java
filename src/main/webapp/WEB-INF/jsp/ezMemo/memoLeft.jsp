<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	   	<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezBoard.i1', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	    <style>
	    	.groupBoard {
				width:158px;
				overflow:hidden;
				text-overflow:ellipsis;
			}
			#FromTreeView {
				height: 100%;
			}
			#mCSB_1_container {
				margin-right: 0px;
			}
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
	    
		<script type="text/javascript" >
	        var items = "${resultCount}";
	        var rightFrame = "";
	        var qstId = "";
	        var pollNum = "2";
	        var configView = false;
	        
		    window.onresize = function () {
		        var menuSize = (parseInt(items) + 2) * 30;
		    };
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		    	rightFrame = window.parent.document.getElementsByName("right")[0];
		    	
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        
		        memoClick('0', '<spring:message code="ezPoll.t237"/> <spring:message code="ezMemo.t001" />');
		
		        leftResize();
		        $(".boardListBox").mCustomScrollbar({
	        		theme : "dark"
	        	});	
		    };
		    
		    function memoClick(folderId, folderName, configView){
	        	window.parent.frames["right"].location.href = "/ezMemo/memoMain.do?brdID=8&folderId="+folderId+"&folderName="+folderName+"&configView="+configView;
		    	configView = false;
		    }
		    
		    function memoConfig(){
		    	configView = true;
		    	window.parent.frames["right"].location.href = "/ezMemo/memoConfig.do";
		    }
		    
		    function memoWrite(){
		    	if (configView){
			    	memoClick('0', '<spring:message code="ezPoll.t237"/> <spring:message code="ezMemo.t001" />', configView);
		    	} else {
			    	window.parent.frames["right"].newMemo();
		    	}
		    	configView = false;
		    }
		    
		    function leftResize(){
	        	$(".boardListBox").height(window.innerHeight-105);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
        	});
		    
	 
	    </script>
	</head>
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
	    	<div class="left_title" title="<spring:message code='ezMemo.t001'/>">
	    		<spring:message code='ezMemo.t001'/>
	    		<span onclick="memoConfig();" class="sub_iconLNB tree_leftconfig" title="<spring:message code="ezBoard.t0005" />"></span>
	        </div>
	        <div class="btn_writeBox">
	        	<p class="btn_write01" onclick="memoWrite();"><span class="sub_iconLNB tree_write"></span><spring:message code="ezMemo.t0014" /></p>
	        </div>
	        <div class="boardListBox" style="overflow:hidden; padding-right: 0;">
		        <div class="lnb_lay">
			        <h2 onclick="memoClick('0', '<spring:message code="ezPoll.t237"/> <spring:message code="ezMemo.t001" />');">
			        	<span class="sub_iconLNB tree_board_memo"></span><span class="h2Title"><spring:message code="ezPoll.t237"/> <spring:message code="ezMemo.t001" /></span>
			        </h2>
		        	<c:forEach items="${folders }" var="folder">
		        		<h2 onclick="memoClick('${folder.folder_id}','${folder.folder_name}');">
				        	<span class="sub_iconLNB tree_board_memo"></span><span class="h2Title"><c:out value="${folder.folder_name}"></c:out></span>
				        </h2>
		        	</c:forEach>
				</div>	
			</div>	        
	    </div>
	</body>
</html>
