
var ezaprhistory_cross_dialogArgument = new Array();
function btnHistory_onclick() {
    var url = "/myoffice/ezApproval/ezAPRHISTORY/ezAPRHISTORY.aspx?DocID=" + escape(pDocID);
    if (CrossYN() || pNoneActiveX == "YES") {
        ezaprhistory_cross_dialogArgument[0] = "";
        ezaprhistory_cross_dialogArgument[1] = history_Complete;
        DivPopUpShow(730, 465, url);
    }
    else
        opencenterwindow(url, "", 730, 430);
}
function history_Complete(RtnVal)
{
    DivPopUpHidden();
}

function UpdateLineHistory(pDocID, pFlag) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
    createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[11]);
    createNodeAndInsertText(xmlpara, objNode, "pUserJobTitle", arr_userinfo[13]);
    createNodeAndInsertText(xmlpara, objNode, "pUserDeptID", arr_userinfo[4]);
    createNodeAndInsertText(xmlpara, objNode, "pUserDeptName", arr_userinfo[15]);
    createNodeAndInsertText(xmlpara, objNode, "chkFlag", pFlag);
    createNodeAndInsertText(xmlpara, objNode, "pUserName2", arr_userinfo[12]);
    createNodeAndInsertText(xmlpara, objNode, "pUserJobTitle2", arr_userinfo[14]);
    createNodeAndInsertText(xmlpara, objNode, "pUserDeptName2", arr_userinfo[16]);

    xmlhttp.open("POST", "/myoffice/ezApproval/ezAPRHISTORY/aspx/UpdateLineHistory.aspx", false);
    xmlhttp.send(xmlpara);

    var dataNodes = GetChildNodes(loadXMLString(xmlhttp.responseText));
    var rtn = getNodeText(dataNodes[0]);

    if (rtn == "TRUE") {
    }
    else {
        var pAlertContent = "" + strLang187 + "";
        OpenAlertUI(pAlertContent);
    }
}


function UpdateDocHistory(pDocID, pHtml) {
    var xmlhttp2 = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "pHtml", pHtml);


    xmlhttp2.open("POST", "/myoffice/ezApproval/ezAPRHISTORY/aspx/UploadDocHistory.aspx", false);
    xmlhttp2.send(xmlpara);

    var URL = xmlhttp2.responseText;
    if (URL.length < 255 && URL != "FALSE") {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "pURL", URL);
        createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[11]);
        createNodeAndInsertText(xmlpara, objNode, "pUserJobTitle", arr_userinfo[13]);
        createNodeAndInsertText(xmlpara, objNode, "pUserDeptID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "pUserDeptName", arr_userinfo[15]);
        createNodeAndInsertText(xmlpara, objNode, "pUserName2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "pUserJobTitle2", arr_userinfo[14]);
        createNodeAndInsertText(xmlpara, objNode, "pUserDeptName2", arr_userinfo[16]);

        xmlhttp.open("POST", "/myoffice/ezApproval/ezAPRHISTORY/aspx/UpdateDocHistory.aspx", false);
        xmlhttp.send(xmlpara);

        var dataNodes = GetChildNodes(loadXMLString(xmlhttp.responseText));
        var rtn = getNodeText(dataNodes[0]);

        if (rtn == "TRUE") {
        }
        else {
            var pAlertContent = strLang188;
            OpenAlertUI(pAlertContent);
        }
    }
    else {
        var pAlertContent = strLang189;
        OpenAlertUI(pAlertContent);
    }
}

function UpdateDocHistoryHWP(pDocID, pHtml) {
    var xmlhttp2 = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "pHtml", pHtml);

    xmlhttp2.open("POST", "/myoffice/ezApproval/ezAPRHISTORY/aspx/UploadDocHistoryHWP.aspx", false);
    xmlhttp2.send(xmlpara);

    var URL = xmlhttp2.responseText;
    if (URL.length < 255 && URL != "FALSE") {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "pURL", URL);
        createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[11]);
        createNodeAndInsertText(xmlpara, objNode, "pUserJobTitle", arr_userinfo[13]);
        createNodeAndInsertText(xmlpara, objNode, "pUserDeptID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "pUserDeptName", arr_userinfo[15]);
        createNodeAndInsertText(xmlpara, objNode, "pUserName2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "pUserJobTitle2", arr_userinfo[14]);
        createNodeAndInsertText(xmlpara, objNode, "pUserDeptName2", arr_userinfo[16]);


        xmlhttp.open("POST", "/myoffice/ezApproval/ezAPRHISTORY/aspx/UpdateDocHistory.aspx", false);
        xmlhttp.send(xmlpara);

        var dataNodes = GetChildNodes(loadXMLString(xmlhttp.responseText));
        var rtn = getNodeText(dataNodes[0]);

        if (rtn == "TRUE") {
        }
        else {
            var pAlertContent = strLang188;
            OpenAlertUI(pAlertContent);
        }
    }
    else {
        var pAlertContent = strLang189;
        OpenAlertUI(pAlertContent);
    }
}

function UpdateAttachHistory(pDocID, tempAttachSN, pModifyFlag) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "pAttachSN", tempAttachSN);
    createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
    createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[11]);
    createNodeAndInsertText(xmlpara, objNode, "pUserJobTitle", arr_userinfo[13]);
    createNodeAndInsertText(xmlpara, objNode, "pUserDeptID", arr_userinfo[4]);
    createNodeAndInsertText(xmlpara, objNode, "pUserDeptName", arr_userinfo[15]);
    createNodeAndInsertText(xmlpara, objNode, "pModifyFlag", pModifyFlag);
    createNodeAndInsertText(xmlpara, objNode, "pUserName2", arr_userinfo[12]);
    createNodeAndInsertText(xmlpara, objNode, "pUserJobTitle2", arr_userinfo[14]);
    createNodeAndInsertText(xmlpara, objNode, "pUserDeptName2", arr_userinfo[16]);

    xmlhttp.open("POST", "/myoffice/ezApproval/ezAPRHISTORY/aspx/UpdateAttachHistory.aspx", false);
    xmlhttp.send(xmlpara);


    if (xmlhttp.responseText.indexOf("TRUE") > -1) {
    }
    else {
        var pAlertContent = strLang190;
        OpenAlertUI(pAlertContent);
    }
}

function opencenterwindow(wfileLocation, wName, wWeigth, wHeigth) {
    try {
        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;
        var left = 0;
        var top = 0;

        left = (parseInt(width) - parseInt(wWeigth)) / 2;
        top = (parseInt(heigth) - parseInt(wHeigth)) / 2;
        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + wHeigth + ",width=" + wWeigth + ",top=" + top + ",left = " + left);
    } catch (e) {
        alert(strLang191 + e.description);
    }
}
