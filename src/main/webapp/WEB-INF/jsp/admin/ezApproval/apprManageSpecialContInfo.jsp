<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t650'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezApproval.e1'/>"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/TreeView.js" ></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/ListView_list.js" ></script>
	    <script type="text/javascript" src="/js/ezApproval/TreeViewCtrl_Cross.js"></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var pDeptID = "${deptID}";
	        var pContType = "${contType}";
	        var pSN = "${sn}";
	        var pCompanyID = "${companyID}";
	        var pInfoXML = "${infoXML}";
	        var labelcolor = "c6c6c6";
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var TreeIdx;
	        var ListIdx;
	        var ReturnFunction;
	
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	
	        window.onload = function () {
                ReturnFunction = opener.managespecialcontinfo_dialogArguments[1];
	
                var ua = navigator.userAgent;
                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
                    var input = document.getElementsByTagName("input");
                    for (var i = 0; i < input.length; i++) {
                        if (GetAttribute(input[i], "type") == "text")
                            KeEventControl(input[i]);
                    }
                }
	
	            InitFormCont();
	
	            if (pInfoXML != "") {
	                document.getElementById("selContType").disabled = true;
	                var xmlRtn = createXmlDom();
	                xmlRtn = loadXMLString(pInfoXML);
	
	                tbSpecialContName.value = getNodeText(SelectNodes(xmlRtn, "CONTNAME")[0]);
	                if (getNodeText(SelectNodes(xmlRtn, "CONTYN")[0]) == "Y")
	                    document.getElementById("rdSel1").checked = true;
	                else
	                    document.getElementById("rdSel2").checked = true;
	
	                for (i = 0; i < SelectNodes(xmlRtn, "FORMID").length; i++) {
	                    var FormIDInfo = getNodeText(SelectNodes(xmlRtn, "FORMID")[i]);
	                    var FormID = FormIDInfo.split(";");
	
	                    var oOption = document.createElement("OPTION");
	                    setNodeText(oOption,FormID[1]);
	                    oOption.value = FormID[0];
	                    if (CrossYN()) {
	                        document.getElementById("lvtSelected").appendChild(oOption);
	                    }
	                    else {
	                        document.getElementById("lvtSelected").add(oOption);
	                    }
	                }
	            }
	            else
	                document.getElementById("selContType").disabled = false;
	        }
	
	        function lvtForm_ondbllick() {
	            btnUseDept_onclick();
	        }
	
	        function InitFormCont() {
	            var xmlpara = createXmlDom();
	            var xmlRtn = createXmlDom();
	            var xmlTree = createXmlDom();
	
	            xmlTree = loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase());
	            var listview = new ListView();
	            listview.SetID("lvt_Form");
	            listview.SetMulSelectable(false);
	            listview.SetRowOnDblClick("lvtForm_ondbllick");
	            document.getElementById('lvtForm').innerHTML = "";
	            listview.DataSource(xmlTree);
	            listview.DataBind("lvtForm");
	
	            var result = "";
	            
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/getFormContInfo.do",
		    		data : {
		    			id : "ROOT",
		    			companyID  : pCompanyID
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
	
	            xmlTree = loadXMLString(document.getElementById("FORMCONTAINER").innerHTML.toUpperCase());
	            if (result != "") {
	                var xmlRtn = loadXMLString(result).documentElement;
	                GetChildNodes(GetChildNodes(xmlTree)[0])[0].appendChild(xmlRtn);
	            }
	
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
	            xmlHTTP.send();
	
	            if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
	                var treeView = new TreeView();
	                treeView.SetID("DeptTreeView");
	                treeView.SetConfig(loadXMLString(xmlHTTP.responseText));
	                treeView.SetUseAgency(true);
	                treeView.SetRequestData("TreeViewRequestData");
	                treeView.SetNodeClick("TreeViewNodeClick");
	                treeView.DataSource(xmlTree);
	                document.getElementById('TreeView').innerHTML = "";
	                treeView.DataBind("TreeView");
	                treeview = null;
	            }
	        }
	
	        var nodeIdx;
	        function TreeViewRequestData(pNodeID, pTreeID) {
	            TreeIdx = pNodeID;
	
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	            var ID = treeNode.GetNodeData("DATA1");
	            var DeptID = treeNode.GetNodeData("DATA2");
	            if (TreeIdx != "") {
	                GetFormContInfo(ID, DeptID);
	            }
	            GetFormInfo(ID, "A01000");
	            treeview = null;
	        }
	
	        function TreeViewNodeClick(pNodeID) {
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	            ID = treeNode.GetNodeData("DATA1");
	            GetFormInfo(ID, "A01000");
	            treeNode = null;
	        }
	
	        function TreeViewNodeClick(pNodeID, pNodeNM) {
	            TreeIdx = pNodeID;
	
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	
	            var ID = treeNode.GetNodeData("DATA1");
	            GetFormInfo(ID, "A01000");
	        }
	
	        function GetFormContInfo(ID, NodeIdx) {
	            var xmlRtn = createXmlDom();
	            
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/getFormContInfo.do",
		    		data : {
		    			id : ID,
		    			companyID  : pCompanyID
		    		},
		    		success: function(text){
			            xmlRtn = loadXMLString(text);
		    		}
		    	});
	
	            if (SelectNodes(xmlRtn, "NODES/NODE/SELECT").length > 0) {
	                if (CrossYN()) {
	                    xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].removeChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("SELECT")[0]);
	                }
	                else {
	                    xmlRtn.selectNodes("NODES/NODE")[0].removeChild(xmlRtn.selectNodes("NODES/NODE/SELECT")[0]);
	                }
	            }
	
	            var treeView = new TreeView();
	            treeView.LoadFromID("DeptTreeView");
	            treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
	        }
	
	        function GetFormInfo(ID, KIND) {
	            var xmlRtn = createXmlDom();
	            
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/MgetForm.do",
		    		data : {
		    			formContID : ID,
		    			formKind   : KIND,
		    			companyID  : pCompanyID
		    		},
		    		success: function(text){
			            xmlRtn = loadXMLString(text);
		    		}
		    	});
	
	            document.getElementById('lvtForm').innerHTML = "";
	
	            var listview = new ListView();
	            listview.SetID("lvt_Form");
	            listview.SetMulSelectable(false);
	            listview.DataSource(xmlRtn);
	            listview.DataBind("lvtForm");
	        }
	
	        function lvtForm_onSel_DBclick() {
	        }
	
	        function trim(parm_str) {
	            return rtrim(ltrim(parm_str));
	        }
	
	        function ltrim(parm_str) {
	            str_temp = parm_str;
	            while (str_temp.length != 0) {
	                if (str_temp.substring(0, 1) == " ") {
	                    str_temp = str_temp.substring(1, str_temp.length);
	                } else {
	                    return str_temp;
	                }
	            }
	            return str_temp;
	        }
	
	        function rtrim(parm_str) {
	            str_temp = parm_str;
	            while (str_temp.length != 0) {
	                int_last_blnk_pos = str_temp.lastIndexOf(" ");
	                if ((str_temp.length - 1) == int_last_blnk_pos) {
	                    str_temp = str_temp.substring(0, str_temp.length - 1);
	                } else {
	                    return str_temp;
	                }
	            }
	            return str_temp;
	        }
	
	        function btnOK_onclick() {
	            if (trim(document.getElementById("tbSpecialContName").value) == "") {
	                OpenAlertUI("<spring:message code='ezApproval.t661'/>");
	                return;
	            }
	
	            if (trim(document.getElementById("tbSpecialContName").value) != document.getElementById("tbSpecialContName").value.replace("\"", "")) {
	                OpenAlertUI("<spring:message code='ezApproval.t662'/><spring:message code='ezApproval.t663'/><br><spring:message code='ezApproval.t664'/>");
	                return;
	            }
	
	            if (document.getElementById("lvtSelected").length <= 0) {
	                OpenAlertUI("<spring:message code='ezApproval.t665'/>");
	                return;
	            }
	
	            var rtnVal = SaveSpecialContInfo();
	            if (rtnVal == "TRUE") {
	                if(ReturnFunction != null)
	                    ReturnFunction("OK");
	                window.close();
	            }
	            else {
	                OpenAlertUI("<spring:message code='ezApproval.t666'/>");
	            }
	        }
	
	        var ezapralert_cross_dialogArgument = new Array();
	        function OpenAlertUI(pAlertContent) {
	            var parameter = pAlertContent;
	            var url = "/admin/ezApproval/ezAprAlert.do";
	            ezapralert_cross_dialogArgument[0] = parameter;
	            var result = GetOpenWindow(url, "ezAPRALERT_Cross", 330, 205, "NO");
	        }
	
	        function SaveSpecialContInfo() {
	        	var pContYN = "";
	        	
	            if (document.getElementById("rdSel1").checked) {
	                pContYN = "Y";
	            } else {
	                pContYN = "N";
	            }
	            
	            var Count = document.getElementById("lvtSelected").length;
	            var formIDs = "";
	            for (var i = 0; i < Count; i++) {
	            	if (i == 0) {
		            	formIDs += document.getElementById("lvtSelected")[i].value;
	            	} else {
		            	formIDs += "," + document.getElementById("lvtSelected")[i].value;
	            	}
	            }
	            
	            var result = "";
	            
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/specialContAdd.do",
		    		data : {
		    			deptID   : pDeptID,
		    			contType : document.getElementById("selContType").value,
		    			sn       : pSN,
		    			contName : trim(document.getElementById("tbSpecialContName").value),
		    			contYN   : pContYN,
		    			formIDs  : formIDs,
		    			companyID  : pCompanyID
		    		},
		    		success: function(text){
			            result = text;
		    		}
		    	});
		    	
	            return getNodeText(GetChildNodes(loadXMLString(result))[0]);
	        }
	
	        function btnClose_onclick() {
	            if(ReturnFunction != null)
	                ReturnFunction("cancel");
	            window.close();
	        }
	
	        function btnUseDept_onclick() {
	            var listview = new ListView();
	            listview.LoadFromID("lvt_Form");
	            var selRow = listview.GetSelectedRows()[0];
	            if (selRow) {
	                var Count = document.getElementById("lvtSelected").length;
	                var FormID = trim_Cross(GetAttribute(selRow, "DATA1"));
	
	                var DuplicateFlag = true;
	                for (i = 0; i < Count; i++) {
	                    var ParaValue = document.getElementById("lvtSelected").item(i);
	                    if (ParaValue.value == FormID)
	                        DuplicateFlag = false;
	                }
	
	                if (DuplicateFlag) {
	                    var oOption = document.createElement("OPTION");
	                    setNodeText(oOption,getNodeText(selRow));
	                    oOption.value = trim_Cross(GetAttribute(selRow, "DATA1"));
	
	                    if (CrossYN()) {
	                        document.getElementById("lvtSelected").appendChild(oOption);
	                    }
	                    else {
	                        document.getElementById("lvtSelected").add(oOption);
	                    }
	                }
	                else {
	                    OpenAlertUI("<spring:message code='ezApproval.t667'/>");
	                }
	            }
	        }
	
	        function btnDelDept_onclick() {
	            var index;
	            index = document.getElementById("lvtSelected").selectedIndex;
	            if (index != -1)
	                document.getElementById("lvtSelected").remove(index);
	            else
	                OpenAlertUI("<spring:message code='ezApproval.t668'/>");
	        }
	    </script>
	</head>
	<body class="popup">
	    <xml id='FORMLIST' style="display: none">
	  <LISTVIEWDATA>
	    <HEADERS>
	      <HEADER>
	        <NAME><spring:message code='ezApproval.t601'/></NAME>
	        <WIDTH>170</WIDTH>
	        " </HEADER>
	    </HEADERS>
	  </LISTVIEWDATA>
	</xml>
	    <xml id='FORMCONTAINER' style="display: none">
	  <TREEVIEWDATA>
	    <NODE>
	      <EXPANDED>TRUE</EXPANDED>
	      <ISLEAF>FALSE</ISLEAF>
	      <VALUE><spring:message code='ezApproval.t602'/></VALUE>
	      <DATA1>ROOT</DATA1>
	    </NODE>
	  </TREEVIEWDATA>
	</xml>
	
	    <h1><spring:message code='ezApproval.t669'/></h1>
	
	    <table class="content">
	        <tr>
	            <th><spring:message code='ezApproval.t670'/></th>
	            <td>
	                <select name="selContType" id="selContType">
	                    ${codeXML}
	                </select></td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t671'/></th>
	            <td>
	                <input type="text" name="tbSpecialContName" id="tbSpecialContName" style="WIDTH: 400px">
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t672'/></th>
	            <td>
	                <input type="radio" name="rdSel" id="rdSel1" value="Y" checked>
	                <spring:message code='ezApproval.t673'/>
	                <spring:message code='ezApproval.t674'/>
	                <input type="radio" name="rdSel" id="rdSel2" value="N">
	                <spring:message code='ezApproval.t675'/>
	                <spring:message code='ezApproval.t676'/></td>
	        </tr>
	    </table>
	
	    <table style="margin-top: 10px">
	        <tr>
	            <td style="vertical-align: top">
	                <h2><spring:message code='ezApproval.t602'/></h2>
	                <div id="TreeView" style="height: 270px; width: 187px; overflow-x: auto; overflow-y: auto; BORDER: #b6b6b6 1px solid; BACKGROUND-COLOR: #ffffff; vertical-align: top"></div>
	            </td>
	            <td style="padding-left: 5px; vertical-align: top">
	                <h2><spring:message code='ezApproval.t677'/></h2>
	                <div class="listview" style="BORDER: 0; WIDTH: 177px; HEIGHT: 270px; overflow: auto">
	                    <div id="lvtForm" style="BORDER: 0; WIDTH: 175px; HEIGHT: 260px;" onrowdblclick="lvtForm_onSel_DBclick()"></div>
	                </div>
	            </td>
	            <td style="width: 50px; text-align: center">
	                <a id="btnUseDept" class="imgbtn" onclick="btnUseDept_onclick()"><span><spring:message code='ezApproval.t678'/></span></a>
	                <a id="btnDelDept" class="imgbtn" onclick="btnDelDept_onclick()"><span><spring:message code='ezApproval.t679'/></span></a>
	            </td>
	            <td style="vertical-align: top">
	                <h2><spring:message code='ezApproval.t680'/></h2>
	                <select name="lvtSelected" id="lvtSelected" style="BORDER: #c6c6c6 1px solid; WIDTH: 165px; HEIGHT: 270px" size="2">
	                </select>
	            </td>
	        </tr>
	    </table>
	
	    <div class="btnposition">
	        <a class="imgbtn" onclick="btnOK_onclick()"><span><spring:message code='ezApproval.t272'/></span></a>
	        <a class="imgbtn" onclick="btnClose_onclick()"><span><spring:message code='ezApproval.t273'/></span></a>
	    </div>
	</body>
</html>