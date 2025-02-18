<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t344'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/control_Cross/TreeView.js')}" ></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeViewCtrl_Cross.js')}"></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var DeptID, DeptName;
	        var xmlHTTP = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var P_companyID;
	        var P_DeptID;
	        var Para = new Array();
	        var topID = "";
	        var ReturnFunction;
	
	        
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	        window.onload = function () {
	            try {
	                dialogArguments = opener.organ_dialogArguments[0];
	                ReturnFunction = opener.organ_dialogArguments[1];
	            } catch (e) { }
	
	            topID = dialogArguments;
	            
	            /* 2020-10-21 홍승비 - 관리자단 전자결재 > 문서삭제, 문서이동(부서선택, 이동)에서 현재 선택한 회사의 조직도 표출 */
	            if (topID == "") {
	                topID = "top";
	            }
				topID += "/organ";
	
	            Tree_setconfig();
	
	            TreeViewinitialize("", topID, "extensionAttribute2;extensionAttribute3", "${serverName}", null, null, true);
	            Para[0] = "";
	            Para[1] = "";
	            window.returnValue = Para;
	        }
	
	        function Tree_setconfig() {
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
	            xmlHTTP.send();
	
	            if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
	                var treeView = new TreeView();
	                
	                treeView.SetConfig(loadXMLString(xmlHTTP.responseText));
	            }
	        }
	        function pNodeDblClick() {
	
	        }
	        function bt_Ok_onclick() {
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            nodeIdx = treeView.GetSelectNode();
	
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(nodeIdx.NodeID);
	            
	            // 전체 회사 조직도 표출 및 선택 가능
	        //    if (treeNode.GetNodeData("EXTENSIONATTRIBUTE2") == topID) {
	                Para[0] = treeNode.GetNodeData("CN");
	                Para[1] = treeNode.GetNodeData("VALUE");
	                Para[2] = treeNode.GetNodeData("EXTENSIONATTRIBUTE2"); // 선택한 부서/회사의 회사ID를 전달
	
	                if(ReturnFunction != null)
	                    ReturnFunction(Para);
	                window.close();
/* 	            }
	            else {
	            	// 2018-06-20. 황윤호  관리자 > 전자결재 > alert창 짤림 수정
	            	window.close();
		            window.opener.alert("<spring:message code='ezApproval.t774'/>");
	            } */
	        }
	
	        function bt_Close_onclick() {
	            Para[0] = "";
	            Para[1] = "";
	
	            if (ReturnFunction != null)
	                ReturnFunction(Para);
	            window.close();
	        }
	    var nodeIdx;
	    function TreeViewNodeClick() {
	        nodeIdx = TreeView.selectedIndex;
	    }
	
	    function TreeViewNodeDbClick() {
	    }
	    </script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApproval.t344'/></h1>
	    <div id="close">
            <ul>
                <li><span onclick="bt_Close_onclick()"></span></li>
            </ul>
        </div>
	    <div id="TreeView" style="border: 1px solid #ddd; height: 370px; width: 100%; overflow-x: auto; overflow-y: auto; background-color: #FFFFFF;" onnodedblclick="TreeView.toggle(TreeView.selectedIndex)"></div>
	    <div class="btnpositionNew">
	        <a class="imgbtn" onclick="bt_Ok_onclick()"><span><spring:message code='ezApproval.t84'/></span></a>
	    </div>
	</body>
</html>