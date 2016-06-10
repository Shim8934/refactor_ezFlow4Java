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

var m_eAllDayCheckbox;
var m_rgeTimeCell=new Array();
CONST_SAVE_NO         = 0;
CONST_SAVE_EXPLICIT   = 1;
CONST_SAVE_IMPLICIT   = 2;
var g_nMsgSaved = CONST_SAVE_NO;

var m_fExplicitSave=true;

function window_onload()
{
	
	var iD = null, iM = null, iY = null;
	var objD = new Date();
	
	if( g_winDocAll['idDatepicker'].isoDateUTF == "" )
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
		
		g_winDocAll['idDatepicker'].vtLocalCalDate = objD;
		g_winDocAll['idDatepicker'].vtLocalEndCalDate = objD;
		
		onStartDateChanged.holdTime=g_winDocAll['idDatepicker'].vtLocalDate;
		onEndDateChanged.holdTime=g_winDocAll['idDatepicker'].vtLocalEndDate;
	
	}
	
}


function window.document.onkeydown()
{
	var fClearKey=false;
}

function FreeBusy_onTimeChange()
{
	g_winDocAll['idDatepicker'] = g_winDocAll['idDatepicker']
	//the logic below picks up for 'both'
	if (event.szWhichTimeChanged != 'end')
	{
		g_winDocAll['idDatepicker'].vtLocalDate = event.objDateStart;
		onStartDateChanged();
	}
	if (event.szWhichTimeChanged != 'start')
	{
		g_winDocAll['idDatepicker'].vtLocalEndDate = event.objDateEnd;
		onEndDateChanged();

	}
}

var m_FreeBusyIsLoaded  = false;
var m_fGoingToFb=false;

function FreeBusy_onReady()
{
	divFreebusy.allDayEvent = m_fIsAllDayEvent;
	divFreebusy.viewDate = g_winDocAll['idDatepicker'].vtLocalDate;
	divFreebusy.startDate = g_winDocAll['idDatepicker'].vtLocalDate;
	divFreebusy.endDate = g_winDocAll['idDatepicker'].vtLocalEndDate;

	if (tb_PersonInvite.style.display == "") //if recipient field is showing
	{
		m_fGoingToFb = true;

		NameCertify_onClick();
	}
	else
	{
		divFreebusy.addAttendees(null);
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
	m_fDirtyDateForFb=true; 
}

void function UpdateMessageData()
{
	mf_setRecipients();
	if (onStartDateChanged.fDirty || onEndDateChanged.fDirty || m_fIsAllDayEvent)
	{
		if (m_fIsAllDayEvent)
		{
			g_winDocAll['idDatepicker'].startHours=0;
			g_winDocAll['idDatepicker'].startMinutes=0;
			g_winDocAll['idDatepicker'].endHours=23;
			g_winDocAll['idDatepicker'].endMinutes=59;
		}
		objMessage.setSchemaProperty("urn:schemas:calendar:","dtstart",g_winDocAll['idDatepicker'].isoDateUTC);
		onStartDateChanged.fDirty=false;
		objMessage.setSchemaProperty("urn:schemas:calendar:","dtend",g_winDocAll['idDatepicker'].isoEndDateUTC);
		onStartDateChanged.fDirty=false;
	}
	if (g_winDocAll("subject").dirty == "1")
	{
		objMessage.subject = g_winDocAll("subject").value;
		g_winDocAll("subject").dirty="0";
	}    
	if (g_winDocAll("busystatus").dirty == "1")
	{
		objMessage.setSchemaProperty("urn:schemas:calendar:","busystatus",g_winDocAll("busystatus").value);
		g_winDocAll("busystatus").dirty="0";
	}    
	if (g_winDocAll("location").dirty == "1")
	{
		objMessage.setSchemaProperty("urn:schemas:calendar:","location",g_winDocAll("location").value);
		g_winDocAll("location").dirty="0";
	}    
	if (g_winDocAll("txtMsgBody").dirty == "1")
	{
		objMessage.setSchemaProperty("urn:schemas:httpmail:","textdescription",g_winDocAll("txtMsgBody").value);
		g_winDocAll("location").dirty="0";
	}   
	if("0" != m_eAllDayCheckbox.dirty)
	{
		objMessage.setSchemaProperty("urn:schemas:calendar:","alldayevent",(m_eAllDayCheckbox.checked)?"1":"0");
		m_eAllDayCheckbox.dirty="0";
	}

	if(openRecurrence.bDirty)
	{
		var szHr    =   String(g_winDocAll['idDatepicker'].startHours);
		var szMin   =   String(g_winDocAll['idDatepicker'].startMinutes);
		szHr    = (2 >  szHr.length)?"0" + szHr:szHr;
		szMin   = (2 >  szMin.length)?"0" + szMin:szMin;
		objMessage.addPostData("dtstart_Time", szHr + ":" + szMin);

		szHr    =   String(g_winDocAll['idDatepicker'].endHours);
		szMin   =   String(g_winDocAll['idDatepicker'].endMinutes);
		szHr    = (2 >  szHr.length)?"0" + szHr:szHr;
		szMin   = (2 >  szMin.length)?"0" + szMin:szMin;
		objMessage.addPostData("dtend_Time", szHr + ":" + szMin);
		openRecurrence.bDirty=false;
	}
}

function mfValidDates()
{
	if (g_winDocAll['idDatepicker'].vtLocalDate > g_winDocAll['idDatepicker'].vtLocalEndDate)
	{
		alert(L_EndDateBeforeStartDate_Text);
		return(false);
	}
	return(true);
}

onStartDateChanged.fDirty=false;
onStartDateChanged.holdTime;

function onStartDateChanged()
{
	onStartDateChanged.fDirty=true;
	onStartDateChanged.holdTime=g_winDocAll['idDatepicker'].vtLocalDate;
	if (m_curTab==1)
	{
		divFreebusy.viewDate = g_winDocAll['idDatepicker'].vtLocalDate;
		divFreebusy.startDate = g_winDocAll['idDatepicker'].vtLocalDate;
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
	onEndDateChanged.fDirty=true;
	onEndDateChanged.holdTime = g_winDocAll['idDatepicker'].vtLocalEndDate;
	
	if (m_curTab==1)
	{
		divFreebusy.endDate = g_winDocAll['idDatepicker'].vtLocalEndDate;
		m_fDirtyDateForFb=false;
	}
	else
	{
		m_fDirtyDateForFb=true;
	}
}

function onStartTimeChanged()
{
	var iDur = (null==onStartDateChanged.holdTime) ? 30 : (onEndDateChanged.holdTime - onStartDateChanged.holdTime);
	g_winDocAll['idDatepicker'].vtLocalEndDate = g_winDocAll['idDatepicker'].vtLocalDate + iDur;
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

