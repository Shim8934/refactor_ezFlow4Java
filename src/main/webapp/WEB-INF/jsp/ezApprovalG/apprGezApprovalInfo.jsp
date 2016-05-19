<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html id="htmlhag" style="overflow:hidden">
<head>
    <title><spring:message code='ezApprovalG.t1742'/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
    <link rel="stylesheet" href="/css/Tab.css" type="text/css">
    <script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/escapenew.js"></script>
    <script type="text/javascript" src="/js/ezApprovalG/conn_Cross.js"></script>
    <script src="/js/ezApprovalG/MiscFunc_Cross.js" type="text/javascript"></script>
    <script src="/js/ezApprovalG/TabMenu.js" type="text/javascript"></script>
    <script src="/js/ezApprovalG/TreeView.js" type="text/javascript"></script>
    <script src="/js/ezApprovalG/TreeViewCtrl_Cross.js" type="text/javascript"></script>
    <script src="/js/ezApprovalG/ListView_list.js" type="text/javascript"></script>
    <script src="/js/ezApprovalG/AprlineG.js" type="text/javascript"></script>
    <script src="/js/ezApprovalG/AprlineV.js" type="text/javascript"></script>
    <script src="/js/ezApprovalG/TempLineinfo.js" type="text/javascript"></script>
    <script src="/js/ezApprovalG/LineinfoIni.js" type="text/javascript"></script>
    <script src="/js/ezApprovalG/Lineinfo.js" type="text/javascript"></script>
    <script src="/js/ezApprovalG/SelectSubTitles.js" type="text/javascript"></script>
    <script src="/js/ezApprovalG/Receptinfo.js" type="text/javascript"></script>
    <script src="/js/ezApprovalG/TempReceptinfo.js" type="text/javascript"></script>
    <script src="/js/ezApprovalG/Cabinetinfo.js" type="text/javascript"></script>
    <script src="/js/ezApprovalG/CabCategoryInfo.js" type="text/javascript"></script>
    <script src="/js/ezApprovalG/CabRoleInfo.js" type="text/javascript"></script>
    <script src="/js/ezApprovalG/Docinfo.js" type="text/javascript"></script>
    <script src="/js/ezApprovalG/composeappt.js" type="text/javascript" ></script>
    <script src="/js/ezApprovalG/datepicker.htc.js" type="text/javascript" ></script>
    <script src="/js/Common.js" type="text/javascript"></script>
    <script src="/js/NameControl.js" type="text/javascript"></script>
    <script type="text/javascript">
        var OrderCell = "";
        var arr_userinfo = new Array();
        arr_userinfo[0] = "user"; 							// 사용자-부서구분
        arr_userinfo[1] = "${userInfo.id}";           // 사용자ID
        arr_userinfo[2] = "${userInfo.displayName1}";      // 사용자명
        arr_userinfo[3] = "${userInfo.title1}";            // 사용자 직위
        arr_userinfo[4] = "${userInfo.deptID}";           // 사용자 부서 ID
        arr_userinfo[5] = "${userInfo.deptName1}";         // 사용자 부서 이름
        arr_userinfo[6] = "${userInfo.jikChek}";          // 사용자 직책            
        arr_userinfo[7] = "N";                                        // 부재중 설정
        arr_userinfo[8] = "${userInfo.email}";            // E-Mail Address 
        arr_userinfo[9] = "";
        arr_userinfo[10] = "${susinAdmin}";             // 수신 접수담당자
        arr_userinfo[11] = "${userInfo.displayName1}"; 	// 사용자명(P)
        arr_userinfo[12] = "${userInfo.displayName2}"; 	// 사용자명(S)
        arr_userinfo[13] = "${userInfo.title1}"; 			// 사용자 직위(P)
        arr_userinfo[14] = "${userInfo.title2}"; 			// 사용자 직위(S)
        arr_userinfo[15] = "${userInfo.deptName1}"; 		// 사용자 부서 이름(P)
        arr_userinfo[16] = "${userInfo.deptName2}"; 		// 사용자 부서 이름(S)
        var CompanyID = "${userInfo.companyID}";
        var companyID = "${userInfo.companyID}";
        var UserLang = "${userInfo.lang}";
        var DeptID = "${userInfo.deptID}";
        var USE_OCS = "${useOcs}";
        var linealt1 = "<spring:message code='ezApprovalG.t1742'/>";
        var linealt2 = "<spring:message code='ezApprovalG.t228'/>";
        var linealt3 = "<spring:message code='ezApprovalG.t226'/>";
        var linealt4 = "<spring:message code='ezApprovalG.t227'/>";
        var linealt5 = "<spring:message code='ezApprovalG.t396'/>";
        var linealt6 = "<spring:message code='ezApprovalG.t394'/>";
        var linealt7 = "<spring:message code='ezApprovalG.t395'/>";
        var linealt8 = "<spring:message code='ezApprovalG.t396'/>";
        var linealt9 = "<spring:message code='ezApprovalG.t393'/>";
        var linealt10 = "<spring:message code='ezApprovalG.t399'/>";
        var linealt11 = "<spring:message code='ezApprovalG.t400'/>";
        var linealt12 = "<spring:message code='ezApprovalG.t228'/>";
        var linealt13 = "<spring:message code='ezApprovalG.t2001'/>";
        var linealt14 = "<spring:message code='ezApprovalG.t322'/>";
        var linealt15 = "<spring:message code='ezApprovalG.t323'/>";
        var linealt16 = "<spring:message code='ezApprovalG.t324'/>";
        var linealt17 = "<spring:message code='ezApprovalG.t1178'/>";
        var Cabinet1 = "<spring:message code='ezApprovalG.t379'/>";
        var Cabinet2 = "<spring:message code='ezApprovalG.t572'/>";
        var Cabinet3 = "<spring:message code='ezApprovalG.t573'/>";
        var Cabinet4 = "<spring:message code='ezApprovalG.t1081'/>";
        var Cabinet5 = "<spring:message code='ezApprovalG.t1065'/>";
        var Cabinet6 = "<spring:message code='ezApprovalG.t1160'/>";
        var Docalt1 = "<spring:message code='ezApprovalG.t1202'/>";
        var Docalt2 = "<spring:message code='ezApprovalG.t288'/>";
        var Docalt3 = "<spring:message code='ezApprovalG.t289'/>";
        var Docalt4 = "<spring:message code='ezApprovalG.t10030'/>";
        var pUserID = arr_userinfo[1];
        var tempAprTypeXML = "${aprTypeXML}";
        var AprTypeXML = createXmlDom();   //Xml Dom 구조
        var pAprLineTempletFlag = false; //결재선템플릿사용여부플래그
        var p_CheckAprLineTempletSN;       //사용한 결재선의 Index값 
        var p_CheckAprLineTempletName;     //[2006.06.14]사용한 결재선의 이름
        var pDocID;
        var pFormID;
        var pSignCount;
        var pHapYuiCount;
        var pGamSaCount;
        var pReDraftFlag;               // 재기안 Flag
        var pSuSinFlag;                //수신처 셀 Flag
        var pChamJoFlag;               //참조 셀 Flag
        var pGongramCount;
        var pReDraftAprLineFlag;       //재기안 결재선 변경 Flag
        var chkReDraft = "";
        var pAprLineArea;
        var pHapyuiArea;
        var ppDocType;
        var pSelAprLineState;
        var WorkFlowXML = createXmlDom();
        var WorkFlowString = "";
        var WorkFlowOption = "AUTO";	// "AUTO" - 로딩시에 자동 입력 및 삭제. else - 확인시에만 체크.
        var optGamsabu = "${optGamsabu}";        
        var ProcessorXML = createXmlDom();
        var InsertMode = "Add";
        var pAprLineXml = new Array(); // 결재선 , 수신처 Xml Return Value
        var DeptAddIndex = 1;
        var Draftinfoini = false;
        var Lineinfoini = false;
        var Lineinfoini2 = false;
        var Recinfoini = false;
        var Recinfoini2 = false;
        var Recinfoini3 = false;
        var Recinfoini4 = false;
        var Opinionini = false;
        var internalTab = true;
        var pSelAprLineType;           // 결재자 선택시 결재방법
        var pUrgentFlag;
        var pPublicFlag;
        var psecuritylevel;
        var pkeeperiod;
        var pkeyword;
        var ret = new Array();
        var CurAprLine;
        var pReDraftAprLineChangeFlag = false;
        var pHapyuiArea = 0;
        var pAprLineArea = 0;
        var onlydocinfiview;
        var onlyviewsusin = false;
        var pIniGubun = "${guBun}";
        var AdminYN = "FALSE";
        var szRoleInfo = "${userInfo.rollInfo}";
        var g_bRecAdmin = false;	//기록물 관리책임자 여부
        var g_bDeptCharger = false;	//부서업무 담당자 여부
        var g_InitFlag = "${initFlag}";
        var bDisplayFlag = "0";
        var bSpecialFlag = "0";
        var arrTask = new Array();
        var rtnVal = new Array();
        var g_SelCabID = "";
        var APRLINE = "";
        var vSecurity, vAprUrgency, vSummery, vAprSecurity;
        var vdocdisplay, vPublicFlag, vtreatment, vPageNum;
        var chkReporter = false;
        var chkSuggester = false;
        var SummaryFlag;
        var NonActiveX = "YES";
        var pDocSn = "${docSN}";
        var SusinGroupUseFlag = "${susinGroupUseFlag}";
        /* 2015-06-23 추가 - KSK */
        var T1361andT1362 = "<spring:message code='ezApprovalG.t1361'/>" + "<br>" + "<spring:message code='ezApprovalG.t1362'/>";
        var SummaryOuterReceiverList = "";

        window.onload = function () {
            if (MACSAFARIYN()) {
                window.resizeBy(0, 35);
            }
            if (screen.height >= 900) {
                document.getElementById("orgbtnArea").style.display = "";
                document.getElementById("btnArea").style.display = "none";
            }
            else {
                document.getElementById("orgbtnArea").style.display = "none";
                document.getElementById("btnArea").style.display = "inline";
            }

            GetDocInfo();            
            AprTypeXML = loadXMLString(tempAprTypeXML);
            ChangeTab(document.getElementById("1tab1"));
            document.getElementById('textUser').focus();            
            if (SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[0] == null) {
                document.getElementById("deptaddbtn").style.display = "none";
            }
alert(100);
            CheckGubunInit();

            if (pReDraftFlag == "DRAFT") {
                document.getElementById("btnaddress").style.display = "";
            }
            if (window.screen.height <= 768) {
                window.resizeTo(1000, 720);
                document.getElementById("bodytag").style.overflow = "auto";
                document.getElementById("htmlhag").style.overflow = "auto";
            }
        };

        function KeEventControl(obj) {
            useragt = navigator.userAgent.toUpperCase();
            if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) //사파리 브라우저일 경우
            {
                useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
                if (parseInt(useragt) > 5) {
                    return;
                }
            }
            obj.onkeydown = function () {
                if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
                    return false;
                if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
                        parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
                        parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
                        parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
                        parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
                    return false;
            };
        }
        var RetValue;
        var ReturnFunction;
        function GetDocInfo() {
            try {
                RetValue = parent.ezapprovalinfo_dialogArguments[0];
                ReturnFunction = parent.ezapprovalinfo_dialogArguments[1];
            } catch (e) {
                try {
                    RetValue = opener.ezapprovalinfo_dialogArguments[0];
                    ReturnFunction = opener.ezapprovalinfo_dialogArguments[1];
                } catch (e) {
                    RetValue = window.dialogArguments;
                }
            }
            
            pDocID = RetValue[0];        //문서ID
            pFormID = RetValue[1];        //FormID
            pSignCount = RetValue[2];        //사인칸 수
            pSignInfo = RetValue[3];        //사인정보
            pHapYuiCount = RetValue[4];        //합의칸 수
            pReDraftFlag = RetValue[5];        //재기안 Flag : REDRAFT / DRAFT
            pSuSinFlag = RetValue[6];        //수신자유뮤 Flag : Y  / N
            pChamJoFlag = RetValue[7];        //참조유무 Flag : Y / N
            pGongramCount = RetValue[8];       //공람수
            pReDraftAprLineFlag = RetValue[9]; //결재기:결재선 변경 Flag
            pDocType = RetValue[10];
            pGamSaCount = RetValue[11];
            chkReDraft = RetValue[13];
            if (pReDraftAprLineFlag) pOrgApruserid = RetValue[13];

            onlydocinfiview = RetValue[28];
            g_SelCabID = RetValue[30];

            //문서정보 추가
            vSecurity = RetValue[31];
            vAprUrgency = RetValue[32];
            vSummery = RetValue[33];
            vdocdisplay = RetValue[34];
            vPublicFlag = RetValue[35];
            vtreatment = RetValue[36];
            vPageNum = RetValue[37];
            vAprSecurity = trim(RetValue[38]);
            SummaryFlag = RetValue[39];

            if (pSuSinFlag == "N") {
                document.getElementById("showReceptinfo").style.display = "none";//.innerHTML = "";
            }

            try {
                //2015-06-30 표준모듈:추가(외부수신자요약) - KSK
                SummaryOuterReceiverList = RetValue[40];
                if (SummaryOuterReceiverList != "") {
                    document.getElementById("inputSummaryOuterReceiverList").value = SummaryOuterReceiverList;
                    document.getElementById("trSummaryOuterReceiverList").style.display = "";
                }
            } catch (e) { alert(e.description); }
        }
        function CheckGubunInit() {
            if (pIniGubun == "1") {
                document.getElementById("1tab1").onclick();
                document.getElementById("2tab1").onclick();
                liniReceptOuter();
            }
            else if (pIniGubun == "2") {
                document.getElementById("1tab2").click();
                liniReceptOuter();
            }
            else if (pIniGubun == "3") {
                document.getElementById("1tab3").onclick();
                liniReceptOuter();
            }
            else if (pIniGubun == "4") {
                document.getElementById("1tab4").onclick();
                liniReceptOuter();
            }
            else if (pIniGubun == "5") { //수신자, 결재정보
                document.getElementById("showAprLine").style.display = "none";
                document.getElementById("showCabinetinfo").style.display = "none";
                document.getElementById("Lineinfo").style.display = "none";
                document.getElementById("Cabinetinfo").style.display = "none";
                document.getElementById("1tab2").onclick();
                ChangeTab(document.getElementById("1tab2"));
                liniReceptOuter();
            }
            else if (pIniGubun == "6") { //결재선, 결재정보
                document.getElementById("showReceptinfo").style.display = "none";
                document.getElementById("showCabinetinfo").style.display = "none";
                document.getElementById("Receptinfo").style.display = "none";
                document.getElementById("Cabinetinfo").style.display = "none";
                document.getElementById("1tab1").onclick();
                document.getElementById("2tab1").onclick();
            }
            else if (pIniGubun == "7") { //결재정보
                document.getElementById("showAprLine").style.display = "none";
                document.getElementById("showReceptinfo").style.display = "none";
                document.getElementById("showCabinetinfo").style.display = "none";
                document.getElementById("Lineinfo").style.display = "none";
                document.getElementById("Receptinfo").style.display = "none";
                document.getElementById("Cabinetinfo").style.display = "none";
                document.getElementById("1tab4").onclick();
                ChangeTab(document.getElementById("1tab4"));
            }
            else if (pIniGubun == "8") { //결재선, 수신자, 결재정보
                document.getElementById("showCabinetinfo").style.display = "none";
                document.getElementById("Cabinetinfo").style.display = "none";
                document.getElementById("1tab1").onclick();
                document.getElementById("2tab1").onclick();
                liniReceptOuter();
            }
            else if (pIniGubun == "9") { //결재선
                document.getElementById("showDocinfo").style.display = "none";
                document.getElementById("showReceptinfo").style.display = "none";
                document.getElementById("showCabinetinfo").style.display = "none";
                document.getElementById("Receptinfo").style.display = "none";
                document.getElementById("Cabinetinfo").style.display = "none";
                document.getElementById("Docinfo").style.display = "none";
                document.getElementById("1tab1").onclick();
                document.getElementById("2tab1").onclick();
            }
            else if (pIniGubun == "10") { //수신자
                document.getElementById("showDocinfo").style.display = "none";
                document.getElementById("showAprLine").style.display = "none";
                document.getElementById("showCabinetinfo").style.display = "none";
                document.getElementById("Lineinfo").style.display = "none";
                document.getElementById("Cabinetinfo").style.display = "none";
                document.getElementById("Docinfo").style.display = "none";
                document.getElementById("1tab2").onclick();
                ChangeTab(document.getElementById("1tab2"));
                liniReceptOuter();
            }
            else if (pIniGubun == "11") { //결재선, 기록물철, 결재정보
                document.getElementById("showReceptinfo").style.display = "none";
                document.getElementById("Receptinfo").style.display = "none";
                document.getElementById("1tab1").onclick();
                document.getElementById("2tab1").onclick();
            }
            else if (pIniGubun == "12") { //기록물철, 결재정보
                document.getElementById("showAprLine").style.display = "none";
                document.getElementById("showReceptinfo").style.display = "none";
                document.getElementById("Lineinfo").style.display = "none";
                document.getElementById("Receptinfo").style.display = "none";
                document.getElementById("1tab3").onclick();
                ChangeTab(document.getElementById("1tab3"));
            }
            else if (pIniGubun == "13") { //기록물철
                document.getElementById("showAprLine").style.display = "none";
                document.getElementById("showReceptinfo").style.display = "none";
                document.getElementById("showDocinfo").style.display = "none";
                document.getElementById("Lineinfo").style.display = "none";
                document.getElementById("Receptinfo").style.display = "none";
                document.getElementById("Docinfo").style.display = "none";
                document.getElementById("1tab3").onclick();
                ChangeTab(document.getElementById("1tab3"));
            }
        }

        var bool = false;
        var bool2 = false;
        var bool3 = false;
        var bool4 = false;
        function ChangeTab(obj) {
            
            //DisabledTab();
            var pSelectTab = obj.getAttribute("divname");
            document.getElementById(pSelectTab).style.display = "";

            switch (pSelectTab) {
                case "Lineinfo":
                    document.getElementById("Receptinfo").style.display = "none";
                    document.getElementById("Cabinetinfo").style.display = "none";
                    document.getElementById("Docinfo").style.display = "none";
                    if (!bool)
                        Lineinfo_ini();
                    bool = true;
                    break;
                case "Receptinfo":
                    document.getElementById("Lineinfo").style.display = "none";
                    document.getElementById("Cabinetinfo").style.display = "none";
                    document.getElementById("Docinfo").style.display = "none";
                    if (!bool2)
                        Receptinfo_ini();
                    bool2 = true;
                    break;
                case "Cabinetinfo":
                    document.getElementById("Lineinfo").style.display = "none";
                    document.getElementById("Receptinfo").style.display = "none";
                    document.getElementById("Docinfo").style.display = "none";
                    if (!bool3) {
                        Cabinetinfo_ini();
                        Docinfo_ini();
                    }
                    bool3 = true;
                    bool4 = true;
                    break;
                case "Docinfo":
                    document.getElementById("Lineinfo").style.display = "none";
                    document.getElementById("Receptinfo").style.display = "none";
                    document.getElementById("Cabinetinfo").style.display = "none";
                    if (!bool4)
                        Docinfo_ini();
                    bool4 = true;
                    break;
                case "Opinioninfo":
                    break;

            }
        }

        //발의자여부
        function Suggester_onclick() {
            try {
                var pAPRLINE = new ListView();      //// ListView 선언
                pAPRLINE.LoadFromID("lvAPRLINE");

                var CurSelRow = pAPRLINE.GetSelectedRows();

                if (CurSelRow.length <= 0) {
                    OpenAlertUI("<spring:message code='ezApprovalG.t389'/>");
	            Suggester.checked = false;
	            return;
	        }

            if (CurSelRow.length > 0) {

                var pSelectedRow = pAPRLINE.GetSelectedRows();
                if (pSelectedRow) {
                    var RCheckVal = Suggester.checked;
                    var p_CurAprStat = pSelectedRow[0].cells[5].innerText;
                }
            }
            else {
                OpenAlertUI("<spring:message code='ezApprovalG.t389'/>");
                Suggester.checked = false;
                return;
            }

            var pTmpAprLineType;
            pTmpAprLineType = "003";
            pTmpAprLineType = ConvertAprLineState(pTmpAprLineType, "Value");

            if (pSelectedRow.length != 0 && (p_CurAprStat != pTmpAprLineType || pReDraftFlag == "REDRAFT")) {

                if (RCheckVal) {
                    SetAttribute(pSelectedRow[0], "DATA8", "Y");
                    if (CrossYN()) {
                        if (pSelectedRow[0].cells[0].textContent.indexOf("★") == -1)
                            pSelectedRow[0].cells[0].textContent = "★" + pSelectedRow[0].cells[0].textContent;
                    }
                    else {
                        if (pSelectedRow[0].cells[0].innerText.indexOf("★") == -1)
                            pSelectedRow[0].cells[0].innerText = "★" + pSelectedRow[0].cells[0].innerText;
                    }
                    chkSuggester = true;
                } else {
                    SetAttribute(pSelectedRow[0], "DATA8", "N");
                    var rep = /★/g;
                    if (CrossYN()) {
                        pSelectedRow[0].cells[0].textContent = pSelectedRow[0].cells[0].textContent.replace(rep, "");
                    }
                    else {
                        pSelectedRow[0].cells[0].innerText = pSelectedRow[0].cells[0].innerText.replace(rep, "");
                    }
                    chkSuggester = false;
                }
            }
        } catch (e) {
            alert("Suggester_onclick :: " + e.description);
        }
    }

    //보고자여부
    function Reporter_onclick() {
        try {
            var pAPRLINE = new ListView();
            pAPRLINE.LoadFromID("lvAPRLINE");

            var CurSelRow = pAPRLINE.GetSelectedRows();

            if (CurSelRow.length <= 0) {
                OpenAlertUI("<spring:message code='ezApprovalG.t390'/>");
	            Reporter.checked = false;
	            return;
	        }

            if (CurSelRow.length > 0) {
                var pSelectedRow = pAPRLINE.GetSelectedRows();
                if (pSelectedRow) {
                    var RCheckVal = Reporter.checked;
                    var p_CurAprStat = pSelectedRow[0].cells[5].innerText;
                }
            }
            else {
                OpenAlertUI("<spring:message code='ezApprovalG.t390'/>");
                Reporter.checked = false;
                return;
            }

            var pTmpAprLineType;

            pTmpAprLineType = "003";
            pTmpAprLineType = ConvertAprLineState(pTmpAprLineType, "Value");
            if (pSelectedRow.length != 0 && (p_CurAprStat != pTmpAprLineType || pReDraftFlag == "REDRAFT")) {
                if (RCheckVal) {
                    SetAttribute(pSelectedRow[0], "DATA9", "Y");
                    if (CrossYN()) {
                        if(pSelectedRow[0].cells[0].textContent.indexOf("⊙") == -1)
                            pSelectedRow[0].cells[0].textContent = "⊙" + pSelectedRow[0].cells[0].textContent;
                    }
                    else {
                        if(pSelectedRow[0].cells[0].innerText.indexOf("⊙") == -1)
                            pSelectedRow[0].cells[0].innerText = "⊙" + pSelectedRow[0].cells[0].innerText;
                    }
                    chkReporter = true;
                } else {
                    SetAttribute(pSelectedRow[0], "DATA9", "N");
                    var rep = /⊙/g;
                    if (CrossYN()) {
                        pSelectedRow[0].cells[0].textContent = pSelectedRow[0].cells[0].textContent.replace(rep, "");
                    }
                    else {
                        pSelectedRow[0].cells[0].innerText = pSelectedRow[0].cells[0].innerText.replace(rep, "");
                    }
                    chkReporter = false;
                }
            }
        } catch (e) {
            alert("Reporter :: " + e.description);
        }
    }


    function btnSearchDept_onKeyPress(e) {
        if (e.keyCode == "13") {
            document.getElementById("Span2").onclick();
        }
    }
    function btnSearchDept_onKeyPress2(e) {
        if (e.keyCode == "13") {
            document.getElementById("Span7").onclick();
        }
    }


    function getGyulJeDateDB() {
        try {
            var objNode;
            var xmlpara = createXmlDom();
            var xmlhttp = createXMLHttpRequest();

            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "getDate", "");

            xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/GetDateDB.aspx", false);
            xmlhttp.send(xmlpara);

            return xmlhttp.responseText;
        }
        catch (e) {
            alert("getGyulJeDateDB()" + e.description);
        }
    }

    function btn_OK() {
        try {
            if (!onlydocinfiview) {
                ret[0] = "OK";

                var line = Checkline();
                if (line == false) {
                    return;
                }
                if (pIniGubun != 5 && pIniGubun != 7 && pIniGubun != 10 && pIniGubun != 12) {
                    var rtnVal = CheckSignCellValueLast();

                    if (!rtnVal)
                        return;
                }
                if (pIniGubun != 5 && pIniGubun != 6 && pIniGubun != 7 && pIniGubun != 8 && pIniGubun != 9 && pIniGubun != 10) {
                    var List = new ListView();
                    List.LoadFromID("DivTaskSCateList");

                    var MyList = new ListView();
                    MyList.LoadFromID("DivMyTaskSCateList");

                    var totalRows = List.GetSelectedRows();
                    var MyRows = MyList.GetSelectedRows();

                    if (totalRows.length == 0 && MyRows.length == 0) {
                        OpenAlertUI(Cabinet4);
                        document.getElementById("1tab3").onclick();
                        return;
                    }
                    else {
                        if (MyRows.length > 0) {
                            if (GetAttribute(MyRows[0], "DATA1") == "") {
                                OpenAlertUI(Cabinet4);
                                document.getElementById("1tab3").onclick();
                                return;
                            }
                            else
                                totalRows = MyRows;
                        }
                        else if (totalRows.length > 0) {
                            if (GetAttribute(totalRows[0], "DATA1") == "") {
                                OpenAlertUI(Cabinet4);
                                document.getElementById("1tab3").onclick();
                                return;
                            }
                        }
                    }
                }

                if (SummaryFlag)
                    Docinfo_ini();

                var chkDocinfoFlag = checkDocinfo();
                if (!chkDocinfoFlag) {
                    var tabshow = document.getElementById("1tab4");
                    Tab1_MouseClick(tabshow);
                    return;
                }

                ret[1] = SaveAprLineList(); //결재선 저장 XML

                CheckAprPerson();
                var listview = new ListView();
                listview.LoadFromID("lvRECEPTLIST");
                var receptRow = listview.GetDataRows();

                if (receptRow.length > 0 && receptRow[0].id.indexOf("noItems") == -1) {
                    ret[2] = AprDeptListXML(); //수신자 저장 XML
                    ret[3] = MakertnVal(); //문서 매핑 XML
                }
                else
                    ret[2] = "";

                if (pIniGubun != 5 && pIniGubun != 6 && pIniGubun != 7 && pIniGubun != 8 && pIniGubun != 9 && pIniGubun != 10) {
                    ret[4] = GetSelCabInfoXml(totalRows); //기록물철 XML
                }

                if (pReDraftAprLineChangeFlag) {
                    ret[5] = "R";
                }
                else {
                    ret[5] = "C";
                }

                ret[7] = selSecLevel.value;
                if (AprUrgency.checked)
                    ret[8] = "Y";
                else
                    ret[8] = "N";
                ret[9] = document.getElementById("taSummery").value;
                ret[10] = getdocdisplay();
                ret[11] = getPublicFlag();
                ret[12] = txtLimitRange.value;
                ret[13] = txtPageNum.value;

                if (document.getElementById("AprSecurity").checked)
                    ret[14] = document.getElementById("idDatepicker").value.substring(0, 10);
                else
                    ret[14] = "";

                if (document.getElementById("inputSummaryOuterReceiverList").value != "") {
                    ret[15] = document.getElementById("inputSummaryOuterReceiverList").value;
                } else {
                    ret[15] = "";
                }

                if (ReturnFunction != null) {
                    ReturnFunction(ret);
                }
                else {
                    window.returnValue = ret;
                }
                window.close();
            }
            else {
                var docinfo = MakeDocInfo();
                ret[0] = "OK";
                ret[1] = docinfo;
                ret[6] = "OnlyDocInfo";
            }
        }
        catch (e) {
            OpenAlertUI("<spring:message code='ezApprovalG.t1600'/>");
            ret[0] = "FALSE";
        }
    }

    function CheckAprPerson() {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvAPRLINE");

        var xmlpara = createXmlDom();
        xmlhttp = createXMLHttpRequest();
        var msg = "";
        var objNode;

        for (var i = 0; i < pAPRLINE.GetRowCount() ; i++) {
            msg += "'" + document.getElementById("lvAPRLINE").childNodes[1].childNodes[i].getAttribute("DATA4") + "',";
        }
  
        msg = msg.substring(0, msg.lastIndexOf(','));

        createNodeInsert(xmlpara, objNode, "DATA");
        createNodeAndInsertText(xmlpara, objNode, "CELL", msg);
        xmlhttp.open("POST", "/myoffice/ezApprovalG/ezLine/aspx/CheckAprPerson.aspx", false);
        xmlhttp.onreadystatechange = resultCheckAprPerson;
        xmlhttp.send(xmlpara);
    }

    function resultCheckAprPerson() {

        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            
            var temp = loadXMLString(xmlhttp.responseText);
            alertMsg = "";
            var selNodes = SelectNodes(temp, "DATA/ROW");
            for (var i = 0; i < selNodes.length; i++) {
                var StartDT = getNodeText(GetChildNodes(selNodes[i])[3]).split(':')[3];
                var EndDT = getNodeText(GetChildNodes(selNodes[i])[3]).split(':')[4];
                var NowDT = new Date();
                if (NowDT.getFullYear() >= StartDT.split('-')[0] && NowDT.getFullYear() <= EndDT.split('-')[0] && NowDT.toLocaleString().split(' ')[1].split('월')[0] >= Number(StartDT.split('-')[1]) && NowDT.toLocaleString().split(' ')[1].split('월')[0] <= Number(EndDT.split('-')[1])) {
                    if (StartDT.split('-')[1] != EndDT.split('-')[1]) {
                        if (NowDT.toLocaleString().split(' ')[1].split('월')[0] == Number(StartDT.split('-')[1]) && NowDT.getDate() >= Number(StartDT.split('-')[2].split(' ')[0])) {
                            alertMsg += getNodeText(GetChildNodes(selNodes[i])[UserLang]) + strLang324 + "";
                            alertMsg += getNodeText(GetChildNodes(selNodes[i])[3]).split(':')[1] + strLang325 + "";
                        }
                        else if (NowDT.toLocaleString().split(' ')[1].split('월')[0] > Number(StartDT.split('-')[1]) && NowDT.toLocaleString().split(' ')[1].split('월')[0] < Number(EndDT.split('-')[1])) {
                            alertMsg += getNodeText(GetChildNodes(selNodes[i])[UserLang]) + strLang324 + "";
                            alertMsg += getNodeText(GetChildNodes(selNodes[i])[3]).split(':')[1] + strLang325 + "";
                        }
                        else if (NowDT.toLocaleString().split(' ')[1].split('월')[0] == Number(EndDT.split('-')[1]) && NowDT.getDate() <= Number(EndDT.split('-')[2].split(' ')[0])) {
                            alertMsg += getNodeText(GetChildNodes(selNodes[i])[UserLang]) + strLang324 + "";
                            alertMsg += getNodeText(GetChildNodes(selNodes[i])[3]).split(':')[1] + strLang325 + "";
                        }
                    }
                    else if (NowDT.getDate() >= Number(StartDT.split('-')[2].split(' ')[0]) && NowDT.getDate() <= Number(EndDT.split('-')[2].split(' ')[0])) {
                        alertMsg += getNodeText(GetChildNodes(selNodes[i])[UserLang]) + strLang324 + "";
                        alertMsg += getNodeText(GetChildNodes(selNodes[i])[3]).split(':')[1] + strLang325 + "";
                    }
                }
            }

            if (alertMsg != "") {
                alert(alertMsg);                 
            }
        }
    }

    function MakertnVal() {
        var listview = new ListView();                          // ListView 선언
        listview.LoadFromID("lvRECEPTLIST");                              // ID 지정

        var i;
        var rows = listview.GetDataRows();
        if (rows.length == 0)
            return "";

        var xmlpara = createXmlDom();
        var objRoot, objRow, objDocinfoNode;
        objRoot = createNodeInsert(xmlpara, objRoot, "ROWS");

        for (i = 0; i < rows.length; i++) {
            objRow = createNodeAndAppandNode(xmlpara, objRoot, objRow, "ROW");
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "NAME", rows[i].cells[1].innerText);
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "DEPTID", rows[i].getAttribute("DATA1"));
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "DEPTNAME", rows[i].getAttribute("DATA2"));
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "EXTRECEPTYN", rows[i].getAttribute("DATA3"));
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "PROCESSYN", rows[i].getAttribute("DATA4"));
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "CANEDITYN", rows[i].getAttribute("DATA5"));
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "EMAIL", rows[i].getAttribute("DATA6"));
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "JOBTITLE", rows[i].getAttribute("DATA9"));
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "DEPTNAME1", rows[i].getAttribute("DATA10"));
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "DEPTNAME2", rows[i].getAttribute("DATA11"));
        }
        return getXmlString(xmlpara);
    }

    function btn_Close() {
        ret[0] = "false";

        if (ReturnFunction != null) {
            ReturnFunction(ret);
            window.close();
        }
        else {
            window.returnValue = ret;
            window.close();
        }
    }
    function CabinetSearch_Press(e) {
        if (window.event) {
            if (e.keyCode != 13)
                return;
        }
        else {
            if (e.which != 13)
                return;
        }
        CabinetSearch_onclick();
    }

    var createcabinet_cross_dialogArguments = new Array();
    function btnCreateCab_onclick() {
        var List = new ListView();
        List.LoadFromID("DivTaskSCateList");

        var selnodes = List.GetSelectedRows();
        if (selnodes.length > 0) {
            var selnode = selnodes[0];
            var para = new Array();

            para[0] = GetAttribute(selnode, "DATA7");
            para[1] = selnode.cells[1].innerHTML;
            para[2] = GetAttribute(selnode, "DATA9");
            para[3] = GetAttribute(selnode, "DATA8");
            para[4] = GetAttribute(selnode, "DATA15");
            para[5] = GetAttribute(selnode, "DATA16");
            para[6] = GetAttribute(selnode, "DATA10");
            para[7] = GetAttribute(selnode, "DATA11");
            para[8] = GetAttribute(selnode, "DATA12");
            para[9] = GetAttribute(selnode, "DATA13");
            para[10] = GetAttribute(selnode, "DATA14");
            para[11] = GetAttribute(selnode, "DATA17");
            para[12] = GetAttribute(selnode, "DATA18");

            var url = "/myoffice/ezApprovalG/ezCabinet/CreateCabinet_Cross.aspx";

            createcabinet_cross_dialogArguments[0] = para;
            createcabinet_cross_dialogArguments[1] = btnCreateCab_onclick_Complete;

            if (CrossYN() || NonActiveX == "YES") {
                if (UserLang == "2" || UserLang == "3") {
                    DivPopUpShow(440, 450, url);
                }
                else {
                    DivPopUpShow(440, 450, url);
                }
            }
            else {
                if (UserLang == "2" || UserLang == "3") {
                    var feature = "dialogWidth:440px;dialogHeight:438px;scroll:no;resizable:no;status:no; help:no;edge:sunken";
                    feature = feature + GetShowModalPosition(440, 415);
                }
                else {
                    var feature = "dialogWidth:350px;dialogHeight:438px;scroll:no;resizable:no;status:no; help:no;edge:sunken";
                    feature = feature + GetShowModalPosition(350, 415);
                }
                var rtn = window.showModalDialog(url, para, feature);
                if (rtn[0] == "TRUE") {
                    selTaskMCategory_onchange();
                }
            }
        }
    }

    function btnCreateCab_onclick_Complete(rtn) {
        DivPopUpHidden();
        if (rtn[0] == "TRUE") {
            selTaskMCategory_onchange();
        }
    }

    function btnNewVolume_onclick() {
        var ListCab = new ListView();
        ListCab.LoadFromID("DivTaskSCateList");
        var selnodes = ListCab.GetSelectedRows();

        if (selnodes.length > 0) {
            var selnode = selnodes[0];
            if (trim(GetAttribute(selnode, "DATA1")) == "" || trim(GetAttribute(selnode, "DATA3")) == "") {
                alert("<spring:message code='ezApprovalG.t10028'/>");
                return;
            }
            var rtn = NewVolume(trim(GetAttribute(selnode, "DATA1")), trim(GetAttribute(selnode, "DATA3")));
        }
        else {
            alert("<spring:message code='ezApprovalG.t478'/>");
        }
    }
    function Docinfo_ini() {
        SummaryFlag = false;
        var rtnVal = new Array();
        initdatepicker();
        document.getElementById("taSummery").value = "";

        onload_window();
        if (vSecurity.trim() == "")
            document.getElementById("selSecLevel").options[0].selected = true;
        else
            document.getElementById("selSecLevel").value = vSecurity;
        if (vAprUrgency.trim() == "Y")
            document.getElementById("AprUrgency").checked = true;
        else
            document.getElementById("AprUrgency").checked = false;
        if (vSummery.trim() != "") document.getElementById("taSummery").value = vSummery;

        if (vdocdisplay.trim() != "")
            setdocdisplay(vdocdisplay);
        if (vPublicFlag.trim() != "")
            setPublicFlag(vPublicFlag);
        else
            rdoSecType_onclick("1");
        if (vAprSecurity.trim() != "") {
            document.getElementById("AprSecurity").checked = true;
            var idDatepicker = new datepicker('idDatepicker', 'idDatepicker');
            idDatepicker.attachEvent('datechange', onStartDateChanged);
            idDatepicker.attachEvent('enddatechange', onEndDateChanged);
            idDatepicker.elemDateButtons = "img_Post_D1;img_Post_D2";
            idDatepicker.elemDateInputs = "idDatepicker;Post_D2";
            idDatepicker.popupType = "both";
            idDatepicker.pickerDateFormat = "[yyyy]" + "<spring:message code='ezApprovalG.t1108'/>";
            idDatepicker.pickerTimeFormat = "[tt] [h]:[mm]";
            idDatepicker.inputDateFormat = "[yyyy]-[MM]-[dd] ([ddd])";
            idDatepicker.inputTimeFormat = "[tt] [h]:[mm]";
            idDatepicker.firstDayOfWeek = "0";
            idDatepicker.textAM = "<spring:message code='ezApprovalG.t971'/>";
            idDatepicker.textPM = "<spring:message code='ezApprovalG.t972'/>";
            idDatepicker.textDecimal = ".";
            idDatepicker.textHoursAbbrev = "<spring:message code='ezApprovalG.t1109'/>";
            idDatepicker.textMustSpecifyValidTime = "<spring:message code='ezApprovalG.t1110'/>";
            idDatepicker.daynameLetters = "<spring:message code='ezApprovalG.t1111'/>";
            idDatepicker.daynamesShort = "<spring:message code='ezApprovalG.t1111'/>";
            idDatepicker.daynamesLong = "<spring:message code='ezApprovalG.t1112'/>";
            idDatepicker.monthnamesShort = "1;2;3;4;5;6;7;8;9;10;11;12";
            idDatepicker.monthnamesLong = "1" + "<spring:message code='ezApprovalG.t1113'/>";
            idDatepicker.isoDateUTF = vAprSecurity + "T00:00:00.000Z";
            idDatepicker.isoEndDateUTF = vAprSecurity + "T00:00:00.000Z";
            idDatepicker.ready();
        }
        else {
            document.getElementById("AprSecurity").checked = false;
            AprSecurity_onClick();
        }
        document.getElementById("txtLimitRange").value = vtreatment;
        document.getElementById("txtPageNum").value = vPageNum;
        rtnVal[0] = document.getElementById("selSecLevel").value;
        if (document.getElementById("AprUrgency").checked)
            rtnVal[1] = "Y";
        else
            rtnVal[1] = "N";
        rtnVal[2] = document.getElementById("taSummery").value;
        rtnVal[3] = getdocdisplay();
        rtnVal[4] = getPublicFlag();
        rtnVal[5] = document.getElementById("txtLimitRange").value;
        rtnVal[6] = document.getElementById("txtPageNum").value;
        if (document.getElementById("AprSecurity").checked)
            rtnVal[7] = vAprSecurity;
        else
            rtnVal[7] = "";

        if (CrossYN() || NonActiveX == "YES") {
        }
        else
            window.returnValue = rtnVal;
    }
    function initdatepicker() {
        var idDatepicker = new datepicker('idDatepicker', 'idDatepicker');
        idDatepicker.attachEvent('datechange', onStartDateChanged);
        idDatepicker.attachEvent('enddatechange', onEndDateChanged);
        idDatepicker.elemDateButtons = "img_Post_D1;img_Post_D2";
        idDatepicker.elemDateInputs = "idDatepicker;Post_D2";
        idDatepicker.popupType = "both";
        idDatepicker.pickerDateFormat = "[yyyy]" + "<spring:message code='ezApprovalG.t1108'/>";
        idDatepicker.pickerTimeFormat = "[tt] [h]:[mm]";
        idDatepicker.inputDateFormat = "[yyyy]-[MM]-[dd] ([ddd])";
        idDatepicker.inputTimeFormat = "[tt] [h]:[mm]";
        idDatepicker.firstDayOfWeek = "0";
        idDatepicker.textAM = "<spring:message code='ezApprovalG.t971'/>";
            idDatepicker.textPM = "<spring:message code='ezApprovalG.t972'/>";
        idDatepicker.textDecimal = ".";
        idDatepicker.textHoursAbbrev = "<spring:message code='ezApprovalG.t1109'/>";
            idDatepicker.textMustSpecifyValidTime = "<spring:message code='ezApprovalG.t1110'/>";
        idDatepicker.daynameLetters = "<spring:message code='ezApprovalG.t1111'/>";
        idDatepicker.daynamesShort = "<spring:message code='ezApprovalG.t1111'/>";
        idDatepicker.daynamesLong = "<spring:message code='ezApprovalG.t1112'/>";
        idDatepicker.monthnamesShort = "1;2;3;4;5;6;7;8;9;10;11;12";
        idDatepicker.monthnamesLong = "1" + "<spring:message code='ezApprovalG.t1113'/>";
            idDatepicker.isoDateUTF = "${startDateTime}";
        idDatepicker.isoEndDateUTF = "${endDateTime}";
        idDatepicker.ready();
    }
    var aprdeptname_cross_dialogArguments = new Array();
    function btnaddressChange() {
        var listview = new ListView();
        listview.LoadFromID("lvRECEPTLIST");
        var CurSelRow = listview.GetSelectedRows();
        var windowName = "/myoffice/ezApprovalG/ezAPRDEPT/AprDeptName_Cross.aspx";
        var parameter = "status:no;dialogWidth:340px;dialogHeight:195px;scroll:no;edge:sunken;help:no";

        if (CurSelRow[0] == undefined) {
            alert("<spring:message code='ezApprovalG.t10501'/>");
            return;
        }

        if (CurSelRow[0].getAttribute("DATA6") != "") {
            alert("<spring:message code='ezApprovalG.t10500'/>");
            return;
        }

        var dialogValue = CurSelRow[0].cells[1].innerText;
        if (CrossYN() || NonActiveX == "YES") {
            aprdeptname_cross_dialogArguments[0] = dialogValue;
            aprdeptname_cross_dialogArguments[1] = btnaddressChange_Complete;

            DivPopUpShow(360, 220, windowName);
        }
        else {
            parameter = parameter + GetShowModalPosition(330, 205);
            var AddressName = window.showModalDialog(windowName, dialogValue, parameter);
            if (AddressName == "cancel" || AddressName == undefined)
                return;
            if (CrossYN()) {
                CurSelRow[0].cells[1].textContext = AddressName;
                CurSelRow[0].cells[1].innerText = AddressName;
            }
            else {
                CurSelRow[0].cells[1].innerText = AddressName;
            }
            SetAttribute(CurSelRow[0], "DATA10", AddressName);
            SetAttribute(CurSelRow[0], "DATA11", AddressName);
        }
    }

    function btnaddressChange_Complete(AddressName) {
        DivPopUpHidden();
        if (AddressName == "cancel" || AddressName == undefined)
            return;

        var listview = new ListView();
        listview.LoadFromID("lvRECEPTLIST");
        var CurSelRow = listview.GetSelectedRows();

        if (CrossYN()) {
            CurSelRow[0].cells[1].textContext = AddressName;
            CurSelRow[0].cells[1].innerText = AddressName;
        }
        else {
            CurSelRow[0].cells[1].innerText = AddressName;
        }
        SetAttribute(CurSelRow[0], "DATA10", AddressName);
        SetAttribute(CurSelRow[0], "DATA11", AddressName);
    }
    </script>
</head>
<body id="bodytag" class="popup" style="background-color: #ffffff; overflow: hidden">

    <h1><spring:message code='ezApprovalG.t1742'/>
        <div id="btnArea" style="display:inline;float:right;">
            <a class="imgbtn"><span style="width: 60px; text-align: center;" onclick="btn_OK()"><spring:message code='ezApprovalG.t1760'/></span></a>
            <a class="imgbtn"><span style="width: 60px; text-align: center;" onclick="btn_Close()"><spring:message code='ezApprovalG.t1761'/></span></a>
        </div>
    </h1>
    <div class="portlet_tabpart02">
        <div class="portlet_tabpart02_top" id="tab1">
            <p id="showAprLine"><span divname="Lineinfo" id="1tab1"><spring:message code='ezApprovalG.t1769'/></span></p>
            <p id="showReceptinfo"><span divname="Receptinfo" id="1tab2"><spring:message code='ezApprovalG.t448'/></span></p>
            <p id="showCabinetinfo"><span divname="Cabinetinfo" id="1tab3"><spring:message code='ezApprovalG.t51'/></span></p>
            <p id="showDocinfo"><span divname="Docinfo" id="1tab4"><spring:message code='ezApprovalG.t1204'/></span></p>
        </div>
    </div>
    <div id="Approvallist">
        <!-- 결재선 -->
        <div id="Lineinfo" style="border: 2px solid #dbdbda; width: 970px; height: 597px;">
            <table>
                <tr>
                    <td style="vertical-align: top">
                        <div class="portlet_tabpart01" style="margin-top: 3px;">
                            <div class="portlet_tabpart01_top" id="tab2">
                                <p><span divname="Organ" id="2tab1"><spring:message code='ezApprovalG.t232'/></span></p>
                                <p><span divname="Temp" id="2tab2"><spring:message code='ezApprovalG.G0001'/></span></p>
                            </div>
                        </div>
                        <div id="OrganLineTab" style="display: none; padding-left: 3px">
                            <table style="margin-left: 0px;">
                                <tr>
                                    <td style="vertical-align: top;">
                                        <span>
                                            <div id="TreeView" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 247px; width: 388px; border: 1px solid #b6b6b6; background-color: #FFFFFF; margin: 1px 1px 1px 1px;"></div>
                                            <div class="border_gray" style="Width: 389px; Height: 275px;">
                                                <div id="UserList" style="margin: 0px 1px 1px 1px; Width: 388px; Height: 250px; overflow: auto;"></div>
                                            </div>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="background-color: transparent; height: 28px;">
                                        <input id="textUser" style="width: 150px" name="textUser" onkeypress="return textUser_onkeypress(event)"  maxlength="50">
                                        <a style="margin-top: 2px" class="imgbtn"><span name="btn_searchUser" id="btn_searchUser" onkeypress="return btn_searchUser_onclick()" onclick="return btn_searchUser_onclick()" ><spring:message code='ezApprovalG.t234'/></span></a>
                                        <a style="margin-top: 2px;" class="imgbtn" onclick="APRDEPTADD();" id="deptaddbtn"><span><spring:message code='ezApprovalG.G0002'/></span></a>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="TempLineTab" style="display: none;">
                            <table style="margin-left: 5px;">
                                <tr>
                                    <td style="background-color: #f3f3f3; padding: 4px 0 3px 0; background-color: #ffffff; height: 20px;">
                                        <h2 class="h2_dot"><spring:message code='ezApprovalG.G0003'/></h2>
                                        <div class="border_gray">
                                            <div id="APRTEMPLIST" style="border: 0px; Width: 386px; Height: 180px; OVERFLOW: AUTO; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="background-color: transparent; text-align: center; height: 30px;">
                                        <table class="content" style="margin-bottom: 5px; width: 100%;">
                                            <tr>
                                                <td style="vertical-align: middle; text-align: center; padding-top: 3px;">
                                                    <a class="imgbtn"><span id="btn_DelAprLineTemplet" onclick="return btn_DelAprLineTemplet_onclick()"><spring:message code='ezApprovalG.G0004'/></span></a>
                                                    <a class="imgbtn"><span id="Span1" onclick="return btn_ModifyToAprLine_onclick()"><spring:message code='ezApprovalG.G0005'/></span></a>
                                                    <a class="imgbtn"><span onclick="return btn_AddToAprLine_onclick()" style="width: 60px;"><spring:message code='ezApprovalG.t336'/></span></a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="vertical-align: top;">
                                        <div class="border_gray">
                                            <div id="APRTEMP" style="Width: 386px; Height: 295px; OVERFLOW: AUTO; border: 0px; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td style="vertical-align: top">
                        <table style="margin-left: 5px;">
                            <tr>
                                <td style="vertical-align: top;">
                                    <h2 class="h2_dot"><spring:message code='ezApprovalG.t407'/>
                                        <div style="text-align: right; margin-top: -23px; padding-right: 5px">
                                            <a class="imgbtn" onclick="AprlineUpper_onclick();"><span>
                                                <img src="/images/ImgIcon/prev.gif" height="16" alt="결재선 위로" style="vertical-align:middle"/></span></a>
                                            <a class="imgbtn" onclick="AprlineDown_onclick();"><span>
                                                <img src="/images/ImgIcon/next.gif" height="16" alt="결재선 아래로" style="vertical-align:middle"/></span></a>
                                        </div>
                                    </h2>
                                    <div class="border_gray">
                                        <div id="APRLINE" style="Width: 565px; Height: 490px; overflow: auto; border: 0; font-size: 9pt; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div>
                                        <table class="content" style="margin-top: 5px; width: 100%;">
                                            <tr>
                                                <td colspan="2" style="margin-top: 3px; text-align: center;">
                                                    <input type="checkbox" name="Reporter" id="Reporter" value="checkbox" onclick="return Reporter_onclick()" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;">
                                                    <span><spring:message code='ezApprovalG.t409'/></span>
                                                    <input type="checkbox" id="Suggester" name="Suggester" value="checkbox" onclick="return Suggester_onclick()" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;">
                                                    <span><spring:message code='ezApprovalG.t410'/></span>
                                                </td>
                                            </tr>
                                            <tr style="display: none">
                                                <th><spring:message code='ezApprovalG.t411'/></th>
                                                <td>
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <input id="ReasonNoAprTxt" name="ReasonNoAprTxt" type="text" style="width: 100%">
                                                            </td>
                                                            <td style="text-align: right; width: 55px;"><a class="imgbtn">
                                                                <span id="ReasonNoApr" onclick="return ReasonNoApr_onclick()" style="width: 40px"><spring:message code='ezApprovalG.t336'/></span></a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right;">
                                    <a style="margin-top: 2px; padding-right: 5px" class="imgbtn"><span id="btn_SaveAprLineTemplet" onclick="return btn_SaveAprLineTemplet_onclick()"><spring:message code='ezApprovalG.t384'/></span></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>

        </div>
    </div>

    <!-- 수신처 -->
    <div id="Receptinfo" style="border: 2px solid #dbdbda; width: 970px; height: 597px; display: none;">
        <table>
            <tr>
                <td style="vertical-align: top">
                    <div class="portlet_tabpart01" style="margin-top: 3px; text-align: right;">
                        <div class="portlet_tabpart01_top" id="tab3">
                            <p><span id="3tab1" divname="Organ"><spring:message code='ezApprovalG.t232'/></span></p>
                            <p><span id="3tab4" divname="Outer"><spring:message code='ezApprovalG.t330'/></span></p>
                            <p><span id="3tab2" divname="Save"><spring:message code='ezApprovalG.G0001'/></span></p>
                            <p><span id="3tab3" divname="Group"><spring:message code='ezApprovalG.t1568'/></span></p>
                        </div>
                    </div>
                    <div id="ReceptOrgan" style="display: none; padding-left: 3px">
                        <table style="margin-left: 0px;">
                            <tr>
                                <td style="vertical-align: top;">
                                    <div id="TreeView2" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 524px; width: 388px; border: 1px solid #b6b6b6; background-color: #FFFFFF; margin: 1px 1px 1px 1px;">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td height="30" style="background-color: transparent">
                                    <input id="txtDeptName" style="width: 150px" name="textUser" onkeyup="return btnSearchDept_onKeyPress(event)"  maxlength="50">
                                    <a style="margin-top: 2px" class="imgbtn"><span id="Span2" onkeyup="return btnSearchDept_onClick()" onclick="return btnSearchDept_onClick()" ><spring:message code='ezApprovalG.t250'/></span></a>
                                    <a class="imgbtn" style="margin-top: 2px; margin-right: 5px" id="AprDeptAdd" onclick="AprDeptAdd_onclick('DEPT');"><span><spring:message code='ezApprovalG.G0002'/></span></a>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <div id="ReceptOuter" style="display: none; padding-left: 3px">
                        <table style="margin-left: 0px;">
                            <tr>
                                <td style="vertical-align: top;">
                                    <div id="TreeView3" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 518px; width: 388px; border: 1px solid #b6b6b6; background-color: #FFFFFF; margin: 1px 1px 1px 1px;">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="background-color: transparent; height: 30px;">
                                    <input id="txtOuterDeptName" style="width: 150px" name="textUser2" onkeyup="return btnSearchDept_onKeyPress2(event)"  maxlength="50">
                                    <a style="margin-top: 2px" class="imgbtn"><span id="Span7" onkeyup="return btnSearchDept_onClick()" onclick="return btnSearchDept_onClick()" ><spring:message code='ezApprovalG.t250'/></span></a>
                                    <a class="imgbtn" style="margin-top: 3px;" id="AprDeptOuterAdd" onclick="AprDeptOuterAdd_onclick();"><span><spring:message code='ezApprovalG.t1236'/></span></a>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <div id="ReceptTemp" style="display: none; padding-left: 5px">
                        <table>
                            <tr>
                                <td style="background-color: #f3f3f3; padding: 4px 0 3px 0; background-color: #ffffff; height: 20px;">
                                    <h2 class="h2_dot"><spring:message code='ezApprovalG.G0003'/></h2>
                                    <div class="border_gray">
                                        <div id="RecSaveList" style="border: 0px; Width: 386px; Height: 237px; OVERFLOW: AUTO; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="background-color: transparent; text-align: center; height: 30px;">
                                    <table class="content" style="margin-bottom: 5px; width: 100%;">
                                        <tr>
                                            <td style="text-align: center;">
                                                <a class="imgbtn"><span id="Span3" onclick="return btn_AprDeptTempletDel_onclick()"><spring:message code='ezApprovalG.t252'/></span></a>
                                                <a class="imgbtn"><span id="Span4" onclick="return btn_AprDeptTempletSave_onclick('MODIFY')"><spring:message code='ezApprovalG.G0006'/></span></a>
                                                <a class="imgbtn"><span onclick="return btn_AprDeptTempletAdd_onclick()" style="width: 60px;"><spring:message code='ezApprovalG.t336'/></span></a>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align: top;">
                                    <div class="border_gray">
                                        <div id="RecSaveDetail" style="Width: 386px; Height: 240px; OVERFLOW: AUTO; border: 0px; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="ReceptGroup" style="display: none; padding-left: 5px">
                        <table>
                            <tr>
                                <td style="background-color: #f3f3f3; padding: 4px 0 3px 0; background-color: #ffffff; height: 20px;">
                                    <h2 class="h2_dot"><spring:message code='ezApprovalG.G0007'/></h2>
                                    <div class="border_gray">
                                        <div id="RecGroupList" style="border: 0px; Width: 386px; Height: 190px; OVERFLOW: AUTO; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="background-color: transparent; text-align: center; height: 30px;">
                                    <table class="content" style="margin-bottom: 5px; width: 100%">
                                        <tr>
                                            <td style="text-align: center;">
                                                <a class="imgbtn"><span onclick="return btn_GroupReceptAdd_onclick()" style="width: 60px;"><spring:message code='ezApprovalG.G0008'/></span></a>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align: top;">
                                    <div class="border_gray">
                                        <div id="RecGroupDetail" style="Width: 386px; Height: 295px; OVERFLOW: AUTO; border: 0px; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
                <!-- 2015-06-23 표준모듈:추가 - KSK -->
                <td style="width: 30px; text-align: center;" >
                    <div style="display: inline-block;" id="AddRemoveBTN">
                        <img src="/images/arr_rr.gif" alt="" width="16" height="16" border="0" style="cursor:pointer;" id="imgInsertAll" onclick="return InsertRecAll();">
                        <br>
                        <img src="/images/arr_r.gif" alt="" width="16" height="16" border="0" style="cursor:pointer;" id="imgInsert" onclick="return InsertRec();">
                        <br>
                        <img src="/images/arr_l.gif" alt="" width="16" height="16" border="0" style="cursor:pointer;" id="imgDelete" onclick="return DeleteRec();">
                        <br>
                        <img src="/images/arr_ll.gif" alt="" width="16" height="16" border="0" style="cursor:pointer;" id="imgDeleteAll" onclick="return DeleteRecAll();">
                    </div>
                </td>
                <td style="vertical-align: top">
                    <table style="margin-left: 5px;">
                        <tr>
                            <td style="vertical-align: top;" colspan="2">
                                <h2 class="h2_dot"><spring:message code='ezApprovalG.t253'/></h2>
                                <div class="border_gray">
                                    <div id="RECEPTLIST" style="Width: 550px; Height: 500px; overflow: auto; border: 0; font-size: 9pt; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <!-- 2015-06-30 표준모듈:추가(외부수신자요약) - KSK -->
                        <tr style="display:none;" id="trSummaryOuterReceiverList">
                            <td style="width: 120px;">
                                <h2 class="h2_dot">외부수신자 요약:</h2>
                            </td>
                            <td>
                                <input id="inputSummaryOuterReceiverList" style="width: 97%; margin-top: 5px;" value="" />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:left">
                                <a style="margin-top: 5px; display: none" class="imgbtn" id="btnaddress"><span onclick="return btnAddAddress()" ><spring:message code='ezApprovalG.t334'/></span></a>
                                <a style="margin-top: 5px; display: none;" class="imgbtn" id="btnaddressChange" ><span onclick="return btnaddressChange()" ><spring:message code='ezApprovalG.t348'/></span></a>
                            </td>
                            <td style="text-align:right">
                                <a class="imgbtn" style="padding-right: 5px;margin-top:5px;"><span id="Span5" onclick="return btn_AprDeptTempletSave_onclick('NEW')"><spring:message code='ezApprovalG.G0009'/></span></a>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    <!-- 기록물철 -->
    <div id="Cabinetinfo" style="border: 2px solid #dbdbda; width: 976px; height: 597px; display: none;">
        <table>
            <tr>
                <td colspan="2">
                    <h2 class="h2_dot" style="margin-left: 10px"><spring:message code='ezApprovalG.t1039'/></h2>
                    <table class="content" style="width: 100%; margin-left: 2px;">
                        <tr>
                            <th style="width: 50px"><spring:message code='ezApprovalG.t592'/></th>
                            <td style="width: 105px">
                                <select id="selTaskCategory" onchange="return selTaskCategory_onchange()" style="width: 100px">
                                </select>
                            </td>
                            <th style="width: 50px"><spring:message code='ezApprovalG.t593'/></th>
                            <td style="width: auto;">
                                <select id="selTaskMCategory" onchange="return selTaskMCategory_onchange()" style="width: 100px; margin-top: 3px">
                                </select>
                                &nbsp;
                                        <span id="trCreateCab">
                                        	<c:if test="${initFlag == '1'}">
	                                            <a class="imgbtn" style="margin-top: 2px"><span onclick="return btnCreateCab_onclick()"><spring:message code='ezApprovalG.t1118'/></span></a>
	                                            <a class="imgbtn" style="margin-top: 2px"><span onclick="return btnNewVolume_onclick()"><spring:message code='ezApprovalG.t894'/></span></a>
                                        	</c:if>
                                        </span>
                                <span id="trCreateCabDummy" style="display: none"></span>
                                <span style="vertical-align: middle; position: absolute; right: 20px">
                                    <select id="selSearchOption" style="vertical-align: middle;">
                                        <option>
                                            <spring:message code='ezApprovalG.t10026'/>
                                        </option>
                                        <option>
                                            <spring:message code='ezApprovalG.t577'/>
                                        </option>
                                    </select>
                                    <input type="text" id="Cabinetkeyword" value="" onkeypress="CabinetSearch_Press(event)">
                                    <a class="imgbtn" style="margin-top: 2px"><span name="btnSearch" onclick="return CabinetSearch_onclick()"><spring:message code='ezApprovalG.t111'/></span></a>
                                    <a class="imgbtn" style="margin-top: 2px"><span name="btnSearch" onclick="return Cabinetinfo_ini()"><spring:message code='ezApprovalG.t165'/></span></a>
                                </span>
                            </td>
                        </tr>
                    </table>
                    <div class="border_gray" style="margin-top: 5px; margin-left: 3px">
                        <div id="TaskSCateList" style="border: 0; HEIGHT: 295px; WIDTH: 968px; overflow-x: hidden; overflow-y: auto; margin: 0px 1px 1px 1px;"></div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>                    
                    <h2 class="h2_dot" style="margin-left: 10px"><spring:message code='ezApprovalG.t00001'/></h2>
                </td>
                <td style="padding-top:5px;padding-right:20px">
                    <div align="right">
                        <a class="imgbtn"><span onclick="return Set_MyTask('INS')"><spring:message code='ezApprovalG.t00002'/></span></a>
                        <a class="imgbtn"><span onclick="return Set_MyTask('DEL')"><spring:message code='ezApprovalG.t00003'/></span></a>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div class="border_gray" style="margin-top: 5px; margin-left: 3px">
                        <div id="MyTaskSCateList" style="border: 0; HEIGHT: 180px; WIDTH: 968px; overflow-x: hidden; overflow-y: auto; margin: 0px 1px 1px 1px;"></div>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <!-- 문서정보 -->
    <div id="Docinfo" style="border: 2px solid #dbdbda; width: 976px; height: 597px; display: none;">

        <h2 class="h2_dot" style="margin-left: 5px;"><spring:message code='ezApprovalG.t1204'/></h2>
        <table class="content">
            <tr>
                <th><spring:message code='ezApprovalG.t875'/></th>
                <td>
                    <div style="padding-top: 5px; padding-left: 3px;">
                        <input type="checkbox" name="special1" id="special1" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> <spring:message code='ezApprovalG.t1205'/></span>
                    </div>
                    <div style="padding-top: 5px; padding-left: 3px;">
                        <input type="checkbox" name="special2" id="special2" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> <spring:message code='ezApprovalG.t984'/></span>
                    </div>
                    <div style="padding-top: 5px; padding-left: 3px;">
                        <input type="checkbox" name="special3" id="special3" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> <spring:message code='ezApprovalG.t1206'/></span>
                    </div>
                    <div style="padding-top: 5px; padding-left: 3px;">
                        <input type="checkbox" name="special4" id="special4" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> <spring:message code='ezApprovalG.t986'/></span>
                    </div>
                    <div style="padding-top: 5px; padding-bottom: 5px; padding-left: 3px;">
                        <input type="checkbox" name="special5" id="special5" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> <spring:message code='ezApprovalG.t1207'/></span>
                    </div>

                </td>
            </tr>
            <tr>
                <th><spring:message code='ezApprovalG.t118'/></th>
                <td>
                    <select id="selSecLevel" name="select" style="WIDTH: 85px">
                        ${securityNode3}
                    </select>
                </td>
            </tr>
            <tr>
                <th><spring:message code='ezApprovalG.t109'/></th>
                <td>
                    <div style="padding-left: 3px; padding-top: 5px; padding-bottom: 5px;">
                        <spring:message code='ezApprovalG.t10029'/><br />
                    </div>
                    <div style="padding-left: 3px; padding-bottom: 5px;">
                        <input type="radio" name="rdoSecType" value="1" checked onclick="return rdoSecType_onclick(this.value)" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span><spring:message code='ezApprovalG.t47'/></span>&nbsp;
                        <input type="radio" name="rdoSecType" value="2" onclick="return rdoSecType_onclick(this.value)" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span><spring:message code='ezApprovalG.t150'/></span>&nbsp;
                        <input type="radio" name="rdoSecType" value="3" onclick="return rdoSecType_onclick(this.value)" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span><spring:message code='ezApprovalG.t46'/></span>&nbsp;
                    </div>
                </td>

            </tr>
            <tr>
                <th><spring:message code='ezApprovalG.t989'/></th>
                <td>
                    <div style="padding-top: 5px; padding-left: 3px;">
                        <input type="checkbox" name="selSecLevel1" id="selSecLevel1" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> 1<spring:message code='ezApprovalG.t991'/>&nbsp;</span>
                        <input type="checkbox" name="selSecLevel2" id="selSecLevel2" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> 2<spring:message code='ezApprovalG.t991'/></span>
                        <input type="checkbox" name="selSecLevel3" id="selSecLevel3" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> 3<spring:message code='ezApprovalG.t991'/></span>
                        <input type="checkbox" name="selSecLevel4" id="selSecLevel4" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> 4<spring:message code='ezApprovalG.t991'/></span><br>
                    </div>
                    <div style="padding-top: 5px; padding-bottom: 5px; padding-left: 3px;">
                        <input type="checkbox" name="selSecLevel5" id="selSecLevel5" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> 5<spring:message code='ezApprovalG.t991'/>&nbsp;</span>
                        <input type="checkbox" name="selSecLevel6" id="selSecLevel6" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> 6<spring:message code='ezApprovalG.t991'/></span>
                        <input type="checkbox" name="selSecLevel7" id="selSecLevel7" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> 7<spring:message code='ezApprovalG.t991'/></span>
                        <input type="checkbox" name="selSecLevel8" id="selSecLevel8" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> 8<spring:message code='ezApprovalG.t991'/></span>
                    </div>
                </td>
            </tr>
            <tr>
                <th><spring:message code='ezApprovalG.t876'/></th>
                <td>
                    <input type="text" name="txtLimitRange" id="txtLimitRange" class="text" style="Width: 170px; font-size: 9pt"><span>(<spring:message code='ezApprovalG.t1209'/></span></td>
                <tr>
                    <th><spring:message code='ezApprovalG.t979'/></th>
                    <td>
                        <input type="text" name="txtPageNum" id="txtPageNum" class="text" style="Width: 170px; font-size: 9pt"></td>
                </tr>
            <tr>
                <th><spring:message code='ezApprovalG.t1199'/></th>
                <td>
                    <input type="checkbox" name="AprUrgency" id="AprUrgency" value="checkbox"><spring:message code='ezApprovalG.t10090'/>
                </td>
            </tr>
            <tr>
                <th><spring:message code='ezApprovalG.t1210'/></th>
                <td>
                    <input type="checkbox" name="AprSecurity" id="AprSecurity" value="checkbox" onclick="AprSecurity_onClick()">
                    <input readonly="true" type="text" class="datepicker" id="idDatepicker" />
                    <img id="img_Post_D1" src="/images/i_scheduler.gif" width="19" height="15"
                        style="CURSOR: pointer; POSITION: relative; vertical-align: middle;" popuplocation='topleft'>
                    <input id='Post_D2'
                        class='datepicker_date'
                        readonly="true"
                        type="text"
                        style="width: 95px; display: none" name="Post_D2">
                    <img src="/images/i_scheduler.gif" id="img_Post_D2" border="0" width="19" height="15" popuplocation='topleft' style="display: none; CURSOR: pointer; POSITION: relative" >
                </td>
            </tr>
        </table>
        <h2 style="margin-left: 5px;"><spring:message code='ezApprovalG.t1203'/></h2>
        <textarea id="taSummery" name="taSummery" style="HEIGHT: 198px; WIDTH: 100%; box-sizing: border-box; -moz-box-sizing: border-box;"></textarea>
    </div>
    <br />
    <div style="text-align: center;" id="orgbtnArea">
        <table style="width: 976px">
            <tr>
                <td style="text-align: center;">
                    <a class="imgbtn"><span style="width: 60px; text-align: center;" onclick="btn_OK()"><spring:message code='ezApprovalG.t1760'/></span></a>
                    <a class="imgbtn"><span style="width: 60px; text-align: center;" onclick="btn_Close()"><spring:message code='ezApprovalG.t1761'/></span></a>
                </td>
            </tr>
        </table>
    </div>
    <!-- 사용자 정보 해더 xml -->
    <xml id="userlist_h" style="display: none">
    <LISTVIEWDATA>
    <HEADERS>
        <HEADER>
        <NAME><spring:message code='ezApprovalG.G0028'/></NAME>
        <WIDTH>70</WIDTH>
        </HEADER>
        <HEADER>
        <NAME><spring:message code='ezApprovalG.G0029'/></NAME>
        <WIDTH>100</WIDTH>
        </HEADER>
        <HEADER>
        <NAME><spring:message code='ezApprovalG.G0030'/></NAME>
        <WIDTH>60</WIDTH>
        </HEADER>
        <HEADER>
        <NAME><spring:message code='ezApprovalG.t231'/></NAME>
        <WIDTH>80</WIDTH>
        </HEADER>
    </HEADERS>
    <ROWS></ROWS>
    </LISTVIEWDATA>
</xml>
    <xml id="Category_h" style="display: none">
    <LISTVIEWDATA>
    <HEADERS>
        <HEADER>
        <NAME><spring:message code='ezApprovalG.t10026'/></NAME>
        <WIDTH>17%</WIDTH>
        </HEADER>
        <HEADER>
        <NAME><spring:message code='ezApprovalG.t693'/> (<spring:message code='ezApprovalG.t10091'/>)</NAME>
        <WIDTH>24%</WIDTH>
        </HEADER>
        <HEADER>
        <NAME><spring:message code='ezApprovalG.t577'/> (<spring:message code='ezApprovalG.t10091'/>)</NAME>
        <WIDTH>24%</WIDTH>
        </HEADER>
        <HEADER>
        <NAME><spring:message code='ezApprovalG.t1065'/></NAME>
        <WIDTH>15%</WIDTH>
        </HEADER>
        <HEADER>
        <NAME><spring:message code='ezApprovalG.t10027'/></NAME>
        <WIDTH>10%</WIDTH>
        </HEADER>
        <HEADER>
        <NAME><spring:message code='ezApprovalG.t10092'/></NAME>
        <WIDTH>10%</WIDTH>
        </HEADER>
    </HEADERS>
    <ROWS></ROWS>
    </LISTVIEWDATA>
</xml>
<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
    <!-- 사용자 정보 해더 xml -->
</body>
<script type="text/javascript">
    Tab1_NewTabIni("tab1");
    Tab2_NewTabIni("tab2");
    Tab3_NewTabIni("tab3");
</script>
</html>