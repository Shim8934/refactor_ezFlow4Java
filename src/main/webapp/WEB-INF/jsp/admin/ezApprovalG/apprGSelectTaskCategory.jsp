<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t690' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e3'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TreeView.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var GValue, PCode, companyID = "";
	        var RetValue;
	        var ReturnFunction;
	        window.onload = function () {
	            try {
	                RetValue = parent.selecttaskcategory_cross_dialogArguments[0];
	                ReturnFunction = parent.selecttaskcategory_cross_dialogArguments[1];
	            } catch (e) {
	                try {
	                    RetValue = opener.selecttaskcategory_cross_dialogArguments[0];
	                    ReturnFunction = opener.selecttaskcategory_cross_dialogArguments[1];
	                } catch (e) {
	                    RetValue = window.dialogArguments;
	                }
	            }
	            GValue = RetValue[0];
	            PCode = RetValue[1];
	            companyID = RetValue[2];
	
	            if (GValue == "1") {
	                document.getElementById("tdCateType").innerText = "<spring:message code = 'ezApprovalG.t691' />";
	            } else if (GValue == "2") {
	            	document.getElementById("tdCateType").innerText = "<spring:message code = 'ezApprovalG.t692' />";
	            } else if (GValue == "3") {
	            	document.getElementById("tdCateType").innerText = "<spring:message code = 'ezApprovalG.t693' />";
	            }
	            
		        document.getElementById("tdPCode").innerText = PCode;
		        Tree_setconfig();
		        getGroupTree(1, 1, 0, true);
		    }
	        
			function Tree_setconfig() {
			    var xmlHTTP = createXMLHttpRequest();
			    xmlHTTP.open("GET", "/xml/ezApprovalG/conttree_config.xml", false);
			    xmlHTTP.send();
			
			    if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
			        var treeView = new TreeView();
			        treeView.SetConfig(xmlHTTP.responseXML);
			    }
			}
			
			function TreeView_onRequestData(pNodeID, pTreeID) {		
			    var treeview = new TreeView();
			    treeview.LoadFromID("FromTreeView");
			    node_select(pNodeID, "", pTreeID, TreeView_onNodeSelect);
			    nodeIdx = treeview.GetSelectNode();
			
			    var pLevel = nodeIdx.GetNodeData("DATA1");
			    var pGroupID = nodeIdx.GetNodeData("DATA2");
			
			    getGroupTree(nodeIdx, parseInt(pLevel) + 1, pGroupID, false);
			}
			
			function TreeView_onNodeSelect() {
			    var nodeIdx = TreeView.selectedIndex;
			    if (nodeIdx > 0) {
			        descript.innerText = TreeView.getvalue(nodeIdx, "DATA2");
			    }
			}
			
			function TreeView_onNodeSelect() {
			    var treeview = new TreeView();
			    treeview.LoadFromID("FromTreeView");
			    var nodedata = treeview.GetSelectNode();
			    var pGroupID = nodedata.GetNodeData("DATA2");
			    document.getElementById("descript").innerText = pGroupID;
			}
			
			function getGroupTree(pNodeIdx, pLevel, pGroupID, pFirst) {
			    try {
			        if (pLevel > 3) {
			            var treeView = new TreeView();
			            treeView.LoadFromID("FromTreeView");
			
			            treeView.AppendChildNodes("<NODES></NODES>", treeView.GetSelectNode().NodeID);
			
			            return;
			        }
			        
			        $.ajax({
						type : "POST",
			        	url : "/admin/ezApprovalG/getTaskCategoryTree.do",
			        	async : false,
			        	data : {categoryType : pLevel, parentID : pGroupID, companyID : companyID},
			        	success : function(result){
			        		xmlTree = loadXMLString(result);
			        		
			        		if (pFirst) {
					            var xmlDom2 = createXmlDom();
					
					            xmlDom2 = loadXMLString(document.getElementById("GROUP").innerHTML);
					
					            if (SelectNodes(xmlTree, "NODES/NODE/VALUE").length > 0) {
					                if (CrossYN()) {
					                    var xmlRtn = xmlTree.documentElement;
					                    var Node = xmlTree.importNode(xmlRtn, true);
					
					                    xmlDom2.documentElement.childNodes[1].appendChild(Node);
					                } else {
					                    var xmlRtn = xmlTree.documentElement;
					                    xmlDom2.childNodes[0].childNodes[0].appendChild(xmlRtn);
					                }
					            }
					            
					            document.getElementById('TreeView').innerHTML = "";
					            var treeView = new TreeView();
					            treeView.SetID("FromTreeView");
					            treeView.SetUseAgency(true);
					            treeView.SetRequestData("TreeView_onRequestData");
					            treeView.SetNodeClick("TreeView_onNodeSelect");
					            treeView.DataSource(xmlDom2);
					            treeView.DataBind("TreeView");
					        } else {
					            if (xmlTree.xml == "") return;
					
					            var treeView = new TreeView();
					            treeView.LoadFromID("FromTreeView");
					
					            treeView.AppendChildNodes(xmlTree.documentElement, treeView.GetSelectNode().NodeID)
					        }
			        	}
			        });
			    } catch (e) {
			        alert(e.description);
			    }
			}
			
			function btncancel_onclick() {
			    if(CrossYN()) {
			        ReturnFunction("CANCEL");
			    } else {
			        window.returnValue = "CANCEL";
			    }
			    window.close();
			}
			
			function btnOk_onclick() {
			    var treeview = new TreeView();
			    treeview.LoadFromID("FromTreeView");
			    var nodedata = treeview.GetSelectNode();
			    var pGroupID = nodedata.GetNodeData("DATA2");
			
			    if (nodedata) {
			        if (nodedata.GetNodeData("DATA1") == GValue) {
			            if (CrossYN()) {
			                ReturnFunction(nodedata.GetNodeData("DATA2"));
			            } else {
			                window.returnValue = nodedata.GetNodeData("DATA2");
			            }
			            window.close();
			        } else {
			            var pAlertContent = "<spring:message code = 'ezApprovalG.t694' />";
			          	//2016-07-15 이효진 OpenAlertUI화면 alert로 대체
// 			            OpenAlertUI(pAlertContent);
			            alert(pAlertContent);
			        }
		        } else {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t695' />";
		          	//2016-07-15 이효진 OpenAlertUI화면 alert로 대체
// 		            OpenAlertUI(pAlertContent);
		            alert(pAlertContent);
		        }
			}
	        
			var ezapralert_cross_dialogArguments = new Array();
		    function OpenAlertUI(pAlertContent) {
		        ezapralert_cross_dialogArguments[0] = pAlertContent;
		        ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
		        var ezAPRALERT_Cross = window.open("../../ezAPRALERT_Cross.aspx", "ezAPRALERT_Cross", GetOpenWindowfeature(330, 205));
		        try { ezAPRALERT_Cross.focus(); } catch (e) { }
		    }
			
		    function OpenAlertUI_Complete() {
		    }
		</script>
	</head>
	
	<body class="popup">
    	<xml id="GROUP" style="display: none">
			<TREEVIEWDATA>
				<NODE>
					<EXPANDED>TRUE</EXPANDED>
					<ISLEAF>FALSE</ISLEAF>
					<VALUE>/</VALUE>
					<DATA1>0</DATA1>
					<DATA2>ROOT</DATA2>
					<DATA3></DATA3>
					<DATA4>NULL</DATA4>
				</NODE>
			</TREEVIEWDATA>
		</xml>
	    <h1><spring:message code = 'ezApprovalG.t690' /></h1>
	    <h2 id="maintitle" style="height: 30px;"><span id="tdCateType" style="color: orange"></span></b><spring:message code = 'ezApprovalG.t696' /><br>
        <spring:message code = 'ezApprovalG.t697' />"<span id="tdPCode" style="color: orange"></span></b><spring:message code = 'ezApprovalG.t698' /></h2>
    	<table class="content">
	        <tr>
	            <th><spring:message code = 'ezApprovalG.t699' /></th>
	            <td id="descript">&nbsp;</td>
	        </tr>
    	</table>
    	<div style="BORDER: #b6b6b6 1px solid; OVERFLOW-Y: auto; OVERFLOW-X: auto; WIDTH: 100%; HEIGHT: 260px; BACKGROUND-COLOR: #ffffff" id="TreeView"></div>
    	<div class="btnposition">
        	<a class="imgbtn"><span onclick="return btnOk_onclick()"><spring:message code = 'ezApprovalG.t413' /></span></a>
        	<a class="imgbtn"><span onclick="return btncancel_onclick()"><spring:message code = 'ezApprovalG.t414' /></span></a>
    	</div>
	</body>
</html>