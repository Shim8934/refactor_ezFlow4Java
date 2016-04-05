function setAttachForm() {
    try {

        var doc;
        var form;

        doc = iframe.document;
        form = doc.all("form");
        form.UploadID.value = pBoardID;
        form.UploadSN.value = pAttachSN;
        form.UploadMaxFileSize.value = pBoardFileSize;
        form.UploadAddFileSize.value = pAttachAddFileSize;
    } catch (ErrMsg) {
        alert(ErrMsg.description);
    }
}

function APRAttachXMLParsing() {
    try {
        var i;
        var j;
        var strXML;
        var Rtnxml = createXmlDom();
        Rtnxml = loadXMLString(getXmlString(pAttachListXml));
        var objAttachNodes = SelectNodes(Rtnxml, "LISTVIEWDATA/ROWS/ROW");
        var pTotalRowsLen = objAttachNodes.length;
        var re = /&/g

        strXML = "<LISTVIEWDATA><HEADERS>";
        strXML = strXML + "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
        strXML = strXML + "<HEADER><NAME>" + strLang2 + "</NAME><WIDTH>50</WIDTH></HEADER>";
        strXML = strXML + "</HEADERS><ROWS>";

        for (i = 0 ; i < pTotalRowsLen ; i++) {
            strXML = strXML + "<ROW><CELL><VALUE>" + getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[0]).replace(re, "&amp;") + "</VALUE>";
            strXML = strXML + "<DATA1>" + getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[1]).replace(re, "&amp;") + "</DATA1>";
            strXML = strXML + "<DATA2>" + getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[2]).replace(re, "&amp;") + "</DATA2>";
            strXML = strXML + "<DATA3>" + getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[3]) + "</DATA3>";
            strXML = strXML + "<DATA4>" + getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[4]) + "</DATA4>";
            strXML = strXML + "<DATA5>" + getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[5]) + "</DATA5>";
            strXML = strXML + "<DATA6>" + getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[6]) + "</DATA6></CELL>";
            strXML = strXML + "<CELL><VALUE>" + getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[1])[0]) + "</VALUE></CELL></ROW>";
        }
        strXML = strXML + "</ROWS></LISTVIEWDATA>";
        return strXML;

    } catch (ErrMsg) {
        alert(ErrMsg.description);
    }
}

function DelAttachFileAtList(obj) {
    try {
        var pItemID = obj.getAttribute("_itemid");
        var pISBig = obj.getAttribute("_big");
        if (pISBig != "Y") {
            var xml = "<FILE>";
            xml += "<ROW>";
            xml += "<ATTACHID><![CDATA[" + pItemID + "]]></ATTACHID>";
            xml += "<BIGYN><![CDATA[" + pISBig + "]]></BIGYN>";
            xml += "</ROW>";
            xml += "<ITEMID><![CDATA[" + g_url + "]]></ITEMID></FILE>";
            DelList(xml);
        }
        else {
            var xmlhttp = createXMLHttpRequest();
            xmlhttp.open("GET", "remote/FilelistDelete.aspx?filedata=" + filedate + "&realFileNM=" + pItemID.split('\\')[1], false);
            xmlhttp.send();
        }
    } catch (ErrMsg) {
        alert(ErrMsg.description);
    }
}

function DelList(resultXML) {
    var xml = loadXMLString(resultXML);
    xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "/myoffice/ezEmail/remote/mail_del_interattach.aspx", false);
    xmlhttp.send(xml);
}

function AddAttachFileInfoXmlParsing(resultXML) {
    try {
        var xml = loadXMLString(resultXML);
        var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
        var pstrXML = "";
        var re = /&/g;
        var objXML = createXmlDom();
        var Rtnxml = createXmlDom();
        var filenm = "";
        pstrXML += "<LISTVIEWDATA><HEADERS>";
        pstrXML += "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
        pstrXML += "<HEADER><NAME>" + strLang3 + "</NAME><WIDTH>50</WIDTH></HEADER>";
        pstrXML += "</HEADERS><ROWS>";
        for (i = 0; i < nodes.length; i++) {
            if (getNodeText(GetChildNodes(nodes[i])[1]) != "denied") {
                pstrXML += "<ROW><CELL><VALUE>" + getNodeText(GetChildNodes(nodes[i])[2]).replace(re, "&amp;") + "</VALUE>";
                pstrXML += "<DATA1>" + getNodeText(GetChildNodes(nodes[i])[2]).replace(re, "&amp;") + "</DATA1>";
                pstrXML += "<DATA2>" + getNodeText(GetChildNodes(nodes[i])[0]).replace(re, "&amp;") + "</DATA2>";
                pstrXML += "<DATA3></DATA3>";
                pstrXML += "<DATA4></DATA4>";
                pstrXML += "<DATA5>Y</DATA5>";
                pstrXML += "<DATA6>" + getNodeText(GetChildNodes(nodes[i])[3]) + "</DATA6>";
                pstrXML += "<DATA7>" + getNodeText(GetChildNodes(nodes[i])[5]) + "</DATA7>";
                pstrXML += "</CELL><CELL>";
                pstrXML += "<VALUE>" + getNodeText(GetChildNodes(nodes[i])[3]) + " Bytes" + "</VALUE>";
                pstrXML += "</CELL></ROW>";
            }
        }
        pstrXML += "</ROWS></LISTVIEWDATA>";
        objXML = loadXMLString(pstrXML);

        pAttachListXml = objXML;
        //if (pAttachListXml == "") {
        //    pAttachListXml = objXML;
        //}
        //else {
        //    if (typeof (pAttachListXml) == "string")
        //        Rtnxml = loadXMLString(pAttachListXml);
        //    else
        //        Rtnxml = loadXMLString(getXmlString(pAttachListXml));

        //    for (var i = 0; i < SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW").length; i++) {
        //        var objNewAttachNodes = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW")[i];
        //        if (CrossYN())
        //            var Node = Rtnxml.importNode(objNewAttachNodes, true);
        //        else
        //            GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(objNewAttachNodes);
        //    }
        //    pAttachListXml = Rtnxml;
        //}
        AppendFileAttachInfo(pAttachListXml);
        return;

    } catch (ErrMsg) {

        alert(ErrMsg.description);
    }
}

function AttachRemoveAll() {
    try {
        var objRoot;
        var objNode;
        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pBoardID", pBoardID);

        xmlhttp.open("Post", "/ezflow/ezAPRATTACH/AttachRemove.aspx", false);
        xmlhttp.send(xmlpara);

        return xmlhttp.responseText;

    } catch (ErrMsg) {
        alert(ErrMsg.description);
    }
}

function DeleteFileAtServer(pAttachDelFileName) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;

    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pFileName", pAttachDelFileName);
    createNodeAndInsertText(xmlpara, objNode, "pCompanyID", pCompanyID);
    createNodeAndInsertText(xmlpara, objNode, "pBoardID", pBoardID);

    xmlhttp.open("Post", "DeleteServerFile.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}


function DeleteSaveFileAtServer(pAttachDelFileName, pBoard, pItemID) {
    try {

        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pFileName", pAttachDelFileName);
        createNodeAndInsertText(xmlpara, objNode, "pBoardID", pBoardID);
        createNodeAndInsertText(xmlpara, objNode, "pItemID", pItemID);
        createNodeAndInsertText(xmlpara, objNode, "pCompanyID", pCompanyID);
        xmlhttp.open("Post", "DeleteServerSaveFile.aspx", false);
        xmlhttp.send(xmlpara);
        return xmlhttp.responseText;
    } catch (ErrMsg) {

        alert(ErrMsg.description);
    }
}


function OpenInformationUI(pInformationContent) {
    var parameter = pInformationContent;
    var url = "/myoffice/ezCommunity/htm/ezAPROPINION.aspx";
    var feature = "status:no;dialogWidth:235px;dialogHeight:175px;help:no;scroll:no";
    feature = feature + GetShowModalPosition(235, 175);
    var RtnVal = window.showModalDialog(url, parameter, feature);
    return RtnVal;
}

function GetShowModalPosition(popUpW, popUpH) {
    var heigth = window.screen.availHeight;
    var width = window.screen.availWidth;
    var left = 0;
    var top = 0;
    var pleftpos;
    pleftpos = parseInt(width) - popUpW;
    heigth = parseInt(heigth) - popUpH;
    width = parseInt(width) - pleftpos;

    left = pleftpos / 2;
    top = heigth / 2;

    var feature = ";dialogLeft:" + left + "px;dialogTop:" + top + "px;";

    return feature
}