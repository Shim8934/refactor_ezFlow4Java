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



function OpenAlertUI(pAlertContent) {
    var parameter = pAlertContent;
    var url = "/admin/ezApproval/ezAprAlert.do";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    feature = feature + GetShowModalPosition(330, 205);
    var RtnVal = window.showModalDialog(url, parameter, feature);
}

