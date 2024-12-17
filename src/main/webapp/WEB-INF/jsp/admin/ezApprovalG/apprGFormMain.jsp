<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
	<head>
		<title><c:out value = '${title}' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezForm.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/FormMain.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/admin/AutoLineRuleMaker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/admin/AutoLineRuleMaker_AprLine.js')}"></script>
		
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
		    var approvalFlag = "<c:out value = '${approvalFlag}' />";
		    var useEditor = "<c:out value='${useEditor}'/>";
		    
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        };
		    }
	
		    document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
	
		    $(document).ready(function() {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        
		        document.getElementById("1tab1").setAttribute("class", "tabon");
		        Tab1_SelectID = "1tab1";
		        $("#tr_setAutoItemCode").hide();

		        if (formID != "") {
		            get_FormInfo();
		        }

		        getDeptFullTree("<c:out value = '${companyID}' />");

		        getFormRecv();
		        AprTypeXML = loadXMLString(bodyForm.hidAprTypeXml.value);
		        
		        add_doc_maker(companyID);
		    });
		    
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
// 		            txt_OpinionContent.innerText = pzFormProc.editor.DOM.all.conn.innerHTML.replace('<CONNINFO>', '').replace('</CONNINFO>', '').replace('<conninfo>', '').replace('</conninfo>', '');
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
		        	dataType : "json",
		        	url : "/admin/ezApprovalG/getFormInfo.do",
		        	async : false,
		        	data : {formID : formID, companyID : companyID},
		        	success : function(result) {
		        		if (result != "") {
		        			tbFormName.value = result.vo.formName;
		        			tbFormName2.value = result.vo.formName2;
		        			tbDescript.value = result.vo.formDescription;
		        			selFormKind.value = result.vo.formDocType;
			                formURL = document.location.protocol+"//" + document.location.hostname + ":" + location.port + "/ezCommon/downloadAttach.do?filePath=" + encodeURI(result.vo.formFileLocation);
			                
			                if (result.vo.formConnFlag == "Y") {
			                    document.getElementById("setConnFlag").checked = true;
			                }
			                
			                if (approvalFlag == 'S') {
				                if (result.vo.useFlag == "Y") {
				                    setAutoItemCode.checked = true;
				                    $('#tr_setAutoItemCode').show();
				                    document.getElementById("isPublic").value = result.vo.isPublic;
				                    document.getElementById("tbItemCode").value = result.vo.itemCode;
				                    document.getElementById("tbItemName").value = result.vo.itemName;
				                    document.getElementById("tbItemName2").value = result.vo.itemName2;
				                    document.getElementById("keepperiod").value = result.vo.keepPeriodCode;
				                    document.getElementById("securitylevel").value = result.vo.securityLevel;
			                	}
			                }
			            }
		        	}
		        });
		    }
	
		    function SaveFormInfo_after(result) {
		        try {
		            if (result == "<DATA>OK</DATA>") {
		                alert("<spring:message code = 'ezApprovalG.t1663' />");
		            } else {
		                alert("<spring:message code = 'ezApprovalG.t1669' />");
		            }
	
		            try{
		            	window.close();
		            	window.opener.GetFormInfo(contID, "000", "", "");
		            } catch (ee) {
		            }
		        } catch (e) {
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

		            createNodeAndInsertText(xmlpara, objNode, "TOPID", "<c:out value = '${companyID}' />");
// 		            createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2");
					createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2;displayName1;displayName2");
					createNodeAndInsertText(xmlpara, objNode, "DISPLAYTRASHDEPT", "true");
	
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
		            treeView.DataBind("TreeView");
		
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
		    	var xmlDom = loadXMLFile("/xml/organtree_config.xml");
		        
	            var treeView = new TreeView();
	            treeView.SetConfig(xmlDom);
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
// 		        createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2");
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
		        var xmlpara = createXmlDom();
		        
		        $.ajax({
		        	type : "POST",
		        	url : "/admin/ezApprovalG/getFormRecvAdmin.do",
		        	async : false,
		        	data : {

		    			formID 	  : formID,
		    			companyID : companyID
		    		},

		        	success : function(result) {
						xmlpara = loadXMLString(result);
	        		}
		        });
	
		        listview = new ListView();
		        listview.SetID("lvtForm");
		        listview.SetMulSelectable(true);
		        listview.SetRowOnClick("lvtDeptSelect_SelChange");
		        listview.SetRowOnDblClick("lvtDeptSelect_rowdblclick");
		        listview.DataSource(xmlpara);
		        listview.DataBind("divlvtForm");
		    }
		    
		    var ezapralert_cross_dialogArguments = new Array();
		    function insertCont_onclick() {
		        var DuplicateFlag = DuplicateAprDeptCheck(treeNode.GetNodeData("CN"));

		        if (DuplicateFlag) {
		            AprLineAddDept(treeNode.GetNodeData("VALUE"), treeNode.GetNodeData("CN"), "D");
		        } else {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t2001' />";
		            OpenAlertUI(pAlertContent);
		        }
		    }
		    
		    function insertAllCont_onclick() {
		        var pAlertContent = "<spring:message code = 'ezApprovalG.t1361'/><spring:message code = 'ezApprovalG.t1362'/>";
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
		                AprLineAddDept(aDeptName, aDeptID, "D");
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
		        } catch (e) { alert(e.description); }
		    }
	
		    function DuplicateAprDeptCheck(DeptID) {
		    	var AprDeptList = listview.GetDataRows();
		    	
		        var deptID;
	
		        for (var i = 0 ; i < listview.GetRowCount() ; i++) {
		            deptID = listview.GetDataRows()[i].getAttribute("DATA1");
	
		            if (deptID == DeptID) {
		                return false;
		                break;
		            }
		        }
		        return true;
		    }
	
		    function AprLineAddDept(TNAME, TID, TYPE) {
				var Resultxml = createXmlDom();
		        
		        if (approvalFlag == 'S') {
		        	Resultxml = loadXMLString("<LISTVIEWDATA><ROWS><ROW><CELL><VALUE></VALUE><DATA1></DATA1><DATA2></DATA2></CELL><CELL><VALUE></VALUE></CELL></ROW></ROWS></LISTVIEWDATA>");
		        } else {
		        	Resultxml = loadXMLString("<LISTVIEWDATA><ROWS><ROW><CELL><VALUE></VALUE><DATA1></DATA1></CELL></ROW></ROWS></LISTVIEWDATA>");
		        }
		        
		        var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");
		        setNodeText(GetChildNodes(objNodes[0])[0], TNAME);
		        setNodeText(GetChildNodes(objNodes[0])[1], TID);
		        
		        if (approvalFlag == 'S') {
		        	if (TYPE == "D") {
			            setNodeText(GetChildNodes(objNodes[0])[2], "");
			            setNodeText(GetChildNodes(objNodes[1])[0], "");
			        } else {
			            var pUserList = new ListView();
			            pUserList.LoadFromID("lvUserList");
			
			            var selnode = pUserList.GetSelectedRows();
			            setNodeText(GetChildNodes(objNodes[0])[2], GetAttribute(selnode[0], "DATA2"));
			            setNodeText(GetChildNodes(objNodes[1])[0], GetAttribute(selnode[0], "DATA4"));
			        }
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
		            for (var i = 0; i < selRow.length; i++) {
		                lvtFormView.DeleteRow(selRow[i].getAttribute("id"));
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
		            $('property span').html("<spring:message code = 'ezApprovalG.t999934' />");
		        } else {
		        	$('property span').html("<spring:message code = 'ezApprovalG.t999935' />");
		        }
		    }
		    
		    var FormConnInfo_dialogarguments = new Array();
		    function btn_OpinionAdd_onclick() {
		    	FormConnInfo_dialogarguments[0] = "";
		        FormConnInfo_dialogarguments[1] = FormConnInfo_onclick_Complete;
		        var url = "/admin/ezApprovalG/formConnInfo.do?companyID=" + encodeURIComponent(companyID);
		        GetOpenWindow(url, "FormConnInfo", 440, 480, "NO");
		    }
		    
		    function FormConnInfo_onclick_Complete(retVal) {
		        if (retVal != "cancel") {
		            if (txt_OpinionContent.value == "") {
		                txt_OpinionContent.value = retVal;
		            } else {
		                txt_OpinionContent.value = txt_OpinionContent.value + "\n" + retVal;
		            }
		        }
		    }
	
		    function btn_OpinionSave_onclick() {
		        var rtnVal = new Array();
		        var pInformationContent = "<spring:message code = 'ezApprovalG.t1455' />";
		        var Ans = OpenInformationUI(pInformationContent);
		        if (Ans) {
		            rtnVal[0] = "TRUE";
		            rtnVal[1] = "<CONNINFO>\n" + txt_OpinionContent.innerText + "\n</CONNINFO>";
	
		            if (!pzFormProc.editor.DOM.all.conn) {
		                var XMLInfo = "<xml id=conn></xml>";
		                pzFormProc.editor.DOM.body.innerHTML = XMLInfo + pzFormProc.editor.DOM.body.innerHTML;
		                pzFormProc.refresh();
		            }
		            
		            pzFormProc.editor.DOM.all.conn.innerHTML = rtnVal[1];
		            pzFormProc.refresh();
		            alert("XML <spring:message code = 'ezApprovalG.t1459' />");
		        }
		    }
		    
		    function OpenInformationUI(pInformationContent) {
		    	var parameter = pInformationContent;
		        var url = "/ezApprovalG/ezAprOpinion.do";
		        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		        var RtnVal = window.showModalDialog(url, parameter, feature);
		        return RtnVal;
		    }
	
		    function btn_ViewProcUI_onclick() {
		        if (!pzFormProc.editor.DOM.all.PROCESSOR) {
		            var XMLInfo = "<xml id=PROCESSOR></xml>";
		            pzFormProc.editor.DOM.body.innerHTML = XMLInfo + pzFormProc.editor.DOM.body.innerHTML;
		            pzFormProc.refresh();
		        }
	
		        if (!pzFormProc.editor.DOM.all.conn) {
		            var XMLInfo = "<xml id=conn></xml>";
		            pzFormProc.editor.DOM.body.innerHTML = XMLInfo + pzFormProc.editor.DOM.body.innerHTML;
		            pzFormProc.refresh();
		        }
	
		        var susinCnt = "0";
		        var fields = pzFormProc.object.Fields;
		        var field = fields.Item("AprLine");
	
		        if (!field) {
		            alert("<spring:message code  = 'ezApprovalG.lhj04' />");
		            return false;
		        }
	
		        field = fields.Item("1RecvAprLine");
		        if (field) {
		            susinCnt = "1";
		        }
	
		        field = fields.Item("2RecvAprLine");
		        if (field) {
		            susinCnt = "2";
		        }
	
		        var parameter = new Array();
		        parameter[0] = pzFormProc.editor.DOM.all.PROCESSOR.innerHTML;
		        parameter[1] = SCompID.value;
		        parameter[2] = pzFormProc.object.Fields;
		        parameter[3] = pzFormProc.editor.DOM.all.conn.innerHTML;
		        parameter[4] = susinCnt;
	
		        var url = "/myoffice/ezprocdesigner/ProcUI_View.aspx";
		        var feature = "status:no;dialogWidth:1030px;dialogHeight:800px;help:no;scroll:no;edge:sunken";
		        var ret = window.showModalDialog(url, parameter, feature);
	
		        if (ret[0] == "TRUE") {
		            pzFormProc.editor.DOM.all.PROCESSOR.innerHTML = ret[1];
		            pzFormProc.editor.DOM.all.conn.innerHTML = ret[2];
	
		            pzFormProc.editor.DOM.all.PROCESSOR.style.display = "none";
		            pzFormProc.editor.DOM.all.conn.style.display = "none";
	
		            DrawAutoAprLine(ret[1], "", "");
	
		            if (parseInt(susinCnt) > 0) {
		                for (var i = 1; i <= parseInt(susinCnt) ; i++) {
		                    DrawAutoAprLine(ret[1], "SUSIN", i);
		                }
		            }
		            
		            pzFormProc.refresh();
		            alert("XML <spring:message code = 'ezApprovalG.t1459' />");
		        }
		    }
	
		    function viewAutoItemCode() {
		        if (setAutoItemCode.checked) {
		            $("#tr_setAutoItemCode").show();
		            btnItemCode_onclick();
		        } else {
		            $("#tr_setAutoItemCode").hide();
		            DeleteItemCode();
		        }
		    }
	
		    var itemcode_dialogArgument = new Array();
		    function btnItemCode_onclick() {
		
		        itemcode_dialogArgument[0] = "";
		        itemcode_dialogArgument[1] = btnItemCode_Complete;
		        var url = "/admin/ezApprovalG/apprGDocNumUI.do";
		        GetOpenWindow(url, "docnumui_Cross", 795, 370, "NO");
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
		        alert("XML <spring:message code ='ezApprovalG.t1459' />");
		    }
		    
		</script>
		<script type="text/javascript" for="pzFormProc" event="FieldsAvailable">
	        pzFormProc_FieldsAvailable();
	    </script>
	    <script type="text/javascript" for="pzFormProc" event="DocumentComplete">
	        pzFormProc_DocumentComplete()
	    </script>
	    <script type="text/javascript" for="pzFormProc" event="BlurTDElement">
	        pzFormProc_BlurTDElement();
	    </script>
	    <script type="text/javascript" for="pzFormProc" event="FPError">
	        pzFormProc_FPError();
	    </script>
	    <script type="text/javascript" for="pzFormProc" event="InvalidDocument">
	        pzFormProc_InvalidDocument();
	    </script>
	    <script type="text/javascript" for="pzFormProc" event="ElementKeyEvent(nKey)">
	        pzFormProc_ElementKeyEvent(nKey);
	    </script>
	    <script type="text/javascript" for="pzFormProc" event="ElementChange">
	        pzFormProc_ElementChange();
	    </script>
	</head>
	<body class="popup">
        <div id="menu">
            <ul>
            	<li><span id="btnSave" onClick="return btnSave_onclick()"><spring:message code = 'ezApprovalG.t1767' /></span></li>
            </ul>
        </div>
        <div id="close">
            <ul>
                <li><span id="btnClose" onClick="return btnClose_onclick()"></span></li>
            </ul>
        </div>
        <div class="portlet_tabpart01">
	        <div class="portlet_tabpart01_top" id="tab1">
	        	<p id = "ApvForm_sub1"><span divname="ApvForm_div1" id="1tab1"><spring:message code = 'ezApprovalG.t00004' /></span></p><!-- 양식정보 -->
	        	<p id = "ApvForm_sub2"><span divname="ApvForm_div2" id="1tab2"><spring:message code = 'ezApprovalG.t1456' /></span></p><!-- 양식작성기 -->
                <p id = "ApvForm_sub3"><span divname="ApvForm_div3" id="1tab3"><spring:message code = 'ezApprovalG.t00005' /></span></p><!-- 연동정보 -->
                <p id = "ApvForm_sub4"><span divname="ApvForm_div4" id="1tab4">Workflow</span></p>
                <p id = "ApvForm_sub5"><span divname="ApvForm_div5" id="1tab5"><spring:message code = 'ezApprovalG.t1629' /></span></p><!-- 고정수신처 -->
	        </div>
        </div>
        <!-- 양식정보 -->
        <div id="ApvForm_content1" style="width:100%;height:90%; padding-top:10px; display:none">
             <h2 id="form" class="receiver_tltype01" style="margin-bottom:5px;">
                <span style="min-width: 45px;" id="formstr"><spring:message code = 'ezApprovalG.t825' /></span>
             </h2>
             <table class="content" style="width:100%;">                
                <tr>                
					<th style="width:100px; text-align:center">${primary}</th>
                    <td style="width:40%;">
                        <input type="text" id="tbFormName" name="tbFormName" maxlength="50" style="width:100%">
                        <input type="text" id="tbFormID" name="tbFormID" style="display: none" readonly>
                    </td>
                    <th style="width:100px; text-align:center">${secondary}</th>
                    <td style="width:40%;" colspan="5">
                        <input type="text" id="tbFormName2" name="tbFormName2" maxlength="50" style="width:100%" >
                    </td>        
                </tr>
                <tr>
                    <th style="width:100px; text-align:center"><spring:message code='ezApprovalG.t598'/></th>
                    <td style="width:40%;">
                        <input type="text" id="tbDescript" name="tbDescript" style="WIDTH: 100%" maxlength="50">
                    </td>
                    <th style="width:100px; text-align:center"><spring:message code='ezApproval.t758'/></th>
                    <td style="width:40%;" colspan="5">
                        <select id="selFormKind" name="selFormKind" style="WIDTH: 170px;">${docType}</select>
                    </td>
                </tr>
				<tr>
                    <td colspan="8" style="width:10%; text-align:center;">
                        <input type="checkbox" id="setConnFlag" /><spring:message code = 'ezApprovalG.t1665' />
                    </td>                    
                </tr>                        
            </table>
            <br />
            <div style="padding-bottom:5px; vertical-align:middle; <c:if test="${approvalFlag != 'S' }">display:none;</c:if>">
            	<input type="checkbox" id="setAutoItemCode" name="setAutoItemCode" onclick="viewAutoItemCode()" />
            	<span><spring:message code='ezApproval.t00004'/></span>
            </div>
            <table class="content" style="width:100%;">
				<tr id="tr_setAutoItemCode">
					<th style="width:10%; text-align:center"><spring:message code='ezApprovalG.t1197'/></th>
                    <td style="width:400px;">
                        <input type="text" id="tbItemCode" name="tbItemCode" style="WIDTH: 80px" readonly>
                        <input type="text" id="tbItemName" name="tbItemName" style="WIDTH: 100px" readonly>
                        <input type="hidden" id="tbItemName2" name="tbItemName2">
                        <a class="imgbtn"><span onclick="return btnItemCode_onclick()"><spring:message code='ezApproval.t321'/></span></a>
                        <a class="imgbtn"><span onclick="DeleteItemCode()"><spring:message code='ezApprovalG.t266'/></span></a>
                    </td>
                    <th style="width:10%; text-align:center"><spring:message code='ezApprovalG.t118'/></th>
                    <td style="width:100px; text-align:center">
                        <select id="securitylevel" name="select">${securityNode}</select>
                    </td>
                    <th style="width:10%; text-align:center"><spring:message code='ezApproval.t336'/></th>
                    <td style="width:100px; text-align:center">
                        <select id="keepperiod" name="select">${periodNode}</select>
                    </td>
                    <th style="width:10%; text-align:center"><spring:message code='ezApproval.t82'/></th>
                    <td style="width:100px; text-align:center">
                        <select id="isPublic" name="select">
                            <option value="Y" selected><spring:message code='ezApprovalG.t47'/></option>
                            <option value="N"><spring:message code='ezApprovalG.t46'/></option>
                        </select>
                    </td>
                </tr>
            </table>   
        </div>
           
        <!-- 양식작성 -->
        <div id="ApvForm_content2" style="width:100%;display:none; padding-top:10px;">
            <h2 id="H1" class="receiver_tltype01" style="margin-bottom:5px;">
            <span style="min-width: 45px;" id="Span1"><spring:message code = 'ezApprovalG.t00007' /></span>
            </h2>
             <div id="editor_content" style="padding-top:5px;">
                <div id="mainmenu">
                <ul>
<%--                     <li id="idPropertyBtn"><span onclick="return idPropertyBtn_onclick()"><spring:message code = 'ezApprovalG.t1466' /></span></li> --%>
                    <li id="property"><span onclick="return idSetField_onclick()"><spring:message code = 'ezApprovalG.t999934' /></span></li>                         
                </ul>
                </div>
                <script type="text/javascript">
                    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
                </script>              
            </div>
        </div>
        
        <!-- 연동설정 -->
        <div id="ApvForm_content3" style="width:100%;height:90%;display:none; padding-top:10px;">   
            <h2 id="H2" class="receiver_tltype01" style="margin-bottom:5px;">
            <span style="min-width: 45px;" id="Span2"><spring:message code = 'ezApprovalG.t1446' /></span>
            </h2>         
            <table class="content">
                <tr>
                    <td>&lt;xml id=conn&gt;<br>
                        &lt;connroot&gt;<br>
                        <textarea class="textarea" ID="txt_OpinionContent" style="FONT-SIZE:9pt; WIDTH:98%; HEIGHT:734px"></textarea>
                        <br>
                        &lt;/connroot&gt;<br>
                        &lt;/xml&gt; </td>
                    <th>
                        <a class="imgbtn" id="btn_OpinionAdd"><span onclick="btn_OpinionAdd_onclick()"><spring:message code = 'ezApprovalG.t268' /></span></a><br>      
                        <a class="imgbtn" id="btn_OpinionSave" style="<c:if test="{approvalFlag == 'S'}">display: none;</c:if>"><span onclick="btn_OpinionSave_onclick()"><spring:message code = 'ezApprovalG.t59' /></span></a><br>              
                    </th>
                </tr>
            </table>              
        </div>
        
        <!-- WorkFlow -->
        <div id="ApvForm_content4" style="width:100%;height:60%;display:none; padding-top:10px;">
        	<table class="content"> 
				<tr> 
					<td>&lt;xml id=WORKFLOW&gt;<br> 
						&lt;WORKFLOW&gt;<br> 
						&lt;VALIDATIONS&gt;<br> 
						<textarea name="txt_OpinionContent1" style="FONT-SIZE:9pt; WIDTH:98%; HEIGHT:350px" id="txt_OpinionContent1"></textarea> 
						<br> &lt;/VALIDATIONS&gt;<br> 
						&lt;STATUS&gt;<br> 
						<textarea name="txt_OpinionContent2" style="FONT-SIZE:9pt; WIDTH:98%; HEIGHT:350px" id="txt_OpinionContent2"></textarea> 
						<br> &lt;/STATUS&gt;<br> 
						&lt;/WORKFLOW&gt;<br> 
						&lt;/xml&gt; </td> 
					<th> 
						<a class="imgbtn" id="Submit1"><span onclick="btn_OpinionAdd1_onclick()"><spring:message code = 'ezApprovalG.t268' /> 1</span></a><br>      
						<a class="imgbtn" id="Submit2"><span onclick="btn_OpinionAdd2_onclick()"><spring:message code = 'ezApprovalG.t268' /> 2</span></a><br>   
						<a class="imgbtn" id="Submit3" style="<c:if test="${approvalFlag == 'S'}">display: none;</c:if>"><span onclick="btn_WorkFlowSave_onclick()"><spring:message code = 'ezApprovalG.t59' /></span></a><br>
					</th>
				</tr>
			</table>
        </div>
        
        <!-- 고정수신처 -->
        <div id="ApvForm_content5" style="width:100%;height:100%;display:none; padding-top:10px;">
            <h2 id="group" class="receiver_tltype01" style="margin-bottom:5px;">
            	<span style="min-width: 45px;" id="groupstr"><spring:message code = 'ezApprovalG.t1577' /></span>
            </h2>


            <table style="width:100%; height:565px; border : none;">
                <tr>
                    <td style="width:400px; vertical-align:top; padding-top:5px; border:none">
                        <h2><spring:message code = 'ezApprovalG.t232' /></h2>
<!--                         <div id="divUserContTree" style="height: 775px; width: 100%; overflow-x: auto; overflow-y: auto; border: #ddd 1px solid; BACKGROUND-COLOR: #ffffff;"></div> -->
                        <div id="TreeView" style="<c:if test="${approvalFlag != 'S'}">height: 775px;</c:if><c:if test="${approvalFlag == 'S'}">height: 355px;</c:if> width: 100%; overflow-x: auto; overflow-y: auto; BORDER: #ddd 1px solid; BACKGROUND-COLOR: #ffffff;"></div>
                        <c:if test="${approvalFlag == 'S'}"><br /></c:if>
                        <div class="div_scroll" style="border:none; <c:if test="${approvalFlag != 'S'}">display:none;</c:if>">
                            <div id="UserList" style="height: 405px; width: 100%; overflow-x: auto; overflow-y: auto; BORDER: #ddd 1px solid; BACKGROUND-COLOR: #ffffff;border-top:none"></div>
                        </div>
                    </td>
                    <td style="text-align:center; width:50px; border-left:none; border:none">
                        <img style="cursor:pointer" src="/images/arr_r.gif" width="24" height="24" onclick="return insertCont_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_l.gif" width="24" height="24" onclick="return deleteCont_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_rr.gif" width="24" height="24" onclick="return insertAllCont_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_ll.gif" width="24" height="24" onclick="return deleteAllCont_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_u.gif" width="24" height="24" onclick="return moveUp_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_d.gif" width="24" height="24" onclick="return moveDown_onclick()">
                        <div style="height:250px;<c:if test="${approvalFlag != 'S'}">display:none;</c:if>">&nbsp;</div>
                        <img style="cursor:pointer;<c:if test="${approvalFlag != 'S' }">display:none;</c:if>" src="/images/arr_r.gif" width="24" height="24" onclick="return insertContUser_onclick()"><br>
                    </td>
                    <td style="width:600px; vertical-align:top; padding-top:5px; border:none;">
                        <h2><spring:message code = 'ezApprovalG.t999932' /></h2>
                        <div class="div_scroll" style="border:none; height:775px;">
                            <div id="divlvtForm" style="WIDTH: 100%; HEIGHT: 100%;overflow-x: auto; overflow-y: auto; BORDER: #ddd 1px solid; BACKGROUND-COLOR: #ffffff;border-top:none"></div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background:none rgba(0,0,0,0.5); display:none;" id="mailPanel">&nbsp;</div>	
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		    <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
        <table id="TForm" style="height:0px;">
            <tr>
                <td valign="top">
                    <script type="text/javascript">FormProc_ActiveX3("pzFormProc", "2", "790px");</script>
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
    </body>
</html>