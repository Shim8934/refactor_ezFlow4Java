<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>  
<title><spring:message code='ezApprovalG.t1181'/></title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
<script type="text/javascript" ID="clientEventHandlersJS">
    var g_RecID, g_SepAttNo;
    var CompanyID = "<c:out value='${userInfo.companyID}'/>";
    var UserLang = "<c:out value='${userInfo.lang}'/>";
    var OrderCell = "";
    var RetValue;
    var ReturnFunction;
    window.onload = function () {
        try {
            RetValue = parent.viewrechistory_cross_dialogArguments[0];
            ReturnFunction = parent.viewrechistory_cross_dialogArguments[1];
        } catch (e) {
            try {
                RetValue = opener.viewrechistory_cross_dialogArguments[0];
                ReturnFunction = opener.viewrechistory_cross_dialogArguments[1];
            } catch (e) {
                RetValue = window.dialogArguments;
            }
        }
        g_RecID = RetValue[0];
        g_SepAttNo = RetValue[1];
        GetRecordHistory(g_RecID, g_SepAttNo);
    }
    function RecordList_rowclick() {
        var listview = new ListView();
        listview.LoadFromID("lvRecordList");

        var selRow = listview.GetSelectedRows();
        if (selRow) {
            txtChangeReason.value = selRow[0].getAttribute("DATA3");
        }
    }

    function RecordList_rowdblclick() {
        btnViewInfo_onclick();
    }
    function btnViewInfo_onclick() {
        var listview = new ListView();
        listview.LoadFromID("lvRecordList");

        var selRow = listview.GetSelectedRows();
        if (selRow) {

        }
        else {
            alert("<spring:message code='ezApprovalG.t1177'/>");
        }
    }
    function cmdConfirm_onclick() {
        window.close();
    }
    function GetRecordHistory(pRecID, pSepAttNo) {
        var oXmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETERS");
        createNodeAndInsertText(xmlpara, objNode, "RECORDID", pRecID);
        createNodeAndInsertText(xmlpara, objNode, "SEPATTACHNO", pSepAttNo);
        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
        createNodeAndInsertText(xmlpara, objNode, "LANGTYPE", UserLang);

        oXmlhttp.open("POST", "/ezApprovalG/getRecordHistory.do", false);
        oXmlhttp.send(xmlpara);

        var rtnXml = oXmlhttp.responseXML;

        if (getNodeText(GetChildNodes(rtnXml)[0]) == "FALSE") {
            alert("<spring:message code='ezApprovalG.t1178'/>");
        }
        else {
            var listview = new ListView();
            listview.SetID("lvRecordList");
            listview.SetMulSelectable(false);
            listview.SetRowOnDblClick("RecordList_rowdblclick");
            listview.SetRowOnClick("RecordList_rowclick");
            listview.DataSource(rtnXml);
            listview.DataBind("RecordList");
        }
    }
</script>
<style>
	.mainlist tr th {border-top:0px}
</style>
</head>
<body class="popup">
<h1><spring:message code='ezApprovalG.t1181'/></h1>
<div id="close"><ul><li><span onclick="return cmdConfirm_onclick()"></span></li></ul></div>

<h2 class="h2_dot" id="tdTitle" style="font-weight: normal;"> <spring:message code='ezApprovalG.t1179'/></h2>
<div class="listview" style="width:100%;overflow-x:auto;">
<div id="RecordList" style="overflow-y:auto;border:0px; HEIGHT: 200px; WIDTH: 100%;"></div>
</div>
						
<h2 class="h2_dot" style="margin-top:5px; font-weight: normal;"> <spring:message code='ezApprovalG.t626'/></h2>
<TextArea id="txtChangeReason" style="width:99%; height:138px; resize:none;" readonly="readonly"></TextArea>

</body>
</html>
