var regex = /[\u0000-\u0008\u000B-\u000C\u000E-\u001F]/g;
var emailFlag=false;
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
        	if (!increaseReceiverCount()) {
        		return;
        	}
        	
            var newElem = PrepareMailTag(0, "email", g_myname, g_myemail, "");
            MsgToGot.appendChild(newElem);


            // 2025.06.10 한슬기 : 참조/숨은참조에 내가 들어갈 경우 id를 세팅해준다.
            setIDSelfCcOrBcc(1, g_myemail); // 참조
            setIDSelfCcOrBcc(2, g_myemail); // 숨은참조

            // 내게쓰기 체크할 경우 참조/숨은참조란에서 나를 삭제한다.
            var ccOrBccElem = document.getElementById("selfCcOrBcc");
            if (ccOrBccElem && ccOrBccElem.parentNode) {
                ccOrBccElem.parentNode.removeChild(ccOrBccElem);
            }

        }
    } else {
        for (var i = 0; i < msgDiv.childNodes.length; i++) {
            if (msgDiv.childNodes[i].childNodes[0].getAttribute("email") && msgDiv.childNodes[i].childNodes[0].getAttribute("email") == g_myemail) {
            	decreaseReceiverCount();
            	
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
    var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
    feature = feature + GetOpenPosition(420, 450);
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

function do_Attach_Add(ocx_file, forceBigFileUpload) {
    if (CrossYN()) {
        document.form.file1.click();
    } else {
        var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
        ezUtil.UseUTF8 = true;

        if (!ocx_file) {
            var file = ezUtil.OpenLoadDlgMultiNew("All Files (*.*)\0*.*\0Microsoft Office Files\0*.doc;*.xls;*.ppt;*.pst;*.mdb;\0Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx;\0Text Files\0*.txt;*.csv;\0Archive Files\0*.zip;*.rar;*.cab;*.alz;*.tar\0Executable Files\0*.exe;*.com;*.bat;\0\0", "")

            if (!file)
                return;
            g_fileList = file.split("|");
        }
        else {
            g_fileList = ocx_file.split("|");
        }
        
        var fileSize = 0;
        var fileSize2 = 0;
        var tmpFileSize = 0;
        var pBigFileUploadYN = "N";
        var fileLen = g_fileSizelist.length;
        var strPrint = "";
        for (var i = 0; i < g_fileList.length - 1; i++) {
            tmpFileSize = ezUtil.GetFileSize(g_fileList[i]);
            if (tmpFileSize == 0) {
                alert(strLang167);
                return;
            }
            g_fileSizelist[fileLen + i] = tmpFileSize;
            if (BigSizeAttachSize < tmpFileSize || forceBigFileUpload) {
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
            alert(strLang77 + BigSizeAttachMBSize + "MB" + strLang78 + BigSizeMailAttachDelDay + strLangLS04);
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
                if (g_fileSizelist[fileLen + i] > BigSizeAttachSize || forceBigFileUpload) {
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

        var RemotePath = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezEmail/mailInterUploadX.do";
        var nCount = EzHTTPTrans.StartUpload(RemotePath, filedate, "DocManagement" + newid, "", "");
        if (nCount == 0) {
            alert(strLang89);
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

        var extFlag = false;
        for (var i = 0; i < nCount; i++) {
            var fileinfo = EzHTTPTrans.GetReturn(i);
            var infos = fileinfo.split('/');
            var filename = infos[0].substr(infos[0].lastIndexOf("\\") + 1);
            var filesize = infos[2];
            var filePath = infos[1].split('_kaonisplit_')[0];
            var BigYN = infos[1].split('_kaonisplit_')[1].split('_')[0];
            var extYN = infos[1].split('_kaonisplit_')[1].split('_')[1];

            if (extYN == "true") {
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
            else if (extYN == "denied") {
                extFlag = true;
            }
        }

        if (extFlag)
            alert(strLang323);
        
        var requestUrl = "/ezEmail/mailInterAttachCK.do";
        
    	if (typeof(shareId) != "undefined" && shareId != "") {
    		requestUrl += "?shareId=" + encodeURIComponent(shareId);
    	}
        
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        xmlhttp.open("POST", requestUrl, false);
        xmlhttp.send(xmlDoc.xml);

        if (xmlhttp.status == "200") {
            if (xmlhttp.responseText.indexOf("NO APPEND failed.") > -1) {
                alert(strLang241);
            }
            else {            
                xmlDoc.load(xmlhttp.responseXML)
                g_url = xmlDoc.getElementsByTagName("URL")[0].text;
    
                for (var i = 0; i < xmlDoc.getElementsByTagName("FILE").length; i++) {
                    filename = xmlDoc.getElementsByTagName("FILE")[i].selectSingleNode("NAME").text
                    path = xmlDoc.getElementsByTagName("FILE")[i].selectSingleNode("PATH").text
                    big_yn = xmlDoc.getElementsByTagName("FILE")[i].selectSingleNode("BIG").text
                    size = xmlDoc.getElementsByTagName("FILE")[i].selectSingleNode("SIZE").text
                    attid = xmlDoc.getElementsByTagName("FILE")[i].selectSingleNode("ITEMID").text
                    var aitem = document.location.protocol + "//" + document.location.hostname + "/myoffice/ezEmail/remote/mail_ReadAttach_Ews2.aspx?mode=Attach&ID=" + encodeURIComponent(g_url) + "&ATTID=" + encodeURIComponent(attid);
                    if (big_yn == "Y") {
                        var aitem = document.location.protocol + "//" + document.location.hostname + "/Common/DownloadAttach_Common.aspx?fileid=" + encodeURIComponent(path) + "&filedate=" + encodeURIComponent(attid.split('\\')[0]);
                    }
                    AtthacDivUpdate("addattach", aitem, attid, filename, size, big_yn)
                }
            }
        }
        else {
            alert(xmlhttp.status + " : " + strLang241);
        }
        xmlhttp = null;        
    }
}

function attach_Add(ocx_file) {
    do_Attach_Add(ocx_file, false);
}

function bigattach_Add(ocx_file) {
    do_Attach_Add(ocx_file, true);
}
// fileupload() 로 대체된 것 같음.
// function btn_AttachAdd_onclick() {

//     if (document.form.file1.value != "") {

//         var AttachLimit = 1096;
//         var newid = g_newid;
//         document.getElementById("maxsize").value = FtotSizeAttachSize;
//         document.getElementById("cnt").value = document.getElementById("form").file1.files.length;
//         document.getElementById("newid").value = newid;
//         document.getElementById("bigmaxsize").value = FtotBigSizeAttachSize;
//         document.getElementById("changesize").value = FBigSizeAttachSize;
//         document.getElementById("txtName").value = filedate;
//         document.getElementById("endDay").value = BigSizeMailAttachDelDay;

//         var frm = document.getElementById('form');
//         frm.submit();
//     }
//     else {
//         alert(strLangLHM07);
//     }
// }

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
        alert(strLang77 + BigSizeAttachMBSize + "MB" + strLang78 + BigSizeMailAttachDelDay + strLangLS04);
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

            var aitem = document.location.protocol + "//" + document.location.hostname + "/myoffice/ezEmail/remote/mail_ReadAttach_Ews.aspx?mode=Attach&ID=" + encodeURIComponent(g_url) + "&ATTID=" + encodeURIComponent(attid);

            if (big_yn == "Y") {
                var aitem = document.location.protocol + "//" + document.location.hostname + "/Common/DownloadAttach_Common.aspx?filepath=" + encodeURIComponent(path) + "&filename=" + encodeURIComponent(filename);
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
    g_progresswin = window.showModelessDialog("mail_progress.aspx?fileinfo=" + encodeURIComponent(fileinfo), "", "dialogWidth=390px; dialogHeight:190px; center:yes; status:no; help:no; edge:sunken");
}

function status_change(fileinfo) {
    try {
        g_progresswin.document.Script.fileinfo_change(fileinfo);
    } catch (e) {console.log(e);}
}

function attach_Delete() {
    var filelist = "";
    var retFileName;
    var pBigSizefileListYN = "Y";
    var MailAttachID = "";
    var DelIndex = EzHTTPTrans.GetCheckFileInfo();
    var DelArray = DelIndex.split("\\");
    for (var Cnt = 0; Cnt < DelArray.length; Cnt++) {
        if (DelArray[Cnt] != "") {
            if (MailAttachID == "")
                MailAttachID = EzHTTPTrans.GetFileInfo2(DelArray[Cnt]);
            else
                MailAttachID += "|!|" + EzHTTPTrans.GetFileInfo2(DelArray[Cnt]);
        }
    }
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

    var mailAttachIdList = MailAttachID.split("|!|");
    var filecnt = mailAttachIdList.length;
    var hasAttachment = false;
    var xmlStr = "<FILE>";    
    
    for (var i = 0; i < filecnt; i++) {
        var pItemID = mailAttachIdList[i];
        var pISBig = bigfileList[i];
        
        if (pISBig != "Y") {
            hasAttachment = true;
            xmlStr += "<ROW>";
            xmlStr += "<ATTACHID><![CDATA[" + pItemID + "]]></ATTACHID>";
            xmlStr += "<BIGYN><![CDATA[" + pISBig + "]]></BIGYN>";
            xmlStr += "</ROW>";
        } else {
            var para = document.createElement("P");
            para.setAttribute("_itemid", pItemID);
            DelAttachFileAtList2(para);
        }        
    }
    
    if (hasAttachment) {
        DelAttachFileAtList3(xmlStr);
    }    
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
    catch (e) {console.log(e);}
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
function Send_onClick_preview() {
    // 기본 check
    if (eSubject.value.trim() == "") {
        alert(strNoSubject);
        eSubject.focus();
        return;
    }

    if (eSubject.value.length > 150) {
        alert(strLang95);
        eSubject.focus();
        return;
    }

	if (window.dadiframe && dadiframe.isfileup) {
		alert(strLang86);
		return;
	}

	if (document.getElementById("MsgToGot").children.length == 0 &&
        document.getElementById("MsgCCGot").children.length == 0 &&
        document.getElementById("MsgBCCGot").children.length == 0) {
        alert(strLang93);
        gInvalidAddressArr = null;
        return;
    }

	// 미리보기 or 전송
	if (previewMail == "Y") {
        previewChk = true;
        Save_onClick('previewSend');
    } else if (previewMail == "P" && importantSelect.selectedIndex.toString() == "2") { // 중요도 높음
        previewChk = true;
        Save_onClick('previewSend');
    } else {
        Send_onClick();
    }
}

function Send_onClick() {
    /* Send_onClick_preview 에서 체크하고 오기때문에 주석
    if (eSubject.value.trim() == "") {
        alert(strLangHSG03); // 2024.04.29 한슬기 : 제목란이 비어있습니다.
        eSubject.focus();
        return;
    }
    
    if (eSubject.value.length > 150) {
        alert(strLang95);
        eSubject.focus();
        return;
    }
    
	if (window.dadiframe && dadiframe.isfileup) {
		alert(strLang86);
		return;
	}*/

    NameCertify_onClick(Send_onClick_Complete);
}

var secureMail_dialogArguments = new Array();
var secureMailParams = new Array();
function Send_onClick_Complete(ReturnValue) {
    try {
        if (ReturnValue) {
            try {
                if (document.getElementById("MsgToGot").childNodes[0].childNodes.length == 0 &&
                    document.getElementById("MsgCCGot").childNodes[0].childNodes.length == 0 &&
                    document.getElementById("MsgBCCGot").childNodes[0].childNodes.length == 0) {
                    alert(strLang93);
                    gInvalidAddressArr = null;
                    return;
                }
            } catch (e) {
                if (document.getElementById("MsgToGot").childNodes.length == 0 &&
                        document.getElementById("MsgCCGot").childNodes.length == 0 &&
                        document.getElementById("MsgBCCGot").childNodes.length == 0) {
                    alert(strLang93);
                    gInvalidAddressArr = null;
                    return;
                }
            }
            
            try {
            	individualmailuserNum = Number(individualmailuser);
            } catch (e) {console.log(e);}
            
            if ((MsgToGot.childNodes.length + MsgCCGot.childNodes.length + MsgBCCGot.childNodes.length) > individualmailuserNum && iseachMail == "true") {
                if (confirm(strLangKMS04 + individualmailuserNum + strLangKMS05)) {
                    iseachMail = "false";
                }
                else {
                    gInvalidAddressArr = null;
                    return;
                }
            }
            
            // 보안메일 체크되어있을 경우 보안메일 설정 팝업창을 띄운다.
            if (useSecureMail == "YES" && isSecureMail == "true") {
            	secureMailParams["securePassword"] = securePassword;
            	secureMailParams["secureReadCount"] = secureReadCount;
            	secureMailParams["secureReadDate"] = secureReadDate;
                secureMailParams["securePasswordHint"] = securePasswordHint;
            	
            	secureMail_dialogArguments[0] = secureMailParams;
            	secureMail_dialogArguments[1] = secureMail_Complete;
            	secureMail_dialogArguments[2] = DivPopUpHidden;
            	
            	DivPopUpShow(650, 350, "/ezEmail/mailSecureOption.do");
            } else {
            	Save_onClick("sendsave");
            }
            
        }
    } catch (e) {
        console.log(e);
    }
}

// 보안메일 설정 팝업창에서 발송버튼 클릭하면 실행되는 함수
function secureMail_Complete(returnValue) {
	DivPopUpHidden();
	Save_onClick("sendsave");
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
var gInvalidAddressArr = null;

function checkMailStatusAndSave(savemode) {
    console.log("savemode=" + savemode + ",MailStatus=" + MailStatus);
    
    // 자동 저장 중이면 저장이 완료될 때까지 대기한 후 발송을 수행한다.    
    if (MailStatus == "NO") {                     
        MailStatus = "SEND";
        Save_onClick_Complete.savemode = savemode;
        Save_onClick_Complete(true);
    } else {
        setTimeout(function() {
            checkMailStatusAndSave(savemode);
        }, 1000);
    }     
    
    dadiframe.updateItemUid();
}
var alertFlag = false;
function Save_onClick(savemode) {
    // 이미 저장 혹은 발송 중이면 저장 작업을(자동 저장) 수행하지 않고 그냥 반환한다.
    if (savemode == "tempsave" && MailStatus == "SEND" && !previewChk) {
        return;
    }
    
    // 2024-03-06 이사라 - 임시보관함으로 메일을 저장하는 경우도 제목을 필수로 입력하도록 수정
    if (eSubject.value.trim() == "" && !previewChk) {
        if (!alertFlag) {
            alert(strLang92);
            eSubject.focus();
            alertFlag = true;
        }
        return "noSubject"; // 2024.04.29 한슬기 : 제목이 없는 경우 noSubject를 리턴하도록 변경
    }
    alertFlag = false;

	if (window.dadiframe && dadiframe.isfileup) {
		alert(strLang86);
		return;
	}
	
	if (savemode == "sendsave" && typeof (g_apprMail) != "undefined" && !g_apprMail) {
	    apprPolicy(savemode).then((value) => {
	    	if (!value) {
		        if (!g_apprMail) {
	                return;
	            }
	    	}

            //Save_onClick을 탈 때(발송, 저장, 미리보기) 할 때, 첨부파일 순서를 저장하도록 수정. 2020-03-19 홍대표.
            callMoveAttachFileOrder();

            checkMailStatusAndSave(savemode);
	    })
	} else {
        //Save_onClick을 탈 때(발송, 저장, 미리보기) 할 때, 첨부파일 순서를 저장하도록 수정. 2020-03-19 홍대표.
        callMoveAttachFileOrder();

        checkMailStatusAndSave(savemode);
    }
}

function Save_onClick_Complete(ReturnValue) {
    try {
        if (ReturnValue) {
            var Subject = eSubject.value;
            /* 2024-03-06 이사라 - 임시보관함으로 메일을 저장하는 경우도 제목을 필수로 입력하도록 수정하여 불필요한 부분 주석
            if (TrimText(Subject) == "" && !previewChk)
                Subject = strLang97;*/

            if (isSecureMail == "true")
                pSecurity = "3";
            
            var xmlDoc = createXmlDom();
            var rootNode;
            createNodeInsert(xmlDoc, rootNode, "DATA");
            createNodeAndInsertText(xmlDoc, rootNode, "URL", encodeURIComponent(g_url));
            createNodeAndInsertText(xmlDoc, rootNode, "ORGURL", gg_url);
            createNodeAndInsertText(xmlDoc, rootNode, "CONNURL", "/exchange/" + g_szUserID);
            createNodeAndInsertText(xmlDoc, rootNode, "CMD", (Save_onClick_Complete.savemode == "sendsave" ? "SEND" : "SAVE"));
            createNodeAndInsertText(xmlDoc, rootNode, "MAILCMD", g_cmd);
            createNodeAndInsertText(xmlDoc, rootNode, "ORGMAILCMD", gg_cmd);
            createNodeAndInsertText(xmlDoc, rootNode, "AUTHOR", g_szAuthor);
            createNodeAndInsertText(xmlDoc, rootNode, "SUBJECT", Subject.replace(regex, " "));
            createNodeAndInsertText(xmlDoc, rootNode, "TO", GetAddrFormatForSend(MsgToGot));
            createNodeAndInsertText(xmlDoc, rootNode, "CC", GetAddrFormatForSend(MsgCCGot));
            createNodeAndInsertText(xmlDoc, rootNode, "BCC", GetAddrFormatForSend(MsgBCCGot));
            if (typeof (g_apprMail) != "undefined"){
            	createNodeAndInsertText(xmlDoc, rootNode, "APPRMAIL", g_apprMail);
            	createNodeAndInsertText(xmlDoc, rootNode, "APPRMAIL_TYPE", g_apprMailType);
            	createNodeAndInsertText(xmlDoc, rootNode, "APPRMAIL_APPROVER", g_apprMailApprover);
        	}
            if (document.getElementById("bodyType") != null && document.getElementById("bodyType").value == "1")
                createNodeAndInsertText(xmlDoc, rootNode, "TEXTBODY", document.getElementById("plainTextArea").value);
            else
                createNodeAndInsertText(xmlDoc, rootNode, "TEXTBODY", message.GetEditorTextContent().replace(regex, " "));
            createNodeAndInsertText(xmlDoc, rootNode, "FROM", "\"" + g_sendername + "\" <" + g_from + ">");
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
            createNodeAndInsertText(xmlDoc, rootNode, "STATENAME", filedate);
            createNodeAndInsertText(xmlDoc, rootNode, "MODEFLAG", Save_onClick_Complete.savemode); // 20190807 김수아 : 메일 작성 미리보기
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
            
            // 보안메일 체크되어있을 경우 request xml에 보안메일정보 추가
            if (useSecureMail == "YES" && isSecureMail == "true") {
            	createNodeAndInsertText(xmlDoc, rootNode, "SECUREMAIL", "TRUE");
            	createNodeAndInsertText(xmlDoc, rootNode, "SECUREPASSWORD", secureMailParams["securePassword"]);
            	createNodeAndInsertText(xmlDoc, rootNode, "SECUREREADCOUNT", secureMailParams["secureReadCount"]);
            	createNodeAndInsertText(xmlDoc, rootNode, "SECUREREADDATE", secureMailParams["secureReadDate"]);
                createNodeAndInsertText(xmlDoc, rootNode, "SECUREPASSWORDHINT", secureMailParams["securePasswordHint"]);
            }
            
            ConvertEmbedPath(xmlDoc, xmlDoc);
            ConvertEmbedImagToXml(xmlDoc, xmlDoc);
            
            gInvalidAddressArr = null;

            if (Org_cmd == "docsend" || Org_cmd == "docsenddoc" || Org_cmd == "board" || Org_cmd == "Community" || Org_cmd == "report")
                DocFileIntoXML(xmlDoc, rootNode);

            rootNode = null;

            try {
                var newid = '';
                if (g_cmd == "NEW") {
                    newid = '?' + '&newid=' + g_newid;
                }

                g_saveHttp = createXMLHttpRequest();
                
                var requestUrl = "/ezEmail/mailInterSend.do";
                
                if (typeof(shareId) != "undefined" && shareId != "") {
            		requestUrl += "?shareId=" + encodeURIComponent(shareId);
				}
                
                if (!isClosedSave) {
                    g_saveHttp.open("POST", requestUrl, true);
                    event_SaveonClick.savemode = Save_onClick_Complete.savemode;

                    if (Save_onClick_Complete.savemode == "sendsave" || (Save_onClick_Complete.savemode == "tempsave" && !isAutoSave)) {
                        MailSend_Show_Progress();                        
                    }

                    if (window.iseachMail == "false") {
                    	g_saveHttp.timeout = 20000;
                    }
                    g_saveHttp.onreadystatechange = event_SaveonClick;
                    g_saveHttp.send(xmlDoc);
                }
                else {
                    g_saveHttp.open("POST", requestUrl, false);
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
            	MailStatus = "NO";
            	isAutoSave = false;
            }
        }
    } catch (e) {
        console.log(e);
        
        // 자동 저장 도중 Exception이 발생한 경우 MailStatus가 SEND로 유지되어 발송 버튼을
        // 눌러도 반응이 없는 문제 수정
        MailStatus = "NO";
        isAutoSave = false;        
    }
}

function MailSend_Show_Progress() {
    document.getElementById("mailPanel").style.display = "";
    document.getElementById("loadingLayer").style.display = "";
    
    var messageInSending = document.getElementById("messageInSending");
    
    if (messageInSending != null) {
        if (event_SaveonClick.savemode == "sendsave") {
            messageInSending.style.display = "";
        } else {
            messageInSending.style.display = "none";
        }
    }
    
    if (!CrossYN()) {
        EzHTTPTrans.style.display = "none";
    }    
}

function MailSend_Hidden_Progress() {
    document.getElementById("mailPanel").style.display = "none";
    document.getElementById("loadingLayer").style.display = "none";
    
    if (!CrossYN()) {
        EzHTTPTrans.style.display = "";
    }    
}

function event_SaveonClick() {
    if (g_saveHttp != null && g_saveHttp.readyState == 4) {
    	
        var xmlResult = loadXMLString(g_saveHttp.responseText);
        var pRtnMessage = "";
        
        try {
            if (!CrossYN()) {
                pRtnMessage = xmlResult.childNodes.item(0).childNodes.item(0).text;
            } else if (CrossYN()) {
                pRtnMessage = xmlResult.childNodes.item(0).childNodes.item(0).textContent;
            }
        } catch (e) {
            console.log(e);
        }
        
        //메일 발송인 경우
        if (event_SaveonClick.savemode == "sendsave") {
        	// status code가 200~300이 아닐 경우
        	if (g_saveHttp.status < 200 || g_saveHttp.status > 300) {
        		alert(strLang105 + " error=-1");
        		MailSend_Hidden_Progress();
                g_saveHttp = null;
                MailStatus = "NO";
            }
            // 메일쓰기 도중 로그아웃된 경우
            else if (g_saveHttp.responseText.indexOf("actionLogin()") > -1) {
	        	alert(strLangLHM12);
	        	MailSend_Hidden_Progress();
	            g_saveHttp = null;
	            MailStatus = "NO";
            }
        	// 비정상적으로 처리된 경우
        	else if (pRtnMessage != "OK") {
        		// 편지함 용량 초과한 경우
                if (pRtnMessage.indexOf("OVERQUOTA") > -1) {
                	alert(strLangLHM08);
                }
            	// 메시지 크기 초과한 경우
                else if (pRtnMessage.indexOf("OVERMESSAGESIZE") > -1) {
                	var messageArr = pRtnMessage.split(":");
                    alert(strLangLHM13 + "\n(" + strLangLHM14 + messageArr[1] + strLangLHM15 + messageArr[2] + ")");
                }
                //유효하지 않은 메일주소(내부)가 있을 경우
                else if (pRtnMessage.indexOf("Invalid Addresses") > -1) {
                	var invalidAddresses = pRtnMessage.split(":")[1];
                	var invalidAddressArr = invalidAddresses.split("|");
                	invalidAddresses = invalidAddressArr.join("\n");
                	
                	if (confirm(strLangLHM16 + "\n" + invalidAddresses + "\n" + strLangLHM17)) {
                	    gInvalidAddressArr = invalidAddressArr;
                	    
                		for (var i=0; i<invalidAddressArr.length; i++) {
                			try { deleteMailUser(invalidAddressArr[i],"0"); } catch (e) {console.log(e);}
                			try { deleteMailUser(invalidAddressArr[i],"1"); } catch (e) {console.log(e);}
                			try { deleteMailUser(invalidAddressArr[i],"2"); } catch (e) {console.log(e);}
                		}
                		
                		setTimeout(Send_onClick(), 100);
                	}
                }
                // 잘못된 메일주소가 있을 경우 (ex> mailto:test@test.com)
                else if (pRtnMessage.indexOf("Local address contains illegal character") > -1) {
                	alert(strLangLHM22);
                }
                // 잘못된 도메인 주소가 있을 경우 (ex> mailtotest@tes:t.com)
                else if (pRtnMessage.indexOf("Domain contains illegal character") > -1) { 
                	alert(strLangLHM22);
                }
                else if (pRtnMessage.indexOf("parse error") > -1) {
                    alert(strLang105 + " error=-2");
                }
                else if (pRtnMessage.indexOf("APPR_ERROR") > -1) {
                	if (pRtnMessage == "APPR_ERROR_ALLHANDS_NOT_EXIST") {
                		alert(strLangAppr01);
                	} else if (pRtnMessage == "APPR_ERROR_NORMAL_NOT_EXIST") {
                		alert(strLangAppr02);
                	} else {
                		alert(strLangAppr03);
                	}
                }
                // 그 외
                else {
            		alert(pRtnMessage);
                }
                
                MailSend_Hidden_Progress();
                g_saveHttp = null;
                MailStatus = "NO";
            	g_apprMail = false;
            	g_apprMailType = "";
            	g_apprMailApprover = "";
        	}
        	// 정상적으로 처리된 경우
        	else {
        		g_bDirty = false;
                g_originalHTML = message.GetEditorContent();
                g_bSended = true;

                var result = pRtnMessage;
                var xmlID = "";
                xmlID = loadXMLString(g_saveHttp.responseText);
                
                var tempUrl = "";
                if (!CrossYN()) {
                    tempUrl = xmlID.childNodes.item(0).childNodes.item(1).text;
                }
                else if (CrossYN()) {
                	tempUrl = xmlID.childNodes.item(0).childNodes.item(1).textContent;
                }

                if (g_url = tempUrl) {
                    g_url = tempUrl;
                    g_orgurl = g_url;
                }
                
                g_saveHttp = null;
                MailStatus = "NO";
            	g_apprMail = false;
            	g_apprMailType = "";
            	g_apprMailApprover = "";
                
                if ("always" === mailSendResult) {
                    alert(strSendOK);
                }
                
                try {
//                	window.opener.MailListRefreshByTimeout();
                	/* 2018-05-07 이소담 - 왼쪽 메뉴의 '메일쓰기'로 '내게쓰기'로 메일을 발신했을때 메일 목록 자동으로 새로고침되도록 개선*/
                	if (window.opener.name == "left") {
                		window.opener.parent.frames["right"].MailListRefreshByTimeout();
                	} 
                	/* 2018-07-23 정재은 - 미리보기에서 전달, 회신, 전체회신 후 메일 목록 자동으로 새로고침되도록 개선*/
                	else if (window.opener.name == "ifrmPreViewH" || window.opener.name == "ifrmPreViewW") {
                		window.opener.parent.parent.frames["right"].MailListRefreshByTimeout();
                	} else {
                		window.opener.MailListRefreshByTimeout();
                	}
                } catch (e) {console.log(e);}
                
                window.close();
        	}
        }
        //메일 저장 or 자동임시저장인 경우 or 미리보기
        else {
        	// status code가 200~300이 아닐 경우
        	if (g_saveHttp.status < 200 || g_saveHttp.status > 300) {
        	    alert(strLang105 + " error=-1");
            }
            // 메일쓰기 도중 로그아웃된 경우
            else if (g_saveHttp.responseText.indexOf("actionLogin()") > -1) {
	        	alert(strLangLHM12);
            }
        	// 비정상적으로 처리된 경우
        	else if (pRtnMessage != "OK") {
                // 편지함 용량 초과한 경우
                if (pRtnMessage.indexOf("OVERQUOTA") > -1) {
                	alert(strLang241);
                }
            	// 메시지 크기 초과한 경우
                else if (pRtnMessage.indexOf("OVERMESSAGESIZE") > -1) {
                	var messageArr = pRtnMessage.split(":");
                	alert(strLangLHM13 + "\n(" + strLangLHM14 + messageArr[1] + strLangLHM15 + messageArr[2] + ")");
                }
                else if (pRtnMessage.indexOf("parse error") > -1) {
                    alert(strLang105 + " error=-2");
                }                
                // 그 외
                else {
            		alert(pRtnMessage);
                }
        	} 
        	// 정상적으로 처리된 경우(메일작성 미리보기의 임시저장인 경우) 
        	else if (event_SaveonClick.savemode == "preview"){
                var result = pRtnMessage;
                var xmlID = "";
                xmlID = loadXMLString(g_saveHttp.responseText);
                var xmlItem = xmlID.childNodes.item(0).childNodes;
                
                if (!CrossYN()) {
                	preview_g_url = xmlItem.item(1).text;
                	preview_g_url_forRead = xmlItem.item(2).text + "/" + preview_g_url;
                }
                else if (CrossYN()) {
                	preview_g_url = xmlItem.item(1).textContent;
                	preview_g_url_forRead = xmlItem.item(2).textContent + "/" + preview_g_url;
                }
                
        		preMailRead(preview_g_url_forRead);
        	}
        	// 정상적으로 처리된 경우(메일작성 미리보기의 임시저장인 경우)
            else if (event_SaveonClick.savemode == "previewSend"){
                var result = pRtnMessage;
                var xmlID = "";
                xmlID = loadXMLString(g_saveHttp.responseText);
                var xmlItem = xmlID.childNodes.item(0).childNodes;

                if (!CrossYN()) {
                    preview_g_url = xmlItem.item(1).text;
                    preview_g_url_forRead = xmlItem.item(2).text + "/" + preview_g_url;
                }
                else if (CrossYN()) {
                    preview_g_url = xmlItem.item(1).textContent;
                    preview_g_url_forRead = xmlItem.item(2).textContent + "/" + preview_g_url;
                }

                preMailReadSend(preview_g_url_forRead);
            }
        	// 정상적으로 처리된 경우(메일 저장 or 자동임시저장인 경우)
        	else {
        		g_bDirty = false;
                g_originalHTML = message.GetEditorContent();
                g_bSended = true;

                var result = pRtnMessage;
                var xmlID = "";
                xmlID = loadXMLString(g_saveHttp.responseText);
        		
        		var prevUrl = g_url;
                
                if (!CrossYN()) {
                    g_url = xmlID.childNodes.item(0).childNodes.item(1).text;
                }
                else if (CrossYN()) {
                	g_url = xmlID.childNodes.item(0).childNodes.item(1).textContent;
                }

                if (Org_cmd == "EDIT") {
                    // 메시지가 새롭게 생성되었으므로 새 메시지의 UID로 인라인 다운로드 링크를 변경한다.
                    var curValue = "&amp;uid=" + prevUrl + "&amp;"
                    var newValue = "&amp;uid=" + g_url + "&amp;"
                    var re = new RegExp(curValue, "g");
                    g_originalHTML = g_originalHTML.replace(re, newValue);
                    message.SetEditorContent(g_originalHTML);
                }
                
                g_orgurl = g_url;
                g_cmd = "EDIT";
                
                if (!isAutoSave) {
                	alert(strLang108);
                	MailSend_Hidden_Progress();
                }
                
                try {
                	window.opener.MailListRefreshByTimeout();
                } catch (e) {console.log(e);}
        	}
        	
    		/*if (!isAutoSave) {
        		MailSend_Hidden_Progress();
        	}*/
        	g_saveHttp = null;
        	MailStatus = "NO";
        	isAutoSave = false;
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

function onblurOnRecipientInputField(value) {
    if (navigator.userAgent.toLowerCase().search("trident") > -1) {
        setTimeout(function() {
            if (value != null && value != '' 
                && $("#ui-id-1").css('display') == 'none'
                && $("#ui-id-2").css('display') == 'none'
                && $("#ui-id-3").css('display') == 'none') {
                NameCertify_onClick(null);
            }
        }, 1);
    } else {
        if (value && value.length > 1) {
            NameCertify_onClick(null);
        }
    }    
}

var NameCertify_onClick_returnFunction;
function NameCertify_onClick(returnFunction) {
	document.getElementById("MsgTo").value = removeAsciiCode(document.getElementById("MsgTo").value);
	document.getElementById("MsgCC").value = removeAsciiCode(document.getElementById("MsgCC").value);
	document.getElementById("MsgBCC").value = removeAsciiCode(document.getElementById("MsgBCC").value);
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
    // 20181127 조진호 - 검색 후에 검색 리스트가 계속 보이는 현상 수정
    $('.ui-autocomplete-input').autocomplete("close");
    return true;
}

function removeAsciiCode(str) {
    str = str.replace(/\ufeff/g,'');                    	// BOM 제거 window에서는 보이지 않고 linux에서는 whitespace로 나타나는 문자 제거
    return str.replace(/[\x00-\x1F\x7F]/g, '');				// remove non-printable Ascii code
}

function removeSpace(str) {
    return str.replace(/ /g,'');
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
        createNodeAndInsertText(xmlDOM, objNode, "ORGSEARCH", "displayname::" + name + ";;mail::" + name);
    }
    else {
    	/* 2018-04-26 이소담 - 메일쓰기에서 받는사람에 메일 주소를 직접 입력하였을때 도메인이 내부도메인일 경우 계정이 존재하는지 확인 후 존재하지않으면 입력되지않도록 개선*/
        $.ajax({
        	type	: "GET",
        	data	: {name: name},
        	contentType : "application/json",
        	url		: "/ezEmail/mailCheck.do",
        	async	: false,
        	success	: function(result) {
        		var info = result;
        		if (info === "") {
        			emailFlag=true; 
        			if (document.getElementById("MsgTo").value != ""){
        				document.getElementById("MsgTo").value = "";
        			} else if (document.getElementById("MsgCC").value != "") {
        				document.getElementById("MsgCC").value = "";
        			} else {
        				document.getElementById("MsgBCC").value = "";
        			}
    			}
    		},
        	error	: function(error) {
        		console.log(error);
        	}
        })
        createNodeAndInsertText(xmlDOM, objNode, "ORGSEARCH", "displayname::" + name + ";;mail::" + name);
    }
    createNodeAndInsertText(xmlDOM, objNode, "DLGSEARCH", "displayname::" + name);
    createNodeAndInsertText(xmlDOM, objNode, "CELL", "displayName");
    createNodeAndInsertText(xmlDOM, objNode, "ORGPROP", "company;description;title;mail;extensionAttribute3;displayName2");
    createNodeAndInsertText(xmlDOM, objNode, "DLPROP", "mail");
    createNodeAndInsertText(xmlDOM, objNode, "ORGTYPE", "all");
    createNodeAndInsertText(xmlDOM, objNode, "DLTYPE", "group");
    createNodeAndInsertText(xmlDOM, objNode, "FIELD", "AddressID,SNAME,SEMAIL,STYPE");
    createNodeAndInsertText(xmlDOM, objNode, "ADDFILTER", name);
    createNodeAndInsertText(xmlDOM, objNode, "SHAREDMAILBOXSEARCH", "displayname::" + name);
    // useShowAllCompanies config가 YES일 경우 그룹사 전체 조직도를 대상으로 검색하기 위해 company 패러메터를 빈 값으로 추가함.
    xmlHTTP.open("POST", "/ezEmail/mailNameCheck.do?company=", false);
    xmlHTTP.send(xmlDOM);

    xmlDOM = loadXMLString(xmlHTTP.responseText);
    
    var mailAddressSearchOrder = getNodeText(GetChildNodes(GetChildNodes(SelectNodes(xmlDOM, "RESULT/MAILADDRESSSEARCHORDER/ROW")[0])[0])[0])
    if (mailAddressSearchOrder != "") {
    	var mailAddressSearchOrderSplit = mailAddressSearchOrder.split(";");
    	
    	for (var i = 0; i < mailAddressSearchOrderSplit.length; i++) {
    		if (mailAddressSearchOrderSplit[i] =="organ") {
    			var rows = SelectNodes(xmlDOM, "RESULT/ORGAN/ROW");
    			adCount = m_addrBook.name.length;
    	        for (count = 0; count < rows.length; count++) {
    	            if (getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[1]) == "group") {
    	                m_addrBook["type"][count + adCount] = "email";
    	                m_addrBook["name"][count + adCount] = getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[0]);
    	                m_addrBook["email"][count + adCount] = getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[6]);
    	                m_addrBook["href"][count + adCount] = "";
    	                m_addrBook["company"][count + adCount] = getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[7]);
    	                m_addrBook["dept"][count + adCount] = getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[4]);
    	                m_addrBook["title"][count + adCount] = strLang110;
    	            }
    	            else {
    	                m_addrBook["type"][count + adCount] = "email";
    	                m_addrBook["name"][count + adCount] = getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[0]);
    	                m_addrBook["email"][count + adCount] = getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[6]);
    	                m_addrBook["href"][count + adCount] = "";
    	                m_addrBook["company"][count + adCount] = getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[3]);
    	                m_addrBook["dept"][count + adCount] = getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[4]);
    	                m_addrBook["title"][count + adCount] = getNodeText(GetChildNodes(GetChildNodes(rows[count])[0])[5]);
    	            }
    	        }
    	        
			} else if (mailAddressSearchOrderSplit[i] == "dl") {
				rows = SelectNodes(xmlDOM, "RESULT/DL/ROW");
				adCount = m_addrBook.name.length;
		        for (var count = 0 ; count < rows.length ; count++) {
		            m_addrBook["type"][count + adCount] = "email";
		            m_addrBook["name"][count + adCount] = getNodeText(GetChildNodes(rows[count])[0].getElementsByTagName("VALUE")[0]);
		            m_addrBook["email"][count + adCount] = getNodeText(GetChildNodes(rows[count])[0].getElementsByTagName("DATA3")[0]);
		            m_addrBook["href"][count + adCount] = "";
		            m_addrBook["company"][count + adCount] = strLang114;
		            m_addrBook["dept"][count + adCount] = "";
		            m_addrBook["title"][count + adCount] = "";
		        }
		        
			} else if (mailAddressSearchOrderSplit[i] == "address") {
				var contactList = SelectNodes(xmlDOM, "RESULT/ADDRESS/ROW");
		        var row;
		        var idx = 0;
		        adCount = m_addrBook.name.length;
		        for (count = 0; count < contactList.length; count++) {
		        	if (SelectSingleNodeValue(contactList[count], "SEMAIL") != "") {
		        		if (SelectSingleNodeValue(contactList[count], "STYPE") == "P") {
			                m_addrBook["type"][idx + adCount] = "email";
			                try {
			                    m_addrBook["name"][idx + adCount] = SelectSingleNodeValue(contactList[count], "SNAME");
			                }
			                catch (ex) {
			                    m_addrBook["name"][idx + adCount] = "";
			                }
			                try {
			                    m_addrBook["email"][idx + adCount] = SelectSingleNodeValue(contactList[count], "SEMAIL");
			                }
			                catch (ex) {
			                    m_addrBook["email"][idx + adCount] = "";
			                }
			                m_addrBook["href"][idx + adCount] = "";
			            }
			            else {
			                m_addrBook["type"][idx + adCount] = "mailgroup";
			                m_addrBook["name"][idx + adCount] = SelectSingleNodeValue(contactList[count], "SNAME");
			                m_addrBook["email"][idx + adCount] = SelectSingleNodeValue(contactList[count], "SEMAIL");
			                m_addrBook["href"][idx + adCount] = SelectSingleNodeValue(contactList[count], "ADDRESSID") + "|!|" + SelectSingleNodeValue(contactList[count], "FOLDERTYPE");
			            }
			            m_addrBook["company"][idx + adCount] = SelectSingleNodeValue(contactList[count], "SCOMPANY");
			            m_addrBook["dept"][idx + adCount] = SelectSingleNodeValue(contactList[count], "SDEPT");
			            m_addrBook["title"][idx + adCount] = SelectSingleNodeValue(contactList[count], "STITLE");
			            idx++;
		        	}
		        }
		        adCount = m_addrBook.name.length;
			} else if (mailAddressSearchOrderSplit[i] == "shared") {
		        rows = SelectNodes(xmlDOM, "RESULT/SHAREDMAILBOX/ROW");
		        adCount = m_addrBook.name.length;
		        for (var count = 0 ; count < rows.length ; count++) {
		            m_addrBook["type"][count + adCount] = "email";
		            m_addrBook["name"][count + adCount] = getNodeText(GetChildNodes(rows[count])[0].getElementsByTagName("VALUE")[0]);
		            m_addrBook["email"][count + adCount] = getNodeText(GetChildNodes(rows[count])[0].getElementsByTagName("DATA3")[0]);
		            m_addrBook["href"][count + adCount] = "";
		            m_addrBook["company"][count + adCount] = getNodeText(GetChildNodes(rows[count])[0].getElementsByTagName("DATA4")[0]);
		            m_addrBook["dept"][count + adCount] = strLangSharedMailbox01;
		            m_addrBook["title"][count + adCount] = "";
		        }
			}
    	}
    } else {
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
            if (SelectSingleNodeValue(contactList[count], "STYPE") == "P") {
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
                m_addrBook["href"][count + adCount] = SelectSingleNodeValue(contactList[count], "ADDRESSID") + "|!|" + SelectSingleNodeValue(contactList[count], "FOLDERTYPE");
            }
            m_addrBook["company"][count + adCount] = SelectSingleNodeValue(contactList[count], "SCOMPANY");
            m_addrBook["dept"][count + adCount] = SelectSingleNodeValue(contactList[count], "SDEPT");
            m_addrBook["title"][count + adCount] = SelectSingleNodeValue(contactList[count], "STITLE");
        }
        
        rows = SelectNodes(xmlDOM, "RESULT/DL/ROW");
        adCount += contactList.length;
        
        for (count = 0 ; count < rows.length ; count++) {
            m_addrBook["type"][count + adCount] = "email";
            m_addrBook["name"][count + adCount] = getNodeText(GetChildNodes(rows[count])[0].getElementsByTagName("VALUE")[0]);
            m_addrBook["email"][count + adCount] = getNodeText(GetChildNodes(rows[count])[0].getElementsByTagName("DATA3")[0]);
            m_addrBook["href"][count + adCount] = "";
            m_addrBook["company"][count + adCount] = strLang114;
            m_addrBook["dept"][count + adCount] = "";
            m_addrBook["title"][count + adCount] = "";
        }
        
        adCount += rows.length;
        rows = SelectNodes(xmlDOM, "RESULT/SHAREDMAILBOX/ROW");
        
        for (count = 0 ; count < rows.length ; count++) {
            m_addrBook["type"][count + adCount] = "email";
            m_addrBook["name"][count + adCount] = getNodeText(GetChildNodes(rows[count])[0].getElementsByTagName("VALUE")[0]);
            m_addrBook["email"][count + adCount] = getNodeText(GetChildNodes(rows[count])[0].getElementsByTagName("DATA3")[0]);
            m_addrBook["href"][count + adCount] = "";
            m_addrBook["company"][count + adCount] = getNodeText(GetChildNodes(rows[count])[0].getElementsByTagName("DATA4")[0]);
            m_addrBook["dept"][count + adCount] = strLangSharedMailbox01;
            m_addrBook["title"][count + adCount] = "";
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
        else if (newElem.childNodes[0].getAttribute("href") != null && MsgToGot.childNodes[co].childNodes[0].getAttribute("type") == "mailgroup") {
        	if (newElem.childNodes[0].getAttribute("href").split("|!|")[0] == MsgToGot.childNodes[co].childNodes[0].getAttribute("href").split("|!|")[0]) {
        		return true;
        	}
        }
        
    }
    for (co = 0; co < MsgCCGot.childNodes.length; co++) {
        if (MsgCCGot.childNodes[co].childNodes[0].nodeName == "#text")
            continue;
        if (newElem.childNodes[0].getAttribute("email") == MsgCCGot.childNodes[co].childNodes[0].getAttribute("email") && MsgCCGot.childNodes[co].childNodes[0].getAttribute("type") != "mailgroup")
            return true;
        else if (newElem.childNodes[0].getAttribute("href") != null && MsgCCGot.childNodes[co].childNodes[0].getAttribute("type") == "mailgroup") {
        	if (newElem.childNodes[0].getAttribute("href").split("|!|")[0] == MsgCCGot.childNodes[co].childNodes[0].getAttribute("href").split("|!|")[0]) {
        		return true;
        	}
        }
    }
    for (co = 0; co < MsgBCCGot.childNodes.length; co++) {
        if (MsgBCCGot.childNodes[co].childNodes[0].nodeName == "#text")
            continue;
        if (newElem.childNodes[0].getAttribute("email") == MsgBCCGot.childNodes[co].childNodes[0].getAttribute("email") && MsgBCCGot.childNodes[co].childNodes[0].getAttribute("type") != "mailgroup")
            return true;
        else if (newElem.childNodes[0].getAttribute("href") != null && MsgBCCGot.childNodes[co].childNodes[0].getAttribute("type") == "mailgroup") {
        	if (newElem.childNodes[0].getAttribute("href").split("|!|")[0] == MsgBCCGot.childNodes[co].childNodes[0].getAttribute("href").split("|!|")[0]) {
        		return true;
        	}
        }
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
    
    if (mailArr[mailArr.length - 1] == ""){
    	mailArr.pop(); 
    }

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
            var preTag = mailName.indexOf("<");
            var emailAddressPart = removeSpace(mailName.substring(preTag));
            mailName = mailName.substring(0, preTag) + emailAddressPart;
            
            var reg_email = /^[<][-A-Za-z0-9_]+[-A-Za-z0-9_.]*[@]{1}[-A-Za-z0-9_]+[-A-Za-z0-9_.]*[.]{1}[A-Za-z]{2,5}[>]$/;
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
                    mailTagAddress = mailTagNM;
                }
                newElem = PrepareMailTag(iType, "email", mailTagNM, mailTagAddress, "");
                var IsInsert = CheckMailReceiver(newElem);
                if (!IsInsert) {
                	if (!increaseReceiverCount()) {
                		return;
                	}
                	
                    validDIV.appendChild(newElem);
                }
                continue;
            }
        }
        
        if (isEmailFormat(mailName) == true) {
            mailName = removeSpace(mailName);
        }
        
	    GetMailAddresses(mailName);
	    if (isEmailFormat(mailName) == true) {
	        result = findAddress(mailName, m_addrBook);
	
	        if (result != null) {
	            newElem = PrepareMailTag(iType, result["type"], result["name"], result["email"], result["href"]);
	        } else {
	        	if (emailFlag){
	        		alert(strLang198);
	        		emailFlag = false;
	        		return;
	        	} else {
	        		newElem = PrepareMailTag(iType, "email", mailName, mailName, "");
	        	}
	        }
	
	        var IsInsert = CheckMailReceiver(newElem);
	        if (!IsInsert) {
	        	if (!increaseReceiverCount()) {
            		return;
            	}
	        	
	            validDIV.appendChild(newElem);
	        }
	        var szFromName = "";
	        for (count1 = 1; count1 <= mailArr.length; count1++) {
	        	if (count1 - 1 != i) { // tndk
		            szFromName += mailArr[count1 - 1];
		            
		            if (count1 != mailArr.length) {
		            	szFromName += ";";
		            }
	        	}
	        }
	        /*for (count1 = 1; count1 < mailArr.length; count1++) {
	            szFromName += mailArr[count1];
	            if (count1 != mailArr.length - 1) szFromName += ";";
	        }*/
	        formName.value = szFromName;
	        CompleteEmailAddress(formName, validDIV, iType);
	        return;
	    }
	    
	    // 한번 더 거르는 작업이 불필요한 것처럼 보이기 때문에 주석처리함.
	    //userAddr = GetEmailAddressByName(m_addrBook, mailName);
	    var emailExitsCnt = m_addrBook["name"].length;
	    
	    if (m_addrBook["name"].length == 1 && trim(m_addrBook["email"][0]) == "" && m_addrBook["email"][0].lastIndexOf("@") < 2) {
	        emailExitsCnt = 0;
	    }
	
	    if (emailExitsCnt == 1) {
	        newElem = PrepareMailTag(iType, m_addrBook["type"][0], m_addrBook["name"][0], m_addrBook["email"][0], m_addrBook["href"][0]);
	        var IsInsert = CheckMailReceiver(newElem);
	
	        if (!IsInsert) {
	        	if (!increaseReceiverCount(m_addrBook["type"][0], m_addrBook["href"][0])) {
            		return;
            	}
	        	
	            validDIV.appendChild(newElem);
	        }
	
	        var szFromName = "";
	       
	        for (count1 = 1; count1 <= mailArr.length; count1++) {
	        	if (count1 - 1 != i) { // tndk
		            szFromName += mailArr[count1 - 1];
		            
		            if (count1 != mailArr.length) {
		            	szFromName += ";";
		            }
	        	}
	        }
	        formName.value = szFromName;
	        CompleteEmailAddress(formName, validDIV, iType);
	        return false;
	    } else {
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
	        
	        if (m_addrBook["name"].length == 0) {
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
	        
	        if (!CrossYN()) {
	            EzHTTPTrans.style.display = "none";
	        }    
	        
	        DivPopUpShow(625, 410, "/ezEmail/mailCheckName.do");
	        return false;
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
    else if (rgParams["recipientTDData"] == "delete") {
        for (var z = 0; z < rgParams["returnedRecipientEmail"].length; z++) {
            for (var i = 0; i < checkname_cross_dialogArguments[5].childNodes.length; i++) {
                if (GetAttribute(checkname_cross_dialogArguments[5].childNodes[i].childNodes[0], "email") == rgParams["returnedRecipientEmail"][z]) {
                	decreaseReceiverCount(rgParams["returnedRecipientType"][z], rgParams["returnedRecipientHref"][z]);
                	checkname_cross_dialogArguments[5].removeChild(checkname_cross_dialogArguments[5].childNodes[i]);
                    break;
                }
            }
        }
    }
    else {
        if (rgParams["recipientTDData"] == "change") {
            length = rgParams["returnedRecipientName"].length;

            for (count1 = 0; count1 < length; count1++) {
                newElem = PrepareMailTag(checkname_cross_dialogArguments[4], rgParams["returnedRecipientType"][count1], rgParams["returnedRecipientName"][count1],
                    rgParams["returnedRecipientEmail"][count1], rgParams["returnedRecipientHref"][count1]);

                var IsInsert = CheckMailReceiver(newElem);

                if (!IsInsert) {
                	if (!increaseReceiverCount(rgParams["returnedRecipientType"][count1], rgParams["returnedRecipientHref"][count1])) {
                		return;
                	}
                	
                    checkname_cross_dialogArguments[5].appendChild(newElem);
                }
            }
        }
        
        var szFromName = "";
       
        for (count1 = 1; count1 < checkname_cross_dialogArguments[3].length; count1++) {
    		szFromName += checkname_cross_dialogArguments[3][count1];
           
    		if (count1 != checkname_cross_dialogArguments[3].length-1) {
            	szFromName += ";";
            }
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
var ofileName;
var ofileHref;
var ofileAttachSize;
var ofileTypeCode;
var ofileUrl;
var ofileCopyPath;
function GetDocumentInfo(DocID, DocHref, ImagCnt, Target) {
    AttachFlag = true;
    var docAttach = "";
    ofileName = new Array();
    ofileHref = new Array();
    ofileAttachSize = new Array();
    ofileTypeCode = new Array();
    ofileUrl = new Array();
    ofileCopyPath = new Array();
    var attachcount = 0;
    
    if (DocHref.toLowerCase().indexOf(".doc") == -1 && DocHref.toLowerCase().indexOf(".hwp") == -1) {
        if (DocHref == "IMAGE") {
            var HtmlBody = "<div style='position:relative;display:inline-block' class='margin' id='ezFormProc_div'><hr></hr><div align='center'>";
            if (ImagCnt == "") {
                HtmlBody = HtmlBody + "<img src='" + uploadCommonPath + "/" + GetDateFormatString() + "/" + DocID + ".png' embedding='1'/>";
            }
            else {
                for (var i = 1; i <= parseInt(ImagCnt) ; i++) {

                    if (i != 1)
                        HtmlBody = HtmlBody + "<br><img style='margin-top:-6px;' src='" + uploadCommonPath + "/" + GetDateFormatString() + "/" + DocID + "_" + i + ".png' embedding='1'/>";
                    else
                        HtmlBody = HtmlBody + "<img src='" + uploadCommonPath + "/" + GetDateFormatString() + "/" + DocID + "_" + i + ".png' embedding='1'/>";
                }
            }
            HtmlBody = HtmlBody + "</div></div>";
            document.getElementById("bodyValue").innerHTML = document.getElementById("bodyValue").innerHTML + HtmlBody;
        }
        else {
            if (DocHref.toLowerCase().indexOf(".mht") > -1) {
                var fullPath = encodeURIComponent(DocHref);
                var tempXML = createXmlDom();
//                var XmlBodyATT = createXmlDom();
                var XmlBodyDATA = createXmlDom();
                var tempStr = "";
                tempStr = ConvertMHTtoHTML(fullPath);
                tempXML = loadXMLString(tempStr);
//                XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
                XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
                var htmlData = getNodeText(XmlBodyDATA);
                document.getElementById('docContent').innerHTML = htmlData;
                document.getElementById('docContent').style.height = "220px";
            } 
        }
    } else {
	   	 var fileext = DocHref.toLowerCase().substr(DocHref.length - 4);
	   	 
	   	 // 2018.07.03 (KLIB) 암호화된 파일 확장자 처리 (ezd 확장자라면 원래 확장자로 변경해줌)
	   	 if (fileext === ".ezd") {
	   		// 최소 8글자 이상이 보장됨
	   		fileext = DocHref.toLowerCase().substr(DocHref.length - 8, 4);
	   	 }
	   	 
	     /*var ezUtil = new ActiveXObject("ezUtil.RegScript");
	     var regData = ezUtil.ReadValueEx(2, "SYSTEM\\CurrentControlSet\\Control\\Nls\\CodePage", "OEMCP");
	     ezUtil = null;*/
	   	 
	   	 var regData = "";
	
	     var fullPath = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezCommon/downloadAttach.do?filePath="+ escape(DocHref) + "&filename=" + escape(strLang116 + fileext) + "&regData=" + regData;
	
	     ofileName[attachcount] = strLang116 + fileext;
	     ofileHref[attachcount] = docHref;
//	     ofileAttachSize[attachcount] = docfilesize.toString();
		 ofileTypeCode[attachcount] = "document";
		 
		 attachcount++;
    }
    var xmlHTTP = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var xmlstring = "<DocID>" + DocID + "</DocID>";
    xmlpara = loadXMLString(xmlstring);
    if (Target == "APPROVALG")
        xmlHTTP.open("POST", "/ezApprovalG/aprAttachMail.do?orgCompanyID="+orgCompanyID, false);
    else
        xmlHTTP.open("POST", "/ezApprovalG/aprAttachMail.do?orgCompanyID="+orgCompanyID, false);
    xmlHTTP.send(xmlpara);

    if (xmlHTTP.status == 200) {
        var ReturnXML = loadXMLString(xmlHTTP.responseText);
        if (DocHref.toLowerCase().indexOf(".doc") > 0) {
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
        
//		var ezUtil = new ActiveXObject("ezUtil.RegScript");
//		var regData = ezUtil.ReadValueEx(2, "SYSTEM\\CurrentControlSet\\Control\\Nls\\CodePage", "OEMCP");
//		ezUtil = null;

		// 결재문서의 확장자(mht, hwp 등)에 따라 다르게 작동하던  파일 업로드 방식을 단일 형식으로 통일
        var AttachRows = SelectNodes(ReturnXML, "ATTACHINFO/DATA/ROW");

        for (var i = 0; i < AttachRows.length; i++) {
            var fileName = SelectSingleNodeValue(AttachRows[i], "ATTACHNAME");
            var fileHref = SelectSingleNodeValue(AttachRows[i], "ATTACHFILEHREF");
            var fileAttachSize =  SelectSingleNodeValue(AttachRows[i], "ATTACHFILESIZE");
            var fileTypeCode = SelectSingleNodeValue(AttachRows[i], "ATTACHTYPECODE");
            
            if ((fileAttachSize == "0" || fileAttachSize == "") && (fileHref.indexOf(".hwp") > -1 || fileHref.indexOf(".mht") > -1)) {
            	fileAttachSize = strLang116;
            }
            
            fileName = fileName.replace("&amp;","&");
            fileName = fileName.replace(/[*|\\\":\/?<>]/gi, "_");


            var tmpExt = fileHref.substr(fileHref.length - 3, 3);
            // 2018.07.04 (KLIB) 암호화된 ezd 확장자 파일일 경우 원래 확장자로 처리
            if (tmpExt === 'ezd') {
            	tmpExt = fileHref.substr(fileHref.length - 7, 3);
            }
            
          	if (fileName.length > 3) {
                if (fileName.substr(fileName.length - 3, 3) != tmpExt)
                    fileName += "." + tmpExt;
            } else {
            	fileName += "." + tmpExt;
            }

            ofileName[attachcount] = fileName;
            ofileHref[attachcount] = fileHref;
            ofileAttachSize[attachcount] = fileAttachSize;
            ofileTypeCode[attachcount] = fileTypeCode;

            attachcount++;
        }
        
        /* 2023-05-16 김우철 - 테넌트 컨피그  useHwpDownSecurity의 값이 Y일 때, 배포용 문서로 변환하는 함수 hwp_url를 호출 */
        if (useHwpDownSecurity == "Y" && approvalFlag == "G") {
        	hwp_url(0, ofileName.length);
        } else {
        	attach_Add_OtherModule(ofileName, ofileHref, ofileAttachSize, ofileTypeCode);
        }
	            
/*========
        document.title = getNodeText(GetElementsByTagName(ReturnXML, "DOCTITLE")[0]);
        
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
            else if ((filesize == "0" || filesize == "") && filepath.substring(filepath.toLowerCase().lastIndexOf(".") + 1) == "mht") {
                filename = filename + ".mht";
                filesize = strLang116;
            }

            pstrXML += "<ROW><CELL><VALUE><![CDATA[" + filename + "]]></VALUE>";
            pstrXML += "<DATA1><![CDATA[" + filename + "]]></DATA1>";
            pstrXML += "<DATA2><![CDATA[" + filepath + "]]></DATA2>";
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
//                  if (CrossYN())
//                     var Node = Rtnxml.importNode(objNewAttachNodes, true);
//                  else
                        GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(objNewAttachNodes);
                }
                pAttachListXml = Rtnxml;
            }
            if (DragDropAttachObjetLoading) {
//            	AppendFileAttachInfo(pAttachListXml);
            	dadiframe.fileupload2(pAttachListXml);            	
            }
>>>>>>> master*/
    }
}

function getOriginalFileExtension(filePath) {
	var pathLength = filePath.length;
	var lastIndexOfDot = filePath.lastIndexOf(".");

	if (lastIndexOfDot < 0) {
		return "";
	}

	var ext = trim_Cross(filePath.substr(lastIndexOfDot + 1, filePath.length).toLowerCase());

	if (ext === "ezd") {
		return getOriginalFileExtension(filePath.substr(0, lastIndexOfDot));
	}

	return ext;
}

function GetBoardItemInfo_New(pBoardID, pItemID, pRetransType, pFont) {
	AttachFlag = true;
    var xmlHTTP = createXMLHttpRequest();
    xmlHTTP.open("GET", "/ezBoard/getItemInfo.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID), false);
    xmlHTTP.send("");

    if (xmlHTTP.status == 200) {
        var ReturnXML = loadXMLString(xmlHTTP.responseText);
        var Rurl = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/ContentLocation")[0]);
        var fullPath = Rurl;
        var tempXML = createXmlDom();
//        var XmlBodyATT = createXmlDom();
        var XmlBodyDATA = createXmlDom();
        var tempStr = "";
        var htmlData = "";
        
        if (moduleEditor != "HWP" && fullPath.substr(fullPath.length - 3, fullPath.length).toLowerCase() != "hwp") {
        	tempStr = ConvertMHTtoHTML(fullPath);

	        tempXML = loadXMLString(tempStr);
//      	XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	        XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	        htmlData = getNodeText(XmlBodyDATA);
	        htmlData = ReplaceText(htmlData, "<TD class=FIELD", "<TD");
        }

        eSubject.value = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/Title")[0]);
        var PostDate = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriteDate")[0]);
        var Sender = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriterName")[0]) + " (" +
	                 getNodeText(SelectNodes(ReturnXML, "NODES/NODE/ExtensionAttribute3")[0]) + "," +
			         getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriterDeptName")[0]) + "," +
			         getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriterCompanyName")[0]) + ")";

        if (Sender.indexOf("(,,)") > -1) Sender = Sender.split("(")[0];

        if (pRetransType != "boardAttach") {
            document.getElementById("bodyValue").innerHTML = "<DIV style='LINE-HEIGHT: 15pt' ><br /><br /><DIV id='MailSign'></div><br /></DIV>" +
            	"<br><br><hr></hr><DIV style='font-family:"+ pFont + "'><B>" + strLang118 + "</B>" + PostDate + "<br><B>" + strLang119 + "</B>" + Sender +
            	"<br><B>" + strLang120 + "</B>" + MakeXMLString(eSubject.value) + "</DIV><br><br>" + htmlData;
        }
        
        xmlHTTP.open("POST", "/ezBoard/getItemAttachmentsMail.do?itemID=" + encodeURIComponent(pItemID) + "&mode=" + pRetransType + "&conLocation=" + encodeURIComponent(Rurl) + "&title=" + encodeURIComponent(getNodeText(SelectNodes(ReturnXML, "NODES/NODE/Title")[0])), false);
        xmlHTTP.send();
        var ReturnXML = loadXMLString(xmlHTTP.responseText);
        var AttachRows = SelectNodes(ReturnXML, "NODES/NODE");
        var pstrXML = "";

        //첨부파일이 있을 경우
        if (AttachRows.length > 0) {
            pstrXML += "<LISTVIEWDATA><HEADERS>";
            pstrXML += "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
            pstrXML += "<HEADER><NAME>" + strLang3 + "</NAME><WIDTH>50</WIDTH></HEADER>";
            pstrXML += "</HEADERS><ROWS>";
        }
        for (var i = 0; i < AttachRows.length; i++) {
            var filepath = SelectSingleNodeValue(AttachRows[i], "FilePath");
            var filenameTemp = filepath.split('/')[filepath.split('/').length - 1];
            var filename = SelectSingleNodeValue(AttachRows[i], "FileName");
            var filesize = SelectSingleNodeValue(AttachRows[i], "FileSize2");

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

                for (var i = 0; i < SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW").length; i++) {
                    var objNewAttachNodes = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW")[i];
//                    if (CrossYN())
//                        var Node = Rtnxml.importNode(objNewAttachNodes, true);
//                    else
                        GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(objNewAttachNodes);
                }
                pAttachListXml = Rtnxml;
            }
            if (DragDropAttachObjetLoading) {
//            	AppendFileAttachInfo(pAttachListXml);
            	dadiframe.fileupload2(pAttachListXml);
            }
        }
        
        eSubject.value = strLang121 + eSubject.value;
        Subject_ReApply();
    }
}

function GetBoardItemInfo_New3(pBoardID, pItemID, pFont) {
    AttachFlag = true;
    var xmlHTTP = createXMLHttpRequest();
    xmlHTTP.open("GET", "/ezCommunity/getItemInfo.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID), false);
    xmlHTTP.send("");

    if (xmlHTTP.status == 200) {
        var ReturnXML = loadXMLString(xmlHTTP.responseText);
        var Rurl = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/ContentLocation")[0]);
        var fullPath = Rurl;
        var tempXML = createXmlDom();
//        var XmlBodyATT = createXmlDom();
        var XmlBodyDATA = createXmlDom();
        var tempStr = "";
        var htmlData = "";
        
        if (moduleEditor != "HWP" && fullPath.substr(fullPath.length - 3, fullPath.length).toLowerCase() != "hwp") {
        	tempStr = ConvertMHTtoHTML(fullPath);
	        tempXML = loadXMLString(tempStr);
//      	XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	        XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	        htmlData = getNodeText(XmlBodyDATA);
        }	
        
        eSubject.value = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/Title")[0]);
        var PostDate = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/StartDate")[0]);
        var Sender = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriterName")[0]) + " (" +
	                 getNodeText(SelectNodes(ReturnXML, "NODES/NODE/ExtensionAttribute3")[0]) + "," +
			         getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriterDeptName")[0]) + "," +
			         getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriterCompanyName")[0]) + ")";

        if (Sender.indexOf("(,,)") > -1) Sender = Sender.split("(")[0];

        htmlData = ReplaceText(htmlData, "<TD class=FIELD", "<TD");
        document.getElementById("bodyValue").innerHTML = "<DIV style='LINE-HEIGHT: 15pt' ><br /><br /><DIV id='MailSign'></div><br /></DIV>" +
        	"<br><br><hr></hr><DIV style='font-family:"+ pFont + "'><B>" + strLang118 + "</B>" + PostDate + "<br><B>" + strLang119 + "</B>" + Sender +
        	"<br><B>" + strLang120 + "</B>" + MakeXMLString(eSubject.value) + "<br><br></DIV>" + htmlData;

        xmlHTTP.open("GET", "/ezCommunity/getItemAttachments.do?itemID=" + encodeURIComponent(pItemID) + "&mode=mail", false);
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
            var filename = SelectSingleNodeValue(AttachRows[i], "FileName");
            var filesize = SelectSingleNodeValue(AttachRows[i], "FileSize2");
            
            pstrXML += "<ROW><CELL><VALUE><![CDATA[" + filename + "]]></VALUE>";
            pstrXML += "<DATA1><![CDATA[" + filename + "]]></DATA1>";
            if (SelectSingleNodeValue(AttachRows[i], "HwpItem") == "Y") {
            	pstrXML += "<DATA2><![CDATA[" + filepath + "]]></DATA2>";
            } else {
            	pstrXML += "<DATA2><![CDATA[" + uploadCommunityPath + "/" + filepath + "]]></DATA2>";
            }
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
            if (DragDropAttachObjetLoading) {
//              AppendFileAttachInfo(pAttachListXml);
            	dadiframe.fileupload2(pAttachListXml);
            }
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
    catch (e) {console.log(e);}
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
    catch (e) {console.log(e);}
}

function ConvertEmbedImagToXml(xmlDoc, rootNode) {
    var tempDiv = document.createElement("DIV");
    tempDiv.innerHTML = message.GetEditorContent();

    var imgColl = tempDiv.getElementsByTagName("IMG");
    for (var i = 0; i < imgColl.length; i++) {
        if (imgColl.item(i).src.toLowerCase().indexOf("upload_common") > 0 || imgColl.item(i).src.toLowerCase().indexOf("mailsignimage") > 0
        	|| imgColl.item(i).src.toLowerCase().indexOf("letterboxupload") > 0 || imgColl.item(i).src.toLowerCase().indexOf("mailtemplate") > 0) {
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
            } else {
            	//2017-06-26 이효민 : 이미지 url앞에 http가 있을 경우, hostname이 서버의 hostname과 같으면 inline-image로 처리함.
            	//게시판에서 메일로 발송할 경우 inline-image url앞에 http가 붙어있어서 다음과 같이 수정하였음.
            	if (srcValue.split("/")[2] == window.location.href.split("/")[2]) {
            		var formname = imgColl.item(i).src.substr(imgColl.item(i).src.lastIndexOf("/") + 1);
            		
    	            var XmlHtml = getNodeText(SelectNodes(xmlDoc, "DATA/HTMLBODY")[0]);
    	            var OrgHteml = imgColl.item(i).outerHTML;
    	
    	            imgColl.item(i).setAttribute("src", formname);
    	            imgColl.item(i).removeAttribute("embedding");
    	            imgColl.item(i).outerHTML = imgColl.item(i).outerHTML.replace("src=\"" + formname + "\"", "src=\"" + formname + "\" embedding=\"1\" ");
    	
    	            XmlHtml = XmlHtml.replace(OrgHteml, imgColl.item(i).outerHTML);
    	            if (CrossYN())
    	                SelectNodes(xmlDoc, "DATA/HTMLBODY")[0].textContent = XmlHtml;
    	            else
    	                SelectNodes(xmlDoc, "DATA/HTMLBODY")[0].text = XmlHtml;
    	            createNodeAndInsertText(xmlDoc, rootNode, "IMAGENAME", formname);
    	            createNodeAndInsertText(xmlDoc, rootNode, "IMAGEPATH", imagePath);
            	}
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
    
    if (CrossYN()) {
        for (var i = 0; i < dadiframe.document.getElementById("filelist").childNodes.length - 1; i++) {
            if (dadiframe.document.getElementById("filelist").childNodes.length > 1) {
                if (dadiframe.document.getElementById("filelist").childNodes[i + 1].getAttribute("_big") == "Y") {
                    isBigFile = true;
                }
            }
        }
    } else {
        var bigfile = EzHTTPTrans.FileListAll();
        var bigfilelist = bigfile.split("\\");
        var bigFileYN = EzHTTPTrans.IsBigfileSizeAll();
        var bigFileYNlist = bigFileYN.split("\\");
        var bigfileCount = 0;
        for (var i = 0; i < bigfilelist.length; i++) {
            var bigFileYN = bigFileYNlist[i]
            if (bigFileYN == "Y") {
                isBigFile = true; break;
            }
        }        
    }

    var TempText = "";

    if (isBigFile) {
        TempText = "<div id='_BigAttachListHtml' style='width:100%;'><table width='100%' border='0' cellspacing='0' cellpadding='0' style='font-size:x-small;margin-bottom:10px;'>" +
                        "<tr>" +
                        "<td colspan='2' style='color:#333;font-weight:bold; padding:0px; margin:0px 0px 1px 0px; height:20px;border-bottom:1px solid #dadada;font-size:12px;'><img src='" + document.location.protocol + "//" + g_servername + "/images/icon_addfile.gif' width='7' height='12' style='margin-right:5px;'>" + strLang245 + "</td>" +
                        "</tr>";
        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open("GET", "/ezEmail/fileListSession.do?filedata=" + filedate, false);
        xmlhttp.send();
        var pAttachXml = loadXMLString(xmlhttp.responseText);
        var nodes = SelectNodes(pAttachXml, "ROOT/NODES/NODE");
        var bigAttachFileArr = [];

        //대용량 첨부 파일 순서를 첨부영역과 동일한 순서가 되도록 수정. 2020-03-18 홍대표.
        nodes = setBigFileAttachOrder(nodes);

        for (var i = 0 ; i < nodes.length ; i++) {
            if (getNodeText(GetChildNodes(nodes[i])[5]) == "Y") {
                if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") {
                	// skyblue0o0 20180709 : 모든 대용량 첨부파일 다운로드 링크에 target을 ''로 수정
                    var strTarget = "target=''";
                    var FileName = getNodeText(GetChildNodes(nodes[i])[2]);
                    FileName = replaceAll(FileName, "&", "&amp;");
                    FileName = replaceAll(FileName, "<", "&lt;");
                    FileName = replaceAll(FileName, ">", "&gt;");
                    FileName = replaceAll(FileName, '"', "&quot;");
                    var fileSize = getNodeText(GetChildNodes(nodes[i])[3]);
                    var fileLocation = getNodeText(GetChildNodes(nodes[i])[4]);
                    var fileDate = fileLocation.split("|!|")[0];
                    var strFileExt = FileName.substr(FileName.lastIndexOf('.'));
                    strFileExt = strFileExt.toLowerCase();
                    
                    /*
                    if (strFileExt == ".xls" || strFileExt == ".doc" || strFileExt == ".ppt" ||
                    strFileExt == ".eml" || strFileExt == ".pdf" || strFileExt == ".hwp" ||
                    strFileExt == ".ppt" || strFileExt == ".docx" || strFileExt == ".pptx" ||
                    strFileExt == ".xlsx" || strFileExt == ".rtf" || strFileExt == ".mp3" || strFileExt == ".zip") {
                        strTarget = "target=''";
                    }*/
                    
                    if (fileSize / 1024 / 1024 / 1024 > 1) {
                        fileSize = (Math.floor(parseFloat(fileSize / 1024 / 1024 / 1024 * 10)) / 10).toFixed(1) + "GB";
                    }
                    else if (fileSize / 1024 / 1024 > 1) {
                        fileSize = (Math.floor(parseFloat(fileSize / 1024 / 1024 * 10)) / 10).toFixed(1) + "MB";
                    }
                    else if (fileSize / 1024 > 1) {
                        fileSize = parseInt(fileSize / 1024) + "KB";
                    }
                    else {
                        fileSize = fileSize + "B";
                    }
                    
                    var EmailHref = document.location.protocol + "//" + g_servername + "/ezEmail/downloadAttachCommon.do?fileid=" + getNodeText(GetChildNodes(nodes[i])[0]) + "&filedate=" + fileDate + "&tid=" + tid;
                    TempText += "<tr>" +
                                "<td colspan='2' style='border-left:1px solid #dadada;border-right:1px solid #dadada;border-bottom:1px solid #dadada;  line-height:18px; padding:5px 10px 5px 10px; margin:0px;list-style:none;'>" +
                                "<a href='" + EmailHref + "' " + strTarget + " style='color:#333333; text-decoration: none;'><img src='" + document.location.protocol + "//" + g_servername + "/images/icon_adddownload.gif' width='16' height='16'  style='margin-right:8px; cursor:pointer;vertical-align:middle' border='0'/></a>" +
                                "<a id='BigSizeFileLink' href='" + EmailHref + "' " + strTarget + " style='color:#333333; text-decoration: none;font-size:12px;'>" + FileName + " (" + fileSize + ")</a></td>" +
                                "</tr>";
                    
                    bigAttachFileArr.push(getNodeText(GetChildNodes(nodes[i])[0]).substr(0, 36));
                }
            }
        }
        
        // 대용량첨부 파일 다운로드 횟수제한 메시지 추가 및 대용량 첨부영역 넓이 수정. 2020-03-10 홍대표.
        TempText += "<tr>" +
                    "<td width='50%' style='font-size:11px; font-weight:normal; color:#666666; padding-left:10px; margin:0px; border-bottom:1px solid #dadada;border-left:1px solid #dadada; background:#f6f6f6; height:25px; line-height:25px;'>" +
                    strLang246 + "<span style='color:#FF0000 ;'>" + _pBigAttachDownloadPeriod + "</span></td>" +
                    "<td width='50%' align='right' style='font-size:11px; font-weight:normal; color:#666666; padding-right:10px; margin:0px; border-bottom:1px solid #dadada;border-right:1px solid #dadada; background:#f6f6f6; height:25px; line-height:25px;'>" +
	                strLang247 + "<span style='color:#FF0000 ;'>" + _pBigAttachDownloadDay + strLang248 + "</span>" + strLang249;
        
        if (BigSizeAttachDownloadLimitCount == 1) {
        	TempText += " / " + strLangHDP01 + " <span style='color:#FF0000 ;'>" + BigSizeAttachDownloadLimitCount + "</span> " + strLangLS001;
        } else if (BigSizeAttachDownloadLimitCount > 1) {
        	TempText += " / " + strLangHDP01 + " <span style='color:#FF0000 ;'>" + BigSizeAttachDownloadLimitCount + "</span> " + strLangHDP02;
        }
        
        TempText += "</div></td></tr></table></div>";

        setBigAttachCountInfo(bigAttachFileArr);
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
    } catch (e) {console.log(e);}

    var BodyHTMLContent = "<style>P {MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm}</style> <div " + defaultFontAndSize + ">" + TempText + tempDiv.innerHTML + "</div>";
    
    try {
        // 본문에 <![CDATA[]]> 부분이 있으면 XML 파싱 에러가 발생하여 제거 코드 추가함.
        BodyHTMLContent = ReplaceText(BodyHTMLContent, "<!\\[CDATA\\[", "");
        BodyHTMLContent = ReplaceText(BodyHTMLContent, "\\]\\]>", "");
    } catch (e) {console.log(e);}
    
    bigMakeXmlNode(xmlDoc, rootNode, "HTMLBODY", BodyHTMLContent.replace(regex, " "));
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

    if (!CrossYN()) {
        eImportant.value = importantSelect.selectedIndex.toString();
        m_rgParams4PostOption["important"] = eImportant.value;
    }
    else if (CrossYN()) {
        m_rgParams4PostOption["important"] = importantSelect.selectedIndex.toString();
    }
    m_rgParams4PostOption["important"] = eImportant.value;
}

var letteroption_cross_dialogArguments = new Array();
function Option_onClick() {
    if (!CrossYN()) {
        EzHTTPTrans.style.display = "none";
    }    
    
    g_bDirty = true;
    letteroption_cross_dialogArguments[0] = m_rgParams4PostOption;
    letteroption_cross_dialogArguments[1] = Option_onClick_Complete;
    letteroption_cross_dialogArguments[2] = DivPopUpHidden;
    
    var requestUrl = "/ezEmail/letterOption.do";
    
    if (typeof(shareId) != "undefined" && shareId != "") {
    	requestUrl += "?shareId=" + encodeURIComponent(shareId);
    	
    	if (individualmailuser != "0") {
	        DivPopUpShow(410, 360, requestUrl);
	    } else {
	        DivPopUpShow(410, 275, requestUrl);
	    }
	} else {
		if (individualmailuser != "0") {
	        DivPopUpShow(410, 375, requestUrl);
	    } else {
	        DivPopUpShow(410, 320, requestUrl);
	    }
	}
    
    
}

/* 2023-07-21 이사라 : 본문타입 설정을 메일옵션으로 이동하여 confirm이 불필요하여 주석처리 함
					 본문타입은 mailWrite창에서도 필요하여 input hidden id="bodyType"으로 value를 저장 함  */
function changeTextOption(bodyType) {

	if (bodyType == "1") {
		//if (confirm("<spring:message code='ezEmail.lhm28' />")) {
		document.getElementById("plainTextArea").value =  message.GetEditorTextContent();
		document.getElementById("tbContentElement").style.display = "none";
		document.getElementById("plainTextArea").style.display = "";
		document.getElementById("bodyType").value = m_rgParams4PostOption["bodyType"];
		//m_rgParams4PostOption["bodyType"] = document.getElementById("bodyType").value;
		document.getElementById("SelMailSign").disabled = true;
		dadiframe.document.getElementById("btnBigFileUpload").style.display = "none";
		document.getElementById("SelMailSign").classList.add("disabled"); // plainTextDisable style
		
		// 대용량 첨부파일 없애기
		dadiframe.btnfiledel('big');
		/*} else {
    		//document.getElementById("bodyType").options[0].selected = true;
    	}*/
	} else {
		//message.SetEditorTextContent(document.getElementById("plainTextArea").value);
		document.getElementById("tbContentElement").style.display = "";
		ckeditorReload();
		document.getElementById("plainTextArea").style.display = "none";
		document.getElementById("bodyType").value = m_rgParams4PostOption["bodyType"];
		//m_rgParams4PostOption["bodyType"] = document.getElementById("bodyType").value;
		document.getElementById("SelMailSign").disabled = false;
		document.getElementById("SelMailSign").classList.remove("disabled"); // plainTextDisable style remove
		if(totBigSizeAttachMBSize == 0){
			dadiframe.document.getElementById("btnBigFileUpload").style.display = "none";
		} else {
			dadiframe.document.getElementById("btnBigFileUpload").style.display = "";
		}
	}
}

function Option_onClick_Complete(m_rgParams4PostOption) {
    DivPopUpHidden();
    importantSelect.selectedIndex = parseInt(m_rgParams4PostOption["important"]);
    if (!CrossYN()) {
        eImportant.value = importantSelect.selectedIndex.toString();
    }
    else if (CrossYN()) {
        m_rgParams4PostOption["important"] = importantSelect.selectedIndex.toString();
    }

    if (m_rgParams4PostOption["EachMail"] == "true")
        iseachMail = "true";
    else
        iseachMail = "false";

    if (m_rgParams4PostOption["secureMail"] == "Security") {
		isSecureMail = "true";
	} else {
		isSecureMail = "false";
	}
	changeTextOption(m_rgParams4PostOption["bodyType"]);
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
    receiverData["receiverCount"] = receiverCount;
    receiverData["groupAddressCountMap"] = groupAddressCountMap;
    receiverData["window"] = this;
    mail_newreceiverchoose_dialogArguments[0] = receiverData;
    mail_newreceiverchoose_dialogArguments[1] = SelectReceiver_onClick_Complete;
    var OpenWin = window.open("/ezEmail/mailNewReceiverChoose.do?defaultwin=" + SelectReceiver_Complete.szDefaultWind, "mail_foldermanage_Cross", GetOpenWindowfeature(1120, 700));
    try { OpenWin.focus(); } catch (e) {console.log(e);}
}
function SelectReceiver_onClick_Complete(pListViewMsgTo, pListViewMsgCC, pListViewMsgBCC) {
    try {
        MsgToGot.innerHTML = "";
        MsgCCGot.innerHTML = "";
        MsgBCCGot.innerHTML = "";
        receiverCount = 0;
        
        if (pListViewMsgBCC.getElementsByTagName("TR").length > 1) {
            document.getElementById("BccViewer").childNodes.item(1).src = GroupminImg;
            document.getElementById("MsgBCC_TRu").style.display = "";
            document.getElementById("MsgBCC_TR").style.display = "";
            document.getElementById("BccViewer").setAttribute("status", "on");
            
            if (isCrossBrowser == 'true') {
        		document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - $('#infoTable').height() - 240 + "PX";
        	} else {
        		document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - $('#infoTable').height() - 160 + "PX";
        	}
        }
        addReceiverOneListView(0, pListViewMsgTo);
        addReceiverOneListView(1, pListViewMsgCC);
        addReceiverOneListView(2, pListViewMsgBCC);
    } catch (e) {console.log(e);}
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
    receiverCount = 0;
    
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

function checkDLexist(groupName) {
    var result;
    
    try {
        $.ajax({
            type: "GET",
            async: false,
            url : "/ezEmail/CheckDistributionExist.do",
            dataType : "json",
            data: {
                "groupName" : groupName
                },
            success: function(data) {
                result = data.userName;
            }
        });
    }catch(e) {
            console.log("CheckDistributionExist이 동작 안함");
    }
        return result;
}
var mail_select_dlmember_cross_dialogArguments = new Array();
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
    	var eventElement = (event.target ? event.target : event.srcElement);
    	var name = eventElement.parentElement.getAttribute("name");
    	var mailAddress = eventElement.parentElement.getAttribute("email");
        var checkDistributionName = checkDLexist(name); 
        
        if(checkDistributionName != ""){
            var rtnValue = { "name": new Array(), "email": new Array() };

            mail_select_dlmember_cross_dialogArguments[0] = rtnValue;
            mail_select_dlmember_cross_dialogArguments[1] = dlmember_click_Complete;
            mail_select_dlmember_cross_dialogArguments[2] = DivPopUpHidden;
            DivPopUpShow(601, 470, "/ezEmail/mailSelectDLMember.do?name=" + javaURLEncode(name) + "&cn=" + checkDistributionName + "&mailAddress=" + mailAddress + "&newMailFlag=Y");
        } else{
            GetMailAddresses(name);
            rgParams["addrBook"] = m_addrBook;
            rgParams["g_DisplayName"] = name;
            rgParams["g_EmailAddress"] = eventElement.getAttribute("email");
            rgParams["cmd"] = "JustThis";
            checkname_cross_dialogArguments = new Array();
            checkname_cross_dialogArguments[0] = rgParams;
            checkname_cross_dialogArguments[1] = NameChange_onClick_Complete;
            checkname_cross_dialogArguments[2] = DivPopUpHidden;
            checkname_cross_dialogArguments[3] = eventElement.parentElement;
            
            if (!CrossYN()) {
                EzHTTPTrans.style.display = "none";
            }    
            
            DivPopUpShow(625, 410, "/ezEmail/mailCheckName.do");
        }
    }
}

function dlmember_click_Complete() {
    DivPopUpHidden();
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
    	decreaseReceiverCount(checkname_cross_dialogArguments[3].getAttribute("type"), checkname_cross_dialogArguments[3].getAttribute("href"));
        changedReceiverList.removeChild(checkname_cross_dialogArguments[3].parentElement);
    } else if (rgParams["recipientTDData"] == "change") {
        length = rgParams["returnedRecipientName"].length;
        
        if (length == 0) {
        	return; 
        }
        
        var isOrgElemSelected = false;
        
        for (count1 = 0; count1 < length; count1++) {
        	newElem = PrepareMailTag(checkname_cross_dialogArguments[3].getAttribute("iType"), rgParams["returnedRecipientType"][count1], rgParams["returnedRecipientName"][count1],
                    rgParams["returnedRecipientEmail"][count1], rgParams["returnedRecipientHref"][count1]);
        	
        	var IsInsert = CheckMailReceiver(newElem);
        	
        	if (!IsInsert) {
        		if (!increaseReceiverCount(rgParams["returnedRecipientType"][count1], rgParams["returnedRecipientHref"][count1])) {
            		return;
            	}
        		
        		checkname_cross_dialogArguments[3].parentElement.insertAdjacentElement("afterEnd", newElem);
        	} else {
        		if (!isOrgElemSelected) {
        			if ((checkname_cross_dialogArguments[3].getAttribute("type") === "email")
            				&& (rgParams["returnedRecipientType"][count1] === "email")
            				&& (rgParams["returnedRecipientEmail"][count1] === checkname_cross_dialogArguments[3].getAttribute("email"))) {
            			isOrgElemSelected = true;
            		} else if ((checkname_cross_dialogArguments[3].getAttribute("type") === "mailgroup")
            				&& (rgParams["returnedRecipientType"][count1] === "mailgroup")
            				&& (rgParams["returnedRecipientHref"][count1] === checkname_cross_dialogArguments[3].getAttribute("href"))) {
            			isOrgElemSelected = true;
            		}
        		}
        	}
        }
        
        if (!isOrgElemSelected) {
        	decreaseReceiverCount(checkname_cross_dialogArguments[3].getAttribute("type"), checkname_cross_dialogArguments[3].getAttribute("href"));
        	changedReceiverList.removeChild(checkname_cross_dialogArguments[3].parentElement);
        }
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
                    var name = childElem.getAttribute("name");
                    var email = childElem.getAttribute("email");

                    var regex = /^(.*?)<([^>]+)>$/;
                    var match = name.match(regex);

                    if (match) {
                        name = match[1].trim(); // "<" 밖의 부분
                        email = match[2].trim(); // "<" 안의 부분
                    }

                    retAddr += "\"" + TrimText(ReplaceText(name.replace('"', "&quot;"), ";", "")) + "\"";
                    retAddr += " <" + email + ">";
                    retAddr += ", "

                    break;
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

    if (ReplaceText(retAddr, " ", "") != "") {
        retAddr = retAddr.substr(0, retAddr.length - 2);
        
        if (gInvalidAddressArr != null) {
            var retAddrArr = retAddr.split(", ");
            var newRetAddr = "";
        
            for (var i = 0; i < retAddrArr.length; i++) {
                var addr = retAddrArr[i];
                var isInvalidAddr = false;
                
                for (var j = 0; j < gInvalidAddressArr.length; j++) {            
                    if (addr.indexOf("<" + gInvalidAddressArr[j] + ">") > -1) {
                        isInvalidAddr = true;
                        break;
                    }
                }
                
                if (!isInvalidAddr) {
                    if (addr != "") {
                        newRetAddr += addr + ", ";
                    }
                }
            }
            
            retAddr = newRetAddr;
        }
        
        return retAddr;
    } else {
        return "";
    }
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
    // 앞 뒤로 따옴표 제거
    name = name.replace(/^["']/, "").replace(/["']$/, "");
    email = email.replace(/^["']/, "").replace(/["']$/, "");
    
    // 수신인 추가 정보 (부서 이름 또는 이메일 주소)
    if (g_useAdditionalInfo) {
    	$.ajax({
    		type	: "GET",
    		data	: {name: name, email: email},
    		contentType : "application/json;charset=utf-8",
    		url		: "/ezEmail/mailGetUserAdditionalInfo.do",
    		async	: true,
    		success	: function(additionalInfo) {
    			var targetElem = document.querySelector("#infoTable span[itype='" + iWhich + "'][email='" + email + "']");
    			
    			if (type == "mailgroup") {
    				newElem.innerHTML = "<u title=\"" + strLang126 + "\" alt=\"" + strLang126 + "\" >" + name + additionalInfo + "</u>; ";
    				newElem.parentElement.innerHTML += "<img src='/images/icon/oneline_delete.gif' onclick='deleteMailUser(\"" + type + "\",\"" + iWhich + "\",\"" + href + "\")' style='width:10px;height:10px;cursor:pointer;'/>";
    			} else {
    				newElem.innerHTML = "<u title=\"" + email + "\" alt=\"" + email + "\" >" + name + additionalInfo + "</u>; ";
    				newElem.parentElement.innerHTML += "<img src='/images/icon/oneline_delete.gif' onclick='deleteMailUser(\"" + email + "\",\"" + iWhich + "\")' style='width:10px;height:10px;cursor:pointer;'/>";
    			}
    		},
    		error	: function(error) {
    			console.log(error);
    		}
    	});
    }
    
    newElem.style.cursor = "move"; // [메일쓰기] TO/CC/BCC란 기입 시 MsgTo/CC/BCCGot
    newElem.setAttribute("iType", iWhich); //newElem.getAttribute("iType") = iWhich;
    newElem.setAttribute("onclick", "NameChange_onClick()");
    newElem.setAttribute("type", type);//newElem.getAttribute("type") = type;
    newElem.setAttribute("name", name);//newElem.getAttribute("name") = name;	
    newElem.setAttribute("email", email);// newElem.getAttribute("email") = email;

    if (type == "mailgroup") {
    	newElem.setAttribute("href", href);
    	newElem.style.fontWeight = "bold";
        newElem.style.color = inMailColor;
        
        TopSpan.appendChild(newElem);
        
        if (!g_useAdditionalInfo) {
        	newElem.innerHTML = "<u title=\"" + strLang126 + "\" alt=\"" + strLang126 + "\" >" + name + "</u>; ";
        	TopSpan.innerHTML += "<img src='/images/icon/oneline_delete.gif' onclick='deleteMailUser(\"" + type + "\",\"" + iWhich + "\",\"" + href + "\")' style='width:10px;height:10px;cursor:pointer;'/>";
        }
    } else {
    	var innerDomainList = InnerDomain.toLowerCase().split(';');
    	var emailDomain = email.split('@')[1].toLowerCase();
    	var isInnerDmain = false;
    	
    	for (var i = 0; i < innerDomainList.length; i++) {
    		if (emailDomain == innerDomainList[i]) {
    			isInnerDmain = true;
    			break;
    		}
    	}
    	
    	if (isInnerDmain) {
    		newElem.style.color = inMailColor;
    	} else {
    		newElem.style.color = outMailColor;
    	}
        
        
        TopSpan.appendChild(newElem);
        
        if (!g_useAdditionalInfo) {
        	newElem.innerHTML = "<u title=\"" + email + "\" alt=\"" + email + "\" >" + name + "</u>; ";
        	TopSpan.innerHTML += "<img src='/images/icon/oneline_delete.gif' onclick='deleteMailUser(\"" + email + "\",\"" + iWhich + "\")' style='width:10px;height:10px;cursor:pointer;'/>";
        }
    }

    return TopSpan;
}

function addReceiverOneListView(iWhich, pListView) {
    var szReceiver;
    var recvName, recvAddr;

    var newElem;

    for (var nCnt1 = 1; nCnt1 < pListView.getElementsByTagName("TR").length; nCnt1++) {
        g_bDirty = true;
        
        if (!increaseReceiverCount(pListView.getElementsByTagName("TR")[nCnt1].getAttribute("DATA2"), pListView.getElementsByTagName("TR")[nCnt1].getAttribute("DATA4"))) {
    		return;
    	}
        
        if (pListView.getElementsByTagName("TR")[nCnt1].getAttribute("DATA2") == "mailgroup") {
            newElem = PrepareMailTag(iWhich, "mailgroup",
                    pListView.getElementsByTagName("TR")[nCnt1].getAttribute("DATA1"),
                    pListView.getElementsByTagName("TR")[nCnt1].getAttribute("DATA3"),
                    pListView.getElementsByTagName("TR")[nCnt1].getAttribute("DATA4"));
        } else {
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
    
    if (iWhich < 0 || iWhich > 2) {
    	return;
    }
    
    if (typeof (receiverlist) == "undefined") {
    	return;
    }

    for (var nCnt1 = 0; nCnt1 < receiverlist["name"].length; nCnt1++) {
        recvType = receiverlist["type"][nCnt1];
        recvName = receiverlist["name"][nCnt1];
        recvEmail = receiverlist["email"][nCnt1];
        recvHref = receiverlist["href"][nCnt1];
        
        if (!increaseReceiverCount(recvType, recvHref)) {
    		return;
    	}
        
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
	return /^[-A-Za-z0-9_]+[-A-Za-z0-9_.]*[@]{1}[-A-Za-z0-9_]+[-A-Za-z0-9_.]*[.]{1}[A-Za-z]{2,10}$/.test(mailAddr);
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
var g_originalPlainText = "";

function pzFormProc_FieldsAvailable() {
    tbContentElement.ShowWorkingDlg("", false);
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

// UNUSED: 쓰이는 곳이 없는 것으로 보임.
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

function deleteMailUser(email, iWhich, href) {

    if(!CrossYN())
        window.event.cancelBubble = true;

    switch (iWhich) {
        case "0":
            for (var i = 0; i < MsgToGot.children.length; i++) {
            	if (email == "mailgroup" && GetChildNodes(GetChildNodes(MsgToGot)[i])[0].getAttribute("href") == href) {
            		decreaseReceiverCount(email, href);
                	MsgToGot.removeChild(GetChildNodes(MsgToGot)[i]);
                	
                	return;
        		} else if (GetChildNodes(GetChildNodes(MsgToGot)[i])[0].getAttribute("email") == email) {
        			decreaseReceiverCount();
        			MsgToGot.removeChild(GetChildNodes(MsgToGot)[i]);
        			
                    return;
                }
            }

        case "1":
            for (var j = 0; j < MsgCCGot.children.length; j++) {
            	if (email == "mailgroup" && GetChildNodes(GetChildNodes(MsgCCGot)[j])[0].getAttribute("href") == href) {
            		decreaseReceiverCount(email, href);
                	MsgCCGot.removeChild(GetChildNodes(MsgCCGot)[j]);
                	
                	return;
        		} else if (GetChildNodes(GetChildNodes(MsgCCGot)[j])[0].getAttribute("email") == email) {
        			decreaseReceiverCount();
                	MsgCCGot.removeChild(GetChildNodes(MsgCCGot)[j]);
                	
                	return;
                }
            }

        case "2":
            for (var k = 0; k < MsgBCCGot.children.length; k++) {
            	if (email == "mailgroup" && GetChildNodes(GetChildNodes(MsgBCCGot)[k])[0].getAttribute("href") == href) {
            		decreaseReceiverCount(email, href);
                	MsgBCCGot.removeChild(GetChildNodes(MsgBCCGot)[k]);
                	
                	return;
        		} else if (GetChildNodes(GetChildNodes(MsgBCCGot)[k])[0].getAttribute("email") == email) {
        			decreaseReceiverCount();
                	MsgBCCGot.removeChild(GetChildNodes(MsgBCCGot)[k]);
                	
                	return;
                }
            }
    }
}


var exportOption_cross_dialogArguments = new Array();

function mailExportOption_onClick(type) {
	
    if (!CrossYN()) {
        EzHTTPTrans.style.display = "none";
    }    
    
    g_bDirty = true;
    exportOption_cross_dialogArguments[1] = mailExportOption_onClick_Complete;
    exportOption_cross_dialogArguments[2] = DivPopUpHidden;
    
    DivPopUpShow(460, 240, "/ezEmail/mailExportOption.do?exportType=" + type);
}

function mailExportOption_onClick_Complete(m_rgParams4PostOption) { }

var importOption_cross_dialogArguments = new Array();

function mailImportOption_onClick(tempId, userkey) {
    
	if (!CrossYN()) {
        EzHTTPTrans.style.display = "none";
    }    
    
    g_bDirty = true;
    importOption_cross_dialogArguments[1] = mailImportOption_onClick_Complete;
    importOption_cross_dialogArguments[2] = DivPopUpHidden;
    
    DivPopUpShow(460, 190, "/ezEmail/mailImportOption.do?tempId=" + tempId + "&userkey=" + userkey);
}

function mailImportOption_onClick_Complete(m_rgParams4PostOption) { }

//baonk added
function getEmailAddressList2(ReceiverList, pollSendType) {
    var retVal = {
        "type": new Array(),
        "name": new Array(),
        "email": new Array(),
        "href": new Array()
    };
    
    var jsonReceiverList = JSON.parse(ReceiverList);
    
    if (pollSendType == "one") {
         retVal["name"][0] = jsonReceiverList["userName"];
         retVal["type"][0] = "email";
         retVal["email"][0] = jsonReceiverList["email"];
         retVal["href"][0] = "";
    }
    else {
    	for (var i = 0; i < jsonReceiverList.length; i++) {
            retVal["name"][i] = jsonReceiverList[i]["userName"];
            retVal["type"][i] = "email";
            retVal["email"][i] = jsonReceiverList[i]["email"];
            retVal["href"][i] = "";
    	}
    }

    return retVal;
}

function attach_Add_OtherModule(ofileName, ofileHref, ofileAttachSize) {
    //파일리스트 가져오기
    g_fileList = ofileName;

    //파일 사이즈 체크
    var fileSize = 0;
    var fileSize2 = 0;
    var tmpFileSize = 0;
    var pBigFileUploadYN = "N";
    var fileLen = g_fileSizelist.length;
    var strPrint = "";
    if (g_fileList.length == 0)
        return;

    for (var i = 0; i < g_fileList.length; i++) {
        tmpFileSize = Number(ofileAttachSize[i]);
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

    /* 2023-09-01 홍승비 - 전자결재문서 메일발송 > 대용량 첨부파일 자동삭제 알러트 메세지 중복 표출되지 않도록 수정 (mailDragAndDrop 페이지의 알러트를 사용) */
    if ((BigSizeAttach == false) && (pBigFileUploadYN == "Y")) {
        //alert(strLang77 + BigSizeAttachMBSize + "MB" + strLang78 + BigSizeMailAttachDelDay + strLangLS04);
        BigSizeAttach = true;
        pBigFileUpload = "Y";
    }

    //EzHTTPTrans.AddUploadFile("", "");

    //파일 추가
    var nCount = 0;
    var extFlag = false;
    var xmlDoc = createXmlDom();
    var objRoot = createNodeInsert(xmlDoc, objRoot, "DATA");
    createNodeAndInsertText(xmlDoc, objRoot, "CMD", "ADD");
    createNodeAndInsertText(xmlDoc, objRoot, "URL", g_url);
    var objNode = createNodeAndAppandNode(xmlDoc, objRoot, objNode, "FILELIST");

    var fileNamelist = "";
    var fileName = "";
    var savefileNamelist = "";
    var pBigSizefileListYN = "Y";
    var g_fileGBList = new Array();
    for (var i = 0; i < g_fileList.length; i++) {
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

            //EzHTTPTrans.AddUploadFile(g_fileList[i], pTmpBigFileUpload);
            g_fileGBList[i] = pTmpBigFileUpload;
            if (pTmpBigFileUpload != "Y") {
            }

            var strFileName = g_fileList[i].substr(0, g_fileList[i].lastIndexOf('.'));
            var strFileExt = g_fileList[i].substr(g_fileList[i].lastIndexOf('.') + 1);

            //첨부파일 업로드
            var xmlhttp2 = createXMLHttpRequest();
            var xmlDoc2 = createXmlDom();
            var objRoot = createNodeInsert(xmlDoc2, objRoot, "DATA");
            createNodeAndInsertText(xmlDoc2, objRoot, "guid", "");
            createNodeAndInsertText(xmlDoc2, objRoot, "ext", strFileExt);//확장자
            createNodeAndInsertText(xmlDoc2, objRoot, "dir", "/Upload_DocManagement");
            createNodeAndInsertText(xmlDoc2, objRoot, "prefix", "DocManagement");
            createNodeAndInsertText(xmlDoc2, objRoot, "newid", g_newid);
            createNodeAndInsertText(xmlDoc2, objRoot, "name", strFileName);//첨부파일명
            createNodeAndInsertText(xmlDoc2, objRoot, "filedata", pTmpBigFileUpload);//대용량첨부YN
            createNodeAndInsertText(xmlDoc2, objRoot, "filename", "");
            createNodeAndInsertText(xmlDoc2, objRoot, "sid", "");
            createNodeAndInsertText(xmlDoc2, objRoot, "filehref", ofileHref[i]);
            createNodeAndInsertText(xmlDoc2, objRoot, "fileTypeCode", ofileTypeCode[i]);
            createNodeAndInsertText(xmlDoc2, objRoot, "fileUrl", ofileUrl[i]); // 2023-05-16 김우철 - 웹한글기안기 서버에서 배포용 문서 파일을 다운로드하기 위한 URL 배열
            xmlhttp2.open("POST", "/ezApprovalG/mail_interuploadX_Server.do", false);
            xmlhttp2.send(xmlDoc2);
            var rtnInfo = xmlhttp2.responseText;
            
            if (rtnInfo != "ERROR") {
                var filename = g_fileList[i];
                var filesize = ofileAttachSize[i];
                var filePath = rtnInfo.split('_kaonisplit_')[0];
                
                // 2023-05-16 김우철 - tempFileUpload에 임시저장한 경로를 ofileCopyPath 배열에 저장
                ofileCopyPath[i] = filePath;
                var BigYN = rtnInfo.split('_kaonisplit_')[1].split('_')[0];
                var extYN = rtnInfo.split('_kaonisplit_')[1].split('_')[1];

                if (extYN == "OK") {
                    var subNodes, subNode;
                    subNodes = createNodeAndAppandNode(xmlDoc, objNode, subNodes, "FILE");
                    createNodeAndAppandNodeText(xmlDoc, subNodes, subNode, "NAME", filename);
                    createNodeAndAppandNodeText(xmlDoc, subNodes, subNode, "PATH", filePath);
                    createNodeAndAppandNodeText(xmlDoc, subNodes, subNode, "BIG", BigYN);
                    createNodeAndAppandNodeText(xmlDoc, subNodes, subNode, "SIZE", filesize);
                    createNodeAndAppandNodeText(xmlDoc, subNodes, subNode, "ITEMID", "Y");
                }
                else {
                    extFlag = true;
                }

                nCount++;
            }

        }
        catch (e) {
            alert(g_fileList[i] + " " + strLang85 + "\n\n" + e.number + " - " + e.description);
            return;
        }
    }
    
    
    if (nCount == 0) {
        alert(strLang89);
        var isBigSizeAttach = false;

        for (var i = 0 ; i < g_fileBigSizeYN.length ; i++) {
            if (g_fileBigSizeYN[i] == "Y") {
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

    if (extFlag)
        alert(strLang323);
    
    var pstrXML = "";
    if (g_fileList.length > 0) {
        pstrXML += "<LISTVIEWDATA><HEADERS>";
        pstrXML += "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
        pstrXML += "<HEADER><NAME>" + strLang3 + "</NAME><WIDTH>50</WIDTH></HEADER>";
        pstrXML += "</HEADERS><ROWS>";
    }

    for (var i = 0; i < g_fileList.length; i++) {
    	var filepath = "";
    	
    	if (useHwpDownSecurity == "Y" && approvalFlag == "G") {
    		filepath = ofileCopyPath[i];
    	} else {
    		filepath = ofileHref[i];
    	}
    	
        var filename = ofileName[i];
        var filesize = ofileAttachSize[i];
        if (filesize == "0" && filepath.substring(filepath.toLowerCase().lastIndexOf(".") + 1) == "hwp") {
            filename = filename + ".hwp";
            filesize = strLang116;
        }
        else if ((filesize == "0" || filesize == "") && filepath.substring(filepath.toLowerCase().lastIndexOf(".") + 1) == "mht") {
            filename = filename + ".mht";
            filesize = strLang116;
        }
		
        pstrXML += "<ROW><CELL><VALUE><![CDATA[" + filename + "]]></VALUE>";
        pstrXML += "<DATA1><![CDATA[" + filename + "]]></DATA1>";
        pstrXML += "<DATA2><![CDATA[" + filepath + "]]></DATA2>";
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
    }
    
    dadiframe.fileupload2(pAttachListXml);            	
    xmlhttp = null;
}


function replaceAll(str, searchStr, replaceStr) {
	return str.split(searchStr).join(replaceStr);
}

function getGroupAddressMemberCount(addressId) {
	var count = $.ajax({
    	type : "GET",
    	dataType : "text",
    	url : "/ezAddress/getGroupAddressMemberCount.do",
    	data : {id : addressId},
    	async : false
    }).responseText;
	
	return parseInt(count);
}

function increaseReceiverCount(pType, pHref) {
	if (typeof pType !== 'undefined' && typeof pHref !== 'undefined') {
		if (pType == "mailgroup") {
			var addressId = pHref.split("|!|")[0];
			var count = getGroupAddressMemberCount(addressId);
			
			if (mailMaxReceiverCount < receiverCount + count) {
				alert(strLangReceiverCount01 + mailMaxReceiverCount + strLangReceiverCount02);
	            return false;
			}
			
			groupAddressCountMap[addressId] = count;
			receiverCount += count;
		} else {
			if (mailMaxReceiverCount < receiverCount + 1) {
				alert(strLangReceiverCount01 + mailMaxReceiverCount + strLangReceiverCount02);
	            return false;
			}
			
			receiverCount += 1;
		}
	} else {
		if (mailMaxReceiverCount < receiverCount + 1) {
			alert(strLangReceiverCount01 + mailMaxReceiverCount + strLangReceiverCount02);
            return false;
		}
		
		receiverCount += 1;
	}
	
	return true;
}

function decreaseReceiverCount(pType, pHref) {
	if (typeof pType !== 'undefined' && typeof pHref !== 'undefined') {
		if (pType == "mailgroup") {
	    	var addressId = pHref.split("|!|")[0];
	    	receiverCount -= groupAddressCountMap[addressId];
	    	delete groupAddressCountMap[addressId];
	    } else {
	    	receiverCount -= 1;
	    }
	} else {
		receiverCount -= 1;
	}
}

function preMailRead(Href) {
	if(event_SaveonClick.savemode != 'preview' && !previewChk) {return; }

    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var conWidth = pwidth * 0.8;
    if (conWidth > 890)
        conWidth = 890;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - 890) / 2;
    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
    
	var pURI = "/ezEmail/mailRead.do?iptURL=" + encodeURIComponent(Href) + "&PNFlag=Y&CONTENTCLASS=PREVIEW";
    
    if (typeof(shareId) != "undefined" && shareId != "") {
    	pURI += "&shareId=" + encodeURIComponent(shareId);
    }
    
    ReadMailOpenNewWin = window.open(pURI, "ReadMailOpenNewWin", feature);
    
    if (ReadMailOpenNewWin != null) {
    	window.ReadMailOpenNewWin.focus();
    }
}

function preMailReadSend(Href) {
	if(event_SaveonClick.savemode != 'previewSend' && !previewChk) {return; }

    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var conWidth = pwidth * 0.8;
    if (conWidth > 890)
        conWidth = 890;
    //var pTop = (pheight - conHeight) / 2;
    //var pLeft = (pwidth - 890) / 2;
    var pLeft = window.outerWidth / 2 + window.screenX - (conWidth / 2);
    var pTop = window.outerHeight / 2 + window.screenY - (conHeight / 2);
    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1";

	var pURI = "/ezEmail/mailRead.do?iptURL=" + encodeURIComponent(Href) + "&PNFlag=Y&CONTENTCLASS=PREVIEWSEND";

    if (typeof(shareId) != "undefined" && shareId != "") {
    	pURI += "&shareId=" + encodeURIComponent(shareId);
    }

    ReadMailOpenNewWin = window.open(pURI, "ReadMailOpenNewWin", feature);

    if (ReadMailOpenNewWin != null) {
    	window.ReadMailOpenNewWin.focus();
    }
}

function setBigFileAttachOrder(nodes) {
	var tempBigAttachArr = dadiframe.document.querySelectorAll("#lstAttachLink tr[_big='Y']");
	var tempNodes = [];
	
	for (var i = 0; i < nodes.length; i++) {
		var pUploadSN = getNodeText(GetChildNodes(nodes[i])[0]);
		for (var j = 0; j < tempBigAttachArr.length; j++) {
			if (pUploadSN == tempBigAttachArr[j].getAttribute("value")) {
				tempNodes[j] = nodes[i];
			}
		}
	}
	
	return tempNodes;
}

function callMoveAttachFileOrder() {
    var tmpFileList = dadiframe.document.querySelectorAll("#filelist tr[_fileindex]");
    if(tmpFileList.length > 0) {
    	dadiframe.moveAttachFileOrder(tmpFileList);
    }
}

function setBigAttachCountInfo (bigAttachArr) {
	$.ajax({
		type	: "POST",
		data	: {
			bigAttach : bigAttachArr,
			BigSizeAttachDownloadLimitCount : BigSizeAttachDownloadLimitCount
		},
		dataType: "text",
		url		: "/ezEmail/setBigAttachCountInfo.do",
		async	: true,
		success	: function(res) {
//			alert("setBigAttachCountInfo success");
		},
		error	: function(error) {
			console.log(error);
		}
	});
}

/* 2023-05-16 김우철 - 메일 작성 시 파일을 배포용 문서로 변환할 때, Whwp api가 비동기로 호출되는 것을 제어하기 위한 재귀함수 */
function hwp_url(p_num, arrayLength) {
	// p_num은 각 첨부파일의 배열 인덱스이며, 파일 전체 개수보다 같거나 많아지는 경우 attach_Add_OtherModule 함수 호출
	if (p_num >= arrayLength) {
		return attach_Add_OtherModule(ofileName, ofileHref, ofileAttachSize, ofileTypeCode);
	} else {
		if (isHwpCtrlOpen != true) {
			alert(strLangKWCHd01);
			return;
		}
		
		var strFileExt = ofileName[p_num].substr(ofileName[p_num].lastIndexOf('.') + 1);
		if (useHwpDownSecurity == "Y" && approvalFlag == "G" && strFileExt.toUpperCase() == "HWP" && ofileTypeCode[p_num] == "document") {
			var doc = HwpCtrl.Open(window.location.origin + ofileHref[p_num], "HWP", "", function(res) {
				// console.log("res" + p_num + " : " + JSON.stringify(res));
				if (res.result) {
       				var dact = HwpCtrl.CreateAction("FileSetSecurity");
					var dset = dact.CreateSet();
					
					dact.GetDefault(dset);
					
					// 패스워드 설정
					dset.SetItem("Password", HwpSecurityNum);
					
					// 프린트 사용여부
					dset.SetItem("NoPrint", true);
					
					// 복사 방지
					dset.SetItem("NoCopy", true);
					
					var rtn = dact.Execute(dset, function(action, param, result, userData) {
						// 배포용 문서는 웹한글기안기 서버 상에 저장되며, ofileUrl[p_num]에는 웹한글기안기 서버에서 해당 파일을 다운로드하기 위한 URL이 저장됨
   						ofileUrl[p_num] = result.downloadUrl;
   						ofileAttachSize[p_num] = result.size; // 배포용 문서는 파일 사이즈가 달라지므로 재설정
   						p_num++;
   						
   						return hwp_url(p_num, arrayLength);
					});
       			} else {
       				alert(strLangKWCHd01);
       				return;
       			}
			});	
		} else {
			ofileUrl[p_num] = "noUrl";
			p_num++;
			
			return hwp_url(p_num, arrayLength);
		}
	}
}

//승인메일 정책 체크 로직
var appr_approverSetting_arg = new Object();
async function apprPolicy(savemode) {
	const chkPolicy = await checkApprPolicy(); 	
	
	if ("OK" != chkPolicy) {
		// 예약발송은 승인메일을 할 수 없음
		if (m_rgParams4PostOption["delaySendDate"] !== "") {
			alert(strLangAppr04); return;
		}
		
		if ("ALL_HANDS" == chkPolicy) {
			g_apprMailType = "ALL_HANDS";
			
			g_apprMail = (confirm(strLangAppr05));
		} else if ("ERROR" == chkPolicy) {
			alert(strLangAppr03); return;
		} else {
			g_apprMailType = "NORMAL";
			
			var param = "?shareId=" + shareId;
			
			appr_approverSetting_arg.savemode = savemode;
			appr_approverSetting_arg.complete = apprComplete;
			DivPopUpShow(600, 600, "/ezEmail/appr/approverSettingPopUp.do" + param);
		}
	} else {
		return 1;
	}
}

//승인자or대결자 지정 했을 때 
function apprComplete(savemode, approver) {
	g_apprMail = true;
	g_apprMailApprover = approver;
	Save_onClick(savemode);
}

function checkApprPolicy() {
	return new Promise((resolve, reject) => {
		// 첨부파일 유무 체크
		var hasBigAttachInBody = (message.GetEditorBody().querySelectorAll("#_BigAttachListHtml #BigSizeFileLink").length > 0); // 메일 본문에 대용량첨부파일이 있는지 확인
		var hasAttachInUpload = (dadiframe.document.querySelectorAll("#filelist tr[newfile]").length > 0); // 첨부파일 업로드 위치에 첨부파일이 있는지 확인
		
		let hasAttach = (hasBigAttachInBody || hasAttachInUpload); 
		
		$.ajax({
			type: "POST",
			url: "/ezEmail/appr/checkApprPolicy.do",
			data : {
				"hasAttach" : hasAttach,
				"msgTo" : GetAddrFormatForSend(MsgToGot),
				"msgCC" : GetAddrFormatForSend(MsgCCGot),
				"msgBCC" : GetAddrFormatForSend(MsgBCCGot),
				"shareId" : ((typeof(shareId) != "undefined" && shareId != "") ? shareId : "")
			},
			success: function(e) {
				resolve(e);
			},
			error: function(e) {
				resolve("ERROR");
			}
		});
	});
}
// 2025.02.11 한슬기 : 나를 항상 참조에 포함 설정시 메일쓰기창을 열었을 때 나를 자동으로 참조에 포함
function setSelfCcOrBcc(){
    var iWhich = 0;
    if (selfCcOption == 'cc') {
        iWhich = 1;
    } else if (selfCcOption == 'bcc') {
        iWhich = 2;
    }

    var newElem = PrepareMailTag(iWhich, "email", g_myname, g_myemail, "");

    newElem.id = "selfCcOrBcc"
    if (selfCcOption === 'cc'){
        MsgCCGot.appendChild(newElem);
    } else if (selfCcOption === 'bcc'){
        MsgBCCGot.appendChild(newElem);
    }
}

/**
 * 2025.06.09 한슬기
 * 메일 > 기본환경설정 나를 항상 참조에 포함 설정을 사용하는경우 
 * -> 내게쓰기시 참조/숨은참조에 나를 넣어줄때 id도 함께 부여한다(내가 중복으로 들어가지 않도록 id를 찾아 지워주기 위해).
 * @param iWhch 0:수신자 1:참조 2:숨은참조
 * @param g_myemail 내게쓰기 이메일주소
 */
function setIDSelfCcOrBcc(iWhch, g_myemail){
    var spans = "";
    if (iWhch == 1) {
        spans = MsgCCGot.querySelectorAll("span");
    } else if (iWhch == 2) {
        spans = MsgBCCGot.querySelectorAll("span");
    }
    spans.forEach(span => {
        var innerSpan = span.querySelector("span[email]");
        if (innerSpan && innerSpan.getAttribute("email") === g_myemail) {
            span.id = "selfCcOrBcc";
        }
    });

}
