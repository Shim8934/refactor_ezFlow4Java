<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><c:out value = '${title}' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="/css/Tab.css" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ezForm.js"></script>
		<script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TreeView.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/FormMain.js"></script>		
				
		<script type="text/javascript">
			var companyID = "${companyID}";
		    var contID = "${contID}";
		    var formID = "${formID}";
		    var isInsUp = "${tCheck}";
		    var TreeIdx;
		    var treeNode;
		    var listview;
		    var TreeIdx;
		    var g_toggleFlag = false;
		    var formURL = "";
		    var beforeHTML = "";
		    var AutoRule_Listview;
		    var rtnVal = "";    
		    var AprTypeXML = createXmlDom();
		    var strResx436 = "<spring:message code='ezApproval.t436'/>";
		    var pDocType = "";
		    var thisSelGUID = ""; 
		    var FormProcSpelling = "${formProcSpelling}";
		    var htmlData = "";
		    var ConnData = "";
		    var WorkData = "";
		    var useEditor = "${useEditor}";
		
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
		
		    window.onload = function () {
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
		
		        getDeptFullTree("${topID}");
		        getFormRecv();
		        AprTypeXML = loadXMLString(bodyForm.hidAprTypeXml.value);
		        pDocType = document.getElementsByName("selDocType")[0].options[document.getElementsByName("selDocType")[0].selectedIndex].value;
		        MakeListXML(pDocType);
		        TreeViewinitialize("", companyID, "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName", "${serverName}");
		        if (formID != "") {
		            flag = false;
		            get_FormInfo();
		            if (useEditor != "HWP") {
		                var tempXML = createXmlDom();
		                var XmlBodyATT = createXmlDom();
		                var XmlBodyDATA = createXmlDom();
		                var tempStr = "";
		                tempStr = ConvertMHTtoHTML(formURL);
		
		                if (BroswerAndNonActiveXCheck() == "CROSS") {
		                    var parser = new DOMParser();
		                    tempXML = parser.parseFromString(tempStr, "text/xml");
		                    parser = null;
		                }
		                else {
		                    tempXML.async = "false";
		                    tempXML.loadXML(tempStr);
		                }
		
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
		            else
		                Editor_Complete();
		        }
		    }
		
		    var flag = false;
		    function Editor_Complete() {
		        if (flag == false) {
		            flag = true;
		            if (formURL != "") {
		                if (useEditor == "HWP") {
		                    document.getElementById("btn_OpinionSave").style.display = "";
		                    message.HWP_LoadFile(formURL);
		                    if (message.HWP_GetDocumentElement() != "") {
		                        var ConnURL = ReplaceAll(ReplaceAll(message.HWP_GetDocumentElement(), "<CONNINFO>", ""), "</CONNINFO>", "");
		
		                        var g_XmlDoc = createXmlDom();
		                        g_XmlDoc.async = false;
		                        g_XmlDoc.load(document.location.protocol + "//" + document.location.hostname + "/ezCommon/downloadAttach.do?filePath=" + escape(ConnURL));
		
		                        if (g_XmlDoc.xml == "")
		                            return;
		
		                        for (i = 0; i < g_XmlDoc.documentElement.childNodes.length; i++) {
		                            if (i == 0)
		                                setNodeText(txt_OpinionContent, g_XmlDoc.documentElement.childNodes(i).xml);
		                            else
		                                setNodeText(txt_OpinionContent, getNodeText(txt_OpinionContent) + "\n" + g_XmlDoc.documentElement.childNodes(i).xml);
		                        }
		                    }
		                }
		                else {
		                    document.getElementById("ApvForm_sub4").style.display = "";
		                    document.getElementById("ApvForm_sub6").style.display = "";
		                    document.getElementById("rootTD").style.display = "";
		                    message.SetEditorContent(htmlData);
		                }
		            }
		            else {
		                if (useEditor != "HWP") {
		                    document.getElementById("ApvForm_sub4").style.display = "";
		                    document.getElementById("ApvForm_sub6").style.display = "";
		                    document.getElementById("rootTD").style.display = "";
		                }
		                else
		                    document.getElementById("btn_OpinionSave").style.display = "";
		            }
		        }
		        add_doc_maker();
		    }
		
		    function Attribute_Write(value) {
		        setNodeText(BottonTDValue[1],value);
		        setNodeText(BottonTDValue[2],""); 
		        document.getElementById("EditInput").value = "";
		    }
		
		    function get_FormInfo() {
		    	$.ajax({
		    		type : "POST",
		    		async : false,
		    		url : "/admin/ezApprovalG/getFormInfo.do",
		    		data : {
		    			formID           : formID,
		    			companyID  		 : companyID
		    		},
		    		success: function(result){
// 		    			if (text != "") {
// 		    				var xmldom = createXmlDom();
// 			                xmldom = loadXMLString(text);
			
// 			                tbFormName.value = getNodeText(SelectNodes(xmldom, "DATA/FORMNAME")[0]);
// 			                tbFormName2.value = getNodeText(SelectNodes(xmldom, "DATA/FORMNAME2")[0]);
// 			                tbDescript.value = getNodeText(SelectNodes(xmldom, "DATA/FORMDESCRIPTION")[0]);
// 			                selFormKind.value = getNodeText(SelectNodes(xmldom, "DATA/FORMDOCTYPE")[0]);
// 			                formURL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(getNodeText(SelectNodes(xmldom, "DATA/FORMFILELOCATION")[0]));
			
// 			                if (getNodeText(SelectNodes(xmldom, "DATA/USEFLAG")[0]) == "Y") {
// 			                    setAutoItemCode.checked = true;
// 			                    document.getElementById('tr_setAutoItemCode').style.display = "";
// 			                    document.getElementById("isPublic").value = getNodeText(SelectNodes(xmldom, "DATA/ISPUBLIC")[0]);
// 			                    document.getElementById("tbItemCode").value = getNodeText(SelectNodes(xmldom, "DATA/ITEMCODE")[0]);
// 			                    document.getElementById("tbItemName").value = getNodeText(SelectNodes(xmldom, "DATA/ITEMNAME")[0]);
// 			                    document.getElementById("tbItemName2").value = getNodeText(SelectNodes(xmldom, "DATA/ITEMNAME2")[0]);
// 			                    document.getElementById("keepperiod").value = getNodeText(SelectNodes(xmldom, "DATA/KEEPPERIODCODE")[0]);
// 			                    document.getElementById("securitylevel").value = getNodeText(SelectNodes(xmldom, "DATA/SECURITYLEVEL")[0]);
// 			                }              
// 			            }
		    			
		    			if (result != "") {
			                var xmldom = loadXMLString(result);

			                $("#tbFormName").value(getNodeText(SelectNodes(xmldom, "ROW/FORMNAME")[0]));
			                $("#tbFormName2").value(getNodeText(SelectNodes(xmldom, "ROW/FORMNAME2")[0]));
			                $("#tbDescript").value(getNodeText(SelectNodes(xmldom, "ROW/FORMDESCRIPTION")[0]));
			                $("#selFormKind").value(getNodeText(SelectNodes(xmldom, "ROW/FORMDOCTYPE")[0]));
			                formURL = document.location.protocol+"//" + document.location.hostname + ":" + location.port + "/ezCommon/downloadAttach.do?filePath=" + encodeURI(getNodeText(SelectNodes(xmldom, "ROW/FORMFILELOCATION")[0]));
			                
			                if (getNodeText(SelectNodes(xmldom, "ROW/FORMCONNFLAG")[0]) == "Y") {
			                    document.getElementById("setConnFlag").checked = true;
			                }
			            }
		    		}
		    	});
		    }
		
		    function SaveFormInfo_after(text) {
		        try {
		            var resultXML = createXmlDom();
		            resultXML = loadXMLString(text);
		
		            var result = getNodeText(SelectNodes(resultXML, "DATA")[0]);
		            if (result == "OK") {
		                alert("<spring:message code='ezApproval.t755'/>");
		            }
		            else {
		                alert("<spring:message code='ezApproval.t757'/>");
		            }
		
		            try {
		            	window.close();
		                window.opener.refreshFormList();
		            }
		            catch (ee) {
		            	alert("SaveFormInfo_after error :: " + ee);
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
		            createNodeAndInsertText(xmlpara, objNode, "TOPID", "${topID}");
		            createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2;displayName1;displayName2");
		
		            var xmlHTTP = createXMLHttpRequest();
		            xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
		            xmlHTTP.send(xmlpara);
		            xmlpara = loadXMLString(xmlHTTP.responseText);
		
		            var treeView = new TreeView();
		            treeView.SetID("UserContTree");
		            treeView.SetUseAgency(true);
		            treeView.SetRequestData("RequestData");
		            treeView.SetNodeClick("TreeViewNodeClick");
		            treeView.DataSource(xmlpara);
		            treeView.DataBind("divUserContTree");
		
		            treeView.SetID("LineUserTree");
		            treeView.SetUseAgency(true);
		            treeView.SetRequestData("RequestData");
		            treeView.SetNodeClick("TreeView2NodeClick");
		            treeView.DataSource(xmlpara);
		            treeView.DataBind("divLineUserTree");
		        }
		        catch (e) { alert(e.description); }
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
		
		    function RequestData(pNodeID, pTreeID) {
		        TreeIdx = pNodeID;
		        treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlpara = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "DATA");
		        createNodeAndInsertText(xmlpara, objNode, "DEPTID", treeNode.GetNodeData("CN"));
		        createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2;displayName1;displayName2");
		
		        xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
		        xmlHTTP.send(xmlpara);
		
		        var treeView = new TreeView();
		        treeView.LoadFromID(pTreeID);
		        treeView.AppendChildNodes(loadXMLString(xmlHTTP.responseText).documentElement, pNodeID)
		    }
		
		    function TreeView2NodeClick(pNodeID, pNodeNM) {
		        TreeIdx = pNodeID;
		        treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        displayUserList2(treeNode.GetNodeData("CN"));
		    }
		
		    function TreeViewNodeClick(pNodeID, pNodeNM) {
		        TreeIdx = pNodeID;
		        treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        displayUserList(treeNode.GetNodeData("CN"));
		    }
		
		    function getFormRecv() {
				var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApprovalG/getFormRecvAdmin.do",
		    		data : {
		    			formID 	  : formID,
		    			companyID : companyID
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
		    	
		        var xmlpara = createXmlDom();
		        xmlpara = loadXMLString(result);
		
		        listview = new ListView();
		        listview.SetID("lvtForm");
		        listview.SetMulSelectable(true);
		        listview.SetRowOnClick("lvtDeptSelect_SelChange");
		        listview.SetRowOnDblClick("lvtDeptSelect_rowdblclick");
		        listview.DataSource(xmlpara);
		        listview.DataBind("divlvtForm");        
		    }
		
		    function insertCont_onclick() {
		        var DuplicateFlag = DuplicateAprDeptCheck(treeNode.GetNodeData("CN"));
		        if (DuplicateFlag) {
		            AprLineAddDept(treeNode.GetNodeData("VALUE"), treeNode.GetNodeData("CN"), "D");
		        } else {
		            var pAlertContent = "<spring:message code='ezApproval.t205'/><br>  <spring:message code='ezApproval.t206'/>";
		            OpenAlertUI(pAlertContent);
		        }
		    }
		
		    function insertAllCont_onclick() {
		        var pAlertContent = "<spring:message code='ezApproval.t623'/><br><spring:message code='ezApproval.t624'/>";
		        var Ans = OpenInformationUI(pAlertContent);
		
		        if (!Ans)
		            return;
		
		        chkAllDept(treeNode.GetNodeData("CN"), treeNode.GetNodeData("VALUE"));
		    }
		
		    function chkAllDept(aDeptID, aDeptName) {
		        try {
		            var DuplicateFlag = DuplicateAprDeptCheck(aDeptID);
		            if (DuplicateFlag)
		                AprLineAddDept(aDeptName, aDeptID, "D");
		
		            var xmlHTTP = createXMLHttpRequest();
		            var xmlpara = createXmlDom();
		
		            var objNode;
		            createNodeInsert(xmlpara, objNode, "DATA");
		            createNodeAndInsertText(xmlpara, objNode, "DEPTID", aDeptID);
		            createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2;displayName1;displayName2");
		
		            xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
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
		            return;
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
		
		    function AprLineAddDept(TNAME, TID, TYPE) {
		        var Resultxml = createXmlDom();
		        Resultxml = loadXMLString("<LISTVIEWDATA><ROWS><ROW><CELL><VALUE></VALUE><DATA1></DATA1><DATA2></DATA2></CELL><CELL><VALUE></VALUE></CELL></ROW></ROWS></LISTVIEWDATA>");
		        var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");
		        setNodeText(GetChildNodes(objNodes[0])[0], TNAME);
		        setNodeText(GetChildNodes(objNodes[0])[1], TID);
		
		        if (TYPE == "D") {
		            setNodeText(GetChildNodes(objNodes[0])[2], "");
		            setNodeText(GetChildNodes(objNodes[1])[0], "");
		        }
		        else {
		            var pUserList = new ListView();
		            pUserList.LoadFromID("lvUserList");
		
		            var selnode = pUserList.GetSelectedRows();
		            setNodeText(GetChildNodes(objNodes[0])[2], GetAttribute(selnode[0], "DATA2"));
		            setNodeText(GetChildNodes(objNodes[1])[0], GetAttribute(selnode[0], "DATA4"));
		        }
		
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
		        }
		        else {
		            for (var j = 0; j < length; j++) {
		                var curnum = Number(lvtFormView.GetSelectedRowID(j).substring(lvtFormView.GetSelectedRowID(j).lastIndexOf('_') + 1), lvtFormView.GetSelectedRowID(j).length);
		                if (MaxID < curnum)
		                    MaxID = curnum;
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
		        }
		        else {
		        }
		        lvtFormView = null;
		    }
		
		    function deleteAllCont_onclick() {
		        var selRow = listview.GetRowCount();
		
		        if (selRow > 0) {
		            while (true) {
		                if (listview.GetRowCount() < 1)
		                    break;
		
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
		
		    function idPropertyBtn_onclick() {
		        add_doc_maker();
		    }
		
		    function idSetField_onclick() {
		        message.View_CellProperty(SetFlag);
		    }
		
		    var FormConnInfo_dialogarguments = new Array();
		    function btn_FormConnInfo_onclick() {
		        FormConnInfo_dialogarguments[0] = "";
		        FormConnInfo_dialogarguments[1] = FormConnInfo_onclick_Complete;
		        var url = "/admin/ezApprovalG/formConnInfo.do?companyID=" + escape(companyID);
		        GetOpenWindow(url, "FormConnInfo", 430, 450, "NO");      
		    }
		
		    function FormConnInfo_onclick_Complete(retVal) {
		        if (retVal != "cancel") {
		            if (txt_OpinionContent.value == "") {
		                txt_OpinionContent.value = retVal;
		            }
		            else {
		                txt_OpinionContent.value = txt_OpinionContent.value + "\n" + retVal;
		            }
		        }
		    }
		
		    function viewAutoItemCode() {
		        if (setAutoItemCode.checked) {
		            document.getElementById("tr_setAutoItemCode").style.display = "";
		            btnItemCode_onclick();
		        }
		        else {
		            document.getElementById("tr_setAutoItemCode").style.display = "none";
		            DeleteItemCode();
		        }
		    }
		
		    var itemcode_dialogArgument = new Array();
		    function btnItemCode_onclick() {
		
		        itemcode_dialogArgument[0] = "";
		        itemcode_dialogArgument[1] = btnItemCode_Complete;
		        var url = "/admin/ezApproval/docNumUI.do";
		        GetOpenWindow(url, "docnumui_Cross", 745, 370, "NO");
		    }
		
		    function btnItemCode_Complete(retVal) {
		        if (retVal[0] != "cancel") {
		            document.getElementById("tbItemCode").value = retVal[0];
		            document.getElementById("tbItemName").value = retVal[1];
		            document.getElementById("keepperiod").value = retVal[2];
		            document.getElementById("securitylevel").value = retVal[3];
		            document.getElementById("isPublic").value = retVal[4];
		            document.getElementById("tbItemName2").value = retVal[6];
		            document.getElementById("setAutoItemCode").checked = true;
		        }
		        else {
		            if (document.getElementById("tbItemCode").value == "")
		                document.getElementById("setAutoItemCode").checked = false;
		        }
		    }
		
		    function DeleteItemCode() {
		        document.getElementById("tbItemCode").value = "";
		        document.getElementById("tbItemName").value = "";
		        document.getElementById("tbItemName2").value = "";
		        document.getElementById("securitylevel").selectedIndex = 0;
		        document.getElementById("keepperiod").selectedIndex = 0;
		        document.getElementById("isPublic").selectedIndex = 0;
		        document.getElementById("setAutoItemCode").checked = false;
		    }
		
		    var xmlhttpUserlist;
		    function displayUserList(pDeptID) {
		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezOrgan/getDeptMemberList.do",
		    		data : {
		    				deptID   : pDeptID, 
		    				cell 	 : "displayName;description;title;telephonenumber",
		    				prop     : "department;displayName;description;title",
		    				type 	 : "user"
		    				},
		    		success: function(result){
		    			var retXml = createXmlDom();
		    			
			            if (document.getElementById("UserList").innerHTML != "")
			                document.getElementById("UserList").innerHTML = "";
			
			            var headerData = createXmlDom();
			            headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
			            if (result != "") {
			                var xmlRtn = loadXMLString(result).documentElement.getElementsByTagName("ROWS")[0];
			                headerData.documentElement.appendChild(xmlRtn);
			            }
			            var pUserList = new ListView();
			            pUserList.SetID("lvUserList");
			            pUserList.SetRowOnClick("list_onSel_Click");
			            pUserList.SetRowOnDblClick("list_onSel_DBclick");
			            pUserList.SetSelectFlag(false);
			            pUserList.SetHeightFree(true);
			            pUserList.DataSource(headerData);
			            pUserList.DataBind("UserList");
			
			            var userRows = pUserList.GetDataRows();
			            if (userRows.length <= 0) {
			                OpenAlertUI(linealt1);
			            }
		    		}        			
		    	});
		    }
		
		    function displayUserList2(pDeptID) {
				var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezOrgan/getDeptMemberList.do",
		    		data : {
		    				deptID   : pDeptID, 
		    				cell 	 : "displayName;description;title;telephonenumber",
		    				prop     : "department;displayName;description;title",
		    				type 	 : "user"
		    				},
		    		success: function(result){
		                var retXml = createXmlDom();
		        		
			            if (document.getElementById("LineUserList").innerHTML != "")
			                document.getElementById("LineUserList").innerHTML = "";
			
			            var headerData = createXmlDom();
			            headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
			            if (result != "") {
			                var xmlRtn = loadXMLString(result).documentElement.getElementsByTagName("ROWS")[0];
			                headerData.documentElement.appendChild(xmlRtn);
			            }
			            var pUserList = new ListView();
			            pUserList.SetID("lvLineUserList");
			            pUserList.SetRowOnClick("list2_onSel_Click");
			            pUserList.SetRowOnDblClick("list2_onSel_DBclick");
			            pUserList.SetSelectFlag(false);
			            pUserList.SetHeightFree(true);
			            pUserList.DataSource(headerData);
			            pUserList.DataBind("LineUserList");
			
			            var userRows = pUserList.GetDataRows();
			            if (userRows.length <= 0) {
			                OpenAlertUI(linealt1);
			            }
		    		}        			
		    	});
		    }
		    function list_onSel_Click() {
		
		    }
		
		    function list_onSel_DBclick() {
		        insertContUser_onclick();
		    }
		
		    function list2_onSel_Click() {
		
		    }
		
		    function list2_onSel_DBclick() {
		        var pUserList = new ListView();
		        pUserList.LoadFromID("lvLineUserList");
		
		        var selnode = pUserList.GetSelectedRows();
		        var RtnVal = CheckSignCellValue();
		        InsertMode = "Add";
		        var pAPRLINE = new ListView();
		        pAPRLINE.LoadFromID("lvAPRAUTORULELINE");
		
		        if (RtnVal) {
		            APRLINEATTENDADDFunction(selnode, "PERSON");
		            initJunGyul();
		        }
		    }
		    function insertContUser_onclick() {
		        var DuplicateFlag = DuplicateAprDeptCheck(treeNode.GetNodeData("CN"));
		        if (DuplicateFlag) {
		            AprLineAddDept(treeNode.GetNodeData("VALUE"), treeNode.GetNodeData("CN"), "U");
		        } else {
		            var pAlertContent = "<spring:message code='ezApproval.t205'/><br>  <spring:message code='ezApproval.t206'/>";
		            OpenAlertUI(pAlertContent);
		        }
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
		        var pInformationContent = "<spring:message code='ezApproval.t515'/>";
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
		                alert(strLang410);
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
		                alert(strLang410);
		            }
		        }
		    }
		</script>
	</head>
    <body class="popup">
        <div id="menu">
            <ul>
                <li><span id="btnSave" onClick="return btnSave_onclick()"><spring:message code='ezApproval.t66'/></span></li>
            </ul>
        </div>
        <div id="close">
            <ul>
                <li><span id="btnClose" onClick="return btnClose_onclick()"><spring:message code='ezApproval.t70'/></span></li>
            </ul>
        </div>
        <div class="portlet_tabpart01">
	        <div class="portlet_tabpart01_top" id="tab1">
                <p id = "ApvForm_sub1"><span divname="ApvForm_div1" id="1tab1"><spring:message code='ezApproval.t00003'/></span></p>
                <p id = "ApvForm_sub2"><span divname="ApvForm_div2" id="1tab2"><spring:message code='ezApproval.t518'/></span></p>
                <p id = "ApvForm_sub3"><span divname="ApvForm_div3" id="1tab3"><spring:message code='ezApproval.t00005'/></span></p>
                <p id = "ApvForm_sub4" style="display:none"><span divname="ApvForm_div4" id="1tab4">WORKFLOW</span></p>
                <p id = "ApvForm_sub5"><span divname="ApvForm_div5" id="1tab5"><spring:message code='ezApproval.t730'/></span></p>
                <p id = "ApvForm_sub6" style="display:none"><span divname="ApvForm_div6" id="1tab6"><spring:message code='ezApproval.t990012'/></span></p>
	        </div>
        </div>
        <div id="ApvForm_content1" style="width:100%;height:90%; padding-top:10px; display:none">
             <h2 id="form" class="receiver_tltype01" style="margin-bottom:5px;">
                <span style="min-width: 45px;" id="formstr"><spring:message code='ezApproval.t00006'/></span>
             </h2>
             <table class="content" style="width:100%;">                
                <tr>                
                    <th style="width:100px; text-align:center">${langPrimary}</th>
                    <td style="width:40%;">
                        <input type="text" id="tbFormName" name="tbFormName" maxlength="50" style="width:100%">
                        <input type="text" id="tbFormID" name="tbFormID" style="display: none" readonly>
                    </td>
                    <th style="width:100px; text-align:center">${langSecondary}</th>
                    <td style="width:40%;" colspan="5">
                        <input type="text" id="tbFormName2" name="tbFormName2" maxlength="50" style="width:100%" >
                    </td>        
                </tr>
                <tr>
                    <th style="width:100px; text-align:center"><spring:message code='ezApproval.t507'/></th>
                    <td style="width:40%;">
                        <input type="text" id="tbDescript" name="tbDescript" style="WIDTH: 100%" maxlength="50">
                    </td>
                    <th style="width:100px; text-align:center"><spring:message code='ezApproval.t758'/></th>
                    <td style="width:40%;" colspan="5">
                        <select id="selFormKind" name="selFormKind" style="WIDTH: 170px;">
                            ${docType}
                        </select>
                    </td>
                </tr>    
            </table>   
            <br />
            <div style="padding-bottom:5px; vertical-align:middle"><input type="checkbox" id="setAutoItemCode" name="setAutoItemCode" onclick="viewAutoItemCode()" /><span><spring:message code='ezApproval.t00004'/></span></div>
            <table class="content" style="width:100%;">               
                <tr id="tr_setAutoItemCode" style="">
                    <th style="width:10%; text-align:center"><spring:message code='ezApproval.t335'/></th>
                    <td style="width:400px;">
                        <input type="text" id="tbItemCode" name="tbItemCode" style="WIDTH: 50px" readonly>
                        <input type="text" id="tbItemName" name="tbItemName" style="WIDTH: 80px" readonly>
                        <input type="hidden" id="tbItemName2" name="tbItemName2">
                        <a class="imgbtn"><span onclick="return btnItemCode_onclick()"><spring:message code='ezApproval.t321'/></span></a>
                        <a class="imgbtn"><span onclick="DeleteItemCode()"><spring:message code='ezApproval.t194'/></span></a>
                    </td>
                    <th style="width:10%; text-align:center"><spring:message code='ezApproval.t81'/></th>
                    <td style="width:100px; text-align:center">
                        <select id="securitylevel" name="select">
                            ${securityNode}
                        </select>
                    </td>
                    <th style="width:10%; text-align:center"><spring:message code='ezApproval.t336'/></th>
                    <td style="width:100px; text-align:center">
                        <select id="keepperiod" name="select">
                            ${periodNode}
                        </select>
                    </td>
                    <th style="width:10%; text-align:center"><spring:message code='ezApproval.t82'/></th>
                    <td style="width:100px; text-align:center">
                        <select id="isPublic" name="select">
                            <option value="Y" selected><spring:message code='ezApproval.t50'/></option>
                            <option value="N"><spring:message code='ezApproval.t49'/></option>
                        </select>
                    </td>
                </tr>
            </table>   
        </div>
           
        <div id="ApvForm_content2" style="width:100%;display:none; padding-top:10px;">
            <h2 id="H1" class="receiver_tltype01" style="margin-bottom:5px;">
            <span style="min-width: 45px;" id="Span1"><spring:message code='ezApproval.t00007'/></span>
            </h2>
             <div id="editor_content" style="padding-top:5px;">
                <div id="mainmenu">
                    <ul>
                    <li id="property"><span onclick="return idSetField_onclick()"><spring:message code='ezApproval.t641'/></span></li>
                    </ul>
                </div>
                <script type="text/javascript">
                    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
                </script>          
                 <table id="TForm" style="height:770px; width:1030px;">
                    <tr>
                        <td style="height:770px; vertical-align:top">
                        	<c:choose>
                        		<c:when test="${editorType == 'HWP'}">
	                                <iframe id="message" class="viewbox" src="/admin/ezApprovalG/hwpEditor.do?type=ADMIN" name="message" frameborder="0" style="padding: 0; height: 100%; width: 1030px; overflow: auto; border:none"></iframe>
                        		</c:when>
                        		<c:otherwise>
	                                <iframe id="message" class="viewbox" src="/adnub/ezApprovalG/selectEditor?type=ADMIN" name="message" frameborder="0" style="padding: 0; height: 100%; width: 800px; overflow: auto; border:none;"></iframe>
                        		</c:otherwise>
                        	</c:choose>
                        </td>
                        <td id="rootTD" name="rootTD" style="width:100%; vertical-align:top; text-align:left; padding-left:10px; display:none">
                        </td>
                    </tr>
                </table>  
            </div>
        </div>      
        <div id="ApvForm_content3" style="width:100%;height:90%;display:none; padding-top:10px;">   
            <h2 id="H2" class="receiver_tltype01" style="margin-bottom:5px;">
            <span style="min-width: 45px;" id="Span2"><spring:message code='ezApproval.t504'/></span>
            </h2>         
            <table class="content">
                <tr>
                    <td style="height:800px">&lt;xml id=conn&gt;<br>
                        &lt;connroot&gt;<br>
                        <textarea class="textarea" ID="txt_OpinionContent" style="FONT-SIZE:9pt; WIDTH:100%; HEIGHT:750px"></textarea>
                        <br>
                        &lt;/connroot&gt;<br>
                        &lt;/xml&gt; </td>
                    <th>
                        <a class="imgbtn" id="btn_OpinionAdd"><span onclick="btn_FormConnInfo_onclick()"><spring:message code='ezApproval.t193'/></span></a><br>                              
                        <a class="imgbtn" id="btn_OpinionSave" style="display:none"><span onclick="btn_FormConnSave_onclick()"><spring:message code='ezApproval.t66'/></span></a><br>
                    </th>
                </tr>
            </table>              
        </div>        

        <div id="ApvForm_content4" style="width:100%;height:60%;display:none; padding-top:10px;">       <table class="content"> 
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
                    <a class="imgbtn" id="Submit1"><span onclick="btn_OpinionAdd1_onclick()"><spring:message code='ezApproval.t529'/></span></a><br>      
                    <a class="imgbtn" id="Submit2"><span onclick="btn_OpinionAdd2_onclick()"><spring:message code='ezApproval.t530'/></span></a><br>                           
	            </th> 
                </tr> 
            </table>          
            
        </div>
        <div id="ApvForm_content5" style="width:100%;height:90%;display:none; padding-top:10px;">         
            <h2 id="group" class="receiver_tltype01" style="margin-bottom:5px;">
            <span style="min-width: 45px;" id="groupstr"><spring:message code='ezApproval.t646'/></span>
            </h2>
            <table style="width:100%; height:750px;">         
                <tr>
                    <td style="width:400px; vertical-align:top; padding-top:5px; border-right:none">
                        <h2>
                            <spring:message code='ezApproval.t173'/>
                        </h2>
                        <div id="divUserContTree" style="height: 330px; width: 100%; overflow-x: auto; overflow-y: auto; BORDER: #b6b6b6 1px solid; BACKGROUND-COLOR: #ffffff;"></div>
                        <br />
                        <div class="div_scroll" style="border:none;">
                            <div id="UserList" style="height: 280px; width: 100%; overflow-x: auto; overflow-y: auto; BORDER: #b6b6b6 1px solid; BACKGROUND-COLOR: #ffffff;border-top:none"></div>
                        </div>
                    </td>
                    <td style="text-align:center; width:50px; border-left:none; border-right:none">
                        <img style="cursor:pointer;" src="/images/arr_r.gif" width="24" height="24" onclick="return insertCont_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_l.gif" width="24" height="24" onclick="return deleteCont_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_rr.gif" width="24" height="24" onclick="return insertAllCont_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_ll.gif" width="24" height="24" onclick="return deleteAllCont_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_u.gif" width="24" height="24" onclick="return moveUp_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_d.gif" width="24" height="24" onclick="return moveDown_onclick()"><br>
                        <div style="height:250px;">&nbsp;</div>
                        <img style="cursor:pointer;" src="/images/arr_r.gif" width="24" height="24" onclick="return insertContUser_onclick()"><br>
                    </td>
                    <td style="width:600px; vertical-align:top; padding-top:5px; border-left:none;">
                        <h2>
                            <spring:message code='ezApproval.t61'/>
                        </h2>
                        <div class="div_scroll" style="border:none; height:625px;">
                            <div id="divlvtForm" style="WIDTH: 100%; HEIGHT: 100%;overflow-x: auto; overflow-y: auto; BORDER: #b6b6b6 1px solid; BACKGROUND-COLOR: #ffffff;border-top:none"></div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div id="ApvForm_content6" style="width:100%;height:90%;display:none; padding-top:10px;">         
            <h2 id="H3" class="receiver_tltype01" style="margin-bottom:5px;">
                <span style="min-width: 45px;" id="Span3"><spring:message code='ezApproval.t990012'/></span>
            </h2>
            <table>
	            <tr>
		            <th><spring:message code='ezApproval.t603'/></th>
		            <td><select id="selDocType" name="selDocType" onChange="return OnChange_DocType()">				
				            ${docType}
			            </select>
		            </td>
	            </tr>
            </table>
            <br />
            <table style="width:100%; border:none;">
                <tr>                 
                    <td colspan="2" style="text-align:right;vertical-align:bottom;"> 
                        <img src="/images/arr_u.gif" width="24" height="24" style="cursor: pointer;"
                            onclick="MoveUp_List_AutoRule_onclick()">
                        <img src="/images/arr_d.gif" width="24" height="24" style="cursor: pointer"
                            onclick="MoveDown_List_AutoRule_onclick()">
                    </td>
                </tr>
            <tr> 
                <td style="vertical-align:top;height: 135px;" colspan="2"> 
                    <div class="listview" style="border:1px solid #b6b6b6;width:100%">
                        <div id="div_List_AutoRule" style="border: 0; font-size:9pt;width: 100%; height: 130px;overflow:auto;"></div>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="vertical-align:top" colspan="2"> 
                    <table class="content" style="width:100%;border:0">
                        <tr>
                            <th style="text-align:center;width:10%"><spring:message code='ezApproval.t990016'/></th>
                            <td>
                                <select id="DDL_CHECKTYPE" style="width:130px" onchange="DDL_CHECKTYPE_onChange()">
                                    <option value="FIELD"><spring:message code='ezApproval.t990020'/></option>
                                    <option value="DRAFTER_DEPT"><spring:message code='ezApproval.t990021'/></option>
                                </select>
                                <select id="DDL_FIELDIDLIST" onchange="FieldIdList_onChange()">
                                    <option value=""><spring:message code='ezApproval.t990022'/></option>
                                </select>
                                <input type="text" id="txtCondVal" style="width:150px;ime-mode:disabled;margin-top:-1px" />
                            </td>
                            <td rowspan="4" style="width:150px;">
                                <a class="imgbtn" onclick="return btn_Add();" ><span style="font-size:8pt"><spring:message code='ezApproval.t990043'/></span></a>                   
                            </td>
                        </tr>
                        <tr>
                            <th style="text-align:center;"><spring:message code='ezApproval.t990023'/></th>
                            <td>
                                <select id="DDL_DATATYPE" style="width:80px" onchange="DDL_DATATYPE_onChange()">
                                    <option value="TXT"><spring:message code='ezApproval.t990024'/></option>
                                    <option value="NUM"><spring:message code='ezApproval.t990025'/></option>
                                </select>
                                <select id="DDL_NUMBER_EQUAL" style="width:80px;display:none">
                                    <option value="NUM_GE">>= <spring:message code='ezApproval.t990029'/></option>
                                    <option value="NUM_LE"><= <spring:message code='ezApproval.t990030'/></option>                        
                                    <option value="NUM_GT">> <spring:message code='ezApproval.t990031'/></option>
                                    <option value="NUM_LT">< <spring:message code='ezApproval.t990032'/></option>
                                    <option value="NUM_EQ">= <spring:message code='ezApproval.t990026'/></option>
                                </select>
                                <select id="DDL_TEXT_EQUAL" style="width:80px">
                                    <option value="TXT_EQ"><spring:message code='ezApproval.t990026'/></option>
                                    <option value="TXT_INC"><spring:message code='ezApproval.t990027'/></option>                        
                                    <option value="TXT_NOTINC"><spring:message code='ezApproval.t990028'/></option>
                                </select>
                            </td>
                        </tr>
                        <tr> 
                            <th style="text-align:center;"><spring:message code='ezApproval.t990019'/></th>
                            <td> 
                                <select id="DDL_STANDVAL" onchange="ChangeStandVal()" >
                                    <option value="DeptId"><spring:message code='ezApproval.t171'/></option>                      
                                    <option value="TitleCd" style="display:none"><spring:message code='ezApproval.t170'/></option>
                                    <option value="Direct"><spring:message code='ezApproval.t990022'/></option>
                                </select>
                                <input type="button" value="<spring:message code='ezApproval.t344'/>" id="btnSelDept" onclick="SelectDept()" />
                                <select id="DDL_TITLE" style="display:none" onchange="DDL_TITLE_OnChange()"> 
                                    <option><spring:message code='ezApproval.t990046'/></option>  
                                </select>
                                <input type="text" id="txtStandVal" value="" style="width:150px;margin-top:-5px" />
                            </td>
                        </tr>
                    </table> 
                </td>
            </tr>
        </table>
            <div id="DIVAPRLINE" style="width:100%;height:500px;display:none">
            <table>
                <tr>
                    <td style="height:480px;width:330px;margin-left:5px;vertical-align:top;">
                        <div class="portlet_tabpart01" align="right" style="margin-top:3px;">
	                        <div class="portlet_tabpart01_top" id="tab2">
                                    <p><span divname="Organ" id="2tab1"><spring:message code='ezApproval.t173'/></span></p>  
	                        </div>
                        </div>
                        <div id="OrganLineTab">
                            <table style="margin-left:0px">
                                <tr>
                                    <td valign="top">
                                        <div id ="divLineUserTree" style="margin-top:5px;overflow-x:auto;overflow-y:auto;height:200px;width:330px;border:1px solid #b6b6b6;background-color:#FFFFFF;margin:1px 1px 1px 1px;">
                                    </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="">
                                        <div class="listview" style="border:0px;">
                                            <div id= "LineUserList" style="border:0px;margin:0px;Width:330px; Height:220px;overflow:auto;border:1px solid #b6b6b6;margin:1px 1px 1px 1px;"></div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="30" style="background-color:transparent;border:0px;">
                                        <div style="border:1px solid #b6b6b6;margin:0px 1px 1px 1px;height:27px;">
                                    <input id="textUser" style="width:160px" name="textUser" onKeyPress="return textUser_onkeypress()" tabindex="1" maxlength="50">
                                    <a class="imgbtn" onKeyPress="return btn_searchUser_onclick()" onClick="return btn_searchUser_onclick()" name="btn_searchUser" id="btn_searchUser" tabindex="1"><span  style="width:60px;text-align:center" ><spring:message code='ezApproval.t175'/></span></a>
                                            </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td style="border:0px solid red;vertical-align:central;padding-left:4px;padding-right:4px">
                        <img src="/images/arr_up.gif" width="16" height="16" vspace="2" style="cursor: pointer;" onclick="AprlineUpper_onclick()" alt="<spring:message code='ezApproval.hyj9'/>"><br />
                        <img src="/images/arr_down.gif" width="16" height="16" vspace="2" style="cursor: pointer" onclick="AprlineDown_onclick()" alt="<spring:message code='ezApproval.hyj10'/>"><br />  
                    </td>
                    <td style="border:0px solid red;height:550px;width:650px;vertical-align:top;">
                      <table style="margin-left:1px;height:450px;">
                        <tr>
                            <td valign="top">
                                <h2 style ="vertical-align:top;" >                            
                                    <div style="text-align:right;vertical-align: top; height: 20px;"> 
                                        <a class="imgbtn" onclick="return AddDeptmentSelected();" ><span><spring:message code='ezApproval.t990036'/></span></a>
                                        <a class="imgbtn" onclick="AprlineNullAdd_onclick('user')"><span><spring:message code='ezApproval.t990037'/></span></a>
                                        <a class="imgbtn" onclick="AprlineNullAdd_onclick('dept')"><span><spring:message code='ezApproval.t1101'/></span></a>
                                        <a class="imgbtn" onclick="AprlineNullAdd_onclick('draft')"><span><spring:message code='ezApproval.t990038'/></span></a>
                                        <a class="imgbtn" onclick="AprlineNullAdd_onclick('all')"><span><spring:message code='ezApproval.t990039'/></span></a>
                                        <a class="imgbtn" onclick="AprlineNullAdd_onclick('temp')"><span><spring:message code='ezApproval.t990040'/></span></a>
                                    </div>
                                </h2>
                                <div class="listview">
                                    <div id ="APRLINE" style="Width:650px; Height:425px; overflow:auto;border:0;font-size:9pt; margin:1px 1px 1px 1px;padding-top:1px;"></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="height:30px;border:1px solid #b6b6b6;text-align:center;">
                                <input type="checkbox" name="FixYN" id="FixYN" value ="checkbox" onclick="return FixFlag_onclick()"><spring:message code='ezApproval.t990041'/> &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                        </tr>
                      </table>
                    </td>
                </tr>
            </table>    
        </div>      
        </div>   
         <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background:none rgba(0,0,0,0.7); display:none;" id="mailPanel">&nbsp;</div>	
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		    <iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
	    </div>     
        <form id="bodyForm">
        	<input type="hidden" id="hidCompanyID" value="${companyID}">
        	<input type="hidden" id="hidFormID" value="${formID}">
        	<input type="hidden" id="hidListHeader" value="${listHeader}">
        	<input type="hidden" id="hidAprRule" value="${aprRule}">
        	<input type="hidden" id="hidAprRuleLine" value="${aprRuleLine}">
        	<input type="hidden" id="hidAprTypeXml" value="${aprTypeXML}">
<!--             <asp:HiddenField ID="hidBeforeConnData" runat="server" /> -->
<!--             <asp:HiddenField ID="hidXslt" runat="server" /> -->
        </form>
        <script type="text/javascript">
            Tab1_NewTabIni("tab1");
        </script>

        <xml id="userlist_h" style="display: none">
            <LISTVIEWDATA>
                <HEADERS>
                    <HEADER>
                        <NAME><spring:message code='ezApproval.t265'/></NAME>
                        <WIDTH>70</WIDTH>
                    </HEADER>
                    <HEADER>
                        <NAME><spring:message code='ezApproval.t216'/></NAME>
                        <WIDTH>100</WIDTH>
                    </HEADER>
                    <HEADER>
                        <NAME><spring:message code='ezApproval.t266'/></NAME>
                        <WIDTH>60</WIDTH>
                    </HEADER>
                    <HEADER>
                        <NAME><spring:message code='ezApproval.t172'/></NAME>
                        <WIDTH>80</WIDTH>
                    </HEADER>
                </HEADERS>
                <ROWS></ROWS>
            </LISTVIEWDATA>
        </xml>
</html>