function TreeViewinitialize(targetDeptID, TopDeptID, tProperty, ServerName, mode, orgCompanyID, displayTrashDept) {
    try {
        var xmlHTTP = createXMLHttpRequest();    
        
        var orgCompanyIDStr = "";
        if (typeof(orgCompanyID) != "undefined" && orgCompanyID != null) {
        	orgCompanyIDStr = "<orgCompanyID>" + orgCompanyID + "</orgCompanyID>";
        }
        
        var displayTrashDeptStr = "";
        if (displayTrashDept) {
        	displayTrashDeptStr = "<DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT>";
        }
        
        var strQuery = "<DATA><DEPTID>" + targetDeptID + "</DEPTID><TOPID>" + TopDeptID + "</TOPID><PROP>" + tProperty + "</PROP>" + orgCompanyIDStr + displayTrashDeptStr + "</DATA>";
        
        xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
        xmlHTTP.send(strQuery);
        
        var xmlDom = createXmlDom();
		xmlDom = loadXMLString(xmlHTTP.responseText);

        if (mode == "circulation") {
        	document.getElementById('TreeViewCC').innerHTML = "";
            var treeView = new TreeView();
            treeView.SetID("FromTreeViewCC");
            treeView.SetRequestData("RequestDataCC");
            treeView.SetNodeClick("TreeViewNodeClickCC");
            treeView.SetNodeDblClick("TreeViewNodeDbClickCC");
            treeView.DataSource(xmlDom);
			treeView.DataBind("TreeViewCC");
        } else if (mode == "aprG") {
        	document.getElementById('TreeView').innerHTML = "";
        	var treeView = new TreeView();
        	treeView.SetID("FromTreeView");
        	treeView.SetUseAgency(true);
        	treeView.SetUseSusinColor4AprG(true);
        	treeView.SetRequestData("RequestDataG");
        	treeView.SetNodeClick("TreeViewNodeClick");
        	treeView.DataSource(xmlDom);
			treeView.DataBind("TreeView");
        } else {
        	document.getElementById('TreeView').innerHTML = "";
        	var treeView = new TreeView();
        	var requestData = displayTrashDeptStr ? "RequestDataContainsTrashDept" : "RequestData";
        	treeView.SetID("FromTreeView");
        	treeView.SetUseAgency(true);
			if ($("#1tab1").attr("class") == "tabon") {
				treeView.SetUseSusinColor4AprG(true);
			}
        	treeView.SetRequestData(requestData);
        	treeView.SetNodeClick("TreeViewNodeClick");
        	treeView.DataSource(xmlDom);
			treeView.DataBind("TreeView");
        }
    } catch (ErrMsg) {
        console.log(ErrMsg);
        alert(" TreeViewinitialize : " + ErrMsg.description);
    }
}

function RequestDataContainsTrashDept(pNodeID, pTreeID) {
	RequestData(pNodeID, pTreeID, true);
}

function RequestData(pNodeID, pTreeID) {
	RequestData(pNodeID, pTreeID, true);
}

function RequestData(pNodeID, pTreeID, displayTrashDept) {
	var TreeIdx = pNodeID;
	var treeNode = new TreeNode();
	treeNode.LoadFromID(TreeIdx);
	var deptID = treeNode.GetNodeData("CN");
	
	GetDeptSubTreeInfo(deptID, TreeIdx, true);
}

function RequestDataCC(pNodeID, pTreeID) {
	var TreeIdx = pNodeID;
	var treeNode = new TreeNode();
	treeNode.LoadFromID(TreeIdx);
	var deptID = treeNode.GetNodeData("CN");
	
	GetDeptSubTreeInfoCC(deptID, TreeIdx);
}

function GetDeptSubTreeInfo(deptID, TreeIdx, displayTrashDept) {
    var xmlHTTP = createXMLHttpRequest();
    var xmlRtn = createXmlDom();

	var displayTrashDeptStr = "";
	if (displayTrashDept) {
		displayTrashDeptStr = "<DISPLAY_TRASH_DEPT>true</DISPLAY_TRASH_DEPT>";
	}
    
    var strQuery = "<DATA><DEPTID>" + deptID + "</DEPTID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName;displayName2</PROP>" + displayTrashDeptStr + "</DATA>";
    
    xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
    xmlHTTP.send(strQuery);

    xmlRtn = loadXMLString(xmlHTTP.responseText);

    if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
        if (CrossYN()) {
            xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
        } else {
            xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
        }
    }

    var treeView = new TreeView();      //미리 생성된 TreeView의 ID로 TreeView 개체 생성
    treeView.LoadFromID("FromTreeView");
	if ($("#1tab1").attr("class") == "tabon") {
		treeView.SetUseSusinColor4AprG(true);
	}
    treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
}

function GetDeptSubTreeInfoCC(deptID, TreeIdx) {
	var xmlHTTP = createXMLHttpRequest();
	var xmlRtn = createXmlDom();
	
	var strQuery = "<DATA><DEPTID>" + deptID + "</DEPTID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName;displayName2</PROP></DATA>";
	
	xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
	xmlHTTP.send(strQuery);
	
	xmlRtn = loadXMLString(xmlHTTP.responseText);
	
	if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
		if (CrossYN()) {
			xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
		} else {
			xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
		}
	}
	
	var treeView = new TreeView();      //미리 생성된 TreeView의 ID로 TreeView 개체 생성
	treeView.LoadFromID("FromTreeViewCC");
	
	treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
}

//2020-04-23 : 트리뷰 선택된 노드로 스크롤 이동
function treeViewScrollTo(pTreeViewID) {
    try {
        document.getElementById(pTreeViewID).parentNode.scrollTop = 0;

        var selTreeViewNode = document.getElementById(pTreeViewID).getElementsByClassName("node_selected");
        var centerH = ((Number(document.getElementById(pTreeViewID).parentNode.style.height.replace("px", "")) / 2) + document.getElementById(pTreeViewID).parentNode.getBoundingClientRect().top);

        if (selTreeViewNode != null) {
            document.getElementById(pTreeViewID).parentNode.scrollTop = (selTreeViewNode.item(0).parentNode.getBoundingClientRect().top - centerH);
        }
    } catch (e) { }
}