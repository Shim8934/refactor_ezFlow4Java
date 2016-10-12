<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<HEAD>
<title><spring:message code='ezApprovalG.t1224'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
<script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/SendOffer_Cross.js"></script>
<link rel="stylesheet" href="/css/main_Cross.css"  type="text/css"/>
<link rel="stylesheet" href="/css/organ_tree.css" type="text/css"/>
<script type="text/javascript">
    var pDocID = "${docID}";
    var pServerName = "${serverName}";
    var param = new Array();
    param[0] = "cancel";
    var OrderCell = "";
    var TreeIdx;
    var ReturnFunction;
    var NonActiveX = "YES";
    var RtnVal = "";
    window.onload = function () {
        try {
            ReturnFunction = parent.opener.selectreceipts_cross_dialogArguments[1];
        } catch (e) {
            try {
                ReturnFunction = opener.selectreceipts_cross_dialogArguments[1];
            } catch (e) {
            }
        }
        
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getReceiptinfo.do",
    		data : {
    				docID : pDocID,
    				mode  : "END"
    				},
    		success: function(xml){
    			 RtnVal=loadXMLString(xml);
    		}        			
    	});
        var listview = new ListView();                          
        listview.SetID("AprReceipt1");                              
        listview.SetMulSelectable(false);                       
        listview.SetRowOnDblClick("AprDeptAdd_onclick");                     
        listview.DataSource(RtnVal);                            
        listview.DataBind("lvAprReceipt1");                        

        var listview = new ListView();                          
        listview.SetID("SelReceipt");                              
        listview.SetMulSelectable(false);                       
        listview.SetRowOnDblClick("AprDeptDel_onclick");

        if (CrossYN()){
        	listview.DataSource(SELRECEIPTHEADER);
        }
            else {
            var objXML = createXmlDom();
            objXML = loadXMLString(SELRECEIPTHEADER.xml);
            
            listview.DataSource(objXML);
        }
        
        listview.DataBind("lvSelReceipt");
        if (!CrossYN())
            window.returnValue = param;
    }
    var ezapralert_cross_dialogArguments = new Array();
    function OpenAlertUI(pAlertContent, CompleteFunction) {
        var parameter = pAlertContent;
        var url = "/ezApprovalG/ezAprAlert.do";

        if (CrossYN()) {
            ezapralert_cross_dialogArguments[0] = parameter;
            if (CompleteFunction != undefined)
                ezapralert_cross_dialogArguments[1] = CompleteFunction;
            else
                ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
            DivPopUpShow(330, 205, url);
        }
        else {
            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
            feature = feature + GetShowModalPosition(330, 205);
            var RtnVal = window.showModalDialog(url, parameter, feature);
        }
    }

    function OpenAlertUI_Complete() {
        DivPopUpHidden();
    }
    function btn_OpinionOK_onclick() {
        var listview = new ListView();
        listview.LoadFromID("SelReceipt");

        var tr = listview.GetDataRows();

        if (tr.length > 0 && tr[0].id.indexOf("noItems") == -1) {
            param[0] = "OK";
            param[1] = new Array();
            param[2] = new Array();
            param[3] = new Array();
            param[4] = new Array();

            for (var i = 0 ; i < tr.length ; i++) {
                param[1][i] = tr[i].getAttribute("DATA1");
                param[2][i] = tr[i].getAttribute("DATA3");
                param[3][i] = tr[i].getAttribute("DATA2");
                param[4][i] = tr[i].getAttribute("DATA4");
            }
            if (ReturnFunction != null)
                ReturnFunction(param);
            else
                window.returnValue = param;
            window.close();
        }
        else {
            var alertcontent = "<spring:message code='ezApprovalG.t1225'/>";
            OpenAlertUI(alertcontent);
            return;
        }
    }
    function btn_CancelOK_onclick() {
        if (ReturnFunction != null)
            ReturnFunction(param);
        else
            window.returnValue = param;
        window.close();
    }
    var g_SelTab = "1";
    var g_SelExtTree = false;
    function Tab_MoveClick(pTab) {
        if (pTab != g_SelTab) {
            g_SelTab = pTab;
        }

        switch (pTab) {
            case "1":
                TD_Receipt1.style.display = "";
                TD_Receipt2.style.display = "none";

                break;
            case "2":
                TD_Receipt1.style.display = "none";
                TD_Receipt2.style.display = "";

                if (!g_SelExtTree) {
                    initTreeInfoExt();
                    g_SelExtTree = true;
                }
                break;
        }
    }
    function initTreeInfoExt() {
        try {
            var xmlhttp = createXMLHttpRequest();

            xmlhttp.open("POST", "/ezOrgan/getOrganTreeInfo.do", false);
            xmlhttp.send();

            if (getNodeText(xmlhttp.responseXML) == "") {
                hideProgress();
                OpenAlertUI("<spring:message code='ezApprovalG.t1226'/>");
            }
            else {
                Tree_setconfig();

                var treeView = new TreeView();
                treeView.SetID("FromTreeView");
                treeView.SetUseAgency(true);
                treeView.SetRequestData("RequestDataG");
                treeView.SetNodeClick("TreeViewNodeClick");
                treeView.DataSource(xmlhttp.responseXML);
                treeView.DataBind("TreeView");
            }
        }
        catch (e) {
            hideProgress();
            alert("initTreeInfoExt" + e.description);
        }

        hideProgress();
    }
    function Tree_setconfig() {
        var xmlHTTP = createXMLHttpRequest();
        xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
        xmlHTTP.send();

        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
            var treeView = new TreeView();
            treeView.SetConfig(xmlHTTP.responseXML);
        }
    }
    var nodeIdx;
    function TreeViewNodeClick() {
        var treeView = new TreeView();
        treeView.LoadFromID("FromTreeView");

        var selnode = treeView.GetSelectNode();
        nodeIdx = selnode;
    }
    function RequestDataG(pNodeID, pTreeID) {
        var treeView = new TreeView();
        treeView.LoadFromID("FromTreeView");

        TreeIdx = pNodeID;
        var treeNode = new TreeNode();
        treeNode.LoadFromID(TreeIdx);

        try {
            var xmlhttp = createXMLHttpRequest();
            var xmlpara = createXmlDom();

            var objNode;
            createNodeInsert(xmlpara, objNode, "PARA");
            createNodeAndInsertText(xmlpara, objNode, "DEPTID", treeNode.GetNodeData("DATA2"));

            xmlhttp.open("POST", "/ezOrgan/getOrganSubTreeInfo.do", false);
            xmlhttp.send(xmlpara);

            var xmlRtn = createXmlDom(); 
            xmlRtn = loadXMLString(xmlhttp.responseText);

            if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
                if (CrossYN()) {
                    xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
                }
                else {
                    xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
                }
            }

            var treeView = new TreeView();
            treeView.LoadFromID("FromTreeView");

            treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
        }
        catch (e) {
            hideProgress();
            alert("RequestDataG" + e.description);
        }

        hideProgress();
    }
    var g_progresswin = null;
    function showProgress() {
        g_progresswin = window.showModelessDialog("/myoffice/common/show_progress.aspx?fileinfo=" + escape("<spring:message code='ezApprovalG.t244'/>"), "", "dialogWidth=390px; dialogHeight:185px; center:yes; status:no; help:no; edge:sunken;");
    }
    function hideProgress() {
        try {
            if (g_progresswin)
                g_progresswin.close();
        }
        catch (e) { }
    }
    function AprDeptAdd_onclick(pNodeID) {
    	
        if (g_SelTab == "1") {
            var listview = new ListView();
            listview.LoadFromID("AprReceipt1");

            var objSelRows = listview.GetSelectedRows();

            if (objSelRows.length > 0) {
                var tmpNoDeptList = "";
                var tmpOffList = "";
                for (var i = 0 ; i < objSelRows.length ; i++) {
                    var tmpDeptName = GetChildNodes(objSelRows[i])[1].innerText;
                    var tmpDeptName1 = objSelRows[i].getAttribute("DATA10");
                    var tmpDeptID = objSelRows[i].getAttribute("DATA1");
                    var tmpProcessYN = objSelRows[i].getAttribute("DATA4");
                    var tmpDeptName2 = objSelRows[i].getAttribute("DATA11");

                    if (tmpDeptID.toLowerCase().indexOf("address") == 0) {
                        if (tmpOffList != "")
                            tmpOffList += ", ";

                        tmpOffList += tmpDeptName;
                    }
                    else if (CheckSelReceipt(tmpDeptID)) {
                        if (tmpNoDeptList != "")
                            tmpNoDeptList += ", ";

                        tmpNoDeptList += tmpDeptName;
                    }
                    else {
                        var listview = new ListView();                          
                        listview.LoadFromID("SelReceipt");                              

                        var DeptAddIndex = listview.GetRowCount();
                        if (DeptAddIndex > 0 && listview.GetDataRows()[0].id.indexOf("noItems") == -1 || DeptAddIndex == 0)
                            DeptAddIndex = DeptAddIndex + 1;

                        var tr = listview.GetSelectedRows();
                        var InitTr = listview.GetDataRows();

                        var MaxID = 0;
                        if (InitTr > 0 && InitTr[0].id.indexOf("noItems") == -1) {
                            for (var j = 0  ; j < InitTr.length  ; j++) {
                                var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
                                if (MaxID < curnum)
                                    MaxID = curnum;
                            }
                        }

                        var addXml = "<LISTVIEWDATA>";
                        addXml += "<ROW>";
                        addXml += "<CELL>";
                        addXml += "<VALUE><![CDATA[" + tmpDeptName + "]]></VALUE>";
                        addXml += "<DATA1><![CDATA[" + tmpDeptID + "]]></DATA1>";
                        addXml += "<DATA2><![CDATA[" + tmpProcessYN + "]]></DATA2>";
                        addXml += "<DATA3><![CDATA[" + tmpDeptName1 + "]]></DATA3>";
                        addXml += "<DATA4><![CDATA[" + tmpDeptName2 + "]]></DATA4>";
                        addXml += "</CELL>";
                        addXml += "</ROW>";
                        addXml += "</LISTVIEWDATA>";
                        var xmlDoc = createXmlDom();
                        xmlDoc = loadXMLString(addXml);

                        if (tr.length == 0) {
                            if (InitTr.length == 0) {
                                var objTr = listview.AddRow(0);
                                SetAttribute(objTr, "id", "SelReceipt" + "_TR_" + eval(MaxID + 1));
                                listview.AddDataRow(objTr, xmlDoc);
                            }
                            else {
                                var objTr = listview.AddRow(DeptAddIndex - 1);
                                SetAttribute(objTr, "id", "SelReceipt" + "_TR_" + eval(MaxID + 1));
                                listview.AddDataRow(objTr, xmlDoc);
                            }
                        }
                        else {
                            var objTr = listview.AddRow(DeptAddIndex - 1);
                            SetAttribute(objTr, "id", "SelReceipt" + "_TR_" + eval(MaxID + 1));
                            listview.AddDataRow(objTr, xmlDoc);
                        }
                    }
                }

                if (tmpNoDeptList != "") {
                    var alertcontent = "<spring:message code='ezApprovalG.t1227'/><br><br>" + tmpNoDeptList;
                    OpenAlertUI(alertcontent);
                    return;
                }

                if (tmpOffList != "") {
                    var alertcontent = "<spring:message code='ezApprovalG.t1228'/><br><br>" + tmpOffList;
                    OpenAlertUI(alertcontent);
                    return;
                }
            }
            else {
                var alertcontent = "<spring:message code='ezApprovalG.t1229'/>";
                OpenAlertUI(alertcontent);
                return;
            }
        }
        else {
            var treeNode = new TreeNode();
            treeNode.LoadFromID(nodeIdx.NodeID);

            if (nodeIdx <= 1) {
                var alertcontent = "<spring:message code='ezApprovalG.t1229'/>";
                OpenAlertUI(alertcontent);
                return;
            }

            if (CheckSelReceipt(treeNode.GetNodeData("DATA1"))) {
                var alertcontent = "<spring:message code='ezApprovalG.t1230'/>";
                OpenAlertUI(alertcontent);
                return;
            }

            var rtnNodes = getExtLdapInfo(treeNode.GetNodeData("DATA1"));
            rtnNodes = SelectNodes(rtnNodes, "ORGAN");

            if (rtnNodes == null) return false;
            if (GetChildNodes(rtnNodes[0]).length <= 0) return false;

            var OutDeptList = "";
            if (getNodeText(GetChildNodes(rtnNodes[0])[0]) == getNodeText(GetChildNodes(rtnNodes[0])[4])) {
                if (getNodeText(GetChildNodes(rtnNodes[0])[8]) == "")
                    OutDeptList = getNodeText(GetChildNodes(rtnNodes[0])[2]) + "<spring:message code='ezApprovalG.t177'/>";
                else
                    OutDeptList = getNodeText(GetChildNodes(rtnNodes[0])[8]);
            }
            else {
                var tempRtnNodes = getExtLdapInfo(getNodeText(GetChildNodes(rtnNodes[0])[4]));
                tempRtnNodes = SelectNodes(tempRtnNodes, "ORGAN");

                if (tempRtnNodes == null) return false;
                if (GetChildNodes(tempRtnNodes[0]).length <= 0) {
                    if (getNodeText(GetChildNodes(rtnNodes[0])[8]) == "")
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes[0])[2]) + "<spring:message code='ezApprovalG.t177'/>";
                    else
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes[0])[8]);
                }
                else {
                    if (getNodeText(GetChildNodes(rtnNodes[0])[8]) == "")
                        OutDeptList = getNodeText(GetChildNodes(tempRtnNodes[0])[2]) + "<spring:message code='ezApprovalG.t177'/>";
                    else
                        OutDeptList = getNodeText(GetChildNodes(tempRtnNodes[0])[8]);

                    if (getNodeText(GetChildNodes(rtnNodes[0])[8]) == "")
                        OutDeptList = OutDeptList + "(" + getNodeText(GetChildNodes(rtnNodes[0])[2]) + "<spring:message code='ezApprovalG.t1231'/>";
                    else
                        OutDeptList = OutDeptList + "(" + getNodeText(GetChildNodes(rtnNodes[0])[8]) + ")";
                }
            }

            var listview = new ListView();                          
            listview.LoadFromID("SelReceipt");                              

            var DeptAddIndex = listview.GetRowCount();
            if (DeptAddIndex > 0 && listview.GetDataRows()[0].id.indexOf("noItems") == -1 || DeptAddIndex == 0)
                DeptAddIndex = DeptAddIndex + 1;

            var tr = listview.GetSelectedRows();
            var InitTr = listview.GetDataRows();

            var MaxID = 0;
            if (InitTr > 0 && InitTr[0].id.indexOf("noItems") == -1) {
                for (var j = 0  ; j < InitTr.length  ; j++) {
                    var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
                    if (MaxID < curnum)
                        MaxID = curnum;
                }
            }
            var addXml = "<LISTVIEWDATA>";
            addXml += "<ROW>";
            addXml += "<CELL>";
            addXml += "<VALUE><![CDATA[" + OutDeptList + "]]></VALUE>";
            addXml += "<DATA1><![CDATA[" + treeNode.GetNodeData("DATA1") + "]]></DATA1>";
            addXml += "<DATA2><![CDATA[" + "N" + "]]></DATA2>";
            addXml += "<DATA3><![CDATA[" + treeNode.GetNodeData("VALUE") + "]]></DATA3>";
            addXml += "<DATA4></DATA4>";
            addXml += "</CELL>";
            addXml += "</ROW>";
            addXml += "</LISTVIEWDATA>";
            var xmlDoc = createXmlDom();
            xmlDoc = loadXMLString(addXml);

            if (tr.length == 0) {
                if (InitTr.length == 0) {
                    var objTr = listview.AddRow(0);
                    SetAttribute(objTr, "id", "SelReceipt" + "_TR_" + eval(MaxID + 1));
                    listview.AddDataRow(objTr, xmlDoc);
                }
                else {
                    var objTr = listview.AddRow(DeptAddIndex - 1);
                    SetAttribute(objTr, "id", "SelReceipt" + "_TR_" + eval(MaxID + 1));
                    listview.AddDataRow(objTr, xmlDoc);
                }
            }
            else {
                var objTr = listview.AddRow(DeptAddIndex - 1);
                SetAttribute(objTr, "id", "SelReceipt" + "_TR_" + eval(MaxID + 1));
                listview.AddDataRow(objTr, xmlDoc);
            }
        }
    }
    function getExtLdapInfo(OrganCode) {
        try {
            var xmlhttp = createXMLHttpRequest();
            var xmlpara = createXmlDom();

            var objNode;
            createNodeInsert(xmlpara, objNode, "PARA");
            createNodeAndInsertText(xmlpara, objNode, "ORGID", OrganCode);

            xmlhttp.open("POST", "/myoffice/ezApprovalG/ezOrganG/GetOrgInfo.aspx", false);
            xmlhttp.send(xmlpara);

            return xmlhttp.responseXML;
        }
        catch (e) {
            return "";
        }
    }
    function AprDeptDel_onclick() {
        var listview = new ListView();
        listview.LoadFromID("SelReceipt");

        var objSelRows = listview.GetSelectedRows();
        var iLen = objSelRows.length;

        if (iLen > 0) {
            for (var i = 0 ; i < iLen ; i++) {
                var selRow = objSelRows[i];

                if (selRow) {
                    listview.DeleteRow(GetAttribute(selRow, "id"));
                }
            }
        }
        else {
            var alertcontent = "<spring:message code='ezApprovalG.t1232'/>";
            OpenAlertUI(alertcontent);
            return;
        }
    }
    function CheckSelReceipt(pSelDeptID) {
        var listview = new ListView();
        listview.LoadFromID("SelReceipt");

        var objRows = listview.GetDataRows();

        for (var i = 0 ; i < objRows.length ; i++) {
            if (objRows[i].getAttribute("DATA1") == pSelDeptID)
                return true;
        }

        return false;
    }



    var g_xmlHTTP;
    var searchorganglist_dialogArguments = new Array();
    var checkname2_cross_dialogArguments = new Array();
    function btnSearchDept_onClick() {

        var tmpDeptName = txtOuterDeptName.value;
        if (tmpDeptName.length < 3) {
            var pAlertContent = strLang243;
            OpenAlertUI(pAlertContent);
            document.getElementById("txtOuterDeptName").focus();
            return;
        }
        if (CrossYN()) {
            searchorganglist_dialogArguments[0] = g_progresswin;
            searchorganglist_dialogArguments[1] = btnSearchDept_onClick_Complete;

            DivPopUpShow(600, 600, "/myoffice/ezApprovalG/ezOrganG/SearchOrganGList.aspx?keyword=" + escape(tmpDeptName));
        }
        else {
            var feature = "status:no;dialogWidth:600px;dialogHeight:600px;scroll:no;edge:sunken;help:no;";
            feature = feature + GetShowModalPosition(600, 600);
            reParam = window.showModalDialog("/myoffice/ezApprovalG/ezOrganG/SearchOrganGList.aspx?keyword=" + escape(tmpDeptName), g_progresswin, feature);
            document.getElementById("txtOuterDeptName").focus();


            btnSearchDept_onClick_Complete(reParam);
        }
    }

    function btnSearchDept_onClick_Complete(reParam) {
        DivPopUpHidden();
        if (reParam["ret"] == "OK") {

            if (CheckSelReceipt(reParam["ouCode"])) {
                var alertcontent = "<spring:message code='ezApprovalG.t1230'/>";
                OpenAlertUI(alertcontent);
                return;
            }


            var rtnNodes = getExtLdapInfo(reParam["ouCode"]);
            rtnNodes = SelectNodes(rtnNodes, "ORGAN");


            if (rtnNodes == null) return false;
            if (GetChildNodes(rtnNodes[0]).length <= 0) return false;

            var OutDeptList = "";
            if (getNodeText(GetChildNodes(rtnNodes[0])[0]) == getNodeText(GetChildNodes(rtnNodes[0])[4])) {
                if (getNodeText(GetChildNodes(rtnNodes[0])[8]) == "")
                    OutDeptList = getNodeText(GetChildNodes(rtnNodes[0])[2]) + "<spring:message code='ezApprovalG.t177'/>";
                else
                    OutDeptList = getNodeText(GetChildNodes(rtnNodes[0])[8]);
            }
            else {
                var tempRtnNodes = getExtLdapInfo(getNodeText(GetChildNodes(rtnNodes[0])[4]));
                tempRtnNodes = SelectNodes(tempRtnNodes, "ORGAN");

                if (tempRtnNodes == null) return false;
                if (GetChildNodes(tempRtnNodes[0]).length <= 0) {
                    if (getNodeText(GetChildNodes(rtnNodes[0])[8]) == "")
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes[0])[2]) + "<spring:message code='ezApprovalG.t177'/>";
                    else
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes[0])[8]);
                }
                else {
                    if (getNodeText(GetChildNodes(rtnNodes[0])[8]) == "")
                        OutDeptList = getNodeText(GetChildNodes(tempRtnNodes[0])[2]) + "<spring:message code='ezApprovalG.t177'/>";
                    else
                        OutDeptList = getNodeText(GetChildNodes(tempRtnNodes[0])[8]);

                    if (getNodeText(GetChildNodes(rtnNodes[0])[8]) == "")
                        OutDeptList = OutDeptList + "(" + getNodeText(GetChildNodes(rtnNodes[0])[2]) + "<spring:message code='ezApprovalG.t1231'/>";
                    else
                        OutDeptList = OutDeptList + "(" + getNodeText(GetChildNodes(rtnNodes[0])[8]) + ")";
                }
            }

            var listview = new ListView();
            listview.LoadFromID("SelReceipt");

            var DeptAddIndex = listview.GetRowCount();
            if (DeptAddIndex > 0 && listview.GetDataRows()[0].id.indexOf("noItems") == -1 || DeptAddIndex == 0)
                DeptAddIndex = DeptAddIndex + 1;

            var tr = listview.GetSelectedRows();
            var InitTr = listview.GetDataRows();

            var MaxID = 0;
            if (InitTr > 0 && InitTr[0].id.indexOf("noItems") == -1) {
                for (var j = 0  ; j < InitTr.length  ; j++) {
                    var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
                    if (MaxID < curnum)
                        MaxID = curnum;
                }
            }
            var addXml = "<LISTVIEWDATA>";
            addXml += "<ROW>";
            addXml += "<CELL>";
            addXml += "<VALUE><![CDATA[" + OutDeptList + "]]></VALUE>";
            addXml += "<DATA1><![CDATA[" + reParam["ouCode"] + "]]></DATA1>";
            addXml += "<DATA2><![CDATA[" + "N" + "]]></DATA2>";
            addXml += "<DATA3><![CDATA[" + reParam["chiefTitle"] + "]]></DATA3>";
            addXml += "<DATA4></DATA4>";
            addXml += "</CELL>";
            addXml += "</ROW>";
            addXml += "</LISTVIEWDATA>";
            var xmlDoc = createXmlDom();
            xmlDoc = loadXMLString(addXml);

            if (tr.length == 0) {
                if (InitTr.length == 0) {
                    var objTr = listview.AddRow(0);
                    SetAttribute(objTr, "id", "SelReceipt" + "_TR_" + eval(MaxID + 1));
                    listview.AddDataRow(objTr, xmlDoc);
                }
                else {
                    var objTr = listview.AddRow(DeptAddIndex - 1);
                    SetAttribute(objTr, "id", "SelReceipt" + "_TR_" + eval(MaxID + 1));
                    listview.AddDataRow(objTr, xmlDoc);
                }
            }
            else {
                var objTr = listview.AddRow(DeptAddIndex - 1);
                SetAttribute(objTr, "id", "SelReceipt" + "_TR_" + eval(MaxID + 1));
                listview.AddDataRow(objTr, xmlDoc);
            }

        }
        else if (reParam["ret"] == "MULTISELECT") {
            /* 2015-06-30 표준모듈:추가(외부수신자요약, 검색된 수신자 다중 추가) - KSK */
            for (var i = 0; i < reParam["ouCode"].length; i++) {
                if (CheckSelReceipt(reParam["ouCode"][i])) {
                    var alertcontent = "<spring:message code='ezApprovalG.t1230'/>";
                    OpenAlertUI(alertcontent);
                    return;
                }


                var rtnNodes = getExtLdapInfo(reParam["ouCode"][i]);
                rtnNodes = SelectNodes(rtnNodes, "ORGAN");


                if (rtnNodes == null) return;
                if (GetChildNodes(rtnNodes[0]).length <= 0) return;

                var OutDeptList = "";
                if (getNodeText(GetChildNodes(rtnNodes[0])[0]) == getNodeText(GetChildNodes(rtnNodes[0])[4])) {
                    if (getNodeText(GetChildNodes(rtnNodes[0])[8]) == "")
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes[0])[2]) + "<spring:message code='ezApprovalG.t177'/>";
                    else
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes[0])[8]);
                }
                else {
                    var tempRtnNodes = getExtLdapInfo(getNodeText(GetChildNodes(rtnNodes[0])[4]));
                    tempRtnNodes = SelectNodes(tempRtnNodes, "ORGAN");

                    if (tempRtnNodes == null) return;
                    if (GetChildNodes(tempRtnNodes[0]).length <= 0) {
                        if (getNodeText(GetChildNodes(rtnNodes[0])[8]) == "")
                            OutDeptList = getNodeText(GetChildNodes(rtnNodes[0])[2]) + "<spring:message code='ezApprovalG.t177'/>";
                        else
                            OutDeptList = getNodeText(GetChildNodes(rtnNodes[0])[8]);
                    }
                    else {
                        if (getNodeText(GetChildNodes(rtnNodes[0])[8]) == "")
                            OutDeptList = getNodeText(GetChildNodes(tempRtnNodes[0])[2]) + "<spring:message code='ezApprovalG.t177'/>";
                        else
                            OutDeptList = getNodeText(GetChildNodes(tempRtnNodes[0])[8]);

                        if (getNodeText(GetChildNodes(rtnNodes[0])[8]) == "")
                            OutDeptList = OutDeptList + "(" + getNodeText(GetChildNodes(rtnNodes[0])[2]) + "<spring:message code='ezApprovalG.t1231'/>";
                        else
                            OutDeptList = OutDeptList + "(" + getNodeText(GetChildNodes(rtnNodes[0])[8]) + ")";
                    }
                }

                var listview = new ListView();
                listview.LoadFromID("SelReceipt");

                var DeptAddIndex = listview.GetRowCount();
                if (DeptAddIndex > 0 && listview.GetDataRows()[0].id.indexOf("noItems") == -1 || DeptAddIndex == 0)
                    DeptAddIndex = DeptAddIndex + 1;

                var tr = listview.GetSelectedRows();
                var InitTr = listview.GetDataRows();

                var MaxID = 0;
                for (var j = 0  ; j < InitTr.length  ; j++) {
                    var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
                    if (MaxID < curnum)
                        MaxID = curnum;
                }
                var addXml = "<LISTVIEWDATA>";
                addXml += "<ROW>";
                addXml += "<CELL>";
                addXml += "<VALUE><![CDATA[" + OutDeptList + "]]></VALUE>";
                addXml += "<DATA1><![CDATA[" + reParam["ouCode"][i] + "]]></DATA1>";
                addXml += "<DATA2><![CDATA[" + "N" + "]]></DATA2>";
                addXml += "<DATA3><![CDATA[" + reParam["chiefTitle"][i] + "]]></DATA3>";
                addXml += "<DATA4></DATA4>";
                addXml += "</CELL>";
                addXml += "</ROW>";
                addXml += "</LISTVIEWDATA>";
                var xmlDoc = createXmlDom();
                xmlDoc = loadXMLString(addXml);

                if (tr.length == 0) {
                    if (InitTr.length == 0) {
                        var objTr = listview.AddRow(0);
                        SetAttribute(objTr, "id", "SelReceipt" + "_TR_" + eval(MaxID + 1));
                        listview.AddDataRow(objTr, xmlDoc);
                    }
                    else {
                        var objTr = listview.AddRow(DeptAddIndex - 1);
                        SetAttribute(objTr, "id", "SelReceipt" + "_TR_" + eval(MaxID + 1));
                        listview.AddDataRow(objTr, xmlDoc);
                    }
                }
                else {
                    var objTr = listview.AddRow(DeptAddIndex - 1);
                    SetAttribute(objTr, "id", "SelReceipt" + "_TR_" + eval(MaxID + 1));
                    listview.AddDataRow(objTr, xmlDoc);
                }
            }
        }
    }

    function btnSearchDept_onKeyPress2(e) {
        if (e.keyCode == "13") {
            document.getElementById("Span7").onclick();
        }
    }

</script>
</HEAD>
<body class="popup">
<XML id="SELRECEIPTHEADER" style="display:none">
<LISTVIEWDATA>
	<HEADERS>
		<HEADER>
			<NAME><spring:message code='ezApprovalG.t1233'/></NAME>
			<WIDTH></WIDTH>
		</HEADER>
	</HEADERS>
</LISTVIEWDATA>
</XML>
<!-- <OBJECT id="behave1" style="DISPLAY: none" height="0" width="0" classid="clsid:F8E93A35-2D04-4E2C-A04D-87947594C674"></OBJECT> -->
<h1><spring:message code='ezApprovalG.t1225'/></h1>
<table>
  <tr>
    <td><div id="tabnav" style="width:383px">
        <ul>
          <li id="tagsub1"><span onClick="Tab_MoveClick('1')" ><spring:message code='ezApprovalG.t1234'/></span></li>
          <li id="tagsub2"><span onClick="Tab_MoveClick('2')" ><spring:message code='ezApprovalG.t1235'/></span></li>
        </ul>
      </div>
	  <table>
        <tr>
          <td id="TD_Receipt1"><div class="listview">
             
			<div id="lvAprReceipt1" STYLE="overflow:auto; border:0; HEIGHT: 410px; WIDTH: 375px;margin:1px 1px 1px 1px"></div>
			</div></td>
          <td id="TD_Receipt2" style="display:none">
          <div class="box" style="overflow:auto;width:380px;height:389px" id="TreeView"></div>
              <input id="txtOuterDeptName" style="width: 150px;margin-top:2px;" name="textUser2" onkeyup="return btnSearchDept_onKeyPress2(event)"  maxlength="50">
              <a style="margin-top: 2px" class="imgbtn"><span id="Span7" onkeyup="return btnSearchDept_onClick()" onclick="return btnSearchDept_onClick()" ><spring:message code='ezApprovalG.t250'/></span></a>
          </td>
        </tr>
      </table>
	  </td>
    <td style="width:25px;text-align:center"><img id="AprDeptAdd" alt="<spring:message code='ezApprovalG.t331'/>" src="/images/arr_right.gif" style="cursor:pointer" width="16" height="16" onClick="return AprDeptAdd_onclick()"><img id="AprDeptDel" alt="<spring:message code='ezApprovalG.t332'/>" src="/images/arr_left.gif" style="cursor:pointer" width="16" height="16" onClick="return AprDeptDel_onclick()"> </td>
	<td><div class="listview" style="margin-top:38px" >
		<div ID="lvSelReceipt" STYLE="overflow:auto; border:0;	HEIGHT: 410px; WIDTH: 290px;margin:1px 1px 1px 1px"></div>
      </div></td>
  </tr>
</table>

<div class="btnposition">
  <a class="imgbtn"><span id="btn_OpinionOK" onclick="return btn_OpinionOK_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
  <a class="imgbtn"><span id="btn_CancelOK" onclick="return btn_CancelOK_onclick()"><spring:message code='ezApprovalG.t119'/></span></a>  
</div>
<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
<script type="text/javascript" >
	selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
</script>
</body>
</HTML>
