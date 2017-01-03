function GetFormInfo(ID, KIND, searchtype, searchname) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/admin/ezApproval/getFormList.do",
		data : {
			formContID : ID,
			formKind   : KIND,
			searchType : searchtype,
			searchName : searchname,
			companyID  : companyID
		},
		success: function(text){
			result = text;
		}
	});
	
    var xmlRtn = createXmlDom();
    xmlRtn = loadXMLString(result);
    
    document.getElementById('divlvtForm').innerHTML = "";
    var listview = new ListView();
    listview.SetID("lvtForm");
    listview.SetMulSelectable(false);
    listview.SetHeightFree(true);
    listview.SetRowOnClick("lvtForm_Row_click");
    listview.SetRowOnDblClick("lvtForm_Row_Dbclick");
    listview.DataSource(xmlRtn);
    listview.DataBind("divlvtForm");
    var oArrRows = listview.GetSelectedRows();
    var tr = oArrRows[0];
    if (tr) {
        listview.SetSelectFlag(true);
        document.getElementById('descrip').innerHTML = GetAttribute(tr, "DATA2");
    }
}

function GetFormContInfo(ID, DeptID, eventflag) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/admin/ezApproval/getFormContInfo.do",
		data : {
			id         : ID,
			companyID  : companyID
		},
		success: function(text){
			result = text;
		}
	});
	
    var xmlRtn = createXmlDom();
    xmlRtn = loadXMLString(result);

    if (SelectNodes(xmlRtn, "NODES/NODE/SELECT").length > 0) {
        if (CrossYN() || pNoneActiveX == "YES") {
            xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].removeChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("SELECT")[0]);
        }
        else {
            xmlRtn.selectNodes("NODES/NODE")[0].removeChild(xmlRtn.selectNodes("NODES/NODE/SELECT")[0]);
        }
    }
    var treeView = new TreeView();
    treeView.LoadFromID("FromTreeView");
    treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
}

function InitFormCont() {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/admin/ezApproval/getFormContInfo.do",
		data : {
			id         : "ROOT",
			companyID  : companyID
		},
		success: function(text){
			result = text;
		}
	});
	
	var xmlTree = createXmlDom();
//	xmlTree = loadXMLString(FORMLIST.innerHTML.toUpperCase());
	xmlTree = loadXMLString(FORMCONTAINER.innerHTML.toUpperCase());
	
	if (loadXMLString(result) != null) {
		var xmlRtn = loadXMLString(result).documentElement;
		GetChildNodes(GetChildNodes(xmlTree)[0])[0].appendChild(xmlRtn);
	}

    var listview = new ListView();
    listview.SetID("lvtForm");
    listview.SetMulSelectable(false);
    listview.SetRowOnClick("lvtForm_Row_click");
    listview.SetRowOnDblClick("lvtForm_Row_Dbclick");
    listview.DataSource(xmlRtn);
    listview.DataBind("divlvtForm");

    document.getElementById('divFromTreeView').innerHTML = "";
    var treeView = new TreeView();
    treeView.SetID("FromTreeView");
    treeView.SetUseAgency(true);
    treeView.SetRequestData("TreeViewRequestData");
    treeView.SetNodeClick("TreeViewNodeClick");
    treeView.DataSource(xmlTree);
    treeView.DataBind("divFromTreeView");
}

function OpenAlertUI(pAlertContent) {
    var parameter = pAlertContent;
    var url = "/admin/ezApproval/ezAprAlert.do";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    feature = feature + GetShowModalPosition(330, 205);
    var RtnVal = window.showModalDialog(url, parameter, feature);
}

