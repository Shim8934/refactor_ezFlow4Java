<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezNewPortal.t009' /></title>
		<link href="${util.addVer('main.e15', 'msg')}" rel="stylesheet" type="text/css">
		<link href="${util.addVer('/css/ezNewPortal/newPortal_css.css')}" rel="stylesheet" type="text/css">
		<link rel="stylesheet"  href="${util.addVer('/css/ezNewPortal/jquery.flipster.min.css')}" type="text/css">
		<link rel="stylesheet"  href="${util.addVer('/css/ezMemo/jquery.mCustomScrollbar.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/jquery-flipster-master/dist/jquery.flipster.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<style type="text/css">
			html { height: 100%; }
			#set-body { background-color: white; }
			h3 { padding-left: 20px; margin-top: 25px; margin-bottom: 10px; font-size:14px; }
			.set-head { background-color: #687077; height:44px; line-height:42px; display: flex; align-items: center; margin:0px; padding:0px;}
			.set-head h1 { font-size: 16px; margin-left: 20px; color:#fff;}
			.set-action { height: 9%; display: flex; justify-content: center; align-items: center;} 
			.ui-portlet { position:relative;  width: 230px; height: 47px; box-sizing:border-box; border-radius: 0px; padding-left: 10px; margin: 0px 10px 10px 0px; line-height: 20px;}
			.ui-portlet-on { background-color: #f0f0f0; }
			.ui-portlet-off { background-color: #f0f0f0; }
			.ui-portlet-off .ui-portlet-span{ color:#999;}
			.ui-portlet-content { font-weight: bold; display: inline-block;}
			.ui-portlet-list { padding-left: 20px; height: 335px; width: 97%;}
			.ui-portlet-span { display: inline-block; width: 70%; font-size:13px; color:#333; font-weight:normal;}
			.flipsterLi { width:95px; height: 64px; margin-top:20px; margin-left:20px; padding:20px; background:#fff;}
			.frameList { height: 151px; /* background-color: #e0e3e4; */ margin-left: 20px; margin-right: 20px;}
			
			.select-flipster {border:1px solid #2196f3;}
			.paginationBtn { border: 1px solid black; width: 100px; height: 30px; margin-left:20px; margin-right:20px;}
			
			.switch {margin-top:15px;}
			.flipster__container {margin-left:-20px;}
			.mCSB_container {margin-right:10px !important;}
			.flipster__button {height:65px;}
		</style>
	</head>
	<body id="set-body">
		<section class="set-head">
			<h1><spring:message code='ezNewPortal.t009' /></h1>
		</section>
		<section class="set-frame">
			<h3><spring:message code='ezNewPortal.t010' /></h3>
			<div class="frameList" id="frameList">
				<ul id="frameUl">
				</ul>
			</div>
		</section>
		<section class="set-portlet">
			<h3><spring:message code='ezNewPortal.t009' /></h3>
			<div class="ui-portlet-list" id="portletList"></div>
		</section>
		<div class="btnpositionLayer" style="margin:20px 0px 0px">
			<a class="imgbtn">
				<span id="saveBtn"><spring:message code='ezNewPortal.t002' /></span>
			</a>
			<a class="imgbtn">
				<span id="cancelBtn"><spring:message code='ezNewPortal.t001' /></span>
			</a>
		</div>
		<div id="close">
			<ul>
				<li><span id="closeBtn"></span></li>
			</ul>
		</div>
		<script type="text/javascript">
			var portletSetting = {
				selectedFrame: '',
				usedtheme: '',
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
					portletSetting.selectedFrame = currentFrame.dataset.frameid; 
				}	
				
				// 프레임 리스트 출력
				var getUserFrameList = function () {
					var xhr = new XMLHttpRequest();
					xhr.onload = function () {
						if (xhr.status >= 200 && xhr.status < 300) {
							var ul = document.getElementById('frameUl');
							var frameList = JSON.parse(xhr.responseText).data.frameList;
						
							frameList.forEach(function (item, index) {
								var li = document.createElement('li');
								var div = document.createElement('div');
								div.className = 'flipsterLi';
								
								// 최초 회사 frame 설정
								if(item.frameDefault) {
									div.classList.add('select-flipster');
									portletSetting.selectedFrame = index;
									portletSetting.usedTheme = item.themeId;						
								}
								
								// 사용자가 선택한 frame 설정
								if (item.usedFrame*1 === item.frameId*1) {
									var selectFlipster = document.getElementsByClassName('select-flipster')[0];
									
									if(selectFlipster !== undefined) {
										selectFlipster.classList.remove('select-flipster');
									}
									div.classList.add('select-flipster');
									portletSetting.selectedFrame = index;
									portletSetting.usedTheme = item.themeId;
								}
								div.dataset.frameid = item.frameId
								div.dataset.themeid = item.themeId;
								
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
							    start: (portletSetting.selectedFrame*1),
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
					xhr.open('GET', '/ezNewPortal/getUserFrameList.do');
					xhr.send();
				}
			
				// 포틀릿 리스트 출력
				var getUserPortletList = function () {
					var xhr = new XMLHttpRequest();
					xhr.onload = function () {
						if (xhr.status >= 200 && xhr.status < 300) {
							var portletList = document.getElementById('portletList'); 
							var list = JSON.parse(xhr.responseText).data.portletList;

							list.forEach(function (item, index) {
						
				 				var div = document.createElement('div');
				 				div.classList.add('ui-portlet');
				 				// 사용중인 포틀릿
				 				if (item.portletUsed === true) {
				 					div.classList.add('ui-portlet-on');
				 				} else {
				 					div.classList.add('ui-portlet-off');
				 				}	 				
				 				
				 				div.classList.add('ui-portlet-content');
								var nameSpan = document.createElement('span');
								nameSpan.className = 'ui-portlet-span';
								nameSpan.textContent = item.portletName;
								nameSpan.dataset.portletid = item.portletId;
								nameSpan.dataset.portletorder = item.portletOrder;
								nameSpan.dataset.menuid = item.menuId;
								
								var label = document.createElement('label');
								label.className = 'switch';
								
								var input = document.createElement('input');
								input.type = 'checkbox';
								input.id = 'portletid_' + item.portletId;
			
				 				// 사용중인 포틀릿
				 				if (item.portletUsed === true) {
				 					input.setAttribute('checked', true);
				 				}
				 				
				 				// checkbox click event
				 				input.addEventListener('click', function() {
				 					if(this.getAttribute('checked')) {
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
								div.appendChild(nameSpan);
								div.appendChild(label);			
								
								portletList.appendChild(div);
							});
			
							$(".ui-portlet-list").mCustomScrollbar({
								theme : "dark",
								mouseWheelPixels: 70, 
								//scrollInertia: 60,
							});						
						} else {
							console.error(xhr.responseText);	
						}
					}
					xhr.open('GET', '/ezNewPortal/getUserPortletList.do');
					xhr.send();	
				}
				
				getUserFrameList();
				getUserPortletList();
				bodyFrameSetting('on');
				
				var saveBtn = document.getElementById('saveBtn');
				saveBtn.addEventListener('click', function (){
					var portletList = [];
					var classList = document.getElementsByClassName('ui-portlet-span');
					// 반복문 돌면서 데이터 쌓기
					HTMLCollection.prototype.forEach = Array.prototype.forEach;
 					classList.forEach(function (item, index) {			
						var switchBtn = document.getElementById('portletid_' + item.dataset.portletid);
						if (switchBtn.getAttribute('checked')) {
							var obj = {
								portletId: item.dataset.portletid,
								portletOrder: item.dataset.portletorder,
								menuId: item.dataset.menuid
							}
							portletList.push(obj);				
						}
					});
 					
					// 유저 포틀릿 순서로 재정의
					var temp = [];
					for(var i=0; i<portletList.length; i++) {
						for(var j=i; j<portletList.length; j++) {
							if(portletList[i].portletOrder*1 > portletList[j].portletOrder*1) {
								temp = portletList[i];
								portletList[i] = portletList[j];
								portletList[j] = temp;
							}
						}
					}

					// var reAssemble = [];
					// 순서 재정렬 시작
					var arrIndex = 1;
					portletList.forEach(function (item, index) {
						if(item.portletOrder*1 !== 0 ) {
							item.portletOrder = arrIndex;
							arrIndex++;
						}
					});
					
					portletList.forEach(function (item, index) {
						if(item.portletOrder*1 === 0) {
							item.portletOrder = arrIndex;
							arrIndex++;
						}
					});
					// 순서 재정렬 끝
					console.log('portletList ', portletList);
					
					var param = {
						frameId: portletSetting.selectedFrame,
						themeId: portletSetting.usedTheme,
						portletList: portletList,
					}					
					
					console.log('param', param.portletList);					
					
					if(param.portletList.length < 1) {
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
							parent.document.location.reload()
						} else {
							console.error('failure', xhr.responseText);
						}
					}
					xhr.open('PATCH', '/ezNewPortal/updateUserFrameAndPortelt.do');
					xhr.setRequestHeader('Content-Type', 'application/json');
					xhr.send(JSON.stringify({param: param}));
				});
			
			});
			
			
			function popupClose() {
				bodyFrameSetting('off');
				parent.DivPopUpHidden();
				window.close();
			}		
		</script>
	</body>
</html>