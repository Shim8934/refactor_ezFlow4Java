<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>left</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
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
						url ="/admin/ezCommunity/searchKey.do";
						getApplicationListCount();
						break;
					case 2:
						url = "/admin/ezCommunity/bbsList.do?bName=tbl_c_board";
						getApplicationListCount();
						break;
					case 3:
						url = "/admin/ezCommunity/applicationList.do";
						getApplicationListCount();
						break;
				}
				parent.document.right.document.querySelector("[name='comm_main']").src = url;
				
				$("#left .adminListBox h2 span").click(function(){
					$("#left .adminListBox h2").removeClass("on");
					$(this).parent().addClass("on");
				})

			}
			
			$(document).ready(function() {
				leftResize();
		        $(".adminListBox").mCustomScrollbar({
		    		theme : "dark"
		    	});
				getApplicationListCount();
			});
	        
	        function leftResize(){
	        	$(".adminListBox").height(window.innerHeight-58);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
	    	});
			
			function getApplicationListCount() {
				$.ajax({
					type : "POST",
					dataType : "json",
					async : false,
					url : "/admin/ezCommunity/getApplicationListCount.do",
					success: function(result){
						$("#listCount").html("&nbsp;&nbsp;" + result.count);
					}
				});
			}
		</script>
	</head>
	<body class="newLeft"> 
		<div id="left" class="lnb" style="overflow: auto">
			<div class="admin_left_title" title="Community"><spring:message code = 'ezCommunity.t1529' /></div>
			<div class="adminListBox" style="overflow:hidden; padding-right: 0;">
				<h2 class="on"><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(1)"><spring:message code = 'ezCommunity.khj02' /></span></h2>
				<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(2)"><spring:message code = 'ezCommunity.khj07'/></span></h2>
				<h2><span class="h2Title" style="display:inline-block;width:100%;" onClick="goPage(3)"><spring:message code = 'ezCommunity.khj06' /><span id="listCount" class="txt_color"></span></span></h2>
			</div>
		</div>
	</body>
</html>