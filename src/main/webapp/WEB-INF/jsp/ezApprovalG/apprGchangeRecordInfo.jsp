<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezApprovalG.t969'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/RecordInfo_Cross.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/InitSCPopup_Cross.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/OpenAlert_Cross.js"></script>
<script type="text/javascript" ID="clientEventHandlersJS">
    var rtnVal = new Array();
    var g_RecordID, g_SepAttachNo, g_RecordType;
    var g_ModifyFlag;
    var g_UserID, g_UserName;
    var g_ArrPageInitFlag = new Array();
    g_ArrPageInitFlag[0]=false;
    g_ArrPageInitFlag[1]=false;
    var g_szRecInfoXml;
    var g_SCFlag;
    var g_CodeInfoXml,g_bRecAdmin;
    var CompanyID = "${userInfo.companyID}";
    var UserLang = "${userInfo.lang}";
    var RetValue;
    var ReturnFunction;
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
            KeEventControl(document.getElementById("txtChangeReason"));
            KeEventControl(document.getElementById("txtLimitRange"));
        }

        try {
            RetValue = parent.changerecordinfo_cross_dialogArguments[0];
            ReturnFunction = parent.changerecordinfo_cross_dialogArguments[1];
        } catch (e) {
            try {
                RetValue = opener.changerecordinfo_cross_dialogArguments[0];
                ReturnFunction = opener.changerecordinfo_cross_dialogArguments[1];
            } catch (e) {
                RetValue = window.dialogArguments;
            }
        }

        if (RetValue != undefined) {
            g_RecordID = RetValue[0];
            g_SepAttachNo = RetValue[1];
            g_UserID = RetValue[2];
            g_UserName = RetValue[3];
            g_bRecAdmin = RetValue[4];
        }
        InitCode();
        g_szRecInfoXml = GetRecordSimpleInfo(g_RecordID);

        if (g_bRecAdmin)
        {
            selChangeType_onchange();
        }
        else {
            selChangeType.selectedIndex = 1;
            selChangeType_onchange();
            selChangeType.disabled = true;
        }
        rtnVal[0] = "FALSE";
    }
    function InitCode() {
    	
    	var result = "";
    	
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getCodeList.do",
    		data : {
    			companyID : CompanyID
    		},
    		success: function(xml){
    			result = xml;
    		}        			
    	});
    	g_CodeInfoXml = result;
    	  if (SelectSingleNodeValue(result, "RESULT") == "FALSE") {
    		  OpenAlertUI("<spring:message code='ezApprovalG.t952'/>");
    	    }
        else {
        	
        }
    }
    function InitRecordInfo() {
        var objXml = createXmlDom();
        objXml = loadXMLString(g_szRecInfoXml);

        var ManualFlag = getNodeText(objXml.documentElement.getElementsByTagName("MANUALREGFLAG")[0]);

        if (g_SepAttachNo == "00") {
            if (ManualFlag == "1")
                g_RecordType = "1";
            else
                g_RecordType = "0";
        }
        else {
            g_RecordType = "2";
        }

        if (g_RecordType == "2")
        {
            selChangeType.selectedIndex = 0;
            selChangeType.disabled = true;
        }

        if (g_ModifyFlag == "0") {
            if (!g_ArrPageInitFlag[0])
            {
                txtTitle.value = getNodeText(objXml.documentElement.getElementsByTagName("TITLE")[0]);
                var RegDate = getNodeText(objXml.documentElement.getElementsByTagName("REGISTERDATERAW")[0]);

                var reHipon = /-/g;
                var reSemiColon = /:/g;
                var reSpace = / /g;

                RegDate = RegDate.replace(reHipon, "").replace(reSemiColon, "").replace(reSpace, "").replace("<spring:message code='ezApprovalG.t971'/>", "").replace("<spring:message code='ezApprovalG.t972'/>", "");

                if (RegDate.length == 12 || RegDate.length == 14) {
                    txtRegY.value = RegDate.slice(0, 4);
                    txtRegM.value = RegDate.slice(4, 6);
                    txtRegD.value = RegDate.slice(6, 8);
                    txtRegH.value = RegDate.slice(8, 10);
                    txtRegMi.value = RegDate.slice(10, 12);
                }
                else if (RegDate.length == 13) {
                    txtRegY.value = RegDate.slice(0, 4);
                    txtRegM.value = RegDate.slice(4, 6);
                    txtRegD.value = RegDate.slice(6, 8);
                    txtRegH.value = RegDate.slice(8, 9);
                    txtRegMi.value = RegDate.slice(9, 11);
                }
                txtTotalPage.value = getNodeText(objXml.documentElement.getElementsByTagName("NUMOFPAGE")[0]);

                if (UserLang == "1") {
                    txtAprMemberTitle.value = getNodeText(objXml.documentElement.getElementsByTagName("APRMEMBER")[0]);
                    txtAprMemberTitle2.value = getNodeText(objXml.documentElement.getElementsByTagName("APRMEMBER2")[0]);

                    txtDrafter.value = getNodeText(objXml.documentElement.getElementsByTagName("DRAFTER")[0]);
                    txtDrafter2.value = getNodeText(objXml.documentElement.getElementsByTagName("DRAFTER2")[0]);

                    txtReceiptMember.value = getNodeText(objXml.documentElement.getElementsByTagName("RECEIPTMEMBER")[0]);
                    txtReceiptMember2.value = getNodeText(objXml.documentElement.getElementsByTagName("RECEIPTMEMBER2")[0]);
                }
                else {
                    txtAprMemberTitle.value = getNodeText(objXml.documentElement.getElementsByTagName("APRMEMBER2")[0]);
                    txtAprMemberTitle2.value = getNodeText(objXml.documentElement.getElementsByTagName("APRMEMBER")[0]);

                    txtDrafter.value = getNodeText(objXml.documentElement.getElementsByTagName("DRAFTER2")[0]);
                    txtDrafter2.value = getNodeText(objXml.documentElement.getElementsByTagName("DRAFTER")[0]);

                    txtReceiptMember.value = getNodeText(objXml.documentElement.getElementsByTagName("RECEIPTMEMBER2")[0]);
                    txtReceiptMember2.value = getNodeText(objXml.documentElement.getElementsByTagName("RECEIPTMEMBER")[0]);

                }
                var ExeDate = getNodeText(objXml.documentElement.getElementsByTagName("EXECUTEDATE")[0]);
                if (ExeDate.length == 8) {
                    txtExeY.value = ExeDate.slice(0, 4);
                    txtExeM.value = ExeDate.slice(4, 6);
                    txtExeD.value = ExeDate.slice(6, 8);
                }


                var EletronicFlag = getNodeText(objXml.documentElement.getElementsByTagName("ELECTRONICRECFLAG")[0]);
                if (EletronicFlag == "1")
                    document.getElementsByName("rdoElectronicFlag")[0].checked = true;

                SwapInputField();
                g_ArrPageInitFlag[0] = true;
            }
        }
        else {
            if (!g_ArrPageInitFlag[1])
            {
                var SpecialRecCode = getNodeText(objXml.documentElement.getElementsByTagName("SPECIALRECCODE")[0]);
                InitSpecialRecCode(SpecialRecCode);

                var PublicCode = getNodeText(objXml.documentElement.getElementsByTagName("PUBLICCODE")[0]);
                InitPublicCode(PublicCode);

                txtLimitRange.value = getNodeText(objXml.documentElement.getElementsByTagName("LIMITRANGE")[0]);
                g_SCFlag = getNodeText(objXml.documentElement.getElementsByTagName("SPECIALFLAG")[0]);

                if (g_SCFlag == "2")
                {
                    tdSpecialFlag.innerText = "Y";
                    btnAddSC.style.display = "";

                    InitSCInfo_Mod(getNodeText(objXml.documentElement.getElementsByTagName("SCINFO")[0]));
                }
                else {
                    tdSpecialFlag.innerText = "N";
                    btnAddSC.style.display = "none";
                }
                g_ArrPageInitFlag[1] = true;
            }
        }
    }
    function SwapInputField() {
        switch (g_RecordType) {
            case "0":
                txtTitle.disabled = true;
                txtTitle.style.backgroundColor = "#E5E5E5";

                txtRegY.disabled = true;
                txtRegY.style.backgroundColor = "#E5E5E5";
                txtRegM.disabled = true;
                txtRegM.style.backgroundColor = "#E5E5E5";
                txtRegD.disabled = true;
                txtRegD.style.backgroundColor = "#E5E5E5";
                txtRegH.disabled = true;
                txtRegH.style.backgroundColor = "#E5E5E5";
                txtRegMi.disabled = true;
                txtRegMi.style.backgroundColor = "#E5E5E5";

                txtAprMemberTitle.disabled = true;
                txtAprMemberTitle.style.backgroundColor = "#E5E5E5";

                txtDrafter.disabled = true;
                txtDrafter.style.backgroundColor = "#E5E5E5";

                txtExeY.disabled = true;
                txtExeY.style.backgroundColor = "#E5E5E5";
                txtExeM.disabled = true;
                txtExeM.style.backgroundColor = "#E5E5E5";
                txtExeD.disabled = true;
                txtExeD.style.backgroundColor = "#E5E5E5";

                txtReceiptMember.disabled = true;
                txtReceiptMember.style.backgroundColor = "#E5E5E5";

                document.getElementsByName("rdoElectronicFlag")[0].disabled = true;
                document.getElementsByName("rdoElectronicFlag")[1].disabled = true;
                break;

            case "1":
                break;

            case "2":
                txtRegY.disabled = true;
                txtRegY.style.backgroundColor = "#E5E5E5";
                txtRegM.disabled = true;
                txtRegM.style.backgroundColor = "#E5E5E5";
                txtRegD.disabled = true;
                txtRegD.style.backgroundColor = "#E5E5E5";
                txtRegH.disabled = true;
                txtRegH.style.backgroundColor = "#E5E5E5";
                txtRegMi.disabled = true;
                txtRegMi.style.backgroundColor = "#E5E5E5";

                txtAprMemberTitle.disabled = true;
                txtAprMemberTitle.style.backgroundColor = "#E5E5E5";

                txtDrafter.disabled = true;
                txtDrafter.style.backgroundColor = "#E5E5E5";

                txtExeY.disabled = true;
                txtExeY.style.backgroundColor = "#E5E5E5";
                txtExeM.disabled = true;
                txtExeM.style.backgroundColor = "#E5E5E5";
                txtExeD.disabled = true;
                txtExeD.style.backgroundColor = "#E5E5E5";

                txtReceiptMember.disabled = true;
                txtReceiptMember.style.backgroundColor = "#E5E5E5";

                document.getElementsByName("rdoElectronicFlag")[0].disabled = true;
                document.getElementsByName("rdoElectronicFlag")[1].disabled = true;
                break;
        }
    }
    function InitSpecialRecCode(pCode) {
        var objCode = new String(pCode);
        if (objCode.length > 0) {
            if (objCode.charAt(0) == "Y")
                special1.checked = true;

            if (objCode.charAt(1) == "Y")
                special2.checked = true;

            if (objCode.charAt(2) == "Y")
                special3.checked = true;

            if (objCode.charAt(3) == "Y")
                special4.checked = true;

            if (objCode.charAt(4) == "Y")
                special5.checked = true;
        }
    }
    function InitPublicCode(pCode) {
        var objCode = new String(pCode);
        if (objCode.length > 0) {
            var idx = parseInt(objCode.charAt(0));
            document.getElementsByName("rdoSecType")[idx - 1].checked = true;

            if (idx != 1)
            {
                if (objCode.charAt(1) == "Y")
                    selSecLevel1.checked = true;

                if (objCode.charAt(2) == "Y")
                    selSecLevel2.checked = true;

                if (objCode.charAt(3) == "Y")
                    selSecLevel3.checked = true;

                if (objCode.charAt(4) == "Y")
                    selSecLevel4.checked = true;

                if (objCode.charAt(5) == "Y")
                    selSecLevel5.checked = true;

                if (objCode.charAt(6) == "Y")
                    selSecLevel6.checked = true;

                if (objCode.charAt(7) == "Y")
                    selSecLevel7.checked = true;

                if (objCode.charAt(8) == "Y")
                    selSecLevel8.checked = true;

            }
        }
        rdoSecType_onclick("");
    }
    function GetRecordSimpleInfo(pRecID) {
        var XmlHttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETERS");
        createNodeAndInsertText(xmlpara, objNode, "RECORDID", pRecID);
        createNodeAndInsertText(xmlpara, objNode, "SEPATTACHNO", g_SepAttachNo);
        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);

        XmlHttp.open("POST", "/ezApprovalG/getRecordSimpleInfo.do", false);
        XmlHttp.send(xmlpara);

        var rtnXml = XmlHttp.responseXML;

        if (getNodeText(GetChildNodes(rtnXml)[0]) == "FALSE") {
            OpenAlertUI("<spring:message code='ezApprovalG.t973'/>");
            return "FALSE";
        }
        else if (getNodeText(GetChildNodes(rtnXml)[0]) == "NORECORD") {
            OpenAlertUI("<spring:message code='ezApprovalG.t974'/>");
            return "FALSE";
        }

        return getXmlString(rtnXml);
    }
    function btnReset_onclick() {
        document.getElementById("txtChangeReason").value = "";
    }
    function btnOK_onclick() {
        if (g_ModifyFlag == "0")
        {
            if (txtTitle.value == "") {
                OpenAlertUI("<spring:message code='ezApprovalG.t955'/>");
                return "";
            }
        }
        else {
        }
        if (txtChangeReason.value == "") {
            OpenAlertUI("<spring:message code='ezApprovalG.t624'/>");
            return "";
        }

        if (get_length(txtChangeReason.value) > 100) {
            OpenAlertUI("<spring:message code='ezApprovalG.t960'/>");
            return;
        }

        if (ChangeCabinetInfo()) {
            rtnVal[0] = "TRUE";
            OpenAlertUI("<spring:message code='ezApprovalG.t975'/>");
            window.close();
        }
    }
    function ChangeCabinetInfo() {
        var oXmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objNode, subNode;
        objNode = createNodeInsert(xmlpara, objNode, "PARAMETERS");
        createNodeAndInsertText(xmlpara, objNode, "MODIFYFLAG", g_ModifyFlag);
        createNodeAndInsertText(xmlpara, objNode, "RECORDTYPE", g_RecordType);
        createNodeAndInsertText(xmlpara, objNode, "RECORDID", g_RecordID);
        createNodeAndInsertText(xmlpara, objNode, "SEPATTACHNO", g_SepAttachNo);
        createNodeAndInsertText(xmlpara, objNode, "USERID", g_UserID);
        createNodeAndInsertText(xmlpara, objNode, "USERNAME", g_UserName);
        createNodeAndInsertText(xmlpara, objNode, "USERNAME2", g_UserName);

        if (g_ModifyFlag == "0")
        {
            createNodeAndInsertText(xmlpara, objNode, "TITLE", txtTitle.value);
            createNodeAndInsertText(xmlpara, objNode, "REGISTERDATE", GetRegisterDate());
            createNodeAndInsertText(xmlpara, objNode, "NUMOFPAGE", txtTotalPage.value);

            if (UserLang == "1") {
                createNodeAndInsertText(xmlpara, objNode, "APRMEMBER", txtAprMemberTitle.value);
                createNodeAndInsertText(xmlpara, objNode, "APRMEMBER2", txtAprMemberTitle2.value);
                createNodeAndInsertText(xmlpara, objNode, "DRAFTER", txtDrafter.value);
                createNodeAndInsertText(xmlpara, objNode, "DRAFTER2", txtDrafter2.value);
            }
            else {
                createNodeAndInsertText(xmlpara, objNode, "APRMEMBER", txtAprMemberTitle2.value);
                createNodeAndInsertText(xmlpara, objNode, "APRMEMBER2", txtAprMemberTitle.value);
                createNodeAndInsertText(xmlpara, objNode, "DRAFTER", txtDrafter2.value);
                createNodeAndInsertText(xmlpara, objNode, "DRAFTER2", txtDrafter.value);
            }

            createNodeAndInsertText(xmlpara, objNode, "EXECUTEDATE", GetExecuteDate());

            if (UserLang == "1") {
                createNodeAndInsertText(xmlpara, objNode, "RECEIPTMEMBER", txtReceiptMember.value);
                createNodeAndInsertText(xmlpara, objNode, "RECEIPTMEMBER2", txtReceiptMember2.value);
            }
            else {
                createNodeAndInsertText(xmlpara, objNode, "RECEIPTMEMBER", txtReceiptMember2.value);
                createNodeAndInsertText(xmlpara, objNode, "RECEIPTMEMBER2", txtReceiptMember.value);
            }

            createNodeAndInsertText(xmlpara, objNode, "SENDINGMEMBER", "");
            createNodeAndInsertText(xmlpara, objNode, "SENDINGMEMBER2", "");
            createNodeAndInsertText(xmlpara, objNode, "ELECTRONICFLAG", GetElectronicRecFlag());
            createNodeAndInsertText(xmlpara, objNode, "CHANGEREASON", txtChangeReason.value);
        }
        else
        {
            createNodeAndInsertText(xmlpara, objNode, "SPECIALRECCODE", GetSpecialRecInfo());
            createNodeAndInsertText(xmlpara, objNode, "PUBLICCODE", GetPublicCode());
            createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", txtLimitRange.value);
            createNodeAndInsertText(xmlpara, objNode, "CHANGEREASON", txtChangeReason.value);
            createNodeAndInsertText(xmlpara, objNode, "SCFLAG", g_SCFlag);
            subNode = createNodeAndAppandNode(xmlpara, objNode, subNode, "SCINFO");

            if (g_SCFlag == "2")
            {
                var subNode2;
                subNode2 = createNodeAndAppandNode(xmlpara, subNode, subNode2, "SCNAME");
                createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "LIST1", g_arrSCName[0]);
                createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "LIST2", g_arrSCName[1]);
                createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "LIST3", g_arrSCName[2]);

                if (g_szSCListXml != "")
                {
                    var i;
                    var objSCXml = createXmlDom();
                    objSCXml = loadXMLString(g_szSCListXml);

                    var oRows = SelectNodes(objSCXml, "LISTVIEWDATA/ROWS/ROW");
                    if (oRows.length > 0) {
                        for (i = 0; i < oRows.length; i++) {
                            var subNode3 = createNodeAndAppandNode(xmlpara, objNode, subNode3, "SCDATA");
                            createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "SN", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[0])[0]));
                            if (GetChildNodes(oRows[i])[1])
                                createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "LIST1", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[1])[0]));
                            else
                                createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "LIST1", "");
                            if (GetChildNodes(oRows[i])[2])
                                createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "LIST2", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[2])[0]));
                            else
                                createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "LIST2", "");
                            if (GetChildNodes(oRows[i])[3])
                                createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "LIST3", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[3])[0]));
                            else
                                createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "LIST3", "");
                        }
                    }
                }
            }
        }

        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);

        oXmlhttp.open("POST", "/ezApprovalG/changeRecInfo.do", false);
        oXmlhttp.send(xmlpara);

        var rtnXml = oXmlhttp.responseXML;
        if (getNodeText(GetChildNodes(rtnXml)[0]) == "FALSE") {
            OpenAlertUI("<spring:message code='ezApprovalG.t962'/>");
            return false;
        }
        else {
            return true;
        }
    }
    function btnClose_onclick() {
        rtnVal[0] = "FALSE";
        window.close();
    }
    window.onbeforeunload = function () {
        if (ReturnFunction != null)
            ReturnFunction(rtnVal);
        else
            window.returnValue = rtnVal;
    }
    var AddSpecialCatalog_Cross_dialogArguments = new Array();
    function btnAddSpecialCatalog_onclick() {
        var para = new Array();
        para[0] = g_szSCListXml;
        para[1] = g_arrSCName[0];
        para[2] = g_arrSCName[1];
        para[3] = g_arrSCName[2];
        var url = "/ezApprovalG/insSpecialList.do";
        var rtn;
        AddSpecialCatalog_Cross_dialogArguments[0] = para;
        AddSpecialCatalog_Cross_dialogArguments[1] = btnAddSpecialCatalog_onclick_Complete;
        var OpenWin;
        
            OpenWin = window.open(url, "AddSpecialCatalog_Cross", GetOpenWindowfeature(500, 435));

        try { OpenWin.focus(); } catch (e) { }
    }
    function btnAddSpecialCatalog_onclick_Complete(rtn) {
    	   DivPopUpHidden();
    	   if (rtn[0] == "TRUE") {
    	        g_szSCListXml = rtn[1];
    	    }
    }
    function selChangeType_onchange() {
        g_ModifyFlag = selChangeType.value;

        if (g_szRecInfoXml != "FALSE")
            InitRecordInfo();

        if (g_ModifyFlag == "0")
        {
            divBasicInfo.style.display = "";
            divClassInfo.style.display = "none";

            window.dialogHeight = "510px";
        }
        else if (g_ModifyFlag == "1")
        {
            divBasicInfo.style.display = "none";
            divClassInfo.style.display = "";

            window.dialogHeight = "510px";
        }
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
</script>
</head>
<body style="margin-left:0px;margin-top:0px" class="popup">
<h1><spring:message code='ezApprovalG.t969'/></h1>
<table class="content">
  <tr>
    <th><spring:message code='ezApprovalG.t963'/></th>
    <td><Select id="selChangeType" style="width:120px" onChange="return selChangeType_onchange()">
        <Option value="0"><spring:message code='ezApprovalG.t964'/></Option>
        <Option value="1"><spring:message code='ezApprovalG.t976'/></Option>
      </Select>
    </td>
  </tr>
</table>
<Div id="divBasicInfo">
  <table class="content" style="margin-top:10px">
    <tr>
      <th><spring:message code='ezApprovalG.t106'/></th>
      <td><input type="text" class="text" style="Width:98%;" name="txtTitle" id="txtTitle">
      </td>
    </tr>
    <tr>
      <th><spring:message code='ezApprovalG.t831'/></th>
      <td><input type="text" style="Width:40px;" name="txtRegY" id="txtRegY" maxlength = "4">
        <spring:message code='ezApprovalG.t456'/>
        <input type="text" style="Width:25px;" name="txtRegM"  id="txtRegM" maxlength = "2">
        <spring:message code='ezApprovalG.t968'/>
        <input type="text" style="Width:25px;" name="txtRegD"  id="txtRegD" maxlength = "2">
        <spring:message code='ezApprovalG.t662'/>
        <input type="text" style="Width:25px;" name="txtRegH"  id="txtRegH" maxlength = "2">
        <spring:message code='ezApprovalG.t977'/>
        <input type="text" style="Width:25px;" name="txtRegMi"  id="txtRegMi" maxlength = "2">
        <spring:message code='ezApprovalG.t978'/></td>
    </tr>
    <tr>
      <th ><spring:message code='ezApprovalG.t979'/></th>
      <td ><input type="text" name="txtTotalPage" id="txtTotalPage" style="Width:60px;">
        &nbsp;<spring:message code='ezApprovalG.t980'/></td>
    </tr>
    <tr>
      <th ><spring:message code='ezApprovalG.t862'/></th>
      <td ><input type="text" name="txtAprMemberTitle" id="txtAprMemberTitle" style="Width:98%;"><input type=hidden name="txtAprMemberTitle2" id="txtAprMemberTitle2" />
      </td>
    </tr>
    <tr>
      <th ><spring:message code='ezApprovalG.t445'/></th>
      <td ><input type="text" name="txtDrafter" id="txtDrafter" class="text" style="Width:98%;"><input type=hidden name="txtDrafter2" id="txtDrafter2" />
      </td>
    </tr>
    <tr>
      <th ><spring:message code='ezApprovalG.t863'/></th>
      <td ><input type="text" style="Width:40px;" name="txtExeY" id="txtExeY" maxlength = "4">
        <spring:message code='ezApprovalG.t456'/>
        <input type="text" style="Width:25px;" name="txtExeM"  id="txtExeM" maxlength = "2">
        <spring:message code='ezApprovalG.t968'/>
        <input type="text" style="Width:25px;" name="txtExeD"  id="txtExeD" maxlength = "2">
        <spring:message code='ezApprovalG.t643'/></td>
    </tr>
    <tr>
      <th ><spring:message code='ezApprovalG.t864'/></th>
      <td ><input type="text" name="txtReceiptMember" id="txtReceiptMember" style="Width:98%;"><input type=hidden name="txtReceiptMember2" id="txtReceiptMember2" />
      </td>
    </tr>
    <tr>
      <th ><spring:message code='ezApprovalG.t868'/></th>
      <td style="text-align:left;vertical-align:middle"><Input type="radio" style="vertical-align:text-bottom" name="rdoElectronicFlag" value="1" checked><spring:message code='ezApprovalG.t981'/>
        <Input type="radio" style="vertical-align:text-bottom" name="rdoElectronicFlag" value="2"><spring:message code='ezApprovalG.t982'/></td>
    </tr>
  </table>
</Div>
<Div id="divClassInfo" style="display:none">
  <table class="content" style="margin-top:10px">
    <tr>
      <th  ><spring:message code='ezApprovalG.t875'/></th>
      <td><Input type="checkbox" name="special1" id="special1" value="Y">
        <spring:message code='ezApprovalG.t983'/><br/>
        <Input type="checkbox" name="special2" id="special2" value="Y">
        <spring:message code='ezApprovalG.t984'/><br/>
        <Input type="checkbox" name="special3" id="special3" value="Y">
        <spring:message code='ezApprovalG.t985'/><br/>
        <Input type="checkbox" name="special4" id="special4" value="Y">
        <spring:message code='ezApprovalG.t986'/><br/>
        <Input type="checkbox" name="special5" id="special5" value="Y">
        <spring:message code='ezApprovalG.t987'/></td>
    </tr>
    <tr>
      <th ><spring:message code='ezApprovalG.t109'/></th>
      <td style="vertical-align:middle"><Input type="radio" style="vertical-align:text-bottom;" name="rdoSecType" value="1" checked onClick="return rdoSecType_onclick(this.value)">
        <spring:message code='ezApprovalG.t47'/>
        <Input type="radio" style="vertical-align:text-bottom;" name="rdoSecType" value="2" onClick="return rdoSecType_onclick(this.value)">
        <spring:message code='ezApprovalG.t150'/>
        <Input type="radio" style="vertical-align:text-bottom;" name="rdoSecType" value="3" onClick="return rdoSecType_onclick(this.value)">
        <spring:message code='ezApprovalG.t988'/>
        <Select id="selSecLevel" style="width:60px;display:none">
        </Select>
      </td>
    </tr>
    <tr>
      <th ><spring:message code='ezApprovalG.t989'/></th>
      <td ><input type="checkbox" name="selSecLevel1" id="selSecLevel1" value="Y">
        1<spring:message code='ezApprovalG.t1768'/>
        <input type="checkbox" name="selSecLevel2" id="selSecLevel2" value="Y">
        2<spring:message code='ezApprovalG.t1768'/>
        <input type="checkbox" name="selSecLevel3" id="selSecLevel3" value="Y">
        3<spring:message code='ezApprovalG.t1768'/>
        <input type="checkbox" name="selSecLevel4" id="selSecLevel4" value="Y">
        4<spring:message code='ezApprovalG.t1768'/><br>
        <input type="checkbox" name="selSecLevel5" id="selSecLevel5" value="Y">
        5<spring:message code='ezApprovalG.t1768'/>
        <input type="checkbox" name="selSecLevel6" id="selSecLevel6" value="Y">
        6<spring:message code='ezApprovalG.t1768'/>
        <input type="checkbox" name="selSecLevel7" id="selSecLevel7" value="Y">
        7<spring:message code='ezApprovalG.t1768'/>
        <input type="checkbox" name="selSecLevel8" id="selSecLevel8" value="Y">
        8<spring:message code='ezApprovalG.t1768'/></td>
    </tr>
    <tr>
      <th  ><spring:message code='ezApprovalG.t876'/></th>
      <td ><input type="text" name="txtLimitRange" id="txtLimitRange" style="Width:98%;">
        (<spring:message code='ezApprovalG.t992'/></td>
    </tr>
    <tr>
      <th ><spring:message code='ezApprovalG.t966'/></th>
      <td ><table border="0" style="width:100%;border:0;border-collapse:collapse; border-spacing:0;padding:0px;">
          <tr>
            <td id="tdSpecialFlag">&nbsp;</td>
            <td style="width:70px"><img src="/images/btn_change.gif" style="display:none;cursor:pointer;vertical-align:middle" id="btnAddSC" onClick="return btnAddSpecialCatalog_onclick()" width="51" height="20"></td>
          </tr>
        </table></td>
    </tr>
  </table>
</Div>
<table class="content" style="margin-top:10px">
  <tr>
    <th  ><spring:message code='ezApprovalG.t626'/></th>
    <td><TextArea style="width:97%; height:70px" id=txtChangeReason name=txtChangeReason></TextArea></td>
  </tr>
</table>
<div class="btnposition">
  <a class="imgbtn"><span id="btnReset" onclick="return btnReset_onclick()"><spring:message code='ezApprovalG.t621'/></span></a>
  <a class="imgbtn"><span id="btnOK" onclick="return btnOK_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
  <a class="imgbtn"><span id="btnClose" onclick="return btnClose_onclick()"><spring:message code='ezApprovalG.t119'/></span></a>  
</div>
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/myoffice/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>
