var g_flsDelegate = "0";


var g_szImagePath;
var g_szHTTPServerName;
var m_curTab = -1;
var m_objFreeBusyBehavior;

var g_winDocAll=window.document.all;
var g_winDocBody; 
var g_fIsRecurring=false;
var g_rowStatus;
var g_elemStatusText;
var m_fDirtyDateForFb=true;
var m_fIsAllDayEvent=false;

//var m_eDateTimePicker;
var m_eAllDayCheckbox;
var m_rgeTimeCell=new Array();
CONST_SAVE_NO         = 0;
CONST_SAVE_EXPLICIT   = 1;
CONST_SAVE_IMPLICIT   = 2;
var g_nMsgSaved = CONST_SAVE_NO;

//will be set to false for new items untill 'save' or 'send' pressed
// use this flag to delete new items not explicitly saved   
var m_fExplicitSave=true;

//function window.onload()
//{			
//	onload_window();
//}

function onload_window()
{
	
	var iD = null, iM = null, iY = null;
	var objD = new Date();
	
	if( idDatepicker.isoDateUTF == "" )
	{
		if( typeof( g_DD ) != "undefined" )
		{
			var iD = g_DD; 
		}
	
		if(null==iD || isNaN(iD) || iD=="" ) 
			iD=objD.getDate();
	
		if( typeof( g_MM ) != "undefined" )
		{
			var iM = g_MM; 
		}
	
		if(null==iM || isNaN(iD) || iM == "") 
			iM=objD.getMonth();

		if( typeof( g_YY ) != "undefined" )
		{
			var iY = g_YY; 
		}
	
		if(null==iY || isNaN(iD) || iY == "") 
			iY=objD.getFullYear();
		
		objD.setFullYear(iY,iM,iD);

		idDatepicker.vtLocalCalDate(objD);
		idDatepicker.vtLocalEndCalDate(objD);
		
		// 화면에 표시되는 시간 셋팅
		onStartDateChanged.holdTime = idDatepicker.vtLocalDate();
		onEndDateChanged.holdTime = idDatepicker.vtLocalEndDate();	
	}
}

//function window.document.onkeydown()
//{
//	var fClearKey=false;
//}

function FreeBusy_onTimeChange() {
	//window['idDatepicker'] = g_winDocAll['idDatepicker']
	//the logic below picks up for 'both'
	if (event.szWhichTimeChanged != 'end') {
		idDatepicker.vtLocalDate(event.objDateStart);
		onStartDateChanged();
	}
	if (event.szWhichTimeChanged != 'start') {
		idDatepicker.vtLocalEndDate(event.objDateEnd);
		onEndDateChanged();

	}
}

var m_FreeBusyIsLoaded  = false;
var m_fGoingToFb=false;

function FreeBusy_onReady()
{
    divFreebusy.allDayEvent = m_fIsAllDayEvent;
	divFreebusy.viewDate = idDatepicker.vtLocalDate();
	divFreebusy.startDate = idDatepicker.vtLocalDate();
	divFreebusy.endDate = idDatepicker.vtLocalEndDate();

	if (tb_PersonInvite.style.display == "") //if recipient field is showing
	{
		m_fGoingToFb = true;
		// 이름 체크
		NameCertify_onClick();
	}
	else
	{
		divFreebusy.addAttendees(null); //places current user
	}
	m_FreeBusyIsLoaded = true;
}

function FreeBusy_onAddRecipient()
{
	txt_To.value = event.szRecipientName;
	CompleteEmailAddress( txt_To, div_To, 0 );

	NameCertify_onClick();
}


function RecipientField_OnDeleteRecipients()
{
	m_fDirtyDateForFb=true; //forces recip refresh when tabbing to fb page
}

void function UpdateMessageData()
{
	mf_setRecipients();
	if (onStartDateChanged.fDirty || onEndDateChanged.fDirty || m_fIsAllDayEvent)
	{
		if (m_fIsAllDayEvent) {
			idDatepicker.startHours(0);
			idDatepicker.startMinutes(0);
			idDatepicker.endHours(23);
			idDatepicker.endMinutes(59);
		}
		objMessage.setSchemaProperty("urn:schemas:calendar:", "dtstart", idDatepicker.isoDateUTC());
		onStartDateChanged.fDirty=false;
		objMessage.setSchemaProperty("urn:schemas:calendar:", "dtend", idDatepicker.isoEndDateUTC());
		onStartDateChanged.fDirty=false;
}
	if (document.getElementById("subject").dirty == "1")
	{
	    objMessage.subject = document.getElementById("subject").value;
		document.getElementById("subject").dirty = "0";
	}
	if (document.getElementById("busystatus").dirty == "1")
	{
	    objMessage.setSchemaProperty("urn:schemas:calendar:", "busystatus", document.getElementById("busystatus").value);
		document.getElementById("busystatus").dirty = "0";
	}
	if (document.getElementById("location").dirty == "1")
	{
	    objMessage.setSchemaProperty("urn:schemas:calendar:", "location", document.getElementById("location").value);
	    document.getElementById("location").dirty = "0";
	}
	if (document.getElementById("txtMsgBody").dirty == "1")
	{
	    objMessage.setSchemaProperty("urn:schemas:httpmail:", "textdescription", document.getElementById("txtMsgBody").value);
		document.getElementById("location").dirty = "0";
	}   
	if("0" != m_eAllDayCheckbox.dirty)
	{
		objMessage.setSchemaProperty("urn:schemas:calendar:","alldayevent",(m_eAllDayCheckbox.checked)?"1":"0");
		m_eAllDayCheckbox.dirty="0";
	}

	if(openRecurrence.bDirty) {
	    var szHr = String(idDatepicker.startHours());
		var szMin   =   String(idDatepicker.startMinutes());
		szHr    = (2 >  szHr.length)?"0" + szHr:szHr;
		szMin   = (2 >  szMin.length)?"0" + szMin:szMin;
		objMessage.addPostData("dtstart_Time", szHr + ":" + szMin);

		szHr = String(idDatepicker.endHours());
		szMin   =   String(idDatepicker.endMinutes());
		szHr    = (2 >  szHr.length)?"0" + szHr:szHr;
		szMin   = (2 >  szMin.length)?"0" + szMin:szMin;
		objMessage.addPostData("dtend_Time", szHr + ":" + szMin);
		openRecurrence.bDirty=false;
	}
}

//RETURNS: true if valid
function mfValidDates() {
	if (idDatepicker.vtLocalDate() > idDatepicker.vtLocalEndDate())
	{
		alert(L_EndDateBeforeStartDate_Text);
		return(false);
	}
	return(true);
}

//Following four onDateChange events are fired from the datepicker (g_winDocAll['idDatepicker'])
//functions do not rely on event stack thus callable from anywhere
onStartDateChanged.fDirty=false;
onStartDateChanged.holdTime;

function onStartDateChanged()
{
    onStartDateChanged.fDirty = true;
	onStartDateChanged.holdTime=idDatepicker.vtLocalDate();
	if (m_curTab==1) {
	    divFreebusy.viewDate = idDatepicker.vtLocalDate();
		divFreebusy.startDate = idDatepicker.vtLocalDate();
		m_fDirtyDateForFb=false;
	}
	else
	{
		m_fDirtyDateForFb=true;
	}
}

onEndDateChanged.fDirty=false;
onEndDateChanged.holdTime;

function onEndDateChanged()
{
    onEndDateChanged.fDirty = true;
	onEndDateChanged.holdTime = idDatepicker.vtLocalEndDate();

	if (m_curTab==1)
	{
		divFreebusy.endDate = idDatepicker.vtLocalEndDate();
		m_fDirtyDateForFb=false;
	}
	else
	{
		m_fDirtyDateForFb=true;
	}
}

function onStartTimeChanged() {
//2011.09.16  게시판은 시작시간 변경시 완료날짜 변경 필요 없음.

	var EndDateholdTime = onEndDateChanged.holdTime;

	if (EndDateholdTime == null) {
		EndDateholdTime = idDatepicker.vtLocalEndDate();
	}
	var iDur = (null == onStartDateChanged.holdTime) ? 30 : (Number(EndDateholdTime) - Number(onStartDateChanged.holdTime));
	idDatepicker.vtLocalEndDate(Number(idDatepicker.vtLocalDate()) + iDur);

	onEndDateChanged();
	onStartDateChanged();
	
}

function onEndTimeChanged()
{
	onEndDateChanged();
}

function onClickTabcell()
{	
	if (-1 == m_curTab) 
	{ 
		window.document.createStyleSheet("copy/freebusy.css");
		m_objFreeBusyBehavior = divFreebusy.addBehavior("copy/freebusy.htc");
		m_curTab = 1;
	}
	else if (m_FreeBusyIsLoaded==true)
	{            
//		divFreebusy.clearAttendees();//forces fb refresh every time (need dirty flag to optimize)
		FreeBusy_onReady();
	}    
}

function getLocalDateObjFromGMTTime(szDtTime)
{
		
	var szDay   = szDtTime.substring(8,10);
	var szMonth = Number(szDtTime.substring(5,7))-1;    
	var szYear  = szDtTime.substring(0,4);
	var szHr    = szDtTime.substring(11,13);
	var szMin   = szDtTime.substring(14,16);
	var szSec   = szDtTime.substring(17,19);

	var objD = new Date();
	objD.setUTCFullYear(szYear,szMonth,szDay);
	objD.setUTCHours(szHr,szMin);

	return(objD);
}

