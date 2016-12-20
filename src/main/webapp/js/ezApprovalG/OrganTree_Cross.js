var g_xmlHTTP = null;

function LoadOrganTreeData(szDeptCode, CompanyID) {
    if (typeof (CompanyID) == "undefined") CompanyID = "Top";
    if (CompanyID == "") CompanyID = "Top";

    var strQuery = "<DATA><DEPTID>" + szDeptCode + "</DEPTID><TOPID>" + CompanyID + "</TOPID><PROP></PROP></DATA>";
    var xmlHTTP = createXMLHttpRequest();
    xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
    xmlHTTP.send(strQuery);

    var xmlDom = createXmlDom();
    xmlDom.async = false;
    xmlDom = loadXMLFile("/xml/organtree_config.xml");

    var xmlDomInitData = createXmlDom();
    xmlDomInitData = xmlHTTP.responseXML;
    // 트리 초기화
    var treeView = new TreeView();
    treeView.SetID("treeView");
    treeView.SetUseAgency(true);
    treeView.SetConfig(xmlDom);
    treeView.SetRequestData("RequestData");
    treeView.SetNodeClick("TreeCtrl_onNodeClick");
    treeView.DataSource(xmlDomInitData);
    treeView.DataBind("DocTreeView");

}

//function RequestData() 
function RequestData(obj) {
    var nodeIdx = obj;
    var xmlHTTP = createXMLHttpRequest();

    var treeNode = new TreeNode();
    treeNode.LoadFromID(nodeIdx);

    var strQuery = "<DATA><DEPTID>" + treeNode.GetNodeData("CN") + "</DEPTID><PROP></PROP></DATA>";

    var treeView = new TreeView();
    treeView.LoadFromID("treeView");

    xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
    xmlHTTP.send(strQuery);

    var listNode = SelectSingleNodeNew(xmlHTTP.responseXML, "NODES");

    var xmlDoc;
    if (CrossYN()) {
        var xmlLIST = createXmlDom();
        var nodeToImport = xmlLIST.importNode(listNode, true);
        xmlLIST.appendChild(nodeToImport);

        xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
    }
    else {
        xmlDoc = createXmlDom();
        xmlDoc.appendChild(listNode);
    }
    treeView.AppendChildNodes(listNode, nodeIdx);

}


/*
## 조직도 검색
pSearchList- search_type.value + "::" + keyword.value
pCellList- "company;description;displayname;title;telephonenumber";
pPropList
pClass- user/group/all
*/
function OrganSearch(pSearchList, pCellList, pPropList, pClass) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezOrgan/getSearchList.do",
		data : {
			search : pSearchList,
			cell   : pCellList,
			prop   : pPropList,
			type   : pClass
		},
		success: function(xml){
			result = xml;
		}        			
	});
	
    return loadXMLString(result);
}

function DisplayOrganSearchList(pSearchList, pCellList, pPropList, pClass) {

    var rtnXml = OrganSearch(pSearchList, pCellList, pPropList, pClass);

    var objRoot, objNode, header, Data;

    document.getElementById("OrgListView").innerHTML = "";
    var listview = new ListView();
    listview.SetID("OrganListView");
    listview.SetMulSelectable(true);
    listview.SetRowOnClick("OrganList_rowclick");
    listview.SetRowOnDblClick("OrganListView_rowdblclick");

    if (CrossYN())
        listview.DataSource(OrganListHeader);
    else {
        var objXML = createXmlDom();
        objXML = loadXMLString(OrganListHeader.xml);
        listview.DataSource(objXML);
    }
    listview.DataBind("OrgListView");
    if (SelectNodes(rtnXml, "ROW").length > 0) {
        listview.DataSource(rtnXml);
        listview.RowDataBind("OrgListView");
        listview.SetSelectFlag(false);
    }
}