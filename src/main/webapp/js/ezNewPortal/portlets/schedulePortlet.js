/**
 * 김보미
 */
var pMode = "P";
var openerCalendarMiniView, openerCalendarMiniDataSource;

window.onload = function () {
	openerCalendarMiniView = CalendarMiniView;
	openerCalendarMiniDataSource = CalendarMiniDataSource;
	
	CalendarMiniView("CalendarMini");
	CalendarMiniDataSource();
    
	getScheduleList(nowDay, "P");
	
    if (navigator.userAgent.indexOf('Firefox') != -1) {
    	document.body.style.MozUserSelect = 'none';
    	document.body.style.WebkitUserSelect = 'none';
    	document.body.style.khtmlUserSelect = 'none';
    	document.body.style.oUserSelect = 'none';
    	document.body.style.UserSelect = 'none';
	}
}

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
		if($('.nodata')){
			$('.nodata').remove();
		}

		//2018-07-04 포탈에서 read.do 호출시 출처를 알기위한 변수추가
		var pageFrom = 'Portal';
		
		var listHTML = "";
		listHTML += "<ul class='sscheduleUL'>";
		for (var i = 0; i < 3; i++) {
			if (resultList[i] != null && resultList[i] != "") {
				var SCHEDULETYPE = resultList[i].scheduleType;
				var SCHEDULEID = resultList[i].scheduleId;			            
				var DATETYPE = resultList[i].dateType;
				var REPEATCOUNT = resultList[i].repeatCount;
				var STARTDATE = resultList[i].startDate;
				var ENDDATE = resultList[i].endDate;
				var TITLE = resultList[i].title;
				var startTime = STARTDATE.split(' ')[1].substring(0,5);
				var endTime = ENDDATE.split(' ')[1].substring(0,5);
				var selDateType = new Date(selDate.substring(0, 4), selDate.substring(5, 7), selDate.substring(8, 10));			            
				listHTML += "<li class='scheduleLi' onClick=\"open_schedule('" + SCHEDULEID + "','" + SCHEDULETYPE + "','" + DATETYPE + "','" + REPEATCOUNT + "','" + STARTDATE + "','" + pageFrom + "')\">";
				listHTML += "<p class='scheduleTime'>";
				var timeClass = "";
				if(SCHEDULETYPE == 1) {
					timeClass = "Tindividual";
					listHTML += "<span class='Tindividual'>" + strLang125_1 + "</span>";
				} else if (SCHEDULETYPE == 2) {
					timeClass = "Tdept";
					listHTML += "<span class='Tdept'>" + strLang126_1 + "</span>";
				} else if (SCHEDULETYPE == 3) {
					timeClass = "Tcompany";
					listHTML += "<span class='Tcompany'>" + strLang127_1 + "</span>";
				} else if (SCHEDULETYPE == 7) {
					timeClass = "Tgroup";
					listHTML += "<span class='Tgroup'>" + strLang130_1 + "</span>";
				} else {
					listHTML += "";
				}
				
				listHTML += "<span class='" + timeClass + "_timeText'>" + startTime + " ~ " + endTime + "</span></p>";
				listHTML += "<p class='scheduleText'>";
				listHTML += TITLE+"</p></li>";
			} else {
				listHTML += "<li class='scheduleLi_nodata'>";
				listHTML += "<p class='sNodataText'>" + strLang277 + "</p>";	
				listHTML += "<p class='sNodataPlus' onclick='scheduleWrite()'><img src='/images/kr/main/schedule_plus.png'></p></li>";
			}
		}
		listHTML += "</ul'>";
		document.getElementById("scheduleList").innerHTML = listHTML;
		
	} catch (e) {}
}

function scheduleWrite() {
	var wWeight = "790";
    var wHeight = "830";

    var heigth = window.screen.availHeight;
    var width = window.screen.availWidth;

    var left = (width - wWeight) / 2;
    var top = (heigth - wHeight) / 2;
    
    window.open("/ezSchedule/scheduleWrite.do?defaultid=0", "",
    "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
}

function open_schedule(scheduleid, scheduletype, datetype, repeatcount, date, pageFrom) {
    date = date.substr(0, 10);

    var wWeight = "760";
    var wHeight = "670";
    var heigth = window.screen.availHeight;
    var width = window.screen.availWidth;
    var left = (width - wWeight) / 2;
    var top = (heigth - wHeight) / 2;

    //PNO-3
    if (CrossYN())
        window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&type=" + scheduletype + "&datetype=" + datetype + "&repeatcount=" + repeatcount + "&date=" + date + "&pattern=0","",
            "top = " + top + ", left = " + left + ",height = " + wHeight + "px, width = " + wWeight + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1 scrollbars=0");
    else
        window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&type=" + scheduletype + "&datetype=" + datetype + "&repeatcount=" + repeatcount + "&date=" + date + "&pattern=0","",
            "top = " + top + ", left = " + left + ",height = " + wHeight + "px, width = " + wWeight + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1 scrollbars=0");
    //PNO-3 END
}

function goSchedule() {
	window.open("/ezSchedule/scheduleIndex.do?funCode=2", "main", "");
}
