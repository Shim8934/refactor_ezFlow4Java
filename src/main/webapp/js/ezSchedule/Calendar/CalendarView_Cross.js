var DefaultView = 0;
var sStartDate, sEndDate;
var typeCal = 0;
var sDate = parent.frames["left"].sDate;


var startOfWeek, endOfWeek;

var xmlhttp;
var g_szCurrentApptNum = null;
var g_szCurrentApptPNum;
var g_szCurrentApptOwnerID;
var g_szCurrentApptWriterID;
var g_szCurrentApptInsType;
var g_szCurrentApptGFlag;
var g_szCurrentApptSDate;
var g_szCurrentApptEDate;
var g_szCurrentApptDivID;

var g_selDivID = null;
var g_selTRID = null;
var g_selTDID = null;
var dayOfWeeks;

var monthHeight = ((parseInt(document.documentElement.clientHeight, 10) - 260) / 6) - 11;

function CalendarView(pTagetID) {

    document.getElementById(pTagetID).innerHTML = "";

    if (!parent.frames["left"].document.getElementById("iYear"))
        return;


    if (DefaultView == 0)
        dayOfWeeks = strLang5; 
    else if (DefaultView == 1)
        dayOfWeeks = strLang6; 

    var objElm = document.getElementById(pTagetID);
    if (objElm) {

        var tDiv = document.createElement("DIV");
        tDiv.setAttribute("id", "tooltip");
        tDiv.style.position = "absolute";
        tDiv.style.visibility = "hidden";
        tDiv.style.zIndex = "1000";
        tDiv.style.backgroundColor = "lightyellow";
        tDiv.innerHTML = "";
        objElm.appendChild(tDiv);

        if (sDate.getFullYear() > 1800 && sDate.getFullYear() <= 2101) {
            if (lunarMonthTable[sDate.getFullYear() - 1 - 1799][11] == 1)
                memorialDays[1].day = 29;
            else if (lunarMonthTable[sDate.getFullYear() - 1 - 1799][11] == 2)
                memorialDays[1].day = 30;
        }

        if (typeCal != 1) {
            var oTable = document.createElement("TABLE");
            var oTBody = document.createElement("TBODY");
            var oTr = document.createElement("TR");
            var oTh = document.createElement("TH");
            oTable.setAttribute("cellpadding", "0");
            oTable.setAttribute("cellspacing", "0");
            oTable.setAttribute("border", "0");
            oTable.setAttribute("width", "100%");
            oTh.setAttribute("id", "calTitle");
            oTh.colSpan = "2";
            if (typeCal == 2) {
                var tempyear = sDate.getFullYear();
                var tempmemorial;
                var tempyearmemorial
                if (tempyear > 1800 && tempyear <= 2101) {
                    var month = sDate.getMonth() + 1;
                    var LunarDate = lunarCalc(tempyear, month, sDate.getDate(), 1);
                    var LunarDatemonth = LunarDate.month;
                    var LunarDateday = LunarDate.day;
                    tempmemorial = memorialDayCheck(sDate, LunarDate);
                    tempyearmemorial = yearmemorialDayCheck(sDate, LunarDate);
                    LunarDate = LunarDatemonth + "." + LunarDateday;
                }

                oTable.className = "calendar_day_title";
                if (tempyear > 1800 && tempyear <= 2101) {
                    var isholiday = false;
                    var holidayname = "";;
                    var holidayname2 = "";;

                    for (var i = 0; i < tempmemorial.length; i++) {
                        memorial = tempmemorial[i];
                        if (uselang == "1") {
                            if (i == tempmemorial.length - 1)
                                holidayname += memorial.name;
                            else
                                holidayname += memorial.name + ", ";
                        }
                        else {
                            if (i == tempmemorial.length - 1)
                                holidayname += memorial.name2;
                            else
                                holidayname += memorial.name2 + ", ";
                        }
                        if (memorial.holiday)
                            isholiday = true;
                    }

                    for (var i = 0; i < tempyearmemorial.length; i++) {
                        yearmemorial = tempyearmemorial[i];
                        if (uselang == "1") {
                            if (i == tempyearmemorial.length - 1)
                                holidayname2 += yearmemorial.name;
                            else
                                holidayname2 += yearmemorial.name + ", ";
                        }
                        else {
                            if (i == tempyearmemorial.length - 1)
                                holidayname2 += yearmemorial.name2;
                            else
                                holidayname2 += yearmemorial.name2 + ", ";
                        }
                        if (yearmemorial.holiday)
                            isholiday = true;
                    }

                    if (holidayname != "" && holidayname2 != "")
                        holidayname = holidayname + ", " + holidayname2;
                    else if (holidayname == "" && holidayname2 != "")
                        holidayname = holidayname2;

                    var dayText;
                    if (LunarUse)
                        dayText = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2) + " " + holidayname + " (" + LunarDate + ")";
                    else
                        dayText = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2) + " " + holidayname;


                    var current_day = new Date(sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2));
                    if (current_day.getDay() == "6")
                        oTh.style.color = "#0032cf";
                    else if (current_day.getDay() == "0" || isholiday)
                        oTh.style.color = "#ee1c25";

                }
                else
                    var dayText = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2);
            }
            else {
                oTable.className = "calendar_month_navi";
                var dayText = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2);
            }

            var mSpan = document.createElement("SPAN");
            mSpan.className = "btn_prev";
            var mImg = document.createElement("IMG");
            mImg.setAttribute("src", "/images/calendar/btn_calendar_prev.gif");
            mImg.setAttribute("border", "0");
            if (typeCal == 0)
                mImg.setAttribute("onclick", "parent.frames[\"left\"].preMonth()");
            else
                mImg.setAttribute("onclick", "parent.frames[\"left\"].preDay()");

            mSpan.appendChild(mImg);
            oTh.appendChild(mSpan);

            var oText = document.createTextNode(" " + dayText + " ");
            oTh.appendChild(oText);

            var mSpan = document.createElement("SPAN");
            mSpan.className = "btn_next";
            var mImg = document.createElement("IMG");
            mImg.setAttribute("src", "/images/calendar/btn_calendar_next.gif");
            mImg.setAttribute("border", "0");
            if (typeCal == 0)
                mImg.setAttribute("onclick", "parent.frames[\"left\"].nextMonth()");
            else
                mImg.setAttribute("onclick", "parent.frames[\"left\"].nextDay()");
            mSpan.appendChild(mImg);
            oTh.appendChild(mSpan);
            oTBody.appendChild(oTh);

            if (typeCal == 2) {
                var oTr = document.createElement("TR");
                oTr.setAttribute("id", "calTR");
                var oTd = document.createElement("TD");
                oTd.className = "calendar_time";

                var dTable = document.createElement("TABLE")
                var dTbody = document.createElement("TBODY");
                dTable.setAttribute("cellpadding", "0");
                dTable.setAttribute("cellspacing", "0");
                dTable.setAttribute("border", "0");
                dTable.setAttribute("width", "100%");
                dTable.className = "calendar_row";
                var dTr = document.createElement("TR")
                var dTd = document.createElement("TD")
                dTd.className = "calendar_t_time";
                dTd.innerHTML = "<span class=\"point\">" + strLang124 + "</span>";
                dTr.appendChild(dTd);
                dTbody.appendChild(dTr);
                var dTr = document.createElement("TR")
                var dTd = document.createElement("TD")
                dTr.appendChild(dTd);
                dTbody.appendChild(dTr);
                dTable.appendChild(dTbody);
                oTd.appendChild(dTable);
                oTr.appendChild(oTd);

                var oTd = document.createElement("TD");
                oTd.className = "td_list";
                var dTable = document.createElement("TABLE")
                dTable.setAttribute("cellpadding", "0");
                dTable.setAttribute("cellspacing", "0");
                dTable.setAttribute("border", "0");
                dTable.setAttribute("width", "100%");
                dTable.className = "calendar_row";
                var dTr = document.createElement("TR")
                var dTd = document.createElement("TD")
                dTd.className = "calendar_t_time";
                var dDiv = document.createElement("DIV")
                dDiv.setAttribute("id", dayText.substring(0,10) + "ALL");
                dDiv.style.width = "100%"
                dDiv.style.height = "100px";
                dDiv.style.overflowY = "auto";
                dTd.appendChild(dDiv);
                dTr.appendChild(dTd);
                dTable.appendChild(dTr);
                var dTr = document.createElement("TR")
                var dTd = document.createElement("TD")
                dTd.className = "calendar_t_text";
                dTd.setAttribute("dispDate", dayText);
                dTd.setAttribute("ondblclick", "WriteDateSchedule(this)");
                dTr.appendChild(dTd);
                dTable.appendChild(dTr);
                oTd.appendChild(dTable);
                oTr.appendChild(oTd);
                oTBody.appendChild(oTr);
            }

            oTable.appendChild(oTBody);
            objElm.appendChild(oTable);
            if (typeCal == 2) {
                var oDiv = document.createElement("DIV");
                oDiv.setAttribute("id", "CalDiv")
            }

        }
        else {
            var oTable = document.createElement("TABLE");
            oTable.className = "calendar_week_navi";
            oTable.setAttribute("cellpadding", "0");
            oTable.setAttribute("cellspacing", "0");
            oTable.setAttribute("border", "0");
            oTable.setAttribute("width", "100%");
            var oTbody = document.createElement("TBODY");
            var objTr = document.createElement("TR");
            var objTd = document.createElement("TH");
            objTd.setAttribute("id", "list_Top");
            objTd.colSpan = "9";
            objTr.appendChild(objTd);
            oTbody.appendChild(objTr);
            oTable.appendChild(oTbody);
            objElm.appendChild(oTable);

            var oTBody = GetWeekTopObj();
            objElm.appendChild(oTBody);
            var oDiv = document.createElement("DIV");
            oDiv.setAttribute("id", "CalDiv")
        }



        var oTable = document.createElement("TABLE");
        oTable.setAttribute("id", "dayDiv");
        oTable.setAttribute("cellpadding", "0");
        oTable.setAttribute("cellspacing", "0");
        oTable.setAttribute("border", "0");
        oTable.setAttribute("width", "100%");
        if (typeCal == 0)
            oTable.className = "calendar_month";
        else if (typeCal == 1)
            oTable.className = "calendar_week";
        else if (typeCal == 2)
            oTable.className = "calendar_day";

        if (typeCal == 0)
            var oTBody = GetMonthBodyObj();
        else if (typeCal == 1)
            var oTBody = GetWeekBodyObj();
        else if (typeCal == 2)
            var oTBody = GetDayBodyObj();

        oTable.appendChild(oTBody);

        if (typeCal != 0) {
            oDiv.style.height = "580px";
            oDiv.style.borderBottomColor = "#b5b5b5";
            oDiv.style.borderBottomStyle = "solid";
            oDiv.style.borderBottomWidth = "1px";
            oDiv.style.overflowY = "auto";
            oDiv.appendChild(oTable);
            objElm.appendChild(oDiv);
        }
        else
            objElm.appendChild(oTable);

        objElm = null;
    }


    CalViewSource();
    resize();
}


function GetMonthBodyObj() {
    var year = parent.frames["left"].document.getElementById("iYear").value;
    var month = parseInt(parent.frames["left"].document.getElementById("iMon").value, 10);

    oBeforeDate = new Date(new Date(year, month - 1, 1) - 86400000);  
    oThisDate = new Date(year, month - 1, 1); 
    oBeforeDate.setTime(oBeforeDate.getTime() + (oBeforeDate.getTimezoneOffset() + (oBeforeDate.getHours() * 60) + oBeforeDate.getMinutes()) * 60 * 1000);
    oThisDate.setTime(oThisDate.getTime() + (oThisDate.getTimezoneOffset() + (oThisDate.getHours() * 60) + oThisDate.getMinutes()) * 60 * 1000);

    var oBeforeMaxDay = oBeforeDate.getDate();
    var startThisDay = oThisDate.getDay();
    oThisMonth = oThisDate.getMonth() + 1;

    if (oThisMonth == 12) {
        oThisMonth = 0;
    }

    oBeforeDate.setDate(oBeforeMaxDay - startThisDay + 1 + DefaultView); 

    var oTbody = document.createElement("TBODY");
    var objTr = document.createElement("TR");

    
    for (var j = 0; j < 7; j++) {
        var objTh = document.createElement("TH");
        var oText = document.createTextNode(dayOfWeeks.split(";")[j]);

        if (DefaultView == 0 && j == 0)
            objTh.className = "sun";
        else if (DefaultView == 0 && j == 6)
            objTh.className = "sat";

        if (DefaultView == 1 && j == 6)
            objTh.className = "sun";
        else if (DefaultView == 1 && j == 5)
            objTh.className = "sat";

        var className = "";
        if (DefaultView == 0 && j == 0 || DefaultView == 1 && j == 6)
            className = "sun";
        else if (DefaultView == 0 && j == 6 || DefaultView == 1 && j == 5)
            className = "sat";

        objTh.appendChild(oText);
        objTr.appendChild(objTh);
        objTh = null;
    }
    oTbody.appendChild(objTr);
    
    if (oBeforeMaxDay != 0) {
        oThisDate = oBeforeDate;
    }
    sStartDate = oThisDate.getFullYear() + "-" + (oThisDate.getMonth() + 1) + "-" + oThisDate.getDate();

    
    var TDIndex = 0;
    for (var i = 0; i < 6; i++) {
        var objTr = document.createElement("TR");

        for (var j = 0; j < 7; j++) {
            var objTd = MonthData(oThisDate, TDIndex);
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


function MonthData(oThisDate, TDIndex) {
    var tempyear = oThisDate.getFullYear();
    var LunarDateFull;
    var LunarDate;
    var LunarDate2;
    if (tempyear > 1800 && tempyear <= 2101) {
        var month = oThisDate.getMonth() + 1;
        LunarDate = lunarCalc(tempyear, month, oThisDate.getDate(), 1);
        var LunarDatemonth = LunarDate.month;
        var LunarDateday = LunarDate.day;
        LunarDate2 = LunarDatemonth + "." + LunarDateday;
    }

    var objTd = document.createElement("TD");

    
    if (oThisDate.getDate() == "1")
        var pDateData = (oThisDate.getMonth() + 1) + strLang122 + " " + oThisDate.getDate() + strLang123
    else
        var pDateData = oThisDate.getDate()

    var tempmemorial = memorialDayCheck(oThisDate, LunarDate);
    var tempyearmemorial = yearmemorialDayCheck(oThisDate, LunarDate);

    var isholiday = false;
    var holidayname = "";;
    var holidayname2 = "";;

    for (var i = 0; i < tempmemorial.length; i++) {
        memorial = tempmemorial[i];
        if (uselang == "1") {
            if (i == tempmemorial.length - 1)
                holidayname += memorial.name;
            else
                holidayname += memorial.name + ", ";
        }
        else {
            if (i == tempmemorial.length - 1)
                holidayname += memorial.name2;
            else
                holidayname += memorial.name2 + ", ";
        }
        if (memorial.holiday)
            isholiday = true;
    }

    for (var i = 0; i < tempyearmemorial.length; i++) {
        yearmemorial = tempyearmemorial[i];
        if (uselang == "1") {
            if (i == tempyearmemorial.length - 1)
                holidayname2 += yearmemorial.name;
            else
                holidayname2 += yearmemorial.name + ", ";
        }
        else {
            if (i == tempyearmemorial.length - 1)
                holidayname2 += yearmemorial.name2;
            else
                holidayname2 += yearmemorial.name2 + ", ";
        }
        if (yearmemorial.holiday)
            isholiday = true;
    }

    if (holidayname != "" && holidayname2 != "")
        holidayname = holidayname + ", " + holidayname2;
    else if (holidayname == "" && holidayname2 != "")
        holidayname = holidayname2;

    var className = "";
    if (oThisMonth != oThisDate.getMonth()) 
        className = " gray";
    else if (oThisDate.getDay() == 0 || isholiday)  
        className = " sun";
    else if (oThisDate.getDay() == 6)  
        className = " sat";


    var nowDate = new Date();
    var cell_ID = (oThisDate.getFullYear()) + "-" + leadingZeros((oThisDate.getMonth() + 1), 2) + "-" + leadingZeros(oThisDate.getDate(), 2);
    var nowDay = (nowDate.getFullYear()) + "-" + leadingZeros((nowDate.getMonth() + 1), 2) + "-" + leadingZeros(nowDate.getDate(), 2);

    if (cell_ID == nowDay)
        objTd.className = "today";  
    else
        objTd.className = className; 

    objTd.setAttribute("id", "index_" + TDIndex);
    objTd.setAttribute("day", cell_ID);
    objTd.onmousedown = function (event) { MultiSelectStart(this, event); };
    objTd.onmouseup = function (event) { MultiSelectEnd(this, event); };
    //objTd.onmouseover = function (event) { MultiSelectItems(this, event); };

    
    var subTable = document.createElement("TABLE")
    var subTr = document.createElement("TR")
    var subTd = document.createElement("TD")
    subTable.className = "td_day" + className;
    subTable.setAttribute("cellpadding", "0");
    subTable.setAttribute("cellspacing", "0");
    subTable.setAttribute("border", "0");
    subTd.setAttribute("id", "TD_" + cell_ID + "_Day");
    subTd.setAttribute("onmouseover", "MonthlyViewHeader_onMouseOver(this)");
    subTd.setAttribute("onmouseout", "MonthlyViewHeader_onMouseOut(this)");
    subTd.setAttribute("ondblclick", "WriteDateSchedule(this)");
    subTd.setAttribute("dispDate", cell_ID);
    
    if (tempyear > 1800 && tempyear <= 2101) {
        if (LunarUse)
            subTd.innerHTML = pDateData + " (" + LunarDate2 + ") " + holidayname;
        else
            subTd.innerHTML = pDateData + " " + holidayname;
    }
    else
        subTd.innerHTML = pDateData;

    subTr.appendChild(subTd);
    subTable.appendChild(subTr);
    objTd.appendChild(subTable);

    
    var subSpan = document.createElement("SPAN")
    var subTable = document.createElement("TABLE")
    subSpan.className = "span_list";

    if (monthHeight < 50)
        monthHeight = 70;
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


var DragStartItemID = "";
var DragEndItemID = "";
var IsDrag = false;
function MultiSelectStart(obj, event) {
    IsDrag = true;
    DragStartItemID = GetAttribute(obj, "id");
}
function MultiSelectItems(obj, event) {
    if (IsDrag) {
        var StartIdex = parseInt(DragStartItemID.replace("index_",""));
        var Endidex = parseInt(GetAttribute(obj, "id").replace("index_", ""));

        if (StartIdex > Endidex) {
            var tempIndex = Endidex;
            Endidex = StartIdex;
            StartIdex = tempIndex;
        }

        for (var i = 0; i <= 41; i++) {
            if (StartIdex <= i && Endidex >= i)
                document.getElementById("index_" + i).style.backgroundColor = "#DBE1E7";
            else
                document.getElementById("index_" + i).style.backgroundColor = "";
        }
    }
}
function MultiSelectEnd(obj, event) {
    IsDrag = false;
    DragEndItemID = GetAttribute(obj, "id");
    if (DragStartItemID == DragEndItemID) {
        document.getElementById(DragEndItemID).style.backgroundColor = "";
        DragStartItemID = "";
        DragEndItemID = "";
        return;
    }
    obj.style.backgroundColor = "#DBE1E7";
    Write();
}
function Write() {
    var StartIdex = parseInt(DragStartItemID.replace("index_", ""));
    var Endidex = parseInt(DragEndItemID.replace("index_", ""));

    if (StartIdex > Endidex) {
        var tempIndex = DragEndItemID;
        DragEndItemID = DragStartItemID;
        DragStartItemID = tempIndex;
    }
    var startdate = GetAttribute(document.getElementById(DragStartItemID), "day");
    var enddate = GetAttribute(document.getElementById(DragEndItemID), "day");

    var pheight = window.screen.availHeight;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - 760) / 2;
    var pLeft = (pwidth - 790) / 2;
    var feature = GetOpenPosition(790, 830);
    if (CrossYN()) {
        window.open("schedule_write_Cross.aspx?defaultid=0&startdate=" + startdate + "&enddate=" + enddate + "", "", "height = 830px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
    }
    else {
        window.open("schedule_write.aspx?defaultid=0&startdate=" + startdate + "&enddate=" + enddate + "", "", "height = 660px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
    }
    DragStartItemID = "";
    DragEndItemID = "";
    for (var i = 0; i <= 41; i++) {
        document.getElementById("index_" + i).style.backgroundColor = "";
    }
}


function GetWeekTopObj() {
    var oTable = document.createElement("TABLE");
    oTable.className = "calendar_week_title";
    oTable.setAttribute("cellpadding", "0");
    oTable.setAttribute("cellspacing", "0");
    oTable.setAttribute("border", "0");
    oTable.setAttribute("width", "100%");
    var oTBody = document.createElement("TBODY");
    var objTr = document.createElement("TR");
    var objTd = document.createElement("TH");
    objTd.className = "calendar_th_time"
    objTr.appendChild(objTd);
    
    for (var j = 0; j < 7; j++) {
        var objTd = document.createElement("TH");

        var className = "";
        if (DefaultView == 0 && j == 0 || DefaultView == 1 && j == 6)
            className = "sun";
        else if (DefaultView == 0 && j == 6 || DefaultView == 1 && j == 5)
            className = "sat";

        objTd.className = "calendar_th_list " + className;

        objTd.setAttribute("id", "list_Title" + j);
        objTr.appendChild(objTd);

        objTd.style.overflow = "hidden";
        objTd.style.textOverflow = "ellipsis";
    }

    var objTd = document.createElement("TH");
    objTd.className = "calendar_th_last"
    objTr.appendChild(objTd);
    oTBody.appendChild(objTr);

    var objTr = document.createElement("TR");
    objTr.setAttribute("id", "calTR");
    var objTd = document.createElement("TD");
    objTd.className = "calendar_time";

    var dTable = document.createElement("TABLE")
    var dTbody = document.createElement("TBODY");
    dTable.setAttribute("cellpadding", "0");
    dTable.setAttribute("cellspacing", "0");
    dTable.setAttribute("border", "0");
    dTable.setAttribute("width", "100%");
    dTable.className = "calendar_row";
    var dTr = document.createElement("TR")
    var dTd = document.createElement("TD")
    dTd.className = "calendar_t_time";
    dTd.innerHTML = "<span class=\"point\">" + strLang124 + "</span>";
    dTr.appendChild(dTd);
    dTbody.appendChild(dTr);
    var dTr = document.createElement("TR")
    var dTd = document.createElement("TD")
    dTr.appendChild(dTd);
    dTbody.appendChild(dTr);
    dTable.appendChild(dTbody);
    objTd.appendChild(dTable);
    objTr.appendChild(objTd);

    oTBody.appendChild(objTr);
    oTable.appendChild(oTBody);

    return oTable;
}

function GetWeekBodyObj() {
    startOfWeek = new Date(sDate);
    startOfWeek.setDate(sDate.getDate() - sDate.getDay() + DefaultView);
    var startYear = startOfWeek.getFullYear();
    var startMonth = startOfWeek.getMonth();
    var startDate = startOfWeek.getDate();

    sStartDate = startYear + "-" + (startMonth + 1) + "-" + startDate
    endOfWeek = new Date(sDate);
    endOfWeek.setDate(sDate.getDate() + (6 - sDate.getDay()) + DefaultView);

    var endYear = endOfWeek.getFullYear();
    var endMonth = endOfWeek.getMonth();
    var endDate = endOfWeek.getDate();

    sEndDate = endYear + "-" + (endMonth + 1) + "-" + endDate
    var oTbody = document.createElement("TBODY");
    var oTr = document.createElement("TR");
    var oTD = document.createElement("TD");
    oTD.className = "calendar_time";

    var oText = document.createTextNode(" " + startYear + "-" + leadingZeros((startMonth + 1), 2) + "-" + leadingZeros(startDate, 2) + " ~ " + endYear + "-" + leadingZeros((endMonth + 1), 2) + "-" + leadingZeros(endDate, 2) + " ");

    var mSpan = document.createElement("SPAN");
    mSpan.className = "btn_prev";
    var mImg = document.createElement("IMG");
    mImg.setAttribute("src", "/images/calendar/btn_calendar_prev.gif");
    mImg.setAttribute("border", "0");
    mImg.setAttribute("onclick", "parent.frames[\"left\"].preWeek()");
    mSpan.appendChild(mImg);
    document.getElementById("list_Top").appendChild(mSpan);

    document.getElementById("list_Top").appendChild(oText);

    var mSpan = document.createElement("SPAN");
    mSpan.className = "btn_next";
    var mImg = document.createElement("IMG");
    mImg.setAttribute("src", "/images/calendar/btn_calendar_next.gif");
    mImg.setAttribute("border", "0");
    mImg.setAttribute("onclick", "parent.frames[\"left\"].nextWeek()");
    mSpan.appendChild(mImg);
    document.getElementById("list_Top").appendChild(mSpan);

    for (var k = 0; k < 24; k++) {
        var dTable = document.createElement("TABLE")
        var dTbody = document.createElement("TBODY");
        dTable.setAttribute("cellpadding", "0");
        dTable.setAttribute("cellspacing", "0");
        dTable.setAttribute("border", "0");
        dTable.setAttribute("width", "100%");
        dTable.className = "calendar_row";
        var dTr = document.createElement("TR")
        var dTd = document.createElement("TD")
        dTd.className = "calendar_t_time";

        if (k == 0)
            dTd.innerHTML = strLang1 + " <span class=\"point\">12</span> " + strLang128;
        else if (k == 12)
            dTd.innerHTML = strLang2 + " <span class=\"point\">" + k + "</span> " + strLang128;
        else
            dTd.innerHTML = "<span class=\"point\">" + k + "</span> " + strLang128;
        dTr.appendChild(dTd);
        dTbody.appendChild(dTr);
        var dTr = document.createElement("TR")
        var dTd = document.createElement("TD")
        dTr.appendChild(dTd);
        dTbody.appendChild(dTr);
        dTable.appendChild(dTbody);
        oTD.appendChild(dTable);
    }
    oTr.appendChild(oTD);


    
    for (var j = 0; j < 7; j++) {
        var objTD = WeekData(startOfWeek, dayOfWeeks.split(";")[j], j);
        oTr.appendChild(objTD);

        startOfWeek.setDate(startOfWeek.getDate() + 1)
        endOfWeek.setDate(endOfWeek.getDate() + 1)

    }

    var calTr = document.getElementById("calTR");
    if (calTr) {
        var objTd = document.createElement("TD");
        objTd.className = "calendar_td_last"
        calTr.appendChild(objTd);
    }
    oTbody.appendChild(oTr);
    oTr = null;
    return oTbody;
}


function WeekData(startOfWeek, dayOfWeek, pCnt) {
    var tempyear = startOfWeek.getFullYear();
    var LunarDateFull;
    var LunarDate;
    var LunarDate2;

    if (tempyear > 1800 && tempyear <= 2101) {
        var month = startOfWeek.getMonth() + 1;
        LunarDate = lunarCalc(tempyear, month, startOfWeek.getDate(), 1);
        var LunarDatemonth = LunarDate.month;
        var LunarDateday = LunarDate.day;
        LunarDate2 = LunarDatemonth + "." + LunarDateday;
    }

    var divID = (startOfWeek.getFullYear()) + "-" + leadingZeros((startOfWeek.getMonth() + 1), 2) + "-" + leadingZeros(startOfWeek.getDate(), 2);

    if (tempyear > 1800 && tempyear <= 2101) {
        var tempmemorial = memorialDayCheck(startOfWeek, LunarDate);
        var tempyearmemorial = yearmemorialDayCheck(startOfWeek, LunarDate);

        var isholiday = false;
        var holidayname = "";;
        var holidayname2 = "";;

        for (var i = 0; i < tempmemorial.length; i++) {
            memorial = tempmemorial[i];
            if (uselang == "1") {
                if (i == tempmemorial.length - 1)
                    holidayname += memorial.name;
                else
                    holidayname += memorial.name + ", ";
            }
            else {
                if (i == tempmemorial.length - 1)
                    holidayname += memorial.name2;
                else
                    holidayname += memorial.name2 + ", ";
            }
            if (memorial.holiday)
                isholiday = true;
        }

        for (var i = 0; i < tempyearmemorial.length; i++) {
            yearmemorial = tempyearmemorial[i];
            if (uselang == "1") {
                if (i == tempyearmemorial.length - 1)
                    holidayname2 += yearmemorial.name;
                else
                    holidayname2 += yearmemorial.name + ", ";
            }
            else {
                if (i == tempyearmemorial.length - 1)
                    holidayname2 += yearmemorial.name2;
                else
                    holidayname2 += yearmemorial.name2 + ", ";
            }
            if (yearmemorial.holiday)
                isholiday = true;
        }

        if (holidayname != "" && holidayname2 != "")
            holidayname = holidayname + ", " + holidayname2;
        else if (holidayname == "" && holidayname2 != "")
            holidayname = holidayname2;

        var weekData;
        if (LunarUse)
            weekData = leadingZeros((startOfWeek.getMonth() + 1), 2) + "-" + leadingZeros(startOfWeek.getDate(), 2) + " [" + dayOfWeek + "] " + holidayname + " (" + LunarDate2 + ")";
        else
            weekData = leadingZeros((startOfWeek.getMonth() + 1), 2) + "-" + leadingZeros(startOfWeek.getDate(), 2) + " [" + dayOfWeek + "] " + holidayname;
        if (isholiday)
            document.getElementById("list_Title" + pCnt).className += " sun";
    }
    else
        var weekData = leadingZeros((startOfWeek.getMonth() + 1), 2) + "-" + leadingZeros(startOfWeek.getDate(), 2) + " [" + dayOfWeek + "]";

    var oText = document.createTextNode(weekData);
    document.getElementById("list_Title" + pCnt).appendChild(oText);

    if (screen.width < 1025) {
        document.getElementById("list_Title" + pCnt).style.whiteSpace = "nowrap";
        document.getElementById("list_Title" + pCnt).style.overflow = "hidden";
        document.getElementById("list_Title" + pCnt).style.textOverflow = "ellipsis";
        document.getElementById("list_Title" + pCnt).title = weekData;
    }

    var objTd = document.createElement("TD");
    objTd.className = "td_list";

    var calTr = document.getElementById("calTR");
    if (calTr) {

        var tTd = document.createElement("TD");
        tTd.className = "td_list";

        var dTable = document.createElement("TABLE")
        dTable.setAttribute("cellpadding", "0");
        dTable.setAttribute("cellspacing", "0");
        dTable.setAttribute("border", "0");
        dTable.setAttribute("width", "100%");
        dTable.className = "calendar_row";
        var dTr = document.createElement("TR")
        var dTd = document.createElement("TD")
        dTd.className = "calendar_t_time";
        var dDiv = document.createElement("DIV")
        dDiv.setAttribute("id", divID + "ALL");
        dDiv.style.height = "100px";
        dDiv.style.overflowY = "auto";
        dDiv.style.overflowN = "hidden";
        dDiv.style.whiteSpace = "noWrap";
        dTd.appendChild(dDiv);
        dTr.appendChild(dTd);
        dTable.appendChild(dTr);
        var dTr = document.createElement("TR")
        var dTd = document.createElement("TD")
        dTd.className = "calendar_t_text";
        dTd.setAttribute("dispDate", divID);
        dTd.setAttribute("ondblclick", "WriteDateSchedule(this)");
        dTr.appendChild(dTd);
        dTable.appendChild(dTr);
        tTd.appendChild(dTable);
        calTr.appendChild(tTd);
    }

    for (var k = 0; k < 24; k++) {
        var dTable = document.createElement("TABLE")
        dTable.setAttribute("cellpadding", "0");
        dTable.setAttribute("cellspacing", "0");
        dTable.setAttribute("border", "0");
        dTable.setAttribute("width", "100%");
        if (pDisplaySTime <= k && pDisplayETime > k)
            dTable.className = "calendar_row today";
        else
            dTable.className = "calendar_row";
        var dTr = document.createElement("TR")
        var dTd = document.createElement("TD")
        dTd.className = "calendar_t_time";
        dTd.setAttribute("id", "TD_" + divID + "_" + k + ":0_Value");
        dTd.setAttribute("ondblclick", "WriteDateSchedule(this)");
        dTd.setAttribute("dispTime", divID + " " + leadingZeros(k, 2) + ":00:00");
        dTr.appendChild(dTd);
        dTable.appendChild(dTr);
        var dTr = document.createElement("TR")
        var dTd = document.createElement("TD")
        dTd.className = "calendar_t_text";
        dTd.setAttribute("id", "TD_" + divID + "_" + k + ":3_Value");
        dTd.setAttribute("ondblclick", "WriteDateSchedule(this)");
        dTd.setAttribute("dispTime", divID + " " + leadingZeros(k, 2) + ":00:00");
        dTr.appendChild(dTd);
        dTable.appendChild(dTr);
        objTd.appendChild(dTable);

    }
    return objTd;
}



function GetDayBodyObj() {
    var oTbody = document.createElement("TBODY");
    var objTr = document.createElement("TR");
    var objTd = document.createElement("TD");
    objTd.className = "calendar_time";

    for (var k = 0; k < 24; k++) {
        var dTable = document.createElement("TABLE")
        var dTbody = document.createElement("TBODY");
        dTable.setAttribute("cellpadding", "0");
        dTable.setAttribute("cellspacing", "0");
        dTable.setAttribute("border", "0");
        dTable.setAttribute("width", "100%");
        dTable.className = "calendar_row";
        var dTr = document.createElement("TR")
        var dTd = document.createElement("TD")
        dTd.className = "calendar_t_time";

        if (k == 0)
            dTd.innerHTML = strLang1 + " <span class=\"point\">12</span> " + strLang128;
        else if (k == 12)
            dTd.innerHTML = strLang2 + " <span class=\"point\">" + k + "</span> " + strLang128;
        else
            dTd.innerHTML = "<span class=\"point\">" + k + "</span> " + strLang128;
        dTr.appendChild(dTd);
        dTbody.appendChild(dTr);
        var dTr = document.createElement("TR")
        var dTd = document.createElement("TD")
        dTr.appendChild(dTd);
        dTbody.appendChild(dTr);
        dTable.appendChild(dTbody);
        objTd.appendChild(dTable);
    }

    objTr.appendChild(objTd);


    var objTd = document.createElement("TD");
    objTd.className = "td_list";

    for (var j = 0; j < 24; j++) {

        var objTD = DayData(j);
        objTd.appendChild(objTD);
    }
    objTr.appendChild(objTd);
    oTbody.appendChild(objTr);

    objTr = null;
    sStartDate = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2)
    sDate.setDate(sDate.getDate() + 1);
    sEndDate = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2)
    sDate.setDate(sDate.getDate() - 1);
    return oTbody;
}


function DayData(j) {

    var divID = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2);
    var sTable = document.createElement("TABLE");
    sTable.setAttribute("cellpadding", "0");
    sTable.setAttribute("cellspacing", "0");
    sTable.setAttribute("border", "0");
    sTable.setAttribute("width", "100%");
    if (pDisplaySTime <= j && pDisplayETime > j)
        sTable.className = "calendar_row today";
    else
        sTable.className = "calendar_row";
    var s_Tr = document.createElement("TR");
    var s_Td = document.createElement("TD");
    s_Td.className = "calendar_t_time";
    s_Td.setAttribute("id", "TD_" + divID + "_" + j + ":0_Value");
    s_Td.setAttribute("ondblclick", "WriteDateSchedule(this)");
    s_Td.setAttribute("dispTime", divID + " " + leadingZeros(j, 2) + ":00:00");
    s_Tr.appendChild(s_Td);
    sTable.appendChild(s_Tr);
    var s_Tr = document.createElement("TR");
    var s_Td = document.createElement("TD");
    s_Td.className = "calendar_t_text";
    s_Td.setAttribute("ondblclick", "WriteDateSchedule(this)");
    s_Td.setAttribute("id", "TD_" + divID + "_" + j + ":3_Value");
    s_Td.setAttribute("dispTime", divID + " " + leadingZeros(j, 2) + ":00:00");
    s_Tr.appendChild(s_Td);
    sTable.appendChild(s_Tr);
    return sTable;
}





function mfGetUTFIsoDate(iYr, iMon, iDate, iHr, iMin) {
    var oDate = new Date();
    oDate.setFullYear(iYr, iMon, iDate);
    oDate.setHours(iHr, iMin, 0);

    var iYear = oDate.getFullYear();
    var szMonth = oDate.getMonth() + 1; 
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
    if (-1 < szRet.search(/\[t/g)) 
    {
        szRet = szRet.replace(/\[tt\]/g, (iHr > 11 && iHr < 24) ? L_PM_Text : L_AM_Text);
        szRet = szRet.replace(/\[t\]/g, (iHr > 11 && iHr < 24) ? L_PM_Text : L_AM_Text);
    }
    if (-1 < szRet.search(/\[h/g)) 
    {
        if (iHr > 12) iHr -= 12;
        if (iHr == 0) iHr = 12;
        szRet = szRet.replace(/\[hh\]/g, iHr > 9 ? iHr : "0" + iHr);
        szRet = szRet.replace(/\[h\]/g, iHr);
    }
    if (-1 < szRet.search(/\[H/g)) 
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
            if (memorialDays[i].month == lunarDate.month &&
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
            if (yearmemorialDays[i].year == lunarDate.year &&
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