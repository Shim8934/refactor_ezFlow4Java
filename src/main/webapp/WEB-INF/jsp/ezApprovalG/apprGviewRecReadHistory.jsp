<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezApprovalG.t1184'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
<script type="text/javascript" ID="clientEventHandlersJS">
    var g_DocID;
    var CompanyID = "<c:out value='${userInfo.companyID}'/>";
    var UserLang = "<c:out value='${userInfo.lang}'/>";
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
</script>
	<style>
	    	.mainlist tr th {border-top:0px}
	 </style>
</head>

<body style="background-color:#FFFFFF;" class="popup" >
<h1><spring:message code='ezApprovalG.t1184'/></h1>
<div id="close"><ul><li><span onClick="return cmdConfirm_onclick()"></span></li></ul></div>
<h2 class="h2_dot" id="tdTitle" style="font-weight: normal;"><spring:message code='ezApprovalG.t1186'/></h2>
<div class="listview" style="width:100%; "> 
<div id=lvList style="overflow:auto; border:0; height: 355px; width:100%;"></div>
</div>
</body>
</html>
