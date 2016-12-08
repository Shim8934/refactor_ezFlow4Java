function TreeViewinitialize(targetDeptID, TopDeptID, tProperty, ServerName) {
    try {
        var xmlpara = createXmlDom();
        var xmlTree = createXmlDom();
        var xmlHTTP = createXMLHttpRequest();
        var objNode;
        createNodeInsert(xmlpara, objNode, "DATA");
        createNodeAndInsertText(xmlpara, objNode, "DEPTID", targetDeptID);
        createNodeAndInsertText(xmlpara, objNode, "TOPID", TopDeptID);
        createNodeAndInsertText(xmlpara, objNode, "PROP", tProperty);

        xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
        xmlHTTP.send(xmlpara);
        xmlTree = loadXMLString(xmlHTTP.responseText);
        document.getElementById('TreeView').innerHTML = "";
        var treeView = new TreeView();
        treeView.SetID("FromTreeView");
        treeView.SetUseAgency(true);
        treeView.SetRequestData("TreeViewRequestData");
        treeView.SetNodeClick("TreeViewNodeClick");
        treeView.SetNodeDblClick("TreeViewNodeDbClick");
        treeView.DataSource(xmlTree);
        treeView.DataBind("TreeView");
    }
    catch (ErrMsg) {
        alert(" TreeViewinitialize : " + ErrMsg.description);
    }
}

function TreeViewRequestData(pNodeID, pTreeID) {
    var TreeIdx = pNodeID;

    var treeNode = new TreeNode();
    treeNode.LoadFromID(TreeIdx);

    var deptID = treeNode.GetNodeData("CN");
    GetDeptSubTreeInfo(deptID, TreeIdx);
}


function GetDeptSubTreeInfo(deptID, TreeIdx) {
    var xmlHTTP = createXMLHttpRequest();
    var xmlRtn = createXmlDom();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "DEPTID", deptID);
    createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName");


    xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
    xmlHTTP.send(xmlpara);


    xmlRtn = loadXMLString(xmlHTTP.responseText);
    if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
        if (CrossYN() || pNoneActiveX == "YES") {
            xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
        }
        else {
            xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
        }
    }


    var treeView = new TreeView();
    treeView.LoadFromID("FromTreeView");
    treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
}


function RequestData_KMS(pNodeID, pTreeID) {
    var TreeIdx = pNodeID;

    var treeNode = new TreeNode();
    treeNode.LoadFromID(TreeIdx);

    var nodeNM = treeNode.GetNodeData("NODENAME");
    var nodeLevel = treeNode.GetNodeData("NODELEVEL");

    GetSubTreeInfo_KMS(nodeNM, TreeIdx, nodeLevel);

}


function GetSubTreeInfo_KMS(nodeNM, TreeIdx, nodeLevel) {
    var xmlHTTP = createXMLHttpRequest();
    var xmlRtn = createXmlDom();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "NODENAME", nodeNM);
    createNodeAndInsertText(xmlpara, objNode, "NODELEVEL", nodeLevel);

    xmlHTTP.open("POST", "/myoffice/ezApproval/conn/kms/aspx/getKmsTreeSub.aspx", false);
    xmlHTTP.send(xmlpara);

    
    xmlRtn = loadXMLString(xmlHTTP.responseText);

    if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
        if (CrossYN() || pNoneActiveX == "YES") {
            xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
        }
        else {
            xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
        }
    }

    var treeView = new TreeView();      
    treeView.LoadFromID("FromTreeView");

    treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);

}