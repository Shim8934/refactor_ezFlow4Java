<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <title><spring:message code='ezBoard.kmh20'/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/TreeView.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
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
                    ReturnFunction = opener.mnguserscrapcont_dialogArgument[1];
                } catch (e) {
                    try {
                        ReturnFunction = parent.mnguserscrapcont_dialogArgument[1];
                    } catch (e) {
                    }
                }                    

                Tree_setconfig();
                var xmlDom = createXmlDom();
                xmlDom = loadXMLString('${userScrapCont}');
                var treeView = new TreeView();
                treeView.SetID("UserScrapContTree");
                treeView.SetUseAgency(true);
                treeView.SetRequestData("UserScrapContRequestData");
                treeView.SetNodeClick("UserScrapContNodeClick");
                treeView.DataSource(xmlDom);
                treeView.DataBind("divUserScrapContTree");

                var node = $(".node_normal");

                for(var i=0; i<node.length; i++) {
                    node[i].setAttribute("TITLE", node[i].innerText);
                    node[i].innerText = node[i].innerText;
                }

            } catch (ErrMsg) {
                alert(ErrMsg.description);
            }
        }
        
        
        var ezboardalert_cross_dialogArguments = new Array();
		function OpenAlertUI(pAlertContent, CompleteFunction, type) {
		    var parameter = pAlertContent;
		    var url = "";
		    if(CompleteFunction == "OPEN") 
		        url = "/ezBoard/boardAlert.do?type=OPEN";
		    else
		        url = "/ezBoard/boardAlert.do";
		
		    if (CrossYN()) {
		        ezboardalert_cross_dialogArguments[0] = parameter;
		        ezboardalert_cross_dialogArguments[1] = CompleteFunction;
		
		        if (CompleteFunction != undefined) {
		            if (CompleteFunction == "OPEN")
		            {
		            	if (type != undefined) { //2018-09-20 김보미 - 윈도우 팝업창 확인 안닫히는 문제
		            		ezboardalert_cross_dialogArguments[2] = true;
		            	}
		            	ezboardalert_cross_dialogArguments[1] = OpenAlertUI_Complete;
		                var OpenWin = GetOpenWindow(url, "", 330, 205, "NO");
		            }
		            else
		                DivPopUpShow(330, 205, url);
		        }
		        else {            
		            ezboardalert_cross_dialogArguments[1] = OpenAlertUI_Complete;
		            DivPopUpShow(330, 205, url);
		        }
		    }
		    else {
		        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		        feature = feature + GetShowModalPosition(330, 205);
		        var RtnVal = window.showModalDialog(url, parameter, feature);
		    }
		}

		function OpenAlertUI_Complete(RtnVal) {
		    DivPopUpHidden();
		}
        
        function Tree_setconfig() {
            var xmlHTTP = createXMLHttpRequest();
            xmlHTTP.open("GET", "/xml/ezBoard/boardconttree_config.xml", false);
            xmlHTTP.send();

            if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
                var treeView = new TreeView();
                treeView.SetConfig(loadXMLString(xmlHTTP.responseText));
            }
        }

        function ScrapTreeViewRefresh() {
            var xmlHTTP = createXMLHttpRequest();
            var strQuery = "<DATA><USERID>" + pUserID + "</USERID><ParentScrapContID>ROOT</ParentScrapContID><NAME></NAME></DATA>";
            xmlHTTP.open("POST", "/ezBoard/getUserScrapContSubTree.do", false);
            xmlHTTP.send(strQuery);

            var xmlDomRet = createXmlDom();
            xmlDomRet = loadXMLString(xmlHTTP.responseText);

            document.getElementById('divUserScrapContTree').innerHTML = "";

            var treeView = new TreeView();
            treeView.SetID("UserScrapContTree");
            treeView.SetUseAgency(true);
            treeView.SetRequestData("UserScrapContRequestData");
            treeView.SetNodeClick("UserScrapContNodeClick");
            treeView.DataSource(xmlDomRet);
            treeView.DataBind("divUserScrapContTree");

            var node = $(".node_normal");

            for(var i=0; i<node.length; i++) {
                node[i].setAttribute("TITLE", node[i].innerText);
                node[i].innerText = node[i].innerText;
            }
        }
        
        var nodeIdx;
        function UserScrapContNodeClick(pNodeID, pNodeNM) {
            nodeIdx = pNodeID;
        }

        function UserScrapContRequestData(pNodeID, pTreeID) {
            var xmlHTTP = createXMLHttpRequest();

            var treeNode = new TreeNode();
            treeNode.LoadFromID(pNodeID);

            var strQuery = "<DATA><USERID>" + pUserID + "</USERID><ParentScrapContID>" + treeNode.GetNodeData("DATA1") + "</ParentScrapContID><NAME></NAME></DATA>";
            xmlHTTP.open("POST", "/ezBoard/getUserScrapContSubTree.do", false);
            xmlHTTP.send(strQuery);

            var treeView = new TreeView();
            treeView.LoadFromID(pTreeID);
            treeView.AppendChildNodes(loadXMLString(xmlHTTP.responseText).documentElement, pNodeID)

            var node = document.getElementById(pNodeID);
            var title2 = node.getElementsByClassName("node_div");

            for (var i = 0; i < title2.length; i++) {
                var title3 = title2[i].getElementsByClassName("node_normal");
                title3[0].title = title3[0].innerText;
            }
        }
        
        function btnCancel_onclick() {
            ReturnFunction("cancel");
            window.close();
        }
        
        function btnIns_onclick() {
            if (nodeIdx == undefined || nodeIdx == "") {
                var pAlertContent = "<spring:message code='ezBoard.kmh24'/>";
                OpenAlertUI(pAlertContent);
                return;
            }
            if (CrossYN())
                getScrapContName("", "INS");
            else {
                var treeNode = new TreeNode();
                treeNode.LoadFromID(nodeIdx);

                var scrapContID = treeNode.GetNodeData("DATA1");
                var scrapContName = getScrapContName("");
                if (scrapContName != "cancel") {
                    getScrapContName_Complete(scrapContName, "INS");
                }
            }
        }

        function btnEdit_onclick() {
            if (nodeIdx == undefined) {
                var pAlertContent = "<spring:message code='ezBoard.kmh27'/>";
                OpenAlertUI(pAlertContent);
                return;
            }

            var treeNode = new TreeNode();
            treeNode.LoadFromID(nodeIdx);
            var scrapContID = treeNode.GetNodeData("DATA1");
            if (CrossYN())
                getScrapContName(treeNode.GetNodeData("VALUE"), "MOD");
            else {
                var treeNode = new TreeNode();
                treeNode.LoadFromID(nodeIdx);

                var scrapContID = treeNode.GetNodeData("DATA1");
                var scrapContName = valData;
                if (scrapContName != "cancel") {
                    getScrapContName_Complete(scrapContName, "MOD");
                }
            }
        }

        function btnDel_onclick() {
            if (nodeIdx == undefined) {
                var pAlertContent = "<spring:message code='ezBoard.kmh32'/>";
                OpenAlertUI(pAlertContent);
                return;
            }
            var treeNode = new TreeNode();
            treeNode.LoadFromID(nodeIdx);

            if (treeNode.GetNodeData("DATA2") == "ROOT") {
                var pAlertContent = "<spring:message code='ezBoard.kmh33'/>";
                OpenAlertUI(pAlertContent);
                return;
            }

            var scrapContName = treeNode.GetNodeData("VALUE");
            scrapContName = scrapContName.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
            
            var OpinionContent = "[" + scrapContName + "] <spring:message code='ezBoard.kmh34'/>";

            if (CrossYN()){
            	OpenBoardInformationUI(OpinionContent, Del_Complete);
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
            var scrapContName = treeNode.GetNodeData("VALUE");
            var scrapContID = treeNode.GetNodeData("DATA1");
            if (RtnVal) {
                var rvalue = DelScrapUserCont(scrapContID, "CHECK");
                if (rvalue == "FALSE" || rvalue == "") {
                    var pAlertContent = "<spring:message code='ezBoard.kmh35'/>";
                    OpenAlertUI(pAlertContent);
                    return;
                }
                else if (rvalue == "TRUE") {
                    var pAlertContent = "<spring:message code='ezBoard.kmh36'/>";
                    OpenAlertUI(pAlertContent);
                    ScrapTreeViewRefresh();
                    try {opener.ScrapTreeViewRefresh();}catch (e) {}
                    nodeIdx = undefined;
                    return;
                } else if (rvalue == "HASSUBCONT") {
                    var pAlertContent = "<spring:message code='ezBoard.kmh37'/>";
                    OpenAlertUI(pAlertContent);
                    return;
                }
                else {
                    scrapContName = scrapContName.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
                    var OpinionContent = "[" + scrapContName + "] <spring:message code='ezBoard.kmh38'/>" + rvalue + "]<spring:message code='ezBoard.kmh39'/>"
                    OpenBoardInformationUI(OpinionContent, Del_Complete_MUST);
                }
            } else {
                //self.close();
                DivPopUpHidden();
            }
        }

        function Del_Complete_MUST(Rtnval) {
            var treeNode = new TreeNode();
            treeNode.LoadFromID(nodeIdx);
            var scrapContID = treeNode.GetNodeData("DATA1");
            if (Rtnval) {
                var rvalue = DelScrapUserCont(scrapContID, "MUST");
                if (rvalue == "TRUE") {
                    var pAlertContent = "<spring:message code='ezBoard.kmh36'/>";
                    OpenAlertUI(pAlertContent);
                    ScrapTreeViewRefresh();
                    try {opener.ScrapTreeViewRefresh();}catch (e) {}
                    return;
                }
                else {
                    var pAlertContent = "<spring:message code='ezBoard.kmh35'/>";
                    OpenAlertUI(pAlertContent);
                    return;
                }
            }
            else {
                DivPopUpHidden();
            }
        }
        
        var getscrapcontname_dialogArgument = new Array();
        function getScrapContName(tempName, type) {
            var windowName = "/ezBoard/getScrapContName.do?Title=&TitleText=" + escape(encodeURIComponent(tempName));
            var height = "";
            
            if (navigator.userAgent.toLowerCase().indexOf("msie") != -1 || (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1)) { // IE
            	height = 211;
            } else { // Chrome
            	height = 205;
            }
            
            if (CrossYN()) {
                var para = new Array();
                para[0] = type;
                getscrapcontname_dialogArgument[0] = para;
                getscrapcontname_dialogArgument[1] = getScrapContName_Complete;
                DivPopUpShow(330, height, windowName)
            }
            else {
                var parameter = "status:no;dialogWidth:330px;dialogHeight:" + height + "px;scroll:no;edge:sunken";
                parameter = parameter + GetShowModalPosition(330, height);
                var ret = window.showModalDialog(windowName, "", parameter);
                return ret;
            }
        }

        function getScrapContName_Complete(scrapContName, type) {
            DivPopUpHidden();
            var treeNode = new TreeNode();
            treeNode.LoadFromID(nodeIdx);

            var scrapContID = treeNode.GetNodeData("DATA1");
            if (scrapContName != "cancel") {
                var xmlhttp = createXMLHttpRequest();
                var xmlpara = createXmlDom();
                var objNode;

                if (type == "INS") {
                    createNodeInsert(xmlpara, objNode, "PARAMETER");
                    createNodeAndInsertText(xmlpara, objNode, "OwnUserID", pUserID);
                    createNodeAndInsertText(xmlpara, objNode, "pScrapContID", scrapContID);
                    createNodeAndInsertText(xmlpara, objNode, "pScrapContName", scrapContName);
                    createNodeAndInsertText(xmlpara, objNode, "Description", "");
                    xmlhttp.open("POST", "/ezBoard/insertUserScrapCont.do", false);
                    xmlhttp.send(xmlpara);
                    if (xmlhttp != null && xmlhttp.readyState == 4) {
                        if (xmlhttp.status == 200) {
                            var ResultXML = "";
                            ResultXML = loadXMLString(xmlhttp.responseText);
                            var dataNodes = GetChildNodes(ResultXML);

                            if (getNodeText(dataNodes[0]) == "TRUE") {
                                var pAlertContent = "<spring:message code='ezBoard.kmh25'/>";
                                OpenAlertUI(pAlertContent);
                                ScrapTreeViewRefresh();
                                try {opener.ScrapTreeViewRefresh();}catch (e) {}
                                nodeIdx = undefined;
                                return;
                            }
                        } else {
                            var pAlertContent = "<spring:message code='ezBoard.kmh26'/>";
                            OpenAlertUI(pAlertContent);
                            return;
                        }
                    }

                } else if (type == "MOD") {
                    createNodeInsert(xmlpara, objNode, "PARAMETER");
                    createNodeAndInsertText(xmlpara, objNode, "ScrapContID", scrapContID);
                    createNodeAndInsertText(xmlpara, objNode, "OwnUserID", pUserID);
                    createNodeAndInsertText(xmlpara, objNode, "pScrapContID", "");
                    createNodeAndInsertText(xmlpara, objNode, "pScrapContName", scrapContName);
                    createNodeAndInsertText(xmlpara, objNode, "Description", "");
                    xmlhttp.open("POST", "/ezBoard/updateUserScrapCont.do", false);
                    xmlhttp.send(xmlpara);

                    if (xmlhttp != null && xmlhttp.readyState == 4) {
                        if (xmlhttp.status == 200) {
                            var ResultXML = "";
                            ResultXML = loadXMLString(xmlhttp.responseText);
                            var dataNodes = GetChildNodes(ResultXML);

                            if (getNodeText(dataNodes[0]) == "TRUE") {
                                var pAlertContent = "<spring:message code='ezBoard.kmh30'/>";
                                OpenAlertUI(pAlertContent);
                                ScrapTreeViewRefresh();
                                try {opener.ScrapTreeViewRefresh();}catch (e) {}
                                nodeIdx = undefined;
                                return;
                            }
                        } else {
                            var pAlertContent = "<spring:message code='ezBoard.kmh31'/>";
                            OpenAlertUI(pAlertContent);
                            return;
                        }
                    }
                }

            }
        }

        function DelScrapUserCont(scrapContID, Mode) {
            var xmlhttp = createXMLHttpRequest();
            var xmlpara = createXmlDom();
            var objNode;
            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "ScrapContID", scrapContID);
            createNodeAndInsertText(xmlpara, objNode, "Mode", Mode);

            xmlhttp.open("POST", "/ezBoard/deleteUserScrapCont.do", false);
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
        
        var ezboardopinion_cross_dialogArguments = new Array();
        function OpenBoardInformationUI(pInformationContent, FunctionName, Type) {
            var parameter = pInformationContent;
            var url = "/ezBoard/boardOpinion.do";
            if (CrossYN()) {
                ezboardopinion_cross_dialogArguments[0] = parameter;
                if (FunctionName != undefined)
                    ezboardopinion_cross_dialogArguments[1] = FunctionName;
                else
                    ezboardopinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
                if (Type == undefined) {
                    DivPopUpShow(330, 205, url);
                }
                else {
                	//2018-08-21 배현상, type에 대한 처리를 controller에서 하지않고 opener의 변수를 가지고 사용하기에 로직 수정
                	ezboardopinion_cross_dialogArguments[2] = true;
                    GetOpenWindow(url, "ezBoardOPINION_Cross", 325, 200, "NO");
                }
            }
            else {
                var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
                feature = feature + GetShowModalPosition(330, 205);
                var RtnVal = window.showModalDialog(url, parameter, feature);
                return RtnVal;
            }
        }

        function OpenInformationUI_Complete(RtnVal, Complete_Function) {
            DivPopUpHidden();
            if (RtnVal) {
                Complete_Function(RtnVal);   
            }
        }
    </script>
</head>
<body class="popup">
    <h1><spring:message code='ezBoard.kmh20'/></h1>
    <div id="close">
        <ul>
            <li><span onclick="return btnCancel_onclick()"></span></li>
        </ul>
    </div>
    <div class="box" style="WIDTH: 440px; HEIGHT: 270px; overflow: auto; BACKGROUND-COLOR: #FFFFFF; padding: 4px 6px 6px 4px" id="divUserScrapContTree"></div>
    <div class="btnposition btnpositionNew">
        <a class="imgbtn" onclick="return btnIns_onclick()"><span><spring:message code='ezBoard.kmh21'/></span></a>
        <a class="imgbtn" onclick="return btnEdit_onclick()"><span><spring:message code='ezBoard.kmh22'/></span></a>
        <a class="imgbtn" onclick="return btnDel_onclick()"><span><spring:message code='ezBoard.kmh23'/></span></a>
    </div>
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
    <iframe src="<spring:message code='main.kms4' />" style="border:none; overflow:hidden;" id="iFrameLayer"></iframe>
    </div>
</body>
</html>


