<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%
	response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, post-check=0, pre-check=0");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
%> 
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezNewPortal.t009' /></title>
		<link href="${util.addVer('/css/default.css')}" rel="stylesheet" type="text/css">
		<link href="${util.addVer('main.default.css', 'msg')}" rel="stylesheet" type="text/css">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezNewPortal/portal.css')}" />
		<link href="${util.addVer('main.portal', 'msg')}" rel="stylesheet" type="text/css">
		<link rel="stylesheet"  href="${util.addVer('/css/ezNewPortal/jquery.flipster.min.css')}" type="text/css">
		<link rel="stylesheet"  href="${util.addVer('/css/ezMemo/jquery.mCustomScrollbar.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/jquery-flipster-master/dist/jquery.flipster.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<style type="text/css">
			html { height: 100%; }
			#set-body { background-color: white;}
			.set-head { background-color: rgb(228, 238, 254); height:44px; line-height:42px; display: flex; align-items: center; margin:0 0 18px; padding:0px;}
			.set-head h1 { font-size: 16px; margin-left: 20px; color:black;}
/* 			.set-portlet{ margin-top: 20px;display: flex;flex-direction: column; align-items: center;} */
			.set-action { height: 9%; display: flex; justify-content: center; align-items: center;} 
			.flipsterLi { width:95px; height: 64px; margin-top:20px; margin-left:20px; padding:20px; background:#fff;}
			.frameList { height: 151px; /* background-color: #e0e3e4; */ margin-left: 20px; margin-right: 20px;}
			
			.select-flipster {border:1px solid #2196f3;}
			.paginationBtn { border: 1px solid black; width: 100px; height: 30px; margin-left:20px; margin-right:20px;}
			
			/*.switch {margin-top:15px;} */
			.flipster__container {margin-left:-20px;}
			.mCSB_container {margin-right:10px !important; padding:0;}
			.flipster__button {height:65px;}
			.fixed_span img { vertical-align: top; margin: 3px 5px 0px 0px;}
			/* Tooltip text */
			.fixed_span .tooltiptext {
				visibility: hidden;
			    width: 132px;
			    background-color: rgba(66, 66, 66, 0.5);
			    color: #fff;
			    text-align: center;
			    padding: 5px 0;
			    border-radius: 6px;
			    position: absolute;
			    font-weight: normal;
			    z-index: 1;
			    top: 6px;
			    opacity: 0;
			    transition: opacity 1s;
			}
			
			/* Show the tooltip text when you mouse over the tooltip container */
			.fixed_span img:hover ~ .tooltiptext {visibility: visible;opacity: 1;}
			.fixed_span .tooltiptext::after {
				content: " ";
				position: absolute;
				top: 40%;
				right: 100%;
				margin-top: -5px;
				border-width: 5px;
				border-style: solid;
				border-color: transparent rgba(0,0,0, 0.5) transparent transparent;
			}

			._mCS_2 {overflow: auto;}
			#fixBoardList .mCSB_scrollTools_vertical{display:none !important;}
		</style>
	</head>
	<body id="set-body" class="set-body">
		<section class="set-head">
			<h1><spring:message code='ezNewPortal.HSBPT01' /></h1>
		</section>
		<section class="set-tab">
			<ul>
				<li id="t1" class=""><spring:message code='ezPortal.settingThemeAndMode' /></li>
				<li id="t2" class="on"><spring:message code='ezPortal.t134' /></li>
			</ul>
		</section>
		<div style="height: calc(100% - 160px);overflow-y: auto;">
			<section class="set-frame" style="display:none;">
				<h3><spring:message code='ezPortal.t990022' /></h3>
				<ul class="form_set theme" id="themeSet">
					<li class="default select">
						<span class="form_image"></span>
						<span class="form_name"><spring:message code='ezPortal.defaultTheme' /></span>
					</li>
					<li class="shortcut">
						<span class="form_image"></span>
						<span class="form_name"><spring:message code='ezPortal.shortcutTheme' /></span>
					</li>
					<li class="separation">
						<span class="form_image"></span>
						<span class="form_name"><spring:message code='ezPortal.separationTheme' /></span>
					</li>
				</ul>
				<h3><spring:message code='ezPortal.settingMode' /></h3>
				<ul class="form_set mode default" id="modeSet">
					<li class="white select">
						<span class="form_image"></span>
						<span class="form_name">White</span>
					</li>
					<li class="blue">
						<span class="form_image"></span>
						<span class="form_name">Blue</span>
					</li>
					<li class="red">
						<span class="form_image"></span>
						<span class="form_name">Red</span>
					</li>
					<li class="dark">
						<span class="form_image"></span>
						<span class="form_name">Dark Mode</span>
					</li>
				</ul>
				<h3><spring:message code='ezNewPortal.topMenu.hth03' /></h3>
				<ul class="form_set menu default" id="menuSet">
					<li class="top select">
						<span class="form_image"></span>
						<span class="form_name"><spring:message code='ezNewPortal.topMenu.hth11' /></span>
					</li>
					<li class="left">
						<span class="form_image"></span>
						<span class="form_name"><spring:message code='ezNewPortal.topMenu.hth12' /></span>
					</li>
				</ul>
			</section>
			<section class="set-portlet" id="set-portlet">
				<h3 id="fixPortletText"><spring:message code='ezPortal.fixedPortlet' /></h3>
				<div class="ui-portlet-list" id="fixBoardList"></div>
				<h3><spring:message code='ezPortal.t134' />
					<div class="cont_slide_check">
						<label>
							<input id="pagingSetting" type="checkbox"><spring:message code='ezNewPortal.usePaging' />
						</label>
					</div>
				</h3>
				<div class="ui-portlet-list portlet-scroll" id="portletList"></div>
			</section>
		</div>
		<div class="btnpositionLayer" style="margin:20px 0px 0px;">
			<a class="imgbtn">
				<span id="saveBtn"><spring:message code='ezNewPortal.t002' /></span>
			</a>
			<a class="imgbtn">
				<span id="cancelBtn"><spring:message code='ezNewPortal.t001' /></span>
			</a>
		</div>
		<div id="close" class="portalSetting">
			<ul>
				<li><span id="closeBtn"></span></li>
			</ul>
		</div>
		<script type="text/javascript">
			var mainFrame = window.parent.parent.document.getElementsByName('main')[0].contentWindow;
			var topFrame = window.parent.parent.document.getElementsByName('top')[0].contentWindow;
			var portletSetting = {
				selectedFrame: '',
				usedTheme: mainFrame.usedTheme
			};
			
			var bodyFrameSetting = function (type) {
				var bodyFrame = parent.document.getElementsByClassName('mainbg')[0];
			
				if (type === "on") {
			    bodyFrame.style.width = '100%';
				    bodyFrame.style.position = 'fixed';
				    bodyFrame.style.overflowY = 'scroll';				
				} else if (type === "off") {
				    bodyFrame.style.width = '';
				    bodyFrame.style.position = '';
				    bodyFrame.style.overflowY = '';				
				}
			}
			
			// 2024-08-21 조수빈 - 포탈 설정 변경 확인용 변수
			var beforeTheme = mainFrame.usedTheme - 1;
			var beforeDisplayMenu = topFrame.menuDisplayMode;
			var beforeUseColor = topFrame.useColor;
			const initialStates = {};
			
			$(function() {
				$("#closeBtn").on("click", popupClose);
				$("#cancelBtn").on("click", popupClose);
			
				var selectFrame = function () {
					var selectedFrame = document.querySelector('div.select-flipster');
					selectedFrame && selectedFrame.classList.remove('select-flipster');
					
					// 선택된 내용에 select-flipster 추가하기.
					var currentLi = document.querySelector('li.flipster__item--current').firstChild;
					var currentFrame = currentLi.firstElementChild;
					currentFrame.classList.add('select-flipster');
					
					// 설정된 프레임id
					portletSetting.selectedFrame = currentFrame.getAttribute("frameid");
					/* portletSetting.selectedFrame = currentFrame.dataset.frameid;  */
				}	
				
				// 프레임 리스트 출력
				var getUserFrameList = function () {
					var xhr = new XMLHttpRequest();
					xhr.onload = function () {
						if (xhr.status >= 200 && xhr.status < 300) {
							var ul = document.getElementById('frameUl');
							var frameList = JSON.parse(xhr.responseText).data.frameList;
							var usedIndex = -1;
							
							frameList.forEach(function (item, index) {
								var li = document.createElement('li');
								var div = document.createElement('div');
								div.className = 'flipsterLi';
								
								// 최초 회사 frame 설정
								if(usedIndex == -1 && item.frameDefault) {
									div.classList.add('select-flipster');
									portletSetting.selectedFrame = item.usedFrame;
									portletSetting.usedTheme = item.themeId;	
									usedIndex = index;
								}
								
								// 사용자가 선택한 frame 설정
								if (item.usedFrame*1 === item.frameId*1) {
									var selectFlipster = document.getElementsByClassName('select-flipster')[0];
									
									if(selectFlipster !== undefined) {
										selectFlipster.classList.remove('select-flipster');
									}
									div.classList.add('select-flipster');
									portletSetting.selectedFrame = item.usedFrame;
									portletSetting.usedTheme = item.themeId;
									usedIndex = index;
								}
								
								div.setAttribute("frameid", item.frameId);
								div.setAttribute("themeid", item.themeId);
								/* div.dataset.frameid = item.frameId;
								div.dataset.themeid = item.themeId; */
								// 프레임 이미지 나오면 변경하자!!
								var img = document.createElement('img');
								img.src = '/images/admin/theme' + item.themeId + "_frame" + item.frameId + ".png";
								
								div.appendChild(img);
								li.appendChild(div);
								ul.appendChild(li);
							});

							// jquey flipster 적용
 							$(".frameList").flipster({
								style: 'carousel',
							    spacing: -0.4,
							    nav: false,
							    buttons: true,
							    start: (usedIndex*1),
							    fadeIn : 0,
							});					

							// 프레임이 한 개인 경우 별도 처리
							var listCnt = frameList.length; 
							if(listCnt === 1) {
								var onlyOneFrame = document.getElementById('frameList');
								onlyOneFrame.style.display = 'flex';
								onlyOneFrame.style.justifyContent = 'center';
							}
							
							// 배경색은 리스트 화면에 출력할 때 설정하는 걸로!
							var frameList = document.getElementById('frameList').style.backgroundColor = '#e0e3e4';
							
							// flipsterBtn 위치 고정
							var flipsterBtnPrev = document.getElementsByClassName('flipster__button--prev')[0];
							var flipsterBtnNext = document.getElementsByClassName('flipster__button--next')[0];
							if(flipsterBtnPrev !== undefined && flipsterBtnNext !== undefined) {
								//flipsterBtnPrev.style.top = '9%';
								//flipsterBtnNext.style.top = '9%';
								// 2021-02-24 박기범 - 화살표 버튼으로도 프레임 선택되게 수정
								flipsterBtnPrev.addEventListener('click',currentClick);
								flipsterBtnNext.addEventListener('click',currentClick);
							}
							
							if(listCnt !== 1) {
								var frameUl = document.getElementById('frameUl');
								HTMLCollection.prototype.forEach = Array.prototype.forEach;
								frameUl.children.forEach(function(item, index) {
									item.addEventListener('click', selectFrame);
								});								
							}
						} else {
							console.error(xhr.responseText);	
						}
					}
					xhr.open('GET', '/ezNewPortal/getUserFrameList.do?' + (new Date()).getTime());
					xhr.send();
				}
			
				// getUserFrameList();
				bodyFrameSetting('on');
				
				var saveBtn = document.getElementById('saveBtn');
				saveBtn.addEventListener('click', updatePortalSettings);
			});
			
			function updatePortalSettings() {
				// 현재 보여지고 있는 화면의 내용만 저장함.
				// 테마에 따라 포틀릿의 종류가 변하기 때문에 테마 변경 시 포틀릿도 변경되어야 함.
				var activeTab = document.querySelector(".set-tab ul .on").getAttribute('id');
				
				if (activeTab == 't1') {
					// 테마/모드 설정 화면 저장
					var selectThemeElem = document.querySelector('#themeSet .select');
					var selectThemeIdx = Array.from(selectThemeElem.parentNode.children).indexOf(selectThemeElem);
					
					var selectModeElem = document.querySelector('#modeSet .select');
					var selectModeIdx = Array.from(selectModeElem.parentNode.children).indexOf(selectModeElem);
					
					var selectMenuElem = document.querySelector('#menuSet .select');
					var selectMenuIdx = Array.from(selectMenuElem.parentNode.children).indexOf(selectMenuElem);
					
					var param = {
							themeId: (selectThemeIdx + 1),
							useColor: selectModeIdx,
							menuDisplayMode: selectMenuIdx
						}
					
					var xhr = new XMLHttpRequest();
					xhr.onload = function () {
						if(xhr.status >= 200 && xhr.status < 300) {
							console.log('success', xhr.responseText);
			
							bodyFrameSetting('off');
							parent.DivPopUpHidden();
							window.close();
							window.parent.parent.document.location.reload();
						} else {
							console.error('failure', xhr.responseText);
						}
					}
					
					xhr.open('POST', '/ezNewPortal/updateUserThemeAndMode.do');
					xhr.setRequestHeader('Content-Type', 'application/json');
					xhr.send(JSON.stringify({param: param}));
				} else if (activeTab == 't2') {
					// 포틀릿 설정 화면 저장
					var portletList = [];
					var classList = document.getElementsByClassName('ui-portlet-span');
					var orderCount = 1;
					var usedCount = 0;
					// 반복문 돌면서 데이터 쌓기
					HTMLCollection.prototype.forEach = Array.prototype.forEach;
 					classList.forEach(function (item, index) {
 						var itemPortletId = item.getAttribute("portletid");
 						var itemMenuId = item.getAttribute("menuId");
						var switchBtn = document.getElementById('portletid_' + itemPortletId);
						var obj = null;
						var curr;
						if (!!item.getAttribute("data-fix")) {
							curr = item.getAttribute("portletorder");
						} else {
							curr = orderCount++;
						}
						
						obj = {
							portletId: itemPortletId,
							portletOrder: curr,
							menuId: itemMenuId,
							portletUsed : switchBtn.checked
						}

						if (switchBtn.checked) {
							usedCount++;
						}
						
						portletList.push(obj);
					});
 					
					var param = {
						frameId: portletSetting.selectedFrame,
						themeId: portletSetting.usedTheme,
						portletList: portletList,
						usePaging: !document.getElementById("pagingSetting").checked ? 0 : 1
					}
					
					if (usedCount < 1) {
						alert('<spring:message code="ezNewPortal.t011" />');	
						return;
					}
					
					var xhr = new XMLHttpRequest();
					xhr.onload = function () {
						if(xhr.status >= 200 && xhr.status < 300) {
							console.log('success', xhr.responseText);
			
							bodyFrameSetting('off');
							parent.DivPopUpHidden();
							window.close();
							window.parent.parent.document.location.reload();
						} else {
							console.error('failure', xhr.responseText);
						}
					}
					
					xhr.open('POST', '/ezNewPortal/updateUserFrameAndPortelt.do');
					xhr.setRequestHeader('Content-Type', 'application/json');
					xhr.send(JSON.stringify({param: param}));
				}
			}
			
			// 포틀릿 리스트 출력
			var getUserPortletList = function () {
				var xhr = new XMLHttpRequest();
				xhr.onload = function () {
					if (xhr.status >= 200 && xhr.status < 300) {
						var portletList = document.getElementById('portletList');
						var list = JSON.parse(xhr.responseText).data.portletList;
						var fixBoardList = document.getElementById('fixBoardList');
						
						while (portletList.firstChild) {
							portletList.removeChild(portletList.firstChild);
						}
						
						while (fixBoardList.firstChild) {
							fixBoardList.removeChild(fixBoardList.firstChild);
						}

						list.forEach(function (item, index) {
			 				var div = document.createElement('div');
			 				div.classList.add('ui-portlet');
			 				// 사용중인 포틀릿
			 				if (item.portletUsed === true || item.fixed === true) {
			 					div.classList.add('ui-portlet-on');
			 				} else {
			 					div.classList.add('ui-portlet-off');
			 				}
			 				
			 				div.classList.add('ui-portlet-content');

			 				
			 				//2018-12-18 유은정 - 포틀릿 필수 사용 지정 관련 개발
			 				var fixedSpan = document.createElement('div');
		 					fixedSpan.className = 'fixed_span';
			 				var fixedImg = "";
			 				var tooltipText = "";
			 				
			 				if (item.fixed === true) {
			 					fixedImg = document.createElement('span');
			 					fixedImg.className = 'fixed_portlet';
			 					tooltipText = document.createElement('span');
			 					tooltipText.className = 'tooltiptext';
			 					var contents = document.createTextNode("<spring:message code='ezNewPortal.t130' />");
			 					tooltipText.appendChild(contents);
			 				}
			 				
							var nameSpan = document.createElement('span');
							nameSpan.className = 'ui-portlet-span';
							nameSpan.textContent = item.portletName;
							nameSpan.setAttribute("portletid", item.portletId);
							nameSpan.setAttribute("portletorder", item.portletOrder);
							nameSpan.setAttribute("menuid", item.menuId);
							
							/* nameSpan.dataset.portletid = item.portletId;
							nameSpan.dataset.portletorder = item.portletOrder;
							nameSpan.dataset.menuid = item.menuId; */
							
							var label = document.createElement('label');
							label.className = 'switch';
							
							var input = document.createElement('input');
							input.type = 'checkbox';
							input.id = 'portletid_' + item.portletId;
							input.setAttribute("isfixed", item.fixed);
							/* input.dataset.isfixed = item.fixed; */
		
			 				// 사용중인 포틀릿
			 				if (item.portletUsed === true || item.fixed === true) {
			 					input.setAttribute('checked', true);
			 				}
			 				
			 				// checkbox click event
			 				input.addEventListener('click', function() {
			 					if(this.getAttribute('checked') && !this.getAttribute("isfixed")) {
			 						this.removeAttribute('checked');
			 						div.classList.remove('ui-portlet-on');
			 						div.classList.add('ui-portlet-off');
			 					} else {
			 						this.setAttribute('checked', true);
			 						div.classList.remove('ui-portlet-off');
			 						div.classList.add('ui-portlet-on');
			 					}
			 				});
							
							var slideSpan = document.createElement('span');
							slideSpan.classList.add('slider');
							slideSpan.classList.add('round');
							
							label.appendChild(input);
							label.appendChild(slideSpan);
							
							if (fixedImg != "") {
								fixedSpan.appendChild(fixedImg);
								fixedSpan.appendChild(tooltipText);
							}
							
							fixedSpan.appendChild(nameSpan);
							div.appendChild(fixedSpan);
							div.appendChild(label);

							if (item.fixBoard == true) {
								nameSpan.setAttribute("data-fix", "true");
								fixBoardList.appendChild(div);
							} else {
								portletList.appendChild(div);
							}
						});
						
						//event setting
						$(".switch").find("input").on("change", checkIsFixed);
						
						// $(".ui-portlet-list").mCustomScrollbar({
						// 	theme : "dark",
						// 	mouseWheelPixels: 70,
						// 	//scrollInertia: 60,
						// });
						
						// 최초의 on / off 설정 값 저장
						const usePortlets = document.querySelectorAll("#set-portlet input[type='checkbox']");
						
						for (var i = 0; i < usePortlets.length; i++) {
							var checkbox = usePortlets[i];
							initialStates[checkbox.id] = checkbox.checked;
						}
						
					} else {
						console.error(xhr.responseText);
					}
				}
				
				xhr.open('GET', '/ezNewPortal/getUserPortletList.do?' + (new Date()).getTime());
				xhr.send();
				
			}
			
			//2018-12-18 유은정 - 포틀릿 필수 사용 지정 관련 개발
			var checkIsFixed = function() {
				var isFixed = this.getAttribute("isfixed");
				
				if (isFixed === "true") {
					alert('<spring:message code="ezNewPortal.t131" />');
					$(this).prop("checked", true);
					document.getElementById(this.id).parentElement.parentElement.classList.remove('ui-portlet-off');
					document.getElementById(this.id).parentElement.parentElement.classList.add('ui-portlet-on');
					return;
				}
			}
			
			function popupClose() {
				bodyFrameSetting('off');
				parent.DivPopUpHidden();
				window.close();
			}

			function currentClick() {
				var current = document.getElementsByClassName("flipster__item--current");

				if (current.length > 0) {
					current[0].click();
				}
			}
			window.onload = function() {
				var tabs = document.querySelectorAll(".set-tab ul li");
				
				for (var i = 0; i < tabs.length; i++) {
					(function(tab) {
						tab.addEventListener("click", function() {
							
							if (checkChangeSettings()) {
								if (confirm("<spring:message code='ezPortal.saveSettings' />")) {
									updatePortalSettings();
									return;
								}
							}
							
							for (var j = 0; j < tabs.length; j++) {
								tabs[j].classList.remove("on");
							}
							
							tab.classList.add("on");
							
							if (tab.id == "t1") {
								document.querySelector(".set-frame").style.display = "block";
								document.querySelector(".set-portlet").style.display = "none";
								
								document.querySelectorAll('#themeSet li')[beforeTheme].click();
								document.querySelectorAll('#modeSet li')[beforeUseColor].click();
								document.querySelectorAll('#menuSet li')[beforeDisplayMenu].click();
								
							} else {
								document.querySelector(".set-frame").style.display = "none";
								document.querySelector(".set-portlet").style.display = "block";
								
								getUserPortletList();
							}
						});
					})(tabs[i]);
				}
				
				var themeTab = document.querySelectorAll(".form_set.theme li");
				
				for (var k = 0; k < themeTab.length; k++) {
					(function(theme) {
						theme.addEventListener("click", function() {
							
							for (var l = 0; l < themeTab.length; l++) {
								themeTab[l].classList.remove("select");
							}
							
							theme.classList.add("select");
						});
					})(themeTab[k]);
				}
				
				var modeTab = document.querySelectorAll(".form_set.mode li");
				
				for (var m = 0; m < modeTab.length; m++) {
					(function(mode) {
						mode.addEventListener("click", function() {
							
							for (var n = 0; n < modeTab.length; n++) {
								modeTab[n].classList.remove("select");
							}
							
							mode.classList.add("select");
						});
					})(modeTab[m]);
				}
				
				var menuTab = document.querySelectorAll(".form_set.menu li");
				
				for (var o = 0; o < menuTab.length; o++) {
					(function (menu) {
						menu.addEventListener("click", function() {
							
							for (var p = 0; p < menuTab.length; p++) {
								menuTab[p].classList.remove("select");
							}
							
							menu.classList.add("select");
						});
					})(menuTab[o]);
				}
				
				document.querySelector(".portlet-scroll").style.height = (window.innerHeight - 299) + "px";
				// 295는 메인 타이틀 / 탭 / 서브 타이틀 / 하단 버튼 영역 / margin 값 / 하단 여백 10 을 더한 값
				
	            if (document.querySelectorAll(".portlet-scroll .ui-portlet-content").length >= 15) {
					document.querySelector(".portlet-scroll").style.padding = "0 8px 0 20px";
				}
				
				var pagingSetting = document.getElementById("pagingSetting");
				
				if (mainFrame.usePaging == 1) {
					pagingSetting.checked = true;
				} else {
					pagingSetting.checked = false;
				}
				
				// 테마 2이면 공간은 차지하고 보이지는 않도록 함.
				if (mainFrame.usedTheme == '2') {
					document.getElementById('fixPortletText').style.color = 'white';
				}
				
				document.getElementById('themeSet').getElementsByTagName('li')[beforeTheme].click();
				document.getElementById('menuSet').getElementsByTagName('li')[beforeDisplayMenu].click();
				document.getElementById('modeSet').getElementsByTagName('li')[beforeUseColor].click();
				document.getElementById('t2').click();
				getUserPortletList();
	        }
			
			function checkChangeSettings() {
				var activeTab = document.querySelector(".set-tab ul .on").getAttribute('id');
				
				if (activeTab == 't1') {
					// 테마/모드 설정 화면
					var selectThemeElem = document.querySelector('#themeSet .select');
					var selectThemeIdx = Array.from(selectThemeElem.parentNode.children).indexOf(selectThemeElem);
					
					var selectModeElem = document.querySelector('#modeSet .select');
					var selectModeIdx = Array.from(selectModeElem.parentNode.children).indexOf(selectModeElem);
					
					var selectMenuElem = document.querySelector('#menuSet .select');
					var selectMenuIdx = Array.from(selectMenuElem.parentNode.children).indexOf(selectMenuElem);
					
					if (beforeTheme != selectThemeIdx || beforeUseColor != selectModeIdx || beforeDisplayMenu != selectMenuIdx) {
						return true;
					} else {
						return false;
					}
				} else if (activeTab == 't2') {
					// 포틀릿 설정 화면
					var checkboxes = document.querySelectorAll('#set-portlet input[type="checkbox"]');
					
					if (checkboxes.length > 1) {
						for (var i = 0; i < checkboxes.length; i++) {
							var checkbox = checkboxes[i];
							
							if (checkbox.checked !== initialStates[checkbox.id]) {
								return true;
							}
						}
					}
					
            		return false;
				}
			}
		</script>
	</body>
</html>