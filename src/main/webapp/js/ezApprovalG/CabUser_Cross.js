
function GetTaskCharger(pCabClassNo, pDeptCode) {
    var oXmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS");
    createNodeAndInsertText(xmlpara, objNode, "CABCLASSNO", pCabClassNo);
    createNodeAndInsertText(xmlpara, objNode, "DEPTCODE", pDeptCode)
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);

    oXmlhttp.open("POST", "/ezApprovalG/getTaskCharger.do", false);
    oXmlhttp.send(xmlpara);

    return oXmlhttp.responseXML;
}
