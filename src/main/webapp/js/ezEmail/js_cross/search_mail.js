var g_searchHttp = null;
var g_progresswin = null;
function showProgress() {
    document.getElementById("progressviewerRayer").style.top = "200px";
    document.getElementById("progressviewerRayer").style.left = (document.documentElement.clientWidth / 2) - 240 + "px";
    document.getElementById("progressviewerRayer").style.display = "";
    document.getElementById("progressviewer").src = "/myoffice/common/show_progress.aspx?fileinfo=" + encodeURIComponent(strLang147);
}
function hideProgress() {
    try {
        document.getElementById("progressviewerRayer").style.display = "none";
    }
    catch (e) { }
}
function ShowMailProgress() {
    document.getElementById("mailPanel").style.display = "";
    document.getElementById("MailProgress").style.top = "300px";
    document.getElementById("MailProgress").style.left = (document.documentElement.clientWidth / 2) - 100 + "px";
    document.getElementById("MailProgress").style.display = "";
}
function HiddenMailProgress() {
    document.getElementById("mailPanel").style.display = "none";
    document.getElementById("MailProgress").style.display = "none";
}
function MailListRefresh() {
	start_search();
}
function start_search() {
    listContentArry = new Array();
    listEventCheckbox = false;
    PressShiftKey = false;
    PressCtrlKey = false;
    if (TrimText(keyword.value) == null || TrimText(keyword.value) == "") {
        alert(strLang254);
        return;
    }

    if (g_searchHttp != null)
        return;

    resultCount.innerHTML = "";
    recordCount = 0;

    var sYear, sMonth, sDay, eYear, eMonth, eDay, sTime, eTime;
    var sCategory;
    var sKeyword;
    var i;
    var bError = false;
    var startDate = "", endDate = "";

    if (usepostDate) {
        startDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";
        endDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";

        var sDate = new Date(startDate.split(' ')[0].split('-')[0], startDate.split(' ')[0].split('-')[1], startDate.split(' ')[0].split('-')[2]);
        var eDate = new Date(endDate.split(' ')[0].split('-')[0], endDate.split(' ')[0].split('-')[1], endDate.split(' ')[0].split('-')[2]);

        if (sDate > eDate) {
            alert(strLang312);
            return;
        }
    }

    if (keyword.value.indexOf("%") != -1) {
        alert("'%'" + strLang148);
        return;
    }

    sKeyword = TrimText(keyword.value);
    sCategory = TrimText(select.value);

    var baseURL = document.location.protocol + "//" + g_servername + "/" + g_expath + "/" + g_userID + "/";


    var sMailFolder = TrimText(select2.value);
    ShowMailProgress();
    searchRecurMail(sKeyword, sCategory, sMailFolder, startDate, endDate);
}
function GetBoxPath(Url, boxinfo, sKeyword, sCategory, startDate, endDate) {
    var strXml = "<?xml version='1.0' encoding='utf-8'?>" +
		"<a:propfind xmlns:a='DAV:' xmlns:b='urn:schemas:httpmail:'>" +
		"<a:prop>" +
		"<b:" + boxinfo + "/>" +
		"</></>";

    g_searchHttp = new ActiveXObject("Microsoft.XMLHttp");
    g_searchHttp.open("PROPFIND", Url, true);
    g_searchHttp.setRequestHeader("Content-Type", "text/xml;charset=utf-8");
    g_searchHttp.setRequestHeader("Depth", "0");
    event_GetBoxPath.boxinfo = boxinfo;
    event_GetBoxPath.sKeyword = sKeyword;
    event_GetBoxPath.sCategory = sCategory;
    event_GetBoxPath.startDate = startDate;
    event_GetBoxPath.endDate = endDate;
    g_searchHttp.onreadystatechange = event_GetBoxPath;
    g_searchHttp.send(strXml);
}

function event_GetBoxPath() {
    if (g_searchHttp != null && g_searchHttp.readyState == 4) {
        if (g_searchHttp.status > 199 && g_searchHttp.status < 300) {
            var path = g_searchHttp.responseXML.getElementsByTagName("d:" + event_GetBoxPath.boxinfo).item(0).text
            g_searchHttp = null;
            searchRecurMail(path, event_GetBoxPath.sKeyword, event_GetBoxPath.sCategory, event_GetBoxPath.startDate,
					event_GetBoxPath.endDate, true);
        }
        else {
            HiddenMailProgress();

            alert(strLang150)
            g_searchHttp = null;
        }
    }
}

function searchRecurMail(sKeyword, sCategory, sMailFolder, startDate, endDate) {
    if (sKeyword.length && sCategory.length) {
        sKeyword = ReplaceText(sKeyword, "&", "&amp;");
        sKeyword = ReplaceText(sKeyword, "<", "&lt;");
        sKeyword = ReplaceText(sKeyword, ">", "&gt;");
        sKeyword = ReplaceText(sKeyword, "'", "''");
        switch (String(sCategory)) {
            case strLang151:
                sCategory = "SUBJECT";
                break;

            case strLang152:
                sCategory = "CONTENT";
                break;

            case strLang153:
                sCategory = "FROM";
                break;

            case strLang154:
                sCategory = "RECEIVE";
                break;
        }
    }

    g_searchHttp = createXMLHttpRequest();
    var xmlDOM = createXmlDom();


    var objNode;
    createNodeInsert(xmlDOM, objNode, "DATA");
    createNodeAndInsertText(xmlDOM, objNode, "MAILFOLDER", sMailFolder);
    createNodeAndInsertText(xmlDOM, objNode, "KEYWORD", sKeyword);
    createNodeAndInsertText(xmlDOM, objNode, "CATEGORY", sCategory);
    createNodeAndInsertText(xmlDOM, objNode, "STARTDATE", startDate);
    createNodeAndInsertText(xmlDOM, objNode, "ENDDATE", endDate);

    if (p_ListOrderObject == null) {
        event_HeaderClick(document.getElementById("tofromdate"));
    }

    createNodeAndInsertText(xmlDOM, objNode, "PORP", p_ListOrderObject.getAttribute("porp"));
    createNodeAndInsertText(xmlDOM, objNode, "ORDERBY", p_ListOrderObject.getAttribute("orderoption"));

    g_searchHttp.open("POST", "/ezEmail/mailSearch.do", true);
    g_searchHttp.onreadystatechange = event_searchRecurMail;
    g_searchHttp.send(xmlDOM);
}

var resultTable = null;
var recordCount = 0;


function event_searchRecurMail() {
    if (g_searchHttp != null && g_searchHttp.readyState == 4) {
        if (g_searchHttp.status > 199 && g_searchHttp.status < 300) {
            if (document.getElementById("Checkbox1").checked)
                document.getElementById("Checkbox1").checked = false;

            var passXml = createXmlDom();
            passXml = loadXMLString(g_searchHttp.responseText);

            resultView(passXml);
            g_searchHttp = null;

            HiddenMailProgress();

            if (resultTable.rows.length == 0) {
                tr = resultTable.insertRow();
                tr.height = 20;
                td = tr.insertCell();
                td.innerHTML = strLang155;
            }
            else
                resultCount.innerHTML = " : " + strLang156 + "<b>" + recordCount + "</b> " + strLang157;
        }
        else {
            HiddenMailProgress();

            alert(strLang158 + g_searchHttp.status)
            g_searchHttp = null;
        }
    }
}


function resultView(xmlDoc) {
    var i, k;
    var tr, td;
    var tempText;
    var webserver;

    var fromemail, datereceived, parentname, subject, importance, fromname, hasattachment, read, href, displayto, ItemClass, Size, Flag;

    var ChildCnt = 0;
    if (!CrossYN())
        ChildCnt = 1;
    if (select2.value == strLang64) {
        if (GetChildNodes(tofromname).length > ChildCnt) {
            var temphtml = GetChildNodes(tofromname)[ChildCnt].outerHTML;
            tofromname.innerText = strLang11;
            tofromname.innerHTML += temphtml;
        }
        else
            tofromname.innerText = strLang11;

        if (GetChildNodes(tofromdate).length > ChildCnt) {
            temphtml = GetChildNodes(tofromdate)[ChildCnt].outerHTML;
            tofromdate.innerText = strLang159;
            tofromdate.innerHTML += temphtml;
        }
        else
            tofromdate.innerText = strLang159;
    }
    else {
        if (GetChildNodes(tofromname).length > ChildCnt) {
            var temphtml = GetChildNodes(tofromname)[ChildCnt].outerHTML;
            tofromname.innerText = strLang160;
            tofromname.innerHTML += temphtml;
        }
        else
            tofromname.innerText = strLang160;

        if (GetChildNodes(tofromdate).length > ChildCnt) {
            temphtml = GetChildNodes(tofromdate)[ChildCnt].outerHTML;
            tofromdate.innerText = strLang9;
            tofromdate.innerHTML += temphtml;
        }
        else
            tofromdate.innerText = strLang9;
    }

    if (resultTable != null) {
        resultTable = null;
    }

    resultTable = document.createElement("TABLE");
    resultTable.style.tableLayout = "fixed";
    resultTable.id = "maillist";
    resultTable.className = "mainlist";
    resultTable.style.width = "100%";

    resultTD.innerHTML = "";
    resultTD.appendChild(resultTable);

    var fromNode, dateNode, parentNode, subjectNode, impNode, nameNode, attachNode, readNode, idNode, toNode, ItemClassNode;
    var XmlRows = SelectNodes(xmlDoc, "DATA/ROWS/ROW")
    var loopCount = XmlRows.length;
    recordCount += loopCount;
    for (i = 0; i < loopCount; i++) {
        fromemail = SelectSingleNodeValue(XmlRows[i], "FROMEMAIL");
        datereceived = SelectSingleNodeValue(XmlRows[i], "DATERECEIVED");
        parentname = SelectSingleNodeValue(XmlRows[i], "PARENTNAME");
        subject = SelectSingleNodeValue(XmlRows[i], "SUBJECT");
        importance = SelectSingleNodeValue(XmlRows[i], "IMPORTANCE");
        fromname = SelectSingleNodeValue(XmlRows[i], "FROMNAME");
        hasattachment = SelectSingleNodeValue(XmlRows[i], "HASATTACHMENT");
        read = SelectSingleNodeValue(XmlRows[i], "READ");
        id = SelectSingleNodeValue(XmlRows[i], "ITEMID");
        displayto = SelectSingleNodeValue(XmlRows[i], "DISPLAYTO");
        ItemClass = SelectSingleNodeValue(XmlRows[i], "CONTENTCLASS");
        Size = SelectSingleNodeValue(XmlRows[i], "SIZE");
        Flag = SelectSingleNodeValue(XmlRows[i], "FLAG");
        parentname = ReplaceText(parentname, "/PERSONAL", "/" + strLang67);
        parentname = ReplaceText(parentname, "/초안", "/" + strLang65);
        tr = resultTable.insertRow();
        tr.parentname = parentname;
        tr.style.cursor = "pointer";
        tr.id = id;
        tr.setAttribute("contentclass", ItemClass);
        tr.setAttribute("itemID", id);
        tr.setAttribute("targetURL", id);
        tr.onmouseover = function () { event_listMover(this); };
        tr.onmouseout = function () { event_listMout(this); };
        tr.onclick = function () { event_listclick(this); };
        tr.ondblclick = view_click;
        tr.valign = "center";

        var tempText = "<input type='checkbox' id = 'checklol" + i + "' name='checklol' onclick='event_listCheckboxclick(this)'>";
        preparedTD(tr, "26px", "center", "middle", tempText, "", "", true);

        tempText = "";
        if (importance == 2)
            tempText = "<img src='/images/ImgIcon/icon-highimportance.gif' border=0>";
        else if (importance == 0)
            tempText = "<img src='/images/ImgIcon/icon-lowimportance.gif' border=0>";

        preparedTD(tr, "26px", "center", "middle", tempText, "", "", true);

        if (read == "1")
            tempText = "<img src='/images/ImgIcon/icon-msg-read.gif' border=0>";
        else
            tempText = "<img src='/images/ImgIcon/icon-msg-unread.gif' border=0>";

        preparedTD(tr, "26px", "center", "middle", tempText, "", "", true);


        tempText = "";
        if (Flag == "0")
            tempText = "<img src='/images/ImgIcon/view-flag.gif' border=0>";
        else
            tempText = "<img src='/images/ImgIcon/icon-flag.gif' border=0>";

        preparedTD(tr, "26px", "center", "middle", tempText, "", "", true);


        tempText = "";
        if (hasattachment == "1")
            tempText = "<img src='/images/newAttach.gif' border=0>";

        preparedTD(tr, "26px", "center", "middle", tempText, "", "", true);

        if (tofromname.innerText == strLang160) {
            preparedTD(tr, "100px", "left", "middle", fromname, fromname, 1, false);
            tr.recvFrom = fromname;
        }
        else {
            preparedTD(tr, "100px", "left", "middle", displayto, displayto, 1, false);
            tr.recvFrom = displayto;
        }

        preparedTD(tr, "100%", "left", "middle", subject, subject, 1, false);

        if (TrimText(datereceived) != "null")
            datereceived = GetLocalTime(g_timezone, datereceived);

        datereceived = datereceived.replace("T", " ")
        preparedTD(tr, "200px", "left", "middle", datereceived, "", "", false);


        var foldername = parentname;

        if (g_userLang != "1") {
            foldername = ReplaceText(foldername, strLang63, strLang161);
            foldername = ReplaceText(foldername, strLang64, strLang162);
            foldername = ReplaceText(foldername, strLang65, strLang163);
            foldername = ReplaceText(foldername, strLang66, strLang164);
            foldername = ReplaceText(foldername, strLang67, strLang71);
        }

        preparedTD(tr, "120px", "left", "middle", foldername, foldername, 1, false);

        preparedTD(tr, "50px", "left", "middle", FormatSize(Size), "", "", false);

        if (importance == 2) {
            for (var n = 0; n < tr.childNodes.length; n++) {
                tr.childNodes.item(n).style.color = importanceColor;
            }
        }
    }
}

function FormatSize(p_Prop8) {
    var iSize = parseInt(p_Prop8);
    if (iSize < 1000) {
        p_Prop8 = iSize + " B";
    }
    else {
        iSize = Math.round(iSize / 1024);

        if (iSize > 1000) {
            iSize = Math.round(iSize / 1024);
            iSize = String(iSize);
            p_Prop8 = iSize + " MB";
        }
        else
            p_Prop8 = iSize + " KB";
    }
    return p_Prop8;

}

var _RowObject = null;
function event_listMover(obj) {
    if (!obj.childNodes.item(0).childNodes.item(0).checked) {
        for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
            obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorOver;
        }
    }
}
function event_listMout(obj) {
    if (!obj.childNodes.item(0).childNodes.item(0).checked) {
        for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
            obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
        }
    }
}

var listContentArry = new Array();
var listSubContentArry = new Array();
var listEventCheckbox = false;
var listSubEventCheckbox = false;
var PressShiftKey = false;
var PressCtrlKey = false;
function event_listclick(obj) {
    if (!listEventCheckbox) {
        if (document.getElementById("Checkbox1").checked) {
            var TemplistArray = new Array();
            if (obj.childNodes.item(0).childNodes.item(0).checked) {
                for (var i = 0; i < listContentArry.length; i++) {
                    if (obj.getAttribute("id") == listContentArry[i]) {
                        obj.childNodes.item(0).childNodes.item(0).checked = false;
                        for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
                            obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
                        }
                    }
                    else {
                        TemplistArray[TemplistArray.length] = listContentArry[i];
                    }
                }
                listContentArry = TemplistArray;
            }
            else {
                obj.childNodes.item(0).childNodes.item(0).checked = true;
                for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
                    obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
                }
                listContentArry[listContentArry.length] = obj.getAttribute("id");
            }
        }
        else {
            if (!PressShiftKey && !PressCtrlKey && listContentArry.length > 0) {
                for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
                    _RowObject = document.getElementById(listContentArry[Cnt]);
                    for (var RowCnt = 0; RowCnt < _RowObject.childNodes.length; RowCnt++) {
                        _RowObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
                    }
                    _RowObject.childNodes.item(0).childNodes.item(0).checked = false;
                }
                listContentArry = new Array();
            }
            if (PressShiftKey) {
                for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
                    _RowObject = document.getElementById(listContentArry[Cnt]);
                    for (var RowCnt = 0; RowCnt < _RowObject.childNodes.length; RowCnt++) {
                        _RowObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
                    }
                    _RowObject.childNodes.item(0).childNodes.item(0).checked = false;
                }
                listContentArry = new Array();
                var PrelistContent = _RowObject.getAttribute("id");
                _RowObject = obj;

                var CurlistContent = obj.getAttribute("id");
                var PrePoint = parseInt(PrelistContent.replace("Maillist_", ""));
                var CurPoint = parseInt(CurlistContent.replace("Maillist_", ""));
                if (PrePoint < CurPoint) {

                    for (var Cnt = PrePoint; Cnt <= CurPoint; Cnt++) {
                        _RowObject = document.getElementById("Maillist_" + Cnt);
                        for (var RowCnt = 0; RowCnt < _RowObject.childNodes.length; RowCnt++) {
                            _RowObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
                        }
                        _RowObject.childNodes.item(0).childNodes.item(0).checked = true;
                        listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
                    }

                }
                else if (PrePoint > CurPoint) {
                    for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
                        _RowObject = document.getElementById("Maillist_" + Cnt);
                        for (var RowCnt = 0; RowCnt < _RowObject.childNodes.length; RowCnt++) {
                            _RowObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
                        }
                        _RowObject.childNodes.item(0).childNodes.item(0).checked = true;
                        listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
                    }
                }
                else
                    return;
            }
            else {
                _RowObject = obj;
                if (_RowObject.childNodes.item(0).childNodes.item(0).checked) {
                    for (var RowCnt = 0; RowCnt < _RowObject.childNodes.length; RowCnt++) {
                        _RowObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
                    }
                    _RowObject.childNodes.item(0).childNodes.item(0).checked = false;
                    listContentArry = ArrayDelete(listContentArry, _RowObject.id);
                }
                else {
                    for (var RowCnt = 0; RowCnt < _RowObject.childNodes.length; RowCnt++) {
                        _RowObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
                    }
                    _RowObject.childNodes.item(0).childNodes.item(0).checked = true;
                    listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
                }
            }
        }
    }
    else
        listEventCheckbox = false;
}
function event_listCheckboxclick(obj) {
    if (obj.checked) {
        for (var RowCnt = 0; RowCnt < obj.parentElement.parentElement.childNodes.length; RowCnt++) {
            obj.parentElement.parentElement.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
        }
        listContentArry[listContentArry.length] = obj.parentElement.parentElement.getAttribute("itemid");
    }
    else {
        var TemplistArray = new Array();
        for (var i = 0; i < listContentArry.length; i++) {
            if (obj.parentElement.parentElement.getAttribute("itemid") == listContentArry[i]) {
                for (var RowCnt = 0; RowCnt < obj.parentElement.parentElement.childNodes.length; RowCnt++) {
                    obj.parentElement.parentElement.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
                }
            }
            else {
                TemplistArray[TemplistArray.length] = listContentArry[i];
            }
        }
        listContentArry = TemplistArray;
    }
    listEventCheckbox = true;
}
function ArrayDelete(TargetArray, DeleteNodeStr) {
    var TempArray = new Array();
    for (var i = 0; i < TargetArray.length; i++) {
        if (TargetArray[i] != DeleteNodeStr)
            TempArray[TempArray.length] = TargetArray[i];
    }
    TargetArray = TempArray;
    return TargetArray;
}

function preparedTD(TR, width, align, valign, innerHTML, title, textmode, nopadding) {

    if (navigator.userAgent.indexOf('Firefox') != -1) {
        var td = TR.insertCell(TR.childNodes.length);
    }
    else if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1) {
        var td = TR.insertCell(TR.childNodes.length);
    }
    else {
        var td = TR.insertCell();
    }

    if (width != "")
        td.style.width = width;

    td.style.overflow = "hidden";
    td.style.textOverflow = "ellipsis";
    td.style.whiteSpace = "nowrap";
    td.align = align;
    td.noWrap = true;




    if (nopadding)
        td.style.padding = "0px";

    if (typeof (title) != "undefined")
        td.title = title;

    if (textmode == "1") {
        if(CrossYN())
            td.textContent = innerHTML;
        else
            td.innerText = innerHTML;
    }
    else
        td.innerHTML = innerHTML;
}

function callback() {
    start_search();
}

function view_click() {
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var conWidth = pwidth * 0.8;
    if (conWidth > 890)
        conWidth = 890;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - 890) / 2;
    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
    if (this.parentname == ("/" + strLang65)) {
    	window.open("/ezEmail/mailWrite.do?URL=" + encodeURIComponent(this.getAttribute("targeturl")) + "&cmd=EDIT", "", feature);
    }
    else {
    	window.open("/ezEmail/mailRead.do?URL=" + encodeURIComponent(this.getAttribute("targeturl")) + "&SEARCHPAGE=1&CONTENTCLASS=" + this.getAttribute("contentclass"), "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
    }
}


function onmouseOver() {
    this.style.color = "blue";
    this.style.backgroundColor = "#F5F0D7";
}

function onmouseOut() {
    this.style.color = "";
    this.style.backgroundColor = "#FFFFFF";
}

