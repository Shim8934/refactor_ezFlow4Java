﻿/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//	NameControl.js 내에서 Common.js의 함수를 호출하여 사용하므로,
//	호출한 페이지 내에 /myoffice/ezOCS/script/Common.js가 같이 선언된 상태에서 사용한다.
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



var PresenceControlbrowseris = new PresenceControlBrowseris();
var PresenceControlObject = null;
var bPresenceControlInited = false;

var PresenceControlURIDictionaryObj = null;
var PresenceControlStatesDictionaryObj = null;

var PresenceControlOrigScrollFunc = null;
var bPresenceControlInScrollFunc = false;

// Lync DB에서 쿼리해온 사용자 State 저장하는 XML
var xmlPresenceDom;
if (window.DOMParser) {
    var parser = new DOMParser();
    xmlPresenceDom = parser.parseFromString("", "text/xml");
}
else {
    xmlPresenceDom = new ActiveXObject("Microsoft.XMLDOM");
}

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

// Presence Context Menu의 표시 형식을 설정합니다. 기본값 = 1
// 1 = Kaoni에서 개발된 Custom Context Menu를 사용
// 2 = Microsoft Office NameCtrl에서 제공하는 Context Menu 사용
var presenceType = 1;

// 그룹웨어에서 동작하는 상태인지 체크
// true = 그룹웨어 모듈
// false = ezOCS 모듈
var bGroupwarePresence = true;
// Lync Tab 주소 (그룹웨어에서 동작할 때 Tab 주소 입력)
var LyncTabURL = "http://lync2013web.sharepoint.dev";

// 다국어 처리용 변수 선언
var NameControlstrLang1;
var NameControlstrLang2;
var NameControlstrLang3;
var NameControlstrLang4;
var NameControlstrLang5;
var NameControlstrLang6;
var NameControlstrLang7;
var NameControlstrLang8;
var NameControlstrLang9;
var NameControlstrLang10;
var NameControlstrLang11;
var NameControlstrLang12;
var NameControlstrLang13;
var NameControlstrLang14;
var NameControlstrLang15;
var NameControlstrLang16;
var NameControlstrLang17;
var NameControlstrLang18;
var NameControlstrLang19;
var NameControlstrLang20;
var NameControlstrLang21;
var NameControlstrLang22;
var NameControlstrLang23;

var displaylang;


// Lync 설치 여부 체크
CheckOCInstall();

// Lync 2013 이상 설치 여부 체크
CheckOfficeInstall();

// 언어 설정
GetLang();



// Lync install 여부 체크
function CheckOCInstall() {
    try {
        if (IsSupportedNPApiBrowserOnWin()) {
            // Office 2013 플러그인이 설치 되어 있는지 확인
            if (IsNPAPIOnWinPluginInstalled("application/x-sharepoint-uc")) {
                bInstall = true;
            }
            else {
                bInstall = false;
            }
        }
        else if (PresenceControlbrowseris.safari3up) {
            if (!IsMacPluginInstalled()) {
                bInstall = false;
            }
        }
        else {
            if (GetLyncPath() == "") {
                bInstall = false;
            }
        }
	} catch (e) {
		bInstall = false;
	}
}

// Lync 2013 이상 설치 여부 체크
function CheckOfficeInstall() {
    try {
        if (IsSupportedNPApiBrowserOnWin()) {
            // Office 2013 플러그인이 설치 되어 있는지 확인
            if (IsNPAPIOnWinPluginInstalled("application/x-sharepoint-uc")) {
                bOutLook = true;
                // 크롬, 파폭의 경우 NameControl 사용
                presenceType = 2;
            }
            else {
                bInstall = false;
            }
        }
        else if (PresenceControlbrowseris.safari3up) {
            if (IsMacPluginInstalled()) {
                bOutLook = true;
                // 사파리의 경우 NameControl 사용
                presenceType = 2;
            }
            else {
                bInstall = false;
            }
        }
        else {
            if (CheckLync2010Higher() == true) {
                bOutLook = true;

                // ModalDialog 인 경우 별도 처리 (ModalDialog 일 때 NameControl.dll 사용불가)
                if (window.dialogArguments != undefined) {
                    // Presence용 iframe을 미리 생성한다.
                    CreatePresenceiframeElement();
                }
            }
            else {
                // Lync 2010에서는 Communicator Automation API 사용
                bOutLook = false;

                // Lync 2010에서는 무조건 Kaoni Context Menu를 사용
                presenceType = 1;
            }
        }
    } catch(e) {
        bOutLook = false;
    }
}

function EnsurePresenceControl()
{
    if (!bPresenceControlInited) {
        try {
            // 사파리 일 경우
            if (IsSupportedMacBrowser()) {
                PresenceControlObject = CreateMacPlugin();
//                if (PresenceControlObject != null) {
//                    PresenceControlObject.OnStatusChange = PresenceControlOnStatusChange;
//                }
            }
            // Windows OS에서 파폭, 크롬일 경우
            else if (IsSupportedNPApiBrowserOnWin()) {
                PresenceControlObject = CreateNPApiOnWindowsPlugin("application/x-sharepoint-uc");
                if (PresenceControlObject != null) {
                    PresenceControlObject.OnStatusChange = PresenceControlOnStatusChange;
                }
            }
            // 그 외에 IE 일 경우
            else if (PresenceControlbrowseris.ie5up) {
                if (Boolean(window.ActiveXObject)) {
                    PresenceControlObject = new ActiveXObject("Name.NameCtrl.1");
                    if (PresenceControlObject) {
                        var onStatusChange;

                        if (PresenceControlbrowseris.mac && (PresenceControlbrowseris.firefox3up || PresenceControlbrowseris.safari3up || PresenceControlbrowseris.chrome))
                            onStatusChange = "PresenceControlOnStatusChange";
                        else
                            onStatusChange = PresenceControlOnStatusChange;
                        PresenceControlObject.OnStatusChange = onStatusChange;
                    }
                }
            }
            bPresenceControlInited = true;
        }
        catch (e) {
            PresenceControlObject = null;
        }
        AddEvtHandler(window, "onbeforeunload", DiscardPresenceControl);
    }
    return PresenceControlObject;
}

function PresenceControlOnStatusChange(name, state, id)
{
//alert(name + ":::" + state + ":::" + id);
    if (PresenceControlStatesDictionaryObj)
    {
        var img = PresenceControlGetStatusImage(state);
        
        if (PresenceControlStatesDictionaryObj[id] != state)
        {
	    // Modal창에서 호출한 iframe 일 경우 부모 창의 프리젠스 이미지 업데이트
            if (document.location.href.toLowerCase().indexOf("namectrloniframe.htm") >= 0) {
                parent.document.Script.PresenceControlUpdateImage(id, img);
            }
	    // 그 외의 경우에 해당 상태 값 저장
	    else {
		PresenceControlStatesDictionaryObj[id] = state;
	    }
            PresenceControlUpdateImage(id, img);
        }

        // Kaoni에서 개발된 Custom Context Menu를 사용하는 경우에만 image에 상태정보 text 표시
        if ((presenceType == 1) || (window.dialogArguments != undefined))
        {
            try {
                var obj = document.images[id];
                if (obj == undefined)
                    obj = document.images.item(id);
                if (obj.length != null) {
                    if (obj)
                    {
                        for (var i = 0; i < obj.length; i++) {
                            obj[i].alt = ConvertKoreanByStatusText(PresenceControlGetStatusText(state));
                            // 사용자 이미지에도 alt 명 추가 (img 태그 id 형식 : 프리젠스 img 태그 id + :photo)
                            if (document.images[id + ":photo"])
                            {
                                document.images[id + ":photo"][i].alt = obj[i].alt;
                            }

                        }
                    }
                }
                else  {
                    if (obj)
                    {
                        obj.alt = ConvertKoreanByStatusText(PresenceControlGetStatusText(state));
                        // 사용자 이미지에도 alt 명 추가 (img 태그 id 형식 : 프리젠스 img 태그 id + :photo)
                        if (document.images[id + ":photo"])
                        {
                            document.images[id + ":photo"].alt = obj.alt;
                        }

                    }
                }
            } catch (e) {}
        }

        // Modal 창을 위한 Presence 처리 페이지(namectrloniframe.htm)에서 호출한 경우
        if (document.location.href.toLowerCase().indexOf("namectrloniframe.htm") >= 0)
        {
            try {
                if (parent.document.Script.PresenceControlOnStatusChange != undefined)
                {
                    // 부모창(Modal)의 Presence를 업데이트
                    parent.document.Script.PresenceControlOnStatusChange(name, state, id);
                }

            } catch (e) {}
        }
    }
}

function PresenceControlShowOOUIMouse(objEvent)
{
	PresenceControlShowOOUI(objEvent, 0);
}
    
function PresenceControlShowOOUIFocus(objEvent)
{
	PresenceControlShowOOUI(objEvent, 1);
}

function PresenceControlShowOOUI(objEvent, inputType)
{
    try {

        if (PresenceControlbrowseris.ie5up || IsSupportedMacBrowser() || IsSupportedNPApiBrowserOnWin()) {
            var currEvent = GetCurrentEvent(objEvent);
            var obj = GetEventTarget(currEvent);
            var objSpan = obj;
            var objOOUI = obj;
            var oouiX = 0, oouiY = 0;
            if (EnsurePresenceControl() && Boolean(PresenceControlURIDictionaryObj))
            {
                var objRet = PresenceControlGetOOUILocation(obj, false);

                if (Boolean(objRet)) {
                    objSpan = objRet.objSpan;
                    objOOUI = objRet.objOOUI;
                    oouiX = objRet.oouiX;
                    oouiY = objRet.oouiY;
                    if (Boolean(currEvent.clientX))
                        oouiX = currEvent.clientX;

                    try {
                        // Modal창이 아니고, NameControl의 Presence를 사용하는 경우 상태 문구를 삭제
                        if (window.dialogArguments == undefined && presenceType == 2) {
                            document.images[objOOUI.id].alt = "";
                            document.images[objOOUI.id + ":photo"].alt = "";
                        }
                    } catch (e) { }


                    // 사진에서 호출한 경우 고려하여 ":photo" 변환
                    var name = PresenceControlURIDictionaryObj[objOOUI.id.replace(":photo", "")];
                    if (Boolean(objSpan))
                        objSpan.onkeydown = PresenceControlHandleAccelerator;
                    if (typeof PresenceControlObject.ShowOOUI != 'undefined')
                        PresenceControlObject.ShowOOUI(name, inputType, Math.round(oouiX), Math.round(oouiY));
                }
            }
        }

    } catch (e) {}
}


function PresenceControlHideOOUI() {
    if (Boolean(PresenceControlObject)) {
        if (typeof PresenceControlObject.HideOOUI != 'undefined')
            PresenceControlObject.HideOOUI();
    }
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
        case 7:
            img = "PresenceControlBUSY.GIF";
            break;
        case 8:
            img = "PresenceControlAWAY.GIF";
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
            img = "PresenceControlBusyInactive.GIF";
            break;
        case 21:  // 원격 제어 시 표시 됨.
            img = "PresenceControlDoNotDisturb.gif";
            break;
    }
    
    // 8 : 자리비움
    return img;
}

// Lync DB에서 쿼리해온 사용자 State NameControl에 맞게 변환
function ConvertLyncDBState_ToNameControlState(state)
{
    var pState = 1;
    
    if (state >= 3000 && state <= 4499)   // Availiable
        pState = 0;
    else if (state >= 4500 && state <= 5999)    // Availiable - Idle
        pState = 16;
    else if (state >= 6000 && state <= 7499)    // Busy
        pState = 3;
    else if (state >= 7500 && state <= 8999)    // Busy - Idle
        pState = 19;
    else if (state >= 9000 && state <= 11999)  // Do Not Disturb
        pState = 9;
    else if (state >= 12000 && state <= 14999)    // Be Right Back
        pState = 4;
    else if (state >= 15000 && state <= 17999)    // Away
        pState = 2;
    else  // Offline
        pState = 1;
    
    return pState;
}

// NameCtrl 상태정보에 해당하는 Text 리턴
function PresenceControlGetStatusText(state)
{
    var sText = "";
    switch (state) {
        case 0:
            sText = "AVAILABLE";
            break;
        case 1:
            sText = "OFFLINE";
            break;
        case 2:
            sText = "AWAY";
            break;
        case 3:
            sText = "BUSY";
            break;
        case 4:
            sText = "BE RIGHT BACK";
            break;
        case 5:
            sText = "ON A PHONE";
            break;
        case 6:
            sText = "AWAY";
            break;
        case 7:
            sText = "IN A CONFERENCE";
            break;
        case 8:
            sText = "AWAY";
        case 9:
            sText = "DO NOT DISTURB";
            break;
        case 10:
            sText = "BUSY";
            break;
	case 16:
            sText = "INACTIVE";
            break;
        case 19:
            sText = "INACTIVE";
            break;
        case 21:
	        sText = "PRESENTATION";
	        break;
    }
    return sText;
}

function PresenceControlUpdateImage(id, img) {
    var obj = document.images[id];
    if (obj == undefined)
        obj = document.images.item(id);
    try {
        if (obj.length != null) {
            if (obj) {
                for (var i = 0; i < obj.length; i++) {
                    var oldImg = obj[i].src;
                    var index = oldImg.lastIndexOf("/");
                    var newImg = oldImg.slice(0, index + 1);
                    newImg += img;
                    if (oldImg != newImg)
                        obj[i].src = newImg;
                    if (obj[i].altbase) {
                        obj[i].alt = obj[i].altbase;
                    }
                }
            }
        }
        else {
            if (obj) {
                var oldImg = obj.src;
                var index = oldImg.lastIndexOf("/");
                var newImg = oldImg.slice(0, index + 1);
                newImg += img;
                if (oldImg != newImg)
                    obj.src = newImg;
                if (obj.altbase) {
                    obj.alt = obj.altbase;
                }
            }
        }
    } catch (e) { }
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


// 기존 코딩되어 있는 소스의 호환성을 위해 임시로 만든 함수 (삭제해야 함)
function PresenceControl(uri)
{
	PresenceControl(uri, null);
}

// 이미지 개체 정보를 pObj 로 전달
function PresenceControl(uri, pObj) {
    // Lync 2010 버전은 Communicator API를 사용하여 Presence를 보여주도록 처리
    try{
        if (bOutLook == false)
        {
            Gumdrop(uri, pObj);
            return;
        }
        
        if (uri == null || uri == '')
            return;

        if (PresenceControlbrowseris.win32) {
            //            var obj = window.event.srcElement;
            // 기존 코드를 제거하고 전달받은 개체 정보를 사용.
            var obj = pObj;

            var objSpan = obj;
            var id = obj.id;


            // Lync가 설치되지 않았을 경우 Presence를 표시하지 않음
            if (!bInstall) {
                PresenceControlUpdateImage(id, "PresenceControlBLANK.GIF");
                return;
            }

            var fFirst = false;
            if (!PresenceControlStatesDictionaryObj) {
                PresenceControlStatesDictionaryObj = new Object();
                PresenceControlURIDictionaryObj = new Object();
                if (!PresenceControlOrigScrollFunc) {
                    PresenceControlOrigScrollFunc = window.onscroll;
                    window.onscroll = PresenceControlScroll;
                }
            }

            if (PresenceControlStatesDictionaryObj) {
                if (!PresenceControlURIDictionaryObj[id]) {
                    PresenceControlURIDictionaryObj[id] = uri;
                    fFirst = true;
                }

                if (typeof (PresenceControlStatesDictionaryObj[id]) == "undefined") {
                    PresenceControlStatesDictionaryObj[id] = 1;
                }

                // 신뢰할 수 있는 사이트에 등록되어야 동작한다.
                if (fFirst && EnsurePresenceControl() && PresenceControlObject.PresenceEnabled) {
                    var state = 1, img;
                    state = PresenceControlObject.GetStatus(uri, id);
                    if (state == 1)
                        state = GetLyncDBStatus(uri);
                    img = PresenceControlGetStatusImage(state);
                    PresenceControlUpdateImage(id, img);
                    PresenceControlStatesDictionaryObj[id] = state;

                    // Offline이 아닌 경우에만 실행
                    if (state != 1) {
                        // 0.5초 후 DB State 입히기
                        setTimeout(function() { UpdateInitState(id, state); }, 500);
                    }

                    AddPresenceEvt(id);
                }
                else if (!PresenceControlObject.PresenceEnabled) {

                    // Modal창인 경우 Presence 처리

                    if (CheckLync2010Higher() == true) {
                        // Lync 2013 이상인 경우

                        if (fFirst == true) {
                            // Presence 이미지 초기화
                            var state = 1, img;
                            state = GetLyncDBStatus(uri);
                            img = PresenceControlGetStatusImage(state);

                            PresenceControlUpdateImage(id, img);
                            PresenceControlStatesDictionaryObj[id] = state;

                            // Offline이 아닌 경우에만 실행
                            if (state != 1) {
                                // 0.5초 후 DB State 입히기
                                setTimeout(function() { UpdateInitState(id, state); }, 500);
                            }

                            if (presenceType == 1) {
                                // Presence 이미지에 Event추가
                                AddPresenceEvt(id);
                            }
                            else {
                                // Modal창에서 호출한 경우
                                if (window.dialogArguments != undefined) {
                                    // Presence 이미지에 Event추가
                                    AddPresenceEvt(id);
                                }
                            }
                        }
                        else {
                            // Lync 2013 이상인 경우
                            var findNode = "A" + uri.toUpperCase().replace("@", "_");
                            try {
                                if (!(xmlPresenceDom.getElementsByTagName(findNode).length != 0 && PresenceControlStatesDictionaryObj[id] == 1)) {
                                    PresenceControlStatesDictionaryObj[id] = document.getElementById("Presence_iframe").contentWindow.PresenceControlStatesDictionaryObj[id];
                                    PresenceControlUpdateImage(id, PresenceControlGetStatusImage(PresenceControlStatesDictionaryObj[id]));
                                }
                            }
                            catch (e) { }
                            // Kaoni에서 개발된 Custom Context Menu를 사용하는 경우에만 image에 상태정보 text 표시
                            if ((presenceType == 1) || (window.dialogArguments != undefined)) {
                                try {
                                    var obj = document.images[id];
                                    if (obj == undefined)
                                        document.images.item(id);
                                    if (obj.length != null) {
                                        if (obj) {
                                            for (var i = 0; i < obj.length; i++) {
                                                obj[i].alt = ConvertKoreanByStatusText(PresenceControlGetStatusText(PresenceControlStatesDictionaryObj[id]));
                                                // 사용자 이미지에도 alt 명 추가 (img 태그 id 형식 : 프리젠스 img 태그 id + :photo)
                                                if (document.images[id + ":photo"] != null)
                                                    document.images[id + ":photo"][i].alt = obj[i].alt;
                                            }
                                        }
                                    }
                                    else {
                                        if (obj) {
                                            obj.alt = ConvertKoreanByStatusText(PresenceControlGetStatusText(PresenceControlStatesDictionaryObj[id]));
                                            // 사용자 이미지에도 alt 명 추가 (img 태그 id 형식 : 프리젠스 img 태그 id + :photo)
                                            if (document.images[id + ":photo"] != null)
                                                document.images[id + ":photo"].alt = obj.alt;
                                        }
                                    }
                                } catch (e) { }
                            }
                            if (presenceType == 1) {
                                // Presence 이미지에 Event추가
                                AddPresenceEvt(id);
                            }
                            else {
                                // Modal창에서 호출한 경우
                                if (window.dialogArguments != undefined) {
                                    // Presence 이미지에 Event추가
                                    AddPresenceEvt(id);
                                }
                            }
                        }

                        if (CreatePresenceiframeElement() == true) {
                            CreatePresenseImagesOnIframe(uri, id);
                        }
                    }
                }
                else if (!fFirst && EnsurePresenceControl()) {
                    if (CheckLync2010Higher() == true) {
                        // Lync 2013 이상인 경우
                        var findNode = "A" + uri.toUpperCase().replace("@", "_");
                        try {
                            PresenceControlStatesDictionaryObj[id] = PresenceControlObject.GetStatus(uri, id);
                            if (!(xmlPresenceDom.getElementsByTagName(findNode).length != 0 && PresenceControlStatesDictionaryObj[id] == 1)) {
                                PresenceControlUpdateImage(id, PresenceControlGetStatusImage(PresenceControlStatesDictionaryObj[id]));
                                // Modal창에서 호출한 iframe 일 경우 부모 창의 프리젠스 이미지 업데이트
                                if (document.location.href.toLowerCase().indexOf("namectrloniframe.htm") >= 0) {
                                    parent.document.Script.PresenceControlUpdateImage(id, PresenceControlGetStatusImage(PresenceControlStatesDictionaryObj[id]));
                                }
                            }
                        }
                        catch (e) { }
                        if (presenceType == 1) {
                            try {
                                var obj = document.images[id];
                                if (obj == undefined)
                                    obj = document.images.item(id);
                                if (obj.length != null) {
                                    if (obj) {
                                        for (var i = 0; i < obj.length; i++) {
                                            obj[i].alt = ConvertKoreanByStatusText(PresenceControlGetStatusText(PresenceControlStatesDictionaryObj[id]));
                                            // 사용자 이미지에도 alt 명 추가 (img 태그 id 형식 : 프리젠스 img 태그 id + :photo)
                                            if (document.images[id + ":photo"] != null)
                                                document.images[id + ":photo"][i].alt = obj[i].alt;
                                        }
                                    }
                                }
                                else {
                                    if (obj) {
                                        obj.alt = ConvertKoreanByStatusText(PresenceControlGetStatusText(PresenceControlStatesDictionaryObj[id]));
                                        // 사용자 이미지에도 alt 명 추가 (img 태그 id 형식 : 프리젠스 img 태그 id + :photo)
                                        if (document.images[id + ":photo"] != null)
                                            document.images[id + ":photo"].alt = obj.alt;
                                    }
                                }
                            } catch (e) { }
                        }
                        if (presenceType == 1) {
                            // Presence 이미지에 Event추가
                            AddPresenceEvt(id);
                        }
                    }
                }
            }

            if (fFirst && presenceType == 2) {
                var objRet = PresenceControlGetOOUILocation(obj, false);

                if (Boolean(objRet)) {
                    objSpan = objRet.objSpan;
                    if (Boolean(objSpan)) {
                        objSpan.onmouseover = PresenceControlShowOOUIMouse;
                        objSpan.onfocusin = PresenceControlShowOOUIFocus;
                        objSpan.onmouseout = PresenceControlHideOOUI;
                        objSpan.onfocusout = PresenceControlHideOOUI;
                    }
                }
            }
        }
    }
    catch (ex)
    {  }
}

// Modal 윈도우에서 Presence를 표시하기 위해 NameCtrlOniframe.htm 호출
function CreatePresenceiframeElement()
{
	var bResult = false;

	try {
	    if (document.getElementById("Presence_iframe") == undefined) {
			var pUrl = "/myoffice/ezOCS/script/NameCtrlOniframe.htm";
			if(bGroupwarePresence)
			{
				pUrl = "/myoffice/Common/NameCtrlOniframe.htm";	// 그룹웨어에서 호출 시 그룹웨어에 위치한 경로를 호출
			}

			// Modal창에 Presence 정보를 전달할 iframe 선언
			var objIframe = document.createElement("iframe");
			objIframe.setAttribute("id", "Presence_iframe");
			objIframe.style.setAttribute("display", "none");
			objIframe.setAttribute("src", pUrl);

			document.body.insertBefore(objIframe);
			
			if(document.getElementById("Presence_Div") == undefined)
			{
			    // Presence 정보 저장용 Div 선언
			    var objDiv = document.createElement("div");
			    objDiv.setAttribute("id", "Presence_Div");
			    objDiv.style.setAttribute("display", "none");
			    
				document.body.insertBefore(objDiv);
            }
			bResult = true;
		}
		else
		{
			bResult = true;

}
	} catch (e) {}

	return bResult;
}

function IFrameRefresh() {
	if (document.getElementById("Presence_iframe") != undefined) {
		try {
		document.getElementById("Presence_iframe").contentWindow.SetParentPresence();
		}
		catch (e) { }
	}
}

// iframe 내에 Presence 이미지 생성
function CreatePresenseImagesOnIframe(uri, id)
{
	try {
		var bExist = false;
		var presenceList = document.getElementById("Presence_Div").innerText;
		var arrPresence = presenceList.split("|");
		for (var i = 0; i < arrPresence.length-1; i++)
		{
			// arrItem[0]: sip / arrItem[1]: image Id
			var arrItem = arrPresence[i].split(";");
			if (arrItem[1].toLowerCase() == id.toLowerCase())
			{
				// 중복된 Image id가 있는지 체크
				bExist = true;
				break;
			}
		}

		// Presence_iframe 페이지의 window onload 시 일괄 처리를 위해 저장
		if (bExist == false) {
			document.getElementById("Presence_Div").innerText = document.getElementById("Presence_Div").innerText + uri + ";" + id + "|";
			
			try {
			    if (document.getElementById("Presence_iframe").readyState == "complete") {
			        IFrameRefresh();
			    }
			}
			catch (e) {}
		}

	} catch (e) {}
}

function ConvertKoreanByStatusText(statusText) {
    var kText = statusText;
    switch (statusText.toUpperCase()) {
        case "AVAILABLE":
            kText = NameControlstrLang4;
            break;
        case "OFFLINE":
            kText = NameControlstrLang5;
            break;
        case "BUSY":
            kText = NameControlstrLang6;
            break;
        case "DO NOT DISTURB":
            kText = NameControlstrLang7;
            break;
        case "BE RIGHT BACK":
            kText = NameControlstrLang8;
            break;
        case "AWAY":
            kText = NameControlstrLang9;
            break;
        case "INACTIVE":
            kText = NameControlstrLang10;
            break;
        case "ON A PHONE":
            kText = NameControlstrLang11;
            break;
        case "IN A CONFERENCE":
            kText = NameControlstrLang12;
            break;
        case "PRESENTATION":
            kText = NameControlstrLang23;
            break;
        case "UNKNOWN":
            kText = NameControlstrLang13;    
    }

    return kText;
}

// Lync 2010 버전에서 Communicator API를 이용하는 경우에만 사용된다.
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
            imgobj.alt = NameControlstrLang13;
        }
        oPersona = null;
    }
}

// 아이콘 업데이트
function PresenceImageUpdate(objEvent) {
    var obj = GetCurrentEvent(objEvent);  //window.event.srcElement;
    obj = GetEventTarget(obj);
	var id = obj.id;	
	var uri = "";
	// Office 사용자
	if (PresenceControlURIDictionaryObj)
	{
		/*
		// NameControl 사용 시 마우스 오버 시 Presence 이미지 업데이트 하지 않도록 처리
		if (PresenceControlURIDictionaryObj[id])
		{
			uri = PresenceControlURIDictionaryObj[id];
			var state = 1, img;
			try
			{
				state = PresenceControlObject.GetStatus(uri, id);
				img = PresenceControlGetStatusImage(state);
				PresenceControlUpdateImage(id, img);
				PresenceControlStatesDictionaryObj[id] = state;
			} catch (e) {}
		}
		*/
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

// Lync 로그인 사용자
var g_StoreMyID = "";
function getMySignInName()
{
	var MyID = "";

	if (g_StoreMyID == "")
	{
		if (CheckLync2010Higher() == true)
		{
			// Lync 2013 이상의 상위 버전인 경우
			MyID = GetSignInNameFromRegistry();
		}
		else
		{
			// Lync 2010 버전은 PersonaControls ActiveX 사용
			MyID = GetSignInNameFromPersonaControls();
		}

		g_StoreMyID = MyID;
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
	if (CheckLync2010Higher() == true)
	{
		// Lync 2013 이상의 상위 버전인 경우

		CallConversationWindow(pUri, "2", "");
	}
	else
	{
		var oPersona = null;
		try {
			oPersona = new ActiveXObject("PersonaControls.Persona");
			oPersona.SipUri = pUri;
			oPersona.OpenCallMobileWindow();
			oPersona.ReleaseOC();
			oPersona = null;

			// Modal이 아닌 경우에만 blur 처리
			if (window.dialogArguments == undefined)
			{
				this.blur();
			}
		} catch (e) {
			oPersona = null;
		}
	}
}

// 회사전화 (1명)
function btn_OpenCallWorkWindow(pUri)
{
	if (CheckLync2010Higher() == true)
	{
		// Lync 2013 이상의 상위 버전인 경우

		CallConversationWindow(pUri, "2", "");
	}
	else
	{
		var oPersona = null;
		try {
			oPersona = new ActiveXObject("PersonaControls.Persona");
			oPersona.SipUri = pUri;
			oPersona.OpenCallWorkWindow();
			oPersona.ReleaseOC();
			oPersona = null;

			// Modal이 아닌 경우에만 blur 처리
			if (window.dialogArguments == undefined)
			{
				this.blur();
			}
		} catch (e) {
			oPersona = null;
		}
	}
}

// 집전화 (1명)
function btn_OpenCallHomeWindow(pUri)
{
	if (CheckLync2010Higher() == true)
	{
		// Lync 2013 이상의 상위 버전인 경우

		CallConversationWindow(pUri, "2", "");
	}
	else
	{
		var oPersona = null;
		try {
			oPersona = new ActiveXObject("PersonaControls.Persona");
			oPersona.SipUri = pUri;
			oPersona.OpenCallHomeWindow();
			oPersona.ReleaseOC();
			oPersona = null;

			// Modal이 아닌 경우에만 blur 처리
			if (window.dialogArguments == undefined)
			{
				this.blur();
			}
		} catch (e) {
			oPersona = null;
		}
	}
}

// 대화상대추가 (1명)
function btn_AddContact(pUri) {
    try {
        var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
        var strProgramFilesFolderPath = ezUtil.GetProgramFilesFolderPath(); // Program Files 폴더 경로
        strProgramFilesFolderPath = strProgramFilesFolderPath.replace(" (x86)", "");
        var strPath = strProgramFilesFolderPath + "\\Common Files\\KaoniComponent\\CheckProcess.exe";
        var argstr = "AddContactList \"" + strProgramFilesFolderPath + "\\Common Files\\KaoniComponent\\AddContactList.exe\" " + pUri + " " + displaylang;
        var oUtil = new ActiveXObject("PersonaControls.Util");
        oUtil.ExecuteShell(strPath, argstr);
        oUtil = null;
        ezUtil = null;
    }
    catch (e) { 

    }
}

// 여러명이 동시에
//  1: IM		eunkyu@kaoni.com;best2258@kaoni.com (";" 구분자로 넘겨준다.)
//  2: Phone		5886;5912 (SIP URI 에 맵핑되어야 한다.)
//  8: Audio(communicator)		eunkyu@kaoni.com;best2258@kaoni.com (";" 구분자로 넘겨준다.)
// 16: Video(communicator)		eunkyu@kaoni.com;best2258@kaoni.com (";" 구분자로 넘겨준다.)
function btn_OpenCallGroupWindow(pUri, pFlag)
{
	if (pUri == "" || pFlag == "")
		return;


	if (CheckLync2010Higher() == true)
	{
		// Lync 2013 이상의 상위 버전인 경우

		CallConversationWindow(pUri, pFlag, "");
	}
	else
	{
		// SIP주소인 경우 앞에 "sip:" 이 붙도록 처리
		var pSipUri = ConvertUri(pUri);

		var oPersona = null;
		try {
			oPersona = new ActiveXObject("PersonaControls.Persona");
			oPersona.OpenCallGroupWindow(pSipUri, pFlag);
			oPersona.ReleaseOC();
			oPersona = null;

			// Modal이 아닌 경우에만 blur 처리
			if (window.dialogArguments == undefined)
			{
				this.blur();
			}
		} catch (e) {
			oPersona = null;
		}
	}
}

// Lync IM, Audio, Video로 call 처리
// pSipUri: 수신자Id(여러명인경우 ;(세미콜론)으로 구분), Sip Uri 또는 전화번호
// pFlag: 구분자(1: IM, 2: Audio, 3: Video)
// pMessage: IM 전송(pFlag: 1)인 경우 Toast로 보낼 메시지
function CallConversationWindow(pUri, pFlag, pMessage)
{
	if (pUri == "" || pFlag == "")
		return;

	// SIP주소인 경우 앞에 "sip:" 이 붙도록 처리
	var pSipUri = ConvertUri(pUri);

	// Flag를 CallConversationWindow.exe에 맞게 변경한다. (이전 버전의 소스코드와 호환성 유지)
	if (pFlag == "8")
	{
		pFlag = "2";	// Audio
	}
	else if (pFlag == "16")
	{
		pFlag = "3";	// Video
	}

	try {
		var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
		var strProgramFilesFolderPath = ezUtil.GetProgramFilesFolderPath(); // Program Files 폴더 경로
		strProgramFilesFolderPath = strProgramFilesFolderPath.replace(" (x86)", "");
		var strPath = strProgramFilesFolderPath + "\\Common Files\\KaoniComponent\\CallConversationWindow.exe";
		var argstr = pSipUri + "|" + pFlag + "|" + pMessage;

		var oUtil = new ActiveXObject("PersonaControls.Util");
		oUtil.ExecuteShell(strPath, argstr);
		oUtil = null;
		ezUtil = null;

		// Modal이 아닌 경우에만 blur 처리
		//if (window.dialogArguments == undefined)
		//{
		//	this.blur();
		//}
	}
	catch (e)
	{ }
}

// 인자값으로 전달할 SipUri/전화번호 정보를 보정한다.
function ConvertUri(pUri)
{
	var pSipUri = "";

	if (pUri != "")
	{
		// SIP주소인 경우 앞에 "sip:" 이 붙도록 처리
		var pArr = pUri.split(";");
		for (var i=0; i<pArr.length; i++)
		{
			var temp = pArr[i].toLowerCase();

			// SIP Uri: "@" 문자가 포함된 경우
			if (temp.indexOf("@") >= 0)
			{
				// sip: + 주소 형태로 변경
				if (temp.indexOf("sip:") < 0)
					temp = "sip:" + temp;
			}
			else
			{
				// 전화번호 처리
				temp = CheckPhoneNumber(temp);		// 전화번호인 경우 앞에 +를 붙여준다.
				temp = ReplaceText(temp, "-", "");	// - 문자를 제거한다.
			}

			pSipUri = pSipUri + temp;
			if (i != pArr.length-1)
				pSipUri = pSipUri + ";";
		}
	}

	return pSipUri;
}


// orgStr 의 문자열 중에 findStr 에 해당하는 문자열을 replaceStr 로 바꿉니다.
// 이 때 findStr 에는 정규식에 해당하는 문자열 경우 "\\" + findStr 형식으로 주어야 합니다.
function ReplaceText( orgStr, findStr, replaceStr )
{
	var re = new RegExp( findStr, "gi" );
	
	return ( orgStr.replace( re, replaceStr ) );
}


// 전자메일을 보내는 메소드
function btn_OpenSendEMail(email)
{
    try {       
        if(email != "") {
            document.location.href = "mailto:" + email;
        }
    } catch(e) {
    }
}

// 이미지에 이벤트 추가
function AddPresenceEvt(id)
{
	var oimg = document.images[id];
	if (oimg == null)
	    oimg = document.images.item(id);
	try {
	    if (oimg.length != null) {
	        if (oimg) {
	            for (var i = 0; i < oimg.length; i++) {
	                oimg[i].style.cursor = "pointer";
	                oimg[i].onmouseover = PresenceImageUpdate;
	                oimg[i].onmouseout = HideLayer;
	                oimg[i].onclick = ViewContext;
	            }
	        }
	    }
	    else {
	        if (oimg) {
	            oimg.style.cursor = "pointer";
	            oimg.onmouseover = PresenceImageUpdate;
	            oimg.onmouseout = HideLayer;
	            oimg.onclick = ViewContext;
	        }
	    }
	}
	catch (e) {}
}

// Context Menu를 보여주기 위한 처리
function ViewContext(objEvent) {
        var MyID = "";

        // 크로스 브라우져일 경우 메뉴 확장 후 return 처리.
        if (IsSupportedMacBrowser() || IsSupportedNPApiBrowserOnWin()) {
            var obj = GetCurrentEvent(objEvent);
            PresenceControlImageOnClick(obj);
            return;
        }
        else {
            MyID = getMySignInName();
            if (MyID == "") {
                alert(NameControlstrLang1);
                return;
            }
        }

        var obj = window.event.srcElement;
        var id = obj.id;
        var uri = "";

        // 조직도 사진 이미지를 클릭한 경우 고려
        id = id.replace(":photo", "");

        // Office 사용자
        if (PresenceControlURIDictionaryObj) {
            if (PresenceControlURIDictionaryObj[id]) {
                uri = PresenceControlURIDictionaryObj[id];
            }
        }
        else if (GumdropURIDictionaryObj)	// OC 개체 이용 시
        {
            if (GumdropURIDictionaryObj[id]) {
                uri = GumdropURIDictionaryObj[id];
            }
        }

        if (uri != "") {
            // 가온아이 Context Menu를 사용하는 경우
            if (presenceType == 1) {
                CreateLayer(uri, MyID);
            }
            else if (presenceType == 2)	// Name.dll을 사용하는 경우
            {
                // Modal창에서 호출한 경우
                if (window.dialogArguments != undefined) {
                    // 가온아이 Context Menu를 보여준다.
                    CreateLayer(uri, MyID);
                }
                else {
                    if (uri.toLowerCase() != MyID.toLowerCase()) {
                        // NameCtrl의 Context Menu를 숨김 처리
                        PresenceControlHideOOUI();

                        // IM창을 바로 띄워준다.
                        setTimeout('btn_OpenCallGroupWindow("' + uri + '", "1")', 1);
                    }
                    else {
                        alert(NameControlstrLang2);
                    }
                }
            }
        //}
    }
}

function CreateLayer(uri, MyID)
{
	var FriendlyName = "";
	var Mobile = "";
	var WorkPhone = "";
	var HomePhone = "";
	var EMail = "";

	if (CheckLync2010Higher() == true)
	{
		// Lync 2013 이상

	    var resultDOM = getPropertiesBySIPURI(uri);
	    if (resultDOM != null) {
	        var xmlDOM = new ActiveXObject("Microsoft.XMLDOM");
	        xmlDOM = resultDOM;

	        FriendlyName = xmlDOM.getElementsByTagName("ROW").item(0).selectNodes("CELL/VALUE").item(0).text; 		// displayname
	        // xmlDOM.getElementsByTagName("ROW").item(0).selectNodes("CELL/VALUE").item(1).text;			// title
	        Mobile = CheckPhoneNumber(xmlDOM.getElementsByTagName("ROW").item(0).selectNodes("CELL/VALUE").item(2).text); 	// mobile
	        WorkPhone = CheckPhoneNumber(xmlDOM.getElementsByTagName("ROW").item(0).selectNodes("CELL/VALUE").item(3).text); // telephonenumber
	        HomePhone = CheckPhoneNumber(xmlDOM.getElementsByTagName("ROW").item(0).selectNodes("CELL/VALUE").item(4).text); // homephone
	        EMail = xmlDOM.getElementsByTagName("ROW").item(0).selectNodes("CELL/VALUE").item(5).text; 			// mail
	        xmlDOM = null;
	        resultDOM = null;
	    }
	    else {
	        // 정보가 없는 경우 context메뉴가 보여지지 않도록 처리
	        return;
	    }
	}
	else
	{
		// Lync 2010 버전

		var oPersona = null;
		try {
			oPersona = new ActiveXObject("PersonaControls.Persona");
			oPersona.SipUri = uri;
			FriendlyName = oPersona.FriendlyName;
			Mobile = CheckPhoneNumber(oPersona.Mobile);
			WorkPhone = CheckPhoneNumber(oPersona.WorkPhone);
			HomePhone = CheckPhoneNumber(oPersona.HomePhone);
			EMail = oPersona.EMail;
			oPersona.ReleaseOC();
			oPersona = null;
		} catch(e) {
			oPersona = null;
			alert(e.message);
			return;
		}
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


	oouiX = event.clientX + truebody().scrollLeft;
	oouiY = event.clientY + truebody().scrollTop;


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
//		g_newlayer = document.createElement('<div id="ContextMenu" style="position:absolute;z-index:1000;font-family:dotum; font-size:9pt; color:#333333;display:inline;" onclick="this.style.display=\'none\';" onmouseout="this.style.display=\'none\';" onmouseover="this.style.display=\'\';"></div>');

	    // IE 9.0 부터 createElement의 문법이 변경되었음.
	    var parent = document.createElement("div");
	    parent.innerHTML = '<div id="ContextMenu" style="position:absolute;z-index:1000;font-family:dotum; font-size:9pt; color:#333333;display:inline;" onclick="this.style.display=\'none\';" onmouseout="this.style.display=\'none\';" onmouseover="this.style.display=\'\';"></div>';
	    g_newlayer = parent.firstChild;
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
	strHTML += '<tr onclick="show_personinfo_Lync(\'' + EMail + '\')"><td style="' + menu_icon + '"><img src="/images/ezOCS/ContextMenu/user.png" /></td><td style="' + menu_txt + '">' + FriendlyName + '</td></tr>';

	if (bUse == true) {
	    // Instance Message
	    strHTML += '<tr onclick="btn_OpenCallGroupWindow(\'' + uri + '\', \'1\')"><td style="' + menu_icon + '"><img src="/images/ezOCS/ContextMenu/user_comment.png" /></td><td style="' + menu_txt + '">' + NameControlstrLang15 + '</td></tr>';

	    // bar
	    strHTML += '<tr><td bgcolor="#ecf1f3"></td><td style="' + menu_line + '">──────────────────────────────────────────────────────────────────</td></tr>';

	    if (WorkPhone != "") {
	        //WorkPhone
	        strHTML += '<tr onclick="btn_OpenCallWorkWindow(\'' + WorkPhone + '\')"><td rowspan="2" style="' + menu_icon + '"><img src="/images/ezOCS/ContextMenu/building.png" /></td></tr>';
	        strHTML += '<tr onclick="btn_OpenCallWorkWindow(\'' + WorkPhone + '\')"><td style="' + menu_txt + '"><b>' + NameControlstrLang16 + ' </b>' + WorkPhone + '</td></tr>';
	        strHTML += '<tr><td bgcolor="#ecf1f3"></td><td height="1px"></td></tr>';
	    }

	    if (Mobile != "") {
	        //Mobile
	        strHTML += '<tr onclick="btn_OpenCallMobileWindow(\'' + Mobile + '\')"><td rowspan="2" style="' + menu_icon + '"><img src="/images/ezOCS/ContextMenu/phone.png" /></td></tr>';
	        strHTML += '<tr onclick="btn_OpenCallMobileWindow(\'' + Mobile + '\')"><td style="' + menu_txt + '"><b>' + NameControlstrLang17 + ' </b>' + Mobile + '</td></tr>';
	        strHTML += '<tr><td bgcolor="#ecf1f3"></td><td height="1px"></td></tr>';
	    }

	    if (HomePhone != "") {
	        //HomePhone
	        strHTML += '<tr onclick="btn_OpenCallHomeWindow(\'' + HomePhone + '\')"><td rowspan="2" style="' + menu_icon + '"><img src="/images/ezOCS/ContextMenu/house.png" /></td></tr>';
	        strHTML += '<tr onclick="btn_OpenCallHomeWindow(\'' + HomePhone + '\')"><td style="' + menu_txt + '"><b>' + NameControlstrLang18 + ' </b>' + HomePhone + '</td></tr>';
	    }

	    // Lync 통화
	    strHTML += '<tr onclick="btn_OpenCallGroupWindow(\'' + uri + '\', \'8\')"><td style="' + menu_icon + '"><img src="/images/ezOCS/ContextMenu/telephone_go.png" /></td><td style="' + menu_txt_bold + '">' + NameControlstrLang19 + ' </td></tr>';

	    // bar
	    strHTML += '<tr><td bgcolor="#ecf1f3"></td><td style="' + menu_line + '">──────────────────────────────────────────────────────────────────</td></tr>';

	    // 화상 통화
	    strHTML += '<tr onclick="btn_OpenCallGroupWindow(\'' + uri + '\', \'16\')"><td style="' + menu_icon + '"><img src="/images/ezOCS/ContextMenu/webcam.png" /></td><td style="' + menu_txt + '">' + NameControlstrLang20 + ' </td></tr>';

	    // 전자 메일 메시지
	    strHTML += '<tr onclick="btn_OpenSendEMail(\'' + EMail + '\')"><td style="' + menu_icon + '"><img src="/images/ezOCS/ContextMenu/email_edit.png" /></td><td style="' + menu_txt + '">' + NameControlstrLang21 + ' </td></tr>';

	    // bar
	    strHTML += '<tr><td bgcolor="#ecf1f3"></td><td style="' + menu_line + '">──────────────────────────────────────────────────────────────────</td></tr>';

	    // 대화상대 목록에 추가
	    strHTML += '<tr onclick="btn_AddContact(\'' + uri + '\')"><td style="' + menu_icon + '"><img src="/images/ezOCS/ContextMenu/add.png" /></td><td style="' + menu_txt + '">' + NameControlstrLang22 + ' </td></tr>';
	    strHTML += '<tr><td bgcolor="#ecf1f3"></td><td height="1px"></td></tr>';


	}

	strHTML += '</table>';

	g_newlayer.innerHTML = '';
	g_newlayer.innerHTML = g_newlayer.innerHTML + strHTML;
	//g_newlayer.style.cursor = "hand";
	g_newlayer.style.cursor = "pointer";
	document.body.insertBefore(g_newlayer);
}

function HideLayer() {
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

//function PopupCenter(pageURL, title, w, h) {
//    var left = (screen.width / 2) - (w / 2);
//    var top = (screen.height / 2) - (h / 2);
//    var targetWin = window.open(pageURL, title, 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
//}

// 사용자 정보 보여주기
function show_personinfo_Lync(email)
{
    var width = "420px";
    var height = "450px";
    //Allow for borders.
    var left = (screen.width / 2) - (width / 2);
    var top = (screen.height / 2) - (height / 2);
    
    if (email != "")
    {
        if(bGroupwarePresence) {
            window.open("/ezCommon/showPersonInfo.do?email=" + encodeURI(email) + "&displaylang=" + displaylang, "", "height=" + height + ",width=" + width + ", top=" + top + ", left=" + left + ",  status = no, toolbar=no, menubar=no,location=no, resizable=1");
        }
        else {
            window.open("/myoffice/ezOCS/Organinfo/ShowPersonInfo.aspx?email=" + escape(email) + "&displaylang=" + displaylang, "", "height=" + height + ",width=" + width + ", top=" + top + ", left=" + left + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
        }
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

function PresenceControlImageOnClick(objEvent) {
    if (Boolean(PresenceControlObject)) {
        PresenceControlShowOOUI(objEvent, 1);
        if (typeof PresenceControlObject.DoAccelerator != 'undefined')
            PresenceControlObject.DoAccelerator();
    } 
}

function PresenceControlGetOOUILocation(obj, fprint)
{
    var objRet = new Object;
    var objSpan = obj;
    var objOOUI = obj;
    var oouiX = 0, oouiY = 0, objDX = 0;
    var fRtl = document.dir == "rtl";
    while (objSpan && objSpan.tagName != "SPAN" && objSpan.tagName != "DIV")
    {
        objSpan = objSpan.parentNode;
    }
    if (objSpan)
    {
       var collNodes = objSpan.tagName == "DIV" ?
                       objSpan.childNodes :
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
	    var navIdx;

	    this.osver = 1.0;
	    if (Boolean(agt)) {
	        var stOSVer = agt.substring(agt.indexOf("windows ") + 11);

	        this.osver = parseFloat(stOSVer);
	    }
	    this.major = parseInt(navigator.appVersion);
	    this.nav = agt.indexOf('mozilla') != -1 && (agt.indexOf('spoofer') == -1 && agt.indexOf('compatible') == -1);
	    this.nav6 = this.nav && this.major == 5;
	    this.nav6up = this.nav && this.major >= 5;
	    this.nav7up = false;
	    if (this.nav6up) {
	        navIdx = agt.indexOf("netscape/");
	        if (navIdx >= 0)
	            this.nav7up = parseInt(agt.substring(navIdx + 9)) >= 7;
	    }
	    this.ie = agt.indexOf("msie") != -1;
	    this.ipad = agt.indexOf("ipad") != -1;
	    this.windowsphone7 = agt.indexOf("windows phone os 7.5") != -1;
	    this.aol = this.ie && agt.indexOf(" aol ") != -1;
	    if (this.ie) {
	        var stIEVer = agt.substring(agt.indexOf("msie ") + 5);

	        this.iever = parseInt(stIEVer);
	        this.verIEFull = parseFloat(stIEVer);
	    }
	    else
	        this.iever = 0;
	    this.ie4up = this.ie && this.major >= 4;
	    this.ie5up = this.ie && this.iever >= 5;
	    this.ie55up = this.ie && this.verIEFull >= 5.5;
	    this.ie6up = this.ie && this.iever >= 6;
	    this.ie7down = this.ie && this.iever <= 7;
	    this.ie8down = this.ie && this.iever <= 8;
	    this.ie7up = this.ie && this.iever >= 7;
	    this.ie8standard = this.ie && Boolean(document.documentMode) && document.documentMode == 8;
	    this.ie8standardUp = this.ie && Boolean(document.documentMode) && document.documentMode >= 8;
	    this.ie9standardUp = this.ie && Boolean(document.documentMode) && document.documentMode >= 9;
	    this.ie10standardUp = this.ie && Boolean(document.documentMode) && document.documentMode >= 10;
	    this.winnt = agt.indexOf("winnt") != -1 || agt.indexOf("windows nt") != -1;
	    this.win32 = this.major >= 4 && navigator.platform == "Win32" || agt.indexOf("win32") != -1 || agt.indexOf("32bit") != -1;
	    this.win64bit = agt.indexOf("win64") != -1;
	    this.win = this.winnt || this.win32 || this.win64bit;
	    this.mac = agt.indexOf("mac") != -1;
	    this.w3c = this.nav6up;
	    this.webKit = agt.indexOf("webkit") != -1;
	    this.safari = agt.indexOf("webkit") != -1;
	    this.safari125up = false;
	    this.safari3up = false;
	    if (this.safari && this.major >= 5) {
	        navIdx = agt.indexOf("webkit/");
	        if (navIdx >= 0)
	            this.safari125up = parseInt(agt.substring(navIdx + 7)) >= 125;
	        var verIdx = agt.indexOf("version/");

	        if (verIdx >= 0)
	            this.safari3up = parseInt(agt.substring(verIdx + 8)) >= 3;
	    }
	    this.firefox = this.nav && agt.indexOf("firefox") != -1;
	    this.firefox3up = false;
	    this.firefox36up = false;
	    this.firefox4up = false;
	    if (this.firefox && this.major >= 5) {
	        var ffVerIdx = agt.indexOf("firefox/");

	        if (ffVerIdx >= 0) {
	            var firefoxVStr = agt.substring(ffVerIdx + 8);

	            this.firefox3up = parseInt(firefoxVStr) >= 3;
	            this.firefox36up = parseFloat(firefoxVStr) >= 3.6;
	            this.firefox4up = parseInt(firefoxVStr) >= 4;
	        }
	    }
	    this.win8AppHost = agt.indexOf("msapphost") != -1;
	    this.chrome = this.nav && agt.indexOf("chrome") != -1;
	    this.chrome7up = false;
	    this.chrome8up = false;
	    this.chrome9up = false;
	    if (this.chrome && this.major >= 5) {
	        var chmVerIdx = agt.indexOf("chrome/");

	        if (chmVerIdx >= 0) {
	            var chmVerStr = agt.substring(chmVerIdx + 7);
	            var chmVerInt = parseInt(chmVerStr);

	            this.chrome7up = chmVerInt >= 7;
	            this.chrome8up = chmVerInt >= 8;
	            this.chrome9up = chmVerInt >= 9;
	        }
	    }
	    this.msTouch = typeof navigator.msPointerEnabled != "undefined" && navigator.msPointerEnabled;
	    this.isTouch = this.msTouch || "ontouchstart" in document.documentElement;
	    this.armProcessor = agt.indexOf("arm") != -1;
	}
	catch(ex)
	{}
}

//************************** 추가한 함수 시작 ***********************************//
// 프리젠스를 표시할 Plugin 참조
function CreateNPApiOnWindowsPlugin(strMimeType) {
    var plugin = null;

    if (IsSupportedNPApiBrowserOnWin()) {
        try {
            plugin = document.getElementById(strMimeType);
            if (!Boolean(plugin) && IsNPAPIOnWinPluginInstalled(strMimeType)) {
                var pluginNode = document.createElement("object");

                pluginNode.id = strMimeType;
                pluginNode.type = strMimeType;
                pluginNode.width = "0";
                pluginNode.height = "0";
                pluginNode.style.setProperty("visibility", "hidden", "");
                document.body.appendChild(pluginNode);
                plugin = document.getElementById(strMimeType);
            }
        }
        catch (e) {
            plugin = null;
        }
    }
    return plugin;
}

// OS가 windows고 브라우져가 파폭인지
function IsSupportedFirefoxOnWin() {
    return PresenceControlbrowseris.win && PresenceControlbrowseris.firefox3up;
}
// OS가 windows고 브라우져가 크롬인지
function IsSupportedChromeOnWin() {
    return PresenceControlbrowseris.win && PresenceControlbrowseris.chrome;
}
// 지원 가능 브라우져 인지 확인
function IsSupportedNPApiBrowserOnWin() {
    return IsSupportedChromeOnWin() || IsSupportedFirefoxOnWin();
}

// Plugin 설치 및 작동 유무 확인
function IsNPAPIOnWinPluginInstalled(strMimeType) {
    return Boolean(navigator.mimeTypes) && navigator.mimeTypes[strMimeType] && navigator.mimeTypes[strMimeType].enabledPlugin;
}

// 브라우져를 지원하고, Plugin이 설치되어 있는지 확인
function IsSupportedNPApiBrowser() {
    if (IsSupportedNPApiBrowserOnWin()) {
        if (IsNPAPIOnWinPluginInstalled("application/x-sharepoint-uc")) {
            return true;
        }
    }
    return false;
}

function GetCurrentEvent(objEvent) {
    if (PresenceControlbrowseris.ie5up)
        return window.event;
    if (Boolean(objEvent))
        return objEvent;
    return window.event;
}
function GetEventTarget(objEvent) {
    if (Boolean(objEvent.srcElement))
        return objEvent.srcElement;
    return objEvent.target;
}
function DiscardPresenceControl() {
    if (PresenceControlObject != null)
        PresenceControlObject = null;
}
function AddEvtHandler(ele, strEvt, func) {
    if (PresenceControlbrowseris.ie)
        ele.attachEvent(strEvt, func);
    else
        ele.addEventListener(strEvt.substr(2), func, false);
}


//************************** Mac OS 지원 시작 **********************************//
// Mac OS 지원 확인
function IsSupportedMacBrowser() {
    return PresenceControlbrowseris.mac && (PresenceControlbrowseris.firefox3up || PresenceControlbrowseris.safari3up || PresenceControlbrowseris.chrome);
}

// Mac OS 에서 Plugin 활성화
function CreateMacPlugin() {
    var plugin = null;

    if (IsSupportedMacBrowser()) {
        plugin = document.getElementById("macSharePointPlugin");
        if (plugin == null && IsMacPluginInstalled()) {
            var pluginMimeType = null;

            if (PresenceControlbrowseris.safari3up && IsBrowserPluginInstalled("application/x-sharepoint-webkit"))
                pluginMimeType = "application/x-sharepoint-webkit";
            else
                pluginMimeType = "application/x-sharepoint";
            var pluginNode = document.createElement("object");

            pluginNode.id = "macSharePointPlugin";
            pluginNode.type = pluginMimeType;
            pluginNode.width = "0";
            pluginNode.height = "0";
            pluginNode.style.visibility = "hidden";
            document.body.appendChild(pluginNode);
            plugin = document.getElementById("macSharePointPlugin");
        }
    }
    return plugin;
}

// Mac OS에서 Plugin이 설치 되었는지 확인
function IsMacPluginInstalled() {
    var webkitPluginInstalled = IsBrowserPluginInstalled("application/x-sharepoint-webkit");
    var npapiPluginInstalled = IsBrowserPluginInstalled("application/x-sharepoint");

    if (PresenceControlbrowseris.safari3up && webkitPluginInstalled)
        return true;
    return npapiPluginInstalled;
}

// Mac OS 브라우져에 Plugin 설치 확인
function IsBrowserPluginInstalled(mimeType) {
    var hasMimeType = Boolean(navigator.mimeTypes) && navigator.mimeTypes[mimeType];

    if (hasMimeType) {
        var type = navigator.mimeTypes[mimeType];

        return !!type.enabledPlugin;
    }
    return false;
}

//************************** Mac OS 지원 끝 **********************************//

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
    var obj = document.images[id];
    if (obj == undefined)
        obj = document.images.item(id);
    try {
        if (obj.length != null) {
            if (obj) {
                for (var i = 0; i < obj.length; i++) {
                    var oldImg = obj[i].src;
                    var index = oldImg.lastIndexOf("/");
                    var newImg = oldImg.slice(0, index + 1);
                    newImg += img;
                    if (oldImg != newImg)
                        obj[i].src = newImg;
                    if (obj[i].altbase)
                        obj[i].alt = obj[i].altbase;
                }
            }
        }
        else {
            if (obj) {
                var oldImg = obj.src;
                var index = oldImg.lastIndexOf("/");
                var newImg = oldImg.slice(0, index + 1);
                newImg += img;
                if (oldImg != newImg)
                    obj.src = newImg;
                if (obj.altbase)
                    obj.alt = obj.altbase;
            }
        }
    }
    catch (e) { }
}

//This function is called on the PageLoad to show the status gumdrop
//for a contact.
function Gumdrop(uri, pObj)
{
    
    if (uri == null || uri == '')
        return;
        
    var obj = pObj
    var id = obj.id;
    var Contact;
    var myID;

	if(bInstall) {
	    myID = getMySignInName();
	    if(myID != "") {
    	    try {
    	        if(g_StatusInterval == null)
        		{
    	            if(document.getElementById("MOC_Div") == undefined)
    	            {
    	                g_MOC_Div = document.createElement('<div id="MOC_Div" style="display:none;"></div>');
    	                document.body.insertBefore(g_MOC_Div);
    	                document.getElementById("MOC_Div").innerHTML = '<object id="MOC" height="0" style="display:none"; codeType="application/x-oleobject" width="0" classid="clsid:8885370D-B33E-44B7-875D-28E403CF9270" VIEWASTEXT></object>';
    	                setTimeout("function MOC.object::OnContactStatusChange(contact, state) { UpdateStatus('PresenceUpdate'); }", 10);
    	                //MOCObjectEventEnable();
    	            }
    	            else if(document.getElementById("MOC_Div").innerHTML == "") 
    	            {
    	                document.getElementById("MOC_Div").innerHTML = '<object id="MOC" height="0" style="display:none"; codeType="application/x-oleobject" width="0" classid="clsid:8885370D-B33E-44B7-875D-28E403CF9270" VIEWASTEXT></object>';
    	                setTimeout("function MOC.object::OnContactStatusChange(contact, state) { UpdateStatus('PresenceUpdate'); }", 10);
    	                //MOCObjectEventEnable();
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
	    if (document.getElementById(id) != null) {
	        GumdropUpdateImage(id, "PresenceControlBLANK.GIF");
	        return;
	    }
	    else
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

            // Presence 이미지에 Event추가
            AddPresenceEvt(id);
        }
    }
}

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

	try
	{
		var oIframe = document.getElementById("Presence_iframe");
		document.body.removeChild(oIframe); 

		var oDiv = document.getElementById("Presence_Div");
		document.body.removeChild(oDiv); 
	} catch (e) {}
}
function CustomRandom() {
    var now = new Date();
    var seed = now.getMilliseconds();
    return Math.random(seed) + 1;
}
function S4() { 
    return ((CustomRandom() * 0x10000) | 0).toString(16).substring(1);
} 
function GetGUID() { 
   return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4()); 
}

// 사번 또는 E-Mail 주소로 SIP URI를 가져온다.
function getSIPUri(strCNList, strEMailList) {
    if(bGroupwarePresence) {
    	url = "/ezOrgan/getSIPUriList.do";
    }
    else {
    	url = "/myoffice/ezOCS/OrganInfo/ezOrgan/GetSIPUriList.aspx";
    }
    $.ajax({
		type : "POST",
		dataType : "json",
		async : false,
		url : url,
		data : { cnList : strCNList,
					  emailList : strEMailList
					},
		success: function(result){
			strRet = result.strRet;
		},
		error: function(){
			strRet = "";
		} 
	});
    return strRet;
}

function GetLang() {

    // 메신저 설정 언어를 가져온다.
    try {
        displaylang = GetLyncLanguage();

        SelectLang(displaylang);
        return;
    }
    catch (e) {}


    // 쿠키값의 Lang 값을 가져온다.
    try {
        var idx_s = document.cookie.indexOf("LANG=");
        if (idx_s > -1) {
            idx_s = document.cookie.indexOf("=", idx_s) + 1;
            var idx_e = document.cookie.indexOf("&", idx_s);
            if (idx_e > -1) {
                displaylang = document.cookie.substring(idx_s, idx_e);
            }
            else {
                displaylang = document.cookie.substring(idx_s, document.cookie.length);
            }
            switch (displaylang) {
                case "1" : displaylang = "1042"; break;
                case "2" : displaylang = "1033"; break;
                case "3" : displaylang = "1041"; break;
                case "4" : displaylang = "3076"; break;
                default : displaylang = "1042"; break;
            }
        }
    }
    catch (e) {
        displaylang = "1042";
    }
    SelectLang(displaylang);
}

function SelectLang(lang) {
    switch(lang) {
        case "1042":   // 한국어
            NameControlstrLang1 = "메신저에 로그인 후 대화가 가능합니다.";
            NameControlstrLang2 = "자기 자신에게는 대화 요청을 할 수 없습니다.";
            NameControlstrLang3 = "대화상대가 메신저에 접속해 있지 않습니다.";
            NameControlstrLang4 = "대화 가능";
            NameControlstrLang5 = "오프라인";
            NameControlstrLang6 = "다른 용무 중";
            NameControlstrLang7 = "방해 금지";
            NameControlstrLang8 = "곧 돌아오겠음";
            NameControlstrLang9 = "자리 비움";
            NameControlstrLang10 = "대화 불가능";
            NameControlstrLang11 = "통화 중";
            NameControlstrLang12 = "회의 중";
            NameControlstrLang13 = "알 수 없음";
            NameControlstrLang14 = "대화상대추가";
            NameControlstrLang15 = "인스턴트 메시지 보내기";
            NameControlstrLang16 = "회사: ";
            NameControlstrLang17 = "휴대폰: ";
            NameControlstrLang18 = "집: ";
            NameControlstrLang19 = "Lync 통화";
            NameControlstrLang20 = "화상 통화 시작";
            NameControlstrLang21 = "전자 메일 메시지 보내기";
            NameControlstrLang22 = "대화상대 목록에 추가";
            NameControlstrLang23 = "프리젠테이션 중";
            break;
        case "1041":   // 일어
            NameControlstrLang1 = "メッセンジャーにログイン後話ができます。";
            NameControlstrLang2 = "自分は会話要求を行うことができません。";
            NameControlstrLang3 = "話相手がメッセンジャーに接續していません。";
            NameControlstrLang4 = "連絡可能";
            NameControlstrLang5 = "オフライン";
            NameControlstrLang6 = "取り込み中";
            NameControlstrLang7 = "応答不可";
            NameControlstrLang8 = "一時退席中";
            NameControlstrLang9 = "退席中";
            NameControlstrLang10 = "非アクティブ";
            NameControlstrLang11 = "通話中";
            NameControlstrLang12 = "会議中";
            NameControlstrLang13 = "状態確認不可";
            NameControlstrLang14 = "連絡先追加";
            NameControlstrLang15 = "インスタントメッセージの送信";
            NameControlstrLang16 = "会社: ";
            NameControlstrLang17 = "ケータイ: ";
            NameControlstrLang18 = "自宅: ";
            NameControlstrLang19 = "Lync 通話";
            NameControlstrLang20 = "テレビ通話の開始";
            NameControlstrLang21 = "電子メールメッセージを送信";
            NameControlstrLang22 = "連絡先リストに追加";
            NameControlstrLang23 = "プレゼンテーション";
            break;
        case "1033":   // 영어
            NameControlstrLang1 = "After log in, IM is possible.";
            NameControlstrLang2 = "Can't request IM to yourself.";
            NameControlstrLang3 = "User are not logged in.";
            NameControlstrLang4 = "Available";
            NameControlstrLang5 = "Offline";
            NameControlstrLang6 = "Busy";
            NameControlstrLang7 = "Do Not Disturb";
            NameControlstrLang8 = "Be Right Back";
            NameControlstrLang9 = "Away";
            NameControlstrLang10 = "Inactive";
            NameControlstrLang11 = "In a call";
            NameControlstrLang12 = "In a conference";
            NameControlstrLang13 = "Unknown";
            NameControlstrLang14 = "Add Contact";
            NameControlstrLang15 = "Send an Instant Message";
            NameControlstrLang16 = "Work: ";
            NameControlstrLang17 = "Mobile: ";
            NameControlstrLang18 = "Home: ";
            NameControlstrLang19 = "Lync Call";
            NameControlstrLang20 = "Start a Video Call";
            NameControlstrLang21 = "Send an Email Message";
            NameControlstrLang22 = "Add to Cantacts List";
            NameControlstrLang23 = "Presenting";
            break;
        case "1028":
        case "2052":
        case "3076":         //중국어
            NameControlstrLang1 = "登录到Messenger后的对话是可能的。";
            NameControlstrLang2 = "对于他自己的请求将无法对话。";
            NameControlstrLang3 = "Messenger无法连接到您的联系人。";
            NameControlstrLang4 = "有空";
            NameControlstrLang5 = "脱机";
            NameControlstrLang6 = "忙碌";
            NameControlstrLang7 = "请勿打扰";
            NameControlstrLang8 = "马上回来";
            NameControlstrLang9 = "离开";
            NameControlstrLang10 = "非活动状态";
            NameControlstrLang11 = "接听电话";
            NameControlstrLang12 = "会议中";
            NameControlstrLang13 = "显示状态未知";
            NameControlstrLang14 = "添加联系人";
            NameControlstrLang15 = "发送即时消息";
            NameControlstrLang16 = "公司: ";
            NameControlstrLang17 = "移动电话: ";
            NameControlstrLang18 = "家庭: ";
            NameControlstrLang19 = "Lync 通话";
            NameControlstrLang20 = "开始视频通话";
            NameControlstrLang21 = "发送电子邮件";
            NameControlstrLang22 = "发送电子邮件";
            NameControlstrLang23 = "呈现";
            break;
        default :
            NameControlstrLang1 = "메신저에 로그인 후 대화가 가능합니다.";
            NameControlstrLang2 = "자기 자신에게는 대화 요청을 할 수 없습니다.";
            NameControlstrLang3 = "대화상대가 메신저에 접속해 있지 않습니다.";
            NameControlstrLang4 = "대화 가능";
            NameControlstrLang5 = "오프라인";
            NameControlstrLang6 = "다른 용무 중";
            NameControlstrLang7 = "방해 금지";
            NameControlstrLang8 = "곧 돌아오겠음";
            NameControlstrLang9 = "자리 비움";
            NameControlstrLang10 = "대화 불가능";
            NameControlstrLang11 = "통화 중";
            NameControlstrLang12 = "회의 중";
            NameControlstrLang13 = "알 수 없음";
            NameControlstrLang14 = "대화상대추가";
            NameControlstrLang15 = "인스턴트 메시지 보내기";
            NameControlstrLang16 = "회사: ";
            NameControlstrLang17 = "휴대폰: ";
            NameControlstrLang18 = "집: ";
            NameControlstrLang19 = "Lync 통화";
            NameControlstrLang20 = "화상 통화 시작";
            NameControlstrLang21 = "전자 메일 메시지 보내기";
            NameControlstrLang22 = "대화상대 목록에 추가";
            NameControlstrLang23 = "프리젠테이션 중";
            break;
    }
}

// SipUri를 이용하여 사용자 속성 정보를 가져온다. (Lync 2013에서 사용)
function getPropertiesBySIPURI(pSipUri) {
    
    var adCount = 0;
    var xmlHTTP = createXMLHttpRequest();
    var xmlDOM = createXmlDom();

 	$.ajax({
			url : '/ezOrgan/getSearchList.do',
			method : 'POST',
			dataType : "json",
			data : {
				search : "EXACT_SIPURI::" + pSipUri ,
				cell : "displayName;title;mobile;telephoneNumber;homePhone;mail",
				prop : "",
				type : "user",
				lang : displaylang
			} ,
			success : function(data, textStatus, jqXHR) {

			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert(textStatus);
			}
		}); 
   /* var objNode;
    createNodeInsert(xmlDOM, objNode, "DATA");
    createNodeAndInsertText(xmlDOM, objNode, "SEARCH", "EXACT_SIPURI::" + pSipUri);
    createNodeAndInsertText(xmlDOM, objNode, "CELL", "displayName;title;mobile;telephoneNumber;homePhone;mail");
    createNodeAndInsertText(xmlDOM, objNode, "PROP", "");
    createNodeAndInsertText(xmlDOM, objNode, "TYPE", "user");
    createNodeAndInsertText(xmlDOM, objNode, "LANG", displaylang);*/

    /*try {
        if(bGroupwarePresence) {
            xmlHTTP.open("POST", "/ezOrgan/getSearchList.do", false);
        }
        else {
            xmlHTTP.open("POST", "/ezOrgan/getSearchList.do", false);
        }
        xmlHTTP.send(xmlDOM);

        if (xmlHTTP.statusText != "OK") {
            xmlDOM = null;
            xmlHTTP = null;
        }
        else {
            xmlDOM = loadXMLString(xmlHTTP.responseText);
            adCount = xmlDOM.getElementsByTagName("ROW").length;
        }
    }
    catch (e) {
        alert("getPropertiesBySIPURI: " + e.description);
        xmlDOM = null;
        xmlHTTP = null;
    }

    if (adCount == 0)
    {
        xmlDOM = null;
    }

    return xmlDOM; */
}

// xmlPresenceDom(LyncDB에서 쿼리해온 사용자 state xml)에서 사용자 state 쿼리해서 NameControl state에 맞게 변환
function GetLyncDBStatus(pUri) {
    var findNode = "A" + pUri.toUpperCase().replace("@", "_");
    var pState = 1;
    try {
        if (xmlPresenceDom.getElementsByTagName(findNode).length != 0) {
            if (typeof xmlPresenceDom.getElementsByTagName(findNode).item(0).text != "undefined")
                pState = ConvertLyncDBState_ToNameControlState(xmlPresenceDom.getElementsByTagName(findNode).item(0).text);
            else
                pState = ConvertLyncDBState_ToNameControlState(xmlPresenceDom.getElementsByTagName(findNode).item(0).textContent);
        }
    }
    catch (e) {  }
    
    return pState;
}

// Lync DB에서 사용자 State 쿼리해서 xmlPresenceDom에 저장(USERID에 사용자 sipuri값 ,로 구분하여 전달)
function getxmlPresenceDom(pUserIDs) {
    if (pUserIDs != "" && pUserIDs != null) {
        var xmldom = createXmlDom();
        var p_xmlHTTP = createXMLHttpRequest();

        var objNode;
        createNodeInsert(xmldom, objNode, "PARAM");
        createNodeAndInsertText(xmldom, objNode, "USERID", pUserIDs);

        // 그룹웨어 프리젠스일 시
        if (bGroupwarePresence) {
            var objNode = xmldom.createNode(1, "TabURL", "");
            createNodeAndInsertText(xmldom, objNode, "TABURL", LyncTabURL);
            p_xmlHTTP.open("POST",  "/myoffice/Common/GetPresenceState_GroupWare.aspx", false);
            p_xmlHTTP.send(xmldom);
            if (p_xmlHTTP != null && p_xmlHTTP.readyState == 4) {
                if (p_xmlHTTP.statusText == "OK") {
                    try {
                        xmlPresenceDom = p_xmlHTTP.responseXML;
                        //xmlPresenceDom.load(p_xmlHTTP.responseXML);
                    }
                    catch (e) {}
                }
            }
        }
        else {
            p_xmlHTTP.open("POST", "/myoffice/ezOCS/Remote/GetPresenceState.aspx", false);
            p_xmlHTTP.send(xmldom);
            if (p_xmlHTTP != null && p_xmlHTTP.readyState == 4) {
                if (p_xmlHTTP.statusText == "OK") {
                    try {
                        xmlPresenceDom = p_xmlHTTP.responseXML;
                        //xmlPresenceDom.load(p_xmlHTTP.responseXML);
                    }
                    catch (e) {}
                }
            }
        }
        xmldom = null;
        p_xmlHTTP = null;
    }
}

// GetStatus 함수 호출 후 Lync DB에서 가져온 State 입히는 함수
function UpdateInitState(id, state) {
	var img = PresenceControlGetStatusImage(state);
        PresenceControlUpdateImage(id, img);
        PresenceControlStatesDictionaryObj[id] = state;	
	try {
        var obj = document.images[id];
        if (obj == undefined)
            obj = document.images.item(id);
        if (obj.length != null) {
            if (obj)
            {
                for (var i = 0; i < obj.length; i++) {
                    obj[i].alt = ConvertKoreanByStatusText(PresenceControlGetStatusText(state));
                    // 사용자 이미지에도 alt 명 추가 (img 태그 id 형식 : 프리젠스 img 태그 id + :photo)
                    document.images[id + ":photo"][i].alt = obj[i].alt;
                }
	    }
        }
        else  {
            if (obj)
            {
                obj.alt = ConvertKoreanByStatusText(PresenceControlGetStatusText(state));
                // 사용자 이미지에도 alt 명 추가 (img 태그 id 형식 : 프리젠스 img 태그 id + :photo)
                document.images[id + ":photo"].alt = obj.alt;
            }
        }
	}
	catch(e) { }
}

//************************ 크로스 브라우져 ajax 처리 함수 시작 ************************//
// XMLHttpRequest 객체를 생성합니다.
function createXMLHttpRequest() {
    var oXmlRequest;
    try {
        oXmlRequest = new XMLHttpRequest();
    }
    catch (trymicrosoft) {
        try {
            oXmlRequest = new ActiveXObject("Microsoft.XMLHTTP");
        }
        catch (failed) {
            oXmlRequest = failed;
        }
    }

    return oXmlRequest;
}
// DOM 객체를 생성합니다.
function createXmlDom() {
    var xmlDoc;

    if (window.ActiveXObject) {
        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
    }
    else if (document.implementation && document.implementation.createDocument) {
        xmlDoc = document.implementation.createDocument("", "", null);
    }
    else {
        xmlDoc = null;
    }

    return xmlDoc;
}
// XMLString을 DOM 객체로 반환합니다.
function loadXMLString(xmlstring) {
    var xmlDoc;
    if (window.ActiveXObject) {
        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
        xmlDoc.async = "false";
        xmlDoc.loadXML(xmlstring);
    }
    else if (window.DOMParser) {
        var parser = new DOMParser();
        xmlDoc = parser.parseFromString(xmlstring, "text/xml");
        parser = null;
    }
    return xmlDoc;
}
// 노드를 생성합니다.
function createNode(node, tagName) {
    if (window.ActiveXObject) {
        return node.createNode(1, tagName, "");
    }
    else if (window.DOMParser) {
        return node.createElement(tagName);
    }
}
// text를 추가합니다.
function InsertText(xmlDoc, node, value) {
    if (window.ActiveXObject) {
        node.text = value;
        xmlDoc.documentElement.appendChild(node);
    }
    else if (window.DOMParser) {
        var newText = document.createTextNode(value);
        node.appendChild(newText);
        xmlDoc.documentElement.appendChild(node);
    }
}
// 노드를 생성하고 rootNode를 추가합니다.
function createNodeInsert(xmlparam, node, tagName) {
    node = createNode(xmlparam, tagName);
    xmlparam.appendChild(node);
    return node;
}
// 노드를 생성하고 text를 추가합니다.
function createNodeAndInsertText(xmlparam, node, tagName, value) {
    node = createNode(xmlparam, tagName);
    InsertText(xmlparam, node, value);
    return node;
}
// 노드 텍스트를 가져옵니다.
function getNodeText(node) {
    var result = "";
    if (window.ActiveXObject) {
        result = node.text;
    }
    else if (window.DOMParser) {
        result = node.textContent;
    }
    return result;
}
//************************ 크로스 브라우져 ajax 처리 함수 끝 ************************//