
function GetFormInfo(ID, KIND, searchtype, searchname) {
    var xmlRtn = createXmlDom();

    if (searchtype == undefined)
        searchtype = "";
    if (searchname == undefined)
        searchname = "";

    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getForm.do",
		data : {
				id : ID,
				kind  : KIND,
				searchType : searchtype,
				searchName : searchname
				},
		success: function(xml){
			xmlRtn = xml;
		}        			
	});

    document.getElementById('divlvtForm').innerHTML = "";

    var listview = new ListView();                          
    listview.SetID("lvtForm");                              
    listview.SetMulSelectable(false);                       
    listview.SetRowOnClick("lvtForm_onSel_Changed");
    listview.SetRowOnDblClick("lvtForm_onSel_DBclick");
    listview.DataSource(loadXMLString(xmlRtn));                            
    listview.DataBind("divlvtForm");                           

    var selRow = listview.GetSelectedRows();
    var tr = selRow[0];

    if (tr) {
        listview.SetSelectFlag(true);
        document.getElementById('descrip').innerHTML = tr.getAttribute("DATA2");
    }

}


function GetFormContInfo(ID, DeptID, eventflag) {
    var xmlRtn = createXmlDom(); 
    var result = "";

    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getFormContainer.do",
		data : {
				id : ID,
				deptID  : DeptID
				},
		success: function(text){
			result = text;
		}        			
	});

    xmlRtn = loadXMLString(result);

    if (loadXMLString(result) == "") return;

    if (SelectNodes(xmlRtn, "NODES/NODE/SELECT").length > 0) {
        xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].removeChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("SELECT")[0]);
    }

    var treeView = new TreeView();      
    treeView.LoadFromID("FormTreeView");

    treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
}

function InitFormCont() {
    var xmlTree = createXmlDom();
    var result = "";

    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getFormContainer.do",
		data : {
				id : "ROOT",
				deptID  : pDeptID
				},
		success: function(xml){
			result = xml;
		}        			
	});

    xmlTree = loadXMLString(FORMCONTAINER.innerHTML.toUpperCase());

    if (result != "") {
    	result = loadXMLString(result);
    	
        var xmlRtns = result.documentElement;
        var xmlRtn = result;
        for (var i = 0; i < SelectNodes(xmlRtn, "NODES/NODE").length ; i++) {
            if (i == 0) {
                setNodeText(GetChildNodes(SelectNodes(xmlRtn, "NODES/NODE")[i])[1], "FALSE");
            }
            else {
                setNodeText(GetChildNodes(SelectNodes(xmlRtn, "NODES/NODE")[i])[0], "FALSE");
            }
        }

        if (CrossYN()) {
        	var Node = xmlTree.importNode(xmlRtns, true);
        	xmlTree.documentElement.getElementsByTagName("NODE")[0].appendChild(Node);
        } else {
        	xmlTree.documentElement.getElementsByTagName("NODE")[0].appendChild(xmlRtns);
        }
    }

    document.getElementById('TreeView').innerHTML = "";
    var treeView = new TreeView();
    treeView.SetID("FormTreeView");
    treeView.SetUseAgency(true);
    treeView.SetRequestData("TreeViewRequestData");
    treeView.SetNodeClick("TreeViewNodeClick");
    treeView.DataSource(xmlTree);
    treeView.DataBind("TreeView");

}


var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN()) {
        ezapralert_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
        DivPopUpShow(330, 205, url);
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
}

function OpenAlertUI_Complete() {
    DivPopUpHidden();
}


var ezapropinion_cross_dialogArguments = new Array();
function OpenInformationUI(pInformationContent, CompleteFunction) {
    var parameter = pInformationContent;
    var url = "/ezApprovalG/ezAprOpinion.do";

    if (CrossYN()) {
        ezapropinion_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapropinion_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
        DivPopUpShow(330, 205, url);
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
    return RtnVal;
}

function OpenInformationUI_Complete() {
    DivPopUpHidden();
}