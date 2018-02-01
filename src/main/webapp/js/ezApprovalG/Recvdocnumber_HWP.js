var fractionsymbol;
function setDocNumFormat() {
    var Arr_Header = new Array()
    var Header, Tail
    var i
    var d = new Date();

    var numHeader = ""
    var DeptSymbol = getDeptSymbol(arr_userinfo[4], arr_userinfo[5]);

    if (!HwpCtrl.CheckFieldExist("receiptnumber"))
        return;

    var fieldValue = trim(HwpCtrl.GetFieldText("receiptnumber"));
    if (fieldValue != "" && fieldValue.replace("@", "") == fieldValue) {
        pDocNo = fieldValue;
        var tempString = pDocNo.split("-");

        var tempNumString = "";
        if (tempString.length - 1 > 0)
            tempNumString = tempString[tempString.length - 1];

        var i = 0;
        var templen = tempNumString.length;
        for (i = 0; i < 6 - templen; i++)
            tempNumString = "0" + tempNumString;
        pDocNumCode = arr_userinfo[4] + tempNumString;
        return false;
    }
    else if (fieldValue == "") {
        fieldValue = GetDocumentElement(HwpCtrl, "receiptnumber");
    }

    Arr_Header = fieldValue.split("@")
    for (i = 1; i < Arr_Header.length; i++) {
        Header = Arr_Header[i].substr(0, 2);
        Tail = Arr_Header[i].substr(2);

        switch (Header) {
            case "DP":
                numHeader = numHeader + DeptSymbol + Tail
                break;

            case "dp":
                numHeader = numHeader + DeptSymbol + Tail
                break;

            case "YY":
                numHeader = numHeader + d.getYear() + Tail
                break;

            case "yy":
                var yyear = d.getYear()
                numHeader = numHeader + yyear.toString().substr(2) + Tail
                break;

            case "MM":
                var mmonth = d.getMonth() + 1
                if (parseInt(mmonth) < 10) mmonth = "0" + mmonth;
                numHeader = numHeader + mmonth + Tail
                break;

            case "mm":
                numHeader = numHeader + (d.getMonth() + 1) + Tail
                break;

            case "NN":
                break;

            case "nn":
                break;

            case "cs":
                numHeader = numHeader + strLang107 + Tail;
                break;

            default:
                numHeader = numHeader + fieldValue;
                break;
        }
    }
    HwpCtrl.SetFieldText("receiptnumber", numHeader);
    return true;
}
function getRecvDocNumber(pDeptID) {
    try {
        var name, docnumber
        var rtnval

        name = "receiptnumber"
        if (!HwpCtrl.CheckFieldExist(name)) {
            var DeptSymbol = getDeptSymbol(arr_userinfo[4], arr_userinfo[5]);
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
            pDocNo = DeptSymbol + "-" + SN;
            var tempNumString = SN;
            var i = 0;
            var templen = tempNumString.length;
            for (i = 0; i < 6 - templen; i++)
                tempNumString = "0" + tempNumString;
            pDocNumCode = pDeptID + tempNumString;
            SaveFile();
            return true;
        }
        var rtnVal = setDocNumFormat();
        if (!rtnVal)
            return true;

        fractionsymbol = trim(HwpCtrl.GetFieldText(name));

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
            pDocNumCode = "";
            pDocNo = "";
            HwpCtrl.SetFieldText(name, "");
            return false;
        }
        else {
            HwpCtrl.SetFieldText(name, fractionsymbol + SN);
            pDocNo = fractionsymbol + SN;
            var tempNumString = SN;
            var i = 0;
            var templen = tempNumString.length;
            for (i = 0; i < 6 - templen; i++)
                tempNumString = "0" + tempNumString;
            pDocNumCode = pDeptID + tempNumString;
            SaveFile();
            return true;
        }
    } catch (e) {
        if (SN != "") {
            HwpCtrl.SetFieldText(name, fractionsymbol + SN);
            rollbackDocNumber(pDeptID, pDocID)
            return false;
        }
        else {
            HwpCtrl.SetFieldText(name, "");
            pDocNo = "";
        }
    }
}
function rollbackDocNumber(pDeptID, pDocID) {
    try {
        var name, docnumber
        var rtnval

        name = "receiptnumber"
        if (!HwpCtrl.CheckFieldExist(name))
            return;

        docnumber = HwpCtrl.GetFieldText(name);
        if (fractionsymbol == "") {
            var tempList = docnumber.split("-");
            fractionsymbol = tempList[0] + "-";
        }
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
        HwpCtrl.SetFieldText(name, "");

        if (rtnval == "FALSE") {
            pDocNumCode = "";
            pDocNo = "";
        }
        else {
            SaveFile();
            pDocNumCode = "";
            pDocNo = "";
        }
    } catch (e) {
        HwpCtrl.SetFieldText(name, "");
        pDocNumCode = "";
        pDocNo = "";
    }
}
function SaveFile() {
    try {

        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "Html", HwpCtrl.GetCloneData("", "HWP"));


        xmlhttp.open("POST", "aspx/SaveFileHWP.aspx", false);
        xmlhttp.send(xmlpara);

        return xmlhttp.responseText;
    } catch (e) {
        alert("SaveFile : " + e.description);
    }
}

function getDeptSymbol(DeptID, DeptName) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "CN", DeptID);
    createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute6");
    createNodeAndInsertText(xmlpara, objNode, "CATE", "group");

    xmlhttp.open("POST", "/myoffice/ezOrgan/OrganInfo/GetADInfos.aspx", false);
    xmlhttp.send(xmlpara);

    var dataNodes = GetChildNodes(loadXMLString(xmlhttp.responseText).documentElement);
    var RtnVal = getNodeText(dataNodes[0]);

    if (RtnVal == "") {
        return DeptName;
    }
    else {
        return RtnVal;
    }
}