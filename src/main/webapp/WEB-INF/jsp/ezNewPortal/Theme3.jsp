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
	#theme3Body .two_column {width:48.4%;}
	.orbit-wrapper .timer {display:none;}
	.linkIcon {display: block; margin: 0 auto; padding: 9px 0px 5px 0px; text-align: center;}
	.linkTxt {display: block; width: 78px; text-align: center; color: #333; font-size: 12px; height: 27px; letter-spacing: 0px; overflow: hidden;margin: 0 auto; padding: 2px 0px 0px 0px; word-break: break-all; line-height: 15px; text-overflow: ellipsis; white-space: nowrap;}
	
	/* 2023-06-08 홍승비 - 테마3 > 카운트 포틀릿의 li 태그 > 마우스 포인터 스타일 추가 */
	.theme3CntLi {cursor:pointer;}
</style>
</head>
<body class="mainbg" id="theme3Body">
	<div id="Center">
	<div style="position:relative;">
		<aside id="quickSide" style="width:0px;height:100%">
			<p class="linkBtn_close" id="linkBtn_open"><img id="quicklinkBtn" src="/images/ezNewPortal/theme3Img/linkBtn_open.png"></p>
			<div class="aside_quick">
				<p class="quickmenu_title"><spring:message code='ezNewPortal.t020' /></p>
				<ul id="quickmenu" class="quickmenu">
				</ul>
			</div>
			<div class="aside_link">
				<div class="linkBtn">
					<p class="btnLay" id="btnLay">
					</p>
				</div>
			</div>
		</aside>
	</div>	
		<section class="section_main">
			<div class="portlet_area">
			</div>
		</section>
		
		<div style="width: 100%; height: 100%; position: fixed; top: 0; left: 0; z-index: 1005; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
			
		<div class="layerpopup"  style="z-index: 2000; position: fixed;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</div>		
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
<!-- 일정관리 -->
<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/schedulePortlet.js')}"></script>		
<c:choose>
	<c:when test="${checkBrowser == true}">
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/sCalendarMini_IEEIP.js')}"></script>
	</c:when>
	<c:otherwise>
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/sCalendarMini_EIP.js')}"></script>
	</c:otherwise>
</c:choose>
<!-- 일정관리 끝 -->
<script type="text/javascript">
	var portletOrder = JSON.parse('${portletOrder}');
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
 	var WorkspaceUrl = "${workspaceHostUrl}"; // 협업이 그룹웨어와 별도의 Url로 서비스 되는 경우에만 설정
    var workspaceContextRootUrl = "${workspaceContextRootUrl}";
    var userLang = "<c:out value='${userLang}'/>";
    var userLang2 = "<c:out value='${userLang2}'/>";
 	
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
		$("#featured").orbit();
		
		var portletCount = portletOrder.length;
		var portletHTML = "";
		
		for (var i = 0; i < portletCount; i++) {
			portletHTML += "<div class='portlet' id='" + portletOrder[i].portletId + "Portlet'></div>";
		}
		
		$(".portlet_area").html(portletHTML);
 		frameSetting(frameId);
		
		for (var i = 0; i < portletCount; i++) {
			var portletId = portletOrder[i].portletId;
			var portletUrl = portletOrder[i].portletUrl;
			var portletName = portletOrder[i].portletName;
			var portletCode = portletOrder[i].portletCode;
			
			/* if (portletUrl.indexOf("ezNewPortal") != -1) { */
				(function (portletId, portletUrl, portletName, portletCode) {
					$.ajax({
						type : "GET",
						dataType : "html",
						data : {"portletId" : portletId, "portletName" : portletName, "usedTheme" : usedTheme},
						url : portletUrl,
						tryCount : 0,
						retryLimit : 3,
						success : function(result) {
							$("#" + portletId + "Portlet").append(result);
							
							/* 2023-06-08 홍승비 - 디자인 개선을 위해 테마3의 모든 포틀릿 background 스타일 제거  */
							//if (portletId != "34") {
							$("#" + portletId + "Portlet").css("background", "");
							//}
							
							eventSetting(portletId, usedTheme, portletCode, false);
							
							if (navigator.userAgent.toLowerCase().indexOf("firefox") != -1) {
								sortableEvent();
							}
						},
						error : function() {
							var nonePage = "<article class='box_shadow'></article>"
							$("#" + portletId + "Portlet").append(nonePage);
						},
						error : function() {
							this.url = "/ezNewPortal/errorPortlet.do";
							this.tryCount++;
							
							if (this.tryCount <= this.retryLimit) {
								//try again
								$.ajax(this);
								return;
							}
							
							if (navigator.userAgent.toLowerCase().indexOf("firefox") != -1) {
								sortableEvent();
							}
							
							return;
						}
					});
				}(portletId, portletUrl, portletName, portletCode));
			/* } */
			
		}
		
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
		getQuickLink();		
		
		//포틀릿 드래그 앤 드롭
		if (navigator.userAgent.toLowerCase().indexOf("firefox") == -1) {
			sortableEvent();
		}
		
		/* $(".portlet_area").disableSelection(); */
		
		setPortalRefresh();
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
				$(".info_right").css("width", "calc(100% - 194px)");
				$(".info_right").css("background", "#ffffff");
			} else if (media1686.matches) {
				$(".portlet").addClass("two_column");
				$(".info_left").css("display", "inline-block");
				$(".info_left").css("float", "left");
				$(".info_left").css("width", "189px");
				$(".info_left").css("margin-right", "5px");
				$(".info_left").css("background", "url(/images/ezNewPortal/theme3Img/info_background.png) center center no-repeat");
				$(".info_right").css("width", "calc(100% - 194px)");
				$(".info_right").css("background", "#ffffff");
			} else if (media1685.matches) {
				$(".portlet").addClass("two_column");
				$(".info_left").css("display", "inline-block");
				$(".info_left").css("float", "left");
				$(".info_left").css("width", "189px");
				$(".info_left").css("margin-right", "5px");
				$(".info_left").css("background", "url(/images/ezNewPortal/theme3Img/info_background.png) center center no-repeat");
				$(".info_right").css("width", "calc(100% - 194px)");
				$(".info_right").css("background", "#ffffff");
			} else if (media1589.matches) {
				$(".portlet").removeClass("two_column");
			} else if (media1279.matches) {
				$(".portlet").removeClass("two_column");
			}
		}
	}
	</script>
	</body>
</html>