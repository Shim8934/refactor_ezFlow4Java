function getGroupTree(pNodeIdx, pLevel, pGroupID, pFirst) {
    try {
        var result = "";
        
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/admin/ezApproval/getDocNumGroupNode.do",
    		data : {
    			g_level      : pLevel,
    			groupID      : pGroupID,
    			companyID    : companyID
    		},
    		success: function(text){
    			result = text;
    		}
    	});
    	
        var xmlRtn = loadXMLString(text);

        if (pFirst) {
            var xmlDom2 = createXmlDom();
            xmlDom2 = loadXMLString(document.getElementById("GROUP").innerHTML.toUpperCase());

            if (SelectNodes(xmlRtn, "NODES/NODE/VALUE")) {
                var xmlRtn = loadXMLString(text).documentElement;
                GetChildNodes(xmlDom2.documentElement)[0].appendChild(xmlRtn);
                
            }
            document.getElementById('TreeView').innerHTML = "";
            var treeView = new TreeView();
            treeView.SetID("FormTreeView");
            treeView.SetUseAgency(true);
            treeView.SetRequestData("TreeViewRequestData");
            treeView.SetNodeClick("TreeViewNodeClick");
            treeView.DataSource(xmlDom2);
            treeView.DataBind("TreeView");

        }
        else {
            var XmlNode = loadXMLString(text);
            if (XmlNode.xml == "") return;
            var treeView = new TreeView();
            treeView.LoadFromID("FormTreeView");
            treeView.AppendChildNodes(XmlNode.documentElement, pNodeIdx);

        }
    } catch (e) {
        alert(e.description);
    }
}

function getGroupItem(pGroupID) {
    var result = "";
    
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/admin/ezApproval/getDocNumItem.do",
		data : {
			g_level      : pLevel,
			groupID      : pGroupID,
			companyID    : companyID
		},
		success: function(text){
			result = text;
		}
	});

    var xmlDoc = loadXMLString(text);

    if (document.getElementById("lvtForm").innerHTML != "") document.getElementById("lvtForm").innerHTML = "";
    var FormList = new ListView();
    FormList.SetID("FormList");
    FormList.SetMulSelectable(false);
    FormList.SetRowOnClick("lvtForm_onclick");
    FormList.SetRowOnDblClick("lvtForm_onSel_DBclick");
    FormList.DataSource(xmlDoc);
    FormList.DataBind("lvtForm");
    FormList = null;
}

function OpenAlertUI(pAlertContent) {
    var parameter = pAlertContent;
    var url = "/admin/ezApproval/ezAprAlert.do";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    feature = feature + GetShowModalPosition(330, 205);
    var RtnVal = window.showModalDialog(url, parameter, feature);
}

