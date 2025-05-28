<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
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
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		
		<script type="text/javascript">
	
			function goPage(idx) {
				var url = "";
			    switch (idx) {
			        case 1:
			            url = "/admin/ezPersonal/manageNotice.do";
			            break;

			        case 2:
			            if (CrossYN())
			                url = "/myoffice/ezPersonal/Link/ManageCompanyLink_Cross.aspx";
			            else {
			                url = "/myoffice/ezPersonal/Link/ManageCompanyLink.aspx";
			            }
			            break;

			        case 3:
			            url = "/admin/ezPersonal/managePoll.do";
			            break;

			        case 4:
			            url = "/admin/ezPersonal/managePopup.do";
			            break;

			        case 5:
			            url = "/myoffice/ezPersonal/SuperPersonal/ManageSuperPersonal.aspx";
			            break;

			        case 7:
			            url = "/admin/ezPersonal/employeeOfMonth.do";
			            break;

			        case 8:
			            url = "/admin/ezPersonal/manageQuickLink.do";
			            break;

			        case 9:
			            url = "/admin/ezPersonal/sliderImages.do";
			            break;
			            
			        case 10:
			            url = "/admin/ezNewPortal/portalLogos.do";
			            break;
			    }
				parent.frames["right"].location.href = url;
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
			<div class="admin_left_title" title="<spring:message code = 'main.t7' />"><spring:message code = 'main.t7' /></div>   
		  	<%-- <h2>
		  		 <span onClick="goPage(1)" style="display:inline-block;width:100%"><spring:message code = 'main.t65' /></span>
		    	<ul></ul> <!-- 공지사항 사용안함 -->
			</h2> --%>
			
			<div class="adminListBox" style="overflow:hidden; padding-right: 0;">
				<h2><span onClick="goPage(10)" style="display:inline-block;width:100%"><spring:message code='ezNewPortal.t057' /></span></h2>
				<%-- <h2><span onClick="goPage(8)" style="display:inline-block;width:100%">빠른링크</span></h2>
			  	<h2 style="display: ${(pollFlag != 'YES') ? 'block' : 'none'};"><span onClick="goPage(3)" style="display:inline-block;width:100%">Quick Poll</span></h2>
			  	<h2 style="display: 'block';"><span onClick="goPage(3)" style="display:inline-block;width:100%"><spring:message code = 'ezPersonal.hyh1' /></span></h2>
			  	<h2><span onClick="goPage(4)" style="display:inline-block;width:100%"><spring:message code = 'main.t67' /></span></h2>
			  	<h2><span onClick="goPage(7)" style="display:inline-block;width:100%;"><spring:message code = 'main.t68' /></span></h2>
			  	<h2><span onClick="goPage(9)" style="display:inline-block;width:100%;"><spring:message code = 'main.t10000' /></span></h2> --%>
		  	</div>
		  	<%-- <c:if test="${useKMS == 'YES' }">
				<h2><span onClick="goPage(5)" style="display:inline-block;width:100%"><spring:message code = 'main.t68' /></span>
					<ul></ul>
				</h2>
			</c:if> --%>
		</div>
	</body>
</html>