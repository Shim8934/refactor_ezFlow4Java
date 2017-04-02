var pRelayDocInfo = createXmlDom();
var decodePass = "";
var decodePath = "";
var pRelayURL = "";
var pRelayURL2 = "";
var needDoubleFormFlag = false;
var pPublicFlag = "";

function GetRelayDocInfo() {
    try {
        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);

        xmlhttp.open("POST", "/myoffice/ezApprovalG/ReceivUI/aspx/getRelayDocInfo.aspx", false);
        xmlhttp.send(xmlpara);

        pRelayDocInfo = loadXMLString(xmlhttp.responseText);
        if (pRelayDocInfo.documentElement.childNodes.length < 1)
            return false;
        else
            return true;

    } catch (e) {
        alert("GetRelayDocInfo : " + e.description);
        return false;
    }
}

function getPasswdEnd() {
    var url = "/myoffice/ezApprovalG/enforce/cert_Cross.aspx";
    var feature = "status:no;dialogWidth:420px;dialogHeight:350px;help:no;scroll:no"
    feature = feature + GetShowModalPosition(420, 350);
    var param = true;
    var ret = window.showModalDialog(url, param, feature);

    if (ret[0]) {
        decodePass = ret[1];
        decodePath = ret[2];
    }
    return ret[0];
}

function decodeUp(emlName) {
    var BaseDN;
    var result = true;

    var xmlContent = createXmlDom();
    xmlContent.async = false;
    xmlContent.load("/Upload_ApprovalG/" + sCompanyID + "/ExDocMSG/" + emlName);
    var ContentsView = xmlContent.selectSingleNode("pack/contents");
    var ContentText = getNodeText(ContentsView);

    var objSave = new ActiveXObject("EzUtil.MiscFunc");
    objSave.Base64ToLocalFile(ContentText, "c:\\smime.p7m");

    arrDelFiles[arrDelFiles.length] = "c:\\smime.p7m";

    var ReceivedDate = getNodeText(pRelayDocInfo.getElementsByTagName("ReceivedDate").item(0));
    var xDeptID = getNodeText(pRelayDocInfo.getElementsByTagName("xToCode").item(0));

    if (GetAttribute(ContentsView.childNodes(0), "content-type") == "application/gcc-mime;smime-type=signedandenveloped-data;") {
        if (ObjGPKI.Decode(decodePath, xDeptID, "c:\\smime.p7m", decodePass, ReceivedDate)) {
            ObjGPKI.WriteResultFile("C:\\" + pDocID + ".xml");

            var ContentsView = xmlContent.selectSingleNode("pack/contents");
            ContentsView.parentNode.removeChild(ContentsView);

            var XMLText = xmlContent.xml;
            XMLText = XMLText.replace("</pack>", "<contents>" + ObjGPKI.Content + "</contents></pack>");

            objSave.SaveTextToFile("C:\\" + pDocID + ".xml", XMLText);

            arrDelFiles[arrDelFiles.length] = "C:\\" + pDocID + ".xml";

            result = UploadDec(XMLText);
            if (result)
                result = UpdateAttachURL();
        }
        else {
            var message = ObjGPKI.ErrorMsg;
            var tempmessage = message.replace("req-resend|", "")
            if (tempmessage == message) {
                var pAlertContent = strLang722 + message.replace("\n", "<br>");
                OpenAlertUI(pAlertContent);
            }
            else {
                var pAlertContent = strLang722 + tempmessage.replace("\n", "<br>") + "<br>" + strLang723;
                OpenAlertUI(pAlertContent);
                SendAckForSend(tempmessage, "req-resend");
                RemoveDocInfo();
            }
            result = false;
        }
    }
    else if (GetAttribute(ContentsView.childNodes(0), "content-type") == "application/gcc-mime;smime-type=signed-data;") {
        if (ObjGPKI.DecodeBySign(decodePath, xDeptID, "c:\\smime.p7m", decodePass, ReceivedDate)) {
            ObjGPKI.WriteResultFile("C:\\" + pDocID + ".xml");

            var ContentsView = xmlContent.selectSingleNode("pack/contents");
            ContentsView.parentNode.removeChild(ContentsView);

            var XMLText = xmlContent.childNodes(2).xml;
            XMLText = XMLText.replace("</pack>", "<contents>" + ObjGPKI.Content + "</contents></pack>");

            objSave.SaveTextToFile("C:\\" + pDocID + ".xml", XMLText);

            arrDelFiles[arrDelFiles.length] = "C:\\" + pDocID + ".xml";

            result = UploadDec(XMLText);
            if (result)
                result = UpdateAttachURL();
        }
        else {
            var message = ObjGPKI.ErrorMsg;
            var tempmessage = message.replace("req-resend|", "")
            if (tempmessage == message) {
                var pAlertContent = strLang722 + message.replace("\n", "<br>");
                OpenAlertUI(pAlertContent);
            }
            else {
                var pAlertContent = strLang722 + tempmessage.replace("\n", "<br>") + "<br>" + strLang723;
                OpenAlertUI(pAlertContent);
                SendAckForSend(tempmessage, "req-resend");
                RemoveDocInfo();
            }
            result = false;
        }
    }
    else if (GetAttribute(ContentsView.childNodes(0), "content-type") == "text/xml") {
        result = UploadDec(xmlContent.xml);
        if (result)
            result = UpdateAttachURL();
    }
    else {
        var pAlertContent = "GPKI " + strLang724 + "<br>" + GetAttribute(ContentsView.childNodes(0), "content-type");
        OpenAlertUI(pAlertContent);
        result = false;
    }

    objSave = null;

    return result;
}

function UploadDec(XMLText) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var xmlpara2 = createXmlDom();
    xmlpara.loadXML(XMLText);
    xmlpara2.loadXML(xmlpara.documentElement.xml);

    xmlhttp.open("POST", "/myoffice/ezApprovalG/ReceivUI/aspx/uploadDec.aspx", false);
    xmlhttp.send(xmlpara2);

    if (xmlhttp.responseText == "OK")
        return true;
    else
        return false;
}

function UpdateAttachURL() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var xmlre = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "xDocID", getNodeText(pRelayDocInfo.getElementsByTagName("xDocID").item(0)));
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);

    xmlhttp.open("POST", "/myoffice/ezApprovalG/ReceivUI/aspx/updateAttachURL.aspx", false);
    xmlhttp.send(xmlpara);

    xmlre = loadXMLString(xmlhttp.responseText);

    if (xmlre.xml == "") {
        return false;
    }
    else {
        if (getNodeText(xmlre.documentElement.childNodes(0)) == "TRUE")
            return true;
        else
            return false;
    }
}

function SendAckForSend(errMsg, type) {
    var xmlpara = createXmlDom();
    var xmlhttp = createXMLHttpRequest();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "pType", type);
    createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[11]);
    createNodeAndInsertText(xmlpara, objNode, "pDeptName", arr_userinfo[15]);
    createNodeAndInsertText(xmlpara, objNode, "errMsg", errMsg);
    xmlhttp.open("Post", "/myoffice/ezApprovalG/ezAPRRECEIVE/aspx/sendAckforReSend.aspx", false);
    xmlhttp.send(xmlpara);

    if (type == "req-resend") {
        var pAlertContent = strLang725;
        OpenAlertUI(pAlertContent);
    }
}

function RemoveDocInfo() {
    var xmlpara = createXmlDom();
    var xmlhttp = createXMLHttpRequest();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);

    xmlhttp.open("Post", "/myoffice/ezApprovalG/aspx/UndoDocMust.aspx", false);
    xmlhttp.send(xmlpara);
}

function getExtInfo() {
    var xmlURL = getNodeText(GetElementsByTagName(pRelayDocInfo, "xmlURL")[0]);
    var sealURL = getNodeText(GetElementsByTagName(pRelayDocInfo, "sealURL")[0]);
    if (xmlURL == "") {
        var pAlertContent = "XML" + strLang167;
        OpenAlertUI(pAlertContent);
        chkBtnConfirm("1");
        return false;
    }

    xmlURL = "/Upload_ApprovalG/" + sCompanyID + "/ExDocXML/" + xmlURL;

    var xmlhttp = createXMLHttpRequest();
    var xmlDocCheck = createXmlDom();
    var sihangXML = createXmlDom();

    var objNode;
    createNodeInsert(xmlDocCheck, objNode, "PARAMETER");
    createNodeAndInsertText(xmlDocCheck, objNode, "XMLPATH", xmlURL);

    xmlhttp.open("POST", "/myoffice/ezApprovalG/ReceivUI/aspx/loadDocXML.aspx", false);
    xmlhttp.send(xmlDocCheck);

    sihangXML = loadXMLString(xmlhttp.responseText);

    if (getXmlString(sihangXML) == "") {
        alert(strLang726 + xmlURL);
        return false;
    }

    var fields = message.GetFieldsList();
    var field
    var eNodes = sihangXML;

    try {
        var Nodes = null;
        var bodyTagUse = true;
        // 에러로그 여부
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "body");
            if (Nodes.length > 0) {
                bodyTagUse = true;
            }
            else {
                bodyTagUse = false;
            }

            Nodes = SelectNodes(eNodes, "ERRORMESSAGE");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/body");
            if (Nodes.length > 0) {
                bodyTagUse = true;
            }
            else {
                bodyTagUse = false;
            }

            Nodes = SelectNodes(eNodes, "pubdoc/ERRORMESSAGE");
        }

        if (Nodes.length > 0) {
            if (bodyTagUse) {
                OpenAlertUI("오류내용:" + getNodeText(Nodes[0]) + "<br>" + " > 문서를 불러올수 있으나 정상표시되는지 확인하세요.");
            }
            else {
                OpenAlertUI("오류내용:" + getNodeText(Nodes[0]) + "<br>" + " > 문서를 불러올수 없습니다.");
                return false;
            }
        }

        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "head/organ");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/head/organ");
        }

        if (Nodes.length > 0) {
            field = message.GetListItem(fields, "organ");
            if (field) {
                setNodeText(field, getNodeText(Nodes[0]));
            }
        }
    } catch (e) { }

    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "head/receiptinfo/recipient");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/head/receiptinfo/recipient");
        }
        if (Nodes.length > 0) {
            if (GetAttribute(Nodes[0], "refer") == "true") {
                field = message.GetListItem(fields, "recipient");
                if (field)
                    setNodeText(field, strLang728);

                field = message.GetListItem(fields, "recipientheader");
                if (field)
                    setNodeText(field, strLang830);

                field = message.GetListItem(fields, "recipients");
                if (field)
                    setNodeText(field, getNodeText(Nodes[0]));
            }
            else {
                field = message.GetListItem(fields, "recipient");
                if (field)
                    setNodeText(field, getNodeText(Nodes[0]));

                field = message.GetListItem(fields, "recipientheader");
                if (field)
                    setNodeText(field, " ");

                field = message.GetListItem(fields, "recipients");
                if (field)
                    setNodeText(field, " ");
            }
        }
    } catch (e) { }

    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "head/receiptinfo/via");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/head/receiptinfo/via");
        }

        if (Nodes.length > 0) {
            field = message.GetListItem(fields, "refer");
            if (field) {
                setNodeText(field, getNodeText(Nodes[0]));
            }
        }
    } catch (e) { }


    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "body/title");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/body/title");
        }

        if (Nodes.length > 0) {
            field = message.GetListItem(fields, "doctitle");
            if (field) {
                setNodeText(field, getNodeText(Nodes[0]));
            }
            field = message.GetListItem(fields, "doctitle2");
            if (field) {
                setNodeText(field, getNodeText(Nodes[0]));
            }
        }

    } catch (e) { }

    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "body");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/body");
        }

        if (Nodes.length > 0) {
            if (GetAttribute(Nodes[0], "separate") == "false" || GetAttribute(Nodes[0], "separate") == null) {
                var tempNodes = null;
                if (CrossYN()) {
                    tempNodes = SelectNodes(eNodes, "body/content");
                }
                else {
                    tempNodes = SelectNodes(eNodes, "pubdoc/body/content");
                }
                if (tempNodes.length > 0) {
                    field = message.GetListItem(fields, "body");
                    if (field) {
                        var bodySTR = "";
                        for (var i = 0 ; i < tempNodes[0].childNodes.length ; i++) {
                            if (i == 0)
                                bodySTR = getNodeText(tempNodes[0].childNodes[i]);
                            else
                                bodySTR = bodySTR + getNodeText(tempNodes[0].childNodes[i]);
                        }

                        if (bodySTR.indexOf("<![CDATA[") > -1) {
                            bodySTR = bodySTR.replace("<![CDATA[", "");
                            bodySTR = bodySTR.replace("]]>", "");
                        }
                        var mmTopxTagStyle = Document_mmTopx(bodySTR);
                        field.innerHTML = mmTopxTagStyle;
                    }
                }
            }
            else {
                var tempNodes = null;
                if (CrossYN()) {
                    tempNodes = SelectNodes(eNodes, "body/content");
                }
                else {
                    tempNodes = SelectNodes(eNodes, "pubdoc/body/content");
                }
                if (tempNodes.length > 0) {
                    field = message.GetListItem(fields, "body");
                    if (field) {
                        var bodySTR = "";
                        for (var i = 0 ; i < tempNodes[0].childNodes.length ; i++) {
                            if (i == 0)
                                bodySTR = getNodeText(tempNodes[0].childNodes[i]);
                            else
                                bodySTR = bodySTR + getNodeText(tempNodes[0].childNodes[i]);
                        }

                        if (bodySTR.indexOf("<![CDATA[") > -1) {
                            bodySTR = bodySTR.replace("<![CDATA[", "");
                            bodySTR = bodySTR.replace("]]>", "");
                        }

                        var mmTopxTagStyle = Document_mmTopx(bodySTR);
                        field.innerHTML = mmTopxTagStyle;
                    }
                }
            }
        }
    } catch (e) { }


    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "foot/sendername");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/foot/sendername");
        }
        if (Nodes.length > 0) {
            field = message.GetListItem(fields, "chief");
            if (field) {
                setNodeText(field, getNodeText(Nodes[0]));
            }
        }
    } catch (e) { }


    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "foot/seal");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/foot/seal");
        }
        if (Nodes.length > 0) {
            var pomit = GetAttribute(Nodes[0], "omit")
            if (pomit == "false") {
                sealPath = "/Upload_ApprovalG/" + sCompanyID + "/ExDocSign/" + sealURL;
                field = message.GetListItem(fields, "sealsign");
                if (field) {
                    var signWidth = 105;
                    var signHeight = 105;
                    if ((GetAttribute(Nodes[0].firstElementChild, "width") != "") && (GetAttribute(Nodes[0].firstElementChild, "width") != null)) {
                        var tempWidth = GetAttribute(Nodes[0].firstElementChild, "width");
                        tempWidth = ConversionPt(tempWidth);
                        signWidth = tempWidth;
                    }

                    if ((GetAttribute(Nodes[0].firstElementChild, "height") != "") && (GetAttribute(Nodes[0].firstElementChild, "height") != null)) {
                        var tempHeight = GetAttribute(Nodes[0].firstElementChild, "height");
                        tempHeight = ConversionPt(tempHeight);
                        signHeight = tempHeight;
                    }

                    var field2 = message.GetListItem(fields, "chief");
                    var chiefwidth = 1;
                    if (field2) {
                        cheifwidth = parseInt(field2.style.offsetWidth);
                        field2.style.height = signHeight;
                    }

                    var sealwidth = (maxwidth + cheifwidth) / 2 - 60;
                    var field2 = message.GetListItem(fields, "sealwidth");
                    if (field2)
                        field2.style.width = sealwidth;

                    var field2 = message.GetListItem(fields, "noseal");
                    if (field2)
                        field2.style.width = (maxwidth - sealwidth - signWidth);

                    field.style.width = signWidth
                    field.style.height = signHeight

                    var strimg = "<img src='" + RootURL + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(sealPath) + "' border=0 embedding='1' ";
                    strimg = strimg + " width=" + signWidth;
                    strimg = strimg + " height=" + signHeight + ">";

                    field.innerHTML = strimg;
                }
            }

            if (pomit == "true") {
                field = message.GetListItem(fields, "noseal");
                if (field) {
                    var signWidth = 105;
                    var signHeight = 35;
                    var strimg = "<img src='" + RootURL + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape("/Upload_ApprovalG/SealImg/nostamp.gif") + "' border=0 embedding='1' >";
                    var field2 = message.GetListItem(fields, "chief");
                    var chiefwidth = 1;
                    if (field2) {
                        cheifwidth = parseInt(field2.style.offsetWidth);
                        field2.style.height = signHeight;
                    }

                    var sealwidth = (maxwidth + cheifwidth) / 2 + 20;
                    var field2 = message.GetListItem(fields, "sealwidth");
                    if (field2)
                        field2.style.width = sealwidth;

                    var field2 = message.GetListItem(fields, "sealsign");
                    if (field2)
                        field2.style.width = "1";

                    field.style.width = maxwidth - sealwidth - 1;
                    field.innerHTML = strimg;
                }
            }
        }
    } catch (e) { }

    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "foot/approvalinfo/approval");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/foot/approvalinfo/approval");
        }
        var ApprovalAnyFlag = 0;
        if (Nodes.length > 0) {
            var lastSignSN = Nodes.length;
            for (i = 0; i < Nodes.length; i++) {
                var SignOrder = GetAttribute(Nodes[i], "order");
                var SignText = "";
                if (SignOrder == "final")
                    SignOrder = lastSignSN;

                SignText = "";

                var tempNode = SelectSingleNode(Nodes[i], "signposition");
                if (tempNode) {
                    field = message.GetListItem(fields, "jikwe" + SignOrder);
                    if (field) {
                        setNodeText(field, getNodeText(tempNode) + SignText);
                    }
                }
                var SignInputFlag = false;
                SignText = "";

                var tempNode = SelectSingleNode(Nodes[i], "type");
                if (tempNode) {
                    if (getNodeText(tempNode) == strLang6) {
                        SignText = SignText + strLang6;
                        ApprovalAnyFlag = ApprovalAnyFlag + 1;
                    }
                    else if (getNodeText(tempNode) == strLang7) {
                        SignText = SignText + strLang7;
                        ApprovalAnyFlag = 1;
                    }
                    else {
                        ApprovalAnyFlag = 0;
                    }
                }

                if (GetAttribute(Nodes[i], "order") == "final" || ApprovalAnyFlag == 1) {
                    var tempNode = SelectSingleNode(Nodes[i], "date");
                    if (tempNode)
                        SignText = SignText + convertDate(getNodeText(tempNode));
                }

                if (SignText != "" && ApprovalAnyFlag <= 1)
                    SignText = SignText + "<br>";

                var tempNode = SelectSingleNode(Nodes[i], "name");
                if (tempNode) {
                    field = message.GetListItem(fields, "sign" + SignOrder);
                    if (field) {
                        if (ApprovalAnyFlag > 1)
                            field.innerHTML = SignText;
                        else {
                            field.innerHTML = SignText + "<P style=\"MARGIN-TOP:0px;MARGIN-BOTTOM:0px;FONT-WEIGHT:bold;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + getNodeText(tempNode) + "</P>";
                        }
                    }
                    SignInputFlag = true;
                }

                var tempNode = SelectSingleNode(Nodes[i], "signimage");
                if (tempNode) {
                    signPath = "/Upload_ApprovalG/" + sCompanyID + "/ExDocUserSign/" + getSignURL(GetAttribute(tempNode.selectSingleNode("img"), "src"));
                    field = message.GetListItem(fields, "sign" + SignOrder);
                    if (field) {
                        if (GetAttribute(tempNode.selectSingleNode("img"), "width") == "" || GetAttribute(tempNode.selectSingleNode("img"), "width") == null)
                            var signWidth = 50;
                        else
                            var signWidth = ConversionPt(GetAttribute(tempNode.selectSingleNode("img"), "width"));

                        if (GetAttribute(tempNode.selectSingleNode("img"), "height") == "" || GetAttribute(tempNode.selectSingleNode("img"), "height") == null)
                            var signHeight = 28;
                        else
                            var signHeight = ConversionPt(GetAttribute(tempNode.selectSingleNode("img"), "height"));

                        if (signWidth > 70)
                            signWidth = 50;

                        if (signHeight > 48)
                            signHeight = 28;

                        var strimg = "<img src='" + RootURL + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(signPath) + "' border=0 embedding='1' ";
                        strimg = strimg + " width=" + signWidth;
                        strimg = strimg + " height=" + signHeight + ">";

                        field.innerHTML = SignText + strimg;
                    }
                    SignInputFlag = true;
                }

                if (!SignInputFlag) {
                    field = message.GetListItem(fields, "sign" + SignOrder);
                    if (field) {
                        field.innerHTML = SignText;
                    }
                }
            }
            if (message.GetListItem(fields, "lineapr")) {
                if (Nodes.length > 4) {
                    fields.Item("lineapr").style.display = "";
                    for (i = 0; i < fields.Item("lineapr").childNodes.length; i++)
                        fields.Item("lineapr").childNodes[i].style.display = "";
                }
                else {
                    fields.Item("lineapr").style.display = "none";
                    for (i = 0; i < fields.Item("lineapr").childNodes.length; i++)
                        fields.Item("lineapr").childNodes[i].style.display = "none";
                }
            }
        }
    } catch (e) { }

    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "foot/approvalinfo/assist");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/foot/approvalinfo/assist");
        }

        if (Nodes.length > 0) {
            message.GetListItem(fields, "habyui")
            if (message.GetListItem(fields, "habyui")) {
                message.GetListItem(fields, "habyui").style.display = "";
            }
            var lastSignSN = Nodes.length;
            for (i = 0; i < Nodes.length; i++) {
                var SignOrder = GetAttribute(Nodes[i], "order");
                var SignText = "";
                if (SignOrder == "final")
                    SignOrder = lastSignSN;

                var tempNode = SelectSingleNode(Nodes[i], "signposition");
                if (tempNode) {
                    field = message.GetListItem(fields, "habyuipositon" + SignOrder);
                    if (field) {
                        setNodeText(field, getNodeText(tempNode) + SignText);
                    }
                }

                var tempNode = selectSingleNode(Nodes[i], "name");
                if (tempNode) {
                    field = message.GetListItem(fields, "habyuisign" + SignOrder);
                    if (field) {
                        field.innerHTML = "<P style=\"MARGIN-TOP:0px;MARGIN-BOTTOM:0px;FONT-WEIGHT:bold;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + getNodeText(tempNode) + "</P>";
                    }
                }

                var tempNode = SelectSingleNode(Nodes[i], "signimage");
                if (tempNode) {
                    signPath = "/Upload_ApprovalG/" + sCompanyID + "/ExDocUserSign/" + getSignURL(GetAttribute(tempNode.selectSingleNode("img"), "src"));

                    field = message.GetListItem(fields, "habyuisign" + SignOrder);
                    if (field) {
                        if (GetAttribute(tempNode.selectSingleNode("img"), "width") == "" || GetAttribute(tempNode.selectSingleNode("img"), "width") == null)
                            var signWidth = 50;
                        else
                            var signWidth = ConversionPt(GetAttribute(tempNode.selectSingleNode("img"), "width"));

                        if (GetAttribute(tempNode.selectSingleNode("img"), "height") == "" || GetAttribute(tempNode.selectSingleNode("img"), "height") == null)
                            var signHeight = 28;
                        else
                            var signHeight = ConversionPt(GetAttribute(tempNode.selectSingleNode("img"), "height"));

                        if (signWidth > 70)
                            signWidth = 50;

                        if (signHeight > 48)
                            signHeight = 28;

                        var strimg = "<img src='" + RootURL + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(signPath) + "' border=0 embedding='1' ";
                        strimg = strimg + " width=" + signWidth;
                        strimg = strimg + " height=" + signHeight + ">";

                        field.innerHTML = SignText + strimg;
                    }
                }
            }

            if (message.GetListItem(fields, "linehab")) {
                if (Nodes.length > 4) {
                    fields["linehab"].style.display = "";
                    for (i = 0; i < fields["linehab"].childNodes.length; i++)
                        fields["linehab"].childNodes[i].style.display = "";
                }
                else {
                    fields["linehab"].style.display = "none";
                    for (i = 0; i < fields["linehab"].childNodes.length; i++)
                        fields["linehab"].childNodes[i].style.display = "none";
                }
            }
        }
        else {
            if (message.GetListItem(fields, "linehab")) {
                fields["linehab"].style.display = "none";
                for (i = 0; i < fields["linehab"].childNodes.length; i++)
                    fields["linehab"].childNodes[i].style.display = "none";
            }
        }
    } catch (e) { }


    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "foot/processinfo/regnumber");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/foot/processinfo/regnumber");
        }
        if (Nodes.length > 0) {
            field = message.GetListItem(fields, "docnumber");
            if (field) {
                setNodeText(field, getNodeText(Nodes[0]));
            }
            var regnumbercode = GetAttribute(Nodes[0], "regnumbercode");
            if (regnumbercode.length > 0) {
                message.document.body.setAttribute("deptid", regnumbercode.substring(0, 7));
                message.document.body.setAttribute("regnumbercode", regnumbercode.substring(7, regnumbercode.length));
                pOrgDocNumCode = regnumbercode;
            }
            else {
                message.document.body.setAttribute("deptid", "");
                message.document.body.setAttribute("regnumbercode", "");
                pOrgDocNumCode = "";
            }
        }
        else {
            field = message.GetListItem(fields, "docnumber");
            if (field) {
                setNodeText(field, "");
            }
            message.document.body.setAttribute("deptid", "");
            message.document.body.setAttribute("regnumbercode", "");
            pOrgDocNumCode = "";
        }
    } catch (e) { }


    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "foot/processinfo/enforcedate");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/foot/processinfo/enforcedate");
        }
        if (Nodes.length > 0) {
            field = message.GetListItem(fields, "enforcedate");
            if (field) {
                setNodeText(field, getNodeText(Nodes[0]));
            }
        }
    } catch (e) { }


    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "foot/processinfo/receipt");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/foot/processinfo/receipt");
        }
        if (Nodes.length > 0) {
            var tempNode = Nodes[0].selectSingleNode("number");
            if (tempNode) {
                field = message.GetListItem(fields, "receiptnumber");
                if (field) {
                    message.document.body.setAttribute("receiptnumber", field.value);
                    field.value = getNodeText(tempNode);
                }
                message.document.body.setAttribute("recvdeptid", "");
                message.document.body.setAttribute("recvdeptname", "");
                message.document.body.setAttribute("recvdocnum", "");
            }
            else {
                field = message.GetListItem(fields, "receiptnumber");
                if (field) {
                    message.document.body.setAttribute("receiptnumber", field.value);
                    field.value = "";
                }
                message.document.body.setAttribute("recvdeptid", "");
                message.document.body.setAttribute("recvdeptname", "");
                message.document.body.setAttribute("recvdocnum", "");
            }

            var ReceiptDateText = "";
            var tempNode = Nodes[0].selectSingleNode("date");
            if (tempNode) {
                ReceiptDateText = getNodeText(tempNode);
            }

            var tempNode = Nodes[0].selectSingleNode("time");
            if (tempNode) {
                ReceiptDateText = ReceiptDateText + " " + getNodeText(tempNode);
            }
            field = message.GetListItem(fields, "receiptdate");
            if (field) {
                setNodeText(field, ReceiptDateText);
            }
        }
        else {
            field = message.GetListItem(fields, "receiptnumber");
            if (field) {
                message.document.body.setAttribute("receiptnumber", field.value);
                setNodeText(field, "");
            }
            field = message.GetListItem(fields, "receiptdate");
            if (field) {
                setNodeText(field, getGyulJeDate());
            }
        }
    } catch (e) { }


    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "foot/sendinfo/zipcode");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/foot/sendinfo/zipcode");
        }
        if (Nodes.length > 0) {
            field = message.GetListItem(fields, "zipcode");
            if (field) {
                setNodeText(field, getNodeText(Nodes[0]));
            }
        }
    } catch (e) { }


    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "foot/sendinfo/address");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/foot/sendinfo/address");
        }
        if (Nodes.length > 0) {
            field = message.GetListItem(fields, "address");
            if (field) {
                setNodeText(field, getNodeText(Nodes[0]));
            }
        }
    } catch (e) { }


    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "foot/sendinfo/homeurl");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/foot/sendinfo/homeurl");
        }
        if (Nodes.length > 0) {
            field = message.GetListItem(fields, "homepage");
            if (field) {
                setNodeText(field, getNodeText(Nodes[0]));
            }
        }
    } catch (e) { }


    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "foot/sendinfo/telephone");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/foot/sendinfo/telephone");
        }
        if (Nodes.length > 0) {
            field = message.GetListItem(fields, "telephone");
            if (field) {
                setNodeText(field, getNodeText(Nodes[0]));
            }
        }
    } catch (e) { }


    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "foot/sendinfo/fax");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/foot/sendinfo/fax");
        }
        if (Nodes.length > 0) {
            field = message.GetListItem(fields, "fax");
            if (field) {
                setNodeText(field, getNodeText(Nodes[0]));
            }
        }
    } catch (e) { }


    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "foot/sendinfo/email");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/foot/sendinfo/email");
        }
        if (Nodes.length > 0) {
            field = message.GetListItem(fields, "email");
            if (field) {
                setNodeText(field, getNodeText(Nodes[0]));
            }
        }
    } catch (e) { }


    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "foot/sendinfo/publication");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/foot/sendinfo/publication");
        }
        if (Nodes.length > 0) {
            field = message.GetListItem(fields, "publication");
            if (field) {
                setNodeText(field, getNodeText(Nodes[0]));
                pPublicFlag = GetAttribute(Nodes[0], "code");
            }
        }
    } catch (e) { }

    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "foot/sendinfo/symbol");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/foot/sendinfo/symbol");
        }
        if (Nodes.length > 0) {
            field = message.GetListItem(fields, "symbol");
            if (field) {
                signPath = "/Upload_ApprovalG/" + sCompanyID + "/ExDocUserSign/" + getSignURL(GetAttribute(GetChildNodes(Nodes[0])[0], "src"));
                if (GetAttribute(GetChildNodes(Nodes[0])[0], "width") == "" || GetAttribute(GetChildNodes(Nodes[0])[0], "width") == null)
                    var signWidth = 70;
                else
                    var signWidth = ConversionPt(GetAttribute(GetChildNodes(Nodes[0])[0], "width"));

                if (GetAttribute(GetChildNodes(Nodes[0])[0], "height") == "" || GetAttribute(GetChildNodes(Nodes[0])[0], "height") == null)
                    var signHeight = 70;
                else
                    var signHeight = ConversionPt(GetAttribute(GetChildNodes(Nodes[0])[0], "height"));

                var strimg = "<img src='" + RootURL + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(signPath) + "' border=0 embedding='1' ";
                strimg = strimg + " width=" + signWidth;
                strimg = strimg + " height=" + signHeight + ">";
                field.innerHTML = strimg;
            }
        }
        else {
            field = message.GetListItem(fields, "symbol");
            if (field) {
                field.innerHTML = "";
            }
        }
    } catch (e) { field.innerHTML = ""; }


    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "foot/sendinfo/logo");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/foot/sendinfo/logo");
        }
        if (Nodes.length > 0) {
            field = message.GetListItem(fields, "logo");
            if (field) {
                signPath = "/Upload_ApprovalG/" + sCompanyID + "/ExDocUserSign/" + getSignURL(GetAttribute(GetChildNodes(Nodes[0])[0], "src"));

                if (GetAttribute(GetChildNodes(Nodes[0])[0], "width") == "" || GetAttribute(GetChildNodes(Nodes[0])[0], "width") == null)
                    var signWidth = 70;
                else
                    var signWidth = ConversionPt(GetAttribute(GetChildNodes(Nodes[0])[0], "width"));

                if (GetAttribute(GetChildNodes(Nodes[0])[0], "height") == "" || GetAttribute(GetChildNodes(Nodes[0])[0], "height") == null)
                    var signHeight = 70;
                else
                    var signHeight = ConversionPt(GetAttribute(GetChildNodes(Nodes[0])[0], "height"));

                var strimg = "<img src='" + RootURL + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(signPath) + "' border=0 embedding='1' ";
                strimg = strimg + " width=" + signWidth;
                strimg = strimg + " height=" + signHeight + ">";

                field.innerHTML = strimg;
            }   
        }
        else {
            field = message.GetListItem(fields, "logo");
            if (field) {
                field.innerHTML = "";
            }
        }
    } catch (e) { }


    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "foot/campaign/headcampaign");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/foot/campaign/headcampaign");
        }
        if (Nodes.length > 0) {
            field = message.GetListItem(fields, "headcampaign");
            if (field) {
                setNodeText(field, getNodeText(Nodes[0]));
            }
        }
        else {
            field = message.GetListItem(fields, "headcampaign");
            if (field) {
                setNodeText(field, "");
            }
        }
    } catch (e) { }

    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "foot/campaign/footcampaign");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/foot/campaign/footcampaign");
        }
        if (Nodes.length > 0) {
            field = message.GetListItem(fields, "footcampaign");
            if (field) {
                setNodeText(field, getNodeText(Nodes[0]));
            }
        }
        else {
            field = message.GetListItem(fields, "footcampaign");
            if (field) {
                setNodeText(field, "");
            }
        }
    } catch (e) { }


    try {
        var Nodes = null;
        if (CrossYN()) {
            Nodes = SelectNodes(eNodes, "attach/title");
        }
        else {
            Nodes = SelectNodes(eNodes, "pubdoc/attach/title");
        }
        if (Nodes.length > 0) {
            field = message.GetListItem(fields, "attachment");
            if (field) {
                var AttachmentText = "";
                var isFirst = true;

                for (i = 0; i < Nodes.length; i++) {
                    if (isFirst) {
                        AttachmentText = getNodeText(Nodes[i]);
                        isFirst = false;
                    }
                    else {
                        AttachmentText = ", " + getNodeText(Nodes[i]);
                    }
                }
                field.value = AttachmentText;
            }
        }
    } catch (e) { }

    message.document.body.setAttribute("ExtDocFlag", "Y");

    SetHref("UPD");
    SetDocInfo();
    SaveFile();
    SendAckForSend("", "accept");
    return true;
}

function SetHref(mode) {
    var xmlpara = createXmlDom();
    var xmlhttp = createXMLHttpRequest();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "pFileType", "mht");
    createNodeAndInsertText(xmlpara, objNode, "pMode", mode);
    xmlhttp.open("POST", "/myoffice/ezApprovalG/ReceivUI/aspx/setHref.aspx", false);
    xmlhttp.send(xmlpara);
}

function Decode(text) {
    var doc;
    var tags;
    var enumTag;
    var tagNames = new Array("TABLE", "TD", "COL", "IMG", "COLGROUP", "TH", "P");
    var i, j;

    var pzDoc = new ActiveXObject("PzDNAClass.PzHTMLDocument");
    pzDoc.async = false;
    pzDoc.HTMLText = "<Html>" + text + "</Html>"
    doc = pzDoc.Document

    for (i = 0; i < tagNames.length; i++) {
        tags = doc.all.tags(tagNames[i]);
        for (j = 0; j < tags.length; j++) {
            var enumTag = tags[j];
            if (enumTag.width != "") {
                if (tagNames[i] == "p" || tagNames[i] == "P") {
                    if (!enumTag.style.marginTop)
                        enumTag.style.marginTop = "0mm";
                    if (!enumTag.style.marginBottom)
                        enumTag.style.marginBottom = "0mm";
                    if (enumTag.style.lineHeight)
                        if (enumTag.style.lineHeight.indexOf("%") < 0)
                            enumTag.style.lineHeight = ConversionPt(enumTag.style.lineHeight) + "pt";
                    if (enumTag.innerHTML == "")
                        enumTag.innerHTML = "&nbsp;";
                }
                else {
                    enumTag.width = ConversionPt(enumTag.width) + "pt";
                }
            }

            if (enumTag.tagName != "COL" && enumTag.tagName != "COLGROUP" && enumTag.tagName != "P") {
                if (enumTag.height != "") {
                    enumTag.height = ConversionPt(enumTag.height) + "pt";
                }
            }

            if (enumTag.tagName == "TABLE") {
                if (!enumTag.cellPadding)
                    enumTag.cellPadding = 0;
                if (!enumTag.cellSpacing)
                    enumTag.cellSpacing = 0;
                if (enumTag.border == 1) {
                    enumTag.borderColorDark = "white";
                    enumTag.borderColorLight = "black";
                }
            }
        }
    }

    return doc.body.innerHTML;
}

function getSignURL(SignURL) {
    var rtnVal = "";
    for (i = 0; i < pRelayDocInfo.getElementsByTagName("SignName").length; i++) {
        if (getNodeText(pRelayDocInfo.getElementsByTagName("SignName").item(i)).toLowerCase() == SignURL.toLowerCase())
            rtnVal = getNodeText(pRelayDocInfo.getElementsByTagName("RealSignName").item(i));
    }
    return rtnVal;
}

function SetDocInfo() {
    var xmlpara = createXmlDom();
    var xmlhttp = createXMLHttpRequest();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "pPublicFlag", pPublicFlag);
    createNodeAndInsertText(xmlpara, objNode, "pDocNo", pDocNo);
    createNodeAndInsertText(xmlpara, objNode, "pDocNumCode", pDocNumCode);
    createNodeAndInsertText(xmlpara, objNode, "pOrgDocNumCode", pOrgDocNumCode);
    createNodeAndInsertText(xmlpara, objNode, "pMode", "I");
    createNodeAndInsertText(xmlpara, objNode, "pFileType", "mht");
    xmlhttp.open("POST", "aspx/setRecvDocInfo.aspx", false);
    xmlhttp.send(xmlpara);
}

function convertDate(datestring) {
    try {
        var datedim = datestring.split(".");
        if (datedim.length > 1) {
            return datedim[1] + "/" + datedim[2];
        }
        else {
            var datedim2 = datestring.split("-");
            if (datedim2.length > 1) {
                return datedim2[1] + "/" + datedim2[2];
            }
            else {
                return datestring;
            }
        }
    }
    catch (e) {
        return datestring;
    }
}

function btnReqReSend_onclick() {
    var url = "/myoffice/ezApprovalG/ezRETOPINION_Cross.aspx";
    var feature = "status:no;dialogWidth:420px;dialogHeight:270px;help:no;scroll:no"
    feature = feature + GetShowModalPosition(420, 270);
    var ret = window.showModalDialog(url, null, feature);

    if (ret[0]) {
        var pRetMsg = ret[1];
        pRetMsg = ReplaceText(pRetMsg, "\n", "<br>");
        pRetMsg = ReplaceText(pRetMsg, "&", "&amp;");
        pRetMsg = ReplaceText(pRetMsg, "<", "&lt;");
        pRetMsg = ReplaceText(pRetMsg, ">", "&gt;");

        SendAckForSend(pRetMsg, "req-resend");
    }
}

function getDraftUserInfo() {
        try {
        	var result = "";
        	$.ajax({
        		type : "POST",
        		dataType : "text",
        		async : false,
        		url : "/ezOrgan/getADInfos.do",
        		data : {
        			cn : pUserID,
        			prop : "displayName;mail;description;company;facsimileTelephoneNumber;telephoneNumber;streetaddress;postalcode",
        			cate  : "user"
        		},
        		success: function(xml){
        			result = xml;
        		}        			
        	});
        	
            xmluserInfo = loadXMLString(result);

        } catch (e) {
            alert("getDraftUserInfo()" + e.description);
        }
}

function GetDraftAprLineInfo(ret) {
    try {
        var xmlKuljea;
        var chamjo;
        var hapyuiCnt;
        var SignCnt;
        var referCnt;
        var xmlReDraft;

        var objNodes;
        var FormProc;
        var fields;
        var findstring;
        var count;
        var i;
        var name;

        var OrderType = new Array();
        var OrderTypeName = new Array();
        var OrderDept = new Array();
        var OrderName = new Array();
        var OrderStat = new Array();
        var OrderStatName = new Array();
        var OrderJobtitle = new Array();
        var OrderReason = new Array();
        var OrderSuggester = new Array();
        var OrderReporter = new Array();

        var xmldom = createXmlDom();

        if (ret[5] == undefined) {
            xmlKuljea = ret[0];
            xmlReDraft = ret[2];
        }
        else {
            xmlKuljea = ret[1];
            xmlReDraft = ret[5];
        }


        setAprLinesXML(xmlKuljea);

        ClearDocCellInfo();
        if (xmlReDraft == "C") {
            ApplyDocCellInfo();
        }
        else if (xmlReDraft == "R") {
            ClearDocCellInfo();
        }


        xmldom = loadXMLString(xmlKuljea);

        objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");

        fields = message.GetFieldsList();

        count = objNodes.length;


        var susinSN = "";
        if (pDraftFlag == "SUSIN" || pDocState == "011") {
            susinSN = pSusinSN
        }

        for (i = 1; i < 20; i++) {
            name = susinSN + "habyuisign" + i
            field = message.GetListItem(fields, name);

            if (field) {
                name = susinSN + "habyui" + i
                field = message.GetListItem(fields, name);

                if (field) {
                    setNodeText(field, " ");
                }

                fieldname = susinSN + "habyuisign" + i;
                field = message.GetListItem(fields, fieldname);

                if (field) {
                    setNodeText(field, " ");
                }

                fieldname = susinSN + "habyuipositon" + i;
                field = message.GetListItem(fields, fieldname);

                if (field) {
                    setNodeText(field, " ");
                }


                fieldname = susinSN + "habyuidate" + i;
                field = message.GetListItem(fields, fieldname);

                if (field) {
                    setNodeText(field, " ");
                }
            }
            else {
                break;
            }
        }


        field = message.GetListItem(fields, "refer");
        if (field) setNodeText(field, "");


        field = message.GetListItem(fields, "hgamsa");

        if (field) setNodeText(field, "");


        for (i = 1; i < fields.Count; i++) {
            field = message.GetListItem(fields, "gongram" + i);
            if (field) setNodeText(field, "");
        }


        for (i = 0; i < count; i++) {
            var Cell = GetChildNodes(objNodes[i]);
            var KyljeaOrder = getNodeText(Cell[0]);
            var KyljeaName = getNodeText(Cell[1]);
            var KyljeaDeptName = getNodeText(Cell[3]);
            var KyljeaType = getNodeText(Cell[16]);
            var KyljeaTypeName = getNodeText(Cell[4]);
            var KyljeaStat = getNodeText(Cell[17]);
            var KyljeaStatName = getNodeText(Cell[5]);
            var KyljeaJobtitle = getNodeText(Cell[2]);
            var ReasonDoNotApprov = getNodeText(Cell[12]);

            var suggester = getNodeText(Cell[13]);
            var reporter = getNodeText(Cell[14]);
            
            if (KyljeaType == "003") {
       			continue;
       		}

            OrderType[KyljeaOrder] = KyljeaType;
            OrderTypeName[KyljeaOrder] = KyljeaTypeName;
            OrderName[KyljeaOrder] = KyljeaName;
            OrderDept[KyljeaOrder] = KyljeaDeptName;
            OrderStat[KyljeaOrder] = KyljeaStat;
            OrderStatName[KyljeaOrder] = KyljeaStatName;
            OrderJobtitle[KyljeaOrder] = KyljeaJobtitle;
            OrderReason[KyljeaOrder] = ReasonDoNotApprov;
            OrderSuggester[KyljeaOrder] = suggester;
            OrderReporter[KyljeaOrder] = reporter;
        }

        if (isSplit == "Y")
            SplitSign(OrderType, OrderName, OrderDept, OrderStat, OrderJobtitle);

        LastSignSN = OrderType.length

        CurAprType = OrderType[1];
        if (OrderType.length > 2)
            NextAprType = OrderType[2];

        for (i = 1; i < OrderType.length; i++) {
            if (OrderType[i] == strAprType4 || OrderType[i] == strAprType16) {
                LastSignSN = i;
                i = OrderType.length
            }
            else if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType3)
                LastSignSN = i;
        }


        lastKyulName = OrderName[LastSignSN]
        lastKyuljiwee = OrderJobtitle[LastSignSN]
        var field = message.GetListItem(fields, "lastKyuljikwee");
        if (field)
            setNodeText(field, lastKyuljiwee);

        var field = message.GetListItem(fields, "lastKyulName")
        if (field)
            setNodeText(field, lastKyulName);

        hapyuiCnt = 1;
        SignCnt = 1;
        referCnt = 1;
        gongramCnt = 1;

        var fieldname;
        var field;
        var refer = "";


        for (i = 1; i < 10; i++) {
            fieldname = susinSN + "jikwe" + i
            field = message.GetListItem(fields, fieldname);

            if (field) {
                field.Value = " ";
                fieldname = susinSN + "sign" + i
                field = message.GetListItem(fields, fieldname);
                if (field)
                    setNodeText(field, " ");
            } else {
                break;
            }
        }

        for (i = 1; i < 10; i++) {
            fieldname = "hjkwe" + i
            field = message.GetListItem(fields, fieldname);

            if (field) {
                setNodeText(field, " ");
            } else {
                break;
            }
        }

        var idx = 1;
        var hidx = 1;

        for (i = 1; i < OrderJobtitle.length; i++) {
            if (OrderType[i] == strAprType18 || OrderType[i] == strAprType19 || OrderType[i] == strAprType1 || OrderType[i] == strAprType1 || OrderType[i] == strAprType4 || OrderType[i] == strAprType16 || OrderType[i] == strAprType3) {
                fieldname = susinSN + "jikwe" + idx;
                field = message.GetListItem(fields, fieldname);

                if (field) {
                    var jikweName = trim(getNodeText(field));
                    if (jikweName.substring(0, 1) != strLang128)
                        setNodeText(field, OrderJobtitle[i]);

                    if (OrderSuggester[i] == "Y")
                        setNodeText(field, strLang75 + getNodeText(field));

                    if (OrderReporter[i] == "Y")
                        setNodeText(field, strLang76 + getNodeText(field));
                }

                fieldname = susinSN + "sign" + idx;
                field = message.GetListItem(fields, fieldname);

                if (field) {
                }
                idx = idx + 1;
            }
            else if (OrderType[i] == strAprType8 || OrderType[i] == strAprType9 || OrderType[i] == strAprType11 || OrderType[i] == strAprType12) {
                fieldname = susinSN + "habyui" + hidx;
                field = message.GetListItem(fields, fieldname);
                if (field) {
                    setNodeText(field, OrderDept[i]);
                }

                fieldname = susinSN + "habyuipositon" + hidx;
                field = message.GetListItem(fields, fieldname);
                if (field) {
                    var jikweName = trim(getNodeText(field));

                    if (OrderSuggester[i] == "Y")
                        setNodeText(field, strLang75 + getNodeText(field));

                    if (OrderReporter[i] == "Y")
                        setNodeText(field, strLang76 + getNodeText(field));
                }
                hidx = hidx + 1;
            }
        }

        if (message.GetListItem(fields, "lineapr")) {
            if (idx > 5) {
                message.GetListItem(fields, "lineapr").style.display = "";
                for (i = 0; i < message.GetListItem(fields, "lineapr").childNodes.length; i++) {
                    if (message.GetListItem(fields, "lineapr").childNodes[i].nodeType == "1") {
                        message.GetListItem(fields, "lineapr").childNodes[i].style.display = "";
                    }
                }
            }
            else {
                message.GetListItem(fields, "lineapr").style.display = "none";
                for (i = 0; i < message.GetListItem(fields, "lineapr").childNodes.length; i++) {
                    if (message.GetListItem(fields, "lineapr").childNodes[i].nodeType == "1") {
                        message.GetListItem(fields, "lineapr").childNodes[i].style.display = "none";
                    }
                }
            }
        }

        if (message.GetListItem(fields, "linehab")) {
            if (hidx > 5) {
                message.GetListItem(fields, "linehab").style.display = "";
                for (i = 0; i < message.GetListItem(fields, "linehab").childNodes.length; i++) {
                    if (message.GetListItem(fields, "linehab").childNodes[i].nodeType == "1") {
                        message.GetListItem(fields, "linehab").childNodes[i].style.display = "";
                    }
                }
            }
            else {
                message.GetListItem(fields, "linehab").style.display = "none";
                for (i = 0; i < message.GetListItem(fields, "linehab").childNodes.length; i++) {
                    if (message.GetListItem(fields, "linehab").childNodes[i].nodeType == "1") {
                        message.GetListItem(fields, "linehab").childNodes[i].style.display = "none";
                    }
                }
            }
        }

    } catch (e) {
        alert("GetDraftAprLineInfo(ret)" + e.description);
    }
}

function ApplyDocCellInfo() {
    try {
        var i;
        var j;
        var k;
        var fieldname;
        var fieldvalue;

        var fields = message.GetFieldsList();

        for (j = 1 ; j <= hapyuiCount ; j++) {
            fieldname = "habyuidate" + j;
            field = message.GetListItem(fields, fieldname);
            if (field) {
                fieldvalue = getNodeText(field);
                fieldvalue = trim_Cross(fieldvalue);
                if (fieldvalue == "") {
                    fieldname = "habyui" + j;
                    field = message.GetListItem(fields, fieldname);
                    if (field)
                        setNodeText(field, "");
                }
            }
        }
    } catch (e) {
        alert("ApplyDocCellInfo : " + e.description);
    }
}

function ClearDocCellInfo() {
    try {
        var i;
        var j;
        var k;
        var fieldname;
        var susunSN = "";
        var fields = message.GetFieldsList();

        if (pDraftFlag == "SUSIN" || pDocState == "011") susunSN = pSusinSN;

        for (i = 1; i <= SignCount ; i++) {
            fieldname = susunSN + "sign" + i;
            field = message.GetListItem(fields, fieldname);
            if (field)
                setNodeText(field, " ");

            fieldname = susunSN + "seumyung" + i;
            field = message.GetListItem(fields, fieldname);
            if (field)
                setNodeText(field, " ");

            fieldname = susunSN + "seumyungdate" + i;
            field = message.GetListItem(fields, fieldname);
            if (field)
                setNodeText(field, " ");

            fieldname = susunSN + "jikwe" + i;
            field = message.GetListItem(fields, fieldname);

            if (field)
                setNodeText(field, " ");
        }

        for (j = 1 ; j <= hapyuiCount ; j++) {
            fieldname = susunSN + "habyui" + j;
            field = message.GetListItem(fields, fieldname);
            if (field)
                setNodeText(field, " ");

            fieldname = susunSN + "habyuipositon" + j;
            field = message.GetListItem(fields, fieldname);
            if (field)
                setNodeText(field, " ");

            fieldname = susunSN + "habyuidate" + j;
            field = message.GetListItem(fields, fieldname);
            if (field)
                setNodeText(field, " ");

            fieldname = susunSN + "habyuisign" + j;
            field = message.GetListItem(fields, fieldname);
            if (field)
                setNodeText(field, " ");
        }
    } catch (e) {
        alert("ClearDocCellInfo : " + e.description);
    }
}

function SetPropertyValue() {
    try {
        var fields = message.GetFieldsList();
        if (!fields) return;

        var fieldname;
        var field;
        var pSusinNextSN;
        var objNodes;
        var CurrentDate;
        objNodes = GetChildNodes(xmluserInfo.documentElement);


        CurrentDate = getGyulJeDate();
        SignInfo = "";
        hapyuiCount = 0;
        SignCount = 0;

        for (i = 0; i < fields.length; i++) {
            var field = fields[i];
            if (!fields) return;

            if (pDraftFlag == "HAPYUI" || pDraftFlag == "GAMSABU" || pDraftFlag == "WHOKYUL") {
                switch (field.id) {
                    case "enforcedate":
                        break;
                    case "recipient":
                        break;
                    case "refer":
                        break;
                    case "zipcode":
                        setNodeText(field, getNodeText(objNodes[7]));
                        break;
                    case "address":
                        setNodeText(field, getNodeText(objNodes[6]));
                        break;
                    case "telephone":
                        setNodeText(field, getNodeText(objNodes[5]));
                        break;
                    case "fax":
                        setNodeText(field, getNodeText(objNodes[5]));
                        break;
                    case "department":
                        setNodeText(field, getNodeText(objNodes[2]));
                        break;
                    case "parantdept":
                        setNodeText(field, getNodeText(objNodes[3]));
                        break;
                    case "seniorposition":
                        break;
                    case "seniorname":
                        break;
                    case "charge":
                        setNodeText(field, getNodeText(objNodes[0]));
                        break;
                    case "position":
                        setNodeText(field, arr_userinfo[3]);
                        break;
                    case "keepperiod":
                        break;
                    case "publication":
                        break;
                    case "examname":
                        break;
                    case "examdate":
                        break;
                    case "headcampaign":
                        setNodeText(field, getNodeText(objNodes[3]));
                        break;
                    case "deptname":
                        setNodeText(field, arr_userinfo[5]);
                        break;
                    case "seal":
                        setNodeText(field, getNodeText(objNodes[3]) + strLang157);
                        break;
                    case "username":
                        setNodeText(field, arr_userinfo[2]);
                        break;
                    case "draftername":
                        setNodeText(field, arr_userinfo[2]);
                        break;
                    case "draftdate":
                        setNodeText(field, CurrentDate);
                        break;
                    case "receiptdate":
                        setNodeText(field, CurrentDate);
                        break;
                }
            }
            else {
                switch (field.id) {
                    case "receiptdate":
                        setNodeText(field, CurrentDate);
                        break;
                    case pSusinSN + "receiptdate":
                        setNodeText(field, CurrentDate);
                        break;
                    case "susinhide":
                        field.style.display = 'none'
                        break;
                    case "susinhideP":
                        field.style.display = 'none'
                        break;
                    case "susinbody":
                        field.style.display = ''
                        setMenuBar("btnEdit", true);
                        break;
                }
            }

            if (pDraftFlag == "SUSIN" || pDocState == "011") {
                var pSignSusin = pSusinSN + "sign";
                if (field.id.substr(0, 5) == pSignSusin) {
                    SignCount = SignCount + 1;
                }
            } else {
                if (field.id.substr(0, 4) == "sign") {
                    SignCount = SignCount + 1;
                }
            }

            var pSignSusin = pSusinSN + "habyuisign";
            if (field.id.substr(0, 11) == pSignSusin) {
                hapyuiCount = hapyuiCount + 1;
            }

            if (field.id.substr(0, 7) == "gongram") {
                gongramCount = gongramCount + 1;
            }


            if (pDraftFlag == "SUSIN" || pSusinSN != "0") {
                var pSignInfoSusin = pSusinSN + "jikwe";
                if (field.id.substr(0, 6) == pSignInfoSusin) {
                    if (SignInfoFlag) {
                        SignInfo = getNodeText(field);
                        SignInfoFlag = false;
                    } else {
                        SignInfo = getNodeText(field) + ";" + SignInfo;
                    }
                }
            }
            else {
                if (field.id.substr(0, 5) == "jikwe") {
                    if (SignInfoFlag) {
                        SignInfo = getNodeText(field);
                        SignInfoFlag = false;
                    }
                    else {
                        SignInfo = getNodeText(field) + ";" + SignInfo;
                    }
                }
            }
        }
        pSuSinFlag = "N";

        if (pDraftFlag != "SUSIN" && pDocState != "011") {
            var RtnVal = message.GetListItem(fields, "recipient");
            if (RtnVal != null) {
                pSuSinFlag = "Y";
            } else {
                pSuSinFlag = "N";
            }
        }

        if (pSusinSN)
            pSusinNextSN = parseInt(pSusinSN) + 1;
        else
            pSusinNextSN = 1;

        fieldname = pSusinNextSN + "sign1";
        field = message.GetListItem(fields, fieldname);

        if (field) {
            pSuSinFlag = "Y";
            btnSetReceivLine.style.display = "";
        }

        RtnVal = message.GetListItem(fields, "refer");
        if (RtnVal != null) {
            pChamJoFlag = "Y";
        } else {
            pChamJoFlag = "N";
        }

        pChamJoFlag = "Y";

    } catch (e) {
        alert("SetAutoPropertyValue : " + e.description);
    }
}



var ezchkpasswd_cross_dialogArguments = new Array();
function chk_Passwd() {
    var parameter = pUserID;
    var url = "/myoffice/ezApprovalG/ezchkPasswd_Cross.aspx";

    ezchkpasswd_cross_dialogArguments[0] = parameter;
    ezchkpasswd_cross_dialogArguments[1] = chk_Passwd_Complete;

    DivPopUpShow(330, 200, url);
}

function btnSetTaskCode_onclick() {
    try {
        var para = new Array();
        para[0] = cabinetID;
        var url = "/myoffice/ezApprovalG/ezCabinet/SelectCabinet.aspx?initFlag=1";
        var feature = "dialogWidth:850px;dialogHeight:455px;scroll:no;resizable:no;status:no; help:no;edge:sunken";
        feature = feature + GetShowModalPosition(850, 455);

        if (url != "")
            var rtn = window.showModalDialog(url, para, feature);


        if (rtn[0] == "TRUE") {
            var g_SelCabXml = rtn[1];
            var xmlCab = createXmlDom();
            xmlCab = loadXMLString(g_SelCabXml);

            cabinetID = getNodeText(SelectNodes(xmlCab, "CABINETINFO/CABINET/CABINETID")[0]);
            TaskCode = getNodeText(SelectNodes(xmlCab, "CABINETINFO/CABINET/TASKCODE")[0]);
        }
    } catch (e) {
        alert("btnSetTaskCode_onclick : " + e.description);
    }
}

function CheckSepAttParamXmlNull(g_SepAttachLVXml) {
    var sepAtt, Data, i;
    var rtnVal = true;
    if (g_SepAttachLVXml != "") {
        var sepLVXml = createXmlDom();
        sepLVXml = loadXMLString(g_SepAttachLVXml);

        var rows = SelectNodes(sepLVXml, "LISTVIEWDATA/ROWS/ROW");

        for (i = 0; i < rows.length; i++) {
            if (getNodeText(rows[i].childNodes[0].getElementsByTagName("DATA1")[0]) == "")
                rtnVal = false;
        }
    }
    return rtnVal;
}

var aprsign1_cross_dialogArguments = new Array();
function openSignUI() {
    try {

        var objRoot;
        var objNode;
        var SignNodeList;

        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);

        xmlhttp.open("Post", "/myoffice/ezApprovalG/ezAPRSIGN/aspx/GetSignRequest.aspx", false);
        xmlhttp.send(xmlpara);

        SignNodeList = SelectNodes(loadXMLString(xmlhttp.responseText), "LISTVIEWDATA/ROWS/ROW");

        if (SignNodeList.length != 0) {
            var parameter = pUserID;

            aprsign1_cross_dialogArguments[0] = parameter;
            aprsign1_cross_dialogArguments[1] = openSignUI_Complete;

            DivPopUpShow(350, 310, "/myoffice/ezApprovalG/ezAPRSIGN/AprSign1_Cross.aspx");
        } else {
            openSignUI_Complete("NAME");
        }
    } catch (e) {
        alert("openSignUI : " + e.description);
    }
}

function SendDraftMappingSign(ret) {
    try {
        var fields = message.GetFieldsList();
        var field;
        var psigncell;
        var pseumyungcell;
        var pseumyungdatecell;
        var signInfo = new Array();
        var signCnt;
        var sn = 1;

        var OpinionText = "";
        var PositionText = "";
        if (getOpinionCount()) {
            PositionText = "(" + strLang5;
        }

        if (LastSignSN == 1 || CurAprType == strAprType4 || CurAprType == strAprType16) {
            OpinionText = getSignDate() + "<br>";
        }

        signCnt = 0;
        if (pDraftFlag == "SUSIN" || pDocState == "011") {
            psigncell = pSusinSN + "sign" + sn;
            pseumyungcell = pSusinSN + "jikwe" + sn;
            pseumyungdatecell = pSusinSN + "seumyungdate" + sn;
        } else {
            psigncell = "sign" + sn;
            pseumyungcell = "jikwe" + sn;
            pseumyungdatecell = "seumyungdate" + sn;
        }


        var RtnVal = getGyulJeDate();
        var CurrentDate = RtnVal.split(".");
        var s = CurrentDate[1] + "." + CurrentDate[2];

        var field = message.GetListItem(fields, psigncell);
        var signWidth = field.offsetWidth
        var signHeight = field.offsetHeight

        if (signWidth > signHeight) {
            signHeight = signHeight - 15;
            signWidth = signHeight;
        } else {
            signWidth = signWidth - 15;
            sighHeight = signWidth
        }
        var field = message.GetListItem(fields, pseumyungdatecell);
        if (field) {
            setNodeText(field , s);
            signWidth = 50;
            signHeight = 50;
        } else {
        	signWidth = 50;
            signHeight = 28;
        }

        var strimg;
        var SingFlag = true;
        var DekyulFlag = false;

        var field = message.GetListItem(fields, pseumyungcell);
        if (field) {
            setNodeText(field, getNodeText(field) + PositionText);
        }

        if (CurAprType == strAprType16) {
            var field = message.GetListItem(fields, psigncell);
            if (field) {

                if (ret != "NAME") {
                    strimg = "<img src='" + document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(ret) + "' border=0 embedding='1' ";
                    strimg = strimg + " width=" + signWidth;
                    strimg = strimg + " height=" + signHeight + " spath='" + escape(ret) + "'>";

                    field.innerHTML = strLang7 + OpinionText + strimg;

                    signInfo[signCnt] = psigncell;
                    SignType[signCnt] = "IMAGE";
                    SignName[signCnt] = psigncell;
                    SignContent[signCnt] = ret + "::" + strLang7 + OpinionText;

                    signCnt = signCnt + 1
                    SingFlag = true;
                }
                else {
                    strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</P>"
                    field.innerHTML = strLang7 + OpinionText + strimg;
                    signInfo[signCnt] = psigncell;
                    SignType[signCnt] = "HTML";
                    SignName[signCnt] = psigncell;
                    SignContent[signCnt] = strLang7 + OpinionText + strimg;
                    signCnt = signCnt + 1
                    SingFlag = false;
                }
            }
            DekyulFlag = true;
            sn = sn + 1;
            if (pDraftFlag == "SUSIN" || pDocState == "011") {
                psigncell = pSusinSN + "sign" + sn;
                pseumyungcell = pSusinSN + "jikwe" + sn;
                pseumyungdatecell = pSusinSN + "seumyungdate" + sn;
            } else {
                psigncell = "sign" + sn;
                pseumyungcell = "jikwe" + sn;
                pseumyungdatecell = "seumyungdate" + sn;
            }
        }

        if (DekyulFlag && NextAprType == strAprType4) {
            var field = message.GetListItem(fields, psigncell);
            if (field) {
                field.innerHTML = strLangAprType4;
                signInfo[signCnt] = psigncell;
                SignType[signCnt] = "TEXT";
                SignName[signCnt] = psigncell;
                SignContent[signCnt] = strLangAprType4;
                signCnt = signCnt + 1
                SingFlag = false;
            }
        }
        else if (DekyulFlag) {
        }
        else {
            var field = message.GetListItem(fields, psigncell);
            if (field) {

                if (ret != "NAME") {
                    strimg = "<img src='" + document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(ret) + "' border=0 embedding='1' ";
                    strimg = strimg + " width=" + signWidth;
                    strimg = strimg + " height=" + signHeight + " spath='" + escape(ret) + "'>";

                    if (CurAprType == strAprType4)
                        OpinionText = strLangAprType4 + OpinionText;

                    field.innerHTML = OpinionText + strimg;

                    signInfo[signCnt] = psigncell;
                    SignType[signCnt] = "IMAGE";
                    SignName[signCnt] = psigncell;
                    SignContent[signCnt] = ret + "::" + OpinionText;

                    signCnt = signCnt + 1
                    SingFlag = true;
                }
                else {
                    if (field) {
                        strimg = "<P style=\"FONT-WEIGHT:900;FONT-SIZE:10pt;FONT-FAMILY:" + strLang9 + "\">" + arr_userinfo[2] + "</P>"
                        if (CurAprType == strAprType4)
                            OpinionText = strLangAprType4 + OpinionText;
                        field.innerHTML = OpinionText + strimg;
                        signInfo[signCnt] = psigncell;
                        SignType[signCnt] = "HTML";
                        SignName[signCnt] = psigncell;
                        SignContent[signCnt] = OpinionText + strimg;
                        signCnt = signCnt + 1
                        SingFlag = false;
                    }
                }
            }
        }
        return signInfo;
    } catch (e) {
        alert("SendDraftMappingSign(ret)" + e.description);
    }
}

function getSignDate() {
    var GyulJeDate;
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "getDate", "");

    xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/GetSignDate.aspx", false);
    xmlhttp.send(xmlpara);
    GyulJeDate = xmlhttp.responseText;
    return GyulJeDate;
}

function getOpinionCount() {
    try {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "chkFlag", "ING");

        xmlhttp.open("POST", "/myoffice/ezApprovalG/ezAPROPINION/aspx/GetOpinionCount.aspx", false);
        xmlhttp.send(xmlpara);

        var tempValue = parseInt(xmlhttp.responseText)
        if (tempValue > 0) {
            return true;
        }
        else {
            return false;
        }
    } catch (e) {
        return false;
    }
}

function UndoSignInfo(signInfo) {
    try {
        var cnt
        var fields = message.GetFieldsList();
        var field;

        if (signInfo) {
            for (cnt = 0; cnt < signInfo.length; cnt++) {
                field = message.GetListItem(fields, signInfo[cnt])
                if (field)
                    setNodeText(field, " ");
            }
        }
    } catch (e) {
        alert("UndoSignInfo : " + e.description);
    }
}

function SetBtnStateTrue() {
    try {
        setMenuBar("btnOpinion", true);
        setMenuBar("btnPrint", true);
        btnClose.Enable = "true";
    } catch (e) {
        alert("SetBtnStateTrue : " + e.description);
    }
}

function SaveDraftDocInfo() {
    var rtnVal;
    SaveFile();
    SignSave();

    rtnVal = SaveDraftDocInfo_susin();
    return rtnVal;
}

function SaveDraftDocInfo_susin() {
    try {

        if (pDocNumCode == "")
            return "FLASE";

        var fields = message.GetFieldsList();
        var field;
        var objRoot;
        var objNode;
        var field;

        var objNodes = GetChildNodes(xmldoc.documentElement);

        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();
        var xmlRtn = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "DocID", getNodeText(objNodes[0]));
        createNodeAndInsertText(xmlpara, objNode, "FormID", getNodeText(objNodes[1]));
        createNodeAndInsertText(xmlpara, objNode, "OrgDocID", getNodeText(objNodes[2]));
        createNodeAndInsertText(xmlpara, objNode, "DocType", getNodeText(objNodes[3]));
        createNodeAndInsertText(xmlpara, objNode, "DocState", getNodeText(objNodes[4]));
        createNodeAndInsertText(xmlpara, objNode, "FunctionType", strAprState2);
        createNodeAndInsertText(xmlpara, objNode, "Href", getNodeText(objNodes[6]));
        field = message.GetListItem(fields, "doctitle");
        createNodeAndInsertText(xmlpara, objNode, "DocTitle", getNodeText(field));

        var field = message.GetListItem(fields, "deptshortedname");
        if (field) {
            createNodeAndInsertText(xmlpara, objNode, "DocNo", getfieldValue(field));
        }
        else {

            var field = message.GetListItem(fields, "docnumber")
            if (field) {
                var pExtDocFlag = message.document.body.getAttribute("extdocflag")
                var field_receiptnum = message.GetListItem(fields, "receiptnumber");
                if (field_receiptnum) {
                    if (pExtDocFlag != null && pExtDocFlag == "Y" && getfieldValue(field_receiptnum).trim() != "") {
                        createNodeAndInsertText(xmlpara, objNode, "DocNo", getfieldValue(field_receiptnum));
                    } else {
                        createNodeAndInsertText(xmlpara, objNode, "DocNo", getfieldValue(field));
                    }
                } else {
                    createNodeAndInsertText(xmlpara, objNode, "DocNo", getfieldValue(field));
                }
            }
            else {
                var field = message.GetListItem(fields, "bedocnumber")
                if (field)
                    createNodeAndInsertText(xmlpara, objNode, "DocNo", getfieldValue(field));
                else
                    createNodeAndInsertText(xmlpara, objNode, "DocNo", "");
            }
        }


        createNodeAndInsertText(xmlpara, objNode, "HasAttachYN", pHasAttachYN);
        createNodeAndInsertText(xmlpara, objNode, "HasOpinionYN", "");
        createNodeAndInsertText(xmlpara, objNode, "StartDate", "DRAFT");
        createNodeAndInsertText(xmlpara, objNode, "EndDate", "DRAFT");
        createNodeAndInsertText(xmlpara, objNode, "WriterID", getNodeText(objNodes[13]));
        createNodeAndInsertText(xmlpara, objNode, "WriterName", getNodeText(objNodes[14]));
        createNodeAndInsertText(xmlpara, objNode, "WriterJobTitle", getNodeText(objNodes[15]));
        createNodeAndInsertText(xmlpara, objNode, "WriterDeptID", getNodeText(objNodes[16]));
        createNodeAndInsertText(xmlpara, objNode, "WriterDeptName", getNodeText(objNodes[17]));
        createNodeAndInsertText(xmlpara, objNode, "Html", message.Get_EditorBodyHTML());
        createNodeAndInsertText(xmlpara, objNode, "OrgHtml", pOrgHtml);
        createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
        createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[2]);
        createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "security", tempSecurity);
        createNodeAndInsertText(xmlpara, objNode, "keepperiod", tempKeep);
        createNodeAndInsertText(xmlpara, objNode, "publication", tempPublic);
        createNodeAndInsertText(xmlpara, objNode, "Public", "");
        createNodeAndInsertText(xmlpara, objNode, "ItemCode", tempItemCode);
        createNodeAndInsertText(xmlpara, objNode, "ItemName", tempItemName);
        createNodeAndInsertText(xmlpara, objNode, "UrgentApproval", tempUrgent);
        createNodeAndInsertText(xmlpara, objNode, "KeyWord", tempKeyword);
        createNodeAndInsertText(xmlpara, objNode, "Xdocid", "");
        createNodeAndInsertText(xmlpara, objNode, "SPECIALRECORDCODE", pSpecialRecordCode);
        createNodeAndInsertText(xmlpara, objNode, "PUBLICITYCODE", pPublicityCode);
        createNodeAndInsertText(xmlpara, objNode, "LIMITRANGE", pLimitRange);
        createNodeAndInsertText(xmlpara, objNode, "PAGENUM", pPageNum);
        createNodeAndInsertText(xmlpara, objNode, "CABINETID", cabinetID);
        createNodeAndInsertText(xmlpara, objNode, "TASKCODE", TaskCode);

        createNodeAndInsertText(xmlpara, objNode, "DOCNUMCODE", pDocNumCode);
        createNodeAndInsertText(xmlpara, objNode, "ORGDOCNUMCODE", pOrgDocNumCode);
        var g_SepAttachLVXml = "";
        g_SepAttachLVXml = message.DocumentBodyGetAttribute("SepAttachLVXml");
        if (!g_SepAttachLVXml)
            createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", "");
        else
            createNodeAndInsertText(xmlpara, objNode, "SEPERATEATTACHXML", GetSepAttParamXml(g_SepAttachLVXml));

        createNodeAndInsertText(xmlpara, objNode, "SUMMARY", pSummery);
        createNodeAndInsertText(xmlpara, objNode, "SECURITYAPPROVAL", tempSecurityDate);
        createNodeAndInsertText(xmlpara, objNode, "WRITERNAME2", getNodeText(objNodes[38]));
        createNodeAndInsertText(xmlpara, objNode, "WRITERJOBTITLE2", getNodeText(objNodes[39]));
        createNodeAndInsertText(xmlpara, objNode, "WRITERDEPTNAME2", getNodeText(objNodes[40]));
        createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[12]);
        createNodeAndInsertText(xmlpara, objNode, "ITEMNAME2", tempItemName);

        xmlhttp.open("POST", "/myoffice/ezApprovalG/DraftUI/aspx/dodraft.aspx", false);
        xmlhttp.send(xmlpara);

        SetBtnStateFalse();

        var dataNodes = GetChildNodes(loadXMLString(xmlhttp.responseText));
        return getNodeText(dataNodes[0])

    } catch (e) {
        alert("SaveDraftDocInfo_susin : " + e.description);
    }
}

function SignSave() {
    if (SignContent.length > 0) {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objRoot, objNode, subNode;
        objRoot = createNodeInsert(xmlpara, objRoot, "SIGNINFOS");

        for (i = 0; i < SignContent.length; i++) {
            objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "SIGNINFO", "");
            createNodeAndAppandNodeText(xmlpara, objNode, subNode, "DOCID", pDocID);
            createNodeAndAppandNodeText(xmlpara, objNode, subNode, "SIGNTYPE", SignType[i]);
            createNodeAndAppandNodeText(xmlpara, objNode, subNode, "SIGNNAME", SignName[i]);
            createNodeAndAppandNodeText(xmlpara, objNode, subNode, "CONTENT", SignContent[i]);
        }
        xmlhttp.open("Post", "/myoffice/ezApprovalG/ezAPRSIGN/aspx/setSignInfo.aspx", false);
        xmlhttp.send(xmlpara);
    }
}
function getfieldValue(pfield) {
    var rtnVal = "";

    if (pfield) {

        switch (pfield.tagName) {
            case "TD":
                rtnVal = getNodeText(pfield);
                break;
            case "SELECT":
                rtnVal = pfield.value;
                break;
            case "INPUT":
                rtnVal = pfield.value;
                break;
        }
    }
    return rtnVal;
}

function SetBtnStateFalse() {
    try {
        setMenuBar("btnSendDraft", false);
        setMenuBar("btnOpinion", false);
    } catch (e) {
        alert("SetBtnStateFalse : " + e.description);
    }
}

function ConversionPt(cmm) {
    if (cmm.indexOf("mm") > -1 || cmm.indexOf("pt") > -1 || cmm.indexOf("px") > -1) {
        if (cmm.indexOf("px") > -1)
            return cmm;
        else {
            cmm = ReplaceText(ReplaceText(cmm, "mm", ""), "pt", "");
            return (cmm * 3.779527559055).toFixed(2);
        }
    }
    else
        return (cmm * 3.779527559055).toFixed(2);
}

function Document_mmTopx(pBodyTag) {
    //우선 HTML로 만든다.
    var Content = document.createElement('div');
    Content.innerHTML = pBodyTag;
    //엘리먼트를 찾는다.
    var ElementsRows = Content.getElementsByTagName("*");
    for (var Cnt = 0; Cnt < ElementsRows.length; Cnt++) {
        ElementsRows.item(Cnt).removeAttribute("bgColor");

        if (ElementsRows.item(Cnt).tagName == "P") {
            if (ElementsRows.item(Cnt).innerHTML == "") {
                ElementsRows.item(Cnt).innerHTML = "&nbsp;";
                continue;
            }
            else {
                var ArrCSSs = ElementsRows.item(Cnt).style.cssText.split(';');
                var retCssText = "";
                var retAlignText = "";
                for (var i = 0; i < ArrCSSs.length; i++) {
                    if (ArrCSSs[i] != "") {
                        var ArrCss = ArrCSSs[i].split(":");
                        if (ArrCss.length == 2) {
                            switch (trim_Cross(ArrCss[0].toLowerCase())) {
                                case "margin-left":
                                case "margin-right":
                                case "margin-top":
                                case "margin-bottom":
                                case "line-height":
                                    retCssText += ArrCSSs[i] + ";";
                                    break;
                                case "text-indent":
                                    if (ArrCss[1].indexOf("mm") == -1)
                                        retCssText += " " + trim_Cross(ArrCss[0].toLowerCase()) + ":" + ArrCss + ";";
                                    else {
                                        var Size = ArrCss[1];
                                        retCssText += " " + trim_Cross(ArrCss[0].toLowerCase()) + ":" + ConversionPt(Size) + "px;";
                                    }
                                    break;
                                case "font-family": retCssText += ArrCSSs[i] + ";";
                                    break;
                                case "font-size": retCssText += ArrCSSs[i] + ";";
                                    break;
                                case "text-align": retAlignText = ArrCss[1].toLowerCase().replace("justify", "left");
                                    break;
                                case "margin":
                                    var marginArr = ArrCss[1].split(" ");
                                    var marginStr = "";
                                    for (var m = 0; m < marginArr.length; m++) {
                                        if (marginArr[m] != "") {
                                            marginStr += ConversionPt(marginArr[m]) + "px";
                                            if (m != marginArr.length - 1)
                                                marginStr += " ";
                                        }
                                    }
                                    retCssText += " " + trim_Cross(ArrCss[0].toLowerCase()) + ":" + marginStr + ";";
                                    break;
                                default:
                                    retCssText += ArrCSSs[i] + ";";
                                    break;
                            }

                            ElementsRows.item(Cnt).style.cssText = retCssText;
                            if (retAlignText != "")
                                ElementsRows.item(Cnt).style.textAlign = retAlignText;
                            var LastTag = ElementsRows.item(Cnt).outerHTML.substring(ElementsRows.item(Cnt).outerHTML.length - 4).toUpperCase();
                            if (LastTag != "</P>")
                                ElementsRows.item(Cnt).outerHTML = ElementsRows.item(Cnt).outerHTML + "</P>";
                        }
                    }
                }
                ElementsRows.item(Cnt).removeAttribute("dir");
            }
        }
        else if (ElementsRows.item(Cnt).tagName == "SPAN") {
            if (ElementsRows.item(Cnt).innerText == "")
                ElementsRows.item(Cnt).outerHTML = "";
            if (ElementsRows.item(Cnt).style.getAttribute("HWP-TAB") != null)
                ElementsRows.item(Cnt).outerHTML = "";
        }
        else if (ElementsRows.item(Cnt).tagName == "A") {
            ElementsRows.item(Cnt).innerHTML = ElementsRows.item(Cnt).innerText;
            ElementsRows.item(Cnt).removeAttribute("target");
            ElementsRows.item(Cnt).removeAttribute("name");
        }
        else {
            if (ElementsRows.item(Cnt).tagName != "COL" && ElementsRows.item(i).tagName != "COLGROUP" && ElementsRows.item(i).tagName != "TR") {
                if (ElementsRows.item(Cnt).style.height != "") {
                    ElementsRows.item(Cnt).style.setAttribute("Hidth", ConversionPt(ElementsRows.item(i).style.pixelHeight) + "px");
                    ElementsRows.item(Cnt).style.removeProperty("height");
                }
                if (ElementsRows.item(Cnt).getAttribute("height") != null && ElementsRows.item(Cnt).getAttribute("height") != "") {
                    ElementsRows.item(Cnt).setAttribute("Height", ConversionPt(ElementsRows.item(Cnt).getAttribute("height")) + "px");
                    ElementsRows.item(Cnt).removeAttribute("height");
                }
            }
            if (ElementsRows.item(Cnt).tagName == "TD") {
                if (ElementsRows.item(Cnt).style.background != "")
                    ElementsRows.item(Cnt).style.removeProperty("background");
                if (ElementsRows.item(Cnt).style.backgroundColor != "")
                    ElementsRows.item(Cnt).style.removeProperty("backgroundColor");

                ElementsRows.item(Cnt).removeAttribute("x:num");
                ElementsRows.item(Cnt).removeAttribute("x:str");

                //width
                if (ElementsRows.item(Cnt).style.width != "") {
                    ElementsRows.item(Cnt).style.setAttribute("width", ConversionPt(ElementsRows.item(i).style.pixelWidth) + "px");
                    ElementsRows.item(Cnt).style.removeProperty("width");
                }
                if (ElementsRows.item(Cnt).getAttribute("width") != null && ElementsRows.item(Cnt).getAttribute("width") != "") {
                    ElementsRows.item(Cnt).setAttribute("width", ConversionPt(ElementsRows.item(Cnt).getAttribute("width")) + "px");
                }

                //height
                if (ElementsRows.item(Cnt).style.height != "") {
                    ElementsRows.item(Cnt).style.setAttribute("height", ConversionPt(ElementsRows.item(i).style.pixelHeight) + "px");
                    ElementsRows.item(Cnt).style.removeProperty("height");
                }
                if (ElementsRows.item(Cnt).getAttribute("height") != null && ElementsRows.item(Cnt).getAttribute("height") != "") {
                    ElementsRows.item(Cnt).setAttribute("height", ConversionPt(ElementsRows.item(Cnt).getAttribute("height")) + "px");
                }

            }
            if (ElementsRows.item(Cnt).tagName == "TABLE") {
                if (ElementsRows.item(Cnt).getAttribute("border") == "")
                    ElementsRows.item(Cnt).setAttribute("border", "1");

                //height
                if (ElementsRows.item(Cnt).style.height != "") {
                    ElementsRows.item(Cnt).style.setAttribute("height", ConversionPt(ElementsRows.item(i).style.pixelHeight) + "px");
                    ElementsRows.item(Cnt).style.removeProperty("height");
                }
                if (ElementsRows.item(Cnt).getAttribute("height") != null && ElementsRows.item(Cnt).getAttribute("height") != "") {
                    ElementsRows.item(Cnt).setAttribute("height", ConversionPt(ElementsRows.item(Cnt).getAttribute("height")) + "px");
                }

                //width
                if (ElementsRows.item(Cnt).style.width != "") {
                    ElementsRows.item(Cnt).style.setAttribute("width", ConversionPt(ElementsRows.item(i).style.pixelWidth) + "px");
                    ElementsRows.item(Cnt).style.removeProperty("width");
                }
                if (ElementsRows.item(Cnt).getAttribute("width") != null && ElementsRows.item(Cnt).getAttribute("width") != "") {
                    ElementsRows.item(Cnt).setAttribute("width", ConversionPt(ElementsRows.item(Cnt).getAttribute("width")) + "px");
                }
            }
            if (ElementsRows.item(Cnt).tagName == "TR") {
                //width
                if (ElementsRows.item(Cnt).style.width != "") {
                    ElementsRows.item(Cnt).style.setAttribute("width", ConversionPt(ElementsRows.item(i).style.pixelWidth) + "px");
                    ElementsRows.item(Cnt).style.removeProperty("width");
                }
                if (ElementsRows.item(Cnt).getAttribute("width") != null && ElementsRows.item(Cnt).getAttribute("width") != "") {
                    ElementsRows.item(Cnt).setAttribute("width", ConversionPt(ElementsRows.item(Cnt).getAttribute("width")) + "px");
                }

                //height
                if (ElementsRows.item(Cnt).style.height != "") {
                    ElementsRows.item(Cnt).style.setAttribute("height", ConversionPt(ElementsRows.item(i).style.pixelHeight) + "px");
                    ElementsRows.item(Cnt).style.removeProperty("height");
                }
                if (ElementsRows.item(Cnt).getAttribute("height") != null && ElementsRows.item(Cnt).getAttribute("height") != "") {
                    ElementsRows.item(Cnt).setAttribute("height", ConversionPt(ElementsRows.item(Cnt).getAttribute("height")) + "px");
                }
            }
        }
    }
    return Content.outerHTML;
}

function HabyuiResultOpinion() {
    try {
        var parameter = new Array();
        var rtnVal = true

        parameter[0] = "";
        parameter[1] = "N";
        parameter[2] = KuyjeType;
        parameter[3] = pOrgDocID;

        var url = "/myoffice/ezApprovalG/ezAPROPINION/AprOpinion.aspx";
        var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no"
        feature = feature + GetShowModalPosition(530, 520);
        var ret = window.showModalDialog(url, parameter, feature);

        if (ret != "cancel") {
            var NodeList;
            var objXML = createXmlDom();

            objXML = loadXMLString(ret);
            NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");

            if (NodeList.length != 0) {
                rtnVal = true;
            } else {
                rtnVal = true;
            }
        }
        return rtnVal;
    } catch (e) {
        alert("HabyuiResultOpinion : " + e.description);
    }
}

function OpenAlertUI_Close_Complete() {
    btnClose_onclick();
}

function delOpinionInfo() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "DocID", "002");

    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezAPROPINION/aspx/DeleteOpinionTypeInfo.aspx", false);
    xmlhttp.send(xmlpara);

    pHasOpinionYN = "";
    return xmlhttp.responseText;
}

var selectcabinet_dialogArguments = new Array();
function btnSetTaskCode_onclick() {
    try {
        var para = new Array();
        para[0] = cabinetID;

        selectcabinet_dialogArguments[0] = para;
        selectcabinet_dialogArguments[1] = btnSetTaskCode_onclick_Complete;

        DivPopUpShow(850, 455, "/myoffice/ezApprovalG/ezCabinet/SelectCabinet.aspx?initFlag=1");
    } catch (e) {
        alert("btnSetTaskCode_onclick : " + e.description);
    }
}

function btnSetTaskCode_onclick_Complete(rtn) {
    DivPopUpHidden();
    if (rtn[0] == "TRUE") {
        var g_SelCabXml = rtn[1];
        var xmlCab = createXmlDom();
        xmlCab = loadXMLString(g_SelCabXml);

        cabinetID = getNodeText(SelectNodes(xmlCab, "CABINETINFO/CABINET/CABINETID")[0]);
        TaskCode = getNodeText(SelectNodes(xmlCab, "CABINETINFO/CABINET/TASKCODE")[0]);
    }
    TaskCode_Save();
}