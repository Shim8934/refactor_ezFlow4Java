var CheckAprLinesXML = "";
var CheckDeptLinesXML = "";

function setAprLinesXML(tempXML) {
    if (tempXML != "cancel")
        CheckAprLinesXML = tempXML;
}

function setDeptLinesXML(tempXML) {
    if (tempXML == "NONE")
        CheckDeptLinesXML = "";
    else if (tempXML != "cancel")
        CheckDeptLinesXML = tempXML;
}

function checkLines() {
    if (CheckAprLinesXML != "") {
        var xmlHTTP = createXMLHttpRequest();
        xmlHTTP.open("POST", "/ezApprovalG/checkAprLines.do", false);
        xmlHTTP.send(CheckAprLinesXML);

        var dataNodes = GetChildNodes(xmlHTTP.responseXML, OpenAlertUILong_Complete);
        var rtnVal = getNodeText(dataNodes[0]);

        if (rtnVal != "") {
            OpenAlertUILong(xmlHTTP.responseText);
            return false;
        }
    }

    if (CheckDeptLinesXML != "") {
        var xmlHTTP2 = createXMLHttpRequest();
        xmlHTTP2.open("POST", "/ezApprovalG/checkDeptLines.do", false);
        xmlHTTP2.send(CheckDeptLinesXML);

        var dataNodes = GetChildNodes(xmlHTTP2.responseXML, OpenAlertUILong_Complete2);
        var rtnVal = getNodeText(dataNodes[0]);

        if (rtnVal != "") {
            OpenAlertUILong(xmlHTTP2.responseText);
            return false;
        }
    }
    return true;
}

var ezapralertlong_cross_dialogArguments = new Array();
function OpenAlertUILong(pAlertContent) {
    var parameter = pAlertContent;
    var url = "/myoffice/ezApprovalG/ezAPRALERTLong_Cross.aspx";

    ezapralertlong_cross_dialogArguments[0] = parameter;
    ezapralertlong_cross_dialogArguments[1] = OpenAlertUILong_Complete;

    DivPopUpShow(330, 205, url);
}

function OpenAlertUILong_Complete() {
    DivPopUpHidden();
    btnSetAprLine_onclick();
}

function OpenAlertUILong_Complete2() {
    DivPopUpHidden();
    btnSetReceivLine_onclick();
}


function getFormInfo(pCode1, pCode2) {
    var Result = "";
    var xmlHTTP3 = createXMLHttpRequest();
    var xmlDOM = createXmlDom();

    var objNode;
    createNodeInsert(xmlDOM, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "CODE1", pCode1);
    createNodeAndInsertText(xmlpara, objNode, "CODE2", pCode2);

    xmlHTTP3.open("POST", "/myoffice/ezApprovalG/ezaprline/aspx/getCodeInfo.aspx", false);
    xmlHTTP3.send(xmlDOM);

    if (xmlHTTP3.statusText == "OK")
        Result = xmlHTTP3.responseText;
    else
        alert("ezViewEnd_HWP.aspx, getFormInfo() - " + xmlHTTP3.statusText);

    xmlHTTP3 = null;
    xmlDOM = null;

    return Result;
}