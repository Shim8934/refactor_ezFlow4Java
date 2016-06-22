function GetCabinetSimpleList(pDeptCode, pProduceYear, pTaskCode, pCabID, pFlag) {
    var XmlHttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID); 
    createNodeAndInsertText(xmlpara, objNode, "PROCESSDEPTCODE", pDeptCode);
    createNodeAndInsertText(xmlpara, objNode, "PRODUCTIONYEAR", pProduceYear);
    createNodeAndInsertText(xmlpara, objNode, "TASKCODE", pTaskCode);
    createNodeAndInsertText(xmlpara, objNode, "FLAG", pFlag);
    createNodeAndInsertText(xmlpara, objNode, "LANGTYPE", UserLang);

    XmlHttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/API_GetCabinetSimpleList.aspx", false);
    XmlHttp.send(xmlpara);

    var rtnXml = XmlHttp.responseXML;

    var iSeledtedIdx = 0;
    if (XmlHttp.responseText == "FALSE") {
        alert(strLang482);
    }
    else {
        if (document.getElementById("CabinetList").innerHTML != "") document.getElementById("CabinetList").innerHTML = "";
        var DocList = new ListView();                           
        DocList.SetID("DivCabinetList");                               
        DocList.SetMulSelectable(false);                        
        DocList.SetRowOnDblClick("CabinetList_rowdblclick");      
        DocList.SetUrgentFlag(false);                                    
        DocList.DataSource(rtnXml);                             
        DocList.DataBind("CabinetList");                          	


        var Rows = DocList.GetDataRows();
        var len = DocList.GetRowCount();
        if (len > 0) {
            if (typeof (pCabID) != "undefined") {
                if (pCabID != "") {
                    iSeledtedIdx = GetSelIdxForCabinet(Rows, len, pCabID);
                }
            }
            selectRow("DivCabinetList", iSeledtedIdx);
        }

        DocList = null;

    }
}

function GetSelIdxForCabinet(Rows, len, pCabID) {
    var i;
    for (i = 0; i < len; i++) {
        if (trim_Cross(Rows[i].getAttribute("DATA1")) == pCabID)
            return i;
    }
    return 0;
}

function GetCabinetClassInfo(pCabID) {
    var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/getCabinetInfo.do",
		data : {
			cabinetID : pCabID,
			companyID : CompanyID,
			strType   : UserLang
		},
		success: function(xml){
			result = xml;
		}        			
	});
    
    var dataNodes = GetChildNodes(result);
    var rtnXml = getNodeText(dataNodes[0]);

    if (rtnXml == "FALSE") {
        alert(strLang483);
    }
    return result;
}

var addvolume_cross_dialogArguments = new Array();
var temppCabClassNo;
function NewVolume(pCabID, pCabClassNo, opentype, CompleteFunction) {
    var para = new Array();
    para[0] = pCabID;
    para[1] = pCabClassNo;

    var url = "/myoffice/ezApprovalG/ezCabinet/AddVolume_Cross.aspx";

    if (CrossYN() || NonActiveX == "YES") {
        addvolume_cross_dialogArguments[0] = para;
        if (CompleteFunction == undefined)
            addvolume_cross_dialogArguments[1] = NewVolume_Complete;
        else
            addvolume_cross_dialogArguments[1] = CompleteFunction;
        temppCabClassNo = pCabClassNo

        if (opentype == "OPEN") {
            var OpenWin = window.open(url, "AddVolume_Cross", GetOpenWindowfeature(360, 310));
            try { OpenWin.focus(); } catch (e) { }
        }
        else
            DivPopUpShow(360, 310, url);
    }
    else {
        var feature = "dialogWidth:360px;dialogHeight:310px;scroll:no;resizable:no;status:no; help:no;edge:sunken";
        feature = feature + GetShowModalPosition(360, 310);

        if (url != "")
            var rtn = window.showModalDialog(url, para, feature);

        if (rtn[0] == "TRUE")
            return AddNewVolume(pCabClassNo, rtn[1]);
        else
            return "FALSE";
    }
}

function NewVolume_Complete(rtn) {
    DivPopUpHidden();
    if (rtn[0] == "TRUE") {
        GetCabinetSimpleList(arr_userinfo[4], "", arrTask[0], AddNewVolume(temppCabClassNo, rtn[1]), "1");
    }
}

function AddNewVolume(pCabClassNo, pNewVolNo) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID); 
    createNodeAndInsertText(xmlpara, objNode, "CABCLASSNO", pCabClassNo);
    createNodeAndInsertText(xmlpara, objNode, "NEWVOLNO", pNewVolNo);

    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/API_AddNewVolume.aspx", false);
    xmlhttp.send(xmlpara);

    var dataNodes = GetChildNodes(xmlhttp.responseXML);
    var rtn = getNodeText(dataNodes[0]);

    if (rtn == "FALSE") {
        alert(strLang486);
    }
    return rtn;
}

function EndCabProduce(pCabClassNo, pExpYear, pFlag) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID); 
    createNodeAndInsertText(xmlpara, objNode, "CABCLASSNO", pCabClassNo);
    createNodeAndInsertText(xmlpara, objNode, "CABCLASSLIST", pCabClassNo);
    createNodeAndInsertText(xmlpara, objNode, "EXPYEAR", pExpYear);
    createNodeAndInsertText(xmlpara, objNode, "FLAG", pFlag);

    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/API_EndCabProduce.aspx", false);
    xmlhttp.send(xmlpara);

    var dataNodes = GetChildNodes(xmlhttp.responseXML);
    var rtn = getNodeText(dataNodes[0]);

    if (rtn != "TRUE")
        return false;
    else
        return true;
}