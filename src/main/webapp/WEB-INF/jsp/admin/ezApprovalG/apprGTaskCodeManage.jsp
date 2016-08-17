<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t765' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e3'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TaskCodeManage_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TreeView.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
		    var OrderCell = "";
		    var companyID = "<c:out value = '${userInfo.companyID}' />";
		    var langType = "<c:out value = '${userInfo.lang}' />";
		    var listview = new ListView();
		    
		    $(document).ready(function(){
		        document.getElementById("SCompID").value = companyID;
		        Tree_setconfig();        
		        getGroupTree(1, 1, 0, true);
		        InitListView();
		        getGroupItem("");
		    });
	
		    function Tree_setconfig() {
		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("GET", "/xml/organtree_config2.xml", false);
		        xmlHTTP.send();
		        
		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(xmlHTTP.responseXML);
				}
			}
	
		    function InitListView() {
		        var xmlTree = createXmlDom();
		        xmlTree = loadXMLString(ITEM.innerHTML.toUpperCase());
		        
		        listview.SetID("lvtDocForm");
		        listview.SetMulSelectable(false);
		        listview.SetTableWidth = 420 - 14;
		        listview.DataSource(xmlTree);
		        listview.DataBind("lvtForm");
		    }
	
		    function getGroupTree(pNodeIdx, pLevel, pGroupID, pFirst) {
		        try {
		            if (pLevel > 3) {
		                var treeView = new TreeView();
		                treeView.LoadFromID("FromTreeView");
		                
		                treeView.AppendChildNodes("<NODES></NODES>", treeView.GetSelectNode().NodeID);
		                
		                return;
		            }
		            var xmlTree = createXmlDom();

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
				                if (xmlTree.xml == "") {
				                	return;
				                }

				                var treeView = new TreeView();
				                treeView.LoadFromID("FromTreeView");
				                
				                treeView.AppendChildNodes(xmlTree.documentElement, treeView.GetSelectNode().NodeID);
				            }
			        	}
					});
		        } catch (e) {
		            alert(e.description);
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
		    
		    function RequestData(pNodeID, pTreeID) {
		        var TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        var deptID = treeNode.GetNodeData("CN");

		        GetDeptSubTreeInfo(deptID, TreeIdx);
		    }
	
		    function TreeView_onNodeSelect() {
		        var treeview = new TreeView();
		        treeview.LoadFromID("FromTreeView");
		        var nodedata = treeview.GetSelectNode();
		        var pLevel = nodedata.GetNodeData("DATA1");
		        var pGroupID = nodedata.GetNodeData("DATA2");
		        document.getElementById("descript").innerText = pGroupID;
	
		        if (pLevel == "3") {
		            getGroupItem(pGroupID);
		        } else {
		            getGroupItem("");
		        }
		    }
	
	
		    function lvtForm_onclick() {
		    }
		    
		    function lvtForm_onSel_Changed() {
		    }
		    
		    var taskcategoryinsert_cross_dialogArguments = new Array();
		    var TaskCategoryInsert_Cross;
		    var temppGroupID;
		    
		    function btnAddTree_onclick() {
		        var treeview = new TreeView();
		        treeview.LoadFromID("FromTreeView");
		        var nodeIdx = treeview.GetSelectNode();
		        
		        if (nodeIdx) {
		            var pLevel = nodeIdx.GetNodeData("DATA1");
		            var pGroupID = nodeIdx.GetNodeData("DATA2");
	
		            if (pLevel == "3") {
		                var pAlertContent = "<spring:message code = 'ezApprovalG.t766' />";
						OpenAlertUI(pAlertContent);
		                
		                return
		            }
		            
		            temppGroupID = pGroupID;
		            var para = new Array();
		            para[0] = "I";
		            para[1] = "";
		            para[2] = "";
		            para[3] = parseInt(pLevel) + 1;
		            para[4] = "";
		            para[5] = pGroupID;
		            para[6] = companyID;
		            para[7] = "";
	
		            taskcategoryinsert_cross_dialogArguments[0] = para;
		            taskcategoryinsert_cross_dialogArguments[1] = btnAddTree_onclick_Complete;
	
		            TaskCategoryInsert_Cross = window.open("/admin/ezApprovalG/taskCategoryInsert.do?tCheck=ins", "TaskCategoryInsert", GetOpenWindowfeature(470, 300));
		            try { TaskCategoryInsert_Cross.focus(); } catch (e) { }
		        } else {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t768' />";
		            OpenAlertUI(pAlertContent);
		        }
		    }
		    
		    function btnAddTree_onclick_Complete(retVal) {
		        if (retVal[0] == "TRUE") {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t767' />";
 		            OpenAlertUI(pAlertContent);
		            TaskCategoryInsert_Cross.close();
		            getGroupTree(1, 1, 0, true);
		        }
		    }
		    
		    var taskcategoryinsert_cross_dialogArguments = new Array();
		    function btnEditTree_onclick() {
		        var treeview = new TreeView();
		        treeview.LoadFromID("FromTreeView");
		        var nodeIdx = treeview.GetSelectNode();
		        
		        if (nodeIdx) {
		            var pParent = nodeIdx.GetNodeData("DATA4");
	
		            if (pParent == "NULL") {
		            	var pAlertContent = "<spring:message code = 'ezApprovalG.t769' />";
 		                OpenAlertUI(pAlertContent);
 		                
		                return;
		            }
		            
		            var para = new Array();
		            para[0] = "U";
		            para[1] = nodeIdx.GetNodeData("DATA2");
		            para[2] = nodeIdx.GetNodeData("VALUE");
		            para[3] = nodeIdx.GetNodeData("DATA1"); 
		            para[4] = nodeIdx.GetNodeData("DATA3"); 
		            para[5] = pParent;
		            para[6] = companyID;
		            para[7] = nodeIdx.GetNodeData("VALUE2");
	
	                taskcategoryinsert_cross_dialogArguments[0] = para;
	                taskcategoryinsert_cross_dialogArguments[1] = btnEditTree_onclick_Complete;
	                var TaskCategoryInsert_Cross = window.open("/admin/ezApprovalG/taskCategoryInsert.do?tCheck=update", "TaskCategoryInsert", GetOpenWindowfeature(470, 300));
	                try { TaskCategoryInsert_Cross.focus(); } catch (e) { }
		        } else {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t771' />";
		            OpenAlertUI(pAlertContent);
		        }
		    }
	
		    function btnEditTree_onclick_Complete(retVal) {
		        if (retVal[0] == "TRUE") {
		            var treeview = new TreeView();
		            treeview.LoadFromID("FromTreeView");
	
		            var nodeIdx = treeview.GetSelectNode();
		            var pParent = nodeIdx.GetNodeData("DATA4");
	
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t770' />";
		            OpenAlertUI(pAlertContent);
	
		            if (pParent == retVal[5]) {
		                nodeIdx.SetNodeName(retVal[1]);
		                nodeIdx.SetNodeData("VALUE", retVal[1]);
		                nodeIdx.SetNodeData("VALUE2", retVal[6]);
		                nodeIdx.SetNodeData("DATA3", retVal[4]);
		            } else {
		                getGroupTree(1, 1, 0, true);
		            }
		        }
		    }
		    
		    var ezapropinion_cross_dialogArguments = new Array();
		    function btnDelTree_onclick() {
		        var treeview = new TreeView();
		        treeview.LoadFromID("FromTreeView");
		        var nodeIdx = treeview.GetSelectNode();
	
		        if (nodeIdx) {
		            var pLevel = nodeIdx.GetNodeData("DATA1");
		            var pGroupID = nodeIdx.GetNodeData("DATA2");
		            var pParent = nodeIdx.GetNodeData("DATA4");
	
		            if (pParent == "NULL") {
		                var pAlertContent = "<spring:message code = 'ezApprovalG.t772' />";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
	
		            var tempVal = GetTaskCategoryNodeExist(pLevel, pGroupID);
		            
		            if (tempVal != "FALSE") {
		                var pAlertContent = "<spring:message code = 'ezApprovalG.t773' />";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
	
		            ezapropinion_cross_dialogArguments[0] = "<spring:message code = 'ezApprovalG.t774' />\n<spring:message code = 'ezApprovalG.t775' />";
		            ezapropinion_cross_dialogArguments[1] = btnDelTree_onclick_Complete;
	
		            var ezAPROPINION_Cross = window.open("/ezApprovalG/ezAprOpinion.do", "ezAPROPINION", GetOpenWindowfeature(330, 205));
		            try { ezAPROPINION_Cross.focus(); } catch (e) { }
		        } else {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t777' />";
		            OpenAlertUI(pAlertContent);
		        }
		    }
	
		    function btnDelTree_onclick_Complete(RtnVal) {
		        if (RtnVal) {
		            var treeview = new TreeView();
		            treeview.LoadFromID("FromTreeView");
		            var nodeIdx = treeview.GetSelectNode();
	
		            var pLevel = nodeIdx.GetNodeData("DATA1");
		            var pGroupID = nodeIdx.GetNodeData("DATA2");
		            var pParent = nodeIdx.GetNodeData("DATA4");
		            
		        	$.ajax({
		        		type : "POST",
		            	url : "/admin/ezApprovalG/removeTaskCategory.do",
		            	async : false,
		            	data : {cateType : pLevel, cateCode : pGroupID, companyID : companyID},
		            	success : function(result) {
		            		if (result == "TRUE") {
		            			var pAlertContent = "<spring:message code = 'ezApprovalG.t776' />";
		 	                    OpenAlertUI(pAlertContent);
			                    
			                    nodeIdx.DeleteNode(treeview.GetID());
		            		}
		            	}
		        	});
				}
		    }
		    
		    var taskcodeinsert_cross_dialogArguments = new Array();
		    function btnAddItem_onclick() {
		        var treeview = new TreeView();
		        treeview.LoadFromID("FromTreeView");
		        var nodeIdx = treeview.GetSelectNode();
	
		        if (nodeIdx) {
		            var pLevel = nodeIdx.GetNodeData("DATA1");
	
		            if (pLevel != "3") {
		            	var pAlertContent = "<spring:message code = 'ezApprovalG.t778' />\n<spring:message code = 'ezApprovalG.t779' />";
 		                OpenAlertUI(pAlertContent);

		                return;
		            }
	
		            var para = new Array();
		            para[0] = "I";
		            para[1] = "";
		            para[2] = nodeIdx.GetNodeData("DATA2");
		            para[3] = companyID;
	
		            if (CrossYN()) {
		                taskcodeinsert_cross_dialogArguments[0] = para;
		                taskcodeinsert_cross_dialogArguments[1] = btnAddItem_onclick_Complete;
	
		                var TaskCodeInsert_Cross = window.open("/admin/ezApprovalG/taskCodeInsert.do?tCheck=ins", "TaskCodeInsert", GetOpenWindowfeature(450, 780));
		                try { TaskCodeInsert_Cross.focus(); } catch (e) { }
		            } else {
		                var url = "/admin/ezApprovalG/taskCodeInsert.do?tCheck=ins";
		                var retVal = window.showModalDialog(url, para, "dialogWidth:450px;dialogHeight:780px;status:no;help:no;scroll:no;edge:sunken");
	
		                if (retVal == "TRUE") {
		                    var pAlertContent = "<spring:message code = 'ezApprovalG.t780' />\n<spring:message code = 'ezApprovalG.t781' />";
 		                    OpenAlertUI(pAlertContent);
	
		                    TreeView_onNodeSelect();
		                }
		            }
		        } else {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t782' />";
 		            OpenAlertUI(pAlertContent);
		        }
		    }
	
		    function btnAddItem_onclick_Complete(retVal) {
		        if (retVal == "TRUE") {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t780' />\n<spring:message code = 'ezApprovalG.t781' />";
 		            OpenAlertUI(pAlertContent);
	
		            TreeView_onNodeSelect();
		        }
		    }
		    
		    function btnEditItem_onclick() {
		        var treeview = new TreeView();
		        treeview.LoadFromID("FromTreeView");
		        var nodeIdx = treeview.GetSelectNode();
	
		        if (nodeIdx) {
		            listview.LoadFromID("lvtDocForm");
		            var selRow = listview.GetSelectedRows();
		            
		            if (selRow) {
		                var para = new Array();
		                para[0] = "U";
		                para[1] = selRow[0].getAttribute("DATA1");
		                para[2] = nodeIdx.GetNodeData("DATA2");
		                para[3] = companyID;
	
		                if (CrossYN()) {
		                    taskcodeinsert_cross_dialogArguments[0] = para;
		                    taskcodeinsert_cross_dialogArguments[1] = btnEditItem_onclick_Complete;
		                    var TaskCodeInsert_Cross = window.open("/admin/ezApprovalG/taskCodeInsert.do?tCheck=update", "TaskCodeInsert_Cross", GetOpenWindowfeature(450, 780));
		                    try { TaskCodeInsert_Cross.focus(); } catch (e) { }
		                } else {
		                    var url = "/admin/ezApprovalG/taskCodeInsert.do?tCheck=update";
		                    var retVal = window.showModalDialog(url, para, "dialogWidth:450px;dialogHeight:780px;status:no;help:no;scroll:no;edge:sunken");
		                    
		                    if (retVal == "TRUE") {
		                        var pAlertContent = "<spring:message code = 'ezApprovalG.t783' />";
 		                        OpenAlertUI(pAlertContent);
	
		                        TreeView_onNodeSelect();
		                    }
		                }
		            }
		        } else {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t784' />";
 		            OpenAlertUI(pAlertContent);
		        }
		    }
	
		    function btnEditItem_onclick_Complete(retVal) {
		        if (retVal == "TRUE") {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t783' />";
 		            OpenAlertUI(pAlertContent);
	
		            TreeView_onNodeSelect();
		        }
		    }
	
		    var ezapropinion_cross_dialogArguments = new Array();
		    function btnDelItem_onclick() {
		        listview.LoadFromID("lvtDocForm");
		        var selRow = listview.GetSelectedRows();
		        
		        if (selRow != "") {
		            var tempVal = GetTaskCodeNodeExist(selRow[0].getAttribute("DATA1"), "");
		            
		            if (tempVal != "FALSE") {
		            	var pAlertContent = "<spring:message code = 'ezApprovalG.t785' />";
 		                OpenAlertUI(pAlertContent);
 		                
		                return;
		            }
	
		            ezapropinion_cross_dialogArguments[0] = "<spring:message code = 'ezApprovalG.t786' />\n<spring:message code = 'ezApprovalG.t787' />";
		            ezapropinion_cross_dialogArguments[1] = btnDelItem_onclick_Complete;
	
		            var ezAPROPINION_Cross = window.open("/ezApprovalG/ezAprOpinion.do", "ezAPROPINION", GetOpenWindowfeature(330, 205));
		            try { ezAPROPINION_Cross.focus(); } catch (e) { }
		        } else {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t784' />";
 		            OpenAlertUI(pAlertContent);
		        }
		    }
	
		    function btnDelItem_onclick_Complete(RtnVal) {
		        if (RtnVal) {
		            listview.LoadFromID("lvtDocForm");
		            var selRow = listview.GetSelectedRows();
/* 		            var xmlpara = createXmlDom();
		            var xmlhttp = createXMLHttpRequest();
		            var objNode;
	
		            createNodeInsert(xmlpara, objNode, "ROW");
		            createNodeAndInsertText(xmlpara, objNode, "TASKCODE", selRow[0].getAttribute("DATA1"));
		            createNodeAndInsertText(xmlpara, objNode, "COMPANYID", companyID);
	
		            xmlhttp.open("POST", "aspx/API_RemoveTaskCode.aspx", false);
		            xmlhttp.send(xmlpara);
	
		            if (SelectSingleNodeValue(xmlhttp.responseXML, "RESULT") == "TRUE") {
		                var pAlertContent = "<spring:message code = 'ezApprovalG.t788' />";
		              	//2016-07-15 이효진 OpenAlertUI화면 alert로 대체
// 	                    OpenAlertUI(pAlertContent);
	                    alert(pAlertContent);

	                    TreeView_onNodeSelect();
		            } */
		            
		            $.ajax({
		            	type : "POST",
		            	url : "/admin/ezApprovalG/removeTaskCode.do",
		            	async : false,
		            	data : {taskCode : selRow[0].getAttribute("DATA1"), companyID : companyID},
		            	success : function(result) {
		            		if (result == "TRUE") {
		            			 var pAlertContent = "<spring:message code = 'ezApprovalG.t788' />";
		  	                    OpenAlertUI(pAlertContent);

		 	                    TreeView_onNodeSelect();
		            		}
		            	}
		            });
		        }
		    }
	
		    var NoneActiveX = "YES";
		    var taskdeptinfomanage_cross_dialogArguments = new Array();
		    
		    function btnConItem_onclick() {
		        listview.LoadFromID("lvtDocForm");
		        var selRow = listview.GetSelectedRows();
		        
		        if (selRow != "") {
		            var para = new Array();
		            para[0] = "";
		            para[1] = selRow[0].getAttribute("DATA1");
		            para[2] = companyID;
	
		            if (CrossYN() || NoneActiveX == "YES") {
		                taskdeptinfomanage_cross_dialogArguments[0] = para;
		                taskdeptinfomanage_cross_dialogArguments[1] = btnConItem_onclick_Complete;
	
		                var TaskDeptInfoManage_Cross = window.open("/admin/ezApprovalG/taskDeptInfoManage.do", "TaskDeptInfoManage", GetOpenWindowfeature(460, 400));
		                try { TaskDeptInfoManage_Cross.focus(); } catch (e) { }
		            } else {
		                var url = "/admin/ezApprovalG/taskDeptInfoManage.do";
		                var retVal = window.showModalDialog(url, para, "dialogWidth:460px;dialogHeight:400px;status:no;help:no;scroll:no;edge:sunken");
		                
		                if (retVal == "TRUE") {
		                    var pAlertContent = "<spring:message code = 'ezApprovalG.t783' />";
 		                    OpenAlertUI(pAlertContent);
		                    alert(pAlertContent);
	
		                    TreeView_onNodeSelect();
		                }
		            }
		        } else {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t784' />";
 		            OpenAlertUI(pAlertContent);
		        }
		    }
	
		    function btnConItem_onclick_Complete(retVal) {
		        if (retVal == "TRUE") {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t783' />";
 		            OpenAlertUI(pAlertContent);
	
		            TreeView_onNodeSelect();
		        }
		    }
	
		    function selectCompanyID() {
		        if (companyID != document.getElementById("SCompID").value) {
		            companyID = document.getElementById("SCompID").value;
	
		            getGroupTree(1, 1, 0, true);
		        }
		    }
		</script>
	</head>
	<body class="mainbody">
		<xml id="GROUP" style="display:none">
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
		<xml id="ITEM" style="display:none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code = 'ezApprovalG.t115' /></NAME>
						<WIDTH>50</WIDTH>
					</HEADER>
					<HEADER>
						<NAME> <spring:message code = 'ezApprovalG.t116' /></NAME>
						<WIDTH>250</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code = 'ezApprovalG.t117' /></NAME>
						<WIDTH>80</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code = 'ezApprovalG.t118' /></NAME>
						<WIDTH>80</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code = 'ezApprovalG.t109' /></NAME>
						<WIDTH>80</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		
		<h1><spring:message code = 'ezApprovalG.t789' /></h1>
		<div id="mainmenu">
			<ul>
		        <b><spring:message code = 'ezApprovalG.t1276' /></b>
		        <SELECT id="SCompID" name="SCompID" onChange="selectCompanyID()">
		        	<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	            	</c:forEach>
		        </SELECT><br /><br />
				<li><span onClick="return btnAddTree_onclick()"><spring:message code = 'ezApprovalG.t790' /></span></li>
				<li><span onClick="return btnEditTree_onclick()"><spring:message code = 'ezApprovalG.t791' /></span></li>
				<li><span onClick="return btnDelTree_onclick()"><spring:message code = 'ezApprovalG.t792' /></span></li>
				<li style="background:none;"><img src="/images/i_bar.gif" style="vertical-align:middle"></li>
				<li><span onClick="return btnViewTaskInfo_onclick()"><spring:message code = 'ezApprovalG.t793' /></span></li>
				<li><span onClick="return btnViewTaskHistoryInfo_onclick()"><spring:message code = 'ezApprovalG.t794' /></span></li>
				<li style="background:none;"><img src="/images/i_bar.gif" style="vertical-align:middle"></li>
				<li><span onClick="return btnAddItem_onclick()"><spring:message code = 'ezApprovalG.t795' /></span></li>
				<li><span onClick="return btnEditItem_onclick()"><spring:message code = 'ezApprovalG.t796' /></span></li>
				<li><span onClick="return btnDelItem_onclick()"><spring:message code = 'ezApprovalG.t797' /></span></li>
				<li><span onClick="return btnConItem_onclick()"><spring:message code = 'ezApprovalG.t798' /></span></li>
			</ul>
		</div>
		<table>
			<tr>
				<td><h2><spring:message code = 'ezApprovalG.t699' /></h2>
					<div style="BORDER:#b6b6b6 1px solid; OVERFLOW-Y:auto; OVERFLOW-X:auto; 
						WIDTH:220px;HEIGHT:400px; BACKGROUND-COLOR:#ffffff" 
						id="TreeView"></div></td>
				<td style="padding-left:5px" ><h2 id="descript">&nbsp;</h2><div class="listview">
					<DIV id="lvtForm" style="BORDER:0; WIDTH: 530px; HEIGHT: 400px; OVERFLOW-Y:auto; OVERFLOW-X:auto;" ></DIV></div>
				</td>
			</tr>
		</table>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>		
	</body>
</html>