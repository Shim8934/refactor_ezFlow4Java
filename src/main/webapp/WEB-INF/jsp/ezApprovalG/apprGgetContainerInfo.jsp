<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t1515'/></title>
	    <style>
	        .IMG_BTN {
	            behavior: url("/css/include/ImgBtn.htc");
	        }
	
	        .pagetd {
	            padding-top: 6px;
	        }
	
	        .pcol {
	            padding-top: 6px;
	        }
	
	        .Right_Point01 {
	            font: bold;
	            color: #017bec;
	        }
	    </style>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/getContainerInfo_Cross.js"></script>
	    <script type="text/javascript" src="/js/Common.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-ui.js"></script>
	    <link rel="stylesheet" href="/js/jquery/jquery-ui.css">
	    <link rel="stylesheet" href="/js/jquery/jquery-ui.min.css"> 
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var labelcolor = "gray";
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var ContainerID, UserID, DocID, DeptID, jobState, pURL, subCondition;
	        var condition = new Array("");
	        var g_tagSelectsub = "1";
	        var NodeList, curpage, nowblock, totalPage, block, p_page, p_nowblock, NodeListLen, Init_Flag, pChackYN, DocListType;
	        var NodeList2, PageSize, ListView;
	        var contFlag = "${contType}";
	        var pSusinManagerFlag = "user";
	        var UserID = "${userInfo.id}";
	        var Block_Size, WriterID;
	        var docdir = "";
	        var OrderOption = "";
	        var OrderCell = "";
	        var pEndDocHref = '${dirPath}';
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user";
	        arr_userinfo[1] = "${userInfo.id}";
	        arr_userinfo[2] = "${userInfo.displayName1}";
	        arr_userinfo[3] = "${userInfo.title1}";
	        arr_userinfo[4] = "${userInfo.deptID}";
	        arr_userinfo[5] = "${userInfo.deptName1}";
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
	        var LoadContID = "${contID}";
	        var LoadSquery = "${sQuery}";
	        var GamSaFlag = false;
	        var CompanyID = "${userInfo.companyID}";
	        var USE_OCS = "${useOcs}";
	        var Udomain = "${userEmail}";
	        var pOpenYaer = "${openYear}";
	        var NonActiveX = "YES";
	
	        var CurrentHeight = 0;
	        var CurrentWidth = 0;
	
	        document.onselectstart = function () { return false; };
	
	        $(function () {
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
	
	        window.onload = function () {
	            //var height = parseInt(divList.style.height.replace('px', '')) + 200;
	            //var reheight = window.innerHeight - parseInt(height);
	            CurrentHeight = document.documentElement.clientHeight;//document.body.clientHeight;
	            CurrenWidth = document.documentElement.clientWidth;//document.body.clientWidth;
	            var height = parseInt(divList.style.height.replace('px', '')) + 200;
	            var reheight = document.documentElement.offsetHeight - parseInt(height);
	
	            document.getElementById('div_AprLine').style.height = reheight + "px";
	
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	
	            var toDay = new Date();
	            var toDayYear = parseInt(toDay.getFullYear());
	            var minusYear = parseInt(toDay.getFullYear()) - parseInt(pOpenYaer);
	            for (var i = toDayYear; i >= toDayYear - minusYear ; i--)
	                AddOption(sel_year, i, i);
	
	            try {
	                if ("${type}" == "1")
	                    GamSaFlag = true;
	
	                PageSize = 10;
	                Block_Size = 10;
	
	                pChackYN = "FALSE";
	
	                if (arr_userinfo[10] == "YES" || arr_userinfo[10] == "Y")
	                    pSusinManagerFlag = "admin";
	                else
	                    pSusinManagerFlag = "user";
	
	                DeptID = arr_userinfo[4];
	                jobState = "APPROVAL";
	
	                var nowyear = new Date().getFullYear();
	                var nowmonth = new Date().getMonth() + 1;
	                var nowday = new Date().getDate();
	
	                if (nowmonth < 10)
	                    nowmonth = "0" + nowmonth;
	
	                if (nowday < 10)
	                    nowday = "0" + nowday;
	
	                for (var i = 0; i < 25; i++) {
	                    condition[i] = "";
	                }
	
	                condition[9] = nowyear - 1;
	                condition[10] = nowmonth;
	                condition[11] = nowday;
	                condition[12] = nowyear;
	                condition[13] = nowmonth;
	                condition[14] = nowday;
	                condition[24] = "";
	                DocListType == "GetDocSearch";

	                if (LoadSquery == "usercontlist") {
	                    ContainerID = LoadContID;
	                    subCondition = "";
	                    GetUserContList();
	                }
	                if (LoadSquery == "deptcontlist") {
	                    ContainerID = LoadContID;
	                    subCondition = "";
	                    GetDeptContList();
	                }
	                if (LoadSquery == "aprlist") {
	                    ContainerID = "";
	                    subCondition = LoadContID;
	                    GetDocList();
	                }
	                else if (LoadContID == "GAMSAHAM") {
	                    GamSaFlag = true;
	                    ContainerID = "";
	                    subCondition = LoadSquery;
	                    GetDocList();
	                }
	                else if (LoadSquery != "") {
	                    for (i = 0; i < 25; i++) {
	                        condition[i] = "";
	                    }
	                    ContainerID = LoadContID;
	                    subCondition = "TBEXPENDAPRDOCINFO.itemcode = '" + LoadSquery + "'";
	                    pChackYN = "FALSE";
	                    Init_Flag = "False";
	                    GetDocSearch();
	                }
	                else {
	                    ContainerID = LoadContID;
	                    subCondition = "";
	                    GetDocSearch();
	                }
	
	                try {
	                    parent.frames["left"].setPresentValue("");
	                } catch (e) { }
	
	            } catch (e) {
	            }
	        };
	
	        var SelYearFlag = false;
	        function onSelect_Year() {
	            SelYearFlag = true;
	            if (GetSelectVal("sel_year") != "ALL") {
	                condition[9] = GetSelectVal("sel_year");
	                condition[10] = "01";
	                condition[11] = "01";
	                condition[12] = GetSelectVal("sel_year");
	                condition[13] = "12";
	                condition[14] = "31";
	                condition[24] = "";
	                DocListType == "GetDocSearch";
	                GetDocSearch();
	            }
	            else {
	                var nowyear = new Date().getFullYear();
	                var nowmonth = new Date().getMonth() + 1;
	                var nowday = new Date().getDate();
	
	                if (nowmonth < 10)
	                    nowmonth = "0" + nowmonth;
	
	                if (nowday < 10)
	                    nowday = "0" + nowday;
	
	                condition[9] = nowyear - 1;
	                condition[10] = nowmonth;
	                condition[11] = nowday;
	                condition[12] = nowyear;
	                condition[13] = nowmonth;
	                condition[14] = nowday;
	                condition[24] = "";
	                DocListType == "GetDocSearch";
	                GetDocSearch();
	            }
	        }
	
	    function lvtDetail_SelChange() { }
	    function SelCont_onclick() {
	        var i;
	        var para;
	        var url = "selectContainer_Cross.aspx";
	        var feature = "dialogWidth:550px;dialogHeight:354px;status:no;scroll:no;help:no;edge:sunken";
	        feature = feature + GetShowModalPosition(550, 354);
	        var retVal = window.showModalDialog(url, para, feature);
	
	        ContainerID = "";
	        Init_Flag = "False";
	
	        for (i = 0; i < retVal.length - 1; i++) {
	            if (retVal[i]) {
	                ContainerID = ContainerID + "'" + retVal[i] + "',";
	            }
	        }
	
	        ContainerID = ContainerID + "'" + retVal[i] + "'";
	        subCondition = "";
	        if (ContainerID != "'undefined'") {
	            document.getElementById("presentcell").innerHTML = " - " + "<spring:message code='ezApprovalG.t1516'/>";
	            GetDocList();
	        }
	    }
	    function SelCont_onclick2(cont, ContainerName) {
	        if (ContainerName == "<spring:message code='ezApprovalG.t1517'/>") {
	            GamSaFlag = true;
// 	            cont = "";
	        }
	        else {
	            GamSaFlag = false;
	        }
	
	        document.getElementById("presentcell").innerHTML = " - " + ContainerName;
	
	        ContainerID = cont;
	        subCondition = "";
	
	        for (var i = 0; i < 25; i++) {
	            condition[i] = "";
	        }
	
	        var nowyear = new Date().getFullYear();
	        var nowmonth = new Date().getMonth() + 1;
	        var nowday = new Date().getDate();
	
	        if (nowmonth < 10)
	            nowmonth = "0" + nowmonth;
	
	        if (nowday < 10)
	            nowday = "0" + nowday;
	
	        condition[9] = nowyear - 1;
	        condition[10] = nowmonth;
	        condition[11] = nowday;
	        condition[12] = nowyear;
	        condition[13] = nowmonth;
	        condition[14] = nowday;
	        condition[24] = "";
	        DocListType == "GetDocSearch";
	        GetDocSearch();
	    }
	    function SelCont_onclick3(cont, Containers, ContainerName) {
	        var i;
	        document.getElementById("presentcell").innerHTML = " - " + ContainerName;
	
	        for (i = 0; i < 25; i++) {
	            condition[i] = "";
	        }
	        ContainerID = Containers;
	        subCondition = "TBEXPENDAPRDOCINFO.itemcode = '" + cont + "'";
	        pChackYN = "FALSE";
	        Init_Flag = "False";
	        GetDocSearch();
	    }
	    var g_progresswin = null;
	    function showProgress() {
	    }
	
	    function hideProgress() {
	    }
	    var setsearchinfo_cross_dialogArguments = new Array();
	    var OpenWin2;
	    function SearchCondi_onclick() {
	        var para;
	        setsearchinfo_cross_dialogArguments[0] = para;
	        setsearchinfo_cross_dialogArguments[1] = SearchCondi_onclick_Complete;
	
	        OpenWin2 = window.open("/ezApprovalG/setSearchInfo.do", "setsearchInfo_Cross", GetOpenWindowfeature(510, 350));
	        try { OpenWin2.focus(); } catch (e) { }
	    }
	
	    function SearchCondi_onclick_Complete(returnvalue) {
	        condition = returnvalue;
	        if (condition) {
	            Init_Flag = "False";
	            GetDocSearch();
	        }
	        $('#sel_year').val("ALL");
	        $('#sel_year').selectmenu('refresh');
	    }
	    function lvtDoclist_onclick() {
	    }
	
	    function lvtDoclist_onSel_DBclick() {
	        ViewDoc_onclick();
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
	
	        pChackYN = "TRUE";
	        if (DocListType == "DocList")
	            GetDocList();
	        else if (DocListType == "GetDocSearch")
	            GetDocSearch();
	        else
	            GetDocList();
	    }
	    function lvtDetail_onclick() {
	    }
	    function lvtDetail_onSel_DBclick() {
	        var DocList = new ListView();
	        DocList.LoadFromID("SubDocList");
	        var selRow = DocList.GetSelectedRows();
	        var tr = selRow[0];
	        if (tr != null && typeof (selRow.length) != "undefined" && selRow.length > 0) {
	            if (jobState == "APPROVAL") {
	                if (tr.getAttribute("DATA5") == "Y") {
	                    var heigth = window.screen.availHeight;
	                    var width = window.screen.availWidth;
	                    var left = (parseInt(width) - 525) / 2;
	                    var top = (parseInt(heigth) - 220) / 2;
	                    window.open("/ezApprovalG/ezLineInfo.do?docID=" + tr.getAttribute("DATA3") + "&deptID=" + encodeURI(tr.getAttribute("DATA4")) + "&docState=012", "", "height=270px,width=525px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	                }
	                else
	                    window.open("/ezCommon/showPersonInfo.do?id=" + tr.getAttribute("DATA4"), "", "height=450px,width=600px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
	            }
	            else if (jobState == "RECIPENT") {
	
	                var heigth = window.screen.availHeight;
	                var width = window.screen.availWidth;
	                var left = (parseInt(width) - 540) / 2;
	                var top = (parseInt(heigth) - 220) / 2;
	
	                var isExtYN = tr.getAttribute("DATA3");
	                if (isExtYN.toUpperCase() == "Y") {
	                    var url = "/ezApprovalG/ezReceiptHistoryInfo.do?docID=" + DocID + "&deptID=" + encodeURI(tr.getAttribute("DATA1"));
	                    var feature = "status:no;dialogWidth:555px;dialogHeight:240px;help:no;scroll:no;edge:sunken";
	                    feature = feature + GetShowModalPosition(555, 240);
	                    var ret = window.showModalDialog(url, "", feature);
	                }
	                else {
	                    window.open("/ezApprovalG/ezLineInfo.do?docID=" + DocID + "&deptID=" + escape(tr.getAttribute("DATA1")) + "&docState=011", "", "height=270px,width=600px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	                }
	            }
	        }
	    }
	    //START
	    function ViewDoc_onclick() {
	        var DocList = new ListView();
	        DocList.LoadFromID("DocList");
	        var selRow = DocList.GetSelectedRows();
	        var tr = selRow[0];
	        pURL = tr.getAttribute("DATA2");
	
	        var para = new Array();
	        para[0] = DocID;
	        para[1] = pURL;
	
	        if (tr.getAttribute("DATA10") != "" && tr.getAttribute("DATA10") >= GetTodayDate()) {
	            if (CheckAprLine(tr.getAttribute("DATA1")) == "TRUE") {
	                if ("${approvalPWD}" != "N") {
	                    chk_Passwd(UserID);
	                }
	                else {
	                    chk_Passwd_Complete("TRUE");
	                }
	            }
	            else {
	                OpenAlertUI("<spring:message code='ezApprovalG.t1518'/>");
	                return "";
	            }
	        }
	        else {
	            chk_Passwd_Complete("TRUE");
	        }
	    }
	
	    function chk_Passwd_Complete(Rtn)
	    {
	        if (Rtn == "False") {
	            var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
	            OpenAlertUI(pAlertContent);
	            return "";
	        }
	        else if (Rtn == "cancel") {
	            var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
	            OpenAlertUI(pAlertContent);
	            return "";
	        }
	        else {
	            var DocList = new ListView();
	            DocList.LoadFromID("DocList");
	            var selRow = DocList.GetSelectedRows();
	            var tr = selRow[0];
	            pURL = tr.getAttribute("DATA2");
	
	            var formid = tr.getAttribute("DATA6");
	            var orgdocid = trim_Cross(tr.getAttribute("DATA5"));
	            var openLocation;
	            if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
	                openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezViewEnd_HWP_Cross.aspx";
	            }
	            else {
	                if (CrossYN() || NonActiveX == "YES")
	                    openLocation = "/ezApprovalG/contDocView.do";
	                else {
	                    if (pUse_Editor == "")
	                        openLocation = "/myoffice/ezApprovalG/formContainer/contDocView.aspx";
	                    else
	                        openLocation = "/myoffice/ezApprovalG/formContainer/contDocView_IE.aspx";
	                }                
	            }
	            openLocation = openLocation + "?docID=" + encodeURI(DocID) + "&docHref=" + encodeURI(pURL) + "&formID=" + encodeURI(formid) + "&orgDocID=" + encodeURI(orgdocid);
	            openwindow(openLocation, "", 880, 570);
	        }
	    }
	    //END
	
	        function enforce_onclick() {
	            var heigth = window.screen.availHeight;
	            var width = window.screen.availWidth;
	
	            var heigth = heigth - 10;
	            var width = width - 10;
	
	            var para = new Array();
	            para[0] = DocID;
	            para[1] = pURL;
	
	            var left = 0;
	            var top = 0;
	            var openLocation = "";
	            if (UserID.toLowerCase() != WriterID.toLowerCase()) {
	                var InformationString = "<spring:message code='ezApprovalG.t1519'/>";
	                OpenAlertUI(InformationString);
	                return;
	            }
	
	            if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
	                if ("${userInfoEnforce}" == "1") {
	                    openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezEnforce_HWP_Cross.aspx";
	                }
	                else if ("${userInfoEnforce}" == "2") {
	                    openLocation = "../ezViewHWP/ezConv_HWP_Cross.aspx";
	                }
	                else {
	                    openLocation = "../ezViewHWP/ezConvSend_HWP_Cross.aspx";
	                }
	            }
	            else {
	                if ("${userInfoEnforce}" == "1") {                    
	                    if (CrossYN() || NonActiveX == "YES")
	                        openLocation = "../enforce/convEnforce_CK.aspx";
	                    else
	                    {
	                        openLocation = "../enforce/convEnforce.aspx";
	                    }
	                }
	                else if ("${userInfoEnforce}" == "2") {
	                    openLocation = "../enforce/ezConv.aspx";
	                    if (CrossYN() || NonActiveX == "YES") {
	                        openLocation = "../enforce/ezConv_CK.aspx";
	                    }
	                }
	                else {
	                    openLocation = "../enforce/ezConvSend.aspx";
	                    if (CrossYN() || NonActiveX == "YES") {
	                        openLocation = "../enforce/ezConvSend_Cross.aspx";
	                    }
	                }
	            }
	            openLocation = openLocation + "?DocID=" + escape(DocID) + "&DocHref=" + escape(pURL) + "&ListSusin=";
	            var param = "status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left;
	            window.open(openLocation, "enforce", param);
	        }
	function Approval_onclick() {
	    jobState = "APPROVAL";
	    getDataInfo();
	}
	function Attach_onclick() {
	    jobState = "ATTACH";
	    getDataInfo();
	}
	function Recipent_onclick() {
	    jobState = "RECIPENT";
	    getDataInfo();
	}
	function Opinion_onclick() {
	    jobState = "OPINION";
	    getDataInfo();
	}
	function help_onclick() {
	    CallHelp("<spring:message code='ezApprovalG.t904'/>");
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
	    function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
	        try {
	            var heigth = window.screen.availHeight;
	            var width = window.screen.availWidth;
	
	            var left = 0;
	            var top = 0;
	
	            if (window.screen.width > 800) {
	                var pleftpos;
	
	                pleftpos = parseInt(width) - 967;
	                heigth = parseInt(heigth) - 30;
	                width = parseInt(width) - pleftpos;
	                left = pleftpos / 2;
	            }
	            else {
	                heigth = parseInt(heigth) - 30;
	                width = parseInt(width) - 10;
	            }
	
	            window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
	        }
	        catch (e) {
	            alert("openwindow :: " + e.description);
	        }
	    }
	    function onchange_objSelForm(p_strVal) {
	        GetDocList(p_strVal);
	    }
	    function btnExcel_onclick(AllFG) {
	        var url;
	        if (typeof (ContainerID) == "undefined")
	            ContainerID = "";
	
	        if (typeof (subCondition) == "undefined")
	            subCondition = "";
	
	        var tempPageSize = "65530";
	        var tempPageNum = "1";
	        if (AllFG != 1) {
	            tempPageSize = PageSize;
	            tempPageNum = curpage;
	        }
	
	        if (GamSaFlag)
	            url = "../excelExportOutGS.aspx";
	        else
	            url = "/ezApprovalG/excelExportOut.do";
	
	        if (DocListType == "DocList") {
	            url += "?listType=DOC&cont=" + encodeURI(ContainerID) + "&PN=" +
	                encodeURI(tempPageNum) + "&PS=" + encodeURI(tempPageSize) + "&OC=" + encodeURI(OrderCell) +
	                "&OO=" + encodeURI(OrderOption);
	        }
	        else {
	            url += "?listType=SEARCH&P0=" + encodeURI(condition[0]) + "&P1=" +
	                encodeURI(condition[1]) + "&P2=" + encodeURI(condition[2]) + "&P3=" + encodeURI(condition[3]) +
	                "&P4=" + encodeURI(condition[4]) + "&P5=" + encodeURI(condition[5]) + "&P6=" + encodeURI(condition[6]) +
	                "&P7=" + encodeURI(condition[7]) + "&P8=" + encodeURI(condition[8]) + "&P9=" + encodeURI(condition[9]) +
	                "&P10=" + encodeURI(condition[10]) + "&P11=" + encodeURI(condition[11]) + "&P12=" + encodeURI(condition[12]) +
	                "&P13=" + encodeURI(condition[13]) + "&P14=" + encodeURI(condition[14]) + "&P15=" + encodeURI(condition[15]) +
	                "&P16=" + encodeURI(condition[16]) + "&P17=" + encodeURI(condition[17]) + "&P18=" + encodeURI(condition[18]) +
	                "&P19=" + encodeURI(condition[19]) + "&P20=" + encodeURI(condition[20]) + "&P21=" + encodeURI(condition[21]) +
	                "&P22=" + encodeURI(condition[22]) + "&P23=" + encodeURI(condition[23]) + "&P24=" + encodeURI(ContainerID) +
	                "&PN=" + encodeURI(tempPageNum) + "&PS=" + encodeURI(tempPageSize) + "&OC=" + encodeURI(OrderCell) +
	                "&OO=" + encodeURI(OrderOption) + "&SQ=" + encodeURI(subCondition);
	        }
	        window.frames["saveExcel"].location.href = url;
	    }
	    function SelEDMFolder_onclick() {
	        var DocList = new ListView();
	        DocList.LoadFromID("DocList");
	        var selRow = DocList.GetSelectedRows();
	
	        if (selRow.length <= 0) {
	            var InformationString = "<spring:message code='ezApprovalG.t1520'/>";
	            OpenAlertUI(InformationString);
	            return;
	        }
	        var param = new Array();
	        param[0] = "";
	        var url = "/myoffice/ezApprovalG/ezDMSConnector/SelectFolder.aspx";
	        var feature = "dialogWidth:365px;dialogHeight:450px;status:no; scroll:no; help:no;edge:sunken";
	        feature = feature + GetShowModalPosition(365, 450);
	        var rtn = window.showModalDialog(url, param, feature);
	
	        if (rtn[0] == "OK") {
	            var xmlhttp = createXMLHttpRequest();
	            var xmlpara = createXmlDom();
	
	            var objNode, objRoot, objDocid;
	            objRoot = createNodeInsert(xmlpara, objRoot, "DATA");
	            createNodeAndInsertText(xmlpara, objNode, "DESTFOLD", rtn[1]);
	            var list = createNodeAndAppandNode(xmlpara, objRoot, list, "DOCIDS");
	
	            for (var i = 0; i < selRow.length; i++) {
	                var tr = selRow[i];
	
	                createNodeAndAppandNodeText(xmlpara, list, objDocid, "DOCID", tr.getAttribute("DATA1"));
	            }
	            xmlhttp.open("POST", "aspx/getEDMxmlForDoc.aspx", false);
	            xmlhttp.send(xmlpara);
	
	            var xmlhttp2 = createXMLHttpRequest();
	            xmlhttp2.open("POST", "/myoffice/ezApprovalG/ezDMSConnector/aspx/SendDocDataToEDM.aspx", false);
	            xmlhttp2.send(xmlhttp.responseXML);
	
	            if (xmlhttp2.responseText == "TRUE") {
	                var xmlhttp3 = createXMLHttpRequest();
	                xmlhttp3.open("POST", "aspx/setEDMSYN.aspx", false);
	                xmlhttp3.send(xmlpara);
	
	                if (xmlhttp3.responseText == "TRUE") {
	                    var InformationString = "EDMS " + "<spring:message code='ezApprovalG.t1521'/>";
	                    OpenAlertUI(InformationString);
	
	                    if (DocListType == "DocList")
	                        GetDocList();
	                    else if (DocListType == "GetDocSearch")
	                        GetDocSearch();
	
	                    return;
	                }
	                else {
	                    var InformationString = "EDMS " + "<spring:message code='ezApprovalG.t1522'/>";
	                    OpenAlertUI(InformationString);
	                    return;
	                }
	            }
	            else {
	                var InformationString = "EDMS " + "<spring:message code='ezApprovalG.t1523'/>";
	                OpenAlertUI(InformationString);
	                return;
	            }
	        }
	    }
	    function btnAddJob_onclick() {
	        var parameter = "";
	        var url = "../ezDocInfo/ezSubTitle_Cross.aspx?id=" + escape(UserID);
	        var feature = "status:no;dialogWidth:280px;dialogHeight:259px;help:no;scroll:no;edge:sunken";
	        feature = feature + GetShowModalPosition(280, 259);
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
	            window.parent.frames.left.document.location.href = "/myoffice/ezApprovalG/left_approval_Cross.aspx?listType=1";
	        }
	    }
	    function ChangeCookies() {
            $.ajax({
        		type : "POST",
        		async : false,
        		url : "/ezApprovalG/ChangeUserInfo.do",
        		data : {
        				deptID : arr_userinfo[4],
        				deptName  : arr_userinfo[5],
        				deptName2 : arr_userinfo[14],
        				position  : arr_userinfo[3],
        				position2 : arr_userinfo[16]
        				},
        		success: function(xml){
        		}        			
        	});
	    }
	    window.onbeforeunload = function () {
	        try {
	        } catch (e) { }
	    };
	    function goToPage(page) {
	
	        var goPage = page;
	        if (isNaN(goPage) || goPage == "")
	            return;
	
	        if (parseInt(goPage) < 1 || parseInt(goPage) > parseInt(totalPages))
	            return;
	        curpage = parseInt(goPage);
	        pChackYN = "TRUE";
	        if (DocListType == "DocList")
	            GetDocList();
	        else if (DocListType == "GetDocSearch")
	            GetDocSearch();
	        else if (DocListType == "UserContDocList")
	            GetUserContList();
	        else if (DocListType == "DeptContDocList")
	            GetDeptContList();
	    }
	    var BlockSize = 10;
	    function td_Create1(strtext) {
	        document.getElementById("tblPageRayer").innerHTML = strtext;
	    }
	    function makePageSelPage() {
	        var strtext;
	        var PagingHTML = "";
	        document.getElementById("tblPageRayer").innerHTML = "";
	
	        var period;
	        if (document.getElementById("sel_year").value.toLowerCase() == "all") {
	            var nowyear = new Date().getFullYear();
	            var nowmonth = new Date().getMonth() + 1;
	            var nowday = new Date().getDate();
	            period = (nowyear - 1) + strLang1028 + " " + nowmonth + strLang1029 + " " + nowday + strLang1030 + " ~ " + nowyear + strLang1028 + " " + nowmonth + strLang1029 + " " + nowday + strLang1030;
	        }
	        else {
	            period = document.getElementById("sel_year").value + strLang1028 + " 1" + strLang1029 + " 1" + strLang1030 + " ~ " + document.getElementById("sel_year").value + strLang1028 + " 12" + strLang1029 + " 31" + strLang1030;
	        }
	
	        document.getElementById("TitleInfo").innerHTML = " &nbsp;[" + strLang942 + "<span style='color:#017BEC;font-weight:bold;'> " + NodeListLen + " </span>" + strLang943 + " - " + period + "]";
	
	        strtext = "<div class='pagenavi'>";
	        PagingHTML += strtext;
	        var totalPage = totalPages;
	        var pageNum = curpage;
	        if (totalPage > 1 && pageNum != 1) {
	            strtext = "<span class='btnimg'><a onclick= 'return goToPageByNum(1)'>";
	            strtext = strtext + "<img src='/images/kr/cm/btn_p_prev.gif' width='16' height='16' /></a></span>";
	            PagingHTML += strtext;
	        }
	        else {
	            strtext = "<span class='btnimg'><a >";
	            strtext = strtext + "<img src='/images/kr/cm/btn_p_prev01.gif' width='16' height='16' /></a></span>";
	            PagingHTML += strtext;
	        }
	        if (totalPage > BlockSize) {
	            if (pageNum > BlockSize) {
	                strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'>";
	                strtext = strtext + "<img src='/images/kr/cm/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang940 + "</span>";
	                PagingHTML += strtext;
	            }
	            else {
	                strtext = "<span class='btnimg'>";
	                strtext = strtext + "<img src='/images/kr/cm/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang940 + "</span>";
	                PagingHTML += strtext;
	            }
	        }
	        else {
	            strtext = "<span class='btnimg'>";
	            strtext = strtext + "<img src='/images/kr/cm/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang940 + "</span>";
	            PagingHTML += strtext;
	        }
	        var MaxNum;
	        var i;
	        var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
	        if (totalPage >= (startNum + parseInt(BlockSize))) {
	            MaxNum = (startNum + parseInt(BlockSize)) - 1;
	        }
	        else {
	            MaxNum = totalPage;
	        }
	        for (i = startNum; i <= MaxNum; i++) {
	            if (i == pageNum) {
	                strtext = "<span class='on'>" + i + "</span>";
	                PagingHTML += strtext;
	            }
	            else {
	                strtext = "<span onclick = 'goToPageByNum(" + i + ")'>" + i + "</span>";
	                PagingHTML += strtext;
	            }
	        }
	        if (totalPage > BlockSize) {
	            if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
	                strtext = "<span onclick='return selafterBlock_one()' class='ptxt'>" + strLang941 + "</span><span class='btnimg' onclick='return selafterBlock()'>";
	                strtext = strtext + "<img src='/images/kr/cm/btn_next.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            }
	            else {
	                strtext = "<span onclick='return selafterBlock_one()' class='ptxt'>" + strLang941 + "</span><span class='btnimg'>";
	                strtext = strtext + "<img src='/images/kr/cm/btn_next01.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            }
	        }
	        else {
	            strtext = "<span onclick='return selafterBlock_one()' class='ptxt'>" + strLang941 + "</span><span class='btnimg'>";
	            strtext = strtext + "<img src='/images/kr/cm/btn_next01.gif' width='16' height='16'></span>";
	            PagingHTML += strtext;
	        }
	        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
	            strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'>";
	            strtext = strtext + "<img src='/images/kr/cm/btn_n_next.gif' width='16' height='16' /></span>";
	            PagingHTML += strtext;
	        }
	        else {
	            strtext = "<span class='btnimg'>";
	            strtext = strtext + "<img src='/images/kr/cm/btn_n_next01.gif' width='16' height='16' /></span>";
	            PagingHTML += strtext;
	        }
	        PagingHTML += "</div>";
	        td_Create1(PagingHTML);
	    }
	    function goToPageByNum(Value) {
	        curpage = Value;
	        makePageSelPage();
	        goToPage(Value);
	    }
	    function selbeforeBlock() {
	        var pageNum = curpage;
	        pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
	        goToPageByNum(pageNum);
	    }
	    function selbeforeBlock_one() {
	        var pageNum = curpage;
	        var totalPage = totalPages;
	        if (parseInt(pageNum - 1) > 0)
	            goToPageByNum(parseInt(pageNum - 1));
	        else
	            return;
	    }
	    function selafterBlock() {
	        var pageNum = curpage;
	        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
	        goToPageByNum(pageNum);
	    }
	    function selafterBlock_one() {
	        var pageNum = curpage;
	        var totalPage = totalPages;
	        if (parseInt(pageNum + 1) <= totalPage)
	            goToPageByNum(parseInt(pageNum + 1));
	        else
	            return;
	    }
	    //function GongRamDocInfo() {
	    //    var tr = lvtDoclist.getMultiRowIndex();
	    //    if (tr.length > 0) {
	    //        var heigth = window.screen.availHeight;
	    //        var width = window.screen.availWidth;
	    //        var left = (parseInt(width) - 525) / 2;
	    //        var top = (parseInt(heigth) - 220) / 2;
	    //        window.open("../ezDocInfo/ezLineInfo.aspx?pDocID=" + lvtDoclist.getvalue3(tr[0], 0, "DATA1") + "&pDeptID=&pDocState=015", "", "height=220px,width=525px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	    //    }
	    //}
	    function GongRamDocInfo() {
	        var DocList = new ListView();
	        DocList.LoadFromID("DocList");
	        var selRow = DocList.GetSelectedRows();
	
	        if (selRow.length > 0) {
	            var tr = selRow[0];
	            var heigth = window.screen.availHeight;
	            var width = window.screen.availWidth;
	            var left = (parseInt(width) - 525) / 2;
	            var top = (parseInt(heigth) - 220) / 2;
	            window.open("/ezApprovalG/ezLineInfo.do?docID=" + tr.getAttribute("DATA1") + "&deptID=&docState=015", "", "height=270px,width=600px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	        }
	    }
	
	    function TotalSave_onclick() {
	        var DocList = new ListView();
	        DocList.LoadFromID("DocList");
	        var tr = DocList.GetSelectedRows();
	
	        if (tr.length == 0) {
	            OpenAlertUI("<spring:message code='ezApprovalG.t113'/>");
	            return;
	        }
	        else
	            pDocID = tr[0].getAttribute("DATA1");
	
	        var url = "/ezApprovalG/totalSaveFileInfo.do?docID=" + pDocID + "&type=END";
	        var feature = "status=no,help=no,scroll=no,edge=sunken,width=600px,height=450px";
	        feature = feature + GetOpenPosition(600, 450);
	        window.open(url, "", feature);
	    }
	
	    window.onresize = function () {
	        var height = parseInt(divList.style.height.replace('px', '')) + 200;
	//150709 이윤호 리사이즈 예외처리
	//        var reheight = window.innerHeight - parseInt(height);
	        var reheight = document.documentElement.offsetHeight - parseInt(height);
	        if (reheight < 0) {
	            reheight = 0;
	        }
	        document.getElementById('div_AprLine').style.height = reheight + "px";
	    };
	
	    function ShowMailProgress() {
	        document.getElementById("loadingPanel").style.display = "";
	        document.getElementById("loadingProgress").style.top = "400px";
	        document.getElementById("loadingProgress").style.left = (CurrenWidth / 2) - 100 + "px";
	        document.getElementById("loadingProgress").style.display = "";
	    }
	    function HiddenMailProgress() {
	        document.getElementById("loadingPanel").style.display = "none";
	        document.getElementById("loadingProgress").style.display = "none";
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
	        if (document.getElementById("txt_keyword").value != "") {
	            var radiosearch = document.getElementsByName('searchCheck');
	
	            for (var i = 0; i < 25; i++) {
	                condition[i] = "";
	            }
	
	            if (radiosearch.item(0).checked) {
	                condition[1] = document.getElementById("txt_keyword").value;
	            }
	            else if (radiosearch.item(1).checked) {
	                condition[2] = document.getElementById("txt_keyword").value;
	            }
	        }
	        else {
	            alert("<spring:message code='ezApprovalG.t1160'/>");
	            return;
	        }
	        pageNum = 1;
	        Init_Flag = "False";
	        GetDocSearch();
	
	        $('#sel_year').val("ALL");
	        $('#sel_year').selectmenu('refresh');
	    }
	    </script>
	</head>
	<body class="mainbody" style="margin-top: 0px">
	    <div id="MOC_Div" style="display: none"></div>
	    <object id="behave1" style="DISPLAY: none" height="0" width="0" classid="clsid:F8E93A35-2D04-4E2C-A04D-87947594C674"></object>
	    <h1><spring:message code='ezApprovalG.t102'/><span id="presentcell" style="color:#666;font-weight:normal;"></span><span id="TitleInfo" style="color:#666;font-weight:normal;"></span>
	        <span style="float:right;font-weight:normal;color:black;">
	            <input name="searchCheck" id="Radio1" type="radio" value="rad_Subject" checked style="margin:0px;padding:0px;width:13px;height:13px; "><spring:message code='ezApprovalG.t106'/>
		        <input name="searchCheck" id="Radio2" type="radio" value="rad_Writer" style="margin:0px;padding:0px;width:13px;height:13px; "><spring:message code='ezApprovalG.t445'/>
		        &nbsp;
		        <input id="txt_keyword" style="width:150px;" onkeypress="onkeydown_start_search();" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
	            <a href="#"><img src="/images/sub/bsearch.gif" border="0" style="vertical-align:middle" onClick="search()"></a>
	        </span>
	    </h1>
	    <div id="mainmenu">
	        <ul>
	            <li style="display: none"><span onclick="return SelCont_onclick()"><spring:message code='ezApprovalG.t1516'/></span></li>
	            <li id="tenforce" style="display: none"><span id="enforce" onclick="return enforce_onclick()"><spring:message code='ezApprovalG.t1524'/></span></li>
	            <li id="tbar1" style="background: none; padding-right: 2px; display: none;">
	            <li id="tdEDMFolder" style="display: none"><span id="SelEDMFolder" onclick="return SelEDMFolder_onclick()"><spring:message code='ezApprovalG.t1525'/></span></li>
	            <li id="tbtnExcel"><span id="btnExcel" onclick="return btnExcel_onclick(0)"><spring:message code='ezApprovalG.t1526'/></span></li>
	            <li id="tbtnExcelAll"><span id="btnExcelAll" onclick="return btnExcel_onclick(1)"><spring:message code='ezApprovalG.t1527'/></span></li>
	            <li id="tDocInfo"><span id="DocInfo" onclick="return GongRamDocInfo()"><spring:message code='ezApprovalG.t946'/></span></li>
	            <li id="tbar2" style="background: none; padding-right: 2px; display: none;">
	                <img src="/images/i_bar.gif"></li>
	            <li id="tSearchCondi"><span id="SearchCondi" onclick="return SearchCondi_onclick()"><spring:message code='ezApprovalG.t111'/></span></li>
	            <li id="tViewDoc"><span id="ViewDoc" onclick="return ViewDoc_onclick()"><spring:message code='ezApprovalG.t367'/></span></li>
	            <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
	            <li style="background: none; padding-right: 2px;"><img src="/images/i_bar.gif"></li>
	            <select id="sel_year" name="sel_year" style="width:70px;" onchange="onSelect_Year(this);">    
	                <option value="ALL">ALL</option>
	            </select>  
	        </ul>
	    </div>
	    <div class="div_scroll" style="width:100%;HEIGHT:315px; overflow:AUTO" id="divList">
	        <div id="lvtDoclist"></div>
	    </div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="loadingPanel" onclick="ContextMenuHidden();"></div>
	    <div style="width: 200px; height: 50px; border: 0px solid red; text-align: center; vertical-align: middle; display: none; z-index: 9000; position: absolute;" id="loadingProgress">
	        <img src="/images/email/progress_img.gif" style="vertical-align: middle;" />
	    </div>
	    <br>
	    <div id="tblPageRayer"></div>
	    <div id="trSubInfoTab">
	        <div id="tabnav" style="width: 100%">
	            <ul>
	                <li id="tagsub1"><span onclick="MM_swapImagesub('1', event);Approval_onclick()"><spring:message code='ezApprovalG.t1769'/></span></li>
	                <li id="tagsub2"><span onclick="MM_swapImagesub('2', event);Recipent_onclick()"><spring:message code='ezApprovalG.t950'/></span></li>
	                <li id="tagsub3"><span onclick="MM_swapImagesub('3', event);Attach_onclick()"><spring:message code='ezApprovalG.t56'/></span></li>
	                <li id="tagsub4"><span onclick="MM_swapImagesub('4', event);Opinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	            </ul>
	        </div>
	
	        <div style="WIDTH:100%;HEIGHT:320px; font-size:92%; OVERFLOW-Y:AUTO;" id="div_AprLine">
	            <div id="lvtDetail" style="border: 0;"></div>
	        </div>
	    </div>
	
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	        selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
	    </script>
	
	
	    <iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
	</body>
</html>