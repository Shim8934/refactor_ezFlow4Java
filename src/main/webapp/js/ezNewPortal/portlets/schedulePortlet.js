/**
 * 김보미
 */
var pMode = "P";
var openerCalendarMiniView, openerCalendarMiniDataSource;

window.onload = function () {
	openerCalendarMiniView = CalendarMiniView;
	openerCalendarMiniDataSource = CalendarMiniDataSource;
	
	CalendarMiniView("CalendarMini");	    		
    
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
		dataType : "text",
		async : true,
		url : "/ezNewPortal/getScheduleList.do",
		data : {
			selectDate  : date		    			
		},
		success: function(text){
			getScheduleList_after(text, mode, date);
		}
    });
}

function getScheduleList_after(text, mode, date) {
    try {
    	if($('.nodata')){
	    	$('.nodata').remove();
    	}
        var xmldom = createXmlDom();
        xmldom = loadXMLString(text);
        //2018-07-04 포탈에서 read.do 호출시 출처를 알기위한 변수추가
        var pageFrom = 'Portal';
        
        var listHTML = "";
        listHTML += "<ul class='sscheduleUL'>";
        
        for (var i = 0; i < 3; i++) {
        	if (getNodeText(xmldom.getElementsByTagName("SCHEDULEID").item(i)) != null && getNodeText(xmldom.getElementsByTagName("SCHEDULEID").item(i)) != "") {
	    		var SCHEDULETYPE = getNodeText(xmldom.getElementsByTagName("SCHEDULETYPE").item(i));
	            var SCHEDULEID = getNodeText(xmldom.getElementsByTagName("SCHEDULEID").item(i));			            
	            var DATETYPE = getNodeText(xmldom.getElementsByTagName("DATETYPE").item(i));
	            var REPEATCOUNT = getNodeText(xmldom.getElementsByTagName("REPEATCOUNT").item(i));
	            var STARTDATE = getNodeText(xmldom.getElementsByTagName("STARTDATE").item(i));
	            var ENDDATE = getNodeText(xmldom.getElementsByTagName("ENDDATE").item(i));
	            var TITLE = getNodeText(xmldom.getElementsByTagName("TITLE").item(i));
	            var startTime = STARTDATE.split(' ')[1].substring(0,5);
	            var endTime = ENDDATE.split(' ')[1].substring(0,5);
	            var selDateType = new Date(selDate.substring(0, 4), selDate.substring(5, 7), selDate.substring(8, 10));			            
            	listHTML += "<li class='scheduleLi' onClick=\"open_schedule('" + SCHEDULEID + "','" + SCHEDULETYPE + "','" + DATETYPE + "','" + REPEATCOUNT + "','" + STARTDATE + "','" + pageFrom + "')\">";
            	listHTML += "<p class='scheduleTime'>";
            	
            	var timeClass = "";
            	if(SCHEDULETYPE == 1) {
            		timeClass = "Tindividual";
            		listHTML += "<span class='Tindividual'>" + strLang125 + "</span>";
            	} else if (SCHEDULETYPE == 2) {
            		timeClass = "Tdept";
            		listHTML += "<span class='Tdept'>" + strLang126 + "</span>";
            	} else if (SCHEDULETYPE == 3) {
            		timeClass = "Tcompany";
            		listHTML += "<span class='Tcompany'>" + strLang127 + "</span>";
            	} else if (SCHEDULETYPE == 7) {
            		timeClass = "Tgroup";
            		listHTML += "<span class='Tgroup'>" + strLang130 + "</span>";
            	} else {
            		listHTML += "";
            	}
            	
            	listHTML += "<span class='" + timeClass + "_timeText'>" + startTime + " ~ " + endTime + "</span></p>";
            	listHTML += "<p class='scheduleText'>";
            	listHTML += MakeXMLString(TITLE)+"</p></li>";
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
        window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&type=" + scheduletype + "&datetype=" + datetype + "&repeatcount=" + repeatcount + "&date=" + date + "&pattern=0",
            "top = " + top + ", left = " + left + ",height = " + wHeight + "px, width = " + wWeight + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1 scrollbars=0");
    else
        window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&type=" + scheduletype + "&datetype=" + datetype + "&repeatcount=" + repeatcount + "&date=" + date + "&pattern=0",
            "top = " + top + ", left = " + left + ",height = " + wHeight + "px, width = " + wWeight + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1 scrollbars=0");
    //PNO-3 END
}

function goSchedule() {
	window.open("/ezSchedule/scheduleIndex.do?funCode=2", "main", "");
}
