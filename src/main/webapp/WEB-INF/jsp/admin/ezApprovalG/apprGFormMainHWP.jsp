<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t607' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="/css/Tab.css" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TreeView.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/FormMain_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ezForm_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/Common_Function.js"></script>
		
		<script type="text/javascript">
			var OrderCell = "";
		    var companyID = "<c:out value = '${companyID}' />";
		    var contID = "<c:out value = '${contID}' />";
		    var formID = "<c:out value = '${formID}' />";
		    var isInsUp = "<c:out value = '${isInsUp}' />";
	        var TreeIdx;
	        var treeNode;
	        var listview;
	        var TreeIdx;
	        var g_toggleFlag = false;
	        var formURL = "";
	        var beforeHTML = "";
	        var FormProcSpelling = "0";
	        var htmlData = "";
	        var ConnData = "";
	        var WorkData = "";
	        var flag = false;
	        var pEditorType = "<c:out value = '${pEditorType}' />";
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	
	        var onloadflag = false;
	        window.onload = function () {
	            onloadflag = true;
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	
	            document.getElementById("1tab1").setAttribute("class", "tabon");
	            Tab1_SelectID = "1tab1";
	            ChangeTab(document.getElementById("1tab1"));
	
	            getDeptFullTree("<c:out value = '${topID}' />");
	            getFormRecv();
	
	            if (formID != "") {
	                get_FormInfo();
	                if (pEditorType != "HWP") {
	                    var tempXML = createXmlDom();
	                    var XmlBodyATT = createXmlDom();
	                    var XmlBodyDATA = createXmlDom();
	                    var tempStr = "";
	                    tempStr = ConvertMHTtoHTML(formURL);
	                    tempXML = loadXMLString(tempStr)
	                    XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	                    XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	
	                    var Doc_ContentHtml = document.createElement("DIV");
	                    Doc_ContentHtml.innerHTML = getNodeText(XmlBodyDATA);
	
	
	                    for (var i = 0; i < GetChildNodes(Doc_ContentHtml).length ; i++) {
	                        var TagID = GetChildNodes(Doc_ContentHtml)[i].id;
	                        if (TagID != "" && TagID != undefined)
	                            TagID = TagID.toUpperCase();
	
	                        if (TagID == "CONN") {
	                            ConnData = Doc_ContentHtml.children[i].innerHTML.replace('<CONNINFO>', '').replace('</CONNINFO>', '').replace('<conninfo>', '').replace('</conninfo>', '');
	                            if (ConnData != "") {
	                                setNodeText(txt_OpinionContent, ReplaceText(ConnData, "<BR>", "\n"));
	                            }
	                        }
	                        else if (TagID == "WORKFLOW") {
	                            WorkData = GetChildNodes(Doc_ContentHtml)[i].innerHTML.toUpperCase();
	                            if (WorkData != "") {
	                                var VALIDATIONS = WorkData.slice(WorkData.indexOf("<VALIDATION>"), WorkData.indexOf("</VALIDATIONS>"));
	                                setNodeText(txt_OpinionContent1, ReplaceText(VALIDATIONS, "<BR>", "\n"));
	
	                                var STATUS = WorkData.slice(WorkData.indexOf("<CHECK>"), WorkData.indexOf("</STATUS>"));
	                                setNodeText(txt_OpinionContent2, ReplaceText(STATUS, "<BR>", "\n"));
	                            }
	                        }
	                        else if (TagID == "BODYCONTENT") {
	                            htmlData += GetChildNodes(Doc_ContentHtml)[i].outerHTML;
	                        }
	                        else if (TagID == "") {
	                            htmlData += GetChildNodes(Doc_ContentHtml)[i].outerHTML;
	                        }
	                    }
	                }
	            }
	            Editor_Complete();
	        }
	
	        function Editor_Complete() {
	            if (onloadflag && flag == false) {
	                flag = true;
	                if (formURL != "") {
	                    if (pEditorType == "HWP") {
	                        message.HWP_LoadFile(formURL);
	                        if (message.HWP_GetDocumentElement() != "") {
	                            var ConnURL = ReplaceAll(ReplaceAll(message.HWP_GetDocumentElement(), "<CONNINFO>", ""), "</CONNINFO>", "");
	
	                            var g_XmlDoc = createXmlDom();
	                            g_XmlDoc.async = false;
	                            g_XmlDoc.load(document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezCommon/downloadAttach.do?filePath=" + ecnodeURI(ConnURL));
	
	                            if (g_XmlDoc.xml == "")
	                                return;
	
	                            for (i = 0; i < g_XmlDoc.documentElement.childNodes.length; i++) {
	                                if (i == 0)
	                                    setNodeText(txt_OpinionContent, g_XmlDoc.documentElement.childNodes(i).xml);
	                                else
	                                    setNodeText(txt_OpinionContent, getNodeText(txt_OpinionContent) + "\n" + g_XmlDoc.documentElement.childNodes(i).xml);
	                            }
	                        }
	                        document.getElementById("btn_OpinionSave").style.display = "";
	                    }
	                    else {
	                        document.getElementById("ApvForm_sub4").style.display = "";
	                        document.getElementById("rootTD").style.display = "";
	                        message.SetEditorContent(htmlData);
	                    }
	                }
	                else {
	                    if (pEditorType != "HWP") {
	                        document.getElementById("ApvForm_sub4").style.display = "";
	                        document.getElementById("rootTD").style.display = "";
	                    }
	                    else
	                        document.getElementById("btn_OpinionSave").style.display = "";
	                }
	                add_doc_maker();
	            }
	        }
	
	        function Attribute_Write(value) {
	            if (value == null)
	                value = "";
	            setNodeText(BottonTDValue[1], value);
	            setNodeText(BottonTDValue[2], "");
	            document.getElementById("EditInput").value = "";
	        }
	
	        function get_FormInfo() {
	        	$.ajax({
		        	type : "POST",
		        	url : "/admin/ezApprovalG/getFormInfo.do",
		        	async : false,
		        	data : {formID : formID, companyID : companyID},
		        	success : function(result) {
		        		if (result != "") {
			                var xmldom = loadXMLString(result);

			                tbFormName.value = getNodeText(SelectNodes(xmldom, "ROW/FORMNAME")[0]);
			                tbFormName2.value = getNodeText(SelectNodes(xmldom, "ROW/FORMNAME2")[0]);
			                tbDescript.value = getNodeText(SelectNodes(xmldom, "ROW/FORMDESCRIPTION")[0]);
			                selFormKind.value = getNodeText(SelectNodes(xmldom, "ROW/FORMDOCTYPE")[0]);
			                formURL = document.location.protocol+"//" + document.location.hostname + ":" + location.port + "/ezCommon/downloadAttach.do?filePath=" + encodeURI(getNodeText(SelectNodes(xmldom, "ROW/FORMFILELOCATION")[0]));
			                
			                if (getNodeText(SelectNodes(xmldom, "ROW/FORMCONNFLAG")[0]) == "Y") {
			                    document.getElementById("setConnFlag").checked = true;
			                }
			            }
		        	}
		        });
	        	
	            /* var xmlpara = createXmlDom();
	            var xmlhttp = createXMLHttpRequest();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "DATA");
	            createNodeAndInsertText(xmlpara, objNode, "FORMID", formID);
	            createNodeAndInsertText(xmlpara, objNode, "COMPANYID", companyID);
	
	            xmlhttp.open("POST", "/myoffice/ezApprovalG/manage/FormMaker/aspx/Get_FormInfo.aspx", false);
	            xmlhttp.send(xmlpara);
	
	            if (xmlhttp.status == "200") {
	                if (xmlhttp.responseText != "") {
	                    var xmldom = createXmlDom();
	                    xmldom = loadXMLString(xmlhttp.responseText);
	
	                    tbFormName.value = getNodeText(SelectNodes(xmldom, "DATA/FORMNAME")[0]);
	                    tbFormName2.value = getNodeText(SelectNodes(xmldom, "DATA/FORMNAME2")[0]);
	                    tbDescript.value = getNodeText(SelectNodes(xmldom, "DATA/FORMDESCRIPTION")[0]);
	                    selFormKind.value = getNodeText(SelectNodes(xmldom, "DATA/FORMDOCTYPE")[0]);
	                    formURL = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(getNodeText(SelectNodes(xmldom, "DATA/FORMFILELOCATION")[0]));
	
	                    if (getNodeText(SelectNodes(xmldom, "DATA/FORMCONNFLAG")[0]) == "Y") {
	                        document.getElementById("setConnFlag").checked = true;
	                    }
	                }
	            } */
	        }
	
	        function SaveFormInfo_after() {
	            if (xmlhttp == null || xmlhttp.readyState != 4) return;
	            try {
	                var resultXML = createXmlDom();
	                resultXML = loadXMLString(xmlhttp.responseText);
	
	                var result = getNodeText(SelectNodes(resultXML, "DATA")[0]);
	                if (result == "OK") {
	                    alert("<spring:message code = 'ezApprovalG.t1663' />");
	                }
	                else {
	                    alert("<spring:message code = 'ezApprovalG.t1669' />");
	                }
	
	                try {
	                    window.opener.refreshFormList();
	                }
	                catch (e) {
	                }
	            }
	            catch (e) {
	                alert(e.message);
	            }
	        }
	
	        function FormMaker_RtnMht() {
	            return document.getElementById("ApvForm_div2_ifrm").contentWindow.RtnFormMht();
	        }
	
	        function getDeptFullTree(deptid) {
	        	try {
		            Tree_setconfig();
		            var xmlpara = createXmlDom();
		            var objNode;
		            createNodeInsert(xmlpara, objNode, "DATA");
		            createNodeAndInsertText(xmlpara, objNode, "DEPTID", deptid);
		            createNodeAndInsertText(xmlpara, objNode, "TOPID", "<c:out value = '${topID}' />");
		            createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2");
	
		            var xmlHTTP = createXMLHttpRequest();
		            xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
		            xmlHTTP.send(xmlpara);
	
		            xmlpara = xmlHTTP.responseXML;
	
		            var treeView = new TreeView();
		            treeView.SetID("UserContTree");
		            treeView.SetUseAgency(true);
		            treeView.SetRequestData("RequestData");
		            treeView.SetNodeClick("TreeViewNodeClick");
		            treeView.DataSource(xmlpara);
		            treeView.DataBind("divUserContTree");
		        } catch (e) {
	        		alert(e.description);
	        	}
	            <%-- try {
	                Tree_setconfig();
	                var xmlpara = createXmlDom();
	                var objNode;
	                createNodeInsert(xmlpara, objNode, "DATA");
	                createNodeAndInsertText(xmlpara, objNode, "DEPTID", deptid);
	                createNodeAndInsertText(xmlpara, objNode, "TOPID", "<c:out value = '${topID}' />");
	                createNodeAndInsertText(xmlpara, objNode, "PROP", "EXTENSIONATTRIBUTE2");
	
	                var xmlHTTP = createXMLHttpRequest();
	                xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptTreeInfo.aspx", false);
	                xmlHTTP.send(xmlpara);
	
	                xmlpara = loadXMLString(xmlHTTP.responseText);
	
	                var treeView = new TreeView();
	                treeView.SetID("UserContTree");
	                treeView.SetUseAgency(true);
	                treeView.SetRequestData("RequestData");
	                treeView.SetNodeClick("TreeViewNodeClick");
	                treeView.DataSource(xmlpara);
	                treeView.DataBind("divUserContTree");
	            }
	            catch (e) { alert(e.description); } --%>
	        }
	
	        function Tree_setconfig() {
	        	var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
		        xmlHTTP.send();
	
		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(xmlHTTP.responseXML);
		        }
	            /* var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/myoffice/ezApprovalG/control_Cross/organtree_config.xml", false);
	            xmlHTTP.send();
	
	            if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
	                var treeView = new TreeView();
	                treeView.SetConfig(loadXMLString(xmlHTTP.responseText));
	            } */
	        }
	
	        function RequestData(pNodeID, pTreeID) {
	        	TreeIdx = pNodeID;
	        	
		        treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
	
		        var xmlHTTP = createXMLHttpRequest();
	
		        var xmlpara = createXmlDom();
	
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "DATA");
		        createNodeAndInsertText(xmlpara, objNode, "DEPTID", treeNode.GetNodeData("CN"));
		        createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2");
	
		        xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
		        xmlHTTP.send(xmlpara);
	
		        var treeView = new TreeView();
		        treeView.LoadFromID(pTreeID);
		        treeView.AppendChildNodes(xmlHTTP.responseXML.documentElement, pNodeID);
		        
	            /* TreeIdx = pNodeID;
	
	            treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	
	            var xmlHTTP = createXMLHttpRequest();
	
	            var xmlpara = createXmlDom();
	
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "DATA");
	            createNodeAndInsertText(xmlpara, objNode, "DEPTID", treeNode.GetNodeData("CN"));
	            createNodeAndInsertText(xmlpara, objNode, "PROP", "EXTENSIONATTRIBUTE2");
	
	            xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptSubTreeInfo.aspx", false);
	            xmlHTTP.send(xmlpara);
	
	            var treeView = new TreeView();
	            treeView.LoadFromID(pTreeID);
	            treeView.AppendChildNodes(loadXMLString(xmlHTTP.responseText).documentElement, pNodeID) */
	        }
	
	        function TreeViewNodeClick(pNodeID, pNodeNM) {
	            TreeIdx = pNodeID;
	            treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	        }
	
	        function getFormRecv() {
		        $.ajax({
		        	type : "POST",
		        	url : "/admin/ezApprovalG/getFormRecvAdmin.do",
		        	async : false,
		        	data : {node1 : formID},
		        	success : function(result) {
		        		listview = new ListView();
				        listview.SetID("lvtForm");
				        listview.SetMulSelectable(true);
				        listview.SetRowOnClick("lvtDeptSelect_SelChange");
				        listview.SetRowOnDblClick("lvtDeptSelect_rowdblclick");
				        listview.DataSource(loadXMLString(result));
				        listview.DataBind("divlvtForm");
	        		}
		        });
	
		        
		        
	            /* var xmlhttp = createXMLHttpRequest();
	            var xmlpara = createXmlDom();
	
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "PARAMETER");
	            createNodeAndInsertText(xmlpara, objNode, "NODE1", formID);
	
	            xmlhttp.open("POST", "/myoffice/ezApprovalG/formContainer/aspx/getFormRecvAdmin.aspx", false);
	            xmlhttp.send(xmlpara);
	            xmlpara = loadXMLString(xmlhttp.responseText);
	
	            listview = new ListView();
	            listview.SetID("lvtForm");
	            listview.SetMulSelectable(true);
	            listview.SetRowOnClick("lvtDeptSelect_SelChange");
	            listview.SetRowOnDblClick("lvtDeptSelect_rowdblclick");
	            listview.DataSource(xmlpara);
	            listview.DataBind("divlvtForm"); */
	        }
	
	        function insertCont_onclick() {
	        	var DuplicateFlag = DuplicateAprDeptCheck(treeNode.GetNodeData("CN"));

		        if (DuplicateFlag) {
		            AprLineAddDept(treeNode.GetNodeData("VALUE"), treeNode.GetNodeData("CN"));
		        } else {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t2001' />";
		            OpenAlertUI(pAlertContent);
		        }
	        }
	
	        function insertAllCont_onclick() {
	            var pAlertContent = "<spring:message code = 'ezApprovalG.t1361' /><br><spring:message code = 'ezApprovalG.t1362' />";
	            var Ans = OpenInformationUI(pAlertContent);
	
	            if (!Ans) {
	            	return;
	            }
	
	            chkAllDept(treeNode.GetNodeData("CN"), treeNode.GetNodeData("VALUE"));
	        }
	
	        function chkAllDept(aDeptID, aDeptName) {
	            try {
	            	var DuplicateFlag = DuplicateAprDeptCheck(aDeptID);
		            if (DuplicateFlag) {
		                AprLineAddDept(aDeptName, aDeptID);
		            }
		            
		            var xmlHTTP = createXMLHttpRequest();
		            var xmlpara = createXmlDom();
	
		            var objNode;
		            createNodeInsert(xmlpara, objNode, "DATA");
		            createNodeAndInsertText(xmlpara, objNode, "DEPTID", aDeptID);
		            createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2");
	
		            xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
		            xmlHTTP.send(xmlpara);
	
		            var xmlNodes = createXmlDom();
		            xmlNodes = loadXMLString(xmlHTTP.responseText);
	
		            var objNodes = SelectNodes(xmlNodes, "NODES/NODE");
	
		            if (objNodes.length > 0) {
		                for (var i = 0; i < objNodes.length; i++) {
		                    chkAllDept(objNodes[i].getElementsByTagName("CN")[0].childNodes[0].nodeValue, objNodes[i].getElementsByTagName("VALUE")[0].childNodes[0].nodeValue);
		                }
		            }
		            return;
		            
	                /* var DuplicateFlag = DuplicateAprDeptCheck(aDeptID);
	                if (DuplicateFlag)
	                    AprLineAddDept(aDeptName, aDeptID);
	
	                var xmlHTTP = createXMLHttpRequest();
	                var xmlpara = createXmlDom();
	                var objNode;
	                createNodeInsert(xmlpara, objNode, "DATA");
	                createNodeAndInsertText(xmlpara, objNode, "DEPTID", aDeptID);
	                createNodeAndInsertText(xmlpara, objNode, "PROP", "EXTENSIONATTRIBUTE2");
	
	                xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptSubTreeInfo.aspx", false);
	                xmlHTTP.send(xmlpara);
	
	                var xmlNodes = createXmlDom();
	                xmlNodes = loadXMLString(xmlHTTP.responseText);
	
	                var objNodes = SelectNodes(xmlNodes, "NODES/NODE");
	
	                if (objNodes.length > 0) {
	                    for (var i = 0; i < objNodes.length; i++) {
	                        chkAllDept(objNodes[i].getElementsByTagName("CN")[0].childNodes[0].nodeValue,
	                            objNodes[i].getElementsByTagName("VALUE")[0].childNodes[0].nodeValue);
	                    }
	                }
	                return; */
	            }
	            catch (e) { alert(e.description); }
	        }
	
	        function DuplicateAprDeptCheck(DeptID) {
	            var AprDeptList = listview.GetDataRows();
	
	            var deptID;
	            var i;
	
	            for (i = 0 ; i < listview.GetRowCount() ; i++) {
	                deptID = GetAttribute(listview.GetDataRows()[i], "DATA1");
	
	                if (deptID == DeptID) {
	                    return false;
	                    break;
	                }
	            }
	            return true;
	        }
	
	        function AprLineAddDept(TNAME, TID) {
	            var Resultxml = createXmlDom();
	            Resultxml = loadXMLString("<LISTVIEWDATA><ROWS><ROW><CELL><VALUE></VALUE><DATA1></DATA1></CELL></ROW></ROWS></LISTVIEWDATA>");
	            var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");
	            setNodeText(GetChildNodes(objNodes[0])[0], TNAME);
	            setNodeText(GetChildNodes(objNodes[0])[1], TID);
	
	            var lvtFormView = new ListView();
	            lvtFormView.LoadFromID("lvtForm");
	
	            var InitTr = lvtFormView.GetDataRows();
	            var length = InitTr.length;
	            var noitem = false;
	            if (listview.GetRowCount() == 1) {
	                if (InitTr[0].id.indexOf("_TR_noItems") > -1) {
	                    lvtFormView.DeleteRow('lvtForm_TR_noItems');
	                    length = 0;
	                    noitem = true;
	                }
	            }
	
	            var MaxID = 0;
	            if (noitem) {
	                MaxID = 0;
	            } else {
	                for (var j = 0; j < length; j++) {
	                    var curnum = Number(lvtFormView.GetSelectedRowID(j).substring(lvtFormView.GetSelectedRowID(j).lastIndexOf('_') + 1), lvtFormView.GetSelectedRowID(j).length);
	                    if (MaxID < curnum) {
	                        MaxID = curnum;
	                    }
	                }
	            }
	            MaxID += 1;
	
	            var objTr = lvtFormView.AddRow(length);
	            SetAttribute(objTr, "id", "lvtForm" + "_TR_" + MaxID);
	            lvtFormView.AddDataRow(objTr, GetElementsByTagName(Resultxml.documentElement, "ROW")[0]);
	            lvtFormView.SetSelectFlag(false);
	            lvtFormView = null;
	        }
	
	        function deleteCont_onclick() {
	            var lvtFormView = new ListView();
	            lvtFormView.LoadFromID("lvtForm");
	            var selRow = lvtFormView.GetSelectedRows();
	            
	            if (selRow.length > 0) {
	                for (i = 0; i < selRow.length; i++) {
	                    lvtFormView.DeleteRow(GetAttribute(selRow[i], "id"));
	                }
	            } else {
	            }
	            lvtFormView = null;
	        }
	
	        function deleteAllCont_onclick() {
	            var selRow = listview.GetRowCount();
	
	            if (selRow > 0) {
	                while (true) {
	                    if (listview.GetRowCount() < 1) {
	                        break;
	                    }
	
	                    listview.DeleteRow(listview.GetSelectedRowID(0));
	                }
	            }
	        }
	
	        function lvtDeptSelect_SelChange() {
	
	        }
	
	        function lvtDeptSelect_rowdblclick() {
	            deleteCont_onclick();
	        }
	
	        function moveUp_onclick() {
	            listview.RowMoveUp();
	        }
	
	        function moveDown_onclick() {
	            listview.RowMoveDown();
	        }
	
	        function idSetField_onclick() {
	            message.View_CellProperty();
	        }
	
	        var FormConnInfo_dialogarguments = new Array();
	        function btn_FormConnInfo_onclick() {
	            FormConnInfo_dialogarguments[0] = "";
	            FormConnInfo_dialogarguments[1] = FormConnInfo_onclick_Complete;
	            var url = "/myoffice/ezApprovalG/manage/FormMaker/FormConnInfo.aspx?companyID=" + escape(companyID);
	            GetOpenWindow(url, "FormConnInfo", 430, 450, false);
	        }
	
	        function FormConnInfo_onclick_Complete(retVal) {
	            if (retVal != "cancel") {
	                if (getNodeText(txt_OpinionContent) == "") {
	                    setNodeText(txt_OpinionContent, retVal);
	                }
	                else {
	                    txt_OpinionContent.value = txt_OpinionContent.value + "\n" + retVal;
	                }
	            }
	        }
	
	        var itemcode_dialogArgument = new Array();
	        function btnItemCode_onclick() {
	            itemcode_dialogArgument[0] = "";
	            itemcode_dialogArgument[1] = btnItemCode_Complete;
	            var url = "/myoffice/ezApprovalG/DocNum/docnumui.aspx";
	            GetOpenWindow(url, "docnumui", 745, 370, false);
	        }
	
	        function btnItemCode_Complete(retVal) {
	            if (retVal[0] != "cancel") {
	                document.getElementById("tbItemCode").value = retVal[0];
	                document.getElementById("tbItemName").value = retVal[1];
	                document.getElementById("keepperiod").value = retVal[2];
	                document.getElementById("securitylevel").value = retVal[3];
	                document.getElementById("isPublic").value = retVal[4];
	                document.getElementById("tbItemName2").value = retVal[6];
	            }
	            else {
	            }
	        }
	
	        function DeleteItemCode() {
	            document.getElementById("tbItemCode").value = "";
	            document.getElementById("tbItemName").value = "";
	            document.getElementById("tbItemName2").value = "";
	            document.getElementById("securitylevel").selectedIndex = 0;
	            document.getElementById("keepperiod").selectedIndex = 0;
	            document.getElementById("isPublic").selectedIndex = 0;
	        }
	
	        function btnClose_onclick() {
	            window.opener.refreshFormList();
	            window.close();
	        }
	
	        function btn_OpinionAdd1_onclick() {
	            var SampleXML = "\n <VALIDATION>\n      <FIELD></FIELD>\n       <CLASS></CLASS>\n       <DESC></DESC>\n </VALIDATION>";
	            txt_OpinionContent1.value = txt_OpinionContent1.value + SampleXML;
	        }
	
	        function btn_OpinionAdd2_onclick() {
	            var SampleXML = "\n<CHECK>\n	<CASES>\n		<CASE>\n			<FIELD></FIELD>\n			<VALUE></VALUE>\n			<TYPE></TYPE>\n		</CASE>\n	</CASES>\n		<APRLINES>\n	    <APRLINE>\n			<APRTYPE></APRTYPE>\n			<CLASS></CLASS>\n			<VALUE></VALUE>\n			<DESC></DESC>\n		</APRLINE>\n	</APRLINES>\n</CHECK>";
	            txt_OpinionContent2.value = txt_OpinionContent2.value + SampleXML;
	        }
	
	        function btn_FormConnSave_onclick() {
	            var pInformationContent = "<spring:message code = 'ezApprovalG.t1455' />";
	            var rtnVal = OpenInformationUI(pInformationContent, FormConnSave_Complete);
	
	            if (rtnVal) {
	                var xmlhttp = createXMLHttpRequest();
	                var xmlpara = createXmlDom();
	                var objNode;
	
	                createNodeInsert(xmlpara, objNode, "PARAMETER");
	                createNodeAndInsertText(xmlpara, objNode, "pURL", message.HWP_GetDocumentElement());
	                createNodeAndInsertText(xmlpara, objNode, "pXml", "<?xml version=\"1.0\" encoding=\"euc-kr\"?>\n<CONNINFO>\n" + txt_OpinionContent.value + "\n</CONNINFO>");
	                createNodeAndInsertText(xmlpara, objNode, "pCompanyID", companyID);
	
	                xmlhttp.open("POST", "aspx/FormConnSave.aspx", false);
	                xmlhttp.send(xmlpara);
	
	                if (xmlhttp.responseText != "ERROR") {
	                    message.HWP_SetDocumentElement(xmlhttp.responseText.substring(8, xmlhttp.responseText.indexOf("</RESULT>")));
	                    alert(strLang814);
	                }
	            }
	        }
	
	        function FormConnSave_Complete(Ans) {
	            if (Ans) {
	                var xmlhttp = createXMLHttpRequest();
	                var xmlpara = createXmlDom();
	                var objNode;
	                createNodeInsert(xmlpara, objNode, "PARAMETER");
	                createNodeAndInsertText(xmlpara, objNode, "pURL", message.HWP_GetDocumentElement());
	                createNodeAndInsertText(xmlpara, objNode, "pXml", "<?xml version=\"1.0\" encoding=\"euc-kr\"?>\n<CONNINFO>\n" + txt_OpinionContent.value + "\n</CONNINFO>");
	                createNodeAndInsertText(xmlpara, objNode, "pCompanyID", companyID);
	                xmlhttp.open("POST", "aspx/FormConnSave.aspx", false);
	                xmlhttp.send(xmlpara);
	
	                if (xmlhttp.responseText != "ERROR") {
	                    message.HWP_SetDocumentElement(xmlhttp.responseText.substring(8, xmlhttp.responseText.indexOf("</RESULT>")));
	                    alert(strLang814);
	                }
	            }
	        }
		</script>
	</head>
	
	<body class="popup">
		<div id="menu">
	        <ul>
	            <li><span id="btnSave" onclick="return btnSave_onclick()"><spring:message code = 'ezApprovalG.t1767' /></span></li>
	        </ul>
	    </div>
	    <div id="close">
	        <ul>
	            <li><span id="btnClose" onclick="return btnClose_onclick()"><spring:message code = 'ezApprovalG.t64' /></span></li>
	        </ul>
	    </div>
	    <div class="portlet_tabpart01">
	        <div class="portlet_tabpart01_top" id="tab1">
	            <p id="ApvForm_sub1"><span divname="ApvForm_div1" id="1tab1"><spring:message code = 'ezApprovalG.t00004' /></span></p>
	            <p id="ApvForm_sub2"><span divname="ApvForm_div2" id="1tab2"><spring:message code = 'ezApprovalG.t1456' /></span></p>
	            <p id="ApvForm_sub3"><span divname="ApvForm_div3" id="1tab3"><spring:message code = 'ezApprovalG.t00005' /></span></p>
	            <p id="ApvForm_sub4" style="display:none"><span divname="ApvForm_div4" id="1tab4">WORKFLOW</span></p>
	            <p id="ApvForm_sub5"><span divname="ApvForm_div5" id="1tab5"><spring:message code = 'ezApprovalG.t1629' /></span></p>
	        </div>
	    </div>
	    <div id="ApvForm_content1" style="width: 100%; height: 90%; padding-top: 10px; display: none">
	        <h2 id="form" class="receiver_tltype01" style="margin-bottom: 5px;">
	            <span style="min-width: 45px;" id="formstr"><spring:message code = 'ezApprovalG.t825' /></span>
	        </h2>
	        <table class="content" style="width: 100%;">
	            <tr>
	                <th style="width: 10%; text-align: center"><c:out value = "${primary}" /></th>
	                <td style="width: 40%;">
	                    <input type="text" id="tbFormName" name="tbFormName" maxlength="50" style="width: 100%">
	                    <input type="text" id="tbFormID" name="tbFormID" style="display: none" readonly>
	                </td>
	                <th style="width: 10%; text-align: center"><c:out value = "${secondary}" /></th>
	                <td style="width: 40%;" colspan="5">
	                    <input type="text" id="tbFormName2" name="tbFormName2" maxlength="50" style="width: 100%">
	                </td>
	            </tr>
	            <tr>
	                <th style="width: 10%; text-align: center"><spring:message code = 'ezApprovalG.t598' /></th>
	                <td style="width: 40%;">
	                    <input type="text" id="tbDescript" name="tbDescript" style="WIDTH: 100%" maxlength="50">
	                </td>
	                <th style="width: 10%; text-align: center"><spring:message code = 'ezApprovalG.t1664' /></th>
	                <td style="width: 40%;" colspan="5">
	                    <select id="selFormKind" name="selFormKind" style="WIDTH: 170px;">
	                        <c:out value = "${docType}" />
	                    </select>
	                </td>
	            </tr>
	            <tr>
	                <td colspan="8" style="width: 10%; text-align: center">
	                    <input type="checkbox" id="setConnFlag" /><spring:message code = 'ezApprovalG.t1665' />
	                </td>
	            </tr>
	        </table>
	    </div>
	
	    <div id="ApvForm_content2" style="width: 100%; padding-top: 10px;">
	        <h2 id="H1" class="receiver_tltype01" style="margin-bottom: 5px;">
	            <span style="min-width: 45px;" id="Span1"><spring:message code = 'ezApprovalG.t00007' /></span>
	        </h2>
	        <div id="editor_content" style="padding-top: 5px;">
	            <div id="mainmenu">
	                <ul>
	                    <li id="property"><span onclick="return idSetField_onclick()"><spring:message code = 'ezApprovalG.t999934' /></span></li>
	                </ul>
	            </div>
	            <script type="text/javascript">
	                selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	            </script>
	            <table id="TForm" style="height: 770px; width: 1030px;">
	                <tr>
	                    <td style="height: 770px; vertical-align: top">
	                    	<c:choose>
	                    		<c:when test="${pEditorType == 'HWP' }">
	                    			<iframe id="message" class="viewbox" src="/admin/ezApprovalG/HWPEditor.do?type=ADMIN" name="message" frameborder="0" style="padding: 0; height: 100%; width: 1030px; overflow: auto; border: none"></iframe>
	                    		</c:when>
	                    		
	                    		<c:otherwise>
	                    			<iframe id="message" class="viewbox" src="/myoffice/ezEditor/Select_Editor.aspx?type=ADMIN" name="message" frameborder="0" style="padding: 0; height: 100%; width: 800px; overflow: auto; border:none"></iframe>
	                    		</c:otherwise>
	                    	</c:choose>
	                    	
	                        <%-- <% if (pEditorType == "HWP")
	                           { %>
	                        	<iframe id="message" class="viewbox" src="/myoffice/ezEditor/HWP_Editor.aspx?type=ADMIN" name="message" frameborder="0" style="padding: 0; height: 100%; width: 1030px; overflow: auto; border: none"></iframe>
	                        <% }
	                           else
	                           { %>
	                        	<iframe id="message" class="viewbox" src="/myoffice/ezEditor/Select_Editor.aspx?type=ADMIN" name="message" frameborder="0" style="padding: 0; height: 100%; width: 800px; overflow: auto; border:none"></iframe>
	                        <% } %> --%>
	                    </td>
	                    <td id="rootTD" name="rootTD" style="width: 100%; vertical-align: top; text-align: left; padding-left: 10px; display:none"></td>
	                </tr>
	            </table>
	        </div>
	    </div>
	    <div id="ApvForm_content3" style="width: 100%; height: 90%; display: none; padding-top: 10px;">
	        <h2 id="H2" class="receiver_tltype01" style="margin-bottom: 5px;">
	            <span style="min-width: 45px;" id="Span2"><spring:message code = 'ezApprovalG.t1446' /></span>
	        </h2>
	        <table class="content">
	            <tr>
	                <td>&lt;xml id=conn&gt;<br>
	                    &lt;connroot&gt;<br>
	                    <textarea class="textarea" id="txt_OpinionContent" style="FONT-SIZE: 9pt; WIDTH: 100%; HEIGHT: 760px"></textarea>
	                    <br>
	                    &lt;/connroot&gt;<br>
	                    &lt;/xml&gt; </td>
	                <th>
	                    <a class="imgbtn" id="btn_OpinionAdd"><span onclick="btn_FormConnInfo_onclick()"><spring:message code = 'ezApprovalG.t268' /></span></a><br>
	                    <a class="imgbtn" id="btn_OpinionSave" style="display:none"><span onclick="btn_FormConnSave_onclick()"><spring:message code = 'ezApprovalG.t59' /></span></a><br>
	                </th>
	            </tr>
	        </table>
	    </div>
	
	    <div id="ApvForm_content4" style="width: 100%; height: 60%; display: none; padding-top: 10px;">
	        <table class="content"> 
	                <tr> 
	                <td>&lt;xml id=WORKFLOW&gt;<br> 
	                    &lt;WORKFLOW&gt;<br> 
	                    &lt;VALIDATIONS&gt;<br> 
	                        <textarea name="txt_OpinionContent1" style="FONT-SIZE:9pt; WIDTH:100%; HEIGHT:350px" id="txt_OpinionContent1"></textarea> 
	                    <br> &lt;/VALIDATIONS&gt;<br> 
	                    &lt;STATUS&gt;<br> 
	                        <textarea name="txt_OpinionContent2" style="FONT-SIZE:9pt; WIDTH:100%; HEIGHT:350px" id="txt_OpinionContent2"></textarea> 
	                    <br> &lt;/STATUS&gt;<br> 
	                    &lt;/WORKFLOW&gt;<br> 
	                    &lt;/xml&gt; </td> 
	                <th> 
	                    <a class="imgbtn" id="Submit1"><span onclick="btn_OpinionAdd1_onclick()"><spring:message code = 'ezApprovalG.t268' /> 1</span></a><br>      
	                    <a class="imgbtn" id="Submit2"><span onclick="btn_OpinionAdd2_onclick()"><spring:message code = 'ezApprovalG.t268' /> 2</span></a><br>                           
		            </th> 
                </tr> 
            </table>          
	    </div>
	
	    <div id="ApvForm_content5" style="width: 100%; height: 100%; display: none; padding-top: 10px;">
	
	        <h2 id="group" class="receiver_tltype01" style="margin-bottom: 5px;">
	            <span style="min-width: 45px;" id="groupstr"><spring:message code = 'ezApprovalG.t1577' /></span>
	        </h2>
	
	        <table style="width: 100%; height: 565px;">
	            <tr>
	                <td style="width: 400px; vertical-align: top; padding-top: 5px; border-right: none">
	                    <h2>
	                        <spring:message code = 'ezApprovalG.t232' />
	                    </h2>
	                    <div id="divUserContTree" style="height: 530px; width: 100%; overflow-x: auto; overflow-y: auto; BORDER: #b6b6b6 1px solid; BACKGROUND-COLOR: #ffffff;"></div>
	                </td>
	                <td style="text-align: center; width: 50px; border-left: none; border-right: none">
	                    <img style="cursor: pointer;" src="/images/arr_r.gif" width="24" height="24" onclick="return insertCont_onclick()"><br>
	                    <img style="cursor: pointer" src="/images/arr_l.gif" width="24" height="24" onclick="return deleteCont_onclick()"><br>
	                    <img style="cursor: pointer" src="/images/arr_rr.gif" width="24" height="24" onclick="return insertAllCont_onclick()"><br>
	                    <img style="cursor: pointer" src="/images/arr_ll.gif" width="24" height="24" onclick="return deleteAllCont_onclick()"><br>
	                    <img style="cursor: pointer" src="/images/arr_u.gif" width="24" height="24" onclick="return moveUp_onclick()"><br>
	                    <img style="cursor: pointer" src="/images/arr_d.gif" width="24" height="24" onclick="return moveDown_onclick()">
	                </td>
	                <td style="width: 600px; vertical-align: top; padding-top: 5px; border-left: none;">
	                    <h2>
	                    	<spring:message code = 'ezApprovalG.t999932' />
	                    </h2>
	                    <div class="listview" style="border-top: none; height: 530px;">
	                        <div id="divlvtForm" style="WIDTH: 100%; HEIGHT: 100%; overflow-x: auto; overflow-y: auto; padding: 0px;"></div>
	                    </div>
	                </td>
	            </tr>
	        </table>
	    </div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
	        <iframe src="/blank.htm" style="border: none;" id="iFrameLayer"></iframe>
	    </div>
	    <form runat="server" id="bodyForm">
	        <asp:HiddenField ID="hidCompanyID" runat="server" />
	        <asp:HiddenField ID="hidFormID" runat="server" />
	        <asp:HiddenField ID="hidBeforeConnData" runat="server" />
	    </form>
	    <script type="text/javascript">
	        Tab1_NewTabIni("tab1");
	    </script>
	</body>
</html>