//오늘의 날짜 (년도, 월, 일, 오늘의 요일)
var weektodate = new Date();

//전역변수 (년도, 월, 일, 요일)
var	sz_Year = "";
var	sz_Month = "";
var	sz_Date	= "";
var sz_DayOfWeek = "";

//전역변수 (이번주의 시작일 과 마지막일);
var weekStartDate = "";
var weekEndDate = "";

var dayname = new Array(strLang270, strLang271, strLang272, strLang273, strLang274, strLang275, strLang276);

var resource_text = "";
var tdcount = 0;

var c_xmlhttp = createXMLHttpRequest();

//XMLHttpRequest객체를 생성합니다.
function createXMLHttpRequest() {
    var oXmlRequest;
    try {
        //파폭,크롬,오페라,사파리등등
        oXmlRequest = new XMLHttpRequest();
    }
    catch (trymicrosoft) {
        try {
            oXmlRequest = new ActiveXObject("Microsoft.XMLHTTP");
        }
        catch (failed) {
            oXmlRequest = false;
        }
    }

    return oXmlRequest;
}
//일보기
function todayonlaod(s_Year, s_Month, s_Date)
{
    //오늘의 데이터를 전역변수에 담아준다.
    if (s_Year != null && s_Month != null && s_Date != null &&
        s_Year != "" && s_Month != "" && s_Date != "")
    {
        var weekSetDate = new Date(s_Year, s_Month -1, s_Date);
        sz_Year = weekSetDate.getFullYear();
        sz_Month = weekSetDate.getMonth();
        sz_Date = weekSetDate.getDate();
        sz_DayOfWeek = weekSetDate.getDay();
    }
    
    weekStartDate = new Date(sz_Year, sz_Month, sz_Date);
    
    //시작일 : 신청자명단위해..
    mfGetSearchDate(weekStartDate);

    c_xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "STARTDATETIME", datanameweek(sz_Year, sz_Month + 1, sz_Date, "YES"));
    createNodeAndInsertText(xmlpara, objNode, "ENDDATETIME", datanameweek(sz_Year, sz_Month + 1, sz_Date, "YES"));
    createNodeAndInsertText(xmlpara, objNode, "APP", "1");
    
    //요청하고자 하는 자원의 값을 받아온다. 전체검색은 = TOTAL
    var param = "&resID=" + pBrdid + "&pType=" + p_Type;
    
    //요청하고자하는 페이지 URL 
    var P_Url = folder_Url;
    
    c_xmlhttp.open("POST", P_Url + "?cmd=get" + param, true);
    c_xmlhttp.onreadystatechange = tableListControl_today;
    c_xmlhttp.send(xmlpara);
}

//20120912_자원관리 : 주보기
function weekonload(s_Year, s_Month, s_Date)
{
    //오늘의 데이터를 뽑아서 전역변수에 담는다.
    if (s_Year != null && s_Month != null && s_Date != null &&
        s_Year != "" && s_Month != "" && s_Date != "") {
        var weekSetDate = new Date(s_Year, s_Month - 1 , s_Date);
        //var weekSetDate = new Date();
        sz_Year = weekSetDate.getFullYear();
        sz_Month = weekSetDate.getMonth();
        sz_Date = weekSetDate.getDate();
        sz_DayOfWeek = weekSetDate.getDay();
    }
    //오늘의 날짜를 기준으로 요번주의 시작날짜 0~6 / 일~토 를 구한다. 지금현재는 월요일시작기준으로 date에 + 1을 해주었다.
    if (sz_DayOfWeek == 0)
        weekStartDate = new Date(sz_Year, sz_Month, (sz_Date - sz_DayOfWeek) - 6);
    else
        weekStartDate = new Date(sz_Year, sz_Month, (sz_Date - sz_DayOfWeek) + 1);
    //오늘의 날짜를 기준으로 요번주의 마지막날짜를 가져온다.

    if (sz_DayOfWeek == 0)
        weekEndDate = new Date(sz_Year, sz_Month, sz_Date + (sz_DayOfWeek));
    else
        weekEndDate = new Date(sz_Year, sz_Month, sz_Date + (6 - sz_DayOfWeek) + 1);
    
    mfGetSearchDate(weekStartDate);
    
    c_xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "STARTDATETIME", datanameweek(sz_Year, sz_Month + 1, sz_Date, "YES"));
    createNodeAndInsertText(xmlpara, objNode, "ENDDATETIME", datanameweek(weekEndDate.getFullYear(), weekEndDate.getMonth() + 1, weekEndDate.getDate(), "YES"));
    createNodeAndInsertText(xmlpara, objNode, "APP", "1");
    
    var param = "&resID=" + pBrdid + "&pType=" + p_Type;
        
    var P_Url = folder_Url;
    
    c_xmlhttp.open("POST", P_Url + "?cmd=get" + param, true);
    c_xmlhttp.setRequestHeader("Content-Type", "text/xml");
    c_xmlhttp.onreadystatechange = tableListControl_Week;
    c_xmlhttp.send(xmlpara);
}

function nextToday_onclick(result)  
{
    if(result == "PREV")
    {
        //지난주보기 : 처음 호출시 전역변수에 등록되어 있는 값을 가져와 저번주에 해당하는 날짜데이터를 뽑아온다.
        weekStartDate = new Date(sz_Year, sz_Month, sz_Date - 1); 
    }
    else if(result == "NEXT")
    {
        //다음주보기 : 처음 호출 시 전역변수에 넣어진 값을 가져와 다음주에 해당하는 날짜데이터를 뽑아온다.
        weekStartDate = new Date(sz_Year, sz_Month, sz_Date + 1); 
    }
    mfGetSearchDate(weekStartDate);
    

    c_xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "STARTDATETIME", datanameweek(sz_Year, sz_Month + 1, sz_Date, "YES"));
    createNodeAndInsertText(xmlpara, objNode, "ENDDATETIME", datanameweek(sz_Year, sz_Month + 1, sz_Date, "YES"));
    createNodeAndInsertText(xmlpara, objNode, "APP", "1");

    var param = "&resID=" + pBrdid + "&pType=" + p_Type;
    
    var P_Url = folder_Url;
    
    //c_xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    c_xmlhttp.open("POST", P_Url + "?cmd=get" + param, true);
    c_xmlhttp.setRequestHeader("Content-Type", "text/xml");
    
    if (resource_text == "Resource")
        c_xmlhttp.onreadystatechange = ResourcetList;
    else 
        c_xmlhttp.onreadystatechange = tableListControl_today;
    
    c_xmlhttp.send(xmlpara);
}

function nextWeek_onclick(result) {

    if(result == "PREV")
    {
        //지난주보기 : 처음 호출시 전역변수에 등록되어 있는 값을 가져와 저번주에 해당하는 날짜데이터를 뽑아온다.
        weekStartDate = new Date(sz_Year, sz_Month, sz_Date - sz_DayOfWeek - 6); 
        weekEndDate = new Date(sz_Year, sz_Month, sz_Date + (6 - sz_DayOfWeek) - 6); 
    }
    else if(result == "NEXT")
    {
        //다음주보기 : 처음 호출 시 전역변수에 넣어진 값을 가져와 다음주에 해당하는 날짜데이터를 뽑아온다.
        weekStartDate = new Date(sz_Year, sz_Month, sz_Date - sz_DayOfWeek + 8); 
        weekEndDate = new Date(sz_Year, sz_Month, sz_Date + (6 - sz_DayOfWeek) + 8); 
    }
    
    //weekStartDate에 대한 값이 설정되었으면 mfGetSearchDate함수를 통해 변수에 값을 저장해놓는다.
    mfGetSearchDate(weekStartDate);

    c_xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "STARTDATETIME", datanameweek(sz_Year, sz_Month + 1, sz_Date, "YES"));
    createNodeAndInsertText(xmlpara, objNode, "ENDDATETIME", datanameweek(weekEndDate.getFullYear(), weekEndDate.getMonth() + 1, weekEndDate.getDate(), "YES"));
    createNodeAndInsertText(xmlpara, objNode, "APP", "1");
    
    var param = "&resID=" + pBrdid + "&pType=" + p_Type;

    var P_Url = folder_Url;

    c_xmlhttp.open("POST", P_Url + "?cmd=get" + param, true);
    c_xmlhttp.setRequestHeader("Content-Type", "text/xml");
    c_xmlhttp.onreadystatechange = tableListControl_Week;
    
    c_xmlhttp.send(xmlpara);
}

//저번주,이번주, 다음달,저번달에 대한 값을 전역변수에 저장.
function mfGetSearchDate(objDate)
{
    sz_Year		= objDate.getFullYear();
    sz_Month		= objDate.getMonth();
    sz_Date		= objDate.getDate();
    sz_DayOfWeek = objDate.getDay();
}

//날짜를 가지고 문자열로 만들어 리턴값을 정한다.
function datanameweek(year, month, day, contral)
{
    var DateReslut = "";
    
    if(contral == "YES")
    {
        DateReslut = String(year) + "-" +
        String(((month<10)?"0" + month : month)) + "-" +
        String(((day  <10)?"0" + day : day));
    }
    else if(contral == "HEARDER")
    {
        DateReslut = String(year) + strLang277 + " " + 
        String(((month < 10) ? "0" + month : month)) + strLang279 +
        String(((day < 10) ? "0" + day : day)) + strLang278;
    }
    else if (contral == "ADD")
    {
        DateReslut = String(year) + 
        String(((month < 10) ? "0" + month : month)) +
        String(((day < 10) ? "0" + day : day));
    }
    else
    {
        DateReslut =
        String(((month < 10) ? "0" + month : month)) + "/" +
        String(((day < 10) ? "0" + day : day));
    }

    return(DateReslut);	
}

//주보기시...
function tableListControl_Week()
{
    if (c_xmlhttp.readyState == 4 && c_xmlhttp.status == 200) {
        var xmldom = createXmlDom();
        var XMLstring = c_xmlhttp.responseText;
        xmldom = loadXMLString(XMLstring);

        //시작일의 텍스트와 마지막일의 텍스트를 출력
        var weekStartDatename = datanameweek(weekStartDate.getFullYear(), weekStartDate.getMonth() + 1, weekStartDate.getDate(), "HEARDER");
        var weekEndDatename = datanameweek(weekEndDate.getFullYear(), weekEndDate.getMonth() + 1, weekEndDate.getDate(), "HEARDER");
        //상단에 해더 출력 ex)2012년 9월 10일 ~ 20120 9월 16일
        document.getElementById("divViewHeader").textContent = weekStartDatename + " ~ " + weekEndDatename;
        //테이블구조에서 날짜를 출력한 후 날짜를 담을 변수
        var weekdatename = new Array();
        var b = 0;
        //맨처음 테이블을 시작하는 td에 넣어줄 텍스트
        var _mtable = document.createElement("TABLE");
        _mtable.setAttribute("class", "table_layout");
        var _mtr = document.createElement("TR");
        var _mth = document.createElement("th");
        var _mtd = document.createElement("TD");
        _mth.style.width = "200px";
        _mth.setAttribute("style", "vertical-align:middle");
        _mth.textContent = strLang266;
        _mtr.appendChild(_mth);
        _mtable.appendChild(_mtr);

        //만약에 요번달의 마지막날이 지났을 경우 사용하게 될 임의 변수
        var nextmonthfirstday = 1;

        //이번달의 마지막일 : 31일
        var endDayOfMay = new Date(sz_Year, sz_Month + 1, 0);
        var endMonthday = endDayOfMay.getDate();

        //요일을 출력한 임의 변수
        var countdayname = 1;

        //금주의 시작일 월요일 부터 일요일까지 
        for (var i = sz_Date; i <= sz_Date + 6; i++) {
            //월요일부터 시작 이니깐 1부터 6까지 돌면 마지막에 0으로 변경
            if (countdayname > 6)
                countdayname = 0;

            //만약에 요번달의 마지막날짜와 같거나 작다면 그리고 0보다는 크다면
            if (i <= endMonthday && i > 0) {
                //출력할 날짜에 대한 값을 저장
                var D_nowdate = datanameweek(sz_Year, sz_Month + 1, i, "ADD");
                var D_nowdateTitle = datanameweek(sz_Year, sz_Month + 1, i, "NO");

                var AddDate = datanameweek(sz_Year, sz_Month + 1, i, "YES");
                _mth = document.createElement("TH");
                _mth.style.width = "14.2%";
                _mth.setAttribute("style", "vertical-align:middle");
                _mth.onmouseover = new Function("onmouse_over_Week(this);");
                _mth.onmouseout = new Function("onmouse_out_Week(this);");
                _mth.ondblclick = new Function("idCalendarViewer_OnDoubleClickAppointment2('','" + title_name[0].split("/")[0] + "','" + AddDate + "','" + AddDate + "','" + title_name[0].split("/")[1] + "');");
                _mth.innerHTML = D_nowdateTitle + " [" + dayname[countdayname] + "]";
                _mtr.appendChild(_mth);

                //생성된 날짜를 배열에 저장
                weekdatename[b] = D_nowdate;
                b++;
            } //마지막날짜보다 크다면 여기를 호출
            else if (i > endMonthday) {
                //만약에 월의 날이 12월을 넘어간다면 1월부터과 년도 + 1
                if ((sz_Month + 2) > 12) {
                    var D_nowdate = datanameweek(sz_Year + 1, 1, nextmonthfirstday, "ADD");
                    var D_nowdateTitle = datanameweek(sz_Year + 1, 1, nextmonthfirstday, "NO");
                }
                    //그냥 마지막날보다 크다면 월 + 1 증가와 1일부터 시작 
                else {
                    var D_nowdate = datanameweek(sz_Year, sz_Month + 2, nextmonthfirstday, "ADD");
                    var D_nowdateTitle = datanameweek(sz_Year, sz_Month + 2, nextmonthfirstday, "NO");
                }

                var AddDate = datanameweek(sz_Year, sz_Month + 1, nextmonthfirstday, "YES");

                var AddDate = datanameweek(sz_Year, sz_Month + 1, i, "YES");
                _mth = document.createElement("TH");
                _mth.style.width = "14.2%";
                _mth.setAttribute("style", "vertical-align:middle");
                _mth.onmouseover = new Function("onmouse_over_Week(this);");
                _mth.onmouseout = new Function("onmouse_out_Week(this);");
                _mth.ondblclick = new Function("idCalendarViewer_OnDoubleClickAppointment2('','" + title_name[0].split("/")[0] + "','" + AddDate + "','" + AddDate + "','" + title_name[0].split("/")[1] + "');");
                _mth.innerHTML = D_nowdateTitle + " [" + dayname[countdayname] + "]";
                _mtr.appendChild(_mth);

                //생성된 날짜 배열 저장
                weekdatename[b] = D_nowdate;
                //1부터 시작된 값을 ++
                nextmonthfirstday++;
                //배열에 저장할때 쓸 변수 
                b++;
            }
            //요일을 출력할때쓸 변수
            countdayname++;
        }

        //배열에 저장된 값을 출력할때 쓸 변수
        b = 0;
        //_mtr.appendChild(_mth);
        _mtable.appendChild(_mtr);
        var totalreult;

        //하위 자원의 갯수만큼
        for (var k = 0; k < title_name.length; k++) {
            var _mtr2 = document.createElement("TR");
            _mtd = document.createElement("TD");
            _mtd.style.width = "200px";
            _mtd.setAttribute("style", "vertical-align:middle;cursor:pointer;");
            _mtd.setAttribute("class", "weektd_01");
            _mtd.setAttribute("DATA1", title_name[k].split("/")[0]);
            _mtd.setAttribute("DATA2", title_name[k].split("/")[1]);
            _mtd.align = "left";
            //_mtd.onselectstart = "return false";
            _mtd.onselectstart = function () { return false; };
            _mtd.setAttribute("ondblclick", "newSchedule_onclick(event)");
            //_mtd.ondblclick = new Function("newSchedule_onclick(event);");
            if(title_name[k].split("/")[2] == "1")
                _mtd.innerHTML = "<img src='/images/calendar/icon_resource_ok.png'  style='vertical-align:middle;'>" + title_name[k].split("/")[1];
            else
                _mtd.innerHTML = "<img src='/images/OrganTree_cross/ic-Item.gif'  style='vertical-align:middle;'>" + title_name[k].split("/")[1];
            _mtr2.appendChild(_mtd);

            for (var i = 1; i < 8; i++) {
                var y = i;
                if (i == 7) y = 0;

                var _mtd2 = document.createElement("TD");
                _mtd2.style.width = "14.2%";
                _mtd2.setAttribute("class", "weektd_02");
                _mtd2.verticalAlign = "top";
                _mtd2.setAttribute("id", "Week_" + title_name[k].split("/")[0] + "_" + y);
                _mtr2.appendChild(_mtd2);
                b++;
            }

            _mtable.appendChild(_mtr2);
            b = 0;

        }

        document.getElementById("tdCalViewCell").style.display = "none";
        document.getElementById("TD_CaseOfMonthView").style.display = "none";
        document.getElementById("weekviewer").style.display = "";
        if (p_Type == "MAIN") {
            document.getElementById("tdCalViewCell2").style.display = "none";
            document.getElementById("noapproval").style.display = "none";
            document.getElementById("approval").style.display = "none";
        }

        if (title_name.length == 0) {
            document.getElementById("tdDateCalendarViewer").innerHTML = "<div style='padding-top:20px;'>" + strLang265 + "<div>";
        }
        else {

            if (document.getElementById("tdDateCalendarViewer").childNodes.length > 0)
                document.getElementById("tdDateCalendarViewer").removeChild(document.getElementById("tdDateCalendarViewer").childNodes.item(0))

            document.getElementById("tdDateCalendarViewer").appendChild(_mtable);
        }

        for (var j = 0; j < xmldom.getElementsByTagName("appointment").length; j++) {

            var s_weekDateSet = dataSetChange(getNodeText(xmldom.getElementsByTagName("dtstart")[j]).split("T")[0]);
            var e_weekDateSet = dataSetChange(getNodeText(xmldom.getElementsByTagName("dtend")[j]).split("T")[0]);
            if (s_weekDateSet == e_weekDateSet) {
                var selObj = document.getElementById("Week_" + getNodeText(xmldom.getElementsByTagName("owner_id")[j]) + "_" + getNodeText(xmldom.getElementsByTagName("dsDaytype")[j]));

                var approveflag_name = "";
                if (getNodeText(xmldom.getElementsByTagName("approveFlag")[j]) == 1)
                    approveflag_name = "icon_02";
                else
                    approveflag_name = "icon_01";

                var Content_Sp_Start = getNodeText(xmldom.getElementsByTagName("dtstart")[j]).split("T")[1].split(":");
                var Content_Sp_End = getNodeText(xmldom.getElementsByTagName("dtend")[j]).split("T")[1].split(":");
                var alldayevent = getNodeText(xmldom.getElementsByTagName("alldayevent")[j]);

                var _table = document.createElement("TABLE");
                var _tr = document.createElement("TR");
                var _td = document.createElement("TD");
                var _span = document.createElement("SPAN");

                _table.setAttribute("style", "width:100%;text-align:left;table-layout:fixed;margin:0; white-space:nowrap; overflow:hidden;");

                _td.rowSpan = "2";
                var tdwidth = 3;
                if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1)
                    tdwidth = 18;
                _td.style.width = tdwidth + "px";
                _td.setAttribute("class", approveflag_name);
                _tr.appendChild(_td);

                _td = document.createElement("TD");
                _span.style.color = "#0090d0";

                if (alldayevent == "0")
                    _span.textContent = Content_Sp_Start[0] + ":" + Content_Sp_Start[1] + " ~ " + Content_Sp_End[0] + ":" + Content_Sp_End[1];
                else
                    _span.textContent = strLang126;

                _td.appendChild(_span);
                _tr.appendChild(_td);
                _table.appendChild(_tr);


                _tr = document.createElement("TR");
                _td = document.createElement("TD");
                _td.setAttribute("style", "padding-bottom:5px;padding-top:3px;margin:0; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; cursor:pointer;");
                _span = document.createElement("SPAN");
                _span.setAttribute("style", "white-space:nowrap;");
                //tooltip 추가
                _span.setAttribute("number", getNodeText(xmldom.getElementsByTagName("number")[j]));
                _span.setAttribute("pnumber", getNodeText(xmldom.getElementsByTagName("pnumber")[j]));
                _span.setAttribute("owner_id", getNodeText(xmldom.getElementsByTagName("owner_id")[j]));
                _span.setAttribute("writer_id", getNodeText(xmldom.getElementsByTagName("writer_id")[j]));
                _span.setAttribute("subject", getNodeText(xmldom.getElementsByTagName("subject")[j]));
                _span.setAttribute("instancetype", getNodeText(xmldom.getElementsByTagName("instancetype")[j]));
                _span.setAttribute("location", getNodeText(xmldom.getElementsByTagName("location")[j]));
                _span.setAttribute("dtstart", getNodeText(xmldom.getElementsByTagName("dtstart")[j]));
                _span.setAttribute("dtend", getNodeText(xmldom.getElementsByTagName("dtend")[j]));
                _span.setAttribute("dstartTime", getNodeText(xmldom.getElementsByTagName("dstartTime")[j]));
                _span.setAttribute("dendTime", getNodeText(xmldom.getElementsByTagName("dendTime")[j]));
                _span.setAttribute("dsDaytype", getNodeText(xmldom.getElementsByTagName("dsDaytype")[j]));
                _span.setAttribute("deDaytype", getNodeText(xmldom.getElementsByTagName("deDaytype")[j]));
                _span.setAttribute("alldayevent", getNodeText(xmldom.getElementsByTagName("alldayevent")[j]));
                _span.setAttribute("busystatus", getNodeText(xmldom.getElementsByTagName("busystatus")[j]));
                _span.setAttribute("groupflag", getNodeText(xmldom.getElementsByTagName("groupflag")[j]));
                _span.setAttribute("gubunFlag", getNodeText(xmldom.getElementsByTagName("gubunFlag")[j]));
                _span.setAttribute("importance", getNodeText(xmldom.getElementsByTagName("importance")[j]));
                _span.setAttribute("approveFlag", getNodeText(xmldom.getElementsByTagName("approveFlag")[j]));
                _span.setAttribute("owner_nm", getNodeText(xmldom.getElementsByTagName("owner_nm")[j]));
                _span.setAttribute("dept_name", getNodeText(xmldom.getElementsByTagName("dept_name")[j]));
                _span.setAttribute("writeDay", getNodeText(xmldom.getElementsByTagName("writeDay")[j]));

                //_span.addEventListener("mouseover", function (event) { onmouse_over(this, event) });
                _span.onmouseover = function (event) { onmouse_over(this, event); };
                _span.onmouseout = new Function("onmouse_out(this);");
                var pResourceName = "";
                if (CrossYN())
                    pResourceName = selObj.parentNode.childNodes[0].textContent.trim();
                else
                    pResourceName = selObj.parentNode.childNodes[0].innerText.trim();
                _span.onclick = new Function("idCalendarViewer_OnDoubleClickAppointment2('" + getNodeText(xmldom.getElementsByTagName("number")[j]) + "','" + getNodeText(xmldom.getElementsByTagName("owner_id")[j]) + "','" + getNodeText(xmldom.getElementsByTagName("dtstart")[j]).split("T")[0] + "','" + getNodeText(xmldom.getElementsByTagName("dtend")[j]).split("T")[0] + "','" + pResourceName + "','" + getNodeText(xmldom.getElementsByTagName("writer_id")[j]) + "');");
                _span.textContent = getNodeText(xmldom.getElementsByTagName("subject")[j]);
                _td.appendChild(_span);
                _tr.appendChild(_td);
                _table.appendChild(_tr);


                selObj.appendChild(_table);
            }
            else {
                if (weekdatename[0] <= s_weekDateSet && e_weekDateSet <= weekdatename[6]) {
                    var startCnt = getNodeText(xmldom.getElementsByTagName("dsDaytype")[j]);
                    var endCnt = getNodeText(xmldom.getElementsByTagName("deDaytype")[j]);
                    var endCnt2 = endCnt;
                    if (endCnt == 0) endCnt2 = 7;
                    for (var i = startCnt; i <= endCnt2; i++) {
                        if (endCnt == 0 && i == 7)
                            makeTable(xmldom, j, endCnt);
                        else
                            makeTable(xmldom, j, i);
                    }
                }
                else if (s_weekDateSet < weekdatename[0] && e_weekDateSet <= weekdatename[6]) {
                    var endCnt = getNodeText(xmldom.getElementsByTagName("deDaytype")[j]);
                    for (var i = endCnt; 0 < i; i--) {
                        makeTable(xmldom, j, i);
                    }
                }
                else if (weekdatename[0] <= s_weekDateSet && weekdatename[6] < e_weekDateSet) {
                    var startCnt = getNodeText(xmldom.getElementsByTagName("dsDaytype")[j]);
                    for (var i = startCnt; i < 8; i++) {
                        if (i == 7)
                            makeTable(xmldom, j, 0);
                        else
                            makeTable(xmldom, j, i);
                    }
                }
                else {
                    for (var i = 0; i < 7; i++) {
                        makeTable(xmldom, j, i);
                    }
                }
            }
        }
        Mod = "WEEK";
        resource_text = "";
    }
    
}
function makeTable(xmldom, pNum, dayType) {
    var selObj = document.getElementById("Week_" + getNodeText(xmldom.getElementsByTagName("owner_id")[pNum]) + "_" + dayType);

    var approveflag_name = "";
    if (getNodeText(xmldom.getElementsByTagName("approveFlag")[pNum]) == 1)
        approveflag_name = "icon_02";
    else
        approveflag_name = "icon_01";

    var Content_Sp_Start = getNodeText(xmldom.getElementsByTagName("dtstart")[pNum]).split("T")[1].split(":");
    var Content_Sp_End = getNodeText(xmldom.getElementsByTagName("dtend")[pNum]).split("T")[1].split(":");

    var _table = document.createElement("TABLE");
    var _tr = document.createElement("TR");
    var _td = document.createElement("TD");
    var _span = document.createElement("SPAN");

    _table.setAttribute("style", "width:100%;text-align:left;table-layout:fixed;margin:0; white-space:nowrap; overflow:hidden;");

    _td.rowSpan = "2";
    var tdwidth = 3;
    if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1)
        tdwidth = 18;
    _td.style.width = tdwidth + "px";
    _td.setAttribute("class", approveflag_name);
    _tr.appendChild(_td);

    _td = document.createElement("TD");
    _span.style.color = "#0090d0";
    _span.textContent = Content_Sp_Start[0] + ":" + Content_Sp_Start[1] + " ~ " + Content_Sp_End[0] + ":" + Content_Sp_End[1];
    _td.appendChild(_span);
    _tr.appendChild(_td);
    _table.appendChild(_tr);


    _tr = document.createElement("TR");
    _td = document.createElement("TD");
    _td.setAttribute("style", "padding-bottom:5px;padding-top:3px;margin:0; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; cursor:pointer;");
    _span = document.createElement("SPAN");
    _span.setAttribute("style", "white-space:nowrap;");
    //tooltip 추가
    _span.setAttribute("number", getNodeText(xmldom.getElementsByTagName("number")[pNum]));
    _span.setAttribute("pnumber", getNodeText(xmldom.getElementsByTagName("pnumber")[pNum]));
    _span.setAttribute("owner_id", getNodeText(xmldom.getElementsByTagName("owner_id")[pNum]));
    _span.setAttribute("writer_id", getNodeText(xmldom.getElementsByTagName("writer_id")[pNum]));
    _span.setAttribute("subject", getNodeText(xmldom.getElementsByTagName("subject")[pNum]));
    _span.setAttribute("instancetype", getNodeText(xmldom.getElementsByTagName("instancetype")[pNum]));
    _span.setAttribute("location", getNodeText(xmldom.getElementsByTagName("location")[pNum]));
    _span.setAttribute("dtstart", getNodeText(xmldom.getElementsByTagName("dtstart")[pNum]));
    _span.setAttribute("dtend", getNodeText(xmldom.getElementsByTagName("dtend")[pNum]));
    _span.setAttribute("dstartTime", getNodeText(xmldom.getElementsByTagName("dstartTime")[pNum]));
    _span.setAttribute("dendTime", getNodeText(xmldom.getElementsByTagName("dendTime")[pNum]));
    _span.setAttribute("dsDaytype", getNodeText(xmldom.getElementsByTagName("dsDaytype")[pNum]));
    _span.setAttribute("deDaytype", getNodeText(xmldom.getElementsByTagName("deDaytype")[pNum]));
    _span.setAttribute("alldayevent", getNodeText(xmldom.getElementsByTagName("alldayevent")[pNum]));
    _span.setAttribute("busystatus", getNodeText(xmldom.getElementsByTagName("busystatus")[pNum]));
    _span.setAttribute("groupflag", getNodeText(xmldom.getElementsByTagName("groupflag")[pNum]));
    _span.setAttribute("gubunFlag", getNodeText(xmldom.getElementsByTagName("gubunFlag")[pNum]));
    _span.setAttribute("importance", getNodeText(xmldom.getElementsByTagName("importance")[pNum]));
    _span.setAttribute("approveFlag", getNodeText(xmldom.getElementsByTagName("approveFlag")[pNum]));
    _span.setAttribute("owner_nm", getNodeText(xmldom.getElementsByTagName("owner_nm")[pNum]));
    _span.setAttribute("dept_name", getNodeText(xmldom.getElementsByTagName("dept_name")[pNum]));
    _span.setAttribute("writeDay", getNodeText(xmldom.getElementsByTagName("writeDay")[pNum]));

    _span.onmouseover = function (event) { onmouse_over(this, event); };
    _span.onmouseout = new Function("onmouse_out(this);");
    var pResourceName = "";
    if (CrossYN()) {
    	pResourceName = selObj.parentNode.childNodes[0].textContent.trim();
    } else {
    	pResourceName = selObj.parentNode.childNodes[0].innerText.trim();
    }
    _span.onclick = new Function("idCalendarViewer_OnDoubleClickAppointment2('" + getNodeText(xmldom.getElementsByTagName("number")[pNum]) + "','" + getNodeText(xmldom.getElementsByTagName("owner_id")[pNum]) + "','" + getNodeText(xmldom.getElementsByTagName("dtstart")[pNum]).split("T")[0] + "','" + getNodeText(xmldom.getElementsByTagName("dtend")[pNum]).split("T")[0] + "','" + pResourceName + "','" + getNodeText(xmldom.getElementsByTagName("writer_id")[pNum]) + "');");
    _span.textContent = getNodeText(xmldom.getElementsByTagName("subject")[pNum]);
    _td.appendChild(_span);
    _tr.appendChild(_td);
    _table.appendChild(_tr);


    selObj.appendChild(_table);
}
function newSchedule_onclick(e) {
    var srcEl;

    if (CrossYN()) {
        srcEl = e.currentTarget;
    } else {
        srcEl = window.event.srcElement;
    }
    var selsd = "", seled = "";

    if (srcEl.getAttribute("dispDate") == null) {
        if (srcEl.getAttribute("dispTime") != null) {

            selsd = srcEl.getAttribute("dispTime");
            seled = selsd.replace(":00:", ":30:");
        }
    } else {
        selsd = srcEl.getAttribute("dispDate");
        seled = srcEl.getAttribute("dispDate");
    }
    
    if (CrossYN() || pNoneActiveX == "YES") {
        var feature = GetOpenPosition(820, 700);
        window.open("/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=" + selsd + "&seled=" + seled + "&dayView=&ownerID=" + srcEl.getAttribute("DATA1") + "&brdName=" + encodeURIComponent(srcEl.getAttribute("DATA2")), "", "width=820, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
    } else {
        if (pUse_Editor == "" || pUse_Editor == "CK") {
            var feature = GetOpenPosition(770, 700);
            window.open("/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=" + selsd + "&seled=" + seled + "&dayView=&ownerID=" + srcEl.getAttribute("DATA1") + "&brdName=" + encodeURIComponent(srcEl.getAttribute("DATA2")), "", "width=770, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
        } else {
            var feature = GetOpenPosition(770, 700);
            window.open("/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=" + selsd + "&seled=" + seled + "&dayView=&ownerID=" + srcEl.getAttribute("DATA1") + "&brdName=" + encodeURIComponent(srcEl.getAttribute("DATA2")), "", "width=770, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
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
function dataSetChange(strdate) {
    var date = strdate.replace(/-/gi, "");
    return date;
}

function DateTrueFalse(s_Date, e_Date, fs_Date, fe_Date, writeDate, pdateType) {
    if (pdateType == "WEEK") {
        if ((s_Date <= fs_Date && fs_Date <= e_Date) || (s_Date <= fe_Date && fe_Date <= fe_Date)) {
            if (writeDate == fs_Date || writeDate == fe_Date || fs_Date <= writeDate && writeDate <= fe_Date) {
            	return true;
            } else {
            	return false;
            }
        } else if ((fs_Date < s_Date && s_Date < fe_Date) || (fs_Date < e_Date && fe_Date < fe_Date)) {
            if (writeDate == fs_Date || writeDate == fe_Date || fs_Date <= writeDate && writeDate <= fe_Date) {
            	return true;
            } else {
            	return false;
            }
        } else {
        	return false;
        }
    } else if (pdateType == "TODAY") {
        if (fs_Date <= writeDate && writeDate <= fe_Date && fs_Date != fe_Date) {
        	return true;
        } else if(writeDate == fs_Date || writeDate == fe_Date) {
        	return true;
        } else {
        	return false;
        }
    }
}

function DataSetRemove(fs_Date, fe_Date) {

    if (fs_Date == fe_Date) {
    	return true;
    } else {
    	return false;
    }
}

function tableListControl_today() {
    if (c_xmlhttp.readyState == 4 && c_xmlhttp.status == 200) {

        //c_xmlhttp.onreadystatechange = onAbort;

        var xmldom = createXmlDom();

        var XMLstring = c_xmlhttp.responseText;
        xmldom = loadXMLString(XMLstring);

        var TodayDatename = datanameweek(sz_Year, sz_Month + 1, sz_Date, "YES");
        document.getElementById("divViewHeader").textContent = datanameweek(sz_Year, sz_Month + 1, sz_Date, "HEARDER");
        var _Table = document.createElement("TABLE");
        _Table.setAttribute("class", "table_layout");
        var _Tr = document.createElement("TR");
        var _Th = document.createElement("TH");
        _Th.style.width = "250px";
        _Th.textContent = strLang266;
        _Th.style.verticalAlign = "middle";
        _Tr.appendChild(_Th);
        for (var i = 0; i < 24; i++) {
            var headerday = "";
            if (i < 10)
                headerday = "0" + i;
            else
                headerday = i;

            _Th = document.createElement("TH");
            _Th.colSpan = "2";
            _Th.style.textAlign = "center";
            _Th.style.verticalAlign = "middle";
            _Th.style.width = "4%";
            _Th.innerHTML = headerday;
            _Tr.appendChild(_Th);
        }
        _Table.appendChild(_Tr);

        for (var k = 0; k < title_name.length; k++) {
            var _Tr2 = document.createElement("TR");
            var _TD = document.createElement("TD");
            _TD.style.width = "250px";
            _TD.style.cursor = "pointer";
            _TD.setAttribute("class", "todaytd_01");
            _TD.setAttribute("DATA1", title_name[k].split("/")[0]);
            _TD.setAttribute("DATA2", title_name[k].split("/")[1]);
            _TD.setAttribute("ondblclick", "newSchedule_onclick(event)");
            //_TD.ondblclick = new Function("newSchedule_onclick(event);");
            _TD.align = "left";
            _TD.onselectstart = function () { return false; };
            _TD.innerHTML = "<img src='/images/OrganTree_cross/ic-Item.gif'  style='vertical-align:middle;'>" + title_name[k].split("/")[1];
            _TD.style.verticalAlign = "middle";
            _Tr2.appendChild(_TD);
            for (j = 0 ; j < 48; j++) {
                _TD = document.createElement("TD");
                _TD.align = "center";
                _TD.style.width = "2%";
                _TD.setAttribute("class", "todaytd_02");
                _TD.setAttribute("id", "Day_" + title_name[k].split("/")[0] + "_" + (j + 1));
                _Tr2.appendChild(_TD);
            }
            _Table.appendChild(_Tr2);
        }

        if (title_name.length == 0) {
            document.getElementById("tdDateCalendarViewer").innerHTML = "<div style='padding-top:20px;'>" + strLang265 + "<div>";
        }
        else {

            if (document.getElementById("tdDateCalendarViewer").childNodes.length > 0)
                document.getElementById("tdDateCalendarViewer").removeChild(document.getElementById("tdDateCalendarViewer").childNodes.item(0))

            document.getElementById("tdDateCalendarViewer").appendChild(_Table);
        }

        document.getElementById("tdDateCalendarViewer").appendChild(_Table);

        for (var j = 0; j < xmldom.getElementsByTagName("appointment").length; j++) {
            if (getNodeText(xmldom.getElementsByTagName("approveFlag")[j]) == "1") {
                var pObjectId = "Day_" + getNodeText(xmldom.getElementsByTagName("owner_id")[j]);
                var pObjectSP = (parseInt(getNodeText(xmldom.getElementsByTagName("dstartTime")[j])) / 30) + 1;
                var pObjectEP = (parseInt(getNodeText(xmldom.getElementsByTagName("dendTime")[j])) / 30);

                var pObjectSPDay = getNodeText(xmldom.getElementsByTagName("dtstart")[j]).split("T")[0];
                var pObjectEPDay = getNodeText(xmldom.getElementsByTagName("dtend")[j]).split("T")[0];
                              

                if ((pObjectSPDay == pObjectEPDay && pObjectSP == pObjectEP) && getNodeText(xmldom.getElementsByTagName("alldayevent")[j]) != "1") {
                    //tooltip 추가
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("number", getNodeText(xmldom.getElementsByTagName("number")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("pnumber", getNodeText(xmldom.getElementsByTagName("pnumber")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("owner_id", getNodeText(xmldom.getElementsByTagName("owner_id")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("writer_id", getNodeText(xmldom.getElementsByTagName("writer_id")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("subject", getNodeText(xmldom.getElementsByTagName("subject")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("instancetype", getNodeText(xmldom.getElementsByTagName("instancetype")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("location", getNodeText(xmldom.getElementsByTagName("location")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("dtstart", getNodeText(xmldom.getElementsByTagName("dtstart")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("dtend", getNodeText(xmldom.getElementsByTagName("dtend")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("dstartTime", getNodeText(xmldom.getElementsByTagName("dstartTime")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("dendTime", getNodeText(xmldom.getElementsByTagName("dendTime")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("dsDaytype", getNodeText(xmldom.getElementsByTagName("dsDaytype")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("deDaytype", getNodeText(xmldom.getElementsByTagName("deDaytype")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("alldayevent", getNodeText(xmldom.getElementsByTagName("alldayevent")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("busystatus", getNodeText(xmldom.getElementsByTagName("busystatus")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("groupflag", getNodeText(xmldom.getElementsByTagName("groupflag")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("gubunFlag", getNodeText(xmldom.getElementsByTagName("gubunFlag")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("importance", getNodeText(xmldom.getElementsByTagName("importance")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("approveFlag", getNodeText(xmldom.getElementsByTagName("approveFlag")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("owner_nm", getNodeText(xmldom.getElementsByTagName("owner_nm")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("dept_name", getNodeText(xmldom.getElementsByTagName("dept_name")[j]));
                    document.getElementById(pObjectId + "_" + pObjectSP).setAttribute("writeDay", getNodeText(xmldom.getElementsByTagName("writeDay")[j]));

                    document.getElementById(pObjectId + "_" + pObjectSP).style.backgroundColor = "#0090d0";
                    document.getElementById(pObjectId + "_" + pObjectSP).style.border = "1px solid #0090d0";
                    document.getElementById(pObjectId + "_" + pObjectSP).style.cursor = "pointer";
                    document.getElementById(pObjectId + "_" + pObjectSP).onmouseover = function (event) { onmouse_over_today(this, event); };// new Function("onmouse_over_today(this);");
                    document.getElementById(pObjectId + "_" + pObjectSP).onmouseout = new Function("onmouse_out_today(this);");
                    document.getElementById(pObjectId + "_" + pObjectSP).onclick = new Function("idCalendarViewer_OnDoubleClickAppointment2('" + getNodeText(xmldom.getElementsByTagName("number")[j]) + "', '" + getNodeText(xmldom.getElementsByTagName("owner_id")[j]) + "', '" + getNodeText(xmldom.getElementsByTagName("dtstart")[j]).split("T")[0] + "', '" + getNodeText(xmldom.getElementsByTagName("dtend")[j]).split("T")[0] + "', '" + getNodeText(document.getElementById(pObjectId + "_" + pObjectSP).parentNode.firstChild).trim() + "', '" + getNodeText(xmldom.getElementsByTagName("writer_id")[j]) + "');");
                } else {
                    var alldayevent = getNodeText(xmldom.getElementsByTagName("alldayevent")[j]);
                    if (alldayevent != "1") {

                        if (TodayDatename == pObjectSPDay) {
                            pObjectEP = 48;
                        } else if (TodayDatename == pObjectEPDay) {
                            pObjectSP = 1;
                        } else if (TodayDatename != pObjectSPDay && TodayDatename != pObjectEPDay) {
                            pObjectSP = 1;
                            pObjectEP = 48;
                        }

                        for (var TCnt = pObjectSP; TCnt <= pObjectEP ; TCnt++) {
                            if (TCnt != pObjectSP) {
                                document.getElementById(pObjectId + "_" + TCnt).remove();
                            } else {
                                //tooltip 추가
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("number", getNodeText(xmldom.getElementsByTagName("number")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("pnumber", getNodeText(xmldom.getElementsByTagName("pnumber")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("owner_id", getNodeText(xmldom.getElementsByTagName("owner_id")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("writer_id", getNodeText(xmldom.getElementsByTagName("writer_id")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("subject", getNodeText(xmldom.getElementsByTagName("subject")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("instancetype", getNodeText(xmldom.getElementsByTagName("instancetype")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("location", getNodeText(xmldom.getElementsByTagName("location")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("dtstart", getNodeText(xmldom.getElementsByTagName("dtstart")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("dtend", getNodeText(xmldom.getElementsByTagName("dtend")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("dstartTime", getNodeText(xmldom.getElementsByTagName("dstartTime")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("dendTime", getNodeText(xmldom.getElementsByTagName("dendTime")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("dsDaytype", getNodeText(xmldom.getElementsByTagName("dsDaytype")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("deDaytype", getNodeText(xmldom.getElementsByTagName("deDaytype")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("alldayevent", getNodeText(xmldom.getElementsByTagName("alldayevent")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("busystatus", getNodeText(xmldom.getElementsByTagName("busystatus")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("groupflag", getNodeText(xmldom.getElementsByTagName("groupflag")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("gubunFlag", getNodeText(xmldom.getElementsByTagName("gubunFlag")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("importance", getNodeText(xmldom.getElementsByTagName("importance")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("approveFlag", getNodeText(xmldom.getElementsByTagName("approveFlag")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("owner_nm", getNodeText(xmldom.getElementsByTagName("owner_nm")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("dept_name", getNodeText(xmldom.getElementsByTagName("dept_name")[j]));
                                document.getElementById(pObjectId + "_" + TCnt).setAttribute("writeDay", getNodeText(xmldom.getElementsByTagName("writeDay")[j]));

                                document.getElementById(pObjectId + "_" + TCnt).style.backgroundColor = "#0090d0";
                                document.getElementById(pObjectId + "_" + TCnt).style.border = "1px solid #0090d0";
                                document.getElementById(pObjectId + "_" + TCnt).style.cursor = "pointer";
                                document.getElementById(pObjectId + "_" + TCnt).onmouseover = function (event) { onmouse_over_today(this, event); };
                                document.getElementById(pObjectId + "_" + TCnt).onmouseout = new Function("onmouse_out_today(this);");
                                document.getElementById(pObjectId + "_" + pObjectSP).onclick = new Function("idCalendarViewer_OnDoubleClickAppointment2('" + getNodeText(xmldom.getElementsByTagName("number")[j]) + "', '" + getNodeText(xmldom.getElementsByTagName("owner_id")[j]) + "', '" + getNodeText(xmldom.getElementsByTagName("dtstart")[j]).split("T")[0] + "', '" + getNodeText(xmldom.getElementsByTagName("dtend")[j]).split("T")[0] + "', '" + getNodeText(document.getElementById(pObjectId + "_" + pObjectSP).parentNode.firstChild).trim() + "', '" + getNodeText(xmldom.getElementsByTagName("writer_id")[j]) + "');");
                                document.getElementById(pObjectId + "_" + TCnt).colSpan = (pObjectEP - pObjectSP) + 1;
                            }
                        }
                    } else {
                        //tooltip 추가
                        document.getElementById(pObjectId + "_1").setAttribute("number", getNodeText(xmldom.getElementsByTagName("number")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("pnumber", getNodeText(xmldom.getElementsByTagName("pnumber")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("owner_id", getNodeText(xmldom.getElementsByTagName("owner_id")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("writer_id", getNodeText(xmldom.getElementsByTagName("writer_id")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("subject", getNodeText(xmldom.getElementsByTagName("subject")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("instancetype", getNodeText(xmldom.getElementsByTagName("instancetype")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("location", getNodeText(xmldom.getElementsByTagName("location")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("dtstart", getNodeText(xmldom.getElementsByTagName("dtstart")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("dtend", getNodeText(xmldom.getElementsByTagName("dtend")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("dstartTime", getNodeText(xmldom.getElementsByTagName("dstartTime")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("dendTime", getNodeText(xmldom.getElementsByTagName("dendTime")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("dsDaytype", getNodeText(xmldom.getElementsByTagName("dsDaytype")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("deDaytype", getNodeText(xmldom.getElementsByTagName("deDaytype")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("alldayevent", getNodeText(xmldom.getElementsByTagName("alldayevent")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("busystatus", getNodeText(xmldom.getElementsByTagName("busystatus")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("groupflag", getNodeText(xmldom.getElementsByTagName("groupflag")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("gubunFlag", getNodeText(xmldom.getElementsByTagName("gubunFlag")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("importance", getNodeText(xmldom.getElementsByTagName("importance")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("approveFlag", getNodeText(xmldom.getElementsByTagName("approveFlag")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("owner_nm", getNodeText(xmldom.getElementsByTagName("owner_nm")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("dept_name", getNodeText(xmldom.getElementsByTagName("dept_name")[j]));
                        document.getElementById(pObjectId + "_1").setAttribute("writeDay", getNodeText(xmldom.getElementsByTagName("writeDay")[j]));

                            document.getElementById(pObjectId + "_1").style.backgroundColor = "#0090d0";
                            document.getElementById(pObjectId + "_1").style.border = "1px solid #0090d0";
                            document.getElementById(pObjectId + "_1").style.cursor = "pointer";
                            document.getElementById(pObjectId + "_1").onmouseover = function (event) { onmouse_over_today(this, event); };
                            document.getElementById(pObjectId + "_1").onmouseout = new Function("onmouse_out_today(this);");
                            document.getElementById(pObjectId + "_1").onclick = new Function("idCalendarViewer_OnDoubleClickAppointment2('" + getNodeText(xmldom.getElementsByTagName("number")[j]) + "', '" + getNodeText(xmldom.getElementsByTagName("owner_id")[j]) + "', '" + getNodeText(xmldom.getElementsByTagName("dtstart")[j]).split("T")[0] + "', '" + getNodeText(xmldom.getElementsByTagName("dtend")[j]).split("T")[0] + "', '" + getNodeText(document.getElementById(pObjectId + "_1").parentNode.firstChild).trim() + "', '" + getNodeText(xmldom.getElementsByTagName("writer_id")[j]) + "');");
                            document.getElementById(pObjectId + "_1").colSpan = 48;
                    }
                }
            }
        }
        var dateresult = "";
        TodayDatename = datanameweek(sz_Year, sz_Month + 1, sz_Date, "ADD");

        // 비승인 처리
        headerweek = "";
        var _table = document.createElement("TABLE");
        _table.setAttribute("class", "table_layout");
        var _tr = document.createElement("TR");
        var _th = document.createElement("TH");
        _th.style.textAlign = "center";
        _th.style.verticalAlign = "middle";
        _th.style.width = "250px";
        _th.textContent = strLang266;
        _tr.appendChild(_th);
        for (var i = 0; i < 24; i++) {

            var headerday = "";

            if (i < 10)
                headerday = "0" + i;
            else
                headerday = i;
            _th = document.createElement("TH");
            _th.colSpan = "2";
            _th.style.textAlign = "center";
            _th.style.verticalAlign = "middle";
            _th.style.width = "4%";
            _th.innerHTML = headerday;
            _tr.appendChild(_th);
        }
        _table.appendChild(_tr);


        for (var k = 0; k < title_name.length; k++) {
            for (var j = 0; j < xmldom.getElementsByTagName("appointment").length; j++) {
                var s_weekDateSet = dataSetChange(getNodeText(xmldom.getElementsByTagName("dtstart")[j]).split("T")[0]);
                var e_weekDateSet = dataSetChange(getNodeText(xmldom.getElementsByTagName("dtend")[j]).split("T")[0]);

                if (title_name[k].split("/")[0] == getNodeText(xmldom.getElementsByTagName("owner_id")[j]) && getNodeText(xmldom.getElementsByTagName("approveFlag")[j]) == 0) {
                    if (DateTrueFalse(TodayDatename, TodayDatename, s_weekDateSet, e_weekDateSet, TodayDatename, "TODAY")) {
                        var _Tr2 = document.createElement("TR");
                        var _TD = document.createElement("TD");
                        _TD.style.width = "250px";
                        _TD.style.cursor = "pointer";
                        _TD.setAttribute("class", "todaytd_01");
                        _TD.align = "left";
                        _TD.onselectstart = function () { return false; };
                        _TD.innerHTML = "<img src='/images/OrganTree_cross/ic-Item.gif' style='vertical-align:middle;'>" + title_name[k].split("/")[1] + " [ " + strLang267 + " : " + getNodeText(xmldom.getElementsByTagName("owner_nm")[j]) + "]";
                        _TD.style.verticalAlign = "middle";
                        _Tr2.appendChild(_TD);
                        var alldayevent = getNodeText(xmldom.getElementsByTagName("alldayevent")[j]);
                        if (alldayevent != "1") {
                            for (var i = 0; i < 48; i++) {

                                var t_Startdt = getNodeText(xmldom.getElementsByTagName("dtstart")[j]).split("T")[1];
                                var t_Enddt = getNodeText(xmldom.getElementsByTagName("dtend")[j]).split("T")[1];

                                var s_Startdt = t_Startdt.split(":");
                                var s_Enddt = t_Enddt.split(":");

                                if (s_Startdt[1] == "30")
                                    s_Startdt[0] = Number(s_Startdt[0]) + 0.5;
                                else if (s_Enddt[1] == "30")
                                    s_Enddt[0] = Number(s_Enddt[0]) + 0.5;
                                else if (s_Enddt[1] == "59")
                                    s_Enddt[0] = Number(s_Enddt[0]) + 1;

                                var d1 = new Date(sz_Year, sz_Month, sz_Date, s_Startdt[0], s_Startdt[1]);
                                var d2 = new Date(sz_Year, sz_Month, sz_Date, s_Enddt[0], s_Enddt[1]);
                                //출력할 값
                                var d3 = (d2 - d1) / 1800000;

                                var pObjectSPDay = getNodeText(xmldom.getElementsByTagName("dtstart")[j]).split("T")[0];
                                var pObjectEPDay = getNodeText(xmldom.getElementsByTagName("dtend")[j]).split("T")[0];

                                var width_td = d3 * 2;
                                TodayDatename = datanameweek(sz_Year, sz_Month + 1, sz_Date, "YES");
                                if (TodayDatename == pObjectSPDay) {
                                    s_Enddt[0] = 24;
                                    d2 = new Date(sz_Year, sz_Month, sz_Date, s_Enddt[0], 00);
                                    width_td = ((d2 - d1) / 1800000);
                                } else if (TodayDatename == pObjectEPDay) {
                                    s_Startdt[0] = 0;
                                    d1 = new Date(sz_Year, sz_Month, sz_Date, s_Startdt[0], 00);
                                    width_td = ((d2 - d1) / 1800000);
                                } else if (TodayDatename != pObjectSPDay && TodayDatename != pObjectEPDay) {
                                    s_Startdt[0] = 0;
                                    s_Enddt[0] = 24;
                                    width_td = 48;
                                }
                                TodayDatename = datanameweek(sz_Year, sz_Month + 1, sz_Date, "ADD");
                                
                                if (s_Startdt[0] <= (i / 2) && s_Enddt[0] > (i / 2)) {
                                    
                                    var _TD = document.createElement("TD");
                                    _TD.title_name = strLang267 + " : " + getNodeText(xmldom.getElementsByTagName("owner_nm")[j]) + "&#13;" + strLang268 + " : " + getNodeText(xmldom.getElementsByTagName("dept_name")[j]);
                                    _TD.align = "center";
                                    _TD.style.backgroundColor = "#0090d0";
                                    _TD.style.border = "1px solid #0090d0";
                                    _TD.style.width = width_td + "%";
                                    _TD.setAttribute("class", "todaytd_02");
                                    _TD.setAttribute("id", "nDay_" + title_name[k].split("/")[0] + "_" + (j + 1));
                                    _TD.style.cursor = "pointer";
                                    //tooltip 추가
                                    _TD.setAttribute("number", getNodeText(xmldom.getElementsByTagName("number")[j]));
                                    _TD.setAttribute("pnumber", getNodeText(xmldom.getElementsByTagName("pnumber")[j]));
                                    _TD.setAttribute("owner_id", getNodeText(xmldom.getElementsByTagName("owner_id")[j]));
                                    _TD.setAttribute("writer_id", getNodeText(xmldom.getElementsByTagName("writer_id")[j]));
                                    _TD.setAttribute("subject", getNodeText(xmldom.getElementsByTagName("subject")[j]));
                                    _TD.setAttribute("instancetype", getNodeText(xmldom.getElementsByTagName("instancetype")[j]));
                                    _TD.setAttribute("location", getNodeText(xmldom.getElementsByTagName("location")[j]));
                                    _TD.setAttribute("dtstart", getNodeText(xmldom.getElementsByTagName("dtstart")[j]));
                                    _TD.setAttribute("dtend", getNodeText(xmldom.getElementsByTagName("dtend")[j]));
                                    _TD.setAttribute("dstartTime", getNodeText(xmldom.getElementsByTagName("dstartTime")[j]));
                                    _TD.setAttribute("dendTime", getNodeText(xmldom.getElementsByTagName("dendTime")[j]));
                                    _TD.setAttribute("dsDaytype", getNodeText(xmldom.getElementsByTagName("dsDaytype")[j]));
                                    _TD.setAttribute("deDaytype", getNodeText(xmldom.getElementsByTagName("deDaytype")[j]));
                                    _TD.setAttribute("alldayevent", getNodeText(xmldom.getElementsByTagName("alldayevent")[j]));
                                    _TD.setAttribute("busystatus", getNodeText(xmldom.getElementsByTagName("busystatus")[j]));
                                    _TD.setAttribute("groupflag", getNodeText(xmldom.getElementsByTagName("groupflag")[j]));
                                    _TD.setAttribute("gubunFlag", getNodeText(xmldom.getElementsByTagName("gubunFlag")[j]));
                                    _TD.setAttribute("importance", getNodeText(xmldom.getElementsByTagName("importance")[j]));
                                    _TD.setAttribute("approveFlag", getNodeText(xmldom.getElementsByTagName("approveFlag")[j]));
                                    _TD.setAttribute("owner_nm", getNodeText(xmldom.getElementsByTagName("owner_nm")[j]));
                                    _TD.setAttribute("dept_name", getNodeText(xmldom.getElementsByTagName("dept_name")[j]));
                                    _TD.setAttribute("writeDay", getNodeText(xmldom.getElementsByTagName("writeDay")[j]));

                                    _TD.onmouseover = function (event) { onmouse_over_today(this, event); };
                                    _TD.onmouseout = new Function("onmouse_out_today(this);");
                                    _TD.onclick = new Function("idCalendarViewer_OnDoubleClickAppointment2('" + getNodeText(xmldom.getElementsByTagName("number")[j]) + "', '" + getNodeText(xmldom.getElementsByTagName("owner_id")[j]) + "', '" + getNodeText(xmldom.getElementsByTagName("dtstart")[j]).split("T")[0] + "', '" + getNodeText(xmldom.getElementsByTagName("dtend")[j]).split("T")[0] + "', '" + title_name[k].split("/")[1] + "', '" + getNodeText(xmldom.getElementsByTagName("writer_id")[j]) + "');");
                                    _TD.colSpan = d3;
                                    _Tr2.appendChild(_TD);
                                    //i = i + (d3 - 1);
                                } else {
                                    var _TD = document.createElement("TD");
                                    _TD.align = "center";
                                    _TD.setAttribute("class", "todaytd_02");
                                    _TD.style.width = "2%";
                                    _Tr2.appendChild(_TD);
                                    
                                }
                            }
                        } else {
                            var _TD = document.createElement("TD");
                            _TD.title_name = strLang267 + " : " + getNodeText(xmldom.getElementsByTagName("owner_nm")[j]) + "&#13;" + strLang268 + " : " + getNodeText(xmldom.getElementsByTagName("dept_name")[j]);
                            _TD.align = "center";
                            _TD.style.backgroundColor = "#0090d0";
                            _TD.style.border = "1px solid #0090d0";
                            _TD.style.width = 100 + "%";
                            _TD.setAttribute("class", "todaytd_02");
                            _TD.setAttribute("id", "nDay_" + title_name[k].split("/")[0] + "_" + (j + 1));
                            _TD.style.cursor = "pointer";
                            //tooltip 추가
                            _TD.setAttribute("number", getNodeText(xmldom.getElementsByTagName("number")[j]));
                            _TD.setAttribute("pnumber", getNodeText(xmldom.getElementsByTagName("pnumber")[j]));
                            _TD.setAttribute("owner_id", getNodeText(xmldom.getElementsByTagName("owner_id")[j]));
                            _TD.setAttribute("writer_id", getNodeText(xmldom.getElementsByTagName("writer_id")[j]));
                            _TD.setAttribute("subject", getNodeText(xmldom.getElementsByTagName("subject")[j]));
                            _TD.setAttribute("instancetype", getNodeText(xmldom.getElementsByTagName("instancetype")[j]));
                            _TD.setAttribute("location", getNodeText(xmldom.getElementsByTagName("location")[j]));
                            _TD.setAttribute("dtstart", getNodeText(xmldom.getElementsByTagName("dtstart")[j]));
                            _TD.setAttribute("dtend", getNodeText(xmldom.getElementsByTagName("dtend")[j]));
                            _TD.setAttribute("dstartTime", getNodeText(xmldom.getElementsByTagName("dstartTime")[j]));
                            _TD.setAttribute("dendTime", getNodeText(xmldom.getElementsByTagName("dendTime")[j]));
                            _TD.setAttribute("dsDaytype", getNodeText(xmldom.getElementsByTagName("dsDaytype")[j]));
                            _TD.setAttribute("deDaytype", getNodeText(xmldom.getElementsByTagName("deDaytype")[j]));
                            _TD.setAttribute("alldayevent", getNodeText(xmldom.getElementsByTagName("alldayevent")[j]));
                            _TD.setAttribute("busystatus", getNodeText(xmldom.getElementsByTagName("busystatus")[j]));
                            _TD.setAttribute("groupflag", getNodeText(xmldom.getElementsByTagName("groupflag")[j]));
                            _TD.setAttribute("gubunFlag", getNodeText(xmldom.getElementsByTagName("gubunFlag")[j]));
                            _TD.setAttribute("importance", getNodeText(xmldom.getElementsByTagName("importance")[j]));
                            _TD.setAttribute("approveFlag", getNodeText(xmldom.getElementsByTagName("approveFlag")[j]));
                            _TD.setAttribute("owner_nm", getNodeText(xmldom.getElementsByTagName("owner_nm")[j]));
                            _TD.setAttribute("dept_name", getNodeText(xmldom.getElementsByTagName("dept_name")[j]));
                            _TD.setAttribute("writeDay", getNodeText(xmldom.getElementsByTagName("writeDay")[j]));

                            _TD.onmouseover = function (event) { onmouse_over_today(this, event); };
                            _TD.onmouseout = new Function("onmouse_out_today(this);");
                            _TD.onclick = new Function("idCalendarViewer_OnDoubleClickAppointment2('" + getNodeText(xmldom.getElementsByTagName("number")[j]) + "', '" + getNodeText(xmldom.getElementsByTagName("owner_id")[j]) + "', '" + getNodeText(xmldom.getElementsByTagName("dtstart")[j]).split("T")[0] + "', '" + getNodeText(xmldom.getElementsByTagName("dtend")[j]).split("T")[0] + "', '" + title_name[k].split("/")[1] + "', '" + getNodeText(xmldom.getElementsByTagName("writer_id")[j]) + "');");
                            _TD.colSpan = 48;
                            _Tr2.appendChild(_TD);
                        }
                        _table.appendChild(_Tr2);
                        tdcount = 1;
                    }
                }
            }
        }

        document.getElementById("approval").style.display = "";
        document.getElementById("noapproval").style.display = "";

        if (p_Type == "MAIN") {
            document.getElementById("tdCalViewCell2").style.display = "";
            document.getElementById("noapproval").style.display = "";
        }

        if (tdcount != 0) {
            if (document.getElementById("idCalendarViewer2").childNodes.length > 0)
                document.getElementById("idCalendarViewer2").removeChild(document.getElementById("idCalendarViewer2").childNodes.item(0))
            document.getElementById("idCalendarViewer2").appendChild(_table);

        } else {
            document.getElementById("noapproval").style.display = "none";
            document.getElementById("idCalendarViewer2").innerHTML = "";
        }

        Mod = "TODAY";
        resource_text = "";
    }
}

//화면에서 더블클릭했을때 창뛰우기 : 메인에서 넘겨준부분
function idCalendarViewer_OnDoubleClickAppointment2(sz_Num, sz_OwnerID, sz_Start, sz_End, sz_BrdName, sz_WriterID) {
    var p_url = "";
    var c_Width = "";

    if (CrossYN()) {
    	c_Width = 820;
    } else {
    	c_Width = 770;
    }

    var c_Height = 700;

    //스크린의 크기
    var s_Width = screen.availWidth;
    var s_Height = screen.availHeight;

    //열 창의 포지션
    var px = (s_Width - c_Width) / 2;
    var py = (s_Height - c_Height) / 2;

    if (sz_Num != "" && sz_Num != null) {
        ////읽기창////
        //if (pUse_Editor == "TAGFREE")
        //    window.open("/myoffice/ezResource/ResSch/Schedule_add_TFX.aspx?cmd=mod&from=schedule&" + "num=" + sz_Num + "&ownerID=" + sz_OwnerID + "&type=Master&startDate=" + sz_Start + "&endDate=" + sz_End + "&brdName=" + escape(sz_BrdName), "", "left=" + px + ",top=" + py + ",width=" + c_Width + ", height=" + c_Height + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
        //else
        //    window.open("/myoffice/ezResource/ResSch/Schedule_add_ck.aspx?cmd=mod&from=schedule&" + "num=" + sz_Num + "&ownerID=" + sz_OwnerID + "&type=Master&startDate=" + sz_Start + "&endDate=" + sz_End + "&brdName=" + escape(sz_BrdName), "", "left=" + px + ",top=" + py + ",width=" + c_Width + ", height=" + c_Height + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");

        window.open("/ezResource/scheduleRead.do?cmd=mod&from=schedule&" + "num=" + sz_Num + "&ownerID=" + sz_OwnerID + "&type=Master&startDate=" + sz_Start + "&endDate=" + sz_End + "&brdName=" + sz_BrdName, "", "left=" + px + ",top=" + py + ",width=" + c_Width + ", height=" + c_Height + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
    } else if (p_Type != "MAIN") {

        if (CrossYN() || pNoneActiveX == "YES") {
            window.open("/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=" + sz_Start + "&seled=" + sz_End + "&dayView=&ownerID=" + sz_OwnerID + "&brdName=" + encodeURIComponent(sz_BrdName), "", "left=" + px + ",top=" + py + ",width=" + c_Width + ", height=" + c_Height + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
        } else {
            if (pUse_Editor == "" || pUse_Editor == "CK") {
                window.open("/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=" + sz_Start + "&seled=" + sz_End + "&dayView=&ownerID=" + sz_OwnerID + "&brdName=" + encodeURIComponent(sz_BrdName), "", "left=" + px + ",top=" + py + ",width=" + c_Width + ", height=" + c_Height + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
            } else {
                window.open("/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=" + sz_Start + "&seled=" + sz_End + "&dayView=&ownerID=" + sz_OwnerID + "&brdName=" + encodeURIComponent(sz_BrdName), "", "left=" + px + ",top=" + py + ",width=" + c_Width + ", height=" + c_Height + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
            }
        }
    }
}

function onmouse_over_resource(td) {
    td.style.backgroundColor = "#e8f7fe";
    td.style.cursor = "pointer";
}

function onmouse_out_resource(td) {
    td.style.backgroundColor = "white";
}
//일보기 마우스임팩트
function onmouse_over_today(td, event) {
    td.style.cursor = "pointer";
    td.style.backgroundColor = "#2876b6";

    showTooltip_MouseOver(td, event);
}
//일보기 마우스임팩트
function onmouse_out_today(td) {
    td.style.backgroundColor = "#0090d0";

    hideTooltip();
}
//일보기 마우스임팩트
function onmouse_over(td, event) {
    td.style.cursor = "pointer";
    td.style.textDecoration = "underline";
    td.style.color = "#0090d0";

    showTooltip_MouseOver(td, event);
}
//일보기 마우스임팩트
function onmouse_out(td) {
    td.style.textDecoration = "none";
    td.style.color = "black";

    hideTooltip();
}

function onmouse_over_Week(td) {

    if (p_Type != "MAIN") {
        td.style.cursor = "pointer";
        td.style.backgroundColor = "#2876b6";
    }
}
//일보기 마우스임팩트
function onmouse_out_Week(td) {
    if (p_Type != "MAIN") {
        //td.style.backgroundColor = "#F8F8F8";
        td.style.backgroundColor = "transparent";
    }
}

function MemberInfo_onClick(pSelUserID) {
    var c_Width = 420;
    var c_Height = 438;

    //스크린의 크기
    var s_Width = screen.availWidth;
    var s_Height = screen.availHeight;

    //열 창의 포지션
    var px = (s_Width - c_Width) / 2;
    var py = (s_Height - c_Height) / 2;

	if (pSelUserID != "") {
		window.open("/ezCommon/showPersonInfo.do?id=" + pSelUserID, "", "left=" + px + ",top=" + py + ",height=" + c_Height + "px,width=" + c_Width + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1");		
	}
}

function showTooltip_MouseOver(obj, e) {
    tip = (!e.target ? event.srcElement.value : e.target.value)

    var tTip = document.getElementById('tooltip');
    tTip.innerHTML = "";
    var tTable = document.createElement("TABLE");
    var tTr = document.createElement("TR");
    var tTh = document.createElement("TH");
    tTable.className = "calendar_layer";
    tTable.setAttribute("cellpadding", "0");
    tTable.setAttribute("cellspacing", "0");
    tTable.setAttribute("border", "0");
    tTable.setAttribute("width", "100%");
    tTh.setAttribute("scope", "col");
    tTh.textContent = obj.getAttribute("subject").split("&apos;").join("'");
    tTr.appendChild(tTh);
    tTable.appendChild(tTr);

    var tTr = document.createElement("TR");
    var tTd = document.createElement("TD");
    tTd.className = "text";

    var sTable = document.createElement("TABLE");
    var sTr = document.createElement("TR");
    var sTd = document.createElement("TD");
    sTable.className = "td_list";
    sTable.setAttribute("cellpadding", "0");
    sTable.setAttribute("cellspacing", "0");
    sTable.setAttribute("border", "0");
    sTable.setAttribute("width", "100%");
    sTd.className = "individual";

    var sSpan = document.createElement("SPAN");
    var _img = document.createElement("IMG");
    if (obj.getAttribute("approveFlag") == "1") {
        _img.src = "/images/calendar/icon_resource_ok.png"
        _img.style.verticalAlign = "middle";
        sSpan.appendChild(_img);
        sTd.appendChild(sSpan);
        sTd.innerHTML += strLang307;
    } else {
        _img.src = "/images/calendar/icon_resource_no.png"
        _img.style.verticalAlign = "middle";
        sSpan.appendChild(_img);
        sTd.appendChild(sSpan);
        sTd.innerHTML += strLang308;
    }
    sTr.appendChild(sTd);
    sTable.appendChild(sTr);

    //자원시간
    //반복이면 반복이라고 표현한다.
    var reFlag = "";
    if (obj.getAttribute("instancetype") == "1") {
        reFlag = " (" + strLang572 + ")";
    }

    //하루종일이면
    if (obj.getAttribute("alldayevent") == "1") {
        var sTr = document.createElement("TR");
        var sTd = document.createElement("TD");
        var sSpan = document.createElement("SPAN");
        //sSpan.className = "width_16";
        sTd.appendChild(sSpan);
        sTd.innerHTML += "[" + strLang573 + "]<br />" + strLang126 + reFlag;
        sTr.appendChild(sTd);
        sTable.appendChild(sTr);
        tTd.appendChild(sTable);
        tTr.appendChild(tTd);
        tTable.appendChild(tTr);
    } else {
        var sTr = document.createElement("TR");
        var sTd = document.createElement("TD");
        var sSpan = document.createElement("SPAN");
        //sSpan.className = "width_16";
        sTd.appendChild(sSpan);
        sTd.innerHTML += "[" + strLang569 + "]<br />" + obj.getAttribute("dtstart").replace('T', ' ').substring(0, 16) + reFlag;
        sTr.appendChild(sTd);
        sTable.appendChild(sTr);
        tTd.appendChild(sTable);
        tTr.appendChild(tTd);
        tTable.appendChild(tTr);

        var sTr = document.createElement("TR");
        var sTd = document.createElement("TD");
        var sSpan = document.createElement("SPAN");
        //sSpan.className = "width_16";
        sTd.appendChild(sSpan);
        sTd.innerHTML += "[" + strLang570 + "]<br />" + obj.getAttribute("dtend").replace('T', ' ').substring(0, 16) + reFlag;
        sTr.appendChild(sTd);
        sTable.appendChild(sTr);
        tTd.appendChild(sTable);
        tTr.appendChild(tTd);
        tTable.appendChild(tTr);
    }

    //예약자
    var sTr = document.createElement("TR");
    var sTd = document.createElement("TD");
    var sSpan = document.createElement("SPAN");
    //sSpan.className = "width_16";
    sTd.appendChild(sSpan);
    sTd.innerHTML += "[" + strLang571 + "]<br />" + obj.getAttribute("owner_nm");
    sTr.appendChild(sTd);
    sTable.appendChild(sTr);
    tTd.appendChild(sTable);
    tTr.appendChild(tTd);
    tTable.appendChild(tTr);

    tTip.appendChild(tTable);
    tTip.style.left = getMouseXLocation(e) + 'px';
    tTip.style.top = getMouseYLocation(e) + 'px';
    tTip.style.visibility = 'visible';
}

function hideTooltip() {
    document.getElementById('tooltip').style.visibility = 'hidden';
}//자원 클릭이벤트시 툴팁


function getMouseXLocation(e) {
    if (e)
        var E = e;
    else
        var E = window.event;

    if (E.clientX > 1000) {
        var tTip = document.getElementById("tooltip");
        var locationX = E.clientX + document.body.scrollLeft - tTip.clientWidth;
    } else {
    	var locationX = E.clientX + document.body.scrollLeft + 20;
    }

    return locationX
}

function getMouseYLocation(e) {
    if (e)
        var E = e;
    else
        var E = window.event;

    var tTip = document.getElementById("tooltip");
    if (navigator.userAgent.indexOf('Firefox') != -1) {
        if (E.clientY > 500) {
            var locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
        } else {
            if (document.documentElement.scrollTop > 0) {
                //var locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
                var locationY
                //이벤트 발생 Y좌표보다 toolTip의 높이가 더 크면 - 메디톡스 수정
                if (tTip.clientHeight > E.clientY) {
                    locationY = E.clientY + document.documentElement.scrollTop;
                } else {
                    locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
                }
            } else {
                var locationY = E.clientY + document.documentElement.scrollTop;
            }
        }
    } else {
        if (E.clientY > 500) {
            var locationY = E.clientY + document.body.scrollTop - tTip.clientHeight;
        } else {
            if (document.body.scrollTop > 0) {
                var locationY
                //이벤트 발생 Y좌표보다 toolTip의 높이가 더 크면 - 메디톡스 수정
                if (tTip.clientHeight > E.clientY) {
                    locationY = E.clientY + document.body.scrollTop;
                } else {
                    locationY = E.clientY + document.body.scrollTop - tTip.clientHeight;
                }
            } else {
                var locationY = E.clientY + document.body.scrollTop;
            }
        }
    }

    return locationY
}
