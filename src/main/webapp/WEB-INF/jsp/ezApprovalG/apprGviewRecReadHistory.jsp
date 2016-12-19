<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezApprovalG.t1184'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
<script type="text/javascript" ID="clientEventHandlersJS">
    var g_DocID;
    var CompanyID = "${userInfo.companyID}";
    var UserLang = "${userInfo.lang}";
    var OrderCell = "";
    var RetValue;
    var ReturnFunction;
    window.onload = function () {
        try {
            RetValue = parent.viewrecreadhistory_cross_dialogArguments[0];
            ReturnFunction = parent.viewrecreadhistory_cross_dialogArguments[1];
        } catch (e) {
            try {
                RetValue = opener.viewrecreadhistory_cross_dialogArguments[0];
                ReturnFunction = opener.viewrecreadhistory_cross_dialogArguments[1];
            } catch (e) {
                RetValue = window.dialogArguments;
            }
        }
        g_DocID = RetValue[0];
        GetRecReadHistory()
    }
    function lvList_rowclick() {
    }
    function lvList_rowdblclick() {
    }
    function cmdConfirm_onclick() {
        window.close();
    }
    function GetRecReadHistory() {
        var oXmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();   
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETERS");
        createNodeAndInsertText(xmlpara, objNode, "DOCID", g_DocID);
        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
        createNodeAndInsertText(xmlpara, objNode, "LANGTYPE", UserLang);

        oXmlhttp.open("POST", "/ezApprovalG/getRecReadHistory.do", false);
        oXmlhttp.send(xmlpara);

        var rtnXml = oXmlhttp.responseXML;

        if (getNodeText(GetChildNodes(rtnXml)[0]) == "FALSE") {
            alert("<spring:message code='ezApprovalG.t1185'/>");
        }
        else {
            var listview = new ListView();
            listview.SetID("List");
            listview.SetMulSelectable(false);
            listview.SetRowOnDblClick("lvList_rowdblclick");
            listview.SetRowOnClick("lvList_rowclick");
            listview.DataSource(rtnXml);
            listview.DataBind("lvList");
        }
    }
</SCRIPT>
</head>

<body style="background-color:#FFFFFF;margin-left:0px;margin-top:0px" class="popup" >
<h1><spring:message code='ezApprovalG.t1184'/></h1>
<div id="close"><ul><li><span onClick="return cmdConfirm_onclick()"><spring:message code='ezApprovalG.t64'/></span></li></ul></div>
<h2 id="tdTitle"> <spring:message code='ezApprovalG.t1186'/></h2>
<div class="listview" style="WIDTH: 593px;"> 
<DIV id=lvList style="overflow:auto; border:0;HEIGHT: 300px; WIDTH: 591px;margin:1px 1px 1px 1px"></DIV>
</div>
</body>
</html>
