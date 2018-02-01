var fractionsymbol;
function getDocNumber(pDeptID, pPrefix) {
    try {
        var name, docnumber
        var rtnval

        name = pPrefix + "docnumber"
        if (!HwpCtrl.CheckFieldExist(name))
            return true;

        fractionsymbol = HwpCtrl.GetFieldText(name);

        var xmlhttp = createXMLHttpRequest();
        var RtnValxml = createXmlDom();
        var xmlpara = createXmlDom();




        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "DATA", pDeptID);
        createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);

        xmlhttp.open("Post", "/myoffice/ezApprovalG/docnum/aspx/getCabinetSN.aspx", false);
        xmlhttp.send(xmlpara);

        var SN = getNodeText(loadXMLString(xmlhttp.responseText));

        if (SN == "") {
            DocNumCode = "";
            return false;
        }
        else {
            HwpCtrl.SetFieldText(name, fractionsymbol.substr(0, fractionsymbol.lastIndexOf('-') + 1) + SN);
            var tempNumString = SN;
            var i = 0;
            var templen = tempNumString.length;
            for (i = 0; i < 6 - templen; i++)
                tempNumString = "0" + tempNumString;
            DocNumCode = pDeptID + tempNumString;

            if (HwpCtrl.CheckFieldExist("enforcedate"))
                if (trim(HwpCtrl.GetFieldText("enforcedate")) == "")
                    HwpCtrl.SetFieldText("enforcedate", getGyulJeDate());

            return true;
        }
    } catch (e) {
        if (SN != "") {
            HwpCtrl.SetFieldText(name, fractionsymbol.substr(0, fractionsymbol.lastIndexOf('-') + 1) + SN);
            rollbackDocNumber(pDeptID, pPrefix, pDocID)
            return false;
        }
    }
}
function rollbackDocNumber(pDeptID, pPrefix, pDocID) {
    try {
        var name, docnumber
        var rtnval

        name = pPrefix + "docnumber"
        if (!HwpCtrl.CheckFieldExist(name))
            return true;

        docnumber = HwpCtrl.GetFieldText(name);
        docnumber = docnumber.replace(fractionsymbol, "");

        var xmlpara = createXmlDom();



        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "DATA", pDeptID);
        createNodeAndInsertText(xmlpara, objNode, "DATA", docnumber);
        createNodeAndInsertText(xmlpara, objNode, "DATA", pDocID);

        xmlhttp.open("Post", "/myoffice/ezApprovalG/docnum/aspx/rollbackCabinetSN.aspx", false);
        xmlhttp.send(xmlpara);

        rtnval = getNodeText(loadXMLString(xmlhttp.responseText));
        HwpCtrl.SetFieldText(name, fractionsymbol);

        if (rtnval == "FALSE") {
            DocNumCode = "";
        }
        else {
            DocNumCode = "";
        }
    } catch (e) {
        HwpCtrl.SetFieldText(name, fractionsymbol);
    }
}