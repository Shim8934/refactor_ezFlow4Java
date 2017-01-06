<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<html>
	<head>
		<title><spring:message code='ezApproval.t25001'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="/css/Tab.css" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApproval.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApproval/control_Cross/TreeView.js" ></script>
		<script type="text/javascript">
		    var ContID = "";
		    var FormID = "";
		    var companyID = "";
		    var xmlhttp = createXMLHttpRequest();
		    var xmldoc = createXmlDom();
		    var Rtnval = new Array();
		    window.onload = function () {
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
		
		         ContID = RetValue[0];
		         FormID = RetValue[1];
		         companyID = RetValue[2];
		         Tree_setconfig();
		
		        InitFormCont();
		
		        Rtnval[0] = "cancel";
		        Rtnval[1] = "cancel";
		        window.returnValue = Rtnval;
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
		
		    function InitFormCont() {
		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/getFormContInfo.do",
		    		data : {
		    			id         : "ROOT",
		    			companyID  : companyID
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
		    	
		        var xmlTree = createXmlDom();
		        xmlTree = loadXMLString(FORMCONTAINER.innerHTML.toUpperCase());
		
		        if (result != null) {
		            if (CrossYN()) {
		                var xmlRtn = loadXMLString(result).documentElement;
		                var Node = xmlTree.importNode(xmlRtn, true);
		                xmlTree.documentElement.getElementsByTagName("NODE")[0].appendChild(Node);
		            }
		            else {
		                var xmlRtn = loadXMLString(result).documentElement;
		                xmlTree.childNodes[0].childNodes[0].appendChild(xmlRtn);
		            }
		        }
		
		        document.getElementById('divFromTreeView').innerHTML = "";
		        var treeView = new TreeView();
		        treeView.SetID("FromTreeView");
		        treeView.SetUseAgency(true);
		        treeView.SetRequestData("TreeViewRequestData");
		        treeView.SetNodeClick("TreeViewNodeClick");
		        treeView.DataSource(xmlTree);
		        treeView.DataBind("divFromTreeView");
		    }
		
		    function TreeViewNodeClick(pNodeID, pNodeNM) {
		    }
		
		    var nodeIdx;
		    function TreeViewRequestData(pNodeID, pTreeID) {
		        TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        ID = treeNode.GetNodeData("DATA1");
		        DeptID = treeNode.GetNodeData("DATA2");
		
		        if (TreeIdx != "") {
		            GetFormContInfo(ID, DeptID, "REQUEST")
		        }
		    }
		
		    function GetFormContInfo(ID, DeptID, eventflag) {
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
		
		        if (SelectNodes(xmlRtn, "NODES/NODE/SELECT").length > 0) {
		            if (CrossYN()) {
		                xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].removeChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("SELECT")[0]);
		            }
		            else {
		                xmlRtn.selectNodes("NODES/NODE")[0].removeChild(xmlRtn.selectNodes("NODES/NODE/SELECT")[0]);
		            }
		        }
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx)
		    }
		
		    function Move_onclick() {
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		
		        var selectedNode = treeView.GetSelectNodeID();
		
		        var SelContID = document.getElementById(selectedNode).getAttribute("DATA1");
		
		        if (SelContID == undefined)
		            SelContID = "";
		
		        if (ContID == SelContID) {
		            alert("<spring:message code='ezApproval.t25002'/>" + " " + "<spring:message code='ezApproval.t25004'/>");
		            return;
		        }
		
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApproval/formMove.do",
		    		data : {
		    			contID     : ContID,
		    			formID     : FormID,
		    			selContID  : SelContID,
		    			companyID  : companyID
		    		},
		    		success: function(text){
		    			if (text == "OK") {
			                alert("<spring:message code='ezApproval.t25003'/>");
			
			                Rtnval[0] = "OK";
			                window.returnValue = Rtnval;
			            } else {
			                alert(strLang131);
			            }
			                
		    			window.close();
		    		}
		    	});
		    }
		</script>
	</head>
	<body class="popup">
		<xml id='FORMCONTAINER' style="display:none">
		  <TREEVIEWDATA>
		    <NODE>
		      <EXPANDED>TRUE</EXPANDED>
		      <ISLEAF>FALSE</ISLEAF>
		      <VALUE><spring:message code='ezApproval.t602'/></VALUE>
		    </NODE>
		  </TREEVIEWDATA>
		</xml>
		<h1><spring:message code='ezApproval.t25001'/></h1>
	    <table style="margin-top: 5px;">
	        <tr>
	            <td style="width: 400px; vertical-align: top">
	                <div id="divFromTreeView" style="vertical-align: top; padding-top: 5px; height: 480px; width: 100%; overflow-x: auto; overflow-y: auto; BORDER: #b6b6b6 1px solid; BACKGROUND-COLOR: #ffffff"></div>
	            </td>
	        </tr>
	        <tr>
	            <td style="padding-left: 5px; padding-right: 5px; padding-top: 5px; vertical-align: top; text-align: center">
	                <a class="imgbtn"><span onclick="return Move_onclick()"><spring:message code='ezApproval.t25005'/></span></a>
	                <a class="imgbtn"><span onclick="window.close()"><spring:message code='ezApproval.t85'/></span></a>
	            </td>
	        </tr>
	    </table>
	</body>
</html>