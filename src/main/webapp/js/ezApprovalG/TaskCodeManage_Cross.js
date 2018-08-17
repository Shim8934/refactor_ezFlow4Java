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
        	data : {categoryType : pLevel,
        			parentID : pGroupID,
        			companyID : companyID},
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

function getGroupItem(pGroupID) {
	$.ajax({
		type : "POST",
    	url : "/admin/ezApprovalG/getTaskInSubCategoryForManage.do",
    	async : false,
    	data : {sCateCode : pGroupID,
    			companyID : companyID},
    	success : function(result) {
    	    document.getElementById('lvtForm').innerHTML = "";

    	    listview.DataSource(loadXMLString(result));
    	    listview.DataBind("lvtForm");
    	}
	});
}

var viewtaskinfo_cross_dialogArguments = new Array();
function btnViewTaskInfo_onclick() {
    listview.LoadFromID("lvtDocForm");
    var selRow = listview.GetSelectedRows();

    if (selRow != "") {
        var para = new Array();
        para[0] = "";
        para[1] = selRow[0].getAttribute("DATA1");

        viewtaskinfo_cross_dialogArguments[0] = para;
        viewtaskinfo_cross_dialogArguments[1] = btnViewTaskInfo_onclick_Complete;
        
        
        var ViewTaskInfo_Cross = window.open("/admin/ezApprovalG/viewTaskInfo.do", "ViewTaskInfo", GetOpenWindowfeature(450, 710));
        try { ViewTaskInfo_Cross.focus(); } catch (e) {
        }
    }
    else {
    	alert(strLang437);
    }
}

function btnViewTaskInfo_onclick_Complete() {
}

var taskhistoryinfo_cross_dialogArguments = new Array();
function btnViewTaskHistoryInfo_onclick() {
    listview.LoadFromID("lvtDocForm");
    var selRow = listview.GetSelectedRows();
    if (selRow != "") {
        var para = new Array();
        para[0] = "";
        para[1] = selRow[0].getAttribute("DATA1");
        para[2] = companyID;

        taskhistoryinfo_cross_dialogArguments[0] = para;
        taskhistoryinfo_cross_dialogArguments[1] = btnViewTaskHistoryInfo_onclick_Complete;

        var ViewTaskInfo_Cross = window.open("/admin/ezApprovalG/taskHistoryInfo.do", "TaskHistoryInfo", GetOpenWindowfeature(840, 326));
        try { ViewTaskInfo_Cross.focus(); } catch (e) {
        }
    }
    else {
    	alert(strLang437);
    }
}

function btnViewTaskHistoryInfo_onclick_Complete() {
}

function GetTaskCategoryNodeExist(pType, pGroupID) {
	var retVal = "";
	
	$.ajax({
		type : "POST",
    	url : "/admin/ezApprovalG/getTaskCategoryNodeExist.do",
    	async : false,
    	data : {cateType : pType, sCateCode : pGroupID, companyID : companyID},
    	success : function(result) {
    		retVal = result;
    	},
    	error : function() {
    		retVal = "FALSE";
    	}
	});
	
	return retVal;
}

function GetTaskCodeNodeExist(taskCode, deptID) {
	var retVal = "";
	
	$.ajax({
		type : "POST",
    	url : "/admin/ezApprovalG/getTaskCodeNodeExist.do",
    	async : false,
    	data : {taskCode : taskCode, deptID : deptID, companyID : companyID},
    	success : function(result) {
    		retVal = result;
    	}
	});
	
	return retVal;
}
var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent) {
    ezapralert_cross_dialogArguments[0] = pAlertContent;
    var ezAPRALERT_Cross = window.open("/ezApprovalG/ezAprAlert.do", "ezAPRALERT", GetOpenWindowfeature(330, 205));
    try { ezAPRALERT_Cross.focus(); } catch (e) {
    }
}

function OpenAlertUI_Complete() {
}

//function OpenInformationUI(pInformationContent) {
//    var parameter = pInformationContent;
//    var url = "../../ezAPROPINION_Cross.aspx";
//    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
//    var RtnVal = window.showModalDialog(url, parameter, feature);
//    return RtnVal;
//}
