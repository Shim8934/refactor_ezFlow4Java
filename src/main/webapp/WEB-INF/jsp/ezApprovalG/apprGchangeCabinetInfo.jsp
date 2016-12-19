<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezApprovalG.t951'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
<script type="text/javascript"  src="/js/ezApprovalG/InitSCPopup_Cross.js"></script>
<script type="text/javascript"  src="/js/ezApprovalG/OpenAlert_Cross.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" ID="clientEventHandlersJS" >
    var rtnVal = new Array();
    var g_InitFlag="0";
    var xmlhttp = createXMLHttpRequest();
    var g_CabinetID, g_CabClassNo;
    var g_ModifyFlag;
    var g_UserID, g_UserName , g_UserName2;
    var g_ArrPageInitFlag = new Array();
    g_ArrPageInitFlag[0]=false;
    g_ArrPageInitFlag[1]=false;
    var g_szCabInfoXml;
    var g_DisplayFlag;
    var g_SCFlag;
    var g_bRecAdmin;
    var CompanyID = "${userInfo.companyID}";
    var RetValue;
    var ReturnFunction;
    var NonActiveX = "YES";
    window.onload = function () {
        var ua = navigator.userAgent;
        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
            KeEventControl(document.getElementById("txtTitle"));
            KeEventControl(document.getElementById("txtChangeReason"));
        }
        try {
            RetValue = parent.changecabinetinfo_cross_dialogArguments[0];
            ReturnFunction = parent.changecabinetinfo_cross_dialogArguments[1];
        } catch (e) {
            try {
                RetValue = opener.changecabinetinfo_cross_dialogArguments[0];
                ReturnFunction = opener.changecabinetinfo_cross_dialogArguments[1];
            } catch (e) {
                RetValue = window.dialogArguments;
            }
        }
        g_CabinetID = RetValue[0];
        g_CabClassNo = RetValue[1];
        g_UserID = RetValue[2];
        g_UserName = RetValue[3];
        g_UserName2 = RetValue[5];
        g_bRecAdmin = RetValue[4];

        InitCode();
        g_szCabInfoXml = GetCabinetSimpleInfo(g_CabinetID);

        if (g_bRecAdmin) {
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
    			result = loadXMLString(xml);
    		}        			
    	});
    	g_CodeInfoXml = result;

    	  if (SelectSingleNodeValue(result, "RESULT") == "FALSE") {
    		  OpenAlertUI("<spring:message code='ezApprovalG.t952'/>");
    	    }
        else {
            var nodesKeepPeriod = SelectNodes(result, "CODELIST/KEEPINGPERIOD/CODE")
            InitCodeSelectBox(nodesKeepPeriod, selKeepPeriod);

            var nodesRecType = SelectNodes(result, "CODELIST/RECORDTYPE/CODE")

            InitCodeSelectBox(nodesRecType, selRecTypeCode);


        }
    	  
    }
    function InitCabinetInfo() {
        var CabXml = loadXMLString(g_szCabInfoXml);
        if (g_ModifyFlag == "0") {
            if (!g_ArrPageInitFlag[0])
            {
                txtTitle.value = SelectSingleNodeValueNew(CabXml, "RESULT/TITLE");
                selindex = parseInt(SelectSingleNodeValueNew(CabXml, "RESULT/RECTYPECODE")) - 1;
                SelOptionInSingleSelBox(selRecTypeCode, selindex);
                g_SCFlag = SelectSingleNodeValueNew(CabXml, "RESULT/SPECIALFLAG");

                if (g_SCFlag == "1")
                {
                    tdSpecialFlag.innerHTML = "Y";
                    btnAddSC.style.display = "";
                    InitSCInfo_Mod(SelectSingleNodeNew(CabXml, "RESULT/SCINFO"));

                }
                else {
                    tdSpecialFlag.innerHTML = "N";
                    btnAddSC.style.display = "none";
                }
                g_ArrPageInitFlag[0] = true;
            }
        }
        else {
            if (!g_ArrPageInitFlag[1])
            {
                selKeepPeriod.value = SelectSingleNodeValueNew(CabXml, "RESULT/KEEPPERIOD");

                g_DisplayFlag = SelectSingleNodeValueNew(CabXml, "RESULT/DISPLAYFLAG");
                if (g_DisplayFlag != "1")
                {
                    tdDisplayFlag.innerHTML = "<spring:message code='ezApprovalG.t602'/>";

                    txtDisplayEndY.disabled = true;
                    txtDisplayEndM.disabled = true;
                    txtDisplayEndD.disabled = true;

                    txtDisplayReason.disabled = true;

                    txtDisplayEndY.style.backgroundColor = "#E5E5E5";
                    txtDisplayEndM.style.backgroundColor = "#E5E5E5";
                    txtDisplayEndD.style.backgroundColor = "#E5E5E5";

                    txtDisplayReason.style.backgroundColor = "#E5E5E5";
                }
                else {
                    tdDisplayFlag.innerHTML = "<spring:message code='ezApprovalG.t601'/>";

                    var DispEndDate = SelectSingleNodeValueNew(CabXml, "RESULT/DISPLAYENDDATE");
                    if (DispEndDate.length == 8) {
                        txtDisplayEndY.value = DispEndDate.slice(0, 4);
                        txtDisplayEndM.value = DispEndDate.slice(4, 6);
                        txtDisplayEndD.value = DispEndDate.slice(6, 8);
                    }

                    txtDisplayReason.value = SelectSingleNodeValueNew(CabXml, "RESULT/DISPLAYREASON");;
                }
                g_ArrPageInitFlag[1] = true;
            }
        }
    }
    function GetCabinetSimpleInfo(pCabID) {
        var XmlHttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETERS");

        createNodeAndInsertText(xmlpara, objRoot, "CABINETID", pCabID);
        createNodeAndInsertText(xmlpara, objRoot, "COMPANYID", CompanyID);
        createNodeAndInsertText(xmlpara, objRoot, "STRTYPE", "${userInfo.lang}");

        XmlHttp.open("POST", "/ezApprovalG/getCabinetSimpleInfo.do", false);
        XmlHttp.send(xmlpara);

        var rtnXml = XmlHttp.responseXML;

        if (SelectSingleNodeValue(XmlHttp.responseXML, "RESULT") == "FALSE") {
            OpenAlertUI("<spring:message code='ezApprovalG.t953'/>");
            return "FALSE";
        }
        else if (SelectSingleNodeValue(XmlHttp.responseXML, "RESULT") == "NORECORD") {
            OpenAlertUI("<spring:message code='ezApprovalG.t954'/>");
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
            if (g_DisplayFlag == "1") {
                if (txtDisplayEndY.value == "" || txtDisplayEndM.value == "" || txtDisplayEndD.value == "") {
                    OpenAlertUI("<spring:message code='ezApprovalG.t956'/>");
                    return "";
                }
                else if (!ValidateYearValue(txtDisplayEndY.value)) {
                    OpenAlertUI("<spring:message code='ezApprovalG.t957'/>");
                    return "";
                }
                else if (!ValidateNumber(txtDisplayEndM.value)) {
                    OpenAlertUI("<spring:message code='ezApprovalG.t958'/>");
                    return "";
                }
                else if (!ValidateNumber(txtDisplayEndD.value)) {
                    OpenAlertUI("<spring:message code='ezApprovalG.t959'/>");
                    return "";
                }
            }
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
            OpenAlertUI("<spring:message code='ezApprovalG.t961'/>", btnOK_onclick_Complete);
        }
    }
    function btnOK_onclick_Complete() {
        window.close();
    }
    function ChangeCabinetInfo() {
        var oXmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();
        var objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETERS");
        var objNode = createNodeAndInsertText(xmlpara, objRoot, "MODIFYFLAG", g_ModifyFlag);
        objNode = createNodeAndInsertText(xmlpara, objRoot, "CABINETID", g_CabinetID);
        objNode = createNodeAndInsertText(xmlpara, objRoot, "CABCLASSNO", g_CabClassNo);
        objNode = createNodeAndInsertText(xmlpara, objRoot, "USERID", g_UserID);
        objNode = createNodeAndInsertText(xmlpara, objRoot, "USERNAME", g_UserName);
        objNode = createNodeAndInsertText(xmlpara, objRoot, "USERNAME2", g_UserName);

        if (g_ModifyFlag == "0")
        {
            objNode = createNodeAndInsertText(xmlpara, objRoot, "TITLE", txtTitle.value);
            objNode = createNodeAndInsertText(xmlpara, objRoot, "RECTYPECODE", selRecTypeCode.value);

            objNode = createNodeAndInsertText(xmlpara, objRoot, "CHANGEREASON", txtChangeReason.value);

            objNode = createNodeAndInsertText(xmlpara, objRoot, "SCFLAG", g_SCFlag);

            var scinfo = createNodeAndAppandNode(xmlpara, objRoot, scinfo, "SCINFO");

            if (g_SCFlag == "1")
            {

                var scname = createNodeAndAppandNode(xmlpara, scinfo, scname, "SCNAME");
                var objlist
                objlist = createNodeAndAppandNodeText(xmlpara, scname, objlist, "LIST1", g_arrSCName[0]);
                objlist = createNodeAndAppandNodeText(xmlpara, scname, objlist, "LIST2", g_arrSCName[1]);
                objlist = createNodeAndAppandNodeText(xmlpara, scname, objlist, "LIST3", g_arrSCName[2]);

                if (g_szSCListXml != "")
                {
                    var i;
                    var objSCXml = loadXMLString(g_szSCListXml);
                    var oRows = SelectNodes(objSCXml, "LISTVIEWDATA/ROWS/ROW");
                    if (oRows.length > 0) {
                        for (i = 0; i < oRows.length; i++) {
                            var objSC = createNodeAndAppandNode(xmlpara, scinfo, objSC, "SCDATA");
                            var objData = createNodeAndAppandNodeText(xmlpara, objSC, objData, "SN", getNodeText(GetChildNodes(oRows[i])[0]));
                            for (var j = 1 ; j < 4; j++) {
                                if (j < oRows[i].childNodes.length)
                                    objData = createNodeAndAppandNodeText(xmlpara, objSC, objData, "LIST" + j, getNodeText(GetChildNodes(oRows[i])[j]));
                                else
                                    objData = createNodeAndAppandNodeText(xmlpara, objSC, objData, "LIST" + j, "");
                            }
                        }
                    }
                }
            }
        }
        else
        {

            objNode = createNodeAndInsertText(xmlpara, objRoot, "KEEPPERIOD", selKeepPeriod.value);
            objNode = createNodeAndInsertText(xmlpara, objRoot, "DISPLAYFLAG", g_DisplayFlag);
            objNode = createNodeAndInsertText(xmlpara, objRoot, "DISPLAYENDDATE", GetDisplayEndDate());
            objNode = createNodeAndInsertText(xmlpara, objRoot, "DISPLAYREASON", txtDisplayReason.value);
            objNode = createNodeAndInsertText(xmlpara, objRoot, "CHANGEREASON", txtChangeReason.value);
        }

        objNode = createNodeAndInsertText(xmlpara, objRoot, "COMPANYID", CompanyID);

        oXmlhttp.open("POST", "/ezApprovalG/changeCabInfo.do", false);
        oXmlhttp.send(xmlpara);

        var rtnXml = oXmlhttp.responseXML;

        if (SelectSingleNodeValue(oXmlhttp.responseXML, "RESULT") == "FALSE") {
            OpenAlertUI("<spring:message code='ezApprovalG.t962'/>");
            return false;
        }
        else {
            return true;
        }
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
    function btnClose_onclick() {
        rtnVal[0] = "FALSE";
        window.close();
    }
    window.onunload = function () {
        if (ReturnFunction != null)
            ReturnFunction(rtnVal);
        else
            window.returnValue = rtnVal;
    }
    function selChangeType_onchange() {
        g_ModifyFlag = selChangeType.value;
        if (g_szCabInfoXml != "FALSE")
            InitCabinetInfo();

        if (g_ModifyFlag == "0")
        {
            btnReset_onclick();
            divBasicInfo.style.display = "";
            divClassInfo.style.display = "none";

            window.dialogHeight = "360px";
        }
        else if (g_ModifyFlag == "1")
        {
            btnReset_onclick();
            divBasicInfo.style.display = "none";
            divClassInfo.style.display = "";

            window.dialogHeight = "360px";
        }
    }
</script>
</head>
<body class="popup">
<h1><spring:message code='ezApprovalG.t951'/></h1>
<table class="content">
  <tr>
    <th><spring:message code='ezApprovalG.t963'/></th>
    <td><Select id="selChangeType" style="width:120PX" onChange="return selChangeType_onchange()">
        <Option value="0" id="0"><spring:message code='ezApprovalG.t964'/></Option>
        <Option value="1" id="1"><spring:message code='ezApprovalG.t965'/></Option>
      </Select>
    </td>
  </tr>
</table>
<Div id="divBasicInfo">
  <table class="content" style="margin-top:10px" >
    <tr >
      <th><spring:message code='ezApprovalG.t106'/></th>
      <td ><input type="text" class="text" style="Width:99%; " name="txtTitle" id="txtTitle">
      </td>
    </tr>
    <tr >
      <th><spring:message code='ezApprovalG.t826'/></th>
      <td><Select id="selRecTypeCode" style="width:100%">
        </Select>
      </td>
    </tr>
    <tr>
      <th><spring:message code='ezApprovalG.t966'/></th>
      <td>
          <table style="width:100%">
          <tr>
            <td id="tdSpecialFlag">&nbsp;</td>
            <td style="width:70px">
                <img src="/images/btn_change.gif"style="display:none;cursor:pointer" name="btnAddSC" id="btnAddSC" onClick="return btnAddSpecialCatalog_onclick()" width="51" height="20"></td>
          </tr>
        </table></td>
    </tr>
  </table>
</Div>
<Div id="divClassInfo" style="display:none">
  <table class="content" style="margin-top:10px" >
    <tr>
      <th><spring:message code='ezApprovalG.t117'/></th>
      <td><Select id="selKeepPeriod" style="width:100px">
        </Select>
      </td>
    </tr>
    <tr>
      <th><spring:message code='ezApprovalG.t967'/></th>
      <td  id="tdDisplayFlag" >&nbsp;</td>
    </tr>
    <tr id="trDisplayEndDate" >
      <th><spring:message code='ezApprovalG.t842'/></th>
      <td><input type="text" class="text" style="Width:50px; " name="txtDisplayEndY" id="txtDisplayEndY" maxlength = "4">
        <spring:message code='ezApprovalG.t456'/>
        <input type="text" class="text" style="Width:30px; " name="txtDisplayEndM"  id="txtDisplayEndM" maxlength = "2">
        <spring:message code='ezApprovalG.t968'/>
        <input type="text" class="text" style="Width:30px; " name="txtDisplayEndD"  id="txtDisplayEndD" maxlength = "2">
        <spring:message code='ezApprovalG.t643'/></td>
    </tr>
    <tr>
      <th id="trDisplayReason"><spring:message code='ezApprovalG.t843'/></th>
      <td id="trDisplayReasonData" style="padding-top:2px;">
          <TextArea style="width:95%; height:40px" id=txtDisplayReason name=txtDisplayReason></TextArea>
      </td>
    </tr>
  </table>
</Div>
<table class="content" style="margin-top:10px" >
  <tr>
    <th><spring:message code='ezApprovalG.t626'/></th>
    <td style="padding-top:2px;"><TextArea style="width:96%;height:70px" id=txtChangeReason name=txtChangeReason></TextArea>
    </td>
  </tr>
</table>
<div class="btnposition">
  <a class="imgbtn"><span id="btnReset" onclick="return btnReset_onclick()"><spring:message code='ezApprovalG.t621'/></span></a>
  <a class="imgbtn"><span id="btnOK" onclick="return btnOK_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
  <a class="imgbtn"><span id="btnClose" onclick="return btnClose_onclick()"><spring:message code='ezApprovalG.t119'/></span></a>  
</div>
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>
