/********************************************************************************************
함수명      : OpenWeb()
작성목적    : 웹페이지를 호출한다.
Parameter
Return
작성자      : 유건호
최초작성일  : 2009-03-25
최종작성일  :
수정내역    : 
********************************************************************************************/
function OpenWeb(_url, _name, _height, _width, _scrollbars, _resizable, _status, _toolbar, _Menubar, _location) {
    var x = window.screen.availWidth;
    var y = window.screen.availHeight;
    var height = (_height?_height:y);    
    var width = (_width?_width:800);
    var iL = (x - width) / 2;
    var iT = (y > 600 ? (y - height) / 2 : 0);
    var _tarurl = _url ? _url : "about:blank";
    var _tarname = _name ? _name : "newWin";
    var _Opts = '';
    _Opts = _Opts + 'left='+iL;
    _Opts = _Opts + ',top='+iT;
    _Opts = _Opts + ',height='+height;
    _Opts = _Opts + ',width='+width;

    _Opts = _Opts + ',scrollbars='+(_scrollbars?_scrollbars:'no');
    _Opts = _Opts + ',status='+(_status?_status:'no');
    _Opts = _Opts + ',toolbar='+(_toolbar?_toolbar:'no');
    _Opts = _Opts + ',Menubar='+(_Menubar?_Menubar:'no');
    _Opts = _Opts + ',location='+(_location?_location:'no');
    _Opts = _Opts + ',resizable='+(_resizable?_resizable:'no');

    var newWin = null;
    try {
        newWin = window.open(_tarurl, _tarname, _Opts, false);
    }
    catch (e)
    {
        // IE 8.0 사용자 중 웹브라우저 컨트롤에서 window.open시 오류가 발생하는 case가 있으므로 별도로 처리한다.
        // Url이 지정되어 있는 경우를 제외하고, 현재 Url로 설정한다.
        if ( (_tarurl.indexOf("http://") == -1) && (_tarurl.indexOf("https://") == -1) )
        {
            _tarurl = document.location.protocol + "//" + document.location.hostname + _tarurl;
        }

//        openWindowbyezUtil(_tarurl);
    }

    try {
        newWin.focus();
    } catch (e) {}

    return newWin;
}

// Lync 옆에 조직도가 열리도록 함수 추가
function OpenWeb2(_url, _name, _scrollbars, _resizable, _status, _toolbar, _Menubar, _location) {
    var pWinWidth = 615; // 조직도 창 Width 크기
    var result = window.external.getLyncLocation();
    var pWinSize = result.split("|"); // 0:Lync x좌표, 1:Lync y좌표, 2:Lync Width, 3:Lync Height, 4:Titlebar Size, 5:Border X Size, 6:Border Y Size, 7:TabService Height, 8:TabService Width
    // window x 시작 위치 설정

    if (pWinSize[0] > pWinWidth + pWinSize[5] * 2 + 4)
        pWinSize[0] = pWinSize[0] - pWinWidth - pWinSize[5] * 2 - 4;
    else
        pWinSize[0] = 0;
    // 탭 위치에 따라 위치 및 크기 설정
    if (TabOption == "0") {
        pWinSize[3] = pWinSize[3] - pWinSize[4] + parseInt(pWinSize[7]) - pWinSize[6] * 2 - 4;
    }
    else if (TabOption == "2") {
        pWinSize[3] = pWinSize[3] - pWinSize[4] - pWinSize[6] * 2 - 4;
        if (pWinSize[0] > pWinSize[8])
            pWinSize[0] -= pWinSize[8]
        else
            pWinSize[0] = 0;
    }
    else {
        pWinSize[3] = pWinSize[3] - pWinSize[4] - pWinSize[6] * 2 - 4;
    }

    var _tarurl = _url ? _url : "about:blank";
    var _tarname = _name ? _name : "newWin";
    var _Opts = '';
    _Opts = _Opts + 'left=' + pWinSize[0];
    _Opts = _Opts + ',top=' + pWinSize[1];
    _Opts = _Opts + ',height=' + pWinSize[3];
    _Opts = _Opts + ',width=' + pWinWidth;

    _Opts = _Opts + ',scrollbars=' + (_scrollbars ? _scrollbars : 'no');
    _Opts = _Opts + ',status=' + (_status ? _status : 'no');
    _Opts = _Opts + ',toolbar=' + (_toolbar ? _toolbar : 'no');
    _Opts = _Opts + ',Menubar=' + (_Menubar ? _Menubar : 'no');
    _Opts = _Opts + ',location=' + (_location ? _location : 'no');
    _Opts = _Opts + ',resizable=' + (_resizable ? _resizable : 'no');

    var newWin = null;
    try {
        newWin = window.open(_tarurl, _tarname, _Opts, false);

    }
    catch (e) {
        // XP, IE 8.0 사용자 중 웹브라우저 컨트롤에서 window.open시 오류가 발생하는 case가 있으므로 별도로 처리한다.
        // Url이 지정되어 있는 경우를 제외하고, 현재 Url로 설정한다.
        if ((_tarurl.indexOf("http://") == -1) && (_tarurl.indexOf("https://") == -1)) {
            _tarurl = document.location.protocol + "//" + document.location.hostname + _tarurl;
        }

//        openWindowbyezUtil(_tarurl);
    }

    try {
        newWin.focus();
    } catch (e) { }

    return newWin;
}

function useTab(el) {
    if (9 == event.keyCode) {
        (el.selection = document.selection.createRange()).text = "\t";
        event.returnValue = false;
    }
} 

function CheckReg(reg, searchword) {
    return reg.test(searchword);
}

function IEClose() {
    if (/MSIE/.test(navigator.userAgent)) {
        var version = navigator.appVersion;
        var parseVersion = new RegExp("(MSIE )([-0-9+._:]*)");
        var iVerstion;

        try {
            parseVersion.exec(version);
            iVerstion = parseInt(RegExp.$2);
        } catch (e) {
            iVerstion = 0;
        }

        if (iVerstion != 0) {
            //Explorer 7이상일때
            if (iVerstion >= 7) {
                window.open('about:blank', '_self').close();
            }
            //Explorer 7이하일때
            else {
                window.opener = self;
                self.close();
            }
        }
        else {
            //Explorer 7이상일때
            if (navigator.appVersion.indexOf("MSIE 7.0") >= 0) {
                window.open('about:blank', '_self').close();
            }
            //Explorer 7이하일때
            else {
                window.opener = self;
                self.close();
            }
        }
    }
}


function CalcuSize(fileSize) {
    if (fileSize > 1024) {
        fileSize = parseInt(fileSize / 1024);
        if (fileSize > 1024)
            fileSize = (parseInt(fileSize / 102.4) / 10) + " MB";
        else
            fileSize = fileSize + " KB";
    }
    else
        fileSize = fileSize + " Byte"

    return fileSize;
}

function Img_Swap(img, url) {
    img.src = url;
}	

String.prototype.replaceAll = function(findStr, replaceStr) {
    var regExp = new RegExp(findStr, "gi");
    return this.replace(regExp, replaceStr);
};

String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, '');
};


// ezUtil을 이용하여 internet explorer 호출
function openWindowbyezUtil(pParam) {

    var FilePath = "";
    try {
        var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
        FilePath = ezUtil.GetProgramFilesFolderPath();
        ezUtil = null;

        FilePath = FilePath + "\\Internet Explorer\\iexplore.exe";

        // IE 8.0 이상인 경우 "nomerge" 인자값을 붙여 브라우져간 세션이 공유되지 않도록 처리한다.
        var bResult = IEVersion();
        if (bResult) {
            pParam = "-nomerge " + pParam;
        }

        var oUtil = new ActiveXObject("PersonaControls.Util");
        oUtil.ExecuteShellShow(FilePath, pParam);
        oUtil = null;
    } catch (e) {

        try {
            // PersonaControls 2.0.1.2 하위 버전을 사용하는 사이트를 고려하여 예외 처리
            // PersonaControls.Util의 ExecuteShellShow 메소드는 2.0.1.2 버전 부터 지원
            var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
            ezUtil.ExecuteFile(FilePath, pParam);
            ezUtil = null;
        } catch (ex) {}

    }
}

// IE 버전이 8.0이상인지 체크
function IEVersion() {
    var bResult = false;

    if (/MSIE/.test(navigator.userAgent)) {
        var version = navigator.appVersion;
        var parseVersion = new RegExp("(MSIE )([-0-9+._:]*)");
        var iVerstion;

        try {
            parseVersion.exec(version);
            iVerstion = parseInt(RegExp.$2);
        } catch (e) {
            iVerstion = 0;
        }

        if (iVerstion != 0) {
            //Explorer 8이상일때
            if (iVerstion >= 8) {
                bResult = true;
            }
        }
        else {
            //Explorer 8이상일때
            if (navigator.appVersion.indexOf("MSIE 8.0") >= 0) {
                bResult = true;
            }
        }
    }

    return bResult;
}





///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 전역 변수 선언

var bNameControlInited = false;
var NameControlObject = null;
var g_NameControlStatus = "1";	// Name Control 상태 기본값: offline(1)로 지정, Online인 경우: 0
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// 현재 Lync에 로그인한 사용자 이름을 가져온다.
// Lync 2013 고려하여 PersonaControls ActiveX에서 값을 가져오지 못하는 경우
// 레지스트리의 값을 읽어와서 해당 사용자의 Status를 Office의 NameCtrl을 이용하여 체크하도록 처리한다.
function GetSignInName()
{
	var ocSignName = "";

	if (CheckLync2010Higher() == true)
	{
		// Lync 2013 이상의 상위 버전인 경우
		ocSignName = GetSignInNameFromRegistry();
		if (ocSignName != "")
		{
			GetNameCtrlStatus(ocSignName); // Lync 로그인 상태 체크
		}
	}
	else
	{
		// Lync 2010 버전은 PersonaControls ActiveX 사용
		ocSignName = GetSignInNameFromPersonaControls();
	}

	return ocSignName;
}

// 레지스트리에서 로그인 Id를 가져온다. (Lync 2013 이상 버전에서 사용)
function GetSignInNameFromRegistry()
{
	var ocSignName = "";

	try {
		var ezUtil = new ActiveXObject("ezUtil.RegScript");
		var pOfficeVersion = GetOfficeVersion();
		if (pOfficeVersion != "")
		{
			// HKEY_CURRENT_USER(1)
			ocSignName = ezUtil.ReadValueEx(1, "Software\\Microsoft\\Office\\" + pOfficeVersion + "\\Lync", "ServerSipUri");
		}
		ezUtil = null;
	} catch (e) {}

	return ocSignName;
}

// PersonaControls ActiveX로 부터 로그인 Id를 가져온다. (Lync 2010 버전에서 사용)
function GetSignInNameFromPersonaControls()
{
	var ocSignName = "";

	try {
		var oPersona = new ActiveXObject("PersonaControls.Persona");
		ocSignName = oPersona.MySignInName();
		oPersona.ReleaseOC();
		oPersona = null;
	} catch (e) {}

	return ocSignName;
}

function InitNameControl()
{
	if (!bNameControlInited)
	{
		try {
			NameControlObject = new ActiveXObject("Name.NameCtrl.1");
		}
		catch (e) {}
	}
	bNameControlInited = true;
	if (NameControlObject)
	{
		NameControlObject.OnStatusChange = NameControlOnStatusChange;
	}

	return NameControlObject;
}

// 현재 Lync에 로그인한 사용자의 상태정보
function GetNameCtrlStatus(pSipUri)
{
	try {
		if (InitNameControl())
		{
			// Modal창으로 호출되는 페이지는 NameControlObject.PresenceEnabled 값이 "0" 이므로
			// 로그인 상태를 체크하지 않는다.
			if (NameControlObject.PresenceEnabled)
			{
				NameControlObject.GetStatus(pSipUri, "dummy");
			}
		}
		else
		{
			// NameControl이 설치되어 있지 않은 경우 강제 종료 처리
			NameControlOnStatusChange(pSipUri, "1", "dummy");
		}
	} catch (e) {}
}

// NameControl을 사용하는 경우 NameControlObject.GetStatus 메소드에서 바로 Status값을 가져오지 못하고,
// OnStatusChange 이벤트 핸들러에서만 실제 상태를 가져올 수 있으므로 별도 처리
function NameControlOnStatusChange(name, state, id)
{
	try {
		// offine 상태에서 접속한 경우 강제 종료 처리
		if (g_NameControlStatus == "1" && state.toString() == "1")
		{
			var bIEClose = true;	// IE 강제 종료 여부
			var pHref = document.location.href.toLowerCase();

			// iconpage.aspx 호출하는 경우 예외 처리
			if (pHref.indexOf("iconpage.aspx") >= 0)
			{
				bIEClose = false;
			}
			// createuserinfo.aspx 에서 인자값에 "pageid=0" 이 있는 경우 예외 처리 (iconpage.aspx 호출)
			if ( pHref.indexOf("createuserinfo.aspx") >= 0 && pHref.indexOf("pageid=0") >=0 )
			{
				bIEClose = false;
			}
		
			// 로그인 하지 않는 사용자인 경우 강제 종료
			if (bIEClose == true)
			{
				// 조직도, 쪽지 등 개별페이지에서 접속한 사용자와 다른 경우를 체크하므로 현재 접속한 사용자의 offline 여부는 체크하지 않는다.
				//IEClose();
			}
		}

		// 접속 상태 변경
		if (g_NameControlStatus.toString() != state.toString())
		{
			g_NameControlStatus = state.toString();
		}
	} catch (e) {}
}

// Lync 2010보다 상위 버전인지 체크
function CheckLync2010Higher()
{
	var bResult = false;

	try {
	    var crossYN = false;
	    if (typeof IsSupportedMacBrowser != "undefined" && typeof IsSupportedNPApiBrowserOnWin != "undefined") {
	        if (IsSupportedMacBrowser() || IsSupportedNPApiBrowserOnWin()) {
	            crossYN = true;
	            if (typeof PresenceControlObject != "undefined") {
	                if (PresenceControlObject.PresenceEnabled == 1)
	                    bResult = true;
	            }
	        }
	    }
	    if (!crossYN) {
	        var pLyncPath = GetLyncPath();
	        if (pLyncPath.indexOf("lync.exe") >= 0) {
	            // Lync 2010 실행파일: communicator.exe
	            // Lync 2013 부터는 lync.exe 파일명을 사용한다.
	            bResult = true; // Lync 2013 이상의 상위 버전인 경우

	        }
	    }
	} catch (e) {}    

	return bResult;
}

// Lync 실행파일의 경로를 가져온다. (경로는 소문자로 치환하여 반환)
function GetLyncPath()
{
    var result = "";

    try {
        var ezUtil = new ActiveXObject("ezUtil.RegScript");
        // 0(HKEY_CLASSES_ROOT), Lync 2010과 상위버전이 공통으로 가지고 있는 레지스트리키를 이용하여 버전을 구분한다.
        var pLyncPath = ezUtil.ReadValueEx(0, "sip\\DefaultIcon", "").toLowerCase();
        result = pLyncPath.split(",")[0];
    } catch (e) {}

    return result;
}

// Lync 사용 언어를 가져온다. (레지스트리)
function GetLyncLanguage()
{
    var ocLang;

    try {
        var ezUtil = new ActiveXObject("ezUtil.RegScript");
        if (CheckLync2010Higher() == true) {
            // Lync 2013 이상의 상위 버전: Office의 언어 설정을 이용한다.
            ocLang = ezUtil.ReadValueEx(1, "Software\\Microsoft\\Shared", "OfficeUILanguage");
        }
        else {
            // Lync 2010 버전 Language
            ocLang = ezUtil.ReadValueEx(1, "Software\\Microsoft\\Communicator", "Language");
        }
        ezUtil = null;

        // ezUtil 에서 DWORD 값을 제대로 반환하이 않아 chatCodeAt 통해서 임시로 구별
        // 한국 184
        // 일본 174
        // 영어 94
        // 중국어 44, 48, 412
        switch ((ocLang.charCodeAt(0).toString() + ocLang.charCodeAt(1).toString())) {
            case "184": ocLang = "1042";
                break;
            case "174": ocLang = "1041";
                break;
            case "94": ocLang = "1033";
                break;
            case "44": ocLang = "1028";
                break;
            case "48": ocLang = "2052";
                break;
            case "412": ocLang = "3076";
                break;
            default: ocLang = "1042";
                break;
        }

    } catch (e) {
        ocLang = "1042";
    }

    return ocLang;
}

// Lync 기본 다운로드 폴더 경로
function GetDefaultReceiveFolder()
{
    var result = "";

    try {
        var ezUtil = new ActiveXObject("ezUtil.RegScript");
        if (CheckLync2010Higher() == true) {
            // Lync 2013 이상의 상위 버전 ReceiveFolder
            var pOfficeVersion = GetOfficeVersion();
            if (pOfficeVersion != "")
                result = ezUtil.ReadValueEx(1, "Software\\Microsoft\\Office\\" + pOfficeVersion + "\\Lync", "FtReceiveFolder");
        }
        else {
            // Lync 2010 버전 ReceiveFolder
            result = ezUtil.ReadValueEx(1, "Software\\Microsoft\\Communicator", "FtReceiveFolder");
        }
        ezUtil = null;

        if (result == "")
            result = "C:\\";

    } catch (e) {
        result = "C:\\";
    }

    return result;
}

// 레지스트리에서 Office 버전을 읽어온다. (예: 15.0)
// Lync 2013 이상 버전에서만 사용한다
function GetOfficeVersion()
{
    var result = "";

    try {
        // 1(HKEY_CURRENT_USER)의 해당 경로의 값에서 Office 버전 정보를 추출한다.
        var ezUtil = new ActiveXObject("ezUtil.RegScript");
        var pPath = ezUtil.ReadValueEx(1, "Software\\Microsoft\\Tracing\\UccAPI\\Lync", "FileDirectory").toLowerCase();
        ezUtil = null;

        if (pPath != "") {
            pPath = pPath.substring(pPath.indexOf("office"));
            pPath = pPath.substring(pPath.indexOf("\\") + 1);
            pPath = pPath.substring(0, pPath.indexOf("\\"));

            result = pPath;
        }
    } catch (e) {
    }

    return result;
}




