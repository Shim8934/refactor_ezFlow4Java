<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezApprovalG.KMHF05'/></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<style type="text/css">
			.tree_plus {margin-top: -3px !important;}
			.tree_minus {margin-top: 0px !important;}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeViewFolder.js')}"></script>
<%-- 		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script> --%>
		<script type="text/javascript">
			var ContID = "";
		    var parentContID = "";
		    var companyID = "";
		    var xmlhttp = createXMLHttpRequest();
		    var xmldoc = createXmlDom();
		    var Rtnval = new Array();
		    
		    window.onload = function () {
				try {
					RetValue = parent.fContMain_dialogArguments[0];
					ReturnFunction = parent.fContMain_dialogArguments[1];
				} catch (e) {
				    try {
				        RetValue = opener.fContMain_dialogArguments[0];
				        ReturnFunction = opener.fContMain_dialogArguments[1];
				    } catch (e) {
				    	RetValue = window.dialogArguments;
				    }
				}
				
				ContID = RetValue[0];
				parentContID = RetValue[1];
				companyID = RetValue[2];
				Tree_setconfig();
	
		        InitFormCont();
	
		        Rtnval[0] = "cancel";
		        Rtnval[1] = "cancel";
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
				
				if(selectedNode == "FromTreeView_0")
					SelContID = "ROOT";
				
		        if (ContID == SelContID) {
		            alert("<spring:message code = 'ezApprovalG.KMHF01' />");
		            return;
		        }

				if (parentContID == SelContID) {
					alert("<spring:message code = 'ezApprovalG.KMHF02' />");
					return;
				}
		        
		        $.ajax({
		        	type : "POST",
		        	dataType : "json",
		        	async : false,
		        	url : "/admin/ezApprovalG/contMove.do",
		        	data : {
		        		companyID : companyID,
		        		contID : ContID,
		        		selContID : SelContID,
						parentContID : parentContID
		        	},
		        	success : function (result) {
		        		if (result["result"] == "OK") {
							
			                Rtnval[0] = "OK";
			                
			                if (ReturnFunction != null) {
				                ReturnFunction(Rtnval);
			                } else {
				                window.returnValue = Rtnval;
			                }
							window.close();
		        		}  else if (result["result"] == "CHILD"){
							alert("<spring:message code = 'ezApprovalG.KMHF03' />");
						}  else {
		        			alert(strLang131);
							window.close();
		        		}
		        	},
		        	error : function () {
		        		alert(strLang131);
		        		
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
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<table style="margin-top: 5px;">
			<tr>
				<td style="width: 438px; vertical-align: top">
					<div id="divFromTreeView" style="vertical-align: top; padding-top: 5px; height: 480px; width: 100%; overflow-x: auto; overflow-y: auto; BORDER: #ddd 1px solid; BACKGROUND-COLOR: #ffffff"></div>
				</td>
			</tr>
			<tr>
				<td style="padding-left: 5px; padding-right: 5px; padding-top: 5px; vertical-align: top; text-align: center">
					<div class="btnpositionNew">
						<a class="imgbtn"><span onclick="return Move_onclick()"><spring:message code = 'ezApprovalG.t948' /></span></a>
					</div>	
				</td>
			</tr>
		</table>
	</body>
</html>