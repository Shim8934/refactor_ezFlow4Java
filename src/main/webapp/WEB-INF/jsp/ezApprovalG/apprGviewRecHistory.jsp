<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>  
<title><spring:message code='ezApprovalG.t1181'/></title>
<link rel="stylesheet" href="<spring:message code='ezStatistics.e2' />" type="text/css" />
<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
<script type="text/javascript" ID="clientEventHandlersJS">
    var g_RecID, g_SepAttNo;
    var CompanyID = "${userInfo.companyID}";
    var UserLang = "${userInfo.lang}";
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
</head>
<body class="popup">
<h1><spring:message code='ezApprovalG.t1181'/></h1>
<div id="close"><ul><li><span onclick="return cmdConfirm_onclick()"><spring:message code='ezApprovalG.t64'/></span></li></ul></div>

<h2 id="tdTitle"> <spring:message code='ezApprovalG.t1179'/></h2>
<div class="listview" style="width:592px;overflow-x:auto;">
<div id="RecordList" style="overflow-y:auto;border:0px; HEIGHT: 200px; WIDTH: 1000px;margin:1px 1px 1px 1px;"></div>
</div>
						
<h2 style="margin-top:5px" > <spring:message code='ezApprovalG.t626'/></h2>
<TextArea id="txtChangeReason" style="Width:592px; height:80px" readonly="readonly"></TextArea>

<script type="text/javascript" >
	selToggleList(document.getElementById("close"), "ul", "li", "0");
</script>

</body>
</html>
