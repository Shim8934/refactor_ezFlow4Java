
function GetFormInfo(ID, KIND, searchtype, searchname) {
    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();
    var objNode;

    if (searchtype == undefined)
        searchtype = "";
    if (searchname == undefined)
        searchname = "";

    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "ID", ID);
    createNodeAndInsertText(xmlpara, objNode, "KIND", KIND);
    createNodeAndInsertText(xmlpara, objNode, "SEARCHTYPE", searchtype);
    createNodeAndInsertText(xmlpara, objNode, "SEARCHNAME", searchname);
    xmlhttp.open("POST", "aspx/getForm.aspx", false);
    xmlhttp.send(xmlpara);

    xmlRtn = loadXMLString(xmlhttp.responseText);

    document.getElementById('divlvtForm').innerHTML = "";

    var listview = new ListView();                          
    listview.SetID("lvtForm");                              
    listview.SetMulSelectable(false);                       
    listview.SetRowOnClick("lvtForm_onSel_Changed");
    listview.SetRowOnDblClick("lvtForm_onSel_DBclick");
    listview.DataSource(xmlRtn);                            
    listview.DataBind("divlvtForm");                           

    var selRow = listview.GetSelectedRows();
    var tr = selRow[0];

    if (tr) {
        listview.SetSelectFlag(true);
        document.getElementById('descrip').innerHTML = tr.getAttribute("DATA2");
    }

}


function GetFormContInfo(ID, DeptID, eventflag) {
    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom(); 
    var objNode;

    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "ID", ID);
    createNodeAndInsertText(xmlpara, objNode, "DeptID", DeptID);
    xmlhttp.open("POST", "aspx/getFormContainer.aspx", false);
    xmlhttp.send(xmlpara);

    xmlRtn = loadXMLString(xmlhttp.responseText);

    if (xmlhttp.responseText == "") return;

    if (SelectNodes(xmlRtn, "NODES/NODE/SELECT").length > 0) {
        if (CrossYN()) {
            xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].removeChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("SELECT")[0]);
        }
        else {
            xmlRtn.selectNodes("NODES/NODE")[0].removeChild(xmlRtn.selectNodes("NODES/NODE/SELECT")[0]);
        }
    }


    var treeView = new TreeView();      
    treeView.LoadFromID("FormTreeView");

    treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
}

function InitFormCont() {
    var xmlpara = createXmlDom();
    var xmlTree = createXmlDom(); 

    var objNode;

    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "ID", "ROOT"); 
    createNodeAndInsertText(xmlpara, objNode, "DeptID", pDeptID);

    xmlhttp.open("POST", "aspx/getFormContainer.aspx", false);
    xmlhttp.send(xmlpara);

    xmlTree = loadXMLString(FORMCONTAINER.innerHTML.toUpperCase());

    if (xmlhttp.responseText != "") {

        if (CrossYN()) {
            var xmlRtns = xmlhttp.responseXML.documentElement;
            var xmlRtn = xmlhttp.responseXML;
            for (var i = 0; i < SelectNodes(xmlRtn, "NODES/NODE").length ; i++) {
                if (i == 0) {
                    setNodeText(GetChildNodes(SelectNodes(xmlRtn, "NODES/NODE")[i])[1], "FALSE");
                }
                else {
                    setNodeText(GetChildNodes(SelectNodes(xmlRtn, "NODES/NODE")[i])[0], "FALSE");
                }
            }
            var Node = xmlTree.importNode(xmlRtns, true);
            xmlTree.documentElement.getElementsByTagName("NODE")[0].appendChild(Node);
        }
        else {
            var xmlRtn = xmlhttp.responseXML.documentElement;
            for (var i = 0; i < SelectNodes(xmlRtn, "NODES/NODE").length ; i++) {
                if (i == 0) {
                    setNodeText(GetChildNodes(SelectNodes(xmlRtn, "NODES/NODE")[i])[1], "FALSE");
                }
                else {
                    setNodeText(GetChildNodes(SelectNodes(xmlRtn, "NODES/NODE")[i])[0], "FALSE");
                }
            }
            xmlTree.childNodes[0].childNodes[0].appendChild(xmlRtn);
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
    var url = "/myoffice/ezApprovalG/ezAPRALERT_Cross.aspx";

    if (CrossYN() || NonActiveX == "YES") {
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
    var url = "/myoffice/ezApprovalG/ezAPROPINION_Cross.aspx";

    if (CrossYN() || NonActiveX == "YES") {
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