var ModiFlag;
var attachxml = "";
var attachxsl = "";
var PackDocID = "";
function GetExchInfo() {
    return;
}

function btnXMLEdit_onclick() {
    var parameter = new Array(); 
    parameter[0] = "";
    parameter[1] = attachxml;
    parameter[2] = attachxsl;

    var url = "/myoffice/ezApprovalG/ezAPRATTACH/ExchXML.aspx";
    var feature = "status:no;dialogWidth:800px;dialogHeight:600px;help:no;scroll:yes;resizable:yes;";
    var RtnVal = window.showModalDialog(url, parameter, feature);
}