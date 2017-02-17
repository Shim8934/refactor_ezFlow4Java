<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1076'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/RegRecord_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/CabinetInfo_Cross.js"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
		    var rtnVal = new Array();
		    var g_RecordID;
		    var g_CabinetID="";
		    var g_OrgCabinetID;
		    var g_TaskCode;
		    var g_CodeInfoXml;
		    var g_VisualAudioFlag="0";
		    var g_RecTypeCode;
		    var g_NodesRcdgAVType=null;
		    var g_NodesPhotoAVType=null;
		    var g_InitFlag;
		    var g_SepAttachXml;
		    var g_RegType="";
		    var g_AVType="";
		    var CompanyID = "${userInfo.companyID}";
		    var UserLang = "${userInfo.lang}";
		    var RetValue;
		    var ReturnFunction;
		    var NonActiveX = "YES";
		    window.onload = function () {
		        try {
		            RetValue = parent.regsepattach_cross_dialogArguments[0];
		            ReturnFunction = parent.regsepattach_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.regsepattach_cross_dialogArguments[0];
		                ReturnFunction = opener.regsepattach_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        if (RetValue != null) {
		            g_InitFlag = RetValue[0];
		            g_RecordID = RetValue[1];
		            g_CabinetID = RetValue[2];
		            g_SepAttachXml = RetValue[3];
		            g_OrgCabinetID = RetValue[4];
		        }
		        InitCode();
		        if (g_SepAttachXml != "") {
		            InitSepAttInfo();
		        }
		        if (typeof (g_CabinetID) != "undefined") {
		            if (g_CabinetID.length > 0) InitCabinetInfo(GetCabinetClassInfo(g_CabinetID));
		        }
		        if (typeof (g_OrgCabinetID) != "undefined") {
		            if (g_OrgCabinetID.length > 0) InitOrgCabinetInfo(GetCabinetClassInfo(g_OrgCabinetID));
		        }
		        InitRegisterType();
		        rtnVal[0] = "FALSE";
		    };
		    function InitCabinetInfo(objCabInfoXml) {
		        g_TaskCode = SelectSingleNodeValueNew(objCabInfoXml, "RESULT/TASKCODE");
		
		        g_RecTypeCode = SelectSingleNodeValueNew(objCabInfoXml, "RESULT/RECTYPE");
		        
		        if("${userInfo.lang}" =="1") {
		        	tdCabinetName.innerHTML = SelectSingleNodeValueNew(objCabInfoXml, "RESULT/TITLE");
		        } else {
		        	tdCabinetName.innerHTML = SelectSingleNodeValueNew(objCabInfoXml, "RESULT/TITLE2");
		        } 
		        tdCabinetType.innerHTML = SelectSingleNodeValueNew(objCabInfoXml, "RESULT/RECTYPEDES");
		        tdCabinetVolNo.innerHTML = SelectSingleNodeValueNew(objCabInfoXml, "RESULT/VOLNO");
		    }
		    function InitOrgCabinetInfo(objCabInfoXml) {
		        g_TaskCode = SelectSingleNodeValue(objCabInfoXml.documentElement, "TASKCODE");
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
		        
		        g_CodeInfoXml = getXmlString(result);
		
		        if (SelectSingleNodeValue(result, "RESULT") == "FALSE") {
		            alert("<spring:message code='ezApprovalG.t1077'/>");
		        }
		        else {
		            var nodesRegType = SelectNodes(result, "CODELIST/REGISTERTYPE/CODE");
		            InitCodeSelectBox(nodesRegType, selRegisterType);
		
		            g_NodesRcdgAVType = SelectNodes(result, "CODELIST/RECORDINGAVTYPE/CODE");
		            g_NodesPhotoAVType = SelectNodes(result, "CODELIST/PHOTOAVTYPE/CODE");
		        }
		    }
		    function SwapAVTypeChkBox(bEnable) {
		        var i;
		        var colAVType = tdAVType.all("chkAVType");
		        for (i = 0; i < colAVType.length; i++) {
		            if (bEnable) {
		                colAVType.item(i).disabled = false;
		                colAVType.item(i).style.backgroundColor = "";
		            }
		            else {
		                colAVType.item(i).checked = false;
		                colAVType.item(i).disabled = true;
		                colAVType.item(i).style.backgroundColor = "#E5E5E5";
		            }
		        }
		    }
		    function selRegisterType_onchange() {
		        var Val = selRegisterType.value;
		        if (Val == 5 || Val == 6) {
		            window.dialogHeight = "596px";
		            if (CrossYN())
		                window.resizeTo(565, 690);
		
		            divAudioVisualDummy.style.display = "none";
		            divAudioVisual.style.display = "";
		            g_VisualAudioFlag = "1";
		
		            if (Val == 5) {
		                InitAVTypeTD(g_NodesPhotoAVType, tdAVType1, tdAVType2);
		            }
		            else if (Val == 6) {
		                InitAVTypeTD(g_NodesRcdgAVType, tdAVType1, tdAVType2);
		            }
		
		            ChkAVTypeCode();
		        }
		        else {
		            window.dialogHeight = "420px";
		            if (CrossYN())
		                window.resizeTo(565, 460);
		
		            document.getElementById("divAudioVisualDummy").style.display = "";
		            document.getElementById("divAudioVisual").style.display = "none";
		            g_VisualAudioFlag = "0";
		        }
		    }
		    function ChkAVTypeCode() {
		        var arrAVCode = g_AVType.split(",");
		        var i, j;
		        var colAVType = document.getElementsByName("chkAVType");
		        for (i = 0; i < colAVType.length; i++) {
		            for (j = 0; j < arrAVCode.length; j++) {
		                if (colAVType[i].value == arrAVCode[j]) {
		                    colAVType[i].checked = true;
		                    break;
		                }
		            }
		        }
		    }
		    function InitRegisterType() {
		        selRegisterType.innerHTML = "";
		
		        var RegTypeCodeXml = createXmlDom();
		        var Root, objNode;
		
		        var objCodeInfo = createXmlDom();
		        objCodeInfo = loadXMLString(g_CodeInfoXml);
		
		        if (navigator.userAgent.indexOf('Trident') == -1) {
		            Root = "<REGISTERTYPE>";
		            switch (g_RecTypeCode) {
		                case "1":
		                    var nodes = objCodeInfo.evaluate("CODELIST/REGISTERTYPE/CODE[CODENUM='1']", objCodeInfo, null, XPathResult.ANY_TYPE, null);
		                    Root += getXmlString(nodes.iterateNext());
		                    nodes = objCodeInfo.evaluate("CODELIST/REGISTERTYPE/CODE[CODENUM='2']", objCodeInfo, null, XPathResult.ANY_TYPE, null);
		                    Root += getXmlString(nodes.iterateNext());
		                    break;
		                case "2":
		                    nodes = objCodeInfo.evaluate("CODELIST/REGISTERTYPE/CODE[CODENUM='3']", objCodeInfo, null, XPathResult.ANY_TYPE, null);
		                    Root += getXmlString(nodes.iterateNext());
		                    nodes = objCodeInfo.evaluate("CODELIST/REGISTERTYPE/CODE[CODENUM='4']", objCodeInfo, null, XPathResult.ANY_TYPE, null);
		                    Root += getXmlString(nodes.iterateNext());
		                    break;
		                case "3":
		                    nodes = objCodeInfo.evaluate("CODELIST/REGISTERTYPE/CODE[CODENUM='5']", objCodeInfo, null, XPathResult.ANY_TYPE, null);
		                    Root += getXmlString(nodes.iterateNext());
		                    break;
		                case "4":
		                    nodes = objCodeInfo.evaluate("CODELIST/REGISTERTYPE/CODE[CODENUM='6']", objCodeInfo, null, XPathResult.ANY_TYPE, null);
		                    Root += getXmlString(nodes.iterateNext());
		                    break;
		                case "5":
		                    nodes = objCodeInfo.evaluate("CODELIST/REGISTERTYPE/CODE[CODENUM='7']", objCodeInfo, null, XPathResult.ANY_TYPE, null);
		                    Root += getXmlString(nodes.iterateNext());
		                    nodes = objCodeInfo.evaluate("CODELIST/REGISTERTYPE/CODE[CODENUM='8']", objCodeInfo, null, XPathResult.ANY_TYPE, null);
		                    Root += getXmlString(nodes.iterateNext());
		                    break;
		            }
		            Root += "</REGISTERTYPE>";
		            RegTypeCodeXml = loadXMLString(Root);
		        }
		        else {
		            Root = createNodeInsert(RegTypeCodeXml, Root, "REGISTERTYPE");
		            switch (g_RecTypeCode) {
		                case "1":
// 		                    Root.appendChild(objCodeInfo.documentElement.selectSingleNode("REGISTERTYPE/CODE[CODENUM='1']"));
// 		                    Root.appendChild(objCodeInfo.documentElement.selectSingleNode("REGISTERTYPE/CODE[CODENUM='2']"));
							Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[0]);
							Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[0]);
		                    break;
		                case "2":
		                	Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[2]);
		                	Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[2]);
// 		                    Root.appendChild(objCodeInfo.documentElement.selectSingleNode("REGISTERTYPE/CODE[CODENUM='3']"));
// 		                    Root.appendChild(objCodeInfo.documentElement.selectSingleNode("REGISTERTYPE/CODE[CODENUM='4']"));
		                    break;
		                case "3":
		                    Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[4]);
		                    break;
		                case "4":
		                	Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[5]);
		                    break;
		                case "5":
		                	Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[6]);
		                    Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[6]);
		                    break; 
		            }
		        }

		        InitCodeSelectBox(RegTypeCodeXml.documentElement.childNodes, selRegisterType);
		        SelectOption(selRegisterType, g_RegType);
		
		        selRegisterType_onchange();
		    }
		    function btnReset_onclick() {
		        txtTitle.value = "";
		        txtNumOfPage.value = "";
		        txtSummary.value = "";
		    }
		    function btnOK_onclick() {
		        if (txtTitle.value == "") {
		            alert("<spring:message code='ezApprovalG.t1078'/>");
		            return "";
		        }
		
		        if (!CheckLen(txtTitle, 100))
		            return "";
		
		        if (!ValidateNumber(txtNumOfPage.value)) {
		            alert("<spring:message code='ezApprovalG.t1079'/>");
		            return "";
		        }
		
		        if (txtNumOfPage.value.length > 3) {
		            alert("<spring:message code='ezApprovalG.t1080'/>");
		            return "";
		        }
		
		        if (g_CabinetID == "") {
		            alert("<spring:message code='ezApprovalG.t1081'/>");
		            return;
		        }
		
		        if (g_VisualAudioFlag == "1") {
		            if (txtSummary.value == "") {
		                alert("<spring:message code='ezApprovalG.t1082'/>");
		                return "";
		            }
		
		            if (txtSummary.value.length > 250) {
		                alert("<spring:message code='ezApprovalG.t1083'/>");
		                return "";
		            }
		
		
		            if (GetAVTypeCode() == "") {
		                alert("<spring:message code='ezApprovalG.t1084'/>");
		                return "";
		            }
		        }
		
		        if (g_InitFlag == "0") {
		            if (RegSeparateAttach()) {
		                rtnVal[0] = "TRUE";
		
		                if (ReturnFunction != null) {
		                    ReturnFunction(rtnVal);
		                    window.close();
		                }
		                else {
		                    window.returnValue = rtnVal;
		                    window.close();
		                }
		            }
		        }
		        else {
		            rtnVal[0] = "TRUE";
		            rtnVal[1] = GetSepAttInfoXml();
		            if (ReturnFunction != null) {
		                ReturnFunction(rtnVal);
		                window.close();
		            }
		            else {
		                window.returnValue = rtnVal;
		                window.close();
		            }
		        }
		    }
		    function InitSepAttInfo() {
		        var InfoXml = createXmlDom();
		        InfoXml = loadXMLString(g_SepAttachXml);
		        if (InfoXml.firstChild.nodeValue != null) {
		            g_RecordID = SelectSingleNodeValueNew(InfoXml, "PARAMETERS/RECORDID");
		        }
		        else {
		            g_RecordID = "";
		        }
		        g_CabinetID = SelectSingleNodeValueNew(InfoXml, "PARAMETERS/CABINETID");
		
		        txtTitle.value = SelectSingleNodeValueNew(InfoXml, "PARAMETERS/TITLE");
		        txtNumOfPage.value = SelectSingleNodeValueNew(InfoXml, "PARAMETERS/NUMOFPAGE");
		
		        g_RegType = SelectSingleNodeValueNew(InfoXml, "PARAMETERS/REGTYPE");
		        if (InfoXml.childNodes[0].childNodes[5].lastChild != null) {
		            txtSummary.value = SelectSingleNodeValueNew(InfoXml, "PARAMETERS/SUMMARY");
		        }
		        else {
		            txtSummary.value = "";
		        }
		        if (InfoXml.childNodes[0].childNodes[6].lastChild != null) {
		            g_AVType = SelectSingleNodeValueNew(InfoXml, "PARAMETERS/AVTYPE");
		        }
		        else {
		            g_AVType = "";
		        }
		
		        if (g_RegType == "1" || g_RegType == "2")
		            g_RecTypeCode = "1";
		        else if (g_RegType == "3" || g_RegType == "4")
		            g_RecTypeCode = "2";
		        else if (g_RegType == "5")
		            g_RecTypeCode = "3";
		        else if (g_RegType == "6")
		            g_RecTypeCode = "4";
		        else if (g_RegType == "7" || g_RegType == "8")
		            g_RecTypeCode = "5";
		    }
		    function GetSepAttInfoXml() {
		        var pRegType = selRegisterType.value;
		
		        var xmlpara = createXmlDom();
		
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "PARAMETERS");
		        createNodeAndInsertText(xmlpara, objNode, "RECORDID", g_RecordID);
		        createNodeAndInsertText(xmlpara, objNode, "CABINETID", g_CabinetID);
		        createNodeAndInsertText(xmlpara, objNode, "TITLE", txtTitle.value);
		        createNodeAndInsertText(xmlpara, objNode, "NUMOFPAGE", txtNumOfPage.value);
		        createNodeAndInsertText(xmlpara, objNode, "REGTYPE", selRegisterType.value);
		        if (pRegType == "5" || pRegType == "6")
		        {
		            createNodeAndInsertText(xmlpara, objNode, "SUMMARY", txtSummary.value.substring(0, 250));
		            createNodeAndInsertText(xmlpara, objNode, "AVTYPE", GetAVTypeCode());
		        }
		        else {
		            createNodeAndInsertText(xmlpara, objNode, "SUMMARY", "");
		            createNodeAndInsertText(xmlpara, objNode, "AVTYPE", "");
		        }
		
		        var sIdx = selRegisterType.selectedIndex;
		        if (sIdx > -1) {
		            createNodeAndInsertText(xmlpara, objNode, "REGTYPEDESC", selRegisterType.options[sIdx].innerHTML);
		        }
		        else {
		            createNodeAndInsertText(xmlpara, objNode, "REGTYPEDESC", "");
		        }
		
		        if (pRegType == "5" || pRegType == "6")
		        {
		            createNodeAndInsertText(xmlpara, objNode, "AVTYPEDESC", GetAVTypeCode());
		        }
		        else {
		            createNodeAndInsertText(xmlpara, objNode, "AVTYPEDESC", "");
		        }
		        createNodeAndInsertText(xmlpara, objNode, "CABINETNAME", tdCabinetName.innerHTML);
		
		        return getXmlString(xmlpara);
		    }
		    function RegSeparateAttach() {
		        var oXmlhttp = createXMLHttpRequest();
		        var xmlpara = createXmlDom();
		        var szXml = GetSepAttInfoXml();
		        xmlpara = loadXMLString(szXml);
		
		        var objNode = createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);   
		
		        oXmlhttp.open("POST", "/ezApprovalG/regSepAttach.do", false);
		        oXmlhttp.send(xmlpara);
		
		        var rtnXml = oXmlhttp.responseXML;
		
		        if (SelectSingleNodeValue(rtnXml, "RESULT") == "FALSE") {
		            alert("<spring:message code='ezApprovalG.t1085'/>");
		            return false;
		        }
		        else {
		            return true;
		        }
		    }
		
		    var selectcabinetintask_cross_dialogArguments = new Array();
		    function btnChangeCabinet_onclick() {
		        var para = new Array();
		        para[0] = g_TaskCode;
		        para[1] = g_CabinetID;
		        var url = "/ezApprovalG/selectCabinetInTask.do";
		
		        if (CrossYN()) {
		            selectcabinetintask_cross_dialogArguments[0] = para;
		            selectcabinetintask_cross_dialogArguments[1] = btnChangeCabinet_onclick_Complete;
		
		            DivPopUpShow(475, 375, url);
		        }
		        else {
		            var feature = "dialogWidth:475px;dialogHeight:415px;scroll:no;resizable:no;status:no; help:no;edge:sunken";
		            feature = feature + GetShowModalPosition(455, 365);
		
		            if (url != "")
		                var rtn = window.showModalDialog(url, para, feature);
		
		            if (rtn[0] == "TRUE") {
		                InitSelCabinetInfo(rtn[1]);
		            }
		        }
		    }
		
		    function btnChangeCabinet_onclick_Complete(rtn) {
		        DivPopUpHidden();
		        if (rtn[0] == "TRUE") {
		            InitSelCabinetInfo(rtn[1]);
		        }
		    }
		    function InitSelCabinetInfo(szSelCabXml) {
		        var CabXml = createXmlDom();
		        CabXml = loadXMLString(szSelCabXml);
		
		        g_CabinetID = SelectSingleNodeValue(CabXml.documentElement.childNodes[0], "CABINETID");
		        g_RecTypeCode = SelectSingleNodeValue(CabXml.documentElement.childNodes[0], "RECTYPE");
		
		        tdCabinetName.innerHTML = SelectSingleNodeValue(CabXml.documentElement.childNodes[0], "CABINETNAME");
		        tdCabinetType.innerHTML = SelectSingleNodeValue(CabXml.documentElement.childNodes[0], "RECTYPE");
		        tdCabinetVolNo.innerHTML = SelectSingleNodeValue(CabXml.documentElement.childNodes[0], "CABINETVOLNO");
		
		        InitCabinetInfo(GetCabinetClassInfo(g_CabinetID));
		        InitRegisterType();
		    }
		    function btnClose_onclick() {
		        rtnVal[0] = "FALSE";
		
		        if (ReturnFunction != null) {
		            ReturnFunction(rtnVal);
		            window.close();
		        }
		        else {
		            window.returnValue = rtnVal;
		            window.close();
		        }
		    }
		    window.onbeforeunload = function () {
		        window.returnValue = rtnVal;
		    };
		    function CheckLen(pObj, pSize) {
		        var ch;
		        var count = 0;
		        var nlen = pObj.value.length;
		        for (var k = 0; k < nlen; k++) {
		            ch = pObj.value.charAt(k);
		            if (escape(ch).length > 4)
		                count += 2;
		            else
		                count++;
		        }
		        if (parseInt(count) > parseInt(pSize)) {
		            alert("<spring:message code='ezApprovalG.t1086'/>" + pSize + " byte " + "<spring:message code='ezApprovalG.t1087'/>");
		            pObj.focus();
		            return false;
		        }
		        else
		            return true;
		    }
		    //document.onkeydown = function (evt) {
		    //    var e = evt;
		    //    if (e == null) e = window.event;
		    //    if (new RegExp(/Safari/).test(navigator.userAgent) && navigator.userAgent.indexOf("Chrome") == -1) {
		    //        if ((e.keyCode > 47) && (e.keyCode < 58))
		    //        {
		    //            e.preventDefault();
		    //        }
		    //        else if ((e.keyCode > 95) && (e.keyCode < 106))
		    //        {
		    //            e.preventDefault();
		    //        }
		    //        else if ((e.keyCode > 64) && (e.keyCode < 91))
		    //        {
		    //            e.preventDefault();
		    //        }
		    //        else if ((e.keyCode == 106) ||
		    //            (e.keyCode == 107) ||
		    //            (e.keyCode == 109) ||
		    //            (e.keyCode == 110) ||
		    //            (e.keyCode == 111) ||
		    //            (e.keyCode == 186) ||
		    //            (e.keyCode == 187) ||
		    //            (e.keyCode == 188) ||
		    //            (e.keyCode == 189) ||
		    //            (e.keyCode == 190) ||
		    //            (e.keyCode == 191) ||
		    //            (e.keyCode == 192) ||
		    //            (e.keyCode == 219) ||
		    //            (e.keyCode == 220) ||
		    //            (e.keyCode == 221) ||
		    //            (e.keyCode == 222))  
		    //        {
		    //            e.preventDefault();
		    //        }
		    //        else if ((e.keyCode == 229))
		    //        {
		    //            e.returnValue = false;
		    //        }
		    //    }
		    //}
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t1076'/></h1>
		<h2><spring:message code='ezApprovalG.t1018'/></h2>
		<table class="content">
		  <tr>
		    <th ><spring:message code='ezApprovalG.t1063'/></th>
		    <td><table style="width:100%">
		        <tr>
		          <td id="tdCabinetName">&nbsp;</td>
		          <td style="width:70px"><a class="imgbtn"><span onclick="return btnChangeCabinet_onclick()"><spring:message code='ezApprovalG.t1064'/></span></a></td>
		        </tr>
		      </table></td>
		  </tr>
		  <tr>
		    <th><spring:message code='ezApprovalG.t1088'/></th>
		    <td id="tdCabinetType"  >&nbsp;</td>
		  </tr>
		  <tr>
		    <th><spring:message code='ezApprovalG.t573'/></th>
		    <td id="tdCabinetVolNo"  >&nbsp;</td>
		  </tr>
		</table>
		<h2 style="margin-top:10px" ><spring:message code='ezApprovalG.t1089'/></h2>
		<table class="content">
		  <tr>
		    <th><spring:message code='ezApprovalG.t859'/></th>
		    <td><Select id="selRegisterType" style="width:100%" onChange="return selRegisterType_onchange()"></Select>
		    </td>
		  </tr>
		  <tr>
		    <th><spring:message code='ezApprovalG.t106'/></th>
		    <td><input type="text" class="text" style="Width:98%;" name="txtTitle" id="txtTitle">
		    </td>
		  </tr>
		  <tr>
		    <th><spring:message code='ezApprovalG.t979'/></th>
		    <td><input type="text" class="text" style="Width:60px;" name="txtNumOfPage" id="txtNumOfPage">
		      &nbsp;<spring:message code='ezApprovalG.t980'/></td>
		  </tr>
		</table>
		<table style="display:none;width:380px" id="divAudioVisualDummy" >
		  <tr>
		    <td></td>
		  </tr>
		</table>
		
		<Div id="divAudioVisual">
		  <h2 style="margin-top:10px" ><spring:message code='ezApprovalG.t1074'/></h2>
		  <table class="content" >
		    <tr>
		      <th><spring:message code='ezApprovalG.t1075'/></th>
		      <td><TextArea style="width:100%; height:70px" id=txtSummary name=txtSummary></TextArea>
		      </td>
		    </tr>
		    <tr >
		      <th><spring:message code='ezApprovalG.t826'/></th>
		      <td id=tdAVType><table border="0" style="border-collapse:collapse; border-spacing:0;padding:0px;height:140px;width:100%">
		          <tr>
		            <td id=tdAVType1 style="padding-right:0; padding-left:0;overflow:auto;vertical-align:top"></td>
		            <td id=tdAVType2 style="padding-right:0; padding-left:0;vertical-align:top"></td>
		          </tr>
		        </table></td>
		    </tr>
		  </table>
		</Div>
		
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