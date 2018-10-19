/**
 * 
 */
function updatePortletOrderUser() {
	var portlets = $(".box_shadow");
	var updateOrder = [];
	var portletsCount = portlets.length;
	
	for (var i = 0; i < portletsCount; i++) {
		var portletId = portlets.eq(i).attr("id");
		portletId = portletId.substring(0, portletId.indexOf("P"));
		
		updateOrder.push({"portletOrder" : i + 1, "portletId" : portletId});
	}
	
	var data = {
		updateOrder : updateOrder
	};
	
	//ajax로 순서 변경
	$.ajax({
		type : "POST",
		url : "/ezNewPortal/updatePortletOrderUser.do",
		contentType : "application/json",
		dataType : "text",
		data : JSON.stringify(data),
		success : function(result) {
			if (result === "failed") {
				alert(messages.strLang2);
			}
		},
		error : function() {
			alert(messages.strLang2);
		}
	});
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
	
	//$("#todayTime").html(nowAttiTime.getFullYear() + "."  + leadingZeros((nowAttiTime.getMonth() + 1), 2) + "." + leadingZeros(nowAttiTime.getDate(), 2));
	
}

function attiClock() {
    var h, m;
    var s;
    var time = " ";
    
    nowAttiTime.setSeconds(nowAttiTime.getSeconds() + 1);
    time = leadingZeros(nowAttiTime.getHours(), 2) + ':' + leadingZeros(nowAttiTime.getMinutes(), 2) + ':' + leadingZeros(nowAttiTime.getSeconds(), 2);
    document.getElementById("timeFlow").innerHTML = time;
    if (time == "00:00:00") {
    	//$("#todayTime").html(nowAttiTime.getFullYear() + "<spring:message code='ezAttitude.t66'/> " + leadingZeros((nowAttiTime.getMonth() + 1), 2) + "<spring:message code='ezAttitude.t67'/> " + leadingZeros(nowAttiTime.getDate(), 2) + "<spring:message code='ezAttitude.t68'/>");
    }
    gizmo = setTimeout("attiClock()", 1000);
    
}

function eventSetting(portletId) {
	if (portletId == 4) { //투표
		var url = "/js/ezNewPortal/portlets/votePortlet.js";
		
		$.getScript(url)
		.done(function(script, textStatus) {
			try {
				$("#" + portletId + "Portlet").find("#votePlus").on("click", viewQstList);
				$("#" + portletId + "Portlet").find(".voteBtn").on("click", votePoll);
			} catch(err) {
				console.log(err);
				alert(messages.strLang2);
			}
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
			alert(messages.strLang2);
		});
	} else if (portletId == 9) { //포토게시판
		var url = "/js/ezNewPortal/portlets/photoBoardPortlet.js";
	
		$.getScript(url)
		.done(function(script, textStatus) {
			try {
				$("#" + portletId + "Portlet").find(".nextBtn").on("click", {isNext : true}, photoBoardMovePage);
				$("#" + portletId + "Portlet").find(".preBtn").on("click", {isNext : false}, photoBoardMovePage);
				$("#" + portletId + "Portlet").find("#photoBoardPlus").on("click", viewPhotoBoardList);
			} catch(err) {
				console.log(err);
				alert(messages.strLang2);
			}
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
			alert(messages.strLang2);
		});
	} else if (portletId === 10) {// 즐겨찾기
		var url = "/js/ezNewPortal/portlets/favoriteBoardPortlet.js";
		
		$.getScript(url)
		.done(function(script, textStatus) {
			try {
				getTabList();
			} catch(err) {
				console.log(err);
				alert(messages.strLang2);
			}
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
			alert(messages.strLang2);
		});
	} else if (portletId === 12) { // 도움말
		helpPortletLoadFunc();
	} else if (portletId === 2) {  // 공지사항
		noticePortletLoadFunc();
	} else if (portletId === 5) {  // 설문조사
		pollPortletLoadFunc();
	} else if (portletId === 11) {  // 커뮤니티
		var url = "/js/ezNewPortal/portlets/communityPortlet.js";
		
		$.getScript(url)
		.done(function(script, textStatus) {
			try {
				$("#communityPlus").on("click", viewCommuList);
				
				for (var i=1; i < CommuSize; i ++) {
					clubNo = $('.comListDL0'+i).attr('data1');
					$('.comListDL0'+i).on("click",{ iClubNo : clubNo }, view_bestCommunity);
				}
			} catch(err) {
				console.log(err);
				alert(messages.strLang2);
			}
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
			alert(messages.strLang2);
		});
	} else if (portletId === 1) { // 메일
		var url = "/js/ezNewPortal/portlets/receivedMailPortlet.js";
		
		$.getScript(url)
		.done(function(script, textStatus) {
			try {
				$("#mGraphSpan").css("width", mailPercent + "px");
			} catch(err) {
				console.log(err);
				alert(messages.strLang2);
			}
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
			alert(messages.strLang2);
		});
	}
}

//개인 환경설정으로 이동
function viewPersonalEnv() {
    window.open("/ezPortal/environmentMain.do?topMenuID=F3633607-8E8B-42A1-B777-6E2969072E58", "main", "");
}

function getUnreadCounts(useQuestion, useCircular, useMail, useApproval, useSchedule) {
	var data = {
		"useQuestion" : useQuestion,
		"useCircular" : useCircular,
		"useMail"  : useMail,
		"useApproval" : useApproval,
		"useSchedule" : useSchedule
	};
	
	$.ajax({
		type : "POST",
		url : "/ezNewPortal/unreadCounts.do",
		data : JSON.stringify(data),
		contentType : "application/json",
		dataType : "json",
		success : function(result) {
			if (useQuestion === "YES") {
				getCountSetting("poll", result.pollCount);
			}
			
			if (useCircular === "YES") {
				getCountSetting("circular", result.circularCount);
			}
			
			if (useMail === "YES") {
				getCountSetting("unreadMail", result.unreadMailCount);
			}
			
			if (useApproval === "YES") {
				getCountSetting("approval", result.approvalCount);
			}
			
			if (useSchedule === "YES") {
				getCountSetting("schedule", result.scheduleCount);
			}
		}
	});
}

function getCountSetting(countName, count) {
	if (countName == "poll") {
		if (count > 99) {
			count = "99+";
			$("#pollCount").attr("class", "iconCount");
		} else if (count == 0) {
			$("#pollCount").attr("class", "iconCount_none");
		} else {
			$("#pollCount").attr("class", "iconCount");
		}
		
		$("#pollCount").text(count);
	} else if (countName == "circular") {
		if (count > 99) {
			count = "99+";
			$("#circularCount").attr("class", "iconCount");
		} else if (count == 0) {
			$("#circularCount").attr("class", "iconCount_none");
		} else {
			$("#circularCount").attr("class", "iconCount");
		}
		
		$("#circularCount").text(count);
	} else if (countName == "schedule") {
		if (count > 99) {
			count = "99+";
			$("#scheduleCount").attr("class", "iconCount");
		} else if (count == 0) {
			$("#scheduleCount").attr("class", "iconCount_none");
		} else {
			$("#scheduleCount").attr("class", "iconCount");
		}
		
		$("#scheduleCount").text(count);
	} else if (countName == "approval") {
		if (count > 99) {
			count = "99+";
			$("#approvalCount").attr("class", "iconCount");
		} else if (count == 0) {
			$("#approvalCount").attr("class", "iconCount_none");
		} else {
			$("#approvalCount").attr("class", "iconCount");
		}
		
		$("#approvalCount").text(count);
	} else if (countName == "unreadMail") {
		if (count > 99) {
			count = "99+";
			$("#unreadMailCount").attr("class", "iconCount");
		} else if (count == 0) {
			$("#unreadMailCount").attr("class", "iconCount_none");
		} else {
			$("#unreadMailCount").attr("class", "iconCount");
		}
		
		$("#unreadMailCount").text(count);
	}
}

//생일자 불러오기
function getMonthlyBirthdayEmployees(event) {
	if (event  != undefined) {
		var isNext = event.data.isNext;
		
		if (isNext) {
			if (birthdayMonth === 12) {
				birthdayMonth = 1;
			} else {
				birthdayMonth += 1;
			}
		} else {
			if (birthdayMonth === 1) {
				birthdayMonth = 12;
			} else {
				birthdayMonth -= 1;
			}
		}
	}
	
	birthdayCurPage = 0;
	getBirthdayEmployeesList();
}

function getBirthdayEmployeesList() {
	window.clearTimeout(timer);
	
	$.ajax({
		type : "POST",
		url : "/ezNewPortal/getMonthlyBirthdayEmployees.do",
		dataType : "json",
		data : {"birthdayMonth" : birthdayMonth, "birthdayCurPage" : birthdayCurPage, "birthdayCount" : 6},
		success : function(result) {
			birthdayTotalCount = result.birthdayTotalCount;
			
			if (birthdayCurPage != 0) {
				birthdayCurPage = result.birthdayCurPage;
			}
			
			var birthdayList = result.birthdayList;
			
			var birth = birthdayMonth;
			
			if (birth < 10) {
				birth = "0" + birth;
			}
			
			$("#curMon").text(birth);
			
			if (birthdayList.length > 0 && birthdayList != null) {
				$("#nodata_NewBirth").css("display", "none");
				$("#birthcont").css("display", "");
				
				var strHTML = "";
				var resultCount = birthdayList.length;
				
				for (var i = 0; i < resultCount; i++) {
					var userBirthday = birthdayList[i].userBirthday.substring(5);
					
					strHTML += "<li id='B" + birthdayList[i].userId + "'>";
					strHTML += "<dl class='birthListDL'>";
					strHTML += "<dt class='birthPic'>";
					strHTML += "<img src='" + birthdayList[i].userImg + "' width = '32' height='32'>";
					strHTML += "</dt>";
					strHTML += "<dd class='birthName'>[" + userBirthday + "] " + birthdayList[i].userName + "</dd>";
					strHTML += "<dd class='birthTeam'>" + birthdayList[i].userDeptName + "</dd>";
					strHTML += "</dl>";
					strHTML += "</li>";
				}
				
				$("#userList").html(strHTML);
				
				for (var i = 0; i< resultCount; i++) {
					var userInfo = birthdayList[i];
					$("#B" + userInfo.userId).on("click", {"userId" : userInfo.userId}, openUserInfo);
				}
			} else {
				$("#nodata_NewBirth").css("display", "");
				$("#birthcont").css("display", "none");
			}
			
			timer = window.setInterval(function() {
				if (birthdayTotalCount > 6) {
					birthdayCurPage++;
					getBirthdayEmployeesList();
				}
			}, 5000);
		},
		error : function() {
			alert(messages.strLang2);
		}
	});
}

function openUserInfo(event) {
	var userId = event.data.userId;
	var heigth = window.screen.availHeight;
	var width = window.screen.availWidth;
	var left = (width - 500) / 2;
	var top = (heigth - 400) / 2;
	
	window.open("/ezCommon/showPersonInfo.do?id=" + userId, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
}

function getMonthlyBestEmployee() {
	$.ajax({
		type : "POST",
		url : "/ezNewPortal/getMonthlyBestEmployee.do",
		dataType : "json",
		success : function(result) {
			var bestEmployee = result.bestEmployee;
			var strHTML = "";
			
			if (bestEmployee == null) {
				$("#emPic").find("img").attr("src", "/images/ezNewPortal/bestEmployee_pic_none.png");
				strHTML += "<dl class='nodata' style='margin-top:8px'>";
				strHTML += "<dd>" + messages.strLang1 + "</dd>";
				strHTML += "</dl>";
			} else {
				$("#emPic").find("img").attr("src", bestEmployee.userImg);
				strHTML += "<dd class='emName'>\"" + bestEmployee.userName + " " + bestEmployee.title + "\"</dd>";
				strHTML += "<dd class='emTeam'>" + bestEmployee.userDeptName + "</dd>";
			}
			
			$(".emDL").append(strHTML);
		}
	});
}

function viewPortletEnv() {

	var feature = GetOpenPosition(760, 645);
	
	DivPopUpShow($('body').prop('scrollWidth') * 0.9, 435, "/ezNewPortal/portletSetting.do", "",
		"height = 435px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
}

//근태관리 연동
function getAttitudeList() {
	$.ajax({
		type : "POST",
		dataType : "json",
		async : false,
		url : "/ezAttitude/getAttitudeList.do",
		data : {},
		success : function(result) {
			for (var i = 0; i < result.length; i++) {
				if (result[i].typeId == "A01") {
 					$("#inAttiBtn").attr("onclick", "").unbind("mouseenter");
					$("#inAttiBtn").removeClass("out").addClass("in");
					$("#inAttiBtn").text(result[i].startDate.split(" ")[1].substring(0,5));
				} else if (result[i].typeId == "A02") {
					$("#inAttiBtn").attr("onclick", "").unbind("mouseenter");
					$("#inAttiBtn").removeClass("out").addClass("lateIn");
					$("#inAttiBtn").text(result[i].startDate.split(" ")[1].substring(0,5));
				} else if (result[i].typeId == "A03") {
					$("#outAttiBtn").attr("onclick", "").unbind("mouseenter");
					$("#outAttiBtn").removeClass("out").addClass("in");
					$("#outAttiBtn").text(result[i].startDate.split(" ")[1].substring(0,5));
				}
			}
		}
	})
}

//시간놓고 alert내용을 파라미터로 던져서 체크??
function addAttitude(obj) {
	var pTypeId = obj.getAttribute("type");
	var pDateType = obj.getAttribute("datetype");
	if (pTypeId == "A03") {
		var returnValue = getIsAttitude("A01");
		if (returnValue == 0) {
			alert(messages.strLang3);
    		return;
		} else {
			getAttitudeList();
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
			getAttitudeList();
		},
		complete : function() {
			afterAlertDate = new Date();
    		overTime = (afterAlertDate.getTime() - beforeAlertDate.getTime());
    		nowAttiTime.setMilliseconds(nowAttiTime.getMilliseconds() + overTime);
		}
	})
}

function getHolidayList() {
	$.ajax({
		type:"POST",
		dataType : "json",
		async : true,
		url : "/ezAttitude/getHolidayList.do",
		data : {
			//isRest : "rest"
		},
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

//휴일 체크
function checkHoliday(obj) {
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
		checkAttitude(obj);
	} else {
		alert(messages.strLang9);
	}
}

//근태 중복 체크
	function checkAttitude(obj) {
	var returnValue = getIsAttitude(obj.getAttribute("type"));
	
	if (returnValue == 0) {
		addAttitude(obj);
	} else {
		alert(messages.strLang10);
		getAttitudeList();
		try{parent.frames["right"].getAttitudeMainList();}catch(e){}
	}
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

function quickMenuOpen(event) {
	var url = "";
	var location = "";
	var option = " ";
	var menu = event.data.menu;
	
	switch (menu) {
		case "NewMail" : 
			url = "/ezEmail/mailMain.do";
			location = "main";
			break;						
		case "ApprG" : 	
			// 문서Type 선택 1=결재할문서 2=기안할문서  3=결재진행문서  4=수신문서처리(접수기)
			var listType = 1;
			url = "/ezApprovalG/apprGMain.do?listType=" + listType;
			location = "main";
			break;
		case "Schedule" :
			url = "/ezSchedule/scheduleIndex.do?funCode=2";
			location = "main";
			break;
		case "Poll" :
			url = "/ezBoard/boardMain.do?func=1";
			location = "main";
			break;
	    case "Circular":
			url = "/ezCircular/circularIndex.do";
			location = "main";
	        break; 
	}
	
	window.open(url, location, option);
}