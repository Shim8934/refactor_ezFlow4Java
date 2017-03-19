<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE HTML>
<html>
<head>
    <title><spring:message code='ezApproval.t322'/></title>
    
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	<script type="text/javascript" src="/js/ezApprovalG/TreeView.js"></script>
	<script type="text/javascript" src="/js/ezApprovalG/Common_Function.js"></script>
    <script type="text/javascript" id="clientEventHandlersJS">
	    var pUserID = "${userInfo.id}";
	    var sCompanyID = "${userInfo.companyID}";
    
        var nodeIdx;
        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
            window.onblur = function () {
                window.focus();
            }
        }
        var ReturnFunction;
        window.onload = function () {
            try {
                try {
                    ReturnFunction = opener.SelUserCont_dialogArgument[1];
                } catch (e) {
                    try {
                        ReturnFunction = parent.SelUserCont_dialogArgument[1];
                    } catch (e) {
                    }
                }
                if(!CrossYN())
                    window.returnValue = "cancel";

                Tree_setconfig();
                var xmlDom = createXmlDom();
                xmlDom = loadXMLString("${userCont}");

                var treeView = new TreeView();
                treeView.SetID("UserContTree");
                treeView.SetUseAgency(true);
                treeView.SetRequestData("RequestData");
                treeView.SetNodeClick("TreeViewNodeClick");
                treeView.DataSource(xmlDom);
                treeView.DataBind("divUserContTree");

            }
            catch (ErrMsg) {
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
        function TreeViewNodeClick(pNodeID, pNodeNM) {
            nodeIdx = pNodeID;
        }
        function RequestData(pNodeID, pTreeID) {
            var treeNode = new TreeNode();
            treeNode.LoadFromID(pNodeID);

            var xmlHTTP = createXMLHttpRequest();
            var strQuery = "<DATA><USERID>" + pUserID + "</USERID><ParentContID>" + treeNode.GetNodeData("DATA1") + "</ParentContID><NAME></NAME></DATA>";
            xmlHTTP.open("POST", "/ezApprovalG/getUserContSubTree.do", false);
            xmlHTTP.send(strQuery);

            var treeView = new TreeView();
            treeView.LoadFromID(pTreeID);
            treeView.AppendChildNodes(loadXMLString(xmlHTTP.responseText).documentElement, pNodeID)
        }
        function btnOK_onclick() {
            var treeNode = new TreeNode();
            treeNode.LoadFromID(nodeIdx);
            if (nodeIdx == "" || nodeIdx == undefined) {
                OpenAlertUI("<spring:message code='ezApproval.t319'/>");
                return;
            }

            if (ReturnFunction != null) {
                ReturnFunction(treeNode.GetNodeData("DATA1"));
            }
            else {
                window.returnValue = treeNode.GetNodeData("DATA1");
            }
            window.close();
        }
        function btnCancel_onclick() {
            if (ReturnFunction != null)
                ReturnFunction("cancel");
            else {
                window.returnValue = "cancel";
            }
            window.close();
        }      
    </script>
</head>
<body class="popup">

    <h1><spring:message code='ezApproval.t323'/></h1>
    <div class="box" style="WIDTH: 315px; HEIGHT: 300px; BACKGROUND-COLOR: #fff; overflow: auto;" id="divUserContTree"></div>
    <div class="btnposition">
        <a class="imgbtn" onclick="return btnOK_onclick()"><span><spring:message code='ezApprovalG.t105'/></span></a>
        <a class="imgbtn" onclick="return btnCancel_onclick()"><span><spring:message code='ezApprovalG.t119'/></span></a>
    </div>
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
    <iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
    </div>
</body>
</html>


