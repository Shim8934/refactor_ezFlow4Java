/**
 * 김보미
 */
//근태관리 연동
function ptlGetAttitudeList() {
	$.ajax({
		type : "POST",
		dataType : "json",
		async : false,
		url : "/ezAttitude/getAttitudeList.do",
		success : function(result) {
			for (var i = 0; i < result.length; i++) {
				if (result[i].typeId == "A01") { //출근
 					$("#ptlInAttiBtn").attr("onclick", "").unbind("mouseenter");
					$("#ptlInAttiBtn").removeClass("out").addClass("lateIn");
					$("#ptlInAttiBtn dt").css("margin-bottom","5px");
					$("#ptlInAttiBtn dd").text(result[i].startDate.split(" ")[1].substring(0,5));
				} else if (result[i].typeId == "A02") { //지각
					$("#ptlInAttiBtn").attr("onclick", "").unbind("mouseenter");
					$("#ptlInAttiBtn").removeClass("out").addClass("lateIn");
					$("#ptlInAttiBtn dt").css("margin-bottom","5px");
					$("#ptlInAttiBtn dd").text(result[i].startDate.split(" ")[1].substring(0,5));
				} else if (result[i].typeId == "A03") { //퇴근
					$("#ptlOutAttiBtn").attr("onclick", "").unbind("mouseenter");
					$("#ptlOutAttiBtn").removeClass("out").addClass("lateIn");
					$("#ptlOutAttiBtn dd").text(result[i].startDate.split(" ")[1].substring(0,5));
				}
			}
		}
	})
}

function ptlAttiClock() {
    var ptlH, ptlM;
    var ptlS;
    var ptlTime = " ";
    
    ptlTime = leadingZeros(nowAttiTime.getHours(), 2) + ':' + leadingZeros(nowAttiTime.getMinutes(), 2);
    document.getElementById("ptlTimeFlow").innerHTML = ptlTime;

    if (ptlTime == "00:00" || ptlTime == "12:00") {
    	ptlAmPmCheck(nowAttiTime.getHours())
    }
    
    gizmo = setTimeout("ptlAttiClock()", 1000 * 60);
}

function ptlAmPmCheck(hours) {
	if (Number(hours) >= 12 ) {
    	$(".presentTime .timeTxt span.timePM").css("display","");
    	$(".presentTime .timeTxt span.timeAM").css("display","none");
    } else {
    	$(".presentTime .timeTxt span.timePM").css("display","none");
    	$(".presentTime .timeTxt span.timeAM").css("display","");
    }
}

//휴일 체크
function ptlCheckHoliday(obj) {
	var todayLunar = lunarCalc(nowAttiTime.getFullYear(), nowAttiTime.getMonth() + 1, nowAttiTime.getDate(), 1);
	var todayMemorialDayList = memorialDayCheck(nowAttiTime, todayLunar);
	var todayYearMemorialDayList = yearmemorialDayCheck(nowAttiTime, todayLunar);
	var addAttitude = true; // true 등록 가능
	
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
	
	if(addAttitude) {
		ptlCheckAttitude(obj);
	} else {
		alert(messages.strLang9);
	}
}

//근태 중복 체크
function ptlCheckAttitude(obj) {
	var returnValue = getIsAttitude(obj.getAttribute("type"));
	
	if (returnValue == 0) {
		ptlAddAttitude(obj);
	} else {
		alert(messages.strLang10);
		ptlGetAttitudeList();
		try{}catch(e){}
	}
}

//시간놓고 alert내용을 파라미터로 던져서 체크
function ptlAddAttitude(obj) {
	var pTypeId = obj.getAttribute("type");
	var pDateType = obj.getAttribute("datetype");
	if (pTypeId == "A03") {
		var returnValue = getIsAttitude("A01");
		if (returnValue == 0) {
			alert(messages.strLang3);
    		return;
		} else {
			ptlGetAttitudeList();
		}
	}
	
	beforeAlertDate = new Date();
	var dateAlert = nowAttiTime.getFullYear() + messages.strLang4 + (nowAttiTime.getMonth() + 1) + messages.strLang5 + (nowAttiTime.getDate()) + messages.strLang6 + leadingZeros(nowAttiTime.getHours(), 2) + ":" + leadingZeros(nowAttiTime.getMinutes(), 2) + ":"+ leadingZeros(nowAttiTime.getSeconds(), 2);
	var saveFlag = confirm(messages.strLang7 + dateAlert + messages.strLang8);
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
			ptlGetAttitudeList();
		},
		complete : function() {
			afterAlertDate = new Date();
    		overTime = (afterAlertDate.getTime() - beforeAlertDate.getTime());
    		nowAttiTime.setMilliseconds(nowAttiTime.getMilliseconds() + overTime);
		}
	})
}

function infoSetClick() {
	window.open("/ezPortal/environmentMain.do?topMenuID=F3633607-8E8B-42A1-B777-6E2969072E58", "main", "");
}
function infoLogoutClick () {
	window.open("/user/login/actionLogout.do", "top", "");
}