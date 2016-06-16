var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/myoffice/ezApprovalG/ezAPRALERT_Cross.aspx";

    if (CrossYN() || NonActiveX == "YES") {
        ezapralert_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined) {
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
            var OpenWin = window.open(url, "ezAPRALERT_Cross", GetOpenWindowfeature(325, 200));
            try { OpenWin.focus(); } catch (e) { }
        }
        else {
            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
            var OpenWin = window.open(url, "ezAPRALERT_Cross", GetOpenWindowfeature(325, 200));
            try { OpenWin.focus(); } catch (e) { }
        }
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
}
function OpenAlertUI_Complete() {
    DivPopUpHidden();
}

function ISCabCharger(pCabClassNo, pUserID) {
    var XmlHttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();	
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
    createNodeAndInsertText(xmlpara, objNode, "CABCLASSNO", pCabClassNo);
    createNodeAndInsertText(xmlpara, objNode, "USERID", pUserID);

    XmlHttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/API_ISCabCharger.aspx", false);
    XmlHttp.send(xmlpara);

    var ResultXML = XmlHttp.responseXML;
    var rtnVal = getNodeText(GetChildNodes(ResultXML)[0]);

    if (rtnVal == "FALSE" || rtnVal == "") {
        OpenAlertUI(strLang489);
        return false;
    }
    else {
        if (rtnVal == "0")
            return false;
        else if (rtnVal == "1")
            return true;
    }
}

function initUserRoleinfo() {
    if (GetValFromRoleStr(szRoleInfo, "m") == "1")
        g_bRecAdmin = true;
    else
        g_bRecAdmin = false;

    if (GetValFromRoleStr(szRoleInfo, "w") == "1")
        g_bDeptCharger = true;
    else
        g_bDeptCharger = false;

    if (GetValFromRoleStr(szRoleInfo, "c") == "1")
        AdminYN = "TRUE";
    else
        AdminYN = "FALSE";
}

function GetValFromRoleStr(szRoleStr, RoleChar) {
    var idx = szRoleStr.indexOf(RoleChar);
    if (idx >= 0)
        return szRoleStr.substr(idx + 2, 1);
    else
        return "";
}

function IsDocDept(pDeptCode) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA"); 
    createNodeAndInsertText(xmlpara, objNode, "CN", pDeptCode);
    createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute4");

    xmlhttp.open("POST", "/myoffice/ezOrgan/OrganInfo/GetADInfo.aspx", false);
    xmlhttp.send(xmlpara);

    var ResultXML = xmlhttp.responseXML;
    var result = getNodeText(GetChildNodes(ResultXML)[0]);
    if (result != "")
        return true;
    else
        return false;
}