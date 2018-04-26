<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<title>left_attitude</title>
		<link rel="stylesheet" href="/css/email_tree.css" type="text/css"/>
		<link rel="stylesheet" href="/css/default_kr.css" type="text/css"/>
		<link rel="stylesheet" href="/css/main.css" type="text/css"/>		
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/Holiday.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezAttitude/Calendar.js"></script>
		<style>
			.time {
				font-family: Gulim, Dotum, Arial, Helvetica, sans-serif;
				float:left;
				width:100%;
				margin:0px 0px 5px 0px;
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
				font: 12px gulim;
				padding-top: 7px;
 				border: 1px solid #ddd;
 				color: #666;
				border-radius:3px
			}
			
			.btn_hover{
				cursor: pointer;
				color: rgb(4, 112, 227) !important;
				border-color: rgb(4, 112, 227) !important;
			}
			
			.btn_disabled{
				background-color: rgb(153, 153, 153);
			}
		</style>
	</head>
<body class="leftbody">
	<div class="left_pims" title="근태관리"><span>근태관리</span></div>
	<article class="time">
		<p class="title"><spring:message code='main.t00023' /></p>
		<div style=" margin-left:52px ;width:110px; height:67px; border:2px solid grey; border-radius:27px; font-weight:bold; color: black; letter-spacing:4px; font-size:18px; font-family:Arial, Helvetica, sans-serif; text-align:center; line-height:25px; background-color:rgb(255,255,255);">
			<p id="timeinput" style="margin:21px 0px 0px 2px;"></p>
		</div>
			<div id="atti_area" style="font-family:Arial, Helvetica, sans-serif; text-align:center; overflow:hidden;">
			<p id="inAttiClock" style="margin:5px 0px 0px 0px; font-size:13px;">출근 : 00:00:00</p>
			<p id="outAttiClock" style="margin:5px 0px 8px 0px;  font-size:13px;">퇴근 : 00:00:00</p>
			<span id="inAttiBtn" type="A01" datetype="2" onclick="checkHoliday(this)" style="margin-left:0px;">출근</span>
			<span id="outAttiBtn" type="A03" datetype="2" onclick="checkHoliday(this)">퇴근</span>
		</div>
	</article>
	<div id="left" style="border-top:1px solid #dedede">
		<h2><span id="userAttitude" onclick="functionFlag(1)" style="width:100%; display:inline-block">개인근태현황</span></h2>
		<ul></ul>
		<h2><span id="deptAttitude" onclick="functionFlag(2)" style="width:100%; display:inline-block">부서근태현황</span></h2>
		<ul></ul>
		<h2><span id="" onclick="functionFlag(3)" style="width:100%; display:inline-block">근태수정현황</span></h2>
		<ul>
			<li><span id="" onclick="functionFlag(3)" style="width:100%;display:inline-block">&nbsp;신청현황</span></li>
			<c:if test="${attitudeAdminCheck == true}">
				<li><span id="" onclick="functionFlag(4)" style="width:100%;display:inline-block">&nbsp;신청관리현황</span></li>
			</c:if>
		</ul>
	</div>
	<script type="text/javascript">
		var userOffset = "${userOffset}";
		var uselang = "${uselang}";
		var closedDay = "";
		var checkClosedToday = false;
		
		window.onload = function(){
			setAttiBtnHover();
			getAttitudeList();
		    yourClock();
		    select_memorialDays(uselang);
		    
		    document.getElementById('userAttitude').onclick();
		    
		    initToggleList(document.getElementById("left"), "h2", "ul", "li");
		}
		
		function yourClock() {
	        var nd = new Date();
	        var h, m;
	        var s;
	        var time = " ";		        
	        time = getWorldTime(parseInt(userOffset.split(':')[0]),parseInt(userOffset.split(':')[1]));
	        document.getElementById("timeinput").innerHTML = time;
	        gizmo = setTimeout("yourClock()", 1000);
	    }
		
		function getWorldTime(tzOffsetHour, tzOffsetMinute) { // 24시간제
	        var now = new Date();
	        var tz = now.getTime() + (now.getTimezoneOffset() * 60000) + (tzOffsetHour * 3600000) + (tzOffsetMinute * 60000);
	        now.setTime(tz);
	        var s =
	          leadingZeros(now.getHours(), 2) + ':' +
	          leadingZeros(now.getMinutes(), 2) + ':' +
	          leadingZeros(now.getSeconds(), 2);
	        return s;
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
	    		async : true,
	    		url : "/ezAttitude/getAttitudeList.do",
	    		data : {},
	    		success : function(result) {
	    			for (var i = 0; i < result.length; i++) {
	    				if (result[i].typeId == "A01") {
	    					$("#inAttiClock").text("출근 : " + result[i].startDate.split(" ")[1]);
	    					$("#inAttiBtn").attr("onclick", "").addClass("btn_disabled").unbind("mouseenter");
	    				} else if (result[i].typeId == "A02") {
	    					$("#inAttiClock").text("").append("출근 : <font color='red'>" + result[i].startDate.split(" ")[1] + "</font>");
	    					$("#inAttiBtn").attr("onclick", "").addClass("btn_disabled").unbind("mouseenter");
	    				} else if (result[i].typeId == "A03") {
	    					$("#outAttiClock").text("퇴근 : " + result[i].startDate.split(" ")[1]);
	    					$("#outAttiBtn").attr("onclick", "").addClass("btn_disabled").unbind("mouseenter");
	    				}
	    			}
	    		}
	    	})
	    }
	    
		function checkHoliday(obj) {
			var now = new Date();
			var tz = now.getTime() + (now.getTimezoneOffset() * 60000) + (parseInt(userOffset.split(':')[0]) * 3600000) + (parseInt(userOffset.split(':')[1]) * 60000);
			now.setTime(tz);
			$.ajax({
				type:"POST",
				dataType : "json",
				async : true,
				url : "/ezAttitude/getHolidayList.do",
				data : {},
				success : function(result) {
					for (var i = 0; i < result.holidayList.length; i++) {
						if (result.holidayList[i].isRepeat == 1) { //매년 반복되는 경우
							memorialDays.push(new memorialDay(result.holidayList[i].holidayName, result.holidayList[i].holidayName2, 
															  result.holidayList[i].holidayDate.substring(5,7), result.holidayList[i].holidayDate.substring(8,10),
															  result.holidayList[i].isSolar, result.holidayList[i].isRest == 1 ? true : false));
						} else if (result.holidayList[i].isRepeat == 0) { //해당 년에만 적용이 되는 경우
							yearmemorialDays.push(new yearmemorialDay(result.holidayList[i].holidayName, result.holidayList[i].holidayName2,
																	  result.holidayList[i].holidayDate.substring(0,4), result.holidayList[i].holidayDate.substring(5,7),
																	  result.holidayList[i].holidayDate.substring(8,10), result.holidayList[i].isSolar,
																	  result.holidayList[i].isRest == 1 ? true : false));
						}
					}
					
					var todayLunar = lunarCalc(now.getFullYear(), now.getMonth() + 1, now.getDate(), 1);
					var todayMemorialDayList = memorialDayCheck(now, todayLunar);
					var todayYearMemorialDayList = yearmemorialDayCheck(now, todayLunar);
					
					if (todayMemorialDayList.length != 0 || todayYearMemorialDayList.length != 0) {
						checkClosedToday = true;
					}
					
					closedDay = result.attitudeConfigVO.closedDay.split(",");
					if (closedDay[now.getDay()] == "1" || checkClosedToday) {
			    		alert("휴일은 출/퇴근을 등록할 수 없습니다.");
					} else {
						addAttitude(obj);
					}
				}
			});
		}
		
	    function addAttitude(obj) {
	    	var pTypeId = obj.getAttribute("type");
	    	var pDateType = obj.getAttribute("datetype");
	    	if (pTypeId == "A03" && !$("#inAttiBtn").hasClass("btn_disabled")) {
	    		alert("출근 후 퇴근이 가능합니다.");
	    		return;
	    	}
	    	$.ajax({
	    		type : "POST",
	    		async : true,
	    		url : "/ezAttitude/attitudeSave.do",
	    		data : {
	    			typeId : pTypeId,
	    			dateType : pDateType,
	    			mode : "new"
	    		},
	    		success : function() {
	    			getAttitudeList();
	    			parent.frames["right"].getAttitudeMainList();
	    		}
	    	})
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
	    	
	    	switch(funcFlag) {
	    		case 1:
	    			window.open("/ezAttitude/attitudeUserMain.do", "right");
	    			break;
	    		case 2:
	    			window.open("/ezAttitude/attitudeDeptMain.do", "right");
	    			break;
	    		case 3: // 신청현황
	    			window.open("/ezAttitude/attModAppList.do", "right");
	    			break;
	    		case 4:	// 신청관리현황
	    			window.open("/ezAttitude/manageAttModAppList.do", "right");
	    			break;
	    	}
	    }
	</script>
</body>
</html>