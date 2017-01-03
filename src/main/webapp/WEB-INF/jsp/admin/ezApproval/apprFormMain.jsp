<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<html>
	<head>
		<title>${title}</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="/css/Tab.css" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApproval.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApproval/admin/ezForm.js"></script>
		<script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApproval/control_Cross/ListView_list.js" ></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/TreeView.js" ></script>
		<script type="text/javascript" src="/js/ezApproval/TreeViewCtrl_Cross.js"></script>  
		<script type="text/javascript" src="/js/ezApproval/Common.js"></script>
		<script type="text/javascript" src="/js/ezApproval/admin/FormMain.js"></script>
		<script type="text/javascript" src="/js/ezApproval/admin/AutoLineRuleMaker.js"></script>
		<script type="text/javascript" src="/js/ezApproval/admin/AutoLineRuleMaker_AprLine.js"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
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
		    var FormProcSpelling = "0";
		
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
		        
		        if (formID != "") {
		            get_FormInfo(); 
		        }
		       
		        getDeptFullTree("${topID}");
		        getFormRecv();
		        AprTypeXML = loadXMLString(bodyForm.hidAprTypeXml.value);
		        pDocType = document.getElementsByName("selDocType")[0].options[document.getElementsByName("selDocType")[0].selectedIndex].value;
		        MakeListXML(pDocType);
		        TreeViewinitialize("", companyID, "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName", "${userInfo.serverName}");
		
		        add_doc_maker(companyID);
		    }
		    var flag = false;
		    function pzFormProc_DocumentComplete() {
		        if (flag == false) {
		            ChangeTab(document.getElementById("1tab1"));
		            flag = true;
		
		            if (formURL != "") {
		                pzFormProc.LoadURL(formURL);                
		            }
		        }
		    }
		
		    function pzFormProc_InvalidDocument() {
		        pzFormProc.ShowWorkingDlg("", false);
		    }
		
		    function pzFormProc_FieldsAvailable() {
		        if (formURL != "") {
		            ReturnFormConnXML();
		            ReturnWorkFlowXML();
		        }
		        
		    }
		
		    function ReturnFormConnXML() {        
		        if (pzFormProc.editor.DOM.all.conn) {
		            setNodeText(txt_OpinionContent, pzFormProc.editor.DOM.all.conn.innerHTML.replace('<CONNINFO>', '').replace('</CONNINFO>', '').replace('<conninfo>', '').replace('</conninfo>', ''));
		        }
		    }
		
		    function ReturnWorkFlowXML() {
		        if (pzFormProc.editor.DOM.all.WORKFLOW) {
		            var WorkData = pzFormProc.editor.DOM.all.WORKFLOW.innerHTML.toUpperCase();
		            var VALIDATIONS = WorkData.slice(WorkData.indexOf("<VALIDATION>"), WorkData.indexOf("</VALIDATIONS>"));
		            setNodeText(txt_OpinionContent1, ReplaceText(VALIDATIONS, "<BR>", "\n"));
		
		            var STATUS = WorkData.slice(WorkData.indexOf("<CHECK>"), WorkData.indexOf("</STATUS>"));
		            setNodeText(txt_OpinionContent2, ReplaceText(STATUS, "<BR>", "\n"));           
		        }
		    }
		
		    function get_FormInfo() {
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/getFormInfo.do",
		    		data : {
		    			formID           : formID,
		    			lang             : "${userInfo.lang}",
		    			companyID  		 : companyID
		    		},
		    		success: function(text){
		    			if (text != "") {
			                var xmldom = createXmlDom();
			                xmldom = loadXMLString(text);
			
			                tbFormName.value = getNodeText(SelectNodes(xmldom, "DATA/FORMNAME")[0]);
			                tbFormName2.value = getNodeText(SelectNodes(xmldom, "DATA/FORMNAME2")[0]);
			                tbDescript.value = getNodeText(SelectNodes(xmldom, "DATA/FORMDESCRIPTION")[0]);
			                selFormKind.value = getNodeText(SelectNodes(xmldom, "DATA/FORMDOCTYPE")[0]);             
			                formURL = "/ezCommon/downloadAttach.do?filePath=" + escape(getNodeText(SelectNodes(xmldom, "DATA/FORMFILELOCATION")[0]));
			
			                if (getNodeText(SelectNodes(xmldom, "DATA/USEFLAG")[0]) == "Y") {
			                    setAutoItemCode.checked = true;
			                    document.getElementById('tr_setAutoItemCode').style.display = "";
			                    isPublic.value = getNodeText(SelectNodes(xmldom, "DATA/ISPUBLIC")[0]);
			                    tbItemCode.value = getNodeText(SelectNodes(xmldom, "DATA/ITEMCODE")[0]);
			                    tbItemName.value = getNodeText(SelectNodes(xmldom, "DATA/ITEMNAME")[0]);
			                    tbItemName2.value = getNodeText(SelectNodes(xmldom, "DATA/ITEMNAME2")[0]);
			                    SetSelectVal("keepperiod", getNodeText(SelectNodes(xmldom, "DATA/KEEPPERIODCODE")[0]))                    
			                    securitylevel.value = getNodeText(SelectNodes(xmldom, "DATA/SECURITYLEVEL")[0]);
			                }                
			            }
		    		}
		    	});
		    }
		
		
		    function SaveFormInfo_after(text) {
		        try {
		            if (text == "<DATA>OK</DATA>") {
		                alert("<spring:message code='ezApproval.t755'/>");
		            }
		            else {
		                alert("<spring:message code='ezApproval.t757'/>");
		            }
		
		            try{
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
		    		url : "/admin/ezApproval/getFormRecvAdmin.do",
		    		data : {
		    			formID 	  : formID,
		    			companyID : companyID
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
		    	var xmlRtn = createXmlDom();
		        xmlRtn = loadXMLString(result);
		
		        listview = new ListView();
		        listview.SetID("lvtForm");
		        listview.SetMulSelectable(true);
		        listview.SetRowOnClick("lvtDeptSelect_SelChange");
		        listview.SetRowOnDblClick("lvtDeptSelect_rowdblclick");
		        listview.DataSource(xmlRtn);
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
		        add_doc_maker(companyID);
		    }
		
		    function idSetField_onclick() {
		        g_toggleFlag = !g_toggleFlag;
		
		        pzFormProc.SetCheckFieldForAdmin(g_toggleFlag);
		        button();
		    }
		
		    function button() {
		        var str;
		        if (g_toggleFlag != true) {
		            setNodeText(property.childNodes(0),"<spring:message code='ezApproval.t641'/>");
		            }
		            else {
		            setNodeText(property.childNodes(0),"<spring:message code='ezApproval.t642'/>");
		            }
		        }
		
		    var FormConnInfo_dialogarguments = new Array();
		    function btn_FormConnInfo_onclick() {
		        FormConnInfo_dialogarguments[0] = "";
		        FormConnInfo_dialogarguments[1] = FormConnInfo_onclick_Complete;
		        var url = "/myoffice/ezApproval/manage/FormMaker/FormConnInfo.aspx?companyID=" + escape(companyID);
		        GetOpenWindow(url, "FormConnInfo", 430, 450, false);
		    }
		
		    function FormConnInfo_onclick_Complete(retVal) {
		        if (retVal != "cancel") {
		            if (getNodeText(txt_OpinionContent) == "") {
		                setNodeText(txt_OpinionContent,retVal);
		            }
		            else {
		                setNodeText(txt_OpinionContent,getNodeText(txt_OpinionContent) + "\n" + retVal);
		            }
		        }
		    }
		
		    function btn_FormConnSave_onclick() {
		        var rtnVal = new Array();
		        var pInformationContent = "<spring:message code='ezApproval.t515'/>";
		        var Ans = OpenInformationUI(pInformationContent);
		        if (Ans) {
		            rtnVal[0] = "TRUE";
		            rtnVal[1] = "<CONNINFO>\n" + getNodeText(txt_OpinionContent) + "\n</CONNINFO>";
		
		            if (!pzFormProc.editor.DOM.all.conn) {
		                var XMLInfo = "<xml id=conn></xml>";
		                pzFormProc.editor.DOM.body.innerHTML = XMLInfo + pzFormProc.editor.DOM.body.innerHTML;
		                pzFormProc.refresh();
		            }
		
		            pzFormProc.editor.DOM.all.conn.innerHTML = rtnVal[1];
		            pzFormProc.refresh();
		            alert("XML <spring:message code='ezApproval.t522'/>");
		        }
		    }
		
		    function OpenInformationUI(pInformationContent) {
		        var parameter = pInformationContent;
		        var url = "/admin/ezApproval/ezAprOpinion.do";
		        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		        var RtnVal = window.showModalDialog(url, parameter, feature);
		        return RtnVal;
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
		//그냥 버젼 소스 꼬임
// 		    function btnItemCode_onclick() {
// 		        var url = "/admin/ezApproval/docNumUI.do";
// 		        var retVal = window.showModalDialog(url, "", "dialogWidth:745px;dialogHeight:370px;status:no;help:no;scroll:no;edge:sunken");
		
// 		        if (retVal[0] != "cancel") {
// 		            tbItemCode.value = retVal[0];
// 		            tbItemName.value = retVal[1];
// 		            SetSelectVal("keepperiod", retVal[2]);            
// 		            securitylevel.value = retVal[3];
// 		            isPublic.value = retVal[4];
// 		            tbItemName2.value = retVal[6];
// 		            setAutoItemCode.checked = true;
// 		        }
// 		        else {
// 		            if (tbItemCode.value == "")
// 		                setAutoItemCode.checked = false;
// 		        }
// 		    }
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
		//그냥 버젼
// 		    function DeleteItemCode() {
// 		        tbItemCode.value = "";
// 		        tbItemName.value = "";
// 		        tbItemName2.value = "";
// 		        securitylevel.selectedIndex = 0;
// 		        keepperiod.selectedIndex = 0;
// 		        isPublic.selectedIndex = 0;
// 		        setAutoItemCode.checked = false;
// 		    }
		
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
		    	$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezOrgan/getDeptMemberList.do",
					data : {
							deptID   : pDeptID, 
							cell 	 : "displayName;description;title;telephoneNumber",
							prop     : "department;displayName;description;title",
							type 	 : "user"
							},
					success: function(text){
						var retXml = createXmlDom();
						
			            if (document.getElementById("UserList").innerHTML != "")
			                document.getElementById("UserList").innerHTML = "";
			
			            var headerData = createXmlDom();
			            headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
			            if (text != "") {
			                var xmlRtn = loadXMLString(text).documentElement.getElementsByTagName("ROWS")[0];
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
		    	$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezOrgan/getDeptMemberList.do",
					data : {
							deptID   : pDeptID, 
							cell 	 : "displayName;description;title;telephoneNumber",
							prop     : "department;displayName;description;title",
							type 	 : "user"
							},
					success: function(text){
			            var retXml = createXmlDom();
			
			            if (document.getElementById("LineUserList").innerHTML != "")
			                document.getElementById("LineUserList").innerHTML = "";
			
			            var headerData = createXmlDom();
			            headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
			            if (text != "") {
			                var xmlRtn = loadXMLString(text).documentElement.getElementsByTagName("ROWS")[0];
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
		
		    function btn_OpinionAdd1_onclick() {
		        var SampleXML = "\n<VALIDATION>\n            <FIELD></FIELD>\n	    <CLASS></CLASS>\n	    <DESC></DESC>\n</VALIDATION>\n";
		        txt_OpinionContent1.value = txt_OpinionContent1.value + SampleXML;
		    }
		
		    function btn_OpinionAdd2_onclick() {
		        var SampleXML = "\n<CHECK>\n	<CASES>\n		<CASE>\n			<FIELD></FIELD>\n			<VALUE></VALUE>\n			<TYPE></TYPE>\n		</CASE>\n	</CASES>\n		<APRLINES>\n	    <APRLINE>\n			<APRTYPE></APRTYPE>\n			<CLASS></CLASS>\n			<VALUE></VALUE>\n			<DESC></DESC>\n		</APRLINE>\n	</APRLINES>\n</CHECK>\n";
		        txt_OpinionContent2.value = txt_OpinionContent2.value + SampleXML;
		    }
		
		    function btn_WorkFlowSave_onclick() {
		        if (!pzFormProc.editor.DOM.all.WORKFLOW) {
		            var XMLInfo = "<xml id=WORKFLOW style='display:none;'></xml>";
		            pzFormProc.editor.DOM.body.innerHTML = XMLInfo + pzFormProc.editor.DOM.body.innerHTML;
		            pzFormProc.refresh();
		        }
		
		        pzFormProc.editor.DOM.all.WORKFLOW.innerHTML = "\n   <WORKFLOW>\n    <VALIDATIONS>\n" + txt_OpinionContent1.value + "\n</VALIDATIONS>\n  <STATUS>\n" + txt_OpinionContent2.value + "\n</STATUS>\n</WORKFLOW>\n";
		        pzFormProc.refresh();
		        alert("XML <spring:message code='ezApproval.t522'/>");
		    }
		
		</script>
		<script type="text/javascript" for="pzFormProc" event="FieldsAvailable">
		    pzFormProc_FieldsAvailable();
		</script>
		<script type="text/javascript" for="pzFormProc" event="DocumentComplete">
		    pzFormProc_DocumentComplete()
		    
		</script>
		<script type="text/javascript" for="pzFormProc" event="BlurTDElement">
		    pzFormProc_BlurTDElement()
		
		</script>
		<script type="text/javascript" for="pzFormProc" event="FPError">
		    pzFormProc_FPError()
		
		</script>
		<script type="text/javascript" for="pzFormProc" event="InvalidDocument">
		    pzFormProc_InvalidDocument()
		
		</script>
		<script type="text/javascript" for="pzFormProc" event="ElementKeyEvent(nKey)">
		    pzFormProc_ElementKeyEvent(nKey)
		
		</script>
		<script type="text/javascript" for="pzFormProc" event="ElementChange">
		    pzFormProc_ElementChange()
		
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
                <p id = "ApvForm_sub4"><span divname="ApvForm_div4" id="1tab4">WORKFLOW</span></p>
                <p id = "ApvForm_sub5"><span divname="ApvForm_div5" id="1tab5"><spring:message code='ezApproval.t730'/></span></p>
                <p id = "ApvForm_sub6"><span divname="ApvForm_div6" id="1tab6"><spring:message code='ezApproval.t990012'/></span></p>
	        </div>
        </div>
        <div id="ApvForm_content1" style="width:100%;height:90%; padding-top:10px; display:none">
             <h2 id="form" class="receiver_tltype01" style="margin-bottom:5px;">
                <span style="min-width: 45px;" id="formstr"><spring:message code='ezApproval.t00006'/></span>
             </h2>
             <table class="content" style="width:100%;">                
                <tr>                
                    <th style="width:10%; text-align:center">${langPrimary}</th>
                    <td style="width:40%;">
                        <input type="text" name="tbFormName" maxlength="50" style="width:100%">
                        <input type="text" name="tbFormID" style="display: none" readonly>
                    </td>
                    <th style="width:10%; text-align:center">${langSecondary}</th>
                    <td style="width:40%;" colspan="5">
                        <input type="text" name="tbFormName2" maxlength="50" style="width:100%" >
                    </td>        
                </tr>
                <tr>
                    <th style="width:10%; text-align:center"><spring:message code='ezApproval.t507'/></th>
                    <td style="width:40%;">
                        <input type="text" name="tbDescript" style="WIDTH: 100%" maxlength="50">
                    </td>
                    <th style="width:10%; text-align:center"><spring:message code='ezApproval.t758'/></th>
                    <td style="width:40%;" colspan="5">
                        <select name="selFormKind" style="WIDTH: 170px;">
                            ${docType}
                        </select>
                    </td>
                </tr>    
                <tr>
                    <td colspan="8">
                        <span><input type="checkbox" id="setAutoItemCode" name="setAutoItemCode" onclick="viewAutoItemCode()" /><spring:message code='ezApproval.t00004'/></span>
                    </td>
                </tr>   
                <tr id="tr_setAutoItemCode" style="display:none">
                    <th style="width:10%; text-align:center"><spring:message code='ezApproval.t335'/></th>
                    <td style="width:400px;">
                        <input type="text" name="tbItemCode" id="tbItemCode" style="WIDTH: 50px" readonly>
                        <input type="text" name="tbItemName" id="tbItemName" style="WIDTH: 80px" readonly>
                        <input type="hidden" name="tbItemName2" id="tbItemName2">
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
            </div>
        </div>      
        <div id="ApvForm_content3" style="width:100%;height:90%;display:none; padding-top:10px;">   
            <h2 id="H2" class="receiver_tltype01" style="margin-bottom:5px;">
            <span style="min-width: 45px;" id="Span2"><spring:message code='ezApproval.t504'/></span>
            </h2>         
            <table class="content">
                <tr>
                    <td>&lt;xml id=conn&gt;<br>
                        &lt;connroot&gt;<br>
                        <textarea class="textarea" ID="txt_OpinionContent" style="FONT-SIZE:9pt; WIDTH:100%; HEIGHT:790px"></textarea>
                        <br>
                        &lt;/connroot&gt;<br>
                        &lt;/xml&gt; </td>
                    <th>
                        <a class="imgbtn" id="btn_OpinionAdd"><span onclick="btn_FormConnInfo_onclick()"><spring:message code='ezApproval.t193'/></span></a><br>      
                        <a class="imgbtn" id="btn_OpinionSave"><span onclick="btn_FormConnSave_onclick()"><spring:message code='ezApproval.t66'/></span></a><br>              
                    </th>
                </tr>
            </table>              
        </div>        

        <div id="ApvForm_content4" style="width:100%;height:60%;display:none; padding-top:10px;">   
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
                        <a class="imgbtn" id="Submit1"><span onclick="btn_OpinionAdd1_onclick()"><spring:message code='ezApproval.t529'/></span></a><br>      
                        <a class="imgbtn" id="Submit2"><span onclick="btn_OpinionAdd2_onclick()"><spring:message code='ezApproval.t530'/></span></a><br>   
                        <a class="imgbtn" id="Submit3"><span onclick="btn_WorkFlowSave_onclick()"><spring:message code='ezApproval.t66'/></span></a><br>
	                </th> 
                  </tr> 
                </table>          
        </div>
        
        <div id="ApvForm_content5" style="width:100%;height:100%;display:none; padding-top:10px;">         
            <h2 id="group" class="receiver_tltype01" style="margin-bottom:5px;">
         	  <span style="min-width: 45px;" id="groupstr"><spring:message code='ezApproval.t646'/></span>
            </h2>

            <table style="width:100%; height:665px;">         
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
        <div id="ApvForm_content6" style="width:100%;height:100%;display:none; padding-top:10px;">         
            
            <h2 id="H3" class="receiver_tltype01" style="margin-bottom:5px;">
            <span style="min-width: 45px;" id="Span3"><spring:message code='ezApproval.t990012'/></span>
            </h2>
            <table class="content">
				<tr>
					<th><spring:message code='ezApproval.t603'/></th>
					<td>
						<select name="selDocType" onChange="return OnChange_DocType()">
							${docTypeOption}
                        </select>
					</td>
				</tr>
			</table>
            <table style="width:100%;">              
            <tr> 
                <td style="vertical-align:top;height: 10px;">                    
                </td>
                <td style="text-align:right;vertical-align:bottom;height: 10px;"> 
                    <img src="/images/arr_up.gif" width="16" height="16" vspace="2" style="cursor: pointer;"
                        onclick="MoveUp_List_AutoRule_onclick()">
                    <img src="/images/arr_down.gif" width="16" height="16" vspace="2" style="cursor: pointer"
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
                            <th style="text-align:center;width:130px"><spring:message code='ezApproval.t990016'/></th>
                            <td>
                                <select id="DDL_CHECKTYPE" style="width:130px" onchange="DDL_CHECKTYPE_onChange()">
                                    <option value="FIELD"><spring:message code='ezApproval.t990020'/></option>
                                    <option value="DRAFTER_DEPT"><spring:message code='ezApproval.t990021'/></option>
                                </select>
                                <select id="DDL_FIELDIDLIST" onchange="FieldIdList_onChange()">
                                    <option value=""><spring:message code='ezApproval.t990022'/></option>
                                </select>
                                <input type="text" id="txtCondVal" style="width:150px;ime-mode:disabled;margin-top:-5px" disabled="disabled" />
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
                                    <option value="NUM_LE"><![CDATA[<=]]> <spring:message code='ezApproval.t990030'/></option>                        
                                    <option value="NUM_GT">> <spring:message code='ezApproval.t990031'/></option>
                                    <option value="NUM_LT"><![CDATA[<]]> <spring:message code='ezApproval.t990032'/></option>
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
        <table id="TForm" style="height:0px;">
            <tr>
                <td style="vertical-align:top">
                    <script type="text/javascript">FormProc_ActiveX2("pzFormProc", "2", "790px", "757px");</script>
                </td>
                <td id="rootTD"></td>
            </tr>
        </table> 
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
        <script type="text/javascript">EzHTTPTrans_ActiveX("EzHTTPTrans");</script>
    </body>
</html>