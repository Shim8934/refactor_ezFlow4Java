<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<HTML>
	<HEAD>
		<title><spring:message code='ezApproval.t607'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApproval.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApproval/control_Cross/TreeView.js" ></script>
		<script type="text/javascript" src="/js/ezApproval/control_Cross/ListView_list.js" ></script>
		<script type="text/javascript" src="/js/ezApproval/admin/FormCont.js"></script>
		<script type="text/javascript">
		    var xmlhttp = createXMLHttpRequest();
		    var xmldoc  = createXmlDom();		    
		    var pDeptID;
		    var Rtnval = new Array();
		    var companyID = "";
		    var TreeIdx;
		    var ListIdx;
		    var g_multiDataNum = "${multiDataNum}";
		    var pEDITOR = "${editor}";
		    document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
		
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        }
		    }
		    window.onload = function () {
		        companyID = document.getElementById("ListCompany").value;
		        Tree_setconfig();
		        InitFormCont();
		    }
		
		    function refreshFormList() {
		        InitFormCont();
		    } 
		
		    function selectCompanyID() {
		        if (companyID != document.getElementById("ListCompany").value) {
		            companyID = document.getElementById("ListCompany").value;
		            Tree_setconfig();
		            InitFormCont();
		        }
		    }
		
		    function Tree_setconfig() {
		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("GET", "/xml/organtree_config2.xml", false);
		        xmlHTTP.send();
		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(loadXMLString(xmlHTTP.responseText));
		        }
		    }
		
		    function select_onchange() {
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        ID = treeNode.GetNodeData("DATA1");
		        if (TreeIdx != "") {
		            var ID = treeNode.GetNodeData("DATA1");
		            var KIND = document.getElementById('FromList').value;
		            GetFormInfo(ID, KIND, "", "");
		        }
		    }
		
		    var nodeIdx;
		    function TreeViewRequestData(pNodeID, pTreeID) {
		        TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        ID = treeNode.GetNodeData("DATA1");
		        DeptID = treeNode.GetNodeData("DATA2");
		        KIND = document.getElementById('FromList').value;
		
		        if (TreeIdx != "") {
		            GetFormContInfo(ID, DeptID, "REQUEST")
		        }
		        GetFormInfo(ID, KIND, "", "");
		    }
		
		    function TreeViewNodeClick(pNodeID, pNodeNM) {
		        TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        ID = treeNode.GetNodeData("DATA1");
		        DeptID = treeNode.GetNodeData("DATA2");
		        KIND = document.getElementById('FromList').value;
		
		        GetFormInfo(ID, KIND, "", "");
		    }
		
		    var FormContMain_dialogarguments = new Array();
		    function btnInsFcont_onclick() {
		        var para = new Array();
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        var nodeIdx = treeView.GetSelectNode();
		        if (nodeIdx != null) {
		            para[0] = "I";
		            para[1] = nodeIdx.GetNodeData("DATA1");
		            para[2] = nodeIdx.GetNodeData("DATA2");
		            para[3] = companyID;
		            para[4] = nodeIdx.GetNodeData("DATA7");
		            para[5] = g_multiDataNum;
		        }
		        else {
		            return;
		        }
		
		        FormContMain_dialogarguments[0] = para;
		        FormContMain_dialogarguments[1] = btnInsFcont_onclick_Complete;
		        var url = "/admin/ezApproval/formContMain.do?tCheck=FContIns&companyID=" + escape(companyID);
		        GetOpenWindow(url, "FormContMain", 800, 700, "NO");        
		    }
		
		    function btnInsFcont_onclick_Complete(retVal) {
		        if (retVal[0] == "TRUE") {
		            var tmpDisplayFormName = "";
		            if (g_multiDataNum == "")
		                tmpDisplayFormName = retVal[2];
		            else
		                tmpDisplayFormName = retVal[7];
		
		            Tree_setconfig();
		            InitFormCont();
		        }
		    }
		
		    function btnUpFcont_onclick() {
		        UpdateFCont();
		    }
		
		    function UpdateFCont() {
		        var para = new Array();
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        var nodeIdx = treeView.GetSelectNode();
		        if (nodeIdx != null) {
		
		            para[0] = "U";
		            para[1] = nodeIdx.GetNodeData("DATA1");
		            para[2] = nodeIdx.GetNodeData("DATA2");
		            para[3] = nodeIdx.GetNodeData("DATA3");
		            para[4] = nodeIdx.GetNodeData("DATA4");
		            para[5] = nodeIdx.GetNodeData("DATA5");
		            para[6] = nodeIdx.GetNodeData("DATA6");
		            para[7] = companyID;
		            para[8] = nodeIdx.GetNodeData("DATA7");
		            para[9] = g_multiDataNum;
		
		            FormContMain_dialogarguments[0] = para;
		            FormContMain_dialogarguments[1] = btnUpFcont_onclick_Complete;
		
		            var url = "/admin/ezApproval/formContMain.do?tCheck=FContmod&companyID=" + escape(companyID);
		            GetOpenWindow(url, "FormContMain", 800, 700, "NO");           
		        }
		    }
		
		    function btnUpFcont_onclick_Complete(retVal) {
		        if (retVal[0] == "TRUE") {
		            var tmpDisplayFormName = "";
		            if (g_multiDataNum == "")
		                tmpDisplayFormName = retVal[1];
		            else
		                tmpDisplayFormName = retVal[5];
		
		            var treeView = new TreeView();
		            treeView.LoadFromID("FromTreeView");
		            var nodeIdx = treeView.GetSelectNode();
		            if (nodeIdx != null) {
		                nodeIdx.SetNodeName(tmpDisplayFormName);
		                nodeIdx.SetNodeData("VALUE", tmpDisplayFormName);
		                nodeIdx.SetNodeData("DATA2", retVal[1]);
		                nodeIdx.SetNodeData("DATA3", retVal[3]);
		                nodeIdx.SetNodeData("DATA5", retVal[2]);
		                nodeIdx.SetNodeData("DATA6", retVal[4]);
		                nodeIdx.SetNodeData("DATA7", retVal[5]);
		            }
		        }
		    }
		
		    function btnDelFcont_onclick() {
		        DelFCont();
		    }
		
		    function DelFCont() {
		        var xmlRtn = createXmlDom();
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		
		        var nodeIdx = treeView.GetSelectNode();
		        if (nodeIdx != null) {
		            var ID = nodeIdx.GetNodeData("DATA1");
		
		            if (!CheckSubFormCont(ID, nodeIdx)) {
		                var listview = new ListView();
		                listview.LoadFromID("lvtForm");
		
		                var Rows = listview.GetDataRows();
		                if (Rows[0].id.indexOf('TR_noItems') > 0) {
		                	var result = "";
		    		    	
		    		    	$.ajax({
		    		    		type : "POST",
		    		    		dataType : "text",
		    		    		async : false,
		    		    		url : "/admin/ezApproval/delFormCont.do",
		    		    		data : {
		    		    			id         : ID,
		    		    			companyID  : companyID
		    		    		},
		    		    		success: function(text){
		    		    			result = text;
		    		    		}
		    		    	});
		    		    	
		                    xmlRtn = loadXMLString(result);
		
		                    var objNode = xmlRtn.documentElement.childNodes;
		
		                    if (getNodeText(GetChildNodes(xmlRtn.documentElement)[0]) == "TRUE") {
		                        Tree_setconfig();
		                        InitFormCont();
		                    }
		                    else
		                        window.alert("<spring:message code='ezApproval.t715'/>");
		                }
		                else
		                    window.alert("<spring:message code='ezApproval.t716'/>");
		            }
		            else
		                window.alert("<spring:message code='ezApproval.t717'/>");
		        }
		    }
		
		    function CheckSubFormCont(ID, pNodeIdx) {
		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/getFormContInfo.do",
		    		data : {
		    			id         : ID,
		    			companyID  : companyID
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
		    	
		        var xmlRtn = createXmlDom();
		        xmlRtn = loadXMLString(result);
		
		        if (SelectNodes(xmlRtn, "NODES/NODE").length > 0) {
		            return true;
		        }
		        return false;
		    }
		
		    function btnInsForm_onclick(type) {
		        var para = new Array();
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		
		        var nodeIdx = treeView.GetSelectNode();
		        if (nodeIdx != null) {
		            if (nodeIdx.GetNodeData("DATA1") != "ROOT") {
		                var url = "";
		                var HWP = "&type=HWP";
		                var parameter = "?tCheck=FIns&contID=" + escape(nodeIdx.GetNodeData("DATA1")) + "&companyID=" + escape(companyID);
		                if (type == "HWP") {
		                    if (!CrossYN())
		                        url = "/myoffice/ezApproval/manage/FormMaker/FormMain_Cross.aspx";
		                    else
		                        return;
		                    parameter = parameter + HWP;
		                }
		                else {
		                    if (type == 'REFORM')
		                        url = "/admin/ezApproval/formMainReform.do";
		                    else {                        
		                        if(pEDITOR == "DEXT")
		                            url = "/myoffice/ezApproval/manage/FormMaker/FormMain_Cross.aspx";
		                        else                        
		                            url = "/admin/ezApproval/formMain.do";
		                    }
		                }
		                var retVal = GetOpenWindow(url + parameter, "FormMain", 1050, 970, "NO");
		                Tree_setconfig();
		                InitFormCont();
		            } 
		            else {
		                alert("<spring:message code='ezApproval.t722'/>");
		            }
		        }
		    }
		
		    var FormMain_dialogarguments = new Array();
		    function UpdateForm() {
		        var para = new Array();
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		
		        var listview = new ListView();
		        listview.LoadFromID("lvtForm");
		
		        var nodeIdx = treeView.GetSelectNode();
		        var selRow = listview.GetSelectedRows();        
		        if (selRow) {
		            var url = "";
		            var HWP = "&type=HWP";
		            var parameter = "?tCheck=FUpdate&contID=" + escape(nodeIdx.GetNodeData("DATA1")) + "&formID=" + escape(GetAttribute(selRow[0], "DATA1")) + "&companyID=" + escape(companyID);
		            if ((GetAttribute(selRow[0], "DATA4") != null ? GetAttribute(selRow[0], "DATA4").toLowerCase().indexOf(".hwp") : -1) > 0) {
		                if (!CrossYN())
		                    url = "/myoffice/ezApproval/manage/FormMaker/FormMain_Cross.aspx";
		                else
		                    return;
		                parameter = parameter + HWP;
		            }
		            else {
		                if (pEDITOR == "DEXT")
		                    url = "/myoffice/ezApproval/manage/FormMaker/FormMain_Cross.aspx";
		                else
		                    url = "/admin/ezApproval/formMain.do";
		            }
		            var retVal = GetOpenWindow(url + parameter, "FormMain", 1050, 950, "YES");
		            Tree_setconfig();
		            InitFormCont();
		        }
		    }
		
		    function DelForm() {
		        var xmlpara = createXmlDom();
		        var xmlRtn = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "PARAMETER");
		
		        var listview = new ListView();
		        listview.LoadFromID("lvtForm");
		        var selRow = listview.GetSelectedRows();
		        if (selRow)
		        {
		            if (confirm(strLang597) == true) {
		                createNodeAndInsertText(xmlpara, objNode, "ID", GetAttribute(selRow[0], "DATA1"));
		                createNodeAndInsertText(xmlpara, objNode, "COMPANYID", companyID);
		                xmlhttp.open("POST", "/myoffice/ezApproval/manage/FormMaker/aspx/Del_Form.aspx", false);
		                xmlhttp.send(xmlpara);
		                xmlRtn = loadXMLString(xmlhttp.responseText);
		
		                if (getNodeText(SelectNodes(xmlRtn, "RESULT")[0]) == "TRUE") {
		                    listview.DeleteRow(GetAttribute(selRow[0], "id"));
		                    setNodeText(descrip,"");
		                }
		                else
		                    window.alert("<spring:message code='ezApproval.t715'/>");
		            } else {
		                return;
		            }
		        }        
		    }    
		
		    function lvtForm_Row_click() {
		        var listview = new ListView();
		        listview.LoadFromID("lvtForm");
		        var oArrRows = listview.GetSelectedRows();
		        var tr = oArrRows[0];
		
		        if (tr) {
		            document.getElementById('descrip').innerHTML = GetAttribute(tr, "DATA2");
		
		            if ((GetAttribute(tr, "DATA4") != null ? GetAttribute(tr, "DATA4").toLowerCase().indexOf(".hwp") : -1) > 0)
		                document.getElementById("btnFormListView").style.display = "none";
		            else
		                document.getElementById("btnFormListView").style.display = "";
		        }
		    }
		
		    function lvtForm_Row_Dbclick() {
		        if ("${useReform}" == "YES")
		            UpdateForm_Reform();
		        else
		            UpdateForm();
		    }
		
		    function MoveUp_onclick() {
		        var listview = new ListView();
		        listview.LoadFromID("lvtForm");
		        listview.RowMoveUp();
		    }
		
		    function MoveDown_onclick() {
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);
		        var listview = new ListView();
		        listview.LoadFromID("lvtForm");
		        listview.RowMoveDown();
		    }
		
		    function FormOrder_Save() {
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        var nodeIdx = treeView.GetSelectNode();
		        var listview = new ListView();
		        listview.LoadFromID("lvtForm");
		        var iRowCount = listview.GetRowCount();
		        var strFormList = "";
		
		        if (iRowCount != 0) {
		            for (i = 0; i < iRowCount; i++) {
		                strFormList += GetAttribute(listview.GetDataRows()[i], "DATA1") + ";";
		            }
		        }
		        var xmlpara = createXmlDom();
		        var objNode;
		        var objSubNode;
		        var objDataNode;
		        objNode = createNodeInsert(xmlpara, objNode, "NODES");
		        objSubNode = createNodeAndAppandNode(xmlpara, objNode, objSubNode, "NODE");
		        createNodeAndAppandNodeText(xmlpara, objSubNode, objDataNode, "FORMCONTID", nodeIdx.GetNodeData("DATA1"));
		        createNodeAndAppandNodeText(xmlpara, objSubNode, objDataNode, "BOARDIDLIST", strFormList);
		
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/myoffice/ezApproval/manage/FormMaker/aspx/Set_FormOrder.aspx", false);
		        xmlhttp.send(xmlpara);
		
		        if (xmlhttp.responseText == "<RESULT>OK</RESULT>") {
		            alert("<spring:message code='ezApproval.t454'/>");
		        } else {
		            alert("<spring:message code='ezApproval.t391'/>");
		        }
		        xmlhttp = null;
		    }
		
		    function btnFormListView_onclick() {
		        var listview = new ListView();
		        listview.LoadFromID("lvtForm");
		        var oArrRows = listview.GetSelectedRows();
		        var tr = oArrRows[0];
		        var url = "Form_Preview.aspx?href=" + escape(GetAttribute(tr, "DATA4"));
		        if ("${useReform}" == "YES" && GetAttribute(tr, "DATA7") == "Y")
		            url = url + "&reformtype=" + escape(GetAttribute(tr, "DATA7")) + "&FormID=" + escape(GetAttribute(tr, "DATA1"));
		        var retVal = GetOpenWindow(url, "Form_Preview", 1050, 1000, "YES");
		    }
		
		    function searchform() {
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        ID = treeNode.GetNodeData("DATA1");
		
		        if (TreeIdx != "") {
		            if (document.getElementById('forminfo').value == "") {
		                OpenAlertUI(strLang554);
		                return;
		            }
		            var ID = treeNode.GetNodeData("DATA1");
		            var KIND = document.getElementById('FromList').value;
		            var searchtype = document.getElementById('searchoption').selectedIndex;
		            var searchname = document.getElementById('forminfo').value;
		            GetFormInfo("ALL", KIND, searchtype, searchname);
		        }
		    }
		
		    function reset() {
		        document.getElementById('forminfo').value = "";
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        ID = treeNode.GetNodeData("DATA1");
		        var ID = treeNode.GetNodeData("DATA1");
		        var KIND = document.getElementById('FromList').value;
		        GetFormInfo(ID, KIND, "", "");
		    }
		
		    function search_press(evt) {
		        if (window.event) {
		            if (window.event.keyCode == 13) {
		                searchform();
		            }
		        }
		        else {
		            if (evt.which == 13)
		                searchform();
		        }
		    }
		
		    function MoveForm() {
		        var para = new Array();
		
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		
		        var listview = new ListView();
		        listview.LoadFromID("lvtForm");
		
		        var nodeIdx = treeView.GetSelectNode();
		        if (nodeIdx != null) {
		            para[0] = nodeIdx.GetNodeData("DATA1");
		        }
		        var selRow = listview.GetSelectedRows();
		        if (selRow) {
		            para[1] = GetAttribute(selRow[0], "DATA1");
		            para[2] = companyID;
		
		            var url = "FormSelect.aspx";
		            var retVal = window.showModalDialog(url, para, "dialogWidth:430px;dialogHeight:580px;status:no;help:no;scroll:no;edge:sunken");
		
		            if (retVal[0] == "OK") {
		                Tree_setconfig();
		                InitFormCont();
		            }
		        }
		    }
		
		    function UpdateForm_Reform() {
		        var para = new Array();
		
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		
		        var listview = new ListView();
		        listview.LoadFromID("lvtForm");
		
		        var nodeIdx = treeView.GetSelectNode();
		        if (nodeIdx > 0) {
		            para[0] = "U";
		            para[1] = nodeIdx.GetNodeData("DATA1");
		        }
		        var selRow = listview.GetSelectedRows();
		        if (selRow) {
		            para[2] = GetAttribute(selRow[0], "DATA1");
		            para[3] = GetAttribute(selRow[0], "DATA5");
		            para[4] = GetAttribute(selRow[0], "DATA2");
		            para[5] = GetAttribute(selRow[0], "DATA3");
		            para[6] = companyID;
		            para[7] = GetAttribute(selRow[0], "DATA4");
		            para[8] = GetAttribute(selRow[0], "DATA6");
		
		            var url = "";
		            if (GetAttribute(selRow[0], "DATA4").toLowerCase().indexOf(".hwp") > 0)
		                url = "/myoffice/ezApproval/ezViewHWP/FormMain_hwp.aspx?TCheck=FUpdate&contID=" + escape(nodeIdx.GetNodeData("DATA1")) + "&formID=" + escape(GetAttribute(selRow[0], "DATA1")) + "&companyID=" + escape(companyID);
		            else
		                url = "/myoffice/ezApproval/manage/reFormMaker/FormMain_reform.aspx?TCheck=FUpdate&contID=" + escape(nodeIdx.GetNodeData("DATA1")) + "&formID=" + escape(GetAttribute(selRow[0], "DATA1")) + "&companyID=" + escape(companyID) + "&formURL=" + escape(GetAttribute(selRow[0], "DATA4"));
		
		            var retVal;
		            var retVal = GetOpenWindow(url, "FormMain", 1050, 950, "YES");
		            Tree_setconfig();
		            InitFormCont();
		        }
		    }
		
		</script>
	</HEAD>
	<body class="mainbody">
		<form id="Form1" method="post">
		<xml id='FORMLIST' style="display:none">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezApproval.t608'/></NAME>
		        <WIDTH>215</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		<xml id='FORMCONTAINER' style="display:none">
		  <TREEVIEWDATA>
		    <NODE>
		      <EXPANDED>TRUE</EXPANDED>
		      <ISLEAF>FALSE</ISLEAF>
		      <VALUE><spring:message code='ezApproval.t602'/></VALUE>
		      <DATA1>ROOT</DATA1>
		        <DATA2><spring:message code='ezApproval.t602'/></DATA2>
		        <DATA4><spring:message code='ezApproval.t602'/></DATA4>
		    </NODE>
		  </TREEVIEWDATA>
		</xml>
		<h1><spring:message code='ezApproval.t527'/></h1>
		<div id="mainmenu">        
		    <span>
		    	<b><spring:message code='ezApproval.t378'/></b>
		    	<select id="ListCompany" name="ListCompany" onchange="selectCompanyID()">
			        ${companySel}
			    </select>
		    </span><br/><br/>
		     <ul>
	            <li id="btnInsFcont"><span onclick="return btnInsFcont_onclick()"><spring:message code='ezApproval.t724'/></span></li>
	            <li id="btnUpFcont"><span onclick="return btnUpFcont_onclick()"><spring:message code='ezApproval.t728'/></span></li>
	            <li id="btnDelFcont"><span onclick="return btnDelFcont_onclick()"><spring:message code='ezApproval.t729'/></span></li>
	            <li style="background: none;"><img src="/images/i_bar.gif" style="vertical-align: middle"></li>
	            <c:choose>
	            	<c:when test="${useReform == 'YES'}">
			            <li id="btnInsForm3"><span onclick="return btnInsForm_onclick('REFORM')"><spring:message code='ezApproval.t760'/></span></li>
			            <li id="btnUpForm2"><span onclick="return UpdateForm_Reform()"><spring:message code='ezApproval.t761'/></span></li>
	            	</c:when>
	            	<c:otherwise>
			            <li id="btnInsForm1"><span onclick="return btnInsForm_onclick('MHT')"><spring:message code='ezApproval.t760'/></span></li>
			            <li id="btnInsForm2"><span onclick="return btnInsForm_onclick('HWP')">HWP <spring:message code='ezApproval.t760'/></span></li>
			            <li id="btnUpForm"><span onclick="return UpdateForm()"><spring:message code='ezApproval.t761'/></span></li>
	            	</c:otherwise>
	            </c:choose>
	            <li id="btnDelForm"><span onclick="return DelForm()"><spring:message code='ezApproval.t721'/></span></li>
	            <li id="btnModeForm"><span onclick="return MoveForm()"><spring:message code='ezApproval.t25000'/></span></li>
	            <li style="background: none;"><img src="/images/i_bar.gif" style="vertical-align: middle"></li>                     
	            <li id="btnFormListView"><span onclick="return btnFormListView_onclick()"><spring:message code='ezApproval.t350'/></span></li>
	        </ul>
		</div>
		<table class="content" style="width:1000px">
		  <tr>
		    <th><spring:message code='ezApproval.t603'/></th>
		    <td><select name="select" style="WIDTH:200px;" onchange="return select_onchange()" id="FromList">
		        <option value="A01000" selected><spring:message code='ezApproval.t604'/></option>
		        ${docType}
		      </select></td>
		      <td style="white-space:nowrap">
		                <select id="searchoption">
		                    <option value ="1"><spring:message code='ezApproval.t433'/></option>
		                    <option value ="2"><spring:message code='ezApproval.t507'/></option>
		                </select>
		                <input id="forminfo" onkeypress="search_press(event)" type="text" style="margin-bottom:3px;"/>
		                <a class="imgbtn" onclick="searchform()"><span><spring:message code='ezApproval.t236'/></span></a>
		                <a class="imgbtn" onclick="reset()"><span><spring:message code='ezApproval.t397'/></span></a>
		            </td>
		  </tr>
		</table>
		<table style="margin-top:5px;width:1005px;height:500px">
		  <tr>
		    <td rowspan="3" style="width:400px; vertical-align:top">
				<div id="divFromTreeView" style="vertical-align:top; padding-top:5px; height:500px; width:100%; overflow-x:auto;overflow-y:auto;BORDER:#b6b6b6 1px solid; BACKGROUND-COLOR:#ffffff" ></div>
			</td>
		    <td style="width:600px; padding-left:5px; padding-right:5px;vertical-align:top">
			    <div class="listview">
			        <div id="divlvtForm" style="WIDTH: 100%; HEIGHT: 470px;overflow-x:auto;overflow-y:auto; padding:0px"  ></div>
			    </div>
			</td>    
		  </tr>
		    <tr>
		    <td style="padding-left:5px; padding-right:5px; padding-top:5px; vertical-align:top">
		        <table class="content">
		            <tr>
		              <th><spring:message code='ezApproval.t605'/></th>
		              <td id="descrip">&nbsp;</td>
		            </tr>
		        </table>
		    </td>
		  </tr>   
		    <tr>
		    <td style="padding-left:5px; padding-right:5px; padding-top:5px; vertical-align:top; text-align:center">
		        <a class="imgbtn"><span onclick="return MoveUp_onclick()"><spring:message code='ezApproval.t659'/></span></a>
		        <a class="imgbtn"><span onclick="return MoveDown_onclick()"><spring:message code='ezApproval.t660'/></span></a>
		        <a class="imgbtn"><span onclick="return FormOrder_Save()"><spring:message code='ezApproval.t66'/></span></a>
		    </td>
		  </tr>  
		</table>
	    </form>
	</body>
</HTML>
