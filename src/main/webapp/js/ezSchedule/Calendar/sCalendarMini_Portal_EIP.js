var sStartDate, sEndDate;
var DefaultView = 0;
var sDate = new Date();

//리스트뷰 바디 생성
var oBeforeDate, oThisDate;
var oThisMonth;

var g_selDivID = null;
var g_selTRID = null;
var g_selTDID = null;
var g_selTRIDTOP = null;
var g_selTDIDTOP = null;
var dayOfWeeks;
var typeCal = 0;


var idtype = "T";
var idlist = "";
var groupid = "";
var firstYN = false;

var nowDate = new Date();

if (typeof UserOffset !== 'undefined' && UserOffset) {
	var _timez = nowDate.getTime() + (nowDate.getTimezoneOffset() * 60000) + (parseInt(UserOffset.split(':')[0]) * 3600000);
	nowDate.setTime(_timez);	
}

var nowDay = (nowDate.getFullYear()) + "-" + leadingZeros((nowDate.getMonth() + 1), 2) + "-" + leadingZeros(nowDate.getDate(), 2);

function CalendarMiniView(pTagetID) {
	
	document.getElementById(pTagetID).innerHTML = "";
	var objElm = document.getElementById(pTagetID);
	
	if (pTagetID == "CalendarMini") {
		//Portlet
		
		if (objElm) {
	        var mTable = document.createElement("TABLE");
	        mTable.className = "scalendar_mini_title";///
	        mTable.setAttribute("id", "MiniCalendar")
	        mTable.setAttribute("cellpadding", "0");
	        mTable.setAttribute("cellspacing", "0");
	        mTable.setAttribute("border", "0");
	        mTable.setAttribute("width", "100%");
	        var mTr = document.createElement("TR");

	        var mTd = document.createElement("TD");
	        mTd.className = "btn_prev"
        	mTd.setAttribute("style","position: relative; z-index: 999;");
	        var mSpan = document.createElement("SPAN");
	        mSpan.style.cursor = "pointer";
	        //mSpan.style.marginLeft = "6px";
	        //mSpan.style.marginTop = "4px";
	        var mImg = document.createElement("IMG");
	        mImg.setAttribute("src", "/images/ezNewPortal/calender_pre.png");///
	        mImg.setAttribute("border", "0");
			mSpan.setAttribute("onclick", "preMonth()");
	        mSpan.appendChild(mImg);
	        mTd.appendChild(mSpan);
	        mTr.appendChild(mTd);

	        var mTd = document.createElement("TD");
	        mTd.className = "calendar_mini_day"
	        
	        var mSel = document.createElement("SELECT");
	 		mSel.style.display = "none";///
	        mSel.setAttribute("name", "iYear");
	        mSel.setAttribute("id", "iYear");
	        mSel.setAttribute("onchange", "changeYear()");

	        var curYear = sDate.getFullYear() + 3;
	        for (var i = curYear; i >= curYear - 6; i--) {
	            var mOpt = document.createElement("OPTION");
	            mOpt.setAttribute("Value", i);

	            if ((curYear - 3) == i)
	                mOpt.setAttribute("selected", "");

	            var mText = document.createTextNode(i);
	            mOpt.appendChild(mText);
	            mSel.appendChild(mOpt);
	        }

	        mTd.appendChild(mSel);

	        var mSel = document.createElement("SELECT");
	        mSel.style.marginLeft = "10px";
	        mSel.style.display = "none";///
	        mSel.setAttribute("name", "iMon");
	        mSel.setAttribute("id", "iMon");
	        mSel.setAttribute("onchange", "changeMonth()");

	        var curMonth = sDate.getMonth() + 1;
	        for (var j = 1; j <= 12; j++) {

	            var mOpt = document.createElement("OPTION");
	            mOpt.setAttribute("Value", j);

	            if (curMonth == j)
	                mOpt.setAttribute("selected", "");

	            var mText = document.createTextNode(j);
	            mOpt.appendChild(mText);
	            mSel.appendChild(mOpt);
	        }       
	        mTd.appendChild(mSel);
	        
	        var iySpan = document.createElement("SPAN");
	        iySpan.setAttribute("id", "iYear");

	        var curYear = sDate.getFullYear();
	        var yText = document.createTextNode(curYear);
	        iySpan.appendChild(yText);

	        mTd.appendChild(iySpan);

	        var dotText = document.createTextNode(".");
	        mTd.appendChild(dotText);

	        var imSpan = document.createElement("SPAN");//년 월 select박스인것 바꿔야할듯
	        imSpan.setAttribute("id", "iMon");

	        var curMonth = sDate.getMonth() + 1;
	        var mText = document.createTextNode(curMonth);
	        imSpan.appendChild(mText);
	        
	        mTd.appendChild(imSpan);
	        mTr.appendChild(mTd);

	        var mTd = document.createElement("TD");
	        mTd.className = "btn_next"
        	mTd.setAttribute("style","position: relative; z-index: 999;");
	        var mSpan = document.createElement("SPAN");
	        mSpan.style.cursor = "pointer";
	        //mSpan.style.marginRight = "6px";
	        //mSpan.style.marginTop = "4px";
	        var mImg = document.createElement("IMG");
	        mImg.setAttribute("src", "/images/ezNewPortal/calender_next.png");///
	        mImg.setAttribute("border", "0");
			mSpan.setAttribute("onclick", "nextMonth()");
	        mSpan.appendChild(mImg);
	        mTd.appendChild(mSpan);
	        mTr.appendChild(mTd);


	        mTable.appendChild(mTr);
	        objElm.appendChild(mTable);

	        var oTable = document.createElement("TABLE");

	        oTable.setAttribute("id", "");
	        oTable.setAttribute("cellpadding", "0");
	        oTable.setAttribute("cellspacing", "0");
	        oTable.setAttribute("border", "0");
	        oTable.setAttribute("width", "100%");
	        oTable.className = "scalendar_mini";

	        var oTBody = GetTableMiniBodyObj();
	        oTable.appendChild(oTBody);
	        objElm.appendChild(oTable);
	    }
		
	} else if (pTagetID == "CalendarMini_Top") {
		//Top
		if (objElm) {
	        var mTable = document.createElement("TABLE");
	        mTable.className = "scalendar_mini_title";///
	        mTable.setAttribute("id", "MiniCalendar_Top")
	        mTable.setAttribute("cellpadding", "0");
	        mTable.setAttribute("cellspacing", "0");
	        mTable.setAttribute("border", "0");
//	        mTable.setAttribute("width", "100%");
	        var mTr = document.createElement("TR");

	        var mTd = document.createElement("TD");
	        mTd.className = "btn_prev"
	        var mSpan = document.createElement("SPAN");
	        mSpan.style.cursor = "pointer";
	        mSpan.setAttribute("onclick", "preMonthTop()");
	        var mImg = document.createElement("IMG");
	        mImg.setAttribute("src", "/images/ezNewPortal/calender_pre.png");///
	        mImg.setAttribute("border", "0");
	        mSpan.appendChild(mImg);
	        mTd.appendChild(mSpan);
	        mTr.appendChild(mTd);

	        var mTd = document.createElement("TD");
	        mTd.className = "calendar_mini_day"
	        
	        var mSel = document.createElement("SELECT");
	 		mSel.style.display = "none";///
	        mSel.setAttribute("name", "iYear");
	        mSel.setAttribute("id", "iYearTop");
	        mSel.setAttribute("onchange", "changeYearTop()");

	        var curYear = sDate.getFullYear() + 3;
	        for (var i = curYear; i >= curYear - 6; i--) {
	            var mOpt = document.createElement("OPTION");
	            mOpt.setAttribute("Value", i);

	            if ((curYear - 3) == i)
	                mOpt.setAttribute("selected", "");

	            var mText = document.createTextNode(i);
	            mOpt.appendChild(mText);
	            mSel.appendChild(mOpt);
	        }

	        mTd.appendChild(mSel);

	        var mSel = document.createElement("SELECT");
	        mSel.style.marginLeft = "10px";
	        mSel.style.display = "none";///
	        mSel.setAttribute("name", "iMon");
	        mSel.setAttribute("id", "iMonTop");
	        mSel.setAttribute("onchange", "changeMonthTop()");

	        var curMonth = sDate.getMonth() + 1;
	        for (var j = 1; j <= 12; j++) {

	            var mOpt = document.createElement("OPTION");
	            mOpt.setAttribute("Value", j);

	            if (curMonth == j)
	                mOpt.setAttribute("selected", "");

	            var mText = document.createTextNode(j);
	            mOpt.appendChild(mText);
	            mSel.appendChild(mOpt);
	        }       
	        mTd.appendChild(mSel);
	        
	        var iySpan = document.createElement("SPAN");
	        iySpan.setAttribute("id", "iYearTop");

	        var curYear = sDate.getFullYear();
	        var yText = document.createTextNode(curYear);
	        iySpan.appendChild(yText);

	        mTd.appendChild(iySpan);

	        var dotText = document.createTextNode(".");
	        mTd.appendChild(dotText);

	        var imSpan = document.createElement("SPAN");//년 월 select박스인것 바꿔야할듯
	        imSpan.setAttribute("id", "iMonTop");

	        var curMonth = sDate.getMonth() + 1;
	        var mText = document.createTextNode(curMonth);
	        imSpan.appendChild(mText);
	        
	        mTd.appendChild(imSpan);
	        mTr.appendChild(mTd);

	        var mTd = document.createElement("TD");
	        mTd.className = "btn_next"
	        var mSpan = document.createElement("SPAN");
	        mSpan.style.cursor = "pointer";
	        mSpan.setAttribute("onclick", "nextMonthTop()");
	        var mImg = document.createElement("IMG");
	        mImg.setAttribute("src", "/images/ezNewPortal/calender_next.png");///
	        mImg.setAttribute("border", "0");
	        mSpan.appendChild(mImg);
	        mTd.appendChild(mSpan);
	        mTr.appendChild(mTd);


	        mTable.appendChild(mTr);
	        objElm.appendChild(mTable);

	        var oTable = document.createElement("TABLE");

	        oTable.setAttribute("id", "");
	        oTable.setAttribute("cellpadding", "0");
	        oTable.setAttribute("cellspacing", "0");
	        oTable.setAttribute("border", "0");
	        oTable.setAttribute("width", "100%");
	        oTable.className = "scalendar_mini";

	        var oTBody = GetTableMiniBodyObjTop();
	        oTable.appendChild(oTBody);
	        objElm.appendChild(oTable);
	    }
	}
}

function GetTableMiniBodyObj() {
    var year = document.getElementById("iYear").value;
    var month = parseInt(document.getElementById("iMon").value);

    if (DefaultView == 0)
        dayOfWeeks = strLang5_1; // 일>토
    else if (DefaultView == 1)
        dayOfWeeks = strLang6_1; // 월>일

    oBeforeDate = new Date(new Date(year, month - 1, 1) - 86400000);  // 이전달
    oThisDate = new Date(year, month - 1, 1); // 현재달
    oBeforeDate.setTime(oBeforeDate.getTime() + (oBeforeDate.getTimezoneOffset() + (oBeforeDate.getHours() * 60) + oBeforeDate.getMinutes()) * 60 * 1000);
    oThisDate.setTime(oThisDate.getTime() + (oThisDate.getTimezoneOffset() + (oThisDate.getHours() * 60) + oThisDate.getMinutes()) * 60 * 1000);

    var oBeforeMaxDay = oBeforeDate.getDate();
    var startThisDay = oThisDate.getDay();
    oThisMonth = oBeforeDate.getMonth() + 1;

    if (oThisMonth == 12) {
        oThisMonth = 0;
    }

    oBeforeDate.setDate(oBeforeMaxDay - startThisDay + 1 + DefaultView); // 월의 시작일 지정

    var oTbody = document.createElement("TBODY");
    var objTr = document.createElement("TR");

    // day of the week Start
    for (var j = 0; j < 7; j++) {
        var objTD = document.createElement("TH");
        objTD.setAttribute("scope", "col");

        if (DefaultView == 0 && j == 0)
            objTD.className = "sun";
        else if (DefaultView == 0 && j == 6)
            objTD.className = "sat";

        if (DefaultView == 1 && j == 6)
            objTD.className = "sun";
        else if (DefaultView == 1 && j == 5)
            objTD.className = "sat";

        var oText = document.createTextNode(dayOfWeeks.split(";")[j]);
        objTD.appendChild(oText);
        objTr.appendChild(objTD);
        objTD = null;
    }
    oTbody.appendChild(objTr);
    // day of the week End
    if (oBeforeMaxDay != 0) {
        oThisDate = oBeforeDate;
    }
    sStartDate = oThisDate.getFullYear() + "-" + (oThisDate.getMonth() + 1) + "-" + oThisDate.getDate();

    //Month Start
    for (var i = 0; i < 6; i++) {
        var objTr = document.createElement("TR");
        objTr.setAttribute("id", "TR_" + oThisMonth + "_" + i);

        for (var j = 0; j < 7; j++) {
            var objTD = MonthMiniData(oThisDate);
          //2018-12-31 mini holiday push
            var tempyear = oThisDate.getFullYear();
            if (tempyear > 1800 && tempyear <= 2101) {
                var oThisDate2 = new Date(oThisDate.getFullYear(), oThisDate.getMonth(), oThisDate.getDate());
                oThisDate2.setDate(oThisDate2.getDate() - 1);
                var month = oThisDate2.getMonth() + 1;
                LunarDate = lunarCalc(oThisDate2.getFullYear(), month, oThisDate2.getDate(), 1);

                var memorial = memorialDayCheck(oThisDate2, LunarDate);
                var yearmemorial = yearmemorialDayCheck(oThisDate2, LunarDate);

                var isholiday = false;
                for (var k = 0; k < memorial.length; k++) {
                    if (memorial[k].holiday)
                        isholiday = true;
                }
                for (var k = 0; k < yearmemorial.length; k++) {
                    if (yearmemorial[k].holiday)
                        isholiday = true;
                }
                if (objTD.className != " gray" && isholiday) {
                	if (objTD.className == "today") {
                		objTD.className = "todaysun";
                	} else {
                		objTD.className = " sun";
                	}
                }
            }
            objTr.appendChild(objTD);
            objTD = null;
        }
        oTbody.appendChild(objTr);
    }
    //Month End
    oThisDate.setDate(oThisDate.getDate() - 1);
    sEndDate = oThisDate.getFullYear() + "-" + (oThisDate.getMonth() + 1) + "-" + oThisDate.getDate();
    objTr = null;

    return oTbody;
}

// 그냥 Top 전용함수 똑같은거 하나 더 만듬
function GetTableMiniBodyObjTop() {
    var year = document.getElementById("iYearTop").value;
    var month = parseInt(document.getElementById("iMonTop").value);

    if (DefaultView == 0)
        dayOfWeeks = strLang5_1; // 일>토
    else if (DefaultView == 1)
        dayOfWeeks = strLang6_1; // 월>일

    oBeforeDate = new Date(new Date(year, month - 1, 1) - 86400000);  // 이전달
    oThisDate = new Date(year, month - 1, 1); // 현재달
    oBeforeDate.setTime(oBeforeDate.getTime() + (oBeforeDate.getTimezoneOffset() + (oBeforeDate.getHours() * 60) + oBeforeDate.getMinutes()) * 60 * 1000);
    oThisDate.setTime(oThisDate.getTime() + (oThisDate.getTimezoneOffset() + (oThisDate.getHours() * 60) + oThisDate.getMinutes()) * 60 * 1000);

    var oBeforeMaxDay = oBeforeDate.getDate();
    var startThisDay = oThisDate.getDay();
    oThisMonth = oBeforeDate.getMonth() + 1;

    if (oThisMonth == 12) {
        oThisMonth = 0;
    }

    oBeforeDate.setDate(oBeforeMaxDay - startThisDay + 1 + DefaultView); // 월의 시작일 지정

    var oTbody = document.createElement("TBODY");
    var objTr = document.createElement("TR");
    
    /* 2023-06-05 홍승비 - 포탈 홈 > 디자인 개선을 위해  테마2에서 사용되는 미니캘린더 영역의 요일 표기 숨김처리 (id 부여 후 .css 파일로 조정) */
    objTr.setAttribute("id", "scalendarMini_dayOfWeek");

    // day of the week Start
    for (var j = 0; j < 7; j++) {
        var objTD = document.createElement("TH");
        objTD.setAttribute("scope", "col");

        if (DefaultView == 0 && j == 0)
            objTD.className = "sun";
        else if (DefaultView == 0 && j == 6)
            objTD.className = "sat";

        if (DefaultView == 1 && j == 6)
            objTD.className = "sun";
        else if (DefaultView == 1 && j == 5)
            objTD.className = "sat";

        var oText = document.createTextNode(dayOfWeeks.split(";")[j]);
        objTD.appendChild(oText);
        objTr.appendChild(objTD);
        objTD = null;
    }
    oTbody.appendChild(objTr);
    // day of the week End
    if (oBeforeMaxDay != 0) {
        oThisDate = oBeforeDate;
    }
    sStartDate = oThisDate.getFullYear() + "-" + (oThisDate.getMonth() + 1) + "-" + oThisDate.getDate();

    //Month Start
    for (var i = 0; i < 6; i++) {
        var objTr = document.createElement("TR");
        //이거 그냥 이름정해놓고 그대로 갖다 쓰는거 같은데 TR뒤에 TOP만 붙여봄
        objTr.setAttribute("id", "TR_TOP" + oThisMonth + "_" + i);

        for (var j = 0; j < 7; j++) {
            var objTD = MonthMiniDataTop(oThisDate);
          //2018-12-31 mini holiday push
            var tempyear = oThisDate.getFullYear();
            if (tempyear > 1800 && tempyear <= 2101) {
                var oThisDate2 = new Date(oThisDate.getFullYear(), oThisDate.getMonth(), oThisDate.getDate());
                oThisDate2.setDate(oThisDate2.getDate() - 1);
                var month = oThisDate2.getMonth() + 1;
                LunarDate = lunarCalc(oThisDate2.getFullYear(), month, oThisDate2.getDate(), 1);

                var memorial = memorialDayCheck(oThisDate2, LunarDate);
                var yearmemorial = yearmemorialDayCheck(oThisDate2, LunarDate);

                var isholiday = false;
                for (var k = 0; k < memorial.length; k++) {
                    if (memorial[k].holiday)
                        isholiday = true;
                }
                for (var k = 0; k < yearmemorial.length; k++) {
                    if (yearmemorial[k].holiday)
                        isholiday = true;
                }
                if (objTD.className != " gray" && isholiday) {
                	if (objTD.className == "main_today") {
                		objTD.className = "main_todaysun";
                	} else {
                		objTD.className = " sun";
                	}
                }
            }
            objTr.appendChild(objTD);
            objTD = null;
        }
        oTbody.appendChild(objTr);
    }
    //Month End
    oThisDate.setDate(oThisDate.getDate() - 1);
    sEndDate = oThisDate.getFullYear() + "-" + (oThisDate.getMonth() + 1) + "-" + oThisDate.getDate();
    objTr = null;

    return oTbody;
}


// 선택한 월의 날짜 입력 시작
function MonthMiniData(oThisDate) {

    var objTd = document.createElement("TD");

    var divID = (oThisDate.getFullYear()) + "-" + leadingZeros((oThisDate.getMonth() + 1), 2) + "-" + leadingZeros(oThisDate.getDate(), 2);

    var className = "";
    if (divID == nowDay) {
        className = "today";  // 현재일
    }

    var oDiv = document.createElement("DIV");
    //이건 This라서 그대로 써도 될것같다
    oDiv.setAttribute("onclick", "DayOnMouseClick(this);");
//    oDiv.setAttribute("ondblclick", "MonthMiniDbClick()");

    var pDateData = oThisDate.getDate()


    if (oThisMonth != oThisDate.getMonth()) // 현재월 이외의 날
    {
        objTd.className = "gray";
        className += " gray";
    }
    else if (oThisDate.getDay() == 0)  // 일요일
        className += " sun";
    else if (oThisDate.getDay() == 6)  // 토요일
        className += " sat";

    objTd.className = className;
    oDiv.innerHTML = pDateData;
    oDiv.setAttribute("id", "TDMINI_" + divID + "_Day");
    oDiv.setAttribute("dispDate", divID);
    objTd.innerHTML = oDiv.outerHTML;
    oThisDate.setDate(oThisDate.getDate() + 1);
    return objTd;
}// 선택한 월의 날짜 입력 완료

//선택한 월의 날짜 입력 시작
function MonthMiniDataTop(oThisDate) {

    var objTd = document.createElement("TD");

    var divID = (oThisDate.getFullYear()) + "-" + leadingZeros((oThisDate.getMonth() + 1), 2) + "-" + leadingZeros(oThisDate.getDate(), 2);

    var className = "";
    if (divID == nowDay) {
        className = "main_today";  // 현재일
    }

    var oDiv = document.createElement("DIV");
    oDiv.setAttribute("onclick", "DayOnMouseClickTop(this);");
//    oDiv.setAttribute("ondblclick", "MonthMiniDbClick()");

    var pDateData = oThisDate.getDate()


    if (oThisMonth != oThisDate.getMonth()) // 현재월 이외의 날
    {
        objTd.className = "gray";
        className += " gray";
    }
    else if (oThisDate.getDay() == 0)  // 일요일
        className += " sun";
    else if (oThisDate.getDay() == 6)  // 토요일
        className += " sat";

    objTd.className = className;
    oDiv.innerHTML = pDateData;
    //이거 그냥 이름정해놓고 그대로 갖다 쓰는거 같은데 TDMINI뒤에 TOP만 붙여봄
    oDiv.setAttribute("id", "TDMINITOP_" + divID + "_Day");
    oDiv.setAttribute("dispDate", divID);
    objTd.innerHTML = oDiv.outerHTML;
    oThisDate.setDate(oThisDate.getDate() + 1);
    return objTd;
}// 선택한 월의 날짜 입력 완료

//자원데이터에 마우스 클릭시
function DayOnMouseClick(event) {
    if (!event) event = window.event;
	
	// 2023-10-13 황인경 - 디자인 개선 > 포탈 > 테마2 > 상단 캘린더일 경우
    if ($("#CalendarMini_Top").length > 0) {
    	if ($("#"+g_selTDID)) {
    		$("#"+g_selTDID).css("background-color", "").css("color", "");
    	}
    	if ($("#"+g_selTRID)) {
    		$("#"+g_selTRID).css("background-color", "").css("color", "");
    	}
    } else {
    	if ($("#"+g_selTDID)) {
    		$("#"+g_selTDID).parent().css("background-color", "").css("color", "");
    	}
    	if ($("#"+g_selTRID)) {
			$("#"+g_selTRID).parent().css("background-color", "").css("color", "");
    	}
    }
    
    
    /*if (document.getElementById(g_selTDID))
        document.getElementById(g_selTDID).style.backgroundColor = "";
    if (document.getElementById(g_selTRID))
        document.getElementById(g_selTRID).style.backgroundColor = "";*/   
 
    //document.getElementById(event.getAttribute("id")).style.backgroundColor = "#f0f6ff";
    if ($("#CalendarMini_Top").length > 0) {
    	// if ($("#"+event.getAttribute("id")).parent().attr('class').indexOf('sun') > -1) {
    	// 	$("#"+event.getAttribute("id")).css("background","#f0f6ff").css("color","red");
    	// } else {
    	// 	$("#"+event.getAttribute("id")).css("background","#f0f6ff").css("color","black");
    	// }
		$("#CalendarMini .scalendar_mini td").removeClass("select");
		$("#"+event.getAttribute("id")).parent().addClass("select");
    } else {
    	if ($("#"+event.getAttribute("id")).parent().attr('class').indexOf('sun') > -1) {
    		$("#"+event.getAttribute("id")).parent().css("background","#f0f6ff").css("color","red");
    	} else {
    		$("#"+event.getAttribute("id")).parent().css("background","#f0f6ff").css("color","black");
    	}
    }
	//$("#"+event.getAttribute("id")).parent().css("border-radius","20px");
	
    g_selTRID = event.parentNode.parentNode.getAttribute("id");
    g_selTDID = event.getAttribute("id");

    var sDate = event.getAttribute("id").substring(7, 17);
    date = sDate;
    getScheduleList(date, pMode);
        
}

//자원데이터에 마우스 클릭시
function DayOnMouseClickTop(event) {
    if (!event) event = window.event;

    if ($("#CalendarMini_Top").length > 0) {
    	if ($("#"+g_selTDIDTOP)) {
    		$("#"+g_selTDIDTOP).css("background-color", "").css("color", "");
    	}
    	if ($("#"+g_selTRIDTOP)) {
    		$("#"+g_selTRIDTOP).css("background-color", "").css("color", "");
    	}
    } else {
    	if ($("#"+g_selTDIDTOP)) {
    		$("#"+g_selTDIDTOP).parent().css("background-color", "").css("color", "");
    	}
    	if ($("#"+g_selTRIDTOP)) {
    		$("#"+g_selTRIDTOP).parent().css("background-color", "").css("color", "");
    	}
    	
    }

    /*if (document.getElementById(g_selTDID))
        document.getElementById(g_selTDID).style.backgroundColor = "";
    if (document.getElementById(g_selTRID))
        document.getElementById(g_selTRID).style.backgroundColor = "";*/   
 
    //document.getElementById(event.getAttribute("id")).style.backgroundColor = "#f0f6ff";
    if ($("#CalendarMini_Top").length > 0) {
    	// if ($("#"+event.getAttribute("id")).parent().attr('class').indexOf('sun') > -1) {
    	// 	$("#"+event.getAttribute("id")).css("background","#f0f6ff").css("color","red");
    	// } else {
    	// 	$("#"+event.getAttribute("id")).css("background","#f0f6ff").css("color","black");
    	// }
		$("#CalendarMini_Top .scalendar_mini td").removeClass("select");
		$("#"+event.getAttribute("id")).parent().addClass("select");
    } else {
    	if ($("#"+event.getAttribute("id")).parent().attr('class').indexOf('sun') > -1) {
    		$("#"+event.getAttribute("id")).parent().css("background","#f0f6ff").css("color","red");
    	} else {
    		$("#"+event.getAttribute("id")).parent().css("background","#f0f6ff").css("color","black");
    	}
    	
    }
	
    g_selTRIDTOP = event.parentNode.parentNode.getAttribute("id");
    g_selTDIDTOP = event.getAttribute("id");
    var sDate = event.getAttribute("id").substring(10, 20);
    date = sDate;
    getScheduleList_Top(date, pMode);
        
}

var delFlag = false;

function CalendarMiniDataSource(Type) {
	if (Type == null || Type == "") {
		if (!document.getElementById("MiniCalendar")) {
			return;
		}
	} else if (Type == "Top") {
		if (!document.getElementById("MiniCalendar_Top")) {
			return;
		}
    }
    
    $.ajax({
		type : "POST",
		dataType : "json",
		async : (!delFlag ? true : false),
		url : "/ezNewPortal/getScheduleList.do",
		data : {
			STARTDATE : sStartDate,
			ENDDATE : sEndDate,
			APP : "0",
			GROUPID : groupid,
			IDLIST : (idlist == "") ? 'T' : idlist
		},
		success: function(json){
			if (Type == null || Type == "") {
				getCalendarMiniDataSource_after(json.resultList);
				delFlag = false;
			} else if (Type == "Top") {
				getCalendarMiniDataSourceTop_after(json.resultList);
				delFlag = false;
		    }
		}
    }); 
}

function sTempData() {
}

function dateDiff(_date1, _date2) {
    var diffDate_1 = _date1 instanceof Date ? _date1 : new Date(_date1);
    var diffDate_2 = _date2 instanceof Date ? _date2 : new Date(_date2);
 
    diffDate_1 = new Date(diffDate_1.getFullYear(), diffDate_1.getMonth()+1, diffDate_1.getDate());
    diffDate_2 = new Date(diffDate_2.getFullYear(), diffDate_2.getMonth()+1, diffDate_2.getDate());
 
    var diff = Math.abs(diffDate_2.getTime() - diffDate_1.getTime());
    diff = Math.ceil(diff / (1000 * 3600 * 24));
 
    return diff;
}

function getCalendarMiniDataSource_after(resultList) {
    var tempData = new Array();
    var k = 0;
    
    $.each(resultList, function(idx, item) {
    	var _Dtstart = item.startDate;
    	var _Dtend = item.endDate;
    	var DataSDT = new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7)) - 1, parseInt(_Dtstart.substring(8, 10)), parseInt(_Dtstart.substring(11, 13)), parseInt(_Dtstart.substring(14, 16)));
    	var DataEDT = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7)) - 1, parseInt(_Dtend.substring(8, 10)), parseInt(_Dtend.substring(11, 13)), parseInt(_Dtend.substring(14, 16)));
    	OrgDataSDT = new Date(DataSDT);
        OrgDataEDT = new Date(DataEDT);
        
        var diff = Math.abs(OrgDataEDT.getTime() - OrgDataSDT.getTime());
        diff = Math.ceil(diff / (1000 * 3600 * 24)); 
    	
    	if (_Dtstart.substring(0, 10) != _Dtend.substring(0, 10)) { // 반복일정
    		
    		var betweenDay = new Date(_Dtend.substring(0, 10)) - new Date(_Dtstart.substring(0, 10));
    		var day = 1000 * 60 * 60 * 24;
    		betweenDay = parseInt(betweenDay / day, 10);
    		if (_Dtend.substring(10) == " 00:00:00.0") {
            	betweenDay = betweenDay - 1;
            }
    		
    		for (var j = 0; j <= betweenDay; j++) {
    			
    			var trID = DataSDT.getFullYear() + "-" + leadingZeros(parseInt(DataSDT.getMonth() + 1), 2, 10) + "-" + leadingZeros(DataSDT.getDate(), 2);
    			tempData[k] = new sTempData();
    			tempData[k].trID = trID;
    			
    			MiniDataBind(tempData[k]);
    			DataSDT.setDate(DataSDT.getDate() + 1);
    			k += 1;
    		}
    	} else {
    		var trID = DataSDT.getFullYear() + "-" + leadingZeros(parseInt(DataSDT.getMonth() + 1), 2, 10) + "-" + leadingZeros(DataSDT.getDate(), 2);
    		tempData[k] = new sTempData();
    		tempData[k].trID = trID;
    		
    		MiniDataBind(tempData[k]);
    		k += 1;
    	}
    	DataSDT = null;
    	DataEDT = null;
    })
    tempData = null;
}

function getCalendarMiniDataSourceTop_after(resultList) {
    var tempData = new Array();
    var k = 0;
    
    $.each(resultList, function(idx, item) {
    	var _Dtstart = item.startDate;
    	var _Dtend = item.endDate;
    	var DataSDT = new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7)) - 1, parseInt(_Dtstart.substring(8, 10)), parseInt(_Dtstart.substring(11, 13)), parseInt(_Dtstart.substring(14, 16)));
    	var DataEDT = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7)) - 1, parseInt(_Dtend.substring(8, 10)), parseInt(_Dtend.substring(11, 13)), parseInt(_Dtend.substring(14, 16)));
    	OrgDataSDT = new Date(DataSDT);
        OrgDataEDT = new Date(DataEDT);
        
        var diff = Math.abs(OrgDataEDT.getTime() - OrgDataSDT.getTime());
        diff = Math.ceil(diff / (1000 * 3600 * 24));     	
    	
    	if (_Dtstart.substring(0, 10) != _Dtend.substring(0, 10)) { // 반복일정
    		
    		var betweenDay = new Date(_Dtend.substring(0, 10)) - new Date(_Dtstart.substring(0, 10));
    		var day = 1000 * 60 * 60 * 24;
    		betweenDay = parseInt(betweenDay / day, 10);
    		if (_Dtend.substring(10) == " 00:00:00.0") {
    			betweenDay = betweenDay - 1;
            }
    		
    		for (var j = 0; j <= betweenDay; j++) {
    			
    			var trID = DataSDT.getFullYear() + "-" + leadingZeros(parseInt(DataSDT.getMonth() + 1), 2, 10) + "-" + leadingZeros(DataSDT.getDate(), 2);
    			tempData[k] = new sTempData();
    			tempData[k].trID = trID;
    			
    			MiniDataBindTop(tempData[k]);
    			DataSDT.setDate(DataSDT.getDate() + 1);
    			k += 1;
    		}
    	} else {
    		var trID = DataSDT.getFullYear() + "-" + leadingZeros(parseInt(DataSDT.getMonth() + 1), 2, 10) + "-" + leadingZeros(DataSDT.getDate(), 2);
    		tempData[k] = new sTempData();
    		tempData[k].trID = trID;
    		
    		MiniDataBindTop(tempData[k]);
    		k += 1;
    	}
    	DataSDT = null;
    	DataEDT = null;
    })
    tempData = null;
}

function MiniDataBind(oAppointment) {
    var objElm = document.getElementById("TDMINI_" + oAppointment.trID + "_Day");
    if (objElm) {
//        objElm.style.fontWeight = "bold"
    	if ($("#"+"TDMINI_" + oAppointment.trID + "_Day").parent().children(".dataHave").length > 0) {
    		return;
    	} else {
    		$("#"+"TDMINI_" + oAppointment.trID + "_Day").parent().append("<div class='dataHave' style='height:1px;line-height:1px;background:none;' onclick='clickDay(\"TDMINI_" + oAppointment.trID + "_Day\")'>·</div>");
    	}
    }
}

function MiniDataBindTop(oAppointment) {
    var objElm = document.getElementById("TDMINITOP_" + oAppointment.trID + "_Day");
    if (objElm) {
//        objElm.style.fontWeight = "bold"
    	if ($("#"+"TDMINITOP_" + oAppointment.trID + "_Day").parent().children(".dataHave").length > 0) {
    		return;
    	} else {
    		$("#"+"TDMINITOP_" + oAppointment.trID + "_Day").parent().append("<div class='dataHave' style='height:1px;line-height:1px;background:none;' onclick='clickDayTop(\"TDMINITOP_" + oAppointment.trID + "_Day\")'>·</div>");
    	}
    }
}

function clickDay(val01) {
	
	if ($("#CalendarMini_Top").length > 0) {
		if ($("#"+g_selTDID)) {
			$("#"+g_selTDID).css("background-color", "").css("color", "");
		}
		if ($("#"+g_selTRID)) {
			$("#"+g_selTRID).css("background-color", "").css("color", "");
		}
	} else {
		if ($("#"+g_selTDID)) {
			$("#"+g_selTDID).parent().css("background-color", "").css("color", "");
		}
		if ($("#"+g_selTRID)) {
			$("#"+g_selTRID).parent().css("background-color", "").css("color", "");
		}
	}

	if ($("#CalendarMini_Top").length > 0) {
		// if ($("#"+val01).parent().attr('class').indexOf('sun') > -1) {
		// 	$("#"+val01).css("background","#f0f6ff").css("color","red");
		// } else {
		// 	$("#"+val01).css("background","#f0f6ff").css("color","black");
		// }
		$("#CalendarMini .scalendar_mini td").removeClass("select");
		$("#"+val01).parent().addClass("select");
	} else {
		if ($("#"+val01).parent().attr('class').indexOf('sun') > -1) {
			$("#"+val01).css("background","#f0f6ff").parent().css("color","red");
		} else {
			$("#"+val01).css("background","#f0f6ff").parent().css("color","black");
		}
	}
	
    g_selTRID = $("#"+val01).parent().parent().attr("id");
    g_selTDID = val01;

    var sDate = val01.substring(7, 17);

    date = sDate;
    getScheduleList(date, pMode);
}

function clickDayTop(val01) {
	
	if ($("#CalendarMini_Top").length > 0) {
		if ($("#"+g_selTDIDTOP)) {
			$("#"+g_selTDIDTOP).css("background-color", "").css("color", "");
		}
		if ($("#"+g_selTRIDTOP)) {
			$("#"+g_selTRIDTOP).css("background-color", "").css("color", "");
		}
	} else {
		if ($("#"+g_selTDIDTOP)) {
			$("#"+g_selTDIDTOP).parent().css("background-color", "").css("color", "");
		}
		if ($("#"+g_selTRIDTOP)) {
			$("#"+g_selTRIDTOP).parent().css("background-color", "").css("color", "");
		}
	}
	
	if ($("#CalendarMini_Top").length > 0) {
		// if ($("#"+val01).parent().attr('class').indexOf('sun') > -1) {
	    // 	$("#"+val01).css("background","#f0f6ff").css("color","red");
		// } else {
		// 	$("#"+val01).css("background","#f0f6ff").css("color","black");
		// }
		$("#CalendarMini_Top .scalendar_mini td").removeClass("select");
		$("#"+val01).parent().addClass("select");
	} else {
		if ($("#"+val01).parent().attr('class').indexOf('sun') > -1) {
	    	$("#"+val01).parent().css("background","#f0f6ff").css("border-radius","20px").css("color","red");
		} else {
			$("#"+val01).parent().css("background","#f0f6ff").css("border-radius","20px").css("color","black");
		}
	}
	
	g_selTRIDTOP = $("#"+val01).parent().parent().attr("id");
	g_selTDIDTOP = val01;

    var sDate = val01.substring(10, 20);

    date = sDate;
    getScheduleList_Top(date, pMode);
}

function mfGetUTFIsoDate(iYr, iMon, iDate, iHr, iMin) {
    var oDate = new Date();
    oDate.setFullYear(iYr, iMon, iDate);
    oDate.setHours(iHr, iMin, 0);

    var iYear = oDate.getFullYear();
    var szMonth = oDate.getMonth() + 1; //0 offset adjustment
    var szDate = oDate.getDate();
    var szHours = oDate.getHours();
    var szMinutes = oDate.getMinutes();

    if (szMonth < 10) {
        szMonth = "0" + szMonth;
    }

    if (szDate < 10) {
        szDate = "0" + szDate;
    }

    if (szHours < 10) {
        szHours = "0" + szHours;
    }

    if (szMinutes < 10) {
        szMinutes = "0" + szMinutes;
    }

    return (String(iYear + "-" + szMonth + "-" + szDate + "T" + szHours + ":" + szMinutes + ":00.000Z"));
}

function leadingZeros(n, digits) {
    var zero = '';
    n = n.toString();

    if (n.length < digits) {
        for (var i = 0; i < digits - n.length; i++)
            zero = '0' + zero;
    }
    return zero + n;
}

mfFormatTime.szFormat = (null == this.timeFormat) ? "[tt] [h]:[mm]" : this.timeFormat;
function mfFormatTime(iMin) {
    var iHr = Math.floor(iMin / 60);
    var iMn = iMin % 60;
    var L_AM_Text = strLang1;
    var L_PM_Text = strLang2;
    var szRet = mfFormatTime.szFormat;
    if (-1 < szRet.search(/\[t/g)) //must be first before we modify iHr
    {
        szRet = szRet.replace(/\[tt\]/g, (iHr > 11 && iHr < 24) ? L_PM_Text : L_AM_Text);
        szRet = szRet.replace(/\[t\]/g, (iHr > 11 && iHr < 24) ? L_PM_Text : L_AM_Text);
    }
    if (-1 < szRet.search(/\[h/g)) //12 hour format
    {
        if (iHr > 12) iHr -= 12;
        if (iHr == 0) iHr = 12;
        szRet = szRet.replace(/\[hh\]/g, iHr > 9 ? iHr : "0" + iHr);
        szRet = szRet.replace(/\[h\]/g, iHr);
    }
    if (-1 < szRet.search(/\[H/g)) //24 hour	format
    {
        szRet = szRet.replace(/\[HH\]/g, iHr > 9 ? iHr : "0" + iHr);
        szRet = szRet.replace(/\[H\]/g, iHr);
    }
    if (-1 < szRet.search(/\[m/g)) {
        szRet = szRet.replace(/\[mm\]/g, iMn > 9 ? iMn : "0" + iMn);
        szRet = szRet.replace(/\[m\]/g, iMn);
    }
    return (szRet);
}



//이전월 이동
function preMonth() {
    var iMonth = parseInt(document.getElementById("iMon").value, 10) - 1;
    var iYear = document.getElementById("iYear").value;

    if (iMonth < 1) {
        iYear--;
        iMonth = 12;
    }
    else if (iMonth > 12) {
        iYear++;
        iMonth = 1;
    }

    document.getElementById("iYear").value = iYear;
    document.getElementById("iMon").value = iMonth;
    sDate.setFullYear(iYear, iMonth - 1, 14);
        

    CalendarMiniView("CalendarMini");
    CalendarMiniDataSource();

   
}

//다음월 이동
function nextMonth() {
    var iMonth = parseInt(document.getElementById("iMon").value, 10) + 1;
    var iYear = document.getElementById("iYear").value;

    if (iMonth < 1) {
        iYear--;
        iMonth = 12;
    }
    else if (iMonth > 12) {
        iYear++;
        iMonth = 1;
    }

    sDate.setFullYear(iYear, iMonth - 1, 14);
    document.getElementById("iYear").value = iYear;
    document.getElementById("iMon").value = iMonth;

   
    CalendarMiniView("CalendarMini");
    CalendarMiniDataSource();

   
}


//이전월 이동
function preMonthTop() {
  var iMonth = parseInt(document.getElementById("iMonTop").value, 10) - 1;
  var iYear = document.getElementById("iYearTop").value;

  if (iMonth < 1) {
      iYear--;
      iMonth = 12;
  }
  else if (iMonth > 12) {
      iYear++;
      iMonth = 1;
  }

  document.getElementById("iYearTop").value = iYear;
  document.getElementById("iMonTop").value = iMonth;
  sDate.setFullYear(iYear, iMonth - 1, 14);
      

  CalendarMiniView("CalendarMini_Top");
  CalendarMiniDataSource("Top");

 
}

//다음월 이동
function nextMonthTop() {
  var iMonth = parseInt(document.getElementById("iMonTop").value, 10) + 1;
  var iYear = document.getElementById("iYearTop").value;

  if (iMonth < 1) {
      iYear--;
      iMonth = 12;
  }
  else if (iMonth > 12) {
      iYear++;
      iMonth = 1;
  }

  sDate.setFullYear(iYear, iMonth - 1, 14);
  document.getElementById("iYearTop").value = iYear;
  document.getElementById("iMonTop").value = iMonth;

 
  CalendarMiniView("CalendarMini_Top");
  CalendarMiniDataSource("Top");

 
}

//이전년도 이동
function preYear() {
    var iMonth = document.getElementById("iMon").value;
    var iYear = document.getElementById("iYear").value;

    iYear--;
    document.getElementById("iYear").value = iYear;
    document.getElementById("iMon").value = iMonth;

    sDate.setFullYear(iYear, iMonth - 1, 14);

   
    CalendarMiniView("CalendarMini");
    CalendarMiniDataSource();

   
}

//다음년도 이동
function nextYear() {
    var iMonth = document.getElementById("iMon").value;
    var iYear = document.getElementById("iYear").value;

    iYear++;
    sDate.setFullYear(iYear, iMonth - 1, 14);
    document.getElementById("iYear").value = iYear;
    document.getElementById("iMon").value = iMonth;

  
    CalendarMiniView("CalendarMini");
    CalendarMiniDataSource();

    
}

//선택한 년도 이동
function changeYear() {
    var iMonth = document.getElementById("iMon").value;
    var iYear = document.getElementById("iYear").value;


    document.getElementById("iYear").value = iYear;
    document.getElementById("iMon").value = iMonth;
    sDate.setFullYear(iYear, iMonth - 1, 14);

   
    CalendarMiniView("CalendarMini");
    CalendarMiniDataSource();

   
}

//선택한 월 이동
function changeMonth() {
    var iMonth = document.getElementById("iMon").value;
    var iYear = document.getElementById("iYear").value;

    document.getElementById("iYear").value = iYear;
    document.getElementById("iMon").value = iMonth;
    sDate.setFullYear(iYear, iMonth - 1, 14);

   
    CalendarMiniView("CalendarMini");
    CalendarMiniDataSource();

    
}

function preWeek() {
    sDate.setDate(sDate.getDate() - 7);

    var itemID = "TDMINI_" + sDate.getFullYear() + "-" + leadingZeros(sDate.getMonth() + 1, 2) + "-" + leadingZeros(sDate.getDate(), 2) + "_Day";
    var DayItem = document.getElementById(itemID);
    if (DayItem)
        DayItem.onclick();
    else {
        preWeekMonth();
        var DayItem = document.getElementById(itemID);
        if (DayItem) {
            DayItem.onclick();
            CalendarMiniDataSource();
        }
    }
}

function nextWeek() {

    sDate.setDate(sDate.getDate() + 7);

    var itemID = "TDMINI_" + sDate.getFullYear() + "-" + leadingZeros(sDate.getMonth() + 1, 2) + "-" + leadingZeros(sDate.getDate(), 2) + "_Day";
    var DayItem = document.getElementById(itemID);
    if (DayItem)
        DayItem.onclick();
    else {
        nextWeekMonth();

        var DayItem = document.getElementById(itemID);
        if (DayItem) {
            DayItem.onclick();
            CalendarMiniDataSource();
        }
    }
}


function preDay() {
    sDate.setDate(sDate.getDate() - 1);

    var itemID = "TDMINI_" + sDate.getFullYear() + "-" + leadingZeros(sDate.getMonth() + 1, 2) + "-" + leadingZeros(sDate.getDate(), 2) + "_Day";
    var DayItem = document.getElementById(itemID);
    if (DayItem)
        DayItem.onclick();
    else {
        preWeekMonth();
        var DayItem = document.getElementById(itemID);
        if (DayItem) {
            DayItem.onclick();
            CalendarMiniDataSource();
        }
    }
}

function nextDay() {

    sDate.setDate(sDate.getDate() + 1);

    var itemID = "TDMINI_" + sDate.getFullYear() + "-" + leadingZeros(sDate.getMonth() + 1, 2) + "-" + leadingZeros(sDate.getDate(), 2) + "_Day";
    var DayItem = document.getElementById(itemID);
    if (DayItem)
        DayItem.onclick();
    else {
        nextWeekMonth();

        var DayItem = document.getElementById(itemID);
        if (DayItem) {
            DayItem.onclick();
            CalendarMiniDataSource();
        }
    }
}



//이전월 이동
function preWeekMonth() {
    var iMonth = parseInt(document.getElementById("iMon").value, 10) - 1;
    var iYear = document.getElementById("iYear").value;

    if (iMonth < 1) {
        iYear--;
        iMonth = 12;
    }
    else if (iMonth > 12) {
        iYear++;
        iMonth = 1;
    }

    document.getElementById("iYear").value = iYear;
    document.getElementById("iMon").value = iMonth;

    CalendarMiniView("CalendarMini");
}

//다음월 이동
function nextWeekMonth() {
    var iMonth = parseInt(document.getElementById("iMon").value, 10) + 1;
    var iYear = document.getElementById("iYear").value;

    if (iMonth < 1) {
        iYear--;
        iMonth = 12;
    }
    else if (iMonth > 12) {
        iYear++;
        iMonth = 1;
    }

    sDate.setFullYear(iYear, iMonth - 1, 14);
    document.getElementById("iYear").value = iYear;
    document.getElementById("iMon").value = iMonth;

    CalendarMiniView("CalendarMini");
    CalendarMiniDataSource();
}

//이전월 이동
function preWeekMonthTop() {
    var iMonthTop = parseInt(document.getElementById("iMonTop").value, 10) - 1;
    var iYearTop = document.getElementById("iYearTop").value;

    if (iMonthTop < 1) {
        iYearTop--;
        iMonthTop = 12;
    }
    else if (iMonthTop > 12) {
        iYearTop++;
        iMonthTop = 1;
    }

    document.getElementById("iYearTop").value = iYearTop;
    document.getElementById("iMonTop").value = iMonthTop;

    CalendarMiniView("CalendarMini_Top");
    CalendarMiniDataSource();
}

//다음월 이동
function nextWeekMonthTop() {
    var iMonth = parseInt(document.getElementById("iMonTop").value, 10) + 1;
    var iYear = document.getElementById("iYearTop").value;

    if (iMonth < 1) {
        iYear--;
        iMonth = 12;
    }
    else if (iMonth > 12) {
        iYear++;
        iMonth = 1;
    }

    sDate.setFullYear(iYear, iMonth - 1, 14);
    document.getElementById("iYearTop").value = iYear;
    document.getElementById("iMonTop").value = iMonth;

    CalendarMiniView("CalendarMini_Top");
    CalendarMiniDataSource();
}

function memorialDayCheck(solarDate, lunarDate) {
    var i;
    var memorial;

    var tempmemorialDays = new Array();
    for (i = 0; i < memorialDays.length; i++) {
        if (solarDate.getFullYear() > 1800 && solarDate.getFullYear() <= 2101) {
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

function lunarCalc(year, month, day, type, leapmonth) {
    var solYear, solMonth, solDay;
    var lunYear, lunMonth, lunDay;
    var lunLeapMonth, lunMonthDay;
    var i, lunIndex;
    var solMonthDay = [31, 0, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    /* range check */
    if (year < 1800 || year > 2101) {
        alert('1800년부터 2101년까지만 지원합니다');
        return;
    }
    /* 속도 개선을 위해 기준 일자를 여러개로 한다 */
    if (year >= 2080) {
        /* 기준일자 양력 2080년 1월 1일 (음력 2079년 12월 10일) */
        solYear = 2080;
        solMonth = 1;
        solDay = 1;
        lunYear = 2079;
        lunMonth = 12;
        lunDay = 10;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 2080 년 2월 28일 */
        lunMonthDay = 30; /* 2079년 12월 */
    }
    else if (year >= 2060) {
        /* 기준일자 양력 2060년 1월 1일 (음력 2059년 11월 28일) */
        solYear = 2060;
        solMonth = 1;
        solDay = 1;
        lunYear = 2059;
        lunMonth = 11;
        lunDay = 28;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 2060 년 2월 28일 */
        lunMonthDay = 30; /* 2059년 11월 */
    }
    else if (year >= 2040) {
        /* 기준일자 양력 2040년 1월 1일 (음력 2039년 11월 17일) */
        solYear = 2040;
        solMonth = 1;
        solDay = 1;
        lunYear = 2039;
        lunMonth = 11;
        lunDay = 17;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 2040 년 2월 28일 */
        lunMonthDay = 29; /* 2039년 11월 */
    }
    else if (year >= 2020) {
        /* 기준일자 양력 2020년 1월 1일 (음력 2019년 12월 7일) */
        solYear = 2020;
        solMonth = 1;
        solDay = 1;
        lunYear = 2019;
        lunMonth = 12;
        lunDay = 7;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 2020 년 2월 28일 */
        lunMonthDay = 30; /* 2019년 12월 */
    }
    else if (year >= 2000) {
        /* 기준일자 양력 2000년 1월 1일 (음력 1999년 11월 25일) */
        solYear = 2000;
        solMonth = 1;
        solDay = 1;
        lunYear = 1999;
        lunMonth = 11;
        lunDay = 25;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 2000 년 2월 28일 */
        lunMonthDay = 30; /* 1999년 11월 */
    }
    else if (year >= 1980) {
        /* 기준일자 양력 1980년 1월 1일 (음력 1979년 11월 14일) */
        solYear = 1980;
        solMonth = 1;
        solDay = 1;
        lunYear = 1979;
        lunMonth = 11;
        lunDay = 14;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 1980 년 2월 28일 */
        lunMonthDay = 30; /* 1979년 11월 */
    }
    else if (year >= 1960) {
        /* 기준일자 양력 1960년 1월 1일 (음력 1959년 12월 3일) */
        solYear = 1960;
        solMonth = 1;
        solDay = 1;
        lunYear = 1959;
        lunMonth = 12;
        lunDay = 3;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 1960 년 2월 28일 */
        lunMonthDay = 29; /* 1959년 12월 */
    }
    else if (year >= 1940) {
        /* 기준일자 양력 1940년 1월 1일 (음력 1939년 11월 22일) */
        solYear = 1940;
        solMonth = 1;
        solDay = 1;
        lunYear = 1939;
        lunMonth = 11;
        lunDay = 22;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 1940 년 2월 28일 */
        lunMonthDay = 29; /* 1939년 11월 */
    }
    else if (year >= 1920) {
        /* 기준일자 양력 1920년 1월 1일 (음력 1919년 11월 11일) */
        solYear = 1920;
        solMonth = 1;
        solDay = 1;
        lunYear = 1919;
        lunMonth = 11;
        lunDay = 11;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 1920 년 2월 28일 */
        lunMonthDay = 30; /* 1919년 11월 */
    }
    else if (year >= 1900) {
        /* 기준일자 양력 1900년 1월 1일 (음력 1899년 12월 1일) */
        solYear = 1900;
        solMonth = 1;
        solDay = 1;
        lunYear = 1899;
        lunMonth = 12;
        lunDay = 1;
        lunLeapMonth = 0;
        solMonthDay[1] = 28; /* 1900 년 2월 28일 */
        lunMonthDay = 30; /* 1899년 12월 */
    }
    else if (year >= 1880) {
        /* 기준일자 양력 1880년 1월 1일 (음력 1879년 11월 20일) */
        solYear = 1880;
        solMonth = 1;
        solDay = 1;
        lunYear = 1879;
        lunMonth = 11;
        lunDay = 20;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 1880 년 2월 28일 */
        lunMonthDay = 30; /* 1879년 11월 */
    }
    else if (year >= 1860) {
        /* 기준일자 양력 1860년 1월 1일 (음력 1859년 12월 9일) */
        solYear = 1860;
        solMonth = 1;
        solDay = 1;
        lunYear = 1859;
        lunMonth = 12;
        lunDay = 9;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 1860 년 2월 28일 */
        lunMonthDay = 30; /* 1859년 12월 */
    }
    else if (year >= 1840) {
        /* 기준일자 양력 1840년 1월 1일 (음력 1839년 11월 27일) */
        solYear = 1840;
        solMonth = 1;
        solDay = 1;
        lunYear = 1839;
        lunMonth = 11;
        lunDay = 27;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 1840 년 2월 28일 */
        lunMonthDay = 30; /* 1839년 11월 */
    }
    else if (year >= 1820) {
        /* 기준일자 양력 1820년 1월 1일 (음력 1819년 11월 16일) */
        solYear = 1820;
        solMonth = 1;
        solDay = 1;
        lunYear = 1819;
        lunMonth = 11;
        lunDay = 16;
        lunLeapMonth = 0;
        solMonthDay[1] = 29; /* 1820 년 2월 28일 */
        lunMonthDay = 30; /* 1819년 11월 */
    }
    else if (year >= 1800) {
        /* 기준일자 양력 1800년 1월 1일 (음력 1799년 12월 7일) */
        solYear = 1800;
        solMonth = 1;
        solDay = 1;
        lunYear = 1799;
        lunMonth = 12;
        lunDay = 7;
        lunLeapMonth = 0;
        solMonthDay[1] = 28; /* 1800 년 2월 28일 */
        lunMonthDay = 30; /* 1799년 12월 */
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
        /* add a day of solar calendar */
        if (solMonth == 12 && solDay == 31) {
            solYear++;
            solMonth = 1;
            solDay = 1;
            /* set monthDay of Feb */
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
        /* add a day of lunar calendar */
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
                lunMonthDay = 30;
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

var lunarMonthTable = [
[1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2],
[2, 1, 2, 5, 2, 1, 2, 1, 2, 1, 2, 1],
[1, 2, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2], /* 1801 */
[1, 1, 2, 1, 2, 1, 2, 2, 2, 1, 2, 1],
[2, 3, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 1, 3, 2, 1, 2, 2, 2, 1],
[2, 2, 1, 2, 1, 1, 1, 2, 1, 2, 2, 1],
[2, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[1, 2, 2, 1, 5, 2, 1, 2, 1, 1, 2, 1],
[2, 2, 1, 2, 2, 1, 2, 1, 2, 1, 1, 2],
[1, 2, 1, 2, 2, 1, 2, 2, 1, 2, 1, 2],
[1, 1, 5, 2, 1, 2, 2, 1, 2, 2, 1, 2], /* 1811 */
[1, 1, 2, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 1, 1, 1, 2, 1, 2, 2, 2, 1],
[2, 5, 2, 1, 1, 1, 2, 1, 2, 2, 1, 2],
[2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 5, 1, 2, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1],
[2, 1, 2, 2, 1, 2, 2, 1, 2, 1, 1, 2],
[1, 2, 1, 5, 2, 2, 1, 2, 2, 1, 2, 1],
[1, 2, 1, 2, 1, 2, 1, 2, 2, 2, 1, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2], /* 1821 */
[2, 1, 5, 1, 1, 2, 1, 2, 2, 1, 2, 2],
[2, 1, 2, 1, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 4, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 1, 2, 2, 4, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 1, 2, 3, 2, 1, 2, 2, 1, 2, 2, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2], /* 1831 */
[1, 2, 1, 2, 1, 1, 2, 1, 5, 2, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 5, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2],
[1, 2, 1, 5, 1, 2, 2, 1, 2, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 4, 1, 1, 2, 1, 2, 1, 2, 2, 1],   /* 1841 */
[2, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 1],
[2, 2, 2, 1, 2, 1, 4, 1, 2, 1, 2, 1],
[2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 5, 2, 1, 2, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 3, 2, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 1, 2, 3, 2, 1, 2, 2],   /* 1851 */
[2, 1, 2, 2, 1, 1, 2, 1, 2, 1, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 5, 2, 1, 2, 1, 2],
[1, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1, 2],
[1, 2, 1, 1, 5, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[2, 1, 6, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2],   /* 1861 */
[2, 1, 2, 1, 2, 2, 1, 5, 2, 1, 1, 2],
[1, 2, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2],
[1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 4, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2],
[1, 2, 2, 3, 2, 1, 1, 2, 1, 2, 2, 1],
[2, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 2, 2, 1, 2, 1, 2, 1, 1, 5, 2, 1],
[2, 2, 1, 2, 2, 1, 2, 1, 2, 1, 1, 2],   /* 1871 */
[1, 2, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2],
[1, 1, 2, 1, 2, 4, 2, 1, 2, 2, 1, 2],
[1, 1, 2, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1],
[2, 2, 1, 1, 5, 1, 2, 1, 2, 2, 1, 2],
[2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 2, 4, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 1, 2, 2, 1, 2, 2, 1, 2, 1, 1, 2],
[1, 2, 1, 2, 1, 2, 5, 2, 2, 1, 2, 1],   /* 1881 */
[1, 2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2],
[2, 1, 1, 2, 3, 2, 1, 2, 2, 1, 2, 2],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 2, 1, 5, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 5, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],   /* 1891 */
[1, 1, 2, 1, 1, 5, 2, 2, 1, 2, 2, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 5, 1, 2, 1, 2, 1, 2, 1],
[2, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 5, 2, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 5, 2, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1],   /* 1901 */
[2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 3, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1],
[2, 2, 1, 2, 2, 1, 1, 2, 1, 2, 1, 2],
[1, 2, 2, 4, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 1, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2],
[1, 5, 1, 2, 1, 2, 1, 2, 2, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 1, 1, 5, 1, 2, 2, 1, 2, 2],   /* 1911 */
[2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2],
[2, 2, 1, 2, 5, 1, 2, 1, 2, 1, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 3, 2, 1, 2, 2, 1, 2, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 2, 1, 1, 2, 1, 5, 2, 1, 2, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],   /* 1921 */
[2, 1, 2, 2, 3, 2, 1, 1, 2, 1, 2, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2],
[2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 1],
[2, 1, 2, 5, 2, 1, 2, 2, 1, 2, 1, 2],
[1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 5, 1, 2, 1, 1, 2, 2, 1, 2, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2],
[1, 2, 2, 1, 1, 5, 1, 2, 1, 2, 2, 1],
[2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1],   /* 1931 */
[2, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2],
[1, 2, 2, 1, 6, 1, 2, 1, 2, 1, 1, 2],
[1, 2, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2],
[1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 4, 1, 1, 2, 2, 1, 2, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1],
[2, 2, 1, 1, 2, 1, 4, 1, 2, 2, 1, 2],
[2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 2, 1, 2, 2, 4, 1, 1, 2, 1, 2, 1],   /* 1941 */
[2, 1, 2, 2, 1, 2, 2, 1, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 4, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2],
[2, 5, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 3, 2, 1, 2, 1, 2],
[1, 2, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2],   /* 1951 */
[1, 2, 1, 2, 4, 1, 2, 2, 1, 2, 1, 2],
[1, 2, 1, 1, 2, 2, 1, 2, 2, 1, 2, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2],
[2, 1, 4, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 1, 5, 2, 1, 2, 2],
[1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 5, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2],   /* 1961 */
[1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 2, 3, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 2],
[1, 2, 5, 2, 1, 1, 2, 1, 1, 2, 2, 1],
[2, 2, 1, 2, 2, 1, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 2, 1, 5, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2],
[1, 2, 1, 1, 5, 2, 1, 2, 2, 2, 1, 2],   /* 1971 */
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 5, 1, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 2, 1, 5, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 1],
[2, 1, 2, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 6, 1, 2, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2],   /* 1981 */
[2, 1, 2, 3, 2, 1, 1, 2, 1, 2, 2, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[2, 1, 2, 2, 1, 1, 2, 1, 1, 5, 2, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 2, 1, 2, 1, 2, 1, 1],
[2, 1, 2, 1, 2, 5, 2, 2, 1, 2, 1, 2],
[1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 1, 5, 1, 2, 2, 1, 2, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2],   /* 1991 */
[1, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[1, 2, 5, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 1, 2, 5, 2, 1, 1, 2],
[1, 2, 1, 2, 2, 1, 2, 1, 2, 2, 1, 1],
[2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 3, 2, 2, 1, 2, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1],
[2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1],
[2, 2, 1, 5, 2, 1, 1, 2, 1, 2, 1, 2],   /* 2001 */
[2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2],
[1, 5, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 1, 5, 2, 2, 1, 2, 2],
[1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2],
[2, 2, 1, 1, 5, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1],   /* 2011 */
[2, 1, 2, 5, 2, 2, 1, 1, 2, 1, 2, 1],
[2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 1, 2, 5, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 2, 1, 2, 1, 4, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2],
[2, 1, 2, 5, 2, 1, 1, 2, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1],   /* 2021 */
[2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2],
[1, 5, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 2, 1, 1, 5, 2, 1, 2, 2, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1],
[2, 2, 2, 1, 5, 1, 2, 1, 1, 2, 2, 1],
[2, 2, 1, 2, 2, 1, 1, 2, 1, 1, 2, 2],
[1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 5, 2, 1, 2, 2, 1, 2, 1, 2, 1],   /* 2031 */
[2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 5, 2],
[1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 4, 1, 1, 2, 2, 1, 2],
[2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2, 1],
[2, 2, 1, 2, 5, 2, 1, 2, 1, 2, 1, 1],
[2, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2, 1],
[2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2],   /* 2041 */
[1, 5, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2],
[2, 1, 2, 1, 1, 2, 3, 2, 1, 2, 2, 2],
[2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[2, 1, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2],
[2, 1, 2, 2, 4, 1, 2, 1, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 2, 1, 2, 1, 1, 2, 1],
[2, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2, 1],
[1, 2, 4, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2, 2],   /* 2051 */
[1, 2, 1, 1, 2, 1, 1, 5, 2, 2, 2, 2],
[1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2],
[1, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2],
[1, 2, 2, 1, 2, 4, 1, 1, 2, 1, 2, 1],
[2, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2],
[1, 2, 2, 1, 2, 1, 2, 2, 1, 1, 2, 1],
[2, 1, 2, 4, 2, 1, 2, 1, 2, 2, 1, 1],
[2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2, 1],
[2, 2, 3, 2, 1, 1, 2, 1, 2, 2, 2, 1],   /* 2061 */
[2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1],
[2, 2, 1, 2, 1, 2, 3, 2, 1, 2, 1, 2],
[2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2],
[1, 2, 1, 2, 5, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 1, 2, 2, 1, 2, 2, 1, 2],
[1, 2, 1, 5, 1, 2, 1, 2, 2, 2, 1, 2],
[2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2],
[2, 1, 2, 1, 2, 1, 1, 5, 2, 1, 2, 2],   /* 2071 */
[2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2],
[2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1],
[2, 1, 2, 2, 1, 5, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 1],
[2, 1, 2, 3, 2, 1, 2, 2, 2, 1, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2],
[1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[2, 1, 5, 2, 1, 1, 2, 1, 2, 1, 2, 2],
[1, 2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2],   /* 2081 */
[1, 2, 2, 2, 1, 2, 3, 2, 1, 1, 2, 2],
[1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1],
[2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2],
[1, 2, 1, 1, 6, 1, 2, 2, 1, 2, 1, 2],
[1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1],
[2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2],
[1, 2, 1, 5, 1, 2, 1, 1, 2, 2, 2, 1],
[2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1],
[2, 2, 2, 1, 2, 1, 1, 5, 1, 2, 2, 1],
[2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2, 1],   /* 2091 */
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
