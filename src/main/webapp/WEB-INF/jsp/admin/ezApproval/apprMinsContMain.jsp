<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title>${title}</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/TreeView.js" ></script>
		<script type="text/javascript" src="/js/ezApproval/control_Cross/ListView_list.js" ></script>
	    <script type="text/javascript" src="/js/ezApproval/TreeViewCtrl_Cross.js"></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var labelcolor = "gray"
	        var xmlhttp = createXMLHttpRequest();
	        var xmlHTTP = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var gState, gDeptID;
	        var P_companyID;
	        var DeptID;
	        var ReturnFunction;
	
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	
	        window.onload = function () {
	            try {
	                dialogArguments = opener.minscontmain_dialogArguments[0];
	                ReturnFunction = opener.minscontmain_dialogArguments[1];
	            } catch (e) { }
	
	            var Para = dialogArguments;
	            gState = Para[0];
	            gDeptID = Para[1];
	            P_companyID = Para[2];
	            DeptID = Para[3];
	
	            if (gState == "U") {
	                P_companyID = Para[4];
	                DeptID = Para[5];
	            }
	            Tree_setconfig();
	
	            TreeViewinitialize("", "${userInfo.companyID}", "extensionAttribute2;extensionAttribute3", "${serverName}");
	            getDocType();
	            if (gState == "U") {
	                initVal(Para);
	            }
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
	
	        function getDocType() {
	            var xmlRtn = createXmlDom();
	            
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/MLgetDoctype.do",
		    		data : {
		    			comID  : P_companyID
		    		},
		    		success: function(xml){
		    			xmlRtn = loadXMLString(xml);
		    		}
		    	});
		    	
	            var Cnt, oOption
	            
	            for (Cnt = 0; Cnt < xmlRtn.getElementsByTagName("VALUE").length ; Cnt++) {
	                Add_ContType(xmlRtn.getElementsByTagName("VALUE")[Cnt].childNodes[0].nodeValue, xmlRtn.getElementsByTagName("DATA1")[Cnt].childNodes[0].nodeValue);
	            }
	        }
	
	        function Add_ContType(Name, ID) {
	            var oOption = document.createElement("OPTION");
	            setNodeText(oOption, Name);
	            oOption.value = ID
	
	            var sOption = document.getElementById("selContName");
	
	            if (CrossYN())
	                sOption.add(oOption, null);
	            else
	                sOption.add(oOption);
	
	            oOption = null;
	        }
	
	        function initVal(Para) {
	            document.getElementsByName("tbContID")[0].value = Para[1];
	            document.getElementById("selContName").value = Para[2];
	            gDeptID = Para[3];
	            
	            var xmlRtn = createXmlDom();
	            
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/MgetContGroup.do",
		    		data : {
		    			comID  : P_companyID,
		    			contID : Para[1]
		    		},
		    		success: function(xml){
		    			xmlRtn = loadXMLString(xml);
		    		}
		    	});
		    	
	            var objNode = xmlRtn.documentElement.childNodes;
	            if (SelectSingleNodeValueNew(xmlRtn, "PARAMETER/ID0") != "FALSE") {
	                document.getElementsByName("chkUseDept")[0].checked = true;
	                chkUseDept_onclick();
	
	                for (Cnt = 0; Cnt < objNode.length / 2 ; Cnt++) {
	                    if (SelectSingleNodeValueNew(xmlRtn, "PARAMETER/NAME" + Cnt) == "")
	                        break;
	
	                    Add_Group(SelectSingleNodeValueNew(xmlRtn, "PARAMETER/NAME" + Cnt), SelectSingleNodeValueNew(xmlRtn, "PARAMETER/ID" + Cnt));
	                }
	            }
	        }
	
	        function Add_Group(Name, ID) {
	            var oOption = document.createElement("OPTION");
	            setNodeText(oOption,Name);
	            oOption.value = ID;
	            sOption = document.getElementById("selUseDept");
	            if (CrossYN())
	                sOption.add(oOption, null);
	            else
	                sOption.add(oOption);
	
	            oOption = null;
	        }
	
	        function insCont(state) {
	        	var selUseDept = "";
	        	
	            if (state == "G") {
	                var Count = document.getElementById("selUseDept").length;
	
	                for (i = 0; i < Count; i++) {
	                	if (i == 0) {
		                	selUseDept += document.getElementById("selUseDept").item(i).value;
	                	} else {
		                	selUseDept += "," + document.getElementById("selUseDept").item(i).value;
	                	}
	                }
	            }
	            
	        	var result = "";

	            $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/MinsCont.do",
		    		data : {
		    			comID  : P_companyID,
		    			contType : document.getElementById("selContName").value,
		    			contOwnDeptID : gDeptID,
		    			selUseDept : selUseDept
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
	
	            if (result.indexOf("FALSE") > -1) {
	                return false;
	            } else {
	                return true;
	            }
	        }
	
	        function UpdateCont(state) {
	            if (state == "G") {
	                var Count = document.getElementById("selUseDept").length;
	
	                for (i = 0; i < Count; i++) {
	                	if (i == 0) {
		                	selUseDept += document.getElementById("selUseDept").item(i).value;
	                	} else {
		                	selUseDept += "," + document.getElementById("selUseDept").item(i).value;
	                	}
	                }
	            }
	            
	        	var result = "";
	        	
	            $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/MupdateCont.do",
		    		data : {
		    			comID  : P_companyID,
		    			contID : document.getElementsByName("tbContID")[0].value,
		    			contType : document.getElementById("selContName").value,
		    			contOwnDeptID : gDeptID,
		    			selUseDept : selUseDept
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
	
	            if (result.indexOf("FALSE") > -1) {
	                return false;
	            } else {
	                return true;
	            }
	        }
	
	        function chkUseDept_onclick() {
	            if (document.getElementsByName("chkUseDept")[0].checked) {
	                document.getElementById("btnAppdept").style.display = "";
	                document.getElementById("btnDeldept").style.display = "";
	                document.getElementsByName("selUseDept")[0].disabled = false;
	            }
	            else {
	                document.getElementById("btnAppdept").style.display = "none";
	                document.getElementById("btnDeldept").style.display = "none";
	                document.getElementsByName("selUseDept")[0].disabled = true;
	            }
	        }
	
	        function btnAppdept_onclick() {
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            var nodeIdx = treeView.GetSelectNode();
	
	            var selDeptID, selDeptName
	            var oOption = document.createElement("OPTION");
	            var selnode = treeView.GetSelectNode();
	            if (selnode) {
	                var treeNode = new TreeNode();
	                treeNode.LoadFromID(nodeIdx.NodeID);
	
	                selDeptName = treeNode.GetNodeData("VALUE");
	                selDeptID = treeNode.GetNodeData("CN");
	
	                setNodeText(oOption,selDeptName);
	                oOption.value = selDeptID;
	
	                if (document.getElementById("selUseDept").length > 0) {
	                    for (var i = 0 ; i < document.getElementById("selUseDept").length ; i++) {
	                        if (document.getElementById("selUseDept").item(i).value == oOption.value) {
	                            alert("<spring:message code='ezApproval.t735'/>");
	                            return;
	                        }
	                    }
	                }
	                if (CrossYN())
	                    document.getElementsByName("selUseDept")[0].add(oOption, null);
	                else
	                    document.getElementsByName("selUseDept")[0].add(oOption);
	
	            }
	            else {
	                alert("<spring:message code='ezApproval.t736'/>");
	            }
	        }
	
	        function btncancel_onclick() {
	            if(ReturnFunction != null)
	                ReturnFunction("FALSE");
	            window.close();
	        }
	
	        function btnDeldept_onclick() {
	            var index;
	            index = document.getElementById("selUseDept").selectedIndex;
	            if (index != -1)
	                document.getElementById("selUseDept").remove(index);
	            else
	                alert("<spring:message code='ezApproval.t737'/>");
	        }
	
	        function btnOk_onclick() {
	            var rtnVal, itmeCnt;
	
	            if (gState == "I") {
	                if (document.getElementsByName("chkUseDept")[0].checked) {
	                    itemCnt = document.getElementById("selUseDept").length;
	                    if (itemCnt > 0) {
	                        rtnVal = insCont("G");
	                    }
	                    else
	                        window.alert("<spring:message code='ezApproval.t738'/>");
	                }
	                else {
	                    rtnVal = insCont("N");
	                }
	            }
	            else {
	                if (document.getElementsByName("chkUseDept")[0].checked) {
	                    itemCnt = document.getElementById("selUseDept").length;
	                    if (itemCnt > 0) {
	                        rtnVal = UpdateCont("G");
	                    }
	                    else
	                        window.alert("<spring:message code='ezApproval.t738'/>");
	                }
	                else {
	                    rtnVal = UpdateCont("N");
	                }
	            }
	            if (typeof (rtnVal) != "undefined") {
	                if (rtnVal) {
	                    if(ReturnFunction != null)
	                        ReturnFunction("TRUE");
	                    window.close();
	
	                }
	                else {
	                    if (ReturnFunction != null)
	                        ReturnFunction("FALSE");
	                    window.close();
	                }
	            }
	            else {
	                if (ReturnFunction != null)
	                    ReturnFunction("FALSE");
	                window.close();
	            }
	        }
	
	        function TreeViewNodeClick() {
	        }
	        function TreeViewNodeDbClick() {
	        }
	
	        window.oncontextmenu = function () {
	            return false;
	        }
	    </script>
	</head>
	<body class="popup">
	    <h1>${title}</h1>
	    <table class="content">
	        <tr>
	            <th><spring:message code='ezApproval.t611'/></th>
	            <td>
	                <select id="selContName" name="selContName" style="WIDTH: 150px">
	                </select>
	                <input type="hidden" name="tbContID">
	            </td>
	        </tr>
	    </table>
	    <table style="margin-top: 10px">
	        <tr>
	            <td colspan="3">
	                <input type="checkbox" name="chkUseDept" value="checkbox" onclick="return chkUseDept_onclick()">
	                <spring:message code='ezApproval.t739'/></td>
	        </tr>
	        <tr>
	            <td style="vertical-align: top">
	                <div style="BORDER: #b6b6b6 1px solid; OVERFLOW-Y: auto; OVERFLOW-X: hidden; BEHAVIOR: url(/myoffice/common/organtreeview.htc); WIDTH: 260px; HEIGHT: 230px; BACKGROUND-COLOR: #ffffff" id="TreeView" onrequestdata="RequestData()" onnodeselect="TreeViewNodeClick()" onnodedblclick="TreeView.toggle(TreeView.selectedIndex)"></div>
	            </td>
	            <td style="width: 68px; text-align: center; white-space: nowrap;">
	                <a class="imgbtn" id="btnAppdept" onclick="btnAppdept_onclick()" style="display: none"><span><spring:message code='ezApproval.t678'/></span></a>
	                <br>
	                <a class="imgbtn" id="btnDeldept" onclick="btnDeldept_onclick()" style="display: none"><span><spring:message code='ezApproval.t679'/></span></a>
	                <br>
	            </td>
	            <td style="vertical-align: top">
	                <select id="selUseDept" name="selUseDept" style="WIDTH: 234px; HEIGHT: 235px" disabled size="2"></select>
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition">
	        <a class="imgbtn" onclick="btnOk_onclick()"><span><spring:message code='ezApproval.t84'/></span></a>
	        <a class="imgbtn" onclick="btncancel_onclick()"><span><spring:message code='ezApproval.t85'/></span></a>
	    </div>
	</body>
</html>