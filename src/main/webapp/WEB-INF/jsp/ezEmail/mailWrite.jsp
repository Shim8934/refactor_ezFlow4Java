<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title><spring:message code='ezEmail.t660' /></title>
    <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
    <link rel="stylesheet" href="/css/default_kr.css" type="text/css" />
    <script type="text/javascript" src="/js/ezEmail/lang/ezEmail_ko.js"></script>
    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
    <script type="text/javascript" src="/js/mouseeffect.js"></script>
    <script type="text/javascript" src="/js/ezEmail/js_cross/string_component.js"></script>
    <script type="text/javascript" src="/js/ezEmail/js_cross/encode_component.js"></script>
    <script type="text/javascript" src="/js/ezEmail/js_cross/newMail_Cross.js"></script>
    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    <SCRIPT type="text/javascript" src="/js/ezEmail/js_cross/AttachMain_CK.js"></SCRIPT>
    <SCRIPT type="text/javascript" src="/js/ezEmail/js_cross/AttachItem_CK.js"></SCRIPT>
    <script type="text/javascript">
        var g_szAuthor = "";
        var g_szExchange = "exchange";
        var g_cmd = "${cmd}";
        var Org_cmd = "${cmd}";
        var g_servername = document.location.hostname;
        var g_myname = "${userInfo.displayName}";
        var g_myemail = "${userInfo.mail}";
        var g_szUserID = "${userInfo.mailNickName}";
        var g_companyID = "${userInfo.physicalDeliveryOfficeName}";
        var g_senderinfo = "${userInfo.company}" + ", " + "${userInfo.description}" + ", " + "${userInfo.title}";
        var g_eImportance = "${importance}";
        var g_ePostType = "${postType}";
        var g_url = "${url}";
        var g_unread = "${unread}";
        var m_rgParams4PostOption = new Array();
        var g_bDirty = false;
        var m_addrBook = null;
        var g_bSended = false;
        var objMHT;
        var g_SendFrom = "${sendFrom}";
        var g_charset = "utf-8";
        var g_encoding = "BASE64";
        var g_font = "<spring:message code='ezEmail.t409' />";
        var g_showdisplay = "";
        var g_simplemimeencoding = "7bit";
        var g_simplemime = "";
        var g_xmldoc = createXmlDom();
        var useMultiLangMail = "${useMultiLangMail}";
        var g_isFormat = false;
        var g_DisplayNamePrintable = "${displayNamePrintable}";
        var g_showEnglishDisplay = "";
        var g_charsetCheck = "${charsetCheck}";
	    var g_use_ApprovalG = "${userInfoApprovalG}";
        var g_ReSendFlag = "${reSendFlag}";
        var BigSizeAttachMBSize = "${bigSizeMailAttachLimit}";
        var totBigSizeAttachMBSize = "${totBigSizeMailAttachLimit}";
        var totSizeAttachMBSize = "${mailAttachLimit}";
        var BigSizeAttachSize = BigSizeAttachMBSize * 1024 * 1024;
        var totBigSizeAttachSize = totBigSizeAttachMBSize * 1024 * 1024;
        var totSizeAttachSize = totSizeAttachMBSize * 1024 * 1024;
        var FBigSizeAttachSize = parseInt(BigSizeAttachSize);
        var FtotBigSizeAttachSize = parseInt(totBigSizeAttachSize);
        var FtotSizeAttachSize = parseInt(totSizeAttachSize);
        var BigSizeMailAttachDelDay = "${bigSizeMailAttachDelDay}";
        var charsetControlFlag = "${userLang}";
        var userTimezone = "${userTimeset}";
        var isPrimary = "${userPrimary}";
        var initFlag = false;
        var gg_cmd = "${cmdOwn}";
        var gg_url = "${urlOwn}";        
        var g_newid = "${newWindowId}";
        var FileUploadtype = "${fileUploadType}";
        var iseachMail = "false";
        var individualmailuser = "${individualMailUser}";
        var pSecurity = "${pSecurity}";
        var docHref = "${docHref}";
        var isReserve = "NO";
        var pCDOMessageId = "";
        var Add_xmlhttp = "";
        var mailsel = "${mailSignSel}";
        var mailpath = "";
        var fileSize_add = "";
        var fileName_add = "";
        var fileType_add = "";
        var bigtrue = 0;
        var tmpXML = "";
        var tempUrl = "";
        var folderDate = "${folderDate}";
        var filedate = "${stateName}";
        var gubunlist = "1";
        var tempvalue = "0";
        var _pBigAttachDownloadDay = "${pBigAttachDownloadDay}";
        var _pBigAttachDownloadPeriod = "${pBigAttachDownloadPeriod}";
        var ua = navigator.userAgent;
        var InnerDomain = "${mailInnerDomain}";
        var inMailColor = "${inMailColor}";
        var outMailColor = "${outMailColor}";
        var pUse_Editor = "${useEditor}";
        window.onload = function () {

            if (g_unread == "1") {
                try {
                    window.opener.document.Script.refreshUnreadCount()
                } catch (e) { }
            }
            if (pSecurity == "Security") {
                pSecurity = "3";
            }
            if (typeof (document.getElementById("xmpSubject").outerText) != "undefined" && document.getElementById("xmpSubject").outerText != "")
                document.getElementById("eSubject").value = document.getElementById("xmpSubject").outerText;

            eFrom.value = xmpFrom.innerHTML;
            importantSelect.selectedIndex = g_eImportance;
            m_rgParams4PostOption["important"] = g_eImportance;
            m_rgParams4PostOption["postType"] = g_ePostType;
            m_rgParams4PostOption["replySendTime"] = "0";
            m_rgParams4PostOption["replyReadTime"] = "1";
            m_rgParams4PostOption["delaySendDate"] = "";
            m_rgParams4PostOption["showMsgCC"] = true;
            m_rgParams4PostOption["showMsgBCC"] = true;
            m_rgParams4PostOption["tagMsgCC"] = MsgCC_TR;
            m_rgParams4PostOption["tagMsgCCu"] = MsgCC_TRu;
            m_rgParams4PostOption["tagMsgBCC"] = MsgBCC_TR;
            m_rgParams4PostOption["tagMsgBCCu"] = MsgBCC_TRu;
            m_rgParams4PostOption["bodyType"] = "0";
            m_rgParams4PostOption["EachMail"] = iseachMail;
            m_rgParams4PostOption["SecurityMail"] = pSecurity;
            if (xmpTo.innerHTML != "") {
                var splitAddr = getEmailAddressList(xmpTo.innerHTML);
                addReceiverFromList(0, splitAddr);
            }
            if (xmpCc.innerHTML != "") {
                splitAddr = getEmailAddressList(xmpCc.innerHTML);
                addReceiverFromList(1, splitAddr);
            }
            if (xmpBcc.innerHTML != "") {
                splitAddr = getEmailAddressList(xmpBcc.innerHTML);
                addReceiverFromList(2, splitAddr);
            }
            Subject_ReApply();
            g_bDirty = false;
            if (g_charsetCheck == "0") {
                if (confirm("<spring:message code='ezEmail.t665' />")) {
                    location.href = location.href + "&attach=1";
                }
            }
            if ((g_cmd == "FORWARD" || g_cmd == "EDIT" || g_ReSendFlag == "Y") && document.getElementById("AttachXmlList").innerHTML != "") {
                AddAttachFileInfoXmlParsing(document.getElementById("AttachXmlList").innerHTML);
            }
            SelMailSign.value = "${mailSignSel}";

        Simple_Choice();
        var pSaveTime = "${pAutoSaveTime}";
        var pSaveInterval = parseInt(pSaveTime) * 1000;
        if (pSaveInterval > 0)
            window.setInterval("Mail_AutoSave()", pSaveInterval);

        var ua = navigator.userAgent;
        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
            document.getElementById("file1").multiple = false;
        }

        if (document.getElementById("eSubject").value == "")
            document.getElementById("MsgTo").focus();
        }
    var isAutoSave = false;
    var MailStatus = "NO";
    function Mail_AutoSave() {
        if (MailStatus == "NO") {
            isAutoSave = true;
            Save_onClick("tempsave");
        }
    }
    window.onresize = function () {       
        if (document.getElementById("BccViewer").getAttribute("status") == "off") {
            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 400 + "PX";
        }
        else {
            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 460 + "PX";
        }
        message.Editor_Resize();
    }
    function KeEventControl(obj) {
        useragt = navigator.userAgent.toUpperCase();
        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) //사파리 브라우저일 경우
        {
            useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
            if (parseInt(useragt) > 5) {
                return;
            }
        }
        obj.onkeydown = function () {
            if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
                return false;
            if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
                    parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
                    parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
                    parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
                    parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
                return false;
        };
    }
    
    function JSleep(sTime) {
        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open("GET", "remote/userSleep.aspx?time=" + sTime + "&newid=" + g_newid, false);
        xmlhttp.send();
        xmlhttp = null;
    }
    var isClosedSave = false;
    window.onbeforeunload = function () {
        var retVal = "";
        if (retVal != "0" && g_url != "" && ("${folderPath}" != "Draft" && g_cmd != "EDIT")) {
            if (!isDelted)
                delDrafts();
        }
    }
    var mail_message_cross_dialogArguments = new Array();
    function window_close() {
        var retVal = "";
        var g_filelist = "";
        if ((g_bDirty || g_originalHTML != message.GetEditorContent() || g_filelist != "") && g_saveHttp == null) {
            mail_message_cross_dialogArguments[1] = window_close_Complete;
            var pUrl = "mail_message_cross.aspx?CAPTION=" + encodeURI("<spring:message code='ezEmail.t666' />") + "&MESSAGE=" + encodeURI("<spring:message code='ezEmail.t667' />") + "&BUTTONNAMES=" + encodeURI("<spring:message code='ezEmail.t671' />");
            DivPopUpShow(330, 205, pUrl);
        }
        window_close_Complete("");
    }
    function window_close_Complete(retVal) {
        DivPopUpHidden();
        if (retVal == "0") {
            isClosedSave = true;
            Save_onClick("tempsave");
            window.close();
        }
        g_bDirty = false;
        var LoopCnt = 0;
        while (g_saveHttp != null) {
            JSleep(500);
            if (LoopCnt > 10) {
                break;
            }
            LoopCnt++;
        }
        if (retVal != "0" && g_url != "" && ("${folderPath}" != "Draft" && g_cmd != "EDIT")) {
            delDrafts();
        }
        if (retVal != "2")
            window.close();
    }
    var isDelted = false;
    function delDrafts() {
        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open("GET", "/ezEmail/delDrafts.do?itemid=" + encodeURIComponent(g_url), false);
        xmlhttp.send();
        xmlhttp = null;
        isDelted = true;
    }
    var PrintEvent = false;
    function Print_onClick() {
        PrintEvent = true;
        document.getElementById("test").innerHTML = message.GetEditorContent();
        var obj = document.getElementById("frmPrint");
        var objDoc = obj.contentWindow || obj.contentDocument;
        objDoc.btnPrint_onClick();
    }
    var mail_formatlist_cross_dialogArguments = new Array();
    function LoadFormat_onClick() {
        mail_formatlist_cross_dialogArguments[1] = LoadFormat_onClick_Complete;
        mail_formatlist_cross_dialogArguments[2] = DivPopUpHidden;
        DivPopUpShow(460, 467, "mail_FormatList_cross.aspx");
    }
    function LoadFormat_onClick_Complete(strFileName) {
        DivPopUpHidden();
        if (typeof (strFileName) == "undefined")
            return;
        var fullPath = "/Email_Formats/" + strFileName;
        var xmpMailSign = "";
        try {
            xmpMailSign = message.CKEDITOR.instances.editor1.document.$.getElementById('MailSign').outerHTML;
        } catch (e) {
        }
        message.SetEditorContentURL_Format(fullPath);
        message.SetEditorContent(message.CKEDITOR.instances.editor1.document.$.body.innerHTML + xmpMailSign);
    }
    function ReplaceText(orgStr, findStr, replaceStr) {
        var re = new RegExp(findStr, "gi");
        return (orgStr.replace(re, replaceStr));
    }
    function RenderFontStyleSet(BodyHtml) {
        return "<span><P>&nbsp;</P><P>&nbsp;</P>" + BodyHtml + "</span>"
    }
    function Rebody() {
        try {
            if (message.CKEDITOR.instances.editor1.document.$.body.getAttribute(("KP_YGubun"), 0) == null) {
                message.SetEditorContent("<DIV style='LINE-HEIGHT: 15pt' ><br /><br /><DIV id='MailSign'></div><br /></DIV>");
            }
        } catch (e) { }
        if (document.getElementById("bodyValue").innerHTML != "") {
            switch (mailsel) {

                case "0": message.SetEditorContent(RenderFontStyleSet(document.getElementById("bodyValue").innerHTML));
                    break;
                case "1": message.SetEditorContent(document.getElementById("xmpMailSign1").innerHTML + RenderFontStyleSet(document.getElementById("bodyValue").innerHTML));
                    tempvalue = "1";
                    break;
                case "2": message.SetEditorContent(document.getElementById("xmpMailSign2").innerHTML + RenderFontStyleSet(document.getElementById("bodyValue").innerHTML));
                    tempvalue = "1";
                    break;
                case "3": message.SetEditorContent(document.getElementById("xmpMailSign3").innerHTML + RenderFontStyleSet(document.getElementById("bodyValue").innerHTML));
                    tempvalue = "1";
                    break;
            }
        }
        else if (document.getElementById("tempbody").innerHTML != "") {
            switch (mailsel) {

                case "0": message.SetEditorContent(RenderFontStyleSet(document.getElementById("tempbody").innerHTML));
                    break;
                case "1": message.SetEditorContent(document.getElementById("xmpMailSign1").innerHTML + RenderFontStyleSet(document.getElementById("tempbody").innerHTML));
                    tempvalue = "1";
                    break;
                case "2": message.SetEditorContent(document.getElementById("xmpMailSign2").innerHTML + RenderFontStyleSet(document.getElementById("tempbody").innerHTML));
                    tempvalue = "1";
                    break;
                case "3": message.SetEditorContent(document.getElementById("xmpMailSign3").innerHTML + RenderFontStyleSet(document.getElementById("tempbody").innerHTML));
                    tempvalue = "1";
                    break;
            }
        }
        else {
            switch (mailsel) {

                case "0": message.SetEditorContent(RenderFontStyleSet(document.getElementById("bodyValue").innerHTML));
                    break;
                case "1": message.SetEditorContent(document.getElementById("xmpMailSign1").innerHTML + RenderFontStyleSet(document.getElementById("bodyValue").innerHTML));
                    tempvalue = "1";
                    break;
                case "2": message.SetEditorContent(document.getElementById("xmpMailSign2").innerHTML + RenderFontStyleSet(document.getElementById("bodyValue").innerHTML));
                    tempvalue = "1";
                    break;
                case "3": message.SetEditorContent(document.getElementById("xmpMailSign3").innerHTML + RenderFontStyleSet(document.getElementById("bodyValue").innerHTML));
                    tempvalue = "1";
                    break;
            }

        }
    }

    function MailSignSel() {
        var sign = "";
        var signcom = "";
        try {
            var fields = message.GetFieldsList();
            if (fields == "") {
                message.SetEditorContent("<DIV style='LINE-HEIGHT: 15pt' ><br /><DIV id='MailSign'></div><br /></DIV><br/>" + message.GetEditorContent());
            }
            else {
                message.SetEditorContent(message.GetEditorHtml() + "<DIV style='LINE-HEIGHT: 15pt' ><br /><DIV id='MailSign'></div><br /></DIV><br/>");
            }
        } catch (e) { }
        switch (SelMailSign.value) {
            case "0":
                sign = "";
                signcom = "";
                break;
            case "1":
                if (navigator.userAgent.indexOf('Firefox') != -1) {
                    sign = document.getElementById("xmpMailSign1").innerHTML;
                }
                else {
                    sign = document.getElementById("xmpMailSign1").innerText;
                }
                break;
            case "2":
                if (navigator.userAgent.indexOf('Firefox') != -1) {
                    sign = document.getElementById("xmpMailSign2").innerHTML;
                }
                else {
                    sign = document.getElementById("xmpMailSign2").innerText;
                }
                break;
            case "3":
                if (navigator.userAgent.indexOf('Firefox') != -1) {
                    sign = document.getElementById("xmpMailSign3").innerHTML;
                }
                else {
                    sign = document.getElementById("xmpMailSign3").innerText;
                }
                break;
        }
        var fields = message.GetFieldsList();
        var signValue = message.GetListItem(fields, "MailSign");
        signValue.innerHTML = sign;
    }

    function MailSignLoad() {
        SelMailSign.value = "${mailSignSel}";
        MailSignSel();
    }

    function setEachMail() {
        if (chkeachmail.checked) {
            iseachMail = "true";
        }
        else {
            iseachMail = "false";
        }

        m_rgParams4PostOption["EachMail"] = iseachMail;
    }

    function new_Address() {
        var type = "config";
        var receiverData = new Array();
        receiverData["window"] = this;
        mail_newreceiverchoose_dialogArguments[0] = receiverData;
        mail_newreceiverchoose_dialogArguments[1] = new_Address_Complete;
        var OpenWin = window.open("mail_NewreceiverChoose.aspx?defaultwin=&type=" + type, "mail_foldermanage_Cross", GetOpenWindowfeature(970, 655));
        try { OpenWin.focus(); } catch (e) { }
    }

    function new_Address_Complete() {
        Simple_Choice();
    }

    function Simple_Choice() {
        document.getElementById("SelectToAddress").innerHTML = "";
        document.getElementById("SelectCcAddress").innerHTML = "";
        document.getElementById("SelectBCCAddress").innerHTML = "";
        newoption1 = new Option(strLang199, strLang199);
        CCnewoption1 = new Option(strLang199, strLang199);
        BCCnewoption1 = new Option(strLang199, strLang199);
        document.getElementById("SelectToAddress").options[0] = newoption1;
        document.getElementById("SelectToAddress").options[0].selected = true;
        document.getElementById("SelectCcAddress").options[0] = CCnewoption1;
        document.getElementById("SelectCcAddress").options[0].selected = true;
        document.getElementById("SelectBCCAddress").options[0] = BCCnewoption1;
        document.getElementById("SelectBCCAddress").options[0].selected = true;
        Add_xmlhttp = createXMLHttpRequest();
        Add_xmlhttp.open("Post", "/myoffice/ezEmail/remote/mail_get_address.aspx", true);
        Add_xmlhttp.onreadystatechange = Simple_Choice_complete;
        Add_xmlhttp.send("");
    }

    function Simple_Choice_complete() {
        try {
            var gubunGount = 1;
            if (Add_xmlhttp == null || Add_xmlhttp.readyState != 4)
                return;
            if (Add_xmlhttp.status >= 200 && Add_xmlhttp.status < 300) {
                if (navigator.userAgent.indexOf("MSIE") != -1) {
                    var xmlDom = loadXMLString(Add_xmlhttp.responseText);
                    var objNodes = xmlDom.selectNodes("NewDataSet/Table");
                    for (var count = 0; count < objNodes.length; count++) {
                        lastindex = document.all("SelectToAddress").length;
                        newoption = new Option(objNodes(count).selectSingleNode("NAME").text, objNodes(count).selectSingleNode("NAME").text + ";" + objNodes(count).selectSingleNode("EMAIL").text);
                        CCnewoption = new Option(objNodes(count).selectSingleNode("NAME").text, objNodes(count).selectSingleNode("NAME").text + ";" + objNodes(count).selectSingleNode("EMAIL").text);
                        BCCnewoption = new Option(objNodes(count).selectSingleNode("NAME").text, objNodes(count).selectSingleNode("NAME").text + ";" + objNodes(count).selectSingleNode("EMAIL").text);
                        document.getElementById("SelectToAddress").options[lastindex] = newoption;
                        document.getElementById("SelectCcAddress").options[lastindex] = CCnewoption;
                        document.getElementById("SelectBCCAddress").options[lastindex] = BCCnewoption;
                    }
                }
                else if (navigator.userAgent.indexOf("MSIE") == -1) {
                    var xmlDom = loadXMLString(Add_xmlhttp.responseText);
                    var Nodeslength = xmlDom.childNodes.item(0).childElementCount;
                    for (var count = 0; count < Nodeslength; count++) {
                        //lastindex = document.all("SelectToAddress").length;
                        lastindex = document.getElementById("SelectToAddress").childNodes.length;
                        if (gubunGount == 1) {
                            newoption = new Option(xmlDom.childNodes.item(0).childNodes.item(gubunGount).childNodes.item(1).textContent, xmlDom.childNodes.item(0).childNodes.item(gubunGount).childNodes.item(1).textContent + ";" + xmlDom.childNodes.item(0).childNodes.item(gubunGount).childNodes.item(3).textContent);
                            CCnewoption = new Option(xmlDom.childNodes.item(0).childNodes.item(gubunGount).childNodes.item(1).textContent, xmlDom.childNodes.item(0).childNodes.item(gubunGount).childNodes.item(1).textContent + ";" + xmlDom.childNodes.item(0).childNodes.item(gubunGount).childNodes.item(3).textContent);
                            BCCnewoption = new Option(xmlDom.childNodes.item(0).childNodes.item(gubunGount).childNodes.item(1).textContent, xmlDom.childNodes.item(0).childNodes.item(gubunGount).childNodes.item(1).textContent + ";" + xmlDom.childNodes.item(0).childNodes.item(gubunGount).childNodes.item(3).textContent);
                        }
                        else {
                            newoption = new Option(xmlDom.childNodes.item(0).childNodes.item(gubunGount).childNodes.item(1).textContent, xmlDom.childNodes.item(0).childNodes.item(gubunGount).childNodes.item(1).textContent + ";" + xmlDom.childNodes.item(0).childNodes.item(gubunGount).childNodes.item(3).textContent);
                            CCnewoption = new Option(xmlDom.childNodes.item(0).childNodes.item(gubunGount).childNodes.item(1).textContent, xmlDom.childNodes.item(0).childNodes.item(gubunGount).childNodes.item(1).textContent + ";" + xmlDom.childNodes.item(0).childNodes.item(gubunGount).childNodes.item(3).textContent);
                            BCCnewoption = new Option(xmlDom.childNodes.item(0).childNodes.item(gubunGount).childNodes.item(1).textContent, xmlDom.childNodes.item(0).childNodes.item(gubunGount).childNodes.item(1).textContent + ";" + xmlDom.childNodes.item(0).childNodes.item(gubunGount).childNodes.item(3).textContent);
                        }

                        gubunGount = gubunGount + 2;
                        document.getElementById("SelectToAddress").options[lastindex] = newoption;
                        document.getElementById("SelectCcAddress").options[lastindex] = CCnewoption;
                        document.getElementById("SelectBCCAddress").options[lastindex] = BCCnewoption;
                    }
                }
            }
        }
        catch (e) {
            alert(e.message);
        }
        Add_xmlhttp = null;
    }

    function simple_select(Type, obj) {
        switch (Type) {
            case "TO":
                SimpleEmailAddress(SelectToAddress.value, MsgToGot, 0);
                break;
            case "CC":
                SimpleEmailAddress(SelectCcAddress.value, MsgCCGot, 1);
                break;
            case "BCC":
                SimpleEmailAddress(SelectBCCAddress.value, MsgBCCGot, 2);
                break;
            default:
                break;
        }
        obj.item(0).selected = true;
    }

    function SimpleEmailAddress(formName, validDIV, iType) {
        if (formName != "") {
            var mailArr = String(formName).split(";");
            var mailName = ReplaceText(mailArr[0], " ", "");
            var pemail = ReplaceText(mailArr[1], " ", "");
            var newElem;
            newElem = PrepareMailTag(iType, "email", mailName, pemail, "");
            var IsInsert = CheckMailReceiver(newElem);

            if (!IsInsert) {
                switch (iType) {
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
            formName = "";
            g_bDirty = true;
        }
        return true;
    }

    function returnvalue(strXML) {
        pAttachXml = loadXMLString(strXML);
        var nodes = SelectNodes(pAttachXml, "ROOT/NODES/NODE");
        for (i = 0; i < nodes.length; i++) {
            if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") {
                if (getNodeText(GetChildNodes(nodes[i])[3]) == 0)       //filesize
                {
                    alert(strLang89); return;
                }
            }
            else if (getNodeText(GetChildNodes(nodes[i])[1]) == "overflow") {
                alert(strLang168 + AttachLimit + "MB" + strLang169);
                return;
            }
            else if (getNodeText(GetChildNodes(nodes[i])[1]) == "denied") {
                alert(strLang323);
            }
            else {
                alert(filename + strLang85 + "\n\n" + result);
            }
        }
        AttachFileInfo(strXML);
    }

    function FileUpdateAfter(strXML) {
        tempXML = strXML;
        pAttachXml = loadXMLString(strXML);
        var nodes = SelectNodes(pAttachXml, "ROOT/NODES/NODE");
        var xmlDoc = createXmlDom();
        var objNode;
        var objRow;
        var objRows;
        var objRowRow;
        objNode = createNodeInsert(xmlDoc, objNode, "DATA");
        createNodeAndInsertText(xmlDoc, objNode, "CMD", "ADD");
        createNodeAndInsertText(xmlDoc, objNode, "URL", g_url);
        objRow = createNodeAndAppandNode(xmlDoc, objNode, objRow, "FILELIST");
        for (var i = 0; i < nodes.length; i++) {
            if (getNodeText(GetChildNodes(nodes[i])[1]) != "denied") {
                objRows = createNodeAndAppandNode(xmlDoc, objRow, objRows, "FILE");
                createNodeAndAppandNodeText(xmlDoc, objRows, objRowRow, "NAME", getNodeText(GetChildNodes(nodes[i])[2]));
                createNodeAndAppandNodeText(xmlDoc, objRows, objRowRow, "PATH", getNodeText(GetChildNodes(nodes[i])[4]));
                createNodeAndAppandNodeText(xmlDoc, objRows, objRowRow, "BIG", getNodeText(GetChildNodes(nodes[i])[5]));
                createNodeAndAppandNodeText(xmlDoc, objRows, objRowRow, "SIZE", getNodeText(GetChildNodes(nodes[i])[3]));
                createNodeAndAppandNodeText(xmlDoc, objRows, objRowRow, "ITEMID", "Y");
            }
        }
        xmlhttp = createXMLHttpRequest();
        xmlhttp.open("POST", "/ezEmail/mailInterAttachCK.do", false);
        xmlhttp.send(xmlDoc);
        var aitem;
        var xmlReturnValue = createXmlDom();
        var objNode;
        var objRow;
        var objRows;
        objNode = createNodeInsert(xmlReturnValue, objNode, "DATA");
        if (xmlhttp.status == "200") {
            xmlDoc = loadXMLString(xmlhttp.responseText);

            if (CrossYN())
                g_url = xmlDoc.getElementsByTagName("URL").item(0).textContent;
            else
                g_url = xmlDoc.getElementsByTagName("URL").item(0).text;
            var filelist = SelectNodes(xmlDoc, "DATA/FILELIST/FILE");
            for (var i = 0; i < filelist.length; i++) {
                filename = SelectSingleNodeValue(filelist[i], "NAME");
                path = SelectSingleNodeValue(filelist[i], "PATH");
                big_yn = SelectSingleNodeValue(filelist[i], "BIG");
                size = SelectSingleNodeValue(filelist[i], "SIZE");
                attid = SelectSingleNodeValue(filelist[i], "ITEMID");
                aitem = document.location.protocol + "//" + document.location.hostname + "/myoffice/ezEmail/remote/mail_ReadAttach_Ews.aspx?mode=Attach&ID=" + encodeURI(g_url) + "&ATTID=" + encodeURI(attid);
                if (big_yn == "Y") {
                    bigtrue = bigtrue + 1;
                    aitem = document.location.protocol + "//" + document.location.hostname + "/Common/DownloadAttach_Common.aspx?fileid=" + encodeURI(path) + "&filedate=" + encodeURI(attid.split('\\')[0]);
                }
                else {
                    aitem = document.location.protocol + "//" + document.location.hostname + "/myoffice/ezEmail/remote/mail_ReadAttach_Ews.aspx?mode=Attach&ID=" + encodeURI(g_url) + "&ATTID=" + encodeURI(attid);
                }
                objRows = createNodeAndAppandNode(xmlReturnValue, objNode, objRows, "ROW");
                createNodeAndAppandNodeText(xmlReturnValue, objRows, objRow, "FILEPATH", path);
                createNodeAndAppandNodeText(xmlReturnValue, objRows, objRow, "URL", aitem);
                createNodeAndAppandNodeText(xmlReturnValue, objRows, objRow, "BIG", big_yn);
                createNodeAndAppandNodeText(xmlReturnValue, objRows, objRow, "ITEMID", attid);
            }
        }
        else {
            alert(xmlhttp.status + " : " + strLang241);
        }
        return xmlReturnValue;
    }

    var pOrgAttachListXml = "";
    function Editor_Complete() {
        if (initFlag == false) {
            if (Org_cmd == "board") {
                GetBoardItemInfo_New("${boardID}", "${itemID}", "${retransType}");
            }
            else if (Org_cmd == "Community") {
                GetBoardItemInfo_New3("${boardID}", "${itemID}");
            }
            else if (Org_cmd == "report") {
                GetUpmooItemInfo_New("${itemID}", "${docHref}")
            }
            else if (Org_cmd == "docsend" || Org_cmd == "docsenddoc")
                GetDocumentInfo("${docID}", "${docHref}", "${docImagCnt}", "${docTarget}");
            initFlag = true;
            pOrgAttachListXml = pAttachListXml;
        }
        Rebody();
    }

    function btn_AttachSelect_onclick() {
        document.getElementById('mode').value = "ATT";
        document.form.file1.click();
    }

    function FieldsAvailable() {
    }

    var GroupplusImg = "/images/ImgIcon/groupplus.gif";
    var GroupminImg = "/images/ImgIcon/groupmin.gif";
    function MailBCCView(obj) {
        if (obj.getAttribute("status") == "off") {
            obj.childNodes.item(1).src = GroupminImg;
            document.getElementById("MsgBCC_TRu").style.display = "";
            document.getElementById("MsgBCC_TR").style.display = "";
            obj.setAttribute("status", "on");
        }
        else {
            obj.childNodes.item(1).src = GroupplusImg;
            document.getElementById("MsgBCC_TRu").style.display = "none";
            document.getElementById("MsgBCC_TR").style.display = "none";
            obj.setAttribute("status", "off");
        }
        if (document.getElementById("BccViewer").getAttribute("status") == "off") {
            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 400 + "PX";
        }
        else {
            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 460 + "PX";
        }
    }

    function ChangeSenderName(obj) {
        if (obj.value != "NONE")
            g_showdisplay = "";
        else
            g_showdisplay = "";
    }

    function shownoti(str) {
        if (str.trim() != "")
            alert(str);
    }

    var DragDropAttachObjetLoading = false;
    function DragObjectComplet() {
        DragDropAttachObjetLoading = true;
        var AttachRows = SelectNodes(pAttachListXml, "LISTVIEWDATA/ROWS/ROW")

        if (AttachRows.length > 0) {
            AppendFileAttachInfo(pAttachListXml);
            dadiframe.fileupload2(pAttachListXml);
        }
    }

    function DownloadAttach(DownloadUrl) {
        AttachDownFrame.location.href = DownloadUrl;
    }

    </script>
</head>
<body id="parentBody" class="popup" style="overflow:hidden;height:98%;">
    <table id="normalScreen" class="layout">
        <tr>
            <td style="height:20px;">
                <div id="menu">
                    <ul>
                        <li><span onclick="Send_onClick()"><spring:message code='ezEmail.t674' /></span></li>
                        <li><span onclick="Save_onClick('tempsave')"><spring:message code='ezEmail.t48' /></span></li>
                        <li  style="display:none"><span onclick="Print_onClick()">
                            <spring:message code='ezEmail.t546' /></span></li>
                        <li><span onclick="LoadFormat_onClick()">
                            <spring:message code='ezEmail.t824' /></span></li>
                        <li><span onclick="NameCertify_onClick()">
                            <spring:message code='ezEmail.t331' /></span></li>
                        <li style="margin-left:5px;"><span onclick="Option_onClick()" id="Span1">
                            <spring:message code='ezEmail.t353' /></span></li>
                        <li class="sel" style="background:none; border:0; padding:4px 0px 0px 0px; cursor:default; color:#fff;">
                            <img src="/images/pbar.gif" ><spring:message code='ezEmail.t359' />&nbsp;</li>
                        <li id="menuTable" class="sel" style="background:none;border:0; padding:4px 0 0 0; margin:0; vertical-align:top;">
                            <select name="importantSelect" id="importantSelect" onchange="important_change()" style="vertical-align:top;">
                                <option>
                                    <spring:message code='ezEmail.t360' /></option>
                                <option selected="selected">
                                    <spring:message code='ezEmail.t361' /></option>
                                <option>
                                    <spring:message code='ezEmail.t362' /></option>
                            </select>
                        </li>
                        <li class="bar"  style="background:none; border:0;padding-left:5px;padding-right:0;cursor:default; display: none;">
                            <img src="/images/pbar.gif"></li>
                        
                        <li class="bar" style="background:none; border:0;padding-left:5px;padding-right:0;padding-top:4px;cursor:default;">
                            <img src="/images/pbar.gif"></li> 
                        <li class="sel" style="background:none; border:none; padding:0px;padding-top:4px;">
                            <select id="SelMailSign" onchange="MailSignSel()" style="vertical-align:top;">
                                <option value='0' selected>
                                    <spring:message code='ezEmail.t825' /></option>
                                <option value='1'>
                                    <spring:message code='ezEmail.t826' /></option>
                                <option value='2'>
                                    <spring:message code='ezEmail.t827' /></option>
                                <option value='3'>
                                    <spring:message code='ezEmail.t828' /></option>
                            </select>
                        </li>
                        <li class="bar" style="background:none; border:0;padding-left:5px;padding-right:0;padding-top:4px;cursor:default;">
                            <img src="/images/pbar.gif"></li> 
                        <li class="sel" style="background:none; border:none; padding:0px;padding-top:4px;">
                            <select style="vertical-align:top;width:120px;" onchange="ChangeSenderName(this);">
                            ${mailSendObject}
                            </select>
                        </li>
                        <li class="bar" style="background: none; border: 0; padding-left: 10px; padding-right: 0; cursor: default; display: none;" nowrap="nowrap">
                                <input type="checkbox" style="display: inline;" id="chkeachmail" onclick="setEachMail()" /><spring:message code='ezEmail.t748' /></li>
                    </ul>
                </div>
                <div id="close">
                    <ul>
                        <li><span onclick="window_close()">
                            <spring:message code='ezEmail.t63' /></span></li>
                    </ul>
                </div>
            </td>
        </tr>
        <tr>
            <td style="height:20px;">
                <table class="popuplist" style="width:100%">
                    <tr id="MsgTo_TR">
                        <th rowspan="2" style="width:1%">
                            <a href="#" class="imgbtn"><span onclick="SelectReceiver_onClick('To')" style="width: 50px; text-align: center;">
                                <spring:message code='ezEmail.t66' /></span></a>
                            <div style="font-weight:normal; "><INPUT id="toMe" onclick="MailToMe_Onclick();" value="" type="checkbox" name="toMe"/>
                            <label for="toMe" style="margin-left:-3px; cursor:pointer" ><spring:message code='ezEmail.t99000010' /></label></div>
                        </th>
                        <td style="width: 76%">
                            <input type="text" name="MsgTo" id="MsgTo" onkeyup="return on_keydown(event)" tabindex="1" style="width: 99%;
                                ime-mode: active;">
                        </td>
                        <td style="width: 1%; border-left: #ffffff 1px solid;">
                            <select id="SelectToAddress" style="width: 100px" onchange="simple_select('TO',this)"
                                runat="server">
                            </select>
                        </td>
                        <td style="width: 1%; border-left: #ffffff 1px solid;">
                            <a class="imgbtn"><span onclick="new_Address()">
                                <spring:message code='ezEmail.t832' /></span></a>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <div id="MsgToGot" style="overflow-y: auto; height: 17px" class="viewtxt"></div>
                        </td>
                    </tr>
                    <tr id="MsgCC_TR">
                        <th rowspan="2">
                            <a href="#" class="imgbtn"><span onclick="SelectReceiver_onClick('CC')" style="width: 50px; text-align: center;"> 
                                <spring:message code='ezEmail.t594' /></span></a>
                            <div onclick="MailBCCView(this);" style="cursor:pointer;" status="off" id="BccViewer">
                            <img src="/images/ImgIcon/groupplus.gif" align="absmiddle"/><span><spring:message code='ezEmail.t562' /></span>
                            </div>
                        </th>
                        <td style="width: 76%">
                            <input type="text" name="MsgCC" id="MsgCC" onkeyup="return on_keydown(event)" tabindex="2" style="width: 99%">
                        </td>
                        <td style="width: 100px; border-left: #ffffff 1px solid;">
                            <select id="SelectCcAddress" style="width: 100px" onchange="simple_select('CC',this)"
                                runat="server">
                            </select>
                        </td>
                        <td style="width: 200px; border-left: #ffffff 1px solid;">
                            <a class="imgbtn"><span onclick="new_Address()">
                                <spring:message code='ezEmail.t832' /></span></a>
                        </td>
                    </tr>
                    <tr id="MsgCC_TRu">
                        <td colspan="3">
                            <div id="MsgCCGot" style="overflow-y: auto; height: 17px" class="viewtxt"></div>
                        </td>
                    </tr>
                    <tr id="MsgBCC_TR"  style="display:none;">
                        <th rowspan="2">
                            <a href="#" class="imgbtn"><span onclick="SelectReceiver_onClick('BCC')" style="width: 60px; text-align: center;">
                                <spring:message code='ezEmail.t562' /></span></a>
                        </th>
                        <td>
                            <input type="text" name="MsgBCC" id="MsgBCC" onkeyup="return on_keydown(event)" tabindex="3" style="width: 99%">
                        </td>
                        <td style="width: 100px; border-left: #ffffff 1px solid;">
                            <select id="SelectBCCAddress" style="width: 100px" onchange="simple_select('BCC',this)"
                                runat="server">
                            </select>
                        </td>
                        <td style="width: 200px; border-left: #ffffff 1px solid;">
                            <a class="imgbtn"><span onclick="new_Address()">
                                <spring:message code='ezEmail.t832' /></span></a>
                        </td>
                    </tr>
                    <tr id="MsgBCC_TRu" style="display:none;">
                        <td colspan="3">
                            <div id="MsgBCCGot" style="overflow-y: auto; height: 17px" class="viewtxt"></div>
                        </td>
                    </tr>
                    <tr>
                        <th style="text-align: center">
                            <spring:message code='ezEmail.t98' />
                        </th>
                        <td colspan="3">
                            <input id="eSubject" name="eSubject" onkeyup="Subject_ReApply()" type="text" value="${encodedSubject}"
                                tabindex="4" style="width: 99%">
                        </td>
                    </tr>
                </table>
                <div id="messageBody" mbody="${body}" style="display: none">
                </div>
                <xmp id="xmpTo" style="display: none">${to}</xmp>
                <xmp id="xmpCc" style="display: none">${cc}</xmp>
                <xmp id="xmpBcc" style="display: none">${bcc}</xmp>
                <xmp id="xmpFrom" style="display: none">${from}</xmp>
                <xmp id="xmpSubject" style="display: none">${subject}</xmp>
                <xmp id="test" style="display: none"></xmp>
                <xmp id="xmpMailSign1" style="display: none">${mailSign1}</xmp>
                <xmp id="xmpMailSign2" style="display: none">${mailSign2}</xmp>
                <xmp id="xmpMailSign3" style="display: none">${mailSign3}</xmp>
                <xmp id="bodyValue" style="display: none">${bodyValue}</xmp>
                <xmp id="tempbody" style="display: none">${tempBody}</xmp>
            </td>
        </tr>
        <tr>
            <td style="height:380px;" id="EdtorSize">
                <table style="width:100%;height:100%;">
                    <tr>
                        <td style="height:100%;">
                            <%-- if (Use_Editor == "TAGFREE") { %>
                                <iframe id="tbContentElement" class="viewbox" src="TagFree_TFX_Editor.aspx" name="message" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
                            <% } else if (Use_Editor == "DEXT") { %>
                                <iframe id="tbContentElement" class="viewbox" src="DEXT_Editor.aspx" name="message" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
                            <% } else { --%>
                                <iframe id="tbContentElement" class="viewbox" src="/ezEmail/mailCKEditor.do" name="message" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
                            <%-- } --%>
                        </td>
                    </tr>
                    <!-- <asp:PlaceHolder ID="HolderDocSend" runat="server" Visible="false">
                        <tr>
                            <td style="height:150px;">
                                <div id="docContentBorder" style="border: #B6B6B6 1px solid; background-color: white;margin-top: 5px;overflow:auto;text-align:center;">
                                    <div id="docContent" style="height: 100%; margin:auto;width:620px;border:none;text-align:center;" ></div>
                                </div>
                            </td>
                        </tr>
                    </asp:PlaceHolder> -->
                </table>
            </td>
        </tr>
        <tr style="display:none;">
        <td style="padding-top: 0px">
            <table class="file">
                <tr>
                    <td>
                       <div id="attachedfileDIV" style="display:none;"></div>
                    </td>
                </tr>
            </table>
        </td>
        </tr>
        <tr>
            <td style="padding-top: 10px;height:20px;vertical-align:middle;">
                <span style="color:#3a76c3;font-weight:bold;height:15px;display:inline-block;"><img src="/images/i_urgency.gif" />&nbsp;${pAttachWarning}</span>
                <iframe id="dadiframe" name="dadiframe" style="width:100%;border:0px" src="/ezEmail/dragAndDrop.do"></iframe>
            </td>
        </tr>
    </table>
    <div id="sendScreen" style="display:none;">
      <table width="100%" cellspacing="0" cellpadding="0" class="message" style="background-image:url(/images/email/mailsendnoti.gif)">
        <tr>
          <td style="text-align:right">
              <table border="0" style="width:80%;">
                <tr>
                    <td>
                        <div><spring:message code='ezEmail.t679' /></div>
                        <div style="margin-top:3px;"><spring:message code='ezEmail.t680' /></div>
                        <img src="/images/email/progress_img.gif" style="vertical-align:middle;margin-top:5px;"/>
                    </td>
                </tr>
              </table>
        </tr>
      </table>
    </div>
    <iframe id="frmPrint" name="printname" src="/blank.htm" frameborder="0" style="width: 5px; height: 5px;display:none"></iframe>
    <iframe id="printtest" src="/blank.htm" frameborder="0" style="width: 5px; height: 5px;display:none"></iframe>
    <input id="eFrom" type="hidden" name="eFrom">
    <input type="hidden" name="eImportant" style="display: none;">
    <iframe name="ifrm" src="about:blank" style="display:none"></iframe>
     <form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezEmail/mailInterUploadXCK.do?timestamp=${stateName}" target="ifrm" style="display:none;" >
        <input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width:1px; height:1px;" multiple="true" />
        <input type="hidden" name="maxsize" id="maxsize" />
        <input type="hidden" name="cnt" id="cnt" />
        <input type="hidden" name="newguid" id="newguid" />
        <input type="hidden" name="newid" id="newid" />
        <input type="hidden" name="bigmaxsize" id="bigmaxsize" />
        <input type="hidden" name="changesize" id="changesize" />
        <input type="hidden" name="txtName" id="txtName" />
        <input type="hidden" name="endDay" id="endDay" />
    </form>
    <div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.7);display:none;" id="mailPanel">&nbsp;</div>
    <span class="loading_layer" style="z-index:6000;position:absolute;top:400px;left:300px;display:none;" id="loadingLayer"><span class="right"><img src="/images/loading/loading.gif" width="24" height="24" ><spring:message code='ezEmail.t679' /><spring:message code='ezEmail.t680' /></span></span>
    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
    <iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
    </div>
    <iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>  
    <script type="text/javascript">
        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 400 + "PX";
    </script>
</body>
 <xmp id="AttachXmlList" style="display:none;">
    ${attach}
 </xmp>
    
</html>
