var defaultView = 0; // 달력 시작 일 (일 = 0, 월 = 1)
var sDate = new Date();
var dayOfWeeks;

//2018-08-14 배현상, 브라우저의 창 크기가 작을 경우 달력의 height가 작게 고정되어 근태유형의 max height의 값을 적용
var monthHeight = Math.floor((781 - 191) /6) > (((parseInt(document.documentElement.clientHeight, 10) - 255) / 6) - 6) ? Math.floor((781 - 191) /6) : (((parseInt(document.documentElement.clientHeight, 10) - 255) / 6) - 6);
/**
 * 달력 생성(월보기만 제공)
 * @param pTargetID 달력을 배치시킬 ID
 */
function CalendarView(pTargetID) {
	
	if (defaultView == 0) {
		dayOfWeeks = strLang5;
	} else if (defaultView == 1) {
		dayOfWeeks = strLang6;
	}
	
	getCalTitle(pTargetID);
	
	
	var btnType = $(".mainmenuTabUL li.on").attr("id");
	if (btnType == "btnCalList" || btnType == undefined) {
		getAttitudeMainList();
	} else {
		getAttitudeTableList();
	}
	
	//month picker 호출함수    
    var WstartDate, WendDate; 
    var monthCssHidden = function(){
		window.setTimeout(function(){
			 $('.ui-datepicker-month').css('display','none');
			 $('.ui-datepicker-year').css('margin','0 auto');
		}, 1);
	}
    var monthCssShow = function(){
		window.setTimeout(function(){
			 $('.ui-datepicker-month').css('display','');
			 $('.ui-datepicker-year').css('margin','');
		}, 1);
	}
    var removeMonthClass = function(){
		window.setTimeout(function(){
			 $('#ui-datepicker-div').removeClass('ui-monthpicker');
		}, 1);
	}
       
    $(".datePick").monthpicker({
    	showOn: "both",
		buttonImage: "/images/ImgIcon/calendar-month.png",
		buttonImageOnly: true,
		onSelect: function (dateText, inst) {
			var iMonth = parseInt($('.datePick').val().substring(5,7),10)-1;
			var iYear = $('.datePick').val().substring(0,4);
			var iDay = $('.datePick').val().substring(8,10);
			
			var beforeMonth = leadingZeros((sDate.getMonth() + 1), 2) - 1; 	   
			var beforeYear = sDate.getFullYear();
			
			sDate.setFullYear(iYear, iMonth, iDay); 
			if(iYear == beforeYear && iMonth == beforeMonth){
				return;   			   
			}else CalendarView("attiCalendar");

		}
    });               
}

function getCalTitle(pTargetID) {
	var objElm = document.getElementById(pTargetID);
//	if (objElm) {
		objElm.innerHTML = "";
		
		// 이전 달로 이동하는 버튼 생성
		var mSpan = document.createElement("SPAN");
		mSpan.className = "icon16 calendarleft";
		mSpan.setAttribute("onclick", "preMonth()");
		
		$("#preM").html("");
        $("#preM").append(mSpan);
		
		// 년-월 을 보여주는 textNode 생성
        var dayText = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2);
		var oText = document.createTextNode(" " + dayText + " ");
		
		$("#calTitle").html("");
        $("#calTitle").append(oText);
		
		// month picker 
        var uploadSDate = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2);
        var datePick = document.createElement("INPUT");
        datePick.setAttribute("type", "hidden");
        datePick.setAttribute("name", "datePick");
        datePick.setAttribute("class", "datePick");
        datePick.setAttribute("value", uploadSDate);
        
        $("#calTitle").append(datePick);
		
		// 다음 달로 이동하는 버튼 생성        
		var mSpan2 = document.createElement("SPAN");
		mSpan2.className = "icon16 calendarright";
		mSpan2.setAttribute("onclick", "nextMonth()");
		
		$("#preN").html("");
        $("#preN").append(mSpan2);
		
		// 달력 날짜 부분
		var oTable = document.createElement("TABLE");
		oTable.setAttribute("id", "dayDiv");
		oTable.setAttribute("cellpadding", "0");
		oTable.setAttribute("cellspacing", "0");
		oTable.setAttribute("border", "0");
		oTable.setAttribute("width", "100%");
		oTable.className = "calendar_month";
		
		// month data
		var oTBody = getMonthBodyObj();
		
		oTable.appendChild(oTBody);
		objElm.appendChild(oTable);
		
		objElm = null;
//	}
}

/**
 * tBody td로 month 반환
 */
function getMonthBodyObj() {
	var year = sDate.getFullYear();
	var month = sDate.getMonth();
	
	// 해당 달의 달력이 6*7을 다 채우지 못하는 경우 앞의 달의 뒷부분과 뒤의 달의 앞부분을 채워주기 위한 로직
	oBeforeDate = new Date(new Date(year, month, 1) - 86400000);
	oThisDate = new Date(year, month, 1);
	
	// 두 개의 date에 해당 지역의 offset 적용
	oBeforeDate.setTime(oBeforeDate.getTime() + (oBeforeDate.getTimezoneOffset() + (oBeforeDate.getHours() * 60) + oBeforeDate.getMinutes()) * 60 * 1000);
	oThisDate.setTime(oThisDate.getTime() + (oThisDate.getTimezoneOffset() + (oThisDate.getHours() * 60) + oThisDate.getMinutes()) * 60 * 1000);
	
	var oBeforeMaxDay = oBeforeDate.getDate();
	var startThisDay = oThisDate.getDay();
	oThisMonth = oBeforeDate.getMonth() + 1;
	
	if (oThisMonth == 12) {
		oThisMonth = 0;
	}
	
	// 이번 달에 시작하는 요일 전의 날짜를 이전 달의 날짜로 채우기 위해
	// DefaultView를 더해주는 이유는 달력이 일요일에서 시작하는 경우와 월요일에서 시작하는 경우 이전 달의 날짜를 가져오는 게 차이가 있기 때문이다.
	oBeforeDate.setDate(oBeforeMaxDay - startThisDay + 1 + defaultView);
	
	var oTbody = document.createElement("TBODY");
	var objTr = document.createElement("TR");
	
	// 달력의 '일,월,화,수,목,금,토'를 셋팅하는 반복문
	for (var j = 0; j < 7; j++) {
		var objTh = document.createElement("TH");
		var oText = document.createTextNode(dayOfWeeks.split(";")[j]); // dayOfWeeks => '일;월;화;수;목;금;토'
		var className = "";
		
		//defaultView == 0인 경우는 0번째가 일요일 , defaultView == 1인 경우는 6번째가 일요일
		if (defaultView == 0 && j == 6 || defaultView == 1 && j == 5) {
			objTh.className = "sat";
			className = "sat";
		} else if (defaultView == 0 && j == 0 || defaultView == 1 && j == 6 || companyHoliday[j] == "1") {
			objTh.className = "sun";
			className = "sun";
		} 
		
		objTh.appendChild(oText);
		objTr.appendChild(objTh);
		objTh = null;
	}
	oTbody.appendChild(objTr);
	
	// 달력에 일자 데이터를 넣어주기 위해 oBeforeDate를 oThisDate를 넣는다.
	// oBeforeMaxDay가 0이면 안넣어 주는 이유는 이전 달의 데이터가 필요가 없으므로 안넣어 줘도 된다.
	if (oBeforeMaxDay != 0) {
		oThisDate = oBeforeDate;
	}
	
	sStartDate = oThisDate.getFullYear() + "-" + (oThisDate.getMonth() + 1) + "-" + oThisDate.getDate();
	
	var TDIndex = 0;
	//6x7의 달력
	for (var i = 0; i < 6; i++) {
		var objTr = document.createElement("TR");
		for (var j = 0; j < 7; j++) {
			var objTd = monthDate(oThisDate, TDIndex);
			TDIndex++;
			objTr.appendChild(objTd);
			objTd = null;
		}
		oTbody.appendChild(objTr);
	}
	
	oThisDate.setDate(oThisDate.getDate());
	sEndDate = oThisDate.getFullYear() + "-" + (oThisDate.getMonth() + 1) + "-" + oThisDate.getDate();
	objTr = null;
	
	return oTbody;
}

//달력에 하루의 TD를 셋팅
function monthDate(oThisDate, TDIndex) {
	var tempyear = oThisDate.getFullYear();
	var lunarDate; // 음력 날짜를 저장하기 위한 변수
	var lunarDate2; // 음력월.음력일 => 달력에 음력일을 표시해주기 위한 변수
	if (tempyear > 1800 && tempyear <= 2101) { // 음력에 대한 날짜 제공은 1800 ~ 2101
		lunarDate = lunarCalc(tempyear, oThisDate.getMonth() + 1, oThisDate.getDate(), 1);
		
		lunarDate2 = lunarDate.month + "." + lunarDate.day;
		if (lunarDate.leapMonth) {
			lunarDate2 = "윤" + lunarDate2;
		}
	}
	var objTd = document.createElement("TD");
	
	//매달 1일에는 x월 1일 을 표시해주기 위해
	if (oThisDate.getDate() == "1") {
		var pDateData = (oThisDate.getMonth() + 1) + strLang122 + " " + oThisDate.getDate() + strLang123;
	} else {
		var pDateData = oThisDate.getDate();
	}
	
	var tempmemorial = memorialDayCheck(oThisDate, lunarDate); // 날짜에 해당하는 휴일을 가져온다.
	var tempyearmemorial = yearmemorialDayCheck(oThisDate, lunarDate);
	
	var isholiday = false;
	var holidayname = "";
	var holidayname2 = "";
	
	for (var i = 0; i < tempmemorial.length; i++) {
        memorial = tempmemorial[i];
        
        // 2020-04-03 김민성 - 윤달일 때 음력 기념일 안나타나도록 수정
        if (lunarDate.leapMonth && memorial.solarLunar == 2) {
        	continue;
        }
        
        if (uselang == "1") {
            if (i == tempmemorial.length - 1) {
            	holidayname += memorial.name;
            } else {
            	holidayname += memorial.name + ", ";
            }
        } else {
            if (i == tempmemorial.length - 1) {
            	holidayname += memorial.name2;
            } else {
            	holidayname += memorial.name2 + ", ";
            }
        }
        if (memorial.holiday) {
        	isholiday = true;
        }
    }

    for (var i = 0; i < tempyearmemorial.length; i++) {
        yearmemorial = tempyearmemorial[i];
        if (uselang == "1") {
            if (i == tempyearmemorial.length - 1) {
            	holidayname2 += yearmemorial.name;
            } else {
            	holidayname2 += yearmemorial.name + ", ";
            }
        } else {
            if (i == tempyearmemorial.length - 1) {
            	holidayname2 += yearmemorial.name2;
            } else {
            	holidayname2 += yearmemorial.name2 + ", ";
            }
        }
        if (yearmemorial.holiday) {
        	isholiday = true;
        }
    }

    if (holidayname != "" && holidayname2 != "") {
    	holidayname = holidayname + ", " + holidayname2;
    } else if (holidayname == "" && holidayname2 != "") {
    	holidayname = holidayname2;
    }
    
	//이전 달의 요일을 구분하기 위해 다른 클래스를 적용
	var className = "";
	if (oThisMonth != oThisDate.getMonth()) {
		className = " gray";
	} else if (isholiday) {
		className = " sun";
	} else if (oThisDate.getDay() == 6) {
		className = " sat";
	} else if (oThisDate.getDay() == 0 || companyHoliday[oThisDate.getDay()] == "1") {
		className = " sun";
	}
	
	//각 나라별로 오늘을 구하기 위해 다음 로직 사용
	var nowDate = new Date();
	
	if (typeof UserOffset !== 'undefined' && UserOffset) {
		//getTimezoneOffset() ==> minite, timez : 사용자의 UTC가 적용된 날짜
		var timez = nowDate.getTime() + (nowDate.getTimezoneOffset() * 60000) + (parseInt(UserOffset.split(':')[0]) *3600000);
		nowDate.setTime(timez);
	}
	
	var cell_ID = (oThisDate.getFullYear()) + "-" + leadingZeros((oThisDate.getMonth() + 1), 2) + "-" + leadingZeros(oThisDate.getDate(), 2);
	var nowDay = (nowDate.getFullYear()) + "-" + leadingZeros((nowDate.getMonth() + 1), 2) + "-" + leadingZeros(nowDate.getDate(), 2);
	
	if (cell_ID == nowDay) {
		objTd.className = "today";
	} else {
		objTd.className = className;
	}
	
	objTd.setAttribute("id", "index_" + TDIndex);
	objTd.setAttribute("day", cell_ID);
	//objTd.onmousedown = function (event) { MultiSelectStart(this, event); };
    //objTd.onmouseup = function (event) { MultiSelectEnd(this, event); };
    //objTd.onmouseover = function (event) { MultiSelectItems(this, event); };
	
	var subTable = document.createElement("TABLE");
	var subTr = document.createElement("TR");
	var subTd = document.createElement("TD");
	subTable.className = "td_day" + className;
	subTable.setAttribute("cellpadding", "0");
	subTable.setAttribute("cellspacing", "0");
	subTable.setAttribute("border", "0");
	subTd.setAttribute("id", "TD_" + cell_ID + "_Day");
	//subTd.setAttribute("onmouseover", "MonthlyViewHeader_onMouseOver(this)");
    //subTd.setAttribute("onmouseout", "MonthlyViewHeader_onMouseOut(this)");
    //subTd.setAttribute("ondblclick", "WriteDateSchedule(this)");
    subTd.setAttribute("dispDate", cell_ID);
    
    //음력분기 여기서 타면 됨
    if (LunarUse) {
    	subTd.innerHTML = pDateData + " (" + lunarDate2 + ") " + holidayname;
    } else {
    	subTd.innerHTML = pDateData + " " + holidayname;
    }
    
    subTr.appendChild(subTd);
    subTable.appendChild(subTr);
    objTd.appendChild(subTable);
    
    var subSpan = document.createElement("SPAN");
    var subTable = document.createElement("TABLE");
    subSpan.className = "span_list";
    
    if (deptFlag != "true") { 
    	var monthHeight2 = monthHeight - 13.3;
    	
    	if (monthHeight2 < 90.66) {
    		monthHeight2 = 90.66;
        }
    	
    	subSpan.style.height = monthHeight2 + "px"
    } else {
    	if (monthHeight < 50) {
        	monthHeight = 70;
        }
    	
    	subSpan.style.height = monthHeight + "px"
    }
    
    subSpan.setAttribute("name", "span_list");
    subTable.setAttribute("id", "TD_" + cell_ID + "_Value");
    subTable.className = "td_list";
    subTable.setAttribute("cellpadding", "0");
    subTable.setAttribute("cellspacing", "0");
    subTable.setAttribute("border", "0"); 
    subSpan.appendChild(subTable);
    objTd.appendChild(subSpan);

    oThisDate.setDate(oThisDate.getDate() + 1);
    return objTd;
}

/**
 * 자릿수 통일 (1 => 01)
 * @param n
 * @param digits 자릿수 길이
 * @returns {String}
 */
function leadingZeros(n, digits) {
    var zero = '';
    n = n.toString();

    if (n.length < digits) {
        for (var i = 0; i < digits - n.length; i++)
            zero = '0' + zero;
    }
    return zero + n;
}

/**
 * 다음달 이동 함수
 */
function nextMonth() {
	var cYear = $("#calTitle").text().trim().split("-")[0];
	var cMonth = parseInt($("#calTitle").text().trim().split("-")[1], 10) + 1; // 다음달로 이동 +1
	
	if (cMonth > 12) {
		cYear++;
		cMonth = 1;
	}
	
	sDate.setFullYear(cYear, cMonth - 1, 14);
	$("#calTitle").text(" " + cYear + "-" + leadingZeros(cMonth, 2) + " ");
	
	var btnType = $(".mainmenuTabUL li.on").attr("id");
	if (btnType == "btnCalList" || btnType == undefined) {
		CalendarView("attiCalendar");
	} else {
		getCalTitle("attiCalendar");
		getAttitudeTableList();
	}
}

/**
* 이전달 이동 함수
*/
function preMonth() {
	var cYear = $("#calTitle").text().trim().split("-")[0];
	var cMonth = parseInt($("#calTitle").text().trim().split("-")[1], 10) - 1; // 이전달로 이동 -1
	
	if (cMonth < 1) {
		cYear--;
		cMonth = 12;
	}
	
	sDate.setFullYear(cYear, cMonth - 1, 1);
	$("#calTitle").text(" " + cYear + "-" + leadingZeros(cMonth, 2) + " ");
	
	var btnType = $(".mainmenuTabUL li.on").attr("id");
	if (btnType == "btnCalList" || btnType == undefined) {
		CalendarView("attiCalendar");
	} else {
		getCalTitle("attiCalendar");
		getAttitudeTableList();
	}
}

function memorialDayCheck(solarDate, lunarDate) {
    var i;
    var memorial;

    var tempmemorialDays = new Array();
    for (i = 0; i < memorialDays.length; i++) {
    	if (memorialDays[i].type == 'Y') {
    		var resultDate = changeRepetitionToDate(memorialDays[i].repetition, solarDate.getFullYear());
    		if (resultDate.getMonth() == solarDate.getMonth() && resultDate.getDate() == solarDate.getDate() && memorialDays[i].solarLunar == 1) {
    			tempmemorialDays.push(memorialDays[i]);
    		}        		
    	} else {
    		if (memorialDays[i].month == solarDate.getMonth() + 1 &&
    				memorialDays[i].day == solarDate.getDate() &&
    				memorialDays[i].solarLunar == 1) {
    			tempmemorialDays.push(memorialDays[i]);
    		}
    		
    		if (memorialDays[i].month == "12" && memorialDays[i].day == "30" && memorialDays[i].solarLunar == 2 && !memorialDays[i].leapMonth
    			&& (lunarDate.month == "12" && lunarDate.day == "29")) {
    			var tempDate = new Date(solarDate.getTime());
				tempDate.setDate(tempDate.getDate() + 1);
				var tempLunarDate = lunarCalc(tempDate.getFullYear(), tempDate.getMonth() + 1, tempDate.getDate(), 1);
                var tempLunarDatemonth = tempLunarDate.month;
                var tempLunarDateday = tempLunarDate.day;
                
                if (!(tempLunarDatemonth == "12" && tempLunarDateday == "30")) {
                	var tempMemorial = {}
                	var keys = Object.keys(memorialDays[i]);
                    
                    for (var j = 0; j < keys.length; j++) {
                        var key = keys[j];
                        tempMemorial[key] = memorialDays[i][key];
                    }
                    tempMemorial.day = "29"
                	tempmemorialDays.push(tempMemorial);
                }
				
			} else if (memorialDays[i].month == lunarDate.month &&
					memorialDays[i].day == lunarDate.day &&
					memorialDays[i].solarLunar == 2 &&
					!memorialDays[i].leapMonth) {
				tempmemorialDays.push(memorialDays[i]);
    		}
    	}
    }
    return tempmemorialDays;
}

function yearmemorialDayCheck(solarDate, lunarDate) {
    var i;
    var yearmemorial;

    var tempyearmemorialDays = new Array();
    for (i = 0; i < yearmemorialDays.length; i++) {
        if (solarDate.getFullYear() > 1800 && solarDate.getFullYear() <= 2101) {
        	if (yearmemorialDays[i].type == 'Y') {
        		var resultDate = changeRepetitionToDate(yearmemorialDays[i].repetition, '');
        		if (resultDate.getFullYear() == solarDate.getFullYear() && resultDate.getMonth() == solarDate.getMonth() && resultDate.getDate() == solarDate.getDate()  && yearmemorialDays[i].solarLunar == 1) {
        			tempyearmemorialDays.push(yearmemorialDays[i]);
        		}        		
        	} else {
        		if (yearmemorialDays[i].year == solarDate.getFullYear() &&
        				yearmemorialDays[i].month == solarDate.getMonth() + 1 &&
        				yearmemorialDays[i].day == solarDate.getDate() &&
        				yearmemorialDays[i].solarLunar == 1) {
        			tempyearmemorialDays.push(yearmemorialDays[i]);
        		}
        		
        		if (yearmemorialDays[i].year == lunarDate.year && yearmemorialDays[i].month == "12" && yearmemorialDays[i].day == "30" && yearmemorialDays[i].solarLunar == 2 && !yearmemorialDays[i].leapMonth
        			&& (lunarDate.month == "12" && lunarDate.day == "29")) {
        			var tempDate = new Date(solarDate.getTime());
    				tempDate.setDate(tempDate.getDate() + 1);
    				var tempLunarDate = lunarCalc(tempDate.getFullYear(), tempDate.getMonth() + 1, tempDate.getDate(), 1);
                    var tempLunarDatemonth = tempLunarDate.month;
                    var tempLunarDateday = tempLunarDate.day;
                    
                    if (!(tempLunarDatemonth == "12" && tempLunarDateday == "30")) {
                    	var tempMemorial = {}
                    	var keys = Object.keys(yearmemorialDays[i]);
                        
                        for (var j = 0; j < keys.length; j++) {
                            var key = keys[j];
                            tempMemorial[key] = yearmemorialDays[i][key];
                        }
                        tempMemorial.day = "29"
                        tempyearmemorialDays.push(tempMemorial);
                    }
        				
        		} else if (yearmemorialDays[i].year == lunarDate.year &&
	    				yearmemorialDays[i].month == lunarDate.month &&
	    				yearmemorialDays[i].day == lunarDate.day &&
	    				yearmemorialDays[i].solarLunar == 2 &&
	    				!yearmemorialDays[i].leapMonth) {
        			tempyearmemorialDays.push(yearmemorialDays[i]);
        		}
        	}
        }
    }
    return tempyearmemorialDays;
}

/**
 * type이 1인 경우에는 양력 날짜를 받아 음력 날짜를 반환
 * type이 2인 경우에는 음력 날짜를 받아 양력 날짜를 반환
 * */
function lunarCalc(year, month, day, type, leapmonth) {
    var solYear, solMonth, solDay;
    var lunYear, lunMonth, lunDay;
    var lunLeapMonth, lunMonthDay;
    var i, lunIndex;
    var solMonthDay = [31, 0, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    
    if (year < 1800 || year > 2101) {
        alert('1800년부터 2101년까지만 지원합니다');
        return;
    }
    
    if (year >= 2080) {
        
        solYear = 2080;
        solMonth = 1;
        solDay = 1;
        lunYear = 2079;
        lunMonth = 12;
        lunDay = 10;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; 
        lunMonthDay = 30; 
    }
    else if (year >= 2060) {
        
        solYear = 2060;
        solMonth = 1;
        solDay = 1;
        lunYear = 2059;
        lunMonth = 11;
        lunDay = 28;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; 
        lunMonthDay = 30; 
    }
    else if (year >= 2040) {
        
        solYear = 2040;
        solMonth = 1;
        solDay = 1;
        lunYear = 2039;
        lunMonth = 11;
        lunDay = 17;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; 
        lunMonthDay = 29; 
    }
    else if (year >= 2020) {
        
        solYear = 2020;
        solMonth = 1;
        solDay = 1;
        lunYear = 2019;
        lunMonth = 12;
        lunDay = 7;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; 
        lunMonthDay = 30; 
    }
    else if (year >= 2000) {
        
        solYear = 2000;
        solMonth = 1;
        solDay = 1;
        lunYear = 1999;
        lunMonth = 11;
        lunDay = 25;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; 
        lunMonthDay = 30; 
    }
    else if (year >= 1980) {
        
        solYear = 1980;
        solMonth = 1;
        solDay = 1;
        lunYear = 1979;
        lunMonth = 11;
        lunDay = 14;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; 
        lunMonthDay = 30; 
    }
    else if (year >= 1960) {
        
        solYear = 1960;
        solMonth = 1;
        solDay = 1;
        lunYear = 1959;
        lunMonth = 12;
        lunDay = 3;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; 
        lunMonthDay = 29; 
    }
    else if (year >= 1940) {
        
        solYear = 1940;
        solMonth = 1;
        solDay = 1;
        lunYear = 1939;
        lunMonth = 11;
        lunDay = 22;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; 
        lunMonthDay = 29; 
    }
    else if (year >= 1920) {
        
        solYear = 1920;
        solMonth = 1;
        solDay = 1;
        lunYear = 1919;
        lunMonth = 11;
        lunDay = 11;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; 
        lunMonthDay = 30; 
    }
    else if (year >= 1900) {
        
        solYear = 1900;
        solMonth = 1;
        solDay = 1;
        lunYear = 1899;
        lunMonth = 12;
        lunDay = 1;
        lunLeapMonth = 0;
        solMonthDay[1] = 28; 
        lunMonthDay = 30; 
    }
    else if (year >= 1880) {
        
        solYear = 1880;
        solMonth = 1;
        solDay = 1;
        lunYear = 1879;
        lunMonth = 11;
        lunDay = 20;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; 
        lunMonthDay = 30; 
    }
    else if (year >= 1860) {
        
        solYear = 1860;
        solMonth = 1;
        solDay = 1;
        lunYear = 1859;
        lunMonth = 12;
        lunDay = 9;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; 
        lunMonthDay = 30; 
    }
    else if (year >= 1840) {
        
        solYear = 1840;
        solMonth = 1;
        solDay = 1;
        lunYear = 1839;
        lunMonth = 11;
        lunDay = 27;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; 
        lunMonthDay = 30; 
    }
    else if (year >= 1820) {
        
        solYear = 1820;
        solMonth = 1;
        solDay = 1;
        lunYear = 1819;
        lunMonth = 11;
        lunDay = 16;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; 
        lunMonthDay = 30; 
    }
    else if (year >= 1800) {
        
        solYear = 1800;
        solMonth = 1;
        solDay = 1;
        lunYear = 1799;
        lunMonth = 12;
        lunDay = 7;
        lunLeapMonth = 0;
        solMonthDay[1] = 28; 
        lunMonthDay = 30; 
    }
    lunIndex = lunYear - 1799;
    while (true) {
        if (type == 1 &&
         year == solYear &&
         month == solMonth &&
         day == solDay) {
            return new myDate(lunYear, lunMonth, lunDay, lunLeapMonth);
        }
        else if (type == 2 &&
          year == lunYear &&
          month == lunMonth &&
          day == lunDay &&
          leapmonth == lunLeapMonth) {
            return new myDate(solYear, solMonth, solDay, 0);
        }
        
        if (solMonth == 12 && solDay == 31) {
            solYear++;
            solMonth = 1;
            solDay = 1;
            
            if (solYear % 400 == 0)
                solMonthDay[1] = 29;
            else if (solYear % 100 == 0)
                solMonthDay[1] = 28;
            else if (solYear % 4 == 0)
                solMonthDay[1] = 29;
            else
                solMonthDay[1] = 28;
        }
        else if (solMonthDay[solMonth - 1] == solDay) {
            solMonth++;
            solDay = 1;
        }
        else
            solDay++;
        
        if (lunMonth == 12 &&
         ((lunarMonthTable[lunIndex][lunMonth - 1] == 1 && lunDay == 29) ||
         (lunarMonthTable[lunIndex][lunMonth - 1] == 2 && lunDay == 30))) {
            lunYear++;
            lunMonth = 1;
            lunDay = 1;
            if (lunYear > 2101) {
                alert("입력하신 날 또는 달은 없습니다. 다시 입력하시기 바랍니다.");
                break;
            }
            lunIndex = lunYear - 1799;
            if (lunarMonthTable[lunIndex][lunMonth - 1] == 1)
                lunMonthDay = 29;
            else if (lunarMonthTable[lunIndex][lunMonth - 1] == 2)
                lunMonthDay = 30;
        }
        else if (lunDay == lunMonthDay) {
            if (lunarMonthTable[lunIndex][lunMonth - 1] >= 3
             && lunLeapMonth == 0) {
                lunDay = 1;
                lunLeapMonth = 1;
            }
            else {
                lunMonth++;
                lunDay = 1;
                lunLeapMonth = 0;
            }
            if (lunarMonthTable[lunIndex][lunMonth - 1] == 1)
                lunMonthDay = 29;
            else if (lunarMonthTable[lunIndex][lunMonth - 1] == 2)
                lunMonthDay = 30;
            else if (lunarMonthTable[lunIndex][lunMonth - 1] == 3)
                lunMonthDay = 29;
            else if (lunarMonthTable[lunIndex][lunMonth - 1] == 4 &&
              lunLeapMonth == 0)
                lunMonthDay = 29;
            else if (lunarMonthTable[lunIndex][lunMonth - 1] == 4 &&
              lunLeapMonth == 1)
                lunMonthDay = 29;
            else if (lunarMonthTable[lunIndex][lunMonth - 1] == 5 &&
              lunLeapMonth == 0)
                lunMonthDay = 30;
            else if (lunarMonthTable[lunIndex][lunMonth - 1] == 5 &&
              lunLeapMonth == 1)
                lunMonthDay = 29;
            else if (lunarMonthTable[lunIndex][lunMonth - 1] == 6)
                lunMonthDay = 30;
        }
        else
            lunDay++;
    }
}

// 1800 ~ 2101까지의 음력을 저장한 테이블 => 불규칙적인 음력 날짜를 표시하기 위함
var lunarMonthTable = [
[1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2],
[2, 1, 2, 5, 2, 1, 2, 1, 2, 1, 2, 1],
[1, 2, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2], 
[1, 1, 2, 1, 2, 1, 2, 2, 2, 1, 2, 1],
[2, 3, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 1, 3, 2, 1, 2, 2, 2, 1],
[2, 2, 1, 2, 1, 1, 1, 2, 1, 2, 2, 1],
[2, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[1, 2, 2, 1, 5, 2, 1, 2, 1, 1, 2, 1],
[2, 2, 1, 2, 2, 1, 2, 1, 2, 1, 1, 2],
[1, 2, 1, 2, 2, 1, 2, 2, 1, 2, 1, 2],
[1, 1, 5, 2, 1, 2, 2, 1, 2, 2, 1, 2], 
[1, 1, 2, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 1, 1, 1, 2, 1, 2, 2, 2, 1],
[2, 5, 2, 1, 1, 1, 2, 1, 2, 2, 1, 2],
[2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 5, 1, 2, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1],
[2, 1, 2, 2, 1, 2, 2, 1, 2, 1, 1, 2],
[1, 2, 1, 5, 2, 2, 1, 2, 2, 1, 2, 1],
[1, 2, 1, 2, 1, 2, 1, 2, 2, 2, 1, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2], 
[2, 1, 5, 1, 1, 2, 1, 2, 2, 1, 2, 2],
[2, 1, 2, 1, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 4, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 1, 2, 2, 4, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 1, 2, 3, 2, 1, 2, 2, 1, 2, 2, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2], 
[1, 2, 1, 2, 1, 1, 2, 1, 5, 2, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 5, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2],
[1, 2, 1, 5, 1, 2, 2, 1, 2, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 4, 1, 1, 2, 1, 2, 1, 2, 2, 1],   
[2, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 1],
[2, 2, 2, 1, 2, 1, 4, 1, 2, 1, 2, 1],
[2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 5, 2, 1, 2, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 3, 2, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 1, 2, 3, 2, 1, 2, 2],   
[2, 1, 2, 2, 1, 1, 2, 1, 2, 1, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 5, 2, 1, 2, 1, 2],
[1, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1, 2],
[1, 2, 1, 1, 5, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[2, 1, 6, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2],   
[2, 1, 2, 1, 2, 2, 1, 5, 2, 1, 1, 2],
[1, 2, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2],
[1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 4, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2],
[1, 2, 2, 3, 2, 1, 1, 2, 1, 2, 2, 1],
[2, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 2, 2, 1, 2, 1, 2, 1, 1, 5, 2, 1],
[2, 2, 1, 2, 2, 1, 2, 1, 2, 1, 1, 2],   
[1, 2, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2],
[1, 1, 2, 1, 2, 4, 2, 1, 2, 2, 1, 2],
[1, 1, 2, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1],
[2, 2, 1, 1, 5, 1, 2, 1, 2, 2, 1, 2],
[2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 2, 4, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 1, 2, 2, 1, 2, 2, 1, 2, 1, 1, 2],
[1, 2, 1, 2, 1, 2, 5, 2, 2, 1, 2, 1],   
[1, 2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2],
[2, 1, 1, 2, 3, 2, 1, 2, 2, 1, 2, 2],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 2, 1, 5, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 5, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],   
[1, 1, 2, 1, 1, 5, 2, 2, 1, 2, 2, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 5, 1, 2, 1, 2, 1, 2, 1],
[2, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 5, 2, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 5, 2, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1],   
[2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 3, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1],
[2, 2, 1, 2, 2, 1, 1, 2, 1, 2, 1, 2],
[1, 2, 2, 4, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 1, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2],
[1, 5, 1, 2, 1, 2, 1, 2, 2, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 1, 1, 5, 1, 2, 2, 1, 2, 2],   
[2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2],
[2, 2, 1, 2, 5, 1, 2, 1, 2, 1, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 3, 2, 1, 2, 2, 1, 2, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 2, 1, 1, 2, 1, 5, 2, 1, 2, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],   
[2, 1, 2, 2, 3, 2, 1, 1, 2, 1, 2, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2],
[2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 1],
[2, 1, 2, 5, 2, 1, 2, 2, 1, 2, 1, 2],
[1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 5, 1, 2, 1, 1, 2, 2, 1, 2, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2],
[1, 2, 2, 1, 1, 5, 1, 2, 1, 2, 2, 1],
[2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1],   
[2, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2],
[1, 2, 2, 1, 6, 1, 2, 1, 2, 1, 1, 2],
[1, 2, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2],
[1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 4, 1, 1, 2, 2, 1, 2, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1],
[2, 2, 1, 1, 2, 1, 4, 1, 2, 2, 1, 2],
[2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 2, 1, 2, 2, 4, 1, 1, 2, 1, 2, 1],   
[2, 1, 2, 2, 1, 2, 2, 1, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 4, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2],
[2, 5, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 3, 2, 1, 2, 1, 2],
[1, 2, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2],   
[1, 2, 1, 2, 4, 1, 2, 2, 1, 2, 1, 2],
[1, 2, 1, 1, 2, 2, 1, 2, 2, 1, 2, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2],
[2, 1, 4, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 1, 5, 2, 1, 2, 2],
[1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 5, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2],   
[1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 2, 3, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 2],
[1, 2, 5, 2, 1, 1, 2, 1, 1, 2, 2, 1],
[2, 2, 1, 2, 2, 1, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 2, 1, 5, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2],
[1, 2, 1, 1, 5, 2, 1, 2, 2, 2, 1, 2],   
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 5, 1, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 2, 1, 5, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 1],
[2, 1, 2, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 6, 1, 2, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2],   
[2, 1, 2, 3, 2, 1, 1, 2, 1, 2, 2, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[2, 1, 2, 2, 1, 1, 2, 1, 1, 5, 2, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 2, 1, 2, 1, 2, 1, 1],
[2, 1, 2, 1, 2, 5, 2, 2, 1, 2, 1, 2],
[1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 1, 5, 1, 2, 2, 1, 2, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2],   
[1, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[1, 2, 5, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 1, 2, 5, 2, 1, 1, 2],
[1, 2, 1, 2, 2, 1, 2, 1, 2, 2, 1, 1],
[2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 3, 2, 2, 1, 2, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1],
[2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1],
[2, 2, 1, 5, 2, 1, 1, 2, 1, 2, 1, 2],   
[2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2],
[1, 5, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 1, 5, 2, 2, 1, 2, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2],
[2, 2, 1, 1, 5, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1],   
[2, 1, 2, 5, 2, 2, 1, 1, 2, 1, 2, 1],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 1, 2, 5, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 2, 1, 2, 4, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2],
[2, 1, 2, 5, 2, 1, 1, 2, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1],   
[2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2],
[1, 5, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 2, 1, 1, 5, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1],
[2, 2, 2, 1, 5, 1, 2, 1, 1, 2, 2, 1],
[2, 2, 1, 2, 2, 1, 1, 2, 1, 1, 2, 2],
[1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 5, 2, 1, 2, 2, 1, 2, 1, 2, 1],   
[2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 5, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 1, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2, 1],
[2, 2, 1, 2, 5, 2, 1, 2, 1, 2, 1, 1],
[2, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2],   
[1, 5, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2],
[2, 1, 2, 1, 1, 2, 3, 2, 1, 2, 2, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2],
[2, 1, 2, 2, 4, 1, 2, 1, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 2, 1, 2, 1, 1, 2, 1],
[2, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2, 1],
[1, 2, 4, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2, 2],   
[1, 2, 1, 1, 2, 1, 1, 5, 2, 2, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2],
[1, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[1, 2, 2, 1, 2, 4, 1, 1, 2, 1, 2, 1],
[2, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 1, 2, 2, 1, 1, 2, 1],
[2, 1, 2, 4, 2, 1, 2, 1, 2, 2, 1, 1],
[2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2, 1],
[2, 2, 3, 2, 1, 1, 2, 1, 2, 2, 2, 1],   
[2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1],
[2, 2, 1, 2, 1, 2, 3, 2, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2],
[1, 2, 1, 2, 5, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 1, 2, 2, 1, 2, 2, 1, 2],
[1, 2, 1, 5, 1, 2, 1, 2, 2, 2, 1, 2],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2],
[2, 1, 2, 1, 2, 1, 1, 5, 2, 1, 2, 2],   
[2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 1, 2, 2, 1, 5, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 1],
[2, 1, 2, 3, 2, 1, 2, 2, 2, 1, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 5, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[1, 2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2],   
[1, 2, 2, 2, 1, 2, 3, 2, 1, 1, 2, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 1, 6, 1, 2, 2, 1, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 5, 1, 2, 1, 1, 2, 2, 2, 1],
[2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1],
[2, 2, 2, 1, 2, 1, 1, 5, 1, 2, 2, 1],
[2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2, 1],   
[2, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1],
[1, 2, 2, 1, 2, 4, 2, 1, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 3, 2, 1, 1, 2, 2, 2, 1, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2],
[2, 5, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2, 1],
[2, 2, 1, 2, 2, 1, 5, 2, 1, 1, 2, 1]];

function myDate(year, month, day, leapMonth) {
    this.year = year;
    this.month = month;
    this.day = day;
    this.leapMonth = leapMonth;
}
//- 주 - 요일을 - 일로 바꿔주는 함수
function changeRepetitionToDate(repetition, solarYear) {
	var date = repetition.split('|');
	var year = date[0];
	if (solarYear != null && solarYear != '') {
		year = solarYear;
	}
	var month = date[1]; 
	var order = date[2];
	var day  = date[3];
	
	var resultDate = changeDayToDate(year, month, order, day);
	
	return resultDate;
}

function changeDayToDate(year, month, order, day) {
	//해당 년,월의 첫번째 날의 요일을 구한다.
	var firstDate = new Date(year + '/' + month + '/01');
	var firstDateDay = firstDate.getDay();
	var resultDay;
	
	if (day < firstDateDay) {
		order = parseInt(order) + 1;
		if (order == 5) {
			resultDay = (order - 1) * 7 + (day - firstDateDay) + 1;
			var resultDate = new Date(year + '/' + month + '/' + resultDay);
			
			return resultDate;
		}
	}
	
	//order > 4는 마지막주일때 계산
	if (order > 4) {
		var lastDateDay = getLastDateDay(year, month, day, firstDate);
		
		var totalDate = getTotalDate(year, month);
		
		if (day <= lastDateDay) {
			resultDay = totalDate + (day - lastDateDay);
		} else {
			resultDay = totalDate + (day - lastDateDay) - 7;
		}
	} else {
		resultDay = (order - 1) * 7 + (day - firstDateDay) + 1; 
	}
	
	var resultDate = new Date(year + '/' + month + '/' + resultDay);
		
	return resultDate;
}

// 이번달의 마지막일의 요일을 구하는 함수
function getLastDateDay(year, month, day, firstDate) {
	var firstDateDay = firstDate.getDay();
	var temp_Date = firstDate.getDate();
	var lastDay = firstDateDay; //시작요일을 저장하는 변수이다. 먼저 기본값으로 현재 요일을 저장한다.
	
	//먼저 당월에 대한 총 일수를 구한다. 위에서 선언한 메소드를 가지고 구한다.
	var totalDate = getTotalDate(year, month);
	lastDay = lastDay - 1;
	for(temp_Date ; temp_Date <= totalDate ; temp_Date++) { //시작값:현지 일자, 끝값 : 당월 마지막일
		lastDay++; // +1씩 증가
		if(lastDay > 6) //요일은 0부터 6까지 있기 때문에 6을 초과하면 0으로 초기화 해준다.(한바퀴)
		{
			lastDay = 0;
		}			
	}
	return lastDay;
}

function getTotalDate(year, month) {
	if(month.indexOf('0') == 0) {
		 month = month.substring(1);
	 }
	
	if(month==4 || month==6 || month==9 || month==11) {
		return 30;
	} else if(month==2) {
		if(year%4 == 0) { // 2월이면서 윤년일 때
			return 29;
		} else { // 2월이면서 윤년이 아닐 때
			return 28;
		}			
	} else {
		return 31;
	}
}