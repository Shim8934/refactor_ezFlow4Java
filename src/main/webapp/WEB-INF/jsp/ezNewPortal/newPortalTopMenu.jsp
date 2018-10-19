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
		
		var newPortalTopMenu = {
			menuList: {},
			menuWidth: [],
		};
	
		// 로고 설정
		var setLogo = function () {
			var str = '';
				
				str += '<div class="logo">';
				str += '	<img src="${logoUrl}" id="logoUrl" style="cursor:pointer">';
				str += '</div>';
				
			return str;
		}
		
		// 유틸메뉴 설정
		var setUtilMenu = function () {
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
		
		// 메인메뉴 조합하는 함수
		var assembleMainMenu = function () {
			var menuList = JSON.parse('${menuList}');
			var str = '';
			menuList.forEach(function (item, index) {
				str += '<li id="menu_' + item.menuId + '">' + item.menuName + '</li>';
				
				// 메뉴리스트 객체 생성
				newPortalTopMenu.menuList['menu_'+ item.menuId] = {
					menuId: item.menuId,
					menuUrl: item.menuUrl,
				};
			});
			return str;	
		}
		
		// 메인메뉴 설정
		var setMainMenu = function () {
			
			var str = '';
			
				str += '<ul class="contentlayout topmenu">';
				//str += '<li class="contentlayout_none" style="margin:0 auto">';
				str += '<li class="contentlayout_none">';
				//str += '<nav id="topNav" class="topNavCls" tyle="max-width:1102px;">';
				str += '<nav id="topNav" class="topNavCls">';
				str += '<div id="topMenuFull" class="full_nav off"><span class="icon_topmenu full_menu"></span></div>';
				str += '<div class="countBox" style="display: block;"><span class="hidden_nav_count" id="nav_count"></span><span class="icon_topmenu icon_count_arrow"></span></div>';
				// str += '<div class="countBox"><span class="hidden_nav_count">+1</span><span class="icon_topmenu icon_count_arrow"></span></div>';
				str += '<ul class="navUL" id="mainMenuList">';
				
				str += assembleMainMenu();
				
				str += '</ul>'				
				str += '<div class="full_menu_toggle" style="display:none;"></div>';
				str += '</nav>';
				str += '</li>';
				str += '</ul>';
				
			return str;
		}
		
		// 헤더 세팅
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
		
		// window.open 이벤트 처리하기
		var setEvent = function (id, url, location, option) {
			if ( id === "logoUrl" ) {
		
			} else {
				var element = document.getElementById(id);
				element.addEventListener('click', function () {
					window.open(url, location, option);
				});				
			}
		}
		
		// 유틸메뉴 이벤트 모아둔 곳
		var setUtilEvent = function () {
			setEvent('logoUrl', '/ezPortal/myPortal.do', 'main' ,'');
			setEvent('util_employee_search', '/ezPersonal/personSearch.do', '' ,'height=560px,width=750px, status = no, toolbar=no, menubar=no,location=no, resizable=0');
			setEvent('util_set', '/ezPortal/environmentMain.do', 'main' ,'');
			setEvent('util_help', '/ezPortal/help/help.do', 'helpWindow', 'height=700px,width=1000px, status = no, toolbar=no, menubar=no, location=no, resizable=0');			
		}
		
		// 메인메뉴 이벤트 모아둔 곳
		var setMainEvent = function () {
			HTMLCollection.prototype.forEach = Array.prototype.forEach;
			var menuList = JSON.parse('${menuList}');
			var menuLi = document.getElementById('mainMenuList').children;
			
			menuLi.forEach(function (item, index) {
				var menuUrl = newPortalTopMenu.menuList['menu_' + (index + 1)].menuUrl;
				item.addEventListener('click', function () {
					window.open(menuUrl, 'main', '');
				});
			});
		}
		
		// 메뉴 리스트의 사이즈 구하기
		var getMenuListWidth = function () {
 			document.getElementById('mainMenuList').childNodes.forEach(function (item, index) {
				newPortalTopMenu.menuWidth[index] = item.offsetWidth;
			});	
			console.log('list',newPortalTopMenu.menuWidth);
		}
		
		// 탑메뉴 숨김메뉴 개수 표시
		var countTopMenuList = function () {
			// 현재 메인메뉴의 width를 구하기
			var listWidth = document.getElementById('mainMenuList').offsetWidth;
			
			var sumWidth = 0;
			var menuCnt = 0;
			var totalMenuCnt = 0;
			// 각 메뉴들의 사이즈를 더해서 현재 메인메뉴의 width보다 작을때를 확인.
			newPortalTopMenu.menuWidth.forEach(function (item, index) {
				if (sumWidth < listWidth) {
					sumWidth += (item*1);
					menuCnt++;
				}
				totalMenuCnt++;
			});
			document.getElementById('nav_count').innerHTML = '+' + (totalMenuCnt*1 - (menuCnt*1-1));
		}
		
 		var newPortalTopMenuFunc = function () {
			setTopMenu();            // 헤더 전체 셋팅
			setUtilEvent();          // 유틸메뉴 이벤트 설정
			setMainEvent();          // 메인메뉴 이벤트 설정
			getMenuListWidth();      // 메인메뉴 li별 사이즈 측정
			countTopMenuList();      // 메인메뉴 카운팅
		}
		
 		
 		// 시작지점
		newPortalTopMenuFunc();	
		
		window.onresize = function () {
			countTopMenuList();      // 메인메뉴 카운팅
		}
		</script>	
	</body>
</html>
