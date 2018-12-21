/**
 * 
 */

//포틀릿 순서 업데이트
function updatePortletOrderUser(usedTheme) {
	var portlets = $(".portlet");
	var updateOrder = [];
	var portletsCount = portlets.length;
	
	for (var i = 0; i < portletsCount; i++) {
		var portletId = portlets.eq(i).attr("id");
		
		if (portletId) { // 테마3의 경우 class가 box_shadow인것이 한 포틀릿 안에 있으므로 아이디가 존재 하는 경우에만 하도록.
			portletId = portletId.substring(0, portletId.indexOf("P"));
		}	
		updateOrder.push({"portletOrder" : i + 1, "portletId" : portletId});
	}
	
	var data = {
		themeId : usedTheme,
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
				//alert(messages.strLang2);
			}
		},
		error : function() {
			//alert(messages.strLang2);
		}
	});
}

function parseDate(themeId) {
	
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
    portletTime = leadingZeros(nowAttiTime.getHours(), 2) + ':' + leadingZeros(nowAttiTime.getMinutes(), 2);
    document.getElementById("timeFlow").innerHTML = time;
    
    if (document.getElementById("ptlTimeFlow") != null) {
    	document.getElementById("ptlTimeFlow").innerHTML = portletTime;
    }
    
    if (portletTime == "00:00" || portletTime == "12:00") {
    	ptlAmPmCheck(nowAttiTime.getHours());
    }
    
    gizmo = setTimeout("attiClock()", 1000);
    
}

function eventSetting(portletId, themeId) { //포틀릿 아이디별로 자바스크립트 로드 
	var nowTheme = themeId;
	var url = "";
	
	switch (portletId) {
	case 1 : // 메일
		url = "/js/ezNewPortal/portlets/receivedMailPortlet.js";
		
		$.getScript(url)
		.done(function(script, textStatus) {
			try {
				getMailList();
			} catch(err) {
				console.log(err);
			}
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
		});
		
		break;
	case 2 : // 공지사항
		url = "/js/ezNewPortal/portlets/noticePortlet.js";
		
		$.getScript(url)
		.done(function (script, textStatus) {
			try {
				noticePortletLoadFunc();
			} catch(err) {
				console.log(err);
			}
			
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
		});
		
		break;
	case 4 : // 투표
		url = "/js/ezNewPortal/portlets/votePortlet.js";
		
		$.getScript(url)
		.done(function(script, textStatus) {
			try {
				$("#" + portletId + "Portlet").find("#votePlus").on("click", viewQstList);
				$("#" + portletId + "Portlet").find(".voteBtn").on("click", votePoll);
			} catch(err) {
				console.log(err);
			}
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
		});
		
		break;
	case 5 : // 설문조사
		url = "/js/ezNewPortal/portlets/pollPortlet.js";
		
		$.getScript(url)
		.done(function (script, textStatus) {
			try {
				pollPortletLoadFunc();
			} catch(err) {
				console.log(err);
			}
			
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
		});
		
		break;
	case 6 : // 일정관리
		url = "/js/ezNewPortal/portlets/schedulePortlet.js";
		
		$.getScript(url)
		.done(function (script, textStatus) {
			try {
				openerCalendarMiniView = CalendarMiniView;
				openerCalendarMiniDataSource = CalendarMiniDataSource;
				
				CalendarMiniView("CalendarMini");
				CalendarMiniDataSource();
			    
//				today();
				
				getScheduleList(nowDay, "P");
				
			    if (navigator.userAgent.indexOf('Firefox') != -1) {
			    	document.body.style.MozUserSelect = 'none';
			    	document.body.style.WebkitUserSelect = 'none';
			    	document.body.style.khtmlUserSelect = 'none';
			    	document.body.style.oUserSelect = 'none';
			    	document.body.style.UserSelect = 'none';
			    }
			    
			    if (nowTheme == 3) {
			    	$("#6portlet").css("background","");
			    }
			} catch(err) {
				console.log(err);
			}
			
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
		});
		
		break;
	case 9 : //포토게시판
		url = "/js/ezNewPortal/portlets/photoBoardPortlet.js";
	
		$.getScript(url)
		.done(function(script, textStatus) {
			try {
				$("#" + portletId + "Portlet").find(".nextBtn").on("click", {isNext : true}, photoBoardMovePage);
				$("#" + portletId + "Portlet").find(".preBtn").on("click", {isNext : false}, photoBoardMovePage);
				$("#" + portletId + "Portlet").find("#photoBoardPlus").on("click", viewPhotoBoardList);
			} catch(err) {
				console.log(err);
			}
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
		});
		
		break;
	case 10 : // 즐겨찾기
		url = "/js/ezNewPortal/portlets/favoriteBoardPortlet.js";
		
		$.getScript(url)
		.done(function(script, textStatus) {
			try {
				getTabList();
			} catch(err) {
				console.log(err);
			}
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
		});
		
		break;
	case 11 : // 커뮤니티
		url = "/js/ezNewPortal/portlets/communityPortlet.js";
		
		$.getScript(url)
		.done(function(script, textStatus) {
			try {
				$("#communityPlus").on("click", viewCommuList);
				
				for (var i=1; i < 3; i ++) {
					$('.comListDL0'+i).on("click", view_bestCommunity);
				}
			} catch(err) {
				console.log(err);
			}
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
		});
		
		break;
	case 12 : // 도움말
		url = "/js/ezNewPortal/portlets/helpPortlet.js";
		
		$.getScript(url)
		.done(function (script, textStatus) {
			try {
				helpPortletLoadFunc();
			} catch(err) {
				console.log(err);
			}
			
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
		});
		
		break;	
	case 26 : // 생일자
		url = "/js/ezNewPortal/portlets/birthdayPortlet.js";
		
		$.getScript(url)
		.done(function (script, textStatus) {
			try {
				//생일자 조회 기능 연동
				$("#birthNext").on("click", {isNext : true}, ptlGetMonthlyBirthday);
				$("#birthPrev").on("click", {isNext : false}, ptlGetMonthlyBirthday);
				
				//이번달 생일자 목록 불러오기
				ptlGetMonthlyBirthday();
			} catch(err) {
				console.log(err);
			}
			
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
		});
		
		break;	
	case 34 : // 슬라이드 이미지
		url = "/js/ezNewPortal/portlets/slideImagePortlet.js";
		
		$.getScript(url)
		.done(function (script, textStatus) {
			try {
				$("#roll_featured").orbit(); //슬라이드 포틀릿
				
				imageSizeControl(); //이미지 사이즈 조절
			} catch(err) {
				console.log(err);
			}
			
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
		});
		
		break;	
	case 36 : // 유저정보
		url = "/js/ezNewPortal/portlets/userInfoPortlet.js";
		
		$.getScript(url)
		.done(function (script, textStatus) {
			try {
				//근태관리 연동
				var useAttitude = $("#useAttitude").val();
				
				if (useAttitude === "YES") {
					ptlParseDate();
					ptlAttiClock();
					ptlGetAttitudeList(nowTheme);
					getHolidayList();
					ptlAmPmCheck(ptlNowAttiTime.getHours());
				} else {
					//$(".time_check .main_time").css("display", "none");
					//$(".time_check .presentTime").addClass("presentTime_commuteNone");
					ptlParseDate();
					ptlAttiClock();
					ptlAmPmCheck(ptlNowAttiTime.getHours());
				}
				
				if (nowTheme == 3) {
					$("#36portlet").css("background","");
				}
		 		frameSetting(frameId);
			} catch(err) {
				console.log(err);
			}
			
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
		});
		
		break;
	case 49 : //동영상게시판
		url = "/js/ezNewPortal/portlets/cntPortlet.js";
	
		$.getScript(url)
		.done(function(script, textStatus) {
			try {
				
			} catch(err) {
				console.log(err);
			}
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
		});
		
		break;
	case 47 : //동영상게시판
		url = "/js/ezNewPortal/portlets/movieBoardPortlet.js";
	
		$.getScript(url)
		.done(function(script, textStatus) {
			/*try {
				$("#" + portletId + "Portlet").find(".nextBtn").on("click", {isNext : true}, photoBoardMovePage);
				$("#" + portletId + "Portlet").find(".preBtn").on("click", {isNext : false}, photoBoardMovePage);
				$("#" + portletId + "Portlet").find("#movieBoardPlus").on("click", viewMovieBoardList);
			} catch(err) {
				console.log(err);
				alert(messages.strLang2);
			}*/
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
		});
		
		break;
	}
}

//개인 환경설정으로 이동
function viewPersonalEnv() {
    window.open("/ezPortal/environmentMain.do?topMenuID=F3633607-8E8B-42A1-B777-6E2969072E58", "main", "");
}

//읽지않은 메일, 설문조사, 회람판, 결재할 문서, 오늘일정 개수 ajax가져오기
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
				setCountSetting("poll", result.pollCount);
			}
			
			if (useCircular === "YES") {
				setCountSetting("circular", result.circularCount);
			}
			
			if (useMail === "YES") {
				setCountSetting("unreadMail", result.unreadMailCount);
			}
			
			if (useApproval === "YES") {
				setCountSetting("approval", result.approvalCount);
			}
			
			if (useSchedule === "YES") {
				setCountSetting("schedule", result.scheduleCount);
			}
		}
	});
}

//읽지않은 메일, 설문조사, 회람판, 결재할 문서, 오늘일정 개수 setting
function setCountSetting(countName, count) {
	switch (countName) {
	case "poll" : 
		if (count > 99) {
			count = "99+";
			document.getElementById("pollCount").classList.remove("iconCount_none");
			document.getElementById("pollCount").classList.add("iconCount");
		} else if (count == 0) {
			document.getElementById("pollCount").classList.remove("iconCount");
			document.getElementById("pollCount").classList.add("iconCount_none");
		} else {
			document.getElementById("pollCount").classList.remove("iconCount_none");
			document.getElementById("pollCount").classList.add("iconCount");
		}

		document.getElementById("pollCount").textContent = count;
		
		break;
	case "circular" :
		if (count > 99) {
			count = "99+";
			document.getElementById("circularCount").classList.remove("iconCount_none");
			document.getElementById("circularCount").classList.add("iconCount");
		} else if (count == 0) {
			document.getElementById("circularCount").classList.remove("iconCount");
			document.getElementById("circularCount").classList.add("iconCount_none");
		} else {
			document.getElementById("circularCount").classList.remove("iconCount_none");
			document.getElementById("circularCount").classList.add("iconCount");
		}

		document.getElementById("circularCount").textContent = count;
		
		break;
	case "schedule" :  
		if (count > 99) {
			count = "99+";
			document.getElementById("scheduleCount").classList.remove("iconCount_none");
			document.getElementById("scheduleCount").classList.add("iconCount");
		} else if (count == 0) {
			document.getElementById("scheduleCount").classList.remove("iconCount");
			document.getElementById("scheduleCount").classList.add("iconCount_none");
		} else {
			document.getElementById("scheduleCount").classList.remove("iconCount_none");
			document.getElementById("scheduleCount").classList.add("iconCount");
		}

		document.getElementById("scheduleCount").textContent = count;
		
		break;
	case "approval" :
		if (count > 99) {
			count = "99+";
			document.getElementById("approvalCount").classList.remove("iconCount_none");
			document.getElementById("approvalCount").classList.add("iconCount");
		} else if (count == 0) {
			document.getElementById("approvalCount").classList.remove("iconCount");
			document.getElementById("approvalCount").classList.add("iconCount_none");
		} else {
			document.getElementById("approvalCount").classList.remove("iconCount_none");
			document.getElementById("approvalCount").classList.add("iconCount");
		}

		document.getElementById("approvalCount").textContent = count;
		
		break;
	case "unreadMail" :
		if (count > 99) {
			count = "99+";
			document.getElementById("unreadMailCount").classList.remove("iconCount_none");
			document.getElementById("unreadMailCount").classList.add("iconCount");
		} else if (count == 0) {
			document.getElementById("unreadMailCount").classList.remove("iconCount");
			document.getElementById("unreadMailCount").classList.add("iconCount_none");
		} else {
			document.getElementById("unreadMailCount").classList.remove("iconCount_none");
			document.getElementById("unreadMailCount").classList.add("iconCount");
		}
		
		document.getElementById("unreadMailCount").textContent = count;
		
		break;
	}
}

//생일자 목록 month 세팅
function getMonthlyBirthdayEmployees(isNext) {
	if (isNext  != undefined) {
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

//생일자 불러오기
function getBirthdayEmployeesList() {
	window.clearTimeout(timer);
	
	$.ajax({
		type : "POST",
		url : "/ezNewPortal/getMonthlyBirthdayEmployees.do",
		dataType : "json",
		data : {"birthdayMonth" : birthdayMonth, "birthdayCurPage" : birthdayCurPage, "birthdayCount" : 6},
		success : function(result) {
			birthdayTotalCount = result.birthdayTotalCount;
			
			birthdayCurPage = result.birthdayCurPage;
			
			var birthdayList = result.birthdayList;
			
			var birth = birthdayMonth;
			
			if (birth < 10) {
				birth = "0" + birth;
			}
			
			$("#curMon").text(birth);
			
			if (birthdayList != null && birthdayList != undefined && birthdayList.length > 0) {
				$("#nodata_NewBirth").css("display", "none");
				$("#birthcont").css("display", "");
				
				var strHTML = "";
				var resultCount = birthdayList.length;
				
				for (var i = 0; i < resultCount; i++) {
					var userBirthday = birthdayList[i].userBirthday.substring(5);
					
					strHTML += "<li id='B" + birthdayList[i].userId + "'>";
					strHTML += "<dl class='theme1_birthListDL'>";
					strHTML += "<dt class='theme1_birthPic'>";
					strHTML += "<img src='" + birthdayList[i].userImg + "' width = '32' height='32'>";
					strHTML += "</dt>";
					strHTML += "<dd class='theme1_birthName'>[" + userBirthday + "] " + birthdayList[i].userName + "</dd>";
					strHTML += "<dd class='theme1_birthTeam'>" + birthdayList[i].userDeptName + "</dd>";
					strHTML += "</dl>";
					strHTML += "</li>";
				}
				
				$("#userList").html(strHTML);
				
				for (var i = 0; i< resultCount; i++) {
					var userInfo = birthdayList[i];
					$("#B" + userInfo.userId).on("click", {"userId" : userInfo.userId}, openUserInfo);
				}
			} else {
				$("#nodata_NewBirth").css("display", "block");
				$("#birthcont").css("display", "none");
			}
			// 프로젝트 종료 시 주석 해제
			timer = window.setInterval(function() {
				if (birthdayTotalCount > 6) {
					//birthdayCurPage++;
					getBirthdayEmployeesList();
				}
			}, 5000);
		},
		error : function() {
			//alert(messages.strLang2);
		}
	});
}

//사용자 정보 불러오기(윈도우 팝업)
function openUserInfo(event) {
	var userId = event.data.userId;
	var heigth = window.screen.availHeight;
	var width = window.screen.availWidth;
	var left = (width - 500) / 2;
	var top = (heigth - 400) / 2;
	
	window.open("/ezCommon/showPersonInfo.do?id=" + userId, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
}

//월별 우수사원 정보 호출
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

//포틀릿 및 프레임 환경설정 열기
function viewPortletEnv() {
	
	var feature = GetOpenPosition(760, 645);
	
//	DivPopUpShow($('body').prop('scrollWidth') * 0.9, 435, "/ezNewPortal/portletSetting.do", "",
//		"height = 435px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
	DivPopUpShow(1000, 700, "/ezNewPortal/portletSetting.do", "",
		"height = 435px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);	
}

//근태관리 연동
function getAttitudeList(themeId) {
	var nowTheme = themeId
	
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
 					
 					if (nowTheme == 2) {
 	 					$("#inAttiBtn_txt").attr("onclick", "").unbind("mouseenter");
 						$("#inAttiBtn").parent().addClass("commute_on");
 					}
 					
 					if ($('#36Portlet')) {
 						$("#ptlInAttiBtn").attr("onclick", "").unbind("mouseenter");
 						$("#ptlInAttiBtn").removeClass("out").addClass("in");
 						$("#ptlInAttiBtn dt").css("margin-bottom","5px");
 						$("#ptlInAttiBtn dd").text(result[i].startDate.split(" ")[1].substring(0,5));
 					}
 					
					if (nowTheme == 2) {
 						$("#inAttiBtn").removeClass("main_out").addClass("main_in");
 						$("#inAttiBtn_txt").removeClass("main_out").addClass("main_in");
						$("#inAttiBtn_txt").text(result[i].startDate.split(" ")[1].substring(0,5));
 					} else {
 						$("#inAttiBtn").removeClass("main_out").addClass("main_in");
 						$("#inAttiBtn").text(result[i].startDate.split(" ")[1].substring(0,5));
 					}
					
				} else if (result[i].typeId == "A02") {
					$("#inAttiBtn").attr("onclick", "").unbind("mouseenter");
					
					if (nowTheme == 2) {
 	 					$("#inAttiBtn_txt").attr("onclick", "").unbind("mouseenter");
 						$("#inAttiBtn").parent().addClass("commute_on");
 					}
					
					if ($('#36Portlet')) {
						$("#ptlInAttiBtn").attr("onclick", "").unbind("mouseenter");
						$("#ptlInAttiBtn").removeClass("out").addClass("lateIn");
						$("#ptlInAttiBtn dt").css("margin-bottom","5px");
						$("#ptlInAttiBtn dd").text(result[i].startDate.split(" ")[1].substring(0,5));
 					}
					
					if (nowTheme == 2) {
 						$("#inAttiBtn").removeClass("main_out").addClass("main_lateIn");
 						$("#inAttiBtn_txt").removeClass("main_out").addClass("main_lateIn");
						$("#inAttiBtn_txt").text(result[i].startDate.split(" ")[1].substring(0,5));
 					} else {
 						$("#inAttiBtn").removeClass("main_out").addClass("main_lateIn");
 						$("#inAttiBtn").text(result[i].startDate.split(" ")[1].substring(0,5));
 					}
				} else if (result[i].typeId == "A03") {
					$("#outAttiBtn").attr("onclick", "").unbind("mouseenter");
					
					if (nowTheme == 2) {
						$("#outAttiBtn_txt").attr("onclick", "").unbind("mouseenter");
 						$("#outAttiBtn").parent().addClass("commute_on");
 					}
					
					if ($('#36Portlet')) {
						$("#ptlOutAttiBtn").attr("onclick", "").unbind("mouseenter");
						$("#ptlOutAttiBtn").removeClass("out").addClass("in");
						$("#ptlOutAttiBtn dt").css("margin-bottom","5px");
						$("#ptlOutAttiBtn dd").text(result[i].startDate.split(" ")[1].substring(0,5));
 					}
					
					if (nowTheme == 2) {
						$("#outAttiBtn").removeClass("main_out").addClass("main_in");
						$("#outAttiBtn_txt").removeClass("main_out").addClass("main_in");
						$("#outAttiBtn_txt").text(result[i].startDate.split(" ")[1].substring(0,5));
 					} else {
 						$("#outAttiBtn").removeClass("main_out").addClass("main_in");
 						$("#outAttiBtn").text(result[i].startDate.split(" ")[1].substring(0,5));
 					}
				}
			}
		}
	})
}

//시간놓고 alert내용을 파라미터로 던져서 체크
function addAttitude(obj, themeId) {
	var pTypeId = obj.getAttribute("type");
	var pDateType = obj.getAttribute("datetype");
	if (pTypeId == "A03") {
		var returnValue = getIsAttitude("A01");
		if (returnValue == 0) {
			alert(messages.strLang3);
    		return;
		} else {
			getAttitudeList(themeId);
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
			getAttitudeList(themeId);
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
function checkHoliday(obj, themeId) {
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
		checkAttitude(obj, themeId);
	} else {
		alert(messages.strLang9);
	}
}

//근태 중복 체크
function checkAttitude(obj, themeId) {
	var returnValue = getIsAttitude(obj.getAttribute("type"));
	
	if (returnValue == 0) {
		addAttitude(obj, themeId);
	} else {
		alert(messages.strLang10);
		getAttitudeList(themeId);
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

//메뉴 열기
function quickMenuOpen(menu) {
	var url = "";
	var location = "";
	var option = " ";
	console.log(menu);
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
		case "AprDraft" : 	
			var listType = 2;
			url = "/ezApprovalG/apprGMain.do?listType=" + listType;
			location = "main";
			break;
		case "AprProcessing" : 	
			var listType = 3;
			url = "/ezApprovalG/apprGMain.do?listType=" + listType;
			location = "main";
			break;
		case "AprDeptSusin" : 	
			var listType = 4;
			url = "/ezApprovalG/apprGMain.do?listType=" + listType;
			location = "main";
			break;
		case "Schedule" :
			url = "/ezSchedule/scheduleIndex.do?funCode=2";
			location = "main";
			break;
		case "Poll" :
			url = "/ezQuestion/qstMain.do";
			location = "main";
			break;
	    case "Circular":
			url = "/ezCircular/circularIndex.do";
			location = "main";
	        break; 
	}
	
	window.open(url, location, option);
}

function viewQuick() {
	
	var openPx;
	var closePx;
	var leftSide = false;
	
	if(usedTheme == 3) {
		openPx = '100px';
		closePx = '0px';
	} else {
		openPx = '82px';
		closePx = '3px';
	}
	
	// 프레임에 퀵링크가 좌측에 위치한 경우
	if(usedTheme == '1' && (frameId === 'Frame2' || frameId === 'Frame4')) {
		leftSide = true;
	}

	if (document.getElementById("quickSide").style.width == "0px") {
		$(document.getElementById("quickSide")).animate({width: '100px'});
		if(leftSide) {
			$(".linkBtn_close").animate({left: openPx}, function(){
				$(".linkBtn_close").attr("class", "linkBtn_open");
			});			
		} else {
			$(".linkBtn_close").animate({right: openPx}, function(){
				$(".linkBtn_close").attr("class", "linkBtn_open");
			});			
		}
	} else {
		$(document.getElementById("quickSide")).animate({width: '0px'});
		if(leftSide) {
			$(".linkBtn_open").animate({left: closePx}, function(){
				$(".linkBtn_open").attr("class", "linkBtn_close");
			});					
		} else {
			$(".linkBtn_open").animate({right: closePx}, function(){
				$(".linkBtn_open").attr("class", "linkBtn_close");
			});	
		}
	}
}

// 퀵메뉴
function quickMenuOpenRight(menu) {
	var url = '';
	var location = '';
	var option = '';
	//var menu = event.data.menu;
	
	var pheight = window.screen.availHeight;
	var conHeight = pheight * 0.8;
	var pwidth = window.screen.availWidth;
	var conWidth = pwidth * 0.8;			
			
	if (conWidth > 890) conWidth = 890;
		        
	var pTop = (pheight - conHeight) / 2;
	var pLeft = (pwidth - 890) / 2;			

	switch (menu) {
		case 'mail':    
		    url = '/ezEmail/mailWrite.do?cmd=NEW';
			location = '';
			option = 'top='+pTop+', left='+pLeft+', height='+conHeight+', width='+conWidth+', status=no, toolbar=no, menubar=no, location=no, resizable=1';
			break;
		case 'appr':
			openForm();
			break;
		case 'schedule':		
			url = '/ezSchedule/scheduleWrite.do?defaultid=0';
			location = '';
			pTop = (pheight - 819) / 2;
			pLeft = (pwidth - 890) / 2;	
			option = 'top='+pTop+', left='+pLeft+ ',height='+ '802' +', width='+'890'+', status=no, toolbar=no, menubar=no, location=no, resizable=1';			
			break;
		case 'organ':
			url = '/ezPersonal/personSearch.do';
			pTop = (pheight - 659) / 2;
			pLeft = (pwidth - 715) / 2;	
			option = 'top='+pTop+', left='+pLeft+ ',height=560px,width=750px, status = no, toolbar=no, menubar=no,location=no, resizable=0';			
			break;
	}
	
	if(menu!=='appr') window.open(url, location, option);
}

var formURL = "";
var formDocType = "";
var getformcont_cross_dialogArguments = new Array();
var url = "";

function openForm() {
    var parameter = new Array();
    parameter[0] = "${userInfo.deptID}";
    parameter[1] = "A01000";
    
    url = "/ezApprovalG/getFormCont.do";
    
    if (CrossYN()) {
        getformcont_cross_dialogArguments[0] = parameter;
        getformcont_cross_dialogArguments[1] = openForm_Complete;
        var getFormCont_Cross = window.open(url, "/ezApprovalG/getFormCont.do", GetOpenWindowfeature(713, 570));
        
        try { getFormCont_Cross.focus(); } catch (e) {}
    } else {
        var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no";
        var ret = window.showModalDialog(url, parameter, feature);
        formURL = ret[0];
        formDocType = ret[1];
        
        if (formURL != "cancel") {
            openDraftUI(formURL, formDocType);
        }
    }
}

function openForm_Complete(ret) {
    formURL = ret[0];
    formDocType = ret[1];

    if (formURL != "cancel") {
        openDraftUI();
    }
}

function openDraftUI() {
    var pArgument = new Array();
    var gb = "";
    
    if ("${userApprovalG}" == ("YES"))
        gb = "G";
    
	pArgument[0] = "${userInfo.id}";
    pArgument[1] = formURL;
    pArgument[2] = "DRAFT";
    pArgument[3] = formDocType;
    pArgument[4] = "0"
    pArgument[5] = ""
    pArgument[6] = ""
    pArgument[7] = "";

    var openLocation = "";
    if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
        if (!isIE()) {
            alert(messages.strLang16);
            return;
        } else {
           var openLocation = "/ezApprovalG/draftuiHWP.do";
        }
    } else {
        var openLocation = "/ezApprovalG/draftui.do";
    }
    
    openLocation = openLocation + "?formURL=" + escape(pArgument[1]) + "&draftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
    openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&docState=" + escape(pArgument[5]) + "&listType=1" + "&aprState=" + escape(pArgument[6]);
    openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7]);
    
    openwindow(openLocation, "", 890, 620);
}
