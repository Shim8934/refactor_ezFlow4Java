function GetTransStatus(TransFlag) {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
    createNodeAndInsertText(xmlpara, objNode, "DEPTCODE", DeptID);
    createNodeAndInsertText(xmlpara, objNode, "TRANSFLAG", TransFlag);

    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/Manage/aspx/API_GetTransStatus.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseXML;
}




function openSelFileTransCab() {
    try {
        var url = "/myoffice/ezApprovalG/ezCabinet/Manage/SelectTransCab_Cross.aspx";
        var feature = "status:no;dialogWidth:754px;dialogHeight:400px;edge:sunken;scroll:no;help:no"; 
        feature = feature + GetShowModalPosition(754, 400);
        var ret = window.showModalDialog(url, "", feature);

        return ret;
    } catch (e) {
        OpenAlertUI("openSelFileTransCab()" + e.description);
    }
}


function MenuCtl_Trans() {
    var DocList = new ListView();
    DocList.LoadFromID("lvtDoclist");
    var selRow = DocList.GetSelectedRows();

    if (selRow.length > 0) {
        if (DocList_Flag == "CABINET") {
            var CabStatus = parseInt(selRow[0].getAttribute("DATA8"));
            if ((CabStatus & 128) == 128)
            {
                if (typeof (imgViewRejReason) != "undefined" && typeof (imgViewRejReason) != "unknown")
                    SwapIcon(imgViewRejReason, "true");
            }
            else {
                if (typeof (imgViewRejReason) != "undefined" && typeof (imgViewRejReason) != "unknown")
                    SwapIcon(imgViewRejReason, "false");
            }
        }
        else if (DocList_Flag == "RECORD") {

        }
    }
}
