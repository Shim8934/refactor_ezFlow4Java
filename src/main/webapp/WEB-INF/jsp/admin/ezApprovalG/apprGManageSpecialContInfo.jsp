<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t650'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/control_Cross/TreeView.js')}" ></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/control_Cross/ListView_list.js')}" ></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeViewCtrl_Cross.js')}"></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var pDeptID = "<c:out value='${deptID}'/>";
	        var pContType = "<c:out value='${contType}'/>";
	        var pSN = "<c:out value='${sn}'/>";
	        var pCompanyID = "<c:out value='${companyID}'/>";
	        var pInfoXML = "<c:out value='${infoXML}'/>";
	        var labelcolor = "c6c6c6";
	        var xmlhttp = createXMLHttpRequest();
	        var xmlDoc = createXmlDom();
	        var TreeIdx;
	        var ListIdx;
	        var ReturnFunction;
	
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	
	        window.onload = function () {
	        	try {
	                ReturnFunction = parent.managespecialcontinfo_dialogArguments[1];
	            } catch (e) {
	                try {
	                    ReturnFunction = opener.managespecialcontinfo_dialogArguments[1];
	                } catch (e) {
	                    RetValue = window.dialogArguments;
	                }
	            }
	            
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
		    		dataType : "json",
		    		async : false,
		    		url : "/admin/ezApprovalG/getFormContInfo.do",
		    		data : {
		    			id : "ROOT",
		    			companyID  : pCompanyID
		    		},
		    		success: function(result){
		    			result = result.resultXML;
		    		}
		    	});
	
	            xmlTree = loadXMLString(document.getElementById("FORMCONTAINER").innerHTML.toUpperCase());
	            if (result != "") {
	                var xmlRtn = loadXMLString(result).documentElement;
	                GetChildNodes(GetChildNodes(xmlTree)[0])[0].appendChild(xmlRtn);
	            }
	            
	            var xmlDom = createXmlDom();
	            xmlDom = loadXMLFile("/xml/organtree_config2.xml");
	
                var treeView = new TreeView();
                treeView.SetID("DeptTreeView");
                treeView.SetConfig(xmlDom);
                treeView.SetUseAgency(true);
                treeView.SetRequestData("TreeViewRequestData");
                treeView.SetNodeClick("TreeViewNodeClick");
                treeView.DataSource(xmlTree);
                document.getElementById('TreeView').innerHTML = "";
                treeView.DataBind("TreeView");
                treeview = null;
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
		    		dataType : "json",
		    		async : false,
		    		url : "/admin/ezApprovalG/getFormContInfo.do",
		    		data : {
		    			id : ID,
		    			companyID  : pCompanyID
		    		},
		    		success: function(result){
			            xmlRtn = loadXMLString(result.resultXML);
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
	        	
	        	if (KIND == "A01000") {
	            	KIND = "BASE";
	            }
	        	
	        	$.ajax({
	        		type : "POST",
	        		url : "/admin/ezApprovalG/getFormList.do",
	        		async : false,
	        		dataType : "json",
	        		data : {id : ID,
	        				kind : KIND,
	        				companyID : pCompanyID},
	        		success : function(result) {
	        			xmlRtn = loadXMLString(result.resultXML);
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
	                OpenAlertUI("<spring:message code='ezApprovalG.t1621'/>");
	                return;
	            }
	
	            var rtnVal = SaveSpecialContInfo();
	            
	            if (rtnVal == "TRUE") {
	                if(ReturnFunction != null) {
	                    ReturnFunction("OK");
	                }
	                
	                window.close();
	            }
	            else {
	                OpenAlertUI("<spring:message code='ezApprovalG.t1296'/>");
	            }
	        }
	        
	        var ezapralert_cross_dialogArguments = new Array();
	        function OpenAlertUI(pAlertContent) {
	            var parameter = pAlertContent;
	            var url = "/ezApprovalG/ezAprAlert.do";
	            ezapralert_cross_dialogArguments[0] = parameter;
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
	            
	            var resultVal = "";
	            
		    	$.ajax({
		    		type : "POST",
		    		dataType : "json",
		    		async : false,
		    		url : "/admin/ezApprovalG/specialContAdd.do",
		    		data : {
		    			deptID   : pDeptID,
		    			contType : document.getElementById("selContType").value,
		    			sn       : pSN,
		    			contName : trim(document.getElementById("tbSpecialContName").value),
		    			contYN   : pContYN,
		    			formIDs  : formIDs,
		    			companyID  : pCompanyID
		    		},
		    		success : function(result){
						resultVal = result.result;
		    		},
		    		error : function(jqXHR, textStatus, errorThrown) {
		    			resultVal = "FALSE";
		    		}
		    	});
		    	
	            return resultVal;
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
	                    OpenAlertUI("<spring:message code='ezApprovalG.t20001'/>");
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
						<NAME><spring:message code='ezApprovalG.t1537'/></NAME>
						<WIDTH>170</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
	    <xml id='FORMCONTAINER' style="display: none">
			<TREEVIEWDATA>
				<NODE>
					<EXPANDED>TRUE</EXPANDED>
					<ISLEAF>FALSE</ISLEAF>
					<VALUE><spring:message code='ezApprovalG.t1539'/></VALUE>
					<DATA1>ROOT</DATA1>
				</NODE>
			</TREEVIEWDATA>
		</xml>
	
	    <h1><spring:message code='ezApproval.t669'/></h1>
		<div id="close">
            <ul>
                <li><span onclick="btnClose_onclick()"></span></li>
            </ul>
        </div>
	    <table class="content">
	        <tr>
	            <th><spring:message code='ezApproval.t670'/></th>
	            <td>
	                <select name="selContType" id="selContType">
	                    ${codeXML}
	                </select>
				</td>
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
	                <spring:message code='ezApproval.t676'/>
				</td>
	        </tr>
	    </table>
	
	    <table style="margin-top: 10px">
	        <tr>
	            <td style="vertical-align: top">
	                <h2><spring:message code='ezApprovalG.t1539'/></h2>
	                <div id="TreeView" style="height: 270px; width: 187px; overflow-x: auto; overflow-y: auto; BORDER: #ddd 1px solid; BACKGROUND-COLOR: #ffffff; vertical-align: top"></div>
	            </td>
	            <td style="padding-left: 5px; vertical-align: top">
	                <h2><spring:message code='ezApproval.t677'/></h2>
	                <div class="listview" style="BORDER: 0; WIDTH: 177px; HEIGHT: 270px; overflow: auto">
	                    <div id="lvtForm" style="BORDER: 0; WIDTH: 175px; HEIGHT: 260px;" onrowdblclick="lvtForm_onSel_DBclick()"></div>
	                </div>
	            </td>
	            <td style="width: 50px; text-align: center">
	                <a id="btnUseDept" class="imgbtn" onclick="btnUseDept_onclick()"><span><spring:message code='ezApprovalG.t1649'/></span></a>
	                <a id="btnDelDept" class="imgbtn" onclick="btnDelDept_onclick()"><span><spring:message code='ezApprovalG.t1650'/></span></a>
	            </td>
	            <td style="vertical-align: top">
	                <h2><spring:message code='ezApproval.t680'/></h2>
	                <select name="lvtSelected" id="lvtSelected" style="BORDER: #c6c6c6 1px solid; WIDTH: 165px; HEIGHT: 270px" size="2">
	                </select>
	            </td>
	        </tr>
	    </table>
	
	    <div class="btnposition">
	        <a class="imgbtn" onclick="btnOK_onclick()"><span><spring:message code='ezApprovalG.t413'/></span></a>
	    </div>
	</body>
</html>