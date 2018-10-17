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
<link href="${util.addVer('/css/ezNewPortal/newPortal_css.css')}" rel="stylesheet" type="text/css">

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
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/newPortal_common.js')}"></script>
<!-- 종균 시작-->
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/helpPortlet.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/noticePortlet.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/pollPortlet.js')}"></script>
<!-- 종균 끝 -->
<!-- 해안 시작 -->
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/communityPortlet.js')}"></script>
<!-- 해안 끝 -->
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
 	
	$(function() {
		$("#featured").orbit();
	 	
		var portletCount = portletOrder.length;
		
		for (var i = 0; i < portletCount; i++) {
			var strHTML = "";
			strHTML += "<div class='box_shadow' id='";
			strHTML += portletOrder[i].portletId + "Portlet'>";
			strHTML += "</div>";
			
			$(".portlet_area").append(strHTML);
		}
		
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
		
		//ajax로 count 불러오기
		getUnreadCounts();
		
		//근태관리 연동
		parseDate();
		attiClock();
		
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
		
		//포틀릿 드래그 앤 드롭
		$(".portlet_area").sortable({
			handle : ".sortablePortlet",
			update : function(event, ui) {
				updatePortletOrderUser();
			}
		});
		
		$(".portlet_area").disableSelection();
	});
	
	</script>
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
	</style>
</head>

	<body class="mainbg">
		<div id="center">
			<section class="section_left" style="height:1130px;">
				<article class="time_check">
					<div id="timeinput" class="presentTime">
	               		<p class="timeTit" id="todayTime">현재시간</p>
						<div id="timeFlow" class="timeText"></div>
			    	</div>
			    	<div id="atti_area" class="main_time">
	            	<dl class="timeCheckIn">
	                	<dd id="inAttiBtn" class="out" type="A01" datetype="2" onclick="checkHoliday(this)">출근</dd>
	                </dl>
	                <dl class="timeCheckOut">
	                   	<dd id="outAttiBtn" class="out" type="A03" datetype="2" onclick="checkHoliday(this)">퇴근</dd>
	                </dl>
		    	</div>
				</article>
				
				<article class="countingIcon">
					<div class="countingIcon01">
						<dl id="NewMail" onclick="btnSumming_click(this)">
                			<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon01.png"></dt>
                    		<dd class="iconText">새메일</dd>
                    		<dd id="unreadMailCount" class="iconCount_none">0</dd>
                		</dl>
                		<dl id="AprSign" onclick="btnSumming_click(this)">
                    		<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon03.png"></dt>
                    
                    		<dd class="iconText">결재문서</dd>
                    		<dd id="approvalCount" class="iconCount_none">0</dd>
                		</dl>
                		<dl id="Schedule" onclick="btnSumming_click(this)">
                  		  	<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon02.png"></dt>
                    		<dd class="iconText">오늘일정</dd>
                		    <dd id="scheduleCount" class="iconCount_none">0</dd>
               			</dl>
					</div>
					<div class="countingIcon02">
            			<dl id="Poll" onclick="btnSumming_click(this)">
                    		<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon05.png"></dt>
                    		<dd class="iconText">전자설문</dd>                        
                    		<dd id="pollCount" class="iconCount_none">0</dd>
                		</dl>
            	
                		<dl id="Circular" onclick="btnSumming_click(this)"> 
                    		<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon04.png"></dt>
                    		<dd class="iconText">회람판</dd>
                    		<dd id="circularCount" class="iconCount_none">0</dd>
                		</dl>
                	</div>
				</article>
				<article class="birthday">
					<div class="birthTit">
               			<p class="birthText"><span id="curMon"></span>월 생일자</p>
           	    		<span class="birthRighttbtn" id="birthdayNext"><img src="/images/ezNewPortal/birthday_next.png"></span>
                		<span class="birthLeftbtn" id="birthdayPrev"><img src="/images/ezNewPortal/birthday_pre.png"></span>
            		</div>
            		<div id="birthcont" style="display: none;">
            			<ul class="birthList" id="userList"></ul>
            		</div>
            		<div id="nodata_NewBirth" style="">
            			<dl class="nodata">
	            			<dt style="padding-top:33px"><img src="/images/ezNewPortal/nodata.png"></dt>
	            			<dd>"데이터가 없습니다"</dd>
            			</dl>
            		</div>
				</article>
				<article class="bestEmployee">
					<p class="emPic" id="emPic"><img src="/images/ezNewPortal/bestEmployee_pic_none.png"></p>
					<dl class="emDL">
            			<dt class="emTit">이달의 우수사원</dt>
            		</dl>
				</article>
			</section>
		</div>
		<aside id="quickSide">
			<p class="linkBtn_open"></p>
			<div class="aside_quick">퀵메뉴</div>
			<div class="aside_link">퀵링크</div>
		</aside>
		<section class="section_main">
			<div class="portlet_area">
			</div>
		</section>
		
		<div style="width: 100%; height: 100%; position: fixed; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>
			
		<div class="layerpopup"  style="z-index: 2000; position: fixed;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
	</body>
</html>