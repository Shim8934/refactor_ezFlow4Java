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
		<link rel="stylesheet" href="/css/ezAttitude/clockTemp1.css" type="text/css" />	
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
		</style>
		
		<script type="text/javascript">
		var userOffset = "${userOffset}";
		var uselang = "${uselang}";
		var closedDay = "";
		var checkClosedToday = false;
		var leaveEarlyFlag = false; // 조퇴가 등록되어있는지 체크
		var serverTime = "${serverTime}";
		var nowAttiTime = "";
		var beforeAlertDate = "";
		var afterAlertDate = "";
		var overTime = "";
		
		window.onload = function(){
			setAttiBtnHover();
			getAttitudeList();
			getHolidayList();
		    //yourClock();
		    select_memorialDays(uselang);
		    
		    document.getElementById('userAttitude').onclick();
		    
		    initToggleList(document.getElementById("left"), "h2", "ul", "li");
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
	    					$("#inAttiClock").text("출근 : " + result[i].startDate.split(" ")[1]);
	    					$("#inAttiBtn").attr("onclick", "").addClass("btn_disabled").unbind("mouseenter");
	    				} else if (result[i].typeId == "A02") {
	    					$("#inAttiClock").text("").append("출근 : <font color='#ff4b00'>" + result[i].startDate.split(" ")[1] + "</font>");
	    					$("#inAttiBtn").attr("onclick", "").addClass("btn_disabled").unbind("mouseenter");
	    				} else if (result[i].typeId == "A03") {
	    					$("#outAttiClock").text("퇴근 : " + result[i].startDate.split(" ")[1]);
	    					$("#outAttiBtn").attr("onclick", "").addClass("btn_disabled").unbind("mouseenter");
	    				}
	    			}
	    		}
	    	})
	    }
	    
		function getHolidayList() {
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
					closedDay = result.attitudeConfigVO.closedDay.split(",");
				}
			});
		}
		
		function checkHoliday(obj) {
			var todayLunar = lunarCalc(nowAttiTime.getFullYear(), nowAttiTime.getMonth() + 1, nowAttiTime.getDate(), 1);
			var todayMemorialDayList = memorialDayCheck(nowAttiTime, todayLunar);
			var todayYearMemorialDayList = yearmemorialDayCheck(nowAttiTime, todayLunar);
			
			if (closedDay[nowAttiTime.getDay()] == "1" || todayMemorialDayList.length != 0 || todayYearMemorialDayList.length != 0) {
	    		alert("<spring:message code='ezAttitude.bbhs34'/>");
			} else {
				var returnValue = getIsAttitude(obj.getAttribute("type"));
				
				if (returnValue == 0) {
					addAttitude(obj);
				} else {
					getAttitudeList();
	    			parent.frames["right"].getAttitudeMainList();
				}
			}
		}
		
		//시간놓고 alert내용을 파라미터로 던져서 체크??
	    function addAttitude(obj) {
	    	var pTypeId = obj.getAttribute("type");
	    	var pDateType = obj.getAttribute("datetype");
	    	if (pTypeId == "A03") {
	    		var returnValue = getIsAttitude("A01");
	    		if (returnValue == 0) {
	    			alert("출근 후 퇴근이 가능합니다.");
		    		return;
	    		} else {
	    			getAttitudeList();
	    			parent.frames["right"].getAttitudeMainList();
	    		}
	    	}
	    	
	    	beforeAlertDate = new Date();
	    	var dateAlert = nowAttiTime.getFullYear() + "년 " + (nowAttiTime.getMonth() + 1) + "월 " + (nowAttiTime.getDate()) + "일 " + leadingZeros(nowAttiTime.getHours(), 2) + ":" + leadingZeros(nowAttiTime.getMinutes(), 2) + ":"+ leadingZeros(nowAttiTime.getSeconds(), 2);
	    	var saveFlag = confirm("현재 시각은 " + dateAlert + "입니다.");
	    	if (!saveFlag) {
	    		afterAlertDate = new Date();
	    		overTime = (afterAlertDate.getTime() - beforeAlertDate.getTime());
	    		nowAttiTime.setMilliseconds(nowAttiTime.getMilliseconds() + overTime);
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
	    		success : function(result) {
	    			getAttitudeList();
	    			parent.frames["right"].getAttitudeMainList();
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
	    		case 5:	// 내꺼
	    			window.open("/ezAttitude/attitudeManage.do", "right");
	    			break;
	    	}
	    }
	    
    	function format(type){
	        nowAttiTime.setSeconds(nowAttiTime.getSeconds() + 1);
	        
	        var s =
	        	leadingZeros(nowAttiTime.getHours(), 2)+
	            leadingZeros(nowAttiTime.getMinutes(), 2)+
	            leadingZeros(nowAttiTime.getSeconds(), 2);
	        return s;
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
    	}
    	
	    $(function(){
	    	parseDate();
	    	
	    	var clock = $('#clock');
	    	
	    	var digit_to_name = 'zero one two three four five six seven eight nine'.split(' ');

	    	// This object will hold the digit elements
	    	var digits = {};

	    	// Positions for the hours, minutes, and seconds
	    	//'h1', 'h2', ':', 'm1', 'm2', ':', 's1', 's2'
	    	var positions = [
				'h1', 'h2', ':', 'm1', 'm2', ':', 's1', 's2'
	    	];

	    	// Generate the digits with the needed markup,
	    	// and add them to the clock

	    	var digit_holder = clock.find('.digits');

	    	$.each(positions, function(){

	    		if(this == ':'){
	    			digit_holder.append('<div class="dots">');
	    		}
	    		else{

	    			var pos = $('<div>');

	    			for(var i=1; i<8; i++){
	    				pos.append('<span class="d' + i + '">');
	    			}

	    			// Set the digits as key:value pairs in the digits object
	    			digits[this] = pos;

	    			// Add the digit elements to the page
	    			digit_holder.append(pos);
	    		}

	    	});

	    	(function update_time(){
	    		var now = format();

	    		digits.h1.attr('class', digit_to_name[now[0]]);
	    		digits.h2.attr('class', digit_to_name[now[1]]);
	    		digits.m1.attr('class', digit_to_name[now[2]]);
	    		digits.m2.attr('class', digit_to_name[now[3]]);
	    		digits.s1.attr('class', digit_to_name[now[4]]);
	    		digits.s2.attr('class', digit_to_name[now[5]]);

	    		// Mark the active day of the week
	    		setTimeout(update_time, 1000);

	    	})();
	    	
	    });
		
    	//카운트 refresh
    	function leftCount() {
	    	$.ajax({
				type : 'get',
			    url : '/ezAttitude/getTotalAttCount.do',
			    dataType : "text",
			    error: function(xhr, status, error){
			    	alert("오류발생");
			    },
			    success : function(result){
			    	if (result == "0") {
			    		result = "";
			    	} else {
			    		result = "("+ result +")";
			    	}
			    	try {
						document.getElementsByClassName("attCount")[0].innerText = result;
						document.getElementsByClassName("attCount")[1].innerText = result;
					} catch (e) {	}
			    }
	    	})
	    }
    	
		</script>
	</head>
<body class="leftbody">
	<div class="left_pims" title="근태관리"><span>근태관리</span></div>
<!-- 	<article class="time"> -->
<%-- 		<p class="title"><spring:message code='main.t00023' /></p> --%>
<!-- 		<div style=" margin-left:52px ;width:110px; height:67px; border:2px solid grey; border-radius:27px; font-weight:bold; color: black; letter-spacing:4px; font-size:18px; font-family:Arial, Helvetica, sans-serif; text-align:center; line-height:25px; background-color:rgb(255,255,255);"> -->
<!-- 			<p id="timeinput" style="margin:21px 0px 0px 2px;"></p> -->
<!-- 		</div> -->
<!-- 			<div id="atti_area" style="font-family:Arial, Helvetica, sans-serif; text-align:center; overflow:hidden;"> -->
<!-- 			<p id="inAttiClock" style="margin:5px 0px 0px 0px; font-size:13px;">출근 : 00:00:00</p> -->
<!-- 			<p id="outAttiClock" style="margin:5px 0px 8px 0px;  font-size:13px;">퇴근 : 00:00:00</p> -->
<!-- 			<span id="inAttiBtn" type="A01" datetype="2" onclick="checkHoliday(this)" style="margin-left:0px;">출근</span> -->
<!-- 			<span id="outAttiBtn" type="A03" datetype="2" onclick="checkHoliday(this)">퇴근</span> -->
<!-- 		</div> -->
<!-- 	</article> -->
	<div id="left" style="border-top:1px solid #dedede">
		<div style="display: block;">
			<article class="time">
				<div id="clock" class="light">
					<div class="display">
						<div class="digits" style="padding:18px 5px 0px 5px; width:186px; border:1px solid #ddd; margin:16px; margin-left:10px; border-radius:15px; height:130px"></div>
					</div>
				</div>
				<div id="atti_area" style="font-family:Arial, Helvetica, sans-serif; text-align:center; width:213px; margin-bottom: 12px">
					<p id="inAttiClock" style="margin:5px 0px 0px 7px; font-size:14px; text-align: left; margin-left:50px; padding-left:22px;">출근 : 출근 전</p>
					<p id="outAttiClock" style="margin:5px 0px 30px 8px;  font-size:14px; text-align: left; margin-left:50px; padding-left:22px">퇴근 : 퇴근 전</p>
					<span id="inAttiBtn" type="A01" datetype="2" onclick="checkHoliday(this)">출근</span>
					<span id="outAttiBtn" type="A03" datetype="2" onclick="checkHoliday(this)" style="margin-left:2px">퇴근</span>
				</div>
			</article>
		</div>
<!-- 	<div id="left" style="border-top:1px solid #dedede"> -->
		<h2><span id="userAttitude" onclick="functionFlag(1)" style="width:100%; display:inline-block"><spring:message code='ezAttitude.bbhs5'/></span></h2>
		<ul></ul>
		<h2><span id="deptAttitude" onclick="functionFlag(2)" style="width:100%; display:inline-block"><spring:message code='ezAttitude.bbhs6'/></span></h2>
		<ul></ul>
		<h2>
			<span id="" onclick="functionFlag(3)" style="width:100%; display:inline-block">
				<spring:message code = 'ezAttitude.t7' />
				<c:if test="${attitudeAdminCheck == true}">
					<c:if test="${totalAtt != 0 }">
						<span class="attCount">(${totalAtt})</span>
					</c:if>
				</c:if>
			</span>
		</h2>
		<ul>
			<li><span id="" onclick="functionFlag(3)" style="width:100%;display:inline-block">&nbsp;<spring:message code='ezAttitude.bbhs32'/></span></li>
			<c:if test="${attitudeAdminCheck == true}">
				<li>
					<span id="" onclick="functionFlag(4)" style="width:100%;display:inline-block">
						&nbsp;<spring:message code='ezAttitude.bbhs33'/>
						<c:if test="${totalAtt != 0 }">
							<span class="attCount">(${totalAtt})</span>
						</c:if>
					</span>
				</li>
			</c:if>
		</ul>
		<c:if test="${attitudeAdminCheck == true}"> 
			<h3><span id="" onclick="functionFlag(5)" style="width:100%;display:inline-block">&nbsp;근태정보관리</span></h3>
		</c:if>
	</div>
</body>
</html>