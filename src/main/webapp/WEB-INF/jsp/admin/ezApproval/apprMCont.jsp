<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title></title>
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezApproval.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/TreeView.js" ></script>
		<script type="text/javascript" src="/js/ezApproval/control_Cross/ListView_list.js" ></script>
	    <script type="text/javascript" src="/js/ezApproval/TreeViewCtrl_Cross.js"></script>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var xmlHTTP = createXMLHttpRequest();
	        var labelcolor = "gray"
	        var xmldoc = createXmlDom();
	        var gManageID, gFContID, gParant, Flag, RtnState;
	        var DeptID;
	        var CompanyID;
	        var text1 = "<spring:message code='ezApproval.t611'/>";
	        var listview = new ListView();
	
	        window.onload = function () {
	            
	            Tree_setconfig();
	
	            document.getElementById('lvtForm').innerHTML = "";
	            listview.SetID("lvtDocForm");
	            listview.SetMulSelectable(true);
	            listview.SetRowOnClick("lvtForm_onSel_Click");
	            listview.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));
	            listview.DataBind("lvtForm");
	
	            TreeViewinitialize("", document.getElementById("ListCompany").value, "cn;extensionAttribute2;extensionAttribute3", "${serverName}");
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
	        function TreeViewNodeDbClick() {
	        }
	        function pNodeDblClick() {
	        }
	
	        function TreeViewNodeClick() {
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            var nodeIdx = treeView.GetSelectNode();
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(nodeIdx.NodeID);
	            CompanyID = treeNode.GetNodeData("EXTENSIONATTRIBUTE2");
	            getContInfo(treeNode.GetNodeData("CN"));
	        }
	
	        function lvtForm_onSel_Changed() {
	        }
	
	        function lvtForm_onSel_Click() {
	        }
	
	        function lvtForm_onSel_DBclick() {
	        }
	
	        function lvtForm_onclick() {
	        }
	
	        function getContInfo(DeptID) {
	            document.getElementById("lvtForm").innerHTML = "";
	            var xmlRtn = createXmlDom();
	            
//성공후에 deptID R 반환하는거 고쳐야겠지?	            
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/MgetContinfo.do",
		    		data : {
		    			deptID : DeptID,
		    			comID  : CompanyID
		    		},
		    		success: function(xml){
		    			xmlRtn = loadXMLString(xml);
			            listview.LoadFromID("lvtDocForm");
			            listview.DataSource(xmlRtn);
			            listview.DataBind("lvtForm");
		    		}
		    	});
	        }
	
	        function delContainer(selRow) {
	            var ContID = GetAttribute(listview.GetDataRows()[selRow], "DATA1");
	            var xmlRtn = createXmlDom();
	            
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/MdelCont.do",
		    		data : {
		    			contID : ContID,
		    			comID  : CompanyID
		    		},
		    		success: function(xml){
		    			xmlRtn = loadXMLString(xml);
		    		}
		    	});
	
	            if (xmlRtn.getElementsByTagName("RESULT")[0].childNodes[0].nodeValue != "TRUE") {
	                window.alert("<spring:message code='ezApproval.t681'/>");
	            } 
	        }
	
	        function listAdd(pContName, pContID, pData2, pContNameLang, pData4) {
	            pparsingXML = "<LISTVIEWDATA><HEADERS>";
	            pparsingXML = pparsingXML + "<HEADER><NAME>" + text1 + "</NAME><WIDTH>250</WIDTH></HEADER>";
	            pparsingXML = pparsingXML + "</HEADERS><ROWS><ROW><CELL>";
	            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(pContName) + "</VALUE>";
	            pparsingXML = pparsingXML + "<DATA1>" + pContID + "</DATA1>";
	            pparsingXML = pparsingXML + "<DATA2>" + pData2 + "</DATA2>";
	            pparsingXML = pparsingXML + "<DATA3>" + MakeXMLString(pContNameLang) + "</DATA3>";
	            pparsingXML = pparsingXML + "<DATA4>" + pData4 + "</DATA4>";
	            pparsingXML = pparsingXML + "</CELL></ROW>";
	            pparsingXML = pparsingXML + "</ROWS></LISTVIEWDATA>";
	            return pparsingXML;
	        }
	
	        function MakeXMLString(pOrgString) {
	            return ReplaceText(ReplaceText(ReplaceText(pOrgString, "&", "&amp;"), "<", "&lt;"), ">", "&gt;");
	        }
	
	        function ReplaceText(orgStr, findStr, replaceStr) {
	            try {
	                if (findStr == ".") {
	                    var a = 0;
	                    for (a = 0; a < 10; a++)
	                        orgStr = orgStr.replace(".", replaceStr);
	                    return orgStr;
	                }
	                else {
	                    var re = new RegExp(findStr, "gi");
	                    return (orgStr.replace(re, replaceStr));
	                }
	            } catch (e) {
	                return orgStr
	            }
	        }
	
	        function btnDel_onclick() {
	            listview.LoadFromID("lvtDocForm");
	            var selRow = listview.GetSelectedIndexes().split(",");
	            var unSelRows = listview.GetUnSelectedIndexes().split(",");
	            var unSelRowLength = listview.GetRowCount() - selRow.length;
	            var xmlRtn = createXmlDom();
	            for (var count = 0 ; count < selRow.length ; count++)
	                if (selRow[count]) {
	                    delContainer(selRow[count])
	                }
	
	            var pContName = new Array();
	            var pData2 = new Array();
	            var pContID = new Array();
	            var pData4 = new Array();
	            var pContNameLang = new Array();
	            var j = 0;
	            if (unSelRowLength > 0) {
	                for (var count1 = 0 ; count1 < unSelRowLength	; count1++) {
	                    pContName[j] = getNodeText(listview.GetDataRows()[unSelRows[j]].cells[0]);
	                    pContID[j] = GetAttribute(listview.GetDataRows()[unSelRows[j]], "DATA1");
	                    pData2[j] = GetAttribute(listview.GetDataRows()[unSelRows[j]], "DATA2");
	                    pContNameLang[j] = GetAttribute(listview.GetDataRows()[unSelRows[j]], "DATA3");
	                    pData4[j] = GetAttribute(listview.GetDataRows()[unSelRows[j]], "DATA4");
	                    j++;
	                }
	            }
	            j = 0;
	
	            for (count1 = listview.GetRowCount() - 1 ; count1 >= 0 ; count1--) {
	                var tr = listview.GetDataRows()[count1];
	                listview.DeleteRow(GetAttribute(tr, "id"));
	            }
	
	            for (count1 = 0 ; count1 < unSelRowLength ; count1++) {
	                var strXML = listAdd(pContName[j], pContID[j], pData2[j], pContNameLang[j], pData4[j]);
	                var objTr = listview.AddRow(j);
	                SetAttribute(objTr, "id", "lvtDocForm" + "_TR_" + j);
	                xmlRtn = loadXMLString(strXML);
	                listview.AddDataRow(objTr, xmlRtn);
	                j++;
	            }
	        }
	
	        var minscontmain_dialogArguments = new Array();
	        function btnIns_onclick() {
	            var para = new Array();
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            var nodeIdx = treeView.GetSelectNode();
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(nodeIdx.NodeID);
	
	            if (CompanyID == "") {
	                alert("<spring:message code='ezApproval.t683'/>");
	                return;
	            }
	
	            if (nodeIdx.NodeID != null) {
	                para[0] = "I";
	                para[1] = treeNode.GetNodeData("CN");
	                para[2] = CompanyID;
	                para[3] = DeptID;
	
	                var url = "/admin/ezApproval/MinsContMain.do?TCheck=DContIns";
	                minscontmain_dialogArguments[0] = para;
	                minscontmain_dialogArguments[1] = btnIns_onclick_Complete;
	                var result = GetOpenWindow("/admin/ezApproval/MinsContMain.do", "MinsContMain_Cross", 580, 455, "NO");
	            }
	            else {
	                alert("<spring:message code='ezApproval.t684'/>");
	            }
	        }
	
	        function btnIns_onclick_Complete(retVal) {
	            if (retVal == "TRUE") {
	                getContInfo(retVal[1])
	            }
	        }
	
	        function btnUpdate_onclick() {
	            var para = new Array();
	            listview.LoadFromID("lvtDocForm");
	            var selRow = listview.GetSelectedRows();
	
	            if (CompanyID == "") {
	                alert("<spring:message code='ezApproval.t683'/>");
	                return;
	            }
	
	            if (selRow[0]) {
	                para[0] = "U";
	                para[1] = GetAttribute(selRow[0], "DATA1");
	                para[2] = GetAttribute(selRow[0], "DATA2");
	                para[3] = GetAttribute(selRow[0], "DATA4");
	                para[4] = CompanyID;
	                para[5] = DeptID;
	                var url = "/admin/ezApproval/MinsContMain.do?TCheck=DContUpdate"
	                minscontmain_dialogArguments[0] = para;
	                minscontmain_dialogArguments[1] = btnUpdate_onclick_Complete;
	                var result = GetOpenWindow("/admin/ezApproval/MinsContMain.do", "MinsContMain_Cross", 580, 455, "NO");
	            }
	            else {
	                alert("<spring:message code='ezApproval.t685'/>");
	            }
	        }
	
	        function btnUpdate_onclick_Complete(retVal) {
	            if (retVal == "TRUE")
	                getContInfo(retVal[3]);
	        }
	
	        var mconttype_dialogArguments = new Array();
	        function btnDocTypeReg_onclick() {
	            var para = new Array();
	            if (CompanyID == "") {
	                alert("<spring:message code='ezApproval.t683'/>");
	            }
	            else {
	                para["P_companyID"] = CompanyID;
	                mconttype_dialogArguments[0] = para;
	                var result = GetOpenWindow("/admin/ezApproval/MContType.do", "MContType_Cross", 290, 400, "NO");
	            }
	        }
	        
	        var minsconttype_dialogArguments = new Array();
	        function btnContTypeReg_onclick() {
	            var para = new Array();
	            if (CompanyID == "") {
	                alert("<spring:message code='ezApproval.t683'/>");
	            }
	            else {
	                para["P_companyID"] = CompanyID;
	                minsconttype_dialogArguments[0] = para;
	                var result = GetOpenWindow("/admin/ezApproval/MinsContType.do", "MinsContType_Cross", 590, 430, "NO");
	            }
	        }
	
	        function btnClose_onclick() {
	            window.close();
	        }
	
	
	        function btnSpecial_onclick() {
	
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            var nodeIdx = treeView.GetSelectNode();
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(nodeIdx.NodeID);
	
	            if (CompanyID == "") {
	                alert("<spring:message code='ezApproval.t683'/>");
	                return;
	            }
	
	            if (nodeIdx != "") {
	                var url = "manageSpecialCont.do?deptID=" + escape(treeNode.GetNodeData("CN")) + "&companyID=" + escape(treeNode.GetNodeData("EXTENSIONATTRIBUTE2")) + "&deptName=" + escape(treeNode.GetNodeData("VALUE"));
	                var result = GetOpenWindow(url, "ManageSpecialCont", 540, 296, "NO");
	            }
	        }
	
	        function changeCompID() {
	            document.getElementById('TreeView').innerHTML = "";
	            TreeViewinitialize("", document.getElementById("ListCompany").value, "extensionAttribute2;extensionAttribute3", "${serverName}");
	            document.getElementById('lvtForm').innerHTML = "";
	            listview.LoadFromID("lvtDocForm");
	            listview.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));
	            listview.DataBind("lvtForm");
	        }
	    </script>
	</head>
	<body class="mainbody">
		<xml id='FORMLIST' style="display: none">
		    <LISTVIEWDATA>
		    <HEADERS>
			    <HEADER>
				    <NAME><spring:message code='ezApproval.t611'/></NAME>
				    <WIDTH>215</WIDTH>
			    </HEADER>
		    </HEADERS>
		    </LISTVIEWDATA>
		</xml>
	    <h1><spring:message code='ezApproval.t686'/></h1>
	    <span><b><spring:message code='ezApproval.t378'/></b>
               <select id="ListCompany" name="ListCompany" onchange="return changeCompID()">
      				${companySel}
  				</select>
       	</span>
	    <table class="table_manage">
	        <tr>
	            <td>
	                <h2><spring:message code='ezApproval.t173'/></h2>
	            </td>
	            <td style="padding-left: 5px; padding-right: 5px">
	                <h2><spring:message code='ezApproval.t325'/></h2>
	            </td>
	            <td>&nbsp;</td>
	        </tr>
	        <tr>
	            <td>
	                <div style="BORDER: #b6b6b6 1px solid; OVERFLOW-Y: auto; OVERFLOW-X: auto; WIDTH: 300px; HEIGHT: 400px; BACKGROUND-COLOR: #ffffff" id="TreeView" onnodedblclick="TreeView.toggle(TreeView.selectedIndex)"></div>
	            </td>
	            <td style="padding-left: 5px; padding-right: 5px">
	
	                <div class="listview">
	                    <div id="lvtForm" style="BORDER: 0; WIDTH: 300px; HEIGHT: 400px; overflow-x: hidden; overflow-y: auto" onselchanged="lvtForm_onSel_Changed()" onrowclick="lvtForm_onSel_Click()" onselclick="lvtForm_onSel_Click()" onseldblclick="lvtForm_onSel_DBclick()" onrowdblclick="lvtForm_onSel_DBclick()" onclick="lvtForm_onclick()"></div>
	                </div>
	            </td>
	            <th><a class="imgbtn"><span onclick="return btnDocTypeReg_onclick()"><spring:message code='ezApproval.t687'/></span></a><br>
	                <a class="imgbtn"><span onclick="return btnContTypeReg_onclick()"><spring:message code='ezApproval.t688'/></span></a><br>
	                <a class="imgbtn"><span onclick="return btnIns_onclick()"><spring:message code='ezApproval.t193'/></span></a><br>
	                <a class="imgbtn"><span onclick="return btnUpdate_onclick()"><spring:message code='ezApproval.t274'/></span></a><br>
	                <a class="imgbtn"><span onclick="return btnDel_onclick()"><spring:message code='ezApproval.t194'/></span></a><br>
	                <a class="imgbtn"><span onclick="return btnSpecial_onclick()"><spring:message code='ezApproval.t689'/></span></a> </th>
	        </tr>
	    </table>
	</body>
</html>