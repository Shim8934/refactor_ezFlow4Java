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
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>		
		<script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
	</head>
	<body>
	<header id="header">
	</header>
		<style type="text/css">
		#editBtn {
			float: right;
		}
		#editBtn img {
			width: 20px;
			height: 20px;
			margin-right: 10px;
			margin-top: 7px;
			cursor: pointer;
		}
		#editMenuBtn {
			display: none;
		}
		</style>
		<script type="text/javascript">
		
		var newPortalTopMenu = {
			menuListArr: [],           // 메뉴 리스트 배열에 저장
			menuListObj: {},           // 메뉴 리스트 객체에 저장
			menuWidth: [],             // 메뉴별 width 저장
			companyOrder: [],          // 기본 순서 저장 
			isInitOrder: false,        // 메뉴 순서 초기화일 경우.
		};
	
		// 로고 설정
		var setLogo = function () {
			var str = '';
				
				str += '<div class="logo">';
				str += '	<img src="${logoUrl}" id="logoUrl" style="cursor:pointer">';
				str += '</div>';
				
			return str;
		}
		
		// 메인메뉴 조합하는 함수
		var setMainMenuList = function (reData) {
			var menuList;

			if(reData === undefined) {
				menuList = newPortalTopMenu.menuListArr;
			} else {
				menuList = reData;
			}
			
			document.getElementById('mainMenuList').innerHTML = '';
			
 			var str = '';
			menuList.forEach(function (item, index) {
				str += '<li id="menu_' + item.menuId + '">' + item.menuName + '</li>';
				
				// 메뉴리스트 객체 생성
				newPortalTopMenu.menuListObj['menu_'+ item.menuId] = {
					menuId: item.menuId,
					menuUrl: item.menuUrl,
					companyOrder: item.companyOrder,
					iconUrl: item.iconUrl,
					menuName: item.menuName,
				};
			});
			
			document.getElementById('mainMenuList').innerHTML = str;
			
			// 메인메뉴 이벤트 모아둔 곳
			HTMLCollection.prototype.forEach = Array.prototype.forEach;
			var menuLi = document.getElementById('mainMenuList').children;
			menuLi.forEach(function (item, index) {
				var menuUrl = newPortalTopMenu.menuListObj[item.id].menuUrl;
				item.addEventListener('click', function () {
					window.open(menuUrl, 'main', '');
					// 클릭하면 창닫기.
					subMenuClickEvent('off');
				});
			});
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
				
				//str += assembleMainMenu();
				
				str += '</ul>';				
				
				str += '<div id="menu_toggle">';
				str += '	<div class="full_menu_toggle"><ul class="full_menu_toggleUL" id="toggleMenu"></ul></div>';
				str += '	<div class="menu_toggle_context" id="expandMenuFooter">'
				str += '		<div id="editBtn"><img src="/images/kr/left/icon_setup.gif" /></div>';
				str += '		<div id="editMenuBtn">'
				str += '			<span class="topMenuBtn" id="editMenuCancel">취소</span>';
				str += '			<span class="topMenuBtn" id="editMenuSave">저장</span>';
				str += '			<span class="topMenuBtn initOrder" id="editcompanyOrder">메뉴 순서 초기화</span>';
				str += '		</div>';
				str += '	</div>';				
				str += '</div>';
				str += '</nav>';
				str += '</li>';
				str += '</ul>';
				
			return str;
		}
		
		// 헤더 세팅
		var setTopMenu = function () {
			var str = '';
			
				str += '<ul class="contentlayout topmenulayout">';
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
			var element = document.getElementById(id);
			element.addEventListener('click', function () {
				window.open(url, location, option);
			});				
		}
		
		// 유틸메뉴 설정
		var setUtilMenu = function () {
			var str = '';
			
				str += '<ul class="util">';
				if ('${roleInfo}' === 'admin') str += '<li><span class="icon_topmenu util_admin" id="util_admin" title="관리자"></span></li>';
				str += '<li><span class="icon_topmenu util_employee_search" id="util_employee_search" title="직원조회"></span></li>';
				str += '<li><span class="icon_topmenu util_set" id="util_set" title="환경설정"></span></li>';
				str += '<li><span class="icon_topmenu util_help" id="util_help" title="도움말"></span></li>';
				str += '<li><span class="icon_topmenu util_logout" id="util_logout" title="로그아웃"></span></li>';
				str += '</ul>';
			
			return str;
		}		
		
		// 유틸메뉴 이벤트 모아둔 곳
		var setUtilEvent = function () {
			setEvent('logoUrl', '/ezNewPortal/newPortalPortalPage.do', 'main' ,'');
			if('${roleInfo}' === 'admin') {
				setEvent('util_admin', '${utilAdminUrl}', '' ,'');	
			}
			setEvent('util_employee_search', '/ezPersonal/personSearch.do', '' ,'height=560px,width=750px, status = no, toolbar=no, menubar=no,location=no, resizable=0');
			setEvent('util_set', '/ezPortal/environmentMain.do', 'main' ,'');
			setEvent('util_help', '/ezPortal/help/help.do', 'helpWindow', 'height=700px,width=1000px, status = no, toolbar=no, menubar=no, location=no, resizable=0');
			setEvent('util_logout', '/user/login/actionLogout.do', 'top', '');	
		}
		
		// 확장버튼 UI 이벤트 함수
		var subMenuClickEvent = function (type) {
			var topMenuFull = document.getElementById('topMenuFull');
			var topFrame = parent.document.getElementById('topFrame');
			var bodyTag = document.getElementsByTagName('Body')[0];				
			if(type === 'on') {
				$("#menu_toggle").css('display', 'none');
				$("#topMenuFull").fadeOut(0, function() {
					$("#topMenuFull").attr("class", "full_nav on");
					$("#topMenuFull").fadeIn(100);
				});				
				var screenHeight = screen.height;
				topFrame.style.position = 'relative';
				topFrame.style.minHeight = screenHeight+"px";
				bodyTag.style.backgroundColor = 'rgba(0, 0, 0, 0.3)';
				$("#menu_toggle").slideDown(200);
			} else if (type === 'off'){
				$("#topMenuFull").fadeOut(100, function() {
					$("#topMenuFull").attr("class", "full_nav off");
					$("#topMenuFull").fadeIn(100);
				});
				
				$("#menu_toggle").slideUp(200, function() {
					topFrame.style.position = '';	
				});
				// 취소버튼과 같은 역할
				var editMenuCancel = document.getElementById('editMenuCancel');
				editMenuCancel.click();			
			}
		}				
		
		// 확장메뉴 리스트 출력
		var setExpandMenuList = function (orderData) {
			var menuList;

			if(orderData === undefined) {
				menuList = newPortalTopMenu.menuListArr;
			} else {
				menuList = orderData;
			}
			
			var str = '';
			var toggleMenu = document.getElementById('toggleMenu');
			toggleMenu.innerHTML = '';

			menuList.forEach(function (item, index) {				
				str += '<li id="'+item.menuId+'" data-companyorder='+ item.companyOrder +'><dl class="full_menu_toggleDL"><dt><span class="'+ item.iconUrl +'"></span></dt><dd>'+ item.menuName +'</dd></dl></li>';
			});

			toggleMenu.innerHTML = str;
			
			// 확장메뉴 링크 이벤트
			var toggleMenu = document.getElementById('toggleMenu').children;
			toggleMenu.forEach(function (item, index) {
				var menuUrl = newPortalTopMenu.menuListObj['menu_' + item.id].menuUrl;
				item.addEventListener('click', function () {
					window.open(menuUrl, 'main', '');
					subMenuClickEvent('off');
				});
			});				
		}
		
		
		// 확장메뉴 버튼에서 나오는 메뉴리스트 및 이벤트
		var setExpandMenuListEvent = function () {

			setExpandMenuList(); // 확장메뉴 리스트
			
			// 편집모드로 변경 이벤트
			var editBtn = document.getElementById('editBtn');
			editBtn.addEventListener('click', function () {
				HTMLCollection.prototype.forEach = Array.prototype.forEach;
				
				// 드래그앤드롭
				$('#toggleMenu').sortable({
					activate: function () {
						if(newPortalTopMenu.isInitOrder === true) {
							newPortalTopMenu.isInitOrder = false;
						}
					}
				});
				$('#toggleMenu').sortable("option", "disabled", false);
				$('#toggleMenu').disableSelection();	
				var sortedMenu = document.getElementById('toggleMenu');
				sortedMenu.className = 'full_menu_toggleUL_edit';
				
				// 하단 메뉴 변경
				var editMenuBtn = document.getElementById('editMenuBtn');
				editBtn.style.display = 'none';
				editMenuBtn.style.display = 'block';
			});
			
			// 취소버튼
			var editMenuCancel = document.getElementById('editMenuCancel');
			editMenuCancel.addEventListener('click', function() {
				
				document.getElementById('editMenuBtn').style.display = 'none';
				document.getElementById('editBtn').style.display = 'block';
				
				var sortedMenu = document.getElementById('toggleMenu');
				sortedMenu.className = 'full_menu_toggleUL';
				
				$('#toggleMenu').sortable();
				$('#toggleMenu').sortable("option", "disabled", true);
				
				// 취소하면 버튼 처음으로 재정렬
				setExpandMenuList();
			});
			
			// 저장버튼
			var editMenuSave = document.getElementById('editMenuSave');
			editMenuSave.addEventListener('click', function() {
				alert('저장하였습니다.');		
				
				document.getElementById('editMenuBtn').style = 'none';
				document.getElementById('editBtn').style = 'block';
				
				var sortedMenu = document.getElementById('toggleMenu');
				sortedMenu.className = 'full_menu_toggleUL';
				
				$('#toggleMenu').sortable();
				$('#toggleMenu').sortable("option", "disabled", true);				
				
				HTMLCollection.prototype.forEach = Array.prototype.forEach;
				var sortedMenu = document.getElementById('toggleMenu').getElementsByTagName('li');
				
				var orderObj = [];
				sortedMenu.forEach(function (item, index) {
					orderObj.push({
						menuId: item.id,
						order: (index*1) + 1,
					});
				});
				
	 			var xhr = new XMLHttpRequest();
				xhr.onload = function () {
					// 결과 값으로 다시 출력할 메뉴 가져오기.
					if (xhr.status >= 200 && xhr.status < 300) {
						var result = JSON.parse(xhr.responseText).data;
						newPortalTopMenu.menuListArr = result.menuList; 
						// 메뉴 리스트 다시 덮어씌우기
						setMainMenuList(result.menuList);
						setExpandMenuList(result.menuList); 
					} else {
						console.error(xhr.responseText);
					}
				};
				
				// 메뉴 순서 초기화 버튼인 경우 아닌 경우 
				if (newPortalTopMenu.isInitOrder) {
					xhr.open('DELETE', '/ezNewPortal/deleteUserMenuOrder.do');
					xhr.send();
				} else {
					xhr.open('PATCH', '/ezNewPortal/updateUserMenuOrder.do');
					xhr.setRequestHeader('Content-Type', 'application/json');
					xhr.send(JSON.stringify({
						data: orderObj,
					}));					
				}
				
			});			
			
			// 메뉴 순서 초기화 버튼
			var editcompanyOrder = document.getElementById('editcompanyOrder');
			editcompanyOrder.addEventListener('click', function() {
 
				var elements = document.getElementById('toggleMenu').childNodes;
	 			Array.prototype.forEach.call(elements, function (item, index) { 				
					newPortalTopMenu.companyOrder[index] = {
						menuId: item.id,
						companyOrder: item.dataset.companyorder*1,
						iconUrl: newPortalTopMenu.menuListObj['menu_'+item.id].iconUrl,
						menuName: newPortalTopMenu.menuListObj['menu_'+item.id].menuName,
						menuUrl: newPortalTopMenu.menuListObj['menu_'+item.id].menuUrl,
					};
				});
	 			
	 			var temp = [];
	 			for(var i=0; i<newPortalTopMenu.companyOrder.length; i++ ) {
	 				for(var j=i; j<newPortalTopMenu.companyOrder.length; j++) {
	 					if(newPortalTopMenu.companyOrder[i].companyOrder > newPortalTopMenu.companyOrder[j].companyOrder ) {
	 						temp = newPortalTopMenu.companyOrder[i];
	 						newPortalTopMenu.companyOrder[i] = newPortalTopMenu.companyOrder[j];
	 						newPortalTopMenu.companyOrder[j] = temp;
	 					}
	 				}
	 			};
	 			
				// 확장메뉴 재배치	
	 			setExpandMenuList(newPortalTopMenu.companyOrder);
				
				// 메뉴 순서 초기화 값 true로 변경
				newPortalTopMenu.isInitOrder = true;
			});			
		}			
		
		// 확장메뉴 이벤트 모아둔 곳
		var setExpandMenuEvent = function () {
			// 확장버튼 UI 이벤트 설정
			var topMenuFull = document.getElementById('topMenuFull');
			topMenuFull.addEventListener('click', function () {
				if (topMenuFull.className.indexOf('on') > -1) { // 닫을 때
					subMenuClickEvent('off');
				} else if (topMenuFull.className.indexOf('off') > -1) { // 열 때
					//setExpandMenuList();
					subMenuClickEvent('on');
				}
			});		
		}		
		
		// 메뉴 리스트의 사이즈 구하기
		var getMenuListWidth = function () {
			var elements = document.getElementById('mainMenuList').childNodes;
 			Array.prototype.forEach.call(elements, function (item, index) {
				newPortalTopMenu.menuWidth[index] = item.offsetWidth;
			});	
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
		
		var getNotiPopup = function () {
			var notiList = JSON.parse('${popupNotiList}');
			
			if (notiList != null || notiList.length != 0) {
				for (var i = 0; i < notiList.length; i++) {
					var notiInfo = notiList[i];
					
					openNotiPopup(notiInfo.itemSeq, notiInfo.width, notiInfo.height, notiInfo.position);
				}
			}
		}
		
		//위치 지정하여 팝업 열기 --- 팝업 공지사항
		var openNotiPopup = function (popup_number, wWidth, wHeight, wPosition) {
		    var wVertical, wHorizontal;
		    
			if(wPosition == 0) {
		        wVertical = Math.floor(screen.height/2) - (wHeight/2); 
		        wHorizontal = Math.floor(screen.width/2) - (wWidth/2);
		    } else if(wPosition == 1) {
		        wVertical = 100; 
		        wHorizontal = 100;
		    } else if(wPosition == 2) {
		        wVertical = screen.height - wHeight - 100; 
		        wHorizontal = 100;
		    } else if(wPosition == 3) {
		        wVertical = 100; 
		        wHorizontal = screen.width - wWidth - 100;
		    } else if(wPosition == 4) {
		        wVertical = screen.height - wHeight - 100; 
		        wHorizontal = screen.width - wWidth - 100;
		    } else if(wPosition == 5) {
		        wVertical = 100; 
		        wHorizontal = Math.floor(screen.width/2) - (wWidth/2);
		    } else if(wPosition == 6) {
		        wVertical = screen.height - wHeight - 100; 
		        wHorizontal = Math.floor(screen.width/2) - (wWidth/2);
		    } else {
		        wVertical = 0; 
		        wHorizontal = 0;
		    }

		    if(wVertical < 0)
		        wVertical = 0;

		    if(wHorizontal < 0)
		        wHorizontal = 0;

		    if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1)
		        wHeight = eval(wHeight) - 60;

		    window.open("/admin/ezPersonal/showPopup.do?itemSeq=" + popup_number + 
					"&answer=", "", "height=" + wHeight + "px,width=" + wWidth + "px, left=" + wHorizontal + "px, top=" + wVertical + "px, status = no, toolbar=no, menubar=no,location=no, resizable=0");
		}
		
 		var newPortalTopMenuFunc = function () {
 			newPortalTopMenu.menuListArr = JSON.parse('${menuList}');
		
			setTopMenu();            // 헤더 전체 셋팅
			setMainMenuList();       // 메인메뉴 리스트 출력
			setUtilEvent();          // 유틸메뉴 이벤트 설정
			getMenuListWidth();      // 메인메뉴 li별 사이즈 측정
			countTopMenuList();      // 메인메뉴 카운팅
			getNotiPopup();          // 팝업공지 불러오기
			setExpandMenuListEvent();// 확장메뉴 이벤트 설정
			setExpandMenuEvent();    // 확장메뉴 이벤트 설정
			
		}		
 		
 		// 시작지점
		newPortalTopMenuFunc();	
		
		window.onresize = function () {
			countTopMenuList();      // 메인메뉴 카운팅
		}
		</script>	
	</body>
</html>
