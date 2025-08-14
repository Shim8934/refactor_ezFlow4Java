function isTabletDevice_Sub() {
    var isTablet = false;
    const userAgent = navigator.userAgent;
    if (
        userAgent.match(/Tablet/i) ||
        userAgent.match(/iPad/i) ||
        userAgent.match(/Kindle/i) ||
        userAgent.match(/Playbook/i) ||
        userAgent.match(/Nexus/i) ||
        userAgent.match(/Xoom/i) ||
        userAgent.match(/silk/i) ||
        userAgent.match(/SM-N900T/i) || //Samsung Note 3
        userAgent.match(/GT-N7100/i) || //Samsung Note 2
        userAgent.match(/SAMSUNG-717/i) || //Samsung Note
        userAgent.match(/SM-T/i) ||		//Samsung Tab 4
        userAgent.match(/SM-X/i)		//Samsung Tab
    ) { isTablet = true; }

    //alert("userAgent: " + userAgent + "    isTablet: " + isTablet);
    return isTablet;
}

function isTabletDevice() {
    var isTablet = false;
    const userAgent = navigator.userAgent;
    if (userAgent.toLowerCase().indexOf('ipad') > -1 || (userAgent.toLowerCase().indexOf('android') > -1 && userAgent.toLowerCase().indexOf('mobile') == -1) || userAgent.toLowerCase().indexOf('sm-x') > -1) {
        isTablet = true;
    }

    if (isTabletDevice_Sub()) {
        isTablet = true;
    }

    // 갤럭시 탭만을 위한 리다이렉트. Mobile 이라는 단어가 안들어오게 되면 지우셔도 됨 
    var galaxyTabModel = new Array('shw-');
    for (i = 0; i < galaxyTabModel.length; i++) {
        if (userAgent.toLowerCase().indexOf(galaxyTabModel[i]) > -1) {
            isTablet = true;
        }
    }
    //alert("userAgent: " + userAgent + "    isTablet: " + isTablet);

    return isTablet;
}

function createXMLHttpRequest() {
    var oXmlRequest;
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        oXmlRequest = new XMLHttpRequest();
    }
    else {
        oXmlRequest = new ActiveXObject("Microsoft.XMLHTTP");
    }
    return oXmlRequest;
}

function BroswerAndNonActiveXCheck() {
    // IE10+, edge, chrome
    //return "CROSS";   //2020.04.22 이거 주석풀면 전자결재G 유통문서 로딩이 안된다.
    if (typeof (pNoneActiveX) == "undefined") {
        if (window.ActiveXObject || "ActiveXObject" in window) {
            return "IE";
        }
        else if (window.DOMParser) {
            return "CROSS";
        }
    }
    else {
        if (pNoneActiveX == "YES") {
            return "CROSS";
        }
        else {
            if (window.ActiveXObject || "ActiveXObject" in window) {
                return "IE";
            }
            else if (window.DOMParser) {
                return "CROSS";
            }
        }
    }
}

//Teams에 로그인된 계정 정보 불러와서 upn 전달 -> 보안문제로 토큰방식으로 변경
function Auth_GetContext(pDevice, pTabMenu, pIndex) {
    microsoftTeams.getContext(function (context) {
        if (context.upn) {
            var strQuery = "<DATA>";
            strQuery = strQuery + "<FLAG>" + "CONTEXT" + "</FLAG>";
            strQuery = strQuery + "<ACC>" + context.upn + "</ACC>";
            strQuery = strQuery + "<DEVICE>" + pDevice + "</DEVICE>";
            strQuery = strQuery + "</DATA>";

            xmlhttp = null;
            xmlhttp = createXMLHttpRequest();
            xmlhttp.open("POST","/ezTeams/Main/GetCurrUser", true);
            xmlhttp.onreadystatechange = function () {
                authAfter(pDevice, pTabMenu, pIndex);
            };
            xmlhttp.send(strQuery);
        } else {
            console.log("Auth_GetContext error:");
        }
    });
}

//Teams에 로그인된 계정 auth 토큰 반환 후 전달
function Auth_AuthToken(pDevice, pTabMenu, pIndex) {
    microsoftTeams.authentication.getAuthToken({
        successCallback: (result) => {
            var tokenResult = result;
            var strQuery = "<DATA>";
            strQuery = strQuery + "<FLAG>" + "AUTHTOKEN" + "</FLAG>";
            strQuery = strQuery + "<TOKEN>" + tokenResult + "</TOKEN>";
            strQuery = strQuery + "<DEVICE>" + pDevice + "</DEVICE>";
            strQuery = strQuery + "</DATA>";

            xmlhttp = null;
            xmlhttp = createXMLHttpRequest();
            xmlhttp.open("POST", "/ezTeams/Main/GetCurrUser", true);
            xmlhttp.onreadystatechange = function () {
                authAfter(pDevice, pTabMenu, pIndex);
            };
            xmlhttp.send(strQuery);
        },
        failureCallback: function (error) {
            console.log("Auth_AuthToken error:" + error);
            Auth_GetContext(pDevice, pTabMenu, pIndex);
        }
    });
}

function authAfter(device, tabmenu, index) {
    if (xmlhttp == null || xmlhttp.readyState != 4) return;
    try {
        if (xmlhttp.responseText == "") return;

        if (device == "mobile") {
            moveToMenu(true, tabmenu, index);
        }
        else {
            moveToMenu(false, tabmenu, index);
        }
    } catch (e) { console.log("authAfter error:" + error); }
}

function moveToMenu(isMobile, tabMenu, index) {
    var query = "";
    var result_Url = "";
    if (index) {
        query = setIndexPara(index);
    }
    switch (tabMenu) {
        case "portal":
            if (isMobile) {
                result_Url = "https://" + mServerHost + "/ezMobileHome/Common/CreateUserInfoHybrid?app=teams";
            }
            else {
                result_Url = "https://" + wServerHost + "/ezPortal/Main/PortalLayout_Basic?app=teams";
            }
            break;

        case "email":
            if (isMobile) {
                result_Url = "https://" + mServerHost + "/Email/Main/MailList?app=teams";
            }
            else {
                result_Url = "https://" + wServerHost + "/ezEmail/Main/IndexEmail?app=teams";
            }
            break;

        case "approval":
            if (isMobile) {
                result_Url = "https://" + mServerHost + "/Approval/Main/ApprovalList?gubun=1&app=teams";
            }
            else {
                result_Url = "https://" + wServerHost + "/ezApproval/Main/IndexApproval?app=teams";
            }
            break;

        case "board":
            if (isMobile) {
                result_Url = "https://" + mServerHost + "/Board/Main/BoardList?&MyBoard=Y&BoardID={FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}&app=teams";
            }
            else {
                result_Url = "https://" + wServerHost + "/ezBoardSTD/Main/IndexBoard?app=teams";
            }
            break;

        case "schedule":
            if (isMobile) {
                result_Url = "https://" + mServerHost + "/Schedule/Main/ScheduleList?app=teams";
            }
            else {
                result_Url = "https://" + wServerHost + "/ezSchedule/Main/IndexSchedule?app=teams";
            }
            break;

        case "resource":
            if (isMobile) {
                result_Url = "https://" + mServerHost + "/Resource/Main/MainResSchedule?Share=N&cmd=get&app=teams";
            }
            else {
                result_Url = "https://" + wServerHost + "/ezResource/Main/IndexResource?app=teams";
            }
            break;

        case "organ":
            if (isMobile) {
                result_Url = "https://" + mServerHost + "/Employee/Main/EmployeeMain?app=teams";
            }
            else {
                result_Url = "https://" + wServerHost + "/ezOrgan/Main/Search_Organ?companyid=top&search=&searchType=PORTAL&app=teams";
            }
            break;

        case "community":
            if (isMobile) {
                result_Url = "https://" + mServerHost + "/Community/Main/CommunityMain?app=teams";
            }
            else {
                result_Url = "https://" + wServerHost + "/ezCommunity/Main?app=teams";
            }
            break;

        case "survey":
            if (isMobile) {
                result_Url = "https://" + mServerHost + "/Question/Main/QuestionMain?apr=1&app=teams";
            }
            else {
                result_Url = "https://" + wServerHost + "/ezQuestion/Main/IndexQuestion?app=teams";
            }
            break;

        case "teamsorgan":
            if (isMobile) {
                result_Url = "https://" + wServerHost + "/ezOrgan/organMain?app=teams&device=mobile";
            }
            else {
                result_Url = "https://" + wServerHost + "/ezOrgan/organMain?app=teams";
            }
            break;

        case "newteamsorgan":
            if (isMobile) {
                result_Url = "https://" + wServerHost + "/ezOrgan/organMain_New?app=teams&device=mobile";
            }
            else {
                result_Url = "https://" + wServerHost + "/ezOrgan/organMain_New?app=teams";
            }
            break;
        case "config":
            if (isMobile) {
                result_Url = "https://" + mServerHost + "/ezMobileHome/Main/Setting?callpage=startmenu&app=teams";
            }
            else {
                result_Url = "https://" + wServerHost + "/ezPersonal/Main/index_environment?app=teams";
            }
            break;
        case "search":
            if (isMobile) {
                redirect_Url = "https://" + mobileServerName + "/ezMobileHome/Main/Setting?callpage=startmenu&app=teams";
            }
            else {
                redirect_Url = "https://" + serverName + "/ezSearch/Main/Index/Index?app=teams";
            }
            break;

        default:
            if (isMobile) {
                result_Url = "https://" + mServerHost + "/Email/Main/MailList?app=teams";
            }
            else {
                result_Url = "https://" + wServerHost + "/ezEmail/Main/IndexEmail?app=teams";
            }
            break;
    }

    var targetUrl = result_Url + query;
    if (isMobile) {
        location.href = result_Url;
    }
    else {
        location.href = targetUrl;
    }
}

function setIndexPara(index) {
    var result = "";

    switch (index) {
        case "10":  // 받은편지함
            result = "funcode=1";
            break;
        case "11":  // 보낸편지함
            result = "funcode=1&subfunction=2";
            break;

        case "20":  // 결재할문서 - 대시보드 사용시 대시보드페이지로 이동 (일반버전)
            result = "";
            break;
        case "21":  // 결재할문서 (일반버전)
            result = "listType=1";
            break;
        case "23":  // 결재진행중인 문서 (일반버전)
            result = "listType=3";
            break;
        case "24":  // 부서수신문서 (일반버전)
            result = "listType=4";
            break;
        case "211":  // 반려문서 (일반버전)
            result = "listType=11";
            break;

        case "30":  // 결재할문서 (G버전)
            result = "";
            break;
        case "31":  // 결재진행문서 (G버전)
            result = "listType=1";
            break;
        case "33":  // 결재진행중인 문서 (G버전)
            result = "listType=3";
            break;
        case "34":  // 부서수신문서 (G버전)
            result = "listType=4";
            break;

        case "40":  // 게시판
            if (typeof (param) != 'undefined')
                result = "boardid=" + param;
            else
                result = "";
            break;
        case "41":  // 전자설문
            result = "";
            break;
        case "42":  // 단위조직 
            result = "" + param;
            break;
        case "43":  // 내부정보공유 
            result = "boardid=" + param;
            break;

        case "50":  // 일정
            result = "";
            break;
        case "51":  // 업무관리
            result = "";
            break;

        case "60":  // 자원관리
            result = "";
            break;

        case "70":  // 주소록
            result = "";
            break;

        case "80":  // 협업
            result = "";
            break;

        case "90":  // 환경설정
            result = "";
            break;

        case "91":  // 환경설정 포탈 화면 설정
            result = "menuType=1";
            break;

        case "92":  // 환경설정 퀵링크 화면 설정
            result = "menuType=2";
            break;

        case "93":  // 환경설정 MySystem 화면 설정
            result = "menuType=3";
            break;

        case "97":  // 환경설정 알림 환경 설정
            result = "menuType=7";
            break;

        case "100": // 커뮤니티
            result = "";
            break;
    }

    if (index.Length > 10) // 게시판 ID
        result = "boardid=" + index;

    return "&" + result;
}