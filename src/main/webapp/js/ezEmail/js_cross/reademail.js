

var m_bPrevNext = false;

function get_mail(flag) {
    var Flag;

    if (null != opener) {
        m_bPrevNext = true;
    }
    if (m_bPrevNext) {

        try {
            if (flag == "prev") {
                var Rtn = opener.PopUpPreMail();
                if (Rtn == "PREEND") {
                    alert(strLang184);
                }
                else if (Rtn == "PREMOVE") {
                    alert(strLang305);
                    window.close();
                }
                else {
                    window.close();
//                    opener.ReadMailOpenNewWin.focus();
                }
            }
            else {
                var Rtn = opener.PopUpNextMail();
                if (Rtn == "NEXTEND") {
                    alert(strLang185);
                }
                else if (Rtn == "NEXTMOVE") {
                    alert(strLang306);
                    window.close();
                }
                else {
                    window.close();
//                    opener.ReadMailOpenNewWin.focus();
                }
            }
        }
        catch (e) {
            alert(e.description);
            self.close();
        }
        m_bPrevNext = false;
    }

}
function ReSend(pURL, pEmail) {
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - 890) / 2;
    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
    
    window.open("/ezEmail/mailWrite.do?url=" + encodeURIComponent(pURL) + "&cmd=RESEND&msgto=" + encodeURI(pEmail), "", feature);
    /*if (CrossYN() || pNoneActiveX == "YES") {
        window.open("mail_write_Cross.aspx?url=" + encodeURIComponent(pURL) + "&cmd=RESEND&msgto=" + pEmail, "", feature);
    }
    else {
        if (pUse_Editor == "")
            window.open("mail_write_Cross.aspx?url=" + encodeURIComponent(pURL) + "&cmd=RESEND&msgto=" + pEmail, "", feature);
        else
            window.open("mail_write_Cross.aspx?url=" + encodeURIComponent(pURL) + "&cmd=RESEND&msgto=" + pEmail, "", feature);
    }*/
}

function encoding_mail() {
    try {
        var infolder = "/exchange/" + CutBeforeText(g_paramURL, "/exchange/");
        var strQuery = "<DATA><URL>" + infolder + "</URL><AUTHOR>" + g_author + "</AUTHOR></DATA>"

        var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
        xmlHTTP.open("POST", "remote/mail_interencode.aspx", false);
        xmlHTTP.setRequestHeader("content-type:", "text/xml");
        xmlHTTP.send(strQuery);

        var strRetUrl = xmlHTTP.responseXML.text;
        xmlHTTP = null;

        if (strRetUrl != "") {
            try {
                window.opener.MailListRefresh();
            }
            catch (e) { }

            if (strRetUrl.substr(0, 5) != "ERROR") {
                document.location.href = "/myoffice/ezEmail/mail_read.aspx?URL=" + encodeURIComponent(strRetUrl);
            }
        }
    }
    catch (e) { }
}

function reply_onClick() {
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - 890) / 2;

    window.location.href = "/ezEmail/mailWrite.do?URL=" + encodeURIComponent(g_paramURL) + "&cmd=REPLY";        
}

function allreply_onClick() {
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - 890) / 2;
    
    window.location.href = "/ezEmail/mailWrite.do?URL=" + encodeURIComponent(g_paramURL) + "&cmd=REPLYALL";
}

function pass_onClick() {
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - 890) / 2;
    
    window.location.href = "/ezEmail/mailWrite.do?URL=" + encodeURIComponent(g_paramURL) + "&cmd=FORWARD";
}
var mail_movecopy_cross_dialogArguments = new Array();
function move_onClick() {
    mail_movecopy_cross_dialogArguments[1] = move_onclick_Complete;
    mail_movecopy_cross_dialogArguments[2] = DivPopUpHidden;
    DivPopUpShow(320, 375, "/ezEmail/mailMoveCopy.do");
}
function move_onclick_Complete(moveUrl) {
    DivPopUpHidden();
    if (typeof (moveUrl) == "undefined")
        return;

    var szOrgURL = g_paramURL;

    if (moveUrl["cmd"] == "MOVE")
        CopyOrMoveMail(moveUrl["cmd"], g_paramURL, moveUrl["url"]);
    else if (moveUrl["cmd"] == "COPY")
        CopyOrMoveMail(moveUrl["cmd"], g_paramURL, moveUrl["url"]);

    usedMoveDel = "1";
}
var g_deleteHttp = null;
function delete_mail_2010(cmd, copyFolderID) {
    try {
        g_deleteHttp = createXMLHttpRequest();
        var xmlDOM = createXmlDom();

        var objNode;
        createNodeInsert(xmlDOM, objNode, "DATA");
        createNodeAndInsertText(xmlDOM, objNode, "CMD", cmd);
        createNodeAndInsertText(xmlDOM, objNode, "UNIQUEID", g_paramURL);
        createNodeAndInsertText(xmlDOM, objNode, "FOLDERID", copyFolderID);

        objRoot.appendChild(objNode3);

        g_deleteHttp.open("POST", "/myoffice/ezEmail/remote/mail_movecopy.aspx", true);
        g_deleteHttp.onreadystatechange = event_deletemail_end;
        g_deleteHttp.send(xmlDOM);

    }
    catch (e) {
        g_deleteHttp = null;
        if (cmd == "COPY")
            alert(strLang52);
        else if (cmd == "MOVE")
            alert(strLang5);
        else if (cmd == "BDELETE" || cmd == "BMOVE")
            alert(strLang6);
    }

}
function delete_mail() {
    if (!confirm(strLang59))
        return;

    if (g_deleteHttp != null)
        return;
    try {

        g_deleteHttp = createXMLHttpRequest();
        var xmlDOM = createXmlDom();

        var objNode;
        createNodeInsert(xmlDOM, objNode, "DATA");
        createNodeAndInsertText(xmlDOM, objNode, "CMD", pisDelete);
        createNodeAndInsertText(xmlDOM, objNode, "UNIQUEID", g_paramURL);
        createNodeAndInsertText(xmlDOM, objNode, "FOLDERID", "");

        g_deleteHttp.open("POST", "/ezEmail/mailDelete.do?cmd=" + pisDelete, true);
        g_deleteHttp.onreadystatechange = event_deletemail_end;
        g_deleteHttp.send(xmlDOM);

    }
    catch (e) {

    }


}

function event_deletemail() {
    if (g_deleteHttp != null && g_deleteHttp.readyState == 4) {
        if (g_deleteHttp.status < 200 || g_deleteHttp.status > 300) {
            g_deleteHttp = null;
            alert(strLang131);
        }
        else {
            try {
                var DestURL = g_deleteHttp.responseXML.getElementsByTagName("d:deleteditems").item(0).text
                var paramURL = CutBeforeText(g_paramURL, g_userID);
                paramURL = CutAfterText(paramURL, "/");

                g_deleteHttp = null;
                g_deleteHttp = new ActiveXObject("Microsoft.XMLHttp");

                if (paramURL == CutBeforeText(DestURL, g_userID)) {
                    g_deleteHttp.open("DELETE", g_paramURL, true);
                    g_deleteHttp.setRequestHeader("Content-Length:", "0");
                    g_deleteHttp.onreadystatechange = event_deletemail_end;
                    g_deleteHttp.send("");
                }
                else {
                    g_deleteHttp.open("MOVE", g_paramURL, true);
                    g_deleteHttp.setRequestHeader("Destination", DestURL + "/delete.eml");
                    g_deleteHttp.setRequestHeader("Content-Length:", "0");
                    g_deleteHttp.setRequestHeader("Translate:", "f");
                    g_deleteHttp.setRequestHeader("allow-rename:", "t");
                    g_deleteHttp.setRequestHeader("Overwrite:", "f");
                    g_deleteHttp.onreadystatechange = event_deletemail_end;
                    g_deleteHttp.send("");
                }
            }
            catch (e) {
                g_deleteHttp = null;
                alert(strLang131);
            }
        }
    }
}

function event_deletemail_end() {
    if (g_deleteHttp != null && g_deleteHttp.readyState == 4) {
        if (g_deleteHttp.status < 200 || g_deleteHttp.status > 300) {
            g_deleteHttp = null;
            alert(strLang131);
        }
        else {
            g_deleteHttp = null;
            window.close();
            try {
                window.opener.MailListRefresh();
            } catch (e) { }
        }

    }
}

var g_copyItemHttp = null;
function CopyOrMoveMail(cmd, itemIDs, copyFolderID) {
    if (g_copyItemHttp != null)
        return;

    try {

        g_copyItemHttp = createXMLHttpRequest();

        var xmlDOM = createXmlDom();

        var objNode;
        createNodeInsert(xmlDOM, objNode, "DATA");
        createNodeAndInsertText(xmlDOM, objNode, "CMD", cmd);
        createNodeAndInsertText(xmlDOM, objNode, "UNIQUEID", itemIDs);
        createNodeAndInsertText(xmlDOM, objNode, "FOLDERID", copyFolderID);

        g_copyItemHttp.open("POST", "/ezEmail/mailMoveCopyMessage.do", true);
        event_CopyOrMoveMail.cmd = cmd;
        g_copyItemHttp.onreadystatechange = event_CopyOrMoveMail;
        g_copyItemHttp.send(xmlDOM);

    }
    catch (e) {
        g_copyItemHttp = null;
        if (cmd == "COPY")
            alert(strLang52);
        else if (cmd == "MOVE")
            alert(strLang5);
        else if (cmd == "BDELETE")
            alert(strLang6);
    }
}


function event_CopyOrMoveMail() {
    if (g_copyItemHttp != null && g_copyItemHttp.readyState == 4) {
        if (g_copyItemHttp.status < 200 && g_copyItemHttp.status > 300) {
            if (event_CopyOrMoveMail.cmd == "MOVE")
                alert(strLang132);
            else {
                if (g_copyItemHttp.responseText == "FULL") {
                    alert(strLang241);
                }
                else {
                    alert(strLang52);
                }
            }
            g_copyItemHttp = null;
        }
        else {
            if (event_CopyOrMoveMail.cmd == "MOVE") {
                alert(strLangLHM06);
                window.close();
                try {
                    window.opener.MailListRefresh();
                } catch (e) { }
            }
            else {
                if (g_copyItemHttp.responseText == "FULL") {
                    alert(strLang241);
                }
                else {
                    alert(strLang53);
                }
            }
            g_copyItemHttp = null;
        }
    }
}

function download_mail() {
    fileName = mailSubject.innerText;
    fileName = ReplaceText(fileName, "\\\\", "");
    fileName = ReplaceText(fileName, "/", "");
    fileName = ReplaceText(fileName, ":", "_");
    fileName = ReplaceText(fileName, "\\*", "");
    fileName = ReplaceText(fileName, "\\?", "");
    fileName = ReplaceText(fileName, "\"", "");
    fileName = ReplaceText(fileName, "<", "");
    fileName = ReplaceText(fileName, ">", "");
    fileName = ReplaceText(fileName, "\\|", "");
    fileName = ReplaceText(fileName, "\\.", "");

    if (fileName.length > 30)
        fileName = fileName.substr(0, 30);

    fileName = fileName + ".eml";

    if (ReplaceText(fileName, " ", "") == ".eml") fileName = "untitled.eml"
    if (!CrossYN() && pNoneActiveX != "YES") {
        var ezUtil_regData = new ActiveXObject("ezUtil.RegScript");
        var regData = ezUtil_regData.ReadValueEx(2, "SYSTEM\\CurrentControlSet\\Control\\Nls\\CodePage", "OEMCP");
        ezUtil_regData = null;

        form1.iptURL.value = g_paramURL;
        var newwin = window.open("", "download", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = 660px, width = 760px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
        form1.action = "remote/mail_readattach.aspx?filename=" + ReplaceText(encodeURI(fileName), "\\+", "%2B") + "&regData=" + regData;
        form1.target = "download";
        form1.submit();
    }
    else {
        var regData = navigator.systemLanguage
        form1.iptURL.value = g_paramURL;
        form1.action = "remote/mail_readattach.aspx?filename=" + ReplaceText(encodeURI(fileName), "\\+", "%2B") + "&regData=" + regData;
        form1.target = "_self";
        form1.submit();
    }
}
var address_foldermanage_dialogArguments = new Array();
function func_addaddr(stype) {
    var ret;
    address_foldermanage_dialogArguments[1] = timedCall_func_addaddr_Complete;
    address_foldermanage_dialogArguments[3] = stype;
    DivPopUpShow(450, 500, "/ezAddress/addressFolderManage.do?mode=Show");
}

function timedCall_func_addaddr_Complete(ret) {
	setTimeout(function() {
		func_addaddr_Complete(ret);
	}, 1000);
}

function func_addaddr_Complete(ret) {
    try {
        DivPopUpHidden();
        if (ret == "0" || ret == "1") {
            return;
        }
        var type = ret.split(':')[0];
        var folderID = ret.split(':')[1];

        var xmlHTTP = createXMLHttpRequest();

        try {
            senderName = TrimText(ConvertCharToEntityReference(LabelFromName.textContent));
            senderEmail = TrimText(ConvertCharToEntityReference(g_fromEmail));
            
            var xmlDom = createXmlDom();
            
            var objNode, objRow;
            objNode = createNodeInsert(xmlDom, objNode, "DATA");
            createNodeAndInsertText(xmlDom, objNode, "FOLDERID", folderID);
            createNodeAndInsertText(xmlDom, objNode, "TYPE", type);
            createNodeAndInsertText(xmlDom, objNode, "OWNERID", "");
            createNodeAndInsertText(xmlDom, objNode, "ADDRESSID", "");
            createNodeAndInsertText(xmlDom, objNode, "CHANGEKEY", "");
            createNodeAndInsertText(xmlDom, objNode, "PHOTOPATH", "");
            createNodeAndInsertText(xmlDom, objNode, "SNAME", senderName);
            createNodeAndInsertText(xmlDom, objNode, "SCOMPANY", "");
            createNodeAndInsertText(xmlDom, objNode, "SDEPT", "");
            createNodeAndInsertText(xmlDom, objNode, "STITLE", "");
            createNodeAndInsertText(xmlDom, objNode, "SCOMPANYPHONE", "");
            createNodeAndInsertText(xmlDom, objNode, "SMOBILE", "");
            createNodeAndInsertText(xmlDom, objNode, "SFAX", "");
            createNodeAndInsertText(xmlDom, objNode, "SEMAIL", senderEmail);
            createNodeAndInsertText(xmlDom, objNode, "SHOMEPAGE", "");
            createNodeAndInsertText(xmlDom, objNode, "SCOMPANYZIP", "");
            createNodeAndInsertText(xmlDom, objNode, "SCOMPANYADDR", "");
            createNodeAndInsertText(xmlDom, objNode, "SCOMPANYADDR", "");
            createNodeAndInsertText(xmlDom, objNode, "SHOMEZIP", "");
            createNodeAndInsertText(xmlDom, objNode, "SHOMEADDR", "");
            createNodeAndInsertText(xmlDom, objNode, "SMEMO", "");
            createNodeAndInsertText(xmlDom, objNode, "STYPE", "P");
            createNodeAndInsertText(xmlDom, objNode, "USERNM", "");
            createNodeAndInsertText(xmlDom, objNode, "USERNM2", "");
            objRow = createNodeAndAppandNode(xmlDom, objNode, objRow, "ATTACHLIST");
            
            xmlHTTP.open("POST", "/ezAddress/addressSave.do", false);
            xmlHTTP.send(xmlDom);
        }
        catch (e) {
            xmlHTTP = null;
            alert(strLang133 + e.description);
            return;
        }
        
        if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
            if (xmlHTTP.status != 200) {
            	alert(strLang133 + xmlHTTP.statusText);
            }
            else if (xmlHTTP.responseText == "PRE") {
                alert(strLang134);
                return;
            }
            else if (xmlHTTP.responseText == "NO_AUTHORITY") {
            	alert(strLangLHM02);
            }
            else {
            	alert(strLang135);
            }
        }
        else {
        	alert(strLang136);
        }

        xmlHTTP = null;
    } catch (e) { }
}
var denial_cross_dialogArguments = new Array();
function func_reject() {
    if (g_fromEmail == "" && g_rejectWord == "") {
        alert(strLang137);
        return;
    }
    var params = new Array();
    params["email"] = new Array();
    params["link"] = new Array();
    if (document.getElementById('LabelFromName').textContent != g_fromEmail) {
        params["email"][0] = document.getElementById('LabelFromName').textContent + " <" + g_fromEmail + ">";
    }
    else {
        params["email"][0] = g_fromEmail;
    }
    params["link"][0] = g_rejectWord;

    denial_cross_dialogArguments[0] = params;
    denial_cross_dialogArguments[1] = func_reject_Complete;
    DivPopUpShow(335, 314, "/ezEmail/mailDenial.do");
}
function func_reject_Complete(retVal) {
    try {
        DivPopUpHidden();
        if (typeof (retVal) == "string") {
            if (retVal == "cancel")
                return;
        }
        var objXml = new DOMParser().parseFromString('<DATA></DATA>', "text/xml");
        var objRoot = objXml.documentElement;



        for (var i = 0 ; i < retVal.length ; i++) {
            var objRow = objXml.createElement("ROW");
            objRoot.appendChild(objRow);

            var objNode = objXml.createElement("DENIAL");
            objNode.appendChild(objXml.createCDATASection(retVal[i]));
            objRow.appendChild(objNode);
        }

        var xmlHTTP = new XMLHttpRequest();

        xmlHTTP.open("POST", "/ezEmail/mailRequestDenial.do", false);
        xmlHTTP.setRequestHeader("Content-Type", "text/xml");
        xmlHTTP.send(objXml);
        var result = xmlHTTP.responseText;

        result = replaceAll(result, "<DATA><![CDATA[", "");
        result = replaceAll(result, "]]></DATA>", "");

        if (result == 'OK') {
            alert(strLang61);
        }
        else if (result == "DOMAINERROR")
            alert(strLang352);
        else {
            alert(strLang138);
        }
        xmlHTTP = null;
    } catch (e) {}
}
function replaceAll(pStrContent, pStrOrg, pStrRep) {
    return pStrContent.split(pStrOrg).join(pStrRep);
}
function write_mail(userinfo) {
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - 890) / 2;
    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1";

    if (pUse_Editor == "")
        window.open('mail_write_Cross.aspx' + "?MsgTo=" + userinfo + '&cmd=NEW', "", feature);
    else
        window.open('mail_write_Cross.aspx' + "?MsgTo=" + userinfo + '&cmd=NEW', "", feature);

    window.close();
}
function receiveCheck_onClick() {
    var OpenWin = window.open("/ezEmail/mailReaderList.do?url=" + encodeURIComponent(g_paramURL), "mail_readerlist", GetOpenWindowfeature(620, 500));
    try { OpenWin.focus(); } catch (e) { }
}
function view_original() {

    if (navigator.appVersion.indexOf("MSIE 6") > -1) {
        MM_openBrWindow('/ezEmail/mailReadOriginal.do?url=' + encodeURIComponent(g_paramURL), 800, 660);
    }
    else {
        MM_openBrWindow('/ezEmail/mailReadOriginal.do?url=' + encodeURIComponent(g_paramURL), 850, 650);
    }
}
function MM_openBrWindow(url, w, h) {
    var pheight = window.screen.availHeight;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - h) / 2;
    var pLeft = (pwidth - w) / 2;

    var opwin = window.open(url, "oWin"
      , "width=" + w + ",height=" + h + ",status=no,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,location=no,top=" + pTop + ",left = " + pLeft);
}


var flagXmlHttp;
function toggle_flag() {
    var now = new Date();
    now.setDate(now.getDate() + 1);

    var month = parseInt(now.getMonth()) + 1;
    var pSDate = now.getFullYear() + "-" + month + "-" + now.getDate();
    var pEDate = pSDate;


    flagXmlHttp = createXMLHttpRequest();
    var xmlDom = createXmlDom();


    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "ITEMID", g_paramURL);
    createNodeAndInsertText(xmlDom, objNode, "STARTDATE", pSDate);
    createNodeAndInsertText(xmlDom, objNode, "ENDDATE", pEDate);

    try {
        flagXmlHttp.open("POST", "/ezEmail/mailSetFlag.do", true);
        flagXmlHttp.onreadystatechange = event_toggle_flag_end;
        flagXmlHttp.send(xmlDom);
    }
    catch (e) { }
}
function event_toggle_flag_end() {
    if (flagXmlHttp != null && flagXmlHttp.readyState == 4) {
        if (flagXmlHttp.status < 200 || flagXmlHttp.status > 300) {
            flagXmlHttp = null;
            alert("ERROR");
        }
        else {
            if (flagXmlHttp.responseText == "NEW")
                alert(strLang139);
            else if (flagXmlHttp.responseText == "DEL")
                alert(strLang140);
            else
                alert("ERROR");

            window.opener.MailListRefresh();
        }
    }
}
function show_senderprofile() {
    if (g_notiSSO == "1")
        return;

    var feature = "height=500px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
    feature = feature + GetOpenPosition(420, 500);
    window.open("/ezCommon/showPersonInfo.do?email=" + g_fromEmail, "", feature);
}
function show_personinfo(email) {
    if (g_notiSSO == "1")
        return;

    var feature = "height=500px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
    feature = feature + GetOpenPosition(420, 500);
    window.open("/ezCommon/showPersonInfo.do?email=" + encodeURI(email), "", feature);
}
function attach_SelectAll() {
    if (CrossYN()) {
        var checks = attachedfileDIV.getElementsByTagName("input");
        for (var i = 0; i < checks.length; i++)
            checks.item(i).checked = true;
    }
    else {
        var checks = attachedfileDIV.all.tags("input");
        for (var i = 0; i < checks.length; i++)
            checks.item(i).checked = true;
    }
}
function attach_Download() {
    var param = { "href": new Array(), "filesize": new Array(), "name": new Array(), "folderpath": new String() };
    var count = 0;
    var checks;

    if (CrossYN()) {
        checks = attachedfileDIV.getElementsByTagName("input");

        for (var i = 0; i < checks.length; i++) {
            if (checks.item(i).checked == true) {
                param["href"][count] = GetAttribute(checks.item(i), "filehref");
                param["filesize"][count] = GetAttribute(checks.item(i), "filesize");
                param["name"][count] = GetAttribute(checks.item(i), "filename");
                count++;
            }
        }
    }
    else {
        checks = attachedfileDIV.all.tags("input");

        for (var i = 0; i < checks.length; i++) {
            if (checks.item(i).checked == true) {
                param["href"][count] = checks.item(i).filehref;
                param["filesize"][count] = checks.item(i).filesize;
                param["name"][count] = checks.item(i).filename;
                count++;
            }
        }
    }


    if (count == 0) {
        alert(strLang141);
        return;
    }

    downloadAll(checks);


}
var suffix = 0;
function downloadAll(checks) {
    if (checks.item(suffix)) {
        if (checks.item(suffix).checked) {

            location.href = GetAttribute(checks.item(suffix++), "filehref");
            setTimeout(function () { downloadAll(checks) }, 1000);
        }
        else {
            suffix++;
            downloadAll(checks);
        }
    }
    else
        suffix = 0;
}
function attach_Delete() {
    var count = 0;
    var param = new Array();

    var xml = "<FILE>";

    if (CrossYN()) {
        var checks = attachedfileDIV.getElementsByTagName("input");

        for (var i = 0; i < checks.length; i++) {
            if (checks.item(i).checked == true) {
                xml += "<ROW>";
                xml += "<NAME><![CDATA[" + GetAttribute(checks.item(i), "fileid") + "]]></NAME>";
                xml += "</ROW>";
                param[count] = i;
                count++;

            }
        }
    }
    else {
        var checks = attachedfileDIV.all.tags("input");

        for (var i = 0; i < checks.length; i++) {
            if (checks.item(i).checked == true) {
                xml += "<ROW>";
                xml += "<NAME><![CDATA[" + checks.item(i).fileid + "]]></NAME>";
                xml += "</ROW>";
                param[count] = i;
                count++;

            }
        }
    }

    if (count == 0) {
        alert(strLang90);
        return;
    }

    xml += "<ITEMID><![CDATA[" + g_paramURL + "]]></ITEMID></FILE>";

    xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "/myoffice/ezEmail/remote/mail_del_interattach.aspx", false);
    xmlhttp.send(xml);

    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
        var oRoot = xmlhttp.responseXML.documentElement;
        var ret = oRoot.childNodes[0].nodeValue;

        if (ret != "FAIL") {
            g_paramURL = ret;
            for (i = 0; i < count; i++) {
                var delindex = param[i] - i;
                checks.item(delindex).parentElement.outerHTML = "";
                if (checks.item(delindex) != null && typeof (checks.item(delindex).parentElement) != "undefined") {
                    if (typeof (checks.item(delindex).parentElement.parentElement) != "undefined") {
                        if (checks.item(delindex).parentElement.parentElement.childNodes[delindex].nodeName == "BR") {
                            checks.item(delindex).parentElement.parentElement.childNodes[delindex].outerHTML = "";
                        }
                    }
                }
            }
        }
        else {
            alert(strLang183);
        }
    }
}

var g_xmlHttp;

// 메일 회수 선택
function cancel_send() {
   
    if (!confirm(strLang143))
        return;

    var xmlDom = createXmlDom();
    g_xmlHttp = createXMLHttpRequest();

    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "URL", g_paramURL);

    g_xmlHttp.open("POST", "remote/mail_cancelsend.aspx", false);
    g_xmlHttp.onreadystatechange = mail_cancelsend_after;
    g_xmlHttp.send(xmlDom);

}
function mail_cancelsend_after() {
    if (g_xmlHttp != null && g_xmlHttp.readyState == 4) {
        var szStatus = g_xmlHttp.status;
        switch (szStatus) {
            case 200:
                if (g_xmlHttp.responseText == "OK")
                    alert(strLang146);
                else if (g_xmlHttp.responseText.indexOf("RE:") > -1) {
                    if (confirm(strLang261)) {
                        var splitNum = g_xmlHttp.responseText.split(':')[1];

                        view_recallMessageReport(splitNum)
                    }
                }
                else {
                    alert(g_xmlHttp.responseText)
                }
                break;
        }
    }
}
function view_recallMessageReport(pnum) {
    var feature = "height=320,width=730,resizable=yes,scrollbars=no";
    feature = feature + GetOpenPosition(730, 320);
    window.open("/myoffice/ezemail/htm/cancelMessageReport_cross.aspx?num=" + pnum, '', feature);

}
function post_mail() {
    openwindow("/myoffice/ezBoard/gwBoard_Post_ITem.aspx?Mod=New&pbrdGbn=SiteNewBoard&pFromScreen=list&url=" + encodeURIComponent(g_paramURL), "", 880, 550);
    window.close();
}
function post_mail_New() {
    var feature = "height=720,width=765,resizable=yes,scrollbars=no";
    feature = feature + GetOpenPosition(765, 720);
    if (CrossYN() || pNoneActiveX == "YES")
        window.open("/myoffice/ezBoardSTD/NewBoardItem_Cross.aspx?url=" + encodeURIComponent(g_paramURL), '', feature);
    else {
        if (pUse_Editor == "")
            window.open("/myoffice/ezBoardSTD/NewBoardItem.aspx?url=" + encodeURIComponent(g_paramURL), '', feature);
        else
            window.open("/myoffice/ezBoardSTD/NewBoardItem_IE.aspx?url=" + encodeURIComponent(g_paramURL), '', feature);
    }

    window.close();
}
function Item_View(vItem, pCItemID, vWriter, pBrdid, vGbnBoard, pBrdnm, brd_Gubun) {
    var pcurpage = "1", pBrdMod = "WorkBoard", pDeptBoardYN = "N", pAdminFg = "0"

    var rep = new RegExp("&", "gi");
    Brdnm = pBrdnm.replace(rep, "chr(38)");

    pURL = "/Myoffice/ezboard/gwBoard_Get_View.aspx?BoardID=" + pBrdid + "&ItemID=" + vItem + "&GoTopage=" + pcurpage + "&Brd_mod=" + pBrdMod + "&Brdnm=" + Brdnm + "&CItemID=" + pCItemID;
    pURL = pURL + "&WUserID=" + vWriter + "&DeptBoardYN=" + pDeptBoardYN + "&AdminFg=" + pAdminFg + "&pGbnBoard=" + vGbnBoard + "&pbrdGubun=" + brd_Gubun;

    var openLocation = pURL;
    openwindow(openLocation, "", 880, 550);
}
function Item_View_New(pBoardID, pItemID, pBoardType) {
    if (pBoardType == "3" || pBoardType == "4") {
        var pheight = window.screen.availHeight;
        var pwidth = window.screen.availWidth;
        var pTop = (pheight - 720) / 2;
        var pLeft = (pwidth - 765) / 2;

        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open("POST", "/ezBoard/getItemViewNew.do?boardID=" + pBoardID + "&itemID=" + pItemID, false);
        xmlhttp.send();
        if (getNodeText(xmlhttp.responseXML.documentElement) != "0") {
            window.open("/myoffice/ezBoardSTD/BoardItemView_Photo.aspx?&ItemID=" + pItemID + "&BoardID=" + pBoardID + "&location=GENERAL", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=780,width=765,top=" + pTop + ",left=" + pLeft, "");
        }
        else {
            alert(strLang166);
        }
    }
    else {
        var pheigth = window.screen.availHeight;
        var pwidth = window.screen.availWidth;
        pheigth = parseInt(pheigth) / 2;
        pwidth = parseInt(pwidth) / 2;
        pheigth = pheigth - 284;
        pwidth = pwidth - 359;

        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open("POST", "/ezBoard/getItemViewNew.do?boardID=" + pBoardID + "&itemID=" + pItemID, false);
        xmlhttp.send();

        if (getNodeText(xmlhttp.responseXML.documentElement) != "0") {
            window.open("/ezBoard/boardItemView.do?itemID=" + pItemID + "&boardID=" + pBoardID, "", "height=720,width=765, status = no, toolbar=no, menubar=no, location=no,scrollbars=1, resizable=1, top=0, left=0", "");
        }
        else {
            alert(strLang166);
        }
    }
}
function Item_View_APPR(pBoardID, pItemID, pgubun) {
    var pheigth = window.screen.availHeight;
    var pwidth = window.screen.availWidth;
    pheigth = parseInt(pheigth) / 2;
    pwidth = parseInt(pwidth) / 2;
    pheigth = pheigth - 284;
    pwidth = pwidth - 359;

    var xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "/ezBoard/getItemViewNew.do?boardID=" + pBoardID + "&itemID=" + pItemID, false);
    xmlhttp.send();

    
    if (getNodeText(xmlhttp.responseXML.documentElement) != "0") {
        if (pgubun == "3" || pgubun == "4") {
            window.open("/myoffice/ezBoardSTD/BoardItemView_Photo.aspx?ItemID=" + pItemID + "&BoardID=" + pBoardID + "&location=GENERAL", "", "height=770,width=765, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=0, left=0", "");
        }
        else {
            window.open("/ezBoard/boardItemView.do?itemID=" + pItemID + "&boardID=" + pBoardID + "&location=GENERAL", "", "height=720,width=765, status = no, scrollbars=1, toolbar=no, menubar=no, location=no, resizable=1, top=0, left=0", "");
        }
    }
    else {
        alert(strLang166);
    }
}


// 20060724 준호추가
// 커뮤니티 게시판에서 넘어온 경우 처리
// 게시 보기(새거)
function Item_View_New_Community(pBoardID, pItemID, pCommunityID) {
    var pheigth = window.screen.availHeight;
    var pwidth = window.screen.availWidth;
    pheigth = parseInt(pheigth) / 2;
    pwidth = parseInt(pwidth) / 2;
    pheigth = pheigth - 284;
    pwidth = pwidth - 359;

    if (CrossYN())
        window.open("/myoffice/ezCommunity/BoardItemView_cross.aspx?ItemID=" + pItemID + "&BoardID=" + pBoardID + "&code=" + pCommunityID, "", "height=720,width=765, status = no, toolbar=no, scrollbars=1, menubar=no, location=no, resizable=1, top=0, left=0", "");
    else
        window.open("/myoffice/ezCommunity/BoardItemView.aspx?ItemID=" + pItemID + "&BoardID=" + pBoardID + "&code=" + pCommunityID, "", "height=720,width=765, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=0, left=0", "");
}

// 결재 보기
function ViewDoc(pDocID, pURL, pWhat, pOpinionFlag, pdocState, pListSusin, podoc) {
    if (typeof (pWhat) == "undefined" || podoc == "") {
        openLocation = "/ezflow/AprDocView.asp?DocID=" + encodeURI(pDocID) + "&DocHref=" + encodeURI(pURL);
        openwindow(openLocation, "", 880, 550);
    }
    else if (pWhat == "1") {
        openLocation = "/ezflow/AprDocView.asp?DocID=" + encodeURI(pDocID) + "&DocHref=" + encodeURI(pURL) + "&OpinionFlag=" + encodeURI(pOpinionFlag) + "&docState=" + encodeURI(pdocState) + "&ListSusin=" + encodeURI(pListSusin) + "&odoc=" + encodeURI(podoc);
        openwindow(openLocation, "", 880, 550);
    }
    else {
        openLocation = "/ezflow/AprDocView.asp?DocID=" + encodeURI(pDocID) + "&DocHref=" + encodeURI(pURL);
        openwindow(openLocation, "", 880, 550);
    }
}

function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
    try {
        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;

        var left = 0;
        var top = 0;

        if (window.screen.width > 800) {
            var pleftpos;
            pleftpos = parseInt(width) - 700;
            heigth = parseInt(heigth) - 176;
            width = parseInt(width) - pleftpos;
            left = pleftpos / 2;
        }
        else {
            heigth = parseInt(heigth) - 30;
            width = parseInt(width) - 10;
        }

        if (wName == "")
            window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
        else
            window.open("", wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);

    } catch (e) { }
}

