<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t152'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<link rel="stylesheet" href="/css/Tab.css" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TreeView.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/getContainerInfo_Cross.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var xmlhttp = createXMLHttpRequest();	
		    var xmldoc = createXmlDom();
		    var OrderCell = "";
		    var pDeptID;
		    var Rtnval = new Array();
		    var DocFileType = "${fileType}";
		    var Server_Name = "${serverName}";
		    var TreeIdx;
		    var ListIdx;
		    var RetValue;
		    var ReturnFunction;
		    var NonActiveX = "YES";
		    window.onload = function () {
		        Get_Favoritelist();
		
		        document.getElementById("LocalloadHwp").style.display = "none";
		        document.getElementById("LocalloadMht").style.display = "none";
		        DocFileType = DocFileType.toLowerCase();
		        Tree_setconfig();
		        if (DocFileType == "mht")
		            document.getElementById("LocalloadHwp").style.display = "none";
		        else if (DocFileType == "hwp")
		            document.getElementById("LocalloadMht").style.display = "none";
		        var pFormKind;
		        pDeptID = "${deptID}";
		
		        try {
		            RetValue = parent.getformcont_cross_dialogArguments[0];
		            ReturnFunction = parent.getformcont_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.getformcont_cross_dialogArguments[0];
		                ReturnFunction = opener.getformcont_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		
		        pFormKind = RetValue[1];
		        if (pFormKind == "004") {
		            document.getElementById('FromList').innerHTML = "";
		            var select = document.getElementById('FromList');
		            select.options[select.options.length] = new Option(strLangDocType4, '004');
		            document.getElementById('FromList').value = "004";
		            document.getElementById('Localload').style.display = "none";
		        }
		        else if (pFormKind == "999") {
		            document.getElementById("LocalloadHwp").style.display = "none";
		            document.getElementById("LocalloadMht").style.display = "none";
		        }
		        InitFormCont();
		
		        Rtnval[0] = "cancel";
		        Rtnval[1] = "cancel";
		        if (!CrossYN()) {
		            window.returnValue = Rtnval;
		        }
		    }
		    function Tree_setconfig() {
		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("GET", "/xml/organtree_config2.xml", false);
		        xmlHTTP.send();
		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(xmlHTTP.responseXML);
		        }
		    }
		    function select_onchange() {
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        ID = treeNode.GetNodeData("DATA1");
		        if (TreeIdx != "") {
		            if (pSelectTab == "favoritelist") {
		                Get_Favoritelist();
		            }
		            else {
		                var ID = treeNode.GetNodeData("DATA1");
		                var KIND = document.getElementById('FromList').value;
		                GetFormInfo(ID, KIND);
		            }
		        }
		    }
		    function TreeViewRequestData(pNodeID, pTreeID) {
		        TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        ID = treeNode.GetNodeData("DATA1");
		        DeptID = treeNode.GetNodeData("DATA2");
		        KIND = document.getElementById('FromList').value;
		
		        GetFormInfo(ID, KIND);
		
		        if (ID != "ROOT") {
		            GetFormContInfo(ID, DeptID, "REQUEST")
		        }
		    }
		
		    function TreeViewNodeClick(pNodeID) {
		        TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        ID = treeNode.GetNodeData("DATA1");
		        DeptID = treeNode.GetNodeData("DATA2");
		        KIND = document.getElementById('FromList').value;
		        GetFormInfo(ID, KIND);
		    }
		
		    function TreeViewNodeClick(pNodeID, pNodeNM) {
		        TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        ID = treeNode.GetNodeData("DATA1");
		        DeptID = treeNode.GetNodeData("DATA2");
		        KIND = document.getElementById('FromList').value;
		        GetFormInfo(ID, KIND);
		    }
		
		    function lvtForm_onSel_Changed() {
		        var listview = new ListView();
		        if (pSelectTab == "favoritelist")
		            listview.LoadFromID("lvtFavForm");
		        else
		            listview.LoadFromID("lvtForm");
		        var oArrRows = listview.GetSelectedRows();
		        var tr = oArrRows[0];
		        if (tr) {
		            if (pSelectTab == "favoritelist")
		                document.getElementById('descrip2').innerHTML = tr.getAttribute("DATA2");
		            else
		                document.getElementById('descrip').innerHTML = tr.getAttribute("DATA2");
		        }
		    }
		    function lvtForm_onSel_Click() {
		    }
		    function lvtForm_onSel_DBclick() {
		        btnOK_onclick();
		    }
		    function lvtForm_onclick() {
		    }
		    function btnOK_onclick() {
		        var URL;
		        var listview = new ListView();
		        if (pSelectTab == "favoritelist")
		            listview.LoadFromID("lvtFavForm");
		        else
		            listview.LoadFromID("lvtForm");
		        var oArrRows = listview.GetSelectedRows();
		        var selRow = oArrRows[0];
		        if (selRow) {
		            URL = selRow.getAttribute("DATA4");
		            if ((DocFileType == "") || (URL.substr(URL.length - 3, URL.length).toLowerCase() == DocFileType)) {
		                Rtnval[0] = selRow.getAttribute("DATA4");
		                Rtnval[1] = selRow.getAttribute("DATA3");
		                Rtnval[2] = selRow.getAttribute("DATA1");
		                Rtnval[3] = selRow.childNodes[0].innerText;
		
		                if (ReturnFunction != null) {
		                    ReturnFunction(Rtnval);
		                }
		                else {
		                    window.returnValue = Rtnval;
		                }
		                window.close();
		            }
		            else {
		                if (DocFileType == "doc") {
		                    var pAlertContent = "<spring:message code='ezApprovalG.t1528'/>" + "<br>MHT, HWP " + "<spring:message code='ezApprovalG.t1529'/>";
		                }
		                else if (DocFileType == "hwp") {
		                    var pAlertContent = "<spring:message code='ezApprovalG.t1528'/>" + "<br>MHT, " + "<spring:message code='ezApprovalG.t1531'/>";
		                }
		                else {
		                    var pAlertContent = "MHT " + "<spring:message code='ezApprovalG.t1532'/>" + "<br>HWP, " + "<spring:message code='ezApprovalG.t1531'/>";
		                }
		                OpenAlertUI(pAlertContent);
		            }
		        }
		        else {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
		            OpenAlertUI(pAlertContent);
		        }
		    }
		    function btncancel_onclick() {
		        if (ReturnFunction != null) {
		            ReturnFunction(Rtnval);
		        }
		        else {
		            window.returnValue = Rtnval;
		        }
		        window.close();
		    }
		    function Localload_onclick(pGubun) {
		        Rtnval[0] = "PC";
		        Rtnval[1] = "PC";
		        Rtnval[2] = pGubun;
		        if (ReturnFunction != null) {
		            ReturnFunction(Rtnval);
		        }
		        else {
		            window.returnValue = Rtnval;
		        }
		        window.close();
		    }
		    function btnAddForm_onclick(type) {
		        var listView = new ListView();
		        if (type == "2")
		            listView.LoadFromID("lvtFavForm");
		        else
		            listView.LoadFromID("lvtForm");
		
		        var treeView = new TreeView();
		        treeView.LoadFromID("FormTreeView");
		        var oArrRow = listView.GetSelectedRows();
		        var selRow = oArrRow[0];
		        if (selRow) {
		            var tempFormID = selRow.getAttribute("DATA1");
		            var selnode = treeView.GetSelectNode();
		            if (selnode) {
		                var pInformationText = "";
		                var xmlhttp = createXMLHttpRequest();
		                if (type == "2")
		                    xmlhttp.open("POST", "aspx/delFormUserInfo.aspx", false);
		                else
		                    xmlhttp.open("POST", "aspx/setFormUserInfo.aspx", false);
		                xmlhttp.send("<RESULT><PARA>" + tempFormID + "</PARA></RESULT>");
		                if (getNodeText(GetChildNodes(xmlhttp.responseXML)[0]) == "TRUE") {
		                    if (type == "2") {
		                        OpenAlertUI("<spring:message code='ezApprovalG.t804'/>");
		                        Get_Favoritelist();
		                    }
		                    else {
		                        OpenAlertUI("<spring:message code='ezApprovalG.t801'/>");
		                        Get_Favoritelist();
		                    }
		                }
		                else {
		                    OpenAlertUI("<spring:message code='ezApprovalG.t180'/>");
		                }
		            }
		        }
		        else {
		            OpenAlertUI("<spring:message code='ezApprovalG.t1536'/>");
		        }
		    }
		
		    var Tab1_SelectID = "";
		    var Tab1_flag = true;
		    function Tab1_MouserOver(obj) {
		        obj.className = "tabover";
		    }
		    function Tab1_MouserOut(obj) {
		        if (Tab1_SelectID != obj.id)
		            obj.className = "";
		    }
		    function Tab1_MouseClick(obj) {
		        obj.className = "tabon";
		        if (obj.id != Tab1_SelectID) {
		            if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
		                document.getElementById(Tab1_SelectID).className = "";
		
		            obj.className = "tabon";
		            Tab1_SelectID = obj.id;
		            ChangeTab(obj);
		        }
		    }
		    function Tab1_NewTabIni(pTabNodeID) {
		        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
		            if (document.getElementById(pTabNodeID).childNodes[i].nodeName == "P") {
		                if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].nodeName == "SPAN") {
		                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseover = function () { Tab1_MouserOver(this); };;
		                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseout = function () { Tab1_MouserOut(this); };;
		                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick(this); };;
		
		                    if (Tab1_flag) {
		                        document.getElementById(pTabNodeID).childNodes[i].childNodes[0].className = "tabon";
		                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id;
		                        Tab1_flag = false;
		                    }
		
		                }
		            }
		        }
		    }
		
		    var pSelectTab = "favoritelist";
		    var tempFromList;
		    var tempFromList2;
		    function ChangeTab(obj) {
		        pSelectTab = obj.getAttribute("divname");
		        switch (pSelectTab) {
		            case "favoritelist":
		                tempFromList = document.getElementById("FromList").selectedIndex;
		                document.getElementById("FromList").selectedIndex = tempFromList2;
		                document.getElementById("favoritetable").style.display = "";
		                document.getElementById("formtable").style.display = "none";
		                document.getElementById("delfav").style.display = "";
		                document.getElementById("addfav").style.display = "none";
		                break;
		            case "formlist":
		                tempFromList2 = document.getElementById("FromList").selectedIndex;
		                document.getElementById("FromList").selectedIndex = tempFromList;
		                document.getElementById("favoritetable").style.display = "none";
		                document.getElementById("formtable").style.display = "";
		                document.getElementById("delfav").style.display = "none";
		                document.getElementById("addfav").style.display = "";
		                break;
		        }
		    }
		
		    function Get_Favoritelist(type) {
		        var xmlpara = createXmlDom();
		        var xmlRtn = createXmlDom();
		        var objNode;
		
		        createNodeInsert(xmlpara, objNode, "PARAMETER");
		        createNodeAndInsertText(xmlpara, objNode, "ID", "ROOT");
		        createNodeAndInsertText(xmlpara, objNode, "KIND", document.getElementById('FromList').value);
		
		        if (type == "1") {
		            createNodeAndInsertText(xmlpara, objNode, "SEARCHTYPE", document.getElementById('searchoption').selectedIndex);
		            createNodeAndInsertText(xmlpara, objNode, "SEARCHNAME", document.getElementById('forminfo').value);
		        }
		        else {
		            createNodeAndInsertText(xmlpara, objNode, "SEARCHTYPE", "");
		            createNodeAndInsertText(xmlpara, objNode, "SEARCHNAME", "");
		        }
		        xmlhttp.open("POST", "aspx/getForm.aspx", false);
		        xmlhttp.send(xmlpara);
		
		        xmlRtn = loadXMLString(xmlhttp.responseText);
		
		        document.getElementById('divlvtFavForm').innerHTML = "";
		
		        var listview = new ListView();
		        listview.SetID("lvtFavForm");
		        listview.SetMulSelectable(false);
		        listview.SetRowOnClick("lvtForm_onSel_Changed");
		        listview.SetRowOnDblClick("lvtForm_onSel_DBclick");
		        listview.DataSource(xmlRtn);
		        listview.DataBind("divlvtFavForm");
		
		        var selRow = listview.GetSelectedRows();
		        var tr = selRow[0];
		
		        if (tr) {
		            listview.SetSelectFlag(true);
		            document.getElementById('descrip2').innerHTML = tr.getAttribute("DATA2");
		        }
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
		
		    function reset() {
		        document.getElementById('forminfo').value = "";
		        if (pSelectTab == "favoritelist") {
		            Get_Favoritelist();
		        }
		        else {
		            var treeNode = new TreeNode();
		            treeNode.LoadFromID(TreeIdx);
		            ID = treeNode.GetNodeData("DATA1");
		
		            var ID = treeNode.GetNodeData("DATA1");
		            var KIND = document.getElementById('FromList').value;
		
		            GetFormInfo(ID, KIND);
		        }
		    }
		
		    function searchform() {
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        ID = treeNode.GetNodeData("DATA1");
		
		        if (TreeIdx != "") {
		            if (document.getElementById('forminfo').value == "") {
		                alert("<spring:message code='ezApprovalG.t1160'/>");
		                return;
		            }
		
		            if (pSelectTab == "favoritelist") {
		                Get_Favoritelist('1');
		            }
		            else {
		                var ID = treeNode.GetNodeData("DATA1");
		                var KIND = document.getElementById('FromList').value;
		                var searchtype = document.getElementById('searchoption').selectedIndex;
		                var searchname = document.getElementById('forminfo').value;
		
		                GetFormInfo("ALL", KIND, searchtype, searchname);
		            }
		        }
		    }
		</script>
	</head>
	<body class="popup">
		<xml id='FORMLIST' style="Display:none">
		<LISTVIEWDATA>
			<HEADERS>
				<HEADER>
					<NAME><spring:message code='ezApprovalG.t1537'/></NAME>
					<WIDTH>215</WIDTH>
				</HEADER>
			</HEADERS>
		</LISTVIEWDATA>
		</xml>
		<xml id='FORMCONTAINER' style="Display:none">
		<TREEVIEWDATA>
			<NODE>
				<EXPANDED>TRUE</EXPANDED>
				<ISLEAF>FALSE</ISLEAF>
				<VALUE><spring:message code='ezApprovalG.t1539'/></VALUE>
			</NODE>
		</TREEVIEWDATA>
		</xml>
		<h1><spring:message code='ezApprovalG.t152'/></h1>
		    <table class="content" style="width:684px;">
			    <tr>
				    <th><spring:message code='ezApprovalG.t1540'/></th>
				    <td><select name="select" onChange="return select_onchange()" id="FromList">
						    <OPTION value="000" selected><spring:message code='ezApprovalG.t1541'/></OPTION>
						    ${docType}
					    </select>
				    </td>
		            <td style="white-space: nowrap">
		                <select id="searchoption">
		                    <option value="1"><spring:message code='ezApprovalG.t442'/></option>
		                    <option value="2"><spring:message code='ezApprovalG.t598'/></option>
		                </select>
		                <input id="forminfo" onkeypress="search_press(event)" type="text" />
		                <a class="imgbtn" onclick="searchform()"><span><spring:message code='ezApprovalG.t111'/></span></a>
		                <a class="imgbtn" onclick="reset()"><span><spring:message code='ezApprovalG.t1301'/></span></a>
		            </td>
			    </tr>
		    </table>
		        <div class="portlet_tabpart01" style="margin-top: 3px; width: 684px">
		        <div class="portlet_tabpart01_top" id="tab1">
		            <p><span id="1tab1" divname="favoritelist"><spring:message code='ezApprovalG.G00001'/></span></p>
		            <p><span id="1tab2" divname="formlist"><spring:message code='ezApprovalG.t1537'/></span></p>
		            <div style="float: right">
		                <a id="addfav" class="imgbtn" style="display:none"><span onclick="return btnAddForm_onclick('1')"><spring:message code='ezApprovalG.t00002'/></span></a>
		                <a id="delfav" class="imgbtn"><span onclick="return btnAddForm_onclick('2')"><spring:message code='ezApprovalG.t00003'/></span></a>
		            </div>
		        </div>
		    </div>
		    <table id="favoritetable" style="margin-top: 5px; width: 684px;">
		        <tr>
		            <td style="padding-right: 1px; vertical-align: top;">
		                <div class="border_gray">
		                    <div id="divlvtFavForm" style="border: 0; WIDTH: 100%; HEIGHT: 356px; overflow-x: auto; overflow-y: auto; padding: 0px"></div>
		                </div>
		            </td>
		        </tr>
		        <tr>
		            <td style="vertical-align: top;">
		                <table class="content">
		                    <tr>
		                        <th><spring:message code='ezApprovalG.t1543'/></th>
		                        <td id="descrip2" style="width: 100%">&nbsp;</td>
		                    </tr>
		                </table>
		            </td>
		        </tr>
		    </table>
		    <table id="formtable" style="margin-top: 5px;display:none">
		        <tr>
		            <td rowspan="2" style="vertical-align: top;">
		                <div id="TreeView" style="height: 384px; width: 280px; overflow-x: auto; overflow-y: auto; BORDER: #b6b6b6 1px solid; BACKGROUND-COLOR: #ffffff; padding: 4px,6px,6px,4px"></div>
		            </td>
		            <td style="padding-left: 5px; vertical-align: top;">
		                <div class="border_gray">
		                    <!-- 기존 class="listview" -->
		                    <div id="divlvtForm" style="BORDER: 0; WIDTH: 395px; HEIGHT: 353px; margin: 0px 1px 1px 1px; overflow-y: auto; overflow-x: hidden;"></div>
		                </div>
		            </td>
		        </tr>
		        <tr>
		            <td style="padding-left: 5px; vertical-align: top;">
		                <table class="content">
		                    <tr>
		                        <th><spring:message code='ezApprovalG.t1543'/></th>
		                        <td id="descrip" style="width: 320px">&nbsp;</td>
		                    </tr>
		                </table>
		            </td>
		        </tr>
		    </table>
		<div class="btnposition" >
		  <input type="button" name="LocalloadHwp" id="LocalloadHwp" value="<spring:message code='ezApprovalG.t1544'/>" onClick="return Localload_onclick('HWP')" style="width:210px;">
		  <input type="button" name="LocalloadMht" id="LocalloadMht" value="<spring:message code='ezApprovalG.t1545'/>" onClick="return Localload_onclick('MHT')" style="width:210px;">
		
		  <a class="imgbtn"><span onClick="return btnOK_onclick()" ><spring:message code='ezApprovalG.t20'/></span></a>
		  <a class="imgbtn"><span onClick="return btncancel_onclick()" ><spring:message code='ezApprovalG.t119'/></span></a>
		</div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	    <script type="text/javascript">
	        Tab1_NewTabIni("tab1");
		</script>
	</body>
</html>