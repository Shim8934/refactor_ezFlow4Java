var defaultView = 0; // 달력 시작 일 (일 = 0, 월 = 1)
var sDate = new Date();
var startDate; // 아직까지 왜 두는지 모르겟음
var dayOfWeeks;

var monthHeight = ((parseInt(document.documentElement.clientHeight, 10) - 260) / 6) - 11;
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
	
	var objElm = document.getElementById(pTargetID);
	if (objElm) {
		objElm.innerHTML = "";
		//상단 달력 navi
		var oTable = document.createElement("TABLE");
		var oTBody = document.createElement("TBODY");
		var oTr = document.createElement("TR");
		var oTh = document.createElement("TH");
		oTable.setAttribute("cellpadding","0");
		oTable.setAttribute("cellspacing","0");
		oTable.setAttribute("border","0");
		oTable.setAttribute("width","100%");
		oTh.setAttribute("id","calTitle");
		oTh.colSpan = "2";
		
		oTable.className = "calendar_month_navi";
		var dayText = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2);
		
		// 이전 달로 이동하는 버튼 생성
		var mSpan = document.createElement("SPAN");
		mSpan.className = "btn_prev";
		var mImg = document.createElement("IMG");
		mImg.setAttribute("src", "/images/calendar/btn_calendar_mini_prev.gif");
		mImg.setAttribute("border", "0");
		mImg.setAttribute("onclick", "");
		
		mSpan.appendChild(mImg);
		oTh.appendChild(mSpan);
		
		// 년-월 을 보여주는 textNode 생성
		var oText = document.createTextNode(" " + dayText + " ");
		oTh.appendChild(oText);
		
		// 다음 달로 이동하는 버튼 생성
		var mSpan = document.createElement("SPAN");
		mSpan.className = "btn_next";
		var mImg = document.createElement("IMG");
		mImg.setAttribute("src", "/images/calendar/btn_calendar_mini_next.gif");
		mImg.setAttribute("border", "0");
		mImg.setAttribute("onclick", "");
		
		mSpan.appendChild(mImg);
		oTh.appendChild(mSpan);
		oTBody.appendChild(oTh);
		
		// calendar navi append
		oTable.appendChild(oTBody);
		objElm.appendChild(oTable);
		
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
	}
	
	//CalViewSource(); //달력에 근태 데이터 뿌리면 되고
	
}

/**
 * tBody td로 month 반환
 */
function getMonthBodyObj() {
	// 지금은 test라 sData가지고 하는데 navi에 있는 걸로 해야된다.
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
	oThisMonth = oThisDate.getMonth() + 1;
	
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
		if (defaultView == 0 && j == 0 || defaultView == 1 && j == 6) {
			objTh.className = "sun";
			className = "sun";
		} else if (defaultView == 0 && j == 6 || defaultView == 1 && j == 5) {
			objTh.className = "sat";
			className = "sat";
		}
		
		objTh.appendChild(oText);
		objTr.appendChild(objTh);
		objTh = null;
	}
	oTbody.appendChild(objTr);
	
	// 달력에 일자 데이터를 넣어주기 위해 oBeforeDate를 oThisDate를 넣는다.
	//oBeforeMaxDay가 0이면 안넣어 주는 이유는 이전 달의 데이터가 필요가 없으므로 안넣어 줘도 된다.
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

function monthDate(oThisDate, TDIndex) {
	var objTd = document.createElement("TD");
	
	//매달 1일에는 x월 1일 을 표시해주기 위해
	if (oThisDate.getDate() == "1") {
		var pDateData = (oThisDate.getMonth() + 1) + strLang122 + " " + oThisDate.getDate() + strLang123;
	} else {
		var pDateData = oThisDate.getDate();
	}
	
	//이전 달의 요일을 구분하기 위해 다른 클래스를 적용
	var className = "";
	if (oThisMonth != oThisDate.getMonth()) {
		className = " gray";
	} else if (oThisDate.getDay() == 0) {
		className = " sun";
	} else if (oThisDate.getDay() == 6) {
		className = " sat";
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
    
    subTd.innerHTML = pDateData;
    
    subTr.appendChild(subTd);
    subTable.appendChild(subTr);
    objTd.appendChild(subTable);
    
    var subSpan = document.createElement("SPAN");
    var subTable = document.createElement("TABLE");
    subSpan.className = "span_list";
    
    if (monthHeight < 50) {
    	monthHeight = 70;
    }
    
    subSpan.style.height = monthHeight + "px"
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