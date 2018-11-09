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
<%-- <link href="${util.addVer('/css/ezNewPortal/newPortal_css.css')}" rel="stylesheet" type="text/css">  --%>
<link href="${util.addVer('/css/ezNewPortal/theme2_main.css')}" rel="stylesheet" type="text/css">
<link href="${util.addVer('/css/ezNewPortal/theme2.css')}" rel="stylesheet" type="text/css">
</head>

<body class="mainbg">
<div class="section1_bg">
	<section class="section1">
    	<article class="personal">
        	<p>
            	<span class="info_set"></span>
                <span>${userEmail}</span>
            </p>
            <div class="info">
            	<p class="pic"><c:if test='${userPhoto == ""}'><img src="/images/ezNewPortal/info_pic_none.png"  width="100%" height="100%" /></c:if><c:if test='${userPhoto != ""}'><img width="100%" height="100%" id="myImg" src="/ezCommon/downloadAttach.do?filePath=${userPhoto }"></c:if></p>
                <dl class="info_txt">
                	<dt>${deptName}</dt>
                    <dt>${userName} ${userTitle}</dt>
                    <dd>최종접속 : ${lastLogin}</dd>
                </dl>
            </div>
            <div class="personal_content">
            <c:choose>
            	<c:when test="${useAttitude eq 'YES' }">
	             	<dl class="time">
	                	<dt>현재시간</dt>
	                    <dd id="timeFlow"></dd>
	                </dl>
	                <dl class="commute">
	                	<dt id="inAttiBtn" class="out" type="A01" datetype="2" onclick="checkHoliday(this)">출근</dt>
	                </dl>
	                <dl class="commute">
	                	<dt id="outAttiBtn" class="out" type="A03" datetype="2" onclick="checkHoliday(this)">퇴근</dt>
	                </dl>            	
            	</c:when>
            	<c:otherwise>
	            	<dl class="time commuteNone">
	                	<dt>현재시간</dt>
	                    <dd id="timeFlow"></dd>
	                </dl>            	
            	</c:otherwise>
            </c:choose>
            </div>
        </article>
        <div class="schedule">
        	<article class="list">
            	<div class="maintab01">
                	<p class="left_on">개인일정</p>
                    <p class="right">부서일정</p>
                </div>
                <div class="scrollbox-play-light">
                	<div class="scrollbox">
                    	<div class="content">
                        	<ul class="schedule_list">
                            	<li>[13:30 ~ 15:00] 개인업무 정비 및 진행을 검토 개인업무 정비 및 진행을 검토</li>
                                <li>[13:30 ~ 15:00] 개인업무 정비 및 진행을 검토</li>
                                <li>[13:30 ~ 15:00] 개인업무 정비 및 진행을 검토</li>
                                <li>[13:30 ~ 15:00] 개인업무 정비 및 진행을 검토</li>
                                <li>[13:30 ~ 15:00] 개인업무 정비 및 진행을 검토</li>
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
            	<div id="CalendarMini">
                <table class="calendar_mini_title" id="MiniCalendar" cellpadding="0" cellspacing="0" border="0" width="100%">
                    <tr>
                        <td class="btn_prev"><img src="/images/ezNewPortal/theme2Img/btn_calendar_prev.png" border="0" onclick="preMonth()"></td>
                        <td class="calendar_mini_day"><span>2018.10</span> <!--<select name="iYear" id="iYear" onchange="changeYear()">
                                <option value="2021">2021</option>
                                <option value="2020">2020</option>
                                <option value="2019">2019</option>
                                <option value="2018" selected="">2018</option>
                                <option value="2017">2017</option>
                                <option value="2016">2016</option>
                                <option value="2015">2015</option>
                                </select>
                                <select name="iMon" id="iMon" onchange="changeMonth()" style="margin-left: 10px;">
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                                <option value="7">7</option>
                                <option value="8">8</option>
                                <option value="9">9</option>
                                <option value="10" selected="">10</option>
                                <option value="11">11</option>
                                <option value="12">12</option>
                            </select>--></td>
                        <td class="btn_next"><img src="/images/ezNewPortal/theme2Img/btn_calendar_next.png" border="0" onclick="nextMonth()"></td>
                    </tr>
                </table>
                <table id="" cellpadding="0" cellspacing="0" border="0" width="100%" class="calendar_mini">
                    <tbody>
                        <tr>
                            <th scope="col" class="sun">일</th>
                            <th scope="col">월</th>
                            <th scope="col">화</th>
                            <th scope="col">수</th>
                            <th scope="col">목</th>
                            <th scope="col">금</th>
                            <th scope="col" class="sat">토</th>
                        </tr>
                        <tr id="TR_9_0">
                            <td class=" gray"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-09-30_Day" dispdate="2018-09-30">30</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-01_Day" dispdate="2018-10-01">1</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-02_Day" dispdate="2018-10-02">2</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-03_Day" dispdate="2018-10-03">3</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-04_Day" dispdate="2018-10-04">4</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-05_Day" dispdate="2018-10-05">5</div></td>
                            <td class=" sat"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-06_Day" dispdate="2018-10-06">6</div></td>
                        </tr>
                        <tr id="TR_9_1">
                            <td class=" sun"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-07_Day" dispdate="2018-10-07">7</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-08_Day" dispdate="2018-10-08">8</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-09_Day" dispdate="2018-10-09">9</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-10_Day" dispdate="2018-10-10">10</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-11_Day" dispdate="2018-10-11">11</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-12_Day" dispdate="2018-10-12">12</div></td>
                            <td class=" sat"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-13_Day" dispdate="2018-10-13">13</div></td>
                        </tr>
                        <tr id="TR_9_2">
                            <td class=" sun"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-14_Day" dispdate="2018-10-14">14</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-15_Day" dispdate="2018-10-15">15</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-16_Day" dispdate="2018-10-16">16</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-17_Day" dispdate="2018-10-17">17</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-18_Day" dispdate="2018-10-18">18</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-19_Day" dispdate="2018-10-19">19</div></td>
                            <td class=" sat"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-20_Day" dispdate="2018-10-20">20</div></td>
                        </tr>
                        <tr id="TR_9_3">
                            <td class=" sun"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-21_Day" dispdate="2018-10-21">21</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-22_Day" dispdate="2018-10-22">22</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-23_Day" dispdate="2018-10-23">23</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-24_Day" dispdate="2018-10-24">24</div></td>
                            <td class="today"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-25_Day" dispdate="2018-10-25">25</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-26_Day" dispdate="2018-10-26">26</div></td>
                            <td class=" sat"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-27_Day" dispdate="2018-10-27">27</div></td>
                        </tr>
                        <tr id="TR_9_4">
                            <td class=" sun"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-28_Day" dispdate="2018-10-28">28</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-29_Day" dispdate="2018-10-29">29</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-30_Day" dispdate="2018-10-30">30</div></td>
                            <td class=""><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-10-31_Day" dispdate="2018-10-31">31</div></td>
                            <td class=" gray"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-11-01_Day" dispdate="2018-11-01">1</div></td>
                            <td class=" gray"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-11-02_Day" dispdate="2018-11-02">2</div></td>
                            <td class=" gray"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-11-03_Day" dispdate="2018-11-03">3</div></td>
                        </tr>
                        <tr id="TR_9_5">
                            <td class=" gray"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-11-04_Day" dispdate="2018-11-04">4</div></td>
                            <td class=" gray"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-11-05_Day" dispdate="2018-11-05">5</div></td>
                            <td class=" gray"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-11-06_Day" dispdate="2018-11-06">6</div></td>
                            <td class=" gray"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-11-07_Day" dispdate="2018-11-07">7</div></td>
                            <td class=" gray"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-11-08_Day" dispdate="2018-11-08">8</div></td>
                            <td class=" gray"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-11-09_Day" dispdate="2018-11-09">9</div></td>
                            <td class=" gray"><div onclick="DayOnMouseClick(this);" ondblclick="MonthMiniDbClick()" id="TDMINI_2018-11-10_Day" dispdate="2018-11-10">10</div></td>
                        </tr>
                    </tbody>
                </table>
                </div>
            </article>
        </div>
        <div class="bannerlink_area">
        	<article class="writebanner">
                <ul class="writebannerUL">
                    <li>
                        <dl class="writebannerDL">
                            <dt><img src="/images/ezNewPortal/theme2Img/writebanner01.png" alt="새메일"></dt>
                            <dt>새메일</dt>
                            <dd id="unreadMailCount">0</dd>
                        </dl>
                    </li>
                    <li>
                        <dl class="writebannerDL">
                            <dt><img src="/images/ezNewPortal/theme2Img/writebanner02.png" alt="결재문서"></dt>
                            <dt>결재문서</dt>
                            <dd id="approvalCount">0</dd>
                        </dl>
                    </li>
                    <li>
                        <dl class="writebannerDL">
                            <dt><img src="/images/ezNewPortal/theme2Img/writebanner03.png" alt="오늘일정"></dt>
                            <dt>오늘일정</dt>
                            <dd id="scheduleCount">0</dd>
                        </dl>
                    </li>
                    <li>
                        <dl class="writebannerDL">
                            <dt><img src="/images/ezNewPortal/theme2Img/writebanner04.png" alt="전자설문"></dt>
                            <dt>전자설문</dt>
                            <dd id="pollCount">0</dd>
                        </dl>
                    </li>
                    <li>
                        <dl class="writebannerDL">
                            <dt><img src="/images/ezNewPortal/theme2Img/writebanner05.png" alt="회람판"></dt>
                            <dt>회람판</dt>
                            <dd id="circularCount">0</dd>
                        </dl>
                    </li>
                    <li>
                        <dl class="writebannerDL">
                            <dt><img src="/images/ezNewPortal/theme2Img/writebanner06.png" alt="협업"></dt>
                            <dt>협업</dt>
                            <dd>9</dd>
                        </dl>
                    </li>
                </ul>
            </article>
        </div>
        <article class="excellentemployee">
        	<p><span>이달의</span><span class="blue">우수사원</span></p>
            <div class="excellentcontent" id="excellentcontent">
                <dl>
                    <dt id="emPic"></dt>
                    <dd><img src="/images/ezNewPortal/theme2Img/icon_excellent.png"></dd>
                </dl>
                <!-- <p class="name"><span>UI/UX팀</span><span>홍길동</span></p> -->
            </div>
        </article>
        <article class="event">
        	<p><span>이달의</span><span class="blue">행사</span></p>
            <dl>
            	<dt><img src="/images/ezNewPortal/theme2Img/event_pic.png"></dt>
            </dl>
        </article>
    </section>
	<aside id="quickSide">
		<p class="linkBtn_open" id="linkBtn_open"><img src="/images/ezNewPortal/linkBtn_open.png"></p>
		<div class="aside_quick">
			<p class="quickmenu_title">Quick</p>
			<ul class="quickmenu">
				<li id="quickMailwrite"><span class="icon"><img src="/images/ezNewPortal/quick01.png"></span><span class="txt">메일작성</span></li>
				<li id="quickApprovalwrite"><span class="icon"><img src="/images/ezNewPortal/quick02.png"></span><span class="txt">결재작성</span></li>
				<li id="quickSchedulewrite"><span class="icon"><img src="/images/ezNewPortal/quick03.png"></span><span class="txt">일정작성</span></li>
				<li id="quickOrgan"><span class="icon"><img src="/images/ezNewPortal/quick04.png"></span><span class="txt">조직도</span></li>
			</ul>
		</div>
		<div class="aside_link">
			<p class="linkmenu_title">Link</p>
			<ul class="linkmenu" id="QuickUl">
			</ul>
			<div class="linkBtn">
				<p class="btnLay" id="btnLay">
				</p>
			</div>
		</div>
	</aside>    
	<section class="section_main">
		<div class="portlet_area">
		</div>
	</section>    
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
<script type="text/javascript">
	var portletOrder = JSON.parse('${portletOrder}');
	var photoBoardPage = 1;
	var photoCount = 4;
 	var nowAttiTime = "";
 	var beforeAlertDate = "";
	var afterAlertDate = "";
	var overTime = "";
 	var serverTime = "<c:out value='${serverTime}'/>";
 	var birthdayMonth = Number("<c:out value='${nowMonth}'/>");
 	var birthdayCurPage = 0;
 	var birthdayTotalCount = 0;
 	var timer;
 	var frameId = "<c:out value='${usedFrame}'/>";
 	
 	var quickLinkPage = {
 		current: 1,
 		total: 1,
 	}; 	
 	
 	window.onresize = function(event) {
 		frameSetting(frameId);
 	}

	var frameSetting = function (frameSetId) {
		console.log(frameSetId);
		frameId = frameSetId;
		
		if (frameSetId == "Frame3" || frameSetId == "Frame4") {
			var media1921 = window.matchMedia("only screen and (min-width: 1921px)");
			var media1686 = window.matchMedia("only screen and (max-width :1920px) and (min-width :1686px)");
			var media1280 = window.matchMedia("only screen and (max-width :1685px) and (min-width :1280px)");
			
			if (media1921.matches) {
				$(".portlet").css("width", "483px");
			} else if (media1686.matches) {
				$(".portlet").css("width", "48%");
			} else if (media1280.matches) {
				$(".portlet").css("width", "48%");
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
		
		if(quickLinkPage.current*1 === 1) {
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
		
		if(quickLinkPage.current*1 === totalCnt*1) {
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
				var strHTML = "";
				var excellentContent = document.getElementById('excellentcontent');
				
				if(bestEmployee === null) {
					var emPic = document.getElementById('emPic');
					
					var img = document.createElement('img');
 					img.style.width = '100%';
					img.style.height = '100%'; 
					img.src = '\/images/ezNewPortal/bestEmployee_pic_none.png';

					emPic.appendChild(img);
					
					var p = document.createElement('p');
					p.className = 'name';

					var spanDept = document.createElement('span');
					spanDept.textContent = '데이터가 없습니다.';
					
					p.appendChild(spanDept);
				} else {
					var emPic = document.getElementById('emPic');
					
					var img = document.createElement('img');
 					img.style.width = '100%';
					img.style.height = '100%';
					img.src = bestEmployee.userImg;
					
					emPic.appendChild(img);
					
					var p = document.createElement('p');
					p.className = 'name';

					var spanDept = document.createElement('span');
					spanDept.textContent = bestEmployee.userDeptName;
					
					var spanName = document.createElement('span');
					spanName.textContent = bestEmployee.userName;
					
					p.appendChild(spanDept);
					p.appendChild(spanName);
				}

				excellentContent.appendChild(p);
				$(".emDL").append(strHTML);
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
			
			(function (portletId, portletUrl, portletName) {
				$.ajax({
					type : "POST",
					dataType : "html",
					data : {"portletId" : portletId, "portletName" : portletName},
					url : portletUrl,
					success : function(result) {
						$("#" + portletId + "Portlet").append(result);
						eventSetting(portletId);
					}
				});
			}(portletId, portletUrl, portletName));
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
		
		//ajax로 count 불러오기
		getUnreadCounts(useQuestion, useCircular, useMail, useApproval, useSchedule);
		
		//근태관리 연동
		var useAttitude = "<c:out value='${useAttitude}'/>";
		
		if (useAttitude === "YES") {
			parseDate();
			attiClock();
			setAttiBtnHover();
			getAttitudeList();
			getHolidayList();
		} else {
			$(".time_check").css("display", "none");
		}
		
		//생일자 조회 기능 연동
		$("#birthdayNext").on("click", {isNext : true}, getMonthlyBirthdayEmployees);
		$("#birthdayPrev").on("click", {isNext : false}, getMonthlyBirthdayEmployees);
		
		//이번달 생일자 목록 불러오기
		getMonthlyBirthdayEmployees();
		
		//이달의 우수사원 불러오기
		//getMonthlyBestEmployee();
		getMonthlyBestEmployeeTheme2();
		
		//개인환경설정으로 이동 동작 연결
		$("#personalEnv").on("click", viewPersonalEnv);
		$("#portletEnv").on("click", viewPortletEnv);
		//메뉴 이동(왼쪽)
		$("#NewMail").on("click", {"menu" : "NewMail"}, quickMenuOpen);
		$("#Schedule").on("click", {"menu" : "Schedule"}, quickMenuOpen);
		$("#Poll").on("click", {"menu" : "Poll"}, quickMenuOpen);
		$("#Circular").on("click", {"menu" : "Circular"}, quickMenuOpen);
		$("#AprSign").on("click", {"menu" : "ApprG"}, quickMenuOpen);
		
		//퀵메뉴 on/off 버튼
		$("#linkBtn_open").on('click', viewQuick);
		//퀵메뉴 이동(오른쪽)
		$("#quickMailwrite").on('click', {'menu' : 'mail'}, quickMenuOpenRight);
		$("#quickApprovalwrite").on('click', {'menu' : 'appr'}, quickMenuOpenRight);
		$("#quickSchedulewrite").on('click', {'menu' : 'schedule'}, quickMenuOpenRight);
		$("#quickOrgan").on('click', {'menu' : 'organ'}, quickMenuOpenRight);

		// 퀵링크 호출
		getQuickLink();		
		
		//포틀릿 드래그 앤 드롭
		$(".portlet_area").sortable({
			handle : ".sortablePortlet",
			start : function (event, block) {
				$(".ui-sortable-helper").css({
					'width' : $(".box_shadow").outerWidth(),
					'height' : $(".box_shadow").outerHeight()
				});
			},
			update : function(event, ui) {
				updatePortletOrderUser();
			}
		});
		
		$(".portlet_area").disableSelection();
		
	});
</script>
</body>	
</html>