<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
		    var FormProcSpelling = "<c:out value = '${formProcSpelling}' />";
	
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        };
		    }
		    
		    window.onresize = function () {
		        pzFormProc.style.height = null;
		        pzFormProc.height = document.documentElement.clientHeight - 200;
		    }
	
		    document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
	
		    $(document).ready(function() {
		    	window.onresize();
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        
		        document.getElementById("1tab2").setAttribute("class", "tabon");
		        document.getElementById("1tab2").setAttribute("class", "tabon");
		        Tab1_SelectID = "1tab2";
		        ChangeTab(document.getElementById("1tab2"));

		        if (formID != "") {
		            get_FormInfo();
		        }
	
		        getDeptFullTree("<c:out value = '${topID}' />");
		        getFormRecv();
		    });
		    
		    function pzFormProc_DocumentComplete() {
		        if (flag == false) {
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
		        }
		    }
	
		    function ReturnFormConnXML() {
		        if (pzFormProc.editor.DOM.all.conn) {            
		            txt_OpinionContent.innerText = pzFormProc.editor.DOM.all.conn.innerHTML.replace('<CONNINFO>', '').replace('</CONNINFO>', '').replace('<conninfo>', '').replace('</conninfo>', '');
		        }
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

			                document.getElementsByName("tbFormName")[0].value = getNodeText(SelectNodes(xmldom, "ROW/FORMNAME")[0]);
			                document.getElementsByName("tbFormName2")[0].value = getNodeText(SelectNodes(xmldom, "ROW/FORMNAME2")[0]);
			                document.getElementsByName("tbDescript")[0].value = getNodeText(SelectNodes(xmldom, "ROW/FORMDESCRIPTION")[0]);
			                document.getElementsByName("selFormKind")[0].value = getNodeText(SelectNodes(xmldom, "ROW/FORMDOCTYPE")[0]);
			                formURL = "/ezCommon/downloadAttach.do?filePath=" + encodeURI(getNodeText(SelectNodes(xmldom, "ROW/FORMFILELOCATION")[0]));

			                if (getNodeText(SelectNodes(xmldom, "ROW/FORMCONNFLAG")[0]) == "Y") {
			                    document.getElementById("setConnFlag").checked = true;
			                }                
			            }
		        	}
		        });
		    }
	
		    function SaveFormInfo_after() {
		        if (xmlhttp == null || xmlhttp.readyState != 4) return;
	
		        try {
		            if (xmlhttp.responseText == "<DATA>OK</DATA>") {
		                alert("<spring:message code = 'ezApprovalG.t1663' />");
		            } else {
		                alert("<spring:message code = 'ezApprovalG.t1669' />");
		            }
	
		            try{
		            	window.close();
		                window.opener.refreshFormList();
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
		        }
		        catch (e) { alert(e.description); }
		    }
	
		    function Tree_setconfig() {
		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
		        xmlHTTP.send();
	
		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(xmlHTTP.responseXML);
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
		        createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2");
	
		        xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
		        xmlHTTP.send(xmlpara);
	
		        var treeView = new TreeView();
		        treeView.LoadFromID(pTreeID);
		        treeView.AppendChildNodes(xmlHTTP.responseXML.documentElement, pNodeID);
		    }
	
		    function TreeViewNodeClick(pNodeID, pNodeNM) {
		        TreeIdx = pNodeID;
	
		        treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		    }
	
		    function getFormRecv() {		         
		        var xmlpara = createXmlDom();
		        
		        $.ajax({
		        	type : "POST",
		        	url : "/admin/ezApprovalG/getFormRecvAdmin.do",
		        	async : false,
		        	data : {node1 : formID},
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
		        } catch (e) { alert(e.description); }
		    }
	
		    function DuplicateAprDeptCheck(DeptID) {
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
		        add_doc_maker();
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
	
		    function btn_OpinionAdd_onclick() {
		        var url = "/admin/ezApprovalG/formConnInfo.do?companyID=" + encodeURI(companyID);
		        var feature = "status:no;dialogWidth:430px;dialogHeight:450px;help:no;scroll:no;edge:sunken";
		        var ret = window.showModalDialog(url, companyID, feature);
	
		        if (ret != "cancel") {
		            if (txt_OpinionContent.innerText == "") {
		                txt_OpinionContent.innerText = ret;
		            } else {
		                txt_OpinionContent.innerText = txt_OpinionContent.innerText + "\n" + ret;
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
		            document.getElementById("tr_setAutoItemCode").style.display = "";
		            btnItemCode_onclick();
		        } else {
		            document.getElementById("tr_setAutoItemCode").style.display = "none";
		            DeleteItemCode();
		        }
		    }
	
		    function btnItemCode_onclick() {
		        var url = "/myoffice/ezApprovalG/DocNum/docnumui.aspx";
		        var retVal = window.showModalDialog(url, "", "dialogWidth:745px;dialogHeight:370px;status:no;help:no;scroll:no;edge:sunken");
	
		        if (retVal[0] != "cancel") {
		            tbItemCode.value = retVal[0];
		            tbItemName.value = retVal[1];
		            keepperiod.value = retVal[2];
		            securitylevel.value = retVal[3];
		            isPublic.value = retVal[4];
		            tbItemName2.value = retVal[6];
		            setAutoItemCode.checked = true;
		        } else {
		            if (tbItemCode.value == "") {
		                setAutoItemCode.checked = false;
		            }
		        }
		    }
	
		    function DeleteItemCode() {
		        tbItemCode.value = "";
		        tbItemName.value = "";
		        tbItemName2.value = "";
		        securitylevel.selectedIndex = 0;
		        keepperiod.selectedIndex = 0;
		        isPublic.selectedIndex = 0;
		        setAutoItemCode.checked = false;
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
            	<li><span id="btnSave" onClick="return btnSave_onclick()"><spring:message code = 'ezApprovalG.t1767' /></span></li>
            </ul>
        </div>
        <div id="close">
            <ul>
                <li><span id="btnClose" onClick="return btnClose_onclick()"><spring:message code = 'ezApprovalG.t64' /></span></li>
            </ul>
        </div>
        <div class="portlet_tabpart01">
	        <div class="portlet_tabpart01_top" id="tab1">
	        	<p id = "ApvForm_sub2"><span divname="ApvForm_div2" id="1tab2"><spring:message code = 'ezApprovalG.t1456' /></span></p><!-- 양식작성기 -->
                <p id = "ApvForm_sub1"><span divname="ApvForm_div1" id="1tab1"><spring:message code = 'ezApprovalG.t00004' /></span></p><!-- 양식정보 -->
                <p id = "ApvForm_sub3"><span divname="ApvForm_div3" id="1tab3"><spring:message code = 'ezApprovalG.t00005' /></span></p><!-- 연동정보 -->
                <%--<p id = "ApvForm_sub4"><span divname="ApvForm_div4" id="1tab4">Workflow</span></p>--%>
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
                    <th style="width:10%; text-align:center"><c:out value = '${primary}' /></th>
                    <td style="width:40%;">
                        <input type="text" name="tbFormName" maxlength="50" style="width:100%" >
                        <input type="text" name="tbFormID" style="display: none" readonly>
                    </td>
                    <th style="width:10%; text-align:center"><c:out value = '${secondary}' /></th>
                    <td style="width:40%;" colspan="5">
                        <input type="text" name="tbFormName2" maxlength="50" style="width:100%" >
                    </td>        
                </tr>
                <tr>
                    <th style="width:10%; text-align:center"><spring:message code = 'ezApprovalG.t598' /></th>
                    <td style="width:40%;">
                        <input type="text" name="tbDescript" style="WIDTH: 100%" maxlength="50">
                    </td>
                    <th style="width:10%; text-align:center"><spring:message code = 'ezApprovalG.t1664' /></th>
                    <td style="width:40%;" colspan="5">
                        <select name="selFormKind" style="WIDTH: 170px;">
                            ${docType}
                        </select>
                    </td>
                </tr>        
                  <tr>
                    <td colspan="8" style="width:10%; text-align:center">
                        <input type="checkbox" id="setConnFlag" /><spring:message code = 'ezApprovalG.t1665' />
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
                    <li id="idPropertyBtn"><span onclick="return idPropertyBtn_onclick()"><spring:message code = 'ezApprovalG.t1466' /></span></li>
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
                        <textarea class="textarea" ID="txt_OpinionContent" style="FONT-SIZE:9pt; WIDTH:100%; HEIGHT:790px"></textarea>
                        <br>
                        &lt;/connroot&gt;<br>
                        &lt;/xml&gt; </td>
                    <th>
                        <a class="imgbtn" id="btn_OpinionAdd"><span onclick="btn_OpinionAdd_onclick()"><spring:message code = 'ezApprovalG.t268' /></span></a><br>      
                        <a class="imgbtn" id="btn_OpinionSave"><span onclick="btn_OpinionSave_onclick()"><spring:message code = 'ezApprovalG.t59' /></span></a><br>              
                    </th>
                </tr>
            </table>              
        </div>
        
        <!-- WorkFlow -->
        <div id="ApvForm_content4" style="width:100%;height:60%;display:none; padding-top:10px;">            
        </div>
        
        <!-- 고정수신처 -->
        <div id="ApvForm_content5" style="width:100%;height:100%;display:none; padding-top:10px;">         
            
            <h2 id="group" class="receiver_tltype01" style="margin-bottom:5px;">
            <span style="min-width: 45px;" id="groupstr"><spring:message code = 'ezApprovalG.t1577' /></span>
            </h2>

            <table class="content" style="width:100%; height:565px;">         
                <tr>
                    <td style="width:400px; vertical-align:top; padding-top:5px; border-right:none">
                        <h2>
                            <spring:message code = 'ezApprovalG.t232' />
                        </h2>
                        <div id="divUserContTree" style="height: 530px; width: 100%; overflow-x: auto; overflow-y: auto; BORDER: #b6b6b6 1px solid; BACKGROUND-COLOR: #ffffff;"></div>
                    </td>
                    <td style="text-align:center; width:50px; border-left:none; border-right:none">
                        <img style="cursor:pointer" src="/images/arr_r.gif" width="24" height="24" onclick="return insertCont_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_l.gif" width="24" height="24" onclick="return deleteCont_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_rr.gif" width="24" height="24" onclick="return insertAllCont_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_ll.gif" width="24" height="24" onclick="return deleteAllCont_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_u.gif" width="24" height="24" onclick="return moveUp_onclick()"><br>
                        <img style="cursor:pointer" src="/images/arr_d.gif" width="24" height="24" onclick="return moveDown_onclick()">
                    </td>
                    <td style="width:600px; vertical-align:top; padding-top:5px; border-left:none;">
                        <h2>
                            <spring:message code = 'ezApprovalG.t999932' />
                        </h2>
                        <div class="listview" style="border-top:none; height:530px;">
                            <div id="divlvtForm" style="WIDTH: 100%; HEIGHT: 100%; overflow-x:auto;overflow-y:auto; padding:0px;"></div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <table id="TForm" style="height:0px;">
            <tr>
                <td valign="top">
                    <script type="text/javascript">FormProc_ActiveX3("pzFormProc", "2", "790px");</script>
                </td>
                <td id="rootTD"></td>
            </tr>
        </table>
        
        <!-- <form runat="server" id="bodyForm">
            <asp:HiddenField ID="hidCompanyID" runat="server" />
            <asp:HiddenField ID="hidFormID" runat="server" />
            <asp:HiddenField ID="hidBeforeConnData" runat="server" />
        </form> -->
        <script type="text/javascript">
            Tab1_NewTabIni("tab1");
        </script>
    </body>
</html>