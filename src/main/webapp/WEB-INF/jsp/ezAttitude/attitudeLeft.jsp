<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<title>left_attitude</title>
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('/css/main.css')}" type="text/css"/>	
		<link rel="stylesheet" href="${util.addVer('/css/ezAttitude/clockTemp1.css')}" type="text/css" />
<%-- 		<link rel="stylesheet" href="${util.addVer('/css/ezAttitude/timecheck.css')}" type="text/css" />	 --%>
		<link rel="stylesheet" href="${util.addVer('ezAttitude.i2', 'msg')}" type="text/css"/>
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Holiday.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezAttitude/Calendar.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<style>
			.time {
				float:left;
				width:100%;
				border-bottom:1px solid #cdd2d9;
			}
			
			.time .title {
				font-size: 12px;
				color:#000;
				font-weight:bold;
				text-align:center;
				height:25px;
				margin:0px;
				padding:0px;
				line-height:25px;
			}
			
			#atti_area span{
				width:35px;
				margin-left:7px;
				display:inline-block;
				padding: 5px 4px;
				font: 12px malgun gothic;
				padding-top: 7px;
 				border: 1px solid #ddd;
 				color: #666;
				border-radius:3px;
			}
			
			.btn_hover{
				cursor: pointer;
				color: rgb(4, 112, 227) !important;
				border-color: rgb(4, 112, 227) !important;
			}
			
			.btn_disabled{
				background-color: transparent !important;
				border: 1px solid #ddd !important;
				color: #aaa !important;
			}
			
			#inAttiClock, #outAttiClock {
				background: url("/images/clock.png") no-repeat 0 4px;
				background-size: 14px;
				height:20px;
				font-family: Malgun Gothic, Meiryo UI;
			}
			#mCSB_1_container {
				margin-right: 0px;
			}
		</style>
		
		<script type="text/javascript">
		var userOffset = "${userOffset}";
		var uselang = "${uselang}";
		var closedDay = "${attitudeConfigVO.closedDay}";
		var checkClosedToday = false;
		var leaveEarlyFlag = false; // 조퇴가 등록되어있는지 체크
		var serverTime = "${serverTime}";
		var nowAttiTime = "";
		var beforeAlertDate = "";
		var afterAlertDate = "";
		var overTime = "";
		var timeDiff;
		
		window.onload = function(){
			closedDay = closedDay.split(",");
			
			parseDate();
			//attiClock();
			setAttiBtnHover();
			getAttitudeList();
			getHolidayList();
		    /* select_memorialDays(uselang); */
		    
		    document.getElementById('userAttitude').onclick();
		    
		    leftResize();
	        $(".attitudeListBox").mCustomScrollbar({
        		theme : "dark"
        	});
	        
	      	var initClock = setInterval(function(){
		     		var servert = new Date(serverTime);
		     		var clientt = new Date();
		     		
		     		var serverMonth = (servert.getMonth() + 1);
		     		serverMonth = serverMonth >= 10 ? serverMonth : '0' + serverMonth;
					var serverDate = servert.getDate();
					serverDate = serverDate >= 10 ? serverDate : '0' + serverDate;
		     		var serverDay = servert.getFullYear() + '' + serverMonth + '' + serverDate;
		     		
		     		var clientMonth = (clientt.getMonth() + 1);
		     		clientMonth = clientMonth >= 10 ? clientMonth : '0' + clientMonth; 
		     		var clientDate = clientt.getDate();
		     		clientDate = clientDate >= 10 ? clientDate : '0' + clientDate;
		     		var clientDay = clientt.getFullYear() + '' + clientMonth + '' + clientDate;
		     		
		      		if(serverDay < clientDay) {
		      			getAttitudeList();
			     		clearInterval(initClock);
		      		}
		      	}, 5000);
		}
		
		 function leadingZeros(n, digits) {
	        var zero = '';
	        n = n.toString();

	        if (n.length < digits) {
	            for (i = 0; i < digits - n.length; i++)
	                zero += '0';
	        }
	        return zero + n;
	    }
		
		function getAttitudeList() {
	    	$.ajax({
	    		type : "POST",
	    		dataType : "json",
	    		async : false,
	    		url : "/ezAttitude/getAttitudeList.do",
	    		data : {},
	    		success : function(result) {
	    			leaveEarlyFlag = false;
	    			for (var i = 0; i < result.length; i++) {
	    				if (result[i].typeId == "A01") {
		    				$("#inAttiBtn").attr("onclick", "").unbind("mouseenter");
							$("#inAttiBtn").removeClass("out").addClass("in");
							$("#inAttiBtn").html("<span class='sub_iconLNB workIcon'></span>" + "<span class='workT'>"+result[i].startDate.split(" ")[1].substring(0,5)+"</span>");
	    				} else if (result[i].typeId == "A02") {
	    					$("#inAttiBtn").attr("onclick", "").unbind("mouseenter");
							$("#inAttiBtn").removeClass("out").addClass("lateIn");							
							$("#inAttiBtn").html("<span class='sub_iconLNB workIcon'></span>" + "<span class='workT'>"+result[i].startDate.split(" ")[1].substring(0,5)+"</span>");
	    				} else if (result[i].typeId == "A03") {
// 	    					$("#outAttiBtn").attr("onclick", "").unbind("mouseenter"); //퇴근은 여러번 찍을 수 있다.
							$("#outAttiBtn").removeClass("out").addClass("in");
							$("#outAttiBtn").html("<span class='sub_iconLNB workIcon'></span>" + "<span class='workT'>"+result[i].startDate.split(" ")[1].substring(0,5)+"</span>");
	    				}
	    			}
	    			
	    			if(result.length == 0) {
	    				var a = '<p class="btn_write02" id="outAttiBtn" type="A03" datetype="2" onclick="checkHoliday(this)"><span class="sub_iconLNB workIcon"></span><span class="workT"><spring:message code='ezAttitude.t65'/></span></p>'+
	    						'<p class="btn_write01" id="inAttiBtn" type="A01" datetype="2" onclick="checkHoliday(this)"><span class="sub_iconLNB workIcon"></span><span class="workT"><spring:message code='ezAttitude.t64'/></span></p>';
	    				$(".btn_writeBox_work").empty();
	    				$(".btn_writeBox_work").append(a);
	    			}
	    		}
	    	})
	    }
	    
		function getHolidayList() {
			$.ajax({
				type:"GET",
				dataType : "json",
				async : true,
				url : "/ezAttitude/getHolidayList.do",
				data : {
					isRest : "rest"
				},
				success : function(result) {
					for (var i = 0; i < result.holidayList.length; i++) {
						var isSolar = "";
						var holidayFlag = "";
						var repetition = "";
						
						if (result.holidayList[i].isSolar == "1") {
							isSolar = "1";
						} else {
							isSolar = "2";
						}
						
						if (result.holidayList[i].holidayDate == null) {
							result.holidayList[i].holidayDate = '';
						}
						
						if (result.holidayList[i].holidayRepeat == null) {
							repetition = '';
						} else {
							repetition = result.holidayList[i].holidayRepeat;
						}
						
						if (result.holidayList[i].holidayFlag == 'Y') {
							holidayFlag = "Y";			                    
		                } else {
		                    holidayFlag = "D";
		                }
						
						if (result.holidayList[i].isRepeat == 1) { //매년 반복되는 경우
							memorialDays.push(new memorialDay(result.holidayList[i].holidayName, result.holidayList[i].holidayName2, 
															  result.holidayList[i].holidayDate.substring(5,7), result.holidayList[i].holidayDate.substring(8,10),
															  isSolar, result.holidayList[i].isRest == 1 ? true : false, holidayFlag, repetition));
						} else if (result.holidayList[i].isRepeat == 0) { //해당 년에만 적용이 되는 경우
							yearmemorialDays.push(new yearmemorialDay(result.holidayList[i].holidayName, result.holidayList[i].holidayName2,
																	  result.holidayList[i].holidayDate.substring(0,4), result.holidayList[i].holidayDate.substring(5,7),
																	  result.holidayList[i].holidayDate.substring(8,10), isSolar,
																	  result.holidayList[i].isRest == 1 ? true : false, holidayFlag, repetition));
						}
					}
				}
			});
		}
		
		//휴일 체크
		function checkHoliday(obj) {
			var useHolidayCheckYN;
			
			$.ajax({
				type : "POST",
				async : false,
				url : "/ezAttitude/holidayCheck.do",
				data : {},
				success : function(result) {
					useHolidayCheckYN = result;
				}
			});
			
			var todayLunar = lunarCalc(nowAttiTime.getFullYear(), nowAttiTime.getMonth() + 1, nowAttiTime.getDate(), 1);
			var todayMemorialDayList = memorialDayCheck(nowAttiTime, todayLunar);
			var todayYearMemorialDayList = yearmemorialDayCheck(nowAttiTime, todayLunar);
			var addAttitude = true; // true 등록 가능
			
			//휴일 체크 미사용
			if(useHolidayCheckYN == "0"){
				if (closedDay[nowAttiTime.getDay()] == "1"){ //회사지정 휴일인지 체크
					addAttitude = false;				
				} else if (todayMemorialDayList.length != 0 || todayYearMemorialDayList.length != 0) { //기념일체크
					if (todayMemorialDayList.length != 0 ) {
						for (var i = 0; i < todayMemorialDayList.length; i++) {
							if (todayMemorialDayList[i].holiday ==  true) { //휴무일인 기념일일때
								addAttitude = false;
							}
						}
					} 
					if (todayYearMemorialDayList.length != 0) {
						for (var i = 0; i < todayYearMemorialDayList.length; i++) {
							if (todayYearMemorialDayList[i].holiday == true) { //휴무일인 기념일일때
								addAttitude = false;
							}
						}
					}
				}
			}
			
			if(addAttitude) {
				checkAttitude(obj);
			} else {
				alert("<spring:message code='ezAttitude.t167'/>");
			}
		}
		
		//근태 중복 체크
	 	function checkAttitude(obj) {
			var returnValue = getIsAttitude(obj.getAttribute("type"));
			
			if (returnValue == 0) { //해당근태가 없거나, 퇴근일 경우는 근태등록되게
				addAttitude(obj);
			} else {
				if (obj.getAttribute("type") === "A08" || obj.getAttribute("type") === "A03") { //퇴근,조퇴일때 조퇴,퇴근이 있는 경우 경고창
					alert("<spring:message code='ezAttitude.t169'/>");					
				}
				getAttitudeList();
    			try{
    				var calType = "";
    				var btnOnNodes = parent.frames["right"].document.getElementsByClassName("on");
    				for (var i = 0; i < btnOnNodes.length; i++) {
    					if (btnOnNodes[i].getAttribute("id") != null && btnOnNodes[i].getAttribute("id") == "btnTableList") {
    						calType = btnOnNodes[i].getAttribute("id");
    						break;
    					}
    				}
    				
    				if (calType == "btnTableList") {
    					parent.frames["right"].getAttitudeTableList();
    				} else {
	    				parent.frames["right"].getAttitudeMainList();
    				}
    				
    			}catch(e){}
			}
	 	}
		
		//시간놓고 alert내용을 파라미터로 던져서 체크??
	    function addAttitude(obj) {
	    	var pTypeId = obj.getAttribute("type");
	    	var pDateType = obj.getAttribute("datetype");
	    	if (pTypeId == "A03") {
	    		var returnValue = getIsAttitude("A01"); //오늘 날짜의 출근이 있는지 체크
	    		if (returnValue == 0) { //오늘 날짜의 출근이 없을 경우
	    			var inAtt = getIsAttitude("A26"); //전날 출근이 있는지 확인한다.
	    			if(inAtt != 0) { // 전날 출근이 있는 경우
	    				var outAtt = getIsAttitude("A25"); //전날 퇴근이 있는지 확인한다.
	    				var outAtt2 = getIsAttitude("A27"); //오늘 날짜로 전날 퇴근이 있는지 체크한다.
	    				if(outAtt == 0 && outAtt2 == 0){ //전날 퇴근이 없고 오늘 날짜로 퇴근이 없는 경우
	    					getAttitudeList();
	    					pTypeId = "A25";
	    				}else { //전날 출,퇴근 기록이 있고 아직 출근을 안찍은 경우
	    					alert("<spring:message code='ezAttitude.t168'/>");
	    					return;
	    				}
	    			}else { //전날 출근이 없는 경우
		    			alert("<spring:message code='ezAttitude.t168'/>");
			    		return;
	    			}
	    		} else {
	    			getAttitudeList();
	    			try{
	    				var calType = "";
	    				var btnOnNodes = parent.frames["right"].document.getElementsByClassName("on");
	    				for (var i = 0; i < btnOnNodes.length; i++) {
	    					if (btnOnNodes[i].getAttribute("id") != null && btnOnNodes[i].getAttribute("id") == "btnTableList") {
	    						calType = btnOnNodes[i].getAttribute("id");
	    						break;
	    					}
	    				}
	    				
	    				if (calType == "btnTableList") {
	    					parent.frames["right"].getAttitudeTableList();
	    				} else {
		    				parent.frames["right"].getAttitudeMainList();
	    				}
	    				
	    			}catch(e){}
	    		}
	    	}
	    	
	    	beforeAlertDate = new Date();
	    	var dateAlert = nowAttiTime.getFullYear() + "<spring:message code='ezAttitude.t66'/> " + (nowAttiTime.getMonth() + 1) + "<spring:message code='ezAttitude.t67'/> " + (nowAttiTime.getDate()) + "<spring:message code='ezAttitude.t68'/> " + leadingZeros(nowAttiTime.getHours(), 2) + ":" + leadingZeros(nowAttiTime.getMinutes(), 2) + ":"+ leadingZeros(nowAttiTime.getSeconds(), 2);
 
	    	$.ajax({
	    		type : "POST",
	    		async : true,
	    		url : "/ezAttitude/attitudeSave.do",
	    		data : {
	    			typeId : pTypeId,
	    			dateType : pDateType,
	    			mode : "new"
	    		},
	    		success : function(result) {
	    			if(result == "outAttError"){
	    				alert("<spring:message code='ezAttitude.kje21'/>");
	    			}else {
		    			getAttitudeList();
		    			try{
		    				var calType = "";
		    				var btnOnNodes = parent.frames["right"].document.getElementsByClassName("on");
		    				for (var i = 0; i < btnOnNodes.length; i++) {
		    					if (btnOnNodes[i].getAttribute("id") != null && btnOnNodes[i].getAttribute("id") == "btnTableList") {
		    						calType = btnOnNodes[i].getAttribute("id");
		    						break;
		    					}
		    				}
		    				
		    				if (calType == "btnTableList") {
		    					parent.frames["right"].getAttitudeTableList();
		    				} else {
			    				parent.frames["right"].getAttitudeMainList();
		    				}
		    				
		    			}catch(e){}
	    			}
	    		},
	    		complete : function() {
	    			afterAlertDate = new Date();
		    		overTime = (afterAlertDate.getTime() - beforeAlertDate.getTime());
		    		nowAttiTime.setMilliseconds(nowAttiTime.getMilliseconds() + overTime);
	    		}
	    	})
	    }
	    
	    function getIsAttitude(typeId) {
			var isAttitudeReturn = "";
	    	$.ajax({
	    		type : "POST",
	    		dataType : "text",
	    		async : false,
	    		url : "/ezAttitude/getIsAttitude.do",
	    		data : {
	    			typeId : typeId
	    		},
	    		success : function(result) {
	    			isAttitudeReturn = result;
	    		},
	    		complete : function() {
	    			
	    		}
	    	})
	    	return isAttitudeReturn;
	    }

	    function setAttiBtnHover() {
	    	$("#inAttiBtn, #outAttiBtn").hover(function(){
	    		$(this).addClass("btn_hover");
	    	}, function(){
	    		$(this).removeClass("btn_hover");
	    	})
	    }
	    
	    function functionFlag(flag) {
	    	var funcFlag = flag;
	    	
	    	// 2023-06-23 황인경 - 디자인 개선 > 근태관리 > 좌측메뉴 > 트리구조 근태관리, 수정신청관리 서브메뉴 선택시 클래스 제어
	    	if ($(event.target).prop("tagName") == "SPAN" && flag != 7) {
		    	$(".node_selected").attr("class", "list_text");
		    	$(event.target).attr("class", "list_text node_selected");
	    	}
	    	
	    	switch(funcFlag) {
	    		case 1:
	    			window.open("/ezAttitude/attitudeUserMain.do", "right");
	    			break;
	    		case 2:
	    			window.open("/ezAttitude/attitudeDeptMain.do", "right");
	    			break;
	    		case 3:
	    			window.open("/ezAttitude/attitudeUserAnnual.do", "right");
	    			break;
	    		case 4: // 나의수정신청
	    			window.open("/ezAttitude/attModAppList.do", "right");
	    			break;
	    		case 5:	// 신청관리현황
	    			window.open("/ezAttitude/manageAttModAppList.do", "right");
	    			break;
	    		case 6:	// 연차취소관리
	    			window.open("/ezAttitude/manageAnnCanAppList.do", "right");
	    			break;
	    		case 7:	// 근태정보관리
	    			window.open("/ezAttitude/attitudeManage.do", "right");
	    			// 2023-06-23 황인경 - 디자인 개선 > 근태관리 > 좌측메뉴 > LNB 이미지 수정
	    			$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
	    			$(".on").attr("class", "off");
	    			$("#personalH2").attr("class", "on");
	    			$(".list_text.node_selected").removeClass("node_selected");
	    			break;
	    	}
	    }
	        	
    	function parseDate() {
    		var _strDate = "";
    		nowAttiTime = new Date(serverTime);
    		
    		if (nowAttiTime.toString() == 'Invalid Date') {
    		    var _parts = serverTime.split(' ');
    		
    		    var _dateParts = _parts[0];
    		    nowAttiTime = new Date(_dateParts);
    		
    		    if (_parts.length > 1) {
    		        var _timeParts = _parts[1].split(':');
    		        nowAttiTime.setHours(_timeParts[0]);
    		        nowAttiTime.setMinutes(_timeParts[1]);
    		        if (_timeParts.length > 2) {
    		        	nowAttiTime.setSeconds(_timeParts[2]);
    		        }
    		    }
    		}
    		
    		var clientTime = new Date();
    		timeDiff = nowAttiTime.getTime() - clientTime.getTime();
    	}
    	
    	function attiClock() {
	        var h, m;
	        var s;
	        var time = " ";
	        var nowClientTime = new Date();
	        var nowServerTime = new Date(nowClientTime.getTime() + timeDiff);
	        
	        time = leadingZeros(nowServerTime.getHours(), 2) + ':' + leadingZeros(nowServerTime.getMinutes(), 2) + ':' + leadingZeros(nowServerTime.getSeconds(), 2);
	        document.getElementById("timeFlow").innerHTML = time;
	        gizmo = setTimeout("attiClock()", 500);
	    }
    			
    	//카운트 refresh
    	function leftCount() {
	    	$.ajax({
				type : 'get',
			    url : '/ezAttitude/getTotalAttCount.do',
			    dataType : "text",
			    error: function(xhr, status, error){
			    	alert("<spring:message code='ezAttitude.t175'/>");
			    },
			    success : function(result){
			    	if (result == "0") { 
			    		result = "";
			    	} else {
			    		result = "(" + result + ")";
			    	}
			    	try {
						document.getElementById("attCount").innerHTML = result;
// 						document.getElementsByClassName("attCount")[1].innerHTML = result;
					} catch (e) {	}
			    }
	    	})
	    }
    	function leftAnnualCount() {
	    	$.ajax({
				type : 'get',
			    url : '/ezAttitude/getTotalAnnualCount.do',
			    dataType : "text",
			    error: function(xhr, status, error){
			    	alert("<spring:message code='ezAttitude.t175'/>");
			    },
			    success : function(result){
			    	if (result == "0") { 
			    		result = "";
			    	} else {
			    		result = "(" + result + ")";
			    	}
			    	try {
						document.getElementById("annualCount").innerHTML = result;
					} catch (e) {	}
			    }
	    	})
	    }
    	
    	function leftResize(){
        	$(".attitudeListBox").height(window.innerHeight-105);
        }
        
        $( window ).resize(function() {
        	leftResize();
    	});
    	
        // 2023-06-27 황인경 - 디자인 개선 > 근태관리 > 좌측메뉴 > 트리구조 클래스 제어 , LNB 이미지 수정 
        function openFolder() {
        	var openH2 = $(event.target).parent();
        	
        	if ($(openH2).hasClass("off")) {
        		$("h2.on").attr("class", "off");
	           	$(".lnbUL.on").removeClass("on").addClass("off");
	           	$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
	           	$(openH2).attr("class", "on");
	           	$(openH2).next().attr("class", "lnbUL on");
	           	$(openH2).children().eq(0).attr("class", "sub_iconLNB tree_arrow_down");
        	} else {
				$(openH2).attr("class", "off");
				$(".lnbUL.on").removeClass("on").addClass("off");
				$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
			}
		}
        
		</script>
	</head>
	<body class="newLeft">
		<div id="left" class="lnb">
	    	<!-- <div class="lnb_btn"></div> -->
	        <!-- <div class="lnb_btn_hidden"></div> lnb 숨기기 버튼-->
	    	<div class="left_title" title="<spring:message code='ezAttitude.t1'/>">
	    		<spring:message code='ezAttitude.t1'/>
	        </div>
	        <div class="btn_writeBox_work">
	        	<p class="btn_write02" id="outAttiBtn" type="A03" datetype="2" onclick="checkHoliday(this)"><span class="sub_iconLNB workIcon"></span><span class="workT"><spring:message code='ezAttitude.t65'/></span></p> 
	        	<p class="btn_write01" id="inAttiBtn" type="A01" datetype="2" onclick="checkHoliday(this)"><span class="sub_iconLNB workIcon"></span><span class="workT"><spring:message code='ezAttitude.t64'/></span></p>
	        </div>
	        <div class="attitudeListBox" style="overflow:hidden; padding-right: 0;">
		        <h2 class="on">
		            <span class="sub_iconLNB tree_arrow_down"></span><span class="h2Title" onclick="openFolder()"><spring:message code='ezAttitude.t1'/></span>
		        </h2>
		        <ul class="lnbUL on">
                   	<li><span class="list_text node_selected" id="userAttitude" onclick="functionFlag(1)"><spring:message code='ezAttitude.t143'/></span></li>
                   	<li><span class="list_text" id="deptAttitude" onclick="functionFlag(2)"><spring:message code='ezAttitude.t144'/></span></li>
                   	<li><span class="list_text" id="userAnnual" onclick="functionFlag(3)"><spring:message code='ezAttitude.t265'/></span></li>
		        </ul>
		        <h2 class="off">
		            <span class="sub_iconLNB tree_plus"></span><span class="h2Title" onclick="openFolder()"><spring:message code='ezAttitude.t7'/></span>
		        </h2>
		        <ul class="lnbUL off">
               		<li><span class="list_text" onclick="functionFlag(4)"><spring:message code='ezAttitude.t166'/></span></li>
                   	<c:if test="${attitudeAdminCheck == true}">
                   		<li>
							<span class="list_text" onclick="functionFlag(5)"><spring:message code='ezAttitude.t7'/><c:if test="${totalAtt != 0 }"><span id="attCount" class="attCount">(${totalAtt})</span></c:if></span>
						</li>
                   		<li>
							<span class="list_text" onclick="functionFlag(6)"><spring:message code='ezAttitude.t275'/><c:if test="${totalAnnual != '0' }"><span id="annualCount" class="attCount">(${totalAnnual})</span></c:if></span>
						</li>
                    </c:if>
		        </ul>
		        <c:if test="${attitudeAdminCheck == true}">
			        <h2 class="off" id="personalH2">
                  		<span class="sub_iconLNB tree_plus"></span><span class="list_text" onclick="functionFlag(7)"><spring:message code='ezAttitude.t73'/></span>
					</h2>
				</c:if>
			</div>
	    </div>
	<%-- <div class="left_pims" title="<spring:message code='ezAttitude.t1'/>"><span><spring:message code='ezAttitude.t1'/></span></div>
	<div id="left" style="border-top:1px solid #dedede">
		<div style="display: block;">
			<article class="time">
	            <div id="timeinput" style="margin-bottom:15px; border:0px; font-weight:bold; color: black; letter-spacing:4px; font-size:18px; text-align:center; line-height:25px;">
	            	<div id="timeFlow" style='width:175px; margin:20px 0 20px 23px; font-size:30px; font-family:Arial, Helvetica, sans-serif;'><p></p></div>
	            </div>
				<div id="atti_area" style="text-align:center; width:219px; margin-bottom: 12px">
					<div class="sub_time">
    					<dl class="timeCheckIn">
    						<dt>출근</dt>
    						<dd id="inAttiBtn" class="out" type="A01" datetype="2" onClick="checkHoliday(this)">입력</dd>
    					</dl>
    					<dl class="timeCheckOut">
    						<dt>퇴근</dt>
    						<dd id="outAttiBtn" class="out" type="A03" datetype="2" onclick="checkHoliday(this)">입력</dd>
    					</dl>
    				</div>
					<p id="inAttiClock" style="margin:3px 0px 0px 7px; font-size:15px; text-align: left; margin-left:47px; padding-left:22px;"><spring:message code='ezAttitude.t64'/> : <spring:message code='ezAttitude.t71'/></p>
					<p id="outAttiClock" style="margin:7px 0px 30px 8px;  font-size:15px; text-align: left; margin-left:47px; padding-left:22px;"><spring:message code='ezAttitude.t65'/> : <spring:message code='ezAttitude.t72'/></p>
					<span id="inAttiBtn" type="A01" datetype="2" onclick="checkHoliday(this)"><spring:message code='ezAttitude.t64'/></span>
					<span id="outAttiBtn" type="A03" datetype="2" onclick="checkHoliday(this)" style="margin-left:2px"><spring:message code='ezAttitude.t65'/></span>
				</div>
			</article>
		</div>
<!-- 	<div id="left" style="border-top:1px solid #dedede"> -->
		<h2><span id="userAttitude" onclick="functionFlag(1)" style="width:100%; display:inline-block"><spring:message code='ezAttitude.t143'/></span></h2>
		<ul></ul>
		<h2><span id="deptAttitude" onclick="functionFlag(2)" style="width:100%; display:inline-block"><spring:message code='ezAttitude.t144'/></span></h2>
		<ul></ul>
		<h2>
			<c:if test="${attitudeAdminCheck != true}">
				<span id="" onclick="functionFlag(3)" style="width:100%; display:inline-block">
				<spring:message code = 'ezAttitude.t7' />
			</span>
			</c:if>
			<c:if test="${attitudeAdminCheck == true}">
				<span id="" onclick="functionFlag(4)" style="width:100%; display:inline-block">
				<spring:message code = 'ezAttitude.t7' />
				<c:if test="${totalAtt != 0 }">
					<span class="attCount">(${totalAtt})</span>
				</c:if>
			</span>
			</c:if>
		</h2>
		<ul>
			<c:if test="${attitudeAdminCheck == true}">
				<li>
					<span id="" onclick="functionFlag(4)" style="width:100%;display:inline-block">
						&nbsp;<spring:message code='ezAttitude.t7'/>
						<c:if test="${totalAtt != 0 }">
							<span class="attCount">(${totalAtt})</span>
						</c:if>
					</span>
				</li>
			</c:if>
			<li><span id="" onclick="functionFlag(3)" style="width:100%;display:inline-block">&nbsp;<spring:message code='ezAttitude.t166'/></span></li>
		</ul>
		<c:if test="${attitudeAdminCheck == true}">
			<h3><span id="" onclick="functionFlag(5)" style="width:100%;display:inline-block"><spring:message code='ezAttitude.t73'/></span></h3>
		</c:if>
	</div> --%>
</body>
</html>