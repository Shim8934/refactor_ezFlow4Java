<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><spring:message code='ezApprovalG.t1043'/></title>
<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/RegRecord_Cross.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/CabinetInfo_Cross.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/RecordInfo_Cross.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/InitSCPopup_Cross.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/getDocAttach_Cross.js"></script>
<script type="text/javascript" src="/js/escapenew.js"></script>
<script type="text/javascript" src="/js/jquery/jquery.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-ui.js"></script>
<link rel="stylesheet" href="/js/jquery/jquery-ui.css">
<link rel="stylesheet" href="/js/jquery/jquery-ui.min.css">
<script type="text/javascript" ID="clientEventHandlersJS">
    var g_VisualAudioFlag="0";
    var g_NodesRcdgAVType=null;
    var g_NodesPhotoAVType=null;
    var rtnVal = new Array();
    var xmlhttp = createXMLHttpRequest();
    var pUserID = "<c:out value = '${userInfo.id}' />";
    var CompanyID = "<c:out value = '${userInfo.companyID}' />";
    var arr_userinfo = new Array();
    arr_userinfo[0]  = "user";								
    arr_userinfo[1]  = "<c:out value = '${userInfo.id} '/>";            
    arr_userinfo[2]  = "<c:out value = '${userInfo.displayName1} '/>";        
    arr_userinfo[3]  = "<c:out value = '${userInfo.title1} '/>";
    arr_userinfo[4]  = "<c:out value = '${userInfo.deptID} '/>";
    arr_userinfo[5]  = "<c:out value = '${userInfo.deptName1} '/>";
    arr_userinfo[6]  = "<c:out value = '${userInfo.jikChek} '/>";
    arr_userinfo[8]  = "<c:out value = '${userInfo.email} '/>";            
    arr_userinfo[9]  = CompanyID;
    arr_userinfo[11]  = "<c:out value = '${userInfo.displayName1} '/>";
    arr_userinfo[12]  = "<c:out value = '${userInfo.displayName2} '/>";
    arr_userinfo[13]  = "<c:out value = '${userInfo.title1} '/>";
    arr_userinfo[14]  = "<c:out value = '${userInfo.title2} '/>";
    arr_userinfo[15]  = "<c:out value = '${userInfo.deptName1} '/>";
    arr_userinfo[16]  = "<c:out value = '${userInfo.deptName2} '/>";		
    var UserLang = "${userInfo.lang}";
    var pUserID			= arr_userinfo[1];
    var pUserName		= arr_userinfo[2];
    var pUserJobTitle	= arr_userinfo[3];
    var pDeptID			= arr_userinfo[4];
    var pDeptName		= arr_userinfo[5];
    var pDocID =""; 
    var pDocSN = "0";
    var NonActiveX = "YES";
    window.onload = function () {
        var ua = navigator.userAgent;
        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
            KeEventControl(document.getElementById("txtTitle"));
            KeEventControl(document.getElementById("txtRegY"));
            KeEventControl(document.getElementById("txtRegM"));
            KeEventControl(document.getElementById("txtRegD"));
            KeEventControl(document.getElementById("txtRegH"));
            KeEventControl(document.getElementById("txtRegMi"));
            KeEventControl(document.getElementById("txtTotalPage"));
            KeEventControl(document.getElementById("txtAprMemberTitle"));
            KeEventControl(document.getElementById("txtDrafter"));
            KeEventControl(document.getElementById("txtExeY"));
            KeEventControl(document.getElementById("txtExeM"));
            KeEventControl(document.getElementById("txtExeD"));
            KeEventControl(document.getElementById("txtReceiptMember"));
            KeEventControl(document.getElementById("txtDeliveryNo"));
            KeEventControl(document.getElementById("txtOriginSN"));
            KeEventControl(document.getElementById("txtLimitRange"));
            KeEventControl(document.getElementById("txtSummary"));
        }

        if (window.dialogArguments != null) {
            var objWinDlgArgs = window.dialogArguments;
        }

        g_CabListXml = "";
        ListTypeFlag = "0"

        rtnVal[0] = "FALSE";
        InitCode();

        if (g_CabListXml != "") {
            InitCabinetInfo();
        }
        else {
            btnChangeCabinet_onclick();
        }

        selRegisterType_onchange();

        rdoSecType_onclick("1");
    }
    function KeEventControl(obj) {
        useragt = navigator.userAgent.toUpperCase();
        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) //사파리 브라우저일 경우
        {
            return;
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
    function cmdCancel_onclick() {
        rtnVal[0] = "FALSE";
        window.returnValue = rtnVal;
        window.close();
    }
    function CheckInputField() {
        var pRegType = selRegisterType.value;
        if (typeof (g_CabID) == "undefined") {
            alert("<spring:message code='ezApprovalG.t513'/>");
            return false;
        }

        if (g_CabID == "") {
            alert("<spring:message code='ezApprovalG.t513'/>");
            return false;
        }

        if (selRegisterType.value == "") {
            alert("<spring:message code='ezApprovalG.t1044'/>");
            return false;
        }

        if (txtTitle.value == "") {
            alert("<spring:message code='ezApprovalG.t955'/>");
            return false;
        }

        if (txtRegY.value == "" || txtRegD.value == "" || txtRegM.value == "") {
            alert("<spring:message code='ezApprovalG.t1045'/>");
            return false;
        }

        if (!ValidateYearValue(txtRegY.value)) {
            alert("<spring:message code='ezApprovalG.t1046'/>");
            return false;
        }

        if (!ValidateNumber(txtRegM.value)) {
            alert("<spring:message code='ezApprovalG.t1047'/>");
            return false;
        }

        if (!ValidateNumber(txtRegD.value)) {
            alert("<spring:message code='ezApprovalG.t1048'/>");
            return false;
        }

        if (!ValidateNumber(txtRegH.value)) {
            alert("<spring:message code='ezApprovalG.t1049'/>");
            return false;
        }

        if (!ValidateNumber(txtRegMi.value)) {
            alert("<spring:message code='ezApprovalG.t1050'/>");
            return false;
        }

        if (!ValidateYearValue(txtExeY.value)) {
            alert("<spring:message code='ezApprovalG.t1051'/>");
            return false;
        }

        if (!ValidateNumber(txtExeM.value)) {
            alert("<spring:message code='ezApprovalG.t1052'/>");
            return false;
        }

        if (!ValidateNumber(txtExeD.value)) {
            alert("<spring:message code='ezApprovalG.t1053'/>");
            return false;
        }

        if (pRegType == "1")
        {
            if (txtAprMemberTitle.value == "") {
                alert("<spring:message code='ezApprovalG.t1054'/>");
                return false;
            }
        }

        if (txtDrafter.value == "") {
            alert("<spring:message code='ezApprovalG.t1055'/>");
            return false;
        }

        if (pRegType == "2" || pRegType == "4" || pRegType == "8")
        {
            if (txtReceiptMember.value == "") {
                alert("<spring:message code='ezApprovalG.t1056'/>");
                return false;
            }
        }

        if (pRegType == "2" || pRegType == "4")
        {
            if (txtOriginSN.value == "") {
                alert("<spring:message code='ezApprovalG.t1057'/>");
                return false;
            }
        }

        if (pRegType == "5" || pRegType == "6")
        { 
            if (txtSummary.value == "") {
                alert("<spring:message code='ezApprovalG.t1058'/>");
                return false;
            }

            if (GetAVTypeCode() == "") {
                alert("<spring:message code='ezApprovalG.t1059'/>");
                return false;
            }
        }

        if (!ValidateNumber(txtTotalPage.value)) {
            alert("<spring:message code='ezApprovalG.t1060'/>");
            return false;
        }

        if (txtTotalPage.value.length > 3) {
            alert("<spring:message code='ezApprovalG.t1061'/>");
            return false;
        }

        return true;
    }
    function cmdConfirm_onclick() {
        if (CheckInputField()) {
            if (pDocID == "")
                pDocID = createNewDocID();

            if (RegisterRecord()) {
                rtnVal[0] = "TRUE";
                rtnVal[1] = g_CabListXml;
                window.opener.GetRecordList();
                window.close();
            }
        }
    }
    function btnFileAttach_onclick() {
        try {
            if (pDocID == "") {
                pDocID = createNewDocID();
            }

            var ret = openFileAttachUI();
        }
        catch (e) {
            alert("btnFileAttach_onclick : " + e.description);
        }
    }
    function createNewDocID() {
        try {
            var objRoot;
            var objNode;

            var xmlpara = createXmlDom()
            var xmlhttp = createXMLHttpRequest();

            var objNode;
            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "docID", "");

            xmlhttp.open("POST", "/ezApprovalG/createNewDocId.do", false);
            xmlhttp.send(xmlpara);

            if (xmlhttp.responseText == "") {
                alert(strLang131);
            }
            else {
                return xmlhttp.responseText;
            }
        }
        catch (e) {
            alert("createNewDoc()" + e.description);
        }
    }
    function openFileAttachUI() {
        try {
            DivPopUpShow(570, 285, "/ezApprovalG/regRecordAttach.do?docID=" + pDocID);
        }
        catch (e) {
            alert("openFileAttachUI()" + e.description);
        }
    }

    window.onbeforeunload = function () {
        window.returnValue = rtnVal;

        if (pDocID != "")
            Del_DocAttach();
    }
    function Del_DocAttach() {
        try {
            var objRoot;
            var objNode;

            var xmlpara = createXmlDom();
            var xmlhttp = createXMLHttpRequest();

            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "docid", pDocID);

            xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/API_DelAttach.aspx", false);
            xmlhttp.send(xmlpara);
        }
        catch (e) {
            alert("createNewDoc()" + e.description);
        }
    }
    function selRegisterType_onchange() {
        var Val = selRegisterType.value;
        
        if (Val == "5" || Val == "6") {
            divAudioVisualDummy.style.display = "none";
            divAudioVisual.style.display = "";
            g_VisualAudioFlag = "1";


            if (Val == 5) {
                if (CrossYN() || NonActiveX == "YES")
                    window.resizeTo(880, 780);
                InitAVTypeTD(g_NodesPhotoAVType, tdAVType, "");
            }
            else if (Val == 6) {
                if (CrossYN() || NonActiveX == "YES")
                    window.resizeTo(880, 810);
                InitAVTypeTD(g_NodesRcdgAVType, tdAVType, "");
            }
        }
        else {
            divAudioVisualDummy.style.display = "";
            divAudioVisual.style.display = "none";
            g_VisualAudioFlag = "0";

            if (Val == "1" || Val == "3" || Val == "5" || Val == "6")
            {
                if (CrossYN() || NonActiveX == "YES")
                    window.resizeTo(880, 710);

                trDeliveryNo.style.display = "none";
                trOriginSN.style.display = "none";
                trAprMemberTitle.style.display = "";
            }
            else if (Val == "2" || Val == "4")
            {
                if (CrossYN() || NonActiveX == "YES")
                    window.resizeTo(880, 710);

                trDeliveryNo.style.display = "";
                trOriginSN.style.display = "";
                trAprMemberTitle.style.display = "none";
            }
            else {
                if (CrossYN() || NonActiveX == "YES")
                    window.resizeTo(880, 720);

                trDeliveryNo.style.display = "";
                trOriginSN.style.display = "";
                trAprMemberTitle.style.display = "";
            }
        }
    }
    var g_SepAttachLVXml = "";
    var inssepattach_cross_dialogArguments = new Array();
    function btnAddSepAttach_onclick() {
        if (g_CabID != "") {
            var para = new Array();
            para[0] = g_SepAttachLVXml;
            para[1] = g_CabID;

            var url = "/ezApprovalG/insSepAttach.do";

            inssepattach_cross_dialogArguments[0] = para;
            inssepattach_cross_dialogArguments[1] = btnAddSepAttach_onclick_Complete;

            DivPopUpShow(730, 630, url);
        }
        else
        {
            alert("<spring:message code='ezApprovalG.t1062'/>");
            btnChangeCabinet_onclick();
        }
    }

    function btnAddSepAttach_onclick_Complete(rtn) {
        DivPopUpHidden();
        if (rtn[0] == "TRUE") {
            g_SepAttachLVXml = rtn[1];
        }
    }
    function GetSepAttParamXml() {
        var rtnXml = createXmlDom();

        var objRoot, objNode, subNode;

        objRoot = createNodeInsert(rtnXml, objRoot, "SEPATTACHINFO");

        var sepAtt, Data, i;
        if (g_SepAttachLVXml != "") {
            var sepLVXml = createXmlDom();
            sepLVXml = loadXMLString(g_SepAttachLVXml);

            var rows = SelectNodes(sepLVXml, "LISTVIEWDATA/ROWS/ROW")

            for (i = 0; i < rows.length; i++) {
                objNode = createNodeAndAppandNode(sepLVXml, objRoot, objNode, "SEPATTACH");
                createNodeAndAppandNodeText(sepLVXml, objNode, subNode, "CABINETID", getNodeText(rows[i].getElementsByTagName("DATA1")[0]));
                createNodeAndAppandNodeText(sepLVXml, objNode, subNode, "TITLE", getNodeText(GetChildNodes(rows[i])[1]));
                createNodeAndAppandNodeText(sepLVXml, objNode, subNode, "NUMOFPAGE", getNodeText(GetChildNodes(rows[i])[4]));
                createNodeAndAppandNodeText(sepLVXml, objNode, subNode, "REGTYPE", getNodeText(rows[i].getElementsByTagName("DATA2")[0]));
                createNodeAndAppandNodeText(sepLVXml, objNode, subNode, "SUMMARY", getNodeText(GetChildNodes(rows[i])[6]));
                createNodeAndAppandNodeText(sepLVXml, objNode, subNode, "AVTYPE", getNodeText(rows[i].getElementsByTagName("DATA3")[0]));
            }
        }
        return rtnXml;
    }
    function MM_swapImgRestore() {
        var i, x, a = document.MM_sr; for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++) x.src = x.oSrc;
    }
    function MM_preloadimages() {
        var d = document; if (d.images) {
            if (!d.MM_p) d.MM_p = new Array();
            var i, j = d.MM_p.length, a = MM_preloadimages.arguments; for (i = 0; i < a.length; i++)
                if (a[i].indexOf("#") != 0) { d.MM_p[j] = new Image; d.MM_p[j++].src = a[i]; }
        }
    }
    function MM_findObj(n, d) {
        var p, i, x; if (!d) d = document; if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
            d = parent.frames[n.substring(p + 1)].document; n = n.substring(0, p);
        }
        if (!(x = d[n]) && d.all) x = d.all[n]; for (i = 0; !x && i < d.forms.length; i++) x = d.forms[i][n];
        for (i = 0; !x && d.layers && i < d.layers.length; i++) x = MM_findObj(n, d.layers[i].document); return x;
    }
    function MM_swapImage() {
        var i, j = 0, x, a = MM_swapImage.arguments; document.MM_sr = new Array; for (i = 0; i < (a.length - 2) ; i += 3)
            if ((x = MM_findObj(a[i])) != null) { document.MM_sr[j++] = x; if (!x.oSrc) x.oSrc = x.src; x.src = a[i + 2]; }
    }
</SCRIPT>
</head>
<body class="popup">
<h1 style="height:30px;"><spring:message code='ezApprovalG.t1043'/></h1>
<h2><spring:message code='ezApprovalG.t1018'/></h2>
<table style="width:100%" class="content" >
  <tr>
    <th><b><spring:message code='ezApprovalG.t1063'/></b></th>
    <td style="padding-right:15px;white-space:nowrap"><table style="width:100%">
        <tr>
          <td id="tdCabinetName">&nbsp;</td>
          <td style="width:70px"><a  class="imgbtn"><span onClick="return btnChangeCabinet_onclick()" style=""><spring:message code='ezApprovalG.t1064'/></span></a></td>
        </tr>
      </table></td>
    <th><spring:message code='ezApprovalG.t572'/></th>
    <td id="tdCabinetSN" style="padding-right:15px;width:300px;white-space:nowrap">&nbsp;</td>
  </tr>
  <tr>
    <th><b><spring:message code='ezApprovalG.t1065'/></b></th>
    <td id="tdCabinetType" style="padding-right:15px;white-space:nowrap">&nbsp;</td>
    <th ><spring:message code='ezApprovalG.t573'/></th>
    <td id="tdCabinetVolNo" style="padding-right:15px;white-space:nowrap">&nbsp;</td>
  </tr>
</table>
<table style="width:100%">
  <tr>
    <td style="vertical-align:top"><table>
        <tr>
          <td style="vertical-align:top;width:100%"><h2><spring:message code='ezApprovalG.t1066'/></h2>
            <table style="width:100%" id="tbBasicInfo" class="content" >
              <tr>
                <th><spring:message code='ezApprovalG.t859'/></th>
                <td>
                	<select id="selRegisterType" style="width:150px" onChange="return selRegisterType_onchange()" name="select">
                    </select>
                </td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t1067'/></th>
                <td><input type="text" name="txtTitle" id="txtTitle" class="text" style="Width:98%;">
                </td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t831'/></th>
                <td><input type="text" class="text" style="height:16px;padding:0px;margin:0px;" value="${regY}" name="txtRegY" id="txtRegY" maxlength = "4" size="4">
                  <span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t456'/></span>
                  <input type="text" class="text" style="Width:25px;height:16px;padding:0px;margin:0px;" value="${regM}" name="txtRegM"  id="txtRegM" maxlength = "2" size="2">
                  <span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t968'/></span>
                  <input type="text" class="text" style="Width:25px;height:16px;padding:0px;margin:0px;" value="${regD}" name="txtRegD"  id="txtRegD" maxlength = "2" size="2">
                  <span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t662'/></span>
                  <input type="text" class="text" style="height:16px;padding:0px;margin:0px;"value="${regH}" name="txtRegH"  id="txtRegH" maxlength = "2" size="2">
                  <span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t977'/></span>
                  <input type="text" class="text" style="height:16px;padding:0px;margin:0px;" value="${regMi}"  name="txtRegMi"  id="txtRegMi" maxlength = "2" size="2">
                  <span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t1068'/></span></td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t979'/></th>
                <td><input type="text" name="txtTotalPage" id="txtTotalPage" class="text" style="Width:60px;height:16px;padding:0px;margin:0px;">
                &nbsp;<span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t980'/></span></td>
              </tr>
              <tr  id="trAprMemberTitle">
                <th ><spring:message code='ezApprovalG.t862'/></th>
                <td><input type="text" name="txtAprMemberTitle" id="txtAprMemberTitle" class="text" style="Width:98%;">
                </td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t445'/></th>
                <td><input type="text" name="txtDrafter" id="txtDrafter" class="text" style="Width:98%;">
                </td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t863'/></th>
                <td><input type="text" class="text" style="Width:40px;height:16px;padding:0px;margin:0px;" name="txtExeY" id="txtExeY" maxlength = "4">
                  <span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t456'/></span>
                  <input type="text" class="text" style="Width:25px;height:16px;padding:0px;margin:0px;" name="txtExeM"  id="txtExeM" maxlength = "2">
                  <span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t968'/></span>
                  <input type="text" class="text" style="Width:25px;height:16px;padding:0px;margin:0px;" name="txtExeD"  id="txtExeD" maxlength = "2">
                  <span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t662'/></span></td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t864'/></th>
                <td><input type="text" name="txtReceiptMember" id="txtReceiptMember" class="text" style="Width:98%;">
                </td>
              </tr>
              <tr  id="trDeliveryNo">
                <th ><spring:message code='ezApprovalG.t1069'/></th>
                <td><input type="text" name="txtDeliveryNo" id="txtDeliveryNo" class="text" style="Width:98%;" maxlength="6">
                </td>
              </tr>
              <tr  id="trOriginSN">
                <th ><spring:message code='ezApprovalG.t866'/></th>
                <td><input type="text" name="txtOriginSN" id="txtOriginSN" class="text" style="Width:98%;" maxlength="13">
                </td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t94'/></th>
                <td><table border="0" style="width:98%;border-collapse:collapse; border-spacing:0;padding:0px;" >
                    <tr>
                      <td id="tdSpecialFlag">&nbsp;</td>
                      <td style="width:70px"><img src="/images/btn_add.gif" style="display:none;cursor:pointer;vertical-align:middle"id="btnAddSC" onClick="return btnAddSpecialCatalog_onclick()" width="39" height="20"></td>
                    </tr>
                  </table></td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t868'/></th>
                <td style="text-align:left"><input type="radio" name="rdoElectronicFlag" value="1" style="height:13px;width:13px;padding:0px;margin:0px;vertical-align:top;" checked>
                  <span><spring:message code='ezApprovalG.t981'/></span>
                  <input type="radio" name="rdoElectronicFlag" style="height:13px;width:13px;padding:0px;margin:0px;" value="2">
                  <span><spring:message code='ezApprovalG.t1070'/></span></td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t58'/></th>
                <td><a class="imgbtn"><span id="btnAddSepAttach" onClick="return btnAddSepAttach_onclick()" style="" ><spring:message code='ezApprovalG.t949'/></span></a></td>
              </tr>
            </table></td>
          <td style="padding-left:5px;vertical-align:top" ><h2><spring:message code='ezApprovalG.t1071'/></h2>
            <table style="width:<%if("${userInfo.lang}"=="1"){%>375<%}else{%>420<%}%>px"  class="content">
              <tr>
                <th ><spring:message code='ezApprovalG.t875'/></th>
                <td style="width:98%"><input type="checkbox" name="special1" value="checkbox" style="height:13px;width:13px;padding:0px;margin:0px;vertical-align:top;"><span>&nbsp;<spring:message code='ezApprovalG.t983'/></span><br />
                  <input type="checkbox" name="special2" value="checkbox" style="height:13px;width:13px;padding:0px;margin:0px;"><span>&nbsp;<spring:message code='ezApprovalG.t984'/></span><br>
                  <input type="checkbox" name="special3" value="checkbox" style="height:13px;width:13px;padding:0px;margin:0px;"><span>&nbsp;<spring:message code='ezApprovalG.t985'/></span><br />
                  <input type="checkbox" name="special4" value="checkbox" style="height:13px;width:13px;padding:0px;margin:0px;"><span>&nbsp;<spring:message code='ezApprovalG.t986'/></span><br>
                  <input type="checkbox" name="special5" value="checkbox" style="height:13px;width:13px;padding:0px;margin:0px;"><span>&nbsp;<spring:message code='ezApprovalG.t987'/></span></td>
              </tr>
              <tr>
                <th  ><spring:message code='ezApprovalG.t109'/></th>
                <td><input type="radio" name="rdoSecType" value="1" checked onClick="return rdoSecType_onclick(this.value)"  style="height:13px;width:13px;padding:0px;margin:0px;">
                  <span><spring:message code='ezApprovalG.t47'/></span>
                  <input type="radio" name="rdoSecType" value="2" onClick="return rdoSecType_onclick(this.value)"  style="height:13px;width:13px;padding:0px;margin:0px;">
                  <span><spring:message code='ezApprovalG.t150'/></span>
                  <input type="radio" name="rdoSecType" value="3" onClick="return rdoSecType_onclick(this.value)"  style="height:13px;width:13px;padding:0px;margin:0px;">
                  <span><spring:message code='ezApprovalG.t1072'/></span>
                  <select id="selSecLevel" style="width:60px;display:none" name="select2">
                  </select>
                </td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t989'/></th>
                <td><input type="checkbox" name="selSecLevel1" value="checkbox" style="height:13px;width:13px;padding:0px;margin:0px;"><span>&nbsp;1<spring:message code='ezApprovalG.t1768'/></span>
                  <input type="checkbox" name="selSecLevel2" value="checkbox" style="height:13px;width:13px;padding:0px;margin:0px;"><span>&nbsp;2<spring:message code='ezApprovalG.t1768'/></span>
                  <input type="checkbox" name="selSecLevel3" value="checkbox" style="height:13px;width:13px;padding:0px;margin:0px;"><span>&nbsp;3<spring:message code='ezApprovalG.t1768'/></span>
                  <input type="checkbox" name="selSecLevel4" value="checkbox" style="height:13px;width:13px;padding:0px;margin:0px;"><span>&nbsp;4<spring:message code='ezApprovalG.t1768'/></span><br>
                  <input type="checkbox" name="selSecLevel5" value="checkbox" style="height:13px;width:13px;padding:0px;margin:0px;"><span>&nbsp;5<spring:message code='ezApprovalG.t1768'/></span>
                  <input type="checkbox" name="selSecLevel6" value="checkbox" style="height:13px;width:13px;padding:0px;margin:0px;"><span>&nbsp;6<spring:message code='ezApprovalG.t1768'/></span>
                  <input type="checkbox" name="selSecLevel7" value="checkbox" style="height:13px;width:13px;padding:0px;margin:0px;"><span>&nbsp;7<spring:message code='ezApprovalG.t1768'/></span>
                  <input type="checkbox" name="selSecLevel8" value="checkbox" style="height:13px;width:13px;padding:0px;margin:0px;"><span>&nbsp;8<spring:message code='ezApprovalG.t1768'/></span></td>
              </tr>
              <tr>
                <th ><spring:message code='ezApprovalG.t876'/></th>
                <td><input type="text" name="txtLimitRange" id="txtLimitRange" class="text" style="Width:170px;">
                  (<spring:message code='ezApprovalG.t1073'/></td>
              </tr>
            </table>
            <div id="divAudioVisualDummy" style="display:none"> </div>
            <div id="divAudioVisual">
              <h2><spring:message code='ezApprovalG.t1074'/></h2>
              <table style="width:<%if("${userInfo.lang}"=="1"){%>375<%}else{%>410<%}%>px" class="content">
                <tr>
                  <th><spring:message code='ezApprovalG.t1075'/></th>
                  <td><TextArea style="width:96%; height:50px" id=txtSummary name=txtSummary></TextArea>
                  </td>
                </tr>
                <tr>
                  <th><spring:message code='ezApprovalG.t826'/></th>
                  <td>
                  <div id=tdAVType style="overflow:auto;"></div>
                  </td>
                </tr>
              </table>
            </div></td>
        </tr>
        <tr>
            <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
            <td colspan="2" style="height:20px">
                <table class="file">
	                <tr>
		                <th id="btn_Attach" ><spring:message code='ezApprovalG.t65'/></th>
		                <td ><div id="lstAttachLink"></div></td>
	                    <td >
                            <a href="#" class="imgbtn">
                                <span onclick="return btnFileAttach_onclick()"><spring:message code='ezApprovalG.t268'/></span>
                            </a>
                        </td>
	                </tr>
                </table>
            </td>
        </tr>
      </table></td>
  </tr>
</table>
<div class="btnposition">
<a class="imgbtn"><span id="btnOK" onclick="return cmdConfirm_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
<a class="imgbtn"><span id="btnCancel" onclick="return cmdCancel_onclick()"><spring:message code='ezApprovalG.t119'/></span></a>  
</div>
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>
