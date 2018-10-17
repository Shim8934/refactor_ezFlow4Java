<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>TopMenu</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<link href="${util.addVer('/css/ezNewPortal/newPortal_css.css')}" rel="stylesheet" type="text/css">

        <script type="text/javascript" src="${util.addVer('/js/ezPortal/string_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPortal/functionLib.js')}"></script>			
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
	</head>
	<body>
	<header id="header">
	</header>
		<script type="text/javascript">
	
		// 로고 설정
		var setLogo = function () {
			var str = '';
				
				str += '<div class="logo">';
				str += '	<img src="${logoUrl }" id="logoUrl" style="cursor:pointer">';
				str += '</div>';
				
			return str;
		}
		
		// 유틸메뉴 설정
		var setUtilMenu = function () {
			console.log('roleInfo', '${roleInfo}');
			var str = '';
			
				str += '<ul class="util">';
				if ('${roleInfo}' === 'admin') str += '<li><span class="icon_topmenu util_admin" id="util_admin" title="직원조회"></span></li>';
				str += '<li><span class="icon_topmenu util_employee_search" id="util_employee_search" title="직원조회"></span></li>';
				str += '<li><span class="icon_topmenu util_set" id="util_set" title="환경설정"></span></li>';
				str += '<li><span class="icon_topmenu util_help" id="util_help" title="도움말"></span></li>';
				str += '<li><span class="icon_topmenu util_logout" id="util_logout" title="로그아웃"></span></li>';
				str += '</ul>';
			
			return str;
		}
		
		// 메인메뉴 설정
		var setMainMenu = function () {
			var str = '';
			
				str += '<ul class="contentlayout topmenu">';
				str += '<li class="contentlayout_none" style="margin:0 auto">';
				str += '<nav id="topNav" class="topNavCls" tyle="max-width:1102px;">';
				str += '<div id="topMenuFull" class="full_nav off" onclick="subMenuClick()"><span class="icon_topmenu full_menu"></span></div>';
				str += '<div class="countBox" style="display: block;"><span class="hidden_nav_count">+1</span><span class="icon_topmenu icon_count_arrow"></span></div>';
				str += '<ul class="navUL">메뉴들</ul>';
				str += '<div class="full_menu_toggle" style="display:none;"></div>';
				str += '</nav>';
				str += '</li>';
				str += '</ul>';
				
			return str;
		}
		
		var setTopMenu = function () {
			var str = '';
			
				str += '<ul class="contentlayout">';
				str += '	<li class="contentlayout_left">';
				str += setLogo();
				str += '	</li>';
				str += '	<li class="contentlayout_right">';
				str += setUtilMenu();
				str += '	</li>';
				str += '	<li class="contentlayout_none">';
				str += setMainMenu();
				str += '	</li>';
				str += '</ul>';		
			
			document.getElementById('header').innerHTML = str;
		}
		
		var setEvent = function (id, url, location, option) {
			
			if ( id === "logoUrl" ) {
		
			} else {
				var element = document.getElementById(id);
				element.addEventListener('click', function () {
					window.open(url, '', option);
				});				
			}
	
		}
		
 		var newPortalTopMenuFunc = function () {
			setTopMenu();
			// 이벤트 설정
			setEvent('logoUrl', '/ezPortal/myPortal.do', 'main' ,'');
			setEvent('util_employee_search', '/ezPersonal/personSearch.do', '' ,'height=560px,width=750px, status = no, toolbar=no, menubar=no,location=no, resizable=0');
			setEvent('util_set', '/ezPortal/environmentMain.do?topMenuID=F3633607-8E8B-42A1-B777-6E2969072E58', 'main' ,'');
			//setEvent('util_set', '/ezPortal/environmentMain.do', 'main' ,'');
			setEvent('util_help', '/ezPortal/help/help.do?topMenuID=F3633607-8E8B-42A1-B777-6E2969072E58', 'helpWindow', 'height=700px,width=1000px, status = no, toolbar=no, menubar=no, location=no, resizable=0');
			//setEvent('util_help', '/ezPortal/help/help.do', 'helpWindow', 'height=700px,width=1000px, status = no, toolbar=no, menubar=no, location=no, resizable=0');
		}
		
		newPortalTopMenuFunc();	
		</script>	
	</body>
</html>
