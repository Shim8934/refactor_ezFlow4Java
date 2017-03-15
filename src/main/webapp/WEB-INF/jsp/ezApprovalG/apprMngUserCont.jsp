<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE HTML>
<html>
<head>
    <title><spring:message code='ezApproval.t316'/></title>
    
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	<script type="text/javascript" src="/js/ezApprovalG/TreeView.js"></script>
    <script type="text/javascript" src="/js/escapenew.js"></script>
	<script type="text/javascript" src="/js/ezApprovalG/Common_Function.js"></script>
    <script type="text/javascript" id="clientEventHandlersJS">
        var pUserID = "${userInfo.id}";
        var sCompanyID = "${userInfo.companyID}";
        
        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
            window.onblur = function () {
                window.focus();
            }
        }
        var ReturnFunction;
        window.onload = function () {
            try {
                
                try {
                    ReturnFunction = opener.mngusercont_dialogArgument[1];
                } catch (e) {
                    try {
                        ReturnFunction = parent.mngusercont_dialogArgument[1];
                    } catch (e) {
                    }
                }                    

                Tree_setconfig();
                var xmlDom2 = createXmlDom();
                xmlDom2 = loadXMLString("${userCont}");
                var treeView = new TreeView();
                treeView.SetID("UserContTree");
                treeView.SetUseAgency(true);
                treeView.SetRequestData("RequestData");
                treeView.SetNodeClick("TreeViewNodeClick");
                treeView.DataSource(xmlDom2);
                treeView.DataBind("divUserContTree");
            } catch (ErrMsg) {
                alert(ErrMsg.description);
            }
        }
        function Tree_setconfig() {
            var xmlHTTP = createXMLHttpRequest();
            xmlHTTP.open("GET", "/xml/ezApproval/conttree_config.xml", false);
            xmlHTTP.send();

            if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
                var treeView = new TreeView();
                treeView.SetConfig(loadXMLString(xmlHTTP.responseText));
            }
        }
        function TreeViewRefresh() {
            var xmlHTTP = createXMLHttpRequest();
            var strQuery = "<DATA><USERID>" + pUserID + "</USERID><ParentContID>ROOT</ParentContID><NAME></NAME></DATA>";
            xmlHTTP.open("POST", "/ezApprovalG/getUserContSubTree.do", false);
            xmlHTTP.send(strQuery);

            var xmlDomRet = createXmlDom();
            xmlDomRet = loadXMLString(xmlHTTP.responseText);

            document.getElementById('divUserContTree').innerHTML = "";

            var treeView = new TreeView();
            treeView.SetID("UserContTree");
            treeView.SetUseAgency(true);
            treeView.SetRequestData("RequestData");
            treeView.SetNodeClick("TreeViewNodeClick");
            treeView.DataSource(xmlDomRet);
            treeView.DataBind("divUserContTree");
        }
        var nodeIdx;
        function TreeViewNodeClick(pNodeID, pNodeNM) {
            nodeIdx = pNodeID;
        }
        function RequestData(pNodeID, pTreeID) {
            var xmlHTTP = createXMLHttpRequest();

            var treeNode = new TreeNode();
            treeNode.LoadFromID(pNodeID);

            var strQuery = "<DATA><USERID>" + pUserID + "</USERID><ParentContID>" + treeNode.GetNodeData("DATA1") + "</ParentContID><NAME></NAME></DATA>";
            xmlHTTP.open("POST", "/ezApprovalG/getUserContSubTree.do", false);
            xmlHTTP.send(strQuery);

            var treeView = new TreeView();
            treeView.LoadFromID(pTreeID);
            treeView.AppendChildNodes(loadXMLString(xmlHTTP.responseText).documentElement, pNodeID)
        }
        
        function btnCancel_onclick() {
            ReturnFunction("cancel");
            window.close();
        }
        
        function btnIns_onclick() {
            if (nodeIdx == undefined) {
                var pAlertContent = "<spring:message code='ezApproval.t299'/>";
                OpenAlertUI(pAlertContent);
                return;
            }
            if (CrossYN())
                getContName("", "INS");
            else {
                var treeNode = new TreeNode();
                treeNode.LoadFromID(nodeIdx);

                var ContID = treeNode.GetNodeData("DATA1");
                var ContName = getContName("");
                if (ContName != "cancel") {
                    getContName_Complete(ContName, "INS");
                }
            }
        }
        function btnEdit_onclick() {
            if (nodeIdx == undefined) {
                var pAlertContent = "<spring:message code='ezApproval.t302'/>";
                OpenAlertUI(pAlertContent);
                return;
            }

            var treeNode = new TreeNode();
            treeNode.LoadFromID(nodeIdx);

            var ContID = treeNode.GetNodeData("DATA1");
            if (CrossYN())
                getContName(treeNode.GetNodeData("VALUE"), "MOD");
            else {
                var treeNode = new TreeNode();
                treeNode.LoadFromID(nodeIdx);

                var ContID = treeNode.GetNodeData("DATA1");
                var ContName = getContName(treeNode.GetNodeData("VALUE"));
                if (ContName != "cancel") {
                    getContName_Complete(ContName, "MOD");
                }
            }
        }
        function btnDel_onclick() {
            if (nodeIdx == undefined) {
                var pAlertContent = "<spring:message code='ezApproval.t305'/>";
                OpenAlertUI(pAlertContent);
                return;
            }
            var treeNode = new TreeNode();
            treeNode.LoadFromID(nodeIdx);

            if (treeNode.GetNodeData("DATA2") == "ROOT") {
                var pAlertContent = "<spring:message code='ezApproval.t306'/>";
                OpenAlertUI(pAlertContent);
                return;
            }

            var ContName = treeNode.GetNodeData("VALUE");
            var OpinionContent = "[" + ContName + "] <spring:message code='ezApproval.t307'/>";

            if (CrossYN()){
                OpenInformationUI(OpinionContent, Del_Complete);
            }
            else {
                var Rtnval = OpenInformationUI(OpinionContent, Del_Complete);
                if (Rtnval) {
                    Del_Complete(Rtnval);
                }
            }
        }

        function Del_Complete(RtnVal) {
            var treeNode = new TreeNode();
            treeNode.LoadFromID(nodeIdx);
            var ContName = treeNode.GetNodeData("VALUE");
            var ContID = treeNode.GetNodeData("DATA1");            
            if (RtnVal) {
                var rvalue = DelUserCont(ContID, "CHECK");
                if (rvalue == "FALSE" || rvalue == "") {
                    var pAlertContent = "<spring:message code='ezApproval.t308'/>";
                    OpenAlertUI(pAlertContent);
                    return;
                }
                else if (rvalue == "TRUE") {
                    var pAlertContent = "<spring:message code='ezApproval.t309'/>";
                    OpenAlertUI(pAlertContent);
                    TreeViewRefresh();
                    return;
                }
                else {
                    var OpinionContent = "[" + ContName + "] <spring:message code='ezApproval.t310'/>" + rvalue + "]<spring:message code='ezApproval.t311'/>"
                    OpenInformationUI(OpinionContent, Del_Complete_MUST);
                }
            }
        }

        function Del_Complete_MUST(Rtnval) {
            var treeNode = new TreeNode();
            treeNode.LoadFromID(nodeIdx);
            var ContID = treeNode.GetNodeData("DATA1");
            if (Rtnval) {
                var rvalue = DelUserCont(ContID, "MUST");
                if (rvalue == "TRUE") {
                    var pAlertContent = "<spring:message code='ezApproval.t309'/>";
                    OpenAlertUI(pAlertContent);
                    TreeViewRefresh();
                    return;
                }
                else {
                    var pAlertContent = "<spring:message code='ezApproval.t308'/>";
                    OpenAlertUI(pAlertContent);
                    return;
                }
            }
        }
        
        var getcontname_dialogArgument = new Array();
        function getContName(tempName, type) {
            var windowName = "/ezApprovalG/getContName.do?Title=&TitleText=" + escapenew(tempName);
            if (CrossYN()) {
                var para = new Array();
                para[0] = type;
                getcontname_dialogArgument[0] = para;
                getcontname_dialogArgument[1] = getContName_Complete;
                DivPopUpShow(340, 200, windowName)
            }
            else {
                var parameter = "status:no;dialogWidth:340px;dialogHeight:200px;scroll:no;edge:sunken";
                parameter = parameter + GetShowModalPosition(340, 200);
                var ret = window.showModalDialog(windowName, "", parameter);
                return ret;
            }
        }
        function getContName_Complete(ContName, type) {
            DivPopUpHidden();
            var treeNode = new TreeNode();
            treeNode.LoadFromID(nodeIdx);

            var ContID = treeNode.GetNodeData("DATA1");
            if (ContName != "cancel") {
                var xmlhttp = createXMLHttpRequest();
                var xmlpara = createXmlDom();
                var objNode;

                if (type == "INS") {                    
                    createNodeInsert(xmlpara, objNode, "PARAMETER");
                    createNodeAndInsertText(xmlpara, objNode, "OwnUserID", pUserID);
                    createNodeAndInsertText(xmlpara, objNode, "pContID", ContID);
                    createNodeAndInsertText(xmlpara, objNode, "pContName", ContName);
                    createNodeAndInsertText(xmlpara, objNode, "Description", "");
                    xmlhttp.open("POST", "/ezApprovalG/insertUserCont.do", false);
                    xmlhttp.send(xmlpara);

                    var ResultXML = "";
                    ResultXML = loadXMLString(xmlhttp.responseText);
                    var dataNodes = GetChildNodes(ResultXML);

                    if (getNodeText(dataNodes[0]) == "TRUE") {
                        var pAlertContent = "<spring:message code='ezApproval.t300'/>";
                        OpenAlertUI(pAlertContent);
                        TreeViewRefresh();
                        return;
                    }
                    else {
                        var pAlertContent = "<spring:message code='ezApproval.t301'/>";
                        OpenAlertUI(pAlertContent);
                        return;
                    }
                }
                else if (type == "MOD") {
                    createNodeInsert(xmlpara, objNode, "PARAMETER");
                    createNodeAndInsertText(xmlpara, objNode, "ContID", ContID);
                    createNodeAndInsertText(xmlpara, objNode, "OwnUserID", pUserID);
                    createNodeAndInsertText(xmlpara, objNode, "pContID", "");
                    createNodeAndInsertText(xmlpara, objNode, "pContName", ContName);
                    createNodeAndInsertText(xmlpara, objNode, "Description", "");
                    xmlhttp.open("POST", "/ezApprovalG/updateUserCont.do", false);
                    xmlhttp.send(xmlpara);

                    var ResultXML = "";
                    ResultXML = loadXMLString(xmlhttp.responseText);
                    var dataNodes = GetChildNodes(ResultXML);

                    if (getNodeText(dataNodes[0]) == "TRUE") {
                        var pAlertContent = "<spring:message code='ezApproval.t303'/>";
                        OpenAlertUI(pAlertContent);
                        TreeViewRefresh();
                        return;
                    }
                    else {
                        var pAlertContent = "<spring:message code='ezApproval.t304'/>";
                        OpenAlertUI(pAlertContent);
                        return;
                    }
                }
            }
        }
        function DelUserCont(ContID, Mode) {
            var xmlhttp = createXMLHttpRequest();
            var xmlpara = createXmlDom();
            var objNode;
            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "ContID", ContID);
            createNodeAndInsertText(xmlpara, objNode, "Mode", Mode);

            xmlhttp.open("POST", "/ezApprovalG/deleteUserCont.do", false);
            xmlhttp.send(xmlpara);

            var ResultXML = "";
            ResultXML = loadXMLString(xmlhttp.responseText);
            var dataNodes = GetChildNodes(ResultXML);

            return getNodeText(dataNodes[0]);
        }
    </script>
</head>
<body class="popup">
    <h1><spring:message code='ezApproval.t317'/></h1>
    <div class="box" style="WIDTH: 440px; HEIGHT: 240px; overflow: auto; BACKGROUND-COLOR: #FFFFFF; padding: 4px 6px 6px 4px" id="divUserContTree"></div>
    <div class="btnposition">
        <a class="imgbtn" onclick="return btnIns_onclick()"><span><spring:message code='ezApproval.t313'/></span></a>
        <a class="imgbtn" onclick="return btnEdit_onclick()"><span><spring:message code='ezApproval.t314'/></span></a>
        <a class="imgbtn" onclick="return btnDel_onclick()"><span><spring:message code='ezApproval.t315'/></span></a>
        <a class="imgbtn" onclick="return btnCancel_onclick()"><span><spring:message code='ezApproval.t70'/></span></a>
    </div>
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
    <iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
    </div>
</body>
</html>


