<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
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
		        
		        var defaultNode = $(".node_selected");
		        
		        ladderClick(defaultNode);
		
		        leftResize();
		        $(".boardListBox").mCustomScrollbar({
	        		theme : "dark"
	        	});	
		    };
		    
		    function ladderClick(elem){
				$(".node_selected").attr("class","node_normal");
		    	
		    	var mode = $(elem).attr("mode");
		    	$(elem).attr("class","node_selected");
		    	
				var szUrl = "/ezLadder/ladderMain.do?mode=" + mode + "&currPage=1&searchSelect=none&searchInput=&sort=basic&sortFlag=desc";			
				window.parent.document.querySelector("iframe[name=right]").src = szUrl;
		    }
		    
		    function ladderWrite(){
		    	window.parent.document.querySelector("iframe[name=right]").src = '/ezLadder/selectLadderType.do';
		    }
		    
		    function resetNodeSelected(){
		    	$(".node_selected").attr("class","node_normal");
		    	$(".node_normal").eq(0).attr("class","node_selected");
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
	    	<div class="left_title" title="<spring:message code='ezLadder.t001'/>">
	    		<spring:message code="ezLadder.t001" />
	        </div>
	        <div class="btn_writeBox">
	        	<p class="btn_write01" onclick="ladderWrite();"><spring:message code="ezLadder.t018"/></p>
	        </div>
	        <div class="boardListBox" style="overflow:hidden; padding-right: 0;">
				<ul class="lnbUL" style="background: #F8F9FB; padding-top: 17px;">
					<li class="ladder" style="margin: 0px 20px 0px 20px; height: 26px; line-height: 26px;"><span class="node_selected" onclick="ladderClick(this);" mode="all" title="<spring:message code='ezLadder.t011' /> <spring:message code='ezLadder.t001' />"><spring:message code="ezLadder.t011" /> <spring:message code="ezLadder.t001" /></span></li>
					<li class="ladder" style="margin: 0px 20px 0px 20px; height: 26px; line-height: 26px;"><span class="node_normal" onclick="ladderClick(this);" mode="part" title="<spring:message code='ezLadder.t108' />"><spring:message code="ezLadder.t108" /></span></li>
				</ul>	
			</div>	        
	    </div>
	</body>
</html>
