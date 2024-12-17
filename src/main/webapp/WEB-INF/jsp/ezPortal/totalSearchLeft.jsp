<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
	    
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	   	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	</head>
	<style type="text/css">
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
	.wrap-loading {
		position : fixed;
		left : 0;
		right : 0;
		top : 0;
		bottom : 0;
		background: rgba(0,0,0,0.5);
	}
	.loading_layer {
		z-index: 6000; 
		position: absolute; 
		top: 400px; 
		left: 500px; 
	}
	.display_none {
		display: none;
	}	
	</style>
	<script type="text/javascript">
	    window.onload = function () {
	    	rightFrame = window.parent.document.getElementsByName("right")[0];
	    	
	        if (navigator.userAgent.indexOf('Firefox') != -1) {
	            document.body.style.MozUserSelect = 'none';
	            document.body.style.WebkitUserSelect = 'none';
	            document.body.style.khtmlUserSelect = 'none';
	            document.body.style.oUserSelect = 'none';
	            document.body.style.UserSelect = 'none';
	        }
	
	        leftResize();
	        $(".boardListBox").mCustomScrollbar({
	    		theme : "dark"
	    	});	
	    };
	    
	    function leftResize(){
        	$(".boardListBox").height(window.innerHeight-105);
        }
	
	</script>
	<body class="newLeft"> 
	    <div id="left" class="lnb" style="overflow: auto">
	    	<div class="left_title" title="<spring:message code='ezTotalSearch.t0001' />">
	    		<spring:message code='ezTotalSearch.t0001' />
	        </div>
	    	<!-- 일반 회람판하고 같은 아이콘으로 설정. -->
	        <%-- <div class="left_circular" title='<spring:message code="ezTotalSearch.t0001" />'><span><spring:message code='ezTotalSearch.t0001' /></span></div> --%>
	        
	        <div class="boardListBox" style="overflow:hidden; padding-right: 0;">
				<ul class="lnbUL">
					<li class="pollDiv"><span class="sub_iconLNB tree_search"></span><span class="list_text"><spring:message code='ezTotalSearch.t0001' /></span></li>
				</ul>
			</div>	        
	    </div>
	    <%-- <ul class="on">
			<li style="border-top:1px solid #eaeaea" evt="0" class="off"><span id="" onclick="" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezTotalSearch.t0001' /></span></li>
		</ul>	 --%>    
<!-- 	    <script type="text/javascript">
	        initToggleList(document.getElementById("left"), "h2", "ul", "li");
	    </script>
	    <xml id="RootFolderXML" style="display: none;"></xml> -->
	</body>
	<div class="wrap-loading display_none">
		<span class="loading_layer" id="loadingLayer"></span>
	</div>	
</html>