function GetFormInfo(ID, KIND, searchType, searchName) {
	var xmlRtn = createXmlDom();
	
	//2018-10-11 배현상, 전자결재 관리자에서 양식함 조회 시 관리자가 즐겨찾기 한 목록이 양식함 리스트에 조회되는 현상 제거(양식함에는 양식등록이 불가능하여 ajax를 태우지 않고 '데이터가 없습니다' tr셋팅)
	if (ID == "ROOT") {//양식함 = ROOT
		var objTr = document.createElement("TR");
    	objTr.setAttribute("id", "lvtForm_TR_noItems");
    	var oText = document.createTextNode(strLang944);
    	var objTd = document.createElement("TD");
    	objTd.align = "center";
    	objTd.setAttribute("colSpan", 1);
    	objTd.appendChild(oText);
    	objTr.appendChild(objTd);
    	document.getElementById("lvtForm").getElementsByTagName("tbody")[0].innerHTML = "";
    	document.getElementById("lvtForm").getElementsByTagName("tbody")[0].appendChild(objTr);
		return;
	}
	
	if (searchName !== null) {
		searchName = searchName.replace(/\\/g, "\\\\").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/%/g, "\\%").replace(/'/g, "\\'").replace(/_/g, "\\_");
	}
	
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
	document.getElementById('descrip').innerHTML = "";
	
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

