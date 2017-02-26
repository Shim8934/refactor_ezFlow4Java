// 자원사용 중복체크 (true:중복체크, false:중복체크안함)
var bDupCheck = true;

// 자원예약시간 제한, 설정한 날짜 이내에만 예약가능
var ReservationInterval = 365;

// 자원사용범위 제한
var UseInterval = 15;

var g_data = new Array();
var g_printTrueFalse = false;
var attachbody = null;
var attachSave = false;
var g_documentTitle = "";

function removeEntryList()
{
	var length = ScheToGot.childNodes.length;
	
	for( var i = 0 ; i < length ; i++ )
	{
		ScheToGot.childNodes(0).removeNode(true);
	}
}

function DisplayEntryList()
{
	var entries = document.getElementById("xmpEntryEmailList").innerHTML;
	
	removeEntryList();
	
	if( entries != "" )
	{
		var entryStr = entries.split(">");
		
		for( var i = 0 ; i < entryStr.length-1 ; i++ )
		{
			var tmpEntry = entryStr[i].split("<");
			var entryName = tmpEntry[0];
			var entryID = tmpEntry[1];
			var entryEmail = GetUserEMailAddr(entryID);
			
			entryName = entryName.replace(/\"/g, "");
			
			var titleStr = entryName + "<" + entryEmail + ">";
			
			var newElem = document.createElement( "FONT" );
			
			newElem.innerHTML = "<u title=\"" + titleStr + "\">" + entryName + "<span style=\"display:none\">" + entryID + "</span></u>; ";
			newElem.style.cursor = "hand";
			newElem.onclick = EntryDel_onClick;
			
			ScheToGot.appendChild(newElem);
		}
	}
}

function GetUserEMailAddr( pUserID )
{
	var EmailAddr;
	
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var xmlRtn = createXmlDom();
	
	var objRoot = xmlpara.createNode(1,"PERSONINFO","");
	xmlpara.appendChild(objRoot);
	
	var objNode = xmlpara.createNode(1, "pUserID", "");
	objNode.text = pUserID;
	xmlpara.documentElement.appendChild(objNode);
	
	xmlhttp.open("POST","/ezflow/admin/GetPersonInfo.asp",false);
	xmlhttp.send(xmlpara);
	
	xmlRtn.loadXML(xmlhttp.responseXML.xml);
	
	var objNode = xmlRtn.documentElement.childNodes;	
    
	EmailAddr = objNode.item(5).text;
	
	return EmailAddr;
}

// 리소스 사용
function Entry_onKeydown()
{
	var entries = entry.value;
	
	if( entries != "" )	{
		var entryArr = entries.split(";");
	
		for( var i = 0 ; i < entryArr.length ; i++ ){
			var reParams = GetUserID( entryArr[i] );
			
			if( typeof(reParams) == "string" ){
				alert(entryArr[i] + "" + strLang118 + "");
			}else{
				if( reParams["s_proc"] == "select" ){
					var count = reParams["s_UserName"].length;
					
					for( var j = 0 ; j < count ; j++ ){
						var L_UserName = reParams["s_UserName"][j];
						var L_UserID = reParams["s_UserID"][j];
						var L_EMail = reParams["S_EMailAddr"][j];
						
						document.getElementById("xmpEntryEmailList").innerHTML = document.getElementById("xmpEntryEmailList").innerHTML + "\"" + L_UserName + "\"" + "<" + L_UserID + ">";
						
						DisplayEntryList();
					}
				}
			}
		}
	
		entry.value = "";
	}
}

function EntryDel_onClick() 
{
	var insertStr = "";
	var params = new Array();
	
	var selStr = this.childNodes(0).attributes("title").nodeValue;
	var selIDStr = this.childNodes(0).childNodes(1).innerText;
	var selArr = selStr.split("<");
	
	params["Kind"] = "View";
	params["UserName"] = selArr[0];
	params["UserID"] = selIDStr;
	params["UserListXml"] = selArr[1].substring(0, selArr[1].length-1);
	
	var feature =  "dialogHeight:410px; dialogWidth:425px; status:no;scroll:no; help:no;edge:sunken";
	feature =  feature + GetShowModalPosition(425, 410 );
	window.showModalDialog( "../NameCheck.asp", params, feature);
	
	if( params["s_proc"] == "delete" )
	{
		ScheToGot.removeChild(this);
		
		for( var i = 0 ; i < ScheToGot.childNodes.length ; i ++ )
		{
			var title = ScheToGot.childNodes(i).childNodes(0).attributes("title").nodeValue;
			var userid = ScheToGot.childNodes(i).childNodes(0).childNodes(1).innerText;
			
			var titleArr = title.split("<");
			
			insertStr += "\"";
			insertStr += titleArr[0];
			insertStr += "\"<";
			insertStr += userid;
			insertStr += ">";
		}
		
		document.getElementById("xmpEntryEmailList").innerHTML = insertStr;
	}
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

//******************************************************************
//* Function 명   : Schedule_Repetition_onclick()
//* 작성자명      : 박형기                                                                
//* 작성일자      : 2002년 5월 10일                                                       
//* 기능설명      : 반복설정
//* 매개변수      : 
//*               : 
//* 수정일자      : 2002년 5월 12일                                                       
//* 수정내용      : 

// 일정반복 버튼 처리.... 
// 이승엽 : 리소스
//******************************************************************	
var xmlDoc;
var schedule_repetition_cross_dialogArguments = new Array();
function Schedule_Repetition_onclick()
{
	var resultXML;
		
	var xmlHttp = createXMLHttpRequest();
	xmlDoc = createXmlDom();
	var objNode ; 
	
	createNodeInsert(xmlDoc, objNode, "PARAMETER");	
	createNodeAndInsertText(xmlDoc, objNode, "NUM", org_num);
    createNodeAndInsertText(xmlDoc, objNode, "OWNERID", org_ownerID);
    
	if (endDateTimeRepeat !="" ) {
		var startYearNum = Number(startDateTimeRepeat.substring(0, 4));
		var startMonthNum = Number(startDateTimeRepeat.substring(5, 7))-1;
		var startDayNum = Number(startDateTimeRepeat.substring(8, 10));
		var startHourNum = Number(startDateTimeRepeat.substring(11, 13));
		var startMiniteNum = Number(startDateTimeRepeat.substring(14, 16));
		
		var endYearNum = Number(endDateTimeRepeat.substring(0, 4));
		var endMonthNum = Number(endDateTimeRepeat.substring(5, 7))-1;
		var endDayNum = Number(endDateTimeRepeat.substring(8, 10));
		var endHourNum = Number(endDateTimeRepeat.substring(11, 13));
		var endMiniteNum = Number(endDateTimeRepeat.substring(14, 16));
			
		var startDateRepeat = new Date(startYearNum, startMonthNum, startDayNum, startHourNum, startMiniteNum);
		var endDateRepeat = new Date(endYearNum, endMonthNum, endDayNum, endHourNum, endMiniteNum);
	
		g_data["startTime"] = startDateRepeat;
		g_data["endTime"] = endDateRepeat;
	} else {
	    if (repetitionFlag) {
	    	if(reStartDate == null)
	            g_data["startTime"] = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
	        else
	            g_data["startTime"] = reStartDate;
	        if(reEndDate == null)
	            g_data["endTime"] = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
	        else
	            g_data["endTime"] = reEndDate;
	    } else {
	        g_data["startTime"] = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();		// 시작시간
	        g_data["endTime"] = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();	// 종료시간
	    }
	}
	
	g_data["ftDay"] = "";
	 
	var pAlldaycheck = "";
	if (document.getElementById("AllDay").checked == true) {
		pAlldaycheck = "1";
	} else {
		pAlldaycheck = "0";
	}
			
	g_data["alldaycheck"] = pAlldaycheck;
	
	schedule_repetition_cross_dialogArguments[0] = g_data;
	schedule_repetition_cross_dialogArguments[1] = Schedule_Repetition_onclick_Complete;

	DivPopUpShow(450, 550, "/ezResource/scheduleRepetition.do");
}

function Schedule_Repetition_onclick_Complete(retVal) {

    if (typeof (retVal) == "undefined" || (typeof (retVal) == "number" && retVal == -1)) {
        DivPopUpHidden();
        return;
    }

    
    if (typeof (retVal) == "number" && retVal == 0) {
        repetitionFlag = false;
        if (g_data["recurrence"] != "") {
            g_data["recurrence"] = "";

            g_data["recur_del"] = getXmlString(xmlDoc);

            document.getElementById("tr_STime").style.display = "";
               
            document.getElementById("tr_Recur").style.display = "none";

            document.getElementById("iReFlag").value = "0";
            document.getElementById("tmpReFlag").value = "3";
        }
    }
    else {
        repetitionFlag = true;
        if (reFlagVal == "1") {
            document.getElementById("tmpReFlag").value = "2";
        }
        else {
            document.getElementById("iReFlag").value = "1";
            document.getElementById("tmpReFlag").value = "1";
        }

        g_data["recurrence"] = retVal["xml"];
        
        
        var ptDate = new Date(retVal["ptEndDate"]);
        var SetsTime = ptDate.getFullYear() + "-" + (ptDate.getMonth() + 1) + "-" + ptDate.getDate();
        g_data["ptEndDate"] = SetsTime;

        var sDate = new Date(retVal["startTime"]);
        var SetsTime = sDate.getFullYear() + "-" + (sDate.getMonth() + 1) + "-" + sDate.getDate();

        var eDate = new Date(retVal["endTime"]);
        var SeteTime = eDate.getFullYear() + "-" + (eDate.getMonth() + 1) + "-" + eDate.getDate();
        
        $("#Sdatepicker").datepicker('setDate', SetsTime);
        $("#Edatepicker").datepicker('setDate', SeteTime);

        document.getElementById("tr_STime").style.display = "none";
        
        document.getElementById("tr_Recur").style.display = "";

        if (retVal["alldaycheck"] == "1")
            document.getElementById("AllDay").checked = true;
        else
            document.getElementById("AllDay").checked = false;

        show_repetition_info()
    }
    DivPopUpHidden();
}


var repetitionFlag = false;
var reStartDate;
var reEndDate;

function show_repetition_info() {
	var repeatinfo = "" + strLang122 + "";
	
	xmlinDoc = createXmlDom();
	xmlinDoc.async = false;
	xmlinDoc = loadXMLString(g_data["recurrence"]);
	
	szType = getNodeText(SelectNodes(xmlinDoc,"recurrence/frequency")[0]);
	
	switch (szType) {
		case "4":
			repeatinfo += "" + strLang123 + "";
			break;
		case "5":
			repeatinfo += "" + strLang124 + "";
			break;
		case "6":
			repeatinfo += "" + strLang97 + "";
			break;
		case "7":
			repeatinfo += "" + strLang98 + "";
			break;
	}
	
	repeatinfo += ", " + strLang125 + "";
	
	if (document.getElementById("AllDay").checked == true) {
	    repeatinfo += "" + strLang126 + "";
	} else {
	    var sdate, edate, tempstr;
	    sdate = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
	    edate = new Date($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());

	    tempSstr = sdate.toLocaleTimeString().split(" ")[1];
	    tempEstr = edate.toLocaleTimeString().split(" ")[1];

	    
	    reStartDate = getNodeText(SelectNodes(xmlinDoc, "recurrence/startDateTime")[0]);
	    reEndDate = getNodeText(SelectNodes(xmlinDoc, "recurrence/endDateTime")[0]);  

	    var reStartHour = reStartDate.split(" ")[1].split(":")[0];
	    var reEndHour = reEndDate.split(" ")[1].split(":")[0];

	    var reStartMinute = reStartDate.split(" ")[1].split(":")[1];
	    var reEndMinute = reEndDate.split(" ")[1].split(":")[1];

	    if (Number(reStartHour) < 12) {
	        repeatinfo += "" + strLang246 + " ";

	        if (Number(reStartHour) == 0)
	            reStartHour = 12;
	    }
	    else {
	        repeatinfo += "" + strLang247 + " ";

	        if (Number(reStartHour) > 12)
	            reStartHour = Number(reStartHour) - 12;
	    }

	    repeatinfo += reStartHour + ":" + reStartMinute + "" + " ~ " + "";

	    if (Number(reEndHour) < 12) {
	        repeatinfo += "" + strLang246 + " ";

	        if (Number(reEndHour) == 0)
	            reEndHour = 12;
	    }
	    else {
	        repeatinfo += "" + strLang247 + " ";

	        if (Number(reEndHour) > 12)
	            reEndHour = Number(reEndHour) - 12;
	    }

	    repeatinfo += reEndHour + ":" + reEndMinute;
	}
	
	repeatinfo += ", " + strLang580 + getNodeText(xmlinDoc.getElementsByTagName("startDateTime")[0]).split(' ')[0] + " ~ ";

	if (getNodeText(xmlinDoc.getElementsByTagName("endRecurType")[0]) == "0") {
	    repeatinfo += strLang581;
	} else if (getNodeText(xmlinDoc.getElementsByTagName("endRecurType")[0]) == "1") {
	    repeatinfo += getNodeText(xmlinDoc.getElementsByTagName("instances")[0]) + strLang582;
	} else if (getNodeText(xmlinDoc.getElementsByTagName("endRecurType")[0]) == "2") {
	    repeatinfo += getNodeText(xmlinDoc.getElementsByTagName("endDateTime")[0]).split(' ')[0];
	}
	
	document.getElementById("AllDayDisplay").innerHTML = repeatinfo;
}


//******************************************************************
//* Function 명   : SaveRepetition( org_num, org_ownerID )
//* 작성자명      : 박형기                                                                
//* 작성일자      : 2002년 5월 10일                                                       
//* 기능설명      : 반복설정저장
//* 매개변수      : org_num, org_ownerID
//*               : 
//* 수정일자      : 2002년 5월 12일                                                       
//* 수정내용      : 
//******************************************************************
function SaveRepetition( org_num, org_ownerID )
{
	var xmlHttp = createXMLHttpRequest();

	if( reFlagVal == "1" && tmpReFlag.value == "3" )
	{
		xmlHttp.open("POST","/ezResource/scheduleRepetitionProc.do?cmd=del",false);
		xmlHttp.send( g_data["recur_del"] );
		
		var res = xmlHttp.responseText;
		
		if( trim(res) == "NO" )
		{
			alert("" + strLang128 + "");
					
			return;
		}
	}
	else if( reFlagVal == "1" && document.getElementById("tmpReFlag").value == "2")
	{
		xmlHttp.open("POST","/ezResource/scheduleRepetitionProc.do?cmd=mod&num="+org_num+"&ownerID="+org_ownerID,false);
		xmlHttp.send( g_data["recurrence"] );
	
		var res = xmlHttp.responseText;
		
		if( trim(res) == "NO" )
		{			
			return;
		}
	}
	else if( (reFlagVal == "0" || reFlagVal == "") && document.getElementById("tmpReFlag").value == "1" )
	{
		xmlHttp.open("POST","/ezResource/scheduleRepetitionProc.do?cmd=add&num="+org_num+"&ownerID="+org_ownerID,false);
		xmlHttp.send( g_data["recurrence"] );

		var res = xmlHttp.responseText;
		
		if( trim(res) == "NO" )
		{
			alert("" + strLang129 + "");
			return;
		}                                                                                                  
	}
	else if( reFlagVal == "2" && document.getElementById("tmpReFlag").value == "1")		// 기념일 수정하기
	{
		xmlHttp.open("POST","/ezResource/scheduleRepetitionProc.do?cmd=add&num="+org_num+"&ownerID="+org_ownerID,false);
		xmlHttp.send( g_data["recurrence"] );
	
		var res = xmlHttp.responseText;
		
		if( trim(res) == "NO" )
		{			
			return;
		}
	}
}

function invite_onclick() {
	if (invite.style.display == "none") {
		invite.style.display = "block";
		inviteView.style.display = "block";
		menuTable1.style.display = "none";
		menuTable2.style.display = "block";
		
		if( gresFlag.value == "0" || gresFlag.value == "" ) {
			gresFlag.value = "1";
		}
	} else {
		invite.style.display = "none";
		inviteView.style.display = "none";
		menuTable1.style.display = "block";
		menuTable2.style.display = "none";
		
		if( gresFlag.value > "0" || gresFlag.value == "" ) {
			gresFlag.value = "0";
		}
	}
}

function Schedule_Entry_onclick() {

    var g_param = new Array();

    g_param["startTime"] = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
    g_param["endTime"] = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
    g_param["entryList"] = document.getElementById("xmpEntryEmailList").innerHTML;

    var feature = "dialogHeight:450px; dialogWidth:740px; status:no; help:no;edge:sunken";
    feature = feature + GetShowModalPosition(740, 450);
    var reParam = window.showModalDialog("/ezResource/scheduleAddUser.do?cmd=" + cmd + "&num=" + org_num + "&ownerID=" + org_ownerID, g_param, feature);

    if (typeof (reParam) != "undefined" && reParam != null) {
        $("#Sdatepicker").datepicker('setDate', reParam["startTime"]);
        $("#Edatepicker").datepicker('setDate', reParam["endTime"]);

        if (reParam["entryList"] != "") {
            document.getElementById("xmpEntryEmailList").innerHTML = reParam["entryList"];

            DisplayEntryList();
        }
    }
}

function GetUserID( userName ) {
	var returnVal = "";
	
	var xmlhttp = createXMLHttpRequest();
	var xmlpara = createXmlDom();
	var xmlRtn = createXmlDom();
	
	var objRoot = xmlpara.createNode(1,"LISTVIEWDATA","");
	xmlpara.appendChild(objRoot);
			
	var objNode = xmlpara.createNode(1, "NODE", "");
	objNode.text = userName;
	xmlpara.documentElement.appendChild(objNode);
			
	var objNode = xmlpara.createNode(1, "NODE", "");
	xmlpara.documentElement.appendChild(objNode);
			
	var objNode = xmlpara.createNode(1, "NODE", "");
	xmlpara.documentElement.appendChild(objNode);
			
	var objNode = xmlpara.createNode(1, "NODE", "");
	xmlpara.documentElement.appendChild(objNode);
			
	var objNode = xmlpara.createNode(1, "NODE", "");
	xmlpara.documentElement.appendChild(objNode);
			
	/*var objRoot = xmlpara.createNode(1,"LISTVIEWDATA","");
	xmlpara.appendChild(objRoot);
	
	var objNode = xmlpara.createNode(1, "NODE", "");
	objNode.text = userName;
	xmlpara.documentElement.appendChild(objNode);*/
	
	xmlhttp.open("POST","/ezflow/admin/GetUserListVInfo.asp",false);
	xmlhttp.send(xmlpara);
	
	xmlRtn.loadXML(xmlhttp.responseXML.xml);
	
	var Clength = xmlRtn.documentElement.childNodes(1).childNodes.length;
	var params = new Array();
	
	if(Clength == 1) {
		params = new Array();
		
		params["s_proc"] = "select";
		
		params["s_UserName"] = new Array();
		params["s_UserID"] = new Array();
		params["S_EMailAddr"] = new Array();
		
		params["s_UserName"][0] = xmlRtn.selectSingleNode("LISTVIEWDATA/ROWS/ROW/CELL/VALUE").text;
		params["s_UserID"][0] = xmlRtn.selectSingleNode("LISTVIEWDATA/ROWS/ROW/CELL/DATA2").text;
		params["S_EMailAddr"][0] = xmlRtn.selectSingleNode("LISTVIEWDATA/ROWS/ROW/CELL/DATA7").text;
		
		returnVal = params;
	}
	else if(Clength > 1) {
		params["Kind"] = "Duplicate";
		params["UserName"] = userName;
		params["UserListXml"] = xmlRtn.xml;
		
		var feature =  "dialogHeight:410px; dialogWidth:425px; status:no;scroll:no; help:no;edge:sunken";
	    feature =  feature + GetShowModalPosition(425 , 410);
		window.showModalDialog( "../NameCheck.asp", params, feature);
		
		returnVal = params;
	}
	
	return returnVal;
}

function alertCheck_onClink() {
	if( alertCheck.checked == true ) {
		alertTime.disabled = false;
	} else {
		alertTime.disabled = true;
	}
}

function AllDay_onClick() {
	 
	if( document.getElementById("AllDay").checked == true ) {
		document.getElementById("SD_Font").style.display = "none";
		document.getElementById("ED_Font").style.display = "none";
		document.getElementById("_T1").style.display = "none";
		document.getElementById("img_StartTime").style.display = "none";
	} else {
		document.getElementById("SD_Font").style.display = "block";
		document.getElementById("ED_Font").style.display = "block";
		document.getElementById("_T2").style.display = "block";
		document.getElementById("img_EndTime").style.display = "block";
	}
}

function replaceSingleQuotation( reStr ) {
	reStr = reStr.replace(/'/g, "''");
	
	return reStr;
}

// 리소스
// 저장 때... CheckStartEndDateTime에서 호출
function CheckTimeRevision(szTime){
	if( parseInt(szTime) == 0 )	{
		szTime = "00";
	} else if( parseInt(szTime) > 0 && parseInt(szTime) < 10){
		szTime = "0"+szTime;
	}
	
	return szTime
}

// 리소스
// 저장버튼 누를때..사용됨...
// 시작일시와 종료일시 Chk
function CheckStartEndDateTime() {
    var start = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
    var end = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
	
	if( start >= end ) {
		return false;
	} else {
		return true;
	}
}

// 하루종일 체크시 시작시간 종료시간 체크
function AllDayCheckStartEndDateTime() {
    var start = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + "00:00";
    var end = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + "00:00";
	
	if( start > end ) {
		return false;
	} else {
		return true;
	}
}

// 리소스에서 사용
// 저장버튼 누르면 호출됨
function SessionCheck(){
	if( trim(s_userID) == "" )	{
		alert('" + strLang131 + "');
		window.opener.parent.document.location.href = "/login.asp";
		window.close();
	}
}

//******************************************************************
//* Function 명   : SaveSchedule_onClick( cmd )
//* 작성자명      : 박형기                                                                
//* 작성일자      : 2002년 5월 10일                                                       
//* 기능설명      : 개인일정 저장하는 것
//* 매개변수      : cmd
//*               : 
//* 수정일자      : 2002년 5월 12일                                                       
//* 수정내용      : 

// 리소스에서 사용 : 이승엽
//******************************************************************
// 2011-04 : 자원관리 중복 등록 관련 작업 진행
function SaveSchedule_onClick( cmd , resItem) {
	if (ApproveFlag == "1" && SavedApproveFlag == "1" && pAdminFg != "Y" && cmd == "mod") {
		alert("" + strLang132 + "");
		return;
	}

	// 22071213 - 없는 스펙으로 삭제
	// 현재일과 예약시작일과의 차이를 계산  
//	if (CheckInterval() > ReservationInterval)
//	{
//		alert("" + strLang133 + "" + ReservationInterval + "" + strLang134 + "");
//		return;
//	}
	
	// 자원사용시작일과 종료일의 차이를 계산
//	if (CheckUseInterval() > UseInterval)
//	{
//		alert("" + strLang135 + "" + UseInterval + "" + strLang136 + "" + UseInterval + "" + strLang137 + "");
//		return;
//	}
	// 이거때문에 다 팅긴다 그래서 주석.
	SessionCheck();
	
	if(trim_Cross(document.getElementById("title").value) == "" ) {
		alert("" + strLang138 + "");
		return;
	}
	
	// 일반/하루종일
	if(!document.getElementById("AllDay").checked) {
		if( !CheckStartEndDateTime() ) {
			alert("" + strLang139 + "");			
			return;
		}
	} else {
		if (!AllDayCheckStartEndDateTime()) {
			alert("" + strLang139 + "");			
			return;
		}
	}
	
	// 자신의 일정인지 체크
	if ( cmd == "mod" ) {
		// 관리자가 아닌 경우
		if (CheckAdmin() == false && OwnerCheck() == false) {
			alert("" + strLang140 + "");
			return;
		}
	}
	
	//Entry_onKeydown();
	attachSave = true;
	
	var xmlHttp = createXMLHttpRequest();
	var xmlDoc = createXmlDom();
	var resultXML = createXmlDom();
	
	var objNode ;
	
	createNodeInsert(xmlDoc, objNode, "PARAMETER");	
	createNodeAndInsertText(xmlDoc, objNode, "TITLE", document.getElementById("title").value);
    createNodeAndInsertText(xmlDoc, objNode, "LOC", ""); // 2011-04 : 자원 항목 등록시 자원 사용하지 않음.
    createNodeAndInsertText(xmlDoc, objNode, "T_DISPLAY", document.getElementById("timeDisplay").value);
   
    var objNode4,objNode5,objNode6;
	//하루종일이면 시간을 디폴트로 저장하고 그렇지 안으면 설정하여 저장
	if (document.getElementById("AllDay").checked == true) {
	    objNode4 = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";
	    objNode5 = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23:59:00";
		objNode6 = "1";
	} else {
	    objNode4 = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
	    objNode5 = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
		objNode6 = "0";
		
	}
	
	createNodeAndInsertText(xmlDoc, objNode, "STARTDATETIME", objNode4);
    createNodeAndInsertText(xmlDoc, objNode, "ENDDATETIME", objNode5);
    createNodeAndInsertText(xmlDoc, objNode, "ALLDAY", objNode6);
	
	var objNode7;
	if (alertCheck.checked == true) {
		objNode7 =  "30";	// 항상 30분 전 알림
	} else {
		objNode7 = "";
	}
	createNodeAndInsertText(xmlDoc, objNode, "ALERT", objNode7);
	var content = "";
	content = message.GetEditorContent();
	
	createNodeAndInsertText(xmlDoc, objNode, "CONTENT", content);
	
    var objNode9; 
    if (writerID.value == "") {
		objNode9 = s_userID;	// 현재 사용자ID
	} else {
		objNode9 = document.getElementById("writerID").value;
	}
    createNodeAndInsertText(xmlDoc, objNode, "WRITERID", objNode9);
	
	createNodeAndInsertText(xmlDoc, objNode, "IMPORTANCE1", document.getElementById("importance1").value);
	createNodeAndInsertText(xmlDoc, objNode, "ENTRY", "");
	createNodeAndInsertText(xmlDoc, objNode, "REFLAG", document.getElementById("iReFlag").value);
	createNodeAndInsertText(xmlDoc, objNode, "GRESFLAG", document.getElementById("gresFlag").value);
	createNodeAndInsertText(xmlDoc, objNode, "NUM", document.getElementById("num").value);
	createNodeAndInsertText(xmlDoc, objNode, "PNUM", document.getElementById("pnum").value);
	createNodeAndInsertText(xmlDoc, objNode, "OWNERID", resItem); // 2011-04 : 자원관리 중복 등록 관련 작업 진행	
	createNodeAndInsertText(xmlDoc, objNode, "ATTACHFILES", ""); //AttachFileList()
	createNodeAndInsertText(xmlDoc, objNode, "companyID", ss_companyID); // 현재 회사ID
	createNodeAndInsertText(xmlDoc, objNode, "characterID", replaceSingleQuotation( document.getElementById("characterID").value )); //characterID 특성
	createNodeAndInsertText(xmlDoc, objNode, "typeVal", typeVal); // 수정(2007.03.28) : 반복예약 기능
	createNodeAndInsertText(xmlDoc, objNode, "deptNM", replaceSingleQuotation(ss_deptNM ));//부서명
	createNodeAndInsertText(xmlDoc, objNode, "ownerNM", replaceSingleQuotation( ss_ownerNM ));//작성자명
	
	// 승인이 필요한 자원은 신규등록시 0(비승인)으로 저장
	// 수정시엔 DB에 저장되어 있는 값으로 저장
	
	var objNode23;
	if (ApproveFlag == "1") {
		if (cmd == "add") {
			objNode23 = "0";
		} else {
			// 수정(2007.03.28) : 반복예약 기능
			if( reFlagVal == "1" && document.getElementById("iReFlag").value == "0" ) {
				objNode23 = "0";
			} else {
				objNode23 = SavedApproveFlag;
			}
		}
	} else {
		objNode23 = "1";
	}
	createNodeAndInsertText(xmlDoc, objNode, "APPROVE", objNode23); //승인여부
	
	// 위에 노드 22까지 값을 받아 처리부분으로 넘겨준다.
	xmlHttp.open("POST","/ezResource/scheduleAddOk.do?cmd="+cmd+"&type="+typeVal,false);
	xmlHttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
	xmlHttp.send(getXmlString(xmlDoc));
	
	var returnStr, p_num, p_ownerID;
	
	resultXML = xmlHttp.responseXML;
	
	if( typeof(resultXML) != "undefined" && getXmlString(resultXML) != "" )
	{
	    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	    // 2009.11.26 - 자원등록시 자원관리자에게 자원등록 알림메일 발송
	    xmlHttp = null;
	    if(cmd == "add" && objNode23 == "0")
	    {
	        xmlHttp = createXMLHttpRequest();
			xmlHttp.open("POST", "/ezResource/sendMail.do", false);
			xmlHttp.send(xmlDoc);				        
			xmlHttp = null;

			//var objNodes = SelectNodes(resultXML, "RTN_DATA")[0];
			//p_num = getNodeText(GetChildNodes(objNodes)[0]);
			//p_ownerID = getNodeText(GetChildNodes(objNodes)[1]);


			//xmlHttp = createXMLHttpRequest();
			//xmlHttp.open("POST", "/myoffice/ezResource/ResSch/Sendmail.aspx?num=" + p_num + "&ownerID=" + p_ownerID, false);
			//xmlHttp.send(xmlDoc);
			//var ResponseXML = xmlHttp.responseXML;
			//xmlHttp = createXMLHttpRequest();
			//xmlHttp.open("POST", "/myoffice/ezEmail/remote/mail_send_noti.aspx", false);
			//xmlHttp.send(ResponseXML);
			//xmlHttp = null;
	    }
	    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	
		if( document.getElementById("tmpReFlag").value != "0" )
		{
		    var objNodes = SelectNodes(resultXML,"RTN_DATA")[0];
		    p_num = getNodeText(GetChildNodes(objNodes)[0]);//objNodes.item(0).text;
		    p_ownerID = getNodeText(GetChildNodes(objNodes)[1]);// objNodes.item(1).text;
    		
		    // 2011-04 : 자원관리 중복 등록 관련 작업 진행
		    SaveRepetition( p_num, resItem );
		}
		
		if (!setApprovFlag) {
		    window_onUnload();
		    window.close();
		}
	}else{
		alert("" + strLang145 + "");
	}
	
	
}
function OnlySaveSchedule(resItem) {
    if (ApproveFlag == "1" && SavedApproveFlag == "1" && pAdminFg != "Y" && cmd == "mod") {
        alert("" + strLang132 + "");
        return;
    }

    if (trim_Cross(document.getElementById("title").value) == "") {
        alert("" + strLang138 + "");
        return;
    }

    if (!document.getElementById("AllDay").checked) {
        if (!CheckStartEndDateTime()) {
            alert("" + strLang139 + "");
            return;
        }
    }
    else {
        if (!AllDayCheckStartEndDateTime()) {
            alert("" + strLang139 + "");
            return;
        }
    }

    attachSave = true;

    var xmlHttp = createXMLHttpRequest();
    var xmlDoc = createXmlDom();
    var resultXML = createXmlDom();

    var objNode;

    createNodeInsert(xmlDoc, objNode, "PARAMETER");
    createNodeAndInsertText(xmlDoc, objNode, "TITLE", document.getElementById("title").value);
    createNodeAndInsertText(xmlDoc, objNode, "LOC", "");
    createNodeAndInsertText(xmlDoc, objNode, "T_DISPLAY", document.getElementById("timeDisplay").value);

    var objNode4, objNode5, objNode6;
    if (document.getElementById("AllDay").checked == true) {
        objNode4 = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";
        objNode5 = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23:59:00";
        objNode6 = "1";
    } else {
        objNode4 = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
        objNode5 = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
        objNode6 = "0";
    }

    createNodeAndInsertText(xmlDoc, objNode, "STARTDATETIME", objNode4);
    createNodeAndInsertText(xmlDoc, objNode, "ENDDATETIME", objNode5);
    createNodeAndInsertText(xmlDoc, objNode, "ALLDAY", objNode6);

    var objNode7;
    if (alertCheck.checked == true) {
        objNode7 = "30";
    } else {
        objNode7 = "";
    }
    createNodeAndInsertText(xmlDoc, objNode, "ALERT", objNode7);
    var content = "";
    content = message.GetEditorContent();

    createNodeAndInsertText(xmlDoc, objNode, "CONTENT", content);

    var objNode9;
    if (writerID.value == "") {
        objNode9 = s_userID;
    } else {
        objNode9 = document.getElementById("writerID").value;
    }
    createNodeAndInsertText(xmlDoc, objNode, "WRITERID", objNode9);
    createNodeAndInsertText(xmlDoc, objNode, "IMPORTANCE1", document.getElementById("importance1").value);
    createNodeAndInsertText(xmlDoc, objNode, "ENTRY", "");
    createNodeAndInsertText(xmlDoc, objNode, "REFLAG", document.getElementById("iReFlag").value);
    createNodeAndInsertText(xmlDoc, objNode, "GRESFLAG", document.getElementById("gresFlag").value);
    createNodeAndInsertText(xmlDoc, objNode, "NUM", document.getElementById("num").value);
    createNodeAndInsertText(xmlDoc, objNode, "PNUM", document.getElementById("pnum").value);
    createNodeAndInsertText(xmlDoc, objNode, "OWNERID", resItem);
    createNodeAndInsertText(xmlDoc, objNode, "ATTACHFILES", "");
    createNodeAndInsertText(xmlDoc, objNode, "companyID", ss_companyID);
    createNodeAndInsertText(xmlDoc, objNode, "characterID", replaceSingleQuotation(document.getElementById("characterID").value));
    createNodeAndInsertText(xmlDoc, objNode, "typeVal", typeVal);
    createNodeAndInsertText(xmlDoc, objNode, "deptNM", replaceSingleQuotation(ss_deptNM));
    createNodeAndInsertText(xmlDoc, objNode, "ownerNM", replaceSingleQuotation(ss_ownerNM));


    var objNode23;
    if (ApproveFlag == "1") {
        if (cmd == "add") {
        	objNode23 = "0";
        } else {
            if (reFlagVal == "1" && document.getElementById("iReFlag").value == "0") {
            	objNode23 = "0";
            } else {
            	objNode23 = SavedApproveFlag;
            }
        }
    } else {
        objNode23 = "1";
    }
    createNodeAndInsertText(xmlDoc, objNode, "APPROVE", objNode23);

    xmlHttp.open("POST", "/ezResource/scheduleAddOk.do?cmd=" + cmd + "&type=" + typeVal, false);
    xmlHttp.send(getXmlString(xmlDoc));

    var returnStr, p_num, p_ownerID;

    resultXML = xmlHttp.responseXML;


    if (typeof (resultXML) != "undefined" && getXmlString(resultXML) != "") {
        xmlHttp = null;
        if (cmd == "add" && objNode23 == "0") {
            xmlHttp = createXMLHttpRequest();
            xmlHttp.open("POST", "/ezResource/sendMail.do", false);
            xmlHttp.send(xmlDoc);
            var ResponseXML = xmlHttp.responseXML;
            xmlHttp = createXMLHttpRequest();
            xmlHttp.open("POST", "/ezEmail/remote/mailSendNoti.do", false);
            xmlHttp.send(ResponseXML);
            xmlHttp = null;

        }
        if (document.getElementById("tmpReFlag").value != "0") {
            var objNodes = SelectNodes(resultXML, "RTN_DATA")[0];
            p_num = getNodeText(GetChildNodes(objNodes)[0]);
            p_ownerID = getNodeText(GetChildNodes(objNodes)[1]);

            SaveRepetition(p_num, resItem);
        }
    } else {
        alert("" + strLang145 + "");
    }
}
// 2011-04 : 자원관리 중복 등록 관련 작업 진행
function DupCheck(resItemID) {
    //================================================================================
	// 자원사용 중복체크
	var STime = "";
	var ETime = "";
		
	// 하루종일
	if (document.getElementById("AllDay").checked == true) {
	    STime = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:01";
	    ETime = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23:59:59";
	} else {
	    STime = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
	    ETime = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
	}
	
	// Parameter: 자원번호, 시작시간, 종료시간, 회사ID, 글번호, 저장Flag(add, mod)		
	var bUsingResource = isUsingResource(resItemID, STime, ETime, ss_companyID, num.value, cmd, document.getElementById("AllDay").checked);
	if (bUsingResource) {
	    // 2011-05 : 개별체크로 인한 중복 알림 제거
		//alert("" + strLang141 + "");
		return false;
	} else {
	    return true;
	}
	//================================================================================
}

//******************************************************************
//* Function 명   : delSchedule_onClick( num, ownerID )
//* 작성자명      : 박형기                                                                
//* 작성일자      : 2002년 5월 10일                                                       
//* 기능설명      : 일정삭제시
//* 매개변수      : num, ownerID
//*               : 
//* 수정일자      : 2002년 5월 12일                                                       
//* 수정내용      : 
//******************************************************************
var schedule_repetition_del_cross_dialogArguments = new Array();
var m_num;
var m_ownerID;
function delSchedule_onClick( num, ownerID)  {
    var isRepetition = false;

	if( num != "" && ownerID != "" ) {
		if (ApproveFlag == "1" && SavedApproveFlag == "1" && pAdminFg != "Y" && cmd == "mod") {
			alert("" + strLang148 + "");
			return;
		}

		if (CheckAdmin() == false && OwnerCheck() == false) {
			alert("" + strLang94 + "");
			return;
		}
		
		var ans = confirm("" + strLang90 + "");
			
		if (ans) {
		    if (parseInt(reFlagVal) == 1 || parseInt(reFlagVal) == 3) {
		        // 20070511 add
		        isRepetition = true;

		        var rgParams = new Array();
		        rgParams["CancelOpen"] = false;
		        rgParams["InstanceType"] = "";

		        // 수정(2007.03.28) : 반복예약 기능
		        if (CrossYN()) {
		            m_num = num;
		            m_ownerID = ownerID;

		            schedule_repetition_del_cross_dialogArguments[0] = rgParams;
		            schedule_repetition_del_cross_dialogArguments[1] = delSchedule_onClick_Complete;

		            DivPopUpShow(390, 260, "/ezResource/scheduleRepetitionDel.do");
		        } else {
		            var feature = "dialogHeight:260px;dialogWidth:390px;status:no;help:no;center:yes;edge:sunken";
		            feature = feature + GetShowModalPosition(390, 260);
		            var hWin = window.showModalDialog("/ezResource/scheduleRepetitionDel.do", rgParams, feature);

		            if (false != rgParams["CancelOpen"]) return (false);
		            var szType = rgParams["InstanceType"];

		            if (parseInt(reFlagVal) == 1) {
		                if (szType == "Instance") {
		                    pnumVal = num;
		                    writerIDVal = ownerID;
		                    num = "0";
		                    reFlagVal = "3";
		                }
		            } else if (parseInt(reFlagVal) == 3) {
		                if (szType == "Master") {
		                    num = pnumVal;
		                    ownerID = writerIDVal;
		                    reFlagVal = "1";
		                }
		            }
		        }
		    }

		    if ((!isRepetition && CrossYN()) || !CrossYN()) {
		        var xmlHttp = createXMLHttpRequest();
		        var xmlDoc = createXmlDom();

		        var objNode;

		        createNodeInsert(xmlDoc, objNode, "PARAMETER");

		        createNodeAndInsertText(xmlDoc, objNode, "NUM", num);
		        createNodeAndInsertText(xmlDoc, objNode, "OWNERID", ownerID);
		        createNodeAndInsertText(xmlDoc, objNode, "PNUM", pnumVal);
		        createNodeAndInsertText(xmlDoc, objNode, "WRITERID", writerIDVal);
		        createNodeAndInsertText(xmlDoc, objNode, "INSTYPE", reFlagVal);
		        createNodeAndInsertText(xmlDoc, objNode, "GFLAG", gFlagVal);
		        createNodeAndInsertText(xmlDoc, objNode, "STARTDATE", startDateVal);
		        createNodeAndInsertText(xmlDoc, objNode, "ENDDATE", endDateVal);

		        xmlHttp.open("POST", "/ezResource/scheduleAddOk.do?cmd=del", false);
		        xmlHttp.send(xmlDoc);

		        var res = xmlHttp.responseText;

		        if (trim(res) == "OK") {
		            window.close();

		            window_onUnload();
		        } else {
		            alert("" + strLang149 + "");
		        }
		    }
		}
	} else {
		window.close();
	}
}

function delSchedule_onClick_Complete(retVal) {
    if (false != retVal["CancelOpen"]) {
        DivPopUpHidden();
        return (false);
    }
    var szType = retVal["InstanceType"];

    if (parseInt(reFlagVal) == 1) {
        if (szType == "Instance") {
            pnumVal = m_num;
            writerIDVal = m_ownerID;
            m_num = "0";
            reFlagVal = "3";
        }
    } else if (parseInt(reFlagVal) == 3) {
        if (szType == "Master") {
            m_num = pnumVal;
            m_ownerID = writerIDVal;
            reFlagVal = "1";
        }
    }

    var xmlHttp = createXMLHttpRequest();
    var xmlDoc = createXmlDom();

    var objNode;

    createNodeInsert(xmlDoc, objNode, "PARAMETER");

    createNodeAndInsertText(xmlDoc, objNode, "NUM", m_num);
    createNodeAndInsertText(xmlDoc, objNode, "OWNERID", m_ownerID);
    createNodeAndInsertText(xmlDoc, objNode, "PNUM", pnumVal);
    createNodeAndInsertText(xmlDoc, objNode, "WRITERID", writerIDVal);
    createNodeAndInsertText(xmlDoc, objNode, "INSTYPE", reFlagVal);
    createNodeAndInsertText(xmlDoc, objNode, "GFLAG", gFlagVal);
    createNodeAndInsertText(xmlDoc, objNode, "STARTDATE", startDateVal);
    createNodeAndInsertText(xmlDoc, objNode, "ENDDATE", endDateVal);

    xmlHttp.open("POST", "/ezResource/scheduleAddOk.do?cmd=del", false);
    xmlHttp.send(xmlDoc);

    var res = xmlHttp.responseText;

    if (trim(res) == "OK") {
        window.close();
        window_onUnload();
    } else {
        alert("" + strLang149 + "");
    }
    DivPopUpHidden();
}

//******************************************************************
//* Function 명   : print_onClick( printTrueFalse )
//* 작성자명      : 박형기                                                                
//* 작성일자      : 2002년 5월 10일                                                       
//* 기능설명      : 일정 출력
//* 매개변수      : printTrueFalse
//*               : 
//* 수정일자      : 2002년 5월 12일                                                       
//* 수정내용      : 
//******************************************************************
function print_onClick( printTrueFalse )
{
	g_printTrueFalse = printTrueFalse;
        document.getElementById("printDocument").innerHTML = message.GetEditorContent();
        onbeforeprint();		
	    
        message.focus();
        var feature = GetOpenPosition(700, 700);
        printWindow = window.open("", "mywindow", "width=700, height=700,location=0,status=0,scrollbars=1,resizable=1" + feature);
        var strContent = "<html><head>"; // If you use this script inside <head> on the page, there might be error. So I am keeping inside body (becaue of <head>)        
        strContent = strContent + "<title>Print Preview</title>";      
        strContent = strContent + "<link rel=\"stylesheet\" href=\"/css/default_kr.css\" type=\"text/css\" />";       
        strContent = strContent + "</head><body class=\"popup\">";        
        strContent = strContent + "<div style='width:100%;height:20;text-align:right; margin-bottom:25px;'>";        
        strContent = strContent + "<input type='button' id='btnPrint' value='Print' style='width:100px' onclick='window.print()' />";       
        strContent = strContent + "<input type='button' id='btnCancel' value='Cancel' style='width:100px' onclick='window.close()' />";        
        strContent = strContent + "</div>";        
        strContent = strContent + "<div style='width:100%;'><table id='printScreen' class=\"layout\" width='100%' border='0' cellspacing='0' cellpadding='10'>";          
        strContent = strContent + document.getElementById("printScreen").innerHTML ;        
        strContent = strContent + "</table></div>";        
        strContent = strContent + "</body>"; 
        printWindow.document.write(strContent);        
        printWindow.document.close();        
        printWindow.focus();   
  
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

function printpr() {
          var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
			ezUtil.PrintPreview(document);
			ezUtil = null;
}

function onbeforeprint() {
    g_documentTitle = document.title;
    document.title = title.value;

    setNodeText(document.getElementById("printOwner"), getNodeText(document.getElementById("displayNM")));

    //중요도 낮음	importance1.value의 값음 schedule_add.asp 화면에서 직접가지고 온다.
    if (importance1.value == 1) {
        printImportance.textContent = "" + strLang161 + "" + " ";	// 중요도
    }

    //	중요도 보통
    if (importance1.value == 2) {
        printImportance.textContent = "" + strLang163 + "" + " ";
    }

    //중요도 높음
    if (importance1.value == 3) {
        printImportance.textContent = "" + strLang165 + "" + " ";
    }

    if (tr_Recur.style.display != "none") {
        setNodeText(document.getElementById("printDate"), getNodeText(document.getElementById("AllDayDisplay")));
    } else {
        if (!AllDay.checked) {
            setNodeText(document.getElementById("printDate"),$("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " ~ " + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " (" + strLang126 + ")");
        } else {
            setNodeText(document.getElementById("printDate"),$("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val() + " ~ " + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val());
        }
    }

    setNodeText(document.getElementById("printTitle"),title.value + " ");		// 제목 인쇄하는 부분

}

window.onafterprint = function () {
	document.getElementById("normalScreen").style.display = "block";
	document.getElementById("printScreen").style.display = "none";
	document.getElementById("mainbodytag").className ="popup";
	document.title = g_documentTitle;

}

//******************************************************************
//* Function 명   : AttachAdd_onClick()
//* 작성자명      : 박형기                                                                
//* 작성일자      : 2002년 5월 10일                                                       
//* 기능설명      : 첨부파일추가
//* 매개변수      : 
//*               : 
//* 수정일자      : 2002년 5월 12일                                                       
//* 수정내용      : 
//******************************************************************
var g_progresswin;
var g_fileList;

function AttachAdd_onClick() {
	var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
	var file = ezUtil.OpenLoadDlgMulti("", "");

	if (!file) {
		return;
	}

	g_fileList = file.split(";");
	var fileSize = 0;

	for (var i=0; i<g_fileList.length-1; i++) {
		if (ezUtil.GetFileSize(g_fileList[i]) == 0) {
			alert("" + strLang166 + "");
			return;
		}
		fileSize += ezUtil.GetFileSize(g_fileList[i]); 			
	}

	ezUtil = null;

	if (fileSize > 2 * 1024 * 1024) {
		alert("" + strLang167 + "");
		return;
	}

	var fileNamelist = "";
	var fileName = "";

	show_progress(g_fileList[0].substr(g_fileList[0].lastIndexOf("\\")+1) + "" + strLang168 + "" + 1 + "/" + (g_fileList.length-1));

}

function show_progress(fileinfo) {
    var feature = GetShowModalPosition(390, 160);
    g_progresswin = window.showModelessDialog("/ezEmail/showProgress.do?fileinfo=" + encodeURIComponent(fileinfo), "", "dialogWidth=390px; dialogHeight:160px; center:yes; status:no; help:no; edge:sunken" + feature);

	//Dialog 창이 완전히 Loding 되기까지 대기한다.
	//for( ;window.g_progresswin.document.readyState!="complete";) ;//IE 9 지원안함.
	
	beginAttachAdd();
}

//--실제로 파일첨부를 하는 함수
function beginAttachAdd() {
	for (var i=0; i<g_fileList.length-1; i++) {
		try {
			if (i > 0) {
				status_change(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1) + "" + strLang168 + "" + (i+1) + "/" + (g_fileList.length-1));
			}
			oPoster.Clear();
			
			//https 사용
			if(window.location.protocol.toLowerCase() == "http:") {
				oPoster.Protocol = 0; 
			}  else {
				oPoster.Protocol = 1; 
			} 
			
			oPoster.AddFormData("mode", "send");
			oPoster.AddFormData("cmd", "add");
			oPoster.AddFormData("curCmd", cmd);
			oPoster.AddFormData("num", org_num);
			oPoster.AddFormData("userID", org_ownerID);
			oPoster.AddFormData("gresFlag", gFlagVal);
			oPoster.AddFile("attachFile", g_fileList[i], 0);
			oPoster.Host = server_name;
			oPoster.PostURL = "/ezSchedule/scheduleAttach.do";
			oPoster.Post();

			if (oPoster.Response.substr(0, 2) != "OK") {
				try {
					g_progresswin.close();
				} catch(e) {}
				alert(g_fileList[i] + " " + strLang169 + "");
				return;
			} else {
				NotifyResult(oPoster.Response.substr(3, oPoster.Response.length-3), "add", g_fileList[i], 0); 
			}
		} 
		catch (e) {
			try {
				g_progresswin.close();
			} catch(e) {}
			if (e.number == -2147352567) {
				alert("" + strLang170 + "");
			} else {
				alert(g_fileList[i] + " " + strLang171 + "" + "\n\n" + e.number + " - " + e.description);
			} 
			return;
		}	
	}

	try {
		g_progresswin.close();
	} catch(e) {}
}

function status_change(fileinfo) {
	try {
		window.g_progresswin.document.Script.fileinfo_change(fileinfo);
	} catch(e) {}
}

//******************************************************************
//* Function 명   : AttachFileList()
//* 작성자명      : 박형기                                                                
//* 작성일자      : 2002년 5월 10일                                                       
//* 기능설명      : 첨부파일 리스트
//* 매개변수      : 
//*               : 
//* 수정일자      : 2002년 5월 12일                                                       
//* 수정내용      : 
//******************************************************************
function AttachFileList() {
	var fileListStr = "";
	var childCnt = attachedFile.childNodes.length;
	
	for( var i = 0 ; i < childCnt ; i++ ) {
		var objChild = attachedFile.childNodes(i);
		
		if( objChild.value != 'delete' ) {
			fileListStr += trim(objChild.org_filename);
			fileListStr += "<";
			fileListStr += objChild.filesize;
			fileListStr += ">";
		}
	}
	
	return fileListStr;
}
	
//******************************************************************
//* Function 명   : AttachDel_onClick()
//* 작성자명      : 박형기                                                                
//* 작성일자      : 2002년 5월 10일                                                       
//* 기능설명      : 첨부파일 삭제
//* 매개변수      : 
//*               : 
//* 수정일자      : 2002년 5월 12일                                                       
//* 수정내용      : 
//******************************************************************	
function AttachDel_onClick() {	
	try {
		var totLen = divBody.childNodes(0).childNodes(0).childNodes.length;
	} catch(e) {
		return;
	}
	
	var del_Idx = 0;
	
	for( var i = 0; i < totLen; i++ ) {
		var objTRNode = divBody.childNodes(0).childNodes(0).childNodes(del_Idx);
		
		if( objTRNode.childNodes(0).childNodes(0).checked ) {
			var childCnt = attachedFile.childNodes.length;
			
			for( var j = 0 ; j < childCnt ; j++ ) {
				var objChild = attachedFile.childNodes(j);
				
				if( objChild.id == objTRNode.parentID ) {
					objChild.value = 'delete';
				}
			}
			
			divBody.childNodes(0).childNodes(0).removeChild(objTRNode);
			
			var divHeight = divBody.style.height;
			
			if( parseInt(divHeight) != 27 ) {
				divHeight = parseInt(divHeight) - 27;
				//divBody.style.height = divHeight;
				
				//window.resizeBy(0, -27);
			}
		} else {
			del_Idx++;
		}
	}
}

//******************************************************************
//* Function 명   : SaveOrDeleteAttachFile()
//* 작성자명      : 박형기                                                                
//* 작성일자      : 2002년 5월 10일                                                       
//* 기능설명      : 첨부파일 저장 또는삭제
//* 매개변수      : 
//*               : 
//* 수정일자      : 2002년 5월 12일                                                       
//* 수정내용      : 
//******************************************************************
function SaveOrDeleteAttachFile() {
	var xmlhttp = createXMLHttpRequest();
	
	var childCnt = attachedFile.childNodes.length;
	
	// 저장인 경우
	if( attachSave ) {
		for( var i = 0 ; i < childCnt ; i++ ) {
			var objChild = attachedFile.childNodes(i);
			
			if( objChild.value == 'delete' ) {
				var xmlpara = createXmlDom();
				
				var objRoot = xmlpara.createNode(1,"PARAMETER","");
				xmlpara.appendChild(objRoot);
				
				var objNode1 = xmlpara.createNode(1, "CURCMD", "");
				objNode1.text = cmd;
				xmlpara.documentElement.appendChild(objNode1);
				
				var objNode2 = xmlpara.createNode(1, "DELFILENAME", "");
				objNode2.text = objChild.org_filename;
				xmlpara.documentElement.appendChild(objNode2);
				
				var objNode3 = xmlpara.createNode(1, "DELDIVID", "");
				objNode3.text = objChild.id;
				xmlpara.documentElement.appendChild(objNode3);
				
				var objNode4 = xmlpara.createNode(1, "NUM", "");
				objNode4.text = org_num;
				xmlpara.documentElement.appendChild(objNode4);
				
				var objNode5 = xmlpara.createNode(1, "USERID", "");
				objNode5.text = org_ownerID;
				xmlpara.documentElement.appendChild(objNode5);
				
				var objNode6 = xmlpara.createNode(1, "GRESFLAG", "");
				objNode6.text = gFlagVal;
				xmlpara.documentElement.appendChild(objNode6);
				
				xmlhttp.open ("Post","/ezResource/scheduleAttachProc.do?cmd=del",false);
				xmlhttp.send(xmlpara);
				
				var re = xmlhttp.responseText;

				if( re != "OK" ) {
					alert("" + strLang173 + "");
					return;
				}
			}
		}
	} else	 {			// 취소의 경우
		for( var i = 0 ; i < childCnt ; i++ ) {
			var objChild = attachedFile.childNodes(i);
			
			if( (objChild.value == 'delete' && objChild.isOriginal == 'no') || objChild.value == 'insert' ) {
				var xmlpara = createXmlDom();
				
				var objRoot = xmlpara.createNode(1,"PARAMETER","");
				xmlpara.appendChild(objRoot);
				
				var objNode1 = xmlpara.createNode(1, "CURCMD", "");
				objNode1.text = cmd;
				xmlpara.documentElement.appendChild(objNode1);
				
				var objNode2 = xmlpara.createNode(1, "DELFILENAME", "");
				objNode2.text = objChild.org_filename;
				xmlpara.documentElement.appendChild(objNode2);
				
				var objNode3 = xmlpara.createNode(1, "DELDIVID", "");
				objNode3.text = objChild.id;
				xmlpara.documentElement.appendChild(objNode3);
				
				var objNode4 = xmlpara.createNode(1, "NUM", "");
				objNode4.text = org_num;
				xmlpara.documentElement.appendChild(objNode4);
				
				var objNode5 = xmlpara.createNode(1, "USERID", "");
				objNode5.text = org_ownerID;
				xmlpara.documentElement.appendChild(objNode5);
				
				var objNode6 = xmlpara.createNode(1, "GRESFLAG", "");
				objNode6.text = gFlagVal;
				xmlpara.documentElement.appendChild(objNode6);
				
				xmlhttp.open ("Post","/ezResource/scheduleAttachProc.do?cmd=del",false);
				xmlhttp.send(xmlpara);
				
				var re = xmlhttp.responseText;
				
				if( re != "OK" ) {
					alert("" + strLang173 + "");
					return;
				}
			}
		}
	}
}

function NotifyResult( filename, attachMode, param1, filesize ) {
	restore_button();
	
	if( attachMode == "add" ) {
		handleAttachDiv( "add", filename, param1, filesize );
	} else if( attachMode == "del" ) {
		handleAttachDiv( "del", filename, param1, filesize );
	}
	showAttachFile();
}
	
function restore_button() {
	btn_AttachAdd.disabled = false;
}

function handleAttachDiv( mCmd, mFile, mClientPath, mFilesize ) {
	var elem;
	var i;

	if( mCmd == "add" ) {
		var tmpFileName;
		
		tmpFileName = mFile.substring(mFile.indexOf("_")+1, mFile.length);
		tmpFileName = tmpFileName.substring(tmpFileName.indexOf("_")+1, tmpFileName.length);
		
	    //attachedFile.innerHTML += "<div id='attachpak" + parseInt( ( Math.random() * 100000 ).toString() ) + "' filesize='" + mFilesize + "' org_filename='" + mFile + "' value='insert' isOriginal='no'><input type='checkbox'><img src='/pims/img/form-freedoc.gif'><a href='" + mClientPath + "' target='file'>" + tmpFileName + "</a></div>";
		attachedFile.innerHTML += "<div id='attachpak" + parseInt((Math.random((new Date).getMilliseconds()) * 100000).toString()) + "' filesize='" + mFilesize + "' org_filename='" + mFile + "' value='insert' isOriginal='no'><input type='checkbox'><img src='/images/ghost.gif'><a href='" + mClientPath + "' target='file'>" + tmpFileName + "</a></div>";
	} else if (mCmd == "del") {
		for( i = 0; i < attachedFile.childNodes.length; i ++ ) {
			elem = attachedFile.childNodes.item(i);
			
			if( elem.id == mClientPath ) {
				elem.value = 'delete';
				//attachedFile.removeChild( elem );
				break;
			}
		}
	}
}

//******************************************************************
//* Function 명   : showAttachFile()
//* 작성자명      : 박형기                                                                
//* 작성일자      : 2002년 5월 10일                                                       
//* 기능설명      : 첨부파일 보기
//* 매개변수      : 
//*               : 
//* 수정일자      : 2002년 5월 12일                                                       
//* 수정내용      : 
//******************************************************************
function showAttachFile() {
	var elem = new Array(), i, k;
	var delElem;
	var childElem;
	
	var tab_attachedFile = document.createElement( "DIV" );
	
	tab_attachedFile.style.fontSize = "12px";
	tab_attachedFile.innerHTML = attachedFile.innerHTML;
	
	divBody.innerHTML = "";
	var newTable = document.createElement( "TABLE" );
	attachbody = document.createElement( "TBODY" );
	
	newTable.appendChild( attachbody );
	divBody.appendChild( newTable );
	
	var eIdx = 0;
	
	for( i = 0; i < tab_attachedFile.childNodes.length; i++ ) {
		if( tab_attachedFile.childNodes.item(i).value != 'delete' ) {
			elem[eIdx] = tab_attachedFile.childNodes.item(i);
			
			eIdx++;
		}
	}
	
	for( i = 0; i < elem.length; i ++ ) {
		if( elem[i].tagName == "DIV" ) {
			for( k = 0; k < elem[i].childNodes.length; k ++ ) {
				childElem = elem[i].childNodes.item(k);
					
				if( childElem.tagName == "A" ) {
					childElem.id = "URL";
					//childElem.onclick = "return false;";
				}
			}
		}
	}
	
	//window.resizeTo(750, 490);		// 첨부파일 추가 창사이즈 바꿔는것
	window.resizeTo(572, 571);
	
	var h_Val = 27;
	
	for( i = 0; i < elem.length; i ++ ) {
		//divBody.style.height = 100;
		row = attachbody.insertRow();
		//row.onmouseover = overEffect;
		//row.onmouseout = outEffect;
		//row.onclick = onselect;
		//row.ondblclick = onFileSelect;
		row.onclick = onFileSelect;
		row.filename = getNodeText(elem[i]);
		row.org_filename = elem[i].org_filename;
		row.parentID = elem[i].id;
		row.height = "12px";
			
		tdElem = row.insertCell();
		tdElem.innerHTML = elem[i].innerHTML;
		
		if( h_Val != 27 ) {
			//window.resizeBy(0, 27);
		}
		
		h_Val += 27;
	}
}

var selectTR = null;

function deselectAll() {
	var row, tdElem;
	var i;
	var childlength = attachbody.children.length;
	
	for( i = 0; i < childlength; i ++ ) {
		deselect( attachbody.children.item(i) );
	}
}

function deselect( elem ) {
	elem.style.color = "";
	elem.style.backgroundColor = "";
}

function onselect() {
	deselectAll();
		
	selectTR = this;
	
	this.style.color = "";
	this.style.backgroundColor = "#D3E8FC";
}

function outEffect() {
	if( selectTR != this ) {
		this.style.color = "";
		this.style.backgroundColor = "";
	}
}

function overEffect() {
	if( selectTR != this ) {
		this.style.color = "blue";
		this.style.backgroundColor = "#E3EEF5";
	}
}

function onFileSelect() {
	var openFile = eval(this.parentID);	
	
	openFile.children(1).onclick();
}

//******************************************************************
//* Function 명   : windows_close()
//* 작성자명      : 박형기                                                                
//* 작성일자      : 2002년 5월 10일                                                       
//* 기능설명      : 윈도우종료
//* 매개변수      : 
//*               : 
//* 수정일자      : 2002년 5월 12일                                                       
//* 수정내용      : 
//******************************************************************
function windows_close() {
	window.close();
}


// 자원예약시간 중복 체크
function isUsingResource(pResID, pSTime, pETime, pCompanyID, pNum, pCmd, pAllDay) { // 20080123 ryujh, pAllDay 추가 - 반복예약시 하루종일 판단필요
	var xmlHTTP = createXMLHttpRequest();
	var xmlDOM = createXmlDom();
	var objNode ;

	createNodeInsert(xmlDOM, objNode, "DATA");	
	createNodeAndInsertText(xmlDOM, objNode, "RESID", pResID);
	createNodeAndInsertText(xmlDOM, objNode, "STIME", pSTime);
	createNodeAndInsertText(xmlDOM, objNode, "ETIME", pETime);
	createNodeAndInsertText(xmlDOM, objNode, "COMPANYID", pCompanyID);
	createNodeAndInsertText(xmlDOM, objNode, "NUM", pNum);
	createNodeAndInsertText(xmlDOM, objNode, "CMD", pCmd);
	createNodeAndInsertText(xmlDOM, objNode, "APPROVE", ApproveFlag);
	
	// 20080116 ryujh, 반복예약값이 있을때만
	if ( g_data["recurrence"] != null && g_data["recurrence"] != "" ) {
		var xmlDOMrec = createXmlDom();
		xmlDOMrec = loadXMLString(g_data["recurrence"]);
				
		if(pAllDay) {
			createNodeAndInsertText(xmlDOMrec, objNode, "allday", "true");
		} else {
			createNodeAndInsertText(xmlDOMrec, objNode, "allday", "false");
		}
		
		if(CrossYN()) { 
	        var xmlRtn = xmlDOMrec.documentElement;
	        var Node = xmlDOM.importNode(xmlRtn,true);
            xmlDOM.documentElement.appendChild(Node);
	    } else {
	         var xmlRtn = xmlDOMrec.documentElement;
             xmlDOM.documentElement.appendChild(xmlRtn);
	    }
	    
		/*var alldaynode = xmlDOMrec.createNode(1, "allday", '');
		alldaynode.text = pAllDay ? 'true' : 'false';
		xmlDOMrec.documentElement.appendChild(alldaynode); // 20080123 ryujh, 하루종일 조건 추가 (xmlns: -1(true), 0(false))
		xmlDOM.documentElement.appendChild(xmlDOMrec.documentElement); 
		xmlDOMrec = null;*/
	}
    
	//TODO: 주석풀기
//	xmlHTTP.open("POST", "/ezResource/timeDupCheck.do", false);
//	xmlHTTP.send(xmlDOM);
//	
//	var rtnValue = xmlHTTP.responseText;
	var rtnValue = "False";
	
	xmlDOM = null;
	xmlHTTP = null;
	
	// true:중복, false:중복안됨
	if (rtnValue == "False") {
		return false;
	} else {
		return true;
	}
}

//// 자원예약시간 중복 체크
//function isUsingResource(pResID, pSTime, pETime, pCompanyID, pNum, pCmd)
//{
//	var xmlHTTP = createXMLHttpRequest();
//	var xmlDOM = createXmlDom();
//	
//	var objRoot = xmlDOM.createNode(1, "DATA", "");
//	xmlDOM.appendChild(objRoot);
//	
//	var objNode0 = xmlDOM.createNode(1, "RESID", "");
//	objNode0.text = pResID;
//	xmlDOM.documentElement.appendChild(objNode0);
//	
//	var objNode1 = xmlDOM.createNode(1, "STIME", "");
//	objNode1.text = pSTime;
//	xmlDOM.documentElement.appendChild(objNode1);
//	
//	var objNode2 = xmlDOM.createNode(1, "ETIME", "");
//	objNode2.text = pETime;
//	xmlDOM.documentElement.appendChild(objNode2);
//	
//	var objNode3 = xmlDOM.createNode(1, "COMPANYID", "");
//	objNode3.text = pCompanyID;
//	xmlDOM.documentElement.appendChild(objNode3);
//	
//	var objNode4 = xmlDOM.createNode(1, "NUM", "");
//	objNode4.text = pNum;
//	xmlDOM.documentElement.appendChild(objNode4);
//	
//	var objNode5 = xmlDOM.createNode(1, "CMD", "");
//	objNode5.text = pCmd;
//	xmlDOM.documentElement.appendChild(objNode5);

//	var objNode6 = xmlDOM.createNode(1, "APPROVE", "");
//	objNode6.text = ApproveFlag;
//	xmlDOM.documentElement.appendChild(objNode6);

//	xmlHTTP.open("POST", "ezResource_TimeDupCheck.aspx", false);
//	xmlHTTP.send(xmlDOM);
//	
//	var rtnValue = xmlHTTP.responseText;
//	
//	xmlDOM = null;
//	xmlHTTP = null;
//	
//	// true:중복, false:중복안됨
//	if (rtnValue == "False")
//		return false;
//	else
//		return true;
//}

// 자신의 일정인지 체크
function OwnerCheck() {
	// 수정(2007.03.28) : 반복예약 기능
	//if (writerIDVal == org_ownerID)
	if (writerIDVal == s_userID) {
		return true;
	} else {
		return false;
	}
}

// 관리자 여부 체크
function CheckAdmin() {
	if (pAdminFg == "Y") {
		return true;
	} else {
		return false;
	}
}

// 현재일과 예약시작일의 차이를 계산
function CheckInterval() {
	var ms24Hours = 86400000;   // 1일의 ms
	var DiffCnt   = 0;
	var d         = nowDate.split("-");
	
	var strSDate  = new Date(d[0], parseInt(d[1], 10) - 1, parseInt(d[2], 10));
	var strEDate = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
	DiffCnt = (strEDate - strSDate) / ms24Hours;
	
	return DiffCnt;
}

// 예약 시작일과 종료일의 차이를 계산
function CheckUseInterval() {
	var ms24Hours = 86400000;   // 1일의 ms
	var DiffCnt   = 0;
	
	var strSDate = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
	var strEDate = new Date($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
	DiffCnt = (strEDate - strSDate) / ms24Hours;
	
	return DiffCnt;
}

// 자원예약에 대한 사용허가 및 취소
var setApprovFlag = false;

function SetApproval_onClick(pCmd, pFlag) {
    if (pFlag == "1") {
        setApprovFlag = true;
        var result = btn_Save();
        if (!result) {
        	return;
        }
    }
	var msg = ""
	if (pFlag == "1") {
		msg = "" + strLang176 + "";
	} else {
		msg = "" + strLang177 + "";
	}
	
	var result = confirm(msg);
	if (result) {
		// 자원사용 중복체크
		if (bDupCheck == true && pFlag == "1") {
			var STime = "";
			var ETime = "";
			
			// 하루종일
			if (document.getElementById("AllDay").checked == true) {
			    STime = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:01";
			    ETime = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23:59:59";
			} else {
			    STime = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
			    ETime = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
			}
			
			// Parameter: 자원번호, 시작시간, 종료시간, 회사ID, 글번호, 저장Flag(add, mod)
			var bUsingResource = isUsingResource(ownerID.value, STime, ETime, ss_companyID, num.value, pCmd, document.getElementById("AllDay").checked);
			if (bUsingResource) {
				alert("" + strLang141 + "");
				return;
			}
		}
		
		for (var i = 0 ; i < ItemArray[0].length ; i++) {
		    OnlySaveSchedule(ItemArray[0][i]);
		}

		var xmlHTTP = createXMLHttpRequest();
		var xmlDOM = createXmlDom();
		var objNode ;
	
	    createNodeInsert(xmlDOM, objNode, "DATA");	
	    createNodeAndInsertText(xmlDOM, objNode, "COMPANYID", ss_companyID);
	    createNodeAndInsertText(xmlDOM, objNode, "RESID", document.getElementById("ownerID").value);
	    createNodeAndInsertText(xmlDOM, objNode, "NUM", document.getElementById("num").value);
	    createNodeAndInsertText(xmlDOM, objNode, "APPROVE", pFlag);
	    
		xmlHTTP.open("POST", "/ezResource/updateApprovalFlag.do", false);
		xmlHTTP.send(xmlDOM);
		
		var rtnValue = xmlHTTP.responseText;
		
		xmlHTTP = null;
		
		if (rtnValue == "True") {
		    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
	        // 2009.11.26 - 자원승인시 사용자에게 자원승인 알림메일 발송	        
	        	        
	        xmlHTTP = createXMLHttpRequest();
			xmlHTTP.open("POST", "/ezResource/sendMailToUser.do", false);
			xmlHTTP.send(xmlDOM);				        
			var ResponseXML = xmlHTTP.responseXML;
			xmlHTTP = createXMLHttpRequest();
			xmlHTTP.open("POST", "/ezEmail/remote/mailSendNoti.do", false);
			xmlHTTP.send(ResponseXML);
			xmlHTTP = null;
    	         
	        //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
			alert("" + strLang33 + "");
		} else {
			alert("" + strLang178 + "");
		}
		
		xmlDOM = null;
		// 부모창의 예약목록을 새로고침
		if(window.opener != null) {
			window.opener.btnRefresh_onclick();
		}
			
		window.close();
	}
}

//20070517
function TimeRevision(szTime) {
	if(parseInt(szTime) == 0) {
		return szTime = "00";
	}
	return szTime
}