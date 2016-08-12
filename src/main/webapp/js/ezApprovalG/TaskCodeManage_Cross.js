//function getGroupTree(pNodeIdx, pLevel, pGroupID, pFirst) {
//    try {
//        if (pLevel > 3) {
//            treeView.LoadFromID("FromTreeView");

//            treeView.AppendChildNodes("<NODES></NODES>", TreeIdx);

//            return;
//        }

//        var objRoot;
//        var objNode;

//        var xmlpara = createXmlDom();
//        var xmlhttp = createXMLHttpRequest();
//        var xmlTree = createXmlDom();

//        var xmlBrdInfo;

//        createNodeInsert(xmlpara, objNode, "ROW");
//        createNodeAndInsertText(xmlpara, objNode, "categoryType", pLevel);
//        createNodeAndInsertText(xmlpara, objNode, "ParentID", pGroupID);
//        createNodeAndInsertText(xmlpara, objNode, "companyID", companyID);
//        xmlhttp.open("POST", "aspx/API_GetTaskCategoryTree.aspx", false);
//        xmlhttp.send(xmlpara);

//        xmlTree = loadXMLString(xmlhttp.responseText);

//        if (pFirst) {
//            var xmlDom2 = createXmlDom();

//            xmlDom2 = loadXMLString(document.getElementById("GROUP").innerHTML);

//            if (SelectNodes(xmlhttp.responseXML, "NODES/NODE/VALUE").length > 0) {
//                if (CrossYN()) {
//                    var xmlRtn = xmlhttp.responseXML.documentElement;
//                    var Node = xmlTree.importNode(xmlRtn, true);

//                    xmlDom2.documentElement.childNodes[1].appendChild(Node);
//                }
//                else {
//                    var xmlRtn = xmlhttp.responseXML.documentElement;
//                    xmlDom2.childNodes[0].childNodes[0].appendChild(xmlRtn);
//                }
//            }
//            document.getElementById('TreeView').innerHTML = "";
//            var treeView = new TreeView();
//            treeView.SetID("FromTreeView");
//            treeView.SetUseAgency(true);
//            treeView.SetRequestData("TreeView_onRequestData");
//            treeView.SetNodeClick("TreeView_onNodeSelect");
//            treeView.DataSource(xmlDom2);
//            treeView.DataBind("TreeView");
//        }
//        else {
//            if (xmlhttp.responseXML.xml == "") return;

//            TreeView.putchildxml(pNodeIdx, xmlhttp.responseXML);
//        }
//    }
//    catch (e) {
//        alert(e.description);
//    }
//}

function getGroupItem(pGroupID) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();
    var objNode;

    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "SCATECODE", pGroupID);
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", companyID);
    createNodeAndInsertText(xmlpara, objNode, "LANGTYPE", langType);
   
    xmlhttp.open("POST", "/admin/ezApprovalG/getTaskInSubCategoryForManage.do", false);
    xmlhttp.send(xmlpara);

    //var listview = new ListView();
    //listview.LoadFromID("lvtFormID");
    //listview.DataSource(xmlhttp.responseXML);
    ////document.getElementById('lvtForm').innerHTML = "";
    //listview.DataBind("lvtForm");

    xmlRtn = loadXMLString(xmlhttp.responseText);

    document.getElementById('lvtForm').innerHTML = "";

    listview.DataSource(xmlRtn);
    listview.DataBind("lvtForm");

    //if (listview.GetRowCount() <= 0) {
    //    document.getElementById('lvtForm').innerHTML = "";
    //    listview.DataSource(ITEM);
    //    listview.DataBind("lvtForm");
    //}
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

        var ViewTaskInfo_Cross = window.open("/admin/ezApprovalG/viewTaskInfo.do", "ViewTaskInfo", GetOpenWindowfeature(450, 695));
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

        var ViewTaskInfo_Cross = window.open("/admin/ezApprovalG/taskHistoryInfo.do", "TaskHistoryInfo", GetOpenWindowfeature(557, 326));
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
    ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
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
