<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Insert title here</title>
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<link rel="stylesheet" href="/css/Tab.css" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TreeView.js"></script>
<!-- 		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script> -->

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
		    	var treeView = new TreeView();
		    	treeView.SetConfig(loadXMLFile("/xml/organtree_config2.xml"));
		    }
	
		    function InitFormCont() {
		    	var xmlRtn = createXmlDom();
		    	var xmlTree = createXmlDom();
		    	
		    	xmlTree = loadXMLString(FORMCONTAINER.innerHTML.toUpperCase());
		    	
		    	$.ajax({
		    		type : "POST",
		    		url : "/admin/ezApprovalG/getFormContInfo.do",
		    		async : false,
		    		dataType : "json",
		    		data : {id : 'ROOT', companyID : companyID},
		    		success : function (result) {
		    			xmlRtn = loadXMLString(result["resultXML"]);
		    		}
		        })
		        
		        if (xmlRtn != null) {
		            if (CrossYN()) {
		            	
		                xmlTree.documentElement.getElementsByTagName("NODE")[0].appendChild(xmlRtn.documentElement);
		            }
		            else {
		            	GetChildNodes(GetChildNodes(xmlTree)[0])[0].appendChild(xmlRtn.documentElement);
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
		        var xmlRtn = createXmlDom();
	
		        $.ajax({
		    		type : "POST",
		    		url : "/admin/ezApprovalG/getFormContInfo.do",
		    		async : false,
		    		dataType : "json",
		    		data : {id : ID, companyID : companyID},
		    		success : function (result) {
		    			xmlRtn = loadXMLString(result["resultXML"]);
		    		}
		        })
	
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
		        treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
		    }
	
		    function Move_onclick() {
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
	
		        var selectedNode = treeView.GetSelectNodeID();
	
		        var SelContID = document.getElementById(selectedNode).getAttribute("DATA1");
	
		        if (SelContID == undefined)
		            SelContID = "";
	
		        if (ContID == SelContID) {
		            alert("<spring:message code = 'ezApprovalG.t25002' />" + " " + "<spring:message code = 'ezApprovalG.t1392' />");
		            return;
		        }
	
		        var xmlpara = createXmlDom();
		        var xmlhttp = createXMLHttpRequest();
		        var objNode;
		        
		        $.ajax({
		        	type : "POST",
		        	dataType : "json",
		        	async : false,
		        	url : "/admin/ezApprovalG/formMove.do",
		        	data : {
		        		companyID : companyID,
		        		contID : ContID,
		        		selContID : SelContID,
		        		formID : FormID
		        	},
		        	success : function (result) {
		        		if (result["result"] == "OK") {
		        			alert("<spring:message code = 'ezApprovalG.t25003' />");
		        			
			                Rtnval[0] = "OK";
			                window.returnValue = Rtnval;
		        		} else {
		        			alert(strLang131);
		        		}
		        		
		        		window.close();
		        	}
		        })
		    }
		</script>
	</head>
	<body class="popup">
		<xml id='FORMCONTAINER' style="display:none">
			<TREEVIEWDATA>
				<NODE>
					<EXPANDED>TRUE</EXPANDED>
					<ISLEAF>FALSE</ISLEAF>
					<VALUE><spring:message code = 'ezApprovalG.t1539' /></VALUE>
				</NODE>
			</TREEVIEWDATA>
		</xml>
		
		<h1><spring:message code = 'ezApprovalG.t25001' /></h1>
		<table style="margin-top: 5px;">
			<tr>
				<td style="width: 400px; vertical-align: top">
					<div id="divFromTreeView" style="vertical-align: top; padding-top: 5px; height: 480px; width: 100%; overflow-x: auto; overflow-y: auto; BORDER: #b6b6b6 1px solid; BACKGROUND-COLOR: #ffffff"></div>
				</td>
			</tr>
			<tr>
				<td style="padding-left: 5px; padding-right: 5px; padding-top: 5px; vertical-align: top; text-align: center">
					<a class="imgbtn"><span onclick="return Move_onclick()"><spring:message code = 'ezApprovalG.t948' /></span></a>
					<a class="imgbtn"><span onclick="window.close()"><spring:message code = 'ezApprovalG.t119' /></span></a>
				</td>
			</tr>
		</table>
	</body>
</html>