<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>left_Top</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
		<style>
			#mCSB_1_container {
				margin-right: 0px;
			} 
		</style>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<script type="text/javascript">
			
			document.onselectstart = function () {
	        	if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	            	return false;
	        	else
	            	return true;
			};
			
			function goPage(idx) {
				var url = "";
				switch(idx) {
					case 1:
						url = "/admin/ezJournal/formType.do";
						break;
					
					case 2:
						url = "/admin/ezJournal/form.do";
						break;
						
					case 3:
						url = "/admin/ezJournal/author.do";
						break;
				}
				parent.document.querySelector("iframe[name=right]").src = url;
				
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
			<div class="admin_left_title" title="<spring:message code='ezJournal.t1'/>"><spring:message code='ezJournal.t1'/></div>			
			<div class="adminListBox" style="overflow:hidden; padding-right: 0;">
				<h2 class="on"><span class="h2Title" onClick="goPage(1)" style="display:inline-block;width:100%;"><spring:message code='ezJournal.t2'/></span></h2>	
				<h2><span class="h2Title" onClick="goPage(2)" style="display:inline-block;width:100%;"><spring:message code='ezJournal.t3'/></span></h2>	
				<h2><span class="h2Title" onClick="goPage(3)" style="display:inline-block;width:100%;"><spring:message code='ezJournal.t4'/></span></h2>	
			</div>
		</div>
	</body>
</html>