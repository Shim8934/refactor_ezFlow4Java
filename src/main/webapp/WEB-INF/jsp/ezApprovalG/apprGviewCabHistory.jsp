<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
   <title><spring:message code='ezApprovalG.t1176'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<style>
	.mainlist tr th {border-top:0px}
</style>
<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
<script type="text/javascript"  ID="clientEventHandlersJS">
    var g_CabClassNo;
    var OrderCell = "";
    var CompanyID = "<c:out value='${userInfo.companyID}'/>";
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
        createNodeAndInsertText(xmlpara, objNode, "LANGTYPE", "<c:out value='${userInfo.lang}'/>");
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
	<div id="close">
		<ul>
			<li>
				<span onClick="return cmdConfirm_onclick()"></span>
			</li>
		</ul>
	</div>
<h2 id="tdTitle" class="h2_dot" style="font-weight: normal;"><spring:message code='ezApprovalG.t1179'/></h2>
<div class="listview" id="divList" style="width:100%;HEIGHT:200px; overflow:auto;">
    <div ID="lvtDoclist"></div>
</div>
<h2 class="h2_dot" style="margin-top:5px; font-weight: normal;"><spring:message code='ezApprovalG.t626'/></h2>
<TextArea id="txtChangeReason" Style="width:99%; height:130px; resize:none; overflow: auto;" readonly></TextArea>
</body>
</html>
