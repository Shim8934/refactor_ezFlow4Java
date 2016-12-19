function isgetUser(DeptID, DeptLPath) {
    var rtnVal = true;
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "DEPTID", DeptID);
    createNodeAndInsertText(xmlpara, objNode, "CELL", "displayname;Description;Title;telephonenumber");
    createNodeAndInsertText(xmlpara, objNode, "PROP", "Department");
    createNodeAndInsertText(xmlpara, objNode, "TYPE", "user");

    xmlhttp.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptMemberList.aspx", false);
    xmlhttp.send(xmlpara);

    if (xmlhttp.responseXML.xml == "") rtnVal = false;
    var nodes = SelectNodes(xmlhttp.responseXML, "LISTVIEWDATA/ROWS");

    if (rtnVal) {
        if (nodes.length > 0)
            rtnVal = true;
        else
            rtnVal = false;
    }
    return rtnVal;
}
