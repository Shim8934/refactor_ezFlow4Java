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
<link href="${util.addVer('/css/ezNewPortal/theme3_main.css')}" rel="stylesheet" type="text/css">
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
	.mainbg {
		min-width : 1280px;
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
	.two_column {width:48.4%;}
</style>
</head>
<body class="mainbg" id="theme3Body">
	<div id="Center">
	<div style="position:relative;">
		<aside id="quickSide" style="width:0px">
			<p class="linkBtn_close" id="linkBtn_open"><img id="quicklinkBtn" src="/images/ezNewPortal/theme3Img/linkBtn_open.png"></p>
			<div class="aside_quick">
				<p class="quickmenu_title"><spring:message code='ezNewPortal.t020' /></p>
				<ul class="quickmenu">
					<li id="quickMailwrite"><span class="icon"><img src="/images/ezNewPortal/quick01.png"></span><span class="txt"><spring:message code='ezNewPortal.t021' /></span></li>
					<li id="quickApprovalwrite"><span class="icon"><img src="/images/ezNewPortal/quick02.png"></span><span class="txt"><spring:message code='ezNewPortal.t022' /></span></li>
					<li id="quickSchedulewrite"><span class="icon"><img src="/images/ezNewPortal/quick03.png"></span><span class="txt"><spring:message code='ezNewPortal.t023' /></span></li>
					<li id="quickOrgan"><span class="icon"><img src="/images/ezNewPortal/quick04.png"></span><span class="txt"><spring:message code='ezNewPortal.t024' /></span></li>
				</ul>
			</div>
			<div class="aside_link">
				<p class="linkmenu_title"><spring:message code='ezNewPortal.t025' /></p>
				<ul class="linkmenu" id="QuickUl">
				</ul>
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
	var photoCount = 4;
 	var nowAttiTime = "";
 	var ptlNowAttiTime = "";
 	var beforeAlertDate = "";
	var afterAlertDate = "";
	var overTime = "";
 	var serverTime = "<c:out value='${serverTime}'/>";
 	var birthdayMonth = Number("<c:out value='${nowMonth}'/>");
 	var birthdayCurPage = 0;
 	var birthdayTotalCount = 0;
 	var timer;
 	var frameId = "<c:out value='${usedFrame}'/>";
 	var usedTheme = "<c:out value='${usedTheme}'/>";
 	
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
 		
 		var quickUl = document.getElementById('QuickUl');
 		
 		// 현재 리스트를 갖고 있는 경우 삭제 후 진행
 		while (quickUl.hasChildNodes()) {
 			quickUl.removeChild(quickUl.firstChild);
 		}
 		
		quickList.forEach(function (item, index) {
			var li = document.createElement('li');
			li.classList.add('linkText');
			li.textContent = item.quickLinkName;
			
			// 이벤트 등록
			li.addEventListener('click', function(){
				// size가 FULL인 경우 vs 아닌 경우
				if(item.size === 'FULL') {
					window.open(item.url, '_blank', '');
				} else if (item.size.indexOf(':') > 0) {
					var sizeArr = item.size.split(':');
					var popupX = (window.screen.width / 2) - (sizeArr[0] /2);
					var popupY = (window.screen.height / 2) - (sizeArr[1] /2);
					var option = 'width='+sizeArr[0]+'px,height='+sizeArr[1]+'px, left='+popupX+', top='+popupY+', status = no, toolbar=no, menubar=no,location=no, resizable=0';
					window.open(item.url, '_blank', option);
				}
			});
			
			quickUl.appendChild(li);
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
		
		if(quickLinkPage.current*1 === 1 || totalCnt*1 === 0) {
			preBtnImg.setAttribute('src', '/images/ezNewPortal/link_preBtn_dis.png');
			preBtnImg.setAttribute('id', 'preBtnDis');
		} else {
			preBtnImg.setAttribute('src', '/images/ezNewPortal/link_preBtn.png');
			preBtnImg.setAttribute('id', 'preBtn');
		}
		
		linkBtnPre.appendChild(preBtnImg);
		
		var linkBtnNext = document.createElement('span');
		linkBtnNext.classList.add('linkBtn_next');
		var nextBtnImg = document.createElement('img');
		
		if(quickLinkPage.current*1 === totalCnt*1 || totalCnt*1 === 0) {
			nextBtnImg.setAttribute('src', '/images/ezNewPortal/link_nextBtn_dis.png');
			nextBtnImg.setAttribute('id', 'nextBtnDis');
		} else {
			nextBtnImg.setAttribute('src', '/images/ezNewPortal/link_nextBtn.png');
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
			if (portletUrl.indexOf("ezNewPortal") != -1) {
				(function (portletId, portletUrl, portletName) {
					$.ajax({
						type : "POST",
						dataType : "html",
						data : {"portletId" : portletId, "portletName" : portletName, "usedTheme" : usedTheme},
						url : portletUrl,
						success : function(result) {
							$("#" + portletId + "Portlet").append(result);
							
							if(portletId != "34") {
								$("#" + portletId + "Portlet").css("background", "none");
							}
							
							eventSetting(portletId, usedTheme);
						},
						error : function() {
							var nonePage = "<article class='box_shadow'></article>"
							$("#" + portletId + "Portlet").append(nonePage);
						}
					});
				}(portletId, portletUrl, portletName));
			}
		}
		
		var useQuestion = "<c:out value='${useQuestion}'/>";
		var useCircular = "<c:out value='${useCircular}'/>";
		var useMail = "<c:out value='${useMail}'/>";
		var useApproval = "<c:out value='${useApproval}'/>";
		var useSchedule = "<c:out value='${useSchedule}'/>";
		
		//권한에 없는거는 보여주지 않기
		if (useQuestion === "NO") {
			$("#Poll").css("display", "none");
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
		$("#quickMailwrite").on('click', {'menu' : 'mail'}, quickMenuOpenRight);
		$("#quickApprovalwrite").on('click', {'menu' : 'appr'}, quickMenuOpenRight);
		$("#quickSchedulewrite").on('click', {'menu' : 'schedule'}, quickMenuOpenRight);
		$("#quickOrgan").on('click', {'menu' : 'organ'}, quickMenuOpenRight);
		
		//구해안 - 임시로 넣어둠
		$("#portletEnv").on("click", viewPortletEnv);
		
		//구해안 - 테마3일때 일정포틀릿이랑 나의정보 포틀릿은 background 지워버리기
		$("#36portlet").css("background-color","none");
		$("#6portlet").css("background-color","none");

		// 퀵링크 호출
		getQuickLink();		
		
		//포틀릿 드래그 앤 드롭
		$(".portlet_area").sortable({
			handle : ".sortablePortlet",
			helper : "clone",
			start : function (event, block) {
				/* 
				$(".portlet.ui-sortable-helper").css("width", $(".portlet").not(block.item).not(block.placeholder).outerWidth());
				
				$(".ui-sortable-placeholder").css({
					'width' : $(".portlet").not(block.item).not(block.placeholder).outerWidth(),
					'height' : $(".portlet").not(".ui-sortable-helper").outerHeight()
				}); */
			},
			update : function(event, ui) {
				updatePortletOrderUser();
			}
		});
		
		$(".portlet_area").disableSelection();
		
	});
	
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
				$(".portlet").addClass("two_column");
				$(".info_left").css("display", "none");
				$(".info_right").css("width", "100%");
				$(".info_right").css("margin-left", "0px !important");
			} else if (media1279.matches) {
				$(".portlet").css("width", "");
				$(".box_shadow.info_left").css("display", "none");
				$(".box_shadow.info_right").css("width", "100%");
				$(".box_shadow.info_right").css("margin-left", "0px !important");
			}
		}
	}
	</script>
	</body>
</html>