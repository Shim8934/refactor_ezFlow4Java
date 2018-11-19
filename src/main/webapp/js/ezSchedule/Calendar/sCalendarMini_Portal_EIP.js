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
	        mTable.setAttribute("style", "margin: 10px 10px; padding: 0px 25px 0px 3px;");
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
	        mImg.setAttribute("onclick", "preMonth()");
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
	        mImg.setAttribute("onclick", "nextMonth()");
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
	        //mSpan.style.marginLeft = "6px";
	        //mSpan.style.marginTop = "4px";
	        var mImg = document.createElement("IMG");
	        mImg.setAttribute("src", "/images/ezNewPortal/calender_pre.png");///
	        mImg.setAttribute("border", "0");
	        mImg.setAttribute("onclick", "preMonthTop()");
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
	        //mSpan.style.marginRight = "6px";
	        //mSpan.style.marginTop = "4px";
	        var mImg = document.createElement("IMG");
	        mImg.setAttribute("src", "/images/ezNewPortal/calender_next.png");///
	        mImg.setAttribute("border", "0");
	        mImg.setAttribute("onclick", "nextMonthTop()");
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
    oThisMonth = oThisDate.getMonth() + 1;

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
    oThisMonth = oThisDate.getMonth() + 1;

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
        //이거 그냥 이름정해놓고 그대로 갖다 쓰는거 같은데 TR뒤에 TOP만 붙여봄
        objTr.setAttribute("id", "TR_TOP" + oThisMonth + "_" + i);

        for (var j = 0; j < 7; j++) {
            var objTD = MonthMiniDataTop(oThisDate);
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
        className = "today";  // 현재일
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

    if ($("#"+g_selTDID)) {
    	$("#"+g_selTDID).parent().css("background-color", "").css("color", "");
    }
    
    if ($("#"+g_selTRID)) {
    	$("#"+g_selTRID).parent().css("background-color", "").css("color", "");
    }
    
    /*if (document.getElementById(g_selTDID))
        document.getElementById(g_selTDID).style.backgroundColor = "";
    if (document.getElementById(g_selTRID))
        document.getElementById(g_selTRID).style.backgroundColor = "";*/   
 
    //document.getElementById(event.getAttribute("id")).style.backgroundColor = "#f0f6ff";
    if (usedTheme == 3) {
    	$("#"+event.getAttribute("id")).parent().addClass('schedule');
    } else {
    	$("#"+event.getAttribute("id")).parent().css("background","#f0f6ff").css("border-radius","20px").css("color","black");
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

    if ($("#"+g_selTDIDTOP)) {
    	$("#"+g_selTDIDTOP).parent().css("background-color", "").css("color", "");
    }
    
    if ($("#"+g_selTRIDTOP)) {
    	$("#"+g_selTRIDTOP).parent().css("background-color", "").css("color", "");
    }
    
    /*if (document.getElementById(g_selTDID))
        document.getElementById(g_selTDID).style.backgroundColor = "";
    if (document.getElementById(g_selTRID))
        document.getElementById(g_selTRID).style.backgroundColor = "";*/   
 
    //document.getElementById(event.getAttribute("id")).style.backgroundColor = "#f0f6ff";
    if (usedTheme == 3) {
    	$("#"+event.getAttribute("id")).parent().addClass('schedule');
    } else {
    	$("#"+event.getAttribute("id")).parent().css("background","lightgray").css("border-radius","20px").css("color","black");
    }
	//$("#"+event.getAttribute("id")).parent().css("border-radius","20px");
	
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
    		$("#"+"TDMINI_" + oAppointment.trID + "_Day").parent().append("<div class='dataHave' style='height:1px;line-height:1px' onclick='clickDay(\"TDMINI_" + oAppointment.trID + "_Day\")'>·</div>");
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
    		$("#"+"TDMINITOP_" + oAppointment.trID + "_Day").parent().append("<div class='dataHave' style='height:1px;line-height:1px' onclick='clickDayTop(\"TDMINITOP_" + oAppointment.trID + "_Day\")'>·</div>");
    	}
    }
}

function clickDay(val01) {
	
    if ($("#"+g_selTDID)) {
    	$("#"+g_selTDID).parent().css("background-color", "").css("color", "");
    }
    
    if ($("#"+g_selTRID)) {
    	$("#"+g_selTRID).parent().css("background-color", "").css("color", "");
    }
    
	$("#"+val01).parent().css("background","#f0f6ff").css("border-radius","20px").css("color","black");
	
    g_selTRID = $("#"+val01).parent().parent().attr("id");
    g_selTDID = val01;

    var sDate = val01.substring(7, 17);

    date = sDate;
    getScheduleList(date, pMode);
}

function clickDayTop(val01) {
	
	if ($("#"+g_selTDIDTOP)) {
		$("#"+g_selTDIDTOP).parent().css("background-color", "").css("color", "");
	}
	
	if ($("#"+g_selTRIDTOP)) {
		$("#"+g_selTRIDTOP).parent().css("background-color", "").css("color", "");
	}
	
    
	$("#"+val01).parent().css("background","lightgray").css("border-radius","20px").css("color","black");
	
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
}
