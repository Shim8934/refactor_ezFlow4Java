var PresenceControlbrowseris = new PresenceControlBrowseris();
var PresenceControlObject = null;
var bPresenceControlInited = false;

var PresenceControlURIDictionaryObj = null;
var PresenceControlStatesDictionaryObj = null;

var PresenceControlOrigScrollFunc = null;
var bPresenceControlInScrollFunc = false;

// Name Control.dll 사용 가능한지 체크
var bOutLook = false;
// OC 2007 R2 가 설치되어있는지 체크
var bInstall = true;
// OC 2007 R2 가 실행되어있는지 체크
var bOCExec = true;
// ContextMenu를 표시하는 객체
var g_newlayer = null;
// MOC Div 객체
var g_MOC_Div = null;
// MOC Div 로 이벤트를 처리하지 못했을 경우 Interval 처리   
var g_StatusInterval = null;

// Presence 표시 Type 을 설정합니다. 기본값 = 1 (PersonalControl.dll 사용)
// 1 = personalControl.dll 사용
// 2 = NameControl.dll 사용
var presenceType = 1;
// 1 = 간단한 형식 사용
// 2 = OC 아이콘 형식 사용
var contextMenuType = 2;
// Instance Message를 보낼때 오프라인 체크
// true = 오프라인체크
// false = 오프라인미체크
var bShowOfflineIM = false;
// 그룹웨어에서 동작하는 상태인지 체크
// true = 그룹웨어 모듈
// false = ezOCS 모듈
var bGroupwarePresence = true;

// OC 설지 여부 체크
CheckOCInstall();
// Office 2007 이상 설치 여부 체크
CheckOfficeInstall();

// OC install 여부 체크
function CheckOCInstall() {
	try {
		var ezUtil = new ActiveXObject("ezUtil.RegScript");
		var pInstallPath = ezUtil.ReadValueEx(2, "Software\\Microsoft\\Communicator", "InstallationDirectory");
		ezUtil = null;

		if (pInstallPath == "")
		{
			bInstall = false;
		}
	} catch (e) {
	    bInstall = false;
	}
}

// Office 2007 이상 설치 여부 체크
function CheckOfficeInstall() {
    try {
	/*
        // ModalDialog 가 아닐때 실행 (ModalDialog 일 때 NameControl.dll 사용불가)
        if (window.dialogArguments == undefined) {
            //Office 2007 일때만 True
            var EditDocumentButton = new ActiveXObject("SharePoint.OpenDocuments.3");
            EditDocumentButton = null;
            var oNameCrtl = new ActiveXObject("Name.NameCtrl.1");
            oNameCrtl = null;
            bOutLook = true;
        }
	*/
    } catch(e) {
        bOutLook = false;
    }
}

function EnsurePresenceControl()
{
    if (!bPresenceControlInited)
    {
        if (PresenceControlbrowseris.ie5up && PresenceControlbrowseris.win32)
        {
//@cc_on
//@if (@_jscript_version >= 5)
//@            try
//@            {
//@                PresenceControlObject = new ActiveXObject("Name.NameCtrl.1");
//@            } catch(e)
//@            {
//@                
//@            };
//@else
//@end
        }
        bPresenceControlInited = true;
        if (PresenceControlObject)
        {
            PresenceControlObject.OnStatusChange = PresenceControlOnStatusChange;
        }
    }
    return PresenceControlObject;
}

function PresenceControlOnStatusChange(name, state, id)
{
    if (PresenceControlStatesDictionaryObj)
    {
        var img = PresenceControlGetStatusImage(state);
        if (PresenceControlStatesDictionaryObj[id] != state)
        {
            PresenceControlUpdateImage(id, img);
            PresenceControlStatesDictionaryObj[id] = state;
        }
    }
}
    
function PresenceControlShowOOUIMouse()
{
	PresenceControlShowOOUI(0);
}
    
function PresenceControlShowOOUIFocus()
{
	PresenceControlShowOOUI(1);
}

function PresenceControlShowOOUI(inputType)
{
    if (PresenceControlbrowseris.ie5up && PresenceControlbrowseris.win32)
    {
        var obj = window.event.srcElement;
        var objSpan = obj;
        var objOOUI = obj;
        var oouiX = 0, oouiY = 0;
        if (EnsurePresenceControl() && PresenceControlURIDictionaryObj)
        {
            var objRet = PresenceControlGetOOUILocation(obj, false);
         
            objSpan = objRet.objSpan;
            objOOUI = objRet.objOOUI;
            oouiX = objRet.oouiX;
            oouiY = objRet.oouiY;
            var name = PresenceControlURIDictionaryObj[objOOUI.id];
            if (objSpan)
                objSpan.onkeydown = PresenceControlHandleAccelerator;
            PresenceControlObject.ShowOOUI(name, inputType, oouiX, oouiY);
        }
    }
}


function PresenceControlHideOOUI()
{
  PresenceControlObject.HideOOUI();
}
    
function PresenceControlGetStatusImage(state)
{
    var img = "PresenceControlBLANK.GIF";
    switch (state) {
        case 0:
            img = "PresenceControlON.GIF";
            break;
        case 1:
            img = "PresenceControlOFF.GIF";
            break;
        case 2:
            img = "PresenceControlAWAY.GIF";
            break;
        case 3:
            img = "PresenceControlBUSY.GIF";
            break;
        case 4:
            img = "PresenceControlAWAY.GIF";
            break;
        case 5:
            img = "PresenceControlBUSY.GIF";
            break;
        case 6:
            img = "PresenceControlAWAY.GIF";
            break;
        case 9:
            img = "PresenceControlDoNotDisturb.gif";
            break;
        case 10:
            img = "PresenceControlBUSY.GIF";
            break;
        case 16:
            img = "PresenceControlInactive.GIF";
            break;
        case 19:
            img = "PresenceControBusylInactive.PNG";
            break;
    }
    return img;
}
    
function PresenceControlUpdateImage(id, img)
{
    var obj = document.images(id);
    if (obj)
    {
        var oldImg = obj.src;
        var index = oldImg.lastIndexOf("/");
        var newImg = oldImg.slice(0, index + 1);
        newImg += img;
        if (oldImg != newImg)
            obj.src = newImg;
        if (obj.altbase)
        {
            obj.alt = obj.altbase;
        }
    }
}
    
function PresenceControlScroll()
{
    if (!bPresenceControlInScrollFunc)
    {
        bPresenceControlInScrollFunc = true;
        PresenceControlHideOOUI();
    }
    bPresenceControlInScrollFunc = false;
    return PresenceControlOrigScrollFunc ? PresenceControlOrigScrollFunc() : true;   
}

    
function PresenceControl(uri)
{
    // Name Control을 사용할 수 없는 경우 OC를 사용하여 프레즌스를 보여주도록 수정
    if (bOutLook == false)
    {
    	Gumdrop(uri);
	    return;
    }

    if (uri == null || uri == '')
        return;
               
    if (PresenceControlbrowseris.ie5up && PresenceControlbrowseris.win32)
	{
        var obj = window.event.srcElement;
        
        var objSpan = obj;
        var id = obj.id;
        
	    // OC 2007 이 설치되지 않았을 경우 Presence를 표시하지 않음
        if(!bInstall) {
            PresenceControlUpdateImage(id, "PresenceControlBLANK.GIF");
            return;	
    	}

        var fFirst = true;
        
        if (!PresenceControlStatesDictionaryObj)
        {
            PresenceControlStatesDictionaryObj = new Object();
            PresenceControlURIDictionaryObj = new Object();
            if (!PresenceControlOrigScrollFunc )
            {
                PresenceControlOrigScrollFunc = window.onscroll;
                window.onscroll = PresenceControlScroll;
            }
        }
        
        if (PresenceControlStatesDictionaryObj)
        {
            if (!PresenceControlURIDictionaryObj[id])
            {
                PresenceControlURIDictionaryObj[id] = uri;
                fFirst = true;
            }
            if (typeof(PresenceControlStatesDictionaryObj[id]) == "undefined")
            {
                PresenceControlStatesDictionaryObj[id] = 1;
            }
            
            // OnStatusChange 이벤트를 처리하기위해 주석해제
            // 신뢰 사이트 등록으로 해결
            if (fFirst && EnsurePresenceControl() && PresenceControlObject.PresenceEnabled)
            {
                var state = 1, img;
                state = PresenceControlObject.GetStatus(uri, id);
                img = PresenceControlGetStatusImage(state);
                PresenceControlUpdateImage(id, img);
                PresenceControlStatesDictionaryObj[id] = state;

		        if (presenceType != 2) {
			        /////////////////////////////////////////////////////////
			        // Presence 이미지에 Event추가
			        AddPresenceEvt(id);
			        /////////////////////////////////////////////////////////
		        }
            }
	        else if (!PresenceControlObject.PresenceEnabled) { //NameControl.dll 에 Presence가 활성화 되지 않았을 경우 OC Presence 사용	        
		        PresenceStatusInit();
		        bOutLook = false;
		        Gumdrop(uri);
		        return;
	        }
        }

        if (fFirst && presenceType == 2)
        {
            var objRet = PresenceControlGetOOUILocation(obj,false);
            objSpan = objRet.objSpan;

            if (objSpan)
            {
                objSpan.onmouseover = PresenceControlShowOOUIMouse;
                objSpan.onfocusin = PresenceControlShowOOUIFocus;
                objSpan.onmouseout = PresenceControlHideOOUI;
                objSpan.onfocusout = PresenceControlHideOOUI;
            }
        }
     }
}

// IM창 오픈을 위한 처리
function PresenceIM()
{
	var MyID = getSignInName();
	
	// 메신저에 로그인 하지 않은 경우
	if (MyID == "")
	{
		alert("메신저에 로그인 후 대화가 가능합니다.");
		return;
	}

    var obj = window.event.srcElement;        
    var id = obj.id;
	var uri = "";

	// Office 사용자
	if (PresenceControlURIDictionaryObj)
	{
		if (PresenceControlURIDictionaryObj[id])
		{
			uri = PresenceControlURIDictionaryObj[id];

			if (MyID.toLowerCase() == uri.toLowerCase())
			{
				alert("자기 자신에게는 대화 요청을 할 수 없습니다.");
				return;
			}

            // offline이 아닌 경우 IM창을 띄워준다.
            if(!bShowOfflineIM)            
            {
                var state = PresenceControlObject.GetStatus(uri, id);
			    if (state != 1)
			    {
				    btn_OpenCallGroupWindow(uri, "1");
			    }
			    else
			    {
				    alert("대화상대가 메신저에 접속해 있지 않습니다.");
				    return;
			    }
            }
            else 
            {
    			btn_OpenCallGroupWindow(uri, "1");
            }
		}
	}
	else if (GumdropURIDictionaryObj)	// OC 개체 이용 시
	{
		if (GumdropURIDictionaryObj[id])
		{
			uri = GumdropURIDictionaryObj[id];
			var state = 0;
			if (GumdropContactDictionaryObj[id])
			{
				var Contact = GumdropContactDictionaryObj[id];
				state = Contact.Status;
			}

			if (MyID.toLowerCase() == uri.toLowerCase())
			{
				alert("자기 자신에게는 대화 요청을 할 수 없습니다.");
				return;
			}

            // offline이 아닌 경우 IM창을 띄워준다.
            if(!bShowOfflineIM)            
            {
                var state = PresenceControlObject.GetStatus(uri, id);
			    // 0:unknown, 6:Offline
			    if (state != 0 && state != 1 && state != 6)
			    {
				    btn_OpenCallGroupWindow(uri, "1");
			    }
			    else
			    {
				    alert("대화상대가 메신저에 접속해 있지 않습니다.");
				    return;
			    }
            }
            else 
            {
    			btn_OpenCallGroupWindow(uri, "1");
            }
		}
	}
}

function ConvertKoreanByStatusText(statusText) {
    var kText = statusText;
    switch (statusText.toUpperCase()) {
        case "AVAILABLE":
            kText = "대화 가능";
            break;
        case "OFFLINE":
            kText = "오프라인";
            break;
        case "BUSY":
            kText = "다른 용무 중";
            break;
        case "DO NOT DISTURB":
            kText = "방해 금지";
            break;
        case "BE RIGHT BACK":
            kText = "곧 돌아오겠음";
            break;
        case "AWAY":
            kText = "자리 비움";
            break;
        case "INACTIVE":
            kText = "대화 불가능";
            break;
        case "ON A PHONE":
            kText = "통화 중";
            break;
        case "IN A CONFERENCE":
            kText = "전화 회의 중";
            break;
        case "UNKNOWN":
            kText = "알 수 없음";
    }

    return kText;
}

function PresenceAltUpdate(imgobj, sid) {
    var oPersona = null;
    try {
        // 풍선도움말에 상태정보 삽입
        oPersona = new ActiveXObject("PersonaControls.Persona");
        oPersona.SipUri = sid;
        imgobj.alt = ConvertKoreanByStatusText(oPersona.StatusText);
        oPersona.ReleaseOC();
        oPersona = null;    
    } catch(e) {
        if(imgobj != undefined && imgobj != null) {
            imgobj.alt = "알 수 없음";
        }
        oPersona = null;
    }
}

// 아이콘 업데이트
function PresenceImageUpdate()
{
	var obj = window.event.srcElement;
	var id = obj.id;	
	var uri = "";
	// Office 사용자
	if (PresenceControlURIDictionaryObj)
	{
		if (PresenceControlURIDictionaryObj[id])
		{
			uri = PresenceControlURIDictionaryObj[id];
	        var state = 1, img;
	        PresenceAltUpdate(obj, uri);
			state = PresenceControlObject.GetStatus(uri, id);
			img = PresenceControlGetStatusImage(state);
			PresenceControlUpdateImage(id, img);
			PresenceControlStatesDictionaryObj[id] = state;
		}
	}
	else if (GumdropContactDictionaryObj)	// OC 개체 이용 시
	{
		if (GumdropContactDictionaryObj[id])
		{
			var Contact = GumdropContactDictionaryObj[id];
		    PresenceAltUpdate(obj, GumdropURIDictionaryObj[id]);

			var state = 0, img;

			try
			{
				state = Contact.Status;
				img = GumdropGetStatusImage(state);
				GumdropUpdateImage(id, img);
			}
			catch (e)
			{
				//If the contact is not valid, then just mark the state
				//as unknown.
				img = GumdropGetStatusImage(state);
				GumdropUpdateImage(id, img);
			}
		}
	}
}

// OC 로그인 사용자
var g_StoreMyID = "";
function getSignInName()
{
	var MyID = "";
	var oPersona = null;

	if (g_StoreMyID == "")
	{
		try {
			oPersona = new ActiveXObject("PersonaControls.Persona");
			MyID = oPersona.MySignInName();
			oPersona.ReleaseOC();
			oPersona = null;

			g_StoreMyID = MyID;

		} catch (e) {
		    oPersona = null;
		    MyID = "";
		}
	}
	else
	{
		MyID = g_StoreMyID;
	}

	return MyID;
}

// 휴대폰 (1명)
function btn_OpenCallMobileWindow(pUri)
{
    var oPersona = null;
	try {
		oPersona = new ActiveXObject("PersonaControls.Persona");
	    oPersona.SipUri = pUri;
		oPersona.OpenCallMobileWindow();
		this.blur();
		oPersona.ReleaseOC();
		oPersona = null;
	} catch (e) {
	    oPersona = null;
	}
}

// 회사전화 (1명)
function btn_OpenCallWorkWindow(pUri)
{
    var oPersona = null;
	try {
		oPersona = new ActiveXObject("PersonaControls.Persona");
		oPersona.SipUri = pUri;
		oPersona.OpenCallWorkWindow();
		this.blur();
		oPersona.ReleaseOC();
		oPersona = null;
	} catch (e) {
	    oPersona = null;
	}
}

// 집전화 (1명)
function btn_OpenCallHomeWindow(pUri)
{
    var oPersona = null;
	try {
		oPersona = new ActiveXObject("PersonaControls.Persona");
		oPersona.SipUri = pUri;
		oPersona.OpenCallHomeWindow();
		this.blur();
		oPersona.ReleaseOC();
		oPersona = null;
	} catch (e) {
	    oPersona = null;
	}
}

// 대화상대추가 (1명)
function btn_AddContact(pUri) {
    var oPersona = null;
    try {
        oPersona = new ActiveXObject("PersonaControls.Persona");
        oPersona.AddContact(pUri);
        this.blur();
        oPersona.ReleaseOC();
        oPersona = null;
    }
    catch (e) { 
        oPersona = null;
    }
}

// 여러명이 동시에
//  1: IM		eunkyu@kaoni.com;best2258@kaoni.com (";" 구분자로 넘겨준다.)
//  2: Phone		5886;5912 (SIP URI 에 맵핑되어야 한다.)
//  8: Audio(communicator)		eunkyu@kaoni.com;best2258@kaoni.com (";" 구분자로 넘겨준다.)
// 16: Video(communicator)		eunkyu@kaoni.com;best2258@kaoni.com (";" 구분자로 넘겨준다.)
function btn_OpenCallGroupWindow(pUri, pFlag)
{
	var oPersona = null;
	try {
		if (pUri == "" || pFlag == "")
			return;


		// SIP주소인 경우 앞에 "sip:" 이 붙도록 처리
		var pSipUri = "";
		var pArr = pUri.split(";");
		for (var i=0; i<pArr.length; i++)
		{
			var temp = pArr[i].toLowerCase();
			// @문자가 포함된 경우
			if (temp.indexOf("@") >= 0)
			{
				// sip: + 주소 형태로 변경
				if (temp.indexOf("sip:") < 0)
					temp = "sip:" + temp;
			}

			pSipUri = pSipUri + temp;
			if (i != pArr.length-1)
				pSipUri = pSipUri + ";";
		}


		oPersona = new ActiveXObject("PersonaControls.Persona");
		oPersona.OpenCallGroupWindow(pSipUri, pFlag);
		this.blur();
		oPersona.ReleaseOC();
		oPersona = null;
	} catch (e) {
	    oPersona = null;
	}
}

// 전자메일을 보내는 메소드
function btn_OpenSendEMail(pUri)
{
    var email = "";
    var oPersona = null;
    try {
        email = "";
        oPersona = new ActiveXObject("PersonaControls.Persona");
        oPersona.SipUri = pUri;
        email = oPersona.EMail;
        this.blur();
        oPersona.ReleaseOC();
        oPersona = null;
        
        if(email != "") {
            document.location.href = "mailto:" + email;
        }
    } catch(e) {
        oPersona = null;
    }
}

// 이미지에 이벤트 추가
function AddPresenceEvt(id)
{
	var oimg = document.images(id);
	if (oimg)
	{
		oimg.style.cursor = "hand";
		oimg.onmouseover = PresenceImageUpdate;
		oimg.onmouseout = HideLayer;
		oimg.onclick= ViewContext;
	}
}

// Context Menu를 보여주기 위한 처리
function ViewContext()
{
	var MyID = getSignInName();
	
	// 메신저에 로그인 하지 않은 경우
	if (MyID == "")
	{
		alert("메신저에 로그인 후 대화가 가능합니다.");
		return;
	}

    var obj = window.event.srcElement;        
    var id = obj.id;
	var uri = "";

	// Office 사용자
	if (PresenceControlURIDictionaryObj)
	{
		if (PresenceControlURIDictionaryObj[id])
		{
			uri = PresenceControlURIDictionaryObj[id];

			CreateLayer(uri, MyID);
		}
	}
	else if (GumdropURIDictionaryObj)	// OC 개체 이용 시
	{
		if (GumdropURIDictionaryObj[id])
		{
			uri = GumdropURIDictionaryObj[id];

			CreateLayer(uri, MyID);
		}
	}
}

function CreateLayer(uri, MyID)
{
    var oPersona = null;
    var FriendlyName = null;
    var Mobile = null;
    var WorkPhone = null;
    var HomePhone = null;
    
    try {
        oPersona = new ActiveXObject("PersonaControls.Persona");
        oPersona.SipUri = uri;
	    FriendlyName = oPersona.FriendlyName;
	    Mobile = CheckPhoneNumber(oPersona.Mobile);
	    WorkPhone = CheckPhoneNumber(oPersona.WorkPhone);
	    HomePhone = CheckPhoneNumber(oPersona.HomePhone);
	    oPersona.ReleaseOC();
	    oPersona = null;
    } catch(e) {
        oPersona = null;
        alert(e.message);
        return;
    }
    
	var bUse = true;
	// 내부 사용자가 아닌 경우
	if (uri.toLowerCase() == FriendlyName.toLowerCase())
	{
		bUse = false;
	}
	// 본인인 경우
	if (MyID.toLowerCase() == uri.toLowerCase())
	{
		bUse = false;
	}
	
	if(contextMenuType == 1) 
	{
	    var oouiX = 0;
	    var oouiY = 0;
	    var table_width = 160;
	    var table_height = 160;

	    // 전화번호가 없는 경우 table 사이즈를 줄인다.
	    if (Mobile == "")
		    table_height = table_height - 10;
	    if (WorkPhone == "")
		    table_height = table_height - 10;
	    if (HomePhone == "")
		    table_height = table_height - 10;
	    // IM, A/V 메뉴를 보여지지 않는 경우
	    if (bUse == false)
		    table_height = table_height - 80;


	    oouiX = event.clientX+truebody().scrollLeft;
	    oouiY = event.clientY+truebody().scrollTop;

	    // layer가 스크롤 아래로 내려가지 않도록 처리
	    if (event.clientY > truebody().clientHeight - table_height) {
	        oouiY = oouiY - table_height;
	    }
	    else {
	        oouiY = oouiY - 5;
	    }

	    // layer가 스크롤 오른쪽으로 넘어가지 않도록 처리
	    if (event.clientX > truebody().clientWidth - table_width) {
	        oouiX = oouiX - table_width;
	    }
	    else {
	        oouiX = oouiX - 5;
	    }


	    if (!g_newlayer)
	    {
		    g_newlayer = document.createElement('<div id="ContextMenu" style="position:absolute;z-index:1000;color:navy;display:inline;font-size:10pt;font-family:gulim;font-weight:bold;" onclick="this.style.display=\'none\';" onmouseout="this.style.display=\'none\';" onmouseover="this.style.display=\'\';"></div>');
	    }
    	
	    g_newlayer.style.left = oouiX + 'px';
	    g_newlayer.style.top = oouiY + 'px';
	    g_newlayer.style.display = "inline";

	    var menu_txt = "font-family: dotum,arial,verdana;font-size:9pt;color: #000000;vertical-align: middle;padding:4 0 0 20px;background-image:url(/images/ezOCS/ContextMenu/bullet.gif);background-position:left;background-repeat:no-repeat;";
	    var menu_box = "background-color:#f6f6f6; border-style:solid; border-width:1px; border-color:#6593cf;";
	    var menu_line = "background-image:url(/images/ezOCS/ContextMenu/line.gif); background-position:left;background-repeat:no-repeat;";

	    var strHTML = '<table width="' + table_width + '" height="' + table_height + '" border="0" cellpadding="2" cellspacing="0" style="' + menu_box + '">';
	    strHTML += '<tr><td onclick="show_personinfo(\'' + uri + '\')" style="' + menu_txt + '">' + FriendlyName + '</td></tr>';
	    strHTML += '<tr><td style="' + menu_line + '"></td></tr>';
	    if (bUse == true)
	    {
		    strHTML += '<tr onclick="btn_OpenCallGroupWindow(\'' + uri + '\', \'1\')"><td style="' + menu_txt + '">Instant Message</td></tr>';
		    strHTML += '<tr><td style="' + menu_line + '"></td></tr>';
		    strHTML += '<tr onclick="btn_OpenCallGroupWindow(\'' + uri + '\', \'8\')"><td style="' + menu_txt + '">Audio Call</td></tr>';
		    strHTML += '<tr><td style="' + menu_line + '"></td></tr>';
		    strHTML += '<tr onclick="btn_OpenCallGroupWindow(\'' + uri + '\', \'16\')"><td style="' + menu_txt + '">Video Call</td></tr>';
		    strHTML += '<tr><td style="' + menu_line + '"></td></tr>';
    	    strHTML += '<tr onclick="btn_OpenSendEMail(\'' + uri + '\')"><td style="' + menu_txt + '">Send EMail</td></tr>';
		    strHTML += '<tr><td style="' + menu_line + '"></td></tr>';

	    }
	    if (Mobile != "")
	    {
		    strHTML += '<tr onclick="btn_OpenCallMobileWindow(\'' + Mobile + '\')"><td style="' + menu_txt + '">Mobile: ' + Mobile + '</td></tr>';
		    strHTML += '<tr><td style="' + menu_line + '"></td></tr>';
	    }
	    if (WorkPhone != "")
	    {
		    strHTML += '<tr onclick="btn_OpenCallWorkWindow(\'' + WorkPhone + '\')"><td style="' + menu_txt + '">Work: ' + WorkPhone + '</td></tr>';
		    strHTML += '<tr><td style="' + menu_line + '"></td></tr>';
	    }
	    if (HomePhone != "")
	    {
		    strHTML += '<tr onclick="btn_OpenCallHomeWindow(\'' + HomePhone + '\')"><td style="' + menu_txt + '">Home: ' + HomePhone + '</td></tr>';
		    strHTML += '<tr><td style="' + menu_line + '"></td></tr>';
	    }
	    if (bUse == true) {
		    strHTML += '<tr onclick="btn_AddContact(\'' + uri + '\')"><td style="' + menu_txt + '">대화상대추가</td></tr>';
		    strHTML += '<tr><td style="' + menu_line + '"></td></tr>';
	    }
	    strHTML += '</table>';

	    g_newlayer.innerHTML = ''
	    g_newlayer.innerHTML = g_newlayer.innerHTML + strHTML;
	    g_newlayer.style.cursor = "hand";
	    document.body.insertBefore(g_newlayer);
	}
	else if (contextMenuType == 2) {
	    var oouiX = 0;
	    var oouiY = 0;
	    var table_width = 185;
	    var table_height = 215;

	    // 전화번호가 없는 경우 table 사이즈를 줄인다.
	    if (Mobile == "")
		    table_height = table_height - 30;
	    if (WorkPhone == "")
		    table_height = table_height - 30;
	    if (HomePhone == "")
		    table_height = table_height - 30;
	    // IM, A/V 메뉴를 보여지지 않는 경우
	    if (bUse == false)
		    table_height = table_height - 180;


	    oouiX = event.clientX+truebody().scrollLeft;
	    oouiY = event.clientY+truebody().scrollTop;

	    // layer가 스크롤 아래로 내려가지 않도록 처리
	    if (event.clientY > truebody().clientHeight - table_height) {
	        oouiY = oouiY - table_height;
	    }
	    else {
	        oouiY = oouiY - 5;
	    }

	    // layer가 스크롤 오른쪽으로 넘어가지 않도록 처리
	    if (event.clientX > truebody().clientWidth - table_width) {
	        oouiX = oouiX - table_width;
	    }
	    else {
	        oouiX = oouiX - 5;
	    }

	    if (!g_newlayer)
	    {
		    g_newlayer = document.createElement('<div id="ContextMenu" style="position:absolute;z-index:1000;font-family:dotum; font-size:9pt; color:#333333;display:inline;" onclick="this.style.display=\'none\';" onmouseout="this.style.display=\'none\';" onmouseover="this.style.display=\'\';"></div>');
	    }
    	
	    g_newlayer.style.left = oouiX + 'px';
	    g_newlayer.style.top = oouiY + 'px';
	    g_newlayer.style.display = "inline";

	    var menu_txt = "padding-left:10px;";
	    var menu_txt_bold = "padding-left:10px; font-weight: bold;";
	    var menu_box = "border:1px solid #d7d7d7;background-color:White;font-size:9pt;";
	    var menu_icon = "text-align:center; background-color:#ecf1f3; width:24px; height:22px;";
        var menu_line = "padding-left:10px; font-size:1px; color:#8c99aa; height:3px;";
        
	    var strHTML = '<table width="' + table_width + '" border="0" cellpadding="0" cellspacing="0" style="' + menu_box + '">';	    
	    strHTML += '<tr><td bgcolor="#ecf1f3"></td><td height="4px"></td></tr>';
	    
	    // Contact Name
	    strHTML += '<tr onclick="show_personinfo(\'' + uri + '\')"><td style="' + menu_icon + '"><img src="/images/ezOCS/ContextMenu/user.png" /></td><td style="' + menu_txt + '">' + FriendlyName + '</td></tr>';
	    
	    if (bUse == true)
	    {
	        // Instance Message
	        strHTML += '<tr onclick="btn_OpenCallGroupWindow(\'' + uri + '\', \'1\')"><td style="' + menu_icon + '"><img src="/images/ezOCS/ContextMenu/user_comment.png" /></td><td style="' + menu_txt + '">인스턴트 메시지 보내기</td></tr>';
	        
	        // bar
	        strHTML += '<tr><td bgcolor="#ecf1f3"></td><td style="' + menu_line + '">──────────────────────────────────────────────────────────────────</td></tr>';
	        
	        if (WorkPhone != "")
	        {
	            //WorkPhone
		        strHTML += '<tr onclick="btn_OpenCallWorkWindow(\'' + WorkPhone + '\')"><td rowspan="2" style="' + menu_icon + '"><img src="/images/ezOCS/ContextMenu/building.png" /></td></tr>';
		        strHTML += '<tr onclick="btn_OpenCallWorkWindow(\'' + WorkPhone + '\')"><td style="' + menu_txt + '"><b>회사: </b>' + WorkPhone + '</td></tr>';
		        strHTML += '<tr><td bgcolor="#ecf1f3"></td><td height="1px"></td></tr>';
	        }
	        
	        if (Mobile != "")
	        {
	            //Mobile
	            strHTML += '<tr onclick="btn_OpenCallMobileWindow(\'' + Mobile + '\')"><td rowspan="2" style="' + menu_icon + '"><img src="/images/ezOCS/ContextMenu/phone.png" /></td></tr>';
		        strHTML += '<tr onclick="btn_OpenCallMobileWindow(\'' + Mobile + '\')"><td style="' + menu_txt + '"><b>휴대폰: </b>' + Mobile + '</td></tr>';
		        strHTML += '<tr><td bgcolor="#ecf1f3"></td><td height="1px"></td></tr>';
	        }
	        
	        if (HomePhone != "")
	        {
	            //HomePhone
	            strHTML += '<tr onclick="btn_OpenCallHomeWindow(\'' + HomePhone + '\')"><td rowspan="2" style="' + menu_icon + '"><img src="/images/ezOCS/ContextMenu/house.png" /></td></tr>';
		        strHTML += '<tr onclick="btn_OpenCallHomeWindow(\'' + HomePhone + '\')"><td style="' + menu_txt + '"><b>집: </b>' + HomePhone + '</td></tr>';
	        }
	        
	        // Communicator 통화
	        strHTML += '<tr onclick="btn_OpenCallGroupWindow(\'' + uri + '\', \'8\')"><td style="' + menu_icon + '"><img src="/images/ezOCS/ContextMenu/telephone_go.png" /></td><td style="' + menu_txt_bold + '">Communicator 통화 </td></tr>';
	        
	        // bar
	        strHTML += '<tr><td bgcolor="#ecf1f3"></td><td style="' + menu_line + '">──────────────────────────────────────────────────────────────────</td></tr>';
	        
	        // 화상 통화
	        strHTML += '<tr onclick="btn_OpenCallGroupWindow(\'' + uri + '\', \'16\')"><td style="' + menu_icon + '"><img src="/images/ezOCS/ContextMenu/webcam.png" /></td><td style="' + menu_txt + '">화상 통화 시작 </td></tr>';
	        
	        // 전자 메일 메시지
	        strHTML += '<tr onclick="btn_OpenSendEMail(\'' + uri + '\')"><td style="' + menu_icon + '"><img src="/images/ezOCS/ContextMenu/email_edit.png" /></td><td style="' + menu_txt + '">전자 메일 메시지 보내기 </td></tr>';
	        
	        // bar
	        strHTML += '<tr><td bgcolor="#ecf1f3"></td><td style="' + menu_line + '">──────────────────────────────────────────────────────────────────</td></tr>';
	        
	        // 대화상대 목록에 추가
	        strHTML += '<tr onclick="btn_AddContact(\'' + uri + '\')"><td style="' + menu_icon + '"><img src="/images/ezOCS/ContextMenu/add.png" /></td><td style="' + menu_txt + '">대화상대 목록에 추가 </td></tr>';
	        strHTML += '<tr><td bgcolor="#ecf1f3"></td><td height="1px"></td></tr>';
	    }

	    strHTML += '</table>';

	    g_newlayer.innerHTML = ''
	    g_newlayer.innerHTML = g_newlayer.innerHTML + strHTML;
	    g_newlayer.style.cursor = "hand";
	    document.body.insertBefore(g_newlayer);
	}
}

function HideLayer()
{
	try {
		document.all("ContextMenu").style.display = "none";
	} catch (e) {}
}

function truebody()
{ 
	return (document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body
}

function CheckPhoneNumber(pNumber)
{
	var PhoneNumber = pNumber;

	if (PhoneNumber != "")
	{
		if (PhoneNumber.indexOf("+") == -1)
			PhoneNumber = "+" + PhoneNumber;
	}

	return PhoneNumber;
}

// 사용자 정보 보여주기
function show_personinfo(pSIP)
{
    var email = "";
    var oPersona = null;
    try {
        oPersona = new ActiveXObject("PersonaControls.Persona");
        oPersona.SipUri = pSIP;
        email = oPersona.EMail;
        oPersona.ReleaseOC();
        oPersona = null;
        
        if (email != "")
	    {
	        if(bGroupwarePresence) {
	            window.open("/myoffice/common/showpersoninfo.aspx?email=" + escape(email), "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
	        }
	        else {
	            window.open("/myoffice/ezOCS/Organinfo/ShowPersonInfo.aspx?email=" + escape(email), "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
	        }
	    }
    } catch(e){
        oPersona = null;
        alert(e.message);
    }
}

function PresenceControlHandleAccelerator()
{
    if (PresenceControlObject)
    {
       if (event.altKey && event.shiftKey &&
            event.keyCode==121)
        {
           PresenceControlObject.DoAccelerator();
        }
    }
}

function PresenceControlGetOOUILocation(obj, fprint)
{
    var objRet = new Object;
    var objSpan = obj;
    var objOOUI = obj;
    var oouiX = 0, oouiY = 0, objDX = 0;
    var fRtl = document.dir == "rtl";
    while (objSpan && objSpan.tagName != "SPAN" && objSpan.tagName != "TABLE")
    {
        objSpan = objSpan.parentNode;
    }
    if (objSpan)
    {
       var collNodes = objSpan.tagName == "TABLE" ?
                       objSpan.rows(0).cells(0).childNodes :
                       objSpan.childNodes;
       var i;
       for (i = 0; i < collNodes.length; ++i)
       {   
           if (collNodes.item(i).tagName == "IMG" && collNodes.item(i).id)
           {
               objOOUI = collNodes.item(i);
               break;
           }
       }
    }
    obj = objOOUI;
    while (obj)
    {
        if (fRtl)
        {
             if (obj.scrollWidth >= obj.clientWidth + obj.scrollLeft)        
                  objDX = obj.scrollWidth - obj.clientWidth - obj.scrollLeft;             
             else
                  objDX = obj.clientWidth + obj.scrollLeft - obj.scrollWidth;
             oouiX += obj.offsetLeft + objDX;
        }
        else
            oouiX += obj.offsetLeft - obj.scrollLeft;
        oouiY += obj.offsetTop - obj.scrollTop;
    if (fprint)
    {
    alert(obj.scrollTop);
    }
        
        obj = obj.offsetParent;            
    }
    try
    {
        obj = window.frameElement;
        while (obj)
        {
            if (fRtl)
            {
                if (obj.scrollWidth >= obj.clientWidth + obj.scrollLeft)        
                    objDX = obj.scrollWidth - obj.clientWidth - obj.scrollLeft;             
                else
                    objDX = obj.clientWidth + obj.scrollLeft - obj.scrollWidth;
                oouiX += obj.offsetLeft + objDX;
            }
            else
                oouiX += obj.offsetLeft - obj.scrollLeft;
            oouiY += obj.offsetTop - obj.scrollTop;
    if (fprint)
    {
    alert(obj.scrollTop);
    }
            
            obj = obj.offsetParent;
        }
    } catch(e)
    {
    };

    objRet.objSpan = objSpan;
    objRet.objOOUI = objOOUI;
    objRet.oouiX = oouiX;
    objRet.oouiY = oouiY;
    if (fRtl)
        objRet.oouiX += objOOUI.offsetWidth;
        
    if (fprint)
    {
    alert(oouiY);
    }
        
    return objRet;
}
   
function PresenceControlBrowseris () 
{
	try
	{
		var agt = navigator.userAgent.toLowerCase();
	        this.osver = 1.0;
	        if (agt)
	        {
	            var stOSVer = agt.substring(agt.indexOf("windows ") + 11);
		    this.osver = parseFloat(stOSVer);
	        }
        
		this.major = parseInt(navigator.appVersion);
		this.nav = ((agt.indexOf('mozilla')!=-1)&&((agt.indexOf('spoofer')==-1) && (agt.indexOf('compatible')==-1)));
	 	this.nav2 = (this.nav && (this.major == 2));
		this.nav3 = (this.nav && (this.major == 3));
		this.nav4 = (this.nav && (this.major == 4));
		this.nav6 = this.nav && (this.major == 5);
		this.nav6up = this.nav && (this.major >= 5);
		this.nav7up = false;
		if (this.nav6up)
		{
			var navIdx = agt.indexOf("netscape/");
			if (navIdx >=0 )
				this.nav7up = parseInt(agt.substring(navIdx+9)) >= 7;
		}
		this.ie = (agt.indexOf("msie")!=-1);
		this.aol = this.ie && agt.indexOf(" aol ")!=-1;
		if (this.ie)
			{
			var stIEVer = agt.substring(agt.indexOf("msie ") + 5);
			this.iever = parseInt(stIEVer);
			this.verIEFull = parseFloat(stIEVer);
			}
		else
			this.iever = 0;
		this.ie3 = ( this.ie && (this.major == 2));
		this.ie4 = ( this.ie && (this.major == 4));
		this.ie4up = this.ie && (this.major >=4);
		this.ie5up = this.ie && (this.iever >= 5);
		this.ie55up = this.ie && (this.verIEFull >= 5.5);
		this.ie6up = this.ie && (this.iever >= 6);
	    this.win16 = ((agt.indexOf("win16")!=-1)
	               || (agt.indexOf("16bit")!=-1) || (agt.indexOf("windows 3.1")!=-1)
	               || (agt.indexOf("windows 16-bit")!=-1) );
	    this.win31 = (agt.indexOf("windows 3.1")!=-1) || (agt.indexOf("win16")!=-1) ||
	                 (agt.indexOf("windows 16-bit")!=-1);
	    this.win98 = ((agt.indexOf("win98")!=-1)||(agt.indexOf("windows 98")!=-1));
	    this.win95 = ((agt.indexOf("win95")!=-1)||(agt.indexOf("windows 95")!=-1));
	    this.winnt = ((agt.indexOf("winnt")!=-1)||(agt.indexOf("windows nt")!=-1));
	    this.win32 = this.win95 || this.winnt || this.win98 || 
	                 ((this.major >= 4) && (navigator.platform == "Win32")) ||
	                 (agt.indexOf("win32")!=-1) || (agt.indexOf("32bit")!=-1);
	    this.os2   = (agt.indexOf("os/2")!=-1) 
	                 || (navigator.appVersion.indexOf("OS/2")!=-1)  
	                 || (agt.indexOf("ibm-webexplorer")!=-1);
	    this.mac    = (agt.indexOf("mac")!=-1);
	    this.mac68k = this.mac && ((agt.indexOf("68k")!=-1) || 
	                               (agt.indexOf("68000")!=-1));
	    this.macppc = this.mac && ((agt.indexOf("ppc")!=-1) || 
        	                       (agt.indexOf("powerpc")!=-1));
	    this.w3c = this.nav6up;
	}
	catch(ex)
	{}
}

// SIG // Begin signature block
// SIG // MIIaKgYJKoZIhvcNAQcCoIIaGzCCGhcCAQExCzAJBgUr
// SIG // DgMCGgUAMGcGCisGAQQBgjcCAQSgWTBXMDIGCisGAQQB
// SIG // gjcCAR4wJAIBAQQQEODJBs441BGiowAQS9NQkAIBAAIB
// SIG // AAIBAAIBAAIBADAhMAkGBSsOAwIaBQAEFP9Pa/IbB4wX
// SIG // y/rWpP+MsDMOXm4ZoIIUvDCCArwwggIlAhBKGdI4jIJZ
// SIG // HKVdc18VXdyjMA0GCSqGSIb3DQEBBAUAMIGeMR8wHQYD
// SIG // VQQKExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMRcwFQYD
// SIG // VQQLEw5WZXJpU2lnbiwgSW5jLjEsMCoGA1UECxMjVmVy
// SIG // aVNpZ24gVGltZSBTdGFtcGluZyBTZXJ2aWNlIFJvb3Qx
// SIG // NDAyBgNVBAsTK05PIExJQUJJTElUWSBBQ0NFUFRFRCwg
// SIG // KGMpOTcgVmVyaVNpZ24sIEluYy4wHhcNOTcwNTEyMDAw
// SIG // MDAwWhcNMDQwMTA3MjM1OTU5WjCBnjEfMB0GA1UEChMW
// SIG // VmVyaVNpZ24gVHJ1c3QgTmV0d29yazEXMBUGA1UECxMO
// SIG // VmVyaVNpZ24sIEluYy4xLDAqBgNVBAsTI1ZlcmlTaWdu
// SIG // IFRpbWUgU3RhbXBpbmcgU2VydmljZSBSb290MTQwMgYD
// SIG // VQQLEytOTyBMSUFCSUxJVFkgQUNDRVBURUQsIChjKTk3
// SIG // IFZlcmlTaWduLCBJbmMuMIGfMA0GCSqGSIb3DQEBAQUA
// SIG // A4GNADCBiQKBgQDTLiDwaHwsLS6BHLEGsqcLtxENV9pT
// SIG // 2HXjyTMqstT2CVs08+mQ/gkM0NsbWrnN5/aIsZ3AhyXr
// SIG // fVgQc2p4y3EV/cZY9imrWF6WBP0tYhFYgRzKcZTVIlgv
// SIG // 1cwUBYQ2upSqtE1K6e47Iq1WmX4hnGyGwEpHl2q0pjbV
// SIG // /Akt07Q5mwIDAQABMA0GCSqGSIb3DQEBBAUAA4GBAGFV
// SIG // Dj57x5ISfhEQjiLM1LMTK1voROQLeJ6kfvOnB3Ie4lnv
// SIG // zITjiZRM205h77Ok+0Y9UDQLn3BW9o4qfxfO5WO/eWkH
// SIG // cy6wlSiK9e2qqdJdzQrKEAmPzrOvKJbEeSmEktz/umdC
// SIG // SKaQEOS/YficU+WT0XM/+P2dT4SsVdH9EWNjMIIEAjCC
// SIG // A2ugAwIBAgIQCHptXG9ik0+6xP1D4RQYnTANBgkqhkiG
// SIG // 9w0BAQQFADCBnjEfMB0GA1UEChMWVmVyaVNpZ24gVHJ1
// SIG // c3QgTmV0d29yazEXMBUGA1UECxMOVmVyaVNpZ24sIElu
// SIG // Yy4xLDAqBgNVBAsTI1ZlcmlTaWduIFRpbWUgU3RhbXBp
// SIG // bmcgU2VydmljZSBSb290MTQwMgYDVQQLEytOTyBMSUFC
// SIG // SUxJVFkgQUNDRVBURUQsIChjKTk3IFZlcmlTaWduLCBJ
// SIG // bmMuMB4XDTAxMDIyODAwMDAwMFoXDTA0MDEwNjIzNTk1
// SIG // OVowgaAxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8w
// SIG // HQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTsw
// SIG // OQYDVQQLEzJUZXJtcyBvZiB1c2UgYXQgaHR0cHM6Ly93
// SIG // d3cudmVyaXNpZ24uY29tL3JwYSAoYykwMTEnMCUGA1UE
// SIG // AxMeVmVyaVNpZ24gVGltZSBTdGFtcGluZyBTZXJ2aWNl
// SIG // MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
// SIG // wHphh+uypwNjGysaYd6AtxUdoIuQPbsnkoQUOeuFzimS
// SIG // BmZIpANPjehPp/CvXtEvGceR8bWee5Ehzun/407w/K+V
// SIG // WLhjLeaO9ikYzXCOUMPtlrtA274l6EJV1vaF8gbni5kc
// SIG // MfMDD9RMnCQq3Bsbj4LzsO+nTeMUp+CP1sdowmFYqXLU
// SIG // +DBIT9kvb2Mg2YnKgnvCS7woxYFo5+aCQKxGOqD5PzbN
// SIG // TLtUQlp6ZXv+hOTHR1SsuT3sgMca98QzgYHJKpX7f146
// SIG // h5AU28wudfLva+Y9qWC+QgGqT6pbqD8iMZ8SFflzoR6C
// SIG // iwQr6kYCTG2PH1AulUsqeAaEdD2RjyxHMQIDAQABo4G4
// SIG // MIG1MEAGCCsGAQUFBwEBBDQwMjAwBggrBgEFBQcwAYYk
// SIG // aHR0cDovL29jc3AudmVyaXNpZ24uY29tL29jc3Avc3Rh
// SIG // dHVzMAkGA1UdEwQCMAAwRAYDVR0gBD0wOzA5BgtghkgB
// SIG // hvhFAQcBATAqMCgGCCsGAQUFBwIBFhxodHRwczovL3d3
// SIG // dy52ZXJpc2lnbi5jb20vcnBhMBMGA1UdJQQMMAoGCCsG
// SIG // AQUFBwMIMAsGA1UdDwQEAwIGwDANBgkqhkiG9w0BAQQF
// SIG // AAOBgQAt809jYCwY2vUkD1KzDOuzvGeFwiPtj0YNzxpN
// SIG // vvN8eiAwMhhoi5K7Mpnwk7g7FQYnez4CBgCkIZKEEwrF
// SIG // mOVAV8UFJeivrxFqqeU7y+kj9pQpXUBV86VTncg2Ojll
// SIG // CHNzpDLSr6y/xwU8/0Xsw+jaJNHOY64Jp/viG+P9QQpq
// SIG // ljCCBBIwggL6oAMCAQICDwDBAIs8PIgR0T72Y+zfQDAN
// SIG // BgkqhkiG9w0BAQQFADBwMSswKQYDVQQLEyJDb3B5cmln
// SIG // aHQgKGMpIDE5OTcgTWljcm9zb2Z0IENvcnAuMR4wHAYD
// SIG // VQQLExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xITAfBgNV
// SIG // BAMTGE1pY3Jvc29mdCBSb290IEF1dGhvcml0eTAeFw05
// SIG // NzAxMTAwNzAwMDBaFw0yMDEyMzEwNzAwMDBaMHAxKzAp
// SIG // BgNVBAsTIkNvcHlyaWdodCAoYykgMTk5NyBNaWNyb3Nv
// SIG // ZnQgQ29ycC4xHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jw
// SIG // b3JhdGlvbjEhMB8GA1UEAxMYTWljcm9zb2Z0IFJvb3Qg
// SIG // QXV0aG9yaXR5MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
// SIG // MIIBCgKCAQEAqQK9wXDmO/JOGyifl3heMOqiqY0lX/j+
// SIG // lUyjt/6doiA+fFGim6KPYDJr0UJkee6sdslU2vLrnIYc
// SIG // j5+EZrPFa3piI9YdPN4PAZLolsS/LWaammgmmdA6LL8M
// SIG // tVgmwUbnCj44liypKDmo7EmDQuOED7uabFVhrIJ8oWAt
// SIG // d0zpmbRkO5pQHDEIJBSfqeeRKxjmPZhjFGBYBWWfHTdS
// SIG // h/en75QCxhvTv1VFs4mAvzrsVJROrv2nem10Tq8YzJYJ
// SIG // KCEAV5BgaTe7SxIHPFb/W/ukZgoIptKBVlfvtjteFoF3
// SIG // BNr2vq6Alf6wzX/WpxpyXDzKvPAIoyIwswaFybMgdxOF
// SIG // 3wIDAQABo4GoMIGlMIGiBgNVHQEEgZowgZeAEFvQcO9p
// SIG // cp4jUX4Usk2O/8uhcjBwMSswKQYDVQQLEyJDb3B5cmln
// SIG // aHQgKGMpIDE5OTcgTWljcm9zb2Z0IENvcnAuMR4wHAYD
// SIG // VQQLExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xITAfBgNV
// SIG // BAMTGE1pY3Jvc29mdCBSb290IEF1dGhvcml0eYIPAMEA
// SIG // izw8iBHRPvZj7N9AMA0GCSqGSIb3DQEBBAUAA4IBAQCV
// SIG // 6AvAjfOXGDXtuAEk2HcR81xgMp+eC8s+BZGIj8k65iHy
// SIG // 8FeTLLWgR8hi7/zXzDs7Wqk2VGn+JG0/ycyq3gV83TGN
// SIG // PZ8QcGq7/hJPGGnA/NBD4xFaIE/qYnuvqhnIKzclLb5l
// SIG // oRKKJQ9jo/dUHPkhydYV81KsbkMyB/2CF/jlZ2wNUfa9
// SIG // 8VLHvefEMPwgMQmIHZUpGk3VHQKl8YDgA7Rb9LHdyFfu
// SIG // ZUnHUlS2tAMoEv+Q1vAIj364l8WrNyzkeuSod+N2oADQ
// SIG // aj/B0jaK4EESqDVqG2rbNeHUHATkqEUEyFozOG5NHA1i
// SIG // twqijNPVVD9GzRxVpnDbEjqHk3Wfp9KgMIIEyTCCA7Gg
// SIG // AwIBAgIQaguZT8AA3qoR1NhAmqi+5jANBgkqhkiG9w0B
// SIG // AQQFADBwMSswKQYDVQQLEyJDb3B5cmlnaHQgKGMpIDE5
// SIG // OTcgTWljcm9zb2Z0IENvcnAuMR4wHAYDVQQLExVNaWNy
// SIG // b3NvZnQgQ29ycG9yYXRpb24xITAfBgNVBAMTGE1pY3Jv
// SIG // c29mdCBSb290IEF1dGhvcml0eTAeFw0wMDEyMTAwODAw
// SIG // MDBaFw0wNTExMTIwODAwMDBaMIGmMQswCQYDVQQGEwJV
// SIG // UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
// SIG // UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
// SIG // cmF0aW9uMSswKQYDVQQLEyJDb3B5cmlnaHQgKGMpIDIw
// SIG // MDAgTWljcm9zb2Z0IENvcnAuMSMwIQYDVQQDExpNaWNy
// SIG // b3NvZnQgQ29kZSBTaWduaW5nIFBDQTCCASAwDQYJKoZI
// SIG // hvcNAQEBBQADggENADCCAQgCggEBAKKEFVPYCzAONJX/
// SIG // OhvC8y97bTcjTfPSjOX9r/3FAjQfJMflodxU7H4CdEer
// SIG // 2zJYFhRRKTjxfrK0jDpHtTlOblTCMQw6bfvNzctQnBuu
// SIG // p9jZSiY/tcXLj5biSfJt2OmWPt4Fz/CmVTetL2DNgGFC
// SIG // oUlUSg8Yt0vZk5kwWkd1ZLTTu922qwydT7hzOxg6qrSH
// SIG // jLCIsE1PH04RtTOA3w06ZG9ExzS9SpObvKYd+QUjTmAp
// SIG // j8wq8oSama2o2wpwe9Y0QZClt2bHXBsdozMOm1QDGj+Y
// SIG // kLjM5z0EdEMcj/c55rOsSHprKg5iAWE5dm79PpgHSxTx
// SIG // AUb9FQDgR9pP5AXkgCUCAQOjggEoMIIBJDATBgNVHSUE
// SIG // DDAKBggrBgEFBQcDAzCBogYDVR0BBIGaMIGXgBBb0HDv
// SIG // aXKeI1F+FLJNjv/LoXIwcDErMCkGA1UECxMiQ29weXJp
// SIG // Z2h0IChjKSAxOTk3IE1pY3Jvc29mdCBDb3JwLjEeMBwG
// SIG // A1UECxMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSEwHwYD
// SIG // VQQDExhNaWNyb3NvZnQgUm9vdCBBdXRob3JpdHmCDwDB
// SIG // AIs8PIgR0T72Y+zfQDAQBgkrBgEEAYI3FQEEAwIBADAd
// SIG // BgNVHQ4EFgQUKVy5G7bNM+67nll99+XKLsQNNCgwGQYJ
// SIG // KwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQD
// SIG // AgFGMA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQEE
// SIG // BQADggEBAEVY4ppBf/ydv0h3d66M2eYZxVe0Gr20uV8C
// SIG // oUVqOVn5uSecLU2e/KLkOIo4ZCJC37kvKs+31gbK6yq/
// SIG // 4BqFfNtRCD30ItPUwG2IgRVEX2SDZMSplCyK25A3Sg+3
// SIG // 6NRhj3Z24dkl/ySElY0EVlSUoRw6PoK87qWHjByMS3lf
// SIG // tUn6XjJpOh9UrXVN32TnMDzbZElE+/vEHEJx5qA9Re5r
// SIG // AJ+sQr26EbNW5PvVoiqB2B9OolW+J49wpqJsG/9UioK8
// SIG // gUumobFmeqkXp8sGwEfrprPpMRVTPSoEv/9zSNyLJ0P8
// SIG // Y+juJIdbvjbR6DH1Mtle33l6ujCsaYZK+4wRvxuNVFkw
// SIG // ggUPMIID96ADAgECAgphBxFDAAAAAAA0MA0GCSqGSIb3
// SIG // DQEBBQUAMIGmMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
// SIG // V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
// SIG // A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSswKQYD
// SIG // VQQLEyJDb3B5cmlnaHQgKGMpIDIwMDAgTWljcm9zb2Z0
// SIG // IENvcnAuMSMwIQYDVQQDExpNaWNyb3NvZnQgQ29kZSBT
// SIG // aWduaW5nIFBDQTAeFw0wMjA1MjUwMDU1NDhaFw0wMzEx
// SIG // MjUwMTA1NDhaMIGhMQswCQYDVQQGEwJVUzETMBEGA1UE
// SIG // CBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEe
// SIG // MBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSsw
// SIG // KQYDVQQLEyJDb3B5cmlnaHQgKGMpIDIwMDIgTWljcm9z
// SIG // b2Z0IENvcnAuMR4wHAYDVQQDExVNaWNyb3NvZnQgQ29y
// SIG // cG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
// SIG // ggEKAoIBAQCqmb05qBgn9Cs9C0w/fHcup8u10YwNwjp0
// SIG // 15O14KBLP1lezkVPmnkp8UnMGkfuVcIIPhIg+FXy7l/T
// SIG // 4MqWvDDe/ljIJzLQhVTo8JEQu/MrvhnlA5sLhh3zsDmM
// SIG // uP0LHTxzJqxXK8opohWQghXid6NAUgOLncJwuh/pNPbz
// SIG // NZJOVYP42jC2IN5XBrVaQgbeWcvy36a9FUdxGSUj0stv
// SIG // mxl532pb8XYFeSn8w1bKj0QIhVWKy8gPRktVy4yWd0qH
// SIG // 6KlBBsf/DeloV2Nyw2lXtEPPMjow3Bvp1UMmKnn+ldsi
// SIG // ZyTJL9A04+b7UUmGuDzQJV/W7J4DYYepaEDH+OID5s8F
// SIG // AgMBAAGjggFAMIIBPDAOBgNVHQ8BAf8EBAMCBsAwEwYD
// SIG // VR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0OBBYEFGvIxlEg
// SIG // 8LQv06C2rn9eJrK4h1IpMIGpBgNVHSMEgaEwgZ6AFClc
// SIG // uRu2zTPuu55Zffflyi7EDTQooXSkcjBwMSswKQYDVQQL
// SIG // EyJDb3B5cmlnaHQgKGMpIDE5OTcgTWljcm9zb2Z0IENv
// SIG // cnAuMR4wHAYDVQQLExVNaWNyb3NvZnQgQ29ycG9yYXRp
// SIG // b24xITAfBgNVBAMTGE1pY3Jvc29mdCBSb290IEF1dGhv
// SIG // cml0eYIQaguZT8AA3qoR1NhAmqi+5jBKBgNVHR8EQzBB
// SIG // MD+gPaA7hjlodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20v
// SIG // cGtpL2NybC9wcm9kdWN0cy9Db2RlU2lnblBDQS5jcmww
// SIG // DQYJKoZIhvcNAQEFBQADggEBADUj/RNU/Onc8N0MFHr6
// SIG // p7PO/ac6yLrl5/YD+1Pbp5mpoJs2nAPrgkccIb0Uy+dn
// SIG // QAnHFpECVc5DQrTNG12w8zIEPRLlHacHp4+jfkVVdhuW
// SIG // lZFp8N0480iJ73BAt9u1VYDAA8QutijcCoIOx0Pjekhd
// SIG // uAaJkkBsbsXc+JrvC74hCowvOrXtp85xh2gj4bPkGH24
// SIG // RwGlK8RYy7KJbF/90yzEb7gjsg3/PPIRRXTyCQaZGN1v
// SIG // wIYBGBIdKxavVu9lM6HqZ070S4Kr6Q/cAfrfYH9mR13L
// SIG // LHDMe07ZBrhujAz+Yh5C+ZN8oqsKntAjEK5NeyeRbya+
// SIG // aPqmP58j68idu4cxggTaMIIE1gIBATCBtTCBpjELMAkG
// SIG // A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
// SIG // BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
// SIG // dCBDb3Jwb3JhdGlvbjErMCkGA1UECxMiQ29weXJpZ2h0
// SIG // IChjKSAyMDAwIE1pY3Jvc29mdCBDb3JwLjEjMCEGA1UE
// SIG // AxMaTWljcm9zb2Z0IENvZGUgU2lnbmluZyBQQ0ECCmEH
// SIG // EUMAAAAAADQwCQYFKw4DAhoFAKCBqjAZBgkqhkiG9w0B
// SIG // CQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4w
// SIG // DAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQURKkO
// SIG // QXb9/8Gu4J/yqzBPWkkwJI4wSgYKKwYBBAGCNwIBDDE8
// SIG // MDqgGIAWAG8AdwBzAGIAcgBvAHcAcwAuAGoAc6EegBxo
// SIG // dHRwOi8vb2ZmaWNlLm1pY3Jvc29mdC5jb20gMA0GCSqG
// SIG // SIb3DQEBAQUABIIBAC6DQJ1CpMz4Dse72ABumRjqaU3z
// SIG // gxw0TT0n36C9YW45jwoOsRzaZOwLwFQtlfeg2YqA9jf6
// SIG // 2hi3/GTk38HC77UR5XxoinZSKVxhbOIQT0sF9FHuREoX
// SIG // UChJ5MCbgcbS5lvIPOP0MCjEvcSMkLUN2MWu1zd/XVl4
// SIG // 6JTBKjKQyQOoD1VU4DKIp4NShycyUz999eV1XR3OJrlJ
// SIG // XOnnhrJiusHjL116R4s+Ze9M5jgoicjqRRp3UXxT9Quu
// SIG // DidQIvTouYSp3bevTS88CENBZAqzcAqX9XDi7xS1WAsE
// SIG // jfGEifl1yqVSzoHKIVZ0zITJE26qHq963wIFxYFH2hSe
// SIG // oADGjlShggJMMIICSAYJKoZIhvcNAQkGMYICOTCCAjUC
// SIG // AQEwgbMwgZ4xHzAdBgNVBAoTFlZlcmlTaWduIFRydXN0
// SIG // IE5ldHdvcmsxFzAVBgNVBAsTDlZlcmlTaWduLCBJbmMu
// SIG // MSwwKgYDVQQLEyNWZXJpU2lnbiBUaW1lIFN0YW1waW5n
// SIG // IFNlcnZpY2UgUm9vdDE0MDIGA1UECxMrTk8gTElBQklM
// SIG // SVRZIEFDQ0VQVEVELCAoYyk5NyBWZXJpU2lnbiwgSW5j
// SIG // LgIQCHptXG9ik0+6xP1D4RQYnTAMBggqhkiG9w0CBQUA
// SIG // oFkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
// SIG // hkiG9w0BCQUxDxcNMDMwNzE1MDYwNDQ0WjAfBgkqhkiG
// SIG // 9w0BCQQxEgQQM3Bxt6gfpNY17LEzzRwfhzANBgkqhkiG
// SIG // 9w0BAQEFAASCAQAMwR5EZPMBV0Mlobpl0lMYz3zWPwu7
// SIG // rNh9Pg3JISPm9niP12b6mj0baOIz6zLoKd3XPNtf2CjO
// SIG // gJWplq46NqhaMXkNmB5N1PEFnmWjFFL1f2oNhAvR+vDD
// SIG // 4Mm8n7gKufm9gkuniPet5e2Tq+6tYv3vsyKWu6istRzD
// SIG // 3wDRH1j3gTTm+yepkZ1p1Gx2FUwBNDvGd4pttvnYLTLV
// SIG // W4ozNDC8YRo5QzSIvUrrzrADW1VRyHKBHr8r4W9hEAqB
// SIG // ondQlJ6ola7Hq8eBy+W/rRIJ0Paip3PxG/QWFXxom31S
// SIG // fEQ3oNf9xqoIkx2+bzgBM8COeI7AwcAS1bRwJzAV1Imh
// SIG // aHbm
// SIG // End signature block

//*=====================================================================
//  File:      GumDrop.js
//
// 
//
//---------------------------------------------------------------------
// This file is part of the Microsoft Live Communications Code Samples.
//
//  Copyright (C) Microsoft Corporation.  All rights reserved.
//
//This source code is intended only as a supplement to Microsoft
//Development Tools and/or on-line documentation.  See these other
//materials for detailed information regarding Microsoft code samples.
//
//THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
//KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
//PARTICULAR PURPOSE.
//=====================================================================*/

//var comm = new ActiveXObject("Communicator.UIAutomation");
var CommunicatorObject = null;
var GumdropContactDictionaryObj = null;
var GumdropURIDictionaryObj = null;

//This function uses the numeric state value for a contact
//to map to an image to use for the page to display.
function GumdropGetStatusImage(state)
{
    var img = "PresenceControlBLANK.GIF";
    switch (state)
    {
        case 0:
            img = "unknown.gif";
        break;      
        case 6:
            img = "PresenceControlOFF.GIF";
        break;      
        case 18:
            img = "PresenceControlInactive.gif";
        break;  
        case 1:
            img = "PresenceControlOFF.GIF";
        break;  
        case 2:
            img = "PresenceControlON.GIF";
        break;
        case 10:
            img = "PresenceControlBUSY.GIF";
        break;
        case 50:
            img = "PresenceControlBUSY.GIF";
        break;
        case 14:
            img = "PresenceControlAWAY.GIF";
        break;
        case 34:
            img = "PresenceControlAWAY.GIF";
        break;
        case 66:
            img = "PresenceControlAWAY.GIF";
        break;
    }
    return img;
}
//This function replaces the image displayed on the page for a contact
//with the updated version for the new status.
function GumdropUpdateImage(id, img)
{
    var obj = document.images(id);
    if (obj)
    {
        var oldImg = obj.src;
        var index = oldImg.lastIndexOf("/");
        var newImg = oldImg.slice(0, index + 1);
        newImg += img;
        if (oldImg != newImg)
            obj.src = newImg;
        if (obj.altbase)
        {
            obj.alt = obj.altbase;
        }
    }
}

//This function is called on the PageLoad to show the status gumdrop
//for a contact.
function Gumdrop(uri)
{
    if (uri == null || uri == '')
        return;
        
    var obj = window.event.srcElement;
    var id = obj.id;
    var Contact;
    var myID;
    
	if(bInstall) {
	    myID = getSignInName();
	    if(myID != "") {
    	    try {
    	        if(g_StatusInterval == null)
        		{
    	            if(document.getElementById("MOC_Div") == undefined)
    	            {
    	                g_MOC_Div = document.createElement('<div id="MOC_Div" style="display:none;"></div>');
    	                document.body.insertBefore(g_MOC_Div);
    	                document.getElementById("MOC_Div").innerHTML = '<object id="MOC" height="0" style="display:none"; codeType="application/x-oleobject" width="0" classid="clsid:8885370D-B33E-44B7-875D-28E403CF9270" VIEWASTEXT></object>';
    	                MOCObjectEventEnable();
    	            }
    	            else if(document.getElementById("MOC_Div").innerHTML == "") 
    	            {
    	                document.getElementById("MOC_Div").innerHTML = '<object id="MOC" height="0" style="display:none"; codeType="application/x-oleobject" width="0" classid="clsid:8885370D-B33E-44B7-875D-28E403CF9270" VIEWASTEXT></object>';
    	                MOCObjectEventEnable();
    	            }
    	        }
    	    }
            catch(e) {
                document.getElementById("MOC_Div").innerHTML = "";
                g_StatusInterval = setInterval(UpdateStatus, 3000);
    	    }
	    }
	}
	else {
         GumdropUpdateImage(id, "PresenceControlBLANK.GIF");
         return;	
	}

    //We use the GumdropContactDictionaryObj to map
    //between the id of the page element and the Contact
    //object that we use to track the state.
    //if (!GumdropContactDictionaryObj)
    if (!GumdropContactDictionaryObj)
    {
        GumdropContactDictionaryObj = new Object();
	    GumdropURIDictionaryObj = new Object();
    }
          
    if (GumdropContactDictionaryObj )
    {
        if (!GumdropURIDictionaryObj[id])
        {
            GumdropURIDictionaryObj[id] = uri;
        }

        if (!GumdropContactDictionaryObj[id])
        {
            var state = 0, img;

            try 
            {
                //Create a Contact object by using the interface to Communicator.  We pass the SIP
                //URI of the contact to get the object.
                //Contact = document.MOC.GetContact(uri,"{83D4679F-B6D7-11D2-BF36-00C04FB90A03}");
                if(myID != "") {
		            if (!CommunicatorObject)
		            {
			            CommunicatorObject = new ActiveXObject("Communicator.UIAutomation");
		            }
		            Contact = CommunicatorObject.GetContact(uri, CommunicatorObject.MyServiceId);
                    GumdropContactDictionaryObj[id] = Contact;
                    state = Contact.Status;
                    img = GumdropGetStatusImage(state);
                    GumdropUpdateImage(id, img);
                }
            }
            catch (e)
            {
                //If the contact is not on the user's
                //contact list, then there might be a time lag before
                //Contact.Status is a valid operation.  Just use "unknown" as the state.
                img = GumdropGetStatusImage(state);
                GumdropUpdateImage(id, img);
            }

	        if (presenceType != 2) {
	                // Presence 이미지에 Event추가
        	        AddPresenceEvt(id);
	        }
        }
    }
}
/*  오류로 인한 주석처리 2016-02-12
	function MOCObjectEventEnable() {
        // MOC 객체에 이벤트 추가
       	function MOC.object::OnContactStatusChange(contact, state) {   
            	UpdateStatus('PresenceUpdate');
        }
}
*/
function UpdateStatus(caller)
{
	if (bOutLook)
		return;

	if (!GumdropContactDictionaryObj)
		return;

	for (var id in GumdropContactDictionaryObj)
	{
		var Contact = GumdropContactDictionaryObj[id];
		var state = 0, img;
		
		try
		{
			state = Contact.Status;
			img = GumdropGetStatusImage(state);
			GumdropUpdateImage(id, img);
		}
		catch (e)
		{
			//If the contact is not valid, then just mark the state
			//as unknown.
			img = GumdropGetStatusImage(state);
			GumdropUpdateImage(id, img);
		}
	}
}

// 새로고침시 개체 초기화 - 전자우편 처럼 자동으로 refresh하면서 목록갯수가 증가하는 경우 오류 발생할 수 있음
// 새로고침 함수의 상단에 선언한다.
function PresenceStatusInit()
{
	PresenceControlbrowseris = new PresenceControlBrowseris();
	PresenceControlObject = null;
	bPresenceControlInited = false;

	PresenceControlURIDictionaryObj = null;
	PresenceControlStatesDictionaryObj = null;

	PresenceControlOrigScrollFunc = null;
	bPresenceControlInScrollFunc = false;


	//CommunicatorObject = null;
	GumdropContactDictionaryObj = null;
	GumdropURIDictionaryObj = null;
}

function S4() { 
   return (((1+Math.random())*0x10000)|0).toString(16).substring(1); 
} 
function GetGUID() { 
   return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4()); 
}

// 사번 또는 E-Mail 주소로 SIP URI를 가져온다.
function getSIPUri(strCNList, strEMailList) {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "CNLIST", strCNList);
    createNodeAndInsertText(xmlpara, objNode, "EMAILLIST", strEMailList);
 
    var xmlhttp = createXMLHttpRequest();
    if(bGroupwarePresence) {
        xmlhttp.open("POST", "/myoffice/ezOrgan/OrganInfo/GetSIPUriList.aspx", false);
    }
    else {
        xmlhttp.open("POST", "/myoffice/ezOCS/OrganInfo/ezOrgan/GetSIPUriList.aspx", false);
    }
    xmlhttp.send(xmlpara);

    if (xmlhttp.statusText == "OK")
        return xmlhttp.responseText;
    else
        return "";
}