var PreviewH_Move = false;
function PreviewH_onMouserDown(e) {
    curevent = (typeof event == 'undefined' ? e : event)

    var newPos_H = curevent.clientX;

    if (newPos_H < parseInt(CurrenWidth * 0.40)) {
        newPos_H = parseInt(CurrenWidth * 0.40);
    }
    else if (newPos_H > parseInt(CurrenWidth * 0.65)) {
        newPos_H = parseInt(CurrenWidth * 0.65);
    }

    document.getElementById("ResizeBarH").style.left = newPos_H + "px";
    document.getElementById("ResizeBarH").style.display = "";
    document.getElementById("mailPanel").style.display = "";
    PreviewH_Move = true;
    
    // IE에서 Preview 프레임의 크기를 변경하기 위해 마우스를 드래그 후 놓을 때 메일 목록의 텍스트가 모두 선택되는 문제가 발생해 추가함.
    document.onselectstart = function () { return false; };
}
var PreviewW_Move = false;
function PreviewW_onMouserDown(e) {
    curevent = (typeof event == 'undefined' ? e : event)

    var newPos_W = curevent.clientY;

    if (newPos_W < (parseInt(CurrentHeight * 0.25) + 90)) {
        newPos_W = parseInt(CurrentHeight * 0.25) + 90;
    }
    else if (newPos_W > (parseInt(CurrentHeight * 0.65) + 90)) {
        newPos_W = (parseInt(CurrentHeight * 0.65) + 90);
    }

    document.getElementById("ResizeBarW").style.top = newPos_W + "px";
    document.getElementById("ResizeBarW").style.display = "";
    document.getElementById("mailPanel").style.display = "";
    PreviewW_Move = true;
    
    // IE에서 Preview 프레임의 크기를 변경하기 위해 마우스를 드래그 후 놓을 때 메일 목록의 텍스트가 모두 선택되는 문제가 발생해 추가함.
    document.onselectstart = function () { return false; };
}
function MailPreviewEnd(e) {
    if (PreviewW_Move || PreviewH_Move) {
        document.getElementById("ResizeBarH").style.display = "none";
        document.getElementById("ResizeBarW").style.display = "none";
        document.getElementById("mailPanel").style.display = "none";
        if (PreviewH_Move) {
            var newPos_H = parseInt(document.getElementById("ResizeBarH").style.left) - 10;
            if (pMailListWidthH > newPos_H) {
                pMailPreWidthH = pMailPreWidthH + (pMailListWidthH - newPos_H);
                pMailListWidthH = newPos_H;
            } else {
                pMailPreWidthH = CurrenWidth - newPos_H;
                pMailListWidthH = newPos_H;
            }
            document.getElementById("ifrmPreViewH").style.display = "";
            document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
            document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
            document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
            document.getElementById("contentlist").style.height = (CurrentHeight - 70) + "px";
            document.getElementById("PreviewRayerH").style.width = pMailPreWidthH + "px";
            document.getElementById("PreContent_RayerH").style.width = pMailPreWidthH - 5 + "px";
            document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 88) + "px";
            pMailListDiv_H = (pMailListWidthH / CurrenWidth) * 100;
            pMailPreVDiv_H = (pMailPreWidthH / CurrenWidth) * 100;

        }
        else if (PreviewW_Move) {
            var newPos_W = parseInt(document.getElementById("ResizeBarW").style.top) - 90;
            if (pMailListHeightW > newPos_W) {
                pMailPreHeightW = pMailPreHeightW + (pMailListHeightW - newPos_W);
                pMailListHeightW = newPos_W;
            } else {
                pMailPreHeightW = CurrentHeight - newPos_W;
                pMailListHeightW = newPos_W;
            }
            document.getElementById("ifrmPreViewW").style.display = "";
            document.getElementById("MailListRayer").style.width = "100%";
            document.getElementById("PreviewRayerW").style.width = "100%";
            document.getElementById("MailListRayer").style.height = pMailListHeightW + "px";
            document.getElementById("contentlist").style.height = (pMailListHeightW - 70) + "px";
            document.getElementById("PreviewRayerW").style.height = pMailPreHeightW + "px";
            document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 100) + "px";
            pMailListDiv = (pMailListHeightW / CurrentHeight) * 100;
            pMailPreVDiv = (pMailPreHeightW / CurrentHeight) * 100;
        }
        PreviewH_Move = false;
        PreviewW_Move = false;
        ContextMenuHidden();
        if (g_foldertype != "sent") {
            if (SmallSizeList) {
                if (p_ListorderValue == "" || p_ListorderValue == "UNREAD") {
                    BasicViewHeaderChange(SmallSizeList);
                    OldSmallSizeList = SmallSizeList;
                }
            }
            else {
                if (p_ListorderValue == "" && OldSmallSizeList) {
                    BasicViewHeaderChange(SmallSizeList);
                }
                else if (p_ListorderValue == "UNREAD" && OldSmallSizeList) {
                    BasicViewHeaderChange(SmallSizeList);
                }
            }
        }
    }
    
    // IE에서 Preview 프레임의 크기를 변경하기 위해 마우스를 드래그 후 놓을 때 메일 목록의 텍스트가 모두 선택되는 문제가 발생해 추가함.
    // 이 부분은 사용자가 Preview 헤더 부분의 텍스트를 선택 가능하게 하기 위해 필요함.
    document.onselectstart = null;
}
var SmallSizeList = false;
var OldSmallSizeList = false;
function MailPreviewResize(e) {
    if (PreviewH_Move) {
        curevent = (typeof event == 'undefined' ? e : event)
        var minSize = parseInt(200);
        var maxSize = parseInt(document.documentElement.clientWidth - 200);
        if (curevent.clientX < minSize || curevent.clientX > maxSize) {
            MailPreviewEnd(e);
        }
        else {
            var newPos_H = curevent.clientX;

            if (newPos_H < parseInt(CurrenWidth * 0.40)) {
                newPos_H = parseInt(CurrenWidth * 0.40);
                SmallSizeList = true;
            }
            else if (newPos_H > parseInt(CurrenWidth * 0.65)) {
                newPos_H = parseInt(CurrenWidth * 0.65);
            }

            if (newPos_H > parseInt(CurrenWidth * 0.40))
                SmallSizeList = false;

            document.getElementById("ResizeBarH").style.left = newPos_H + "px";
        }
    }
    else if (PreviewW_Move) {
        curevent = (typeof event == 'undefined' ? e : event)
        var minSize = parseInt(100);
        var maxSize = parseInt(document.documentElement.clientHeight-100);
        if (curevent.clientY < minSize || curevent.clientY > maxSize) {
            MailPreviewEnd(e);
        }
        else {
            var newPos_W = curevent.clientY;
            if (newPos_W < (parseInt(CurrentHeight * 0.25) + 90))
                newPos_W = parseInt(CurrentHeight * 0.25) + 90;
            else if (newPos_W > (parseInt(CurrentHeight * 0.65) + 90)) {
                newPos_W = (parseInt(CurrentHeight * 0.65) + 90);
            }
            document.getElementById("ResizeBarW").style.top = newPos_W + "px";
        }
    }
}
function new_mail_onclick() {
	pUrl = "/ezEmail/mailWrite.do?cmd=NEW";
	/*if (CrossYN() || pNoneActiveX == "YES") {
        pUrl = "/myoffice/ezEmail/mail_write_Cross.aspx?cmd=NEW";
    }
    else {
        if (pUse_Editor == "")
            pUrl = "/myoffice/ezEmail/mail_write_Cross.aspx?cmd=NEW";
        else
            pUrl = "/myoffice/ezEmail/mail_write_Cross.aspx?cmd=NEW";
    }*/
    var newwin = GetOpenWindow(pUrl, "", 890, 840, "no");
    newwin.focus();
}
function ReSend(pURL, pEmail) {
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var conWidth = pwidth * 0.8;
    if (conWidth > 890)
        conWidth = 890;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - 890) / 2;
    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px,width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
    
    window.open("/ezEmail/mailWrite.do?url=" + encodeURIComponent(pURL) + "&cmd=RESEND&msgto=" + encodeURI(pEmail), "", feature);
    /*if (CrossYN() || pNoneActiveX == "YES") {
        window.open("/ezEmail/mailWrite.do?url=" + encodeURIComponent(pURL) + "&cmd=RESEND&msgto=" + encodeURI(pEmail), "", feature);
    }
    else {
        if (pUse_Editor == "")
            window.open("mail_write_Cross.aspx?url=" + encodeURIComponent(pURL) + "&cmd=RESEND&msgto=" + encodeURI(pEmail), "", feature);
        else
            window.open("mail_write_Cross.aspx?url=" + encodeURIComponent(pURL) + "&cmd=RESEND&msgto=" + encodeURI(pEmail), "", feature);
    }*/
}

function reply_mail_onclick() {
    if (listContentArry.length == 0 && listSubContentArry.length == 0) {
        alert(strLang43);
    }
    else {
        var pSelectItem;
        if (listContentArry.length > 0) {
            pSelectItem = document.getElementById(listContentArry[listContentArry.length-1])
        }
        else {
            pSelectItem = document.getElementById(listSubContentArry[listSubContentArry.length - 1])
        }
        var pheight = window.screen.availHeight;
        var conHeight = pheight * 0.8;
        var pwidth = window.screen.availWidth;
        var conWidth = pwidth * 0.8;
        if (conWidth > 890)
            conWidth = 890;
        var pTop = (pheight - conHeight) / 2;
        var pLeft = (pwidth - 890) / 2;        
        var pURI = "/ezEmail/mailWrite.do?cmd=REPLY&URL=" + encodeURIComponent(pSelectItem.getAttribute('_href'));
        var newwin = window.open(pURI, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
        newwin.focus();
    }
}

function GetNewGuid() {
    return Math.floor((1 + Math.random()) * 0x10000)
               .toString(16)
               .substring(1);
}

function all_reply_mail_onclick() {
    if (listContentArry.length == 0 && listSubContentArry.length == 0) {
        alert(strLang43);
    }
    else {
        var pSelectItem;
        if (listContentArry.length > 0) {
            pSelectItem = document.getElementById(listContentArry[listContentArry.length - 1])
        }
        else {
            pSelectItem = document.getElementById(listSubContentArry[listSubContentArry.length - 1])
        }
        var pheight = window.screen.availHeight;
        var conHeight = pheight * 0.8;
        var pwidth = window.screen.availWidth;
        var conWidth = pwidth * 0.8;
        if (conWidth > 890)
            conWidth = 890;
        var pTop = (pheight - conHeight) / 2;
        var pLeft = (pwidth - 890) / 2;
        var pURI = "/ezEmail/mailWrite.do?cmd=REPLYALL&URL=" + encodeURIComponent(pSelectItem.getAttribute('_href'));
        var newwin = window.open(pURI, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
        newwin.focus();
    }
}

function transmission_mail_onclick() {
    if (listContentArry.length == 0 && listSubContentArry.length == 0) {
        alert(strLang47);
    }
    else {
        var pSelectItem;
        if (listContentArry.length > 0) {
            pSelectItem = document.getElementById(listContentArry[listContentArry.length - 1])
        }
        else {
            pSelectItem = document.getElementById(listSubContentArry[listSubContentArry.length - 1])
        }
        var pheight = window.screen.availHeight;
        var conHeight = pheight * 0.8;
        var pwidth = window.screen.availWidth;
        var conWidth = pwidth * 0.8;
        if (conWidth > 890)
            conWidth = 890;
        var pTop = (pheight - conHeight) / 2;
        var pLeft = (pwidth - 890) / 2;
        var pURI = "/ezEmail/mailWrite.do?cmd=FORWARD&URL=" + encodeURIComponent(pSelectItem.getAttribute('_href'));
        var newwin = window.open(pURI, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
        newwin.focus();
    }
}
function Read_StatusChange(pGubun) {
    if (listContentArry.length == 0 && listSubContentArry.length == 0) {
        alert(strLang311);
        return;
    }

    var isRead;
    if (pGubun == "R")
        isRead = "TRUE";
    else
        isRead = "FALSE";
    var xmlpara = createXmlDom();
    var xmlHTTP = createXMLHttpRequest();
    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "ISREAD", isRead);
    if (listContentArry.length > 0) {
        for (var i = 0; i < listContentArry.length; i++) {
            createNodeAndInsertText(xmlpara, objNode, "MESSAGEID", document.getElementById(listContentArry[i]).getAttribute("_href"));
        }
    }
    else {
        for (var i = 0; i < listSubContentArry.length; i++) {
            createNodeAndInsertText(xmlpara, objNode, "MESSAGEID", document.getElementById(listSubContentArry[i]).getAttribute("_href"));
        }
    }
    xmlHTTP.open("POST", "/ezEmail/mailSetReadChange.do", false);
    xmlHTTP.send(xmlpara);
    MailListRefresh();
}
var mail_movecopy_cross_dialogArguments = new Array();
function move_mail_onclick() {
    if (listContentArry.length == 0 && listSubContentArry.length == 0) {
        alert(strLang51);
        return;
    }
    mail_movecopy_cross_dialogArguments[1] = move_mail_onclick_Complete;
    mail_movecopy_cross_dialogArguments[2] = "CLOSE";
    var OpenWin = window.open("/ezEmail/mailMoveCopy.do", "mail_movecopy_cross", GetOpenWindowfeature(320, 375));
    try { OpenWin.focus(); } catch (e) { }
}
function move_mail_onclick_Complete(moveUrl) {
    if (typeof (moveUrl) == "undefined")
        return;

    if (moveUrl["cmd"] == "MOVE") {
        var szItemID = "";
        for (var i = 0; i < listContentArry.length; i++) {
            szItemID += document.getElementById(listContentArry[i]).getAttribute("_href") + ",";
        }
        for (var i = 0; i < listSubContentArry.length; i++) {
            szItemID += document.getElementById(listSubContentArry[i]).getAttribute("_href") + ",";
        }
        Mail_CopyPostSend(moveUrl["cmd"], moveUrl["url"], szItemID);
    }
    else if (moveUrl["cmd"] == "COPY") {
        var szItemID = "";
        for (var i = 0; i < listContentArry.length; i++) {
            szItemID += document.getElementById(listContentArry[i]).getAttribute("_href") + ",";
        }
        for (var i = 0; i < listSubContentArry.length; i++) {
            szItemID += document.getElementById(listSubContentArry[i]).getAttribute("_href") + ",";
        }
        Mail_CopyPostSend(moveUrl["cmd"], moveUrl["url"], szItemID);
    }
}
var xmlhttp_mailCopy;
function Mail_CopyPostSend(Mode, Url, szItemID) {
    var xmlpara = createXmlDom();
    var objNode;
    xmlhttp_mailCopy = createXMLHttpRequest();
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "CMD", Mode);
    createNodeAndInsertText(xmlpara, objNode, "UNIQUEID", szItemID);
    createNodeAndInsertText(xmlpara, objNode, "FOLDERID", Url);
    xmlhttp_mailCopy.open("POST", "/ezEmail/mailMoveCopyMessage.do", true);
    xmlhttp_mailCopy.onreadystatechange = event_Mail_CopyPostSend;
    event_Mail_CopyPostSend.mode = Mode;
    xmlhttp_mailCopy.send(xmlpara);
}
function event_Mail_CopyPostSend() {
    if (xmlhttp_mailCopy != null && xmlhttp_mailCopy.readyState == 4) {
        if (xmlhttp_mailCopy.status >= 200 && xmlhttp_mailCopy.status < 300) {
        	pRtnMessage = xmlhttp_mailCopy.responseText;
        	
        	if (pRtnMessage.indexOf("NO COPY processing failed.") > -1) {
        		alert(strLang241);
        	} else {
	        	MailListRefresh();
	            refreshUnreadCount();
	            if(event_Mail_CopyPostSend.mode=="MOVE") {
	            	alert(MoveMsg);
	            } else if (event_Mail_CopyPostSend.mode=="COPY") {
	            	alert(CopyMsg);
	            }
        	}
        }
        else {
            alert(strLang5);
        }
    }
}
var xmlhttp_mailMoveDelete;
function Mail_MoveDeletePostSend(Mode, Url, szItemID) {
    var xmlpara = createXmlDom();
    var objNode;
    xmlhttp_mailMoveDelete = createXMLHttpRequest();
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "UNIQUEID", szItemID);
    createNodeAndInsertText(xmlpara, objNode, "FOLDERID", Url);
    xmlhttp_mailMoveDelete.open("POST", "/ezEmail/mailDelete.do?cmd=" + Mode, true);
    xmlhttp_mailMoveDelete.onreadystatechange = event_xmlhttp_mailMoveDelete_Complete;
    event_xmlhttp_mailMoveDelete_Complete.mode = Mode;
    xmlhttp_mailMoveDelete.send(xmlpara);
}
function event_xmlhttp_mailMoveDelete_Complete() {
    if (xmlhttp_mailMoveDelete != null && xmlhttp_mailMoveDelete.readyState == 4) {
    	if (xmlhttp_mailMoveDelete.responseText.indexOf("NO COPY processing failed.") > -1) {
    		alert(strLang241);
    	}
    	else if (xmlhttp_mailMoveDelete.status >= 200 && xmlhttp_mailMoveDelete.status < 300) {
            MailListRefresh();
            refreshUnreadCount();
            if(event_xmlhttp_mailMoveDelete_Complete.mode=="MOVE")
                alert(MoveMsg);
            else if (event_xmlhttp_mailMoveDelete_Complete.mode == "ALL") {
                parent.frames["left"].LoadEmailTree();
                alert(strLang215)
            }
            else {
                if (event_xmlhttp_mailMoveDelete_Complete.mode != "BMOVE")
                    alert(strLang215)
            }

        }
        else {
            if (event_xmlhttp_mailMoveDelete_Complete.mode == "MOVE")
                alert(strLang52);
            else
                alert(strLang131);
        }
        prevShow_Clear();
    }
}
function refreshUnreadCount() {
    try {
        if (typeof (window.parent.frames.left) != "undefined")
            parent.frames["left"].get_unreadcount();
    } catch (e) { }
}
function deleteWork(bDel) {
    if (listContentArry.length == 0 && listSubContentArry.length == 0) {
        alert(strLang57);
        return;
    }
    var cmd = "";
    if (bDel == true || g_szRootFolderName.replace(' ', '') == strLang4) {
        cmd = "BDELETE";
        if (!confirm(strLang58))
            return;
    }
    else {
        if (g_foldertype == "delete")
            cmd = "SOFTDEL";
        else
            cmd = "BMOVE";
        if (!confirm(strLang59))
            return;
    }
    var szItemID = "";
    for (var i = 0; i < listContentArry.length; i++) {
        szItemID += document.getElementById(listContentArry[i]).getAttribute("_href") + ",";
    }
    for (var i = 0; i < listSubContentArry.length; i++) {
        szItemID += document.getElementById(listSubContentArry[i]).getAttribute("_href") + ",";
    }
    Mail_MoveDeletePostSend(cmd, "", szItemID)
}
function delAllFile() {
    Mail_MoveDeletePostSend("ALL", "", g_moveUrl);
}
function receiveCheck_onClick() {
    if (listContentArry.length == 0 && listSubContentArry.length == 0) {
        alert(strLang49);
        return;
    }
    if (listContentArry.length > 1 || listSubContentArry.length > 1) {
        alert(strLang50);
        return;
    }
    var url = "";
    if (listContentArry.length == 1) {
        url = document.getElementById(listContentArry[0]).getAttribute("_href");
    }
    else {
        url = document.getElementById(listSubContentArry[0]).getAttribute("_href");
    }
    var OpenWin = window.open("/ezEmail/mailReaderList.do?url=" + encodeURIComponent(url), "mail_readerlist", GetOpenWindowfeature(620, 500));
    try { OpenWin.focus(); } catch (e) { }
}
function ListCount(pCount) {
    document.getElementById("MailList").setAttribute("listpageCount", pCount);
    MailOptionHidden();
    MailListRefresh();
}
var denial_cross_dialogArguments = new Array();
function reject_onclick() {
    if (listContentArry.length == 0 && listSubContentArry.length == 0) {
        alert(strLang60);
        return;
    }
    var RejectArray = new Array();

    RejectArray = listContentArry.length == 0 ? listSubContentArry : listContentArry;
    var params = new Array();
    params["email"] = new Array();
    params["link"] = new Array();
    for (var n = 0; n < RejectArray.length; n++) {
        var xmlHTTP = new XMLHttpRequest();
        var xmlpara = createXmlDom();
        var objNode;
        xmlhttp_mailMoveDelete = createXMLHttpRequest();
        createNodeInsert(xmlpara, objNode, "DATA");
        var url = "";
        url = document.getElementById(RejectArray[n]).getAttribute("_href");
        createNodeAndInsertText(xmlpara, objNode, "ITEMID", url);
        try {
            xmlHTTP.open("POST", "/ezEmail/mailGetFromEmail.do", false);
            xmlHTTP.send(xmlpara);

            if (xmlHTTP.status < 200 || xmlHTTP.status > 300) {
                alert("ERROR");
                xmlDOM = null;
                xmlHTTP = null;
            }
        }
        catch (e) {
            alert(e.description);
            xmlDOM = null;
            xmlHTTP = null;
        }

        var fromEmail = xmlHTTP.responseText;
        xmlDOM = null;
        xmlHTTP = null;
        params["email"][n] = fromEmail;
        params["link"][n] = "";
    }
    denial_cross_dialogArguments[0] = params;
    denial_cross_dialogArguments[1] = reject_onclick_Complete;
    var OpenWin = window.open("/ezEmail/mailDenial.do", "denial_cross", GetOpenWindowfeature(335, 314));
    try { OpenWin.focus(); } catch (e) { }
}
function reject_onclick_Complete(retVal)
{
    if (typeof (retVal) == "string") {
        if (retVal == "cancel")
            return;
    }
    var xmlpara = createXmlDom();
    var objNode;
    var objRow;
    var objRow2;
    objNode = createNodeInsert(xmlpara, objNode, "DATA");
    for (var i = 0; i < retVal.length; i++) {
        objRow = createNodeAndAppandNode(xmlpara, objNode, objRow, "ROW");
        createNodeAndAppandNodeText(xmlpara, objRow, objRow2, "DENIAL", retVal[i]);
    }
    var xmlHTTP = new XMLHttpRequest();
    xmlHTTP.open("POST", "/ezEmail/mailRequestDenial.do", false);
    xmlHTTP.setRequestHeader("Content-Type", "text/xml");
    xmlHTTP.send(xmlpara);

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
}
function replaceAll(pStrContent, pStrOrg, pStrRep) {
    return pStrContent.split(pStrOrg).join(pStrRep);
}
var xmlhttp_mailPreview;
var xmlhttp_mailPreviewObject;
var Old_Preview_Href;
function prevShow() {
    if (!g_bPrevShow)
        return;

    try {
        if (listContentArry.length == 0 && listSubContentArry.length == 0) {
            return;
        }
        else {
            var Preview_Href;
            if (listContentArry.length > 0) {
                Preview_Href = document.getElementById(listContentArry[listContentArry.length - 1]).getAttribute("_href");
                xmlhttp_mailPreviewObject = document.getElementById(listContentArry[listContentArry.length - 1]);
            }
            else {
                Preview_Href = document.getElementById(listSubContentArry[listSubContentArry.length - 1]).getAttribute("_href");
                xmlhttp_mailPreviewObject = document.getElementById(listSubContentArry[listSubContentArry.length - 1]);
            }
        }
        //if (Old_Preview_Href == Preview_Href)
        //    return;

        Old_Preview_Href = Preview_Href;
        var strQuery = "<URL>" + Preview_Href + "</URL>";
        xmlhttp_mailPreview = createXMLHttpRequest();
        xmlhttp_mailPreview.open("POST", "/ezEmail/mailPrevShow.do?MSGFLAG=N", true);
        xmlhttp_mailPreview.onreadystatechange = event_xmlhttp_mailPreview_Complete;
        xmlhttp_mailPreview.send(strQuery);

    } catch (e) { }
}
function event_xmlhttp_mailPreview_Complete() {
    if (xmlhttp_mailPreview != null && xmlhttp_mailPreview.readyState == 4) {
        if (xmlhttp_mailPreview.status >= 200 && xmlhttp_mailPreview.status < 300) {
            var xmlDoc = xmlhttp_mailPreview.responseXML;
            var pUnread = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/UNREAD")[0]);
            var pDate = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/DATE")[0]);
            var pFrom = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/FROM")[0]);
            var pFromemail = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/FROMEMAIL")[0]);
            var pFromname = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/FROMNAME")[0]);
            var pTo = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/TO")[0]);
            var pCc = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/CC")[0]);
            var pBcc = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/BCC")[0]);
            var pSubject = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/SUBJECT")[0]);
            var pHtml = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/HTMLDESCRIPTION")[0]);
            var pImportance = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/IMPORTANCE")[0]);
            var pSensitivity = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/SENSITIVITY")[0]);
            var pHasembed = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/HASEMBEDED")[0]);
            var pItemid = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/ITEMID")[0]);
            var pContentClass = getNodeText(SelectNodes(xmlhttp_mailPreview.responseXML, "DATA/CONTENTCLASS")[0]);
            if (pPreviewShow_HOW == "H") {
                PrevViewFormH.iptURL.value = pItemid;
                PrevViewFormH.submit();
            }
            else {
                PrevViewFormW.iptURL.value = pItemid;
                PrevViewFormW.submit();
            }

            var pMailReceiver = pTo;
            var pReceiverArray = pMailReceiver.split(";");
            var pReceiverHtml = "";
            var pReceiverSubHtml = "";
            var pReceiverDetailDisplay = false;
            var pReceiverDetailHtml = "";
            var pMailSenderHtml = "";
            var pReceiverCnt = 0;
            for (var Cnt = 0; Cnt < pReceiverArray.length; Cnt++) {
                var pReceiver_ = pReceiverArray[Cnt].replace(/"/g, "");
                if (pReceiver_.length > 10) {
                    var Pos1 = pReceiver_.indexOf("<");
                    var Pos2 = pReceiver_.indexOf(">");
                    var pReceiver_Name = TrimText(pReceiver_.substring(0, Pos1));
                    var pReceiver_Address = TrimText(pReceiver_.substring(Pos1 + 1, Pos2));

                    if (Cnt == 0) {
                        pReceiverHtml = "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + ConvertStringForHTML(pReceiver_Address) + "' onclick='show_personinfo(\"" + pReceiver_Address + "\")'>\"" + ConvertStringForHTML(pReceiver_Name) + "\"</span>";
                        
                    }

                    if (pReceiverDetailHtml != "")
                        pReceiverDetailHtml += "&nbsp;,&nbsp;";
                    pReceiverDetailHtml += "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + ConvertStringForHTML(pReceiver_Address) + "' onclick='show_personinfo(\"" + pReceiver_Address + "\")'>\"" + ConvertStringForHTML(pReceiver_Name) + "\"</span>";
                    if (g_useremail == pReceiver_Address) {
                        pReceiverHtml = "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + ConvertStringForHTML(pReceiver_Address) + "' onclick='show_personinfo(\"" + pReceiver_Address + "\")'>\"" + ConvertStringForHTML(pReceiver_Name) + "\"</span>";
                    }

                    pReceiverCnt++;
                }
            }
            if (pReceiverCnt >= 2) {
                document.getElementById("PreH_ReceiverDetail").style.display = ""; 
                document.getElementById("PreH_ReceiverDetail").className = "icon_graydown";
                document.getElementById("PreW_ReceiverDetail").style.display = "";
                document.getElementById("PreW_ReceiverDetail").className = "icon_graydown";
                pReceiverSubHtml = "(" + strLang156 + pReceiverCnt + strLang300 + ")";
                pReceiverDetailDisplay = true;
            }
            else {
                document.getElementById("PreH_ReceiverDetail").style.display = "none";
                document.getElementById("PreW_ReceiverDetail").style.display = "none";
                
                pReceiverSubHtml = "";
                pReceiverDetailDisplay = false;
                if (pReceiverHtml == "") {
                    pReceiverHtml = pReceiverDetailHtml;
                }

            }

            ////
            document.getElementById("PreH_CCMain").style.display = "none";
            document.getElementById("PreW_CCMain").style.display = "none";
            document.getElementById("PreH_CCDetail").style.display = "none";
            document.getElementById("PreW_CCDetail").style.display = "none";
            var pCcHtml = "";
            var pCcSubHtml = "";
            var pCcDetailHtml = "";
            if (pCc != "") {
                var pMailCc = pCc;
                var pCcArray = pMailCc.split(";");
                var pCcDetailDisplay = false;
                var pMailSenderHtml = "";
                var pCcCnt = 0;
                for (var Cnt = 0; Cnt < pCcArray.length; Cnt++) {
                    var pCc_ = pCcArray[Cnt].replace(/"/g, "");
                    if (pCc_.length > 10) {
                        var Pos1 = pCc_.indexOf("<");
                        var Pos2 = pCc_.indexOf(">");
                        var pCc_Name = TrimText(pCc_.substring(0, Pos1));
                        var pCc_Address = TrimText(pCc_.substring(Pos1 + 1, Pos2));

                        if (Cnt == 0) {
                            pCcHtml = "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + ConvertStringForHTML(pCc_Address) + "' onclick='show_personinfo(\"" + pCc_Address + "\")'>\"" + ConvertStringForHTML(pCc_Name) + "\"</span>";

                        }

                        if (pCcDetailHtml != "")
                            pCcDetailHtml += "&nbsp;,&nbsp;";
                        pCcDetailHtml += "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + ConvertStringForHTML(pCc_Address) + "' onclick='show_personinfo(\"" + pCc_Address + "\")'>\"" + ConvertStringForHTML(pCc_Name) + "\"</span>";
                        if (g_useremail == pCc_Address) {
                            pCcHtml = "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + ConvertStringForHTML(pCc_Address) + "' onclick='show_personinfo(\"" + pCc_Address + "\")'>\"" + ConvertStringForHTML(pCc_Name) + "\"</span>";
                        }

                        pCcCnt++;
                    }
                }
                if (pCcCnt >= 2) {
                    document.getElementById("PreH_CCDetail").style.display = "";
                    document.getElementById("PreH_CCDetail").className = "icon_graydown";
                    document.getElementById("PreW_CCDetail").style.display = "";
                    document.getElementById("PreW_CCDetail").className = "icon_graydown";
                    pCcSubHtml = "(" + strLang156 + pCcCnt + strLang300 + ")";
                    pCcDetailDisplay = true;
                }
                else {
                    document.getElementById("PreH_CCDetail").style.display = "none";
                    document.getElementById("PreW_CCDetail").style.display = "none";

                    pCcSubHtml = "";
                    pCcDetailDisplay = false;
                    if (pCcHtml == "") {
                        pCcHtml = pCcDetailHtml;
                    }

                }
                if (pPreviewShow_HOW == "H") {
                	// added the following code to solve a layout problem in Preview : dhlee - 2016.05.19
                	document.getElementById("Preview_HeaderH").style.paddingBottom = "";
                	
                    document.getElementById("PreH_CCMain").style.display = "";
                }
                else {
                	// added the following code to solve a layout problem in Preview : dhlee - 2016.05.19
                	document.getElementById("Preview_HeaderW").style.paddingBottom = "";
                	
                    document.getElementById("PreW_CCMain").style.display = "";
                }
            }
            // added the following code to solve a layout problem in Preview : dhlee - 2016.05.19
            else {
            	if (pPreviewShow_HOW == "H") {
            		document.getElementById("Preview_HeaderH").style.paddingBottom = "20px";
            	}
            	else {
            		document.getElementById("Preview_HeaderW").style.paddingBottom = "20px";
            	}
            }
            
            ///
            
            var pOCS = "";
            if (USE_OCS == "YES") {
                pOCS = "<img src='/images/presence/unknown.gif' id='" + GetGUID() + "' onload=\"PresenceControl('" + pFromemail + "',this);\" style='vertical-align:middle;padding-right:5px;'/>";
            }

            pMailSenderHtml = pOCS + "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + ConvertStringForHTML(pFromemail) + "' onclick='show_personinfo(\"" + pFromemail + "\")'>\"" + ConvertStringForHTML(pFromname) + "\"</span>";

            //pMailSenderHtml = "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + ConvertStringForHTML(pFromname) + "' onclick='show_personinfo(\"" + pFromemail + "\")'>\"" + ConvertStringForHTML(pFromname) + "\"</span>";

            if (pPreviewShow_HOW == "H") {
                document.getElementById("PreH_subject").setAttribute("itemid", pItemid);
                document.getElementById("PreH_subject").setAttribute("_contentclass", pContentClass);
                document.getElementById("PreH_MailReceiverDetail_Rayer").style.display = "none";
                document.getElementById("Preview_HeaderH").style.display = "";
                document.getElementById("PreH_sub_subject").innerHTML = pSubject;
                document.getElementById("PreH_subject").style.display = "";
                document.getElementById("PreH_date").innerHTML = pDate;
                document.getElementById("PreH_MailReceiver").innerHTML = pReceiverHtml;
                document.getElementById("PreH_MailReceiver_sub").innerHTML = pReceiverSubHtml;
                document.getElementById("PreH_MailReceiverDetail").innerHTML = pReceiverDetailHtml;
                document.getElementById("PreH_MailCC").innerHTML = pCcHtml;
                document.getElementById("PreH_MailCC_sub").innerHTML = pCcSubHtml;
                document.getElementById("PreH_MailCCDetail").innerHTML = pCcDetailHtml;
                document.getElementById("PreH_sub_MailSender").innerHTML = pMailSenderHtml;
            }
            else {
                document.getElementById("PreW_subject").setAttribute("itemid", pItemid);
                document.getElementById("PreW_subject").setAttribute("_contentclass", pContentClass);
                document.getElementById("PreW_MailReceiverDetail_Rayer").style.display = "none";
                document.getElementById("Preview_HeaderW").style.display = "";
                document.getElementById("PreW_sub_subject").innerHTML = pSubject;
                document.getElementById("PreW_subject").style.display = "";
                document.getElementById("PreW_date").innerHTML = pDate;
                document.getElementById("PreW_MailReceiver").innerHTML = pReceiverHtml;
                document.getElementById("PreW_MailReceiver_sub").innerHTML = pReceiverSubHtml;
                document.getElementById("PreW_MailReceiverDetail").innerHTML = pReceiverDetailHtml;
                document.getElementById("PreW_MailCC").innerHTML = pCcHtml;
                document.getElementById("PreW_MailCC_sub").innerHTML = pCcSubHtml;
                document.getElementById("PreW_MailCCDetail").innerHTML = pCcDetailHtml;
                document.getElementById("PreW_sub_MailSender").innerHTML = pMailSenderHtml;
            }
            MailList_ChangeStatus(xmlhttp_mailPreviewObject);
            xmlhttp_mailPreviewObject = null;
            xmlhttp_mailPreview = null;
        }
    }
}
function MailList_ChangeStatus(obj) {
    if (obj.getAttribute("read") == "0") {
        if (obj.getAttribute("_contentclass") == "IPM.Note") {
            if(p_HeaderViewXML.indexOf("viewXMLFile1_1.xml") > 0)
                obj.childNodes.item(1).childNodes.item(0).src = "/images/ImgIcon/icon-msg-read.gif";
            else
                obj.childNodes.item(2).childNodes.item(0).src = "/images/ImgIcon/icon-msg-read.gif";
        }
        for (var i = 0; i < obj.childNodes.length; i++) {
            obj.childNodes.item(i).style.fontWeight = "";
        }
        obj.setAttribute("read", "1");
        try{
            parent.frames["left"].get_unreadcount();}catch(e){}
    }
}
function prevShow_Clear() {
    if (pPreviewShow_HOW == "W") {
        document.getElementById("Preview_HeaderW").style.display = "none";
        document.getElementById("ifrmPreViewW").src = "/blank.htm";
    }
    else {
        document.getElementById("Preview_HeaderH").style.display = "none";
        document.getElementById("ifrmPreViewH").src = "/blank.htm";
    }
}
function ReceiverDetail_view(obj) {
    if (obj.className == "icon_graydown") {
        obj.className = "icon_grayup"
        if (pPreviewShow_HOW == "W")
            document.getElementById("PreW_MailReceiverDetail_Rayer").style.display = "";
        else
            document.getElementById("PreH_MailReceiverDetail_Rayer").style.display = "";
    }
    else {
        obj.className = "icon_graydown"
        if (pPreviewShow_HOW == "W")
            document.getElementById("PreW_MailReceiverDetail_Rayer").style.display = "none";
        else
            document.getElementById("PreH_MailReceiverDetail_Rayer").style.display = "none";
    }
}
function CCDetail_view(obj) {
    if (obj.className == "icon_graydown") {
        obj.className = "icon_grayup"
        if (pPreviewShow_HOW == "W")
            document.getElementById("PreW_MailCCDetail_Rayer").style.display = "";
        else
            document.getElementById("PreH_MailCC_Rayer").style.display = "";
    }
    else {
        obj.className = "icon_graydown"
        if (pPreviewShow_HOW == "W")
            document.getElementById("PreW_MailCCDetail_Rayer").style.display = "none";
        else
            document.getElementById("PreH_MailCC_Rayer").style.display = "none";
    }
}
function show_personinfo(email) {
    var feature = "height=500px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
    feature = feature + GetOpenPosition(420, 500);
    window.open("/ezCommon/showPersonInfo.do?email=" + encodeURI(email), "", feature);
}
function MailReadOpen() {
    var pItemID;
    var pContentclass;
    if (pPreviewShow_HOW == "W") {
        pItemID = document.getElementById("PreW_subject").getAttribute("itemid");
        pContentclass = document.getElementById("PreW_subject").getAttribute("_contentclass");
    }
    else {
        pItemID = document.getElementById("PreH_subject").getAttribute("itemid");
        pContentclass = document.getElementById("PreH_subject").getAttribute("_contentclass");
    }
    callMsgDlg(pContentclass, pItemID);
}
var isPreviewChange = false;
function PreviewRayerChange(pGubun) {
    try {
        if (pPreviewShow_HOW == pGubun)
            return;

        isPreviewChange = true;
        if (pGubun == "NONE") {
            pPreviewShow_HOW = "OFF";
            document.getElementById("PreviewRayerW").style.display = "none";
            document.getElementById("PreviewRayerH").style.display = "none";
            CurrentHeight = document.documentElement.clientHeight - 110 - (document.getElementById("mainmenu").clientHeight - 28);;
            document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
            document.getElementById("MailListRayer").style.width = "100%";
            if (navigator.userAgent.indexOf('Firefox') != -1)
                document.getElementById("contentlist").style.height = (CurrentHeight - 70) + "px";
            else
                document.getElementById("contentlist").style.height = (CurrentHeight - 70) + "px";
            g_bPrevShow = false;
        }
        else if (pGubun == "W") {
            if (pMailListDiv == 0 || pMailPreVDiv == 0) {
                pMailListDiv = 50; pMailPreVDiv = 50;
            }
            document.getElementById("MailListRayer").style.display = "inline-block";
            document.getElementById("PreviewRayerW").style.display = "block";
            document.getElementById("PreviewRayerH").style.display = "none";

            CurrenWidth = document.documentElement.clientWidth - 10;
            CurrentHeight = document.documentElement.clientHeight - 110 - (document.getElementById("mainmenu").clientHeight - 28);;
            document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
            document.getElementById("ResizeBarW").style.width = (CurrenWidth - 10) + "px";
            pMailListHeightW = parseInt(CurrentHeight * (pMailListDiv / 100));
            pMailPreHeightW = parseInt(CurrentHeight * (pMailPreVDiv / 100));
            document.getElementById("MailListRayer").style.width = "100%";
            document.getElementById("PreviewRayerW").style.width = "100%";
            document.getElementById("MailListRayer").style.height = pMailListHeightW + "px";
            if (navigator.userAgent.indexOf('Firefox') != -1)
                document.getElementById("contentlist").style.height = (pMailListHeightW - 70) + "px";
            else
                document.getElementById("contentlist").style.height = (pMailListHeightW - 70) + "px";
            document.getElementById("PreviewRayerW").style.height = pMailPreHeightW + "px";
            document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 100) + "px";
            pPreviewShow_HOW = "W";
            pMailListDiv = Math.round((pMailListHeightW / CurrentHeight) * 100);
            pMailPreVDiv = Math.round((pMailPreHeightW / CurrentHeight) * 100);
            g_bPrevShow = true;
            if (p_ListorderValue != "SENT" && p_ListorderValue != "SUBJECT" && p_ListorderValue != "RECEIV") {
                if (pMailListWidthH <= parseInt(CurrenWidth * 0.40)) {
                    if (g_foldertype != "sent") {
                        if (p_HeaderViewXML.indexOf("viewXMLFile1_1.xml") > 0) {
                            p_HeaderViewXML = "Controls_cross/" + g_userLang + "/viewXMLFile1.xml";
                            var HeaderObject = document.getElementById("MailHeader");
                            var ContentObject = document.getElementById("MailList");
                            HeaderIni(HeaderObject);
                            GetListInfo(HeaderObject, ContentObject);
                        }
                    }
                }
            }
        }
        else if (pGubun == "H") {
            if (pMailListDiv_H == 0 || pMailPreVDiv_H == 0) {
                pMailListDiv_H = 50; pMailPreVDiv_H = 50;
            }
            document.getElementById("MailListRayer").style.display = "inline-block";
            document.getElementById("PreviewRayerW").style.display = "none";
            document.getElementById("PreviewRayerH").style.display = "inline-block";

            CurrenWidth = document.documentElement.clientWidth - 20;
            CurrentHeight = document.documentElement.clientHeight - 110 - (document.getElementById("mainmenu").clientHeight - 28);
            pMailListWidthH = parseInt(CurrenWidth * (pMailListDiv_H / 100));
            pMailPreWidthH = parseInt(CurrenWidth * (pMailPreVDiv_H / 100)) - 3;

            if(CurrenWidth < (pMailListWidthH + pMailPreWidthH))
            {
                if (pMailListWidthH > parseInt(CurrenWidth * 0.40)) {
                    pMailListWidthH = pMailListWidthH - ((pMailListWidthH + pMailPreWidthH) - CurrenWidth);
                }
                else {
                    pMailPreWidthH = pMailPreWidthH - ((pMailListWidthH + pMailPreWidthH) - CurrenWidth);
                }
            }

            document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
            document.getElementById("ResizeBarW").style.width = CurrenWidth + "px";
            document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
            document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
            document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
            if (navigator.userAgent.indexOf('Firefox') != -1)
                document.getElementById("contentlist").style.height = (CurrentHeight - 70) + "px";
            else
                document.getElementById("contentlist").style.height = (CurrentHeight - 70) + "px";
            document.getElementById("PreviewRayerH").style.width = pMailPreWidthH + "px";
            document.getElementById("PreContent_RayerH").style.width = pMailPreWidthH - 5 + "px";
            document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 88) + "px";
            pPreviewShow_HOW = "H";
            pMailListDiv_H = Math.round((pMailListWidthH / CurrenWidth) * 100);
            pMailPreVDiv_H = Math.round((pMailPreWidthH / CurrenWidth) * 100);
            g_bPrevShow = true;
            if (p_ListorderValue != "SENT" && p_ListorderValue != "SUBJECT" && p_ListorderValue != "RECEIV") {
                if (pMailListWidthH <= parseInt(CurrenWidth * 0.40)) {
                    if (g_foldertype != "sent") {
                        if (p_HeaderViewXML.indexOf("viewXMLFile1.xml") > 0) {
                            p_HeaderViewXML = "Controls_cross/" + g_userLang + "/viewXMLFile1_1.xml";
                            var HeaderObject = document.getElementById("MailHeader");
                            var ContentObject = document.getElementById("MailList");
                            HeaderIni(HeaderObject);
                            GetListInfo(HeaderObject, ContentObject);
                        }
                    }
                }
            }
        }
        MailOptionHidden();
        PreviewMode_ChangeBtn();
        isPreviewChange = false;
        if (g_bPrevShow)
            prevShow();
    } catch (e) { }
}
function Window_resize() {
    try {
        if (!isPreviewChange) {

            if (parseInt(document.documentElement.clientWidth) < 1000) {
                document.getElementById("PreViewleft").style.display = "none";
                if(pPreviewShow_HOW == "H")
                    pPreviewShow_HOW = "W";
                PreviewMode_ChangeBtn();
            }
            else {
                document.getElementById("PreViewleft").style.display = "";
            }

            if (pPreviewShow_HOW == "W") {
                if (pMailListDiv == 0 || pMailPreVDiv == 0) {
                    pMailListDiv = 50; pMailPreVDiv = 50;
                }
                document.getElementById("MailListRayer").style.display = "inline-block";
                document.getElementById("PreviewRayerW").style.display = "block";
                document.getElementById("PreviewRayerH").style.display = "none";

                CurrenWidth = document.documentElement.clientWidth - 10;
                CurrentHeight = document.documentElement.clientHeight - 110 - (document.getElementById("mainmenu").clientHeight - 28);
                document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
                document.getElementById("ResizeBarW").style.width = (CurrenWidth + 10) + "px";
                pMailListHeightW = parseInt(CurrentHeight * (pMailListDiv / 100));
                pMailPreHeightW = parseInt(CurrentHeight * (pMailPreVDiv / 100));
                document.getElementById("MailListRayer").style.width = "100%";
                document.getElementById("PreviewRayerW").style.width = "100%";
                document.getElementById("MailListRayer").style.height = pMailListHeightW + "px";
                if (navigator.userAgent.indexOf('Firefox') != -1)
                    document.getElementById("contentlist").style.height = (pMailListHeightW - 70) + "px";
                else
                    document.getElementById("contentlist").style.height = (pMailListHeightW - 70) + "px";
                document.getElementById("PreviewRayerW").style.height = pMailPreHeightW + "px";
                document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 100) + "px";
                pMailListDiv = Math.round((pMailListHeightW / CurrentHeight) * 100);
                pMailPreVDiv = Math.round((pMailPreHeightW / CurrentHeight) * 100);
            }
            else if (pPreviewShow_HOW == "H") {
                if (pMailListDiv_H == 0 || pMailPreVDiv_H == 0) {
                    pMailListDiv_H = 50; pMailPreVDiv_H = 50;
                }
                document.getElementById("MailListRayer").style.display = "inline-block";
                document.getElementById("PreviewRayerW").style.display = "none";
                document.getElementById("PreviewRayerH").style.display = "inline-block";

                CurrenWidth = document.documentElement.clientWidth - 20;
                CurrentHeight = document.documentElement.clientHeight - 110 - (document.getElementById("mainmenu").clientHeight - 28);
                pMailListWidthH = parseInt(CurrenWidth * (pMailListDiv_H / 100));
                pMailPreWidthH = parseInt(CurrenWidth * (pMailPreVDiv_H / 100)) - 3;

                if (pMailListWidthH <= parseInt(CurrenWidth * 0.40)) {
                    var ChangeListWidthDiv = parseInt(CurrenWidth * 0.40) - pMailListWidthH;
                    pMailListWidthH = parseInt(CurrenWidth * 0.40);
                    pMailPreWidthH = pMailPreWidthH - ChangeListWidthDiv;
                }
                document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
                document.getElementById("ResizeBarW").style.width = CurrenWidth + "px";
                document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
                document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
                document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
                if (navigator.userAgent.indexOf('Firefox') != -1)
                    document.getElementById("contentlist").style.height = (CurrentHeight - 70) + "px";
                else
                    document.getElementById("contentlist").style.height = (CurrentHeight - 70) + "px";
                document.getElementById("PreviewRayerH").style.width = pMailPreWidthH + "px";
                document.getElementById("PreContent_RayerH").style.width = pMailPreWidthH - 5 + "px";
                document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 88) + "px";
                pMailListDiv_H = Math.round((pMailListWidthH / CurrenWidth) * 100);
                pMailPreVDiv_H = Math.round((pMailPreWidthH / CurrenWidth) * 100);
            }
            else if (pPreviewShow_HOW == "OFF") {
                document.getElementById("PreviewRayerW").style.display = "none";
                document.getElementById("PreviewRayerH").style.display = "none";
                CurrentHeight = document.documentElement.clientHeight - 110 - (document.getElementById("mainmenu").clientHeight - 28);
                document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
                document.getElementById("MailListRayer").style.width = "100%";
                if (navigator.userAgent.indexOf('Firefox') != -1)
                    document.getElementById("contentlist").style.height = (CurrentHeight - 70) + "px";
                else
                    document.getElementById("contentlist").style.height = (CurrentHeight - 70) + "px";
            }
        }            
    } catch (e) { }
}
function CustomRandom() {
    var now = new Date();
    var seed = now.getMilliseconds();
    return Math.random(seed) + 1;
}
function s4() {
    return ((CustomRandom() * 0x10000) | 0).toString(16).substring(1);
};

var ReadMailOpenNewWin;
function callMsgDlg(szContentClass, Href) {
    if (szContentClass == "IPM.Appointment") {
        var xmlHTTP = createXMLHttpRequest();
        var xmlDoc = createXmlDom();
        var rootNode;
        createNodeInsert(xmlDoc, rootNode, "DATA");
        createNodeAndInsertText(xmlDoc, rootNode, "ITEMID", Href);
        xmlHTTP.open("POST", "/myoffice/ezEmail/remote/mail_convertid.aspx", false);
        xmlHTTP.send(xmlDoc);
        var scheduleid = "";
        if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
            scheduleid = xmlHTTP.responseText;
        }
        var feature = "height = 660px, width = 770px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
        feature = feature + GetOpenPosition(770, 660);
        window.open("/myoffice/ezSchedule/schedule_read_Cross.aspx?id=" + encodeURIComponent(scheduleid), "",
                feature);
        return;
    }
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var conWidth = pwidth * 0.8;
    if (conWidth > 890)
        conWidth = 890;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - 890) / 2;
    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
    if (!g_bdraft) {
        var pURI;
        pURI = "/ezEmail/mailRead.do?iptURL=" + encodeURIComponent(Href) + "&PNFlag=Y&CONTENTCLASS=" + encodeURIComponent(szContentClass);            
        ReadMailOpenNewWin = window.open(pURI, "", feature);
        
        if (ReadMailOpenNewWin != null) {
        	ReadMailOpenNewWin.focus();
        }
    }
    else {
    	
    	ReadMailOpenNewWin = window.open("/ezEmail/mailWrite.do?cmd=EDIT&URL=" + encodeURIComponent(Href), "", feature);
        /*if (CrossYN() || pNoneActiveX == "YES")
            ReadMailOpenNewWin = window.open("mail_write_Cross.aspx?cmd=EDIT&URL=" + encodeURIComponent(Href), "", feature);
        else
        {
            if(pUse_Editor == "")
                ReadMailOpenNewWin = window.open("mail_write_Cross.aspx?cmd=EDIT&URL=" + encodeURIComponent(Href), "", feature);
            else
                ReadMailOpenNewWin = window.open("mail_write_Cross.aspx?cmd=EDIT&URL=" + encodeURIComponent(Href), "", feature);
        }*/
    	
    	if (ReadMailOpenNewWin != null) {
        	ReadMailOpenNewWin.focus();
        }
    }
}

var PcSaveArrayList = new Array();
function mail_export() {
    if (listContentArry.length == 0 && listSubContentArry.length == 0) {
        alert(strLang42);
        return;
    }
    else {
        PcSaveArrayList = new Array();
        for (var i = 0; i < listContentArry.length; i++) {
            PcSaveArrayList[PcSaveArrayList.length] = document.getElementById(listContentArry[i]);
        }
        for (var i = 0; i < listSubContentArry.length; i++) {
            PcSaveArrayList[PcSaveArrayList.length] = document.getElementById(listSubContentArry[i]);
        }
    }
    if(PcSaveArrayList.length > 0)
        PCMultiDownload();
}
var suffix = 0;
function PCMultiDownload() {
    if (suffix < PcSaveArrayList.length)
        setTimeout(function () { PC_Eml_FileDownload();}, 1000);
    else {
        suffix = 0;
        return;
    }
}
function PC_Eml_FileDownload() {
    if (PcSaveArrayList[suffix].getAttribute("_href") != null) {
        var tmp = PcSaveArrayList[suffix].outerHTML.replaceAll('&nbsp', ' ');
        tmp = tmp.substring(tmp.indexOf('_subject=\"'), tmp.length - 1);
        tmp = tmp.replaceAll("_subject=\"", "");
        tmp = tmp.substring(0, tmp.indexOf('\"'));
        var pItemID = PcSaveArrayList[suffix].getAttribute("_href");
        if (tmp.indexOf("&lt;br/&gt;&lt;span id='_mailpreview'") != -1) // 추가 (safari)
            tmp = tmp.substring(0, tmp.indexOf("&lt;br/&gt;&lt;span id='_mailpreview'"));
        var pItemSubject = tmp + ".eml";
        var fullpath = "/ezEmail/mailExport.do?url=" + encodeURIComponent(pItemID) + "&filename=" + encodeURIComponent(pItemSubject);
        AttachDownFrame.location.href = fullpath;
        AttachDownFrame.target = "_blank"
        suffix++;
        PCMultiDownload();
    }
    else {
        suffix = 0;
        return;
    }
}
function HiddenContextMenu() {
    document.getElementById("mailPanel").style.display = "none";
    document.getElementById("ContextMenuDiv").style.display = "none";
}
function ContextMenuHidden() {
    if (document.getElementById("ContextMenuDiv").style.display == "")
        HiddenContextMenu();
}
function PopUpPreMail() {
    
    var CurrentObject;
    var isMainlist = false;
    if (_RowObject != null) {
        CurrentObject = _RowObject;
        isMainlist = true;
    }
    else {
        CurrentObject = _SubRowObject;
        isMainlist = false;
    }
    if (isMainlist) {
        var isCurrentCnt = parseInt(CurrentObject.getAttribute("id").replace("Maillist_", ""));
        var ContentObject = document.getElementById("MailList");
        var CurrentPageSize = ContentObject.getAttribute("listpagecount")
        var CurrentPage = ContentObject.getAttribute("curpage")
        var CurrentMaxPage = ContentObject.getAttribute("maxpage")
        if (CurrentPage == 1 && isCurrentCnt == 0) {
            return "PREEND";
        }
        else if (CurrentPage != 1 && isCurrentCnt == 0) {
            var pageNum = parseInt(CurrentPage) - 1;
            goToPageByNum(pageNum);
            setTimeout(function () { PagingMove(CurrentPageSize, true); }, 1000);
            return "PREMOVE";
        }
        else {
            var preCurrentCnt = isCurrentCnt -1;
            var preCurrentObject = document.getElementById("Maillist_" + preCurrentCnt);
            _RowObject = preCurrentObject;
            callMsgDlg(preCurrentObject.getAttribute("_contentclass"), preCurrentObject.getAttribute("_href"));
        }
    }
    else {
        var isCurrentCnt = parseInt(CurrentObject.getAttribute("id").replace("Maillist_", ""));
        var ContentObject = document.getElementById("GroupSubList");
        if (isCurrentCnt == 0) {
            return "PREEND";
        }
        else {
            var preCurrentCnt = isCurrentCnt - 1;
            var preCurrentObject = document.getElementById("Maillist_" + preCurrentCnt);
            _SubRowObject = preCurrentObject;
            callMsgDlg(preCurrentObject.getAttribute("_contentclass"), preCurrentObject.getAttribute("_href"));
        }
    }
}
function PagingMove(CurrentPageSize) {
    var preCurrentCnt;
    if (CurrentPageSize != 0)
        preCurrentCnt = CurrentPageSize - 1;
    else
        preCurrentCnt = 0;
    ;
    var preCurrentObject = document.getElementById("Maillist_" + preCurrentCnt);
    _RowObject = preCurrentObject;
    callMsgDlg(preCurrentObject.getAttribute("_contentclass"), preCurrentObject.getAttribute("_href"));
}
function PopUpNextMail() {
    var CurrentObject;
    var isMainlist = false;
    if (_RowObject != null) {
        CurrentObject = _RowObject;
        isMainlist = true;
    }
    else {
        CurrentObject = _SubRowObject;
        isMainlist = false;
    }
    if (isMainlist) {
        var isCurrentCnt = parseInt(CurrentObject.getAttribute("id").replace("Maillist_", ""));
        var ContentObject = document.getElementById("MailList");
        var CurrentPageSize = ContentObject.getAttribute("listpagecount")
        var CurrentPage = ContentObject.getAttribute("curpage")
        var CurrentMaxPage = ContentObject.getAttribute("maxpage")
        var CurrentMaxCount = ContentObject.getAttribute("MaxCount");
        if (CurrentPage == CurrentMaxPage && isCurrentCnt == (CurrentMaxCount  - ((CurrentMaxPage - 1) * CurrentPageSize))-1) {
            return "NEXTEND";
        }
        else if (CurrentPage != CurrentMaxPage && isCurrentCnt == (CurrentPageSize - 1)) {
            var pageNum = parseInt(CurrentPage) +1;
            goToPageByNum(pageNum);
            setTimeout(function () { PagingMove(0); }, 1000);
            return "NEXTMOVE";
        }
        else {
            var preCurrentCnt = isCurrentCnt + 1;
            var preCurrentObject = document.getElementById("Maillist_" + preCurrentCnt);
            _RowObject = preCurrentObject;
            callMsgDlg(preCurrentObject.getAttribute("_contentclass"), preCurrentObject.getAttribute("_href"));
        }
    }
    else {
        var isCurrentCnt = parseInt(CurrentObject.getAttribute("id").replace("Maillist_", ""));
        var ContentObject = document.getElementById("GroupSubList");
        var CurrentMaxCount = ContentObject.getAttribute("MaxCount");
        if (isCurrentCnt == (CurrentMaxCount-1)) {
            return "NEXTEND";
        }
        else {
            var preCurrentCnt = isCurrentCnt + 1;
            var preCurrentObject = document.getElementById("Maillist_" + preCurrentCnt);
            _SubRowObject = preCurrentObject;
            callMsgDlg(preCurrentObject.getAttribute("_contentclass"), preCurrentObject.getAttribute("_href"));
        }
    }
}

function event_flag(obj) {
    var temp_listContentArry = listContentArry;
    listContentArry = [GetAttribute(obj.parentElement, "id")];
    toggle_flag();
    listContentArry = temp_listContentArry;
}

var flagXmlHttp;
function toggle_flag() {
    if (listContentArry.length == 0 && listSubContentArry.length == 0) {
        alert(strLang311);
        return;
    }
    var pSelectItem;
    if (listContentArry.length > 0) {
        if (listContentArry.length > 1) {
            pSelectItem = "";
            for (var i = 1; i <= listContentArry.length; i++) {
                pSelectItem += document.getElementById(listContentArry[listContentArry.length - i]).getAttribute("_href") + ";";
            }
        }
        else
            pSelectItem = document.getElementById(listContentArry[listContentArry.length - 1]).getAttribute("_href") + ";";
    }
    else {
        pSelectItem = document.getElementById(listSubContentArry[listSubContentArry.length - 1])
    }
    var now = new Date();
    now.setDate(now.getDate() + 1);

    var month = parseInt(now.getMonth()) + 1;
    var pSDate = now.getFullYear() + "-" + month + "-" + now.getDate();
    var pEDate = pSDate;


    flagXmlHttp = createXMLHttpRequest();
    var xmlDom = createXmlDom();


    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "ITEMID", pSelectItem);
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

            MailListRefresh();
        }
    }
}
function cancel_send() {

    if (listContentArry.length == 0 && listSubContentArry.length == 0) {
        return;
    }
    var pSelectItem;
    if (listContentArry.length > 0) {
        pSelectItem = document.getElementById(listContentArry[listContentArry.length - 1])
    }
    else {
        pSelectItem = document.getElementById(listSubContentArry[listSubContentArry.length - 1])
    }

    if (!confirm(strLang143))
        return;

    var xmlDom = createXmlDom();
    g_xmlHttp = createXMLHttpRequest();

    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "URL", pSelectItem.getAttribute("_href"));
    g_xmlHttp.open("POST", "/myoffice/ezEmail/remote/mail_cancelsend.aspx", false);
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
    window.open("/myoffice/ezemail/htm/cancelMessageReport_cross.aspx?num=" + pnum, '', 'height=320,width=730,resizable=yes,scrollbars=no');
}
function ShowMailProgress() {
    document.getElementById("mailPanel").style.display = "";
    document.getElementById("MailProgress").style.top = "400px";
    document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 100 + "px";
    document.getElementById("MailProgress").style.display = "";
}
function HiddenMailProgress() {
    document.getElementById("mailPanel").style.display = "none";
    document.getElementById("MailProgress").style.display = "none";
}
function PreviewMode_ChangeBtn() {
    document.getElementById("PreViewNone").setAttribute("src", "/images/kr/cm/btn_noframe.gif");
    document.getElementById("PreViewBottom").setAttribute("src", "/images/kr/cm/btn_bottomframe.gif");
    document.getElementById("PreViewleft").setAttribute("src", "/images/kr/cm/btn_leftframe.gif");
    if (pPreviewShow_HOW == "H")
        document.getElementById("PreViewleft").setAttribute("src", "/images/kr/cm/btn_onleftframe.gif");
    else if (pPreviewShow_HOW == "W")
        document.getElementById("PreViewBottom").setAttribute("src", "/images/kr/cm/btn_onbottomframe.gif");
    else
        document.getElementById("PreViewNone").setAttribute("src", "/images/kr/cm/btn_onnoframe.gif");

}
function MailOptionView(obj) {
    if (obj.getAttribute("mode") == "off") {
        document.getElementById("layer_popup").style.left = document.documentElement.clientWidth - 260 + "px";
        document.getElementById("layer_popup").style.top = "100px";
        document.getElementById("layer_popup").style.display = "";
        obj.setAttribute("src", "/images/kr/cm/btn_arrow_up.gif");
        obj.setAttribute("mode", "on");
    }
    else {
        MailOptionHidden();
    }
}
function MailOptionHidden() {
    document.getElementById("layer_popup").style.display = "none";
    document.getElementById("maillistoptiondiv").setAttribute("mode", "off");
    document.getElementById("maillistoptiondiv").setAttribute("src", "/images/kr/cm/btn_arrow_down.gif");
}