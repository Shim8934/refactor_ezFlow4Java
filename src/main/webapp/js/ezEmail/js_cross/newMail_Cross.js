var regex = /[\u0000-\u0008\u000B-\u000C\u000E-\u001F\uD800-\uDB7F\uDB80-\uDBFF\uDC00-\uDFFF\uFFFE\uFFFF]/g;
function MailToMe_Onclick() {
    var checked = document.getElementById('toMe').checked;
    var msgDiv = document.getElementById('MsgToGot');

    if (checked) {
        var existMe = false;
        for (var i = 0; i < msgDiv.childNodes.length; i++) {
            if (msgDiv.childNodes[i].childNodes[0].getAttribute("email") && msgDiv.childNodes[i].childNodes[0].getAttribute("email") == g_myemail) {
                existMe = true;
            }
        }
        if (!existMe) {
            var newElem = PrepareMailTag(0, "email", g_myname, g_myemail, "");
            MsgToGot.appendChild(newElem);
        }
    } else {
        for (var i = 0; i < msgDiv.childNodes.length; i++) {
            if (msgDiv.childNodes[i].childNodes[0].getAttribute("email") && msgDiv.childNodes[i].childNodes[0].getAttribute("email") == g_myemail) {
                while (msgDiv.childNodes[i].hasChildNodes()) {
                    msgDiv.childNodes[i].removeChild(msgDiv.childNodes[i].lastChild);
                }
                msgDiv.removeChild(msgDiv.childNodes[i]);
                i--;
            }
        }
    }
}

var BigSizeAttach = false;
var pBigFileUpload = "N";
function open_userinfo(cn) {
    var feature = "height=500px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
    feature = feature + GetOpenPosition(420, 500);
    window.open("/ezCommon/showPersonInfo.do?id=" + cn, "", feature);
}

var g_progresswin;
var g_fileList;
var g_fileNameList = new Array();
var g_fileSizelist = new Array();
var g_fileBigSizeYN = new Array();
var g_AttachList = new Array();
var g_bMailCreated = false;
function sendType_change(pMode) {
    var selIndex = 0;
    if (pMode > 0) selIndex = sendTypeSelect.selectedIndex;
    g_charset = g_xmldoc.getElementsByTagName("charset")[selIndex].text;
    g_encoding = g_xmldoc.getElementsByTagName("content-transfer-encoding")[selIndex].text;
    g_font = g_xmldoc.getElementsByTagName("font")[selIndex].text;
    g_showdisplay = g_xmldoc.getElementsByTagName("show-displayname")[selIndex].text;
    g_simplemimeencoding = g_xmldoc.getElementsByTagName("simple-mime-content-transfer-encoding")[selIndex].text;
    g_showEnglishDisplay = g_xmldoc.getElementsByTagName("show-english-displayname")[selIndex].text;
}

var totfileSize = 0;
var totfileSize2 = 0;
function attach_Add() {
    document.form.file1.click();
}

function btn_AttachAdd_onclick() {

    if (document.form.file1.value != "") {

        var AttachLimit = 1096;
        var newid = g_newid;
        document.getElementById("maxsize").value = FtotSizeAttachSize;
        document.getElementById("cnt").value = document.getElementById("form").file1.files.length;
        document.getElementById("newid").value = newid;
        document.getElementById("bigmaxsize").value = FtotBigSizeAttachSize;
        document.getElementById("changesize").value = FBigSizeAttachSize;
        document.getElementById("txtName").value = filedate;
        document.getElementById("endDay").value = BigSizeMailAttachDelDay;

        var frm = document.getElementById('form');
        frm.submit();
    }
    else {
        alert(strLang360);
    }
}

function AttachFileInfo(resultXML) {
    var xml = loadXMLString(resultXML);
    var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
    var i = 0;
    try {
        for (i = 0; i < nodes.length; i++) {
            if (getNodeText(GetChildNodes(nodes[i])[1]) == "Error") {
                var pAlertContent = "" + strLang18 + "";
                alert(pAlertContent);
                return;
            }
            else if (getNodeText(GetChildNodes(nodes[i])[1]) == "FileOverFlowMsg") {
            	//getNodeText(GetChildNodes(nodes[i])[2]) = "";
                setNodeText(GetChildNodes(nodes[i])[2], "");
            }
        }
        AddAttachFileInfoXmlParsing(resultXML);
    }
    catch (ErrMsg) {
        alert(ErrMsg.description);
    }
}

function attach_Add_afterupload_2010() {
}

function attach_Add1(ocx_file) {
    var fileSize = 0;
    var fileSize2 = 0;
    var tmpFileSize = 0;
    var pBigFileUploadYN = "N";
    var fileLen = g_fileSizelist.length;

    for (var i = 0; i < g_fileList.length - 1; i++) {

        tmpFileSize = ezUtil.GetFileSize(g_fileList[i]);
        if (tmpFileSize == 0) {
            alert(strLang167);
            return;
        }

        g_fileSizelist[fileLen + i] = tmpFileSize;

        if (BigSizeAttachSize < tmpFileSize) {
            pBigFileUploadYN = "Y";
            totfileSize2 += tmpFileSize;
            fileSize2 += tmpFileSize;
        }
        else {
            totfileSize += tmpFileSize;
            fileSize += tmpFileSize;
        }
    }

    if (totfileSize > totSizeAttachSize) {
        alert(strLang75 + totSizeAttachMBSize + "MB" + strLang76);
        totfileSize = totfileSize - fileSize;
        return;
    }
    else if (totfileSize2 > totBigSizeAttachSize) {
        alert(strLang168 + totBigSizeAttachMBSize + "MB" + strLang169);
        totfileSize2 = totfileSize2 - fileSize2;
        return;
    }

    ezUtil = null;
    if ((BigSizeAttach == false) && (pBigFileUploadYN == "Y")) {
        alert(strLang77 + BigSizeAttachMBSize + "MB" + strLang78 + BigSizeMailAttachDelDay + " " + strLang79);
        BigSizeAttach = true;
        pBigFileUpload = "Y";
    }
    EzHTTPTrans.AddUploadFile("", "");

    var fileNamelist = "";
    var fileName = "";
    var savefileNamelist = "";
    var pBigSizefileListYN = "Y";
    var g_fileGBList = new Array();
    for (var i = 0; i < g_fileList.length - 1; i++) {
        try {
            var pTmpBigFileUpload = "N";

            if (g_fileSizelist[fileLen + i] > BigSizeAttachSize) {
                pTmpBigFileUpload = "Y";
                g_fileBigSizeYN[i] = "Y";
            }
            else {
                g_fileBigSizeYN[i] = "N";
                pBigSizefileListYN = "N";
            }
            EzHTTPTrans.AddUploadFile(g_fileList[i], pTmpBigFileUpload);
            g_fileGBList[i] = pTmpBigFileUpload;

            if (pTmpBigFileUpload != "Y") {
            }
        }
        catch (e) {
            alert(g_fileList[i] + " " + strLang85 + "\n\n" + e.number + " - " + e.description);
            return;
        }
    }

    var newid = '';
    newid = '&newid=' + g_newid;
    var RemotePath = document.location.protocol + "//" + document.location.hostname + "/myoffice/ezEmail/remote/mail_interuploadX.aspx";
    var nCount = EzHTTPTrans.StartUpload(RemotePath, "/Upload_DocManagement", "DocManagement" + newid, "", "");

    if (nCount == 0) {
        alert(strLang89)
        var isBigSizeAttach = false;
        var bigfile = EzHTTPTrans.IsBigfileYN;
        var bigfileList = bigfile.split("\\");

        for (var i = 0 ; i < bigfileList.length ; i++) {
            if (bigfileList[i] == "Y") {
                isBigSizeAttach = true;
            }
        }
        if (isBigSizeAttach) {
            BigSizeAttach = true;
        }
        else {
            BigSizeAttach = false;
        }
        return false;
    }


    var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
    var rootNodes = xmlDoc.createElement("DATA");
    xmlDoc.appendChild(rootNodes);

    var rootNode = xmlDoc.createElement("CMD");
    rootNode.text = "ADD";
    rootNodes.appendChild(rootNode);

    var rootNode = xmlDoc.createElement("URL");
    rootNode.text = g_url;
    rootNodes.appendChild(rootNode);

    var rootNode = xmlDoc.createElement("FILELIST");
    rootNodes.appendChild(rootNode);

    for (var i = 0; i < nCount; i++) {

        var fileinfo = EzHTTPTrans.GetReturn(i);
        var infos = fileinfo.split('/');
        var filename = infos[0].substr(infos[0].lastIndexOf("\\") + 1);
        var filesize = infos[2];
        var filePath = infos[1].split('_kaonisplit_')[0];
        var BigYN = infos[1].split('_kaonisplit_')[1];
        var subNodes = xmlDoc.createElement("FILE");
        rootNode.appendChild(subNodes);
        var subNode = xmlDoc.createElement("NAME");
        subNode.text = filename
        subNodes.appendChild(subNode);

        var subNode = xmlDoc.createElement("PATH");
        subNode.text = filePath
        subNodes.appendChild(subNode);

        var subNode = xmlDoc.createElement("BIG");
        subNode.text = BigYN
        subNodes.appendChild(subNode);

        var subNode = xmlDoc.createElement("SIZE");
        subNode.text = filesize
        subNodes.appendChild(subNode);

        var subNode = xmlDoc.createElement("ITEMID");
        subNode.text = "Y";
        subNodes.appendChild(subNode);
    }

    xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    xmlhttp.open("POST", "/myoffice/ezEmail/remote/mail_interattach.aspx", false);
    xmlhttp.send(xmlDoc.xml);

    if (xmlhttp.status == "200") {
        xmlDoc.load(xmlhttp.responseXML)
        g_url = xmlDoc.getElementsByTagName("URL")[0].text;

        for (var i = 0; i < xmlDoc.getElementsByTagName("FILE").length; i++) {
            filename = xmlDoc.getElementsByTagName("FILE")[i].selectSingleNode("NAME").text
            path = xmlDoc.getElementsByTagName("FILE")[i].selectSingleNode("PATH").text
            big_yn = xmlDoc.getElementsByTagName("FILE")[i].selectSingleNode("BIG").text
            size = xmlDoc.getElementsByTagName("FILE")[i].selectSingleNode("SIZE").text
            attid = xmlDoc.getElementsByTagName("FILE")[i].selectSingleNode("ITEMID").text

            var aitem = document.location.protocol + "//" + document.location.hostname + "/myoffice/ezEmail/remote/mail_ReadAttach_Ews.aspx?mode=Attach&ID=" + encodeURI(g_url) + "&ATTID=" + encodeURI(attid);

            if (big_yn == "Y") {
                var aitem = document.location.protocol + "//" + document.location.hostname + "/Common/DownloadAttach_Common.aspx?filepath=" + encodeURI(path) + "&filename=" + encodeURI(filename);
            }
            AtthacDivUpdate("addattach", aitem, attid, filename, size, big_yn)
        }
    }
    else {
        alert(xmlhttp.status + " : " + strLang241);
    }
    xmlhttp = null;
}

function AtthacDivUpdate(attachMode, sorcePath, AttachID, filename, filesize, BigFileYN) {

    if (attachMode == "addattach") {

        EzHTTPTrans.InsertFileList(filename, sorcePath, BigFileYN, AttachID, filesize);
    }
    else {
        filelist = EzHTTPTrans.DelfileList();

        var bigfile = EzHTTPTrans.IsBigfileYN;
        var bigfileList = bigfile.split("\\");
        var delfilelist = filelist.split("\\");
        var xml = "<FILE>"

        for (var i = 0; i < bigfileList.length - 1; i++) {
            if (bigfileList[i] != "Y") {
                pBigSizefileListYN = "N";
                totfileSize = totfileSize - g_fileSizelist[i];
                g_fileSizelist.splice(i, 1);
            }
            else {
                totfileSize2 = totfileSize2 - g_fileSizelist[i];
                g_fileSizelist.splice(i, 1);
            }

            if (delfilelist[i] != "" && bigfileList[i] != "") {
                xml += "<ROW>";
                xml += "<NAME><![CDATA[" + delfilelist[i] + "]]></NAME>";
                xml += "<BIGYN><![CDATA[" + bigfileList[i] + "]]></BIGYN>"
                xml += "</ROW>";
            }
        }

        xml += "<ITEMID><![CDATA[" + g_url + "]]></ITEMID></FILE>";
        if (g_url != null && g_url != '') {
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            xmlhttp.open("POST", "/myoffice/ezEmail/remote/mail_del_interattach.aspx", false);
            xmlhttp.send(xml);

            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                var oRoot = xmlhttp.responseXML.documentElement;
                var ret = oRoot.childNodes[0].nodeValue;

                if (ret != "FAIL") {
                    g_url = ret;
                }
                else {
                    alert(strLang183);
                }
            }
        }
        EzHTTPTrans.DeleteFileList();
    }
}

function show_progress(fileinfo) {
    g_progresswin = window.showModelessDialog("mail_progress.aspx?fileinfo=" + encodeURI(fileinfo), "", "dialogWidth=390px; dialogHeight:190px; center:yes; status:no; help:no; edge:sunken");
}

function status_change(fileinfo) {
    try {
        g_progresswin.document.Script.fileinfo_change(fileinfo);
    } catch (e) { }
}

function attach_Delete() {
    var filelist = "";
    var retFileName;
    var pBigSizefileListYN = "Y";

    EzHTTPTrans.DeleteFileList();
    filelist = EzHTTPTrans.DelfileList();

    var bigfile = EzHTTPTrans.IsBigfileYN;
    var bigfileList = bigfile.split("\\");

    for (var i = 0 ; i < bigfileList.length - 1 ; i++) {
        if (bigfileList[i] != "Y") {
            pBigSizefileListYN = "N";
            totfileSize = totfileSize - g_fileSizelist[i];
            g_fileSizelist.splice(i, 1);
        }
        else {
            totfileSize2 = totfileSize2 - g_fileSizelist[i];
            g_fileSizelist.splice(i, 1);
        }
    }

    if (filelist == "") {
        alert(strLang90);
        return;
    }

    if (g_url != null && g_url != '') {
        var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
        var rootNodes = xmlDoc.createElement("DATA");
        xmlDoc.appendChild(rootNodes);

        var rootNode = xmlDoc.createElement("CMD");
        rootNode.text = "DEL";
        rootNodes.appendChild(rootNode);

        var rootNode = xmlDoc.createElement("URL");
        rootNode.text = g_url;
        rootNodes.appendChild(rootNode);

        var rootNode = xmlDoc.createElement("FILE");
        rootNode.text = filelist;
        rootNodes.appendChild(rootNode)

        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        xmlhttp.open("POST", "/myoffice/ezEmail/remote/mail_interattach.aspx", false);
        xmlhttp.send(xmlDoc.xml);
    }
    AtthacDivUpdate("del", "", "", "", "", "");
}

function disable_button() {
    btn_AttachAdd.disabled = true;
    btn_AttachDel.disabled = true;
}

function restore_button() {
    btn_AttachDel.disabled = false;
    btn_AttachAdd.disabled = false;

    try {
        g_progresswin.close();
    }
    catch (e) { }
}

function NotifyResult(filename, attachMode, path) {
    g_bDirty = true;
    restore_button();

    if (attachMode == "addattach") {
        for (var i = 0; i < g_fileList.length - 1; i++) {
            var filename = g_fileNameList[i].substr(g_fileNameList[i].lastIndexOf("/") + 1);
            var rtnVal = EzHTTPTrans.GetReturn(i);
            EzHTTPTrans.InsertFileList(filename, g_fileNameList[i], g_fileBigSizeYN[i], "N", rtnVal.substring(rtnVal.lastIndexOf("/") + 1, rtnVal.length));
        }
    }
    else if (attachMode == "delattach") {
        var isBigSizeAttach = false;
        var bigfile = EzHTTPTrans.IsBigfileYN;
        var bigfileList = bigfile.split("\\");

        for (var i = 0 ; i < bigfileList.length ; i++) {
            if (bigfileList[i] == "Y") {
                isBigSizeAttach = true;
            }
        }

        if (isBigSizeAttach) {
            BigSizeAttach = true;
        }
        else {
            BigSizeAttach = false;
        }
    }
    if (path != "")
        g_url = path;
}

function attach_click(para) {
    var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
    ezUtil.UseUTF8 = true;
    ezUtil.ExecuteFile(para, "");
}

function Send_onClick() {
    if (eSubject.value == "") {
        alert(strLang92);
        eSubject.focus();
        return;
    }

    NameCertify_onClick(Send_onClick_Complete);
}
function Send_onClick_Complete(ReturnValue) {
    try {
        if (ReturnValue) {
            try {
                if (document.getElementById("MsgToGot").childNodes[0].childNodes.length == 0 &&
                    document.getElementById("MsgCCGot").childNodes[0].childNodes.length == 0 &&
                    document.getElementById("MsgBCCGot").childNodes[0].childNodes.length == 0) {
                    alert(strLang93);
                    return;
                }
            } catch (e) {
                if (document.getElementById("MsgToGot").childNodes.length == 0 &&
                        document.getElementById("MsgCCGot").childNodes.length == 0 &&
                        document.getElementById("MsgBCCGot").childNodes.length == 0) {
                    alert(strLang93);
                    return;
                }
            }
            if ((MsgToGot.childNodes.length + MsgCCGot.childNodes.length + MsgBCCGot.childNodes.length) > individualmailuser && iseachMail == "true") {
                if (confirm(strLang182)) {
                    iseachMail = "false";
                }
                else {
                    return;
                }
            }
            Save_onClick("sendsave");
        }
    } catch (e) {
    }
}

function MakeFromAddress(pAddress) {
    if (g_showEnglishDisplay == "1")
        pAddress = "\"" + g_DisplayNamePrintable + "\"" + pAddress.split("\"")[2]

    return pAddress;
}

function CheckNeedsApproval(pURL) {
    var AddrList = "";
    var strTo = GetAddrFormatForSend(MsgToGot);
    var strCC = GetAddrFormatForSend(MsgCCGot);
    var strBCC = GetAddrFormatForSend(MsgBCCGot);
    var i = 0;

    if (strTo != "") {
        if (strTo.indexOf(">,") > -1) {
            for (i = 0; i < strTo.split(">,").length; i++) {
                AddrList += strTo.split(">,")[i].split("<")[1] + ";";
            }
        }
        else {
            AddrList += strTo.split("<")[1].replace(">", "") + ";";
        }
    }

    if (strCC != "") {
        if (strCC.indexOf(">,") > -1) {
            for (i = 0; i < strCC.split(">,").length; i++) {
                AddrList += strCC.split(">,")[i].split("<")[1] + ";";
            }
        }
        else {
            AddrList += strCC.split("<")[1].replace(">", "") + ";";
        }
    }

    if (strBCC != "") {
        if (strBCC.indexOf(">,") > -1) {
            for (i = 0; i < strBCC.split(">,").length; i++) {
                AddrList += strBCC.split(">,")[i].split("<")[1] + ";";
            }
        }
        else {
            AddrList += strBCC.split("<")[1].replace(">", "") + ";";
        }
    }

    xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "remote/mail_check_mailapproval.aspx?url=" + encodeURIComponent(pURL), false);
    xmlhttp.send("<DATA>" + AddrList + "</DATA>");
    var ret = xmlhttp.responseText;
    xmlhttp = null;
    return ret;
}

var g_saveHttp = null;
function Save_onClick(savemode) {
    if (savemode == "tempsave" && MailStatus == "SEND")
        return;
    MailStatus = "SEND";
    Save_onClick_Complete.savemode = savemode;
    //NameCertify_onClick(Save_onClick_Complete);
    Save_onClick_Complete(true);
}

function Save_onClick_Complete(ReturnValue) {
    try {
        if (ReturnValue) {
            if (eSubject.value.length > 120) {
                alert(strLang95);
                return;
            }

            var Subject = eSubject.value;
            if (TrimText(Subject) == "")
                Subject = strLang97;

            if (m_rgParams4PostOption["SecurityMail"] == "Security")
                pSecurity = "3";

            var xmlDoc = createXmlDom();
            var rootNode;
            createNodeInsert(xmlDoc, rootNode, "DATA");
            createNodeAndInsertText(xmlDoc, rootNode, "URL", encodeURIComponent(g_url));
            createNodeAndInsertText(xmlDoc, rootNode, "ORGURL", gg_url);
            createNodeAndInsertText(xmlDoc, rootNode, "CONNURL", "/exchange/" + g_szUserID);
            createNodeAndInsertText(xmlDoc, rootNode, "CMD", (Save_onClick_Complete.savemode == "sendsave" ? "SEND" : "SAVE"));
            createNodeAndInsertText(xmlDoc, rootNode, "MAILCMD", g_cmd);
            createNodeAndInsertText(xmlDoc, rootNode, "AUTHOR", g_szAuthor);
            createNodeAndInsertText(xmlDoc, rootNode, "SUBJECT", Subject.replace(regex, " "));
            createNodeAndInsertText(xmlDoc, rootNode, "TO", GetAddrFormatForSend(MsgToGot));
            createNodeAndInsertText(xmlDoc, rootNode, "CC", GetAddrFormatForSend(MsgCCGot));
            createNodeAndInsertText(xmlDoc, rootNode, "BCC", GetAddrFormatForSend(MsgBCCGot));

            var mhtBody = "";
            if (m_rgParams4PostOption["bodyType"] != 1) {
                mhtBody = message.GetEditorContent();
                mhtBody = "<HTML>" + GetCKEditerHeader() + mhtBody + "</HTML>";
                // dhlee: this line seems to be not needed.
//                mhtBody = ConvertHTMLtoMHT(mhtBody);
            }
            else {
                var div_ = document.createElement("DIV");
                div_.innerHTML = div_.innerHTML = "<HTML>" + GetCKEditerHeader() + message.GetEditorContent() + "</HTML>";
                mhtBody = div_.textContent;
                mhtBody = mhtBody.replace("P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm } ", "");
                mhtBody = mhtBody.replace("P {MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm}", "");
                mhtBody = mhtBody.replace("P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm;line-height:20px;font-size:10pt;} DIV { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm;line-height:20px;font-size:10pt;} ", "");
            }

            createNodeAndInsertText(xmlDoc, rootNode, "TEXTBODY", mhtBody.replace(regex, " "));
            createNodeAndInsertText(xmlDoc, rootNode, "FROM", MakeFromAddress(document.getElementById("eFrom").value));
            createNodeAndInsertText(xmlDoc, rootNode, "SENSITIVITY", m_rgParams4PostOption["postType"]);
            createNodeAndInsertText(xmlDoc, rootNode, "REPLYSENDTIME", m_rgParams4PostOption["replySendTime"]);
            createNodeAndInsertText(xmlDoc, rootNode, "REPLYREADTIME", m_rgParams4PostOption["replyReadTime"]);
            createNodeAndInsertText(xmlDoc, rootNode, "IMPORTANCE", importantSelect.selectedIndex.toString());
            createNodeAndInsertText(xmlDoc, rootNode, "EXTRAHEADERNAME", "comment");
            createNodeAndInsertText(xmlDoc, rootNode, "EXTRAHEADERVALUE", g_senderinfo);
            createNodeAndInsertText(xmlDoc, rootNode, "SENDUSINGHANGE", "1");
            g_simplemime = m_rgParams4PostOption["bodyType"];

            if (typeof (g_simplemime) == "undefined") g_simplemime = "0";
            createNodeAndInsertText(xmlDoc, rootNode, "CHARSET", g_charset);
            createNodeAndInsertText(xmlDoc, rootNode, "CONTENT-TRANSFER-ENCODING", g_encoding);
            createNodeAndInsertText(xmlDoc, rootNode, "SIMPLE-MIME", g_simplemime);
            createNodeAndInsertText(xmlDoc, rootNode, "SIMPLE-MIME-CONTENT-TRANSFER-ENCODING", g_simplemimeencoding);
            createNodeAndInsertText(xmlDoc, rootNode, "SHOW-DISPLAYNAME", g_showdisplay);
            createNodeAndInsertText(xmlDoc, rootNode, "ISEACHMAIL", iseachMail);
            createNodeAndInsertText(xmlDoc, rootNode, "SECURITYMAIL", pSecurity);
            createNodeAndInsertText(xmlDoc, rootNode, "ISRESERVE", isReserve);
            createNodeAndInsertText(xmlDoc, rootNode, "RESERVEDID", pCDOMessageId);
            if (m_rgParams4PostOption["delaySendDate"] == "") {
                createNodeAndInsertText(xmlDoc, rootNode, "DELAYSENDTIME", "");
            }
            else {
                createNodeAndInsertText(xmlDoc, rootNode, "DELAYSENDTIME", m_rgParams4PostOption["delaySendDate"].substring(0, 10) + " " + m_rgParams4PostOption["delaySendDate"].substring(11, 19));

                if (Save_onClick_Complete.savemode == "sendsave") {
                    var utcdate = m_rgParams4PostOption["delaySendDate"];
                    var senddate = new Date();
                    senddate.setUTCFullYear(utcdate.substr(0, 4));
                    senddate.setUTCMonth(utcdate.substr(5, 2) - 1);
                    senddate.setUTCDate(utcdate.substr(8, 2));
                    senddate.setUTCHours(utcdate.substr(11, 2));
                    senddate.setUTCMinutes(utcdate.substr(14, 2));
                    senddate.setUTCSeconds(utcdate.substr(17, 2));


                    alert(strLang98 + "'" + m_rgParams4PostOption["delaySendDate"] + "'" + strLang102 + "'" + strLang100 + "'" + strLang101);

                }
            }
            ConvertEmbedPath(xmlDoc, xmlDoc);
            ConvertEmbedImagToXml(xmlDoc, xmlDoc);

            if (Org_cmd == "docsend" || Org_cmd == "docsenddoc" || Org_cmd == "board" || Org_cmd == "Community" || Org_cmd == "report")
                DocFileIntoXML(xmlDoc, rootNode);

            rootNode = null;

            try {
                var newid = '';
                if (g_cmd == "NEW") {
                    newid = '?' + '&newid=' + g_newid;
                }

                g_saveHttp = createXMLHttpRequest();

                if (!isClosedSave) {
                    g_saveHttp.open("POST", "/ezEmail/mailInterSend.do", true);
                    event_SaveonClick.savemode = Save_onClick_Complete.savemode;

                    if (Save_onClick_Complete.savemode == "sendsave") {
                        MailSend_Show_Progress();
                    }

                    g_saveHttp.onreadystatechange = event_SaveonClick;
                    g_saveHttp.send(xmlDoc);
                }
                else {
                    g_saveHttp.open("POST", "/ezEmail/mailInterSend.do", false);
                    g_saveHttp.send(xmlDoc);
                }
                xmlDoc = null;
            }
            catch (e) {
                xmlDoc = null;
                if (event_SaveonClick.savemode == "sendsave")
                    alert(strLang103);
                else
                    alert(strLang104);
                g_saveHttp = null;
            }
        }
    } catch (e) {
    }
}

function MailSend_Show_Progress() {
    document.getElementById("mailPanel").style.display = "";
    document.getElementById("loadingLayer").style.display = "";
}

function MailSend_Hidden_Progress() {
    document.getElementById("mailPanel").style.display = "none";
    document.getElementById("loadingLayer").style.display = "none";
}

function event_SaveonClick() {
    if (g_saveHttp != null && g_saveHttp.readyState == 4) {
        var xmlResult = loadXMLString(g_saveHttp.responseText);
        var pRtnMessage = "";
        if (navigator.userAgent.indexOf("MSIE") != -1) {
            pRtnMessage = xmlResult.childNodes.item(0).childNodes.item(0).text;
        }
        else if (navigator.userAgent.indexOf("MSIE") == -1) {
        	pRtnMessage = xmlResult.childNodes.item(0).childNodes.item(0).textContent;
//        	pRtnMessage = xmlResult.childNodes.item(0).childNodes.item(1).textContent;
        }
        
        if (pRtnMessage.indexOf("NO APPEND failed.") > -1) {
            alert(strLang241);
            MailSend_Hidden_Progress();
            g_saveHttp = null;
            MailStatus = "NO";
        }
        else if (pRtnMessage != "FULL") {
            if (g_saveHttp.status < 200 || g_saveHttp.status > 300 || pRtnMessage.substr(0, 5) == "ERROR") {
                var result = "";
                if (g_saveHttp.status < 200 || g_saveHttp.status > 300) {
                    result = strLang105;
                }
                else {
                    result = pRtnMessage;
                }
                g_saveHttp = null;
                if (event_SaveonClick.savemode == "sendsave") {
                    if (result.lastIndexOf("not be created.") > 0) {
                        alert(strLang363);
                    }
                    else {
                        if (pRtnMessage == "XSS")
                            alert(strLang250);
                        else
                            alert(result);
                    }
                    if (Org_cmd == "docsend")
                        MailSend_Hidden_Progress();
                    else
                        MailSend_Hidden_Progress();

                    MailStatus = "NO";
                }
                else {
                    if (result.indexOf("ERROR") == 0) {
                        if (result.lastIndexOf("not be created.") > 0) {
                            alert(strLang363);
                        }
                        else
                            alert(result.substr(6, result.length));
                    }
                    else {
                        alert(strLang107 + result);
                    }
                }
            }
            else {
                g_bDirty = false;
                g_originalHTML = message.GetEditorContent();
                g_bSended = true;

                var result = pRtnMessage;
                var xmlID = "";
                xmlID = loadXMLString(g_saveHttp.responseText);

                if (result != "OK") {
                    if (event_SaveonClick.savemode == "tempsave") {
                        if (navigator.userAgent.indexOf("MSIE") != -1) {
                            g_url = xmlID.childNodes.item(0).childNodes.item(1).text;
                        }
                        else if (navigator.userAgent.indexOf("MSIE") == -1) {
                        	g_url = xmlID.childNodes.item(0).childNodes.item(1).textContent;
//                          g_url = xmlID.childNodes.item(0).childNodes.item(3).textContent;
                        }
                        g_orgurl = g_url;
                        g_saveHttp = null;
                        g_cmd = "EDIT";
                        if (!isAutoSave) {
                            alert(strLang108);
                            isAutoSave = false;
                        }

                        try {
                        	window.opener.MailListRefreshByTimeout();
                        } catch (e) { }
                    }
                    else {
                    	if (result.lastIndexOf("not be created.") > 0) {
                            alert(strLang363);
                        }
                        else {

                            if (pRtnMessage == "XSS") {
                                alert(strLang250);
                            }
                            else
                                alert(result);
                        }
                        if (Org_cmd == "docsend")
                            MailSend_Hidden_Progress();
                        else
                            MailSend_Hidden_Progress();
                    }
                    MailStatus = "NO";
                }
                else {
                    if (event_SaveonClick.savemode == "tempsave") {
                        if (navigator.userAgent.indexOf("MSIE") != -1) {
                            g_url = xmlID.childNodes.item(0).childNodes.item(1).text;
                        }
                        else if (navigator.userAgent.indexOf("MSIE") == -1) {
                        	g_url = xmlID.childNodes.item(0).childNodes.item(1).textContent;
//                          g_url = xmlID.childNodes.item(0).childNodes.item(3).textContent;
                        }

                        g_orgurl = g_url;
                        g_saveHttp = null;
                        g_cmd = "EDIT";
                        if (!isAutoSave) {
                            alert(strLang108);
                            isAutoSave = false;
                        }
                        g_saveHttp = null;
                        try {
                        	window.opener.MailListRefreshByTimeout();
                        } catch (e) { }
                    }
                    else {
                        var tempUrl = "";
                        if (navigator.userAgent.indexOf("MSIE") != -1) {
                            tempUrl = xmlID.childNodes.item(0).childNodes.item(1).text;
                        }
                        else if (navigator.userAgent.indexOf("MSIE") == -1) {
                        	tempUrl = xmlID.childNodes.item(0).childNodes.item(1).textContent;
//                          tempUrl = xmlID.childNodes.item(0).childNodes.item(3).textContent;
                        }

                        if (g_url = tempUrl) {
                            g_url = tempUrl;
                            g_orgurl = g_url;
                        }
                        g_saveHttp = null;
                        try {
                        	window.opener.MailListRefreshByTimeout();
                        } catch (e) { }
                        window.close();
                    }
                    MailStatus = "NO";
                }
            }
        }
        else {
            alert(strLang364);
            MailSend_Hidden_Progress();
            g_saveHttp = null;
            MailStatus = "NO";
        }
    }
}

function on_keydown(e) {
    if (window.event) {
        if (window.event.keyCode == "13") {
            NameCertify_onClick(null);
            return;
        }
    }

    if (e.which) {
        if (e.which == 13) {
            NameCertify_onClick(null);
            return;
        }
    }
}
var NameCertify_onClick_returnFunction;
function NameCertify_onClick(returnFunction) {
    if (document.getElementById("MsgTo").value == "" && document.getElementById("MsgCC").value == "" && document.getElementById("MsgBCC").value == "") {
        NameCertify_onClick_returnFunction = null;
        if(returnFunction != undefined)
            returnFunction(true);
        return true;
    }
    if (returnFunction == null)
        NameCertify_onClick_returnFunction = null;
    else
        NameCertify_onClick_returnFunction = returnFunction;
    g_bDirty = true;
    CompletToisEnd = false;
    CompletCcisEnd = false;
    CompletBccisEnd = false;
    CompletCancelBtn = false;
    ToTalCompletEmailAddress();
    return true;
}

function GetMailTips() {
    NameCertify_onClick();
    var receivemail = "";
    var receivname = "";

    if (MsgToGot.innerText != "") {
        receivemail = GetAddrFormatEmail(MsgToGot, "0")
        receivname = GetAddrFormatEmail(MsgToGot, "1")
    }

    if (MsgCCGot.innerText != "") {
        receivemail = receivemail + GetAddrFormatEmail(MsgCCGot, "0")
        receivname = receivname + GetAddrFormatEmail(MsgCCGot, "1")
    }

    if (MsgBCCGot.innerText != "") {
        receivemail = GetAddrFormatEmail(MsgBCCGot, "0") + receivemail;
        receivname = GetAddrFormatEmail(MsgBCCGot, "1") + receivname
    }

    var url = "/myoffice/ezEmail/mail_get_mailtip.aspx?receive=" + encodeURIComponent(receivemail) + "&name=" + encodeURIComponent(receivname);
    var feature = "status:no;dialogWidth:700px;dialogHeight:380px;help:no;scroll:auto;edge:sunken";
    feature = feature + GetShowModalPosition(700, 380);
    var RtnVal = window.showModalDialog(url, "", feature);
}

function EmaaddrFormatExt(pstr) {
    var temp = ExtractBetweenPattern(pstr, "<", ">")
    if (temp != "")
        pstr = temp
    return pstr;
}

function GetMailAddresses(name) {
    m_addrBook = { "type": new Array(), "name": new Array(), "email": new Array(), "href": new Array(), "company": new Array(), "dept": new Array(), "title": new Array() };

    var rows, count;
    var adCount = 0;
    var xmlHTTP = createXMLHttpRequest();
    var xmlDOM = createXmlDom();
    var objNode;
    createNodeInsert(xmlDOM, objNode, "DATA");

    if (EmaaddrFormatExt(name).indexOf("@") == -1) {
        createNodeAndInsertText(xmlDOM, objNode, "ORGSEARCH", "displayname::" + EmaaddrFormatExt(name));
    }
    else {
        createNodeAndInsertText(xmlDOM, objNode, "ORGSEARCH", "mail::" + EmaaddrFormatExt(name));
    }

    createNodeAndInsertText(xmlDOM, objNode, "DLGSEARCH", "displayname::" + name);
    createNodeAndInsertText(xmlDOM, objNode, "CELL", "displayName");
    createNodeAndInsertText(xmlDOM, objNode, "ORGPROP", "company;description;title;mail;extensionAttribute3");
    createNodeAndInsertText(xmlDOM, objNode, "DLPROP", "mail");
    createNodeAndInsertText(xmlDOM, objNode, "ORGTYPE", "all");
    createNodeAndInsertText(xmlDOM, objNode, "DLTYPE", "group");
    createNodeAndInsertText(xmlDOM, objNode, "FIELD", "AddressID,SNAME,SEMAIL,STYPE");
    createNodeAndInsertText(xmlDOM, objNode, "ADDFILTER", name);
    xmlHTTP.open("POST", "/ezEmail/mailNameCheck.do", false);
    xmlHTTP.send(xmlDOM);

    xmlDOM = loadXMLString(xmlHTTP.responseText);
    var rows = SelectNodes(xmlDOM, "RESULT/ORGAN/ROW");
    adCount = rows.length;
    for (count = 0; count < rows.length; count++) {
        if (getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[1]) == "group") {
            m_addrBook["type"][count] = "email";
            m_addrBook["name"][count] = getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[0]);
            m_addrBook["email"][count] = getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[6]);
            m_addrBook["href"][count] = "";
            m_addrBook["company"][count] = getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[7]);
            m_addrBook["dept"][count] = getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[4]);
            m_addrBook["title"][count] = strLang110;
        }
        else {
            m_addrBook["type"][count] = "email";
            m_addrBook["name"][count] = getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[0]);
            m_addrBook["email"][count] = getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[6]);
            m_addrBook["href"][count] = "";
            m_addrBook["company"][count] = getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[3]);
            m_addrBook["dept"][count] = getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[4]);
            m_addrBook["title"][count] = getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[5]);
        }
    }

    var contactList = SelectNodes(xmlDOM, "RESULT/ADDRESS/ROW");
    var row;
    for (count = 0; count < contactList.length; count++) {
        if (SelectSingleNodeValue(contactList[count], "STYLE") == "P") {
            m_addrBook["type"][count + adCount] = "email";
            try {
                m_addrBook["name"][count + adCount] = SelectSingleNodeValue(contactList[count], "SNAME");
            }
            catch (ex) {
                m_addrBook["name"][count + adCount] = "";
            }
            try {
                m_addrBook["email"][count + adCount] = SelectSingleNodeValue(contactList[count], "SEMAIL");
            }
            catch (ex) {
                m_addrBook["email"][count + adCount] = "";
            }
            m_addrBook["href"][count + adCount] = "";
        }
        else {
            m_addrBook["type"][count + adCount] = "mailgroup";
            m_addrBook["name"][count + adCount] = SelectSingleNodeValue(contactList[count], "SNAME");
            m_addrBook["email"][count + adCount] = SelectSingleNodeValue(contactList[count], "SEMAIL");
            m_addrBook["href"][count + adCount] = SelectSingleNodeValue(contactList[count], "ADDRESSID") + "|!|" + SelectSingleNodeValue(contactList[count], "FLODERTYPE");
        }
        m_addrBook["company"][count + adCount] = SelectSingleNodeValue(contactList[count], "SCOMPANY");
        m_addrBook["dept"][count + adCount] = SelectSingleNodeValue(contactList[count], "SDEPT");
        m_addrBook["title"][count + adCount] = SelectSingleNodeValue(contactList[count], "STITLE");
    }
    rows = SelectNodes(xmlDOM, "RESULT/DL/ROW");
    for (var count = 0 ; count < rows.length ; count++) {
        m_addrBook["type"][count + adCount] = "email";
        m_addrBook["name"][count + adCount] = getNodeText(GetChildNodes(rows[count])[0].getElementsByTagName("VALUE")[0]);
        m_addrBook["email"][count + adCount] = getNodeText(GetChildNodes(rows[count])[0].getElementsByTagName("DATA3")[0]);
        m_addrBook["href"][count + adCount] = "";
        m_addrBook["company"][count + adCount] = strLang114;
        m_addrBook["dept"][count + adCount] = "";
        m_addrBook["title"][count + adCount] = "";
    }
    
    //TODO: delete
    for (var count = 0 ; count < m_addrBook["email"].length ; count++) {
    	if (m_addrBook["email"][count].indexOf("opensol2014.com") > -1) {
    		m_addrBook["email"][count] = m_addrBook["email"][count].replace("opensol2014.com", domainName);
    	}
    }
    
    xmlDOM = null;
    xmlHTTP = null;
}

function CheckMailReceiver(newElem) {
    var rtnValue = false;
    for (co = 0; co < MsgToGot.childNodes.length; co++) {
        if (MsgToGot.childNodes[co].childNodes[0].nodeName == "#text")
            continue;
        if (newElem.childNodes[0].getAttribute("email") == MsgToGot.childNodes[co].childNodes[0].getAttribute("email") && MsgToGot.childNodes[co].childNodes[0].getAttribute("type") != "mailgroup")
            return true;
        else if (newElem.childNodes[0].getAttribute("href") == MsgToGot.childNodes[co].childNodes[0].getAttribute("href") && MsgToGot.childNodes[co].childNodes[0].getAttribute("type") == "mailgroup")
            return true;
    }
    for (co = 0; co < MsgCCGot.childNodes.length; co++) {
        if (MsgCCGot.childNodes[co].childNodes[0].nodeName == "#text")
            continue;
        if (newElem.childNodes[0].getAttribute("email") == MsgCCGot.childNodes[co].childNodes[0].getAttribute("email") && MsgCCGot.childNodes[co].childNodes[0].getAttribute("type") != "mailgroup")
            return true;
        else if (newElem.childNodes[0].getAttribute("href") == MsgCCGot.childNodes[co].childNodes[0].getAttribute("href") && MsgCCGot.childNodes[co].childNodes[0].getAttribute("type") == "mailgroup")
            return true;
    }
    for (co = 0; co < MsgBCCGot.childNodes.length; co++) {
        if (MsgBCCGot.childNodes[co].childNodes[0].nodeName == "#text")
            continue;
        if (newElem.childNodes[0].getAttribute("email") == MsgBCCGot.childNodes[co].childNodes[0].getAttribute("email") && MsgBCCGot.childNodes[co].childNodes[0].getAttribute("type") != "mailgroup")
            return true;
        else if (newElem.childNodes[0].getAttribute("href") == MsgBCCGot.childNodes[co].childNodes[0].getAttribute("href") && MsgBCCGot.childNodes[co].childNodes[0].getAttribute("type") == "mailgroup")
            return true;
    }
    return rtnValue
}

var checkname_cross_dialogArguments = new Array();
var CompletToisEnd = false;
var CompletCcisEnd = false;
var CompletBccisEnd = false;
var CompletCancelBtn = false;
function ToTalCompletEmailAddress() {
    var formName, validDIV, iType;
    if (!CompletCancelBtn) {
        if (document.getElementById("MsgTo").value != "" && !CompletToisEnd) {
            formName = ReplaceText(document.getElementById("MsgTo").value, ",", ";");
            var mailArr = String(formName).split(";");
            if (mailArr.length > 0) {
                CompleteEmailAddress(MsgTo, MsgToGot, 0);
                document.getElementById("MsgTo").value = "";
                return;
            }
            else {
                CompletToisEnd = true;
                document.getElementById("MsgTo").value = "";
            }
        }
        else if (document.getElementById("MsgTo").value == "") {
            CompletToisEnd = true;
            document.getElementById("MsgTo").value = "";
        }
        if (document.getElementById("MsgCC").value != "" && !CompletCcisEnd) {
            formName = ReplaceText(document.getElementById("MsgCC").value, ",", ";");
            var mailArr = String(formName).split(";");
            if (mailArr.length > 0) {
                CompleteEmailAddress(MsgCC, MsgCCGot, 1);
                document.getElementById("MsgCC").value = "";
                return;
            }
            else {
                CompletCcisEnd = true;
                document.getElementById("MsgCC").value = "";
            }
        }
        else if (document.getElementById("MsgCC").value == "") {
            CompletCcisEnd = true;
            document.getElementById("MsgCC").value = "";
        }
        if (document.getElementById("MsgBCC").value != "" && !CompletBccisEnd) {
            formName = ReplaceText(document.getElementById("MsgBCC").value, ",", ";");
            var mailArr = String(formName).split(";");
            if (mailArr.length > 0) {
                CompleteEmailAddress(MsgBCC, MsgBCCGot, 2);
                document.getElementById("MsgBCC").value = "";
                return;
            }
            else {
                CompletBccisEnd = true;
                document.getElementById("MsgBCC").value = "";
            }
        }
        else if (document.getElementById("MsgBCC").value == "") {
            CompletBccisEnd = true;
            document.getElementById("MsgBCC").value = "";
        }
    }
    if (NameCertify_onClick_returnFunction != null) {
        if (CompletCancelBtn)
            NameCertify_onClick_returnFunction(false);
        else
            NameCertify_onClick_returnFunction(true);
    }
}

function CompleteEmailAddress(formName, validDIV, iType) {
    if (TrimText(formName.value) == "")
        return true;

    formName.value = ReplaceText(formName.value, ",", ";");
    var mailArr = String(formName.value).split(";");
    var userAddr;
    var mailName;
    var newElem;
    var count1;
    var length;

    nLen = mailArr.length;
    for (var i = 0; i < nLen; i++) {
	    mailName = TrimText(mailArr[i]);
	    if (mailName == "") {
	        if (iType == 0)
	            CompletToCnt++;
	        else if (iType == 1)
	            CompletCcCnt++;
	        else if (iType == 2)
	            CompletBccCnt++;
	
	        ToTalCompletEmailAddress();
	    }
	    
        if (mailName.indexOf("<") > -1 && mailName.indexOf(">") > 0) {
            var reg_email = /^[<][-A-Za-z0-9_]+[-A-Za-z0-9_.]*[@]{1}[-A-Za-z0-9_]+[-A-Za-z0-9_.]*[.]{1}[A-Za-z]{2,5}[>]$/;
            var preTag = mailName.indexOf("<");
            var endTag = mailName.indexOf(">");
            var mailTagNM;
            var mailTagAddress;
            if (reg_email.test(mailName.substring(preTag))) {
                if (preTag > 0) {
                    mailTagNM = TrimText(mailName.substring(0, preTag).replace(/"/g, ""));
                    mailTagAddress = mailName.substring(preTag + 1, endTag);
                }
                else {
                    mailTagNM = mailName.substring(preTag + 1, endTag);
                    mailTagAddress = mailName.substring(preTag + 1, endTag);
                }
                newElem = PrepareMailTag(iType, "email", mailTagNM, mailTagAddress, "");
                var IsInsert = CheckMailReceiver(newElem);
                if (!IsInsert) {
                    validDIV.appendChild(newElem);
                }
                continue;
            }
        }
        
	    GetMailAddresses(mailName);
	    if (isEmailFormat(mailName) == true) {
	        result = findAddress(mailName, m_addrBook);
	
	        if (result != null) {
	            newElem = PrepareMailTag(iType, result["type"], result["name"], result["email"], result["href"]);
	        } else {
	            newElem = PrepareMailTag(iType, "email", mailName, mailName, "");
	        }
	
	        var IsInsert = CheckMailReceiver(newElem);
	        if (!IsInsert) {
	            validDIV.appendChild(newElem);
	        }
	        var szFromName = "";
	        for (count1 = 1; count1 < mailArr.length; count1++) {
	            szFromName += mailArr[count1];
	            if (count1 != mailArr.length - 1) szFromName += ";";
	        }
	        formName.value = szFromName;
	        CompleteEmailAddress(formName, validDIV, iType);
	        return;
	    }
	    userAddr = GetEmailAddressByName(m_addrBook, mailName);
	    var emailExitsCnt = userAddr["name"].length;
	    if (userAddr["name"].length == 1 && trim(userAddr["email"][0]) == "" && userAddr["email"][0].lastIndexOf("@") < 2) {
	        emailExitsCnt = 0;
	    }
	
	    if (emailExitsCnt == 1) {
	        newElem = PrepareMailTag(iType, userAddr["type"][0], userAddr["name"][0], userAddr["email"][0], userAddr["href"][0]);
	        var IsInsert = CheckMailReceiver(newElem);
	
	        if (!IsInsert) {
	            validDIV.appendChild(newElem);
	        }
	
	        var szFromName = "";
	        for (count1 = 1; count1 < mailArr.length; count1++) {
	            szFromName += mailArr[count1];
	            if (count1 != mailArr.length - 1) szFromName += ";";
	        }
	        formName.value = szFromName;
	        CompleteEmailAddress(formName, validDIV, iType);
	    }
	    else {
	        rgParams = new Array();
	        rgParams["recipientTDData"] = null;
	        rgParams["returnedRecipientName"] = "";
	        rgParams["returnedRecipientType"] = "";
	        rgParams["returnedRecipientEmail"] = "";
	        rgParams["returnedRecipientHref"] = "";
	        rgParams["g_EditNameDialog"] = "";
	        rgParams["g_DisplayName"] = mailName;
	        rgParams["cmd"] = "JustThis"
	        rgParams["addrBook"] = m_addrBook;
	        rgParams["g_EmailAddress"] = "";
	        if (userAddr["name"].length == 0) {
	            rgParams["cmd"] = "showAll";
	        }
	        checkname_cross_dialogArguments = new Array();
	        checkname_cross_dialogArguments[0] = rgParams;
	        checkname_cross_dialogArguments[1] = CompleteEmailAddress_Complete;
	        checkname_cross_dialogArguments[2] = DivPopUpHidden;
	        checkname_cross_dialogArguments[3] = mailArr;
	        checkname_cross_dialogArguments[4] = iType;
	        checkname_cross_dialogArguments[5] = validDIV;
	        checkname_cross_dialogArguments[6] = formName;
	        DivPopUpShow(625, 410, "/ezEmail/mailCheckName.do");
	    }
    }
    
    formName.value = "";
    return true;    
}

function CompleteEmailAddress_Complete(rgParams) {
    DivPopUpHidden();
    if (rgParams["recipientTDData"] == "dontprocess") {
        if (checkname_cross_dialogArguments[4] == 0)
            CompletToisEnd = true;
        else if (checkname_cross_dialogArguments[4] == 1)
            CompletCcisEnd = true;
        else if (checkname_cross_dialogArguments[4] == 2)
            CompletBccisEnd = true;

        CompletCancelBtn = true;
    }
    else {
        if (rgParams["recipientTDData"] == "change") {
            length = rgParams["returnedRecipientName"].length;

            for (count1 = 0; count1 < length; count1++) {
                newElem = PrepareMailTag(checkname_cross_dialogArguments[4], rgParams["returnedRecipientType"][count1], rgParams["returnedRecipientName"][count1],
                    rgParams["returnedRecipientEmail"][count1], rgParams["returnedRecipientHref"][count1]);

                var IsInsert = CheckMailReceiver(newElem);

                if (!IsInsert) {
                    checkname_cross_dialogArguments[5].appendChild(newElem);
                }
            }
        }
        var szFromName = "";
        for (count1 = 1; count1 < checkname_cross_dialogArguments[3].length; count1++) {
            szFromName += checkname_cross_dialogArguments[3][count1];
            if (count1 != checkname_cross_dialogArguments[3].length - 1) szFromName += ";";
        }
        checkname_cross_dialogArguments[6].value = szFromName;
    }
    ToTalCompletEmailAddress();
}

function trim(str) {
    var re = /^\s+|\s+$/g;
    return str.replace(re, '');
}

function GetDateFormatString() {
    var today = new Date();
    var year = today.getFullYear();
    var month = today.getMonth();
    var day = today.getDate();
    var resultDate = new Date(year, month, day);
    year = resultDate.getFullYear();
    month = resultDate.getMonth() + 1;
    day = resultDate.getDate();
    if (month < 10)
        month = "0" + month;
    if (day < 10)
        day = "0" + day;
    return year + "" + month + "" + day;
}

var AttachFlag = false;
function GetDocumentInfo(DocID, DocHref, ImagCnt, Target) {
    AttachFlag = true;
    var fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + encodeURI(DocHref);
    var docAttach = "";

    if (DocHref.toLowerCase().indexOf(".doc") == -1 && DocHref.toLowerCase().indexOf(".hwp") == -1) {
        if (DocHref == "IMAGE") {
            var HtmlBody = "<div class='margin' id='ezFormProc_div'><hr></hr><div align='center'>";
            if (ImagCnt == "") {
                HtmlBody = HtmlBody + "<img src='" + document.location.protocol + "//" + document.location.hostname + "/Upload_Common/" + GetDateFormatString() + "/" + DocID + ".png' embedding='1'/>";
            }
            else {
                for (var i = 1; i <= parseInt(ImagCnt) ; i++) {

                    if (i != 1)
                        HtmlBody = HtmlBody + "<br><img style='margin-top:-6px;' src='" + document.location.protocol + "//" + document.location.hostname + "/Upload_Common/" + GetDateFormatString() + "/" + DocID + "_" + i + ".png' embedding='1'/>";
                    else
                        HtmlBody = HtmlBody + "<img src='" + document.location.protocol + "//" + document.location.hostname + "/Upload_Common/" + GetDateFormatString() + "/" + DocID + "_" + i + ".png' embedding='1'/>";
                }
            }
            HtmlBody = HtmlBody + "</div></div>";
            document.getElementById("bodyValue").innerHTML = document.getElementById("bodyValue").innerHTML + HtmlBody;
        }
        else {
            if (DocHref.toLowerCase().indexOf(".mht") > -1) {
                var fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + encodeURI(DocHref);
                var tempXML = createXmlDom();
                var XmlBodyATT = createXmlDom();
                var XmlBodyDATA = createXmlDom();
                var tempStr = "";
                tempStr = ConvertMHTtoHTML(fullPath);
                tempXML = loadXMLString(tempStr)
                XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
                XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
                var htmlData = getNodeText(XmlBodyDATA);
                document.getElementById('docContent').innerHTML = htmlData;
                document.getElementById('docContent').style.height = "220px";
            }
        }
    }
    var xmlHTTP = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var xmlstring = "<DocID>" + DocID + "</DocID>";
    xmlpara = loadXMLString(xmlstring);

    if (Target == "APPROVALG")
        xmlHTTP.open("POST", "/myoffice/ezApprovalG/formContainer/aspx/aprattachMail.aspx", false);
    else
        xmlHTTP.open("POST", "/myoffice/ezApproval/formContainer/aspx/aprattachMail.aspx", false);
    xmlHTTP.send(xmlpara);

    if (xmlHTTP.status == 200) {
        var ReturnXML = loadXMLString(xmlHTTP.responseText);
        if (DocHref.toLowerCase().indexOf(".doc") > 0 || DocHref.toLowerCase().indexOf(".hwp") > 0) {
            var FileExtention = DocHref.substring(DocHref.toLowerCase().lastIndexOf(".") + 1);
            var pstrXML = "";
            pstrXML += "<LISTVIEWDATA><HEADERS>";
            pstrXML += "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
            pstrXML += "<HEADER><NAME>" + strLang3 + "</NAME><WIDTH>50</WIDTH></HEADER>";
            pstrXML += "</HEADERS><ROWS>";
            pstrXML += "<ROW><CELL><VALUE>" + getNodeText(GetElementsByTagName(ReturnXML, "DOCTITLE")[0]) + "." + FileExtention + "</VALUE>";
            pstrXML += "<DATA1>" + getNodeText(GetElementsByTagName(ReturnXML, "DOCTITLE")[0]) + "." + FileExtention + "</DATA1>";
            pstrXML += "<DATA2>" + DocHref + "</DATA2>";
            pstrXML += "<DATA3></DATA3>";
            pstrXML += "<DATA4>APPROVALDOC</DATA4>";
            pstrXML += "<DATA5>N</DATA5>";
            pstrXML += "<DATA6>" + strLang116 + "</DATA6>";
            pstrXML += "</CELL><CELL>";
            pstrXML += "<VALUE>" + strLang116 + "</VALUE>";
            pstrXML += "</CELL></ROW>";
            pstrXML += "</ROWS></LISTVIEWDATA>";
            objXML = loadXMLString(pstrXML);
            if (pAttachListXml == "") {
                pAttachListXml = objXML;
            }
            else {
                if (typeof (pAttachListXml) == "string")
                    Rtnxml = loadXMLString(pAttachListXml);
                else
                    Rtnxml = loadXMLString(getXmlString(pAttachListXml));

                GetChildNodes(SelectNodes(objXML, "<LISTVIEWDATA><ROWS>")).length
                for (var i = 0; i < SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW").length; i++) {
                    var objNewAttachNodes = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW")[i];
                    if (CrossYN()) 
                        var Node = Rtnxml.importNode(objNewAttachNodes, true);                    
                    else
                        GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(objNewAttachNodes);
                }
                pAttachListXml = Rtnxml;
            }
        }
        eSubject.value = strLang117 + getNodeText(GetElementsByTagName(ReturnXML, "DOCTITLE")[0]);
        var AttachRows = SelectNodes(ReturnXML, "ATTACHINFO/DATA/ROW");
        var pstrXML = "";
        if (AttachRows.length > 0) {
            pstrXML += "<LISTVIEWDATA><HEADERS>";
            pstrXML += "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
            pstrXML += "<HEADER><NAME>" + strLang3 + "</NAME><WIDTH>50</WIDTH></HEADER>";
            pstrXML += "</HEADERS><ROWS>";
        }

        for (var i = 0; i < AttachRows.length; i++) {
            var filepath = SelectSingleNodeValue(AttachRows[i], "ATTACHFILEHREF");
            var filename = SelectSingleNodeValue(AttachRows[i], "ATTACHNAME");
            var filesize = SelectSingleNodeValue(AttachRows[i], "ATTACHFILESIZE");
            if (filesize == "0" && filepath.substring(filepath.toLowerCase().lastIndexOf(".") + 1) == "hwp") {
                filename = filename + ".hwp";
                filesize = strLang116;
            }
            else if (filesize == "0" && filepath.substring(filepath.toLowerCase().lastIndexOf(".") + 1) == "mht") {
                filename = filename + ".mht";
                filesize = strLang116;
            }

            pstrXML += "<ROW><CELL><VALUE><![CDATA[" + filename + "]]></VALUE>";
            pstrXML += "<DATA1><![CDATA[" + filename + "]]></DATA1>";
            pstrXML += "<DATA2>" + filepath + "</DATA2>";
            pstrXML += "<DATA3></DATA3>";
            pstrXML += "<DATA4>APPROVAL</DATA4>";
            pstrXML += "<DATA5>N</DATA5>";
            pstrXML += "<DATA6>" + filesize + "</DATA6>";
            if (filesize > BigSizeAttachSize)
                pstrXML += "<DATA7>Y</DATA7>";
            else
                pstrXML += "<DATA7>N</DATA7>";

            pstrXML += "</CELL><CELL>";
            pstrXML += "<VALUE>" + filesize + " Bytes" + "</VALUE>";
            pstrXML += "</CELL></ROW>";
        }
        if (pstrXML != "") {
            pstrXML += "</ROWS></LISTVIEWDATA>";
            objXML = loadXMLString(pstrXML);
            if (pAttachListXml == "") {
                pAttachListXml = objXML;
            }
            else {
                if (typeof (pAttachListXml) == "string")
                    Rtnxml = loadXMLString(pAttachListXml);
                else
                    Rtnxml = loadXMLString(getXmlString(pAttachListXml));

                GetChildNodes(SelectNodes(objXML, "<LISTVIEWDATA><ROWS>")).length
                for (var i = 0; i < SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW").length; i++) {
                    var objNewAttachNodes = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW")[i];
                    if (CrossYN())
                        var Node = Rtnxml.importNode(objNewAttachNodes, true);
                    else
                        GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(objNewAttachNodes);
                }
                pAttachListXml = Rtnxml;
            }
            if (DragDropAttachObjetLoading)
                AppendFileAttachInfo(pAttachListXml);
        }
    }
}


function GetBoardItemInfo_New(pBoardID, pItemID, pRetransType) {
    AttachFlag = true;
    var xmlHTTP = createXMLHttpRequest();
    xmlHTTP.open("GET", "/myoffice/ezBoardSTD/interASP/GetItemInfo.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID, false);
    xmlHTTP.send("");

    if (xmlHTTP.status == 200) {
        var ReturnXML = loadXMLString(xmlHTTP.responseText);
        var Rurl = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/ContentLocation")[0]);
        var fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + encodeURI(Rurl);
        var tempXML = createXmlDom();
        var XmlBodyATT = createXmlDom();
        var XmlBodyDATA = createXmlDom();
        var tempStr = "";
        tempStr = ConvertMHTtoHTML(fullPath);

        tempXML = loadXMLString(tempStr);
        XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
        XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
        var htmlData = getNodeText(XmlBodyDATA);

        eSubject.value = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/Title")[0]);
        var PostDate = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/StartDate")[0]);
        var Sender = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriterName")[0]) + " (" +
	                 getNodeText(SelectNodes(ReturnXML, "NODES/NODE/ExtensionAttribute3")[0]) + "," +
			         getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriterDeptName")[0]) + "," +
			         getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriterCompanyName")[0]) + ")";

        if (Sender.indexOf("(,,)") > -1) Sender = Sender.split("(")[0];

        htmlData = ReplaceText(htmlData, "<P ", "<DIV ");
        htmlData = ReplaceText(htmlData, "/P>", "/DIV>");
        htmlData = ReplaceText(htmlData, "<P>", "<DIV>");
        htmlData = ReplaceText(htmlData, "</P>", "</DIV>");
        htmlData = ReplaceText(htmlData, "<TD class=FIELD", "<TD");
        if (pRetransType != "boardAttach")
            document.getElementById("bodyValue").innerHTML = "<DIV style='LINE-HEIGHT: 15pt' ><br /><br /><DIV id='MailSign'></div><br /></DIV>" + "<br><br><hr></hr><B>" + strLang118 + "</B>" + PostDate + "<br><B>" + strLang119 + "</B>" + Sender + "<br><B>" + strLang120 + "</B>" + eSubject.value + "<br><br>" + htmlData;

        xmlHTTP.open("POST", "/myoffice/ezBoardSTD/interASP/GetItemAttachments.aspx?ItemID=" + pItemID + "&pMode=" + pRetransType + "&ConLocation=" + encodeURI(Rurl) + "&Title=" + encodeURI(getNodeText(SelectNodes(ReturnXML, "NODES/NODE/Title")[0])), false);
        xmlHTTP.send();
        var ReturnXML = loadXMLString(xmlHTTP.responseText);
        var AttachRows = SelectNodes(ReturnXML, "NODES/NODE");
        var pstrXML = "";


        if (AttachRows.length > 0) {
            pstrXML += "<LISTVIEWDATA><HEADERS>";
            pstrXML += "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
            pstrXML += "<HEADER><NAME>" + strLang3 + "</NAME><WIDTH>50</WIDTH></HEADER>";
            pstrXML += "</HEADERS><ROWS>";
        }
        for (var i = 0; i < AttachRows.length; i++) {
            var filepath = SelectSingleNodeValue(AttachRows[i], "FilePath");
            var filenameTemp = filepath.split('/')[filepath.split('/').length - 1];
            var filename = MakeXMLString(filenameTemp.substring(filenameTemp.indexOf("_") + 1, filenameTemp.length));
            var filepath = "/Upload_BoardSTD/" + filepath;
            var filesize = SelectSingleNodeValue(AttachRows[i], "FileSize");

            pstrXML += "<ROW><CELL><VALUE><![CDATA[" + filename + "]]></VALUE>";
            pstrXML += "<DATA1><![CDATA[" + filename + "]]></DATA1>";
            pstrXML += "<DATA2><![CDATA[" + filepath + "]]></DATA2>";
            pstrXML += "<DATA3></DATA3>";
            pstrXML += "<DATA4>BOARD</DATA4>";
            pstrXML += "<DATA5>N</DATA5>";
            pstrXML += "<DATA6>" + filesize + "</DATA6>";
            if(filesize > BigSizeAttachSize )
                pstrXML += "<DATA7>Y</DATA7>";
            else
                pstrXML += "<DATA7>N</DATA7>";
            pstrXML += "</CELL><CELL>";
            pstrXML += "<VALUE>" + filesize + " Bytes" + "</VALUE>";
            pstrXML += "</CELL></ROW>";
        }

        if (pstrXML != "") {
            pstrXML += "</ROWS></LISTVIEWDATA>";
            objXML = loadXMLString(pstrXML);
            if (pAttachListXml == "") {
                pAttachListXml = objXML;
            }
            else {
                if (typeof (pAttachListXml) == "string")
                    Rtnxml = loadXMLString(pAttachListXml);
                else
                    Rtnxml = loadXMLString(getXmlString(pAttachListXml));

                GetChildNodes(SelectNodes(objXML, "<LISTVIEWDATA><ROWS>")).length
                for (var i = 0; i < SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW").length; i++) {
                    var objNewAttachNodes = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW")[i];
                    if (CrossYN())
                        var Node = Rtnxml.importNode(objNewAttachNodes, true);
                    else
                        GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(objNewAttachNodes);
                }
                pAttachListXml = Rtnxml;
            }
            if (DragDropAttachObjetLoading)
                AppendFileAttachInfo(pAttachListXml);
        }
        eSubject.value = strLang121 + eSubject.value;
        Subject_ReApply();
    }
}

function GetBoardItemInfo_New3(pBoardID, pItemID) {
    AttachFlag = true;
    var xmlHTTP = createXMLHttpRequest();
    xmlHTTP.open("GET", "/myoffice/ezCommunity/aspx/GetItemInfo.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID, false);
    xmlHTTP.send("");

    if (xmlHTTP.status == 200) {
        var ReturnXML = loadXMLString(xmlHTTP.responseText);
        var Rurl = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/ContentLocation")[0]);
        var fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + encodeURI(Rurl);
        var tempXML = createXmlDom();
        var XmlBodyATT = createXmlDom();
        var XmlBodyDATA = createXmlDom();
        var tempStr = "";
        tempStr = ConvertMHTtoHTML(fullPath);
        tempXML = loadXMLString(tempStr)
        XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
        XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
        var htmlData = getNodeText(XmlBodyDATA);

        eSubject.value = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/Title")[0]);
        var PostDate = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/StartDate")[0]);
        var Sender = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriterName")[0]) + " (" +
	                 getNodeText(SelectNodes(ReturnXML, "NODES/NODE/ExtensionAttribute3")[0]) + "," +
			         getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriterDeptName")[0]) + "," +
			         getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriterCompanyName")[0]) + ")";

        if (Sender.indexOf("(,,)") > -1) Sender = Sender.split("(")[0];

        htmlData = ReplaceText(htmlData, "<P ", "<DIV ");
        htmlData = ReplaceText(htmlData, "/P>", "/DIV>");
        htmlData = ReplaceText(htmlData, "<P>", "<DIV>");
        htmlData = ReplaceText(htmlData, "</P>", "</DIV>");
        htmlData = ReplaceText(htmlData, "<TD class=FIELD", "<TD");
        document.getElementById("bodyValue").innerHTML = "<DIV style='LINE-HEIGHT: 15pt' ><br /><br /><DIV id='MailSign'></div><br /></DIV>" + "<br><br><hr></hr><B>" + strLang118 + "</B>" + PostDate + "<br><B>" + strLang119 + "</B>" + Sender + "<br><B>" + strLang120 + "</B>" + eSubject.value + "<br><br>" + htmlData;

        xmlHTTP.open("POST", "/myoffice/ezCommunity/aspx/GetItemAttachments.aspx?ItemID=" + pItemID, false);
        xmlHTTP.send();
        var ReturnXML = loadXMLString(xmlHTTP.responseText);
        var AttachRows = SelectNodes(ReturnXML, "NODES/NODE");
        var pstrXML = "";
        if (AttachRows.length > 0) {
            pstrXML += "<LISTVIEWDATA><HEADERS>";
            pstrXML += "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
            pstrXML += "<HEADER><NAME>" + strLang3 + "</NAME><WIDTH>50</WIDTH></HEADER>";
            pstrXML += "</HEADERS><ROWS>";
        }
        for (var i = 0; i < AttachRows.length; i++) {
            var filepath = SelectSingleNodeValue(AttachRows[i], "FilePath");
            var filenameTemp = filepath.split('/')[filepath.split('/').length - 1];
            var filename = MakeXMLString(filenameTemp.substring(filenameTemp.indexOf("_") + 1, filenameTemp.length));
            var filepath = "/Upload_BoardSTD/" + filepath;
            var filesize = SelectSingleNodeValue(AttachRows[i], "FileSize");

            pstrXML += "<ROW><CELL><VALUE>" + filename + "</VALUE>";
            pstrXML += "<DATA1>" + filename + "</DATA1>";
            pstrXML += "<DATA2>" + filepath + "</DATA2>";
            pstrXML += "<DATA3></DATA3>";
            pstrXML += "<DATA4>BOARD</DATA4>";
            pstrXML += "<DATA5>N</DATA5>";
            pstrXML += "<DATA6>" + filesize + "</DATA6>";
            if (filesize > BigSizeAttachSize)
                pstrXML += "<DATA7>Y</DATA7>";
            else
                pstrXML += "<DATA7>N</DATA7>";
            pstrXML += "</CELL><CELL>";
            pstrXML += "<VALUE>" + filesize + " Bytes" + "</VALUE>";
            pstrXML += "</CELL></ROW>";
        }

        if (pstrXML != "") {
            pstrXML += "</ROWS></LISTVIEWDATA>";
            objXML = loadXMLString(pstrXML);
            if (pAttachListXml == "") {
                pAttachListXml = objXML;
            }
            else {
                if (typeof (pAttachListXml) == "string")
                    Rtnxml = loadXMLString(pAttachListXml);
                else
                    Rtnxml = loadXMLString(getXmlString(pAttachListXml));

                GetChildNodes(SelectNodes(objXML, "<LISTVIEWDATA><ROWS>")).length
                for (var i = 0; i < SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW").length; i++) {
                    var objNewAttachNodes = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW")[i];
                    var Node = Rtnxml.importNode(objNewAttachNodes, true);
                    GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(objNewAttachNodes);
                }
                pAttachListXml = Rtnxml;
            }
            if (DragDropAttachObjetLoading)
                AppendFileAttachInfo(pAttachListXml);
        }
        eSubject.value = strLang121 + eSubject.value;
        Subject_ReApply();
    }
}

function DocFileIntoXML(xmlDoc, rootNode) {
    if (pOrgAttachListXml != "") {
        var AttachRows = SelectNodes(pOrgAttachListXml, "LISTVIEWDATA/ROWS/ROW");
        for (var i = 0; i < AttachRows.length; i++) {
            if (getNodeText(GetElementsByTagName(AttachRows[i], "DATA5")[0]) == "N") {
                var pFileName = getNodeText(GetElementsByTagName(AttachRows[i], "DATA1")[0]);
                var pFileHref = getNodeText(GetElementsByTagName(AttachRows[i], "DATA2")[0]);
                var rootNode;
                createNodeAndInsertText(xmlDoc, rootNode, "DOCATTACHNAME", pFileName);
                createNodeAndInsertText(xmlDoc, rootNode, "DOCATTACHPATH", pFileHref);
            }
            //else {
            //    var pFileName = getNodeText(GetElementsByTagName(AttachRows[i], "DATA1")[0]);
            //    var pFileHref = getNodeText(GetElementsByTagName(AttachRows[i], "DATA2")[0]);
            //    var rootNode;
            //    createNodeAndInsertText(xmlDoc, rootNode, "DOCATTACHNAME", pFileName);
            //    createNodeAndInsertText(xmlDoc, rootNode, "DOCATTACHPATH", pFileHref);
            //}
        }
    }
}

function GetEncodeTextNew(pUrl, pMode) {
    var XmlHttp = createXMLHttpRequest();
    var xmlDom = createXmlDom();
    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "URL", encodeURIComponent(pUrl));
    try {
        XmlHttp.open("POST", "/myoffice/ezEmail/remote/LoadMailImage.aspx?MODE=" + pMode, false);
        XmlHttp.send(xmlDom);
        return XmlHttp.responseText;
    }
    catch (e) { }
}

function GetEncodeTextNew_LinkedSystem(pUrl) {
    var XmlHttp = createXMLHttpRequest();
    var xmlDom = createXmlDom();
    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "URL", encodeURIComponent(pUrl));
    try {
        XmlHttp.open("POST", "/myoffice/ezEmail/remote/LoadLinkImage.aspx", false);
        XmlHttp.send(xmlDom);
        return XmlHttp.responseText;
    }
    catch (e) { }
}

function ConvertEmbedImagToXml(xmlDoc, rootNode) {
    var tempDiv = document.createElement("DIV");
    tempDiv.innerHTML = message.GetEditorContent();

    var imgColl = tempDiv.getElementsByTagName("IMG");
    for (var i = 0; i < imgColl.length; i++) {
        if (imgColl.item(i).src.toLowerCase().indexOf("upload_common") > 0 || imgColl.item(i).src.toLowerCase().indexOf("mailsignimage") > 0) {
            var imagePath = imgColl.item(i).src;            
        	var srcValue = imgColl.item(i).getAttribute("src");

        	if (srcValue.substr(0, 4) != "http") {
	            var formname = imgColl.item(i).src.substr(imgColl.item(i).src.lastIndexOf("/") + 1)
	
	            var XmlHtml = getNodeText(SelectNodes(xmlDoc, "DATA/HTMLBODY")[0]);
	            var OrgHteml = imgColl.item(i).outerHTML;
	
	            imgColl.item(i).setAttribute("src", formname);
	            imgColl.item(i).removeAttribute("embedding");
	            imgColl.item(i).outerHTML = imgColl.item(i).outerHTML.replace("src=\"" + formname + "\"", "src=\"" + formname + "\" embedding=\"1\" ")
	
	            XmlHtml = XmlHtml.replace(OrgHteml, imgColl.item(i).outerHTML);
	            if (CrossYN())
	                SelectNodes(xmlDoc, "DATA/HTMLBODY")[0].textContent = XmlHtml;
	            else
	                SelectNodes(xmlDoc, "DATA/HTMLBODY")[0].text = XmlHtml;
	            createNodeAndInsertText(xmlDoc, rootNode, "IMAGENAME", formname);
	            createNodeAndInsertText(xmlDoc, rootNode, "IMAGEPATH", imagePath);
            }
        }
        if (imgColl.item(i).src.toLowerCase().indexOf("ezcommon_interface.aspx") > -1) {
            var encodedText = GetEncodeTextNew(imgColl.item(i).src, '1');
            var formname = "";
            if (imgColl.item(i).src.indexOf("FILENAME=") > -1) {
                formname = imgColl.item(i).src.substr(imgColl.item(i).src.lastIndexOf("FILENAME=") + 9)
                formname = ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(formname, "%25", ""), "\\\[", "%5B"), "\\\]", "%5D"), "&", "%26"), "{", "%7B"), "}", "%7D");   
            }
            else {
                var pos2 = imgColl.item(i).src.indexOf("ATTID=");
                var refilename = imgColl.item(i).src.substr(pos2 + 6).substr(0, imgColl.item(i).src.substr(pos2 + 6).lastIndexOf(".")) + ".jpg";
                formname = refilename;
                formname = ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(formname, "%25", ""), "\\\[", "%5B"), "\\\]", "%5D"), "&", "%26"), "{", "%7B"), "}", "%7D");
            }

            var XmlHtml = getNodeText(SelectNodes(xmlDoc, "DATA/HTMLBODY")[0]);
            var OrgHteml = imgColl.item(i).outerHTML;

            imgColl.item(i).setAttribute("src", formname);
            imgColl.item(i).removeAttribute("embedding");
            imgColl.item(i).outerHTML = imgColl.item(i).outerHTML.replace("src=\"" + formname + "\"", "src=\"" + formname + "\" embedding=\"1\" ")

            XmlHtml = XmlHtml.replace(OrgHteml, imgColl.item(i).outerHTML);
            if (CrossYN())
                SelectNodes(xmlDoc, "DATA/HTMLBODY")[0].textContent = XmlHtml;
            else
                SelectNodes(xmlDoc, "DATA/HTMLBODY")[0].text = XmlHtml;
            createNodeAndInsertText(xmlDoc, rootNode, "IMAGENAME", formname);
            createNodeAndInsertText(xmlDoc, rootNode, "IMAGECONTENT", encodedText);
        }
        else if (imgColl.item(i).src.indexOf("myoffice/Common/DownloadAttach.aspx") > 0 && imgColl.item(i).getAttribute("embedding") == "1") {
            var encodedText = GetEncodeTextNew_LinkedSystem(imgColl.item(i).src);
            var formname = imgColl.item(i).src.substr(imgColl.item(i).src.lastIndexOf("/") + 1);

            var XmlHtml = getNodeText(SelectNodes(xmlDoc, "DATA/HTMLBODY")[0]);
            var OrgHteml = imgColl.item(i).outerHTML;

            imgColl.item(i).setAttribute("src", formname);
            imgColl.item(i).removeAttribute("embedding");
            imgColl.item(i).outerHTML = imgColl.item(i).outerHTML.replace("src=\"" + formname + "\"", "src=\"" + formname + "\" embedding=\"1\" ")

            XmlHtml = XmlHtml.replace(OrgHteml, imgColl.item(i).outerHTML);
            if (CrossYN())
                SelectNodes(xmlDoc, "DATA/HTMLBODY")[0].textContent = XmlHtml;
            else
                SelectNodes(xmlDoc, "DATA/HTMLBODY")[0].text = XmlHtml;
            createNodeAndInsertText(xmlDoc, rootNode, "IMAGENAME", formname);
            createNodeAndInsertText(xmlDoc, rootNode, "IMAGECONTENT", encodedText);
        }
    }
}

function ConvertEmbedPath(xmlDoc, rootNode) {

    var tempDiv = document.createElement("SPAN");
    tempDiv.innerHTML = message.GetEditorContent();

    var isBigFile = false;
    for (var i = 0; i < dadiframe.document.getElementById("filelist").childNodes.length - 1; i++) {
        if (dadiframe.document.getElementById("filelist").childNodes.length > 1) {
            if (dadiframe.document.getElementById("filelist").childNodes[i + 1].getAttribute("_big") == "Y") {
                isBigFile = true;
            }
        }
    }

    if (isBigFile) {
        var TempText = "<div id='_BigAttachListHtml' style='width:100%;'><table width='100%' border='0' cellspacing='0' cellpadding='0' style='font-size:x-small;font-family:dotum,arial,verdana;margin-bottom:10px;'>" +
                        "<tr>" +
                        "<td colspan='2' style='color:#333;font-weight:bold; padding:0px; margin:0px 0px 1px 0px; height:20px;border-bottom:1px solid #dadada;font-size:12px;'><img src='" + document.location.protocol + "//" + g_servername + "/images/icon_addfile.gif' width='7' height='12' style='margin-right:5px;'>" + strLang245 + "</td>" +
                        "</tr>";
        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open("GET", "/ezEmail/fileListSession.do?filedata=" + filedate, false);
        xmlhttp.send();
        var pAttachXml = loadXMLString(xmlhttp.responseText);
        var nodes = SelectNodes(pAttachXml, "ROOT/NODES/NODE");


        for (var i = 0 ; i < nodes.length ; i++) {
            if (getNodeText(GetChildNodes(nodes[i])[5]) == "Y") {
                if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") {
                    var strTarget = "target='_blank'";
                    var FileName = getNodeText(GetChildNodes(nodes[i])[2]);
                    var strFileExt = FileName.substr(FileName.lastIndexOf('.'));
                    strFileExt = strFileExt.toLowerCase();
                    if (strFileExt == ".xls" || strFileExt == ".doc" || strFileExt == ".ppt" ||
                    strFileExt == ".eml" || strFileExt == ".pdf" || strFileExt == ".hwp" ||
                    strFileExt == ".ppt" || strFileExt == ".docx" || strFileExt == ".pptx" ||
                    strFileExt == ".xlsx" || strFileExt == ".rtf" || strFileExt == ".mp3" || strFileExt == ".zip") {
                        strTarget = "target=''";
                    }

                    var EmailHref = document.location.protocol + "//" + g_servername + "/ezEmail/downloadAttachCommon.do?fileid=" + getNodeText(GetChildNodes(nodes[i])[0]) + "&filedate=" + folderDate;
                    TempText += "<tr>" +
                                "<td colspan='2' style='border-left:1px solid #dadada;border-right:1px solid #dadada;border-bottom:1px solid #dadada;  line-height:18px; padding:5px 10px 5px 10px; margin:0px;list-style:none;'>" +
                                "<a href='" + EmailHref + "' " + strTarget + " style='color:#333333; text-decoration: none;'><img src='" + document.location.protocol + "//" + g_servername + "/images/icon_adddownload.gif' width='16' height='16'  style='margin-right:8px; cursor:pointer;' border='0'/></a>" +
                                "<a id='BigSizeFileLink' href='" + EmailHref + "' " + strTarget + " style='color:#333333; text-decoration: none;font-size:12px;'>" + FileName + "</a></td>" +
                                "</tr>";
                }
            }
        }
        TempText += "<tr>" +
                    "<td width='75%' style='font-size:11px; font-weight:normal; color:#666666; padding-left:10px; margin:0px; border-bottom:1px solid #dadada;border-left:1px solid #dadada; background:#f6f6f6; height:25px; line-height:25px;'>" +
                    strLang246 + "<span style='color:#FF0000 ;'>" + _pBigAttachDownloadPeriod + "</span></td>" +
                    "<td width='30%' align='right' style='font-size:11px; font-weight:normal; color:#666666; padding-right:10px; margin:0px; border-bottom:1px solid #dadada;border-right:1px solid #dadada; background:#f6f6f6; height:25px; line-height:25px;'>" +
	                strLang247 + "<span style='color:#FF0000 ;'>" + _pBigAttachDownloadDay + strLang248 + "</span>" + strLang249 + "</div>	</td>" +
                    "</tr></table></div>";

        tempDiv.innerHTML = TempText + tempDiv.innerHTML;
    }

    var imgColl = tempDiv.getElementsByTagName("IMG");

    for (var i = 0; i < imgColl.length; i++) {
        if (typeof (imgColl.item(i).srcorg) != "undefined" && imgColl.item(i).src.toLowerCase().indexOf(document.location.protocol + "//") == 0) {

            imgColl.item(i).src = ReplaceText(imgColl.item(i).srcorg, "%25", "");
            imgColl.item(i).removeAttribute("srcorg");
        }
        else if (typeof (imgColl.item(i).srcorgEmbedImage) != "undefined" && imgColl.item(i).src.toLowerCase().indexOf(document.location.protocol + "//") == 0) {
            imgColl.item(i).src = ReplaceText(imgColl.item(i).srcorgEmbedImage, "%25", "");
            imgColl.item(i).removeAttribute("srcorgEmbedImage");
        }//20131220 image
        else if (imgColl.item(i).src.toLowerCase().indexOf("upload_personal/mailsignimage") > -1 || imgColl.item(i).src.toLowerCase().indexOf("upload_common") > -1) {
        	var srcValue = imgColl.item(i).getAttribute("src");

        	if (srcValue.substr(0, 4) != "http") {
	            var pos = imgColl.item(i).src.lastIndexOf("/");
	            var rePath = ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(imgColl.item(i).src.substr(pos + 1), "%25", ""), "\\\[", "%5B"), "\\\]", "%5D"), "&", "%26"), "{", "%7B"), "}", "%7D");
	            imgColl.item(i).src = rePath;
	            imgColl.item(i).setAttribute("embedding", "1");
        	}
        }//20140801 mailsign sec
        else if (imgColl.item(i).src.toLowerCase().indexOf("ezcommon_interface.aspx") > -1) {
            var pos = imgColl.item(i).src.indexOf("FILENAME=");
            if (pos > -1) {
                var rePath = ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(imgColl.item(i).src.substr(pos + 9), "%25", ""), "\\\[", "%5B"), "\\\]", "%5D"), "&", "%26"), "{", "%7B"), "}", "%7D");
                imgColl.item(i).src = rePath;
                imgColl.item(i).setAttribute("embedding", "1");
            }
            else {
                var pos2 = imgColl.item(i).src.indexOf("ATTID=");
                if (pos2 > -1) {
                    var refilename = imgColl.item(i).src.substr(pos2 + 6).substr(0, imgColl.item(i).src.substr(pos2 + 6).lastIndexOf(".")) + ".jpg";
                    var rePath = ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(refilename, "%25", ""), "\\\[", "%5B"), "\\\]", "%5D"), "&", "%26"), "{", "%7B"), "}", "%7D");
                    imgColl.item(i).src = rePath;
                    imgColl.item(i).setAttribute("embedding", "1");
                }
            }
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                imgColl.item(i).removeAttribute("embedding");
                tempDiv.innerHTML = tempDiv.innerHTML.replace(rePath, rePath + '"' + " embedding=" + '"' + "1");
            }
        }
        else if (imgColl.item(i).src.substr(0, 7) == "file://" || (imgColl.item(i).embedding == 1 && imgColl.item(i).src.substr(0, 7) == document.location.protocol + "//") || (imgColl.item(i).embedding == 1 && imgColl.item(i).src.substr(0, 8) == document.location.protocol + "//")) {
            if (typeof (imgColl.item(i).srcorg) != "undefined")
                imgColl.item(i).removeAttribute("srcorg");

            if (imgColl.item(i).src.indexOf("mode=inlineimage") > 0) {
                imgColl.item(i).src = imgColl.item(i).src.split("&")[1].split("%")[0].replace("ATTID=", "");
            }
            else {
                var pos = imgColl.item(i).src.lastIndexOf("/");
                var rePath = ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(imgColl.item(i).src.substr(pos + 1), "%25", ""), "\\\[", "%5B"), "\\\]", "%5D"), "&", "%26"), "{", "%7B"), "}", "%7D");
                imgColl.item(i).src = rePath;
            }
        }
    }

    var tdColl = tempDiv.getElementsByTagName("TD");

    try {
        for (i = 0; i < tdColl.length; i++) {
            if (tdColl.item(i).innerHTML == "" || (tdColl.item(i).innerText == "" && tdColl.item(i).innerHTML.toLowerCase().indexOf("img") == -1 && tdColl.item(i).innerHTML.toLowerCase().indexOf("embed") == -1)) {
                if (tdColl.item(i).innerHTML.toLowerCase().indexOf("id=ecard") == -1) {
                    tdColl.item(i).innerHTML = "&nbsp;";
                }
            }
        }
    } catch (e) { }


    var BodyHTMLContent = "<style>P {MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm}</style> <div style='font-size:12px;font-family:Gulim'>" + tempDiv.innerHTML + "</div>";
    bigMakeXmlNode(xmlDoc, rootNode, "HTMLBODY", BodyHTMLContent.replace(regex, " "));

    try {
        tempDiv.innerHTML = ReplaceText(tempDiv.innerHTML, "<BR>", "<P>");
        tempDiv.innerHTML = ReplaceText(tempDiv.innerHTML, "</DIV>", "</DIV><P>");
        tempDiv.innerHTML = ReplaceText(tempDiv.innerHTML, "<P>", ";crlf;");
    } catch (e) { }

    bigMakeXmlNode(xmlDoc, rootNode, "eContentText", tempDiv.innerHTML.replace(regex, " "));
}

function ConvertEmbedPath_https(xmlDoc, rootNode) {
    var tempDiv = "";

    tempDiv = tbContentElement.GetBodyHTML();

    if (BigSizeAttach) {
        var TempText = "<br><br><br><br><br><FIELDSET style=\"LEFT: 0px; TOP: 1px; width:90%; padding:10px\">";
        TempText += "<LEGEND><img height=12 hspace=5 src='" + document.location.protocol + "//" + g_servername + "/images/email/mail_004.gif' width=13 vspace=5 align=\"absmiddle\" embedding=\"1\">";
        TempText += "<span style=\"color:#cc6600; font-size:10pt; font-weight:bold\">" + strLang122 + BigSizeMailAttachDelDay + " " + strLang123 + "</span></LEGEND>";


        var tmpattachedfileDIV = attachedfileDIV.all.tags("a");
        var tmpattacheinput = attachedfileDIV.all.tags("input");

        for (var i = 0 ; i < tmpattachedfileDIV.length ; i++) {
            if (tmpattacheinput(i).fileBigSizeYN == "Y") {
                var EmailHref = tmpattacheinput(i).RealHref;

                TempText += "<br><a id='BigSizeFileLink' href='" + EmailHref + "'>" + tmpattachedfileDIV(i).innerText + "</a>";
            }
        }


        TempText += "</FIELDSET>";

        tempDiv = tempDiv + TempText;
    }

    var idx = 0; var start = 0; var temp = ""; var end = 0;
    var oldstart = 0; oldend = 0;

    var tempText = "";

    if (tempDiv.toUpperCase().indexOf("<IMG", start) < 0) {
        tempText = tempDiv;
        tempDiv = "";
    }
    var splitter = "";
    while (tempDiv.toUpperCase().indexOf("<IMG", start) >= 0) {
        start = tempDiv.toUpperCase().indexOf("<IMG", start);
        end = tempDiv.indexOf(">", start + 4) + 1
        text = tempDiv.substring(start, end);
        var srcstart = text.toLowerCase().indexOf("src=", 0);
        splitter = text.substr(srcstart + 4, 1);
        var srcend = text.indexOf(splitter, srcstart + 5);
        var txtsrc = text.substr(srcstart + 5, srcend - (srcstart + 5));
        if (text.toLowerCase().indexOf("srcorg=") >= 0 && txtsrc.toLowerCase().indexOf(document.location.protocol) == 0) {
        }
        else if (text.toLowerCase().indexOf("srcorgembedimage=") >= 0 && text.toLowerCase().indexOf("src=" + splitter + document.location.protocol) >= 0) {

            var embedstart = text.toLowerCase().indexOf("srcorgembedimage=");
            splitter = text.substr(embedstart + 17, 1);
            var embedend = text.indexOf(splitter, embedstart + 18);


            text = text.substr(0, srcstart + 5) + ReplaceText(text.substr(embedstart + 18, embedend - (embedstart + 18)), "%25", "")
	        + text.substr(embedend);

        }
        else if (text.toLowerCase().indexOf("src=" + splitter + "file://") >= 0 || (text.toLowerCase().indexOf("embedding=") >= 0 && text.toLowerCase().indexOf("src=" + splitter + document.location.protocol) >= 0)) {

            if (text.toLowerCase().indexOf("srcorg=") > -1) {
                var srcorgstart = text.toLowerCase().indexOf("srcorg=", 0);
                splitter = text.substr(srcorgstart + 7, 1);
                var srcorgend = text.toLowerCase().indexOf(splitter, srcorgstart + 8);
                text = text.substring(0, srcorgstart) + text.substring(srcorgend + 1);
            }
            var srcstart = text.toLowerCase().indexOf("src=", 0);
            splitter = text.substr(srcstart + 4, 1);
            var srcend = text.toLowerCase().indexOf(splitter, srcstart + 5);
            var textEx = text.substr(srcstart, srcend - srcstart);
            text = text.substr(0, srcstart + 5) + ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(textEx.substr(textEx.lastIndexOf("/") + 1), "%25", ""), "\\\[", "%5B"), "\\\]", "%5D"), "&", "%26"), "{", "%7B"), "}", "%7D") + text.substr(srcend);
        }
        tempText = tempText + tempDiv.substr(oldend, start - oldend) + text;
        oldstart = start;
        oldend = end;
        start = end + 1;
    }

    if (tempDiv.length > start) {
        tempText = tempText + tempDiv.substr(start - 1);
    }
    MakeXmlNode(xmlDoc, rootNode, "HTMLBODY", tempText);
    try {
        tempDiv.innerHTML = ReplaceText(tempDiv, "<BR>", "<P>");
        tempDiv.innerHTML = ReplaceText(tempDiv, "</DIV>", "</DIV><P>");
        tempDiv.innerHTML = ReplaceText(tempDiv, "<P>", ";crlf;");
    } catch (e) { }

    MakeXmlNode(xmlDoc, rootNode, "eContentText", tempText);
}

function EmbedImageIntoXML(xmlDoc, rootNode) {
    var imgColl = tbContentElement.editor.DOM.images;
    for (var i = 0; i < imgColl.length; i++) {
        if ((imgColl.item(i).embedding == 1 || imgColl.item(i).src.substr(0, 7) == "file://") && (typeof (imgColl.item(i).srcorg) != "undefined" || imgColl.item(i).src.substr(0, 7) == "file://")) {
            var encodedText = GetEncodeText(imgColl.item(i).src);
            var newformname = "";

            if (encodedText.length) {
                if (typeof (imgColl.item(i).srcorg) != "undefined") {
                    formname = imgColl.item(i).src.substr(imgColl.item(i).src.lastIndexOf("/") + 1)
                    newformname = ReplaceText(ReplaceText(formname, "\\%", ""), "#", "%23");
                    xmlDoc.getElementsByTagName("HTMLBODY").item(0).text = xmlDoc.getElementsByTagName("HTMLBODY").item(0).text.replace(formname, newformname);
                    formname = ReplaceText(formname, "\\%", "");
                }
                else if (typeof (imgColl.item(i).srcorgEmbedImage) != "undefined") {
                    formname = imgColl.item(i).src.substr(imgColl.item(i).src.lastIndexOf("\\") + 1)
                    newformname = ReplaceText(ReplaceText(formname, "\\%", ""), "#", "%23");
                    xmlDoc.getElementsByTagName("HTMLBODY").item(0).text = xmlDoc.getElementsByTagName("HTMLBODY").item(0).text.replace(formname, newformname);
                    formname = ReplaceText(formname, "\\%", "");
                }
                else if (imgColl.item(i).src.substr(0, 7) != document.location.protocol + "//" || imgColl.item(i).src.substr(0, 8) != document.location.protocol + "//") {
                    if (imgColl.item(i).src.indexOf("mode=inlineimage") > 0) {
                        formname = imgColl.item(i).src.split("&")[1].split("%")[0].replace("ATTID=", "");
                        newformname = formname;
                    }
                    else {
                        formname = imgColl.item(i).src.substr(imgColl.item(i).src.lastIndexOf("/") + 1)
                        newformname = ReplaceText(ReplaceText(formname, "\\%", ""), "#", "%23");
                    }

                    xmlDoc.getElementsByTagName("HTMLBODY").item(0).text = xmlDoc.getElementsByTagName("HTMLBODY").item(0).text.replace(formname, newformname);
                    formname = ReplaceText(formname, "\\%", "");
                }
                else {
                    formname = imgColl.item(i).src.substr(imgColl.item(i).src.lastIndexOf("/") + 1);
                }

                formname = ReplaceText(formname, "%25", "");

                MakeXmlNode(xmlDoc, rootNode, "IMAGENAME", formname);
                MakeXmlNode(xmlDoc, rootNode, "IMAGECONTENT", encodedText);
            }
        }
        else if (((imgColl.item(i).embedding == 1 && imgColl.item(i).src.substr(0, 7) == document.location.protocol + "//") || (imgColl.item(i).embedding == 1 && imgColl.item(i).src.substr(0, 8) == document.location.protocol + "//")) && typeof (imgColl.item(i).srcorgEmbedImage) == "undefined") {
            var encodedText = GetEncodeText(imgColl.item(i).src);
            var newformname = "";

            if (encodedText.length) {
                if (typeof (imgColl.item(i).srcorg) != "undefined") {
                    formname = imgColl.item(i).src.substr(imgColl.item(i).src.lastIndexOf("\\") + 1)
                    newformname = ReplaceText(ReplaceText(formname, "\\%", ""), "#", "%23");
                    xmlDoc.getElementsByTagName("HTMLBODY").item(0).text = xmlDoc.getElementsByTagName("HTMLBODY").item(0).text.replace(formname, newformname);
                    formname = ReplaceText(formname, "\\%", "");
                }
                else if (typeof (imgColl.item(i).srcorgEmbedImage) != "undefined") {
                    formname = imgColl.item(i).src.substr(imgColl.item(i).src.lastIndexOf("\\") + 1)
                    newformname = ReplaceText(ReplaceText(formname, "\\%", ""), "#", "%23");
                    xmlDoc.getElementsByTagName("HTMLBODY").item(0).text = xmlDoc.getElementsByTagName("HTMLBODY").item(0).text.replace(formname, newformname);
                    formname = ReplaceText(formname, "\\%", "");
                }
                else if (imgColl.item(i).src.substr(0, 7) != document.location.protocol + "//" || imgColl.item(i).src.substr(0, 8) != document.location.protocol + "//") {

                    formname = imgColl.item(i).src.substr(imgColl.item(i).src.lastIndexOf("/") + 1)
                    var fullformname = formname;

                    if (formname.indexOf('.aspx') > -1) {
                        var values = formname.split('&');
                        for (j = 0; j < values.length; j++) {
                            if (values[j].indexOf('ATTID') > -1) {
                                var tmp = values[j].split('=');
                                var tmp1 = tmp.length > 1 ? tmp[1] : formname;
                                var isguid = false;

                                if (tmp1.length == 36 && tmp1.charAt(8) == '-' && tmp1.charAt(13) == '-' && tmp1.charAt(18) == '-' && tmp1.charAt(23) == '-') {
                                    isguid = true;
                                }

                                if (isguid) {
                                    formname = unescape(tmp1).split('@')[0];
                                }
                                else {
                                    formname = unescape(tmp1);
                                }
                                break;
                            }
                        }
                    }
                    newformname = ReplaceText(ReplaceText(formname, "\\%", ""), "#", "%23");
                    xmlDoc.getElementsByTagName("HTMLBODY").item(0).text = xmlDoc.getElementsByTagName("HTMLBODY").item(0).text.replace(fullformname.replace(/&/g, '&amp;'), fullformname); // 20110908
                    xmlDoc.getElementsByTagName("HTMLBODY").item(0).text = xmlDoc.getElementsByTagName("HTMLBODY").item(0).text.replace(formname, newformname);
                    formname = ReplaceText(formname, "\\%", "");
                }
                else {
                    formname = imgColl.item(i).src.substr(imgColl.item(i).src.lastIndexOf("/") + 1)
                }
                formname = ReplaceText(formname, "%25", "");
                MakeXmlNode(xmlDoc, rootNode, "IMAGENAME", formname);
                MakeXmlNode(xmlDoc, rootNode, "IMAGECONTENT", encodedText);
            }
        }
        else if (imgColl.item(i).embedding == undefined && imgColl.item(i).src.indexOf('mode=inlineimage') > -1) {
            var encodedText = GetEncodeText(imgColl.item(i).src);
            var newformname = "";
            formname = imgColl.item(i).src.substr(imgColl.item(i).src.lastIndexOf("/") + 1);
            var fullformname = formname;
            if (formname.indexOf('.aspx') > -1) {
                var values = formname.split('&');
                for (j = 0; j < values.length; j++) {
                    if (values[j].indexOf('ATTID') > -1) {
                        var tmp = values[j].split('=');
                        var tmp1 = tmp.length > 1 ? tmp[1] : formname;
                        var isguid = false;

                        if (tmp1.length == 36 && tmp1.charAt(8) == '-' && tmp1.charAt(13) == '-' && tmp1.charAt(18) == '-' && tmp1.charAt(23) == '-') {
                            isguid = true;
                        }

                        if (isguid) {
                            formname = unescape(tmp1).split('@')[0];
                        }
                        else {
                            formname = unescape(tmp1);
                        }
                        break;
                    }
                }
            }

            newformname = ReplaceText(ReplaceText(formname, "\\%", ""), "#", "%23");
            xmlDoc.getElementsByTagName("HTMLBODY").item(0).text = xmlDoc.getElementsByTagName("HTMLBODY").item(0).text.replace(fullformname.replace(/&/g, '&amp;'), fullformname); // 20110908
            xmlDoc.getElementsByTagName("HTMLBODY").item(0).text = xmlDoc.getElementsByTagName("HTMLBODY").item(0).text.replace(formname, newformname);
            formname = ReplaceText(formname, "\\%", "");
            formname = ReplaceText(formname, "%25", "");
            MakeXmlNode(xmlDoc, rootNode, "IMAGENAME", formname);
            MakeXmlNode(xmlDoc, rootNode, "IMAGECONTENT", encodedText);
        }
    }
    if (BigSizeAttach) {
        var pSrc = document.location.protocol + "//" + g_servername + "/images/email/mail_004.gif";
        var encodedText = GetEncodeText(pSrc);
        if (encodedText.length) {
            formname = pSrc.substr(pSrc.lastIndexOf("/") + 1);
            formname = ReplaceText(formname, "\\%", "");
            MakeXmlNode(xmlDoc, rootNode, "IMAGENAME", formname);
            MakeXmlNode(xmlDoc, rootNode, "IMAGECONTENT", encodedText);
        }
    }
}

function GetEncodeText(filename) {
    if (filename.substr(0, 7).toLowerCase() != document.location.protocol + "//" || filename.substr(0, 8).toLowerCase() != document.location.protocol + "//") {
        filename = ReplaceText(filename, "file:///", "");

        var fileExt = filename.substr(filename.length - 3).toLowerCase();
        var result = false;
        var ezUtil = new ActiveXObject("ezUtil.MiscFunc.1");
        ezUtil.UseUTF8 = true;
        if (fileExt == "bmp" || fileExt == "tmp") {
            var imageGUID = ezUtil.GetGUID();

            var newfilename = filename.substr(0, filename.lastIndexOf("/") + 1) + imageGUID + ".png";
            var imageUtil = new ActiveXObject("ezUtil.ImageFunc");

            result = imageUtil.ConvertImageFormat(filename, newfilename, "image/png");

        }

        if (result == true)
            filename = newfilename;

        var fullpath = filename;
        var encodedText = ezUtil.DownloadToBase64(fullpath);

        if (result == true)
            ezUtil.DeleteFile(filename);
    }
    else {
        var ezUtil = new ActiveXObject("ezUtil.MiscFunc.1");
        ezUtil.UseUTF8 = true;
        var encodedText = ezUtil.DownloadToBase64(filename);
    }
    return encodedText;
}

function Attach_onClick() {
    var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
    ezUtil.UseUTF8 = true;
    var imgName = ezUtil.OpenLoadDlg("Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx;\0All Files (*.*)\0*.*\0\0", "")
    var ezUtil = null;

    if (imgName == "")
        return;

    g_bDirty = true;
    var selPosObj = tbContentElement.editor.DOM.selection;
    if (selPosObj.getAttribute("type").toUpperCase() == "TEXT" || selPosObj.getAttribute("type").toUpperCase() == "NONE") {
        var rgElem = selPosObj.createRange();
        rgElem.pasteHTML("<img src=\"" + imgName + "\" embedding=1>");
    }
}

function important_change() {
    g_bDirty = true;

    if (navigator.userAgent.indexOf("MSIE") != -1) {
        eImportant.value = importantSelect.selectedIndex.toString();
        m_rgParams4PostOption["important"] = eImportant.value;
    }
    else if (navigator.userAgent.indexOf("MSIE") == -1) {
        m_rgParams4PostOption["important"] = importantSelect.selectedIndex.toString();
    }
    m_rgParams4PostOption["important"] = eImportant.value;
}

var letteroption_cross_dialogArguments = new Array();
function Option_onClick() {
    g_bDirty = true;
    letteroption_cross_dialogArguments[0] = m_rgParams4PostOption;
    letteroption_cross_dialogArguments[1] = Option_onClick_Complete;
    letteroption_cross_dialogArguments[2] = DivPopUpHidden;
    DivPopUpShow(410, 375, "/ezEmail/letterOption.do");
}

function Option_onClick_Complete(m_rgParams4PostOption) {
    DivPopUpHidden();
    importantSelect.selectedIndex = parseInt(m_rgParams4PostOption["important"]);
    if (navigator.userAgent.indexOf("MSIE") != -1) {
        eImportant.value = importantSelect.selectedIndex.toString();
    }
    else if (navigator.userAgent.indexOf("MSIE") == -1) {
        m_rgParams4PostOption["important"] = importantSelect.selectedIndex.toString();
    }

    if (m_rgParams4PostOption["delaySendDate"] != "")
        document.all("chkeachmail").disabled = true;
    else
        document.all("chkeachmail").disabled = false;
}
function Subject_ReApply() {
    g_bDirty = true;

    if (document.getElementById("eSubject").value == "")
        document.title = strLang124;
    else
        document.title = document.getElementById("eSubject").value + " -- " + strLang125;
}
var mail_newreceiverchoose_dialogArguments = new Array();
function SelectReceiver_onClick(szDefaultWind) {
    SelectReceiver_Complete.szDefaultWind = szDefaultWind;
    NameCertify_onClick(SelectReceiver_Complete);
}
function SelectReceiver_Complete(ReturnValue) {
    var receiverData = getReceiverChooseFormat();
    receiverData["addReceiver"] = addReceiver;
    receiverData["window"] = this;
    mail_newreceiverchoose_dialogArguments[0] = receiverData;
    mail_newreceiverchoose_dialogArguments[1] = SelectReceiver_onClick_Complete;
    var OpenWin = window.open("/ezEmail/mailNewReceiverChoose.do?defaultwin=" + SelectReceiver_Complete.szDefaultWind, "mail_foldermanage_Cross", GetOpenWindowfeature(970, 655));
    try { OpenWin.focus(); } catch (e) { }
}
function SelectReceiver_onClick_Complete(pListViewMsgTo, pListViewMsgCC, pListViewMsgBCC) {
    try {
        MsgToGot.innerHTML = "";
        MsgCCGot.innerHTML = "";
        MsgBCCGot.innerHTML = "";
        if (pListViewMsgBCC.getElementsByTagName("TR").length > 1) {
            document.getElementById("BccViewer").childNodes.item(1).src = GroupminImg;
            document.getElementById("MsgBCC_TRu").style.display = "";
            document.getElementById("MsgBCC_TR").style.display = "";
            document.getElementById("BccViewer").setAttribute("status", "on");
        }
        addReceiverOneListView(0, pListViewMsgTo);
        addReceiverOneListView(1, pListViewMsgCC);
        addReceiverOneListView(2, pListViewMsgBCC);
    } catch (e) { }
}
function getReceiverChooseFormat() {
    var retVal = new Array();
    retVal["to"] = new Array();
    retVal["cc"] = new Array();
    retVal["bcc"] = new Array();
    getJustOneReceiverChooseFormat(MsgToGot, retVal["to"]);
    getJustOneReceiverChooseFormat(MsgCCGot, retVal["cc"]);
    getJustOneReceiverChooseFormat(MsgBCCGot, retVal["bcc"]);
    return retVal;
}
function getJustOneReceiverChooseFormat(receiverCol, receiver) {
    receiver["type"] = new Array();
    receiver["name"] = new Array();
    receiver["email"] = new Array();
    receiver["href"] = new Array();

    var cnt = 0;
    for (var i = 0; i < receiverCol.childNodes.length; i++) {

        if (receiverCol.childNodes.item(i).nodeType == "1") {

            var childElem = receiverCol.childNodes.item(i).childNodes[0];

            receiver["type"][cnt] = childElem.getAttribute("type");
            receiver["name"][cnt] = childElem.getAttribute("name").replace("&quot", '"');
            receiver["email"][cnt] = childElem.getAttribute("email");
            receiver["href"][cnt] = childElem.getAttribute("href");
            cnt++;
        }
    }
}

function addReceiver(pListViewMsgTo, pListViewMsgCC, pListViewMsgBCC) {
    MsgToGot.innerHTML = "";
    MsgCCGot.innerHTML = "";
    MsgBCCGot.innerHTML = "";
    if (pListViewMsgBCC.getElementsByTagName("TR").length > 1) {
        document.getElementById("BccViewer").childNodes.item(1).src = GroupminImg;
        document.getElementById("MsgBCC_TRu").style.display = "";
        document.getElementById("MsgBCC_TR").style.display = "";
        document.getElementById("BccViewer").setAttribute("status", "on");
    }
    addReceiverOneListView(0, pListViewMsgTo);
    addReceiverOneListView(1, pListViewMsgCC);
    addReceiverOneListView(2, pListViewMsgBCC);
}
function NameChange_onClick() {
    g_bDirty = true;
    var count;
    var length;
    var changedReceiverList;

    rgParams = new Array();
    rgParams["recipientTDData"] = null;
    rgParams["returnedRecipientType"] = "";
    rgParams["returnedRecipientName"] = "";
    rgParams["returnedRecipientEmail"] = "";
    rgParams["returnedRecipientHref"] = "";
    rgParams["g_EditNameDialog"] = "";

    if (this != null) {
        GetMailAddresses(TrimText(ReplaceText(event.target.textContent, ";", "")));
        rgParams["addrBook"] = m_addrBook;
        rgParams["g_DisplayName"] = TrimText(ReplaceText(event.target.textContent, ";", ""));
        rgParams["g_EmailAddress"] = event.target.getAttribute("email");
        rgParams["cmd"] = "JustThis";
        checkname_cross_dialogArguments = new Array();
        checkname_cross_dialogArguments[0] = rgParams;
        checkname_cross_dialogArguments[1] = NameChange_onClick_Complete;
        checkname_cross_dialogArguments[2] = DivPopUpHidden;
        checkname_cross_dialogArguments[3] = event.target.parentElement;
        DivPopUpShow(625, 410, "/ezEmail/mailCheckName.do");
    }
}
function NameChange_onClick_Complete(rgParams) {
    DivPopUpHidden();
    if (rgParams["recipientTDData"] == "dontprocess") return;

    switch (parseInt(checkname_cross_dialogArguments[3].getAttribute("iType"))) {
        case 0:
            changedReceiverList = MsgToGot;
            break;
        case 1:
            changedReceiverList = MsgCCGot;
            break;
        case 2:
            changedReceiverList = MsgBCCGot;
            break;
    }

    if (rgParams["recipientTDData"] == "delete") {
        changedReceiverList.removeChild(checkname_cross_dialogArguments[3].parentElement);
    } else if (rgParams["recipientTDData"] == "change") {
        length = rgParams["returnedRecipientName"].length;
        for (count1 = 0; count1 < length; count1++) {
            newElem = PrepareMailTag(checkname_cross_dialogArguments[3].getAttribute("iType"), rgParams["returnedRecipientType"][count1], rgParams["returnedRecipientName"][count1],
                rgParams["returnedRecipientEmail"][count1], rgParams["returnedRecipientHref"][count1]);

            checkname_cross_dialogArguments[3].parentElement.insertAdjacentElement("afterEnd", newElem);
        }
        changedReceiverList.removeChild(checkname_cross_dialogArguments[3].parentElement);
    }
}
function GetAddrFormat(receiveCol) {
    var i;
    var childElem;

    var retAddr = "";

    for (i = 0; i < receiveCol.childNodes.length; i++) {
        childElem = receiveCol.childNodes.item(i);

        retAddr += "\"" + TrimText(ReplaceText(childElem.getAttribute("name"), ";", "")) + "\"";

        if (childElem.getAttribute("type") != "mailgroup") {
            retAddr += " <" + childElem.getAttribute("email") + "-rightSeperator-kaoni-";
        } else {
            retAddr += " <" + "-rightSeperator-kaoni-";
        }
        retAddr += " -leftSeperator-kaoni-" + childElem.getAttribute("type") + "-rightSeperator-kaoni-";
        retAddr += " -leftSeperator-kaoni-" + childElem.getAttribute("href") + ">";

        if (i < receiveCol.childNodes.length - 1) retAddr += ", "
    }
    return retAddr;
}

function GetAddrFormatForSend(receiveCol) {
    var retAddr = "";

    for (var i = 0; i < receiveCol.childNodes.length; i++) {
        if (receiveCol.childNodes.item(i).childNodes[0].nodeName != "#text") {
            var childElem = receiveCol.childNodes.item(i).childNodes[0];

            switch (childElem.getAttribute("type")) {
                case "email":
                case "contact":
                    retAddr += "\"" + TrimText(ReplaceText(childElem.getAttribute("name").replace('"', "&quot;"), ";", "")) + "\"";
                    retAddr += " <" + childElem.getAttribute("email") + ">";
                    retAddr += ", "
                    break;

                case "mailgroup":
                    retAddr += GetGroupEmail(childElem.getAttribute("href"));
                    break;
            }
        }
    }

    if (ReplaceText(retAddr, " ", "") != "")
        return retAddr.substr(0, retAddr.length - 2);
    else
        return "";
}
function GetAddrFormatEmail(receiveCol, ptype) {
    var retAddr = "";
    var getValue = "";

    for (var i = 0; i < receiveCol.childNodes.length; i++) {
        var childElem = receiveCol.childNodes.item(i);

        if (ptype == "0")
            getValue = childElem.getAttribute("email");
        else
            getValue = childElem.getAttribute("name");


        switch (childElem.getAttribute("type")) {
            case "email":
            case "contact":
                retAddr += getValue
                retAddr += ";"
                break;
        }
    }

    if (ReplaceText(retAddr, " ", "") != "")
        return retAddr
    else
        return "";
}

function GetGroupEmail(pAddressId) {
    var xmlHttp = createXMLHttpRequest();
    try {
        if (pAddressId.indexOf("|!|") > 0) {
            var pItemId = pAddressId.split("|!|")[0];
            var pFolderType = pAddressId.split("|!|")[1];
            var pUrl = "/ezAddress/addressGetGroupEmailList.do?id=" + encodeURIComponent(pItemId) + "&foldertype=" + pFolderType;
            xmlHttp.open("GET", pUrl, false);
            xmlHttp.send("");
        }
        else
            return "";
    } catch (e) {
        xmlHttp = null;
        return "";
    }
    if (xmlHttp.status != 200 || xmlHttp.responseXML.Text == "") {
        xmlHttp = null;
        return "";
    }
    var rtnval = ReplaceText(getNodeText(xmlHttp.responseXML.documentElement), ";", ", ")
    return rtnval + ", ";
}

function PrepareMailTag(iWhich, type, name, email, href) {
    var TopSpan = document.createElement("span");
    var newElem = document.createElement("span");
    if (type == "mailgroup")
        newElem.innerHTML = "<u title=\"" + strLang126 + "\" alt=\"" + strLang126 + "\" >" + name + "</u>; ";
    else
        newElem.innerHTML = "<u title=\"" + email + "\" alt=\"" + email + "\" >" + name + "</u>; ";

    //newElem.innerHTML += "<img src='/images/icon/oneline_delete.gif' onclick='deleteMailUser(\"" + email + "\",\"" + iWhich + "\")' style='width:10px;height:10px;'/> " + "</u>";

    newElem.style.cursor = "pointer";

    if (type == "mailgroup") {
        newElem.style.fontWeight = "bold";
    }

    newElem.setAttribute("iType", iWhich); //newElem.getAttribute("iType") = iWhich;
    newElem.setAttribute("onclick", "NameChange_onClick()");
    newElem.setAttribute("type", type);//newElem.getAttribute("type") = type;
    newElem.setAttribute("name", name);//newElem.getAttribute("name") = name;	
    newElem.setAttribute("email", email);// newElem.getAttribute("email") = email;

    if (type == "mailgroup") {
        newElem.style.color = inMailColor;
    }
    else {
    	var InnerDomainList = InnerDomain.toLowerCase().split(',');
    	
    	for (var i = 0; i < InnerDomainList.length; i++) {
    		InnerDomainList[i] = InnerDomainList[i].trim();
    	}
    	
        if (InnerDomainList.indexOf(email.split('@')[1].toLowerCase()) == -1) 
            newElem.style.color = outMailColor;
        else
            newElem.style.color = inMailColor;
    }

    newElem.setAttribute("href", href);//newElem.getAttribute("href") = href;

    TopSpan.appendChild(newElem);
    TopSpan.innerHTML += "<img src='/images/icon/oneline_delete.gif' onclick='deleteMailUser(\"" + email + "\",\"" + iWhich + "\")' style='width:10px;height:10px;cursor:pointer;'/> " + "</u>";

    return TopSpan;
}

function addReceiverOneListView(iWhich, pListView) {
    var szReceiver;
    var recvName, recvAddr;

    var newElem;

    for (var nCnt1 = 1; nCnt1 < pListView.getElementsByTagName("TR").length; nCnt1++) {
        g_bDirty = true;
        if (pListView.getElementsByTagName("TR")[nCnt1].getAttribute("DATA2") == "mailgroup") {
            newElem = PrepareMailTag(iWhich, "mailgroup",
                    pListView.getElementsByTagName("TR")[nCnt1].getAttribute("DATA1"),
                    pListView.getElementsByTagName("TR")[nCnt1].getAttribute("DATA3"),
                    pListView.getElementsByTagName("TR")[nCnt1].getAttribute("DATA4"));
        }
        else {
            newElem = PrepareMailTag(iWhich, "email",
                    pListView.getElementsByTagName("TR")[nCnt1].getAttribute("DATA1"),
                    pListView.getElementsByTagName("TR")[nCnt1].getAttribute("DATA2"),
                    "");
        }
        switch (iWhich) {
            case 0:
                MsgToGot.appendChild(newElem);
                break;

            case 1:
                MsgCCGot.appendChild(newElem);
                break;

            case 2:
                MsgBCCGot.appendChild(newElem);
                break;
        }
    }
}

function addReceiverFromList(iWhich, receiverlist) {
    var szReceiver;
    var recvName, recvAddr;

    var newElem;

    if (iWhich < 0 || iWhich > 2) return;
    if (typeof (receiverlist) == "undefined") return;

    for (var nCnt1 = 0; nCnt1 < receiverlist["name"].length; nCnt1++) {

        recvType = receiverlist["type"][nCnt1];
        recvName = receiverlist["name"][nCnt1];
        recvEmail = receiverlist["email"][nCnt1];
        recvHref = receiverlist["href"][nCnt1];

        newElem = PrepareMailTag(iWhich, recvType, recvName, recvEmail, recvHref);

        switch (iWhich) {
            case 0:
                if (g_cmd == "replyall" && g_myemail == recvAddr) break;
                MsgToGot.appendChild(newElem);
                break;

            case 1:
                MsgCCGot.appendChild(newElem);
                break;

            case 2:
                MsgBCCGot.appendChild(newElem);
                break;
        }
    }
}

function getEmailAddressList(ReceiverList) {
    var count, count2, count3, length, length2;
    var szType, szName, szEmail, szHref;

    var receivers;
    var receiver;

    var retVal = {
        "type": new Array(),
        "name": new Array(),
        "email": new Array(),
        "href": new Array()
    };


    receivers = ReceiverList.split(">,");
    length = receivers.length;
    //receivers[ length - 1 ] = receivers[ length - 1 ].substr( 0, receivers[ length - 1].length - 1);
    for (count = 0, count3 = 0; count < length; count++) {
        receiver = receivers[count];
        receiver = ReplaceText(receiver, "-leftSeperator-kaoni-", "<");
        receiver = ReplaceText(receiver, "-rightSeperator-kaoni-", ">");
        if (ReplaceText(receiver, " ", "") == "") continue;
        receiverPart = receiver.split(" <");
        var pName = receiverPart[0];
        var pEmail = receiverPart[1].replace("<", "").replace(">", "");


        //length2 = receiverPart.length;		
        if (g_cmd != "EDIT") {
            if (pEmail == g_myemail)
                continue;
        }


        retVal["type"][count3] = "email";
        retVal["name"][count3] = pName.replace("\"", "").replace("\"", "");
        retVal["email"][count3] = pEmail;
        retVal["href"][count3] = "";

        count3++;
    }

    return retVal;
}

function findAddress(emailAddress, addrList) {
    var count;
    var length;
    var srcEmail;
    var destEmail;
    var result = new Array();

    if (typeof (addrList) == "undefined" || addrList == null || typeof (addrList["email"]) == "undefined") return null;

    length = addrList["email"].length;

    srcEmail = emailAddress;
    srcEmail = srcEmail.toUpperCase();

    for (count = 0; count < length; count++) {
        destEmail = addrList["email"][count];
        destEmail = destEmail.toUpperCase();
        if (destEmail == srcEmail) {
            result["type"] = addrList["type"][count];
            result["name"] = addrList["name"][count];
            result["email"] = addrList["email"][count];
            result["href"] = addrList["href"][count];

            return result;
        }
    }

    return null;
}

function isEmailFormat(mailAddr) {
    var splitArr = mailAddr.split("@");
    if (splitArr.length != 2) return false;

    return true;
}

function MakeXmlNode(xmldoc, root, key, value) {
    var childNode = xmldoc.createElement(key);
    try {
        var cDataNode = xmldoc.createCDATASection(String(value));
        childNode.appendChild(cDataNode);
    }
    catch (e) {
        childNode.text = String(value);
    }

    root.appendChild(childNode);
}

function bigMakeXmlNode(xmldoc, root, key, value) {
    var childNode = xmldoc.createElement(key);
    try {
        var cDataNode = xmldoc.createCDATASection(String(value));
        childNode.appendChild(cDataNode);
    }
    catch (e) {
        childNode.text = String(value);
    }
    root.documentElement.appendChild(childNode);
}

function GetEmailAddressByName(addrBook, userName) {
    var count1;
    var count2;
    var count3;
    var srcName;
    var destName;
    var userLength = addrBook["name"].length;
    var srcNameLength;
    var destNameLength;
    var result = {
        "type": new Array(),
        "name": new Array(),
        "email": new Array(),
        "href": new Array()
    };

    for (count1 = 0, count2 = 0; count1 < userLength; count1++) {
        srcName = addrBook["name"][count1].toUpperCase();
        destName = userName.toUpperCase();
        srcName = ReplaceText(srcName, " ", "");
        destName = ReplaceText(destName, " ", "");
        srcNameLength = srcName.length;
        destNameLength = destName.length;

        for (count3 = 0; count3 <= srcNameLength - destNameLength; count3++) {
            var subtedstrName;

            subtedStrName = srcName.substring(count3, count3 + destNameLength);

            if (subtedStrName == destName) {
                result["type"][count2] = addrBook["type"][count1];
                result["name"][count2] = addrBook["name"][count1];
                result["email"][count2] = addrBook["email"][count1];
                result["href"][count2] = addrBook["href"][count1];
                count2++;

                break;
            }
        }
    }
    return result;
}
function TrimEmailText(szStr, pos, TotalCount) {
    szStr = TrimText(szStr);
    if (pos == 0) szStr = szStr.substr(1, szStr.length);
    szStr = szStr.substr(0, szStr.length - 1);
    return szStr;
}

DECMD_SETFONTSIZE = 5045;
OLECMDEXECOPT_DODEFAULT = 0;

var g_originalHTML = "";
function pzFormProc_DocumentComplete() {
    if (g_isFormat) return;

    var MailBodyContent = document.createElement("DIV");
    MailBodyContent.innerHTML = messageBody.getAttribute("mbody");

    var DivCnt = MailBodyContent.getElementsByTagName("DIV").length;
    for (var i = DivCnt; i >= 0; i--) {
        if (MailBodyContent.getElementsByTagName("DIV").item(i) != null) {
            try {
                if (MailBodyContent.getElementsByTagName("DIV").item(i).getAttribute("id") == "ezFormProc_div") {
                    MailBodyContent.getElementsByTagName("DIV").item(i).outerHTML = MailBodyContent.getElementsByTagName("DIV").item(i).innerHTML;
                }
                else if (MailBodyContent.getElementsByTagName("DIV").item(i).getAttribute("id") == "ORGMAIL_CONTENT___send") {
                    MailBodyContent.getElementsByTagName("DIV").item(i).outerHTML = MailBodyContent.getElementsByTagName("DIV").item(i).innerHTML;
                }
                else if (MailBodyContent.getElementsByTagName("DIV").item(i).getAttribute("id") == "msgbody") {
                    MailBodyContent.getElementsByTagName("DIV").item(i).outerHTML = MailBodyContent.getElementsByTagName("DIV").item(i).innerHTML;
                }
            } catch (e) {
            }
        }
    }

    message.SetEditorContent("<div id=msgbody><div>" + messageBody.getAttribute("mbody") + "</div></div>")
    g_originalHTML = message.GetHtmlValue();

    if (eSubject.value != "") {
        message.SetEditorFocus();
    }
    else
        MsgTo.focus();

    var tempDiv = document.createElement("DIV");
    tempDiv.innerHTML = message.GetHtmlValue();
    var DivRows = tempDiv.getElementsByTagName("DIV");
    for (var i = 0; i < DivRows.length; i++) {
        if (DivRows.item(i).id == "MailSign" && DivRows.item(i).childNodes.length > 0) {
            if (DivRows.item(i).childNodes.item(0).nodeName == "DIV") {
                if (DivRows.item(i).childNodes.item(0).id == "kaoni_sign1") {
                    document.getElementById("SelMailSign").selectedIndex = 1;
                    CurrentSing = "1";
                }
                else if (DivRows.item(i).childNodes.item(0).id == "kaoni_sign2") {
                    document.getElementById("SelMailSign").selectedIndex = 2;
                    CurrentSing = "2";
                }
                else if (DivRows.item(i).childNodes.item(0).id == "kaoni_sign1") {
                    document.getElementById("SelMailSign").selectedIndex = 3;
                    CurrentSing = "3";
                }
            }
        }
    }
    tempDiv = null;

}

function pzFormProc_FieldsAvailable() {
    tbContentElement.ShowWorkingDlg("", false);
}

function GetUpmooItemInfo_New(Itemid, DocHref) {
    objMHT = new ActiveXObject("MhtFormat.Convert");
    var fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + encodeURI(DocHref);
    objMHT.sync = true;
    var strMht = objMHT.DownloadURL(fullPath);

    objMHT.mhtData = strMht;
    objMHT.filterIn();

    var htmlData = "<div class='margin' id='ezFormProc_div'>" + objMHT.htmlData + "</div>";

    var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
    var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");

    var objRoot = xmlpara.createNode(1, "PARAMETER", "");
    xmlpara.appendChild(objRoot);

    // 0
    var objNode = xmlpara.createNode(1, "ITEMID", "");
    objNode.text = Itemid;
    xmlpara.documentElement.appendChild(objNode);

    // 1
    objNode = xmlpara.createNode(1, "COMPANYID", "");
    objNode.text = g_companyID;
    xmlpara.documentElement.appendChild(objNode);



    xmlHTTP.open("Post", "/myoffice/ezReport/remote/Call_View.aspx", false);
    xmlHTTP.send(xmlpara);

    try {
        if (xmlHTTP.status == 200) {
            var Resultxml = loadXMLString(xmlHTTP.responseText);
            eSubject.value = Resultxml.selectSingleNode("DATA/ROW/TITLE").text;
            var PostDate = Resultxml.selectSingleNode("DATA/ROW/POSTDATE").text;
            var Sender = "";

            if (isPrimary == "1") {
                Sender = Resultxml.selectSingleNode("DATA/ROW/USERNM").text + " (" +
                        Resultxml.selectSingleNode("DATA/ROW/USERDEPTNM").text + ", " +
                        Resultxml.selectSingleNode("DATA/ROW/USERJOBTITLE").text + ")";
            }
            else {
                Sender = Resultxml.selectSingleNode("DATA/ROW/USERNM2").text + " (" +
                        Resultxml.selectSingleNode("DATA/ROW/USERDEPTNM2").text + ", " +
                        Resultxml.selectSingleNode("DATA/ROW/USERJOBTITLE2").text + ")";
            }

            if (Resultxml.selectSingleNode("DATA/ROW/HASATTACH").text == "1") {
                getReportAttachList(Itemid);
            }

            htmlData = htmlData.substr(htmlData.indexOf("<BODY"));
            htmlData = ReplaceText(htmlData, "<P ", "<DIV ");
            htmlData = ReplaceText(htmlData, "/P>", "/DIV>");
            htmlData = ReplaceText(htmlData, "<P>", "<DIV>");
            htmlData = ReplaceText(htmlData, "</P>", "</DIV>");

            messageBody.mbody = "<DIV style='LINE-HEIGHT: 15pt' ><br /><br /><DIV id='MailSign'></div><br /></DIV>" + "<br><br><hr></hr><B>" + strLang118 + "</B>" + PostDate + "<br><B>" + strLang119 + "</B>" + Sender + "<br><B>" + strLang120 + "</B>" + eSubject.value + "<br><br>" + htmlData;
            eSubject.value = strLang121 + eSubject.value;
            Subject_ReApply();
        }

        xmlhttp = null;
        xmlpara = null;
    }
    catch (e) {
        alert("GetReportItemInfo :: " + e.description);
    }
}
function getReportAttachList(ItemNo) {
    try {

        var objRoot;
        var objNode;

        var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
        var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");

        objRoot = xmlpara.createNode(1, "PARAMETER", "");
        xmlpara.appendChild(objRoot);

        objNode = xmlpara.createNode(1, "pItemID", "");
        objNode.text = ItemNo;
        xmlpara.documentElement.appendChild(objNode);

        objNode = xmlpara.createNode(1, "pCompanyID", "");
        objNode.text = g_companyID;
        xmlpara.documentElement.appendChild(objNode);

        xmlhttp.open("Post", "/myoffice/ezReport/remote/Call_ItemAttachList.aspx", false);
        xmlhttp.send(xmlpara);

        var Resultxml = xmlhttp.responseXML;
        objRoot = Resultxml.documentElement;

        if (objRoot != null) {
            var ret = Resultxml.xml;
            AppendFileAttachInfo(ret);
        }

    } catch (e) {
        alert("getReportAttachList :: " + e.description);
    }
}

function ForwardAttachOCX(forfilelist) {
    var arrFiles = forfilelist.split("_AttachLine_");
    for (var i = 0; i < arrFiles.length - 1 ; i++) {
        var filename = arrFiles[i].split("|")[0]
        var filePath = arrFiles[i].split("|")[1]
        var fileSize = arrFiles[i].split("|")[2]
        filePath = document.location.protocol + "//" + document.location.hostname + "/myoffice/ezEmail/" + filePath;
        EzHTTPTrans.InsertFileList(filename, filePath, "N", "N", fileSize);
    }
}

function ImageUrl(pUrl, cnt) {
    var link = "/myoffice/Common/ImgFileRead.asp?PUrl=" + pUrl + "&Cnt=" + cnt;

    return link;
}

function Set_sendflag() {
    try {
        var setValue;
        if (gg_cmd.toLowerCase() == "forward") setValue = "fwd";
        if (gg_cmd.toLowerCase() == "reply") setValue = "reply";
        if (gg_cmd.toLowerCase() == "replyall") setValue = "replyall";

        if (!setValue)
            return false;

        var strQuery = '<?xml version="1.0" encoding="utf-8" ?>';
        strQuery += '<a:propertyupdate xmlns:a="DAV:" xmlns:c="urn:schemas:httpmail:">';
        strQuery += '<a:set><a:prop>';
        strQuery += '<c:mflag>' + setValue + '</c:mflag>';
        strQuery += '</></></>';

        var xmlHTTP = new ActiveXObject("Microsoft.XMLHttp");
        var statusVal;
        xmlHTTP.open("PROPPATCH", gg_url, false);
        xmlHTTP.setRequestHeader("Content-type:", "text/xml");
        xmlHTTP.send(strQuery);
        statusVal = 207;
    } catch (e) {
        alert(e.description);
    }
}

function deleteMailUser(email, iWhich) {

    if(!CrossYN())
        window.event.cancelBubble = true;

    switch (iWhich) {
        case "0":
            for (var i = 0; i < MsgToGot.children.length; i++) {
                if (GetChildNodes(MsgToGot)[i].innerHTML.indexOf(email) > -1) {
                    break;
                }
            }
            MsgToGot.removeChild(GetChildNodes(MsgToGot)[i]);
            break;

        case "1":
            for (var j = 0; j < MsgCCGot.children.length; j++) {
                if (GetChildNodes(MsgCCGot)[j].innerHTML.indexOf(email) > -1) {
                    break;
                }
            }
            MsgCCGot.removeChild(GetChildNodes(MsgCCGot)[j]);
            break;

        case "2":
            for (var k = 0; k < MsgBCCGot.children.length; k++) {
                if (GetChildNodes(MsgBCCGot)[k].innerHTML.indexOf(email) > -1) {
                    break;
                }
            }
            MsgBCCGot.removeChild(GetChildNodes(MsgBCCGot)[k]);
            break;
    }
}