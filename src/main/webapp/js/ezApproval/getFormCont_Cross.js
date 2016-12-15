function GetFormInfo(ID, KIND, searchtype, searchname)
{
    if (KIND == "A01000") KIND = "BASE";

    if (searchtype == undefined)
        searchtype = "";
    if (searchname == undefined)
        searchname = "";


	var xmlpara = createXmlDom();
	var xmlRtn = createXmlDom();
	
	var objNode;		
	createNodeInsert(xmlpara, objNode, "PARAMETER"); 
	createNodeAndInsertText(xmlpara, objNode, "ID", ID);
	createNodeAndInsertText(xmlpara, objNode, "KIND", KIND);
	createNodeAndInsertText(xmlpara, objNode, "SEARCHTYPE", searchtype);
	createNodeAndInsertText(xmlpara, objNode, "SEARCHNAME", searchname);
	xmlhttp.open("POST", "/myoffice/ezApproval/formContainer/aspx/getForm.aspx", false);
	xmlhttp.send(xmlpara);

	xmlRtn = loadXMLString(xmlhttp.responseText);
	
	document.getElementById('divlvtForm').innerHTML = "";
    
    var listview = new ListView();                        
    listview.SetID("lvtForm");                            
    listview.SetMulSelectable(false);                     
    listview.SetRowOnClick("lvtForm_Row_click");      
    listview.SetRowOnDblClick("lvtForm_Row_Dbclick"); 
    listview.DataSource(xmlRtn);                      
    listview.DataBind("divlvtForm");                  
    
    var oArrRows = listview.GetSelectedRows();
    var tr = oArrRows[0]; 
    
	if (tr)
	{	
		listview.SetSelectFlag(true);
		document.getElementById('descrip').innerHTML = GetAttribute(tr, "DATA2");
	}	
}
function GetFormContInfo(ID, DeptID, eventflag)
{
	var xmlpara = createXmlDom();
	var xmlRtn = createXmlDom(); 
	
	var objNode;		
	createNodeInsert(xmlpara, objNode, "PARAMETER"); 
	createNodeAndInsertText(xmlpara, objNode, "ID", ID);
	createNodeAndInsertText(xmlpara, objNode, "DeptID", DeptID);

	xmlhttp.open("POST", "/myoffice/ezApproval/formContainer/aspx/getFormContainer.aspx", false);
	xmlhttp.send(xmlpara);

	xmlRtn = loadXMLString(xmlhttp.responseText);
	
	if(SelectNodes(xmlRtn, "NODES/NODE/SELECT").length > 0)
	{
	    if (CrossYN() || pNoneActiveX == "YES")
	    {
		    xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].removeChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("SELECT")[0]);
		}
		else
		{
		    xmlRtn.selectNodes("NODES/NODE")[0].removeChild(xmlRtn.selectNodes("NODES/NODE/SELECT")[0]);
		}
	}
	
	var treeView = new TreeView();    
    treeView.LoadFromID("FromTreeView");
	treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx)
}
function InitFormCont()
{
	var xmlpara = createXmlDom();
	var xmlTree = createXmlDom();
	
	var objNode;		
	createNodeInsert(xmlpara, objNode, "PARAMETER"); 
	createNodeAndInsertText(xmlpara, objNode, "ID", "ROOT");
	createNodeAndInsertText(xmlpara, objNode, "DeptID", pDeptID);

	xmlhttp.open("POST", "/myoffice/ezApproval/formContainer/aspx/getFormContainer.aspx", false);
	xmlhttp.send(xmlpara);

	xmlTree = loadXMLString(FORMCONTAINER.innerHTML.toUpperCase());
	
	if(xmlhttp.responseText != "")
	{
	    var xmlRtn = loadXMLString(xmlhttp.responseText).documentElement;
	    GetChildNodes(GetChildNodes(xmlTree)[0])[0].appendChild(xmlRtn);

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
var ezapralert_cross_dialogArgument = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/myoffice/ezApproval/ezAPRALERT_Cross.aspx";

    if (CrossYN() || pNoneActiveX == "YES") {
        ezapralert_cross_dialogArgument[0] = parameter;
        if (CompleteFunction != undefined)
            ezapralert_cross_dialogArgument[1] = CompleteFunction;
        else
            ezapralert_cross_dialogArgument[1] = OpenAlertUI_Complete;
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