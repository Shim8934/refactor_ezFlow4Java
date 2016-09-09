function TreeViewinitialize(targetDeptID, TopDeptID, tProperty, ServerName) {
    try {
        var xmlHTTP = createXMLHttpRequest();    
        
        var strQuery = "<DATA><DEPTID>" + targetDeptID + "</DEPTID><TOPID>" + TopDeptID + "</TOPID><PROP>" + tProperty + "</PROP></DATA>";
        xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
        xmlHTTP.send(strQuery);
        
        var xmlDom = createXmlDom();
        xmlDom = loadXMLString(xmlHTTP.responseText);

        document.getElementById('TreeView').innerHTML = "";
        var treeView = new TreeView();
        treeView.SetID("FromTreeView");
        treeView.SetUseAgency(true);
        treeView.SetRequestData("RequestData");
        treeView.SetNodeClick("TreeViewNodeClick");
        treeView.DataSource(xmlDom);
        treeView.DataBind("TreeView");
    } catch (ErrMsg) {
        alert(" TreeViewinitialize : " + ErrMsg.description);
    }
}

function RequestData(pNodeID, pTreeID) {
    var TreeIdx = pNodeID;
    var treeNode = new TreeNode();
    treeNode.LoadFromID(TreeIdx);
    var deptID = treeNode.GetNodeData("CN");

    GetDeptSubTreeInfo(deptID, TreeIdx);
}

function GetDeptSubTreeInfo(deptID, TreeIdx) {
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
    treeView.LoadFromID("FromTreeView");

    treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
}