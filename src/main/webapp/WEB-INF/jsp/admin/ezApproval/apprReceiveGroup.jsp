<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title>Untitled Document</title>
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezApproval.e1'/>"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/TreeViewCtrl_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/TreeView.js" ></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/ListView_list.js" ></script>
	    <script type="text/javascript">
	        var UserAgentState = navigator.userAgent.toLowerCase();
	        var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
	        if (browserIE) {
	            document.write('<script type="text/javascript" src="/js/ezApproval/kaoni_ActiveX.js" \></script\>');
	
	        }
	    </script>
	    <script id="clientEventHandlersJS" type="text/javascript">
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var p_groupid = "";
	        var TreeIdx;
	
	        window.onload = function () {
	            Tree_setconfig();
	            TreeViewinitialize("", "${topID}", "displayName1;displayName2;extensionAttribute2;extensionAttribute3", "${serverName}");
	            getAdminReceivGroup();
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
	
	        function TreeViewNodeClick(pNodeID, pNodeNM) {
	            TreeIdx = pNodeID;
	
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	
	            ID = treeNode.GetNodeData("DATA1");
	            DeptID = treeNode.GetNodeData("DATA2");
	            KIND = document.getElementById('FromList')[0].value;
	
	            GetFormInfo(ID, KIND);
	        }
	        function TreeViewNodeDbClick() {
	        }
	        function changeCompID() {
	            getAdminReceivGroup();
	            p_groupid = "";
	            setNodeText(pGroupID,"");
	            setNodeText(pGroupName2,"");
	            setNodeText(document.getElementById("pGroupName"), "");
	        }
	
	        function getDeptFullTree(deptid) {
	            g_xmlHTTP = createXMLHttpRequest();
	
	            
	            var strQuery = "<DATA><DEPTID>" + deptid + "</DEPTID><TOPID>" + "${topID}" + "</TOPID><PROP>extensionAttribute2;displayName</PROP></DATA>";
	
	            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
	            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	            g_xmlHTTP.send(strQuery);
	        }
	
	        function event_getDeptFullTree() {
	            if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
	                if (g_xmlHTTP.statusText == "OK") {
	                    var xmlDom = createXmlDom();
	                    xmlDom.async = false;
	                    xmlDom.load("/xml/organtree_config.xml");
	                    TreeView.server = "${serverName}";
	                    TreeView.config = xmlDom;
	                    TreeView.source = loadXMLString(g_xmlHTTP.responseText);
	                    TreeView.update();
	                }
	                else {
	                    OpenAlertUI("<spring:message code='ezApproval.t621'/>" + g_xmlHTTP.statusText)
	                    g_xmlHTTP = null;
	                }
	            }
	        }
	
	        function event_getDeptFullTree() {
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
	            xmlHTTP.send();
	
	            if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
	                var treeView = new TreeView();
	                
	                treeView.SetConfig(loadXMLString(xmlHTTP.responseText));
	            }
	        }
	
	        function RequestData() {
	            var nodeIdx = window.event.nodeIdx;
	            var xmlHTTP = createXMLHttpRequest();
	
	            
	            var strQuery = "<DATA><DEPTID>" + TreeView.getvalue(nodeIdx, "CN") + "</DEPTID><PROP>extensionAttribute2;displayName</PROP></DATA>";
	
	            xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
	            xmlHTTP.send(strQuery);
	
	            TreeView.putchildxml(nodeIdx, loadXMLString(xmlHTTP.responseText));
	        }
	
	        function TreeViewNodeClick() {
	        }
	
	        function getAdminReceivGroup(groupid) {
	            var xmlRtn = createXmlDom();
	            
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/getAdminReceivGroup.do",
		    		data : {
		    			groupID : groupid,
		    			mode    : "GROUP",
		    			companyID  : document.getElementById("ListCompany").value
		    		},
		    		success: function(xml){
		    			xmlRtn = loadXMLString(xml);
		    		}
		    	});
		    	
	            document.getElementById('lvtDept').innerHTML = '';
	            var ListView2 = new ListView();
	            ListView2.SetID("lvtDeptID");
	            ListView2.SetRowOnClick("lvtDept_SelChange");
	            ListView2.DataSource(xmlRtn);
	            ListView2.DataBind("lvtDept");
	        }
	
	        function getAdminReceivItem(groupid) {
	            var xmlRtn = createXmlDom();
	            
	            $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/getAdminReceivGroup.do",
		    		data : {
		    			groupID : groupid,
		    			mode    : "ITEM",
		    			companyID  : document.getElementById("ListCompany").value
		    		},
		    		success: function(xml){
		    			xmlRtn = loadXMLString(xml);
		    		}
		    	});
	            
	            document.getElementById('lvtDeptSelect').innerHTML = '';
	            var ListView2 = new ListView();
	            ListView2.SetID("lvtDeptSelectID");
	            ListView2.SetRowOnDblClick("lvtDeptSelect_rowdblclick");
	            ListView2.DataSource(xmlRtn);
	            ListView2.DataBind("lvtDeptSelect");
	        }
	
	        function insertCont_onclick() {
	            if (p_groupid == "") {
	                var pAlertContent = "<spring:message code='ezApproval.t622'/>";
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	
	            var treeview = new TreeView();
	            treeview.LoadFromID("FromTreeView");
	            var selRow = treeview.GetSelectNode();
	
	            if (selRow != -1) {
	                var DuplicateFlag = DuplicateAprDeptCheck(selRow.GetNodeData("CN"));
	                if (DuplicateFlag) {
	                    AprLineAddDept(selRow);
	                }
	                else {
	                    var pAlertContent = "<spring:message code='ezApproval.t205'/><br>  <spring:message code='ezApproval.t206'/>";
	                    OpenAlertUI(pAlertContent);
	                }
	            }
	        }
	
	        var ezapropinion_cross_dialogArgument = new Array();
	        function insertAllCont_onclick() {
	            if (p_groupid == "") {
	                var pAlertContent = "<spring:message code='ezApproval.t622'/>";
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	
	            var pAlertContent = "<spring:message code='ezApproval.t623'/><br><spring:message code='ezApproval.t624'/>";
	
	            ezapropinion_cross_dialogArgument[0] = pAlertContent;
	            ezapropinion_cross_dialogArgument[1] = insertAllCont_onclick_Complete;
	
	            var url = "/admin/ezApproval/ezAprOpinion.do?type=open";
	            var result = GetOpenWindow(url, "ezAPROPINION_Cross", 330, 205, "NO");
	        }
	        function insertAllCont_onclick_Complete(retVal, NextFunction) {
	            if (!retVal)
	                return;
	
	            showProgress();
	
	            var treeview = new TreeView();
	            treeview.LoadFromID("FromTreeView");
	            var selRow = treeview.GetSelectNode();
	
	            if (selRow != -1) {
	                
	                chkAllDept(selRow.GetNodeData("CN"), selRow.GetNodeData("DISPLAYNAME1"), selRow.GetNodeData("DISPLAYNAME2"), selRow.GetNodeData("EXTENSIONATTRIBUTE2"));
	
	                getAdminReceivItem(p_groupid);
	            }
	            hideProgress();
	            return;
	
	        }
	
	        function AddDept(aDeptID, aDeptName, aDeptName2, aCompanyID) {
	            var DuplicateFlag = DuplicateAprDeptCheck(aDeptID);
	            if (!DuplicateFlag)
	                return;
	
	            $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/setGroupSubItemInfo.do",
		    		data : {
		    			groupID : p_groupid,
		    			deptID  : aDeptID,
		    			deptName: aDeptName,
		    			companyID  : document.getElementById("ListCompany").value,
		    			addCompanyID : aCompanyID,
		    			deptName2 : aDeptName2
		    		},
		    		success: function(xml){
		    		}
		    	});
	        }
	
	        function chkAllDept(aDeptID, aDeptName, aDeptName2, aCompanyID) {
	            AddDept(aDeptID, aDeptName, aDeptName2, aCompanyID);
	            var xmlHTTP = createXMLHttpRequest();
	            var strQuery = "<DATA><DEPTID>" + aDeptID + "</DEPTID><PROP>extensionAttribute2;displayName</PROP></DATA>";
	
	            xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
	            xmlHTTP.send(strQuery);
	
	            var xmlNodes;
	            xmlNodes = loadXMLString(getXmlString(loadXMLString(xmlHTTP.responseText).documentElement));
	            xmlNodes = xmlNodes.getElementsByTagName("NODE");
	            if (xmlNodes.length > 0) {
	                var i = 0;
	                for (i = 0; i < xmlNodes.length; i++) {
	                    chkAllDept(xmlNodes[i].getElementsByTagName("CN")[0].childNodes[0].nodeValue,
	                               xmlNodes[i].getElementsByTagName("DISPLAYNAME1")[0].childNodes[0].nodeValue,
	                               xmlNodes[i].getElementsByTagName("DISPLAYNAME2")[0].childNodes[0].nodeValue,
	                               xmlNodes[i].getElementsByTagName("EXTENSIONATTRIBUTE2")[0].childNodes[0].nodeValue);
	                }
	            }
	            return;
	        }
	
	        function DuplicateAprDeptCheck(DeptID) {
	            var AprDeptLIst
	            var AprDeptListLen
	            var deptID
	            var listview = new ListView();
	            listview.LoadFromID("lvtDeptSelectID");
	
	            AprDeptList = listview.GetDataRows();
	            AprDeptListLen = listview.GetRowCount();
	            var i;
	
	            for (i = 0 ; i < AprDeptListLen ; i++) {
	                deptID = GetAttribute(AprDeptList[i], "DATA3");
	                if (deptID == DeptID) {
	                    return false;
	                    break;
	                }
	            }
	            return true;
	        }
	
	        function deleteCont_onclick() {
	            var listview = new ListView();
	            listview.LoadFromID("lvtDeptSelectID");
	            var selRow = listview.GetSelectedRows();
	
	
	            if (selRow[0]) {
	                var rtn = deleteGroupSubiteminfo(selRow[0]);
	                if (rtn == "TRUE") {
	                    listview.DeleteRow(GetAttribute(selRow[0], "id"));
	                }
	            }
	        }
	
	        function deleteAllCont_onclick() {
	            showProgress();
	
	            var listview = new ListView();
	            listview.LoadFromID("lvtDeptSelectID");
	
	            var selRow = listview.GetDataRows();
	            if (listview.GetRowCount() > 0) {
	                for (i = listview.GetRowCount() - 1; i >= 0; i--) {
	                    var rtn = deleteGroupSubiteminfo(selRow[i]);
	                    if (rtn == "TRUE") {
	                        listview.DeleteRow(GetAttribute(selRow[i], "id"));
	                    }
	                }
	            }
	            hideProgress();
	        }
	
	        function deleteGroupSubiteminfo(selRow) {
	            var pgid = GetAttribute(selRow, "DATA1");

	            var result = "";
	        	
	            $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/deleteGroupSubItemInfo.do",
		    		data : {
		    			groupID : pgid,
		    			companyID  : document.getElementById("ListCompany").value,
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});	            
	
	            getAdminReceivItem(p_groupid);
	            return getNodeText(loadXMLString(result));
	        }
	
	        function TreeCtrl_onNodeDblClick() {
	            displayMemberTree();
	            insertCont_onclick();
	        }
	
	        function AprLineAddDept(selRow) {
	            $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/setGroupSubItemInfo.do",
		    		data : {
		    			groupID : p_groupid,
		    			deptID  : selRow.GetNodeData("CN"),
		    			deptName: selRow.GetNodeData("DISPLAYNAME1"),
		    			companyID  : document.getElementById("ListCompany").value,
		    			addCompanyID : selRow.GetNodeData("EXTENSIONATTRIBUTE2"),
		    			deptName2 : selRow.GetNodeData("DISPLAYNAME2")
		    		},
		    		success: function(xml){
		    			getAdminReceivItem(p_groupid);
		    		}
		    	});
	        }
	
	        function Updategroupmaininfo() {
	        	if (p_groupid == null || p_groupid == "") {
	        		var pAlertContent = "<spring:message code='ezApproval.hyj3'/>";
	                OpenAlertUI(pAlertContent);
	                return;
	        	}
	        	
	        	if (document.getElementById("pGroupName").value == "") {
	                var pAlertContent = "<spring:message code='ezApproval.hyj4'/>";
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	        	
	            var result = "";
	            
	            $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/updateGroupMainInfo.do",
		    		data : {
		    			groupID : p_groupid,
		    			groupName : document.getElementById("pGroupName").value,
		    			companyID  : document.getElementById("ListCompany").value,
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
	            
	            if (result == "<RESULT>TRUE</RESULT>") {
	                getAdminReceivGroup();
	                p_groupid = "";
	                setNodeText(pGroupID,"");
	                setNodeText(pGroupName2,"");
	                setNodeText(document.getElementById("pGroupName"),"");
	            }
	            else alert("<spring:message code='ezApproval.t990047'/>");
	        }
	
	        function SetGroupMainInfo() {
	            if (document.getElementById("pGroupName").value == "") {
	                var pAlertContent = "<spring:message code='ezApproval.t625'/>";
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	            
	            var result = "";
	
	            $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/setGroupMainInfo.do",
		    		data : {
		    			groupName : document.getElementById("pGroupName").value,
		    			companyID  : document.getElementById("ListCompany").value
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
	            
	            if (result == "<RESULT>TRUE</RESULT>") {
	                ezapralert_cross_dialogArgument[1] = SetGroupMainInfo_Complete;
	                OpenAlertUI("<spring:message code='ezApproval.t626'/>");
					SetGroupMainInfo_Complete();
	            }
	        }
	        function SetGroupMainInfo_Complete() {
	            getAdminReceivGroup();
	            p_groupid = "";
	            setNodeText(pGroupID,"");
	            setNodeText(pGroupName2,"");
	            setNodeText(document.getElementById("pGroupName"), "");
	        }
	
	        function Deletegroupmaininfo() {
	            var listview = new ListView();
	            listview.LoadFromID("lvtDeptID");
	            var selRow = listview.GetSelectedRows();
	
	            if (p_groupid == "") {
	                OpenAlertUI("<spring:message code='ezApproval.t628'/>");
	                return;
	            }
	
	            
	            var tr = listview.GetDataRows();
	            if (listview.GetRowCount() > 0) {
	                if (tr[0].id.indexOf("noItems") > 0) {
	                    deleteAllCont_onclick();
	                }
	            }
	            
	            var result = "";
	
	            $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/deleteGroupMainInfo.do",
		    		data : {
		    			groupID : p_groupid,
		    			companyID  : document.getElementById("ListCompany").value,
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
	            
	
	            if (result == "<RESULT>TRUE</RESULT>") {
	                var listgroupview = new ListView();
	
	                listgroupview.LoadFromID("lvtDeptID");
	
	                getAdminReceivGroup();
	                p_groupid = "";
	                setNodeText(pGroupID,"");
	                setNodeText(pGroupName2,"");
	                setNodeText(document.getElementById("pGroupName"), "");
	                listgroupview.DataSource("");
	            }
	            else {
	                OpenAlertUI("<spring:message code='ezApproval.t629'/>");
	            }
	        }
	
	        function lvtDept_SelChange() {
	            var listview = new ListView();
	            listview.LoadFromID("lvtDeptID");
	            var selRow = listview.GetSelectedRows();
	
	            if (selRow) {
	                getAdminReceivItem(GetAttribute(selRow[0], 'DATA1'));
	                p_groupid = GetAttribute(selRow[0], 'DATA1');
	                document.getElementById("pGroupID").innerHTML = GetAttribute(selRow[0], 'DATA1');
	                document.getElementById("pGroupName2").innerHTML = selRow[0].childNodes[0].childNodes[0].nodeValue;
	                document.getElementById("pGroupName").value = selRow[0].childNodes[0].childNodes[0].nodeValue;
	            }
	        }
	
	        function lvtDeptSelect_SelChange() {
	
	        }
	
	        function lvtDeptSelect_rowdblclick() {
	            deleteCont_onclick();
	        }
	
	        var ezapralert_cross_dialogArgument = new Array();
	        function OpenAlertUI(pAlertContent) {
	            var parameter = pAlertContent;
	            var url = "/admin/ezApproval/ezAprAlert.do";
	            ezapralert_cross_dialogArgument[0] = parameter;
	            var result = GetOpenWindow(url, "ezAPRALERT_Cross", 330, 205, "NO");
	        }
	
	        var g_progresswin = null;	
	        function showProgress() {
	        }
	
	        function hideProgress() {
	            try {
	                if (g_progresswin)
	                    g_progresswin.close();
	            }
	            catch (e) { }
	        }
	
	    </script>
	</head>
	<body class="mainbody">
	    <h1><spring:message code='ezApproval.t225'/></h1>
	    <table>
	        <tr>
	            <td style="vertical-align: top">
	                <h2><spring:message code='ezApproval.t631'/></h2>
	                <table class="popuplist" style="width: 360px; height: 110px;">
	                    <tr>
	                        <th colspan="2" style="padding: 5px">
	                        	<select id="ListCompany" name="ListCompany" onchange="return changeCompID()">
					    			${companySel}
								</select>
	                        </th>
	                    </tr>
	                    <tr>
	                        <th id="pGroupID" style="width: 50px"></th>
	                        <td id="pGroupName2" style="text-overflow: ellipsis; white-space: nowrap; overflow: hidden; max-width: 270px;"></td>
	                    </tr>
	                    <tr>
	                        <td colspan="2" style="padding: 5px">
	                            <input type="text" name="textfield" style="width: 100%" id="pGroupName" maxlength="50">
	                            <br /><br />
	                            <a class="imgbtn"><span onclick="return Updategroupmaininfo()"><spring:message code='ezApproval.t632'/></span></a>
	                            <a class="imgbtn"><span onclick="return SetGroupMainInfo()"><spring:message code='ezApproval.t193'/></span></a>
	                            <a class="imgbtn"><span onclick="return Deletegroupmaininfo()"><spring:message code='ezApproval.t194'/></span></a></td>
	                    </tr>
	                </table>
	            </td>
	            <td>&nbsp;</td>
	            <td style="vertical-align: top">
	                <h2><spring:message code='ezApproval.t227'/></h2>
	                <div class="listview">
	                    <div id="lvtDept" style="border: 0; Width: 360px; Height: 110px; overflow-x: hidden; overflow-y: auto" onselchanged="return lvtDept_SelChange()"></div>
	                </div>
	                <br>
	            </td>
	        </tr>
	        <tr>
	            <td valign="top">
	                <h2><spring:message code='ezApproval.t173'/></h2>
	                <div style="border: 1px solid #b6b6b6; overflow: auto; height: 320px; width: 360px; background-color: white" id="TreeView" onrequestdata="RequestData()" onnodeselect="TreeViewNodeClick()" onnodedblclick="TreeView.toggle(TreeView.selectedIndex)"></div>
	            </td>
	            <td style="width: 30px; text-align: center">
	                <img src="/images/arr_right.gif" width="16" height="16" style="cursor: pointer" onclick="return insertCont_onclick()">
	                <img src="/images/arr_left.gif" width="16" height="16" style="cursor: pointer" onclick="return deleteCont_onclick()">
	                <img src="/images/arr_rright.gif" width="16" height="16" style="cursor: pointer" onclick="return insertAllCont_onclick()">
	                <img src="/images/arr_lleft.gif" width="16" height="16" style="cursor: pointer" onclick="return deleteAllCont_onclick()">
	            </td>
	            <td style="vertical-align: top">
	                <h2><spring:message code='ezApproval.t61'/></h2>
	                <div class="listview">
	                    <div id="lvtDeptSelect" style="border: 0; Width: 360px; Height: 320px; overflow-x: hidden; overflow-y: auto" onselchanged="return lvtDeptSelect_SelChange()" onrowdblclick="return lvtDeptSelect_rowdblclick()"></div>
	                </div>
	            </td>
	        </tr>
	    </table>
	</body>
</html>