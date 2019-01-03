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
	#theme2Body .two_column{width:48%;}
	.mainbg {min-width:1280px;}
	#main_portletEnv {position:absolute;top:0px;right:30px;display:inline-block;cursor:pointer;}
	.top_two_column {margin : 0px 0px 25px 0px;}
	.orbit-wrapper .timer {display:none;}
</style>
</head>

<body class="mainbg" id="theme2Body">
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
<div class="section1_bg">
	<section class="section1">
    <div class="sec1Layout_left">
    	<article class="personal">
            <div class="info">
            	<p class="pic"><c:if test='${userPhoto == ""}'><img src="/images/default_pic.gif" style="border-radius:100px;" width="100%" height="100%" /></c:if><c:if test='${userPhoto != ""}'><img width="100%" height="100%" style="border-radius:100px;"id="myImg" src="/ezCommon/downloadAttach.do?filePath=${userPhoto }"></c:if></p>
                <dl class="info_txt">
                	<dt>${deptName}
                		<span class="info_set" id="main_personalEnv"></span>
                		<span id="main_portletEnv" style="float:left;"><img src="/images/admin/frameSetting.png" style="margin-top:11px;margin-left:21px;cursor:pointer;background-color:#b9b9b9; border:1px solid #b9b9b9;"/></span>
                	</dt>
                    <dt>${userName} ${userTitle}</dt>
                    <dd><spring:message code='ezNewPortal.t026' />${lastLogin}</dd>
                </dl>
            </div>
            <div class="personal_content">
            	<p>&nbsp;</p>
            <c:choose>
            	<c:when test="${useAttitude eq 'YES' }">
	                <dl class="commute">
	                	<dt id="inAttiBtn" class="main_out" type="A01" datetype="2" onclick="checkHoliday(this, '${usedTheme}')"><spring:message code='ezNewPortal.t013' /></dt>
	                	<dd id="inAttiBtn_txt" class="main_out" type="A01" datetype="2" onclick="checkHoliday(this, '${usedTheme}')"><spring:message code='ezNewPortal.t126' /></dd>
	                </dl>
	                <dl class="commute">
	                	<dt id="outAttiBtn" class="main_out" type="A03" datetype="2" onclick="checkHoliday(this, '${usedTheme}')"><spring:message code='ezNewPortal.t014' /></dt>
	                	<dd id="outAttiBtn_txt" class="main_out" type="A03" datetype="2" onclick="checkHoliday(this, '${usedTheme}')"><spring:message code='ezNewPortal.t126' /></dd>
	                </dl>    
	             	<dl class="time">
	                	<dt><spring:message code='ezNewPortal.t012' /></dt>
	                    <dd id="timeFlow"></dd>
	                </dl>        	
            	</c:when>
            	<c:otherwise>
	            	<dl class="time commuteNone">
	                	<dt><spring:message code='ezNewPortal.t012' /></dt>
	                    <dd id="timeFlow"></dd>
	                </dl>            	
            	</c:otherwise>
            </c:choose>
            </div>
        </article>
        <div class="bannerlink_area">
        	<article class="writebanner">
                <ul class="writebannerUL">
                    <li>
                    	<c:choose>
                    		<c:when test="${useMail eq 'NO' }">								
                    			<dl id="NewMail" class="icon_disabled writebannerDL">
									<dt class="iconCircle_none"><span class="iconCommon"></span></dt>
								</dl>
                    		</c:when>
                    		<c:otherwise>
                        		<dl class="writebannerDL" id="NewMail">
                           		 	<dt><img src="/images/ezNewPortal/theme2Img/writebanner01.png" alt="<spring:message code='ezNewPortal.t015' />"></dt>
                            		<dt><spring:message code='ezNewPortal.t015' /></dt>
                            		<dd id="unreadMailCount" class="iconCount_none">0</dd>
                        		</dl>
                    		</c:otherwise>
                    	</c:choose>
                    </li>
                    <li>
                    	<c:choose>
                    		<c:when test="${useApproval eq 'NO' }">								
                    			<dl id="AprSign" class="icon_disabled writebannerDL">
									<dt class="iconCircle_none"><span class="iconCommon"></span></dt>
								</dl>
                    		</c:when>
                    		<c:otherwise>
                        		<dl class="writebannerDL" id="AprSign">
                            		<dt><img src="/images/ezNewPortal/theme2Img/writebanner02.png" alt="<spring:message code='ezNewPortal.t016' />"></dt>
                            		<dt><spring:message code='ezNewPortal.t016' /></dt>
                            		<dd id="approvalCount" class="iconCount_none">0</dd>
                        		</dl>
                    		</c:otherwise>
                    	</c:choose>
                    </li>
                    <li>
                    	<c:choose>
                    		<c:when test="${useSchedule eq 'NO' }">								
                    			<dl id="Schedule" class="icon_disabled writebannerDL">
									<dt class="iconCircle_none"><span class="iconCommon"></span></dt>
								</dl>
                    		</c:when>
                    		<c:otherwise>
                        		<dl class="writebannerDL" id="Schedule">
                            		<dt><img src="/images/ezNewPortal/theme2Img/writebanner03.png" alt="<spring:message code='ezNewPortal.gu3' />"></dt>
                            		<dt><spring:message code='ezNewPortal.gu3' /></dt>
                            		<dd id="scheduleCount" class="iconCount_none">0</dd>
                        		</dl>
                    		</c:otherwise>
                    	</c:choose>
                    </li>
                    <li>
                    	<c:choose>
                    		<c:when test="${useQuestion eq 'NO' }">								
                    			<dl id="Poll" class="icon_disabled writebannerDL">
									<dt class="iconCircle_none"><span class="iconCommon"></span></dt>
								</dl>
                    		</c:when>
                    		<c:otherwise>
                        		<dl class="writebannerDL" id="Poll">
                            		<dt><img src="/images/ezNewPortal/theme2Img/writebanner04.png" alt="<spring:message code='ezNewPortal.gu4' />"></dt>
                            		<dt><spring:message code='ezNewPortal.gu4' /></dt>
                            		<dd id="pollCount" class="iconCount_none">0</dd>
                       			</dl>
                    		</c:otherwise>
                    	</c:choose>
                    </li>
                    <li>
                    	<c:choose>
                    		<c:when test="${useCircular eq 'NO' }">								
                    			<dl id="Circular" class="icon_disabled writebannerDL">
									<dt class="iconCircle_none"><span class="iconCommon"></span></dt>
								</dl>
                    		</c:when>
                    		<c:otherwise>
                        		<dl class="writebannerDL" id="Circular">
                            		<dt><img src="/images/ezNewPortal/theme2Img/writebanner05.png" alt="<spring:message code='ezNewPortal.gu5' />"></dt>
                            		<dt><spring:message code='ezNewPortal.gu5' /></dt>
                            		<dd id="circularCount" class="iconCount_none">0</dd>
                        		</dl>
                    		</c:otherwise>
                    	</c:choose>
                    </li>
                    <li>
					<c:if test="${useEzWorkspace eq 'YES' }">
                    <dl class="writebannerDL" id="ezWorkspace">
                        <dt><img src="/images/ezNewPortal/theme2Img/writebanner06.png" alt="협업"></dt>
                        <dt><spring:message code='ezNewPortal.pjg01' /></dt>
                        <dd class="iconCount_none" id="workspaceCnt">0</dd>
                    </dl>
                	</c:if>                        
                    </li>
                </ul>
            </article>
        </div>
        </div>
    <div class="sec1Layout_middle">
        <div class="main_schedule">
        	<article class="list">
            	<div class="maintab01">
                	<p class="left_on" id="pSchedule"><spring:message code='ezNewPortal.t027' /></p>
                    <p class="right" id="dSchedule"><spring:message code='ezNewPortal.t028' /></p>
                </div>
                <div class="scrollbox-play-light">
                	<div class="scrollbox">
                    	<div class="content">
                        	<ul class="schedule_list" id="schedule_list_Top">
                            </ul>
                        </div>
                        <div class="scrollbar-v scrollbar-v-disabled">
                        	<img class="button-up" style="display:none;">
                            <img class="thumb-v" style="display:none; top:0px;">
                            <img class="button-down" style="display:none; bottom:0px;">
                        </div>
                    </div>
                </div>
            </article>
            <article class="calender">
            	<div id="CalendarMini_Top">
            	
                </div>
            </article>
        </div>
        </div>
    	<div class="sec1Layout_right">
        <article class="event">
            <p></p>
        </article>
        <article class="exellentEmployee">
        	<p class="title"><span><spring:message code='ezNewPortal.t127' /></span><span class="color"><spring:message code='ezNewPortal.t128' /></span></p>
            <dl class="excellent_info" id="excellentcontent">
            	<dt class="pic" id="emPic"></dt>
                <dt id="exellentEmpName" style="font-size:15px"></dt>
                <dt id="exellentDeptName" style="font-size:13px; color:#777; font-weight: normal"></dt>
                <dd><img src="/images/ezNewPortal/theme2Img/icon_excellent.png"></dd>
            </dl>
        </article>
    </div>
    </section>
</div>
<div class="section_main">
	<section>
		<div class="portlet_area">
		</div>
	</section>
</div>

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
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/schedulePortlet.js')}"></script>		
<c:choose>
	<c:when test="${checkBrowser == true}">
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/sCalendarMini_Portal_IEEIP.js')}"></script>
	</c:when>
	<c:otherwise>
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/sCalendarMini_Portal_EIP.js')}"></script>
	</c:otherwise>
</c:choose>
<%-- <c:choose>
	<c:when test="${checkBrowser == true}">
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/sCalendarMini_Top_IEEIP.js')}"></script>
	</c:when>
	<c:otherwise>
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/sCalendarMini_Top_EIP.js')}"></script>
	</c:otherwise>
</c:choose> --%>
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
 	var theme2 = true;
 	
 	var quickLinkPage = {
 		current: 1,
 		total: 1,
 	}; 	
 	
	var pScheduleList = [];
	var dScheduleList = [];
	
	/* openerCalendarMiniView = CalendarMiniView;
	openerCalendarMiniDataSource = CalendarMiniDataSource; */
 	
 	window.onresize = function(event) {
 		frameSetting(frameId);
 	}

	var frameSetting = function (frameSetId) {
		frameId = frameSetId;
		console.log(frameSetId);
		if (frameSetId == "Frame2") {
			var media1921 = window.matchMedia("only screen and (min-width: 1921px)");
			var media1686 = window.matchMedia("only screen and (max-width :1920px) and (min-width :1686px)");
			var media1280 = window.matchMedia("only screen and (max-width :1685px) and (min-width :1280px)");
			
			if (media1921.matches) {
				$(".portlet").addClass("two_column");
				$(".section1_bg").removeClass("top_two_column");
			} else if (media1686.matches) {
				$(".portlet").addClass("two_column");
				$(".section1_bg").removeClass("top_two_column");
			} else if (media1280.matches) {
				$(".portlet").addClass("two_column");
				$(".section1_bg").addClass("top_two_column");
			}
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
	
	//월별 우수사원 정보 호출
	var getMonthlyBestEmployeeTheme2 = function () {
		$.ajax({
			type : "POST",
			url : "/ezNewPortal/getMonthlyBestEmployee.do",
			dataType : "json",
			success : function(result) {
				var bestEmployee = result.bestEmployee;
				var excellentContent = document.getElementById('excellentcontent');
				
				if(bestEmployee === null || bestEmployee ==  undefined) {
					var emPic = document.getElementById('emPic');
					
					var img = document.createElement('img');
 					img.style.width = '100%';
					img.style.height = '100%'; 
					img.src = '\/images/ezNewPortal/bestEmployee_pic_none.png';

					emPic.appendChild(img);
					
					document.getElementById("exellentDeptName").innerText = "";
					document.getElementById("exellentEmpName").innerText = "데이터가 없습니다.";
					
					var nodata = document.getElementById("exellentEmpName");
					nodata.style.color = "#c0c0c0";
					
				} else {
					var emPic = document.getElementById('emPic');
					
					var img = document.createElement('img');
 					img.style.width = '100%';
					img.style.height = '100%';
					img.src = bestEmployee.userImg;
					
					emPic.appendChild(img);
					
					document.getElementById("exellentDeptName").innerText = bestEmployee.userDeptName;
					document.getElementById("exellentEmpName").innerText = '"' + bestEmployee.userName + '"';
				}
			}
		});
	}
	
	var getScheduleList_after_Theme2 = function (list) {
		// 개인일정, 부서일정 나누기 scheduleType 1 or 2
		pScheduleList = [];
		dScheduleList = [];
		list.forEach(function(item, index) {
			if(item.scheduleType === '1') {
				pScheduleList.push(item);	
			} else if (item.scheduleType === '2' || item.scheduleType === '3') {
				dScheduleList.push(item);
			}
		});
		
		//개인에 탭이 되어있으면
		if (pSchedule.classList.contains('left_on')) {
			assembleScheduleList(pScheduleList);
		}
		//부서에 탭이 되어있으면
		if (dSchedule.classList.contains('right_on')) {
			assembleScheduleList(dScheduleList);
		}
	}
	
	var getScheduleList_Top = function (date, mode) {
		selDate = date;			    
		
		$.ajax({
			type : "POST",
			dataType : "json",
			async : false,
			url : "/ezNewPortal/getScheduleList.do",
			data : {
				selectDate  : date		    			
			},
			success: function(json){
				getScheduleList_after_Theme2(json.resultList);
			}
		});
	}

	var assembleScheduleList = function (data) {
        var schList = document.getElementById('schedule_list_Top');
        
		while(schList.hasChildNodes()) {
			schList.removeChild(schList.firstChild);	
		}
		
		if(data.length === 0) {
			var dl = document.createElement('dl');
			dl.className = 'nodata';
			
			var dt = document.createElement('dt');
			var img = document.createElement('img');
			img.src = '/images/kr/main/nodata.png';
			
			dt.appendChild(img);
			var dd = document.createElement('dd');
			dd.textContent = '\"<spring:message code="ezNewPortal.t018" />\"';
			
			dl.appendChild(dt);
			dl.appendChild(dd);
			
			schList.appendChild(dl);
			return;
		}
		
        data.forEach(function(item, index) {
        	if(index > 4) return;
        	var li = document.createElement('li');
        	li.textContent = '['+ item.startDate.substring(11, 16) + ' ~ ' + item.endDate.substring(11, 16) + '] ' + item.title;
        	li.style.cursor = "pointer";
        	li.addEventListener('click', function() {
			    var wWeight = "760";
			    var wHeight = "670";
			    var heigth = window.screen.availHeight;
			    var width = window.screen.availWidth;
			    var left = (width - wWeight) / 2;
			    var top = (heigth - wHeight) / 2;
			
		        window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(item.scheduleId) + "&type=" + item.scheduleType + "&datetype=" + item.dateType + "&repeatcount=" + item.repeatCount + "&date=" + item.startDate.substr(0, 10) + "&pattern=0","",
			        "top = " + top + ", left = " + left + ",height = " + wHeight + "px, width = " + wWeight + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1 scrollbars=0");        		
        	});
        	schList.appendChild(li);
        });
	}
	
	function schedule_get_holiday_top() {
	    $.ajax({
			type : "POST",
			dataType : "text",
			async : true,
			url : "/ezSchedule/scheduleGetHoliday.do",
			data : {
				COMPANYID  : "VIEW"		    			
			},
			success: function(text){
				XmlNodeText = text;
	            XmlNode = loadXMLString(XmlNodeText);
	            
	            for (var i = 0; i < SelectNodes(XmlNode, "DATA/ROW").length; i++) {
	                if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISUSE")[0].textContent == "1") {
	                    var issolar;
	                    var holiday;
	                    
	                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISSOLAR")[0].textContent == "1")
	                        issolar = "1";
	                    else
	                        issolar = "2";
	                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREST")[0].textContent == "1")			                    	
	                        holiday = true;			                    
	                    else
	                        holiday = false;
	                    
	                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREPEAT")[0].textContent == "1") {
	                        memorialDays.push(new memorialDay(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent, GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent,
	                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(5, 7),
	                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(8, 10), issolar, holiday));
	                    } else {                   	
	                        yearmemorialDays.push(new yearmemorialDay(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent, GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent,
	                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(0, 4),
	                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(5, 7),
	                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(8, 10), issolar, holiday));
	                    }
	                }
	            }			            
	            CalendarMiniView("CalendarMini_Top");
				CalendarMiniDataSource("Top");
			}		    		
	    });
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
							eventSetting(portletId, usedTheme);
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
		
		//메뉴 이동(위) --- 권한이 YES일 때만 버튼 동작
		if (useMail !== "NO") {
			document.getElementById("NewMail").addEventListener('click', function(){quickMenuOpen('NewMail');}, false);
		}
		
		if (useSchedule !== "NO") {
			document.getElementById("Schedule").addEventListener('click', function(){quickMenuOpen('Schedule');}, false);
		}
		
		if (useQuestion !== "NO") {
			document.getElementById("Poll").addEventListener('click', function(){quickMenuOpen('Poll');}, false);
		}
		
		if (useCircular !== "NO") {
			document.getElementById("Circular").addEventListener('click', function(){quickMenuOpen('Circular');}, false);
		}
		
		if (useApproval !== "NO") {
			document.getElementById("AprSign").addEventListener('click', function(){quickMenuOpen('ApprG');}, false);
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
		}
		
		//테마2에서는 생일자 안씀
		/* //생일자 조회 기능 연동
		$("#birthdayNext").on("click", {isNext : true}, getMonthlyBirthdayEmployees);
		$("#birthdayPrev").on("click", {isNext : false}, getMonthlyBirthdayEmployees);
		
		//이번달 생일자 목록 불러오기
		getMonthlyBirthdayEmployees(); */
		
		//이달의 우수사원 불러오기
		//getMonthlyBestEmployee();
		getMonthlyBestEmployeeTheme2();
		
		//개인환경설정으로 이동 동작 연결
		document.getElementById("main_personalEnv").addEventListener('click', viewPersonalEnv);
		document.getElementById("main_portletEnv").addEventListener('click', viewPortletEnv);

		//퀵메뉴 on/off 버튼
		document.getElementById("quicklinkBtn").addEventListener('click', viewQuick);
		
		//퀵메뉴 이동(오른쪽)
		document.getElementById("quickMailwrite").addEventListener('click', function(){quickMenuOpenRight('mail');}, false);
		document.getElementById("quickApprovalwrite").addEventListener('click', function(){quickMenuOpenRight('appr');}, false);
		document.getElementById("quickSchedulewrite").addEventListener('click', function(){quickMenuOpenRight('schedule');}, false);
		document.getElementById("quickOrgan").addEventListener('click', function(){quickMenuOpenRight('organ');}, false);

		// 퀵링크 호출
		getQuickLink();		
		
		//포틀릿 드래그 앤 드롭
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
		
		$(".portlet_area").disableSelection();
		
		//CalendarMiniView_Top("CalendarMini_Top");
		getScheduleList_Top(nowDay, "P");
		
		var pSchedule = document.getElementById('pSchedule');
		var dSchedule = document.getElementById('dSchedule');
		
		pSchedule.addEventListener('click', function() {
			if(!pSchedule.classList.contains('left_on')) {
				// 개인일정이 선택되면 부서일정off
				pSchedule.classList.remove('left');
				pSchedule.classList.add('left_on');

				dSchedule.classList.remove('right_on');
				dSchedule.classList.add('right');
				
				assembleScheduleList(pScheduleList);
			}
		});
		
		dSchedule.addEventListener('click', function() {
			if(!dSchedule.classList.contains('right_on')) {
				// 부서일정이 선택되면 개인일정off
				dSchedule.classList.remove('right');
				dSchedule.classList.add('right_on');
				
				pSchedule.classList.remove('left_on');
				pSchedule.classList.add('left');
				
				assembleScheduleList(dScheduleList);
			}
		});
		
		assembleScheduleList(pScheduleList);
		
		schedule_get_holiday_top(); // getholiday를 2번 부른다. 1번만 호출하도록 수정할 필요 있음.
	});
</script>
<!-- 협업 시작-->
<c:if test="${useEzWorkspace eq 'YES' }">
    <script type="text/javascript" src="http://space.kaoni.com/myoffice/ezWorkspace/Scripts/moment.min.js"></script>
    <script type="text/javascript" src="http://space.kaoni.com/myoffice/ezWorkspace/Scripts/Groupwareapi.js"></script>
    <script type="text/javascript">
	    var g_UserID = "${userId}"; // GW 사용자 Id, 가온누리 Java버전엔 이미 선언되어 있음
	    var WorkspaceUrl = "http://space.kaoni.com"; // 협업이 그룹웨어와 별도의 Url로 서비스 되는 경우에만 설정
	    var g_bGroupwareUIType = false;  // 그룹웨어 UI 타입 => true: UIUX, false: Normal(예전 GW 화면)
	    var feedListCount = 10;
	    var g_bRayful = false;
	    var g_bVisible = true; // 문서탭 선택 시 원문에 포함된 첨부파일 포함 여부 (false: 포함)	    
	        
    	ezWorkspaceData();
    </script>		
</c:if>	
<!-- 협업 끝 -->	
</body>	
</html>