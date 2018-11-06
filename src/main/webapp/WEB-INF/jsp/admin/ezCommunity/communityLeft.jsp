<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>left</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezCommunity.i1', 'msg')}" type="text/css">
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
		<style>
			#mCSB_1_container {
				margin-right: 0px;
			} 
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		
		<script type="text/javascript">
		document.onselectstart = function () {
	        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	            return false;
	        else
	            return true;
			};
			
			function goPage(idx)
			{
				var url = "";
				switch(idx)
				{
					case 1:
						url = "/admin/ezCommunity/bbsList.do?bName=tbl_c_board";
						break;
					case 2:
						url ="/admin/ezCommunity/searchKey.do?sRadio=C_ClubName&keyword=&key&pDivi=admin";
						break;
					case 3:
						url = "/admin/ezCommunity/closeCom.do";
						break;
					case 4:
						url = "/admin/ezCommunity/admitCom.do" ;
						break;
				}				
				window.open(url,"comm_main");
			}
			
			$(document).ready(function() {
				leftResize();
		        $(".adminListBox").mCustomScrollbar({
		    		theme : "dark"
		    	});
			});
	        
	        function leftResize(){
	        	$(".adminListBox").height(window.innerHeight-58);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
	    	});
		</script>
	</head>
	<body class="newLeft"> 
		<div id="left" class="lnb" style="overflow: auto">
			<div class="admin_left_title" title="Community"><spring:message code = 'ezCommunity.t1529' /></div>
			<div class="adminListBox" style="overflow:hidden; padding-right: 0;">
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(2)"><spring:message code = 'ezCommunity.t1117' /></span></h2>
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(1)"><spring:message code = 'ezCommunity.t2001' /></span></h2>
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(3)"><spring:message code = 'ezCommunity.t39' /></span></h2>	
				<h2><span style="display:inline-block;width:100%;" onClick="goPage(4)"><spring:message code = 'ezCommunity.t25' /></span></h2>			
			</div>
		</div>
	</body>
</html>