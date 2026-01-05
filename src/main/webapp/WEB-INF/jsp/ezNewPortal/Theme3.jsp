<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>PortalPage</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/orbit-1.2.3.css')}" type="text/css" />
<link href="${util.addVer('/css/ezNewPortal/swiper.min.css')}" rel="stylesheet" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/swiper.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/fixBoard.js')}"></script>
<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezNewPortal/portal.css')}" />
<link href="${util.addVer('main.portal', 'msg')}" rel="stylesheet" type="text/css">
<style type="text/css">
	.notEmptySlider {
		width : 280px;
		height : 515px;
		cursor : pointer;
	} 
	
	#myImg {
		width : 36px;
		height : 36px;
	}
	
	#userList li {
		cursor : pointer;
		display: block;
	}
	
	.portlet {
		 margin:20px 0px 0px 20px;
		 height:250px;
		 background:#fff;
		 border-radius: 5px;
	}
	.slider_section {height:515px; width:280px;}
	.right_float {float:right;}
	#nodata_NewBirth {display:none;}
	#featured {background : none;}
	/*#theme3Body .two_column {width:48.4%;}*/
	.linkIcon {display: block; margin: 0 auto; padding: 9px 0px 5px 0px; text-align: center;}
	.linkTxt {display: block; width: 78px; text-align: center; color: #333; font-size: 12px; height: 27px; letter-spacing: 0px; overflow: hidden;margin: 0 auto; padding: 2px 0px 0px 0px; word-break: break-all; line-height: 15px; text-overflow: ellipsis; white-space: nowrap;}
	
	/* 2023-06-08 홍승비 - 테마3 > 카운트 포틀릿의 li 태그 > 마우스 포인터 스타일 추가 */
	.theme3CntLi {cursor:pointer;}
</style>
</head>
<body class="mainbg" id="theme3Body">
	<div id="Center">
		<div class="top_info_area_wrap">
			<span class="top_info_toggle_btn"></span>
			<div class="top_info_area">
				<div class="my_info_wrap">
					<div class="my_info" id="myInfo">
						<div class="my_info_img"><img src="/images/ezNewPortal/bannerImg_left.png"></div>
						<div class="my_info_div">
							<span class="name">${userName} ${userTitle}</span>
							<span class="team">${deptName}</span>
						</div>
					</div>

					<div class="portal_setting" onclick="viewPortletEnv()"><spring:message code = 'ezNewPortal.HSBPT01' /></div>
					<div class="config_setting" onclick="infoSetClick()"><spring:message code = 'ezNewPortal.t006' /></div>

					<div class="news_setting" style="display:none;">
						<input type="checkbox" id="portal_set" onchange="displayFixPortlet()">
						<label for="portal_set"><span></span><spring:message code='ezNewPortal.topMenu.hth13'/></label>
					</div>
				</div>
				<ul>
					<li>
						<span class="mail" onclick="openPageOfPortal(this.className)"><span><spring:message code = 'ezNewPortal.topMenu.unReadMail' /></span><em id="unReadMailCount"></em></span>
						<span class="appr" onclick="openPageOfPortal(this.className)"><span><spring:message code = 'ezNewPortal.gu2' /></span><em id="approvalCnt"></em></span>
                        <span class="board" onclick="openPageOfPortal(this.className)"><span><spring:message code = 'ezBoard.t480' /></span><em id="newBoardCnt"></em></span>
					</li>
					<li>
						<h3><spring:message code = 'ezPortal.newPost' /></h3>
						<div class="noti" id="noti"></div>
					</li>
				</ul>
				<div id="fixBoardArea" style=""></div>
			</div>
		</div>
		<section class="section_main active">
			<div id="dummyArea"></div>
			<div id="portletArea" class="portlet_area">
			</div>
		</section>
		
		<div style="width: 100%; height: 100%; position: fixed; top: 0; left: 0; z-index: 1005; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
			
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</div>
	<div class="title_tooltip"></div>
<%-- script line --%>
<script type="text/javascript" src="${util.addVer('/js/ezPortal/string_component.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortal/functionLib.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortal/showModalDialog.js')}" ></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.orbit-1.2.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/raphael-min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezAttitude/Calendar.js')}"></script>
<script type="text/javascript" src="${util.addVer('ezNewPortal.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/newPortal_common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/Holiday.js')}"></script>

<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>

<!-- 일정관리 -->
<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
<c:choose>
	<c:when test="${checkBrowser == true}">
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/sCalendarMini_IEEIP.js')}"></script>
	</c:when>
	<c:otherwise>
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/sCalendarMini_EIP.js')}"></script>
	</c:otherwise>
</c:choose>
<!-- 일정관리 끝 -->
<script type="text/javascript" src="${util.addVer('/js/ezPortlet/web-animations.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortlet/muuri.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortlet/portlet-util.js')}"></script>
<link rel="stylesheet" href="${util.addVer('/css/ezPortlet/portlet.css')}" type="text/css" />
<script type="text/javascript">
	var portletOrder = JSON.parse('${portletOrder}');
	var fixedPortletList = JSON.parse('${fixedPortletList}');
	var photoBoardPage = 1;
	var photoCount = 3;
 	var nowAttiTime = "";
 	var ptlNowAttiTime = "";
 	var beforeAlertDate = "";
	var afterAlertDate = "";
	var overTime = "";
 	var serverTime = "<c:out value='${serverTime}'/>";
 	var timeDiff;
 	var ptlTimeDiff;
 	var birthdayMonth = Number("<c:out value='${nowMonth}'/>");
 	var birthdayCurPage = 0;
 	var birthdayTotalCount = 0;
 	var timer;
 	var frameId = "<c:out value='${usedFrame}'/>";
 	var usedTheme = "<c:out value='${usedTheme}'/>";
 	var usePaging = "<c:out value='${usePaging}'/>";
 	var WorkspaceUrl = "${workspaceHostUrl}"; // 협업이 그룹웨어와 별도의 Url로 서비스 되는 경우에만 설정
    var workspaceContextRootUrl = "${workspaceContextRootUrl}";
    /* 2025-03-13 홍승비 - 협업 모듈에 고정된 하드코딩 문자열 제거 (ezWorkspace), 테넌트 컨피그 workspaceAppPath로 협업 웹응용프로그램 경로를 분리하여 사용 ("" 또는 "/ezWork" 등) */
    var workspaceAppPath = "${workspaceAppPath}";
    var userLang = "<c:out value='${userLang}'/>";
    var userLang2 = "<c:out value='${userLang2}'/>";
	var usePortletSize = "<c:out value='${usePortletSize}'/>" === "Y";
	var portletInfoMap = {};
	var useWebHWP = "<c:out value='${useWebHWP}'/>";
	var companyID = "<c:out value='${companyID}'/>";
	var userID = "<c:out value='${userId}'/>";
	var draftAllTypeB = "<c:out value='${draftAllTypeB}'/>";
	var apprPortletIDs = [];
	var apprPortletTypes = [];
	var strBoardPassword =  "<spring:message code='ezBoard.private.pgb05' />";
	var strBoardOk =  "<spring:message code='ezBoard.private.pgb06' />";
	var strWrongPassword =  "<spring:message code='ezBoard.t267' />";
	
 	var quickLinkPage = {
 		current: 1,
 		total: 1,
 	};
	
 	window.onresize = function(event) {
 		frameSetting(frameId);
 	}
 	
 	var setQuickLinkList = function (data) {
 		var quickList = data.quickLinkList;
 		var totalCnt = data.totalPageCnt;
 		
 		quickLinkPage.total = totalCnt;
 		
 		var quickMenu = document.getElementById('quickmenu');
 		
 		// 현재 리스트를 갖고 있는 경우 삭제 후 진행
 		while (quickMenu.hasChildNodes()) {
 			quickMenu.removeChild(quickMenu.firstChild);
 		}

		quickList.forEach(function (item, index) {
 			var li = document.createElement('li');
 			var spanIcon = document.createElement('span');
 			spanIcon.classList.add('icon');
 			
 			var img = document.createElement('img');
 			img.src = item.linkTypeUrl;
 			spanIcon.appendChild(img);
 			
 			var spanText = document.createElement('span');
 			spanText.classList.add('txt');
 			
 			/* 2021-10-15 홍승비 - 퀵링크 다국어 처리 추가 */
 			if (userLang2 == "2") { // 영어
 				spanText.textContent = item.quickLinkName2;
 			} else if (userLang2 == "3") { // 일본어
 				spanText.textContent = item.quickLinkName3;
 			} else { // 기본 언어
 				spanText.textContent = item.quickLinkName;
 			}
 			
 			li.appendChild(spanIcon);
 			li.appendChild(spanText);
			li.addEventListener('click', function(){
				var url = item.url;
				
				if (url.indexOf("http:") == -1 && url.indexOf("https:") == -1) {
					url = "http://" + url;
				}
				
				// size가 FULL인 경우 vs 아닌 경우
				if(item.quickSize === 'FULL') {
					window.open(url, '_blank', '');
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
		
		// 퀵링크 페이지 					
		var btnLay = document.getElementById('btnLay');
		
		// 현재 리스트를 갖고 있는 경우 삭제 후 진행
 		while (btnLay.hasChildNodes()) {
 			btnLay.removeChild(btnLay.firstChild);
 		}		
		
		var linkBtnPre = document.createElement('span');
		linkBtnPre.classList.add('linkBtn_pre');
		var preBtnImg = document.createElement('img');
		
		/* 2023-06-08 홍승비 - 테마3 > 퀵링크 하단 좌우이동 버튼 이미지 통일 */
		if (quickLinkPage.current*1 === 1 || totalCnt*1 === 0) {
			preBtnImg.setAttribute('src', '/images/ezNewPortal/link_preBtn_dis.png');
			preBtnImg.setAttribute('id', 'preBtnDis');
		} else {
			preBtnImg.setAttribute('src', '/images/ezNewPortal/link_preBtn_dis.png');
			preBtnImg.setAttribute('id', 'preBtn');
		}
		
		linkBtnPre.appendChild(preBtnImg);
		
		var linkBtnNext = document.createElement('span');
		linkBtnNext.classList.add('linkBtn_next');
		var nextBtnImg = document.createElement('img');
		
		if (quickLinkPage.current*1 === totalCnt*1 || totalCnt*1 === 0) {
			nextBtnImg.setAttribute('src', '/images/ezNewPortal/link_nextBtn_dis.png');
			nextBtnImg.setAttribute('id', 'nextBtnDis');
		} else {
			nextBtnImg.setAttribute('src', '/images/ezNewPortal/link_nextBtn_dis.png');
			nextBtnImg.setAttribute('id', 'nextBtn');
		}
		
		linkBtnNext.appendChild(nextBtnImg);
		
		btnLay.appendChild(linkBtnPre);
		btnLay.appendChild(linkBtnNext);
		
		// 페이징 클릭 이벤트
		var preBtn = document.getElementById('preBtn');
		var nextBtn = document.getElementById('nextBtn');

		if(preBtn !== null) {
			preBtn.addEventListener('click', function () {
				quickLinkPage.current = (quickLinkPage.current*1) - 1;
				getQuickLink();
			});	
		}
		
		if(nextBtn !== null) {
			nextBtn.addEventListener('click', function () {
				quickLinkPage.current = (quickLinkPage.current*1) + 1;
				getQuickLink();
			});
		}
		
 	}
 	
 	var getQuickLink = function () {
 		var xhr = new XMLHttpRequest();
 		xhr.onload = function () {
 			if (xhr.status >= 200 && xhr.status < 300) {
 				var parseData = JSON.parse(xhr.responseText);
 				setQuickLinkList(parseData.data);
 			} else {
 				console.error(xhr.responseText);	
 			}
 		};
 		xhr.open('GET', '/ezNewPortal/getQuickLink.do?page='+quickLinkPage.current); 		
 		xhr.setRequestHeader('Content-Type', 'application/json');
 		xhr.send();
 	}
 	
	$(function() {
		makePortletsShell(portletOrder)
		if (!!fixedPortletList) {
			makeFixPortlet(fixedPortletList);
		}
		makePortlets(portletOrder);

		var useQuestion = "<c:out value='${useQuestion}'/>";
		var useSurvey = "<c:out value='${useSurvey}'/>";
		var useCircular = "<c:out value='${useCircular}'/>";
		var useMail = "<c:out value='${useMail}'/>";
		var useApproval = "<c:out value='${useApproval}'/>";
		var useSchedule = "<c:out value='${useSchedule}'/>";
		
		//권한에 없는거는 보여주지 않기
		/* 
		if (useQuestion === "NO") {
			$("#Poll").css("display", "none");
		}
		 */
		if (useSurvey === "NO") {
			$("#Survey").css("display", "none");
		}
		
		if (useCircular === "NO") {
			$("#Circular").css("display", "none");
		}
		
		if (useMail === "NO") {
			$("#NewMail").css("display", "none");
		}
		
		if (useApproval === "NO") {
			$("#AprSign").css("display", "none");
		}
		
		if (useSchedule === "NO") {
			$("#Schedule").css("display", "none");
		}

		$("#helpDiv").css("display", "none");
		
		//퀵메뉴 on/off 버튼
		$("#quicklinkBtn").on('click', viewQuick);
		//퀵메뉴 이동(오른쪽)
// 		document.getElementById("quickMailwrite").addEventListener('click', function(){quickMenuOpenRight('mail');}, false);
// 		document.getElementById("quickApprovalwrite").addEventListener('click', function(){quickMenuOpenRight('appr');}, false);
// 		document.getElementById("quickSchedulewrite").addEventListener('click', function(){quickMenuOpenRight('schedule');}, false);
// 		document.getElementById("quickOrgan").addEventListener('click', function(){quickMenuOpenRight('organ');}, false);
		
		//구해안 - 임시로 넣어둠
		$("#portletEnv").on("click", viewPortletEnv);
		
		//구해안 - 테마3일때 일정포틀릿이랑 나의정보 포틀릿은 background 지워버리기
		$("#36portlet").css("background-color","none");
		$("#6portlet").css("background-color","none");

		// 퀵링크 호출
		//getQuickLink(); 2024-05-23 한태훈 > 퀵링크 아이콘 삭제.		
		
		//포틀릿 드래그 앤 드롭
		if (navigator.userAgent.toLowerCase().indexOf("firefox") == -1) {
			sortableEvent();
		}
		
		/* $(".portlet_area").disableSelection(); */
		
		setPortalRefresh();
		
		setPortalCount();		// 포탈 카운트 세팅
        setBoardItemListToTopMenu("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}");
        makeSwiperByTopMenu();
	});
	
	var refreshInterval = "<c:out value='${usePortalAutoRefreshInterval}'/>";
	var pRefreshInterval = 0;
	var pRefreshIntervalTimerId = 0; // interval id
	var pRefreshTimeOutTimerId = 0; // setTimeout id
	var pNextRefreshTime = 0;
	
	var setPortalRefresh = function() { // set 포탈 자동 새로고침
		if (refreshInterval == null || refreshInterval == "0") { return; }
		
		pRefreshInterval = parseInt(refreshInterval) * 60000;
		setRefreshTimer();
		
		if ('hidden' in document) {
			document.addEventListener('visibilitychange', onVisibilityChange);
			nextRefreshTime();
		}
	}
	
	var setRefreshTimer = function() { // set 새로고침 Interval
		if (pRefreshIntervalTimerId != 0) {
			clearInterval(pRefreshIntervalTimerId);
			pRefreshIntervalTimerId = 0;
		}
		
		if (pRefreshInterval != 0) {
			pRefreshIntervalTimerId = setInterval(function() {
				refreshPage();
			}, pRefreshInterval);
		}
	}
	
	var onVisibilityChange = function() {
		 var remainingTime = pNextRefreshTime - getCurrentTime();
		
		 if (!document.hidden) { // 페이지 상태가 보임으로 변경될 때의 처리
			if (remainingTime <= 0) { // 다음 번 갱신 시간이 이미 지났으면 즉시 목록 갱신을 수행하고 갱신 타이머를 설정한다.
				refreshPage();
			} else { // 다음 번 갱신 시간이 아직 남아 있으면 해당 시간에 갱신이 되도록 타이머를 등록한다.
				pRefreshTimeOutTimerId = setTimeout(function() {
					refreshPage();
				}, remainingTime);
			}			 
		 } else { // 페이지 상태가 숨김으로 변경될 때의 처리   
            if (pRefreshIntervalTimerId != 0) { // interval 목록 갱신 타이머를 제거한다.
                clearInterval(pRefreshIntervalTimerId);
                pRefreshIntervalTimerId = 0;
            }
		 
		 	if (pRefreshTimeOutTimerId != 0) { // setTimeout 제거
		 		clearTimeout(pRefreshTimeOutTimerId);
		 		pRefreshTimeOutTimerId = 0;
		 	}
		 }
	}
	
	var nextRefreshTime = function() { // 다음 새로고침 시각 구하기
		pNextRefreshTime = getCurrentTime() + pRefreshInterval;
	}
	
	var refreshPage = function () { // 포탈 로드
		parent.document.getElementById("mainFrame").contentWindow.location.reload(true);
	}
	
	function getCurrentTime() {
        return new Date().getTime();		        
    }
	
	/* var settingPortalInterval = function () {
		var refreshInterval = "<c:out value='${usePortalAutoRefreshInterval}'/>";
		
		if (refreshInterval != null && refreshInterval != "0") {
			window.setInterval(function() {
				parent.document.getElementById("mainFrame").contentWindow.location.reload(true);
			}, Number(refreshInterval) * 60000);
		}
	} */
	
	var tryCount = 0;
	
	var sortableEvent = function () {
		if (usePortletSize) return false;
		//포틀릿 드래그 앤 드롭
		try {
			$(".portlet_area").sortable({
				handle : ".sortablePortlet",
				helper : "clone",
				scroll: false,
				start : function (event, block) {
					/* 
					$(".portlet.ui-sortable-helper").css("width", $(".portlet").not(block.item).not(block.placeholder).outerWidth());
					
					$(".ui-sortable-placeholder").css({
						'width' : $(".portlet").not(block.item).not(block.placeholder).outerWidth(),
						'height' : $(".portlet").not(".ui-sortable-helper").outerHeight()
					}); */
				},
				update : function(event, ui) {
					updatePortletOrderUser(usedTheme);
				}
			});
		} catch (e) {
			tryCount++;
			if (tryCount <= 5) {
				setTimeout(sortableEvent(), 100);
			} else {
				return;
			}
		}
	}
	
	var frameSetting = function (frameSetId) {
		frameId = frameSetId;
		
		if (frameSetId == "Frame2") {
			var media1921 = window.matchMedia("only screen and (min-width: 1921px)");
			var media1686 = window.matchMedia("only screen and (max-width :1920px) and (min-width :1686px)");
			var media1685 = window.matchMedia("only screen and (max-width :1685px) and (min-width :1590px)");
			var media1589 = window.matchMedia("only screen and (max-width :1589px) and (min-width :1280px)");
			var media1279 = window.matchMedia("only screen and (max-width :1279px)");
			
			if (media1921.matches) {
				$(".portlet").addClass("two_column");
				$(".info_left").css("display", "inline-block");
				$(".info_left").css("float", "left");
				$(".info_left").css("width", "189px");
				$(".info_left").css("margin-right", "5px");
				$(".info_left").css("background", "url(/images/ezNewPortal/theme3Img/info_background.png) center center no-repeat");
				$(".info_right").css("width", "calc(100%)");
			} else if (media1686.matches) {
				$(".portlet").addClass("two_column");
				$(".info_left").css("display", "inline-block");
				$(".info_left").css("float", "left");
				$(".info_left").css("width", "189px");
				$(".info_left").css("margin-right", "5px");
				$(".info_left").css("background", "url(/images/ezNewPortal/theme3Img/info_background.png) center center no-repeat");
				$(".info_right").css("width", "calc(100%)");
			} else if (media1685.matches) {
				$(".portlet").addClass("two_column");
				$(".info_left").css("display", "inline-block");
				$(".info_left").css("float", "left");
				$(".info_left").css("width", "189px");
				$(".info_left").css("margin-right", "5px");
				$(".info_left").css("background", "url(/images/ezNewPortal/theme3Img/info_background.png) center center no-repeat");
				$(".info_right").css("width", "calc(100%)");
			} else if (media1589.matches) {
				$(".portlet").removeClass("two_column");
			} else if (media1279.matches) {
				$(".portlet").removeClass("two_column");
			}
		}
	}
	
	  function setPortalCount(){
	        var reqURL = "/ezNewPortal/allCount.do";
	        $.ajax({
	            method : "GET",
	            url : reqURL,
	            dataType : "text",
	            success : function(retData){
	                var jsonData = JSON.parse(retData);
	                if(jsonData.status != "ok")	{
	                    console.log(jsonData.message);
	                    return;
	                }
	                
	                var newBoardCnt = jsonData.newBoardCnt;
	                var unReadMailCount = jsonData.unreadMailCount;
	                var approvalCnt = jsonData.approvalCnt;

	                if(typeof newBoardCnt == "undefined") newBoardCnt = 0;
	                if(typeof unReadMailCount == "undefined") unReadMailCount = 0;
	                if(typeof approvalCnt == "undefined") approvalCnt = 0;

	                document.getElementById("newBoardCnt").innerText = newBoardCnt;
	                document.getElementById("unReadMailCount").innerText = unReadMailCount;
	                document.getElementById("approvalCnt").innerText = approvalCnt;
	            },
	            error : function(e){
	                console.log(e);
	            }
	        });
	    }

	    function openPageOfPortal(className){
	        if(className === null || typeof className == "undefined" || !className) return;

	        var target = "main";

	        switch(className){
	            case "mail":
	                quickMenuOpen('NewMail');
	                break;
	            case "appr":
	                quickMenuOpen('ApprG');
	                break;
	            case "board":
	                var mainHref = "";
	                var mainBoardHref = "";
	                try {
	                    mainHref = window.parent.main.location.href;
	                } catch (e) {
                        parent.document.querySelector("iframe[name='" + target + "']").src = '/ezBoard/boardMainRedirect.do?boardID="' + encodeURIComponent('{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}') + '"';
	                    break;
	                }
	                try {
	                    mainBoardHref = window.parent.mainBoard.location.href;
	                } catch (e) {
                        parent.document.querySelector("iframe[name='" + target + "']").src = '/ezBoard/boardMainRedirect.do?boardID="'+ encodeURIComponent('{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}') + '"';
	                    break;
	                }

	                var portalURL = "/ezNewPortal/newPortalPortalPage";

	                if (mainHref.indexOf(portalURL) > -1 && mainHref != 'about:blank'){ // 메인영역이 포탈로 활성화되어 있고 메인보드 영역이 비어있을때
	                    target = "main";
	                } else if(mainHref == 'about:blank' && mainBoardHref != 'about:blank'){ // 메인영역이 비어 있고 메인보드 영역이 비어있지 않을때
	                    target = "mainBoard";
	                }
                    parent.document.querySelector("iframe[name='" + target + "']").src = '/ezBoard/boardMainRedirect.do?boardID="'+ encodeURIComponent('{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}') + '"';
	                break;

	            default: break;
	        }
	    }

	    function setBoardItemListToTopMenu(boardId) {
	        if(!boardId) {
	            return;
	        }

	        $.ajax({
	            url : "/ezNewPortal/boardItemListToTopMenu.do",
	            method : "GET",
	            data : {"boardId" : boardId},
	            contentType : "text",
	            success : function(obj){
	                if(obj.status == "ok"){
	                    var len = obj.boardList.length;
	                    if(len > 0){
	                        var target = document.getElementById("noti");
	                        target.innerHTML = "";

	                        var swDiv = document.createElement("div");
	                        swDiv.classList.add('swiper');
	                        swDiv.classList.add('mySwiper');
	                        swDiv.classList.add('swiper-container');
	                        swDiv.classList.add('swiper-container-initialized');
	                        swDiv.classList.add('swiper-container-horizontal');
	                        
	                        var swWrap = document.createElement("div");
	                        swWrap.classList.add('swiper-wrapper');
	                        swWrap.style.cssText = 'transform : translate3d(0px, 0px, 0px)';
	                        swDiv.append(swWrap);
	                        target.append(swDiv);
	                        makeSlideByTopMenu(obj.boardList);
	                    }else{
	                        var target = document.getElementById("noti");
	                        target.innerHTML = "";
	                        var noItemText = "<spring:message code = 'ezNewPortal.topMenu.newBoardItem' />";
	                        var div = document.createElement("div");
	                        div.id = "noItemArea";
	                        div.innerText = noItemText;
	                        target.append(noItemText);
	                    }
	                } else {
	                    var target = document.getElementById("noti");
	                    target.innerHTML = "";
	                    var noItemText = "<spring:message code = 'ezNewPortal.topMenu.newBoardItem' />";
	                    var div = document.createElement("div");
	                    div.id = "noItemArea";
	                    div.innerText = noItemText;
	                    target.append(noItemText);
	                }
	            },
	            error : function(e){
	                var target = document.getElementById("noti");
	                target.innerHTML = "";
	                var noItemText = "<spring:message code = 'ezNewPortal.topMenu.newBoardItem' />";
	                var div = document.createElement("div");
	                div.id = "noItemArea";
	                div.innerText = noItemText;
	                target.append(noItemText);
	                console.log(e)
	            }
	        });
	    }

	    var makeSlideByTopMenu = function (bList) {
	        var noidDiv = document.getElementById('noti');
	        var wrapper = noidDiv.querySelector(".swiper-wrapper");

	        var max = bList.length;
	        for (var i = 0; i < max; i++) {
	            const board = bList[i];
	            const slide = document.createElement('div');
	            slide.classList.add('swiper-slide');
	            if (i===0) {
	                slide.classList.add('swiper-slide-active');
	            } else {
	                slide.classList.add('swiper-slide-next');
	            }
	            wrapper.appendChild(slide);
	            const divText = document.createElement('div');
	            divText.classList.add('swiper_txt');

				if (board.extensionAttribute2 == 1) {
					divText.style.display ="flex";
					const notiDiv = document.createElement('div');
					notiDiv.className = "notiBox";
					notiDiv.innerText = "<spring:message code = 'ezNotification.hth89' />";
					divText.appendChild(notiDiv);
				}
				
	            slide.appendChild(divText);
	            var textNode = document.createTextNode(board.title);
	            divText.appendChild(textNode);
	        }

			wrapper.addEventListener("click", function (event) {
				if (!event.target.closest('.swiper-slide')) return;
				var index = event.target.closest('.swiper-slide').getAttribute('data-swiper-slide-index');
				openBoard(bList[index].itemID,bList[index].guBun,bList[index].boardID);
			});
			
	        makeSwiperByTopMenu();
	    }

		var makeSwiperByTopMenu = function () {
			var swiper = new Swiper(".mySwiper", {
				loop: true,
				autoplay: {
					delay: 5000,
					disableOnInteraction: false,
				}
			});
		}
	    
	    function getCookie(Name) {
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
	    }
	
	// 고정포틀릿 on/off
	function displayFixPortlet() {
		var onOff = document.getElementById("portal_set").checked;
		var fixArea = document.getElementById("fixBoardArea");

		if (onOff) {
			fixArea.classList.add("hidden");
		} else {
			fixArea.classList.remove("hidden");
		}
	}

	$(document).ready(function(){
		$(".top_info_toggle_btn").click(function(){
			if($(this).hasClass("on")){
				$(".top_info_area_wrap").css("width","510px");
			} else {
				$(".top_info_area_wrap").css("width","0");
			}
			$(this).toggleClass("on");

			if($(".top_info_area_wrap").hasClass("position")) {
				$(".section_main").attr("class","section_main");
			} else {
				$(".section_main").toggleClass("active");
			}
			
			$(".top_info_area_wrap").one("transitionend", function() {
				resizePortlet();
			});
		})

		$(window).resize(function(){
			if($(window).width() < 1320){
				if($(".top_info_area_wrap").hasClass("position") == false){
					$(".top_info_area_wrap").css("width","0");
					$(".top_info_toggle_btn").addClass("on");
				}
				$(".top_info_area_wrap").attr("class","top_info_area_wrap position");
				$(".section_main").attr("class","section_main");
			} else{
				$(".top_info_area_wrap").attr("class","top_info_area_wrap");
				if($(".top_info_toggle_btn").hasClass("on")){
					$(".section_main").attr("class","section_main");
				} else{
					$(".section_main").attr("class","section_main active");
				}
			}
		})
	})
	</script>
	</body>
</html>