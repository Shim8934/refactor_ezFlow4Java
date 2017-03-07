//Copyright (c) 2000 Microsoft Corporation.  All rights reserved.
//<script>

var m_dlgArgs = window.dialogArguments;
var m_objStartTime;
var m_objEndTime;
var m_objStartOnDate;
var m_objEndByDate;

var m_msDateDiffStartEnd;
var CONST_MS_IN_24HRS = 86400000;

var g_Error = "" + strLang112 + "";
var g_RetVal = new Array();
var g_Frequency = { "secondly": 1, "minutely": 2, "hourly": 3, "daily": 4, "weekly": 5, "monthly": 6, "yearly": 7 };
var g_Days = { "workdays": "1, 2, 3, 4, 5,", "weekend": "0, 6," };
var g_SelDays = { "8": 0, "9": 1, "0": 2, "1": 3, "2": 4, "3": 5, "4": 6, "5": 7, "6": 8 };

function window_onload()
{
    m_objStartTime = new Date(Number(m_dlgArgs["startTime"]) + 1); 
    m_objEndTime = new Date(Number(m_dlgArgs["endTime"]) + 1);
    m_objStartOnDate = new Date(Number(m_dlgArgs["startTime"]) + 1);
    m_objEndByDate = new Date(Number(m_dlgArgs["endTime"]) + 1);
    m_objEndByDate.setMonth(m_objEndByDate.getMonth() + 3); 

    m_objStartTime.setFullYear(m_objStartTime.getFullYear().toString().substring(0, 4));
    m_objEndTime.setFullYear(m_objEndTime.getFullYear().toString().substring(0, 4));
    m_objStartOnDate.setFullYear(m_objStartOnDate.getFullYear().toString().substring(0, 4));

    idDatepickers.firstDayOfWeek = m_dlgArgs["ftDay"];
    idDatepickers.vtLocalDate = m_objStartTime;
    idDatepickers.vtLocalEndDate = m_objEndTime;

    if (m_dlgArgs["alldaycheck"] == "1")
        document.getElementById("alldaycheck").checked = true;

    m_iMsDuration = m_objEndTime.getTime() - m_objStartTime.getTime();
    if (m_iMsDuration < CONST_MS_IN_24HRS)
    {
        idDatepickers.setEndtimePicker24hours(true);
    }

    var iDateNumber = m_objStartTime.getDate();
    var iWeekdayNumber = m_objStartTime.getDay();
    var iMonthNumber = m_objStartTime.getMonth();

    document.getElementById("day" + iWeekdayNumber).checked = true;

    SetWeekdayDropDown(list_MonthlyDay, iWeekdayNumber);
    SetWeekdayDropDown(list_YearlyDay, iWeekdayNumber);

    document.getElementById("list_MonthlyDays").value = iDateNumber;
    document.getElementById("list_YearlyDays").value = iDateNumber;

    document.getElementById("list_Month").selectedIndex = iMonthNumber;
    document.getElementById("list_Month2").selectedIndex = iMonthNumber;

    var nEach = parseInt(iDateNumber / 7);
    document.getElementById("list_MonthlyEach").selectedIndex = nEach;
    document.getElementById("list_YearlyEach").selectedIndex = nEach;

    if (typeof (m_dlgArgs["recurrence"]) != "undefined")
    {
        var xmlinDoc = null;
        var xmlFrequency = null;

        try
        {
            /*if (navigator.userAgent.indexOf('MSIE') == -1)*/
        	if(CrossYN())
            {
                xmlinDoc = createXmlDom();
                xmlinDoc = loadXMLString(m_dlgArgs["recurrence"]); //new DOMParser().parseFromString(m_dlgArgs["recurrence"], "text/xml");

                szType = xmlinDoc.getElementsByTagName("frequency").item(0).firstChild.nodeValue;
            }
            else
            {
                xmlinDoc = new ActiveXObject("Microsoft.XMLDOM");
                xmlinDoc.async = false;
                xmlinDoc.loadXML(m_dlgArgs["recurrence"]);

                szType = xmlinDoc.getElementsByTagName("frequency").item(0).text;
            }

            switch (szType)
            {
                case "4":
                    SetDaily(xmlinDoc);
                    break;
                case "5":
                    SetWeekly(xmlinDoc);
                    break;
                case "6":
                    SetMonthly(xmlinDoc);
                    break;
                case "7":
                    SetYearly(xmlinDoc);
                    break;
                default:
                    break;
            }

            SetRemainder(xmlinDoc);
        }
        catch (e) {

        }
    }
}

function SetDaily(xmlDaily)
{
    document.getElementById("mpDaily").checked = true;

    showMainPattern(0);

    if (getNodeText(SelectNodes(xmlDaily, "recurrence/selType")[0]) != 0)
    {
        document.getElementById("id0D2").checked = true;
    }
    else
    {
        document.getElementById("txt_De").value = getNodeText(SelectNodes(xmlDaily, "recurrence/interval")[0]); //xmlDaily.getElementsByTagName("interval").item(0).text;
    }
}

function SetWeekly(xmlWeekly)
{
    document.getElementById("mpWeekly").checked = true;

    showMainPattern(1);

    document.getElementById("day" + m_objStartTime.getDay()).checked = false;
    var szValue = getNodeText(SelectNodes(xmlWeekly, "recurrence/daysOfWeek")[0]); //xmlWeekly.getElementsByTagName("daysOfWeek").item(0).text;

    days = window.document.all["day"]; //window.document.getElementById('divRecurPatterns')[1].all["day"];

    for (nCount = 0; nCount < days.length; nCount++)
    {
        if (szValue.indexOf(nCount) != -1)
            document.getElementById("day" + nCount).checked = true;
    }

    document.getElementById("txt_We").value = getNodeText(SelectNodes(xmlWeekly, "recurrence/interval")[0]); 
}

function SetMonthly(xmlMonthly)
{
    document.getElementById("mpMontly").checked = true;
    showMainPattern(2);

    if (getNodeText(SelectNodes(xmlMonthly, "recurrence/selType")[0]) == 0)
    {
        document.getElementById("idOM1").checked = true;
        document.getElementById("list_MonthInterval").value = getNodeText(SelectNodes(xmlMonthly, "recurrence/interval")[0]); 
        document.getElementById("list_MonthlyDays").value = getNodeText(SelectNodes(xmlMonthly, "recurrence/daysOfMonth")[0]); 
    }
    else
    {
        document.getElementById("id0M2").checked = true;
        document.getElementById("list_MonthInterval2").value = getNodeText(SelectNodes(xmlMonthly, "recurrence/interval")[0]);

        var szWeek = getNodeText(SelectNodes(xmlMonthly, "recurrence/byPosition")[0]);

        szWeek == "-1" ? document.getElementById("list_MonthlyEach").selectedIndex = (document.getElementById("list_MonthlyEach").options.length - 1) : (document.getElementById("list_MonthlyEach").selectedIndex = parseInt(szWeek) - 1);
        var szDay = getNodeText(SelectNodes(xmlMonthly, "recurrence/daysOfWeek")[0]);

        szDay = szDay.split(",");

        if (szDay.length == 1 || szDay[1] == "")
        {
            document.getElementById("list_MonthlyDay").selectedIndex = parseInt(szDay[0]) + 2;
        }
        else
        {
            szDay.length > 3 ? document.getElementById("list_MonthlyDay").selectedIndex = 0 : document.getElementById("list_MonthlyDay").selectedIndex = 1;
        }
    }
}

function SetYearly(xmlYearlly)
{
    document.getElementById("mpYealy").checked = true;

    showMainPattern(3);

    if (getNodeText(SelectNodes(xmlYearlly, "recurrence/selType")[0]) == 0)
    {
        document.getElementById("optY1").checked = true;
        document.getElementById("list_YearlyDays").value = getNodeText(SelectNodes(xmlYearlly, "recurrence/daysOfMonth")[0]);
        document.getElementById("list_Month").selectedIndex = parseInt(getNodeText(SelectNodes(xmlYearlly, "recurrence/monthsOfYear")[0])) - 1; 
    }
    else
    {
        document.getElementById("optY2").checked = true;
        document.getElementById("list_Month2").selectedIndex = parseInt(getNodeText(SelectNodes(xmlYearlly, "recurrence/monthsOfYear")[0])) - 1; 

        var szWeek = getNodeText(SelectNodes(xmlYearlly, "recurrence/byPosition")[0]); 

        szWeek == "-1" ? document.getElementById("list_YearlyEach").selectedIndex = (document.getElementById("list_YearlyEach").options.length - 1) : (document.getElementById("list_YearlyEach").selectedIndex = parseInt(szWeek) - 1);
        var szDay = getNodeText(SelectNodes(xmlYearlly, "recurrence/daysOfWeek")[0]);

        szDay = szDay.split(",");

        if (szDay.length == 1 || szDay[1] == "")
        {
            document.getElementById("list_YearlyDay").selectedIndex = parseInt(szDay[0]) + 2;
        }
        else
        {
            szDay.length > 3 ? document.getElementById("list_YearlyDay").selectedIndex = 0 : document.getElementById("list_YearlyDay").selectedIndex = 1;
        }
    }
}

function SetWeekdayDropDown(ddDay, value)
{
    var iList;
    var iLength = ddDay.length;

    for (iList = 0; iList < iLength; iList++)
    {
        if (ddDay[iList].value == value)
        {
            ddDay[iList].selected = true;
            return;
        }
    }
    return;
}

function event_btnRemoveRecurrence_onclick()
{
    window.returnValue = 0; 
    window.close();
}

function event_btnCancel_onclick()
{
    window.returnValue = -1;
    window.close();
}

function putReturnData(szCommand, vData)
{
    g_RetVal[szCommand] = vData;
}

function CheckStartEndDateTime()
{
    var start = idDatepickers.startFullYear() + "-"
				+ TimeRevision((parseInt(idDatepickers.startMonth()) + 1)) + "-"
				+ TimeRevision(idDatepickers.startDate()) + " "
				+ TimeRevision(idDatepickers.startHours()) + ":"
				+ TimeRevision(idDatepickers.startMinutes());
    var end = idDatepickers.endFullYear() + "-"
				+ TimeRevision((parseInt(idDatepickers.endMonth()) + 1)) + "-"
				+ TimeRevision(idDatepickers.endDate()) + " "
				+ TimeRevision(idDatepickers.endHours()) + ":"
				+ TimeRevision(idDatepickers.endMinutes());

    if (start >= end)
        return false;
    else
        return true;
}

function CheckStartDateTime()
{
    var start = idDatepickers.startFullYear() + "-"
				+ TimeRevision((parseInt(idDatepickers.startMonth()) + 1)) + "-"
				+ TimeRevision(idDatepickers.startDate()) + " "
				+ TimeRevision(idDatepickers.startHours()) + ":"
				+ TimeRevision(idDatepickers.startMinutes());
    var end = idDatepickers.startFullYear() + "-"
				+ TimeRevision((parseInt(idDatepickers.startMonth()) + 1)) + "-"
				+ TimeRevision(idDatepickers.startDate()) + " "
				+ TimeRevision(idDatepickers.endHours()) + ":"
				+ TimeRevision(idDatepickers.endMinutes());

    if (TimeRevision(idDatepickers.endHours()) == "00" && TimeRevision(idDatepickers.endMinutes()) == "00")
    {
        end = idDatepickers.startFullYear() + "-"
				+ TimeRevision((parseInt(idDatepickers.startMonth()) + 1)) + "-"
				+ TimeRevision(idDatepickers.startDate()) + " "
				+ "24:00"
    }

    if (start >= end)
    {
        return false;
    }
    else
    {
        return true;
    }
}

function CheckStartEndDate()
{
    var start = idDatepickers.startFullYear() + "-"
				+ TimeRevision((parseInt(idDatepickers.startMonth()) + 1)) + "-"
				+ TimeRevision(idDatepickers.startDate());

    var end = idDatepickers.endFullYear() + "-"
				+ TimeRevision((parseInt(idDatepickers.endMonth()) + 1)) + "-"
				+ TimeRevision(idDatepickers.endDate());

    if (start > end)
        return false;
    else
        return true;
}

function CheckBeforeSave()
{
    if (TB_Promise.style.display != "none")
    {
        if (document.getElementById("EndTimeSet").checked)	
        {
            if (!CheckStartEndDate())
            {
                alert("" + strLang100 + "");
                return false;
            }
        }

        if (!CheckStartDateTime())
        {
            alert("" + strLang101 + "");
            return false;
        }
    }
    else
    {
        if (document.getElementById("EndTimeSet").checked)
        {
            if (!CheckStartEndDate())
            {
                alert("" + strLang100 + "");
                return false;
            }
        }
    }

    return true;
}

function RepCheck(xmlStr)
{
    var start = idDatepickers.startFullYear() + "-"
				+ TimeRevision((parseInt(idDatepickers.startMonth()) + 1)) + "-"
				+ TimeRevision(idDatepickers.startDate());

    var end = idDatepickers.endFullYear() + "-"
				+ TimeRevision((parseInt(idDatepickers.endMonth()) + 1)) + "-"
				+ TimeRevision(idDatepickers.endDate());


    if (start == end)
    {
        return false;
    }
    else
    {
        return true;
    }

    var cmd = getMainPattern();
    var from;

    var xmlHttp = createXMLHttpRequest();
    var xmlDoc = createXmlDom();

    xmlDoc = xmlStr;

    AppendNode(xmlDoc, "frequency");
    AppendNode(xmlDoc, "selType"); 	
    AppendNode(xmlDoc, "startDateTime");
    AppendNode(xmlDoc, "endDateTime"); 	
    AppendNode(xmlDoc, "interval"); 	
    AppendNode(xmlDoc, "daysOfWeek"); 	
    AppendNode(xmlDoc, "daysOfMonth"); 	
    AppendNode(xmlDoc, "byPosition"); 	
    AppendNode(xmlDoc, "monthsOfYear"); 
    AppendNode(xmlDoc, "endRecurType"); 
    AppendNode(xmlDoc, "instances"); 	

    if (TB_Promise.style.display != "none")
        from = "schedule";
    else
        from = "task";

    xmlHttp.Open("POST", "/ZHome/myoffice/controls/dlg_recurrence_proc.asp?from=" + from + "&sDate=" + start + "&eDate=" + end + "&cmd=" + cmd, false);
    xmlHttp.Send(xmlDoc.xml);

    var result = xmlHttp.responseXML;

    if (trim(result.text) == "1")
        return true;
    else
        return false;
}

function trim(parm_str)
{
    return rtrim(ltrim(parm_str));
}

function ltrim(parm_str)
{
    str_temp = parm_str;

    while (str_temp.length != 0)
    {
        if (str_temp.substring(0, 1) == " ")
        {
            str_temp = str_temp.substring(1, str_temp.length);
        }
        else
        {
            return str_temp;
        }
    }

    return str_temp;
}

function rtrim(parm_str)
{
    str_temp = parm_str;

    while (str_temp.length != 0)
    {
        int_last_blnk_pos = str_temp.lastIndexOf(" ");

        if ((str_temp.length - 1) == int_last_blnk_pos)
        {
            str_temp = str_temp.substring(0, str_temp.length - 1);
        }
        else
        {
            return str_temp;
        }
    }

    return str_temp;
}

function ReplaceText(orgStr, findStr, replaceStr)
{
    var re = new RegExp(findStr, "gi");
    return (orgStr.replace(re, replaceStr));
}

function NumCheck(ckNum)
{
    if (!/^[0-9]{1,}$/.test(ckNum))
        return false;
}

function AppendNode(xmlDom, item)
{
    if (SelectSingleNodeNew(xmlDom, item) == null)
    {
        var objNode = xmlDom.createNode(1, item, "");
        objNode.text = "";
        xmlDom.childNodes(0).appendChild(objNode);
    }
}

function event_btnOk_onclick()
{
    var xmlDoc = null;
    var Root = null;

    if (!CheckBeforeSave())
        return;

    if (NumCheck(document.getElementById("txt_De").value) == false)
    {
        alert(g_Error);
        document.getElementById("txt_De").value = "1";
        return;
    }

    if (NumCheck(document.getElementById("txt_We").value) == false)
    {
        alert(g_Error);
        document.getElementById("txt_We").value = "1";
        return;
    }

    if (NumCheck(document.getElementById("list_MonthInterval").value) == false)
    {
        alert(g_Error);
        document.getElementById("list_MonthInterval").value = "1";
        return;
    }

    if (NumCheck(document.getElementById("list_MonthlyDays").value) == false)
    {
        alert(g_Error);
        document.getElementById("list_MonthlyDays").value = idDatepickers.startDate();
        return;
    }

    if (NumCheck(document.getElementById("list_MonthInterval2").value) == false)
    {
        alert(g_Error);
        document.getElementById("list_MonthInterval2").value = "1";
        return;
    }

    if (NumCheck(document.getElementById("list_YearlyDays").value) == false)
    {
        alert(g_Error);
        document.getElementById("list_YearlyDays").value = idDatepickers.startDate();
        return;
    }

    if (document.getElementById("Instances").checked == true && NumCheck(document.getElementById("list_ReCount").value) == false)
    {
        alert(g_Error);
        document.getElementById("list_ReCount").value = "10";
        return;
    }

    try
    {
        xmlDoc = createXmlDom();

        createNodeInsert(xmlDoc, Root, "recurrence");

        var pAlldaycheck = "";
        if (document.getElementById("alldaycheck").checked == true)
            pAlldaycheck = "1";
        else
            pAlldaycheck = "0";

        putReturnData("alldaycheck", pAlldaycheck);
        putReturnData("startTime", m_objStartTime); //m_objStartTime.getVarDate() );
        putReturnData("endTime", m_objEndTime); //m_objEnde.gTimetVarDate() );
        putReturnData("ptEndDate", idDatepickers.isoEndDateUTC());

        Remainder(Root, xmlDoc); // 반복주기 설정범위에 대한 return 값 설정

        switch (getMainPattern())	// 반복주기에 대한 return 값 설정
        {
            case 0:
                DailyDisposal(xmlDoc, 0);
                break;

            case 1:
                if (!WeeklyDisposal(xmlDoc, 1))
                    return;
                break;

            case 2:
                MonthlyDisposal(xmlDoc, 2);
                break;

            case 3:
                YearlyDisposal(xmlDoc, 3);
                break;

                defualt:
                break;
        }

        var startDateTime, endDateTime, tmpEndDateTime;
        createNodeAndInsertText(xmlDoc, Root, "startDateTime", idDatepickers.startFullYear() + "-"
							+ TimeRevision((parseInt(idDatepickers.startMonth()) + 1)) + "-"
							+ TimeRevision(idDatepickers.startDate()) + " "
							+ TimeRevision(idDatepickers.startHours()) + ":"
							+ TimeRevision(idDatepickers.startMinutes()) + ":00");

        createNodeAndInsertText(xmlDoc, Root, "endDateTime", idDatepickers.endFullYear() + "-"
							+ TimeRevision((parseInt(idDatepickers.endMonth()) + 1)) + "-"
							+ TimeRevision(idDatepickers.endDate()) + " "
							+ TimeRevision(idDatepickers.endHours()) + ":"
							+ TimeRevision(idDatepickers.endMinutes()) + ":00");

        putReturnData("xml", getXmlString(xmlDoc));

        if (document.getElementById("EndTimeSet").checked)	// 종료일로 지정
        {
            if (!RepCheck(getXmlString(xmlDoc)))
            {
                alert(strLang111 + "\n" + "" + strLang112 + "");
                return false;
            }
        }

    }
    catch (e) {
    }

    window.returnValue = g_RetVal;
    window.close();
}

function DailyDisposal(xmlDoc, nPattern)
{
    var tmpElem = null;
    var objNode;
    
    try
    {
        createNodeAndInsertText(xmlDoc, objNode, "frequency", g_Frequency["daily"]);
        daily = window.document.all["optDaily"];

        for (nCount = 0; nCount < daily.length; nCount++)
        {
            if (daily[nCount].checked)
                break;
        }

        if (nCount == 0)
        {
            iNumber = validateNumber(document.getElementById("txt_De").value);
            if (isNaN(iNumber))
            {
                document.getElementById("txt_De").focus();
                alert(g_Error);
                createNodeAndInsertText(xmlDoc, objNode, "interval", "");
                return 0;
            }
            else
            {
                if (iNumber == "" || iNumber == 0) {
                    iNumber = 1;
                }
                createNodeAndInsertText(xmlDoc, objNode, "interval", iNumber);
                createNodeAndInsertText(xmlDoc, objNode, "selType", 0);
            }
        }
        else
        {
            createNodeAndInsertText(xmlDoc, objNode, "interval", 1);
            createNodeAndInsertText(xmlDoc, objNode, "selType", 1);
            createNodeAndInsertText(xmlDoc, objNode, "daysOfWeek", g_Days["workdays"]);
        }
    }
    catch (e)
    {
        window.returnValue = -1;
    }
}

function WeeklyDisposal(xmlDoc, nPattern)
{
    var days = null;
    var objNode;
    var szDays = "";

    try
    {
        createNodeAndInsertText(xmlDoc, objNode, "frequency", g_Frequency["weekly"]);

        iNumber = validateNumber(document.getElementById("txt_We").value);
        if (isNaN(iNumber))
        {
            document.getElementById("txt_We").focus();
            alert(g_Error);
            return false;
        }
        else
        {
            createNodeAndInsertText(xmlDoc, objNode, "selType", 1);
            if (iNumber == "" || iNumber == 0) {
                iNumber = 1;
            }
            createNodeAndInsertText(xmlDoc, objNode, "interval", iNumber);

            days = window.document.all["day"];

            var check = 0;

            for (nCount = 0; nCount < days.length; nCount++)
            {
                if (!days[nCount].checked)
                {
                    continue;
                }

                szDays += days[nCount].value + ",";

                check++;
            }

            if (check == 0)
            {
                alert("" + strLang113 + "");
                return false;
            }

            createNodeAndInsertText(xmlDoc, objNode, "daysOfWeek", szDays);

        }

        return true;
    }
    catch (e)
    {
        this.returnValue = -1;
    }
}

function MonthlyDisposal(xmlDoc, nPattern)
{
    var tmpElem = null;
    var month;
    var objNode;
    try
    {
        createNodeAndInsertText(xmlDoc, objNode, "frequency", g_Frequency["monthly"]);
        month = window.document.all["optMonthly"];
        
        for (nCount = 0; nCount < month.length; nCount++)
        {
            if (month[nCount].checked)
                break;
        }

        if (nCount == 0)
        {
            iNumber = validateNumber(document.getElementById("list_MonthInterval").value);

            var iDays = validateNumber(document.getElementById("list_MonthlyDays").value);
            var iMonth = validateNumber(document.getElementById("list_MonthInterval").value);

            if (isNaN(iDays) || iDays > 31)
            {
                document.getElementById("list_MonthInterval").focus();
                alert(g_Error);
                return 0;
            }

            createNodeAndInsertText(xmlDoc, objNode, "selType", 0);

            if (document.getElementById("list_MonthInterval").value == "" || document.getElementById("list_MonthInterval").value == 0)
                document.getElementById("list_MonthInterval").value = 1;

            createNodeAndInsertText(xmlDoc, objNode, "interval", document.getElementById("list_MonthInterval").value);

            if (document.getElementById("list_MonthlyDays").value == "" || document.getElementById("list_MonthlyDays").value == 0)
                document.getElementById("list_MonthlyDays").value = 1;
            createNodeAndInsertText(xmlDoc, objNode, "daysOfMonth", document.getElementById("list_MonthlyDays").value);
        }
        else
        {
            createNodeAndInsertText(xmlDoc, objNode, "selType", 1);

            if (document.getElementById("list_MonthInterval2").value == "" || document.getElementById("list_MonthInterval2").value == 0)
                document.getElementById("list_MonthInterval2").value = 1;
            createNodeAndInsertText(xmlDoc, objNode, "interval", document.getElementById("list_MonthInterval2").value);
            createNodeAndInsertText(xmlDoc, objNode, "selType", 1);
            createNodeAndInsertText(xmlDoc, objNode, "byPosition", document.getElementById("list_MonthlyEach").value);

            if (list_MonthlyDay.value == 8)
            {
                createNodeAndInsertText(xmlDoc, objNode, "daysOfWeek", g_Days["workdays"]);
            }
            else if (list_MonthlyDay.value == 9)
            {
                createNodeAndInsertText(xmlDoc, objNode, "daysOfWeek", g_Days["weekend"]);
            }
            else
            {
                createNodeAndInsertText(xmlDoc, objNode, "daysOfWeek", document.getElementById("list_MonthlyDay").value);
            }

        }
    }
    catch (e) {
        this.returnValue = -1;
    }
}

function YearlyDisposal(xmlDoc, nPattern)
{
    //var xmlDoc = null;
    var tmpElem = null;
    var year;
    var month;
    var objNode;
    
    try
    {
        createNodeAndInsertText(xmlDoc, objNode, "frequency", g_Frequency["yearly"]);
        createNodeAndInsertText(xmlDoc, objNode, "interval", 1);

        year = window.document.all["optYearly"];

        for (nCount = 0; nCount < year.length; nCount++)
        {
            if (year[nCount].checked)
                break;
        }

        if (nCount == 0)
        {
            iNumber = validateNumber(document.getElementById("list_YearlyDays").value);
            if (isNaN(iNumber) || iNumber > 31)
            {
                document.getElementById("list_YearlyDays").focus();
                alert(g_Error);
                return 0;
            }
            createNodeAndInsertText(xmlDoc, objNode, "selType", 0);

            if (document.getElementById("list_Month").value == "")
                document.getElementById("list_Month").value = 1;

            createNodeAndInsertText(xmlDoc, objNode, "monthsOfYear", document.getElementById("list_Month").value);

            if (document.getElementById("list_YearlyDays").value == "" || document.getElementById("list_YearlyDays").value == 0)
                document.getElementById("list_YearlyDays").value = 1;
            createNodeAndInsertText(xmlDoc, objNode, "daysOfMonth", document.getElementById("list_YearlyDays").value);
 
        }
        else
        {
            createNodeAndInsertText(xmlDoc, objNode, "selType", 1);
            createNodeAndInsertText(xmlDoc, objNode, "monthsOfYear", document.getElementById("list_Month2").value);
            createNodeAndInsertText(xmlDoc, objNode, "byPosition", document.getElementById("list_YearlyEach").value);

            if (document.getElementById("list_YearlyDay").value == 8)
            {
                createNodeAndInsertText(xmlDoc, objNode, "daysOfWeek", g_Days["workdays"]);
            }
            else if (document.getElementById("list_YearlyDay").value == 9)
            {
                createNodeAndInsertText(xmlDoc, objNode, "daysOfWeek", g_Days["weekend"]);
            }
            else
            {
                createNodeAndInsertText(xmlDoc, objNode, "daysOfWeek", document.getElementById("list_YearlyDay").value);
            }
        }
    }
    catch (e)
    {
        this.returnValue = -1;
    }
}


var m_iSavedNumber;
function saveNumber(elem)
{
    m_iSavedNumber = event.srcElement.value;
}

function validateNumber(inNum)
{
    var iEntry = Number(inNum);
    
    if (isNaN(iEntry))
    {
        var iCh, chCode, szNewNumber = "";
        
        for (var x = 0; x < inNum.length; x++)
        {

            iCh = inNum.charCodeAt(x);
            chCode = Number(iCh.toString(10));
            if (chCode > 0xFF) //unicode
            {
                chCode = (iCh & 0x001f) | 0x20;
            }
            szNewNumber += String.fromCharCode(chCode);
        }
        iEntry = Number(szNewNumber);
    }
    return (iEntry)
}

function getMainPattern()
{
    ePattern = window.document.all['optMainPattern'];
    for (var x = 0; x < 4; x++)
    {
        if (ePattern[x].checked) break;
    }
    return (x);
}

function showMainPattern(idx)
{
    eAllPatterns = window.document.all['divRecurPatterns'];
    
    for (var x = 0; x < eAllPatterns.length; x++)
    {
        eAllPatterns[x].style.display = "none";
    }
    window.document.all['divRecurPatterns'][idx].style.display = "";
}

function IsLeapYear(yr)
{
    return (((yr % 4 == 0) && (yr % 100 != 0)) || (yr % 400 == 0)) ? 1 : 0;
}

function daysInMonth(iMonth, iYear)
{
    return ((2 == iMonth) ? (28 + issLeapYear(iYear)) : (30 + ((iMonth + (iMonth > 7)) % 2)));
}

function checkYear(YF)
{
    var year = parseInt(YF)

    if (!isNaN(year))
    {
        if ((1970 <= year) && (year <= 2038))
        {
            return year;
        }
        else if ((70 <= year) && (year <= 99))
        {
            return year + 1900;
        }
        else if ((0 <= year) && (year <= 38))
        {
            return year + 2000;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

function onDateChanged(iWhich)
{
    if (0 == iWhich)
    {
        var iMs1 = m_objStartOnDate.getTime();
        m_objStartOnDate.setFullYear(idDatepickers.startFullYear(), idDatepickers.startMonth(), idDatepickers.startDate());
        var msDiff = m_objStartOnDate.getTime() - iMs1;
        m_objStartTime.setTime(m_objStartTime.getTime() + msDiff);
        m_objEndTime.setTime(m_objEndTime.getTime() + msDiff);
    }
    else
    {
        m_objEndByDate.setFullYear(idDatepickers.endFullYear(), idDatepickers.endMonth(), idDatepickers.endDate());
    }
}

var m_iMsDuration;
function onTimeChanged(iWhich)
{
    switch (iWhich)
    {
        case 0: //start
            m_objStartTime.setHours(idDatepickers.startHours(), idDatepickers.startMinutes(), 0, 0);

            if (m_objEndTime.getTime() > m_objStartTime.getTime())
            {
                m_iMsDuration = m_objEndTime.getTime() - m_objStartTime.getTime();
            }
            else
            {
                m_iMsDuration = m_objStartTime.getTime() - m_objEndTime.getTime();
            }
            if (m_iMsDuration < CONST_MS_IN_24HRS)
            {
                idDatepickers.setEndtimePicker24hours(true);
            }
            break;

        case 1: //end
            m_objEndTime.setHours(idDatepickers.endHours());
            if (m_objEndTime.getTime() > m_objStartTime.getTime())
            {
                m_iMsDuration = m_objEndTime.getTime() - m_objStartTime.getTime();
            }
            else
            {
                m_iMsDuration = m_objStartTime.getTime() - m_objEndTime.getTime();
            }
            if (m_iMsDuration < CONST_MS_IN_24HRS)
            {
                idDatepickers.setEndtimePicker24hours(true);
            }
            
            break;
    }
}

function Remainder(Root, xmlDoc)
{
    tmpElem = null;

    try
    {
        if (document.getElementById("Instances").checked)	// 횟수로 지정
        {
            createNodeAndInsertText(xmlDoc, Root, "endRecurType", 1);
            createNodeAndInsertText(xmlDoc, Root, "instances", document.getElementById("list_ReCount").value);
        }
        else if (document.getElementById("EndTimeSet").checked)	// 종료일로 지정
        {
            createNodeAndInsertText(xmlDoc, Root, "endRecurType", 2);

            szEndDate = (parseInt(idDatepickers.endMonth()) + 1) + "/"
									+ idDatepickers.endDate() + "/"
									+ idDatepickers.endFullYear() + " "
									+ TimeRevision(idDatepickers.endHours()) + ":"
									+ TimeRevision(idDatepickers.endMinutes());
            createNodeAndInsertText(xmlDoc, Root, "patternEndDate", szEndDate);
        }
        else	// 종료일 지정안함
        {
            createNodeAndInsertText(xmlDoc, Root, "endRecurType", 0);
        }
    }
    catch (e) {

    }
}

function SetRemainder(xmlRe)
{
    szType = getNodeText(SelectNodes(xmlRe, "recurrence/endRecurType")[0]); //xmlRe.getElementsByTagName("endRecurType").item(0).text;

    if (szType == "1")
    {
        document.getElementById("Instances").checked = true;
        document.getElementById("list_ReCount").value = getNodeText(SelectNodes(xmlRe, "recurrence/instances")[0]); //xmlRe.getElementsByTagName("instances").item(0).text;
    }
    else if (szType == "2") {
        document.getElementById("EndTimeSet").checked = true;

        if (typeof (m_dlgArgs["ptEndDate"]) != "undefined")
        {
            objD = getLocalDateObjFromGMTTime(m_dlgArgs["ptEndDate"]);
        }
        else if (typeof (m_dlgArgs["recurrence"]) != "undefined")
        {
            var tmpDate = getNodeText(SelectNodes(xmlRe, "recurrence/endDateTime")[0]); //xmlRe.getElementsByTagName("endDateTime").item(0).text;

            var y, m1, m2, m, d, h, mm, disp;

            y = tmpDate.substring(0, 4);
            m1 = tmpDate.substring(5, 6);
            m2 = tmpDate.substring(6, 7);
            m = tmpDate.substring(5, 7)
            d = tmpDate.substring(8, 10);

            disp = tmpDate.substring(11, 13);
            var arrTime = tmpDate.substring(14).split(":");
            h = arrTime(0); //tmpDate.substring( 14, 16 );
            mm = arrTime(1); //tmpDate.substring( 17, 19 );

            if (m1 == "0")
                m = "0" + String(parseInt(m2) - 1);
            else
                m = String(parseInt(m) - 1);

            if (disp == "" + strLang15 + "" && parseInt(h) == 12)
                h = parseInt(h) - 12

            objD = new Date(y, m, d, h, mm);
        }

        idDatepickers.vtLocalEndDate(objD);
    }
}

function IsoUTFDate(szDate)
{
    var szTime, iSoDate;

    if (szDate.indexOf(" ") != -1)
    {
        szTime = szDate.split(" ")[2].split(":");

        if ((szDate.search(/strLang116/i) != -1 || szDate.search(/PM/i) != -1) && parseInt(szTime[0], 10) < 12)
        {
            szTime = (szTime[0] = parseInt(szTime[0], 10) + 12) + ":" + szTime[1] + ":" + szTime[2];
        }
        else if (szDate.search(/strLang117/) != -1 || szDate.search(/AM/i) != -1)
        {
            if (szTime[0].length <= 1)
            {
                szTime = "0" + szTime[0] + ":" + szTime[1] + ":" + szTime[2];
            }
            else if (parseInt(szTime[0], 10) == 12)
            {
                szTime = "00" + ":" + szTime[1] + ":" + szTime[2];
            }
        }

        iSoDate = szDate.split(" ")[0] + "T" + szTime + ".000Z";
    }
    else
    {
        iSoDate = szDate + "T00:00:00.000Z";
    }

    return iSoDate;
}

function TimeRevision(szTime)
{
    if (parseInt(szTime) == 0)
    {
        szTime = "00";
    }
    else if (parseInt(szTime) > 0 && parseInt(szTime) < 10)
    {
        szTime = "0" + szTime;
    }

    return szTime
}

