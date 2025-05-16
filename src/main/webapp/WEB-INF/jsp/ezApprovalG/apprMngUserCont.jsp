<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <title><spring:message code='ezApproval.t316'/></title>    
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
    <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeViewFolder.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Common_Function.js')}"></script>
    <script type="text/javascript" id="clientEventHandlersJS">
        var pUserID = "<c:out value='${userInfo.id}'/>";
        var sCompanyID = "<c:out value='${userInfo.companyID}'/>";
        
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
                        if (isParentCommonArgsUsed()) {
                            ReturnFunction = parent.ezCommon_cross_dialogArguments[1];
                        } else {
                            ReturnFunction = parent.mngusercont_dialogArgument[1];
                        }
                    } catch (e) {
                    }
                }                    

                Tree_setconfig();
                var xmlDom2 = createXmlDom();
                xmlDom2 = loadXMLString('${userCont}');
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
            if (nodeIdx == undefined || nodeIdx == "") {
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
                var ContName = valData;
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
            ContName = ContName.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("</", "&lt;/");
            
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
                    opener.TreeViewRefresh();
	                //선택한 노드 값 초기화
            		nodeIdx = undefined;
                    return;
                } else if (rvalue == "HASSUBCONT") {
                	var pAlertContent = "<spring:message code='ezApprovalG.pjj34'/>";
                    OpenAlertUI(pAlertContent);
                    return;
                }
                else {
                	ContName = ContName.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
                    var OpinionContent = "[" + ContName + "] <spring:message code='ezApproval.t310'/>" + rvalue + "]<spring:message code='ezApproval.t311'/>"
                    OpenInformationUI(OpinionContent, Del_Complete_MUST);
                }
            } else {
            	//self.close();
            	DivPopUpHidden();
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
            else {
            	DivPopUpHidden();
            }
        }
        
        var getcontname_dialogArgument = new Array();
        function getContName(tempName, type) {
            var windowName = "/ezApprovalG/getContName.do?Title=&TitleText=" + escape(encodeURIComponent(tempName));
            var height = "";
            
            if (navigator.userAgent.toLowerCase().indexOf("msie") != -1 || (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1)) { // IE
            	height = 211;
            } else { // Chrome
            	height = 205;
            }
            
            if (CrossYN()) {
                var para = new Array();
                para[0] = type;
                getcontname_dialogArgument[0] = para;
                getcontname_dialogArgument[1] = getContName_Complete;
                DivPopUpShow(330, height, windowName)
            }
            else {
                var parameter = "status:no;dialogWidth:330px;dialogHeight:" + height + "px;scroll:no;edge:sunken";
                parameter = parameter + GetShowModalPosition(330, height);
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
                    if (xmlhttp != null && xmlhttp.readyState == 4) {
    		            if (xmlhttp.status == 200) {
    		            	var ResultXML = "";
    	                    ResultXML = loadXMLString(xmlhttp.responseText);
    	                    var dataNodes = GetChildNodes(ResultXML);

    	                    if (getNodeText(dataNodes[0]) == "TRUE") {
    	                        var pAlertContent = "<spring:message code='ezApproval.t300'/>";
    	                        OpenAlertUI(pAlertContent);
    	                        TreeViewRefresh();
    	                        opener.TreeViewRefresh();
    	                      	//선택한 노드 값 초기화
           						nodeIdx = undefined;
    	                        return;
    	                    }
    		            } else {
    		            	 var pAlertContent = "<spring:message code='ezApproval.t301'/>";
    	                        OpenAlertUI(pAlertContent);
    	                        return;
    		            }
		        	}
                    
                } else if (type == "MOD") {
                    createNodeInsert(xmlpara, objNode, "PARAMETER");
                    createNodeAndInsertText(xmlpara, objNode, "ContID", ContID);
                    createNodeAndInsertText(xmlpara, objNode, "OwnUserID", pUserID);
                    createNodeAndInsertText(xmlpara, objNode, "pContID", "");
                    createNodeAndInsertText(xmlpara, objNode, "pContName", ContName);
                    createNodeAndInsertText(xmlpara, objNode, "Description", "");
                    xmlhttp.open("POST", "/ezApprovalG/updateUserCont.do", false);
                    xmlhttp.send(xmlpara);
                    
                    if (xmlhttp != null && xmlhttp.readyState == 4) {
    		            if (xmlhttp.status == 200) {
    		            	var ResultXML = "";
    	                    ResultXML = loadXMLString(xmlhttp.responseText);
    	                    var dataNodes = GetChildNodes(ResultXML);

    	                    if (getNodeText(dataNodes[0]) == "TRUE") {
    	                        var pAlertContent = "<spring:message code='ezApproval.t303'/>";
    	                        OpenAlertUI(pAlertContent);
    	                        TreeViewRefresh();
    	                        opener.TreeViewRefresh();
    	                        nodeIdx = undefined;
    	                        return;
    	                    }
    		            } else {
    		            	var pAlertContent = "<spring:message code='ezApproval.t304'/>";
                            OpenAlertUI(pAlertContent);
                            return;
    		            }
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
            
            if (xmlhttp.status == 200) {
            	 var ResultXML = "";
                 ResultXML = loadXMLString(xmlhttp.responseText);
                 var dataNodes = GetChildNodes(ResultXML);

                 return getNodeText(dataNodes[0]);
            } else {
            	return "FALSE";
            }
              
           
        }
    </script>
</head>
<body class="popup">
    <h1><spring:message code='ezApproval.t317'/></h1>
    <div id="close">
        <ul>
            <li><span onclick="return btnCancel_onclick()"></span></li>
        </ul>
    </div>
    <div class="box" style="WIDTH: 440px; HEIGHT: 270px; overflow: auto; BACKGROUND-COLOR: #FFFFFF; padding: 4px 6px 6px 4px" id="divUserContTree"></div>
    <div class="btnposition btnpositionNew">
        <a class="imgbtn" onclick="return btnIns_onclick()"><span><spring:message code='ezApproval.t313'/></span></a>
        <a class="imgbtn" onclick="return btnEdit_onclick()"><span><spring:message code='ezApproval.t314'/></span></a>
        <a class="imgbtn" onclick="return btnDel_onclick()"><span><spring:message code='ezApproval.t315'/></span></a>
    </div>
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
    <iframe src="<spring:message code='main.kms4' />" style="border:none; overflow:hidden;" id="iFrameLayer"></iframe>
    </div>
</body>
</html>


