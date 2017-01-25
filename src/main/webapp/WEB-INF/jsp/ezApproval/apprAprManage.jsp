<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title>Untitled Document</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=uft-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezApproval.e1'/>" ></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/js_Cross/Common.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/ListView_list.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/js_Cross/Viewer_htc.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/setLogData_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/ezHistory_Cross.js"></script>    
	    <script type="text/javascript" src="/js/ezApproval/js_Cross/SendMailApprove.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/aprmanage_comm.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/Common_Function.js"></script>    
	    <script type="text/javascript" src="/js/NameControl.js"></script>
	    <c:if test="${isIEBrowser}">
		    <script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
		    <script type="text/javascript" src="/js/ezApproval/js/Approval_Preview.js"></script>
	    </c:if>
	    <script type="text/javascript" src="/js/jQuery/jquery.js"></script>
	    <script type="text/javascript" src="/js/jQuery/jquery-ui.js"></script>
	    <link rel="stylesheet" href="/js/jQuery/jquery-ui.css">
	    <link rel="stylesheet" href="/js/jQuery/jquery-ui.min.css">
	    <script id="clientEventHandlersJS">
	        window.onload = window_onload;
	        var pUse_Editor = "${useEditor}";
	        var xpo;
	        var ypo;
	        var Resultxml = createXmlDom();
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user";
	        arr_userinfo[1] = "${userInfo.id}";
	        arr_userinfo[2] = "${userInfo.displayName}";
	        arr_userinfo[3] = "${userInfo.title}";
	        arr_userinfo[4] = "${userInfo.deptID}";
	        arr_userinfo[5] = "${userInfo.deptName}";
	        arr_userinfo[6] = "${userInfo.jikChek}";
	        arr_userinfo[8] = "${userInfo.email}";
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "${susinAdmin}";
	        arr_userinfo[11] = "${userInfo.displayName1}";
	        arr_userinfo[12] = "${userInfo.displayName2}";
	        arr_userinfo[13] = "${userInfo.title1}";
	        arr_userinfo[14] = "${userInfo.title2}";
	        arr_userinfo[15] = "${userInfo.deptName1}";
	        arr_userinfo[16] = "${userInfo.deptName2}";
	        var userLang = "${userInfo.lang}";
	        var companyID = "${userInfo.companyID}";
	        arr_userinfo[7] = "${bujaeInfo}";
	        var formURL = "";
	        var formID = "";    
	        var reFormFlag = "";
	        var formDocType = "";
	        var pDocInfoValue = "1";
	        var pListTypeValue = "${listType}";
	        var pListTypeName = "LISTTYPE";
	        var pDocTypeName = "DOCTYPE";
	        var pUserID = arr_userinfo[1];
	        var KuyjeType;
	        var g_tagSelect = "1";
	        var g_tagSelectsub = "1";
	        var SelectFlag = true;
	        var pSusinManagerFlag;
	        var g_timeID;
	        var displayFlag = true;
	        var pSelMenu = "${selMenu}";
	        var pdate;
	        var datedisplay = "";
	        var pageNum = "1";
	        var BlockSize = "10";
	        var chkPage = true;
	        var newDocID = "";
	        var pDocID = "";
	        var pURL = "";
	        var Block_Size = 10;
	        var nowblock = "0";
	        var OrderOption = "";
	        var OrderCell = "";
	        var SubQuery = "${subQuery}";
	        var _DeptInfo = "${deptInfo}";
	        var MultiSelectedDocID = "";
	        var MultiAppPass = "";
	        var _USE_AdditionalROle = "${useAdditionalRole}";
	        var g_bPrevShow = false;
	        var g_PreView = null;
	        var g_PreViewID = null;
	        var g_PreviewTitle = null;
	        var g_moveStart = false;
	        var g_startPosition = 0;
	        var flag = false;
	        var g_prevElem = null;
	        var g_prevHTTP = null;
	        var g_prevAttHTTP = null;
	        var g_prevBoardID = "";
	        var g_prevItemID = "";
	        var prevHeight = 0;
	        var g_szUserID = arr_userinfo[8];
	        var g_senderinfo = "${userInfo.companyName}" + ", " + "${userInfo.deptName}" + ", " + "${userInfo.title}";
	        var subTabLastCol = 6;
	        var SearchCond = new Array();
	        var SQLPARADATA = "";
	        var t822 = "<spring:message code='ezApproval.t822'/>";
	        var t823 = "<spring:message code='ezApproval.t823'/>";
	        var t809 = "<spring:message code='ezApproval.t809'/>";
	        var t810 = "<spring:message code='ezApproval.t810'/>";
	        var t23 = "<spring:message code='ezApproval.t23'/>";
	        var t24 = "<spring:message code='ezApproval.t24'/>";
	        var t25 = "<spring:message code='ezApproval.t25'/>";
	        var t817 = "<spring:message code='ezApproval.t817'/>";
	        
	        var pOpenYaer = "${openYear}";
	        var ViewLeftCount = "${viewLeftCount}";
	
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	
	        $(function () {
	            if ("${userInfo.lang}" == "2") {
	                document.getElementById("sel_year").style.width = "100px";
	            }
	            $("#sel_year").selectmenu({
	                change: function (event, data) {
	                    onSelect_Year(data.item.value);
	                }
	            });
	
	            $("#number")
	              .selectmenu()
	              .selectmenu("menuWidget")
	                .addClass("overflow");
	        });
	
	        function checkBujaeInfo() {
	            var BString = arr_userinfo[7];
	            if (BString != "") {
	                var BDim = new Array("");
	                BDim = BString.split(":");
	                var tmpStartDate = TextReplace(BDim[3].substring(0, 16), "/", ":");
	                var tmpEndDate = TextReplace(BDim[4].substring(0, 16), "/", ":");
	
	                if (tmpEndDate < "${nowDate}") {
	                    setBujaeOff();
	                    checkBujaeInfo_Complete(true);
	                    return;
	                }
	                else if (tmpStartDate > "${nowDate}") {
	                    checkBujaeInfo_Complete("ING");
	                    return;
	                }
	
	                var pAlertContent = arr_userinfo[2] + "<spring:message code='ezApproval.t803'/><br>" + tmpStartDate + "<spring:message code='ezApproval.t804'/>" + tmpEndDate + "<spring:message code='ezApproval.t805'/><br> <spring:message code='ezApproval.t806'/>";
	                var Rtnval = OpenInformationUI(pAlertContent, checkBujaeInfo_Complete, "OPEN");
	                if (Rtnval)
	                    checkBujaeInfo_Complete(Rtnval);
	            }
	            else {
	                checkBujaeInfo_Complete("ING");
	            }
	        }
	        function checkBujaeInfo_Complete(Rtnval) {
	            if (Rtnval == true) {
	                setBujaeOff();
	            }
	            else if (Rtnval == "ING") { }
	            else {
	                setbuttonenable();
	                return;
	            }
	
	            if (beforeJob != pListTypeValue) {
	                beforeJob = pListTypeValue;
	                pageNum = 1;
	            }
	            if (arr_userinfo[10] == "YES" || arr_userinfo[10] == "Y")
	                pSusinManagerFlag = "admin";
	            else
	                pSusinManagerFlag = "user";
	
	            var nowyear = new Date().getFullYear();
	            var nowmonth = new Date().getMonth() + 1;
	            var nowday = new Date().getDate();
	
	            if (nowmonth < 10)
	                nowmonth = "0" + nowmonth;
	
	            if (nowday < 10)
	                nowday = "0" + nowday;
	
	            var settingDate = new Date();
	            settingDate.setYear(settingDate.getYear() - 1);
	
	            var settingmonth = settingDate.getMonth() + 1;
	            var settingday = settingDate.getDate();
	            if (settingmonth < 10)
	                settingmonth = "0" + settingmonth;
	            if (settingday < 10)
	                settingday = "0" + settingday;
	
	
	            SQLPARADATA = "<ROOT><TYPE>STARTDATEAF;STARTDATEBF;</TYPE><DATA><STARTDATEAF>" + (nowyear - 1) + "-" + settingmonth + "-" + settingday + " 00:00:01</STARTDATEAF><STARTDATEBF>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59</STARTDATEBF></DATA></ROOT>";
	
	            if (pListTypeValue == "1") {
	                getDocList();
	            }
	            if (pListTypeValue == "2") {
	                document.getElementById("tbar1").style.display = "none";
	                getDocList();
	            }
	            else if (pListTypeValue == "3") {
	                document.getElementById("tbar1").style.display = "none";
	                getDocList();
	            }
	            else if (pListTypeValue == "4") {
	                getReceivedDocList();
	            }
	            else if (pListTypeValue == "7" || pListTypeValue == "6") {
	                document.getElementById("tbar1").style.display = "none";
	                getSimsaDocList();
	            }
	            else if (pListTypeValue == "9") {
	                document.getElementById("tbar1").style.display = "none";
	                getDocList();
	            }
	
	            if ("${userInfoEnforce}" == "2") {
	                document.getElementById("tbtnSimsa").style.display = "";
	            }
	        }
	
	        function TextReplace(str, source, copy) {
	            while (str.indexOf(source) != -1) {
	                str = str.substring(0, str.indexOf(source)) + copy + str.substring(str.indexOf(source) + source.length);
	            }
	            return str;
	        }
	        function window_onload() {
	            var height = parseInt(divList.style.height.replace('px', '')) + 200;
	            var reheight = document.documentElement.clientHeight - parseInt(height);
	            if (reheight > 0)
	                document.getElementById('div_AprLine').style.height = reheight + "px";
	
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            try {
	                if ("${useocs}" == "YES") {
	                    SetOCSInfo("${useocs}", "${emailDomain}");
	                }
	                document.getElementById("presentcell").innerHTML = unescape(" - ${tmpValue}");
	                hideProgress();
	
	                var toDay = new Date();
	                var toDayYear = parseInt(toDay.getFullYear());
	                var minusYear = parseInt(toDay.getFullYear()) - parseInt(pOpenYaer);
	
	                for (var i = toDayYear; i >= toDayYear - minusYear ; i--)
	                    AddOption(sel_year, i, i);
	
	                checkBujaeInfo();
	
	            } catch (e) {
	                hideProgress();
	            }
	        }
	
	        var SelYearFlag = false;
	        function onSelect_Year() {
	            SelYearFlag = true;
	            if (GetSelectVal("sel_year") != "ALL")
	                SQLPARADATA = "<ROOT><TYPE>STARTDATEAF;STARTDATEBF;</TYPE><DATA><STARTDATEAF>" + GetSelectVal("sel_year") + "-01-01 00:00:01</STARTDATEAF><STARTDATEBF>" + GetSelectVal("sel_year") + "-12-31 23:59:59</STARTDATEBF></DATA></ROOT>";
	            else {
	                var nowyear = new Date().getFullYear();
	                var nowmonth = new Date().getMonth() + 1;
	                var nowday = new Date().getDate();
	
	                if (nowmonth < 10)
	                    nowmonth = "0" + nowmonth;
	
	                if (nowday < 10)
	                    nowday = "0" + nowday;
	
	                var settingDate = new Date();
	                var settingmonth = settingDate.getMonth() + 1;
	                var settingday = settingDate.getDate();
	                if (settingmonth < 10)
	                    settingmonth = "0" + settingmonth;
	                if (settingday < 10)
	                    settingday = "0" + settingday;
	
	                SQLPARADATA = "<ROOT><TYPE>STARTDATEAF;STARTDATEBF;</TYPE><DATA><STARTDATEAF>" + (nowyear - 1) + "-" + settingmonth + "-" + settingday + " 00:00:01</STARTDATEAF><STARTDATEBF>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59</STARTDATEBF></DATA></ROOT>";
	            }
	
	            if (pListTypeValue == "4")
	                getReceivedDocList();
	            else if (pListTypeValue == "6")
	                getSimsaDocList();
	            else
	                getDocList();
	        }
	
	        function lvDocList_SelChange() {
	            var SelList = new ListView();
	            SelList.LoadFromID("DocList");
	            var oArrRows = SelList.GetSelectedRows();
	            var tr = oArrRows[0];
	            if (tr.length != 0) {
	                if (pListTypeValue != "5") {
	                    if (pDocInfoValue == "1")
	                        getAprLine(tr);
	                    else {
	                        getAprDocAproveInfo(tr)
	                    }
	                }
	                else {
	                    if (tr) {
	                        pDocID = GetAttribute(tr,"DATA1");
	                        pURL = GetAttribute(tr,"DATA2");
	
	                        switch (pDocInfoValue) {
	
	                            case "4":
	                                getDataInfo("3");
	                                break;
	
	                            case "3":
	                                getDataInfo("4");
	                                break;
	
	                            case "1":
	                                getDataInfo("1");
	                                break;
	
	                            case "2":
	                                getDataInfo("2")
	                                break;
	                        }
	                    }
	                }
	                setbuttonenable();
	                if (pListTypeValue == "2" || pListTypeValue == "3") {
	                    if (oArrRows.length > 0) {
	                        var DocID = GetAttribute(tr,"DATA1");
	
	                        cancelYN(DocID);
	                    }
	                }
	            }
	        }
	        function lvDocList_SelChanging() {
	        }
	        function lvDocList_DBSelChange() {
	            var SelList = new ListView();
	            SelList.LoadFromID("DocList");
	            var oArrRows = SelList.GetSelectedRows();
	            var tr = oArrRows[0];
	
	            if (tr != null && oArrRows.length > 0) {
	                if (GetBujaeFlag()) {
	                    var pAlertContent = "<spring:message code='ezApproval.t807'/><br>  <spring:message code='ezApproval.t808'/>";
	                    OpenAlertUI(pAlertContent);
	                    return;
	                }
	                if (pListTypeValue == "1") {
	                    if (document.getElementById("tbtnRedraft").style.display == "none" && document.getElementById("tbtnApprove").style.display == "") {
	                        var oArrRows = SelList.GetSelectedRows();
	                        var pCurSelRow = oArrRows[0];
	
	                        if (_USE_AdditionalROle == "YES") {
	                            if (pCurSelRow) {
	                                var ret = CheckAprLineInfo(pCurSelRow);
	
	                                if (ret != "OK") {
	                                    var pAlertContent = "<spring:message code='ezApproval.t23'/><br>" +
	                                                "<spring:message code='ezApproval.t24'/>" + ret + "<spring:message code='ezApproval.t25'/>";
	                                    OpenAlertUI(pAlertContent);
	                                    return;
	                                }
	                            }
	                        }
	                        openApprovUI();
	                    }
	                    else {
	                        if (document.getElementById("tbtnRedraft").style.display == "none" && GetAttribute(tr,"DATA15") == strDocType4)
	                            openViewDocInfo();
	                        else
	                            btnRedraft_onclick();
	                    }
	                }
	                else if (pListTypeValue == "4") {
	                    var oArrRows = SelList.GetSelectedRows();
	                    var pCurSelRow = oArrRows[0];
	                    if (pCurSelRow.length != 0) {
	                        if (pSusinManagerFlag == "admin" || trim_Cross(GetAttribute(pCurSelRow,"DATA8")) == pUserID) {
	                            var pDraftFlag;
	                            var tmpFunctionType = GetAttribute(pCurSelRow,"DATA9");
	
	                            if (tmpFunctionType == strDocState11 || tmpFunctionType == strDocState15)
	                                pDraftFlag = "SUSIN";
	                            else if (tmpFunctionType == strDocState12)
	                                pDraftFlag = "HAPYUI";
	                            if (GetAttribute(pCurSelRow,"DATA10") == strAprState15) {
	                                openViewDocInfo();
	                            }
	                            else {
	                                OpenReceiveDraftUI(pCurSelRow, pDraftFlag);
	                            }
	                        }
	                        else {
	                            openViewDocInfo();
	                        }
	                    }
	                }
	                else if (pListTypeValue == "9") {
	                    btnRedraft_onclick();
	                }
	                else if (pListTypeValue != "5") {
	                    openViewDocInfo();
	                }
	                else {
	                    var para = new Array()
	                    para[0] = pDocID;
	                    para[1] = pURL;
	                    var openLocation = "";
	                    if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
	                        if (CrossYN())
	                            openLocation = "/myoffice/ezApproval/ezViewHWP/ezViewEnd_HWP_Cross.aspx";
	                        else
	                            openLocation = "/myoffice/ezApproval/ezViewHWP/ezViewEnd_HWP.aspx";
	                    }
	                    else {
	                        openLocation = "/myoffice/ezApproval/formContainer/contDocView";
	
	                        if (CrossYN() || pNoneActiveX == "YES") {
	                            openLocation = "/myoffice/ezApproval/formContainer/contDocView_Cross.aspx";
	                        }
	                        else {
	                            if (pUse_Editor == "")
	                                openLocation = "/myoffice/ezApproval/formContainer/contDocView.aspx";
	                            else
	                                openLocation = "/myoffice/ezApproval/formContainer/contDocView_IE.aspx";
	                        }
	                    }
	                    openLocation = openLocation + "?DocID=" + escape(pDocID) + "&DocHref=" + escape(pURL) + "&ListSusin=";
	                    var result = GetOpenWindow(openLocation, "", 1000, 950, "YES");
	                }
	            } else {
	
	                openApprovUI();
	            }
	        }
	        function lvDocList_HeaderClick(pHeaderName) {
	            if (OrderCell == pHeaderName) {
	                if (OrderOption == "")
	                    OrderOption = "DESC";
	                else
	                    OrderOption = "";
	            }
	            else {
	                OrderCell = pHeaderName;
	                OrderOption = "";
	            }
	            openergetDocInfo();
	        }
	        function lvAprLine_SelChange() {
	        }
	        function lvAprLine_SelClcik() {
	            var SelList = new ListView();
	            SelList.LoadFromID("AprLine");
	            var oArrRows = SelList.GetSelectedRows();
	            var pCurSelRow = oArrRows[0];
	            AttachUrl = escape(GetAttribute(pCurSelRow,"DATA2"));
	            Attachfilename = escape(pCurSelRow.cells[1].innerHTML);
	        }
	        function lvAprLine_DBSelChange() {
	            var DocList = new ListView();
	            DocList.LoadFromID("AprLine");
	            var oArrRows = DocList.GetSelectedRows();
	            var tr = oArrRows[0];
	
	            if (tr != null && oArrRows.length > 0) {
	
	                switch (pDocInfoValue) {
	                    case "1":
	                        if (tr.cells[0].innerHTML != "")
	                            openUserInfo();
	                        break;
	                    case "4":
	                        var AttachfilenameA1 = tr.cells[1].innerHTML;
	                        if (AttachfilenameA1 != null) {
	                            var AttachfilenameN1 = AttachfilenameA1.lastIndexOf(".");
	                            var AttachfilenameA2 = AttachfilenameA1.substr(AttachfilenameN1, AttachfilenameA1.length);
	                            var AttachUrlA1 = GetAttribute(tr,"DATA1");
	                            var AttachUrlN1 = AttachUrlA1.lastIndexOf(".");
	                            var AttachUrlA2 = AttachUrlA1.substr(AttachUrlN1, AttachUrlA1.length);
	                            AttachUrl = encodeURIComponent(GetAttribute(tr,"DATA1"));
	                            if (AttachfilenameN1 < 0) {
	                                Attachfilename = encodeURIComponent(tr.cells[1].innerHTML + AttachUrlA2);
	                            }
	                            else {
	                                Attachfilename = encodeURIComponent(tr.cells[1].innerHTML);
	                            }
	                            var regData = "";
	
	                            if (document.all)
	                                regData = navigator.systemLanguage;
	                            else if (document.layers)
	                                regData = navigator.systemLanguage;
	                            else if (document.getElementById) {
	                                if (navigator && navigator.systemLanguage)
	                                    regData = navigator.systemLanguage.substr(0, 2)
	                                else {
	                                    if (typeof clientInformation != 'undefined')
	                                        regData = clientInformation.systemLanguage;
	                                    else
	                                        regData = "";
	                                }
	                            }
	                            else {
	                                if (typeof clientInformation != 'undefined') {
	                                    if (clientInformation && clientInformation.systemLanguage)
	                                        regData = clientInformation.systemLanguage;
	                                }
	                            }
	
	                            if (AttachUrl != "null") {
	                                var tempINGFlag = "";
	                                if (pListTypeValue == "9")
	                                    tempINGFlag = "TMP"
	                                else if (pListTypeValue == "6")
	                                    tempINGFlag = "END"
	                                else
	                                    tempINGFlag = "APR"
	                                if (GetAttribute(tr,"data4") == "file")
	                                    window.open(document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/ezCommon_InterFace.aspx?TYPE=APPROVAL&DOCID=" + GetAttribute(tr, "data3") + "&DOCSTATUS=" + tempINGFlag + "&DOCATTACHSN=" + GetAttribute(tr,"data2"));
	                                else
	                                    window.open("/myoffice/Common/DownloadAttach.aspx?filename=" + Attachfilename + "&filepath=" + AttachUrl + "&regData=" + regData);
	                            }
	
	                        }
	                        break;
	                    default:
	                }
	            }
	        }
	        function btnDraft_onclick() {
	            if (GetBujaeFlag()) {
	                var pAlertContent = "<spring:message code='ezApproval.t807'/><br>  <spring:message code='ezApproval.t808'/>";
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	            openForm();
	        }
	        function btnApprove_onclick() {
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var oArrRows = DocList.GetSelectedRows();
	            var pCurSelRow = oArrRows[0];
	
	            if (_USE_AdditionalROle == "YES") {
	                if (pCurSelRow) {
	                    var ret = CheckAprLineInfo(pCurSelRow);
	                    if (ret != "OK") {
	                        var pAlertContent = "<spring:message code='ezApproval.t23'/><br>" +
	                                    "<spring:message code='ezApproval.t24'/>" + ret + "<spring:message code='ezApproval.t25'/>";
	                        OpenAlertUI(pAlertContent);
	                        return;
	                    }
	                }
	            }
	            openApprovUI();
	        }
	        function btnUserInfo_onclick() {
	            openUserInfo();
	        }
	        function btnViewDoc_onclick() {
	            if (pListTypeValue != "5") {
	                var DocList = new ListView();
	                DocList.LoadFromID("DocList");
	                var oArrRows = DocList.GetSelectedRows();
	                var pCurSelRow = oArrRows[0];
	
	                if (oArrRows.length > 0)
	                    openViewDocInfo();
	                else {
	                    var pAlertContent = "<spring:message code='ezApproval.t809'/><br> <spring:message code='ezApproval.t810'/>";
	                    OpenAlertUI(pAlertContent);
	                }
	            }
	            else {
	                var para = new Array()
	                para[0] = pDocID;
	                para[1] = pURL;
	                var openLocation = "";
	                if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
	                    openLocation = "/myoffice/ezApproval/ezViewHWP/ezViewEnd_HWP_Cross.aspx";
	                }
	                else {
	
	                    openLocation = "/myoffice/ezApproval/formContainer/contDocView";
	
	                    if (CrossYN() || pNoneActiveX == "YES") {
	                        openLocation = "/myoffice/ezApproval/formContainer/contDocView_Cross.aspx";
	                    }
	                    else {
	                        if (pUse_Editor == "")
	                            openLocation = "/myoffice/ezApproval/formContainer/contDocView.aspx";
	                        else
	                            openLocation = "/myoffice/ezApproval/formContainer/contDocView_IE.aspx";
	                    }
	                }
	                openLocation = openLocation + "?DocID=" + escape(pDocID) + "&DocHref=" + escape(pURL) + "&ListSusin=";
	                var result = GetOpenWindow(openLocation, "", 1000, 950, "YES");
	            }
	        }
	        function btnRedraft_onclick() {
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var oArrRows = DocList.GetSelectedRows();
	            var pCurSelRow = oArrRows[0];
	            formURL = GetAttribute(pCurSelRow, "DATA3");
	            formID = pCurSelRow.getAttribute("DATA17");
	            reFormFlag = pCurSelRow.getAttribute("DATA18");
	
	            if (_USE_AdditionalROle == "YES") {
	                if (pCurSelRow) {
	                    var ret = CheckAprLineInfo(pCurSelRow);
	
	                    if (ret != "OK") {
	                        var pAlertContent = "<spring:message code='ezApproval.t23'/><br>" +
	                                    "<spring:message code='ezApproval.t24'/>" + ret + "<spring:message code='ezApproval.t25'/>";
	                        OpenAlertUI(pAlertContent);
	                        return;
	                    }
	                }
	            }
	            var docState = GetAttribute(pCurSelRow,"DATA12");
	            if (docState == strDocState12 || docState == strDocState14 || docState == strDocState18) {
	                OpenReceiveDraftUI(pCurSelRow, "REDRAFT");
	            }
	            else if (docState == strDocState11) {
	                OpenReceiveENDDraftUI(pCurSelRow, "REDRAFT");
	            }
	            else {
	
	
	                formDocType = GetAttribute(pCurSelRow,"DATA15");
	                var FunctionType = GetAttribute(pCurSelRow,"DATA10");
	
	                if (FunctionType == strAprState0)
	                    openServerDraftUI("REDRAFT", pCurSelRow);
	                else
	                    openDraftUI("REDRAFT", pCurSelRow);
	            }
	        }
	
	        function btnRemoveDoc_onclick() {
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var oArrRows = DocList.GetSelectedRows();
	            for (var i = 0; i < oArrRows.length; i++) {
	                if (pListTypeValue != "9") {
	                    if (GetAttribute(oArrRows[i], "data10") != "A04004" && GetAttribute(oArrRows[i],"data10") != "A04006") {
	                        OpenAlertUI("<spring:message code='ezApproval.t1108'/>", "OPEN");
	                        return;
	                    }
	                }
	            }
	            if (CrossYN() || pNoneActiveX == "YES") {
	                if (pListTypeValue == "9") {
	                    OpenInformationUI("<spring:message code='ezApproval.t811'/>", RemoveTmpDoc, "OPEN");
	                }
	                else {
	                    OpenInformationUI("<spring:message code='ezApproval.t811'/>", RemoveDoc, "OPEN");
	                }
	            }
	            else {
	                if (pListTypeValue == "9") {
	                    var removeOk = OpenInformationUI("<spring:message code='ezApproval.t811'/>", RemoveTmpDoc, "");
	                    if (removeOk)
	                        RemoveTmpDoc();
	                }
	                else {
	                    var removeOk = OpenInformationUI("<spring:message code='ezApproval.t811'/>", RemoveDoc, "");
	                    if (removeOk)
	                        RemoveDoc();
	                }
	            }
	        }
	
	        function btnAssign_onclick() {
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var oArrRows = DocList.GetSelectedRows();
	            var pCurSelRow = oArrRows[0];
	
	            if (pCurSelRow.length != 0)
	                OpenReceiveAssignUI(pCurSelRow);
	        }
	
	        function btnReceipt_onclick() {
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var pCurSelRow = DocList.GetSelectedRows();
	
	            if (pCurSelRow.length > 1) {
	                var pDocID = "", pURL = "";
	                MultiSelectedDocID = "<DOCIDS>";
	                for (var i = 0; i < pCurSelRow.length; i++) {
	                    var tr = pCurSelRow[i];
	
	                    if (GetAttribute(tr,"DATA9") == strDocState11) {
	                        MultiSelectedDocID = MultiSelectedDocID + "<DOCID>" + GetAttribute(tr,"DATA1") + "</DOCID>";
	
	                        if (pDocID == "" && pURL == "") {
	                            pDocID = GetAttribute(tr,"DATA1");
	                            pURL = GetAttribute(tr,"DATA3");
	                        }
	                    }
	                }
	                MultiSelectedDocID = MultiSelectedDocID + "</DOCIDS>";
	
	                if (MultiSelectedDocID == "<DOCIDS></DOCIDS>") {
	                    var pAlertContent = "<spring:message code='ezApproval.t813'/>";
	                    OpenAlertUI(pAlertContent);
	                    return;
	                }
	                OpenAllReceiveDraftUI(pDocID, pURL)
	            }
	            else if (pCurSelRow.length != 0) {
	                var tr = pCurSelRow[0];
	
	                if (pSusinManagerFlag == "admin" || trim_Cross(GetAttribute(tr,"DATA8")) == pUserID) {
	                    var pDraftFlag;
	                    var DATA9 = GetAttribute(tr,"DATA9");
	
	                    if (DATA9 == "A02011")
	                        pDraftFlag = "SUSIN";
	                    else if (DATA9 == strDocState2 || DATA9 == strDocState12)
	                        pDraftFlag = "HAPYUI";
	                    else if (DATA9 == strDocState3 || DATA9 == strDocState4)
	                        pDraftFlag = "GAMSA";
	                    else if (DATA9 == strDocState14)
	                        pDraftFlag = "GAMSABU";
	                    else if (DATA9 == strDocState17)
	                        pDraftFlag = "CHAMJO";
	                    OpenReceiveDraftUI(tr, pDraftFlag);
	                }
	                else {
	                    var pAlertContent = "<spring:message code='ezApproval.t814'/>";
	                        OpenAlertUI(pAlertContent);
	                    }
	                }
	        }
	        function btnDistribute_onclick() {
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var oArrRows = DocList.GetSelectedRows();
	            var pCurSelRow = oArrRows[0];
	
	            if (tr != null)
	                OpenReceiveDistributeUI(pCurSelRow);
	        }
	        function btnReturn_onclick() {
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var oArrRows = DocList.GetSelectedRows();
	
	            if (oArrRows != 0) {
	                var pCurSelRow = oArrRows[0];
	                OpenOpinionUI(pCurSelRow, "HeSong");
	            }
	        }
	
	        function btncallback_onclick(type) {
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var oArrRows = DocList.GetSelectedRows();
	            var pCurSelRow = oArrRows[0];
	
	            if (oArrRows.length > 0)
	                openViewDocInfo(type);
	            else {
	                var pAlertContent = "<spring:message code='ezApproval.t809'/><br> <spring:message code='ezApproval.t810'/>";
	                    OpenAlertUI(pAlertContent);
	                }
	        }
	        
	        function Recipent_onclick() {
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var oArrRows = DocList.GetSelectedRows();
	            if (oArrRows.length != 0) {
	                var tr = oArrRows[0];
	
	                if (pListTypeValue != "5")
	                    getAprDocAproveInfo(tr);
	                else
	                    getDataInfo("2")
	                setbuttonenable();
	            }
	        }
	        function Approval_onclick() {
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var oArrRows = DocList.GetSelectedRows();
	            if (oArrRows.length != 0) {
	                var tr = oArrRows[0];
	                if (pListTypeValue != "5")
	                    getAprLine(tr);
	                else
	                    getDataInfo("1");
	
	                setbuttonenable();
	            }
	        }
	        function Opinion_onclick() {
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var oArrRows = DocList.GetSelectedRows();
	            if (oArrRows.length != 0) {
	                var tr = oArrRows[0];
	                if (pListTypeValue != "5")
	                    getAprDocAproveInfo(tr);
	                else
	                    getDataInfo("4");
	                setbuttonenable();
	            }
	        }
	        function Attach_onclick() {
	
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var oArrRows = DocList.GetSelectedRows();
	
	            if (oArrRows.length != 0) {
	                var tr = oArrRows[0];
	                if (pListTypeValue != "5")
	                    getAprDocAproveInfo(tr);
	                else
	                    getDataInfo("3");
	                setbuttonenable();
	            }
	        }
	        function MM_swapImage(nSel) {
	            if (nSel != g_tagSelect) {
	                g_tagSelect = nSel;
	                var Element = window.event.srcElement;
	                Element.src = "/images/tab_ez0" + nSel + ".gif";
	                var i;
	                for (i = 1 ; i <= 4; i++) {
	                    if (g_tagSelect != i) {
	                        var str = "tag" + i + ".src" + "=" + "\"/images/tab_ez0" + i + "o.gif\"";
	                        eval(str);
	                    }
	                }
	                if (nSel != 6) {
	                    var str = "tag6.src" + "=" + "\"/images/tab_ez06o.gif\"";
	                    eval(str);
	                }
	            }
	        }
	        function MM_swapImagesub(nSel, e) {
	            if (nSel != g_tagSelectsub) {
	                g_tagSelectsub = nSel;
	                var Event = e ? e : window.event;
	                var Element = Event.target ? Event.target : Event.srcElement;
	                Element.src = "/images/tab_appsub" + nSel + ".gif";
	
	                var i;
	                for (i = 1 ; i <= 4; i++) {
	                    if (g_tagSelectsub != i) {
	                        var str = "tagsub" + i + ".src" + "=" + "\"/images/tab_appsub" + i + "a.gif\"";
	                        eval(str);
	                    }
	                }
	            }
	        }
	        function passValLeftMenu(strVal) {
	            pListTypeValue = strVal;
	            window.parent.frames["left"].pListTypeValue = strVal;
	        }
	
	        function btnAddJob_onclick() {
	            var parameter = "";
	            var url = "ezDocInfo/ezSubTitle_Cross.aspx?id=" + escape(pUserID);
	            var feature = "status:no;dialogWidth:440px;dialogHeight:300px;help:no;scroll:no;edge:sunken";
	            feature = feature + GetShowModalPosition(440, 300);
	            var RtnVal = window.showModalDialog(url, parameter, feature);
	            if (RtnVal[0] == "OK") {
	                arr_userinfo[4] = RtnVal[1];
	                arr_userinfo[5] = RtnVal[2];
	                arr_userinfo[3] = RtnVal[3];
	                arr_userinfo[13] = RtnVal[6];
	                arr_userinfo[14] = RtnVal[7];
	                arr_userinfo[15] = RtnVal[4];
	                arr_userinfo[16] = RtnVal[5];
	                DeptID = RtnVal[1];
	                ChangeCookies();
	                window.parent.frames["left"].document.location.href = "/myoffice/ezApproval/left_approval.aspx?listType=" + pListTypeValue;
	            }
	        }
	        window.onunload = function () {
	            try {
	                hideProgress();
	            } catch (e) { }
	        }
	        function goToPage(page, e) {
	            if (page == "front") {
	                if (parseInt(pageNum) - 1 < 1)
	                    return;
	                pageNum = pageNum - 1;
	                openergetDocInfo();
	            }
	            else if (page == "next") {
	                if (parseInt(pageNum) + 1 > parseInt(totalPages))
	                    return;
	                pageNum = pageNum + 1;
	                openergetDocInfo();
	            }
	            else if (page == "page") {
	                if (window.event) {
	                    if (Ex.keyCode != 13)
	                        return;
	                }
	                else {
	                    if (Ex.which != 13)
	                        return;
	                }
	
	                var goPage = trim_Cross(document.getElementById("txt_PageInputNum").value);
	
	                if (isNaN(goPage) || goPage == "")
	                    return;
	
	                if (parseInt(goPage) < 1 || parseInt(goPage) > parseInt(totalPages))
	                    return;
	                pageNum = parseInt(goPage);
	                openergetDocInfo();
	            }
	        }
	        var tempField = "";
	        function btnRegList_onclick() {
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var oArrRows = DocList.GetSelectedRows();
	            var tr = oArrRows[0];
	
	            if (tr != null) {
	                if (_USE_AdditionalROle == "YES") {
	                    var ret = CheckAprLineInfo(tr);
	
	                    if (ret != "OK") {
	                        var pAlertContent = "<spring:message code='ezApproval.t23'/><br>" +
	                                    "<spring:message code='ezApproval.t24'/>" + ret + "<spring:message code='ezApproval.t25'/>";
	                        OpenAlertUI(pAlertContent);
	                        return;
	                    }
	                }
	
	                if (pListTypeValue == "4") {
	                    var pInformationContent = "<spring:message code='ezApproval.t818'/>";
	                    tempField = "1";
	                    if (CrossYN())
	                        OpenInformationUI(pInformationContent, RemoveDocCabinet, "OPEN");
	                    else {
	                        if (OpenInformationUI(pInformationContent, RemoveDocCabinet, ""))
	                            RemoveDocCabinet();
	                    }
	                }
	                else if (pListTypeValue == "6") {
	                    var pInformationContent = "<spring:message code='ezApproval.t819'/>";
	                    tempField = "2";
	                    if (CrossYN())
	                        OpenInformationUI(pInformationContent, RemoveDocCabinet, "OPEN");
	                    else {
	                        if (OpenInformationUI(pInformationContent, RemoveDocCabinet, ""))
	                            RemoveDocCabinet();
	                    }
	                }
	                else {
	                    var pInformationContent = "<spring:message code='ezApproval.t820'/>";
	                    tempField = "0";
	                    if (CrossYN())
	                        OpenInformationUI(pInformationContent, RemoveDocCabinet, "OPEN");
	                    else {
	                        if (OpenInformationUI(pInformationContent, RemoveDocCabinet, ""))
	                            RemoveDocCabinet();
	                    }
	                }
	        }
	        else {
	            var pAlertContent = "<spring:message code='ezApproval.t821'/>";
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	        }
	        function GetBujaeFlag() {
	            var BString = arr_userinfo[7];
	            if (BString != "") {
	                var BDim = new Array("");
	                BDim = BString.split(":");
	
	                var tmpStartDate = TextReplace(BDim[3].substring(0, 16), "/", ":");
	                var tmpEndDate = TextReplace(BDim[4].substring(0, 16), "/", ":");
	
	                if (tmpStartDate <= "${nowDate}" && tmpEndDate >= "${nowDate}") {
	                    return true;
	                }
	            }
	            return false;
	        }
	        function setpause(numberMillis) {
	            var now = new Date();
	            var exitTime = now.getTime() + numberMillis;
	            while (true) {
	                now = new Date();
	                if (now.getTime() > exitTime)
	                    return;
	            }
	        }
	        function ALLapproval_afterCall() {
	            parent.frames["left"].getAprCount();
	            getDocList();
	        }
	        function ViewProgress() {
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var tr = DocList.GetSelectedRows();
	
	            if (tr.length == 0) {
	                OpenAlertUI("<spring:message code='ezApproval.t409'/>");
	            }
	            else {
	                pDocID = GetAttribute(tr[0],"DATA1");
	
	                document.getElementById("mailPanel").style.display = "";
	                document.getElementById("Div_mailImport").style.top = "50px";
	                if ((document.body.clientWidth / 2) - 350 > 0)
	                    document.getElementById("Div_mailImport").style.left = (document.body.clientWidth / 2) - 350 + "px";
	                else
	                    document.getElementById("Div_mailImport").style.left = "0px";
	                document.getElementById("Div_mailImport").style.display = "";
	                document.getElementById("progifrm").src = "/myoffice/ezprocdesigner/ProcUI_Progress.aspx?DocID=" + escape(pDocID) + "&DocHref=&CompID=${userInfo.companyID}";
	            }
	        }
	        function Hiddenimport(evt) {
	            document.getElementById("mailPanel").style.display = "none";
	            document.getElementById("Div_mailImport").style.display = "none";
	            document.getElementById("progifrm").src = "";
	        }
	        var ezStatisticsSearch_dialogArguments = new Array();
	        var OpenWin2;
	        function SearchCondi_onclick() {
	            var para;
	            var url;
	
	            if (pListTypeValue == "9")
	                url = "/myoffice/ezApproval/ezStatistics/ezStatisticsSearch.aspx?INGFLAG=APR2&Listtype=9";
	            else
	                url = "/myoffice/ezApproval/ezStatistics/ezStatisticsSearch.aspx?INGFLAG=APR2";
	
	            if (CrossYN()) {
	                ezStatisticsSearch_dialogArguments[1] = ezStatisticsSearch_Complete;
	                OpenWin2 = GetOpenWindow(url, "ezStatisticsSearch", 500, 340, "NO");
	                try { OpenWin2.focus(); } catch (e) { }
	            }
	            else {
	                var feature = "dialogWidth:500px;dialogHeight:340px;status:no;scroll:no;edge:sunken"
	                feature = feature + GetShowModalPosition(500, 340);
	                condition = window.showModalDialog(url, para, feature);
	                ezStatisticsSearch_Complete(condition);
	            }
	        }
	
	        function ezStatisticsSearch_Complete(condition) {
	            if (condition) {
	                pChackYN = "SEARCH";
	                pageNum = "1";
	                for (i = 0; i < 11; i++) {
	                    if (condition[i] == null)
	                        condition[i] = "";
	                    SearchCond[i] = condition[i];
	                }
	                if (pListTypeValue == "1") {
	                    MakeSubCondition();
	                    getDocList();
	                }
	                if (pListTypeValue == "2") {
	                    MakeSubCondition();
	                    getDocList();
	                }
	                else if (pListTypeValue == "3") {
	                    MakeSubCondition();
	                    getDocList();
	                }
	                else if (pListTypeValue == "4") {
	                    MakeSubCondition();
	                    getReceivedDocList();
	                }
	                else if (pListTypeValue == "7" || pListTypeValue == "6") {
	                    MakeSubCondition();
	                    getSimsaDocList();
	                }
	                else if (pListTypeValue == "9") {
	                    MakeSubCondition();
	                    getDocList();
	                }
	            }
	            $('#sel_year').val("ALL");
	            $('#sel_year').selectmenu('refresh');
	        }
	
	        function TotalSave_onclick() {
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var tr = DocList.GetSelectedRows();
	
	            if (tr.length == 0) {
	                OpenAlertUI("<spring:message code='ezApproval.t581'/>");
	                return;
	            }
	            else
	                pDocID = GetAttribute(tr[0],"DATA1");
	
	
	            var type = "APR";
	            if (pListTypeValue == 6)
	                type = "SIM";
	
	            var url = "TotalSaveFileInfo.aspx?docid=" + pDocID + "&type=" + type;
	            var result = GetOpenWindow(url, "", 600, 450, "NO");
	        }
	
	        window.onresize = function () {
	            var height = parseInt(divList.style.height.replace('px', '')) + 200;
	            var reheight = document.documentElement.clientHeight - parseInt(height);
	            if (reheight > 0)
	                document.getElementById('div_AprLine').style.height = reheight + "px";
	        };
	
	        var ezapralert_cross_dialogArgument = new Array();
	        function OpenAlertUI(pAlertContent) {
	            var parameter = pAlertContent;
	            var url = "";
	            url = "/myoffice/ezApproval/ezAPRALERT_Cross.aspx?type=OPEN";
	
	            if (CrossYN() || pNoneActiveX == "YES") {
	                ezapralert_cross_dialogArgument[0] = parameter;
	                ezapralert_cross_dialogArgument[1] = "OPEN";
	                var OpenWin = GetOpenWindow(url, "", 330, 205, "NO");
	            }
	            else {
	                var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	                feature = feature + GetShowModalPosition(330, 205);
	                var RtnVal = window.showModalDialog(url, parameter, feature);
	            }
	        }
	
	        function onkeydown_start_search() {
	            if (window.event.keyCode == "13") {
	                search();
	            }
	        }
	
	        function keyword_Clear() {
	            document.getElementById('txt_keyword').value = "";
	        }
	
	        function search() {
	            pChackYN = "SEARCH";
	            if (document.getElementById("txt_keyword").value != "") {
	                var radiosearch = document.getElementsByName('searchCheck');
	
	                for (i = 0; i < 11; i++)
	                    SearchCond[i] = "";
	
	                if (radiosearch.item(0).checked) {
	                    SearchCond[1] = document.getElementById("txt_keyword").value;
	                }
	                else if (radiosearch.item(1).checked) {
	                    SearchCond[2] = document.getElementById("txt_keyword").value;
	                }
	            }
	            else {
	                alert(strLang554);
	                return;
	            }
	            pageNum = 1;
	            if (pListTypeValue == "1") {
	                MakeSubCondition();
	                getDocList();
	            }
	            if (pListTypeValue == "2") {
	                MakeSubCondition();
	                getDocList();
	            }
	            else if (pListTypeValue == "3") {
	                MakeSubCondition();
	                getDocList();
	            }
	            else if (pListTypeValue == "4") {
	                MakeSubCondition();
	                getReceivedDocList();
	            }
	            else if (pListTypeValue == "7" || pListTypeValue == "6") {
	                MakeSubCondition();
	                getSimsaDocList();
	            }
	            else if (pListTypeValue == "9") {
	                MakeSubCondition();
	                getDocList();
	            }
	            $('#sel_year').val("ALL");
	            $('#sel_year').selectmenu('refresh');
	        }
	    </script>  
	</head>
	<body class="mainbody" style="BEHAVIOR: url('#default#userData'); overflow:hidden">
	    <table style="border: 0; border-collapse: collapse; border-spacing: 0; padding: 0px; width: 100%">
	        <tr>
	            <td>
	                <h1>
	                    <spring:message code='ezApproval.t824'/><span class="mtitle_sub" id="presentcell" style="color: #666; font-weight: normal;"></span><span id="mailBoxInfo"></span>                  
	                    <span style="float:right;font-weight:normal;color:black;">
	                      <input name="searchCheck" id="Radio1" type="radio" value="rad_Subject" checked style="margin:0px;padding:0px;width:13px;height:13px; "><spring:message code='ezApproval.t911'/>
			              <input name="searchCheck" id="Radio2" type="radio" value="rad_Writer" style="margin:0px;padding:0px;width:13px;height:13px; "><spring:message code='ezApproval.t436'/>
			              &nbsp;
			              <input id="txt_keyword" style="width:150px;" onkeypress="onkeydown_start_search();" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
	                      <a href="#"><img src="/images/sub/bsearch.gif" border="0" style="vertical-align:middle" onClick="search()"></a>
	                    </span>
	                </h1>                 
	                <div id="mainmenu">
	                    <ul>
	                        <li id="tbtnDraft"><span id="btnDraft" onclick="return btnDraft_onclick()"><spring:message code='ezApproval.t86'/></span></li>
	                        <li id="tbtnRedraft"><span id="btnRedraft" onclick="return btnRedraft_onclick()"><spring:message code='ezApproval.t825'/></span></li>
	                        <li id="tbar1" style="background: none; padding-right: 2px;">
	                        <img src="/images/i_bar.gif"></li>
	                        <li id="tbtnApprove"><span id="btnApprove" onclick="return  btnApprove_onclick()"><spring:message code='ezApproval.t1'/></span></li>
	                        <c:if test="${useMobile != 'YES'}">
		                        <li id="tbtnApproveALL" style="DISPLAY:none"><span id="btnApproveALL" onclick="return  btnApproveALL_onclick()"><spring:message code='ezApproval.t940'/></span></li>
	                        </c:if>
	                        <c:if test="${useMobile == 'YES'}">
		                        <li id="tbtnApproveALL"><span id="btnApproveALL" onclick="return  btnApproveALL_onclick()"><spring:message code='ezApproval.t940'/></span></li>
	                        </c:if>
	                        <li id="tbtnReceipt"><span id="btnReceipt" onclick="return btnReceipt_onclick()"><spring:message code='ezApproval.t404'/></span></li>
	                        <li id="tbtnSimsa" style="DISPLAY: none"><span id="btnSimsa" onclick="return btnSimsa_onclick()"><spring:message code='ezApproval.t176'/></span></li>
	                        <li id="tbtnReturn"><span id="btnReturn" onclick="return btnReturn_onclick()"><spring:message code='ezApproval.t497'/></span></li>
	                        <li id="tbtncallback" style="display:none"><span id="btncallback" onclick="return btncallback_onclick('CALLBACK')"><spring:message code='ezApproval.t826'/></span></li>
	                        <li id="tbtnforcecallback" style="display:none"><span id="btnforcecallback" onclick="return btncallback_onclick('FORCECALLBACK')"><spring:message code='ezApproval.t2005'/></span></li>
	                        <li id="tbtnRegList"><span id="btnRegList" onclick="return btnRegList_onclick()"><spring:message code='ezApproval.t827'/></span></li>
	                        <li id="tbar2" style="background: none; padding-right: 2px;">
	                        <img src="/images/i_bar.gif"></li>
	                        <li id="tbtnRemoveDoc"><span id="btnRemoveDoc" onclick="return btnRemoveDoc_onclick()"><spring:message code='ezApproval.t194'/></span></li>
	                        <li id="tbtnViewDoc"><span id="btnViewDoc" onclick="return btnViewDoc_onclick()"><spring:message code='ezApproval.t237'/></span></li>
	                        <li id="tbtnUserInfo" style="DISPLAY: none"><span id="btnUserInfo" onclick="return btnUserInfo_onclick()"><spring:message code='ezApproval.t828'/></span></li>                        
	                        <li id="tbPreView" style="DISPLAY: none"><span onclick="prevShow_onclick()"><spring:message code='ezApproval.t350'/></span></li>
	                        <li id="SearchCondi"><span onclick="return SearchCondi_onclick()"><spring:message code='ezApproval.t236'/></span></li>
	                        <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApproval.t00008'/></span></li>                                               
	                        <li id="Li1" style="background: none; padding-right: 2px;">
	                        <img src="/images/i_bar.gif"></li>
	                        <select id="sel_year" name="sel_year" style="width:92px;" onchange="onSelect_Year(this);">    
	                            <option value="ALL"><spring:message code='ezApproval.t00013'/></option>
	                        </select>     
	                    </ul>       
	                           
	                </div>                
	                <div class="div_scroll" style="width: 100%; HEIGHT: 310px; overflow: AUTO" id="divList">
	                    <div id="lvDocList"></div>
	                </div>
	                <div id="tblPageRayer" style="margin-bottom: 10px;"></div>
	            </td>
	        </tr>
	        <tr id="tb_PrevShow" style="DISPLAY: none;">
	            <td style="padding-bottom: 35px">
	                <table style="border: 1px solid #B5B5B5; OVERFLOW-Y: auto; width: 100%; height: 40px; TABLE-LAYOUT: fixed; background-color: #e4e4e4; border: 0; border-collapse: collapse; border-spacing: 0; padding: 0px;" id="title_preview" onselectstart="event.cancelBubble = true, event.returnValue = false;">
	                    <tr>
	                        <td class='ta' id="td_Attachment" style="PADDING-LEFT: 10px; PADDING-TOP: 4px; width: 80px; vertical-align: top;"><spring:message code='ezApproval.t64'/>	:</td>
	                        <td class='ta' style="OVERFLOW: hidden; PADDING-TOP: 4px; width: 400px; vertical-align: top; text-align: left;"><span style="OVERFLOW-Y: auto; WIDTH: 98%; HEIGHT: 30px" id="div_Attachment" onmousedown="event.cancelBubble=true"></span></td>
	                        <td class='ta' id="value_3" style="PADDING-LEFT: 10px; PADDING-TOP: 4px; vertical-align: top; width: 80px;"><spring:message code='ezApproval.t63'/> :</td>
	                        <td class='ta' id="td_Opinion" style="PADDING-TOP: 4px; vertical-align: top;"><span style="OVERFLOW: hidden; HEIGHT: 25px" id="div_Opinion"></span></td>
	                    </tr>
	                </table>
	                <div style="OVERFLOW-Y: auto; WIDTH: 100%; HEIGHT: 100%;" id="div_PreView" onselectstart="event.cancelBubble=true;event.returnValue=true">
	                    <iframe id="Content" style="background-color: White; height: 1px; width: 1px;"></iframe>
	                </div>
	            </td>
	        </tr>
	    </table>
	    <div id="ViewInfo"></div>
	    <div id="tabnav" style="width: 100%">
	        <ul>
	            <li id="tagsub1"><span onclick="pDocInfoValue='1';MM_swapImagesub('1', event);Approval_onclick()"><spring:message code='ezApproval.t60'/></span></li>
	            <li id="tagsub2"><span onclick="pDocInfoValue='2';MM_swapImagesub('2', event);Recipent_onclick()"><spring:message code='ezApproval.t418'/></span></li>
	            <li id="tagsub3"><span onclick="pDocInfoValue='4'; MM_swapImagesub('3', event);Attach_onclick()"><spring:message code='ezApproval.t64'/></span></li>
	            <li id="tagsub4"><span onclick="pDocInfoValue='3'; MM_swapImagesub('4', event);Opinion_onclick()"><spring:message code='ezApproval.t63'/></span></li>
	        </ul>
	    </div>
	
	    <div style="WIDTH: 100%; HEIGHT: 320px; font-size: 92%; OVERFLOW-Y: AUTO;" id="div_AprLine">
	        <div id="lvAprLine"></div>
	    </div>
	    <div style="border: 2px solid gray; width: 600px; height: 500px; display: none; position: absolute; background-color: #ffffff; z-index: 8000; margin: 0 auto" id="Div_mailImport">
	        <iframe id="progifrm" style="width: 600px; height: 500px;" frameborder="0"></iframe>
	    </div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="mailPanel" onclick="Hiddenimport();"></div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	        selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
	    </script>
	    <iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
	    <iframe id="ifrm" name="ifrm" src="about:blank" style="display: none"></iframe>
	    <form id="formAPP">
	        <input type="hidden" id="APPXML" name="APPXML" />
	    </form>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="Div1">&nbsp;</div>	
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	    <iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>