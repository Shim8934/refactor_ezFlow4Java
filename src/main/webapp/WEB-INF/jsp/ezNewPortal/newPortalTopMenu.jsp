<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>TopMenu</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezNewPortal/portal.css')}" />
		<link href="${util.addVer('main.portal', 'msg')}" rel="stylesheet" type="text/css">
		<link rel="stylesheet" href="${util.addVer('ezNewPortal.e2', 'msg')}">
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezPortal/string_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPortal/functionLib.js')}"></script>			
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/lang/ezSurvey_ko.js')}"></script>
		<script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
		<script type="text/javascript" src="${util.addVer('/js/ClickTracker.js')}"></script>
		<style>
			#editMenuBtn {display: none;}
			.ui-sortable-helper {border-left:1px dashed #898989; border-top : 1px dashed #898989;}
			#logoUrl {height:42px;}
			/*-- top_totalSearch --*/
			.top_totalSearch {font-family:Gulim, Dotum, Arial, Helvetica, sans-serif; font-size:12px;float:right; margin:12px 10px 0px 0px; padding:0px; width:245px; height:34px; background:url(../images/kr/cm/top_search_bg.gif) no-repeat;vertical-align:middle; }
		</style>
		<script>
			var useColor = '<c:out value="${useColor}"/>';
			var packageType = '<c:out value="${packageType}"/>';

			//ezAI 사용 여부
			var useAI = '<c:out value="${useAI}"/>';

			// UI 스킨 작업용
			function skin(skinId){
				var skinLink = "";
				var skinCss = document.getElementById("skinCss");
				var mainFrame = window.parent.document.getElementById("mainFrame").contentWindow;
				var mainSkinCss = mainFrame.document.getElementById("mainSkinCss");
				var notiFrame = window.parent.document.getElementById("iframeNoti").contentWindow;
				var notiSkinCss = notiFrame.document.getElementById("notiSkinCss");
				var themeId = mainFrame.document.querySelector(".mainbg");

				if(skinCss){
					skinCss.href = skinId ? "/css/ezPortal/skin_" + skinId + ".css" : "";
				} else {
					skinLink = document.createElement("link");
					skinLink.id = "skinCss";
					skinLink.rel = "stylesheet";
					skinLink.href = skinId ? "/css/ezPortal/skin_" + skinId + ".css" : "";
					document.head.appendChild(skinLink);
				}

				if(mainSkinCss){
					mainSkinCss.href = skinId ? "/css/ezPortal/skin_" + skinId + ".css" : "";
				} else {
					skinLink = document.createElement("link");
					skinLink.id = "mainSkinCss";
					skinLink.rel = "stylesheet";
					skinLink.href = skinId ? "/css/ezPortal/skin_" + skinId + ".css" : "";
					mainFrame.document.head.appendChild(skinLink);
				}

				if(notiSkinCss){
					notiSkinCss.href = skinId ? "/css/ezPortal/skin_" + skinId + ".css" : "";
				} else {
					skinLink = document.createElement("link");
					skinLink.id = "notiSkinCss";
					skinLink.rel = "stylesheet";
					skinLink.href = skinId ? "/css/ezPortal/skin_" + skinId + ".css" : "";
					notiFrame.document.head.appendChild(skinLink);
				}

				if (mainFrame.document.getElementsByName("left")[0]) {
					var leftFrame = mainFrame.document.getElementsByName("left")[0].contentWindow;
					var leftSkinCss = leftFrame.document.getElementById("leftSkinCss");
	
					if(leftSkinCss){
						leftSkinCss.href = skinId ? "/css/ezPortal/skin_" + skinId + ".css" : "";
					} else {
						skinLink = document.createElement("link");
						skinLink.id = "leftSkinCss";
						skinLink.rel = "stylesheet";
						skinLink.href = skinId ? "/css/ezPortal/skin_" + skinId + ".css" : "";
						leftFrame.document.head.appendChild(skinLink);
					}
				}
				
				if (mainFrame.document.getElementsByName("right")[0]) {
					var rightFrame = mainFrame.document.getElementsByName("right")[0].contentWindow;
					var rightSkinCss = rightFrame.document.getElementById("rightSkinCss");
	
					if(rightSkinCss){
						rightSkinCss.href = skinId ? "/css/ezPortal/skin_" + skinId + ".css" : "";
					} else {
						skinLink = document.createElement("link");
						skinLink.id = "rightSkinCss";
						skinLink.rel = "stylesheet";
						skinLink.href = skinId ? "/css/ezPortal/skin_" + skinId + ".css" : "";
						rightFrame.document.head.appendChild(skinLink);
					}
				}
			}
			
		</script>
	</head>
	<body>
		<%-- ui 확인용 버튼(추후 삭제 예정)-조기완 --%>
		<div class="skin_test" style="position:absolute; left:50%; top:0; transform:translateX(-50%); z-index:10000; user-select:none; display:none;">
			<span style="float:left; font-size:16px; line-height:58px; color:royalblue; cursor:pointer; margin-right:10px;" onclick="skin('');">기본</span>
			<span style="float:left; font-size:16px; line-height:58px; color:royalblue; cursor:pointer; margin-right:10px;" onclick="skin('dark');">다크</span>
			<span style="float:left; font-size:16px; line-height:58px; color:royalblue; cursor:pointer; margin-right:10px;" onclick="skin('blue');">블루</span>
			<span style="float:left; font-size:16px; line-height:58px; color:royalblue; cursor:pointer;" onclick="skin('red');">레드</span>
		</div>
		<header id="top"></header>
		<div class="lnb">
			<ul id="mainMenuListLeft">
			</ul>
			<div class="lnb_menu_all" id="menuAllContainer">
	            <div class="lnb_menu_setting" id="menuSettingElem"<c:if test="${packageType eq 'mail'}"> style = "display:none"</c:if>>
	                <div class="menu_set" id="editBtn">
	                    <p><spring:message code="ezNewPortal.topMenu.hth09" /></p>
	                </div>

	                <div class="set_btn" id="editMenuBtn">
	                    <span id="editMenuSave"><spring:message code="ezNewPortal.t002" /></span><span id="editMenuCancel"><spring:message code="ezNewPortal.t001" /></span>
	                </div>
	            </div>
	            <ul id="menuListAll" class="menu_list_all">
	         	</ul>
	         </div>
	         
		</div>
		<c:if test="${useActiveX == 'YES'}">
			<script type="text/javascript">
				ezIcd_ActiveX("i_icd2");
			</script>
			<iframe id="if_Progress" src="/admin/ezApprovalG/progressAdmin.do?" style="display: none;"></iframe>
		</c:if>

		<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;display:none;" id="progressPanel">&nbsp;</div>
	<script type="text/javascript">
		var connectMenuId = -1; // 웹페이지 연계메뉴는 -1로 고정
		var maxMenuCount = 7;
		// 상단 메뉴시 화면 작아질시 좌측으로 이동 함수 start(테스트용/UIUX-조기완)
		/* function calcWidth(obj){
			var totalWidth = 0;
			$(obj).each(function(){
				totalWidth += $(this).outerWidth(true);
			})
			return totalWidth;
		}

		function gnbChange(){
			var windowWidth = $(window).outerWidth(true);
			var leftWidth = calcWidth(".topmenulayout > .contentlayout_left");
			var rightWidth = calcWidth(".topmenulayout > .contentlayout_right");
			var contWidth = windowWidth - leftWidth - rightWidth;
			var gnbWidth = calcWidth(".topNavCls li");

			if(gnbWidth > contWidth){
				$(window.parent.document).find("#mainFrame").addClass("active");
				$(".contentlayout_none").css("visibility","hidden");
			} else{
				$(window.parent.document).find("#mainFrame").removeClass("active");
				$(".contentlayout_none").css("visibility","visible");
			}
		}

		$(window).resize(function(){
			gnbChange();
		}) */
		// 상단 메뉴시 화면 작아질시 좌측으로 이동 함수 end

		var menuDisplayMode = '<c:out value="${menuDisplayMode}"/>';
		var userLang = '<c:out value="${lang}"/>';
		var userPrimary = '<c:out value="${primary}"/>';
		var userPhotoSrc = '<c:out value="${userPhoto}"/>';
		var primaryLang = '<c:out value="${primaryLang}"/>';
		
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
				str += '	<img src="${logoUrl}" id="logoUrl" style="cursor:pointer; height:42px; margin-top:9px;">';
				str += '</div>';
				
			return str;
		}
		
		// 전자설문 팝업 인덱스
		var surveyPopupIndex;
		
		// 메인메뉴 조합하는 함수
		var setMainMenuList = function (reData) {
			var menuList;

			if(reData === undefined) {
				menuList = newPortalTopMenu.menuListArr;
			} else {
				menuList = reData;
			}
			
			removeAllChildernElem(document.getElementById('mainMenuList'));
			removeAllChildernElem(document.getElementById('mainMenuListLeft'));
			
			var mainMenuElem = null;
			if (menuDisplayMode == "0") {
				mainMenuElem = document.getElementById('mainMenuList');
				document.getElementById('mainMenuListLeft').classList.remove("lnb_list");
			} else if (menuDisplayMode == "1") {
				mainMenuElem = document.getElementById('mainMenuListLeft');
				document.getElementById('mainMenuListLeft').classList.add("lnb_list");
			}
			
			var menuCount = 0;
			menuList.some(function (item, index) {
				if (item.menuId == connectMenuId) {
					return; //연계메뉴 표출 x
				}
				
				if (menuCount < maxMenuCount) { // 최대 7개 표출
					var menuLi = document.createElement('li');
					var mainFrame = window.parent.document.getElementById("mainFrame");
					menuLi.setAttribute("data-menu-id", item.menuId);
					if (menuDisplayMode == "0") { // 메뉴 top에 생성
						menuLi.setAttribute('id', 'menu_' + item.menuId);
						menuLi.textContent = item.menuName;
						mainFrame.style.width = "100%";
						mainFrame.style.float = "none";
						mainFrame.style.position = "static";
						
					} else if (menuDisplayMode == "1") {// 메뉴 left에 생성
						if (!!item.iconUrl && item.iconUrl.split(" ").length > 0) menuLi.classList.add(item.iconUrl.split(" ")[1] + "_leftmenu"); // 탑메뉴 아이콘과 구분하기 위해서 _leftmenu 추가
						menuLi.classList.add('sortable-item');
						menuLi.setAttribute('id', 'menu_' + item.menuId);
						var liSpan = document.createElement('span');
						liSpan.textContent = item.menuName;
						menuLi.appendChild(liSpan);
						mainFrame.style.width = "calc(100% - 81px)";
						mainFrame.style.float = "right";
						mainFrame.style.position = "relative"; // 이거 빼면 mainFrame 스크롤도 안되고 동작도 안됨.
					}
	
					menuLi.addEventListener('click', leftMainMecuClickEvent.bind(menuLi, item.menuUrl, item.openType));
					
					mainMenuElem.appendChild(menuLi);
					menuCount++;
				}
				// 메뉴리스트 객체 생성
				newPortalTopMenu.menuListObj['menu_'+ item.menuId] = {
					menuId: item.menuId,
					menuUrl: item.menuUrl,
					companyOrder: item.companyOrder,
					iconUrl: item.iconUrl,
					menuName: item.menuName,
				};
			});
		}
		
		function leftMainMecuClickEvent(menuUrl, openType) {
			offMenuAll();
			this.classList.add("on");
			subMenuClickEvent('off', menuUrl, openType);
			notice_all_close();
			closeNoti();
		}
		
		/* //포틀릿 및 프레임 환경설정 열기
		function ParentViewPortletEnv() {
			
			var feature = GetOpenPosition(760, 645);
			
//			DivPopUpShow($('body').prop('scrollWidth') * 0.9, 435, "/ezNewPortal/portletSetting.do", "",
//				"height = 435px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
			ParentDivPopUpShow(1000, 700, "/ezNewPortal/portletSetting.do", "",
				"height = 435px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);	
		}
		
		function ParentDivPopUpShow(popUpW, popUpH, URL) {
			//탑메뉴 이동 동작 연결
			var agent = navigator.userAgent.toLowerCase();

		    console.log("HI");
			if (agent.indexOf("msie") > -1 || agent.indexOf("trident") > -1) {
				// 익스플로러임
		        var Position = ParentDivPopUpPosition(popUpW, popUpH);
		        parent.frames["mainFrame"].document.getElementById("iFrameLayer").src = URL;
		        parent.frames["mainFrame"].document.getElementById("iFramePanel").style.top = Position[0] + "px";
		        parent.frames["mainFrame"].document.getElementById("iFramePanel").style.left = Position[1] + "px";
		        parent.frames["mainFrame"].document.getElementById("iFramePanel").style.height = popUpH + "px";
		        parent.frames["mainFrame"].document.getElementById("iFrameLayer").style.width = popUpW + "px";
		        parent.frames["mainFrame"].document.getElementById("iFrameLayer").style.height = popUpH + "px";
		        parent.frames["mainFrame"].document.getElementById("mailPanel").style.display = "";
		        parent.frames["mainFrame"].document.getElementById("iFramePanel").style.display = "";
		        
			} else {
				// 익스플로러 아님
		        var Position = ParentDivPopUpPosition(popUpW, popUpH);
		        parent.frames["mainFrame"].contentDocument.getElementById("iFrameLayer").src = URL;
		        parent.frames["mainFrame"].contentDocument.getElementById("iFramePanel").style.top = Position[0] + "px";
		        parent.frames["mainFrame"].contentDocument.getElementById("iFramePanel").style.left = Position[1] + "px";
		        parent.frames["mainFrame"].contentDocument.getElementById("iFramePanel").style.height = popUpH + "px";
		        parent.frames["mainFrame"].contentDocument.getElementById("iFrameLayer").style.width = popUpW + "px";
		        parent.frames["mainFrame"].contentDocument.getElementById("iFrameLayer").style.height = popUpH + "px";
		        parent.frames["mainFrame"].contentDocument.getElementById("mailPanel").style.display = "";
		        parent.frames["mainFrame"].contentDocument.getElementById("iFramePanel").style.display = "";
			}
		}
		
		function ParentDivPopUpPosition(popUpW, popUpH) {
		    var ReturnValue = new Array();
		    console.log("HI");
		    var agent = navigator.userAgent.toLowerCase();

			if (agent.indexOf("msie") > -1 || agent.indexOf("trident") > -1) {
				// 익스플로러임
			    var heigth = parent.frames["mainFrame"].document.documentElement.clientHeight;
				
			    if (heigth == 0) {
			    	heigth = parent.frames["mainFrame"].document.body.clientHeight;
			    }
			        

			    var width = parent.frames["mainFrame"].document.documentElement.clientWidth;
			    if (width == 0) {
			    	width = parent.frames["mainFrame"].document.body.clientWidth;
			    }

			    var left = 0;
			    var top = 0;
			    var pleftpos = parseInt(width) - popUpW;
			    heigth = parseInt(heigth) - popUpH;
			    width = parseInt(width) - pleftpos;
			    
			    if (heigth < (popUpH + 50)) {
			    	ReturnValue[0] = (heigth / 2);
			    } else {
			    	ReturnValue[0] = (heigth / 2) - 50;
			    }
			    
			    ReturnValue[1] = pleftpos / 2;
			} else {
				// 익스플로러 아님
			    var heigth = parent.frames["mainFrame"].contentDocument.documentElement.clientHeight;
				
			    if (heigth == 0) {
			    	heigth = document.body.clientHeight;
			    }
			    
			    var width = parent.frames["mainFrame"].contentDocument.documentElement.clientWidth;
			    
			    if (width == 0) {
			    	width = parent.frames["mainFrame"].contentDocument.body.clientWidth;
			    }

			    var left = 0;
			    var top = 0;
			    var pleftpos;
			    pleftpos = parseInt(width) - popUpW;
			    heigth = parseInt(heigth) - popUpH;
			    width = parseInt(width) - pleftpos;
			    if (heigth < (popUpH + 50))
			        ReturnValue[0] = (heigth / 2);
			    else
			        ReturnValue[0] = (heigth / 2) - 50;
			    ReturnValue[1] = pleftpos / 2;
			}
		    return ReturnValue
		} */
		
		// 메인메뉴 설정
		var setMainMenu = function () {
			
			var str = '';
			
				str += '<ul class="contentlayout topmenu">';
				//str += '<li class="contentlayout_none" style="margin:0 auto">';
				str += '<li class="contentlayout_none">';
				//str += '<nav id="topNav" class="topNavCls" tyle="max-width:1102px;">';
				str += '<nav id="topNav" class="topNavCls">';
				str += '<ul class="navUL" id="mainMenuList">';
				str += '</ul>';
				str += '</nav>';
				str += '</li>';
				str += '</ul>';

			return str;
		}
		
		// 헤더 세팅
		var setTopMenu = function () {
			var str = '';
				str += '<ul class="contentlayout topmenulayout">';
				str += '	<li class="contentlayout_left"><div class="total_menu"><span onclick="toggleAllMenu()"></span></div></li>';
				str += '	<li class="contentlayout_left">';
				str += setLogo();
				str += '	</li>';
				str += '	<li class="contentlayout_right">';
				str += setUtilMenu();
				str += '	</li>';
				if ('${useTotalSearch}' === 'YES') {
					str += '<li class="contentlayout_right"><div class="employee_search"><input type="text" placeholder="<spring:message code="main.t00029" />" id="topsearch_btn"><span class="totalSearchBtn1" onclick="toggleTopSearch()"></span><span class="totalSearchBtn2" onclick="totalSearch()"></span></div></li>' 
				}
				str += '	<li class="contentlayout_none topMenuBtnsOn" onclick="subMenuClickEvent(\'off\')">';
				str += setMainMenu();
				str += '	</li>';
				str += '</ul>';		
			
			document.getElementById('top').innerHTML = str;
		}
		
		// window.open 이벤트 처리하기
		var setEvent = function (id, url, location, option) {
			var element = document.getElementById(id);
			element.addEventListener('click', function () {
				closeNoti(); // 통합알림창 닫기
				// 메뉴이동 외의 로고 클릭의 경우도 탑 메뉴 항목 off를 위해 분기 추가 함.
				if (id == 'logoUrl') {
					offMenuAll();
					subMenuClickEvent('off');
					window.open(url, location, option);
				} else if (id == 'util_logout') {
			        subMenuClickEvent('off');
			        self.top.location.href = url;
			    } else if (id != 'util_employee_search' && id != 'util_admin' && id != 'util_set') {
			    	offMenuAll();
					subMenuClickEvent('off', url);
				} else {
					subMenuClickEvent('off');
					window.open(url, location, option);
				}				
			});				
		}

		//20250513 : 김진홍 : 챗봇 호출기능 추가
		var openChatbotUi = function(){
			if (!parent.document.getElementById("wrapAIbox").classList.contains("active")) {
				parent.document.getElementById("wrapAIbox").classList.add("active");
			}
		}
		
		// 유틸메뉴 설정
		var setUtilMenu = function () {
			var str = '';
				str += '<ul class="util">';
				//str += '<ul class="util"><li id="listSwitch" style="display: flex;align-items: center;">';
				if ('${packageType}' === 'mail' && '${lastLogin}' != '') {	// 20200326 조진호 - 패키지 타입이 메일 일 때 최종 접속 로그인 시간과 ip를 탑메뉴 상단에 표시
					str += '<li><span style="font-family: 돋움; font-size: 13px; font-weight: bold; color: #333; display: inline-block; margin-top: 17px; width: 111px;" title="' + '<spring:message code="ezSystem.x0025" />(<spring:message code="ezSystem.x0024" />)' + '">' + '${lastLogin} (' + '${loginIP})' + '</span></li>';
				}
								
				//20250513 : 김진홍 : 메인화면 챗봇버튼 추가
				if(useAI == "Y"){
					str += '<li><span class="util_aiToolbar" id="util_aiToolbar" onclick="openChatbotUi();">AI 도구</span></li>';
				}

				if ('${useUtilTalk}' === 'YES') str += '<li><span class="icon_topmenu util_messenger" id="util_messenger" title="' + '<spring:message code="ezNewPortal.kje01" />' + '"></span></li>'; // 메신저 다운로드 추가
				if ('${roleInfo}' === 'admin') str += '<li><span class="util_admin" id="util_admin" title="' + '<spring:message code="ezNewPortal.t004" />' + '"></span></li>';
				str += '<li><span class="util_employee_search" id="util_employee_search" title="' + '<spring:message code="ezNewPortal.t005" />' + '"></span></li>';
				/* str += '<li><span class="icon_topmenu util_frame" id="util_frame" title="프레임설정"></span></li>'; */
			    /* 2023-08-29 - 민지수 포탈 > 탑메뉴 > 다국어 > ? 아이콘 클릭시 영어매뉴얼 다운로드 되도록 수정 */
				if ('${lang}' != '2') str += '<li style="display :none;"><span class="util_help" id="util_help" title="' + '<spring:message code="ezNewPortal.t007" />' + '"></span></li>';
				if ('${lang}' == '2') str += '<li><a href="<%= request.getContextPath() %>/files/QST User Guide.pptx"><span class="icon_topmenu util_help" id="util_help" title="' + '<spring:message code="ezNewPortal.t007" />' + '">'+'</span></a></li>';
				
				// 통합알림
				str += '<li id="util_noti"><span class="util_alarm" title="' + '<spring:message code="ezPortal.notification.hth01" />"' + ' onclick="toggleNoti()"><span id="notiin"></span></span></li>';
				// 퀵메뉴
				str += '<li><span class="util_quick_menu" id="util_quickmenu" title="<spring:message code="ezPersonal.khj1" />"></span>';
                str += '<div class="quick_menu_list util_div_menu" id="quickMenuContainer"><p><spring:message code="ezPersonal.khj1" /></p><ul id="quickMenuList"></ul></div></li>';
                
                // 프로필 정보
			    str += '<li><span class="util_profile" id="util_profile">';
			    if (userPhotoSrc != "") {
				    str += '<img src="' + '/ezCommon/downloadAttach.do?filePath=' + userPhotoSrc + '"></span>';
			    } else {
				    str += '<img src="/images/ezNewPortal/info_pic_none.png"></span>';
			    }
			    
			    str += '<div class="profile_div util_div_menu" id="profileContainer"><div class="btn_tab"><span class="set" id="util_set"><spring:message code="ezNewPortal.t006" /></span>';
				if(primaryLang == 1) {
					str	+= '<span class="help" onclick="openHelp();"><spring:message code="main.t00037" /></span>' ;
				}
				str	+= '<span class="logout" id="util_logout"><spring:message code="ezNewPortal.t008" /></span></div></div></li>';
				str += '</ul>';
			
			return str;
		}
		
		/* 통합검색 */
		var totalSearch = function () {
			var keyword = $("#topsearch_btn").val();
			//$("#input_totalSearch").val("");
// 			OpenWindow(event, "/ezPortal/totalSearch.do?keyword=" + encodeURIComponent(keyword) , "main", "");
            parent.document.querySelector("iframe[name=main]").src = "/ezPortal/totalSearch.do?keyword=" + encodeURIComponent(keyword);
		}
		
		var deleteTotalSearchValue = function () {
			$("#input_totalSearch").val("");
		}
		
		function totalSearch_key_event(e,obj) {
		    var curevent = (typeof event == 'undefined' ? e : event);
		        if (curevent.keyCode == "13" || event.key == 'Enter') {
		            totalSearch();
		        }
		}
		
		//2019-09-20 메신저 다운로드 추가
		var talkDowmClick = function () {
			// 20211102 조진호 - 경기대학교 웹취약점(모의해킹) 체크 결과에 따른 조치. 기존 filePath는 get parameter로 받아와 경로가 보였지만 이 부분을 서버에서 처리하는 방식으로 수정
			AttachDownFrame.location.href = "/ezCommon/talkDownloadAttach.do";				
		}
		
		/* 2019-01-04 김민성 - 웹도움말 팝업창으로 변경 */
		var helpDetail = function () {
			var height = window.screen.availHeight;
			var width = window.screen.availWidth;
			var top = (height - 800) / 2;
			var left = (width - 1560) / 2;
			var url = '/ezNewPortal/help/index.do';
			var option = 'height=800px,width=1560px,top=' + top + ',left = ' + left + 'status = no, toolbar=no, menubar=no, location=no, resizable=1';
			
			window.open(url, "", option);
		}

		/* 2021-04-21 김정언 - (#76684) 직원조회 창 클릭 > 직원조회창 중앙에 뜨도록 수정 */
		var employeeSearch = function () {
			var height = window.screen.availHeight;
			var width = window.screen.availWidth;
			var top = (height - 670) / 2;
			var left = (width - 750) / 2;
			var url = '/ezPersonal/personSearch.do';
			var option = 'height=670px,width=750px,top=' + top + ',left = ' + left + ',status = no, toolbar=no, menubar=no, location=no, resizable=0';
			
			window.open(url, "", option);
		}
		
		// 유틸메뉴 이벤트 모아둔 곳
		var setUtilEvent = function () {
			setEvent('logoUrl', '${logoMainUrl}', 'main' ,'');
			if('${roleInfo}' === 'admin') {
				setEvent('util_admin', '${utilAdminUrl}', '' ,'');	
			}
			setEvent('util_employee_search', '/ezPersonal/personSearch.do', '' ,'height=670px,width=750px,top=' + (window.screen.availHeight - 670)/2 + ',left= ' + (window.screen.availWidth - 750) / 2 + ',status = no, toolbar=no, menubar=no,location=no, resizable=0');
			//document.getElementById("util_employee_search").addEventListener('click', employeeSearch );
			setEvent('util_set', '/ezPortal/environmentMain.do', 'main' ,'');
			//setEvent('util_help', '/ezPortal/help/help.do', 'helpWindow', 'height=700px,width=1000px, status = no, toolbar=no, menubar=no, location=no, resizable=0');
			//setEvent('util_help', '/ezNewPortal/help/index.do', 'helpWindow', 'height=700px,width=1000px, status = no, toolbar=no, menubar=no, location=no, resizable=0');
			setEvent('util_logout', '/user/login/actionLogout.do', 'top', '');

			/* 2023-08-29 - 민지수 포탈 > 탑메뉴 > 다국어 > ? 아이콘 클릭시 영어매뉴얼 다운로드 되도록 수정 */
			if ('${lang}' != '2') {
				document.getElementById("util_help").addEventListener('click', helpDetail);
			}

			if ('${useUtilTalk}' === 'YES') {
				document.getElementById("util_messenger").addEventListener('click', talkDowmClick );	
			}
			/* document.getElementById("util_frmae").addEventListener("click", viewPortletEnv); */
			/*통합검색*/
			if ('${useTotalSearch}' === 'YES') {				
				document.getElementById("topsearch_btn").addEventListener("keydown", totalSearch_key_event);
			}
			
			document.querySelector('#util_quickmenu').addEventListener("click", function() {toggleDivMenu(document.querySelector('#quickMenuContainer'))});
			document.querySelector('#util_profile').addEventListener("click", function() {toggleDivMenu(document.querySelector('#profileContainer'))});
		}

		function openHelp(){
			helpDetail();
			toggleDivMenu(document.querySelector('#profileContainer'))
		}


		/* //포틀릿 및 프레임 환경설정 열기
		function viewPortletEnv() {
			
			var feature = GetOpenPosition(760, 645);
			
			
			//탑메뉴 이동 동작 연결
			var agent = navigator.userAgent.toLowerCase();

			if (agent.indexOf("msie") > -1 || agent.indexOf("trident") > -1) {
				// 익스플로러임
				parent.frames["topFrame"].document.getElementById("iFrameLayer").addEventListener("click", viewPortletEnv);
			} else {
				// 익스플로러 아님
				parent.frames["topFrame"].contentDocument.getElementById("util_frame").addEventListener("click", viewPortletEnv);
			}
			
			DivPopUpShow(1000, 700, "/ezNewPortal/portletSetting.do", "",
				"height = 435px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);	
		} */
		
		// 확장버튼 UI 이벤트 함수
		var subMenuClickEvent = function (type, menuUrl, openType) {
			if(type === 'on') {
				toggleAllMenu(type);
				
			} else if (type === 'off') {
				toggleAllMenu(type);
				toggleDivMenu(document.querySelector('#quickMenuContainer') ,type);
				toggleDivMenu(document.querySelector('#profileContainer') ,type);
				closeNoti(); // 통합알림 팝업창 닫기

				if (openType == 1) {
					window.open(menuUrl, '_blank');
				} else if (openType == 2) {
					window.open(menuUrl, '_blank', 'width=1000,height=900');
				} else if (openType == 3) {
                    parent.document.querySelector("iframe[name=main]").src = menuUrl;
				}

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

			removeAllChildernElem(document.getElementById('menuListAll'));
			
			var menuCount = 1;
			for (var i = 0; i < menuList.length; i++) {
				if (menuCount == 8) {
					var menuResetBtn = document.createElement('li');
					var menuResetBtnSpan = document.createElement('span');
					menuResetBtnSpan.textContent = '<spring:message code="ezNewPortal.topMenu.hth08" />';
					menuResetBtn.appendChild(menuResetBtnSpan);
					menuResetBtn.setAttribute("id", "menuResetting");
					menuResetBtn.classList.add("icon_nav_menuset_leftmenu");
					menuResetBtn.addEventListener('click', menuReset);
					document.getElementById('menuListAll').appendChild(menuResetBtn);
					menuCount++;
					i--;
					continue;
				}
				
				var item = menuList[i];
				if (item.menuId == connectMenuId) {
					continue; //연계메뉴 표출 x
				}
				// 컨텍스트메뉴와 연동하기 위함.
				if(item.menuUrl.indexOf('ezMemo') > -1 && item.menuUsed) {
					parent.useMemoContextMenu = true;
				}
				
				var menuAllList = document.createElement('li');
				var menuAllListSpan = document.createElement('span');
				menuAllListSpan.textContent = item.menuName;
				menuAllList.appendChild(menuAllListSpan);
				menuAllList.setAttribute("id", item.menuId);
				menuAllList.setAttribute("data-menu-id", item.menuId);
				if (!!item.iconUrl && item.iconUrl.split(" ").length > 0)  menuAllList.classList.add(item.iconUrl.split(" ")[1] + "_leftmenu");
				menuAllList.classList.add('sortable-item');
				
				if (menuCount <= maxMenuCount) {
					menuAllList.classList.add('on');
					menuAllList.classList.add('menu-icon');
				}
				
				menuAllList.addEventListener('click', expandMenuClickEvent.bind(menuAllList, item.menuUrl, item.openType));
				
				document.getElementById('menuListAll').appendChild(menuAllList);
				//str += '<li id="'+item.menuId+'" data-companyorder='+ item.companyOrder +'><dl class="full_menu_toggleDL"><dt><span class="'+ item.iconUrl +'"></span></dt><dd>'+ ConvertCharToEntityReference(item.menuName) +'</dd></dl></li>';
				
				menuCount++;
			}

			if(packageType != 'mail'){
			    //  메뉴 개수가 8개보다 작아서 메뉴정렬 버튼이 표출되지 않는 경우, 마지막에 버튼 추가
                if (menuList.length <= maxMenuCount) {
                    var menuResetBtn = document.createElement('li');
                    var menuResetBtnSpan = document.createElement('span');
                    menuResetBtnSpan.textContent = '<spring:message code="ezNewPortal.topMenu.hth08" />';
                    menuResetBtn.appendChild(menuResetBtnSpan);
                    menuResetBtn.setAttribute("id", "menuResetting");
                    menuResetBtn.classList.add("icon_nav_menuset_leftmenu");
                    menuResetBtn.addEventListener('click', menuReset);
                    document.getElementById('menuListAll').appendChild(menuResetBtn);
                }
			}
		}
		
		function expandMenuClickEvent(menuUrl, menuOpenType) {
			offMenuAll();
			var menuId = this.getAttribute("id");
			if (!!document.getElementById("menu_" + menuId)) {
				document.getElementById("menu_" + menuId).classList.add("on");
			}
			subMenuClickEvent('off', menuUrl, menuOpenType);
			notice_all_close();
		}
		
		
		var menuReset = function () {
			HTMLCollection.prototype.forEach = Array.prototype.forEach;
			$('#menuListAll li').removeClass("on");							
			$("#menuListAll .sortable-item").draggable({
			    revert: "invalid",
			    containment: "parent",
			    zIndex: 100,
			    start: function (event, ui) {
			    	var dragElem = $(this);
			    	dragElem.css({
			    		"cursor": "move",
			    		"opacity": "0.6"
			    	});
			    },
			    snap:'#menuListAll li',
			    stop : function(event, ui) {
			    	var dragElem = $(this);
			    	dragElem.css({
			    		"cursor": "pointer",
			    		"opacity": ""
			    	});
			    },
			    helper : "clone"
			});
			  
			$("#menuListAll .sortable-item").droppable({
			    tolerance: "intersect",
			    drop: function(event, ui) {
				var dragElem = ui.draggable;
				var dropElem = $(this);
				changePosition(dragElem, dropElem);
				if(newPortalTopMenu.isInitOrder === true) {
					newPortalTopMenu.isInitOrder = false;
				}
			  }
			});
			
			var sortedMenu = document.getElementById('menuListAll');
			sortedMenu.className = 'full_menu_toggleUL_edit';

			// 하단 메뉴 변경
			var editMenuBtn = document.getElementById('editMenuBtn');
			document.getElementById("editBtn").style.display = "none";
			editMenuBtn.style.display = 'block';
            $("#menuAllContainer ul").addClass("active");
		}
		
		// 확장메뉴 버튼에서 나오는 메뉴리스트 및 이벤트
		var setExpandMenuListEvent = function () {

			setExpandMenuList(); // 확장메뉴 리스트
			
			// 취소버튼
			var editMenuCancel = document.getElementById('editMenuCancel');
			editMenuCancel.addEventListener('click', function() {
				document.getElementById("editBtn").style.display = "block";
				document.getElementById('editMenuBtn').style.display = 'none';
				$("#menuAllContainer ul").removeClass("active");
				
				var sortedMenu = document.getElementById('menuListAll');
				sortedMenu.className = 'full_menu_toggleUL';
				
				$('#menuListAll').sortable();
				$('#menuListAll').sortable("option", "disabled", true);
				
				// 취소하면 버튼 처음으로 재정렬
				setExpandMenuList();
			});
			
			// 저장버튼
			var editMenuSave = document.getElementById('editMenuSave');
			editMenuSave.addEventListener('click', function() {
				document.getElementById("editBtn").style.display = "block";
				document.getElementById('editMenuBtn').style = 'none';
				$("#menuAllContainer ul").removeClass("active");
				 
				var menuListAll = document.getElementById('menuListAll');
				menuListAll.className = 'full_menu_toggleUL';
				
				$('#menuListAll .sortable-item').draggable("disable");
				$('#menuListAll .sortable-item').droppable("disable");
				
				HTMLCollection.prototype.forEach = Array.prototype.forEach;
				var sortedMenu = document.getElementById('menuListAll').getElementsByClassName('sortable-item');
				
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
						subMenuClickEvent('off');
					} else {
						console.error(xhr.responseText);
					}
				};
				
				// 메뉴 순서 초기화 버튼인 경우 아닌 경우 
				if (newPortalTopMenu.isInitOrder) {
					xhr.open('POST', '/ezNewPortal/deleteUserMenuOrder.do');
					xhr.send();
				} else {
					xhr.open('POST', '/ezNewPortal/updateUserMenuOrder.do');
					xhr.setRequestHeader('Content-Type', 'application/json');
					xhr.send(JSON.stringify({
						data: orderObj,
					}));					
				}
				
			});			
		}
		
		function changePosition(dragElem, dropElem) {
			var menuListAllChildren = $("#menuListAll li");
			var dragElemIndex = menuListAllChildren.index(dragElem);
			var dropElemIndex = menuListAllChildren.index(dropElem);
			var menuListAll = $('#menuListAll');
			
			dragElem.insertAfter(menuListAll.children().eq(dropElemIndex));
			if (dragElemIndex > dropElemIndex) {
				dropElem.insertAfter(menuListAll.children().eq(dragElemIndex));
			} else {
				if (dragElemIndex - 1 < 0) {
					dropElem.insertBefore(menuListAll.children().eq(0));
				} else {
					dropElem.insertAfter(menuListAll.children().eq(dragElemIndex - 1));
				}
			}
			
			dragElem.css({
				left: '0',
			    top: '0'
			});
			
			dropElem.css({
				left: '0',
			    top: '0'
		    });
		}
		
		// 메뉴 리스트의 사이즈 구하기
		var getMenuListWidth = function () {
			if (menuDisplayMode != "0") {
				return;
			}
			
			var elements = document.getElementById('mainMenuList').childNodes;
 			Array.prototype.forEach.call(elements, function (item, index) {
 				newPortalTopMenu.menuWidth[index] = item.offsetWidth;
			});	
		}
		
		var getSurveyPopupList = function() {
			var returnObj = {};
			
			$.ajax({
				type: "GET",
				url: "/ezSurvey/getSurveyPopupItems.do",
				data: {
					mode: 'popup'
				},
				dataType: "JSON",
				async: false,
				cache: false,
				success : function(data) {
					
					if (data.surveyPopupList === undefined) {
						returnObj.surveyPopupList = [];	
					} else {
						returnObj.surveyPopupList = data.surveyPopupList;
					}
					
					returnObj.userId = data.userId;
				},
				error : function(error) {
					console.log(error);
					returnList = null;
				}
			});
			return returnObj;
		}
		
		var setLayer = function () {
			toggleAllMenu('off');
			var topFrame = parent.document.getElementById('topFrame');
			var bodyTag = document.getElementsByTagName('Body')[0];
			
			var screenHeight = screen.height;
			topFrame.style.position = 'relative';
			bodyTag.style.backgroundColor = 'rgba(0, 0, 0, 0.3)';
			
			if (menuDisplayMode == "1") {
				document.querySelector('#mainMenuListLeft').classList.add('layer');
				parent.document.getElementById('mainFrame').style.position = 'static';
				$('#mainMenuListLeft li').addClass("layer");
			}
			
			var popupArea = parent.document.getElementById("popupArea");
			popupArea.style.height = (screenHeight) + "px";
			popupArea.style.width = "100%";
			showProgress("notice");
		}
		
		var getNotiPopup = function () {
			var notiList = JSON.parse('${popupNotiList}');
			var position0Count = 0;
			var position1Count = 0;
			var position2Count = 0;
			var position3Count = 0;
			var position4Count = 0;
			var position5Count = 0;
			var position6Count = 0;
			
			if (notiList != null && notiList.length != 0) {
				for (var i = 0; i < notiList.length; i++) {
					var notiInfo = notiList[i];
					var index = 0;
					var wPosition = notiInfo.position;
					
					if (wPosition == 0) {
						index = ++position0Count;
					} else if (wPosition == 1) {
						index = ++position1Count;
					} else if (wPosition == 2) {
						index = ++position2Count;
					} else if (wPosition == 3) {
						index = ++position3Count;
					} else if (wPosition == 4) {
						index = ++position4Count;
					} else if (wPosition == 5) {
						index = ++position5Count;
					} else if (wPosition == 6) {
						index = ++position6Count;
					} else {
						idex = i;
					}
					
					openNotiPopup(notiInfo.itemSeq, notiInfo.width, notiInfo.height, notiInfo.position, index);
					setLayer();
				} 
				var surveyPopupObj = getSurveyPopupList();
				if (surveyPopupObj.surveyPopupList.length > 0 && surveyPopupObj.surveyPopupList != null) {
					index = ++position0Count;
					surveyPopupIndex = index; 
					openSurveyPopup(surveyPopupObj, 600, 600, 0, index);
				}
				
			} else {
				var surveyPopupObj = getSurveyPopupList();
				if (surveyPopupObj.surveyPopupList.length > 0 && surveyPopupObj.surveyPopupList != null) {
					index = ++position0Count;
					surveyPopupIndex = index;
					openSurveyPopup(surveyPopupObj, 600, 600, 0, index);
				}
				
			}
			
		}
		
		//위치 지정하여 팝업 열기 --- 팝업 공지사항
		var openNotiPopup = function (popup_number, wWidth, wHeight, wPosition, index) {
		    var wVertical, wHorizontal;
		    
			if(wPosition == 0) {
				console.log(window.outerHeight);
		        wVertical = Math.floor(window.outerHeight/2) - (wHeight/2) - 56 + (index * 10);
		        wHorizontal = Math.floor(window.outerWidth/2) - (wWidth/2) + (index * 10);
		    } else if(wPosition == 1) {
		        wVertical = 100 + (index*10); 
		        wHorizontal = 100 + (index*10);
		    } else if(wPosition == 2) {
		        wVertical = window.outerHeight - wHeight - 100 + (index * 10); 
		        wHorizontal = 100 + (index * 10);
		    } else if(wPosition == 3) {
		        wVertical = 100 + (index * 10); 
		        wHorizontal = window.outerWidth - wWidth - 100 + (index * 10);
		    } else if(wPosition == 4) {
		        wVertical = window.outerHeight - wHeight - 100 + (index * 10); 
		        wHorizontal = window.outerWidth - wWidth - 100 + (index * 10);
		    } else if(wPosition == 5) {
		        wVertical = 100 + (index*10); 
		        wHorizontal = Math.floor(window.outerWidth/2) - (wWidth/2) + (index * 10);
		    } else if(wPosition == 6) {
		        wVertical = window.outerHeight - wHeight - 100 - (index * 10); 
		        wHorizontal = Math.floor(window.outerWidth/2) - (wWidth/2) + (index * 10);
		    } else {
		        wVertical = 0 + (index*10); 
		        wHorizontal = 0 + (index*10);
		    }

		    if(wVertical < 0)
		        wVertical = 0;

		    if(wHorizontal < 0)
		        wHorizontal = 0;

		    if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1)
		        wHeight = eval(wHeight) - 60;
 			
		    var request = new XMLHttpRequest();
		    request.open('POST', '/admin/ezPersonal/showLayerPopup.do');
		    request.setRequestHeader('Content-Type', 'application/json');
		    var resultHTML = "";
		    
		    request.onload = function () {
		    	if (request.status >= 200 && request.status < 400) {
		    		var result = JSON.parse(request.responseText);
		    		var wHeight = result.height;
		    		var wWidth = result.width;
		    		var wLeft = result.horizontal;
		    		var wTop = result.vertical;
		    		
		    		var popupDiv = document.createElement("div");
		    		popupDiv.id = "popup" + popup_number
		    		popupDiv.className = "popup_notice popup_type" + result.skinValue;
		    		
		    		var formElement = document.createElement("form");
		    		formElement.style.height = "100%";
		    		
		    		var layoutDiv = document.createElement("div");
		    		layoutDiv.className = "popup_noticeLayout";
		    		
		    		var titleDl = document.createElement("dl");
		    		titleDl.className = "popup_noticeTitle";
		    		
		    		var titleDt = document.createElement("dt");
		    		titleDt.className = "title_type" + result.skinValue;
		    		
		    		var titleDd = document.createElement("dd");
		    		titleDd.className = "name_type" + result.skinValue;
		    		titleDd.textContent = result.title;
		    		
		    		titleDl.appendChild(titleDt);
		    		titleDl.appendChild(titleDd);
		    		
		    		var contentDiv = document.createElement("div");
		    		contentDiv.className = "popup_noticeList";
		    		contentDiv.innerHTML = result.content;
		    		
		    		var btnDiv = document.createElement("div");
		    		btnDiv.className = "notice_btn";
		    		
		    		var btnPElem = document.createElement("p");
		    		btnPElem.className = "btn_checkbox";
		    		
		    		var checkInput = document.createElement("input");
		    		checkInput.type = "checkbox";
		    		checkInput.setAttribute("name", "checkbox");
		    		checkInput.className = "inp_noticeCheck";
		    		checkInput.id = "inp_noticeCheck" + popup_number;
		    		
		    		var labelElem = document.createElement("label");
		    		labelElem.className = "name_type" + result.skinValue;
		    		labelElem.setAttribute("for", "inp_noticeCheck");
		    		labelElem.textContent = "<spring:message code = 'ezPersonal.t267' />";
		    		
		    		var closePElem = document.createElement("p");
		    		closePElem.className = "notice_btnClose close_type" + result.skinValue;
		    		closePElem.id = "closeBtn" + popup_number;
		    		
		    		btnPElem.appendChild(checkInput);
		    		btnPElem.appendChild(labelElem);
		    		btnDiv.appendChild(btnPElem);
		    		
		    		layoutDiv.appendChild(titleDl);
		    		layoutDiv.appendChild(contentDiv);
		    		layoutDiv.appendChild(btnDiv);
		    		formElement.appendChild(layoutDiv);
		    		popupDiv.appendChild(closePElem);
		    		popupDiv.appendChild(formElement);
		    		/* resultHTML += "<div id='popup" + popup_number + "' class='popup_notice popup_type" + result.skinValue + "'>";
		    		resultHTML += "<form style='height:100%'>";
		    		resultHTML += "<div class='popup_noticeLayout'>";
		    		resultHTML += "<dl class='popup_noticeTitle'>";
		    		resultHTML += "<dt class='title_type" + result.skinValue + "'></dt>";
		    		resultHTML += "<dd class='name_type" + result.skinValue + "'>" + result.title + "</dd>";
		    		resultHTML += "</dl>";
		    		resultHTML += "<div class='popup_noticeList'>" + result.content + "</div>";
		    		resultHTML += "<div class='notice_btn'><p class='btn_checkbox'>";
		    		resultHTML += "<input type='checkbox' name='checkbox' class='inp_noticeCheck' id='inp_noticeCheck" + popup_number + "'/>";
		    		resultHTML += "<label class='name_type" + result.skinValue + "' for='inp_noticeCheck'><spring:message code = 'ezPersonal.t267' /></label></p>";
		    		resultHTML += '<p class="notice_btnClose close_type' + result.skinValue + '" id="closeBtn' + popup_number + '">&nbsp;</p>';
		    		resultHTML += "</div></div></form></div>";
		    		 */
		    		 
		    		//document.getElementById("popupArea").appendChild(popupDiv);
		    		parent.document.getElementById("popupArea").querySelector("#noticePopupLayer").appendChild(popupDiv);
		    		//$("#popupArea").append(resultHTML);
		    		
		    		parent.document.getElementById("popup" + popup_number).style.height = wHeight - 40 + "px";
		    		parent.document.getElementById("popup" + popup_number).style.width = wWidth - 40 + "px";
		    		parent.document.getElementById("popup" + popup_number).style.left = wLeft + "px";
		    		parent.document.getElementById("popup" + popup_number).style.top = wTop + "px";
		    		parent.document.getElementById("popup" + popup_number).style.zIndex = index + 1;
		    		parent.document.getElementById("popup" + popup_number).addEventListener("click", changeZIndex);
		    		parent.document.getElementById("inp_noticeCheck" + popup_number).addEventListener("change", function() {
		    			notice_close(popup_number, result.userId, "checkbox");
		    		});
		    		
		    		parent.document.getElementById("closeBtn" + popup_number).addEventListener("click", function() {
		    			notice_close(popup_number, result.userId, "btn");
		    		});
		    		
		    		var popupContent = parent.document.getElementById("popup" + popup_number).getElementsByClassName("popup_noticeList")[0];
		    		popupContent.style.height = parent.document.getElementById("popup" + popup_number).clientHeight - 175 + "px"; 
		    		
		    		parent.$("#popup" + popup_number).draggable({
						containment : parent.$("#popupArea"),
						cancel : parent.$(".popup_noticeList"),
						scroll: false 
					});
		    	}
		    }
		    
		    var data = JSON.stringify({
		    	height : wHeight,
		    	width : wWidth,
		        vertical : wVertical,
		        horizontal : wHorizontal,
		        itemSeq : popup_number
			});
			
			request.send(data);
		    /* window.open("/admin/ezPersonal/showPopup.do?itemSeq=" + popup_number + 
					"&answer=", "", "height=" + wHeight + "px,width=" + wWidth + "px, left=" + wHorizontal + "px, top=" + wVertical + "px, status = no, toolbar=no, menubar=no,location=no, resizable=0"); */
		}
		
		var changeZIndex = function () {
			var popupList = parent.document.getElementsByClassName("popup_notice");
			var popupListCount = popupList.length;
			var popupId = this.id;
			var popupZIndex = Number(this.style.zIndex);
			
			for (var i = 0; i < popupListCount; i++) {
				var popup = popupList[i];
				var compPopupZIndex = Number(popup.style.zIndex);
				
				if (popupZIndex <= compPopupZIndex) {
					popupZIndex = compPopupZIndex + 1;
				}
				
			}
			
			this.style.zIndex = popupZIndex;
		}
		
		//위치 지정하여 팝업 열기 --- 전자설문 팝업 공지사항
		var openSurveyPopup = function (surveyPopupObj, wWidth, wHeight, wPosition, index) {
			var surveyList;
			var userId;
			
		    var survPopoup = parent.document.getElementById('surv_popup');
		    if (survPopoup != null) {
 				var notipopup = parent.document.getElementById('noticePopupLayer');
 				notipopup.removeChild(survPopoup);
 			}
		    // 로그인 직후 설문 팝업 생성하는 경우
			if (surveyPopupObj !== "") {
				surveyList = surveyPopupObj.surveyPopupList;
				userId = surveyPopupObj.userId;
				
			// 유저가 설문 팝업에서 설문에 응한 경우
			} else {
				var surveyPopupObj = getSurveyPopupList();
				surveyList = surveyPopupObj.surveyPopupList;
				userId = surveyPopupObj.userId;
			}
			
		    var wVertical, wHorizontal;
		    
		    if(wPosition == 0) {
		        wVertical = Math.floor(window.outerHeight/2) - (wHeight/2) - 56 + (index * 10);
		        wHorizontal = Math.floor(window.outerWidth/2) - (wWidth/2) + (index * 10);
		    } else if(wPosition == 1) {
		        wVertical = 100 + (index*10); 
		        wHorizontal = 100 + (index*10);
		    } else if(wPosition == 2) {
		        wVertical = window.outerHeight - wHeight - 100 + (index * 10); 
		        wHorizontal = 100 + (index * 10);
		    } else if(wPosition == 3) {
		        wVertical = 100 + (index * 10); 
		        wHorizontal = window.outerWidth - wWidth - 100 + (index * 10);
		    } else if(wPosition == 4) {
		        wVertical = window.outerHeight - wHeight - 100 + (index * 10); 
		        wHorizontal = window.outerWidth - wWidth - 100 + (index * 10);
		    } else if(wPosition == 5) {
		        wVertical = 100 + (index*10); 
		        wHorizontal = Math.floor(window.outerWidth/2) - (wWidth/2) + (index * 10);
		    } else if(wPosition == 6) {
		        wVertical = window.outerHeight - wHeight - 100 - (index * 10); 
		        wHorizontal = Math.floor(window.outerWidth/2) - (wWidth/2) + (index * 10);
		    } else {
		        wVertical = 0 + (index*10); 
		        wHorizontal = 0 + (index*10);
		    }

		    if(wVertical < 0)
		        wVertical = 0;

		    if(wHorizontal < 0)
		        wHorizontal = 0;

		    if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1)
		        wHeight = eval(wHeight) - 60;
		    
    		var wLeft = wHorizontal;
    		
    		var wTop = wVertical;
    		
    		var popupDiv = document.createElement("div");
    		popupDiv.id = "surv_popup";
    		popupDiv.className = "popup_notice popup_type0";
    		surveyPopupDom = popupDiv;
    		
    		var formElement = document.createElement("form");
    		formElement.style.height = "100%";
    		
    		var layoutDiv = document.createElement("div");
    		layoutDiv.className = "popup_noticeLayout";
    		
    		var titleDl = document.createElement("dl");
    		titleDl.className = "popup_noticeTitle";
    		
    		var titleDt = document.createElement("dt");
    		titleDt.className = "title_type0";
    		
    		var titleDd = document.createElement("dd");
    		titleDd.className = "name_type0";
    		titleDd.textContent = "<spring:message code='ezSurvey.t01' />"; // 전자설문
    		
    		titleDl.appendChild(titleDt);
    		titleDl.appendChild(titleDd);
    		
    		var contentDiv = document.createElement("div");
    		contentDiv.className = "popup_noticeList";
    		
    		/* 테이블만들기 */
    		var oTable = document.createElement("TABLE");
    		oTable.className = "popuplist";
    		oTable.setAttribute("width" , "100%");
            var oTBody = document.createElement("TBODY");
            var oTr = document.createElement("TR");
            
            var oTh1 = document.createElement("TH");
            oTh1.setAttribute("style", "white-space:nowrap")
            oTh1.setAttribute("width", "350px")
            oTh1.innerHTML = "<spring:message code='ezSurvey.t23' />"; // 제목
            oTr.appendChild(oTh1);
            
            var oTh2 = document.createElement("TH");
            oTh2.setAttribute("style", "white-space:nowrap")
            oTh2.setAttribute("width", "60px")
            oTh2.innerHTML = "<spring:message code='ezSurvey.t24' />"; // 작성자
            oTr.appendChild(oTh2);
            
            var oTh3 = document.createElement("TH");
            oTh3.setAttribute("style", "white-space:nowrap")
            oTh3.setAttribute("width", "90px")
            oTh3.innerHTML = "<spring:message code='ezSurvey.t29' />"; // 종료일
            oTr.appendChild(oTh3);
            
            oTBody.appendChild(oTr);
            
            if (surveyList.length > 0) {
	            for (var i = 0; i < surveyList.length; i++) {
	            	var surveyInfo =  surveyList[i];
	            	
	            	if (surveyInfo.popupFlag === 1) {
		            	var oTr = document.createElement("TR");
		            	oTr.style.cursor = "pointer";
		            	oTr.setAttribute('surveyId', surveyInfo.surveyId); 
		            	oTr.addEventListener('click', function(event) { getDetailSurvey(event, this); }, false);
		            	
			            var oTd1 = document.createElement("TD");
			            oTd1.style.overflow = 'hidden';
			            oTd1.style.textOverflow = 'ellipsis';
			            oTd1.style.whiteSpace = 'nowrap';
			            oTd1.style.maxWidth  = '350px';
				        oTd1.innerHTML = surveyInfo.title;
			            oTr.appendChild(oTd1);
			            
			            var oTd2 = document.createElement("TD");
			            oTd2.style.overflow = 'hidden';
			            oTd2.style.textOverflow = 'ellipsis';
			            oTd2.style.whiteSpace = 'nowrap';
			            oTd2.style.maxWidth  = '60px';
				        oTd2.innerHTML = surveyInfo.creatorName;
			            oTr.appendChild(oTd2);
			            
			            var oTd3 = document.createElement("TD");
			            oTd3.style.overflow = 'hidden';
			            oTd3.style.textOverflow = 'ellipsis';
			            oTd3.style.whiteSpace = 'nowrap';
			            oTd3.style.maxWidth  = '90px';
				        oTd3.innerHTML = surveyInfo.endDate.substr(0, 10);
			            oTr.appendChild(oTd3);
			            
			            oTBody.appendChild(oTr);
	            	}
	            }
            } else {
            	var oTr = document.createElement("TR");
            	
            	var oTd1 = document.createElement("TD");
	            oTd1.style.overflow = 'hidden';
	            oTd1.style.textOverflow = 'ellipsis';
	            oTd1.style.whiteSpace = 'nowrap';
	            oTd1.style.maxWidth  = '500px';
	            oTd1.style.textAlign = 'center';
		        oTd1.innerHTML = SurveyMessages.strNoData;
		        oTd1.colSpan = 3;
	            oTr.appendChild(oTd1);
	            
	            oTBody.appendChild(oTr);
            }
            oTable.appendChild(oTBody);
            contentDiv.appendChild(oTable);
            
    		var btnDiv = document.createElement("div");
    		btnDiv.className = "notice_btn";
    		
    		var btnPElem = document.createElement("p");
    		btnPElem.className = "btn_checkbox";
    		
    		var checkInput = document.createElement("input");
    		checkInput.type = "checkbox";
    		checkInput.setAttribute("name", "checkbox");
    		checkInput.className = "inp_noticeCheck";
    		checkInput.id = "surv_inp_noticeCheck";
    		
    		var labelElem = document.createElement("label");
    		labelElem.className = "name_type0";
    		labelElem.setAttribute("for", "inp_noticeCheck");
    		labelElem.style.paddingLeft = "3px";
    		labelElem.textContent = "<spring:message code = 'ezPersonal.t267' />";
    		
    		var closePElem = document.createElement("p");
    		closePElem.className = "notice_btnClose close_type0";
    		closePElem.id = "surv_closeBtn";
    		
    		btnPElem.appendChild(checkInput);
    		btnPElem.appendChild(labelElem);
    		btnDiv.appendChild(btnPElem);
    		
    		layoutDiv.appendChild(titleDl);
    		layoutDiv.appendChild(contentDiv);
    		layoutDiv.appendChild(btnDiv);
    		formElement.appendChild(layoutDiv);
    		popupDiv.appendChild(closePElem);
    		popupDiv.appendChild(formElement);
    		 
    		parent.document.getElementById("popupArea").querySelector("#noticePopupLayer").appendChild(popupDiv);

			parent.document.getElementById("surv_popup").style.height = wHeight - 40 + "px";
			parent.document.getElementById("surv_popup").style.width = wWidth - 40 + "px";
			parent.document.getElementById("surv_popup").style.left = wLeft + "px";
			parent.document.getElementById("surv_popup").style.top = wTop + "px";
    		parent.document.getElementById("surv_popup").style.zIndex = index + 1;
    		parent.document.getElementById("surv_popup").addEventListener("click", changeZIndex);
    		parent.document.getElementById("surv_inp_noticeCheck").addEventListener("change", function() {
    			notice_close("surv_popup", userId, "checkbox");
    		});
    		
    		parent.document.getElementById("surv_closeBtn").addEventListener("click", function() {
    			notice_close("surv_popup", userId, "btn");
    		});
    		
    		var popupContent = parent.document.getElementById("surv_popup").getElementsByClassName("popup_noticeList")[0];
    		popupContent.style.height = parent.document.getElementById("surv_popup").clientHeight - 175 + "px"; 
    		
    		parent.$("#surv_popup").draggable({
				containment : parent.$("#popupArea"),
				cancel : parent.$(".popup_noticeList"),
				scroll: false 
			});
    		setLayer();
    		
		}
		
		var getDetailSurvey = function (event, thisEl) {
			event.stopPropagation();
			
			var surveyId = thisEl.getAttribute('surveyId');
			var heigth   = window.screen.availHeight;
			var width    = window.screen.availWidth;
			var left     = 0;
			var top      = 0;
			var pleftpos = parseInt(width) - 780;
			var heigth   = parseInt(heigth) - 750;
			var left     = pleftpos / 2;
			var top      = heigth / 2;
			
			var itemPopup;
			itemPopup = window.open("/ezSurvey/surveyDetail.do?itemId=" + surveyId, "fileDetail", "height = " + 750 + "px, width = " + 780 + "px, left=" + left + ", top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes");
		}
		
		var notice_close = function (popupId, userId, position) {
			var isChecked;			// 팝업 공지
			var isScheChecked;		// 일정 팝업
			var isSurvChecked;		// 설문 팝업
			
			if (parent.document.getElementById("inp_noticeCheck" + popupId)) {						// 팝업 공지
				isChecked = parent.document.getElementById("inp_noticeCheck" + popupId).checked;
			} else if (popupId === "" && parent.document.getElementById("sche_inp_noticeCheck")) {					// 일정 팝업
				isScheChecked = parent.document.getElementById("sche_inp_noticeCheck").checked;
			} else if (popupId === "surv_popup" && parent.document.getElementById("surv_inp_noticeCheck")) {					// 설문 팝업
				isSurvChecked = parent.document.getElementById("surv_inp_noticeCheck").checked;
			}
			
			if (isChecked) {
				setCookie("POPUP_" + popupId + "_" + userId, "1", 1); 
			} else if (isScheChecked) {
				setCookie("SCHE_POPUP_" + userId, "1", 1); 
			} else if (isSurvChecked) {
				setCookie("SURV_POPUP_" + userId, "1", 1); 
			}
			
			var popupList = parent.document.getElementsByClassName("popup_notice");
			
			var popup = parent.document.getElementById("popup" + popupId);
			var sche_popup = parent.document.getElementById("sche_popup");
			var surv_popup = parent.document.getElementById("surv_popup");
			
			if (popup) {
				popup.parentNode.removeChild(popup);
			} else if (popupId === "" && sche_popup) {
				sche_popup.parentNode.removeChild(sche_popup);
			} else if (popupId === "surv_popup" && surv_popup) {
				surv_popup.parentNode.removeChild(surv_popup);
			}
			
			if (popupList.length < 1) {
				hideProgress("notice");
				var topFrame = parent.document.getElementById('topFrame');
				document.getElementsByTagName("body")[0].style.backgroundColor = "";
				topFrame.style.position = "";
			}

			var userAgent = navigator.userAgent.toLowerCase();

			if (/iphone|ipod|ipad|android.*mobile/i.test(userAgent) || /tablet|ipad|android/i.test(userAgent) || navigator.maxTouchPoints > 4) {
				window.parent.fixLayout();
			}
		}
		
		var notice_all_close = function () {
			var popupList = parent.document.getElementsByClassName("popup_notice");
			var popupListCount = popupList.length;
			
			for (var i = 0; i < popupListCount; i++) {
				var popupId = popupList[0].id; 
				var popup = parent.document.getElementById(popupId);
				
				popup.parentNode.removeChild(popup);
			}
			
			if (menuDisplayMode == "1") {
				document.querySelector('#mainMenuListLeft').classList.remove('layer');
				parent.document.getElementById('mainFrame').style.position = 'relative';
				$('#mainMenuListLeft li').removeClass("layer");
			}
		}
		
		function setCookie(name, value, expiredays) {
			var todayDate = new Date();
			var expireDate = new Date(todayDate.getFullYear(), todayDate.getMonth(), todayDate.getDate(), 23, 59, 59);
			document.cookie = name + "=" + encodeURIComponent( value ) + "; path=/; expires=" + expireDate.toGMTString() + ";";
		}

		<%--function getCookie(Name) {
			var search = Name + "="
			if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면
				offset = document.cookie.indexOf(search)

				if (offset != -1) { // 쿠키가 존재하면
					offset += search.length
					// set index of beginning of value
					end = document.cookie.indexOf(";", offset);
					// 쿠키 값의 마지막 위치 인덱스 번호 설정
					if (end == -1)
						end = document.cookie.length
					return unescape(document.cookie.substring(offset, end))
				}
			}
		} --%>
		
		var officeBugPatch = function() {
		}
		
		var finish_download = function() {
			officeBugPatch();	
		}
		
		var getObject = function() {
			i_icd2.SetDocumentDisp(window.document);
			i_icd2.xmlURL = "http://" + document.location.hostname + ":" + location.port + "/ezNewPortal/componentListTransfer.do";
			i_icd2.CheckVersion();
			var nCount = i_icd2.nNeedDownload;

			if (nCount) {
				if_Progress.StartOn();
			} else {
				finish_download();
			}
		}
		
		var setUseActiveX = function() {
			var useActiveX = "<c:out value='${useActiveX}' />"
			
			if (useActiveX == 'YES') {
				var userAgent = window.navigator.userAgent;
				
				if ((/msie/i.test(userAgent)) || (/rv:11.0/i.test(userAgent))) {
					//한글기안기 사용일때는 ie9,10,11 전부 activeX 설치
					if (userAgent.indexOf("Trident/5.0") > 0 || userAgent.indexOf("Trident/6.0") > 0 || userAgent.indexOf("Trident/7.0") > 0) {
						getObject();
					}
				}
			}
		}
		
 		var newPortalTopMenuFunc = function () {
 			newPortalTopMenu.menuListArr = JSON.parse('${menuList}');
			setTopMenu();            // 헤더 전체 셋팅
			setMainMenuList();       // 메인메뉴 리스트 출력
			getQuickLink();		     // 퀵메뉴 리스트
			setProfile();            // 프로파일 메뉴 세팅 
			setUtilEvent();          // 유틸메뉴 이벤트 설정
			setExpandMenuListEvent();// 확장메뉴 이벤트 설정			
			getMenuListWidth();      // 메인메뉴 li별 사이즈 측정
			getNotiPopup();          // 팝업공지 불러오기
			if (parseInt(${pollingInterval}) > 0) {
				startPolling(${pollingInterval});
			}
		}
 		
 		var showProgress = function(position) {
 			if (position == "notice") {
				document.getElementById("progressPanel").style.height = "100%";
 				parent.document.getElementById("popupArea").style.display = "block";
 			} else {
 				document.getElementById("progressPanel").style.height = "100%";
 			}
 			
		    document.getElementById("progressPanel").style.display = "block";
		    document.getElementById("progressPanel").style.opacity = 0.5;
		    document.getElementById("progressPanel").style.background = "rgba(0,0,0,0.7)";
		}
        
        var hideProgress = function(area) {
        	document.getElementById("progressPanel").style.display = "none";
        	
        	if (area === "notice") {
        		parent.document.getElementById("popupArea").style.display = "none";
        	}
        	
        	if (menuDisplayMode == "1") {
				document.querySelector('#mainMenuListLeft').classList.remove('layer');
				parent.document.getElementById('mainFrame').style.position = 'relative';
				$('#mainMenuListLeft li').removeClass("layer");
			}
        }
        
        /* 2022-10-14 홍승비 - 상단 메뉴 확장버튼 클릭하여 body 전체에 회색 영역 표출 시, 상단 메뉴가 아닌 회색 영역을 클릭하는 경우 확장메뉴 숨김처리 */
      	$("body").click(function (e) {
      		// 클릭한 영역에 다른 태그가 없고 topBody 또는 contentlayout topmenulayout 클래스를 가지는 태그만이 존재한다면, 확장된 메뉴 이외의 회색 영역을 클릭한 것이므로 메뉴를 닫는다.
      		// 회색 영역이 아닌 상단 메뉴 영역을 클릭한 경우, 메뉴가 확장된 상태를 유지한다.
      		if ($(e.target).hasClass("topBody") || $(e.target).hasClass("contentlayout topmenulayout") || $(e.target).hasClass("dimLayerOpen")) {
      			subMenuClickEvent('off');
      		}
      	});

		<%-- function callAllUserTab() {
			$.ajax({
				type: "GET",
				url: "/ezNewPortal/allUserTab.do",
				dataType: "JSON",
				success : function(data) {
					makeAllUserTab(data);
				}
			});
		}

		function makeAllUserTab(json) {
			var switchUserCompany = "<c:out value='${switchUserCompany}' />"

			if (switchUserCompany !== "Y") return;

			var list = document.createElement("li");
			list.className = "contentlayout_right";

			var select = document.createElement("select");
			select.id = "switchUser";
			select.style.height = "54px";
			select.style.padding = "0 6px";
			list.append(select);

			for (var i = 0; i < json.length; i++) {
				var option = document.createElement("option");
				option.setAttribute("data-dept", json[i].deptId);
				option.setAttribute("data-company", json[i].companyId);
				option.setAttribute("data-job", json[i].jobId);
				option.value = json[i].companyId;
				option.text = json[i].companyName + " (" + json[i].deptName + " " + json[i].title + ")";
				select.appendChild(option);
				option.selected = json[i].curr;
			}
			var last = document.querySelector("#top .contentlayout_none");
			document.querySelector("#top > ul").insertBefore(list, last);

			select.addEventListener("change", function() {
				switchAllUserInfo();
			});
		}

		function switchAllUserInfo() {
			var select = document.getElementById("switchUser").selectedOptions[0];
			var json = {};
			json['companyId'] = select.getAttribute("data-company");
			json['deptId'] = select.getAttribute("data-dept");
			json['jobId'] = select.getAttribute("data-job");

			$.ajax({
				type: "POST",
				url: "/ezNewPortal/switchAllUserInfo.do",
				contentType: "application/json; charset=UTF-8",
				data: JSON.stringify(json),
				success : function(text) {
					if (text === "true") parent.location.reload();
				}
			});
		} --%>
		
		var getQuickLink = function () {
	 		var xhr = new XMLHttpRequest();
	 		xhr.onload = function () {
	 			if (xhr.status >= 200 && xhr.status < 300) {
	 				var parseData = JSON.parse(xhr.responseText);
	 				setQuickMenuList(parseData.data);
	 			} else {
	 				console.error(xhr.responseText);	
	 			}
	 		};
	 		xhr.open('GET', '/ezNewPortal/getQuickLink.do'); 		
	 		xhr.setRequestHeader('Content-Type', 'application/json');
	 		xhr.send();
	 	}
		
		var setProfile = function () {
			$.ajax({
				type: "GET",
				url: "/ezNewPortal/allUserTab.do",
				dataType: "JSON",
				success : function(result) {
					var switchUserCompany = "<c:out value='${switchUserCompany}' />"
					
					var userJobList = result.userJobList;
					var currJobInfo = result.currJobInfo;
					var profileContainer = document.getElementById('profileContainer');
					var btnTabDiv = profileContainer.firstChild; //환경설정, 로그아웃 버튼
					
					var imgDiv = document.createElement('div');
					imgDiv.classList.add('profile_img');
					var userImg = document.createElement('img');
					
					if (userPhotoSrc != "") {
						userImg.setAttribute("src","/ezCommon/downloadAttach.do?filePath=" + userPhotoSrc);
					} else {
						userImg.setAttribute("src", "/images/ezNewPortal/info_pic_none.png");
					}
					imgDiv.appendChild(userImg);
					profileContainer.insertBefore(imgDiv, btnTabDiv);
					
					var dl = document.createElement('dl');
					var dt = document.createElement('dt');
					
					if (userPrimary == "1") {
						dt.textContent = result.userName + " " + currJobInfo.title;
					} else {
						dt.textContent = result.userName2 + " " + currJobInfo.title2;
					}
					
					var dd = document.createElement('dd');
					if (userPrimary == "1") {
						dd.textContent = currJobInfo.deptName;
					} else {
						dd.textContent = currJobInfo.deptName2;
					}
					dl.appendChild(dt);
					dl.appendChild(dd);
					profileContainer.insertBefore(dl, btnTabDiv);
					
					if (switchUserCompany == "Y") {
						var selectDiv = document.createElement('div');
						selectDiv.classList.add('select_div');
						var selectSpan = document.createElement('span');
						selectSpan.classList.add('select_box');
						selectSpan.textContent = "<spring:message code='ezNewPortal.topMenu.hth07' />";
						selectSpan.addEventListener('click', function() {
							event.target.classList.toggle('on');
						});
						selectDiv.appendChild(selectSpan);
						
						var ul = document.createElement('ul');
						
						for (var i = 0; i < userJobList.length; i++) {
							var li = document.createElement("li");
							li.setAttribute("data-dept", userJobList[i].deptId);
							li.setAttribute("data-company", userJobList[i].companyId);
							li.setAttribute("data-job", userJobList[i].jobId);
							if (userPrimary == "1") {
								li.textContent = userJobList[i].companyName + " (" + userJobList[i].deptName + " " + userJobList[i].title + ")";
							} else {
								li.textContent = userJobList[i].companyName2 + " (" + userJobList[i].deptName2 + " " + userJobList[i].title2 + ")";
							}
							
							ul.appendChild(li);
							li.addEventListener('click', function () {
								switchAllUserInfo();
							});
						}
						selectDiv.appendChild(ul);
						
						profileContainer.insertBefore(selectDiv, btnTabDiv);
					}
				}
			});
			
		}
		
		function switchAllUserInfo() {
			var selectedLi = event.target;
			var json = {};
			json['companyId'] = selectedLi.getAttribute("data-company");
			json['deptId'] = selectedLi.getAttribute("data-dept");
			json['jobId'] = selectedLi.getAttribute("data-job");

			$.ajax({
				type: "POST",
				url: "/ezNewPortal/switchAllUserInfo.do",
				contentType: "application/json; charset=UTF-8",
				data: JSON.stringify(json),
				success : function(text) {
					if (text === "true") {
						parent.window.location.reload();
					}
				}
			});
		}
		
		function setQuickMenuList(quickmenuData) {
			var quickMenu = document.querySelector('#quickMenuList');
			var quickList = quickmenuData.quickLinkList;
			
			while(quickMenu.hasChildNodes()) {
	 			quickMenu.removeChild(quickMenu.firstChild);
	 		}
			
			if (quickList == null || quickList.length == 0) {
				var dlEl = document.createElement('dl');
				dlEl.className = 'nodata';
				
				var dtEl = document.createElement('dt');
				
				var imgEl = document.createElement('img');
				imgEl.src = '/images/kr/main/noData_sIcon.png';
				
				var ddEl = document.createElement('dd');
				ddEl.textContent =  '"<spring:message code="main.t00026" />"';
				
				dtEl.appendChild(imgEl);
				
				dlEl.appendChild(dtEl);
				dlEl.appendChild(ddEl);
				
				quickMenu.appendChild(dlEl);
				return;
			}
			
			quickList.forEach(function (item, index) {
				var li = document.createElement('li');
				var div = document.createElement('div');
				div.classList.add("quick_img");
				
				var img = document.createElement('img');
	 			img.src = item.linkTypeUrl;
	 			
	 			div.appendChild(img);
	 			li.appendChild(div);
	 			
	 			var spanText = document.createElement('span');
	 			
	 			if (userLang == "2") { // 영어
	 				spanText.textContent = item.quickLinkName2;
	 			} else if (userLang == "3") { // 일본어
	 				spanText.textContent = item.quickLinkName3;
	 			} else { // 기본 언어
	 				spanText.textContent = item.quickLinkName;
	 			}
	 			
	 			li.appendChild(spanText);
	 			li.addEventListener('click', function(){
					var url = item.url;
					
					if (url.indexOf("http:") == -1 && url.indexOf("https:") == -1) {
						url = "http://" + url;
					}
					
					// size가 FULL인 경우 vs 아닌 경우
					if(item.quickSize === 'FULL') {
						window.open( url, '_blank', '');
					} else if (item.quickSize.indexOf(':') > 0) {
						var sizeArr = item.quickSize.split(':');
						var popupX = (window.screen.width / 2) - (sizeArr[0] /2);
						var popupY = (window.screen.height / 2) - (sizeArr[1] /2);
						var option = 'width='+sizeArr[0]+'px,height='+sizeArr[1]+'px, left='+popupX+', top='+popupY+', status = no, toolbar=no, menubar=no,location=no, resizable=0';
						window.open(url, '_blank', option);
					}
				}); 
	 			
	 			quickMenu.appendChild(li);
			});
            //str += '<li><div class="quick_img"><img src="images/quick_sample.png"></div><span>홈페이지</span></li>'
		}
 		
 		// 시작지점
		newPortalTopMenuFunc();	
		
		window.onload = function() {
			//callAllUserTab();
            if ("<c:out value='${useStatMenu}' />" === "YES") {
                var menuTracker = new ClickTracker().addTarget('[data-menu-id]').addExclude('.ui-draggable').addDataset('menuId').start();
            }
            
			setUseActiveX();		 // activeX 설치 (useActiveX가 YES일때)
		}
		
		function removeAllChildernElem(element){
			while (element.firstChild) {
				element.removeChild(element.firstChild);
			}
		}
		
		function toggleAllMenu(mode) {
			var menuAllContainer = $('#menuAllContainer');
			var mainFrame = window.parent.document.getElementById("mainFrame");
			if (mode == "on" || (mode == null && !menuAllContainer.hasClass('on'))) {
				subMenuClickEvent('off');
				dimLayerControl('open');
				menuAllContainer.addClass('on');
            } else {
            	dimLayerControl('close');
            	menuAllContainer.removeClass('on');
            }
		}
		
		function toggleDivMenu(elem, mode) {
			if (mode == "on" || (typeof mode == "undefined" && getComputedStyle(elem).display == "none")) {
	        	subMenuClickEvent('off');
	        	elem.style.display = "block";
	        	dimLayerControl('open');
	        } else {
	        	elem.style.display = "none";
	            dimLayerControl('close');
	        }
		}
		
		function dimLayerControl(mode) {
			var mainFrame = window.parent.document.getElementById("mainFrame");
            var topFrame =  window.parent.document.getElementById("topFrame");
			if(mode == "open") {
				document.querySelector('body').style.background = "rgba(0,0,0,0.3)";
	            document.querySelector('body').classList.add("dimLayerOpen");
                window.parent.document.getElementById("topFrame").style.zIndex = "5";
                if (menuDisplayMode == "0") {
                	mainFrame.style.float = "right";
                } else {
                	mainFrame.style.position = "static";
					var userAgent = navigator.userAgent.toLowerCase();
					
					if (/iphone|ipod|ipad|android.*mobile/i.test(userAgent) || /tablet|ipad|android/i.test(userAgent) || navigator.maxTouchPoints > 4) {
						window.parent.fixLayout();
					}
                }
                topFrame.style.position = "absolute";
			} else if (mode == "close") {
				document.querySelector('body').style.background = "rgba(0,0,0,0)";
                document.querySelector('body').classList.remove("dimLayerOpen");
                $(window.parent.document).find("#topFrame").css("z-index","0");
                if (menuDisplayMode == "0") {
                	mainFrame.style.float = "none";
                } else {
                	mainFrame.style.position = "relative";
                }
                topFrame.style.position = "";
			}
			
			var userAgent = navigator.userAgent.toLowerCase();
			
			if (/iphone|ipod|ipad|android.*mobile/i.test(userAgent) || /tablet|ipad|android/i.test(userAgent) || navigator.maxTouchPoints > 4) {
				window.parent.fixLayout();
			}
		}
		
		var lastNotiPollTime = "${lastNotiPollTime}";
		
		function pollNewNoti() {
		    $.ajax({
		        url: '/ezNotification/getNewNotiCnt.do', 
		        method: 'GET',
		        dataType : 'JSON',
		        data: {
		        	lastNotiPollTime: lastNotiPollTime
				},
		        success: function(response) {
		        	var newNotiCnt = response.newNotiCnt;
		        	if (parseInt(newNotiCnt) > 0) {
		        		parent.document.getElementById("iframeNoti").src = "/ezNotification/notificationMain.do";
		        	}
		        	lastNotiPollTime = response.lastNotiPollTime;
		        },
		        error: function(xhr, status, error) {
		            console.log(error);
		        }
		    });
		}

		// 일정한 간격으로 pollUnreadData 함수를 실행하는 함수
		function startPolling(interval) {
		    setInterval(function() {
		    	pollNewNoti();
		    }, interval);
		}
		
		function toggleNoti() {
			//subMenuClickEvent('off');
			if (parent.document.getElementById("iframeShawdowLayer").style.display == "block") {
				closeNoti();
			} else {
				openNoti();
			}
		}

		function openNoti() {
			pollNewNoti();
			subMenuClickEvent('off');
			var screenHeight = screen.height;
			var topFrame = parent.document.getElementById('iframeShawdowLayer');
			topFrame.style.minHeight = screenHeight+"px";
			topFrame.style.backgroundColor = 'rgba(0, 0, 0, 0.3)';
			topFrame.style.display = "block";
			topFrame.style.zIndex = "9999";
			topFrame.style.top = "60px";
			topFrame.style.position = "absolute";
			
			var userAgent = navigator.userAgent.toLowerCase();
			
			if (/iphone|ipod|ipad|android.*mobile/i.test(userAgent) || /tablet|ipad|android/i.test(userAgent) || navigator.maxTouchPoints > 4) {
				window.parent.fixLayout();
			}
			
			if (menuDisplayMode == '1') {
				topFrame.style.width = "calc(100vw - 81px)";
			} else {
				topFrame.style.width = "100vw";
			}
			//parent.document.getElementById('topFrame').style.position = 'relative';
		}

		function closeNoti() {
			parent.document.getElementById("iframeShawdowLayer").style.display = "none";
		}

		// 겸직
		function callAllUserTab() {
			$.ajax({
				type: "GET",
				url: "/ezNewPortal/allUserTab.do",
				dataType: "JSON",
				success : function(data) {
					makeAllUserTab(data);
				}
			});
		}

		function makeAllUserTab(json) {
			var switchUserCompany = "<c:out value='${switchUserCompany}' />"

			if (switchUserCompany !== "Y") return;

			var wrap = document.getElementById("listSwitch");
			var select = document.createElement("select");
			select.id = "switchUser";
			select.style.maxWidth = "80px"; // 길이 임시조치
			// select.style.padding = "0 6px";
			// list.append(select);
			wrap.append(select);

			for (var i = 0; i < json.length; i++) {
				var option = document.createElement("option");
				option.setAttribute("data-dept", json[i].deptId);
				option.setAttribute("data-company", json[i].companyId);
				option.setAttribute("data-job", json[i].jobId);
				option.value = json[i].companyId;
				option.text = json[i].companyName + " (" + json[i].deptName + " " + json[i].title + ")";
				select.appendChild(option);
				option.selected = json[i].curr;
			}

			select.addEventListener("change", function() {
				switchAllUserInfo();
			});
		}
		
		function toggleTopSearch() {
			 $(".employee_search").toggleClass("active");
			 if ($(".contentlayout_none.topMenuBtnsOn").length > 0) {
				 $(".contentlayout_none.topMenuBtnsOn").addClass("topMenuBtnsOff");
				 $(".contentlayout_none.topMenuBtnsOn").removeClass("topMenuBtnsOn");
			 } else {
				 $(".contentlayout_none.topMenuBtnsOff").addClass("topMenuBtnsOn");
				 $(".contentlayout_none.topMenuBtnsOff").removeClass("topMenuBtnsOff");
				 
			 }
		}

		function offMenuAll() {
			$(".lnb_list li").removeClass("on");
			$(".navUL li").removeClass("on");
		}

		</script>
		<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>	
	</body>
</html>
