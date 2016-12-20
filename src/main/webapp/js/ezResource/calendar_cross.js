var	g_szCurrentApptNum = null;
var g_szCurrentApptPNum;
var	g_szCurrentApptOwnerID;
var g_szCurrentApptWriterID;
var g_szCurrentApptInsType;
var g_szCurrentApptGFlag;
var g_szCurrentApptSDate;
var g_szCurrentApptEDate;

var g_szCurrentApptcompanyID;		// 회사아디
var g_szCurrentApptGroupID;			// 그룹아디


var g_ExCalendarID = null;
var g_szXmlError = "" + strLang86 + "";


//* 기능설명      : 달력이 온체인지 될때 실행되는 것
function idCalendarControl_OnDateChange(event) {
    return (navigator.userAgent.indexOf('MSIE') == -1) ?
    (function(event) {
        // safari
        if (!event) event = window.event;

	//alert("이승엽 OnDateChange");
	// 수정(08.04.28) : 가끔 event.view 가 NaN 으로 들어와 오류를 발생시킴
        if (isNaN(event.view)) {
            return;
        }
        idCalendarViewer.update(event.date, event.xml, event.view);

        g_szCurrentApptNum = null;

        ToggleView(event.view)

        var NodeList = event.xml.evaluate("root/appointment", event.xml, null, XPathResult.ANY_TYPE, null);
        var j = 0;
        var iterNodeList = null;
        while (iterNodeList = NodeList.iterateNext()) {
            var alldayflag = iterNodeList.getElementsByTagName('alldayevent')[0].firstChild.nodeValue; 	//alldayevent 의 노드를 가지고 오기위한것

            if (alldayflag == "1") {
                j = j + 1;
            }
        }
        /*
        for (var i = 0; i < NodeList.length; i++) {
            var alldayflag = NodeList(i).childNodes.item(9).text; 	//alldayevent 의 노드를 가지고 오기위한것

            if (alldayflag == "1") {
                j = j + 1;
            }
        }
        */
    }).call(this, event) :
    (function() {
        // IE
        if (!event) event = window.event;

        //alert("이승엽 OnDateChange");
        // 수정(08.04.28) : 가끔 event.view 가 NaN 으로 들어와 오류를 발생시킴
        if (isNaN(event.view)) {
	    return;
    }   
	idCalendarViewer.update(event.date, event.xml, event.view);
	
	g_szCurrentApptNum=null;
	
	ToggleView(event.view)
	
    var NodeList = event.xml.selectNodes("root/appointment");
    
    var j = 0;

        for (var i = 0; i < NodeList.length; i++) {
		var alldayflag = NodeList(i).childNodes.item(9).text;		//alldayevent 의 노드를 가지고 오기위한것

            if (alldayflag == "1") {
			j = j + 1;
		}
	}
    }).call(this);
}


//* 기능설명      : (개인/구룹/전체) 구분인자를 넘겨준 xml로
function idCalendarViewer_OnSelectAppointment(event)
{
    if (!event) event = window.event;

	// (개인/구룹/전체) 구분인자를 넘겨준 xml로
	g_szCurrentApptNum = event.num;					// 자원예약번호
	g_szCurrentApptPNum = event.pnum;				// 부모번호
	// 조건문 (T/G/P)	
	g_szCurrentApptcompanyID = event.companyID;		// 회사아디
	g_szCurrentApptGroupID = event.GroupID;			// 그룹아디
	g_szCurrentApptOwnerID = event.owner_id;
	g_szCurrentApptWriterID = event.writer_id;
	g_szCurrentApptInsType = event.instancetype;
	g_szCurrentApptGFlag = event.groupflag;
	g_szCurrentApptSDate = event.startDate;
	g_szCurrentApptEDate = event.endDate;
}

GetISODateObj.re=/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):\d{2}\.\d{3}Z?$/;

function GetISODateObj(szISODate)
{
	GetISODateObj.re.lastIndex=0;
	
	var	arr	= GetISODateObj.re.exec( szISODate );
	
	if (null ==	arr)
	{
		return(null);
	}
	
	var	objD = new Date( Number(arr[1])	, Number(arr[2])-1 , Number(arr[3])	);	
	
	objD.setUTCHours( Number(arr[4]) , Number(arr[5]),0	);
	
	return(objD);
}

var	m_objXMLhttp_search;

event_onRSC_searchMasterStart.szURL;
event_onRSC_searchMasterStart.szType;

function event_onRSC_searchMasterStart()
{
	if(4 ==	m_objXMLhttp_search.readyState)
	{
		if(207!== m_objXMLhttp_search.status)	
		{
			return;
		}
		
		if (null != m_objXMLhttp_search.responseXML.SelectSingleNodeNew("a:multistatus/a:response"))
		{
			var dtstart = m_objXMLhttp_search.responseXML.SelectSingleNodeNew("a:multistatus/a:response/a:propstat/a:prop/dtstart").text;	
			var oDate = GetISODateObj(dtstart);
			
			var feature = GetOpenPosition(560, 540);
			window.open(event_onRSC_searchMasterStart.szURL + "?Cmd=open&Type=" + event_onRSC_searchMasterStart.szType + "&tzoffset=" + oDate.getTimezoneOffset(), String(Math.round(Math.random((new Date).getMilliseconds()) * 100000)), "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=560,height=540" + feature);
		}
		else
		{
			alert(L_errItemNotFound);
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
// 리소스 관리에서 사용하는 곳...

//* 기능설명      : main 화면에서 더블클릭했을때 창뛰우기 : 메인에서 넘겨준부분
function idCalendarViewer_OnDoubleClickAppointment(event) {

    if (!event) event = window.event;

	//개인 그룹에서 값을 가지고
	if (event.command == 'open'){
		var	szNum = event.num;
		var	szPNum = event.pnum;
		var	szOwnerID = event.owner_id;
		var	szWriterID = event.writer_id;
		var	szGroupFlag = event.groupflag;
		var	szStart = new Date(event.startDate);
		var	szEnd = new Date(event.endDate);
		var	szInstancetype = event.instancetype;

		var szType, startDate, endDate, filename;
		
		szType = "Master";
		startDate = szStart.getFullYear() + "-" + (parseInt(szStart.getMonth())+1) + "-" + szStart.getDate();
		endDate = szEnd.getFullYear() + "-" + (parseInt(szEnd.getMonth())+1) + "-" + szEnd.getDate();
		
		if( parseInt(szGroupFlag) == 2 || parseInt(szGroupFlag) == 4 ){
			//메인화면에서 더블클릭하면 분기활
			filename = "Schedule_UnReg.asp";

		}else{
		    filename = "scheduleRead.do";

			// 반복자원예약에 대한 처리
			if( parseInt(szInstancetype) == 1 || parseInt(szInstancetype) == 3)
			{
				// 수정(2007.03.28) : 반복예약 기능 - 일정관리와 스펙을 동일하게 가기 위해 선택 팝업창을 띄우지 않음
				/*var	rgParams = new Array();
				
				rgParams["CancelOpen"] = false;
				rgParams["InstanceType"] = "";
				
				var	hWin = window.showModalDialog("Schedule_Repetition_Open.html", rgParams, "dialogHeight:235px;dialogWidth:390px;status:no;help:no;center:yes;");
				
				// 취소했는지 ... CHK
				if(false !=	rgParams["CancelOpen"]){	return(false);	}
				
				szType = rgParams["InstanceType"];*/
				
				if( parseInt(szInstancetype) == 3 )
				{
					szNum = szPNum;
					szOwnerID = szWriterID;
				}
			}
		}
		
		windowName = "";
		
		// 2011-04 : 자원관리 중복 등록 관련 작업 진행
	    //화면창 더블클릭했을때 오픈창(개인/그룹을 뛰운다)
		if (CrossYN()) {
		    var feature = GetOpenPosition(820, 700);
		    window.open(filename + "?cmd=mod&from=schedule&" + "num=" + szNum + "&ownerID=" + szOwnerID + "&type=" + szType + "&startDate=" + startDate + "&endDate=" + endDate + "&brdName=" + brd_NM, "", "width=820, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		}
		else {
		    var feature = GetOpenPosition(770, 700);
		    window.open(filename + "?cmd=mod&from=schedule&" + "num=" + szNum + "&ownerID=" + szOwnerID + "&type=" + szType + "&startDate=" + startDate + "&endDate=" + endDate + "&brdName=" + brd_NM, "", "width=770, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		}
	}
}

var	m_xmlHTTP;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function checkGroupWrite() 
{
	return g_szCurrentApptGroupID;
}

function DeleteGroupSchedule(companyID, groupID) {

	if( !confirm( "" + strLang90 + "" ) )
	{
		return;
	}


	var xmlHttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	
	var objNode;		
	createNodeInsert(xmlpara, objNode, "PARAMETER"); 
	
	createNodeAndInsertText(xmlpara, objNode, "NUM", g_szCurrentApptNum);
	createNodeAndInsertText(xmlpara, objNode, "WRITERID", g_szCurrentApptWriterID);
	createNodeAndInsertText(xmlpara, objNode, "PNUM", g_szCurrentApptPNum);
	createNodeAndInsertText(xmlpara, objNode, "OWNERID", g_szCurrentApptOwnerID);
	createNodeAndInsertText(xmlpara, objNode, "INSTYPE", g_szCurrentApptInsType);
	createNodeAndInsertText(xmlpara, objNode, "GFLAG", g_szCurrentApptGFlag);
	createNodeAndInsertText(xmlpara, objNode, "STARTDATE", g_szCurrentApptSDate);
	createNodeAndInsertText(xmlpara, objNode, "ENDDATE", g_szCurrentApptEDate);
	
	if(g_szCurrentApptGroupID != "")
	    createNodeAndInsertText(xmlpara, objNode, "GROUPID", g_szCurrentApptGroupID);
	else
	    createNodeAndInsertText(xmlpara, objNode, "GROUPID", groupID);
	    
	createNodeAndInsertText(xmlpara, objNode, "COMPANYID", companyID);
	
	
	
//	var objRoot = xmlDoc.createNode(1, "PARAMETER", "");
//	xmlDoc.appendChild(objRoot);
//	
//	var objNode;
//	
//	objNode = xmlDoc.createNode(1, "NUM", "");
//	objNode.text = g_szCurrentApptNum;
//	objRoot.appendChild(objNode);
//	
//	objNode = xmlDoc.createNode(1, "WRITERID", "");
//	objNode.text = g_szCurrentApptWriterID;
//	objRoot.appendChild(objNode);
//	
//	objNode = xmlDoc.createNode(1, "PNUM", "");
//	objNode.text = g_szCurrentApptPNum;
//	objRoot.appendChild(objNode);
//	
//	objNode = xmlDoc.createNode(1, "OWNERID", "");
//	objNode.text = g_szCurrentApptOwnerID;
//	objRoot.appendChild(objNode);
//	
//	objNode = xmlDoc.createNode(1, "INSTYPE", "");
//	objNode.text = g_szCurrentApptInsType;
//	objRoot.appendChild(objNode);
//	
//	objNode = xmlDoc.createNode(1, "GFLAG", "");
//	objNode.text = g_szCurrentApptGFlag;
//	objRoot.appendChild(objNode);
//	
//	objNode = xmlDoc.createNode(1, "STARTDATE", "");
//	objNode.text = g_szCurrentApptSDate;
//	objRoot.appendChild(objNode);
//	
//	objNode = xmlDoc.createNode(1, "ENDDATE", "");
//	objNode.text = g_szCurrentApptEDate;
//	objRoot.appendChild(objNode);
//	
//	objNode = xmlDoc.createNode(1, "GROUPID", "");
//	objNode.text = g_szCurrentApptGroupID;
//	if(objNode.text == "") {
//		objNode.text = groupID;
//	}
//	objRoot.appendChild(objNode);
//	
//	
//	objNode = xmlDoc.createNode(1, "COMPANYID", "");	
//	objNode.text = companyID;
//	objRoot.appendChild(objNode);
	
	xmlHttp.open("POST", "Schedule_Group_Add_Ok.aspx?cmd=del", false);

	xmlHttp.send(xmlpara);
	
	var res = xmlHttp.responseText;

	if( res == "OK" )
	{
		
	}
	else if( res == "NOWRITE" )
	{
		alert("" + strLang91 + "");
	}
	else
	{
		alert("" + strLang92 + "");
	}

}

function GetShowModalPosition(popUpW, popUpH) {
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

    var feature = ";dialogLeft:" + left + "px;dialogTop:" + top + "px;";

    return feature
}

var schedule_repetition_del_cross_dialogArguments = new Array();
function DeleteAppointment()
{
    var isRepetition = false;
	if( g_szCurrentApptNum == null ){
		alert( "" + strLang93 + "" );
		return;
	}
	
	if(pAdminFg != "Y" && g_szCurrentApptWriterID != pUserID)
	{
		alert("" + strLang94 + "");
		return;
	}
	
	if( !confirm( "" + strLang90 + "" ) )		return;
	
	if(null	!= g_szCurrentApptNum && 0 != g_szCurrentApptNum.length){
	    if (parseInt(g_szCurrentApptInsType) == 1 || parseInt(g_szCurrentApptInsType) == 3) {
	        isRepetition = true;
			var	rgParams = new Array();
			
			rgParams["CancelOpen"] = false;
			rgParams["InstanceType"] = "";
			
			schedule_repetition_del_cross_dialogArguments[0] = rgParams;
			schedule_repetition_del_cross_dialogArguments[1] = DeleteAppointment_Complete;

			DivPopUpShow(390, 260, "/ezResource/scheduleRepetitionDel.do");
		}
		
	    if (!isRepetition) {
	        var szStart = new Date(g_szCurrentApptSDate);
	        var szEnd = new Date(g_szCurrentApptEDate);

	        var xmlHttp = createXMLHttpRequest();
	        var xmlpara = createXmlDom();

	        var objNode;
	        createNodeInsert(xmlpara, objNode, "PARAMETER");

	        createNodeAndInsertText(xmlpara, objNode, "NUM", g_szCurrentApptNum);
	        createNodeAndInsertText(xmlpara, objNode, "OWNERID", g_szCurrentApptOwnerID);
	        createNodeAndInsertText(xmlpara, objNode, "PNUM", g_szCurrentApptPNum);
	        createNodeAndInsertText(xmlpara, objNode, "WRITERID", g_szCurrentApptWriterID);
	        createNodeAndInsertText(xmlpara, objNode, "INSTYPE", g_szCurrentApptInsType);
	        createNodeAndInsertText(xmlpara, objNode, "GFLAG", g_szCurrentApptGFlag);

	        g_szCurrentApptSDate = szStart.getFullYear() + "-" + (parseInt(szStart.getMonth()) + 1) + "-" + szStart.getDate();
	        g_szCurrentApptEDate = szEnd.getFullYear() + "-" + (parseInt(szEnd.getMonth()) + 1) + "-" + szEnd.getDate();

	        createNodeAndInsertText(xmlpara, objNode, "STARTDATE", g_szCurrentApptSDate);
	        createNodeAndInsertText(xmlpara, objNode, "ENDDATE", g_szCurrentApptEDate);

	        xmlHttp.open("POST", "/ezResource/scheduleAddOk.do?cmd=del", false);
	        xmlHttp.send(xmlpara);

	        var res = xmlHttp.responseText;

	        //prompt("", res);
	        if (res == "OK") {
	            delFlag = true;
	            RefreshMessageList();
	        } else {
	            alert("" + strLang92 + "");
	        }
	    }
	}
}
function DeleteAppointment_Complete(retVal) {
    if (false != retVal["CancelOpen"]) {
        DivPopUpHidden();
        return (false);
    }

    var szType = retVal["InstanceType"];

    if (parseInt(g_szCurrentApptInsType) == 1) {
        if (szType == "Instance") {
            g_szCurrentApptPNum = g_szCurrentApptNum;
            g_szCurrentApptWriterID = g_szCurrentApptOwnerID;
            g_szCurrentApptNum = "0";
            g_szCurrentApptInsType = "3";
        }
    }
    else if (parseInt(g_szCurrentApptInsType) == 3) {
        if (szType == "Master") {
            g_szCurrentApptNum = g_szCurrentApptPNum;
            g_szCurrentApptOwnerID = g_szCurrentApptWriterID;
            g_szCurrentApptInsType = "1";
        }
    }

    var szStart = new Date(g_szCurrentApptSDate);
    var szEnd = new Date(g_szCurrentApptEDate);

    var xmlHttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");

    createNodeAndInsertText(xmlpara, objNode, "NUM", g_szCurrentApptNum);
    createNodeAndInsertText(xmlpara, objNode, "OWNERID", g_szCurrentApptOwnerID);
    createNodeAndInsertText(xmlpara, objNode, "PNUM", g_szCurrentApptPNum);
    createNodeAndInsertText(xmlpara, objNode, "WRITERID", g_szCurrentApptWriterID);
    createNodeAndInsertText(xmlpara, objNode, "INSTYPE", g_szCurrentApptInsType);
    createNodeAndInsertText(xmlpara, objNode, "GFLAG", g_szCurrentApptGFlag);

    g_szCurrentApptSDate = szStart.getFullYear() + "-" + (parseInt(szStart.getMonth()) + 1) + "-" + szStart.getDate();
    g_szCurrentApptEDate = szEnd.getFullYear() + "-" + (parseInt(szEnd.getMonth()) + 1) + "-" + szEnd.getDate();

    createNodeAndInsertText(xmlpara, objNode, "STARTDATE", g_szCurrentApptSDate);
    createNodeAndInsertText(xmlpara, objNode, "ENDDATE", g_szCurrentApptEDate);

    xmlHttp.open("POST", "/ezResource/scheduleAddOk.do?cmd=del", false);
    xmlHttp.send(xmlpara);

    var res = xmlHttp.responseText;

    //prompt("", res);
    if (res == "OK") {
        delFlag = true;
        RefreshMessageList();
    } else {
        alert("" + strLang92 + "");
    }
    DivPopUpHidden();
}

function onrscGetDeclineRequest()
{
	if(m_xmlHTTP.readystate	== 4)
	{
		m_xmlHTTP.onreadystatechange = event_nop;
		if(m_xmlHTTP.status	< 300)
		{
			var	nErrno = m_xmlHTTP.responseXML.SelectSingleNodeNew("result/errorcode")
			if (null !=	nErrno && 0	!= nErrno.text)
			{
				if (null !=	m_xmlHTTP.responseXML.SelectSingleNodeNew("result/errortext"))
				{
					alert(m_xmlHTTP.responseXML.SelectSingleNodeValueNew("result/errortext"));
				}
				else
				{
					alert(nErrno.text+"	"+L_idsUnknownError_Text);
				}	
			}
			else
			{
				RefreshMessageList();
				if (null !=	m_xmlHTTP.responseXML.SelectSingleNodeNew("result/redirecturl"))
				{
					// 삭제시 답장 보내지 않음 대화상자 
					szUrl = m_xmlHTTP.responseXML.SelectSingleNodeValueNew("result/redirecturl");
				}
			}	
		}
		else
		{
			alert("Error " + m_xmlHTTP.status +	": " + m_xmlHTTP.statusText);		 
		}
	}
}

function event_onreadystatechange_SendCancellation()
{
	if(m_xmlHTTP.readystate	== 4)
	{
		m_xmlHTTP.onreadystatechange = event_nop;
		
		if(m_xmlHTTP.status	== 200)
		{
				RefreshMessageList();
		}
	}
}

function event_nop()
{
	return;
}

//NOTE:	do not rename RefreshMessageList()
//Generic callback function	used in	the	composenotes by	MSGCTRL.HTC	to
//tell the current viewer to refresh on	delete/move/save etc

function RefreshMessageList()
{
	CalendarView('Calendar');
}


// veritas@kaoni.com 2000.10.10 
function ToggleView(cmdView)
{
	szCmd = "";
	
	switch(cmdView)
	{
		case 0:
			szCmd = "DAY";
		break;
		
		case 1:
// 주보기		
			szCmd = "WEEK";
		break;
		
		case 2:
			szCmd = "MONTH";
		break;
	}
	
	onViewDate(szCmd);
}


function onViewDate(szCmd) {
    switch (szCmd.toUpperCase()) {
        case "DAY":
            typeCal = 2;
            if (document.getElementById(g_selTDID))
                document.getElementById(g_selTDID).style.backgroundColor = "#ECF3BA";
            if (document.getElementById(g_selTRID))
                document.getElementById(g_selTRID).style.backgroundColor = "";
            if (g_selTDID != null && g_selTDID != "")
                sDate = new Date(g_selTDID.substring(7, 11), parseInt(g_selTDID.substring(12, 14)) - 1, parseInt(g_selTDID.substring(15, 17)));

            var ItemID = "TDMINI_" + sDate.getFullYear() + "-" + leadingZeros(sDate.getMonth() + 1, 2) + "-" + leadingZeros(sDate.getDate(), 2) + "_Day";

            var item = document.getElementById(ItemID);
            if (item)
                item.onclick();
            else
                CalendarView("Calendar");

            break;
            // 주보기		
        case "WEEK":
            typeCal = 1;
            if (document.getElementById(g_selTDID))
                document.getElementById(g_selTDID).style.backgroundColor = "";
            if (document.getElementById(g_selTRID))
                document.getElementById(g_selTRID).style.backgroundColor = "#ECF3BA";
            if (g_selTDID != null && g_selTDID != "")
                sDate = new Date(g_selTDID.substring(7, 11), parseInt(g_selTDID.substring(12, 14)) - 1, parseInt(g_selTDID.substring(15, 17)));

            var ItemID = "TDMINI_" + sDate.getFullYear() + "-" + leadingZeros(sDate.getMonth() + 1, 2) + "-" + leadingZeros(sDate.getDate(), 2) + "_Day";

            var item = document.getElementById(ItemID);
            if (item)
                item.onclick();
            else
                CalendarView("Calendar");

            break;

        case "MONTH":
            typeCal = 0;
            if (document.getElementById(g_selTDID))
                document.getElementById(g_selTDID).style.backgroundColor = "";
            if (document.getElementById(g_selTRID))
                document.getElementById(g_selTRID).style.backgroundColor = "";

            CalendarView("Calendar");
            break;
    }
    Window_resize();
}

function CallApptDlg(szUrl, szCmd, szType )
{
	var tmpNode = null;
	var newWin = null;
	var szError = "";
	
	try
	{
		var xmlHttp = createXMLHttpRequest();
	    var xmlpara = createXmlDom();
	    var xmlResult = createXmlDom();
	    
	    var objNode;		
	    createNodeInsert(xmlpara, objNode, "msg"); 
    	
    	if(szCmd == "open")
	        createNodeAndInsertText(xmlpara, objNode, "cmd", "open");
	    else
		    createNodeAndInsertText(xmlpara, objNode, "cmd", "");
		    
		createNodeAndInsertText(xmlpara, objNode, "url", szUrl);
		createNodeAndInsertText(xmlpara, objNode, "instancetype", szType);
	
		    
//		var Msg = xmlDoc.createElement("msg");
//		xmlDoc.appendChild(Msg);
//		
//		Msg.appendChild( tmpNode = xmlDoc.createElement("cmd") );
//		
//		if(szCmd == "open")
//			tmpNode.text = "open";
//		
//		Msg.appendChild( tmpNode = xmlDoc.createElement("url") );
//		tmpNode.text = szUrl;
//		
//		Msg.appendChild( tmpNode = xmlDoc.createElement( "instancetype" ) );
//		tmpNode.text = szType; 
				
		xmlHttp.open("POST", "/EmailApp/ezSchedule/rcvSch.asp", false);
		xmlHttp.send(xmlpara);
		
		xmlResult = xmlHttp.responseXML;
		if( typeof( xmlResult ) != "undefined" || xmlResult )
		{
			szError = g_szXmlError;
			throw e;
		}
		
		if( parseInt( xmlDoc.getElementsByTagName("errstatus")[0].childNodes[0].nodeValue ) != 200 )
		{
			throw e;
		}
	}
	catch(e)
	{
	
	}
}

function getAttendees( szUrl )
{
	var length, count;
	var xmlHttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var xmlResult = createXmlDom();	

	try 
	{
	    var objNode;		
	    createNodeInsert(xmlpara, objNode, "msg"); 
    	
	    createNodeAndInsertText(xmlpara, objNode, "cmd", "get_attendees");
	    createNodeAndInsertText(xmlpara, objNode, "url", szUrl);    
	    
	    	
//		xmlDoc.documentElement = xnMsg = xmlDoc.createElement( "msg" );

//		xnMsg.appendChild( xnCmd = xmlDoc.createElement( "cmd" ) );
//		xnCmd.text = "get_attendees";

//		xnMsg.appendChild( xnUrl = xmlDoc.createElement( "url" ) );
//		xnUrl.text = szUrl;

		xmlHttp.open( "POST", "transmission.asp", false );
		xmlHttp.setRequestHeader( "Content-Type:", "text/xml" );
		xmlHttp.send( xmlpara );
		
		xmlResult = xmlHttp.responseXML;
		//var xnAttendees = selectSingleNode(xmlResult, "attendees" );
		
		xncAddress = SelectSingleNodeNew(xmlResult, "attendees/address");//xnAttendees.getElementsByTagName( "address" );
		xncDisplayName = SelectSingleNodeNew(xmlResult, "attendees/displayName");// xnAttendees.getElementsByTagName( "displayName" );
		
		length = xncAddress.length;
		
		for ( count = 0; count < length; count++ )
		{		
			xnDisplayName = xncDisplayName.item( count );
			xnAddress = xncAddress.item( count );
			szAddress = xnAddress.text;
		
			if( xnDisplayName.text == "" ) xnAttendees.removeChild( xnAddress.parentNode );
						
			xnAddress.text = szAddress.substr( 7, szAddress.length );
		}
		
		return xnAttendees;
	} 
	catch ( e )
	{
		return null;
	}	
}

function deleteNSendCanceled( szUrl, xnAttendees )
{
	var count, length;
	var xmlHttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var retValue;
	
	try 
	{
	    var objNode;		
	    createNodeInsert(xmlpara, objNode, "msg"); 
    	
	    createNodeAndInsertText(xmlpara, objNode, "cmd", "cancel_appt");
	    createNodeAndInsertText(xmlpara, objNode, "url", szUrl);  
	    createNodeAndInsertText(xmlpara, objNode, xnAttendees, "");
	    createNodeAndInsertText(xmlpara, objNode, xmlDoc.createElement( "attendeesToSend" ), "");    
	    
	    
//		xmlDoc.documentElement = xnMsg = xmlDoc.createElement( "msg" );
//	
//		xnMsg.appendChild( xnCmd = xmlDoc.createElement( "cmd" ) );
//		xnCmd.text = "cancel_appt";
//	
//		xnMsg.appendChild( xnUrl = xmlDoc.createElement( "url" ) );
//		xnUrl.text = szUrl;
	
//		xnMsg.appendChild( xnAttendees );
//		xnMsg.appendChild( xnAttendeesToSend = xmlDoc.createElement( "attendeesToSend" ) );

		xmlHttp.open( "POST", "transmission.asp", false );
		xmlHttp.setRequestHeader( "Content-Type:", "text/xml" );
		xmlHttp.send( xmlpara );
		
		retValue = true;
	}
	catch ( e )
	{
		retValue = false;
	}
	
	return retValue;
}

