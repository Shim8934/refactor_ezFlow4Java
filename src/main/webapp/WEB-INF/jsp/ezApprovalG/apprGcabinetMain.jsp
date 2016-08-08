<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title><spring:message code='ezApprovalG.t901'/></title>
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
    <script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/ezApprovalG/CabRoleInfo_Cross.js"></script>
    <script type="text/javascript" src="/js/ezApprovalG/ezCabinet_Cross.js"></script>
    <script type="text/javascript" src="/js/ezApprovalG/CabinetInfo_Cross.js"></script>
    <script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
    <script type="text/javascript" src="/js/ezApprovalG/getContainerInfoCB_Cross.js"></script>
    <script type="text/javascript" src="/js/ezApprovalG/SendOffer_Cross.js"></script>
	<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
    <script type="text/javascript" src="/js/Common.js"></script>
    <script type="text/javascript" src="/js/NameControl.js"></script> 
    <script type="text/javascript" src="/js/jquery/jquery.js"></script>
    <script type="text/javascript" src="/js/jquery/jquery-ui.js"></script>
    <link rel="stylesheet" href="/js/jquery/jquery-ui.css">
    <link rel="stylesheet" href="/js/jquery/jquery-ui.min.css">   
    <script type="text/javascript" id="clientEventHandlersJS">
        var OrderCell = "";        
        var g_sFlag = "${sFlag}";
        var g_uFlag = "${sFlag}";
        var labelcolor = "gray";
        var xmlhttp = createXMLHttpRequest();
        var xmldoc = createXmlDom();
        var ContainerID, condition, DocID, jobState, pURL, FormID, DocDeptYN, SelDept, DelListYN, deptName;
        var g_tagSelectsub = "1";
        var NodeList, nowblock, totalPage, block, p_page, p_nowblock, Init_Flag, DocList_Flag, DocTitle, AdminYN;
        var DeptAdminYN;
	    var contFlag = "${contType}";
        var pSusinManagerFlag = "user";
        var pChackYN, WriterID;
        var docdir = "";
	    var pEndDocHref = '${dirPath}';
        var szRoleInfo = "<c:out value = '${userInfo.rollInfo}' />";
        var UserID = "<c:out value = '${userInfo.id}' />";
        var CompanyID = "<c:out value = '${userInfo.companyID}' />";
        var DeptID = "<c:out value = '${userInfo.deptID} '/>";
        var deptName = "<c:out value = '${userInfo.deptName1}' />";
        var PageSize, Block_Size, curpage, ListView, NodeList2, NodeListLen;
        var arr_userinfo = new Array();
        arr_userinfo[0] = "user";
	    arr_userinfo[0]  = "user";
	    arr_userinfo[1]  = "<c:out value = '${userInfo.id} '/>";
	    arr_userinfo[2]  = "<c:out value = '${userInfo.displayName1} '/>";
	    arr_userinfo[3]  = "<c:out value = '${userInfo.title1} '/>";
	    arr_userinfo[4]  = "<c:out value = '${userInfo.deptID} '/>";
	    arr_userinfo[5]  = "<c:out value = '${userInfo.deptName1} '/>";
	    arr_userinfo[6]  = "<c:out value = '${userInfo.jikChek} '/>";
	    arr_userinfo[8]  = "<c:out value = '${userInfo.email} '/>";
        arr_userinfo[9] = CompanyID;
	    arr_userinfo[10] = "${susinAdmin}";
	    arr_userinfo[11]  = "<c:out value = '${userInfo.displayName1} '/>";
	    arr_userinfo[12]  = "<c:out value = '${userInfo.displayName2} '/>";
	    arr_userinfo[13]  = "<c:out value = '${userInfo.title1} '/>";
	    arr_userinfo[14]  = "<c:out value = '${userInfo.title2} '/>";
	    arr_userinfo[15]  = "<c:out value = '${userInfo.deptName1} '/>";
	    arr_userinfo[16]  = "<c:out value = '${userInfo.deptName2} '/>";
	    var CompanyID = "${userInfo.companyID}";
        var g_DeptInfo = "${deptInfo}";
	    var useOcs = "${useOcs}";
	    var Udomain = "${userEmail}";
        var UserLang = "${userInfo.lang}";
        var g_DeliveryXmlhttp = createXMLHttpRequest();
	    var pOpenYaer = "${openYear}";
        var NonActiveX = "YES";
        var vWriterID;
        document.onselectstart = function () { return false; };

        $(function () {
            $("#rec_year").selectmenu({
                change: function (event, data) {
                    onSelect_Year(data.item.value);
                }
            });

            $("#cab_year").selectmenu({
                change: function (event, data) {
                    onSelect_Year(data.item.value);
                }
            });

            $("#del_year").selectmenu({
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

            var toDay = new Date();
            var toDayYear = parseInt(toDay.getFullYear());
            var minusYear = parseInt(toDay.getFullYear()) - parseInt(pOpenYaer);
            for (var i = toDayYear; i >= toDayYear - minusYear ; i--) {
                AddOption(rec_year, i, i);
                AddOption(cab_year, i, i);
                AddOption(del_year, i, i);
            }

            var height = parseInt(divList.style.height.replace('px', '')) + 200;
            var reheight = window.innerHeight - parseInt(height);
            document.getElementById('div_AprLine').style.height = reheight + "px";

            if (navigator.userAgent.indexOf('Firefox') != -1) {
                document.body.style.MozUserSelect = 'none';
                document.body.style.WebkitUserSelect = 'none';
                document.body.style.khtmlUserSelect = 'none';
                document.body.style.oUserSelect = 'none';
                document.body.style.UserSelect = 'none';
            }
            try {
                DocList_Flag = "";
                pChackYN = "FALSE";

                PageSize = 10;
                Block_Size = 10;

                initUserRoleinfo();
                DocDeptYN = IsDocDept(DeptID);
                jobState = "APPROVAL";

                LoadList();
            }
            catch (e) {
            }
        };
        var isPeriodYear = true;
        function LoadList() {
            switch (g_sFlag) {
                case "m01":
                    RecordList_onclick();
                    break;
                case "m02":
                    isPeriodYear = false;
                    CabinetList_onclick();
                    break;
                case "m03":
                    idistbox_onclick();
                    break;
                case "m05":
                    ReceiptList_onclick();
                    break;
                case "m06":
                    SendList_onclick();
                    break;
                case "m07":
                    isPeriodYear = false;
                    DelayEndYRequest_onclick();
                    break;
                case "m08":
                    isPeriodYear = false;
                    ArrTargetList_onclick();
                    break;
                case "m09":
                    isPeriodYear = false;
                    CabGiveList_onclick();
                    break;
                case "m10":
                    ToggleAdminMenu();
                    break;
                default:
                    RecordList_onclick();
                    break;
            }
        }

        var SelYearFlag = false;
        function onSelect_Year() {
            SelYearFlag = true;
            if (GetSelectVal("rec_year") != "ALL" || GetSelectVal("cab_year") != "ALL" || GetSelectVal("del_year") != "ALL") {

                hideProgress();
                showProgress();

                if (DocList_Flag == "CABINET") {
                    g_CabSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + DeptID + "</DEPTCODE><TITLE></TITLE><TASKCODE></TASKCODE><SPRODUCEY>" + GetSelectVal("cab_year") + "</SPRODUCEY><EPRODUCEY>" + GetSelectVal("cab_year") + "</EPRODUCEY><SENDY></SENDY><EENDY></EENDY><RECTYPECODE></RECTYPECODE><KEEPPERIOD></KEEPPERIOD><KEEPMETHOD></KEEPMETHOD><KEEPPLACE></KEEPPLACE><CHARGER></CHARGER><TRANSEXPIRE/><TRANSFLAG/><RECEIVEDCAB/><GIVECAB/></SEARCHPARAM>";
                    GetCaninetList();
                }
                else if (DocList_Flag == "RECORD") {
                    g_RecSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + DeptID + "</DEPTCODE><TITLE></TITLE><REGTYPE></REGTYPE><SREGDATE>" + GetSelectVal("rec_year") + "-01-01 00:00:00</SREGDATE><EREGDATE>" + GetSelectVal("rec_year") + "-12-31 23:59:59</EREGDATE><CHARGER></CHARGER><SC></SC><TRANSEXPIRE/><DRAFTER></DRAFTER><CABTITLE></CABTITLE></SEARCHPARAM>";
                    GetRecordList();
                }
                else {
                    g_DeliverySearchParamXml = "<SEARCHPARAM><DEPTCODE></DEPTCODE><DEPTCODE2>" + DeptID + "</DEPTCODE2><TITLE></TITLE><SREGDATE>" + GetSelectVal("del_year") + "-01-01 00:00:00</SREGDATE><EREGDATE>" + GetSelectVal("del_year") + "-12-31 23:59:59</EREGDATE><DEBENTURER></DEBENTURER></SEARCHPARAM>";
                    GetDocDeliveryList(g_DeliverySearchParamXml);
                }
            }
            else {
                g_RecSearchParamXml = "";
                g_CabSearchParamXml = "";
                g_DeliverySearchParamXml = "";

                var nowyear = new Date().getFullYear();
                var nowmonth = new Date().getMonth() + 1;
                var nowday = new Date().getDate();

                if (nowmonth < 10)
                    nowmonth = "0" + nowmonth;

                if (nowday < 10)
                    nowday = "0" + nowday;

                if (DocList_Flag == "CABINET") {
                    if (isPeriodYear)
                        g_CabSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + DeptID + "</DEPTCODE><TITLE></TITLE><TASKCODE></TASKCODE><SPRODUCEY>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:00</SPRODUCEY><EPRODUCEY>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59</EPRODUCEY><SENDY></SENDY><EENDY></EENDY><RECTYPECODE></RECTYPECODE><KEEPPERIOD></KEEPPERIOD><KEEPMETHOD></KEEPMETHOD><KEEPPLACE></KEEPPLACE><CHARGER></CHARGER><TRANSEXPIRE/><TRANSFLAG/><RECEIVEDCAB/><GIVECAB/></SEARCHPARAM>";
                    GetCaninetList();
                }
                else if (DocList_Flag == "RECORD") {
                    g_RecSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + DeptID + "</DEPTCODE><TITLE></TITLE><REGTYPE></REGTYPE><SREGDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:00</SREGDATE><EREGDATE>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59</EREGDATE><CHARGER></CHARGER><SC></SC><TRANSEXPIRE/><DRAFTER></DRAFTER><CABTITLE></CABTITLE></SEARCHPARAM>";
                    GetRecordList();
                }
                else {
                    g_DeliverySearchParamXml = "<SEARCHPARAM><DEPTCODE></DEPTCODE><DEPTCODE2>" + DeptID + "</DEPTCODE2><TITLE></TITLE><SREGDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:00</SREGDATE><EREGDATE>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59</EREGDATE><DEBENTURER></DEBENTURER></SEARCHPARAM>";
                    GetDocDeliveryList(g_DeliverySearchParamXml);
                }
            }
        }

        function btnAddJob_onclick() {
            var parameter = "";
            var url = "../ezDocInfo/ezSubTitle_Cross.aspx?id=" + escape(UserID);
            var feature = "status:no;dialogWidth:270px;dialogHeight:250px;help:no;scroll:no;edge:sunken";
            feature = feature + GetShowModalPosition(270, 250);
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
                LoadList();
            }
        }
        function ChangeCookies() {
            var xmlhttp = createXMLHttpRequest();
            var xmlpara = createXmlDom();

            var objNode;

            createNodeInsert(xmlpara, objNode, "DATA");
            createNodeAndInsertText(xmlpara, objNode, "DEPTID", arr_userinfo[4]);
            createNodeAndInsertText(xmlpara, objNode, "DEPTNAME", arr_userinfo[5]);
            createNodeAndInsertText(xmlpara, objNode, "POSITION", arr_userinfo[3]);
            createNodeAndInsertText(xmlpara, objNode, "POSITION1", arr_userinfo[15]);
            createNodeAndInsertText(xmlpara, objNode, "POSITION2", arr_userinfo[16]);
            createNodeAndInsertText(xmlpara, objNode, "DEPTNAME1", arr_userinfo[13]);
            createNodeAndInsertText(xmlpara, objNode, "DEPTNAME2", arr_userinfo[14]);

            xmlhttp.open("POST", "../Include/ChangeUserInfo.aspx", false);
            xmlhttp.send(xmlpara);
        }
        function lvtDetail_SelChange() {
        }
        function lvtDoclist_onclick() {
        }
        function lvtDoclist_onSel_DBclick() {
            if (DocList_Flag == "CABINET") {
                btnViewCabInfo_onclick();
            }
            else {
                ViewDoc_onclick();
            }
        }
        function lvtDetail_onclick() {
        }
        function lvtDetail_onSel_DBclick() {
            var DocList = new ListView();
            DocList.LoadFromID("SubDocList");
            var selRow = DocList.GetSelectedRows();
            var tr = selRow[0];
            if (tr != null && typeof (selRow.length) != "undefined" && selRow.length > 0) {
                if (jobState == "ATTACH") {
                    return;

                    var para = "";
                    var url = tr.getAttribute("DATA1");
                    var feature;
                    feature = window.open(url);

                }
                else if (jobState == "RECIPENT") {
                    OpenReceiptHistory();
                }
                else if (jobState == "APPROVAL") {
                    openUserInfo();
                }
            }
        }
    function idistbox_onclick() {
        document.getElementById("imgTitle").innerHTML = "<spring:message code='ezApprovalG.t911'/>";
        document.getElementById("imgTitle").style.display = "";
        SwapSubMenuDisplay("0");

        pChackYN == "FALSE";
        DocList_Flag = "Delivery";
        try {
            if (trSubInfoTab) {
                document.getElementById("trSubInfoTab").style.display = "";
                document.getElementById("divList").style.height = "310";
                //PageSize = 10;
                Block_Size = 10;
            }
        } catch (e) { }

        var nowyear = new Date().getFullYear();
        var nowmonth = new Date().getMonth() + 1;
        var nowday = new Date().getDate();

        if (nowmonth < 10)
            nowmonth = "0" + nowmonth;

        if (nowday < 10)
            nowday = "0" + nowday;

        g_DeliverySearchParamXml = "<SEARCHPARAM><DEPTCODE></DEPTCODE><DEPTCODE2>" + DeptID + "</DEPTCODE2><TITLE></TITLE><SREGDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:00</SREGDATE><EREGDATE>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59</EREGDATE><DEBENTURER></DEBENTURER></SEARCHPARAM>";

        GetDocDeliveryList(g_DeliverySearchParamXml);
    }
    function ichange_onclick() {
        SendOffer(UserID);
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
    function MM_swapImagesub(nSel, e) {
        if (nSel != g_tagSelectsub) {
            g_tagSelectsub = nSel;
            var Event = e ? e : window.event;
            var Element = Event.target ? Event.target : Event.srcElement;

            Element.src = "/images/tab_appsub" + nSel + ".gif";
//             Element.height = "23";

            var i;
            for (i = 1 ; i <= 4; i++) {
                if (g_tagSelectsub != i) {
                    var str = "tagsub" + i + ".src" + "=" + "\"/images/tab_appsub" + i + "a.gif\"";
                    eval(str);
//                     var str = "tagsub" + i + ".height" + "=" + "23";
//                     eval(str);
                }
            }
        }
    }
    function GetUserRole() {
        if (AdminYN == "TRUE")
            return "Admin";
        else if (g_bRecAdmin)
            return "DeptAdmin";
        else
            return "User";
    }

    function InitSubMenu(MenuType) {
        if (g_sFlag == "m01")
            document.getElementById("tdichange_Rec").style.display = "";
        else
            document.getElementById("tdichange_Rec").style.display = "none";
        switch (MenuType) {
            case "0":
                document.getElementById("trCabSubMenu").style.display = "";
                document.getElementById("trRecSubMenu").style.display = "none";

                document.getElementById("Radio2").style.display = "none";
                document.getElementById("searchwriter").style.display = "none";

                if (g_bDeptCharger || g_bRecAdmin || AdminYN == "TRUE") {
                    if (ListTypeFlag != "8" && ListTypeFlag != "9" && ListTypeFlag != "10")
                        document.getElementById("tdRegCabinet").style.display = "";
                    else
                        document.getElementById("tdRegCabinet").style.display = "none";

                    if (ListTypeFlag != "9")
                        document.getElementById("tdNewVol").style.display = "";
                    else
                        document.getElementById("tdNewVol").style.display = "none";
                }
                else {
                    document.getElementById("tdRegCabinet").style.display = "none";
                    document.getElementById("tdNewVol").style.display = "none";
                }

                if (ListTypeFlag != "9") {
                    if (g_bDeptCharger || g_bRecAdmin || AdminYN == "TRUE")
                        document.getElementById("tdModifyCab").style.display = "";
                    else
                        document.getElementById("tdModifyCab").style.display = "none";

                    if (g_bRecAdmin || AdminYN == "TRUE") {
                        document.getElementById("tdViewCabHist").style.display = "";
                        document.getElementById("tdSetCharger").style.display = "";
                    }
                    else {
                        document.getElementById("tdViewCabHist").style.display = "none";
                        document.getElementById("tdSetCharger").style.display = "none";
                    }

                    document.getElementById("tdbtnViewRecList").style.display = "";
                    document.getElementById("tbar1").style.display = "";

                }
                else {
                    document.getElementById("tdModifyCab").style.display = "none";
                    document.getElementById("tdViewCabHist").style.display = "none";
                    document.getElementById("tdSetCharger").style.display = "none";
                    document.getElementById("tdbtnViewRecList").style.display = "none";
                    document.getElementById("tbar1").style.display = "none";

                }

                if (ListTypeFlag == "8" && (g_bDeptCharger || g_bRecAdmin || AdminYN == "TRUE")) {
                    document.getElementById("tdbtnEndProduce").style.display = "";
                    document.getElementById("tdbtnCancelEndProd").style.display = "";
                }
                else {
                    document.getElementById("tdbtnEndProduce").style.display = "none";
                    document.getElementById("tdbtnCancelEndProd").style.display = "none";
                }

                if (ListTypeFlag == "10" && (g_bDeptCharger || g_bRecAdmin || AdminYN == "TRUE")) {
                    document.getElementById("tdReqDelayEndY").style.display = "";
                    document.getElementById("CancelDelayEndY").style.display = "";
                }
                else {
                    document.getElementById("tdReqDelayEndY").style.display = "none";
                    document.getElementById("CancelDelayEndY").style.display = "none";
                }
                break;

            case "1":
                document.getElementById("trCabSubMenu").style.display = "none";
                document.getElementById("trRecSubMenu").style.display = "";


                if (g_bRecAdmin || AdminYN == "TRUE")
                    document.getElementById("tdRegRecord").style.display = "";
                else
                    document.getElementById("tdRegRecord").style.display = "none";

                if (ListTypeFlag == "0")
                    document.getElementById("tdCabSelect").style.display = "";
                else
                    document.getElementById("tdCabSelect").style.display = "none";

                if (g_bDeptCharger || g_bRecAdmin || AdminYN == "TRUE") {
                    document.getElementById("tdMoveRec").style.display = "";
                    document.getElementById("tdRegSepAtt").style.display = "";
                }
                else {
                    document.getElementById("tdMoveRec").style.display = "none";
                    document.getElementById("tdRegSepAtt").style.display = "none";
                }

                if (g_bDeptCharger || g_bRecAdmin || AdminYN == "TRUE")
                    document.getElementById("tdModifyRec").style.display = "";
                else
                    document.getElementById("tdModifyRec").style.display = "";

                if (g_bRecAdmin || AdminYN == "TRUE") {
                    document.getElementById("tdVeiwRecHist").style.display = "";
                    document.getElementById("tdbtnViewRecReadHist").style.display = "";

                    CheckBtnSetRecRole();
                }
                else {
                    document.getElementById("tdVeiwRecHist").style.display = "none";
                    document.getElementById("tdbtnViewRecReadHist").style.display = "none";
                    document.getElementById("tdbtnSetRecRole").style.display = "none";
                }
                break;
        }
    }

    function CheckBtnSetRecRole() {
        if (g_bRecAdmin || AdminYN == "TRUE") {
            if (AdminYN != "TRUE") {
                var tmpAuthChk = false;
                var tmpChkDeptID = DeptID;

                if (g_RecSearchParamXml != "") {
                    var tmpXMLDOM = createXmlDom();
                    tmpXMLDOM = loadXMLString(g_RecSearchParamXml);
                    var deptcdoenode = SelectSingleNodeNew(tmpXMLDOM, "SEARCHPARAM/DEPTCODE");
                    if (deptcdoenode.length > 0)
                        tmpChkDeptID = getNodeText(deptcdoenode);
                }
                if ("<c:out value = '${userInfo.deptID} '/>" == tmpChkDeptID)
                    tmpAuthChk = true;

                if (g_DeptInfo != "") {
                    var tmpArrDeptInfo = g_DeptInfo.split(";");

                    for (var n = 0 ; n < tmpArrDeptInfo.length ; n++) {
                        if (tmpArrDeptInfo[n].split(":")[0] == tmpChkDeptID)
                            tmpAuthChk = true;
                    }
                }

                if (tmpAuthChk)
                    document.getElementById("tdbtnSetRecRole").style.display = "";
                else
                    document.getElementById("tdbtnSetRecRole").style.display = "none";
            }
            else {
                document.getElementById("tdbtnSetRecRole").style.display = "";
            }
        }
        else {
            document.getElementById("tdbtnSetRecRole").style.display = "none";
        }
    }
    function SwapSubMenuDisplay(flag) {
        if (flag == "0") {
            document.getElementById("trCabSubMenu").style.display = "none";
            document.getElementById("trRecSubMenu").style.display = "none";
            document.getElementById("trDeliveryMenu").style.display = "";
        }
        else {
        }
    }
    function ArrTargetList_onclick() {
        document.getElementById("imgTitle").innerHTML = "<spring:message code='ezApprovalG.t908'/>";
        document.getElementById("imgTitle").style.display = "";
        SwapSubMenuDisplay("1");

        InitGlobals("CABINET", "8", "0");
        if (g_bRecAdmin || AdminYN == "TRUE") {
        }
        else {
            g_CabSearchParamXml = "<SEARCHPARAM><CHARGER>'" + UserID + "'</CHARGER></SEARCHPARAM>";
        }
        GetCaninetList();
    }
    function DelayEndYRequest_onclick() {
        document.getElementById("imgTitle").innerHTML = "<spring:message code='ezApprovalG.t524'/>";
        document.getElementById("imgTitle").style.display = "";
        SwapSubMenuDisplay("1");

        InitGlobals("CABINET", "10", "0");
        if (g_bRecAdmin || AdminYN == "TRUE") {
        }
        else {
            g_CabSearchParamXml = "<SEARCHPARAM><CHARGER>'" + UserID + "'</CHARGER></SEARCHPARAM>";
        }

        GetCaninetList();
    }
    function CabGiveList_onclick() {
        document.getElementById("imgTitle").innerHTML = "<spring:message code='ezApprovalG.t909'/>";
        document.getElementById("imgTitle").style.display = "";
        SwapSubMenuDisplay("1");

        InitGlobals("CABINET", "9", "0");

        GetCaninetList();
    }
    function CabinetList_onclick() {
        document.getElementById("imgTitle").innerHTML = "<spring:message code='ezApprovalG.t912'/>";
        document.getElementById("imgTitle").style.display = "";

        SwapSubMenuDisplay("1");

        InitGlobals("CABINET", "0", "0");

        GetCaninetList();
    }

    var regcabinet_cross_dialogArguments = new Array();
    function btnRegCabinet_onclick() {
        var para = new Array();
        para[0] = "0";
        var url = "/myoffice/ezApprovalG/ezCabinet/RegCabinet_Cross.aspx";

        regcabinet_cross_dialogArguments[0] = para;
        regcabinet_cross_dialogArguments[1] = btnRegCabinet_onclick_Complete;

        var OpenWin;

        if (UserLang == "1")
            OpenWin = window.open(url, "RegCabinet_Cross", GetOpenWindowfeature(835, 435));
        else
            OpenWin = window.open(url, "RegCabinet_Cross", GetOpenWindowfeature(905, 435));

        try { OpenWin.focus(); } catch (e) { }
    }
    function btnRegCabinet_onclick_Complete(rtn) {
        if (rtn[0] == "TRUE")
            GetCaninetList();
    }
    function btnNewVolume_onclick() {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selnode = DocList.GetSelectedRows();

        if (selnode.length != 0) {
            var tr = selnode[0];
            var rtn = NewVolume(tr.getAttribute("DATA1"), tr.getAttribute("DATA2"), "OPEN", btnNewVolume_onclick_Complete);
        }
        else {
            OpenAlertUI("<spring:message code='ezApprovalG.t913'/>");
        }
    }

    function btnNewVolume_onclick_Complete(rtn) {
        if (rtn[0] != "FALSE") {
            AddNewVolume(temppCabClassNo, rtn[1]);
            GetCaninetList();
        }
    }
    var changecabinetinfo_cross_dialogArguments = new Array();
    function btnChangeCabinetInfo_onclick() {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();
        if (selRow.length != 0) {
            var tr = selRow[0];
            var para = new Array();
            para[0] = tr.getAttribute("DATA1");
            para[1] = tr.getAttribute("DATA2");
            para[2] = arr_userinfo[1];
            para[3] = arr_userinfo[2];
            para[4] = g_bRecAdmin;
            var url = "/myoffice/ezApprovalG/ezCabinet/ChangeCabinetInfo_Cross.aspx";

            changecabinetinfo_cross_dialogArguments[0] = para;
            changecabinetinfo_cross_dialogArguments[1] = btnChangeCabinetInfo_onclick_Complete;

            var OpenWin = window.open(url, "ChangeCabinetInfo_Cross", GetOpenWindowfeature(405, 390));
            try { OpenWin.focus(); } catch (e) { }

           
        }
        else {
            OpenAlertUI("<spring:message code='ezApprovalG.t513'/>");
        }
    }
    function btnChangeCabinetInfo_onclick_Complete(rtn) {
        if (rtn[0] == "TRUE") {
            GetCaninetList();
        }
    }
    var settaskchrger_cross_dialogArguments = new Array();
    function btnSetTaskCharger_onclick() {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();
        if (selRow.length != 0) {
            var tr = selRow[0];
            var para = new Array();
            para[0] = tr.getAttribute("DATA2");
            para[1] = DeptID;

            var url = "/myoffice/ezApprovalG/ezCabinet/SetTaskChrger_Cross.aspx";

            settaskchrger_cross_dialogArguments[0] = para;

            var OpenWin = window.open(url, "SetTaskChrger_Cross", GetOpenWindowfeature(520, 415));
            try { OpenWin.focus(); } catch (e) { }
        }
        else {
            OpenAlertUI("<spring:message code='ezApprovalG.t513'/>");
        }
    }
    function ReqDelayEndY_onclick() {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();
        var len = selRow.length;
        var i;

        if (len > 0) {
            var CabClassList = "";
            for (i = 0; i < len; i++) {
                if (CabClassList != "")
                    CabClassList += ",";

                var tr = selRow[i];
                CabClassList += tr.getAttribute("DATA2");
            }

            if (ReqDelayCabEndY(CabClassList, "Y") == "TRUE") {
                OpenAlertUI("<spring:message code='ezApprovalG.t914'/>");
                DelayEndYRequest_onclick();
            }
            else {
                OpenAlertUI("<spring:message code='ezApprovalG.t915'/>");
            }
        }
        else {
            OpenAlertUI("<spring:message code='ezApprovalG.t916'/>");
        }
    }
    function CancelDelayEndY_onclick() {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();
        var len = selRow.length;
        var i;

        if (len > 0) {
            var CabClassList = "";
            for (i = 0; i < len; i++) {
                if (CabClassList != "")
                    CabClassList += ",";

                var tr = selRow[i];
                CabClassList += tr.getAttribute("DATA2");
            }
            if (ReqDelayCabEndY(CabClassList, "N") == "TRUE")
                DelayEndYRequest_onclick();
            else
                OpenAlertUI("<spring:message code='ezApprovalG.t917'/>");
        }
        else {
            OpenAlertUI("<spring:message code='ezApprovalG.t916'/>");
        }
    }
    function ReqDelayCabEndY(CabClassList, Flag) {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETERS");
        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
        createNodeAndInsertText(xmlpara, objNode, "CABCLASSLIST", CabClassList);
        createNodeAndInsertText(xmlpara, objNode, "FLAG", Flag);
        xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/API_ReqDelayCabEndY.aspx", false);
        xmlhttp.send(xmlpara);

        var dataNodes = GetChildNodes(xmlhttp.responseXML);
        return getNodeText(dataNodes[0]);
    }
    var endcabproduce_cross_dialogArguments = new Array();
    function btnEndProduce_onclick() {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();

        if (selRow.length != 0) {
            var tr = selRow[0];
            var para = new Array();
            para[0] = tr.getAttribute("DATA1");
            para[1] = tr.getAttribute("DATA2");

            var url = "/myoffice/ezApprovalG/ezCabinet/EndCabProduce_Cross.aspx";

            endcabproduce_cross_dialogArguments[0] = para;
            endcabproduce_cross_dialogArguments[1] = btnEndProduce_onclick_Complete;

            var OpenWin = window.open(url, "EndCabProduce_Cross", GetOpenWindowfeature(350, 280));
            try { OpenWin.focus(); } catch (e) { }
        }
        else {
            OpenAlertUI("<spring:message code='ezApprovalG.t513'/>");
        }
    }
    function btnEndProduce_onclick_Complete(rtn) {
        if (rtn[0] == "TRUE") {
            GetCaninetList();
        }
    }
    function btnCancelEndProd_onclick() {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();
        if (selRow.length != 0) {
            var tr = selRow[0];
            bCon = OpenInformationUI("<spring:message code='ezApprovalG.t918'/>", btnCancelEndProd_onclick_Complete);
        }
        else {
            OpenAlertUI("<spring:message code='ezApprovalG.t513'/>");
        }
    }
    function btnCancelEndProd_onclick_Complete(bCon) {
        if (bCon) {
            var DocList = new ListView();
            DocList.LoadFromID("DocList");
            var selRow = DocList.GetSelectedRows();
            var tr = selRow[0];

            if (EndCabProduce(tr.getAttribute("DATA2"), "", "1")) {
                GetCaninetList();
            }
            else {
                OpenAlertUI("<spring:message code='ezApprovalG.t919'/>");
            }
        }
    }
    function btnViewRecList_onclick() {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();
        if (selRow.length != 0) {
            var tr = selRow[0];
            SwapSubMenuDisplay("1");
            InitGlobals("RECORD", "0", "1");
            g_SelCabXml = "<CABINETINFO><CABINET><CABINETID>" + tr.getAttribute("DATA1") + "</CABINETID></CABINET></CABINETINFO>";
            GetRecordList();
        }
        else {
            OpenAlertUI("<spring:message code='ezApprovalG.t513'/>");
        }
    }

    var ezapropinion_cross_dialogArguments = new Array();
    function OpenInformationUI(pInformationContent, CompleteFunction) {
        var parameter = pInformationContent;
        var url = "/myoffice/ezApprovalG/ezAPROPINION_Cross.aspx";

        if (CrossYN() || NonActiveX == "YES") {
            ezapropinion_cross_dialogArguments[0] = parameter;
            if (CompleteFunction != undefined)
                ezapropinion_cross_dialogArguments[1] = CompleteFunction;
            else
                ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
            DivPopUpShow(330, 205, url);
        }
        else {
            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
            feature = feature + GetShowModalPosition(330, 205);
            var RtnVal = window.showModalDialog(url, parameter, feature);
        }
        return RtnVal;
    }

    function OpenInformationUI_Complete() {
        DivPopUpHidden();
    }

    function RecordList_onclick() {
        document.getElementById("imgTitle").innerHTML = "<spring:message code='ezApprovalG.t552'/>";
        document.getElementById("imgTitle").style.display = "";
        SwapSubMenuDisplay("1");
        InitGlobals("RECORD", "0", "1");
        GetRecordList();
    }
        function btnRegRecord_onclick() {
            var para = new Array();
            para[0] = g_SelCabXml;
            para[1] = ListTypeFlag;

            if (CrossYN() || NonActiveX == "YES") {
                var url = "/myoffice/ezApprovalG/ezCabinet/RegRecord_Cross.aspx?SelCabXml=" + g_SelCabXml + "&TypeFlag=" + ListTypeFlag;

                var wWeight = "";
                var wHeight = "";

                var heigth = window.screen.availHeight;
                var width = window.screen.availWidth;

                var left = "";
                var top = "";

                if ("${userInfo.lang}" == "1")
              { 
                wWeight = 875;
                wHeight = 625;
                left = (width - wWeight) / 2;
                top = (heigth - wHeight) / 2;
                }
              else
              { 
                wWeight = 875;
                wHeight = 625;
                left = (width - wWeight) / 2;
                top = (heigth - wHeight) / 2;
                } 
                if (url != "")
                    var ret = window.open(url, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
            }
            else {
                var url = "/myoffice/ezApprovalG/ezCabinet/RegRecord.aspx";

                if ("${userInfo.lang}" == "1")
              { 
                var feature = "dialogWidth:755px;dialogHeight:570px;scroll:no;resizable:no;status:no; help:no;edge:sunken";
                }
              else
              { 
                var feature = "dialogWidth:825px;dialogHeight:570px;scroll:no;resizable:no;status:no; help:no;edge:sunken";
                } 
                if (url != "")
                    var rtn = window.showModalDialog(url, para, feature);

                if (rtn[0] == "TRUE") {
                    GetRecordList();
                }
            }
            //if (rtn[0] == "TRUE") {
            //    GetRecordList();
            //}
        }
    var regsepattach_cross_dialogArguments = new Array();
    function btnRegAttach_onclick() {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();
        if (selRow.length != 0) {
            var tr = selRow[0];
            var para = new Array();
            para[0] = "0";
            para[1] = tr.getAttribute("DATA6");
            para[2] = tr.getAttribute("DATA7");
            para[3] = "";

            var url = "/myoffice/ezApprovalG/ezCabinet/RegSepAttach_Cross.aspx";

            regsepattach_cross_dialogArguments[0] = para;
            regsepattach_cross_dialogArguments[1] = btnRegAttach_onclick_Complete;

            var OpenWin = window.open(url, "schedule_select_attendant", GetOpenWindowfeature(565, 460));
            try { OpenWin.focus(); } catch (e) { }
        }
    }

    function btnRegAttach_onclick_Complete(rtn) {
        if (rtn[0] == "TRUE") {
            GetRecordList();
        }
    }

    var selectcabinet_cross_dialogArguments = new Array();
    function CabinetSelect_onclick() {
        DocList_Flag = "RECORD";

        var para = new Array();
        var rtn;
        var url = "/myoffice/ezApprovalG/ezCabinet/SelectCabinet_Cross.aspx?initFlag=0";

        selectcabinet_cross_dialogArguments[0] = para;
        selectcabinet_cross_dialogArguments[1] = CabinetSelect_onclick_Complete;

        var OpenWin = window.open(url, "SelectCabinet_Cross", GetOpenWindowfeature(850, 460));
        try { OpenWin.focus(); } catch (e) { }
    }

    function CabinetSelect_onclick_Complete(rtn) {
        if (rtn[0] == "TRUE") {
            curpage = "1";
            g_SelCabXml = rtn[1];
            g_TransFlag = rtn[2];
            GetRecordList();
        }
    }

    function btnChangeRecCabinet_onclick() {
        var rtn = new Array();
        rtn[0] = "FALSE";
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();
        if (selRow.length != 0) {
            var tr = selRow[0];
            var RecID = tr.getAttribute("DATA6");
            var CabID = tr.getAttribute("DATA7");
            var SepAttNo = tr.getAttribute("DATA8");

            var para = new Array();
            var url = "/myoffice/ezApprovalG/ezCabinet/SelectCabinet_Cross.aspx?initFlag=1";

            selectcabinet_cross_dialogArguments[0] = para;
            selectcabinet_cross_dialogArguments[1] = btnChangeRecCabinet_onclick_Complete;

            var OpenWin = window.open(url, "SelectCabinet_Cross", GetOpenWindowfeature(850, 480));
            try { OpenWin.focus(); } catch (e) { }

           
        }
        else {
            OpenAlertUI("<spring:message code='ezApprovalG.t632'/>");
        }
    }
    var temparrCabInfo;
    function btnChangeRecCabinet_onclick_Complete(rtn) {
        if (rtn[0] == "TRUE") {
            var arrCabInfo = GetSelCabInfo(rtn[1], 0);
            temparrCabInfo = arrCabInfo;
           OpenInformationUI("<spring:message code='ezApprovalG.t927'/>" + arrCabInfo[1] + "(" + arrCabInfo[4] + "<spring:message code='ezApprovalG.t923'/>" + "<spring:message code='ezApprovalG.t924'/>", ChangeRecCabinetOpenUI);
        }
    }

    function ChangeRecCabinetOpenUI(bConfirm) {
        if (bConfirm) {
            var DocList = new ListView();
            DocList.LoadFromID("DocList");
            var selRow = DocList.GetSelectedRows();
            var tr = selRow[0];
            var RecID = tr.getAttribute("DATA6");
            var CabID = tr.getAttribute("DATA7");
            var SepAttNo = tr.getAttribute("DATA8");

            if (MoveRecord(RecID, SepAttNo, temparrCabInfo[0], "0")) {
                OpenAlertUI("<spring:message code='ezApprovalG.t925'/>");
                GetRecordList();
            }
            else {
                OpenAlertUI("<spring:message code='ezApprovalG.t926'/>");
            }
        }
    }

        var ezapropinion_cross_dialogArguments = new Array();
    function OpenInformationUI(pInformationContent, CompleteFunction) {
        var parameter = pInformationContent;
        var url = "/myoffice/ezApprovalG/ezAPROPINION_Cross.aspx";

        if (CrossYN() || NonActiveX == "YES") {
            ezapropinion_cross_dialogArguments[0] = parameter;
            if (CompleteFunction != undefined)
                ezapropinion_cross_dialogArguments[1] = CompleteFunction;
            else
                ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
            
            var OpenWin = window.open(url, "ezAPROPINION_Cross", GetOpenWindowfeature(330, 205));
            try { OpenWin.focus(); } catch (e) { }
        }
        else {
            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
            feature = feature + GetShowModalPosition(330, 205);
            var RtnVal = window.showModalDialog(url, parameter, feature);
        }
        return RtnVal;
    }

    function OpenInformationUI_Complete() {
        DivPopUpHidden();
    }

    function GetSelCabInfo(pCabListXml, idx) {
        var len;
        var rtnArr = new Array();
        if (pCabListXml != "") {
            var CabListXml = createXmlDom();
            CabListXml = loadXMLString(pCabListXml);

            var objCabs = SelectNodes(CabListXml, "CABINET");
            len = objCabs.length;

            if (idx < len) {
                rtnArr[0] = getNodeText(SelectNodes(CabListXml, "CABINETID")[idx]);
                rtnArr[1] = getNodeText(SelectNodes(CabListXml, "CABINETNAME")[idx]);
                rtnArr[2] = getNodeText(SelectNodes(CabListXml, "RECTYPE")[idx]);
                rtnArr[3] = getNodeText(SelectNodes(CabListXml, "CABINETSN")[idx]);
                rtnArr[4] = getNodeText(SelectNodes(CabListXml, "CABINETVOLNO")[idx]);
            }
        }
        return rtnArr;
    }
    var changerecordinfo_cross_dialogArguments = new Array();
    function btnChangeRecInfo_onclick() {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();
        if (selRow.length != 0) {
            var tr = selRow[0];
            var para = new Array();
            para[0] = tr.getAttribute("DATA6");
            para[1] = tr.getAttribute("DATA8");
            para[2] = arr_userinfo[1];
            para[3] = arr_userinfo[2];
            para[4] = g_bRecAdmin;

            var url = "/myoffice/ezApprovalG/ezCabinet/ChangeRecordInfo_Cross.aspx";

            changerecordinfo_cross_dialogArguments[0] = para;
            changerecordinfo_cross_dialogArguments[1] = btnChangeRecInfo_onclick_Complete;

            var OpenWin = window.open(url, "ChangeRecordInfo_Cross", GetOpenWindowfeature(445, 510));
            try { OpenWin.focus(); } catch (e) { }
        }
        else {
            OpenAlertUI("<spring:message code='ezApprovalG.t632'/>");
        }
    }

    function btnChangeRecInfo_onclick_Complete(rtn) {
        if (rtn[0] == "TRUE") {
            GetRecordList();
        }
    }
    var viewrecreadhistory_cross_dialogArguments = new Array();
    function btnViewRecReadHist_onclick() {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();
        if (selRow.length != 0) {
            var tr = selRow[0];
            var para = new Array();
            para[0] = tr.getAttribute("DATA1");

            var url = "/myoffice/ezApprovalG/ezCabinet/ViewRecReadHistory_Cross.aspx";

            viewrecreadhistory_cross_dialogArguments[0] = para;

            var OpenWin = window.open(url, "ViewRecReadHistory_Cross", GetOpenWindowfeature(615, 450));
            try { OpenWin.focus(); } catch (e) { }
        }
        else {
            OpenAlertUI("<spring:message code='ezApprovalG.t632'/>");
        }
    }

    //START
    var SendCard_Cross_dialogArguments = new Array();
    function btnCardSend_onclick() {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();
        if (selRow.length != 0) {
            var tr = selRow[0];
            var para = new Array();
            para[0] = tr.getAttribute("DATA6");
            para[1] = tr.getAttribute("DATA8");
            para[2] = DeptID;

            var url = "/myoffice/ezApprovalG/ezCabinet/SendCard_Cross.aspx";
            SendCard_Cross_dialogArguments[0] = para;
            SendCard_Cross_dialogArguments[1] = SendCard_Cross_Complete;

            var feature = "dialogWidth:400px;dialogHeight:178px;scroll:no;resizable:no;status:no; help:no;edge:sunken";

            var OpenWin = window.open(url, "SendCard_Cross", GetOpenWindowfeature(400, 400));
            try { OpenWin.focus(); } catch (e) { }

        }
        else {
            OpenAlertUI("<spring:message code='ezApprovalG.t632'/>");
        }
    }

    function SendCard_Cross_Complete(Rtn)
    {
        if (Rtn[0] == "TRUE") {
            GetRecordList();
        }
    }
    //END

    function ReceiptList_onclick() {
        document.getElementById("imgTitle").innerHTML = "<spring:message code='ezApprovalG.t905'/>";
        document.getElementById("imgTitle").style.display = "";
        SwapSubMenuDisplay("1");

        InitGlobals("RECORD", "10", "1");
        GetRecordList();
    }
    function SendList_onclick() {
        document.getElementById("imgTitle").innerHTML = "<spring:message code='ezApprovalG.t906'/>";
        document.getElementById("imgTitle").style.display = "";
        SwapSubMenuDisplay("1");
        InitGlobals("RECORD", "11", "1");
        GetRecordList();
    }
    window.onunload = function () {
    };
    function GongRamDocInfo() {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();
        if (selRow.length != 0) {
            var tr = selRow[0];
            var heigth = window.screen.availHeight;
            var width = window.screen.availWidth;
            var left = (parseInt(width) - 600) / 2;
            var top = (parseInt(heigth) - 270) / 2;
            window.open("../ezDocInfo/ezLineInfo_Cross.aspx?pDocID=" + tr.getAttribute("DATA1") + "&pDeptID=&pDocState=015", "", "height=270px,width=600px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
        }
    }
    var aprgongramline_cross_dialogArguments = new Array();
    function btnSendAround_onclick() {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();
        if (selRow.length != 0) {
            var para = new Array();
            para[0] = DocID;
            var url = "/myoffice/ezApprovalG/ReceivUI/AprGongRamLine_Cross.aspx?type=END";

            aprgongramline_cross_dialogArguments[0] = para;
            aprgongramline_cross_dialogArguments[1] = btnSendAround_onclick_Complete;

            var OpenWin = window.open(url, "AprGongRamLine_Cross", GetOpenWindowfeature(1000, 740));
            try { OpenWin.focus(); } catch (e) { }
        }
    }

    function btnSendAround_onclick_Complete(rtn) {
        if (rtn == "OK") {
            var pAlertContent = "<spring:message code='ezApprovalG.t1424'/>";
            OpenAlertUI(pAlertContent);
        }
    }

    // START
    var ezSelectSusin_Cross_dialogArguments = new Array();
    function btnReSend_onclick() {
        if (UserID.toLowerCase() != WriterID.toLowerCase()) {
            var InformationString = "<spring:message code='ezApprovalG.t928'/>";
            OpenAlertUI(InformationString);
            return;
        }
        if (CheckFormConnFlag(DocID)) {
            var InformationString = "<spring:message code='ezApprovalG.t929'/>";
            OpenAlertUI(InformationString);
            return;
        }
        var parameter = new Array();
        parameter[0] = DocID;
        parameter[1] = "";

        ezSelectSusin_Cross_dialogArguments[0] = parameter;
        ezSelectSusin_Cross_dialogArguments[1] = btnReSend_onclick_Complete;

        var url = "/myoffice/ezApprovalG/enforce/ezSelectSusin_Cross.aspx";
        
        var OpenWin = window.open(url, "ezSelectSusin_Cross", GetOpenWindowfeature(750, 650));
        try { OpenWin.focus(); } catch (e) { }

       
    }
    function btnReSend_onclick_Complete(rtn)
    {
        if (rtn[0] != "CANCEL") {
            var xmlhttp = createXMLHttpRequest();
            xmlhttp.open("POST", "../enforce/aspx/resendEndDoc.aspx", false);
            xmlhttp.send(rtn[1]);
        }
        return;
    }
    // END

    var ezreceivedistributeui_cross_dialogArguments = new Array();
    function btnBaeBu_onclick() {
        if (DocID == "") {
            var pAlertContent = "<spring:message code='ezApprovalG.t99991'/>";
            OpenAlertUI(pAlertContent);
            return;
        }
        var xmlpara = createXmlDom();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "DOCID", DocID);

        xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/getCheckEndHref.aspx", false);
        xmlhttp.send(xmlpara);

        if (SelectSingleNodeValue(xmlhttp.responseXML, "RESULT") == "TRUE") {
            var pAlertContent = "수신완료처리된 문서입니다.<BR>추가이송 할수 없습니다.";
            OpenAlertUI(pAlertContent);
            return;
        }

        var parameter = new Array();
        parameter[0] = DocID;
        parameter[1] = "1";
        parameter[2] = arr_userinfo[4];
        parameter[3] = "011";
        parameter[4] = arr_userinfo[4];

        var url = "/myoffice/ezApprovalG/ezAPRRECEIVE/ezReceiveDistributeUI_Cross.aspx?mode=add&pdocid=" + DocID;

        ezreceivedistributeui_cross_dialogArguments[0] = parameter;
        ezreceivedistributeui_cross_dialogArguments[1] = btnBaeBu_onclick_Complete;

        var OpenWin = window.open(url, "ezReceiveDistributeUI_Cross", GetOpenWindowfeature(1000, 740));
        try { OpenWin.focus(); } catch (e) { }
    }

    function btnBaeBu_onclick_Complete(ret) {
        if (ret == "true") {
            var pAlertContent = "<spring:message code='ezApprovalG.t1419'/>";
            OpenAlertUI(pAlertContent);
        }
        idistbox_onclick();
    }

    function TotalSave_onclick() {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var tr = DocList.GetSelectedRows();

        if (tr.length == 0) {
            OpenAlertUI("<spring:message code='ezApprovalG.t113'/>");
        }
        else {
            if (DocList_Flag == "RECORD") {
                if (AdminYN != "TRUE" && (!g_bRecAdmin)) {
                    if (!HasRecReadRight(trim_Cross(tr[0].getAttribute("DATA6")), trim_Cross(tr[0].getAttribute("DATA8")), UserID)) {
                        OpenAlertUI(strLang580);
                        return "";
                    }
                }
                if (tr[0].getAttribute("DATA8") != "00") {
                    OpenAlertUI(strLang260);
                    return "";
                }
            }
            pDocID = tr[0].getAttribute("DATA1");
        }

        var url = "../TotalSaveFileInfo.aspx?docid=" + pDocID + "&type=END";
        var feature = "status=no,help=no,scroll=no,edge=sunken,width=600px,height=450px";
        feature = feature + GetOpenPosition(600, 450);
        window.open(url, "", feature);
    }

    window.onresize = function () {
        var height = parseInt(divList.style.height.replace('px', '')) + 200;
        var reheight = window.innerHeight - parseInt(height);
        document.getElementById('div_AprLine').style.height = reheight + "px";
    };
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
            pageNum = 1;
        }
        else {
            alert("<spring:message code='ezApprovalG.t1160'/>");
            return;
        }

        if (document.getElementById("trRecSubMenu").style.display == "") {
            var radiosearch = document.getElementsByName('searchCheck');

            if (radiosearch.item(0).checked) {
                g_RecSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + DeptID + "</DEPTCODE><TITLE>" + document.getElementById("txt_keyword").value + "</TITLE><REGTYPE></REGTYPE><SREGDATE></SREGDATE><EREGDATE></EREGDATE><CHARGER></CHARGER><SC></SC><TRANSEXPIRE/><DRAFTER></DRAFTER><CABTITLE></CABTITLE></SEARCHPARAM>";
            }
            else if (radiosearch.item(1).checked) {
                g_RecSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + DeptID + "</DEPTCODE><TITLE></TITLE><REGTYPE></REGTYPE><SREGDATE></SREGDATE><EREGDATE></EREGDATE><CHARGER></CHARGER><SC></SC><TRANSEXPIRE/><DRAFTER>" + document.getElementById("txt_keyword").value + "</DRAFTER><CABTITLE></CABTITLE></SEARCHPARAM>";
            }
            switch (ListTypeFlag) {
                case "2":
                    GetTransListXml("P02");
                    break;

                case "3":
                    GetTransListXml("T02");
                    break;

                case "4":
                    GetTransListXml("T02");
                    break;

                default:
                    GetRecordListXml();
            }
        }
        else if (document.getElementById("trCabSubMenu").style.display == "") {
            var radiosearch = document.getElementsByName('searchCheck');

            if (radiosearch.item(0).checked) {
                g_CabSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + DeptID + "</DEPTCODE><TITLE>" + document.getElementById("txt_keyword").value + "</TITLE><TASKCODE></TASKCODE><SPRODUCEY></SPRODUCEY><EPRODUCEY></EPRODUCEY><SENDY></SENDY><EENDY></EENDY><RECTYPECODE></RECTYPECODE><KEEPPERIOD></KEEPPERIOD><KEEPMETHOD></KEEPMETHOD><KEEPPLACE></KEEPPLACE><CHARGER></CHARGER><TRANSEXPIRE/><TRANSFLAG/><RECEIVEDCAB/><GIVECAB/></SEARCHPARAM>";
            }
            else if (radiosearch.item(1).checked) {
                g_CabSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + DeptID + "</DEPTCODE><TITLE></TITLE><TASKCODE></TASKCODE><SPRODUCEY></SPRODUCEY><EPRODUCEY></EPRODUCEY><SENDY></SENDY><EENDY></EENDY><RECTYPECODE></RECTYPECODE><KEEPPERIOD></KEEPPERIOD><KEEPMETHOD></KEEPMETHOD><KEEPPLACE></KEEPPLACE><CHARGER>" + document.getElementById("txt_keyword").value + "</CHARGER><TRANSEXPIRE/><TRANSFLAG/><RECEIVEDCAB/><GIVECAB/></SEARCHPARAM>";
            }

            switch (ListTypeFlag) {
                case "2":
                    GetTransListXml("P01");
                    break;

                case "3":
                    GetTransListXml("T01");
                    break;

                case "4":
                    g_CabSearchParamXml = "<SEARCHPARAM><TRANSFLAG>16=0</TRANSFLAG></SEARCHPARAM>";
                    GetTransListXml("T01");
                    break;
                default:
                    GetCaninetListXml();
            }
        }
        else {
            var radiosearch = document.getElementsByName('searchCheck');

            if (radiosearch.item(0).checked) {
                g_DeliverySearchParamXml = "<SEARCHPARAM><DEPTCODE></DEPTCODE><DEPTCODE2>" + DeptID + "</DEPTCODE2><TITLE>" + document.getElementById("txt_keyword").value + "</TITLE><SREGDATE></SREGDATE><EREGDATE></EREGDATE><DEBENTURER></DEBENTURER></SEARCHPARAM>";
            }
            else if (radiosearch.item(1).checked) {
                g_DeliverySearchParamXml = "<SEARCHPARAM><DEPTCODE></DEPTCODE><DEPTCODE2>" + DeptID + "</DEPTCODE2><TITLE></TITLE><SREGDATE></SREGDATE><EREGDATE></EREGDATE><DEBENTURER>" + document.getElementById("txt_keyword").value + "</DEBENTURER></SEARCHPARAM>";
            }

            GetDocDeliveryList(g_DeliverySearchParamXml);
        }


        $('#sel_year').val("ALL");
        $('#sel_year').selectmenu('refresh');
    }

    </script>
</head>
<body class="mainbody" style="margin-top: 0px">
    <h1><span id="imgTitle"></span>&nbsp;<span id="TitleInfo" style="color:#666;font-weight:normal;"></span>
        <span style="float:right;font-weight:normal;color:black;">
            <input name="searchCheck" id="Radio1" type="radio" value="rad_Subject" checked style="margin:0px;padding:0px;width:13px;height:13px; "><spring:message code='ezApprovalG.t106'/>
	        <input name="searchCheck" id="Radio2" type="radio" value="rad_Writer" style="margin:0px;padding:0px;width:13px;height:13px; "><span id="searchwriter"><spring:message code='ezApprovalG.t445'/></span>
	        &nbsp;
	        <input id="txt_keyword" style="width:150px;" onkeypress="onkeydown_start_search();" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
            <a href="#"><img src="/images/sub/bsearch.gif" border="0" style="vertical-align:middle" onClick="search()"></a>
        </span>
    </h1>



    <div id="mainmenu">
        <ul id="trCabSubMenu" style="Display: None;">
            <li id="tdReqDelayEndY" style="Display: None"><span id="ReqDelayEndY" onclick="return ReqDelayEndY_onclick()">
                <spring:message code='ezApprovalG.t907'/></span></li>
            <li id="tdCancelDelayEndY" style="Display: None"><span id="CancelDelayEndY" onclick="return CancelDelayEndY_onclick()">
                <spring:message code='ezApprovalG.t930'/></span></li>
            <li id="tdbtnEndProduce" style="Display: None"><span id="btnEndProduce" onclick="return btnEndProduce_onclick()">
                <spring:message code='ezApprovalG.t931'/></span></li>
            <li id="tdbtnCancelEndProd" style="Display: None"><span id="btnCancelEndProd" onclick="return btnCancelEndProd_onclick()">
                <spring:message code='ezApprovalG.t932'/></span></li>
            <li id="tdbtnViewRecList"><span id="btnViewRecList" onclick="return btnViewRecList_onclick()">
                <spring:message code='ezApprovalG.t526'/></span></li>
            <li id="tbar1" style="background: none; padding-right: 2px;">
                <img src="/images/i_bar.gif"></li>
            <li id="tdRegCabinet" style="Display: None"><span id="RegCabinet" onclick="return btnRegCabinet_onclick()"><spring:message code='ezApprovalG.t2002'/></span></li>
            <li id="tdNewVol" style="Display: None"><span id="NewVol" onclick="return btnNewVolume_onclick()"><spring:message code='ezApprovalG.t894'/></span></li>
            <li id="tdSetCharger" style="Display: None"><span id="SetCharger" onclick="return btnSetTaskCharger_onclick()"><spring:message code='ezApprovalG.t937'/></span></li>
            <li id="tdViewCabInfo"><span id="ViewCabInfo" onclick="return btnViewCabInfo_onclick()"><spring:message code='ezApprovalG.t527'/></span></li>
            <li id="tdViewCabHist" style="Display: None"><span id="ViewCabHist" onclick="return btnViewCabHistory_onclick()"><spring:message code='ezApprovalG.t529'/></span></li>
            <li id="tbar2" style="background: none; padding-right: 2px;">
                <img src="/images/i_bar.gif"></li>
            <li id="tdModifyCab" style="Display: None"><span id="ModifyCab" onclick="return btnChangeCabinetInfo_onclick()"><spring:message code='ezApprovalG.t269'/></span></li>
            <li id="tdSearchCab"><span id="SearchCab" onclick="return SearchCabinet('0')"><spring:message code='ezApprovalG.t111'/></span></li>
            <li id="tdDocListPrint"><span id="DocListPrintRec" onclick="return DocListPrinter_onclick()"><spring:message code='ezApprovalG.t530'/></span></li>
            <li style="background: none; padding-right: 2px;"><img src="/images/i_bar.gif"></li>
            <select id="cab_year" name="cab_year" style="width:70px;" onchange="onSelect_Year(this);">    
                <option value="ALL">ALL</option>
            </select>  
        </ul>

        <ul id="trRecSubMenu" style="Display: none;">
            <li id="tdichange_Rec"><span id="ichange_Rec" onclick="return ichange_onclick()">
               <spring:message code='ezApprovalG.t939'/></span></li>
            <li id="tdReSend"><span id="ReSend" onclick="return btnReSend_onclick()">
                <spring:message code='ezApprovalG.t940'/></span></li>
            <li id="tbar3" style="background: none; padding-right: 2px;">
                <img src="/images/i_bar.gif"></li>
            <li id="tdCabSelect"><span id="CabSelect" onclick="return CabinetSelect_onclick()"><spring:message code='ezApprovalG.t941'/></span></li>
            <li id="tdRegRecord" style="Display: None"><span id="RegRecord" onclick="return btnRegRecord_onclick()"><spring:message code='ezApprovalG.t933'/></span></li>
            <li id="tdRegSepAtt" style="Display: None"><span id="RegSepAtt" onclick="return btnRegAttach_onclick()"><spring:message code='ezApprovalG.t942'/></span></li>
            <li id="tdbtnCardSend" style="Display: None"><span id="btnCardSend" onclick="return btnCardSend_onclick()"><spring:message code='ezApprovalG.t943'/></span></li>
            <li id="tdbtnSetRecRole" style="Display: None"><span id="btnSetRecRole" onclick="return btnSetRecUserRole_onclick()"><spring:message code='ezApprovalG.t944'/></span></li>
            <li id="tdbtnViewRecReadHist" style="Display: None"><span id="btnViewRecReadHist" onclick="return btnViewRecReadHist_onclick()"><spring:message code='ezApprovalG.t945'/></span></li>
            <li id="tDocInfo"><span id="DocInfo" onclick="return GongRamDocInfo()"><spring:message code='ezApprovalG.t946'/></span></li>
            <li id="tdViewRecInfo"><span id="ViewRecInfo" onclick="return btnViewRecInfo_onclick()"><spring:message code='ezApprovalG.t527'/></span></li>
            <li id="tdVeiwRecHist" style="Display: None"><span id="VeiwRecHist" onclick="return btnViewRecHistory_onclick()"><spring:message code='ezApprovalG.t947'/></span></li>
            <li id="tbar4" style="background: none; padding-right: 2px;">
                <img src="/images/i_bar.gif"></li>
            <li id="tdMoveRec" style="Display: None"><span id="MoveRec" onclick="return btnChangeRecCabinet_onclick()"><spring:message code='ezApprovalG.t948'/></span></li>
            <li id="tdModifyRec" style="Display: None"><span id="ModifyRec" onclick="return btnChangeRecInfo_onclick()"><spring:message code='ezApprovalG.t269'/></span></li>
            <li id="tdSearchRec"><span id="SearchRec" onclick="return btnSearchRec_onclick(0,'OPEN')"><spring:message code='ezApprovalG.t111'/></span></li>
            <li id="tdGongRam"><span id="GongRam" onclick="return btnSendAround_onclick()"><spring:message code='ezApprovalG.t1428'/></span></li>
            <li id="tdDocListPrint"><span id="DocListPrintRec" onclick="return DocListPrinter_onclick()"><spring:message code='ezApprovalG.t530'/></span></li>
            <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
            <li style="background: none; padding-right: 2px;"><img src="/images/i_bar.gif"></li>
            <select id="rec_year" name="rec_year" style="width:70px;" onchange="onSelect_Year(this);">    
                <option value="ALL">ALL</option>
            </select>    
        </ul>

        <ul id="trDeliveryMenu" style="display: none">
            <li id="tbSearchDelivery"><span id="SearchDelivery" onclick="return btnSearchDelivery_onclick()"><spring:message code='ezApprovalG.t111'/></span></li>
            <li id="Li1"><span id="Span1" onclick="return DocListPrinter_onclick()"><spring:message code='ezApprovalG.t530'/></span></li>
            <li id="tbnBaeBu"><span id="Span2" onclick="return btnBaeBu_onclick()"><spring:message code='ezApprovalG.t100000'/></span></li>
            <li style="background: none; padding-right: 2px;"><img src="/images/i_bar.gif"></li>
            <select id="del_year" name="del_year" style="width:70px;" onchange="onSelect_Year(this);">    
                <option value="ALL">ALL</option>
            </select>    
        </ul>
    </div>
    <div class="div_scroll" style="width: 100%; HEIGHT: 310px; overflow: AUTO" id="divList">
        <div id="lvtDoclist"></div>
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

    <div id="tdDebug"></div>

</body>
</html>
