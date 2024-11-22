var sStartDate, sEndDate;
var DefaultView = 1;
var sDate = new Date();

//리스트뷰 바디 생성
var oBeforeDate, oThisDate;
var oThisMonth;

var g_selDivID = null;
var g_selTRID = null;
var g_selTDID = null;
var dayOfWeeks;

var nowDate = new Date();
var nowDay = (nowDate.getFullYear()) + "-" + leadingZeros((nowDate.getMonth() + 1), 2) + "-" + leadingZeros(nowDate.getDate(), 2);


function CalendarMiniView(pTagetID) {
    document.getElementById(pTagetID).innerHTML = "";

	if (sDate.getFullYear() > 1800 && sDate.getFullYear() <= 2101) {
        if (lunarMonthTable[sDate.getFullYear() - 1 - 1799][11] == 1)
            memorialDays[1].day = 29;
        else if (lunarMonthTable[sDate.getFullYear() - 1 - 1799][11] == 2)
            memorialDays[1].day = 30;
    }

    var objElm = document.getElementById(pTagetID);
    if (objElm) {
        var mTable = document.createElement("TABLE");
        mTable.className = "calendar_mini_title";
        mTable.setAttribute("cellpadding", "0");
        mTable.setAttribute("cellspacing", "0");
        mTable.setAttribute("border", "0");
        mTable.setAttribute("width", "100%");
        var mTr = document.createElement("TR");

        var mTd = document.createElement("TD");
        mTd.className = "btn_prev"
        var mSpan = document.createElement("SPAN");
        mSpan.style.marginLeft = "6px";
        mSpan.style.marginTop = "4px";
        var mImg = document.createElement("IMG");
        mImg.setAttribute("src", "/images/calendar/btn_calendar_mini_prev.gif");
        mImg.setAttribute("border", "0");
        mImg.setAttribute("onclick", "preMonth()");
        mSpan.appendChild(mImg);
        mTd.appendChild(mSpan);
        mTr.appendChild(mTd);

        var mTd = document.createElement("TD");
        mTd.className = "calendar_mini_day"
        var mSel = document.createElement("SELECT");
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
        mTr.appendChild(mTd);

        var mTd = document.createElement("TD");
        mTd.className = "btn_next"
        var mSpan = document.createElement("SPAN");
        mSpan.style.marginRight = "6px";
        mSpan.style.marginTop = "4px";
        var mImg = document.createElement("IMG");
        mImg.setAttribute("src", "/images/calendar/btn_calendar_mini_next.gif");
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
        oTable.className = "calendar_mini";

        var oTBody = GetTableMiniBodyObj();
        oTable.appendChild(oTBody);

        objElm.appendChild(oTable);
    }

    CalendarMiniDataSource();
}

function GetTableMiniBodyObj() {
    var year = document.getElementById("iYear").value;
    var month = parseInt(document.getElementById("iMon").value);

    if (DefaultView == 0)
        dayOfWeeks = strLang241; // 일>토
    else if (DefaultView == 1)
        dayOfWeeks = strLang242; // 월>일

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
    sStartDate = oThisDate.getFullYear() + "-" + leadingZeros((oThisDate.getMonth() + 1), 2) + "-" + leadingZeros(oThisDate.getDate(), 2);
    
   //Month Start
    for (var i = 0; i < 6; i++) {
        var objTr = document.createElement("TR");
        objTr.setAttribute("id", "TR_" + oThisMonth + "_" + i);

        for (var j = 0; j < 7; j++) {
            var objTD = MonthMiniData(oThisDate);
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
                    objTD.className = " sun";
                }
            }
            objTr.appendChild(objTD);
            objTD = null;
        }
        oTbody.appendChild(objTr);
    }
    //Month End
    oThisDate.setDate(oThisDate.getDate());
    sEndDate = oThisDate.getFullYear() + "-" + leadingZeros((oThisDate.getMonth() + 1), 2) + "-" + leadingZeros(oThisDate.getDate(), 2);
    objTr = null;

    return oTbody;
}

// 선택한 월의 날짜 입력 시작
function MonthMiniData(oThisDate) {

    var objTd = document.createElement("TD");

    var oDiv = document.createElement("DIV");
    oDiv.setAttribute("onclick", "DateView_onMouseClick(this);");
    oDiv.setAttribute("ondblclick", "newSchedule_onclick(event)");

    var pDateData = oThisDate.getDate()

    var className = "";
    var className = "";

    var divID = (oThisDate.getFullYear()) + "-" + leadingZeros((oThisDate.getMonth() + 1), 2) + "-" + leadingZeros(oThisDate.getDate(), 2);

    if (divID == nowDay) {
        className = "today";  // 현재일
    }
    if (oThisMonth != oThisDate.getMonth()) // 현재월 이외의 날
        className = " gray";
    else if (oThisDate.getDay() == 0)  // 일요일
        className = " sun";
    else if (oThisDate.getDay() == 6)  // 토요일
        className = " sat";

    objTd.className = className;
    oDiv.innerHTML = pDateData;

    oDiv.setAttribute("id", "TDMINI_" + divID + "_Day");
    oDiv.setAttribute("dispDate", divID);
    objTd.innerHTML = oDiv.outerHTML;
    oThisDate.setDate(oThisDate.getDate() + 1);
    return objTd;
}// 선택한 월의 날짜 입력 완료

//자원데이터에 마우스 클릭시
function DateView_onMouseClick(event) {
    if (!event) event = window.event;

    if (document.getElementById(g_selTDID))
        document.getElementById(g_selTDID).style.backgroundColor = "";
    if (document.getElementById(g_selTRID))
        document.getElementById(g_selTRID).style.backgroundColor = "";

    if (typeCal == 0) { //월보기
    }
    else if (typeCal == 1) {
        document.getElementById(GetAttribute(event.parentNode.parentNode,"id")).style.backgroundColor = "#f1f8ff";
        g_selTRID = GetAttribute(event.parentNode.parentNode,"id");
        g_selTDID = GetAttribute(event,"id");

        sDate = new Date(GetAttribute(event,"id").substring(7, 11), parseInt(GetAttribute(event,"id").substring(12, 14), 10) - 1, parseInt(GetAttribute(event,"id").substring(15, 17), 10));
        CalendarView("Calendar")
    }
    else if (typeCal == 2) { //일보기

        document.getElementById(GetAttribute(event,"id")).style.backgroundColor = "#f1f8ff";
        g_selTRID = GetAttribute(event.parentNode.parentNode,"id");
        g_selTDID = GetAttribute(event,"id");
        sDate = new Date(GetAttribute(event,"id").substring(7, 11), parseInt(GetAttribute(event,"id").substring(12, 14), 10) - 1, parseInt(GetAttribute(event,"id").substring(15, 17), 10));
        CalendarView("Calendar")
    }
}

var xmlhttpmini;
function CalendarMiniDataSource() {
    xmlhttpmini = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "STARTDATETIME", sStartDate);
    createNodeAndInsertText(xmlpara, objNode, "ENDDATETIME", sEndDate);
    createNodeAndInsertText(xmlpara, objNode, "APP", "0");

    xmlhttpmini.open("POST", "/ezResource/scheduleGet.do?cmd=get&resID=" + ResID, true);
    xmlhttpmini.onreadystatechange = getCalendarMiniDataSource_after;
    xmlhttpmini.send(xmlpara);

    //getCalendarMiniDataSource_after(xmlhttp);
}

function sTempData() {
}


function getCalendarMiniDataSource_after() {
    var tempData = new Array();
    if (xmlhttpmini == null || xmlhttpmini.readyState != 4) return;

    try {
        if (xmlhttpmini.responseText == "") return;
        var listNode = loadXMLString(xmlhttpmini.responseText);
        var objNodes = SelectNodes(listNode, "root/appointment");
        var k = 0;
        for (var i = 0; i < objNodes.length; i++) {

            var _Dtstart = getNodeText(SelectNodes(objNodes[i], "dtstart")[i]);
            var _Dtend = getNodeText(SelectNodes(objNodes[i], "dtend")[i]);
            var DataSDT = new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7)) - 1, parseInt(_Dtstart.substring(8, 10)), parseInt(_Dtstart.substring(11, 13)), parseInt(_Dtstart.substring(14, 16)));
            var DataEDT = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7)) - 1, parseInt(_Dtend.substring(8, 10)), parseInt(_Dtend.substring(11, 13)), parseInt(_Dtend.substring(14, 16)));

            if (_Dtstart.substring(0, 10) != _Dtend.substring(0, 10)) { // 반복일정

                var betweenDay = parseDate(_Dtend.substring(0, 10)) - parseDate(_Dtstart.substring(0, 10));
                var day = 1000 * 60 * 60 * 24;
                betweenDay = parseInt(betweenDay / day, 10);

                for (var j = 0; j <= betweenDay; j++) {

                    var trID = DataSDT.getFullYear() + "-" + leadingZeros(parseInt(DataSDT.getMonth() + 1), 2, 10) + "-" + leadingZeros(DataSDT.getDate(), 2);
                    tempData[k] = new sTempData();
                    tempData[k].trID = trID;
                    tempData[k].oDtstart = mfGetUTFIsoDate(DataSDT.getFullYear(), DataSDT.getMonth() + 1, DataSDT.getDate(), DataSDT.getHours(), DataSDT.getMinutes());
                    tempData[k].oDtend = mfGetUTFIsoDate(DataEDT.getFullYear(), DataEDT.getMonth() + 1, DataEDT.getDate(), DataEDT.getHours(), DataEDT.getMinutes());
                    tempData[k].odtstartHour = DataSDT.getHours();
                    tempData[k].odtstartMinute = DataSDT.getMinutes();
                    tempData[k].odtendHour = DataEDT.getHours();
                    tempData[k].odtendMinute = DataEDT.getMinutes();
                    tempData[k].o_start = "";
                    tempData[k].o_end = "";
                    tempData[k].odtstartDisplay = mfFormatTime((DataSDT.getHours() * 60) + DataSDT.getMinutes())
                    tempData[k].odtendDisplay = mfFormatTime((DataEDT.getHours() * 60) + DataEDT.getMinutes())
                    tempData[k].oAlldayevent = getNodeText(SelectNodes(objNodes[i], "alldayevent")[i]);
                    tempData[k].oBusystatus = getNodeText(SelectNodes(objNodes[i], "busystatus")[i]);
                    DataSDT.setDate(DataSDT.getDate() + 1);
                    k += 1;
                }
            } else {
                var trID = getNodeText(SelectNodes(objNodes[i], "dtstart")[i]).substring(0, 10);
                tempData[k] = new sTempData();
                tempData[k].trID = trID;
                tempData[k].oDtstart = getNodeText(SelectNodes(objNodes[i], "dtstart")[i]);
                tempData[k].oDtend = getNodeText(SelectNodes(objNodes[i], "dtend")[i]);
                tempData[k].odtstartHour = DataSDT.getHours();
                tempData[k].odtstartMinute = DataSDT.getMinutes();
                tempData[k].odtendHour = DataEDT.getHours();
                tempData[k].odtendMinute = DataEDT.getMinutes();
                tempData[k].o_start = "";
                tempData[k].o_end = "";
                tempData[k].odtstartDisplay = mfFormatTime((DataSDT.getHours() * 60) + DataSDT.getMinutes())
                tempData[k].odtendDisplay = mfFormatTime((DataEDT.getHours() * 60) + DataEDT.getMinutes())
                tempData[k].oAlldayevent = getNodeText(SelectNodes(objNodes[i], "alldayevent")[i]);
                tempData[k].oBusystatus = getNodeText(SelectNodes(objNodes[i], "busystatus")[i]);
                k += 1;
            }
            DataSDT = null;
            DataEDT = null;
        }

        for (var i = 0; i < tempData.length; i++) {
            MiniDataBind(tempData[i], i);
        }

        xmlhttpmini = null;
        tempData = null;
    }
    catch (e) {
        alert("getCalendarMiniDataSource_after : " + e.description);
    }
}

function MiniDataBind(oAppointment, order) {

    var objElm = document.getElementById("TDMINI_" + oAppointment.trID + "_Day");
    if (objElm) {
        objElm.style.fontWeight = "bold"
    }
}


function OnDoubleClickAppointment(srcEl) {

    //if (!event) event = window.event;
    if (GetAttribute(srcEl,"command") == 'open') {
        var szNum = GetAttribute(srcEl,"num");
        var szPNum = GetAttribute(srcEl,"pnum");
        var szOwnerID = GetAttribute(srcEl,"owner_id");
        var szWriterID = GetAttribute(srcEl,"writer_id");
        var szGroupFlag = GetAttribute(srcEl,"groupflag");
        var szStart = new Date(GetAttribute(srcEl,"dtend"));
        var szEnd = new Date(GetAttribute(srcEl,"dtend"));
        var szInstancetype = GetAttribute(srcEl,"instancetype");
        var szType, startDate, endDate, filename;

        szType = "Master";
        startDate = szStart.getFullYear() + "-" + parseInt(szStart.getMonth() + 1, 10) + "-" + szStart.getDate();
        endDate = szEnd.getFullYear() + "-" + parseInt(szEnd.getMonth() + 1, 10) + "-" + szEnd.getDate();

        if (parseInt(szGroupFlag) == 2 || parseInt(szGroupFlag) == 4) {
            //메인화면에서 더블클릭하면 분기
            filename = "Schedule_UnReg.asp";

        } else {
            filename = "scheduleRead.do";

            // 반복자원예약에 대한 처리
            if (parseInt(szInstancetype) == 1 || parseInt(szInstancetype) == 3) {
                if (parseInt(szInstancetype) == 3) {
                    szNum = szPNum;
                    szOwnerID = szWriterID;
                }
            }
        }
        windowName = "";

        if (CrossYN()) {
            GetOpenWindow(filename + "?cmd=mod&from=schedule&" + "num=" + szNum + "&ownerID=" + szOwnerID + "&type=" + szType + "&startDate=" + startDate + "&endDate=" + endDate, "", 820, 700);

        }
        else {
            var feature = GetOpenPosition(790, 420);
            window.open(filename + "?cmd=mod&from=schedule&" + "num=" + szNum + "&ownerID=" + szOwnerID + "&type=" + szType + "&startDate=" + startDate + "&endDate=" + endDate, "", "width=770, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
        }
    }
}

function GetOpenPosition(popUpW, popUpH) {
    //2011.07.28 FireFox는 ShowModalDialog() 호출시 화면 중앙에 뜨지 않아 top, left를 지정해 줘야한다.
    var heigth = window.screen.availHeight;
    var width = window.screen.availWidth;
    var left = 0;
    var top = 0;

    var pleftpos;
    pleftpos = parseInt(width) - popUpW;
    heigth = parseInt(heigth) - popUpH;
    width = parseInt(width) - pleftpos;

    left = pleftpos / 2;
    top = heigth / 2;

    var feature = ",left=" + left + ",top=" + top;

    return feature
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
    var L_AM_Text = strLang238;
    var L_PM_Text = strLang239;
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

function memorialDayCheck(solarDate, lunarDate) {
    var i;
    var memorial;

    var tempmemorialDays = new Array();
    for (i = 0; i < memorialDays.length; i++) {
        if (solarDate.getFullYear() > 1800 && solarDate.getFullYear() <= 2101) {
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
    return tempyearmemorialDays;
}

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
[1, 2, 1, 2, 1, 4, 1, 2, 1, 2, 2, 2],
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
[2, 2, 1, 2, 1, 4, 1, 1, 2, 2, 1, 2],
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


function parseDate(dateStringInRange) {
    var isoExp = /^\s*(\d{4})-(\d\d)-(\d\d)\s*$/,
        date = new Date(NaN), month,
        parts = isoExp.exec(dateStringInRange);

    if (parts) {
        month = +parts[2];
        date.setFullYear(parts[1], month - 1, parts[3]);
        if (month != date.getMonth() + 1) {
            date.setTime(NaN);
        }
    }
    return date;
}
