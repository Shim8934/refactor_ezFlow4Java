<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
   <title><spring:message code='ezApprovalG.t1176'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
<script type="text/javascript"  ID="clientEventHandlersJS">
    var g_CabClassNo;
    var OrderCell = "";
    var CompanyID = "${userInfo.companyID}";
    var g_szParamXml="";
    var g_CabListXmlhttp=null;
    window.onload=window_onload;
    window.onbeforeunload = window_onunload;
    window.onunload = window_onunload;
    var RetValue;
    var ReturnFunction;
    function window_onload() {
        try {
            RetValue = parent.viewcabhistory_cross_dialogArguments[0];
            ReturnFunction = parent.viewcabhistory_cross_dialogArguments[1];
        } catch (e) {
            try {
                RetValue = opener.viewcabhistory_cross_dialogArguments[0];
                ReturnFunction = opener.viewcabhistory_cross_dialogArguments[1];
            } catch (e) {
                RetValue = window.dialogArguments;
            }
        }
       
        g_CabClassNo = RetValue[0];
        GetCabinetHistory_Cross(g_CabClassNo);
    }
    function window_onunload() {
    }
    function CabinetList_rowdblclick() {
        btnViewInfo_onclick();
    }
    function cmdConfirm_onclick() {
        window.close();
    }
    function GetCabinetHistory_Cross(pCabClassNo) {
        var oXmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();		
        var objNode = createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
        createNodeAndInsertText(xmlpara, objNode, "CABCLASSNO", pCabClassNo);
        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
        createNodeAndInsertText(xmlpara, objNode, "LANGTYPE", "${userInfo.lang}");
        oXmlhttp.open("POST", "/ezApprovalG/getCabinetHistory.do", false);
        oXmlhttp.send(xmlpara);

        var rtnXml = oXmlhttp.responseXML;
        var DataNodes = GetChildNodes(rtnXml);

        if (getNodeText(DataNodes[0]) == "FALSE") {
            alert("<spring:message code='ezApprovalG.t1178'/>");
        }
        else {
            InsertToHistoryListView(rtnXml);
        }
    }
    function InsertToHistoryListView(Resultxml) {
        for (var i = 0; i < GetChildNodes(SelectSingleNodeNew(Resultxml, "LISTVIEWDATA/ROWS")).length; i++) {
            GetChildNodes(SelectSingleNodeNew(Resultxml, "LISTVIEWDATA/ROWS"))[i].removeChild(GetChildNodes(GetChildNodes(SelectSingleNodeNew(Resultxml, "LISTVIEWDATA/ROWS"))[i])[6]);
        }

        var ListViewData = SelectSingleNodeNew(Resultxml, "LISTVIEWDATA");
	
        if (ListViewData == null)
            return;

        if (document.getElementById("lvtDoclist").innerHTML != "") document.getElementById("lvtDoclist").innerHTML = "";
        var DocList = new ListView();                           
        DocList.SetID("DocList");                               
        DocList.SetMulSelectable(true);                        
        DocList.SetHeaderOnClick("lvtDoclist_HeaderClick");      
        DocList.SetRowOnClick("lvtDoclist_SelChange");           
        DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");      
        DocList.SetOrderbyCol("COLNAME");
        DocList.SetTitleIdx(0);                                  
        DocList.DataSource(ListViewData);                             
        DocList.DataBind("lvtDoclist");                          
        DocList = null;
    }
    function lvtDoclist_onSel_DBclick() {
    }
    function lvtDoclist_SelChange() {
        var DocList = new ListView();          
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();
        if (selRow.length > 0) {
            txtChangeReason.value = selRow[0].getAttribute("DATA3");
        }
        else {
            OpenAlertUI(strLang578);
        }
    }
    function lvtDoclist_HeaderClick() {
    }
</SCRIPT>
</head>
<body class="popup" >

<h1><spring:message code='ezApprovalG.t1176'/></h1>
<div id="close"><ul><li><span onClick="return cmdConfirm_onclick()"><spring:message code='ezApprovalG.t64'/></span></li></ul></div>

<h2 id="tdTitle"> <spring:message code='ezApprovalG.t1179'/></h2>
<div class="listview"  style="width:100%;HEIGHT:200px;WIDTH: 585px; overflow-x:auto;overflow-y:AUTO" id="divList">
    <div ID="lvtDoclist" style="margin: 1px 1px 1px 1px;"></div>
</div>
<h2 style="margin-top:5px" > <spring:message code='ezApprovalG.t626'/></h2>
<TextArea id="txtChangeReason" Style="Width:97%; height:80px" readonly></TextArea>

<script type="text/javascript"  >
	selToggleList(document.getElementById("close"), "ul", "li", "0");
</script>
</body>
</html>
