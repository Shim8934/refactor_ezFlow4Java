function close_onclick() {
    if (!confirm("" + strLang8 + ""))
        window.close();
    else
        save_task();
}

function show_personinfo(userid) {
    if (userid == "0")
        userid = creatorid;

    var heigth = window.screen.availHeight;
	var width = window.screen.availWidth;
	var left = (width - 420) / 2;
	var top = (heigth - 450) / 2;
	window.open("/ezCommon/showPersonInfo.do?id=" + userid, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
}

function taskstatus_change() {
    var rate = document.getElementById("completerateSelect").value;
    var status = document.getElementById("taskstatusSelect").value;

    if (status == "3") {
        document.getElementById("completerateSelect").value = "100";
        return;
    }

    if (status == "1") {
        document.getElementById("completerateSelect").value = "0";
        return;
    }

    if (rate == "100") {
        document.getElementById("completerateSelect").value = "10";
        return;
    }
}

function rate_change() {
    var rate = document.getElementById("completerateSelect").value;
    var status = document.getElementById("taskstatusSelect").value;

    if (rate == "100") {
        document.getElementById("taskstatusSelect").value = "3";
        return;
    }

    if (rate == "0") {
        if (status == "3")
            document.getElementById("taskstatusSelect").value = "1";
        return;
    }

    if (status == "1" || status == "3")
        document.getElementById("taskstatusSelect").value = "2";
}

var task_select_entity_cross_dialogArguments = new Array();
var m_type;
function manage_share(type) {
    switch (type) {
        case 1:
            m_type = 1;
            task_select_entity_cross_dialogArguments[0] = g_person;
            task_select_entity_cross_dialogArguments[1] = manage_share_Complete;
            var OpenWin = window.open("/ezTask/taskSelectEntity.do?title=" + encodeURI(strLang15) + "", "taskSelectEntity", GetOpenWindowfeature(970, 655));
            try { OpenWin.focus(); } catch (e) { }
            break;
        case 2:
            m_type = 2;
            task_select_entity_cross_dialogArguments[0] = g_share;
            task_select_entity_cross_dialogArguments[1] = manage_share_Complete;
            var OpenWin = window.open("/ezTask/taskSelectEntity.do?title=" + encodeURI(strLang15) + "", "taskSelectEntity", GetOpenWindowfeature(970, 655));
            try { OpenWin.focus(); } catch (e) { }
            break;
    }
}

function manage_share_Complete(retVal) {
    switch (m_type) {
        case 1:
            if (typeof (retVal) != "undefined") {
                if (retVal["id"].length > 1) {
                    alert(strLang54);
                    return;
                }
                if (g_share != null) {
                    for (var i = 0; i < g_share["email"].length; i++) {
                        if (retVal["email"][0] == g_share["email"][i]) {
                            alert(retVal["name"][0] + strLang55);
                            return;
                        }
                    }
                }
                g_person = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };

                if (retVal["id"].length == 0) {
                    setNodeText(document.getElementById("personlist"), "");
                    return;
                }

                setNodeText(document.getElementById("personlist"), retVal["name"][0]);

                g_person["name"][0] = retVal["name"][0];
                g_person["id"][0] = retVal["id"][0];
                g_person["deptname"][0] = retVal["deptname"][0];
                g_person["name1"][0] = retVal["name1"][0];
                g_person["name2"][0] = retVal["name2"][0];
                g_person["deptname2"][0] = retVal["deptname2"][0];
                g_person["email"][0] = retVal["email"][0];
            }
            break;
        case 2:

            if (typeof (retVal) != "undefined") {
                g_share = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };

                setNodeText(document.getElementById("sharelist"), "");

                var j = 0;
                for (var i = 0; i < retVal["id"].length; i++) {
                    if (g_person != null && g_person["email"][0] == retVal["email"][i]) {
                        alert(retVal["name"][i] + strLang56);
                    }
                    else {
                        if (getNodeText(document.getElementById("sharelist")) == "")
                            setNodeText(document.getElementById("sharelist"), retVal["name"][i]);
                        else
                            setNodeText(document.getElementById("sharelist"), getNodeText(document.getElementById("sharelist")) + ", " + retVal["name"][i]);

                        g_share["name"][j] = retVal["name"][i];
                        g_share["id"][j] = retVal["id"][i];
                        g_share["deptname"][j] = retVal["deptname"][i];
                        g_share["name1"][j] = retVal["name1"][i];
                        g_share["name2"][j] = retVal["name2"][i];
                        g_share["deptname2"][j] = retVal["deptname2"][i];
                        g_share["email"][j] = retVal["email"][i];
                        j++;
                    }
                }
                break;
            }
    }
}


function on_keydown(evt) {
    if (window.event) {
        if (evt.keyCode != 13)
            return;
    }
    else {
        if (evt.which != 13)
            return;
    }
    if (CrossYN()) {
        evt.preventDefault();

    }
    else {
        evt.returnValue = false;
    }
    check_name();
}
var retcheck = "";
function check_name() {
    var name = document.getElementById("shareInput").value;
    name = ReplaceText(name, ",", ";");

    var names = name.split(";");

    for (var i = 0; i < names.length; i++) {
        names[i] = TrimText(names[i]);

        if (names[i] == "")
            continue;

        var adCount = 0;
        var xmlHTTP = createXMLHttpRequest();
        var xmlDOM = createXmlDom();
        var objNode;
        createNodeInsert(xmlDOM, objNode, "DATA");
        createNodeAndInsertText(xmlDOM, objNode, "SEARCH", "displayname::" + names[i]);
        createNodeAndInsertText(xmlDOM, objNode, "CELL", "company;description;title;displayname;mail");
        createNodeAndInsertText(xmlDOM, objNode, "PROP", "displayname;description");
        createNodeAndInsertText(xmlDOM, objNode, "TYPE", "user");

        try {
            xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetSearchList.aspx", false);
            xmlHTTP.send(xmlDOM);

            if (xmlHTTP.statusText != "OK") {
                alert("" + strLang16 + "" + xmlHTTP.statusText);
                xmlDOM = null;
                xmlHTTP = null;
                continue;
            }
            else {
                xmlDOM = loadXMLString(xmlHTTP.responseText);
                adCount = xmlDOM.getElementsByTagName("ROW").length;
            }
        } catch (e) {
            alert("" + strLang16 + "" + e.description);
            xmlDOM = null;
            xmlHTTP = null;
            continue;
        }

        if (adCount == 0) {
            alert("'" + names[i] + "' " + strLang17 + "");
            continue;
        }
        else if (adCount == 1) {
            if (g_share == null)
                g_share = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };

            if (xmlDOM.getElementsByTagName("DATA2").item(0).text != userid) {
                var length = g_share["name"].length;
                for (var j = 0; j < length; j++)
                    if (g_share["id"][j] == getNodeText(xmlDOM.getElementsByTagName("DATA2")[0])) {
                        alert("" + strLang18 + "");
                        return;
                    }
            }
            else
            {
                alert("" + strLang20 + "");
                return;
            }
            var nodes = SelectNodes(xmlDOM, "LISTVIEWDATA/ROWS/ROW/CELL");
            g_share["name"][length] = getNodeText(GetChildNodes(nodes[3])[0]);
            g_share["id"][length] = getNodeText(GetChildNodes(nodes[0])[2]);
            g_share["deptname"][length] = getNodeText(GetChildNodes(nodes[0])[7]);
            g_share["name1"][length] = getNodeText(GetChildNodes(nodes[0])[5]);
            g_share["name2"][length] = getNodeText(GetChildNodes(nodes[0])[6]);
            g_share["deptname2"][length] = getNodeText(GetChildNodes(nodes[0])[8]);
            g_share["email"][length] = getNodeText(GetChildNodes(nodes[4])[0]);
            if (length == 0) {
                setNodeText(document.getElementById("receiverlist"), g_share["name"][length]);
            }
            else {
                setNodeText(document.getElementById("receiverlist"), getNodeText(document.getElementById("receiverlist")) + ", " + g_share["name"][length]);
            }
        }
        else {
            document.nameValue.addrBook.value = getXmlString(xmlDOM);
            document.nameValue.name.value = "";
            document.nameValue.id.value = "";
            document.nameValue.deptname.value = "";
            document.nameValue.name1.value = "";
            document.nameValue.name2.value = "";
            document.nameValue.deptname2.value = "";
            document.nameValue.email.value = "";

            var formaction = document.getElementById("nameValue");
            if (navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1) {
                var feature = GetOpenPosition(610, 300);
                retcheck = window.open("", "child", "width=610,height=300" + feature);
            }
            else {
                var feature = GetOpenPosition(610, 350);
                retcheck = window.open("", "child", "width=610,height=350" + feature);
            }

            formaction.target = "child";
            formaction.action = "/myoffice/ezTask/htm/checkName_Cross.aspx";
            formaction.submit();
        }
    }
    document.getElementById("shareInput").value = "";
}

function retevent() {
    if (document.nameValue.name.value != "") {
        if (g_share == null)
            g_share = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };

        if (document.nameValue.id.value != userid) {
            for (var j = 0; j < g_share["id"].length; j++)
                if (g_share["id"][j] == document.nameValue.id.value) {
                    alert("" + strLang18 + "");
                    return;
                }
        }
        else {
            retcheck.alert("" + strLang20 + "");
            retcheck.close();
            return;
        }
        var length = g_share["name"].length;
        g_share["name"][length] = document.nameValue.name.value;
        g_share["id"][length] = document.nameValue.id.value;
        g_share["deptname"][length] = document.nameValue.deptname.value;
        g_share["name1"][length] = document.nameValue.name1.value;
        g_share["name2"][length] = document.nameValue.name2.value;
        g_share["deptname2"][length] = document.nameValue.deptname2.value;
        g_share["email"][length] = document.nameValue.email.value;
        if (length == 0) {
                setNodeText(document.getElementById("receiverlist"), g_share["name"][length]);
        }
        else {
            setNodeText(document.getElementById("receiverlist"), getNodeText(document.getElementById("receiverlist")) + ", " + g_share["name"][length]);
        }
    }
}

var g_progresswin;
var g_fileList;
var g_fileNameList = new Array();
var g_fileInfoList = new Array();

function show_progress(fileinfo) {
    g_progresswin = window.showModelessDialog("/myoffice/ezTask/task_progress.aspx?fileinfo=" + escape(fileinfo), "", "dialogWidth=390; dialogHeight:170; center:yes; status:no; help:no; edge:sunken");
}

function status_change(fileinfo) {
    try {
        g_progresswin.document.Script.fileinfo_change(fileinfo);
    } catch (e) { }
}
function restore_deleted() {
    if (repetitiondel == "") {
        alert("" + strLang25 + "");
        return;
    }

    if (!confirm("" + strLang26 + ""))
        return;

    var xmlHTTP = createXMLHttpRequest();
    var xmlDom = createXmlDom();
    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "DATA", taskid);

    xmlHTTP.open("POST", "/myoffice/ezTask/remote/task_restore_delete.aspx", false);
    xmlHTTP.send(xmlDom);

    if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
        alert("" + strLang27 + "");
    else {
        alert("" + strLang28 + "");

        try { window.opener.document.Script.RefreshView() } catch (e) { }
        repetitiondel = "";
        show_repetition_info();
    }
}

var g_sdate = null;
var g_edate = null;
var task_repetition_cross_dialogArguments = new Array();

function config_repeat() {

    var prameter = new Array();
    if (g_sdate == null) {
        prameter["SDATE"] = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
        prameter["EDATE"] = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
    }
    else {
        prameter["SDATE"] = g_sdate;
        prameter["EDATE"] = g_edate;
    }

    prameter["REPETITION"] = repetition;

    task_repetition_cross_dialogArguments[0] = prameter;
    task_repetition_cross_dialogArguments[1] = config_repeat_Complete;

    DivPopUpShow(450, 460, "/myoffice/ezTask/htm/task_repetition_Cross.aspx");
}

function config_repeat_Complete(retVal) {

    if (retVal == "cancel" || typeof (retVal) == "undefined") {
    }
    else {
        if (retVal["REPETITION"] == "") {
            repetition = "";
            document.getElementById("periodblock").style.display = "";
            document.getElementById("repeatblock").style.display = "none";
            document.getElementById("repeatinfo").innerHTML = "&nbsp;";
        }
        else {
            g_sdate = retVal["SDATE"];
            g_edate = retVal["EDATE"];
            repetition = retVal["REPETITION"];
            show_repetition_info();
        }
    }
    DivPopUpHidden();

}


function show_repetition_info() {

    document.getElementById("periodblock").style.display = "none";
    document.getElementById("repeatblock").style.display = "";

    var info = repetition.split("|");
    var repeatinfo = "" + strLang29 + "";

    switch (info[2]) {
        case "0":
            repeatinfo += "" + strLang30 + "";
            break;
        case "1":
            repeatinfo += "" + strLang31 + "";
            break;
        case "2":
            repeatinfo += "" + strLang32 + "";
            break;
        case "3":
            repeatinfo += "" + strLang33 + "";
            break;
        default:
            break;
    }

    if (repetitiondel != "")
        repeatinfo += ", " + strLang34 + "" + repetitiondel + " " + strLang35 + "";

    document.getElementById("repeatinfo").innerHTML = repeatinfo;
}

function ReplaceText(orgStr, findStr, replaceStr) {
    var re = new RegExp(findStr, "gi");

    return (orgStr.replace(re, replaceStr));
}

function TrimText(orgStr) {
    var copyStr = "";
    var strIndex;
    for (strIndex = 0; strIndex < orgStr.length; strIndex++) {
        if (orgStr.charAt(strIndex) == ' ') continue;
        else {
            copyStr = orgStr.substr(strIndex);
            break;
        }
    }
    for (strIndex = copyStr.length - 1; strIndex >= 0; strIndex--) {
        if (copyStr.charAt(strIndex) == ' ') continue;
        else {
            copyStr = copyStr.substr(0, strIndex + 1);
            break;
        }
    }

    return copyStr;
}

function check_length(chkstr, maxlength, fieldname) {
    var length = 0;
    var i;

    length = chkstr.length;

    if (length > maxlength) {
        alert(fieldname + "" + strLang36 + "" + maxlength + "" + strLang37 + "");
        return false
    }

    return true;
}
function save_task() {
    if (document.getElementById("TextTitle").value == "") {
        alert("" + strLang9 + "");
        document.getElementById("TextTitle").focus();
        return;
    }

    var startdate = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
    var enddate = new Date($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());

    if (startdate > enddate) {
        alert(strLang_1);
        return;
    }

    if (document.getElementById("taskstatusSelect").value != 3 && document.getElementById("TextCompleteDate").value != "") {
        alert("" + strLang10 + "");
        document.getElementById("TextCompleteDate").focus();
        return;
    }

    if (!check_length(document.getElementById("TextTitle").value, 100, "" + strLang11 + "")) return;
    if (!check_length(document.getElementById("TextCompleteDate").value, 20, "" + strLang12 + "")) return;

    var xmlDom = createXmlDom();
    var xmlHTTP = createXMLHttpRequest();
    var objRoot, objNode, attachnode, shobjnode;
    objNode = createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "TASKID", taskid);
    createNodeAndInsertText(xmlDom, objNode, "OWNERID", userid);
    createNodeAndInsertText(xmlDom, objNode, "CREATORID", userid);
    createNodeAndInsertText(xmlDom, objNode, "CREATORNAME", username);
    createNodeAndInsertText(xmlDom, objNode, "CREATORNAME2", username2);
    createNodeAndInsertText(xmlDom, objNode, "HASSHARE", hasshare);
    createNodeAndInsertText(xmlDom, objNode, "TASKSTATUS", document.getElementById("taskstatusSelect").value);
    createNodeAndInsertText(xmlDom, objNode, "COMPLETERATE", document.getElementById("completerateSelect").value);
    createNodeAndInsertText(xmlDom, objNode, "COMPLETEDATE", document.getElementById("TextCompleteDate").value);
    createNodeAndInsertText(xmlDom, objNode, "IMPORTANCE", document.getElementById("importantSelect").value);

    if (repetition == "") {
    createNodeAndInsertText(xmlDom, objNode, "STARTDATE", $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00");
    createNodeAndInsertText(xmlDom, objNode, "ENDDATE", $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23:59");
    }
    else {
        var sdate, edate;

        if (g_sdate == null) {
            startdate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
            enddate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
            sdate = new Date(startdate.substring(0, 4), parseInt(startdate.substring(5, 7)) - 1, startdate.substring(8, 10));
            edate = new Date(enddate.substring(0, 4), parseInt(enddate.substring(5, 7)) - 1, enddate.substring(8, 10));
        }
        else {
            sdate = new Date(g_sdate.substring(0, 4), parseInt(g_sdate.substring(5, 7)) - 1, g_sdate.substring(8, 10));
            edate = new Date(g_edate.substring(0, 4), parseInt(g_edate.substring(5, 7)) - 1, g_edate.substring(8, 10));
        }

        createNodeAndInsertText(xmlDom, objNode, "STARTDATE", sdate.getFullYear() + "-" + (parseInt(sdate.getMonth()) + 1) + "-" + sdate.getDate() + " 00:00");
        createNodeAndInsertText(xmlDom, objNode, "ENDDATE", edate.getFullYear() + "-" + (parseInt(edate.getMonth()) + 1) + "-" + edate.getDate() + " 23:59");

    }

    createNodeAndInsertText(xmlDom, objNode, "REPETITION", repetition);
    createNodeAndInsertText(xmlDom, objNode, "TITLE", document.getElementById("TextTitle").value);

    var Doc_ContentHtml = document.createElement("DIV");
    var strBody = message.GetEditorContent();
    Doc_ContentHtml.innerHTML = strBody;

    strBody = ConvertHTMLtoMHT(EmbedContentIntoXML(strBody));
    createNodeAndInsertText(xmlDom, objNode, "CONTENT", strBody);

    if (taskid == "")
        createNodeAndInsertText(xmlDom, objNode, "CONTENTPATH", "");
    else
        createNodeAndInsertText(xmlDom, objNode, "CONTENTPATH", content);


    var list = createNodeAndAppandNode(xmlDom, objNode, list, "ATTACHLIST");
    if (pAttachListXml != "") {
        var nodes = SelectNodes(pAttachListXml, "LISTVIEWDATA/ROWS/ROW");
        for (var i = 0; i < nodes.length; i++) {
            createNodeAndAppandNodeText(xmlDom, list, attachnode, "ATTACH", unescape(SelectSingleNodeValue(GetChildNodes(nodes[i])[0], "DATA2")) + "/" + unescape(SelectSingleNodeValue(GetChildNodes(nodes[i])[0], "VALUE")) + "/" + unescape(SelectSingleNodeValue(GetChildNodes(nodes[i])[0], "DATA6")));
        }
    }


    var sharelist = createNodeAndAppandNode(xmlDom, objNode, sharelist, "SHARELIST");
    if (g_share != null) {
        for (var i = 0; i < g_share["id"].length; i++) {
            createNodeAndAppandNodeText(xmlDom, sharelist, shobjnode, "SHARERID", g_share["id"][i]);
            createNodeAndAppandNodeText(xmlDom, sharelist, shobjnode, "SHARERNAME1", g_share["name1"][i]);
            createNodeAndAppandNodeText(xmlDom, sharelist, shobjnode, "SHARERNAME2", g_share["name2"][i]);
            createNodeAndAppandNodeText(xmlDom, sharelist, shobjnode, "SHARERDEPTNAME", g_share["deptname"][i]);
            createNodeAndAppandNodeText(xmlDom, sharelist, shobjnode, "SHARERDEPTNAME2", g_share["deptname2"][i]);
        }
    }

    var personlist = createNodeAndAppandNode(xmlDom, objNode, personlist, "PERSONLIST");

    if (taskType == 1) {
        createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONID", userid);
        createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONNAME1", username);
        createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONNAME2", username2);
        createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONDEPTNAME", deptname);
        createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONDEPTNAME2", deptname2);
    }
    else {
        var person = "";

        if (g_person != null) {
            if (g_person["id"].length > 1) { alert("" + strLang41 + ""); return; }
            for (var i = 0; i < g_person["id"].length; i++) {

                createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONID", g_person["id"][i]);
                createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONNAME1", g_person["name1"][i]);
                createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONNAME2", g_person["name2"][i]);
                createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONDEPTNAME", g_person["deptname"][i]);
                createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONDEPTNAME2", g_person["deptname2"][i]);

                if (person != "")
                    person += ", ";
                person += g_person["name"][i] == "" ? g_person["deptname"][i] : g_person["name"][i];
            }
        }
        if (person == "" || person == null) {
            alert("" + strLang57 + "");
            return;
        }
    }

    createNodeAndInsertText(xmlDom, objNode, "TASKTYPE", taskType);
    
    xmlHTTP.open("POST", "/ezTask/taskSave.do", false);
    xmlHTTP.send(xmlDom);

    if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
        alert("" + strLang13 + "");
    else {
        alert("" + strLang14 + "");

        try { window.opener.RefreshView(); } catch (e) { }
        window.close();
    }
}

function EmbedContentIntoXML(bodyhtml) {
    var tempDiv = document.createElement("DIV");
    tempDiv.innerHTML = bodyhtml;

    var imgColl = tempDiv.getElementsByTagName("IMG");
    for (var i = 0; i < imgColl.length; i++) {
        if (imgColl.item(i).src.toLowerCase().indexOf("upload_common") > 0) {
            var OrgSrc = imgColl.item(i).src;
            var ImgHeight = "0";
            var ImgWidth = "0";
            if (imgColl.item(i).outerHTML.toLowerCase().match(/width="?([^>'"]+)['"]/) == null) {
                if (imgColl.item(i).style.width != "")
                    ImgWidth = imgColl.item(i).style.width.replace("px", "");
                if (imgColl.item(i).style.height != "")
                    ImgHeight = imgColl.item(i).style.height.replace("px", "");
            }
            else {
                var result = imgColl.item(i).outerHTML.toLowerCase().match(/width="?([^>'"]+)['"]/);
                if (result.length == 2)
                    ImgWidth = result[1];
                var result = imgColl.item(i).outerHTML.toLowerCase().match(/height="?([^>'"]+)['"]/);
                if (result.length == 2)
                    ImgHeight = result[1];
            }
            ConvertSaveImageFile(OrgSrc, ImgWidth, ImgHeight);
        }
    }
    var BodyHTMLContent = HTMLtoMHT_MakeTag(tempDiv);
    return BodyHTMLContent;
}

function ConvertSaveImageFile(pUrl, pImgWidth, pImgHeight) {
    var XmlHttp = createXMLHttpRequest();
    var xmlDom = createXmlDom();
    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "URL", encodeURIComponent(pUrl));
    createNodeAndInsertText(xmlDom, objNode, "HEIGHT", pImgHeight);
    createNodeAndInsertText(xmlDom, objNode, "WIDTH", pImgWidth);
    createNodeAndInsertText(xmlDom, objNode, "TYPE", "2");
    try {
        XmlHttp.open("POST", "/myoffice/Common/ConvertSaveImage.aspx", false);
        XmlHttp.send(xmlDom);
    }
    catch (e) { }
}