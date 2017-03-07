var ReturnFunction;
var m_dlgArgs;
var	m_objStartTime;
var	m_objEndTime;
var	m_objStartOnDate;
var	m_objEndByDate;

var	m_msDateDiffStartEnd;
var CONST_MS_IN_24HRS = 86400000;

var g_Error = "" + strLang95 + "";
var g_RetVal = new Array();
var g_Frequency = { "secondly" : 1, "minutely" : 2, "hourly" : 3, "daily" : 4, "weekly" : 5, "monthly" : 6, "yearly" : 7 };
var g_Days = { "workdays" : "1, 2, 3, 4, 5," , "weekend" : "0, 6," }; 
var g_SelDays = { "8":0, "9":1, "0":2, "1":3, "2":4, "3":5, "4":6, "5":7, "6":8 };

function window_onload() {
    try {
        m_dlgArgs = parent.schedule_repetition_cross_dialogArguments[0];
        ReturnFunction = parent.schedule_repetition_cross_dialogArguments[1];
    } catch (e) {
        try {
            m_dlgArgs = opener.schedule_repetition_cross_dialogArguments[0];
            ReturnFunction = opener.schedule_repetition_cross_dialogArguments[1];
        } catch (e) {
            m_dlgArgs = dialogArguments;
        }
        
    }


    try {
        if (m_dlgArgs["alldaycheck"] == "1") {
            try {
                m_objStartTime = new Date(m_dlgArgs["startTime"].split(' ')[0].split('-')[0], parseInt(m_dlgArgs["startTime"].split(' ')[0].split('-')[1]) - 1, m_dlgArgs["startTime"].split(' ')[0].split('-')[2], m_dlgArgs["startTime"].split(' ')[1].split(':')[0], m_dlgArgs["startTime"].split(' ')[1].split(':')[1], 0, 0);
                m_objEndTime = new Date(m_dlgArgs["endTime"].split(' ')[0].split('-')[0], parseInt(m_dlgArgs["endTime"].split(' ')[0].split('-')[1]) - 1, m_dlgArgs["endTime"].split(' ')[0].split('-')[2], m_dlgArgs["endTime"].split(' ')[1].split(':')[0], m_dlgArgs["endTime"].split(' ')[1].split(':')[1], 0, 0);
            } catch (e) {
                m_objStartTime = new Date(m_dlgArgs["startTime"]);
                m_objEndTime = new Date(m_dlgArgs["endTime"]);
            }            
            document.getElementById("alldaycheck").checked = true;
        }
        else {
            try {
                m_objStartTime = new Date(m_dlgArgs["startTime"].split(' ')[0].split('-')[0], parseInt(m_dlgArgs["startTime"].split(' ')[0].split('-')[1]) - 1, m_dlgArgs["startTime"].split(' ')[0].split('-')[2], m_dlgArgs["startTime"].split(' ')[1].split(':')[0], m_dlgArgs["startTime"].split(' ')[1].split(':')[1], 0, 0);
                m_objEndTime = new Date(m_dlgArgs["endTime"].split(' ')[0].split('-')[0], parseInt(m_dlgArgs["endTime"].split(' ')[0].split('-')[1]) - 1, m_dlgArgs["endTime"].split(' ')[0].split('-')[2], m_dlgArgs["endTime"].split(' ')[1].split(':')[0], m_dlgArgs["endTime"].split(' ')[1].split(':')[1], 0, 0);
            } catch (e) {
                m_objStartTime = new Date(m_dlgArgs["startTime"]);
                m_objEndTime = new Date(m_dlgArgs["endTime"]);
            }            
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

        if (typeof (m_dlgArgs["recurrence"]) != "undefined" && m_dlgArgs["recurrence"] != "") {
            var xmlinDoc = null;
            var xmlFrequency = null;

            if (CrossYN() || pNoneActiveX == "YES") {
                xmlinDoc = createXmlDom();
                xmlinDoc = loadXMLString(m_dlgArgs["recurrence"]);

                szType = xmlinDoc.getElementsByTagName("frequency").item(0).firstChild.nodeValue;
            }
            else {
                xmlinDoc = createXmlDom();
                xmlinDoc = loadXMLString(m_dlgArgs["recurrence"]);

                szType = xmlinDoc.getElementsByTagName("frequency").item(0).text;
            }
            switch (szType) {
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
    }
    catch (e) {
        alert(e.message);
    }
}


function SetDaily( xmlDaily )
{	

	document.getElementById("mpDaily").checked = true;
	showMainPattern(0);
	if( getNodeText(SelectNodes(xmlDaily,"recurrence/selType")[0])!= 0)
	{
		document.getElementById("id0D2").checked = true;	
	}
	else
	{
		document.getElementById("txt_De").value = getNodeText(SelectNodes(xmlDaily,"recurrence/interval")[0]);
	}	
}

function SetWeekly( xmlWeekly )
{
	document.getElementById("mpWeekly").checked = true;
	
	showMainPattern(1);
	document.getElementById("day"+m_objStartTime.getDay()).checked = false;
	var szValue = getNodeText(SelectNodes(xmlWeekly,"recurrence/daysOfWeek")[0]);
	
	days = window.document.getElementsByName("day");
			
	for( nCount = 0; nCount < days.length; nCount++ )
	{
		if( szValue.indexOf( nCount ) != -1 )
		document.getElementById("day"+nCount).checked = true;
	}
	
	document.getElementById("txt_We").value = getNodeText(SelectNodes(xmlWeekly,"recurrence/interval")[0]);
}

function SetMonthly( xmlMonthly )
{
	document.getElementById("mpMontly").checked = true;
	showMainPattern(2);
	
	if( getNodeText(SelectNodes(xmlMonthly,"recurrence/selType")[0]) == 0 )
	{
		document.getElementById("idOM1").checked = true;
		document.getElementById("list_MonthInterval").value = getNodeText(SelectNodes(xmlMonthly,"recurrence/interval")[0]);
		document.getElementById("list_MonthlyDays").value = getNodeText(SelectNodes(xmlMonthly,"recurrence/daysOfMonth")[0]);
	}
	else
	{
		document.getElementById("id0M2").checked = true;
		document.getElementById("list_MonthInterval2").value = getNodeText(SelectNodes(xmlMonthly,"recurrence/interval")[0]);
	
    var szWeek = getNodeText(SelectNodes(xmlMonthly,"recurrence/byPosition")[0]);
   
    szWeek == "-1" ? document.getElementById("list_MonthlyEach").selectedIndex = (document.getElementById("list_MonthlyEach").options.length - 1) : (document.getElementById("list_MonthlyEach").selectedIndex = parseInt(szWeek) - 1);
    var szDay = getNodeText(SelectNodes(xmlMonthly,"recurrence/daysOfWeek")[0]);
    
    szDay = szDay.split(",");
   
    if( szDay.length == 1 || szDay[1] == "")
    {
			document.getElementById("list_MonthlyDay").selectedIndex = parseInt(szDay[0]) + 2;
    }
		else
		{
			szDay.length > 3 ? document.getElementById("list_MonthlyDay").selectedIndex = 0 : document.getElementById("list_MonthlyDay").selectedIndex = 1;
		}
	}
}

function SetYearly( xmlYearlly )
{
	document.getElementById("mpYealy").checked = true;
	showMainPattern(3);
	if(getNodeText(SelectNodes(xmlYearlly,"recurrence/selType")[0])  == 0)
	{
		document.getElementById("optY1").checked = true;		
		document.getElementById("list_YearlyDays").value = getNodeText(SelectNodes(xmlYearlly,"recurrence/daysOfMonth")[0]);
		document.getElementById("list_Month").selectedIndex = parseInt(getNodeText(SelectNodes(xmlYearlly,"recurrence/monthsOfYear")[0])) - 1;
	}
	else
	{
		document.getElementById("optY2").checked = true;
		document.getElementById("list_Month2").selectedIndex = parseInt(getNodeText(SelectNodes(xmlYearlly,"recurrence/monthsOfYear")[0])) - 1;
		
		var	szWeek = getNodeText(SelectNodes(xmlYearlly,"recurrence/byPosition")[0]);
		
	    szWeek == "-1" ? document.getElementById("list_YearlyEach").selectedIndex = (document.getElementById("list_YearlyEach").options.length - 1) : (document.getElementById("list_YearlyEach").selectedIndex = parseInt(szWeek) - 1);
        var szDay = getNodeText(SelectNodes(xmlYearlly,"recurrence/daysOfWeek")[0]);
        
        szDay = szDay.split(","); 
         
		if( szDay.length == 1 || szDay[1] == "" )
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
    if(ReturnFunction != null)
        ReturnFunction(0);
    else {
        window.returnValue = 0;
        window.close();
    }
}

function event_btnCancel_onclick()
{
    if (ReturnFunction != null)
        ReturnFunction(-1);
    else {
        window.returnValue = -1;
        window.close();
    }
}

function putReturnData(szCommand, vData)
{
	g_RetVal[szCommand] = vData;
}

function CheckStartEndDateTime()
{
    var start = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
    var end = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();

	if( start >= end )
		return false;
	else
		return true;
}

function CheckStartDateTime()
{
    var start = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
    var end = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
				
	if( start >= end )
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
    var start = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val()
	
    var end = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val()
				
	if( start > end )
		return false;
	else
		return true;
}

function CheckBeforeSave()
{
    if (TB_Promise.style.display != "none") {
		if( document.getElementById("EndTimeSet").checked )
		{
			if( !CheckStartEndDate() )
			{
				alert("" + strLang100 + "");
				
				return false;
			}
		}
		if( document.getElementById("EndTimeSet").checked )	{		
			if( !CheckStartDateTime() )
			{
				alert("" + strLang101 + "");
			
				return false;
			}
		}
	}
	else
	{
		if( document.getElementById("EndTimeSet").checked )
		{
			if( !CheckStartEndDate() )
			{
				alert("" + strLang100 + "");
				
				return false;
			}
		}
	}
	
	return true;
}


/* 2017-03-06 이효민 : 안쓰는 함수
function RepCheck( xmlStr )
{
//	var start = idDatepickers.startFullYear() + "-"
//				+ TimeRevision((parseInt(idDatepickers.startMonth()) + 1)) + "-"
//				+ TimeRevision(idDatepickers.startDate());
	
//	var end  = idDatepickers.endFullYear() + "-"
//				+ TimeRevision((parseInt(idDatepickers.endMonth()) + 1)) + "-"
//				+ TimeRevision(idDatepickers.endDate());

	var start = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	var end = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
   
	if(start == end) {
		return false;
	}
	else
	{
		return true;
	}
	
	// 2017-03-06 이효민 : 필요없는 코드
//	var cmd = getMainPattern();
//	var from;
//	
//	var xmlHttp = createXMLHttpRequest();
//	var xmlDoc = createXmlDom();
//	
//	xmlDoc = xmlStr;
//	
//	AppendNode( xmlDoc, "frequency" );				
//	AppendNode( xmlDoc, "selType" );				
//	AppendNode( xmlDoc, "startDateTime" );			
//	AppendNode( xmlDoc, "endDateTime" );			
//	AppendNode( xmlDoc, "interval" );				
//	AppendNode( xmlDoc, "daysOfWeek" );				
//	AppendNode( xmlDoc, "daysOfMonth" );			
//	AppendNode( xmlDoc, "byPosition" );				
//	AppendNode( xmlDoc, "monthsOfYear" );			
//	AppendNode( xmlDoc, "endRecurType" );			
//	AppendNode( xmlDoc, "instances" );				
//	
//	if( TB_Promise.style.display != "none" )
//		from = "schedule";
//	else
//		from = "task";
//
//	xmlHttp.Open("POST","/ZHome/myoffice/controls/dlg_recurrence_proc.asp?from="+from+"&sDate="+start+"&eDate="+end+"&cmd="+cmd,false);
//	xmlHttp.Send(xmlDoc.xml);
//	
//	var result = loadXMLString(xmlHttp.responseText);
//	
//	if( trim(result.text) == "1" )
//		return true;
//	else
//		return false;
}*/

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
	str_temp = parm_str ;
		
	while (str_temp.length != 0)
	{
		int_last_blnk_pos = str_temp.lastIndexOf(" ");
			
		if((str_temp.length - 1) == int_last_blnk_pos)
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

function ReplaceText( orgStr, findStr, replaceStr )
{
	var re = new RegExp( findStr, "gi" );
	
	return ( orgStr.replace( re, replaceStr ) );
}

function NumCheck(ckNum)
{
    if(!/^[0-9]{1,}$/.test(ckNum))
	    return false;
}

function AppendNode( xmlDom, item )
{
	if( SelectSingleNodeNew(xmlDom,item) == null )
	{
		var objNode = xmlDom.createNode( 1, item, "" );
		objNode.text = "";
		xmlDom.childNodes(0).appendChild(objNode);
	}
}
var rtvString = "";
function event_btnOk_onclick()
{
	var xmlDoc = null;
	var Root = null;
	
	if( !CheckBeforeSave() )
		return;
		
    if(NumCheck(document.getElementById("txt_De").value) == false)
    {
        alert(g_Error);
        document.getElementById("txt_De").value = "1";
	    return;
    }
    
    if(NumCheck(document.getElementById("txt_We").value) == false)
    {
        alert(g_Error);
        document.getElementById("txt_We").value = "1";
	    return;
    }
    
    if(NumCheck(document.getElementById("list_MonthInterval").value) == false)
    {
        alert(g_Error);
        document.getElementById("list_MonthInterval").value = "1";
	    return;
    }
    
    if(NumCheck(document.getElementById("list_MonthlyDays").value) == false)
    {
        alert(g_Error);
        //document.getElementById("list_MonthlyDays").value = idDatepickers.startDate();
	    return;
    }
    
    if(NumCheck(document.getElementById("list_MonthInterval2").value) == false)
    {
        alert(g_Error);
        document.getElementById("list_MonthInterval2").value = "1";
	    return;
    }
    
    if(NumCheck(document.getElementById("list_YearlyDays").value) == false)
    {
        alert(g_Error);
        //document.getElementById("list_YearlyDays").value = idDatepickers.startDate();
	    return;
    }
    
    if(document.getElementById("Instances").checked == true && NumCheck(document.getElementById("list_ReCount").value) == false)
    {
        alert(g_Error);
        document.getElementById("list_ReCount").value = "10";
	    return;
    }

    try {
        xmlDoc = createXmlDom();

        createNodeInsert(xmlDoc, Root, "recurrence");

        var pAlldaycheck = "";
        if (document.getElementById("alldaycheck").checked == true) {
            pAlldaycheck = "1";
            rtvString = strLang126 + ", ";
            
            m_objStartTime = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
            m_objEndTime = new Date($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
            m_objEndTime.setHours(23);
            m_objEndTime.setMinutes(59);
        }
        else {
            pAlldaycheck = "0";
            rtvString = $('#Stimepicker').val() + " ~ " + $('#Etimepicker').val() + ", ";
            
            m_objStartTime = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
            m_objStartTime.setHours(Number($('#Stimepicker').val().split(":")[0]));
            m_objStartTime.setMinutes(Number($('#Stimepicker').val().split(":")[1]));
            
            m_objEndTime = new Date($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
            m_objEndTime.setHours(Number($('#Etimepicker').val().split(":")[0]));
            m_objEndTime.setMinutes(Number($('#Etimepicker').val().split(":")[1]));
        }

        putReturnData("alldaycheck", pAlldaycheck);
        putReturnData("startTime", m_objStartTime);
        putReturnData("endTime", m_objEndTime);
        
        Remainder(Root, xmlDoc);

        switch (getMainPattern()) {
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
        if (document.getElementById("alldaycheck").checked == true) {
            createNodeAndInsertText(xmlDoc, Root, "startDateTime", m_objStartTime.getFullYear() + "-" + setLength(m_objStartTime.getMonth() + 1) + "-" + setLength(m_objStartTime.getDate()) + " " + setLength(m_objStartTime.getHours()) + ":" + setLength(m_objStartTime.getMinutes()));
            if (document.getElementById("EndTimeSet").checked) {
                createNodeAndInsertText(xmlDoc, Root, "endDateTime", $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + setLength(m_objEndTime.getHours()) + ":" + setLength(m_objEndTime.getMinutes()));
            }
            else {
                createNodeAndInsertText(xmlDoc, Root, "endDateTime", m_objEndTime.getFullYear() + "-" + setLength(m_objEndTime.getMonth() + 1) + "-" + setLength(m_objEndTime.getDate()) + " " + setLength(m_objEndTime.getHours()) + ":" + setLength(m_objEndTime.getMinutes()));
            }
        }
        else {
            createNodeAndInsertText(xmlDoc, Root, "startDateTime", $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val());
            createNodeAndInsertText(xmlDoc, Root, "endDateTime", $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val());
        }

        putReturnData("xml", getXmlString(xmlDoc));
        putReturnData("str", rtvString);
        
        // 2017-03-06 이효민 : RepCheck함수 이상해서 주석
//        if (document.getElementById("EndTimeSet").checked) {
//            if (!RepCheck(getXmlString(xmlDoc))) {
//                alert(strLang111 + "\n" + "" + strLang112 + "");
//                return false;
//            }
//        }
        
    }
	catch(e)
	{
	}
	
	if (ReturnFunction != null)
	    ReturnFunction(g_RetVal);
    else {
        window.returnValue = g_RetVal;
        window.close();
    }

}

function setLength(num) {
    if (num < 10) {
        num = "0" + num;
    }
    return num;
}
	
function DailyDisposal( xmlDoc, nPattern )
{
	var tmpElem = null;
	var objNode ;
	try
	{
		createNodeAndInsertText(xmlDoc, objNode, "frequency",  g_Frequency["daily"]);
		daily = window.document.getElementsByName("optDaily");
		
		for( nCount = 0; nCount < daily.length; nCount++ )
		{
			if( daily[nCount].checked )
				break;
		}
		
		if( nCount == 0)
		{
			iNumber	= validateNumber(document.getElementById("txt_De").value );
			if( isNaN(iNumber) )
			{
				document.getElementById("txt_De").focus();
				alert( g_Error );	
				createNodeAndInsertText(xmlDoc, objNode, "interval","");		
				return 0;
			}
			else
			{
			    if( iNumber == "" || iNumber == 0 )
				{
					iNumber = 1;
			    }
			    rtvString = iNumber + strLang550 + " " + rtvString;
				createNodeAndInsertText(xmlDoc, objNode, "interval", iNumber);	
				createNodeAndInsertText(xmlDoc, objNode, "selType", 0);	
			}
		}
		else
		{
		    rtvString = strLang551 + " " + rtvString;
			createNodeAndInsertText(xmlDoc, objNode, "interval",1);		
			createNodeAndInsertText(xmlDoc, objNode, "selType",1);
			createNodeAndInsertText(xmlDoc, objNode, "daysOfWeek",g_Days["workdays"]);		
		}
	}
	catch(e)
	{
		window.returnValue = -1;
	}
}

function WeeklyDisposal( xmlDoc, nPattern )
{
	var days = null;
	var objNode ;
	var szDays = "";
	
	try
	{
		createNodeAndInsertText(xmlDoc, objNode, "frequency",  g_Frequency["weekly"]);
			
		iNumber	= validateNumber(document.getElementById("txt_We").value );
		if( isNaN(iNumber) )
		{
			document.getElementById("txt_We").focus();
			
			alert( g_Error );			
			
			return false;
		}
		else
		{	
		    createNodeAndInsertText(xmlDoc, objNode, "selType", 1);		
		    if( iNumber == "" || iNumber == 0 )
			{
				iNumber = 1;
		    }
		    
		    createNodeAndInsertText(xmlDoc, objNode, "interval", iNumber);		
			
			days = window.document.getElementsByName("day");
			
			var check = 0;
			
			for( nCount = 0; nCount < days.length; nCount++ )
			{
				if( !days[nCount].checked )
				{
					continue;
				}
					
				szDays += days[nCount].value + ",";

				check++;
			}
			
			if( check == 0 )
			{
				alert("" + strLang113 + "");
				
				return false;
			}
			var tmpDays = szDays.substring(0, szDays.length - 1);
			rtvString = iNumber + strLang552 + " " + tmpDays.replace("0", strLang270).replace("1", strLang271).replace("2", strLang272).replace("3", strLang273).replace("4", strLang274).replace("5", strLang275).replace("6", strLang276) + " " + rtvString;
			createNodeAndInsertText(xmlDoc, objNode, "daysOfWeek", szDays);		
			
		}
		
		return true;
	}
	catch(e)
	{
		this.returnValue = -1;
	}
}

function MonthlyDisposal( xmlDoc, nPattern )
{
	var tmpElem = null;
	var month;
	var objNode ;
	try
	{
		createNodeAndInsertText(xmlDoc, objNode, "frequency",  g_Frequency["monthly"]);
		month = window.document.getElementsByName("optMonthly");
		for( nCount = 0; nCount < month.length; nCount++ )
		{
			if( month[nCount].checked )
				break;
		}
		
		if( nCount == 0)
		{
			iNumber	= validateNumber( document.getElementById("list_MonthInterval").value );
			
			var	iDays =	validateNumber(document.getElementById("list_MonthlyDays").value);
			var	iMonth = validateNumber(document.getElementById("list_MonthInterval").value);
			
			if( isNaN(iDays) ||	iDays >	31 )
			{
				document.getElementById("list_MonthInterval").focus();
				alert( g_Error );			
				return 0;
			}
			
			createNodeAndInsertText(xmlDoc, objNode, "selType",  0);
			
			
			if( document.getElementById("list_MonthInterval").value == "" || document.getElementById("list_MonthInterval").value == 0 )
				document.getElementById("list_MonthInterval").value = 1;
			
			createNodeAndInsertText(xmlDoc, objNode, "interval",  document.getElementById("list_MonthInterval").value);	
			
			if( document.getElementById("list_MonthlyDays").value == "" || document.getElementById("list_MonthlyDays").value == 0 )
				document.getElementById("list_MonthlyDays").value = 1;
			createNodeAndInsertText(xmlDoc, objNode, "daysOfMonth", document.getElementById("list_MonthlyDays").value);

			rtvString = iMonth + strLang553 + " " + iDays + strLang270 + " " + rtvString;
		}
		else
		{
			createNodeAndInsertText(xmlDoc, objNode, "selType",  1);
			
			if( document.getElementById("list_MonthInterval2").value == "" || document.getElementById("list_MonthInterval2").value == 0 )
				document.getElementById("list_MonthInterval2").value = 1;
			createNodeAndInsertText(xmlDoc, objNode, "interval", document.getElementById("list_MonthInterval2").value);		
			createNodeAndInsertText(xmlDoc, objNode, "selType",  1);
			createNodeAndInsertText(xmlDoc, objNode, "byPosition", document.getElementById("list_MonthlyEach").value);

			rtvString = document.getElementById("list_MonthInterval2").value + strLang554 + " " + document.getElementById("list_MonthlyEach").value.replace("1", strLang554).replace("2", strLang555).replace("3", strLang556).replace("4", strLang557).replace("-1", strLang558) + " " + document.getElementById("list_MonthlyDay").value.replace("8", strLang559).replace("9", strLang560).replace("0", strLang561).replace("1", strLang562).replace("2", strLang563).replace("3", strLang564).replace("4", strLang565).replace("5", strLang566).replace("6", strLang567) + " " + strLang568 + " " + rtvString;

			if( list_MonthlyDay.value == 8 )
			{
			    createNodeAndInsertText(xmlDoc, objNode, "daysOfWeek",  g_Days["workdays"]);
			}
			else if( list_MonthlyDay.value == 9 )
			{
				 createNodeAndInsertText(xmlDoc, objNode, "daysOfWeek",  g_Days["weekend"]);
			}
			else
			{
				 createNodeAndInsertText(xmlDoc, objNode, "daysOfWeek",  document.getElementById("list_MonthlyDay").value);
			}
			
		}
	}
	catch(e)
	{
		this.returnValue = -1;
	}
}

function YearlyDisposal( xmlDoc, nPattern )
{
	var tmpElem = null;
	var year;
	var month;
	var objNode;
	try
	{
		createNodeAndInsertText(xmlDoc, objNode, "frequency",  g_Frequency["yearly"]);
        createNodeAndInsertText(xmlDoc, objNode, "interval",  1);
        
        year = window.document.getElementsByName("optYearly");
        
		for(nCount = 0; nCount < year.length; nCount++ )
		{
			if( year[nCount].checked )
				break;
		}
		
		if( nCount == 0)
		{
			iNumber	= validateNumber( document.getElementById("list_YearlyDays").value );
			if( isNaN(iNumber) || iNumber >	31 )
			{
				document.getElementById("list_YearlyDays").focus();
				alert( g_Error );			
				return 0;
			}
			createNodeAndInsertText(xmlDoc, objNode, "selType",  0);
			
			if( document.getElementById("list_Month").value == "" )
				document.getElementById("list_Month").value = 1;
				
			createNodeAndInsertText(xmlDoc, objNode, "monthsOfYear", document.getElementById("list_Month").value);	
			
			if( document.getElementById("list_YearlyDays").value == "" || document.getElementById("list_YearlyDays").value == 0 )
				document.getElementById("list_YearlyDays").value = 1;
			createNodeAndInsertText(xmlDoc, objNode, "daysOfMonth", document.getElementById("list_YearlyDays").value);

			rtvString = strLang98 + " " + iNumber + strLang271 + " " + document.getElementById("list_Month").value + strLang278 + " " + rtvString;
		}
		else
		{
		    createNodeAndInsertText(xmlDoc, objNode, "selType",  1);
		    createNodeAndInsertText(xmlDoc, objNode, "monthsOfYear",  document.getElementById("list_Month2").value);
		    createNodeAndInsertText(xmlDoc, objNode, "byPosition",  document.getElementById("list_YearlyEach").value);
		    
		    if( document.getElementById("list_YearlyDay").value == 8 )
			{
				createNodeAndInsertText(xmlDoc, objNode, "daysOfWeek", g_Days["workdays"]);
			}
			else if( document.getElementById("list_YearlyDay").value == 9 )
			{
				createNodeAndInsertText(xmlDoc, objNode, "daysOfWeek", g_Days["weekend"]);
			}
			else
			{
				createNodeAndInsertText(xmlDoc, objNode, "daysOfWeek", document.getElementById("list_YearlyDay").value);
			}
		    rtvString = strLang98 + " " + document.getElementById("list_Month2").value + strLang279 + "  " + document.getElementById("list_YearlyEach").value.replace("1", strLang554).replace("2", strLang555).replace("3", strLang556).replace("4", strLang557).replace("-1", strLang558) + " " + document.getElementById("list_YearlyDay").value.replace("8", strLang559).replace("9", strLang560).replace("0", strLang561).replace("1", strLang562).replace("2", strLang563).replace("3", strLang564).replace("4", strLang565).replace("5", strLang566).replace("6", strLang567) + +rtvString;
		}
		
	}
	catch(e)
	{
		this.returnValue = -1;
	}
}	


var	m_iSavedNumber;
function saveNumber(elem)
{
	m_iSavedNumber = event.srcElement.value;
}


function validateNumber(inNum)
{
	var	iEntry = Number(inNum);
	if(isNaN(iEntry))
	{
		var	iCh,chCode,szNewNumber=""; 
		for	(var x=0; x<inNum.length; x++)
		{

			iCh	= inNum.charCodeAt(x);
			chCode = Number(iCh.toString(10));
			if (chCode > 0xFF) 
			{
				chCode = (iCh &	0x001f)	| 0x20;
			}
			szNewNumber	+= String.fromCharCode(chCode);
		}
		iEntry = Number(szNewNumber);
	}
	return (iEntry)
}

function getMainPattern()
{
	ePattern = window.document.getElementsByName("optMainPattern");
	for	(var x=0;x<4;x++)
	{
		if (ePattern[x].checked) break;
	}
	return(x);
}

function showMainPattern(idx)
{
	eAllPatterns = window.document.getElementsByName("divRecurPatterns");
	for(var	x=0;x<eAllPatterns.length;x++)
	{
		eAllPatterns[x].style.display="none";
	}
	window.document.getElementsByName("divRecurPatterns")[idx].style.display = "";
}

function IsLeapYear(yr)
{
	return (((yr % 4 == 0) && (yr % 100 != 0)) || (yr % 400 == 0))?1:0;
}

function daysInMonth(iMonth, iYear)
{
	return( (2 == iMonth) ? (28+issLeapYear(iYear)):(30+((iMonth+(iMonth>7))%2)));
}
function checkYear(YF)
{
	var	year = parseInt(YF)

	if (!isNaN(year))
	{
		if ((1970 <= year) && (year	<= 2038))
		{		
			return year;
		}
		else if	((70 <=	year) && (year <= 99))
		{		
			return year	+ 1900;
		}
		else if	((0	<= year) &&	(year <= 38))
		{
			return year	+ 2000;	
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

//2017-03-06 이효민 사원 : 필요없는 코드
//function onDateChanged(iWhich)
//{
//	if (0==iWhich)
//	{
//		var iMs1 = m_objStartOnDate.getTime();
//		m_objStartOnDate.setFullYear( idDatepickers.startFullYear(),idDatepickers.startMonth(),idDatepickers.startDate() );
//		var msDiff = m_objStartOnDate.getTime()-iMs1;
//		m_objStartTime.setTime(m_objStartTime.getTime()+msDiff);
//		m_objEndTime.setTime(m_objEndTime.getTime()+msDiff);
//	}
//	else
//	{
//		m_objEndByDate.setFullYear(idDatepickers.endFullYear(),idDatepickers.endMonth(),idDatepickers.endDate() );
//	}
//}

//var	m_iMsDuration;
//function onTimeChanged(iWhich) {
//	switch (iWhich)
//	{
//		case 0:	
//			
//			m_objStartTime.setHours(idDatepickers.startHours(),idDatepickers.startMinutes(),0,0);
//			
//			if (m_objEndTime.getTime() > m_objStartTime.getTime()) {
//
//                m_iMsDuration = m_objEndTime.getTime() - m_objStartTime.getTime();
//
//            }
//            else {
//                m_iMsDuration = m_objStartTime.getTime() - m_objEndTime.getTime();
//            }
//
//            if (m_iMsDuration < CONST_MS_IN_24HRS) {
//
//                idDatepickers.setEndtimePicker24hours(true);
//
//            }
//			
//			break;
//
//
//        case 1: 
//
//            m_objEndTime.setHours(idDatepickers.endHours());
//
//            if (m_objEndTime.getTime() > m_objStartTime.getTime()) {
//
//                m_iMsDuration = m_objEndTime.getTime() - m_objStartTime.getTime();
//
//            }
//            else {
//                m_iMsDuration = m_objStartTime.getTime() - m_objEndTime.getTime();
//            }
//
//            if (m_iMsDuration < CONST_MS_IN_24HRS) {
//
//                idDatepickers.setEndtimePicker24hours(true);
//
//            }
//
//            break;
//	}
//}

function Remainder( Root, xmlDoc )
{
	tmpElem = null;
	
	try
	{
	    rtvString += strLang580 + $('#Sdatepicker').val() + " ~ ";
		if( document.getElementById("Instances").checked )	
		{
		    rtvString += document.getElementById("list_ReCount").value + strLang582;
			createNodeAndInsertText(xmlDoc, Root, "endRecurType", 1);
		    createNodeAndInsertText(xmlDoc, Root, "instances",document.getElementById("list_ReCount").value);
		}
		else if( document.getElementById("EndTimeSet").checked )	
		{
		    rtvString += $('#Edatepicker').val()
			createNodeAndInsertText(xmlDoc, Root, "endRecurType", 2);
			
		    // 2017-03-06 이효민 사원 : 필요없는 코드
//			szEndDate = (parseInt(idDatepickers.endMonth()) + 1) + "/"
//									+ idDatepickers.endDate() + "/"
//									+ idDatepickers.endFullYear() + " " 
//									+ TimeRevision(idDatepickers.endHours()) + ":"
//									+ TimeRevision(idDatepickers.endMinutes());
//	         createNodeAndInsertText(xmlDoc, Root, "patternEndDate",szEndDate);
		}
		else
		{
		    createNodeAndInsertText(xmlDoc, Root, "endRecurType", 0);
		    rtvString += strLang581;
		}
	}
	catch(e)
	{
	
	}
}

function SetRemainder( xmlRe )
{   
	szType = getNodeText(SelectNodes(xmlRe,"recurrence/endRecurType")[0]);
	
	if( szType == "1" )
	{
		document.getElementById("Instances").checked = true;	
		document.getElementById("list_ReCount").value = getNodeText(SelectNodes(xmlRe,"recurrence/instances")[0]);
	}
	else if( szType == "2" )
	{
		document.getElementById("EndTimeSet").checked = true;
		
		if(typeof(m_dlgArgs["recurrence"]) != "undefined")
		{
			var tmpDate = getNodeText(SelectNodes(xmlRe,"recurrence/endDateTime")[0]);
			
			var eDate = new Date(tmpDate);
			var SeteTime = eDate.getFullYear() + "-" + (eDate.getMonth() + 1) + "-" + eDate.getDate();
			$("#Edatepicker").datepicker('setDate', SeteTime);
		}
	}
}

function IsoUTFDate( szDate )
{
	var szTime, iSoDate;
		
	if( szDate.indexOf( " " ) != -1 )
	{
		szTime = szDate.split( " " )[2].split( ":" );
		
		if( ( szDate.search( /strLang116/i ) != -1 || szDate.search( /PM/i ) != -1 ) && parseInt( szTime[0], 10 )  < 12 ) 
		{
			szTime = ( szTime[0] = parseInt( szTime[0], 10 ) + 12 ) + ":" + szTime[1] + ":" + szTime[2];
		}
		else if( szDate.search( /strLang117/ ) != -1 || szDate.search( /AM/i ) != -1 )
		{		
			if( szTime[0].length <= 1 )
			{
				szTime = "0" + szTime[0] + ":" + szTime[1] + ":" + szTime[2];
			}
			else if( parseInt( szTime[0], 10 ) == 12 )
			{
				szTime = "00" + ":" + szTime[1] + ":" + szTime[2];
			}
		}
		
		iSoDate = szDate.split( " " )[0] + "T" + szTime + ".000Z";		
	}
	else
	{
		iSoDate = szDate + "T00:00:00.000Z";						
	}
	
	return iSoDate;
}

function TimeRevision(szTime)
{
	if( parseInt(szTime) == 0 )
	{
		szTime = "00";
	}
	else if( parseInt(szTime) > 0 && parseInt(szTime) < 10)
	{
		szTime = "0"+szTime;
	}
	
	return szTime
}



function getLocalDateObjFromGMTTime(szDtTime) {

    var szDay = szDtTime.substring(8, 10);
    var szMonth = Number(szDtTime.substring(5, 7)) - 1;
    var szYear = szDtTime.substring(0, 4);
    var szHr = szDtTime.substring(11, 13);
    var szMin = szDtTime.substring(14, 16);
    var szSec = szDtTime.substring(17, 19);

    var objD = new Date();
    objD.setUTCFullYear(szYear, szMonth, szDay);
    objD.setUTCHours(szHr, szMin);

    return (objD);
}
