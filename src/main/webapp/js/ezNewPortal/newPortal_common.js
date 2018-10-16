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
				alert("오류가 발생하였습니다.");
			}
		},
		error : function() {
			alert("오류가 발생하였습니다.");
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
				alert("에러가 발생하였습니다.");
			}
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
			alert("에러가 발생하였습니다.")
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
				alert("에러가 발생하였습니다.");
			}
		})
		.fail(function(jqxhr, settings, exception) {
			console.log(exception);
			alert("에러가 발생하였습니다.")
		});
	} else if (portletId === 10) {
		getTabList();
	} else if (portletId === 12) { // 도움말
		helpPortletLoadFunc();
	} else if (portletId === 2) {  // 공지사항
		noticePortletLoadFunc();
	} else if (portletId === 5) {  // 설문조사
		pollPortletLoadFunc();
	} else if (portletId === 11) {  // 커뮤니티
		$("#communityPlus").on("click", viewCommuList);
	}
}

//개인 환경설정으로 이동
function viewPersonalEnv() {
    window.open("/ezPortal/environmentMain.do?topMenuID=F3633607-8E8B-42A1-B777-6E2969072E58", "main", "");
}

function getUnreadCounts() {
	$.ajax({
		type : "POST",
		url : "/ezNewPortal/unreadCounts.do",
		dataType : "json",
		success : function(result) {
			getCountSetting("poll", result.pollCount);
			getCountSetting("circular", result.circularCount);
			getCountSetting("schedule", result.scheduleCount);
			getCountSetting("approval", result.approvalCount);
			getCountSetting("unreadMail", result.unreadMailCount);
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
			alert("오류가 발생하였습니다.");
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
				strHTML += "<dd>데이터가 없습니다</dd>";
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