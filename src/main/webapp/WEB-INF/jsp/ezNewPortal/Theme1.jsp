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
<link href="${util.addVer('/css/ezNewPortal/portal.css')}" rel="stylesheet" type="text/css">
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
	.slider_section {height:515px; width:280px;}
	.right_float {float:right;}
	#nodata_NewBirth {display:none;}
	#featured {background : none;}
	.box_shadow {width:100%; margin:0px;}
	.portlet {height:250px; margin:20px 0px 0px 20px;background-color:#ffffff;}
	.infoImg img {width:60px; height:60px; border-radius:90px;-webkit-border-radius:90px;}
	.attitudePtl {border:none;}
	.two_column{width:47.7%;}
	.orbit-wrapper .timer {display:none;}
	.linkIcon {display: block; margin: 0 auto; padding: 9px 0px 5px 0px; text-align: center;}
	.linkIcon img {height: 30px; width: 30px;}
	.linkTxt {display: block; width: 78px; text-align: center; color: #333; font-size: 12px; height: 27px; letter-spacing: 0px; overflow: hidden;margin: 0 auto; padding: 2px 0px 0px 0px; word-break: break-all; line-height: 15px; text-overflow: ellipsis; white-space: nowrap;}
</style>
</head>
<body class="mainbg" id="theme1Body">
	<div id="center">
	<c:if test="${usedFrame eq 'Frame2'  || usedFrame eq 'Frame4'}">
		<section class="section_left right_float" style="height:1130px;">
	</c:if>
	<c:if test="${usedFrame eq 'Frame1'  || usedFrame eq 'Frame3'}">
		<section class="section_left" style="height:1130px;">
	</c:if>
			<article class="rolling_info">
			<div class="slider_section">
				<div class="rolling" id="featured">
            	<c:choose>
	            	<c:when test="${not empty sliderList}">
	            		<c:forEach items="${sliderList}" var="slider">
		            		<c:choose>
		            			<c:when test="${fn:substring(slider.url, 0, 4) eq 'http' }">
		            				<img src="${slider.imagePath}" class="notEmptySlider" onclick="window.open('${slider.url }')" />
		            			</c:when>
		           		 		<c:otherwise> 
									<img src="${slider.imagePath}" class="notEmptySlider" onclick="window.open('http://${slider.url }')" />
								</c:otherwise>
							</c:choose>
						</c:forEach>
	           		</c:when>
	            	<c:otherwise>
		            	<img src="/images/ezNewPortal/rolling01.png" width="280" height="515" />
		            	<img src="/images/ezNewPortal/rolling01.png" width="280" height="515" />
	            	</c:otherwise>
	            </c:choose>
           	 	</div>
			</div>
           	 	<dl class="info">
            		<dt class="infoImg"><c:if test='${userPhoto == ""}'><img src="/images/ezNewPortal/info_pic_none.png"  width="36px" height="36px" style="width:36px;height:36px;" /></c:if><c:if test='${userPhoto != ""}'><img id="myImg" src="/ezCommon/downloadAttach.do?filePath=${userPhoto }"></c:if></dt>
               		<dd class="infoName">${userName} ${userTitle}</dd>
                	<dd class="infoTeam">${deptName}</dd>
                	<%-- <dd class="infoTeam"><spring:message code="main.t00016" /> ${lastLogin }</dd> --%>
                	<dd class="infoSet" id="personalEnv"><img src="/images/kr/main/info_set.png"></dd>
                	<dd class="infoSet" id="portletEnv" style="color:white;right : 30px;"><img src="/images/admin/frameSetting.png" /></dd><!-- 임시용 -->
           		</dl>
			</article>
			<article class="main_time_check">
				<c:choose>
					<c:when test="${useAttitude eq 'YES' }">
						<div id="timeinput" class="main_presentTime">
	               			<p class="main_timeTit" id="todayTime"><spring:message code='ezNewPortal.t012' /></p>
							<div id="timeFlow" class="main_timeText"></div>
			    		</div>
			   			<div id="atti_area" class="main_main_time">
	            			<dl class="main_timeCheckIn">
	                			<dd id="inAttiBtn" class="main_out" type="A01" datetype="2" onclick="checkHoliday(this, '${usedTheme}')"><spring:message code='ezNewPortal.t013' /></dd>
	                		</dl>
	                		<dl class="main_timeCheckOut">
	                   			<dd id="outAttiBtn" class="main_out" type="A03" datetype="2" onclick="checkHoliday(this, '${usedTheme}')"><spring:message code='ezNewPortal.t014' /></dd>
	                		</dl>
		    			</div>
					</c:when>
					<c:otherwise>
						<div id="timeinput" class="main_presentTime presentTime_commuteNone">
	               			<p class="main_timeTit" id="todayTime"><spring:message code='ezNewPortal.t012' /></p>
							<div id="timeFlow" class="main_timeText"></div>
			    		</div>
					</c:otherwise>
				</c:choose>
			</article>
				
				<article class="countingIcon">
					<div class="countingIcon01">
						<c:choose>
							<c:when test="${useMail eq 'NO'}"> <!-- 메일 권한이 없을때 disable 아이콘 나타남 -->
								<dl id="NewMail" class="icon_disabled">
									<dt class="iconCircle_none"><span class="iconCommon"></span></dt>
									<dd class="iconText"></dd>
								</dl>
							</c:when>
							<c:otherwise>
								<dl id="NewMail">
                					<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon01.png"></dt>
                    				<dd class="iconText"><spring:message code='ezNewPortal.t015' /></dd>
                    				<dd id="unreadMailCount" class="iconCount_none">0</dd>
                				</dl>
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${useApproval eq 'NO'}"> <!-- 전자결재 권한이 없을 때 disable 아이콘 나타남 -->
								<dl id="AprSign" class="icon_disabled">
									<dt class="iconCircle_none"><span class="iconCommon"></span></dt>
									<dd class="iconText"></dd>
								</dl>
							</c:when>
							<c:otherwise>
                				<dl id="AprSign">
                    				<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon03.png"></dt>
                    				<dd class="iconText"><spring:message code='ezNewPortal.t016' /></dd>
                    				<dd id="approvalCount" class="iconCount_none">0</dd>
                				</dl>
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${useSchedule eq 'NO'}"> <!-- 일정 권한이 없을 때 disable 아이콘 나타남 -->
								<dl id="Schedule" class="icon_disabled">
									<dt class="iconCircle_none"><span class="iconCommon"></span></dt>
									<dd class="iconText"></dd>
								</dl>
							</c:when>
							<c:otherwise>
                				<dl id="Schedule">
                  		  			<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon02.png"></dt>
                    				<dd class="iconText"><spring:message code='ezNewPortal.gu3' /></dd>
                		  	  	<dd id="scheduleCount" class="iconCount_none">0</dd>
               					</dl>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="countingIcon02">
					<c:choose>
						<c:when test="${useQuestion eq 'NO'}"> <!-- 전자설문 권한이 없을 때 disable 아이콘 나타남 -->
							<dl id="Poll" class="icon_disabled">
								<dt class="iconCircle_none"><span class="iconCommon"></span></dt>
								<dd class="iconText"></dd>
							</dl>
						</c:when>
						<c:otherwise>
            				<dl id="Poll">
                    			<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon05.png"></dt>
                    			<dd class="iconText"><spring:message code='ezNewPortal.gu4' /></dd>                        
                    			<dd id="pollCount" class="iconCount_none">0</dd>
                			</dl>
						</c:otherwise>
					</c:choose>
					<c:choose>
						<c:when test="${useCircular eq 'NO'}"> <!-- 회람판 권한이 없을 때 disable 아이콘 나타남 -->
							<dl id="Circular" class="icon_disabled">
								<dt class="iconCircle_none"><span class="iconCommon"></span></dt>
								<dd class="iconText"></dd>
							</dl>
						</c:when>
						<c:otherwise>
                			<dl id="Circular"> 
                    			<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon04.png"></dt>
                    			<dd class="iconText"><spring:message code='ezNewPortal.gu5' /></dd>
                    			<dd id="circularCount" class="iconCount_none">0</dd>
                			</dl>
						</c:otherwise>
					</c:choose>
                	</div>
				</article>
				<article class="birthday">
					<div class="birthTit">
               			<p class="birthText"><span id="curMon"></span><spring:message code='ezNewPortal.t017' /></p>
           	    		<span class="birthRighttbtn" id="birthdayNext"><img src="/images/ezNewPortal/birthday_next.png"></span>
                		<span class="birthLeftbtn" id="birthdayPrev"><img src="/images/ezNewPortal/birthday_pre.png"></span>
            		</div>
            		<div id="birthcont" style="display: none;">
            			<ul class="birthList" id="userList"></ul>
            		</div>
            		<div id="nodata_NewBirth" style="">
            			<dl class="nodata">
	            			<dt style="padding-top:33px"><img src="/images/ezNewPortal/nodata.png"></dt>
	            			<dd>"<spring:message code='ezNewPortal.t018' />"</dd>
            			</dl>
            		</div>
				</article>
				<article class="bestEmployee">
					<p class="emPic" id="emPic"><img src="/images/ezNewPortal/bestEmployee_pic_none.png"></p>
					<dl class="emDL">
            			<dt class="emTit"><spring:message code='ezNewPortal.t019' /></dt>
            		</dl>
				</article>
			</section>
		</div>
		<div style="position:relative;">
			<aside id="quickSide" style="width:0px">	
				<p class="linkBtn_close" id="linkBtn_open"><img id="quicklinkBtn" src="/images/ezNewPortal/linkBtn_open.png"></p>
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
		leftResize();
 	}
 	
 	var leftResize = function() {
		var wwh = $('.section_main').prop("scrollHeight") + 30;
		$(".section_left").css("height", wwh +"px");
		$(".section_left").css("min-height", "1133px");
	}
 	
 	// 퀵링크 셋팅
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
			
			// 아이콘 추가
			var iconSpan = document.createElement('span');
			var txtSpan  = document.createElement('span');
			var iconImg  = document.createElement('img');
			
			li.classList.add('linkText');
			iconSpan.classList.add('linkIcon');
			txtSpan.classList.add('linkTxt');
			
			switch(item.linkType) {
				case "A" : iconImg.setAttribute("src", "/images/kr/main/link_externalSite.png") ; break;
				case "B" : iconImg.setAttribute("src", "/images/kr/main/link_homePage.png") ; break;
				case "C" : iconImg.setAttribute("src", "/images/kr/main/link_intranet.png") ; break;
				case "D" : iconImg.setAttribute("src", "/images/kr/main/link_connectedPrograms.png"); break;
				case "E" : iconImg.setAttribute("src", "/images/kr/main/link_blog.png"); break;
				default :  iconImg.setAttribute("src", item.linkTypeUrl); break;
			}
			txtSpan.textContent = item.quickLinkName;
			
			iconSpan.appendChild(iconImg);
			li.appendChild(iconSpan);
			li.appendChild(txtSpan);
			
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
							
							if (portletId == 6) {
								$("#" + portletId + "Portlet").css("background","none");
							}
							
							eventSetting(portletId, usedTheme);
						}
					});
				}(portletId, portletUrl, portletName));
			}
		}

		//메뉴 이동(왼쪽)
		$("#NewMail").on("click", {"menu" : "NewMail"}, quickMenuOpen);
		$("#Schedule").on("click", {"menu" : "Schedule"}, quickMenuOpen);
		$("#Poll").on("click", {"menu" : "Poll"}, quickMenuOpen);
		$("#Circular").on("click", {"menu" : "Circular"}, quickMenuOpen);
		$("#AprSign").on("click", {"menu" : "ApprG"}, quickMenuOpen);
		
		var useQuestion = "<c:out value='${useQuestion}'/>";
		var useCircular = "<c:out value='${useCircular}'/>";
		var useMail = "<c:out value='${useMail}'/>";
		var useApproval = "<c:out value='${useApproval}'/>";
		var useSchedule = "<c:out value='${useSchedule}'/>";
		
		//권한에 없는거는 이미지 변경
		if (useQuestion === "NO") {
			$("#Poll").off("click");
		}
		
		if (useCircular === "NO") {
			$("#Circular").off("click");
		}
		
		if (useMail === "NO") {
			$("#NewMail").off("click");
		}
		
		if (useApproval === "NO") {
			$("#AprSign").off("click");
		}
		
		if (useSchedule === "NO") {
			$("#Schedule").off("click");
		}
		
		//ajax로 count 불러오기
		getUnreadCounts(useQuestion, useCircular, useMail, useApproval, useSchedule);
		
		//근태관리 연동
		var useAttitude = "<c:out value='${useAttitude}'/>";
		
		if (useAttitude === "YES") {
			parseDate(usedTheme);
			attiClock();
			setAttiBtnHover();
			getAttitudeList(usedTheme);
			getHolidayList();
		} else {
			parseDate(usedTheme);
			attiClock();
			//$(".time_check").css("display", "none");
		}
		
		//생일자 조회 기능 연동
		$("#birthdayNext").on("click", {isNext : true}, getMonthlyBirthdayEmployees);
		$("#birthdayPrev").on("click", {isNext : false}, getMonthlyBirthdayEmployees);
		
		//이번달 생일자 목록 불러오기
		getMonthlyBirthdayEmployees();
		
		//이달의 우수사원 불러오기
		getMonthlyBestEmployee();
		
		//개인환경설정으로 이동 동작 연결
		$("#personalEnv").on("click", viewPersonalEnv);
		$("#portletEnv").on("click", viewPortletEnv);

		
		//퀵메뉴 on/off 버튼
		$("#quicklinkBtn").on('click', viewQuick);
		//퀵메뉴 이동(오른쪽)
		$("#quickMailwrite").on('click', {'menu' : 'mail'}, quickMenuOpenRight);
		$("#quickApprovalwrite").on('click', {'menu' : 'appr'}, quickMenuOpenRight);
		$("#quickSchedulewrite").on('click', {'menu' : 'schedule'}, quickMenuOpenRight);
		$("#quickOrgan").on('click', {'menu' : 'organ'}, quickMenuOpenRight);

		// 프레임에 따라 퀵링크 위치 변경
		if(frameId === 'Frame2' || frameId === 'Frame4' ) {
			var quickSide = document.getElementById('quickSide');
			quickSide.style.cssFloat = 'left';
			
			var linkBtnOpen = document.getElementById('linkBtn_open');
			linkBtnOpen.style.right = '';
			linkBtnOpen.style.left = '0px';
			
		}
		// 퀵링크 호출
		getQuickLink();		
		
		//포틀릿 드래그 앤 드롭
		$(".portlet_area").sortable({
			handle : ".sortablePortlet",
			helper : "clone",
			start : function (event, block) {
				/* $(".portlet.ui-sortable-helper").css({
					"width" : $(".portlet").not(block.placeholder).not(block.item).width()
				}); 
				
				$(".ui-sortable-placeholder").css({
					'width' : $(".portlet").not(block.item).not(block.placeholder).width() + 0.23,
					'height' : $(".portlet").not(".ui-sortable-helper").height()
				}); */
			},
			update : function(event, ui) {
				updatePortletOrderUser();
			}
		});
		
		$(".portlet_area").disableSelection();

		leftResize();
	});
	
	var frameSetting = function (frameSetId) {
		frameId = frameSetId;
		
		if (frameSetId == "Frame3" || frameSetId == "Frame4") {
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
				$(".info_left").css("display", "none")
				$(".info_right").css("width", "100%");
				$(".info_right").css("margin-left", "0px !important");
			} else if (media1279.matches) {
				$(".portlet").addClass("two_column");
				$(".box_shadow.info_left").css("display", "none");
				$(".box_shadow.info_right").css("width", "100%");
				$(".box_shadow.info_right").css("margin-left", "0px !important");
			}
		}
	}
	</script>
	</body>
</html>