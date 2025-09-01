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
    var height = (_height ? _height : y);
    var width = (_width ? _width : 800);
    var iL = (x - width) / 2;
    var iT = (y > 600 ? (y - height) / 2 : 0);
    var _tarurl = _url ? _url : "about:blank";
    var _tarname = _name ? _name : "newWin";
    var _Opts = '';
    _Opts = _Opts + 'left=' + iL;
    _Opts = _Opts + ',top=' + iT;
    _Opts = _Opts + ',height=' + height;
    _Opts = _Opts + ',width=' + width;

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
        // IE 8.0 사용자 중 웹브라우저 컨트롤에서 window.open시 오류가 발생하는 case가 있으므로 별도로 처리한다.
        // Url이 지정되어 있는 경우를 제외하고, 현재 Url로 설정한다.
        if ((_tarurl.indexOf("http://") == -1) && (_tarurl.indexOf("https://") == -1)) {
            _tarurl = document.location.protocol + "//" + document.location.hostname + getLocationPort() + _tarurl;
        }

        openWindowbyezUtil(_tarurl);
    }

    try {
        newWin.focus();
    } catch (e) { }

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
            _tarurl = document.location.protocol + "//" + document.location.hostname + getLocationPort() + _tarurl;
        }

        openWindowbyezUtil(_tarurl);
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
    if (fileSize != "") {
        if (fileSize > 1024) {
            fileSize = parseInt(fileSize / 1024);
            if (fileSize > 1024)
                fileSize = (parseInt(fileSize / 102.4) / 10) + " MB";
            else
                fileSize = fileSize + " KB";
        }
        else
            fileSize = fileSize + " Byte"
    }

    return fileSize;
}

function Img_Swap(img, url) {
    img.src = url;
}

String.prototype.replaceAll = function (findStr, replaceStr) {
    var regExp = new RegExp(findStr, "gi");
    return this.replace(regExp, replaceStr);
};

String.prototype.trim = function () {
    return this.replace(/^\s+|\s+$/g, '');
};



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
        } catch (ex) { }

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






//슬립함수 ex)1000 : 1초
function sleep(delay) {
    var start = new Date().getTime();
    while (new Date().getTime() < start + delay);
}

