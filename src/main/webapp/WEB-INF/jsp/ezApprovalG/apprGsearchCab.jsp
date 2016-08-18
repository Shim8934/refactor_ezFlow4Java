<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
   <title><spring:message code='ezApprovalG.t1090'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/OpenSelWin_Cross.js"></script>
<script ID="clientEventHandlersJS" type="text/javascript">
    var rtnVal = new Array();
    var g_AdminYN, g_DeptCode, g_DeptName;
    var g_SelTaskCode="";
    var g_SelChargerID="";
    var g_InitFlag="0";
    var CompanyID = "${userInfo.companyID}";
    window.onload = window_onload;
    window.onbeforeunload = window_onunload;
    var RetValue;
    var ReturnFunction;
    var NonActiveX = "YES";
    function window_onload() {
        var ua = navigator.userAgent;
        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
            KeEventControl(document.getElementById("txtTitle"));
        }

        try {
            RetValue = parent.searchcab_cross_dialogArguments[0];
            ReturnFunction = parent.searchcab_cross_dialogArguments[1];
        } catch (e) {
            try {
                RetValue = opener.searchcab_cross_dialogArguments[0];
                ReturnFunction = opener.searchcab_cross_dialogArguments[1];
            } catch (e) {
                RetValue = window.dialogArguments;
            }
        }
        g_AdminYN = RetValue[0];
        g_DeptCode = RetValue[1];
        g_DeptName = RetValue[2];
        g_InitFlag = RetValue[3];

        if (g_InitFlag == "1") {
            trTransExp.style.display = "none";
            trRejectCab.style.display = "";
            trSelDept.style.display = "none";
        }
        rtnVal[0] = "FALSE";
        InitCode();
        txtDeptName.value = g_DeptName;
    }
    function InitCode() {
        var result = "";
        $.ajax({
    		type : "POST",
    		dataType : "xml",
    		async : false,
    		url : "/ezApprovalG/getCodeList.do",
    		data : {
    			companyID : CompanyID
    		},
    		success: function(xml){
    			result = xml;
    		}        			
    	});

        var nodesRecType = SelectNodes(result, "CODELIST/RECORDTYPE/CODE");
        InitCodeSelBoxWithNullOpt(nodesRecType, selRecTypeCode);

        var nodesKeepPeriod = SelectNodes(result, "CODELIST/KEEPINGPERIOD/CODE");
        InitCodeSelBoxWithNullOpt(nodesKeepPeriod, selKeepPeriod);

        var nodesKeepMethod = SelectNodes(result, "CODELIST/KEEPINGMETHOD/CODE");
        InitCodeSelBoxWithNullOpt(nodesKeepMethod, selKeepMethod);

        var nodesKeepPlace = SelectNodes(result, "CODELIST/KEEPINGPLACE/CODE");
        InitCodeSelBoxWithNullOpt(nodesKeepPlace, selKeepPlace)
    }
    function SelectTask_OnClick() {
        SelectTask(g_DeptCode, g_DeptName, "0", "1");
    }
    function SelectTask_Complete(rtn) {
        DivPopUpHidden();
        if (rtn[0] == "TRUE")
            GetSelSTaskInfo(rtn[1]);
    }
    function GetSelSTaskInfo(szTaskXml) {
        var oXml = loadXMLString(szTaskXml);
        var nodesTask = GetElementsByTagName(oXml, "TASK");
        var iLen = nodesTask.length;
        var i;
        var SelTaskName = "";
        g_SelTaskCode = "";

        for (i = 0; i < iLen; i++) {
            if (g_SelTaskCode != "") {
                g_SelTaskCode += ",";
            }

            if (SelTaskName != "") {
                SelTaskName += ";";
            }
            g_SelTaskCode += "'" + SelectSingleNodeValue(nodesTask[i], "CODE") + "'";
            SelTaskName += SelectSingleNodeValue(nodesTask[i], "NAME");
        }
        txtTaskName.value = SelTaskName;
    }
    function SelectUser_OnClick() {
        SelectUser("", g_DeptCode);
    }

    function SelectDept_OnClick() {
        var rtn = SelectDept();

        if (rtn != undefined) {
            if (rtn[0] == "TRUE") {
                g_DeptCode = rtn[1];
                txtDeptName.value = rtn[2];
            }
        }
    }
    function GetSelUserInfo(szXml) {
        var oXml = loadXMLString(szXml);
        var nodesUser = GetElementsByTagName(oXml, "USER");
        var iLen = nodesUser.length;
        var i;
        var SelUserName = "";
        var SelUserName2 = "";
        g_SelChargerID = "";

        for (i = 0; i < iLen; i++) {
            if (g_SelChargerID != "") {
                g_SelChargerID += ",";
            }

            if (SelUserName != "") {
                SelUserName += ";";
            }

            if (SelUserName2 != "") {
                SelUserName2 += ";";
            }
            g_SelChargerID += "'" + SelectSingleNodeValue(nodesUser[i], "ID") + "'";
            SelUserName += SelectSingleNodeValue(nodesUser[i], "NAME");
            SelUserName2 += SelectSingleNodeValue(nodesUser[i], "NAME2");
        }
        txtCharger.value = SelUserName;
    }
    function reset_onclick() {
        txtTitle.value = "";
        g_SelTaskCode = "";
        txtTaskName.value = "";
        selSProduceY.selectedIndex = 0;
        selEProduceY.selectedIndex = 0;
        selSEndY.selectedIndex = 0;
        selEEndY.selectedIndex = 0;
        selRecTypeCode.selectedIndex = 0;
        selKeepPeriod.selectedIndex = 0;
        selKeepMethod.selectedIndex = 0;
        selKeepPlace.selectedIndex = 0;
        g_SelChargerID = "";
        txtCharger.value = "";
    }
    function btnSearch_onclick() {
        var oParamXml = GetCabSearchParamXml();
        if (getNodeText(oParamXml) != "") {
            rtnVal[0] = "TRUE";
            rtnVal[1] = getXmlString(oParamXml);
            window.close();
        }
        else {
            alert("<spring:message code='ezApprovalG.t1091'/>");
        }
    }
    function GetCabSearchParamXml() {
        var xmlpara = createXmlDom();
        var objRoot = createNodeInsert(xmlpara, objRoot, "SEARCHPARAM");
        var oData = createNodeAndInsertText(xmlpara, objRoot, "DEPTCODE", g_DeptCode);
        oData = createNodeAndInsertText(xmlpara, objRoot, "TITLE", txtTitle.value);
        oData = createNodeAndInsertText(xmlpara, objRoot, "TASKCODE", g_SelTaskCode);
        oData = createNodeAndInsertText(xmlpara, objRoot, "SPRODUCEY", selSProduceY.value);
        oData = createNodeAndInsertText(xmlpara, objRoot, "EPRODUCEY", selEProduceY.value);
        oData = createNodeAndInsertText(xmlpara, objRoot, "SENDY", selSEndY.value);
        oData = createNodeAndInsertText(xmlpara, objRoot, "EENDY", selEEndY.value);
        oData = createNodeAndInsertText(xmlpara, objRoot, "RECTYPECODE", selRecTypeCode.value);
        oData = createNodeAndInsertText(xmlpara, objRoot, "KEEPPERIOD", selKeepPeriod.value);
        oData = createNodeAndInsertText(xmlpara, objRoot, "KEEPMETHOD", selKeepMethod.value);
        oData = createNodeAndInsertText(xmlpara, objRoot, "KEEPPLACE", selKeepPlace.value);
        oData = createNodeAndInsertText(xmlpara, objRoot, "CHARGER", g_SelChargerID);

        var inText = "";
        if (chkTransExp.checked)
            inText = "TRUE";

        oData = createNodeAndInsertText(xmlpara, objRoot, "TRANSEXPIRE", inText);

        if (chkRejectCab.checked)
            inText = "128=128";

        oData = createNodeAndInsertText(xmlpara, objRoot, "TRANSFLAG", inText);
        oData = createNodeAndInsertText(xmlpara, objRoot, "RECEIVEDCAB", "");
        oData = createNodeAndInsertText(xmlpara, objRoot, "GIVECAB", "");
        return xmlpara;
    }
    function btnCancel_onclick() {
        rtnVal[0] = "FALSE";
        window.close();
    }
    function window_onunload() {
        if (ReturnFunction != null)
            ReturnFunction(rtnVal);
        else
            window.returnValue = rtnVal;
    }
</script>
</head>
<body class="popup" leftmargin="0" topmargin="0" LANGUAGE ="javascript">
<h1><spring:message code='ezApprovalG.t1090'/></h1>
<table class="content" >
    <tr id="trSelDept"> 
        <th><spring:message code='ezApprovalG.t827'/></th>
        <td style="vertical-align:middle">
            <input class="text" style=" WIDTH: 215px" name="txtDeptName" id=txtDeptName disabled>
            <a class="imgbtn" ><span onclick="return SelectDept_OnClick()" id="btnSelDept"><spring:message code='ezApprovalG.t105'/></span></a>
        </td>
    </tr>
    <tr> 
        <th><spring:message code='ezApprovalG.t1092'/></th>
        <td>
            <input class="text" style=" WIDTH:99%" name="txtTitle" id=txtTitle>    
        </td>
    </tr>
    <tr> 
        <th><spring:message code='ezApprovalG.t1093'/></th>
        <td>
            <input class="text" style=" WIDTH: 215px" name="txtTaskName" id=txtTaskName disabled>
            <a class="imgbtn"><span onClick="return SelectTask_OnClick()" id="btnSelTask"><spring:message code='ezApprovalG.t105'/></span></a>
        </td>
    </tr>
    <tr> 
        <th> <spring:message code='ezApprovalG.t1094'/></th>
        <td>
            <select name="selSProduceY" id="selSProduceY">${yearOption}</select>
            <spring:message code='ezApprovalG.t1095'/>
            <select name="selEProduceY" id="selEProduceY">${yearOption}</select>
            <spring:message code='ezApprovalG.t1096'/>
        </td>
    </tr>
    <tr> 
        <th> <spring:message code='ezApprovalG.t1097'/></th>
        <td>
            <select name="selSEndY" id="selSEndY">${yearOption}</select>
            <spring:message code='ezApprovalG.t1095'/>
            <select name="selEEndY" id="selEEndY">${yearOption}</select>
            <spring:message code='ezApprovalG.t1096'/>
        </td>
    </tr>
    <tr> 
        <th><spring:message code='ezApprovalG.t1088'/></th>
        <td><select name="selRecTypeCode" id="selRecTypeCode" style="HEIGHT: 20px;" ></select></td>
    </tr>
    <tr> 
        <th><spring:message code='ezApprovalG.t1098'/></th>
        <td>
            <select name="selKeepPeriod" id="selKeepPeriod" style="HEIGHT: 20px;"></select>
        </td>
    </tr>
    <tr> 
        <th><spring:message code='ezApprovalG.t1099'/></th>
        <td><select name="selKeepMethod" id="selKeepMethod" style="HEIGHT: 20px;"></select>
        </td>
    </tr>
    <tr> 
        <th><spring:message code='ezApprovalG.t1100'/></th>
        <td>
            <select name="selKeepPlace" id="selKeepPlace" style="HEIGHT: 20px;"></select>
        </td>
    </tr>
    <tr>
        <th> <spring:message code='ezApprovalG.t1101'/></th>
        <td>
            <input class="text" style=" WIDTH: 215px" name="txtCharger" id=txtCharger disabled>
            <a class="imgbtn"><span onClick="return SelectUser_OnClick()" id="btnSelUser" ><spring:message code='ezApprovalG.t105'/></span></a>
        </td>
    </tr>
  </table>
  
<h2 id="trTransExp"><input type="checkbox" name="chkTransExp" id="chkTransExp" value="1"><spring:message code='ezApprovalG.t1102'/></h2>
<h2 id="trRejectCab" style="display:none"><input type="checkbox" name="chkRejectCab" id="chkRejectCab" value="1"><spring:message code='ezApprovalG.t1103'/></h2>

<div class="btnposition">
    <a class="imgbtn"><span id="btnReset" onclick="return reset_onclick()"><spring:message code='ezApprovalG.t621'/></span></a>
    <a class="imgbtn"><span id="btnSearch" onclick="return btnSearch_onclick()"><spring:message code='ezApprovalG.t111'/></span></a>
    <a class="imgbtn"><span id="btnCancel" onclick="return btnCancel_onclick()"><spring:message code='ezApprovalG.t119'/></span></a>  
</div>
<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/myoffice/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>
