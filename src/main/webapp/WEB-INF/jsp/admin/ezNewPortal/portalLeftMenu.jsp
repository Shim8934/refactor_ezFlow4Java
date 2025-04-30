<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>portalLeftMenu</title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	</head>
	
	<style>
		.leftMenu_btn {
			display : inline-block;
			width : 100%;
		}
		#mCSB_1_container {
				margin-right: 0px;
		} 
	</style>
	
	<body class="newLeft"> 
		<div id="left" class="lnb" style="overflow: auto">
			<div class="admin_left_title" title="<spring:message code='ezNewPortal.t053' />"><spring:message code='ezNewPortal.t053' /></div>
			<div class="adminListBox" style="overflow:hidden; padding-right: 0;">
				<!-- themes -->
				<h2 class="on"><span class="sub_iconLNB tree_arrow_down"></span><span class="h2Title" onclick="openFolder()"><spring:message code='ezPortal.jjh01' /></span></h2>

				<ul class="lnbUL">
				<c:if test="${packageType != 'mail'}">  
				<c:if test="${usePortal eq 'YES' }">
					<li class="on"><span class = "list_text leftMenu_btn" id = "themes"><spring:message code='ezNewPortal.t054' /></span></li>
					<li><span class = "list_text leftMenu_btn" id = "menus"><spring:message code='ezNewPortal.t055' /></span></li>
					<li><span class = "list_text leftMenu_btn" id = "portlets"><spring:message code='ezNewPortal.t056' /></span></li>
				</c:if>
					<li><span class = "list_text leftMenu_btn" id = "logos"><spring:message code='ezNewPortal.t057' /></span></li>
				</c:if>
				<c:if test="${packageType == 'mail'}">  
					<li><span class = "list_text leftMenu_btn" id = "logos"><spring:message code='ezNewPortal.t057' /></span></li>
				</c:if>
				</ul>
				<c:if test="${usePortal eq 'YES' }">
				<h2 class="off"><span class="sub_iconLNB tree_plus"></span><span class="h2Title" onclick="openFolder()"><spring:message code='ezPortal.jjh02' /></span></h2>
				<ul class="lnbUL off">
				<c:if test="${packageType != 'mail'}">  
					<li><span  class = "list_text" onClick="goPage(8)"><spring:message code='ezPersonal.khj1' /></span></li>
					<li><span  class = "list_text" onClick="goPage(3)"><spring:message code = 'ezPersonal.hyh1' /></span></li>
					<li><span  class = "list_text" onClick="goPage(4)"><spring:message code = 'main.t67' /></span></li>
					<li><span  class = "list_text" onClick="goPage(7)"><spring:message code = 'ezNewPortal.t019' /></span></li>
<%--					<li><span  class = "list_text" onClick="goPage(9)"><spring:message code = 'main.t10000' /></span></li>--%>
				</c:if>
				<c:if test="${packageType == 'mail'}"> 
					<li><span  class = "list_text" onClick="goPage(4)"><spring:message code = 'main.t67' /></span></li>
				</c:if>
				</ul>
				</c:if>
				<c:if test="${packageType != 'mail'}">
				<h2 class="off"><span class="sub_iconLNB tree_plus"></span><span class="h2Title" onclick="openFolder()"><spring:message code='ezNewPortal.mobilePortal01' /></span></h2>
				<ul class="lnbUL off">
					<li><span  class = "list_text leftMenu_btn" id="MPortlets"><spring:message code='ezNewPortal.t056' /></span></li>
					<li><span  class = "list_text leftMenu_btn" id="MTheme"><spring:message code='ezNewPortal.mobilePortal02' /></span></li>
					<li><span  class = "list_text leftMenu_btn" id="MMenus"><spring:message code = 'ezNewPortal.t055' /></span></li>
					<li><span class = "list_text leftMenu_btn" id = "MLogos"><spring:message code='ezNewPortal.t057' /></span></li>
				</ul>
				</c:if>
			</div>
		</div>
	</body>
	
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
	<script type="text/javascript">
		var eventSetting = function() {
			var elementList = document.querySelectorAll('.leftMenu_btn');
			
			[].forEach.call(elementList, function(element) {
				element.addEventListener('click', function() {
					var url = "";
					switch(this.id) {
						case "themes" :
							url = "/admin/ezNewPortal/portalThemes.do";
							break;
						case "menus" :
							url = "/admin/ezNewPortal/portalMenus.do";
							break;
						case "portlets" :
							url = "/admin/ezNewPortal/portalPortlets.do";
							break;
						case "logos" :
							url = "/admin/ezNewPortal/portalLogos.do";
							break;
						case "MPortlets" :
							url = "/admin/ezNewPortal/portalPortlets.do?type=mobile";
							break;
						case "MMenus" :
							url = "/admin/ezNewPortal/portalMenus.do?type=mobile";
							break;
						case "MTheme" :
							url = "/admin/ezNewPortal/portalThemes.do?type=mobile";
							break;
						case "MLogos" :
							url = "/admin/ezNewPortal/portalLogos.do?type=mobile";
							break;
					}
					
					window.open(url,"right");
					liSelected();
				});
			});
		}
		
		eventSetting();
		
		$(document).ready(function() {
			leftResize();
	        $(".adminListBox").mCustomScrollbar({
	    		theme : "dark"
	    	});
		});
        
        function leftResize(){
        	$(".adminListBox").height(window.innerHeight-78);
        }
        
        $( window ).resize(function() {
        	leftResize();
    	});
        
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
		    }
			parent.document.querySelector("iframe[name=right]").src = url;
			liSelected();
		}
        
        // 2023-07-03 황인경 - 디자인 개선 > 관리자 > 포탈 > 좌측메뉴 > 트리구조 메뉴 선택 
        function liSelected() {
	        $("li.on").attr("class", "");
			$(event.target).parent().attr("class", "on");
        } 
        
        // 2023-07-03 황인경 - 디자인 개선 > 관리자 > 포탈 > 좌측메뉴 > 트리구조 LNB 이미지 추가 
        function openFolder() {
        	var h2Title = $(event.target).parent();
        	
        	if (h2Title.hasClass("on")) {
        		h2Title.attr("class", "off");
        		h2Title.next().addClass("off");
        		h2Title.children().eq(0).attr("class", "sub_iconLNB tree_plus");
        	} else {
        		$("h2.on").attr("class", "off");
        		$(".lnbUL").attr("class", "lnbUL off");
        		h2Title.attr("class", "on");
        		h2Title.next().removeClass("off");
        		$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
        		h2Title.children().eq(0).attr("class", "sub_iconLNB tree_arrow_down");
        	}
        }
		
	</script>
</html>