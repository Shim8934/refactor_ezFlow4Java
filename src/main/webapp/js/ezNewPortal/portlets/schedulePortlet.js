/**
 * 김보미
 */
var pMode = "P";
var openerCalendarMiniView, openerCalendarMiniDataSource;

//var newDate;
//var nDate;
//var str4;
//var nDay;
var usedTheme = Number($("#schedule_usedTheme").val());
var newDate = new Date();

function getScheduleList(date, mode) {
	selDate = date;			    
	
	$.ajax({
		type : "POST",
		dataType : "json",
		async : true,
		url : "/ezNewPortal/getScheduleList.do",
		data : {
			selectDate  : date		    			
		},
		success: function(json){
			getScheduleList_after(json.resultList, mode, date);
		}
	});
}

function getScheduleList_after(resultList, mode, date) {
	try {
		//2018-07-04 포탈에서 read.do 호출시 출처를 알기위한 변수추가
		var pageFrom = 'Portal';
		
		var sDate = date.split("-");
		newDate.setFullYear(sDate[0], sDate[1]-1, sDate[2]);
		
		var str4 = messages.strLang15.split(";");
		var dayOfWeekMsg = messages.strLangSchedule01.split(";");
        var nDay = newDate.getDay();
		
		var listHTML = "";
		listHTML += "<div><ul class='sscheduleUL'>";
		
		for (var i = 0; i < 3; i++) {
			if (resultList[i] != null && resultList[i] != "") {
				var SCHEDULETYPE = resultList[i].scheduleType;
				var SCHEDULEID = resultList[i].scheduleId;
				var PARENTID = resultList[i].parentId;	
				var DATETYPE = resultList[i].dateType;
				var REPEATCOUNT = resultList[i].repeatCount;
				var STARTDATE = resultList[i].startDate;
				var ENDDATE = resultList[i].endDate;
				var TITLE = resultList[i].title;
				var CREATORNAME = resultList[i].creatorName;
				var CONTENTPATH = resultList[i].contentPath;
				var startTime = STARTDATE.split(' ')[1].substring(0,5);
				var endTime = ENDDATE.split(' ')[1].substring(0,5);
				var selDateType = new Date(selDate.substring(0, 4), selDate.substring(5, 7), selDate.substring(8, 10));	
				var groupColor = resultList[i].groupColor;
				var classNameForTheme = "";
				var strLangArrForTheme = new Array();
				
				/* 2023-06-22 황인경 - 디자인 개선 > 일정관리 포틀릿 > '그룹' 분기 추가 */
				/* 2023-05-31 홍승비 - 일정관리 포틀릿 디자인 개선을 위한 클래스 및 메세지 분기 추가 */
				if (SCHEDULETYPE == 1 || SCHEDULETYPE == 9) {
					classNameForTheme = "individual";
				} else if (SCHEDULETYPE == 2) {
					classNameForTheme = "dept";
				} else if (SCHEDULETYPE == 3) {
					classNameForTheme = "company";
				} else if (SCHEDULETYPE == 7) {
					classNameForTheme = "group";
				} else if (SCHEDULETYPE == 10) {
					classNameForTheme = "executive";
				}
				
				strLangArrForTheme[0] = strLang125_2; // 개인
				strLangArrForTheme[1] = strLang126_2; // 부서
				strLangArrForTheme[2] = strLang127_2; // 회사
				strLangArrForTheme[3] = strLang130_2; // 그룹
				strLangArrForTheme[4] = strLang131_2; // 협업
				strLangArrForTheme[5] = strLang141_2; // 구글
				strLangArrForTheme[6] = strLang151_2; // 임원
				
				// 2020-02-25 김정언 - 근태 현황일 경우에는 근태 상세보기로 이동 (DateType 4 : 근태 현황)
				if (DATETYPE == "4") {
					listHTML += "<li class='scheduleLi " + classNameForTheme + "' onClick=\"open_schedule('" + SCHEDULEID + "','" + PARENTID + "','" + SCHEDULETYPE + "','" + DATETYPE + "','" + REPEATCOUNT + "','" + STARTDATE + "','" + pageFrom + "')\">";
					listHTML += "<p class='scheduleType'>";
				} else if (SCHEDULETYPE == 4) {
					// 2024-09-04 조수빈 - 협업은 onclick 연결되는 부분 다르게 연결해야해서 제거함
					listHTML += "<li class='scheduleLi Tcollaborate'>";
					listHTML += "<p class='scheduleType'>";
				} else if (SCHEDULETYPE == "9") {
					listHTML += "<li class='scheduleLi " + classNameForTheme + "' onClick=\"open_google_schedule('" + SCHEDULEID + "','" + PARENTID + "','" + SCHEDULETYPE + "','" + DATETYPE + "','" + REPEATCOUNT + "','" + STARTDATE + "','" + ENDDATE + "')\">";
					listHTML += "<p class='scheduleType'>";
				} else {
					listHTML += "<li class='scheduleLi " + classNameForTheme + "' onClick=\"open_schedule('" + SCHEDULEID + "','" + PARENTID + "','" + SCHEDULETYPE + "','" + DATETYPE + "','" + REPEATCOUNT + "','" + STARTDATE + "','" + pageFrom + "')\">";
					listHTML += "<p class='scheduleType'>";
				}
	        	
				var timeClass = "";
				if (SCHEDULETYPE == 1) {
					timeClass = "Tindividual";
					listHTML += "<span class='Tindividual'>" + strLangArrForTheme[0] + "</span>";
				} else if (SCHEDULETYPE == 2) {
					timeClass = "Tdept";
					listHTML += "<span class='Tdept'>" + strLangArrForTheme[1] + "</span>";
				} else if (SCHEDULETYPE == 3) {
					timeClass = "Tcompany";
					listHTML += "<span class='Tcompany'>" + strLangArrForTheme[2] + "</span>";
				} else if (SCHEDULETYPE == 7) {
					timeClass = "Tgroup";
					// 2023-09-06 조소정 - 일정 포틀릿 그룹일정 그룹색상 표출
		            if(groupColor == null || groupColor == "") {
		            	var groupColor = "#e9de13";
						// listHTML += "<span class='Tgroup' style='color: " + groupColor + ";'>" + strLangArrForTheme[3] + "</span>";
						listHTML += "<span class='Tgroup'>" + strLangArrForTheme[3] + "</span>";
		            }
		            else {
						// listHTML += "<span class='Tgroup' style='color: " + groupColor + ";'>" + strLangArrForTheme[3] + "</span>";
						listHTML += "<span class='Tgroup'>" + strLangArrForTheme[3] + "</span>";		            }
				} else if (SCHEDULETYPE == 4) {
					timeClass = "Tcollaborate";
					listHTML += "<span class='Tcollaborate'>" + strLangArrForTheme[4] + "</span>";
				} else if (SCHEDULETYPE == 9) {
					timeClass = "Tindividual";
					listHTML += "<span class='Tindividual'>" + strLangArrForTheme[5] + "</span>";
				} else if (SCHEDULETYPE == 10) {
					timeClass = "Texecutive";
					listHTML += "<span class='Texecutive'>" + strLangArrForTheme[6] + "</span>";
				} else {
					listHTML += "";
				}
				
				listHTML += "</p>";
				listHTML += "<p class='scheduleTime'>";
				
				// 2020-02-25 김정언
				if (DATETYPE == "4") {
					listHTML += "<span class='scheduleText'>";
					listHTML += "<img class='attiImg' src='/images/ezAttitude/" + CONTENTPATH + ".png' style='margin-left: 8px; vertical-align: sub;'/>"
					listHTML += TITLE + " : " + CREATORNAME
					listHTML += "</span></p></li>"
					//listHTML += "<span class='" + timeClass + "_timeText' style='vertical-align: bottom;'>" + TITLE + " : " + CREATORNAME + "</span></p></li>";
				} else {
					listHTML += "<span class='scheduleText'>";
					listHTML += ConvertCharToEntityReference(TITLE)+"</span>";					
					listHTML += "<span class='" + timeClass + "_timeText'>" + startTime + " ~ " + endTime + "</span></p></li>";
				}
			} else {
				listHTML += "<li class='scheduleLi_nodata'>";
				listHTML += "<p class='sNodataText'>" + strLang277 + "</p>";	
				listHTML += "<p class='sNodataPlus' onclick='scheduleWrite()'><img src='/images/kr/main/schedule_plus.png'></p></li>";
			}
		}
		listHTML += "</ul'></div>";
		
		/* 2023-06-08 홍승비 - 테마3 > 일정 포틀릿 우측 영역 일 및 요일표기 분기처리 */
		/*
		if (usedTheme == 3) {
			$("#theme3PortletCalTextDT").html("<span>" + sDate[2] + strLangHSBScPt3 + "</span> " + str4[nDay]);
		}
		else {
			listHTML += "<dl id='scheduleDate' class='scheduleDate'>";
			listHTML += "<dd class='dayN'>" + sDate[2] + "</dd>"; // 일
			listHTML += "<dt class='dayT'>" + str4[nDay] + "</dt>"; // 요일
			listHTML += "</dl>";
		}
		*/
		$("#scheduleDateTextDT").html(sDate[1] + strLangHSBScPt2 + " " + sDate[2] + strLangHSBScPt3 + " (" + dayOfWeekMsg[nDay] + ")");
		
		document.getElementById("scheduleList").innerHTML = listHTML;
		
		var selectedDate = new Date(date);
		
		$("#scheduleSdatepicker").datepicker('setDate', selectedDate);
		
	} catch (e) { alert(e) }
}

function scheduleWrite() {
	var wWeight = "790";
    var wHeight = "830";

    var heigth = window.screen.availHeight;
    var width = window.screen.availWidth;

    var left = (width - wWeight) / 2;
    var top = (heigth - wHeight) / 2;
    
    window.open("/ezSchedule/scheduleWrite.do?defaultid=0&sdate=" + encodeURIComponent(selDate + " 00:00:00") + "&edate=" + encodeURIComponent(selDate + " 23:59:00"), "",
    "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
}

function open_schedule(scheduleid, parentid, scheduletype, datetype, repeatcount, date, pageFrom) {
    date = date.substr(0, 10);

    var wWeight = "760";
    var wHeight = "670";
    var heigth = window.screen.availHeight;
    var width = window.screen.availWidth;
    var left = (width - wWeight) / 2;
    var top = (heigth - wHeight) / 2;
    
    // 2020-02-25 김정언 - 근태 상세보기
    if(datetype == "4") {
    	if (CrossYN()) {
			var OpenWin = window.open("/ezAttitude/attitudeItemView.do?attitudeId=" + scheduleid + "&typeId=" + parentid, "", GetOpenWindowfeature(672, 640));
			
			try { OpenWin.focus(); } catch (e) { }
		} else {
			window.showModalDialog("/ezAttitude/attitudeItemView.do?attitudeId=" + scheduleid + "&typeId=" + parentid, "", 
			    "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(672, 640));
		}
    }
    else if (scheduleid.indexOf("collaboration") > -1) {// 협업 일정
		scheduleReadUrl = getRedirectScheduleDetailUrl(encodeURIComponent(scheduleid.replace("collaboration:", "")), date, repeatcount, 10);
		window.open(scheduleReadUrl, "", "height = 670px, width = 790px, top=" + top.toString() + ", left=" + left.toString() + ",  status = no, toolbar=no, menubar=no,location=no, resizable=no");
	}
    else {    	
    	//PNO-3
    	if (CrossYN())
    		window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&type=" + scheduletype + "&datetype=" + datetype + "&repeatcount=" + repeatcount + "&date=" + date + "&pattern=0","",
    				"top = " + top + ", left = " + left + ",height = " + wHeight + "px, width = " + wWeight + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1 scrollbars=0");
    	else
    		window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&type=" + scheduletype + "&datetype=" + datetype + "&repeatcount=" + repeatcount + "&date=" + date + "&pattern=0","",
    				"top = " + top + ", left = " + left + ",height = " + wHeight + "px, width = " + wWeight + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1 scrollbars=0");
    	//PNO-3 END
    }
}

function open_google_schedule(scheduleid, parentid, scheduletype, datetype, repeatcount, startdate, enddate) {
    var wWeight = "760";
    var wHeight = "650";
    var heigth = window.screen.availHeight;
    var width = window.screen.availWidth;
    var left = (width - wWeight) / 2;
    var top = (heigth - wHeight) / 2;
    
    window.open("/ezSchedule/googleScheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&repeatcount=" + repeatcount + "&startdate=" + startdate + "&enddate=" + enddate + "&datetype=" + datetype, "",
    		"top = " + top + ", left = " + left + ",height = " + wHeight + "px, width = " + wWeight + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1 scrollbars=0");
    
}
function goSchedule() {
	window.open("/ezSchedule/scheduleIndex.do?funCode=2", "main", "");
}

function getRedirectScheduleDetailUrl(id, date, repeatCount, callTypeId, bMobile) {
    if (typeof (id) == "undefined" || typeof (date) == "undefined")
        return;
    var url = getWorkspaceUrl() + getWorkspaceAppPath() + ((typeof (bMobile) == "undefined" || bMobile == false) ? "/Account/SSO" : "/Account/MobileSSO");
    var returnUrl = "?returnUrl=" + getWorkspaceAppPath() + "/Scheduler/Main/Detail?scheduleId=" + id;

    //// ME 스페이스
    //returnUrl = returnUrl + "%26GroupId=0";

    // 반복 일정의 횟수
    if (typeof (repeatCount) != "undefined")
        if (parseInt(repeatCount) >= 1)
            returnUrl = returnUrl + "%26repeatdate=" + moment(date).format("YYYY-MM-DD") + "%26repeatcount=" + repeatCount;

    // 사이트 레이아웃 없이 단독으로 페이지만 호출되었는지 여부의 식별 값
    returnUrl = returnUrl + "%26singleCall=true";

    // 호출 페이지 타입
    if (typeof (callTypeId) != "undefined")
        returnUrl = returnUrl + "%26callTypeId=" + callTypeId;

    return url + returnUrl;
}

function getWorkspaceUrl() {
    var result = "";

    if (typeof (WorkspaceUrl) != "undefined") {
        result = WorkspaceUrl;
    }
    
    return result;
}

// 협업 웹응용프로그램 경로
function getWorkspaceAppPath() {
    var result = "/";    // 자바
    
    /* 2025-03-13 홍승비 - 협업 모듈에 고정된 하드코딩 문자열 제거 (ezWorkspace), 테넌트 컨피그 workspaceAppPath로 협업 웹응용프로그램 경로를 분리하여 사용 ("/" 또는 "/ezWork" 등) */
    if (typeof (workspaceAppPath) != "undefined") {
        result = workspaceAppPath;
    }

    // 모바일 외부서버에서 접속 시 내부 서버를 통해 데이터를 처리하도록 Mobile 컨트롤러 경로를 붙여준다.
    if (typeof (g_bMobileExtra) != "undefined" && g_bMobileExtra === true) {
        result = result + "/Mobile";
    }
    
    return result;
}                                                                                                                                                                                                                                                                                     

function getThisSchedule(selectedDate) {
	selectedDate = selectedDate.replace(/\./gi, '-');
	
	document.getElementById("iYear").value = new Date(selectedDate).getFullYear();
	document.getElementById("iMon").value = new Date(selectedDate).getMonth() + 1;
	changeMonth();
	
	var selectedTDId = 'TDMINI_' + selectedDate + '_Day'
	var selectedTD = $('#' + selectedTDId);

	var $selTD = $("#"+g_selTDID);
	if (usedTheme == 3) {
    	$selTD.parent().removeClass('schedule');
    	$("#"+g_selTRID).parent().removeClass('schedule');
    } else {
    	if ($selTD.length > 0) {
    		$selTD.parent().removeClass('select');
    	}
    }
	
	if (usedTheme == 3) {
    	if (selectedTD.parent().attr('class').indexOf('sun') > -1) {
    		selectedTD.parent().addClass('schedule');
    		selectedTD.parent().css("color","red");
    	} else {
    		selectedTD.parent().addClass('schedule');
    	}
    }
		
	g_selTRID = document.querySelector('#' + selectedTDId).parentNode.parentNode.getAttribute("id");
    g_selTDID = 'TDMINI_' + selectedDate + '_Day';

	if (usedTheme != 3) {
		if ($("#" + g_selTDID).length > 0) {
			$("#" + g_selTDID).parent().addClass('select');
		}
	}

    date = selectedDate;
    getScheduleList(date, "P");
	
}

function settingScheduleCalendar() {
	var dayList = messages.strLangSchedule01.split(";");
 	var dSun = dayList[0];
	var dMon = dayList[1];
	var dTue = dayList[2];
	var dWed = dayList[3];
	var dThu = dayList[4];
	var dFri = dayList[5];
	var dSat = dayList[6];
	$("#scheduleSdatepicker").datepicker({
		changeMonth: true,
		changeYear: true,
		autoSize: true,
		showOn: "both",
		buttonImage: "/images/ezNewPortal/calIcon.png",
		buttonImageOnly: true,
		closeText: messages.strLang601,
		prevText: messages.strLang599,
		nextText: messages.strLang600,
		currentText: messages.strLang598,
		monthNames: [messages.strLang586, messages.strLang587, messages.strLang588, messages.strLang589, messages.strLang590, messages.strLang591, messages.strLang592, messages.strLang593, messages.strLang594, messages.strLang595, messages.strLang596, messages.strLang597],
		monthNamesShort: [messages.strLang586, messages.strLang587, messages.strLang588, messages.strLang589, messages.strLang590, messages.strLang591, messages.strLang592, messages.strLang593, messages.strLang594, messages.strLang595, messages.strLang596, messages.strLang597],
		dayNames: [dSun, dMon, dTue, dWed, dThu, dFri, dSat],
		dayNamesShort: [dSun, dMon, dTue, dWed, dThu, dFri, dSat],
		dayNamesMin: [dSun, dMon, dTue, dWed, dThu, dFri, dSat],
		weekHeader: "Wk",
		dateFormat: "yy.mm.dd",
		firstDay: 0,
		isRTL: false,
		duration: 200,
		showAnim: "show",
		showMonthAfterYear: true,
		onSelect: function(dateText, inst) {
			var selectedDate = $(this).val();
			getThisSchedule(selectedDate);
		}
	});

	var scheduleSdatepicker = new Date();
	$("#scheduleSdatepicker").datepicker('setDate', scheduleSdatepicker);
}

function refreshSchedulePortlet() {
	var selectedDate = $('#scheduleSdatepicker').val();
	getThisSchedule(selectedDate);
}


//function today() {
//	newDate = new Date();
//	nDate = (newDate.getDate().length > 1 ? '0'+newDate.getDate() : newDate.getDate());
//	
//	str4 = messages.strLang15.split(";");
//	nDay = newDate.getDay();
//}
