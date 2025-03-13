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
	#theme2Body .two_column{width:48%;}
	/*#main_portletEnv {position:absolute;top:0px;right:30px;display:inline-block;cursor:pointer;}*/
	.top_two_column {margin : 0px 0px 25px 0px;}
	.linkIcon {display: block; margin: 0 auto; padding: 9px 0px 5px 0px; text-align: center;}
	.linkTxt {display: block; width: 78px; text-align: center; color: #333; font-size: 12px; height: 27px; letter-spacing: 0px; overflow: hidden;margin: 0 auto; padding: 2px 0px 0px 0px; word-break: break-all; line-height: 15px; text-overflow: ellipsis; white-space: nowrap;}
</style>
</head>

<body class="mainbg" id="theme2Body">
<div class="section1_bg">
	<section class="section1">
    <div class="sec1Layout_left">
    	<article class="personal">
            <div class="info">
            	<p class="pic"><c:if test='${userPhoto == ""}'><img src="/images/default_pic.gif" style="border-radius:20px;" width="100%" height="100%" /></c:if><c:if test='${userPhoto != ""}'><img width="100%" height="100%" style="border-radius:20px;"id="myImg" src="/ezCommon/downloadAttach.do?filePath=${userPhoto }"></c:if></p>
                <dl class="info_txt">
                	<dt>
                		<%-- 2023-06-15 황인경 - 디자인 개선 > 테마2 > 상단 사용자 정보 > 부서 추가 --%>
                		<span class="info_team">${deptName}</span>
                		<span class="info_name">${userName} ${userTitle}</span>
                		<span class="info_icon">
							<span class="info_set" id="main_personalEnv"><img src="/images/admin/infoSetting.png" alt=""></span>
							<span class="info_portlet" id="main_portletEnv"><img src="/images/admin/frameSetting.png"></span>
                		</span>
                	</dt>
                    <dd><spring:message code='ezNewPortal.yej06'/> <span>${lastLogin}</span></dd>
                    <%-- 2023-06-15 황인경 - 디자인 개선 > 테마2 > 상단 사용자 정보 > 최종접속 IP 추가 --%>
                    <dd><spring:message code='ezNewPortal.hik01'/> <span>${lastLoginIP}</span></dd>
                </dl>
            </div>
            <div class="personal_content">
            <c:choose>
            	<c:when test="${useAttitude eq 'YES' }">
            		<%-- 2023-06-15 황인경 - 디자인 개선 > 테마2 > 상단 > 현재시간 문구 추가 --%>
         			<dl class="current"><spring:message code='ezNewPortal.t012' /></dl>
					<dl class="time">
	                    <dd id="timeFlow"></dd>
	                </dl>
	                <dl class="commute">
	                	<dt id="inAttiBtn" class="main_out" type="A01" datetype="2" onclick="checkHoliday(this, '${usedTheme}')"><spring:message code='ezNewPortal.t013' /></dt>
	                	<%-- <dd id="inAttiBtn_txt" class="main_out" type="A01" datetype="2" onclick="checkHoliday(this, '${usedTheme}')"><spring:message code='ezNewPortal.t126' /></dd> --%>
	                </dl>
	                <dl class="commute">
	                	<dt id="outAttiBtn" class="main_out" type="A03" datetype="2" onclick="checkHoliday(this, '${usedTheme}')"><spring:message code='ezNewPortal.t014' /></dt>
	                	<%-- <dd id="outAttiBtn_txt" class="main_out" type="A03" datetype="2" onclick="checkHoliday(this, '${usedTheme}')"><spring:message code='ezNewPortal.t126' /></dd> --%>
	                </dl>
            	</c:when>
            	<c:otherwise>
	            	<dl class="current"><spring:message code='ezNewPortal.t012' /></dl>
	            	<dl class="time">
	                    <dd id="timeFlow" style="line-height:30px;"></dd>
	                </dl>            	
            	</c:otherwise>
            </c:choose>
            </div>
        </article>
        <div class="bannerlink_area">
        	<article class="writebanner">
                <ul class="writebannerUL">
                   	<c:choose>
                   		<c:when test="${useMail eq 'NO'}">
                   		<li>
                   			<dl id="NewMail" class="icon_disabled writebannerDL">
								<dt class="iconCircle_none"><span class="iconCommon"></span></dt>
							</dl>
						</li>
                   		</c:when>
                   		<c:otherwise>
                   		<li>
                       		<dl class="writebannerDL banner_mail" id="NewMail">
                       		 	<dt class="banner_img"></dt>
                           		<dt><spring:message code='ezNewPortal.t015' /></dt>
                           		<dd id="unreadMailCount" class="iconCount_none">0</dd>
                       		</dl>
                       	</li>
                   		</c:otherwise>
                   	</c:choose>
                   	<c:choose>
                   		<c:when test="${useApproval eq 'NO'}">
                   		<li>
                   			<dl id="AprSign" class="icon_disabled writebannerDL">
								<dt class="iconCircle_none"><span class="iconCommon"></span></dt>
							</dl>
						</li>
                   		</c:when>
                   		<c:otherwise>
                   		<li>
                       		<dl class="writebannerDL banner_apr" id="AprSign">
                           		<dt class="banner_img"></dt>
                           		<dt><spring:message code='ezNewPortal.t016' /></dt>
                           		<dd id="approvalCount" class="iconCount_none">0</dd>
                       		</dl>
                       	</li>
                   		</c:otherwise>
                   	</c:choose>
                   	<c:choose>
                   		<c:when test="${useSchedule eq 'NO'}">
                   		<li>
                   			<dl id="Schedule" class="icon_disabled writebannerDL">
								<dt class="iconCircle_none"><span class="iconCommon"></span></dt>
							</dl>
						</li>
                   		</c:when>
                   		<c:otherwise>
                   		<li>
                       		<dl class="writebannerDL banner_schedule" id="Schedule">
                           		<dt class="banner_img"></dt>
                           		<dt><spring:message code='ezNewPortal.gu3' /></dt>
                           		<dd id="scheduleCount" class="iconCount_none">0</dd>
                       		</dl>
                       	</li>
                   		</c:otherwise>
                   	</c:choose>
                   	<c:choose>
                   	<%-- 구버전 전자설문(useQuestion) 영역 --%>
                   		<%-- 
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
                   		 --%>
                   		<c:when test="${useSurvey eq 'NO'}">
                   		<li>
                   			<dl id="Survey" class="icon_disabled writebannerDL">
								<dt class="iconCircle_none"><span class="iconCommon"></span></dt>
							</dl>
						</li>
                   		</c:when>
                   		<c:otherwise>
                   		<li>
                       		<dl class="writebannerDL banner_survey" id="Survey">
                           		<dt class="banner_img"></dt>
                           		<dt><spring:message code='ezNewPortal.gu4' /></dt>
                           		<dd id="surveyCount" class="iconCount_none">0</dd>
                      		</dl>
                      	</li>
                   		</c:otherwise>
                   	</c:choose>
                    
                    <%-- 2023-06-05 홍승비 - 디자인 개선을 위해 테마2 상단 영역 회람판 메뉴 표출되지 않도록 숨김 / 협업 메뉴 이미지 교체 --%>
                    <li style="display:none;">
                    	<c:choose>
                    		<c:when test="${useCircular eq 'NO' }">								
                    			<dl id="Circular" class="icon_disabled writebannerDL">
									<dt class="iconCircle_none"><span class="iconCommon"></span></dt>
								</dl>
                    		</c:when>
                    		<c:otherwise>
                        		<dl class="writebannerDL banner_circular" id="Circular">
                            		<dt class="banner_img"></dt>
                            		<dt><spring:message code='ezNewPortal.gu5' /></dt>
                            		<dd id="circularCount" class="iconCount_none">0</dd>
                        		</dl>
                    		</c:otherwise>
                    	</c:choose>
                    </li>
					<c:if test="${useEzWorkspace}">
					<li>
	                    <dl class="writebannerDL banner_workspace" id="ezWorkspace">
	                        <dt class="banner_img"></dt>
	                        <dt><spring:message code='ezNewPortal.pjg01' /></dt>
	                        <dd class="iconCount_none" id="workspaceCnt">0</dd>
	                    </dl>
                    </li>
                	</c:if>                        
                    <%-- 조직도, 커뮤니티, 메모 영역 추가 (카운트 없음) --%>
					<li>
                    <dl class="writebannerDL banner_organ" id="Organ">
                        <dt class="banner_img"></dt>
                        <dt><spring:message code='ezNewPortal.t024'/></dt>
                    </dl>
                    </li>
                    <c:if test="${useCommunity eq 'YES'}">
					<li>
	                    <dl class="writebannerDL banner_community" id="Community">
	                        <dt class="banner_img"></dt>
	                        <dt><spring:message code='main.t1006'/></dt>
	                    </dl>
                    </li>
                    </c:if>
                    <c:if test="${useMemo eq 'YES'}">
					<li>
	                    <dl class="writebannerDL banner_memo" id="Memo">
	                        <dt class="banner_img"></dt>
	                        <dt><spring:message code='ezMemo.t001'/></dt>
	                    </dl>
                    </li>
                    </c:if>
                </ul>
            </article>
        </div>
	</div>
	
	<%-- 2023-06-05 홍승비 - 디자인 개선을 위해 테마2 상단 영역 공지사항 게시판 포틀릿 추가 --%>
	<c:if test="${useBoard eq 'YES'}">
    <div class="sec1Layout_btm_left">
        <dl class="portlet_title">
			<dt class="portletText"><span></span><spring:message code='main.t65'/></dt>
            <dd class="portletPlus plus" id="theme2Sec1NoticePlusBtn"></dd>
        </dl>
        <ul id="theme2Sec1NoticeBoardUL" class="portlet_list">
			<dl class="nodata">
				<dt style="padding-top:0px;">
					<img src="/images/kr/main/noData_sIcon.png">
				</dt>
				<dd><spring:message code='ezNewPortal.t018' /></dd>
			</dl>
        </ul>
    </div>
	</c:if>
	
	<c:if test="${useSchedule eq 'YES'}">
    <div class="sec1Layout_middle">
        <div class="main_schedule">
			<article class="calender">
            	<div id="CalendarMini_Top"></div>
            </article>
        	<article class="list">
            	<div class="maintab01">
                	<p class="left_on" id="pSchedule"><spring:message code='ezNewPortal.t027' /></p>
                    <p class="right" id="dSchedule"><spring:message code='ezNewPortal.t028' /></p>
                </div>
                <div class="scrollbox-play-light">
                	<div class="scrollbox">
                    	<div class="content">
                        	<ul class="portlet_list" id="schedule_list_Top"></ul>
                        </div>
                        <div class="scrollbar-v scrollbar-v-disabled">
                        	<img class="button-up" style="display:none;">
                            <img class="thumb-v" style="display:none; top:0px;">
                            <img class="button-down" style="display:none; bottom:0px;">
                        </div>
                    </div>
                </div>
            </article>
        </div>
	</div>
	</c:if>
	
	<%-- 2023-06-05 홍승비 - 디자인 개선을 위해 테마2 상단 영역 메일/웹폴더 용량 추가 --%>
	<%-- 실제 기능은 구현 필요 (솔루션 1팀 지원 필요) --%>
	<div class="sec1Layout_right">
        <article class="event">
        	<c:if test="${useMail eq 'YES'}">
	        <dl class="portlet_title">
	            <dt class="portletText"><spring:message code='main.t00045'/></dt>
	            <dd class="mailGraph" id="mailGraphPortal">
	                <p class="mGraph"><span id="mGraphSpanPortal"></span></p><span class="mGraph_text" id="useMailBoxPortal"></span>
	            </dd>
	        </dl>
	        <%-- <dl class="portlet_title">
                <dt class="portletText"><spring:message code='ezNewPortal.t015' /></dt>
                <dd class="mailGraph" id="mailGraphPortal2">
                    <p class="mGraph"><span id="mGraphSpanPortal2"></span></p><span class="mGraph_text" id="useMailBoxPortal2"></span>
                </dd>
            </dl> --%>
	        </c:if>
	        <c:if test="${useWebfolder eq 'YES'}">
	        <dl class="portlet_title">
	            <dt class="portletText"><spring:message code='ezWebFolder.t10'/></dt>
	            <dd class="mailGraph" id="usedRatePortal">
	                <p class="mGraph"><span id="usedRateSpanPortal"></span></p><span class="mGraph_text" id="usingCpacityPortal"></span>
	            </dd>
	        </dl>
	        </c:if>
        </article>
        <article class="exellentEmployee">
			<dl class="portlet_title">
	            <dt class="portletText">
	                <span></span><spring:message code='ezNewPortal.t127'/> <spring:message code='ezNewPortal.t128'/>
	            </dt>
	        </dl>
            <dl class="excellent_info" id="excellentcontent">
                <dt id="exellentEmpName"></dt>
                <dt id="exellentDeptName"></dt>
                <dd id="emPic"><%-- <img src="/images/ezNewPortal/best_month.png"> --%></dd>
            </dl>
        </article>
    </div>
	</section>
</div>
<div class="section_main">
	<section>
		<div id="fixBoardArea"></div>
		<div id="dummyArea"></div>
		<div id="portletArea" class="portlet_area">
		</div>
	</section>
</div>

	<div style="width: 100%; height: 100%; position: fixed; top: 0; left: 0; z-index: 1005; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
			
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
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
<%-- 2023-06-07 홍승비 - 테마2 > 상단 사용자 정보 영역 좌측 하단 > 회사별 공지사항 게시판 표출 영역 추가 --%>
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/boardPortletTheme2Upper.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortlet/web-animations.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortlet/muuri.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortlet/portlet-util.js')}"></script>
<link rel="stylesheet" href="${util.addVer('/css/ezPortlet/portlet.css')}" type="text/css" />
<script type="text/javascript">
	var fixedPortletList = JSON.parse('${fixedPortletList}');
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
 	var usePaging = "<c:out value='${usePaging}'/>";
 	var theme2 = true;
 	var WorkspaceUrl = "${workspaceHostUrl}"; // 협업이 그룹웨어와 별도의 Url로 서비스 되는 경우에만 설정
    var workspaceContextRootUrl = "${workspaceContextRootUrl}";
    /* 2025-03-13 홍승비 - 협업 모듈에 고정된 하드코딩 문자열 제거 (ezWorkspace), 테넌트 컨피그 workspaceAppPath로 협업 웹응용프로그램 경로를 분리하여 사용 ("/" 또는 "/ezWork" 등) */
    var workspaceAppPath = "${workspaceAppPath}";
    var userLang = "<c:out value='${userLang}'/>";
    var userLang2 = "<c:out value='${userLang2}'/>";
	var usePortletSize = "<c:out value='${usePortletSize}'/>" === "Y";
	var portletInfoMap = {};
	var useWebHWP = "<c:out value='${useWebHWP}'/>";
	var companyID = "<c:out value='${companyID}'/>";
	var userID = "<c:out value='${userId}'/>";
	var apprPortletIDs = [];
	var apprPortletTypes = [];
	var strBoardPassword =  "<spring:message code='ezBoard.private.pgb05' />";
	var strBoardOk =  "<spring:message code='ezBoard.private.pgb06' />";
	var strWrongPassword =  "<spring:message code='ezBoard.t267' />";
	
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
 	
 	// 퀵링크 셋팅 
 	var setQuickLinkList = function (data) {
 		var quickList = data.quickLinkList;
 		var totalCnt = data.totalPageCnt;
 		quickLinkPage.total = totalCnt;
 		
 		var quickMenu = document.getElementById('quickmenu');
 		
 		while(quickMenu.hasChildNodes()) {
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
		
		/* 2023-06-07 홍승비 > 홈 > 테마2 퀵링크 영역 디자인 개선을 위한 이미지 수정 */
		preBtnImg.setAttribute('src', '/images/ezNewPortal/link_preBtn_dis_bk.png');
		
		if (quickLinkPage.current*1 === 1 || totalCnt*1 === 0) {
			preBtnImg.setAttribute('id', 'preBtnDis');
		} else {
			preBtnImg.setAttribute('id', 'preBtn');
		}
		
		linkBtnPre.appendChild(preBtnImg);
		
		var linkBtnNext = document.createElement('span');
		linkBtnNext.classList.add('linkBtn_next');
		var nextBtnImg = document.createElement('img');
		
		nextBtnImg.setAttribute('src', '/images/ezNewPortal/link_nextBtn_dis_bk.png');
		
		if (quickLinkPage.current*1 === totalCnt*1 || totalCnt*1 === 0) {
			nextBtnImg.setAttribute('id', 'nextBtnDis');
		} else {
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
	
//  	var setQuickLinkList = function (data) {
//  		var quickList = data.quickLinkList;
//  		var totalCnt = data.totalPageCnt;
 		
//  		quickLinkPage.total = totalCnt;
 		
//  		var quickUl = document.getElementById('QuickUl');
 		
//  		// 현재 리스트를 갖고 있는 경우 삭제 후 진행
//  		while (quickUl.hasChildNodes()) {
//  			quickUl.removeChild(quickUl.firstChild);
//  		}
 		
// 		quickList.forEach(function (item, index) {
// 			var li = document.createElement('li');
// 			li.classList.add('linkText');
// 			li.textContent = item.quickLinkName;
			
// 			// 이벤트 등록
// 			li.addEventListener('click', function(){
// 				// size가 FULL인 경우 vs 아닌 경우
// 				if(item.size === 'FULL') {
// 					window.open(item.url, '_blank', '');
// 				} else if (item.size.indexOf(':') > 0) {
// 					var sizeArr = item.size.split(':');
// 					var popupX = (window.screen.width / 2) - (sizeArr[0] /2);
// 					var popupY = (window.screen.height / 2) - (sizeArr[1] /2);
// 					var option = 'width='+sizeArr[0]+'px,height='+sizeArr[1]+'px, left='+popupX+', top='+popupY+', status = no, toolbar=no, menubar=no,location=no, resizable=0';
// 					window.open(item.url, '_blank', option);
// 				}
// 			});
			
// 			quickUl.appendChild(li);
// 		});
		
// 		// 퀵링크 페이지 					
// 		var btnLay = document.getElementById('btnLay');
		
// 		// 현재 리스트를 갖고 있는 경우 삭제 후 진행
//  		while (btnLay.hasChildNodes()) {
//  			btnLay.removeChild(btnLay.firstChild);
//  		}		
		
// 		var linkBtnPre = document.createElement('span');
// 		linkBtnPre.classList.add('linkBtn_pre');
// 		var preBtnImg = document.createElement('img');
		
// 		if(quickLinkPage.current*1 === 1 || totalCnt*1 === 0) {
// 			preBtnImg.setAttribute('src', '/images/ezNewPortal/link_preBtn_dis.png');
// 			preBtnImg.setAttribute('id', 'preBtnDis');
// 		} else {
// 			preBtnImg.setAttribute('src', '/images/ezNewPortal/link_preBtn.png');
// 			preBtnImg.setAttribute('id', 'preBtn');
// 		}
		
// 		linkBtnPre.appendChild(preBtnImg);
		
// 		var linkBtnNext = document.createElement('span');
// 		linkBtnNext.classList.add('linkBtn_next');
// 		var nextBtnImg = document.createElement('img');
		
// 		if(quickLinkPage.current*1 === totalCnt*1 || totalCnt*1 === 0) {
// 			nextBtnImg.setAttribute('src', '/images/ezNewPortal/link_nextBtn_dis.png');
// 			nextBtnImg.setAttribute('id', 'nextBtnDis');
// 		} else {
// 			nextBtnImg.setAttribute('src', '/images/ezNewPortal/link_nextBtn.png');
// 			nextBtnImg.setAttribute('id', 'nextBtn');
// 		}
		
// 		linkBtnNext.appendChild(nextBtnImg);
		
// 		btnLay.appendChild(linkBtnPre);
// 		btnLay.appendChild(linkBtnNext);
		
// 		// 페이징 클릭 이벤트
// 		var preBtn = document.getElementById('preBtn');
// 		var nextBtn = document.getElementById('nextBtn');

// 		if(preBtn !== null) {
// 			preBtn.addEventListener('click', function () {
// 				quickLinkPage.current = (quickLinkPage.current*1) - 1;
// 				getQuickLink();
// 			});	
// 		}
		
// 		if(nextBtn !== null) {
// 			nextBtn.addEventListener('click', function () {
// 				quickLinkPage.current = (quickLinkPage.current*1) + 1;
// 				getQuickLink();
// 			});
// 		}
		
//  	}	
	
	//월별 우수사원 정보 호출
	var getMonthlyBestEmployeeTheme2 = function () {
		$.ajax({
			type : "GET",
			url : "/ezNewPortal/getMonthlyBestEmployee.do",
			dataType : "json",
			success : function(result) {
				var bestEmployee = result.bestEmployee;
				var excellentContent = document.getElementById('excellentcontent');
				
				if (bestEmployee === null || bestEmployee ==  undefined) {
					var emPic = document.getElementById('emPic');
					
					var img = document.createElement('img');
 					img.style.width = '100%';
					img.style.height = '100%';
 					img.style.maxWidth = '70px';
					img.style.maxHeight = '60px';
					img.src = '\/images/ezNewPortal/bestEmployee_pic_none.png';

					emPic.appendChild(img);
					
					document.getElementById("exellentDeptName").innerText = "";
					document.getElementById("exellentEmpName").innerText = '<spring:message code="ezNewPortal.t018" />';
					
					var nodata = document.getElementById("exellentEmpName");
					nodata.style.color = "#c0c0c0";
					
				} else {
					var emPic = document.getElementById('emPic');
					
					var img = document.createElement('img');
 					img.style.width = '100%';
					img.style.height = '100%';
					img.style.maxWidth = '70px';
					img.style.maxHeight = '60px';
					img.src = bestEmployee.userImg;
					
					emPic.appendChild(img);
					
					document.getElementById("exellentDeptName").innerText = bestEmployee.userDeptName;
					document.getElementById("exellentEmpName").innerText = (bestEmployee.userName + " " + bestEmployee.title);
				}
			}
		});
	}
	
	var getScheduleList_after_Theme2 = function (list) {
		// 개인일정, 부서일정 나누기 scheduleType 1 or 2
		pScheduleList = [];
		dScheduleList = [];
		list.forEach(function(item, index) {
			if(item.scheduleType === '1' || item.scheduleType === '9') {
				pScheduleList.push(item);	
			} else if (item.scheduleType === '2') {
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
			img.src = '/images/kr/main/noData_sIcon.png';
			
			dt.appendChild(img);
			var dd = document.createElement('dd');
			dd.textContent = '<spring:message code="ezNewPortal.t018" />';
			
			dl.appendChild(dt);
			dl.appendChild(dd);
			
			schList.appendChild(dl);
			return;
		}
		
		/* 2023-06-05 홍승비 - 디자인 개선을 위헤 상단 영역 일정 리스트 표출 수정 (li, span 태그 분리 / 클릭 이벤트는 기존 li 태그로 유지) */
        data.forEach(function(item, index) {
        	if (index > 4) { return; }
        	var li = document.createElement('li');
        	var span = document.createElement('span');
        	
        	span.className = "txt";
        	
        	// 2020-02-25 김정언
        	if (item.dateType == "4") {
        		/*
        		li.textContent = item.title + " : " + item.creatorName;
            	li.style.cursor = "pointer";
            	*/
            	span.innerText = (ConvertCharToEntityReference(item.title) + " : " + item.creatorName);
            	
            	li.addEventListener('click', function() {  			    
            		if (CrossYN()) {
    					var OpenWin = window.open("/ezAttitude/attitudeItemView.do?attitudeId=" + encodeURIComponent(item.scheduleId) + "&typeId=" + item.parentId, "", GetOpenWindowfeature(672, 640));
    					
    					try { OpenWin.focus(); } catch (e) { }
    				} else {
    					window.showModalDialog("/ezAttitude/attitudeItemView.do?attitudeId=" + encodeURIComponent(item.scheduleId) + "&typeId=" + item.parentId, "", 
    					    "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(672, 640));
    				}   		
            	});
        	} else if(item.scheduleType == '9') {
        		/*
        		li.textContent = '['+ item.startDate.substring(11, 16) + ' ~ ' + item.endDate.substring(11, 16) + '] ' + item.title;
	        	li.style.cursor = "pointer";
	        	*/
	        	span.innerHTML = ("<span>[" + item.startDate.substring(11, 16) + " ~ " + item.endDate.substring(11, 16) + "]</span> " + ConvertCharToEntityReference(item.title));
	        	
	        	li.addEventListener('click', function() {
				    var wWeight = "760";
				    var wHeight = "650";
				    var heigth = window.screen.availHeight;
				    var width = window.screen.availWidth;
				    var left = (width - wWeight) / 2;
				    var top = (heigth - wHeight) / 2;
				
			        window.open("/ezSchedule/googleScheduleRead.do" + "?id=" + encodeURIComponent(item.googleId) + "&type=" + item.scheduleType + "&datetype=" + item.dateType + "&repeatcount=" + item.repeatCount + "&startdate=" + item.startDate + "&enddate=" + item.endDate + "&pattern=0","",
				        "top = " + top + ", left = " + left + ",height = " + wHeight + "px, width = " + wWeight + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1 scrollbars=0");        		
	        	});
        	} else {
        		/*
	        	li.textContent = '['+ item.startDate.substring(11, 16) + ' ~ ' + item.endDate.substring(11, 16) + '] ' + item.title;
	        	li.style.cursor = "pointer";
	        	*/
	        	span.innerHTML = ("<span>[" + item.startDate.substring(11, 16) + " ~ " + item.endDate.substring(11, 16) + "]</span> " + ConvertCharToEntityReference(item.title));
	        	
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
        	}
        	
        	li.appendChild(span);
        	schList.appendChild(li);
        });
	}
	
	function schedule_get_holiday_top() {
	    $.ajax({
			type : "GET",
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
	                    var holidayFlag;
	                    
	                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISSOLAR")[0].textContent == "1") {
	                        issolar = "1";
	                    } else {
	                        issolar = "2";
	                    }
	                    
	                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREST")[0].textContent == "1") {
	                        holiday = true;			                    
	                    } else {
	                        holiday = false;
	                    }
	                    
	                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYFLAG")[0].textContent == "Y") {
	                        holidayFlag = "Y";			                    
	                    } else {
	                        holidayFlag = "D";
	                    }
	                    
	                    var repetition = GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYREPEAT")[0].textContent;	                    
	                    
	                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREPEAT")[0].textContent == "1") {
	                        memorialDays.push(new memorialDay(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent, GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent,
	                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(5, 7),
	                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(8, 10), issolar, holiday, holidayFlag, repetition));
	                    } else {                   	
	                        yearmemorialDays.push(new yearmemorialDay(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent, GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent,
	                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(0, 4),
	                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(5, 7),
	                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(8, 10), issolar, holiday, holidayFlag, repetition));
	                    }
	                }
	            }			            
	            CalendarMiniView("CalendarMini_Top");
				CalendarMiniDataSource("Top");
			}		    		
	    });
	}

	var tryCount = 0;
	
	var sortableEvent = function () {
		//포틀릿 드래그 앤 드롭
		if (usePortletSize) return false;
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

	$(function() {
		makePortletsShell(portletOrder)
		makePortlets(portletOrder);

		var useQuestion = "<c:out value='${useQuestion}'/>";
		var useSurvey = "<c:out value='${useSurvey}'/>";
		var useCircular = "<c:out value='${useCircular}'/>";
		var useMail = "<c:out value='${useMail}'/>";
		var useApproval = "<c:out value='${useApproval}'/>";
		var useSchedule = "<c:out value='${useSchedule}'/>";
		var useCommunity = "<c:out value='${useCommunity}'/>";
		var useMemo = "<c:out value='${useMemo}'/>";
		var useBoard = "<c:out value='${useBoard}'/>";
		
		//메뉴 이동(위) --- 권한이 YES일 때만 버튼 동작
		if (useMail !== "NO") {
			document.getElementById("NewMail").addEventListener('click', function(){quickMenuOpen('NewMail');}, false);
			//document.getElementById("NewMail").addEventListener('click', function(){Mailmore_btnClick2('${MailServerURL2}');}, false);
		}
		
		if (useSchedule !== "NO") {
			document.getElementById("Schedule").addEventListener('click', function(){quickMenuOpen('Schedule');}, false);
		}
		/* 
		if (useQuestion !== "NO") {
			document.getElementById("Poll").addEventListener('click', function(){quickMenuOpen('Poll');}, false);
		}
		 */
		if (useSurvey !== "NO") {
			document.getElementById("Survey").addEventListener('click', function(){quickMenuOpen('Survey');}, false);
		}
		
		if (useCircular !== "NO") {
			document.getElementById("Circular").addEventListener('click', function(){quickMenuOpen('Circular');}, false);
		}
		
		if (useApproval !== "NO") {
			document.getElementById("AprSign").addEventListener('click', function(){quickMenuOpen('ApprG');}, false);
		}
		
		/* 2023-06-05 홍승비 - 테마2 상단 사용자 영역 > 조직도, 커뮤니티, 메모 메뉴 연결 추가 */
		document.getElementById("Organ").addEventListener('click', function(){quickMenuOpen('Organ');}, false);
		
		if (useCommunity !== "NO") {
			document.getElementById("Community").addEventListener('click', function(){quickMenuOpen('Community');}, false);
		}
		if (useMemo !== "NO") {
			document.getElementById("Memo").addEventListener('click', function(){quickMenuOpen('Memo');}, false);
		}
		
		//ajax로 count 불러오기
		getUnreadCounts(useSurvey, useCircular, useMail, useApproval, useSchedule);
		
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
		//document.getElementById("quicklinkBtn").addEventListener('click', viewQuick); 2024-05-23 링크 아이콘 삭제.
		
		//퀵메뉴 이동(오른쪽)
// 		document.getElementById("quickMailwrite").addEventListener('click', function(){quickMenuOpenRight('mail');}, false);
// 		document.getElementById("quickApprovalwrite").addEventListener('click', function(){quickMenuOpenRight('appr');}, false);
// 		document.getElementById("quickSchedulewrite").addEventListener('click', function(){quickMenuOpenRight('schedule');}, false);
// 		document.getElementById("quickOrgan").addEventListener('click', function(){quickMenuOpenRight('organ');}, false);

		// 퀵링크 호출
		//getQuickLink();		
		
		//포틀릿 드래그 앤 드롭
		if (navigator.userAgent.toLowerCase().indexOf("firefox") == -1) {
			sortableEvent();
		}
		
		/* $(".portlet_area").disableSelection(); */
		
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
		
		/* 2023-06-07 홍승비 - 테마2 > 상단 사용자 정보 영역 좌측 하단 > 회사별 공지사항 게시판 표출 영역 추가 (boardPortletTheme2Upper.js 참고)  */
		if (useBoard == "YES") {
			getTheme2NotiBoardItem();
		}
		
		setPortalRefresh();
		
		// 2023-06-20 한슬기 - 테마2 > 상단에 메일 용량 표시 추가
		var getMailCapacity = function() {
	        var mailCapacityInfo = loadXMLString("${mailCapacityInfo}");
			var mGraphSpanPortal = $("#mGraphSpanPortal");
	        var useMailBoxPortal = $("#useMailBoxPortal");
	        useMailBoxPortal.text(GetChildNodes(SelectNodes(mailCapacityInfo, "DATA/ROW")[0])[1].textContent
	        					 + "\/"+GetChildNodes(SelectNodes(mailCapacityInfo, "DATA/ROW")[0])[0].textContent);
	        mGraphSpanPortal.css('width', GetChildNodes(SelectNodes(mailCapacityInfo, "DATA/ROW")[0])[2].textContent);
		}

		// var getMailCapacity2 = function() {
        //     var mailCapacityInfo2 = loadXMLString("${mailCapacityInfo2}");
        //     var mGraphSpanPortal2 = $("#mGraphSpanPortal2");
        //     var useMailBoxPortal2 = $("#useMailBoxPortal2");
        //     useMailBoxPortal2.text(GetChildNodes(SelectNodes(mailCapacityInfo2, "DATA/ROW")[0])[1].textContent
        //                          + "\/"+GetChildNodes(SelectNodes(mailCapacityInfo2, "DATA/ROW")[0])[0].textContent);
        //     mGraphSpanPortal2.css('width', GetChildNodes(SelectNodes(mailCapacityInfo2, "DATA/ROW")[0])[2].textContent);
        // }
        // getMailCapacity2();

		getMailCapacity();
		
		// 2023-06-20 한슬기 - 테마2 > 상단에 웹폴더(개인) 용량 표시 추가 
		<c:if test="${not empty webFolderPersonalFolderId}">
		
			var webFolderPersonalFolderCapacity = function() {
				// 용량정보 표시
				function getUsageSuffix(webFolderPersonalFolderCapacity) {
					var max = webFolderPersonalFolderCapacity.totalCapacity * 1024 * 1024;
					var usage = webFolderPersonalFolderCapacity.totalUsed / 1024;
					
					return kilobyteCalculation(usage) + "/" + kilobyteCalculation(max);
				}
				
				// KB, MB, GB 표시
				function kilobyteCalculation(kilobyte) {

					if (kilobyte >= 1024 * 1024) {
						return trimDecimal(kilobyte / (1024 * 1024)) + "G";
					} else if (kilobyte >= 1024) {
						return trimDecimal(kilobyte / 1024) + "M";
					} else {
						return trimDecimal(kilobyte) + "K";
					}
				}
				
				function trimDecimal(number) {
					var str = Math.floor(number);
					
					return str;
				}
				
				$.ajax({
					type: "POST",
					async: true,
					url: "/ezWebFolder/getCapacity.do",
					dataType:"json",
					data: {
						folderId: ${webFolderPersonalFolderId}
					},
					success: function(data) {
						var webFolderPersonalFolderCapacity = data.capacity;
						var usedRate = Math.min(webFolderPersonalFolderCapacity.usedRate, 100);
						var usageSuffix = getUsageSuffix(webFolderPersonalFolderCapacity);
						
						$("#usedRateSpanPortal").css("width", usedRate + "%");
						$("#usingCpacityPortal").text(usageSuffix);
					}
				});
			}
			
			webFolderPersonalFolderCapacity();
		</c:if>
	});
	
</script>
<!-- 협업 시작-->
<c:if test="${useEzWorkspace}">
    <script type="text/javascript" src="${workspaceContextRootUrl}/Scripts/moment.min.js"></script>
    <script type="text/javascript" src="${workspaceContextRootUrl}/Scripts/Groupwareapi.js"></script>
    <script type="text/javascript">
	    var g_UserID = "${userId}"; // GW 사용자 Id, 가온누리 Java버전엔 이미 선언되어 있음
	    /* var WorkspaceUrl = "${workspaceHostUrl}"; // 협업이 그룹웨어와 별도의 Url로 서비스 되는 경우에만 설정
	    var workspaceContextRootUrl = "${workspaceContextRootUrl}"; */
	    var g_bGroupwareUIType = false;  // 그룹웨어 UI 타입 => true: UIUX, false: Normal(예전 GW 화면)
	    var feedListCount = 10;
	    var g_bRayful = false;
	    var g_bVisible = true; // 문서탭 선택 시 원문에 포함된 첨부파일 포함 여부 (false: 포함)
	    var g_bEzWorkspaceJava = true; // 협업 자바버전 변경을 위한 변수
	    
    	ezWorkspaceData(workspaceContextRootUrl);
    </script>		
</c:if>	
<!-- 협업 끝 -->	
</body>	
</html>