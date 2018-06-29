function GetFormInfo(ID, KIND, searchType, searchName) {
	var xmlRtn = createXmlDom();
	
	$.ajax({
		type : "POST",
		url : "/admin/ezApprovalG/getFormList.do",
		async : false,
		dataType : "json",
		data : {id : ID,
				kind : KIND,
				companyID : companyID,
				searchType : searchType,
				searchName : searchName},
		success : function(result) {
			xmlRtn = loadXMLString(result.resultXML);
		}
	});
	
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
		document.getElementById('descrip').innerHTML = GetAttribute(tr,"DATA2");
	}
}

function GetFormContInfo(ID, DeptID, eventflag) {
	var xmlRtn = createXmlDom(); 
	
	$.ajax({
		type : "POST",
		url : "/admin/ezApprovalG/getFormContInfo.do",
		async : false,
		dataType : "json",
		data : {id : ID, companyID : companyID},
		success : function (result) {
			xmlRtn = loadXMLString(result.resultXML);
		}
	});
	
	if(SelectNodes(xmlRtn, "NODES/NODE/SELECT").length > 0) {
	    if(CrossYN()) {
		    xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].removeChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("SELECT")[0]);
		} else {
		    xmlRtn.selectNodes("NODES/NODE")[0].removeChild(xmlRtn.selectNodes("NODES/NODE/SELECT")[0]);
		}
	}
	
	var treeView = new TreeView();      
    treeView.LoadFromID("FromTreeView");
	treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
}

function InitFormCont() {
	var tempRet = createXmlDom();
	var xmlTree = createXmlDom(); 	
	
	$.ajax({
		type : "POST",
		url : "/admin/ezApprovalG/getFormContInfo.do",
		async : false,
		dataType : "json",
		data : {id : "ROOT", companyID : companyID},
		success : function (result) {
			tempRet = loadXMLString(result.resultXML);
		}
	});
	
    xmlTree = loadXMLString(FORMLIST.innerHTML.toUpperCase());
    var listview = new ListView();                           
    listview.SetID("lvtForm");                               
    listview.SetMulSelectable(false);                        
    listview.SetRowOnClick("lvtForm_Row_click");        
    listview.SetRowOnDblClick("lvtForm_Row_Dbclick");  
    listview.DataSource(xmlRtn);                       
    listview.DataBind("divlvtForm");                     
    xmlTree = loadXMLString(FORMCONTAINER.innerHTML.toUpperCase());
    
	if(tempRet != null) {
		if(CrossYN()) {
            var xmlRtn = tempRet.documentElement;
            xmlTree.documentElement.getElementsByTagName("NODE")[0].appendChild(xmlRtn);
	    } else {
            var xmlRtn = tempRet.documentElement;
            GetChildNodes(GetChildNodes(xmlTree)[0])[0].appendChild(xmlRtn);
        }
	}
	
	document.getElementById('divFromTreeView').innerHTML = "";
	var treeView = new TreeView();
    treeView.SetID("FromTreeView");
    treeView.SetUseAgency(true);
    treeView.SetRequestData("TreeViewRequestData");
    treeView.SetNodeClick("TreeViewNodeClick");
	treeView.DataSource(xmlTree);
	treeView.DataBind("divFromTreeView");
}
var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent)
{
//	var parameter = pAlertContent;
//	var url = "../ezAPRALERT.aspx";
//	var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
//	feature =  feature + GetShowModalPosition(330, 205);
//	var RtnVal = window.showModalDialog(url,parameter,feature);
	
	ezapralert_cross_dialogArguments[0] = pAlertContent;
	var url = "/ezApprovalG/ezAprAlert.do";
	var RtnVal = window.open(url, "", GetOpenWindowfeature(330, 205));
	try { RtnVal.focus(); } catch(e) {}
}

