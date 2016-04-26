function OpenAlertUI(pAlertContent) {
    var parameter = pAlertContent;
    var url = "/myoffice/ezApprovalG/ezAPRALERT.aspx";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    var RtnVal = window.showModalDialog(url, parameter, feature);
}

function ISCabCharger(pCabClassNo, pUserID) {
    var XmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    var xmlpara = new ActiveXObject("Microsoft.XMLDOM");	
    var objRoot = xmlpara.createNode(1, "PARAMETERS", "");	
    xmlpara.appendChild(objRoot);

    var objNode = xmlpara.createNode(1, "COMPANYID", "");	
    objNode.text = CompanyID;
    xmlpara.documentElement.appendChild(objNode);

    var objNode = xmlpara.createNode(1, "CABCLASSNO", "");	
    objNode.text = pCabClassNo;
    xmlpara.documentElement.appendChild(objNode);

    var objNode = xmlpara.createNode(1, "USERID", "");	
    objNode.text = pUserID;
    xmlpara.documentElement.appendChild(objNode);

    XmlHttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/API_ISCabCharger.aspx", false);
    XmlHttp.send(xmlpara);

    var rtnVal = XmlHttp.responseXML.text;
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
    var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    var xmlpara = new ActiveXObject("Microsoft.XMLDOM");

    var objRoot = xmlpara.createNode(1, "DATA", "");
    xmlpara.appendChild(objRoot);

    var objNode = xmlpara.createNode(1, "CN", "");
    objNode.text = pDeptCode;
    xmlpara.documentElement.appendChild(objNode);

    var objNode = xmlpara.createNode(1, "PROP", "");
    objNode.text = "extensionAttribute4";
    xmlpara.documentElement.appendChild(objNode);

    xmlhttp.open("POST", "/myoffice/ezOrgan/OrganInfo/GetADInfo.aspx", false);
    xmlhttp.send(xmlpara);

    if (xmlhttp.responseXML.text != "")
        return true;
    else
        return false;
}