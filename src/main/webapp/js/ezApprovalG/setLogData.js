//문서분류 트리를 가져 온다.
function setLogData(tempDocID, tempActionCode, tempParam1, tempParam2) {
    try {
        var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
        var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");

        objRoot = xmlpara.createNode(1, "ROW", "");
        xmlpara.appendChild(objRoot);

        objNode = xmlpara.createNode(1, "tempDocID", "");
        objNode.text = tempDocID;
        xmlpara.documentElement.appendChild(objNode);

        objNode = xmlpara.createNode(1, "tempActionCode", "");
        objNode.text = tempActionCode;
        xmlpara.documentElement.appendChild(objNode);

        objNode = xmlpara.createNode(1, "tempParam1", "");
        objNode.text = tempParam1;
        xmlpara.documentElement.appendChild(objNode);

        objNode = xmlpara.createNode(1, "tempParam2", "");
        objNode.text = tempParam2;
        xmlpara.documentElement.appendChild(objNode);

        xmlhttp.open("POST", "/myoffice/ezApprovalG/ezDocInfo/setLogData.aspx", false);
        xmlhttp.send(xmlpara);
    } catch (e) {
        alert("setLogData : " + e.description);
    }
}
