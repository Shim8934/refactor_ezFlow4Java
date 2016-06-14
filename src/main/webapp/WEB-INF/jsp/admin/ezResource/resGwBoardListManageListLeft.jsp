<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t20" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezResource.e2" />" type="text/css" />
		<link type="text/css" rel="stylesheet" href="/css/organ_tree.css" />
		<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
		<script type="text/javascript" src="<spring:message code='ezResource.e1'/>"></script>
		<script type="text/javascript" src="/js/ezResource/organtreeview.htc.js"></script> 
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezResource/admin/gwAdmin.js"></script>
		<script type="text/javascript" id="clientEventHandlersJS" >
			var pUserID		= '${userInfo.id}';
			var pDeptID		= '${userInfo.deptID}';
			var pCompanyID	= '${userInfo.companyID}';
			var pAdminYN	= '${adminYN}';

			var HqProposalNM;
			var pSelCompanyID = "";

			var selectNo = "${selectNo}";

		    function TreeView_onNodeDblClick() {
		        TreeView.toggle(TreeView.selectedIndex());
		    }

		    window.onload = function () {;
		        var TreeView = new organtreeview('TreeView', 'TreeView');
		        TreeView.attachEvent('requestdata', TreeView_onNodeExpanded);
		        TreeView.attachEvent('nodeselect', TreeView_onNodeClick);
		        TreeView.attachEvent('nodedblclick', TreeView_onNodeDblClick);

		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("GET", "/xml/ezResource/organtree_config2.xml", false);
		        xmlHTTP.send();

		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            TreeView.server('${serverName}');
		            TreeView.config(xmlHTTP.responseXML);
		            TreeView.update();
		            GetTopGroupXML();
		            changeTree();
		        }
		    }

		    function changeTree() {
		        pSelCompanyID = document.getElementById("SCompID").value;
		        pCompanyID = pSelCompanyID;

		        if (pAdminYN == "YES")
		            cAdmin = "ADMIN"
		        else
		            cAdmin = "BOARDADMIN"

		        initTreeInfo(pUserID, pDeptID, pSelCompanyID);
		    }

		    function GetTopGroupXML() {
		        var oOption = document.createElement("OPTION");
		        oOption.text = "${userInfo.companyName1}";
		        oOption.value = "${userInfo.companyID}";
		        oOption.setAttribute("DATA", "D090");
		        document.getElementById("SCompID").add(oOption);
		    }

		    function searchValue() {
		        if(window.parent.frames["board_main"].document.getElementById("proc") != null){
		            var pFlag = window.parent.frames["board_main"].document.getElementById("proc").value;
		            NavigateBrdAdminleft(pFlag);
		        }
		    }

		    function TreeView_onNodeClick() {
		        setTimeout(searchValue, 10);
		    }


		    function initTreeInfo(p_UserID, p_DeptID, pSelCompanyID) {
		        var xmlhttp = createXMLHttpRequest();
		        var xmlpara = createXmlDom();
		        var xmlRtn = createXmlDom();

		        var objNode;
		        createNodeInsert(xmlpara, objNode, "BRDLIST");
		        createNodeAndInsertText(xmlpara, objNode, "PARENT_ID", "");
		        createNodeAndInsertText(xmlpara, objNode, "COMPANY_ID", pSelCompanyID);
		        createNodeAndInsertText(xmlpara, objNode, "ACCESS_FLAG", "0");
		        createNodeAndInsertText(xmlpara, objNode, "FIRST_NODE", "Y");
		        createNodeAndInsertText(xmlpara, objNode, "TREE_TYPE", "1");

		        xmlhttp.open("POST", "/admin/ezResource/callManagerDepthNode.do?flag=" + selectNo, false);
		        xmlhttp.send(xmlpara);

		        var XMLstring = xmlhttp.responseText;

		        xmlRtn = loadXMLString(XMLstring);
		        TreeView.source(xmlRtn);
		        TreeView.update();
		    }

		    function TreeView_onNodeExpanded(event) {
		        var nodeIdx = event.nodeIdx;

		        var brd_level = TreeView.getvalue(nodeIdx, "DATA3");
		        var m_param1 = TreeView.getvalue(nodeIdx, "DATA1");

		        if (nodeIdx > 0) {
		            getFirstDepthNode(parseInt(brd_level) + 1, m_param1, nodeIdx)
		        }

		        if (m_param1 == "4") {
		            HqProposalNM = TreeView.getvalue(nodeIdx, "DATA2");
		        }
		    }


		    function getFirstDepthNode(p_Depth, p_brd_id, nodeIdx) {
		        var xmlhttp = createXMLHttpRequest();
		        var xmlRtn = createXmlDom();
		        var xmlpara = createXmlDom();

		        var objNode;
		        createNodeInsert(xmlpara, objNode, "BRDLIST");
		        createNodeAndInsertText(xmlpara, objNode, "PARENT_ID", p_brd_id);
		        createNodeAndInsertText(xmlpara, objNode, "COMPANY_ID", pSelCompanyID);
		        createNodeAndInsertText(xmlpara, objNode, "ACCESS_FLAG", "0");
		        createNodeAndInsertText(xmlpara, objNode, "FIRST_NODE", "N");
		        createNodeAndInsertText(xmlpara, objNode, "TREE_TYPE", "1");

		        xmlhttp.open("POST", "/ezResource/callNodeTreeData.do", false);
		        xmlhttp.send(xmlpara);

		        var XMLstring = xmlhttp.responseText;
		        xmlRtn = loadXMLString(XMLstring);
		        if (XMLstring == "") return;

		        if (SelectNodes(xmlRtn, "NODES/NODE/SELECT").length > 0) {
		            xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].removeChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("SELECT")[0]);
		        }
		        TreeView.putchildxml(nodeIdx, xmlRtn);
		    }

		    function brdlistsInit() {
		        try {
		            document.getElementById("brdlists").value = 0;
		            window.parent.frames["board_menu"].BRDLIST.selectedIndex = 0;
		        } catch (e) {
		        }
		    }
	</script>
	</head>
	<body class="leftbody" style="overflow-y: auto;overflow-x: hidden">	
		<div id="left">
  			<div class="left_admin"><spring:message code="ezResource.t17" /></div>
			<h2><span onClick="NavigateBrdAdmin_Res('MOD')" style="display:inline-block;width:100%;"><spring:message code="ezResource.t22" /></span><ul></ul></h2>
			<h2><span onClick="NavigateBrdAdmin_Res('NEW')" style="display:inline-block;width:100%;"><spring:message code="ezResource.t23" /></span><ul></ul></h2>
			<h2><span onClick="NavigateBrdAdmin_Res('ACL')" style="display:inline-block;width:100%;"><spring:message code="ezResource.t24" /></span><ul></ul></h2>
			<h2><span onClick="brdlistsInit();NavigateBrdAdmin_Res('STEP')" style="display:inline-block;width:100%;"><spring:message code="ezResource.t25" /></span><ul></ul></h2>
			<h2><span onClick="NavigateBrdAdmin_Res('MOV')" style="display:inline-block;width:100%;"><spring:message code="ezResource.t26" /></span><ul></ul></h2>
			<h2><span onClick="NavigateBrdAdmin_Res('DEL')" style="display:inline-block;width:100%;"><spring:message code="ezResource.t27" /></span><ul></ul></h2>
			<div class="point" style="margin-top:10px; margin-left:5px" >
				<script type="text/javascript">
					initToggleList(document.getElementById("left"), "h2", "ul", "li");
				</script>
				<spring:message code="ezResource.t28" />
				<select id="SCompID" name="SCompID" onChange="changeTree()" style="width: 145px"></select>
			</div>
    		<br />
    		<div id="TreeView" valign="top" style="behavior:url(/js/ezResource/organtreeview.htc);height:380px;width:174px;overflow-x:auto;overflow-y:auto;
    			BORDER:#b6b6b6 0px solid; BACKGROUND-COLOR:#F8F8F8;margin-top:5px;" onrequestdata="TreeView_onNodeExpanded(event);"  onnodeselect="TreeView_onNodeClick();"
				onnodedblclick="TreeView.toggle(TreeView.selectedIndex)" onclick="brdlistsInit()">
			</div>
    		
			<form name="brds">
				<input type="hidden" id="up_id" name="up_id" value="0">
				<input type="hidden" id="up_nm" name="up_nm" value="<spring:message code="ezResource.t29" />">
				<input type="hidden" id="up_step" name="up_step" value="0">
				<input type="hidden" id="up_level" name="up_level" value="0">
				<input type="hidden" id="brdlists" name="brdlists" value="0">
			</form>
		</div>
	</body>
</html>