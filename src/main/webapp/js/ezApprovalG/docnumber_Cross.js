var fractionsymbol;
function getDocNumber(pDeptID, pPrefix) {
    var fields = message.GetFieldsList();
    var name, docnumber
    var fractionsymbol
    var rtnval

    name = pPrefix + "docnumber"

    var field = message.GetListItem(fields, name);
    if (!field) return true;

    fractionsymbol = field.textContent;

    var xmlhttp = createXMLHttpRequest();
    var RtnValxml = createXmlDom();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DATA", fractionsymbol);
    createNodeAndInsertText(xmlpara, objNode, "DATA", drafterDeptid);
    createNodeAndInsertText(xmlpara, objNode, "DATA", pFormID);

    xmlhttp.open("Post", "../docnum/aspx/getdocnumber.aspx", false);
    xmlhttp.send(xmlpara);

    var dataNodes = GetChildNodes(xmlhttp.responseXML);
    var RtnVal = getNodeText(dataNodes[0]);
    if (RtnVal != "") {
        field.textContent = fractionsymbol + RtnVal;
        rtnval = true;
    }
    else {
        rtnval = false;
    }
    return rtnval;
}
function rollbackDocNumber(pDeptID, pPrefix) {
    var fields = message.GetFieldsList();
    var name, docnumber
    var fractionsymbol
    var rtnval
    if (!pPrefix) {
        pPrefix = "doc";
    }

    name = pPrefix + "number"

    var field = message.GetListItem(fields, name);
    if (!field) return true;

    docnumber = field.textContent;

    if (typeof upperDeptCode !== "undefined" && upperDeptCode !== "") {
        pDeptID = upperDeptCode;
    }

    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DATA", fractionsymbol);
    createNodeAndInsertText(xmlpara, objNode, "DATA", docnumber);
    createNodeAndInsertText(xmlpara, objNode, "DATA", pDeptID);

    xmlhttp.open("Post", "../docnum/aspx/rollbackdocnumber.aspx", false);
    xmlhttp.send(xmlpara);

    var dataNodes = GetChildNodes(xmlhttp.responseXML);
    rtnval = getNodeText(dataNodes[0]);
    field.value = fractionsymbol;

    if (rtnval == "false") {
        field.value = fractionsymbol;
    }
}