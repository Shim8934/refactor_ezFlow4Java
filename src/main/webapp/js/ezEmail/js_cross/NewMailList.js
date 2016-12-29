
var XmlHeader;
var XmlHeader_SUB;
var BlockSize = 10;
var p_ListOrderObject = null;
var p_SubListOrderObject = null;
var _RowObject = null;
var _SubRowObject = null;
var _SublistDBClickEvent = false;
var GetList_HTTP;
var GetList_HTTP_SUB;
var GetListInfo_HeaderObject;
var GetListInfo_ContentObject;
var m_strColorSelect = "#DBE1E7";
var m_strColorOver = "#f4f5f5";
var m_strColorDefault = "#ffffff";
var GroupplusImg ="/images/ImgIcon/groupplus.gif";
var GroupminImg ="/images/ImgIcon/groupmin.gif";
var GroupSenderImg ="/images/ImgIcon/groupsender.gif";
var GroupSubjectImg ="/images/ImgIcon/groupsubject.gif";
var GroupColor = "#666666";

function HeaderIni(HeaderObject) {
    MakeHeaderHTML(HeaderObject);
}
function HeaderIni_SUB(HeaderObject) {
    MakeHeaderHTML_SUB(HeaderObject);
}
function MakeHeaderHTML(HeaderObject) {
    var Rvalue = "";
    try {
        HeaderObject.innerHTML = "";
        var XmlHttp = createXMLHttpRequest();
        XmlHttp.open("GET", p_HeaderViewXML, false);
        XmlHttp.send();
        XmlHeader = XmlHttp.responseXML;
        XmlRows = SelectNodes(XmlHeader, "view/column");
        var _HeaderTR = document.createElement("TR");
        var _HeaderTH = document.createElement("TH");
        _HeaderTH.style.width = "22px";
        if (p_ListorderValue != "SENT" && p_ListorderValue != "SUBJECT") {
            var _HeaderCheckBox = document.createElement("INPUT");
            _HeaderCheckBox.type = "checkbox";
            _HeaderCheckBox.style.margin = "0px";
            _HeaderCheckBox.style.padding = "0px";
            _HeaderCheckBox.style.width = "13px";
            _HeaderCheckBox.style.height = "13px";
            _HeaderCheckBox.setAttribute("id", "HeaderAllCheckBox");
            if (p_ListorderValue == "GROUPSUBLIST") { _HeaderCheckBox.onclick = function () { event_SubHeaderCheckBoxClick(this); }; }
            else { _HeaderCheckBox.onclick = function () { event_HeaderCheckBoxClick(this); }; }
            _HeaderTH.appendChild(_HeaderCheckBox);
        }
        _HeaderTR.appendChild(_HeaderTH);
        for (var Cnt = 0; Cnt < XmlRows.length; Cnt++) {
            var _HeaderRow = document.createElement("TH");
            if (p_ListorderValue != "SENT" && p_ListorderValue != "SUBJECT") {
                if (p_ListorderValue == "GROUPSUBLIST") {
                    _HeaderRow.onclick = function () { event_SubHeaderClick(this); };
                }
                else {
                    _HeaderRow.onclick = function () { event_HeaderClick(this); };
                }
            }
            _HeaderRow.style.width = SelectSingleNodeValue(XmlRows[Cnt], "width")
            _HeaderRow.style.textAlign = SelectSingleNodeValue(XmlRows[Cnt], "align");
            _HeaderRow.style.cursor = "pointer";
            _HeaderRow.setAttribute("prop", SelectSingleNodeValue(XmlRows[Cnt], "prop"));

            var HeaderType = SelectSingleNodeValue(XmlRows[Cnt], "heading");
            if (HeaderType == "IMG")
                _HeaderRow.innerHTML = "<IMG style=\"cursor:pointer\" src=\"" + SelectSingleNodeValue(XmlRows[Cnt], "imgpath") + "\"/>";
            else
                _HeaderRow.innerHTML = SelectSingleNodeValue(XmlRows[Cnt], "heading");

            var _HeaderSpanimg = null;
            if (SelectSingleNodeValue(XmlRows[Cnt], "prop") == p_ListOrderby) {
                _HeaderRow.setAttribute("orderoption", p_ListOrderOption);
                var _HeaderSpanimg = document.createElement("IMG");
                if (p_ListOrderOption == "DESC")
                    _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortdown.gif");
                else
                    _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortup.gif");

                _HeaderSpanimg.setAttribute("align", "absmiddle");
                if (p_ListorderValue == "GROUPSUBLIST") {
                    p_SubListOrderObject = _HeaderRow;
                }
                else {
                    p_ListOrderObject = _HeaderRow;
                }
            }
            else
                _HeaderRow.setAttribute("orderoption", "");
            if (_HeaderSpanimg != null)
                _HeaderRow.appendChild(_HeaderSpanimg);

            _HeaderTR.appendChild(_HeaderRow);
        }
        HeaderObject.appendChild(_HeaderTR);
    }
    catch (e) {
        alert(e.description);
    }
}
function MakeHeaderHTML_SUB(HeaderObject) {
    var Rvalue = "";
    try {
        HeaderObject.innerHTML = "";
        var XmlHttp = createXMLHttpRequest();
        XmlHttp.open("GET", p_HeaderViewXML, false);
        XmlHttp.send();
        XmlHeader_SUB = XmlHttp.responseXML;
        XmlRows = SelectNodes(XmlHeader_SUB, "view/column");
        var _HeaderTR = document.createElement("TR");
        var _HeaderTH = document.createElement("TH");
        _HeaderTH.style.width = "22px";
        var _HeaderCheckBox = document.createElement("INPUT");
        _HeaderCheckBox.type = "checkbox";
        _HeaderCheckBox.style.margin = "0px";
        _HeaderCheckBox.style.padding = "0px";
        _HeaderCheckBox.style.width = "13px";
        _HeaderCheckBox.style.height = "13px";
        _HeaderCheckBox.setAttribute("id", "HeaderAllCheckBox");
        if (p_ListorderValue == "GROUPSUBLIST") { _HeaderCheckBox.onclick = function () { event_SubHeaderCheckBoxClick(this); }; }
        else { _HeaderCheckBox.onclick = function () { event_HeaderCheckBoxClick(this); }; }
        _HeaderTH.appendChild(_HeaderCheckBox);
        _HeaderTR.appendChild(_HeaderTH);
        for (var Cnt = 0; Cnt < XmlRows.length; Cnt++) {
            var _HeaderRow = document.createElement("TH");
            _HeaderRow.onclick = function () { event_SubHeaderClick(this); };
            _HeaderRow.style.width = SelectSingleNodeValue(XmlRows[Cnt], "width")
            _HeaderRow.style.textAlign = SelectSingleNodeValue(XmlRows[Cnt], "align");
            _HeaderRow.style.cursor = "pointer";
            _HeaderRow.setAttribute("prop", SelectSingleNodeValue(XmlRows[Cnt], "prop"));

            var HeaderType = SelectSingleNodeValue(XmlRows[Cnt], "heading");
            if (HeaderType == "IMG")
                _HeaderRow.innerHTML = "<IMG style=\"cursor:pointer\" src=\"" + SelectSingleNodeValue(XmlRows[Cnt], "imgpath") + "\"/>";
            else
                _HeaderRow.innerHTML = SelectSingleNodeValue(XmlRows[Cnt], "heading");

            var _HeaderSpanimg = null;
            if (SelectSingleNodeValue(XmlRows[Cnt], "prop") == p_ListOrderby) {
                _HeaderRow.setAttribute("orderoption", p_ListOrderOption);
                var _HeaderSpanimg = document.createElement("IMG");
                if (p_ListOrderOption == "DESC")
                    _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortdown.gif");
                else
                    _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortup.gif");

                _HeaderSpanimg.setAttribute("align", "absmiddle");
                p_SubListOrderObject = _HeaderRow;
            }
            else
                _HeaderRow.setAttribute("orderoption", "");
            if (_HeaderSpanimg != null)
                _HeaderRow.appendChild(_HeaderSpanimg);

            _HeaderTR.appendChild(_HeaderRow);
        }
        HeaderObject.appendChild(_HeaderTR);
    }
    catch (e) {
        alert(e.description);
    }
}

function drag(ev) {
    var szItemID = "";

    for (var i = 0; i < listContentArry.length; i++) {
        szItemID += GetAttribute(document.getElementById(listContentArry[i]), "_href") + ",";
    }

    if (szItemID != "") {
        ev.dataTransfer.setData("text", szItemID);
    }
    else {
        if (typeof (ev.target) == "undefined") {
            ev.dataTransfer.setData("text", GetAttribute(ev.srcElement, "_href") + ",");
        }
        else {
            ev.dataTransfer.setData("text", GetAttribute(ev.target, "_href") + ",");
        }
    }
}

function MakeListInfoHTML(ConentObject) {
    if (p_ListorderValue == "" || p_ListorderValue == "RECEIV" || p_ListorderValue == "UNREAD" || p_ListorderValue == "GROUPSUBLIST") {
    	try {
            var XmlList = GetList_HTTP.responseXML;
            
            if (XmlList == null) {
                return;
            }
            
            var XmlRows = SelectNodes(XmlList, "maillist/response");
            var p_TotalCnt = getNodeText(SelectNodes(XmlList, "maillist/CONTENTRANGE")[0]);            
            var szRangeHeader = getNodeText(SelectNodes(XmlList, "maillist/CONTENTRANGE")[0]);
            GetListInfo_ContentObject.innerHTML = "";
            if (p_ListorderValue != "GROUPSUBLIST") {
                document.getElementById("contentlist").scrollTop = "0";
            }
            for (var Cnt = 0; Cnt < XmlRows.length; Cnt++) {
                var p_Href = SelectSingleNodeValue(XmlRows[Cnt], "href");
                var p_Importance = SelectSingleNodeValue(XmlRows[Cnt], "importance");
                var p_Flag = SelectSingleNodeValue(XmlRows[Cnt], "flag");
                var p_Attach = SelectSingleNodeValue(XmlRows[Cnt], "attach");
                var p_Sender = SelectSingleNodeValue(XmlRows[Cnt], "sender");
                var p_Subject = SelectSingleNodeValue(XmlRows[Cnt], "subject");
                var p_ReceiveDT = SelectSingleNodeValue(XmlRows[Cnt], "receivedt");
                var p_Size = SelectSingleNodeValue(XmlRows[Cnt], "size");
                var p_Read = SelectSingleNodeValue(XmlRows[Cnt], "read");
                var p_ContentClass = SelectSingleNodeValue(XmlRows[Cnt], "contentclass");
                var p_IsDraft = SelectSingleNodeValue(XmlRows[Cnt], "isdraft");
                var _TR = document.createElement("TR");
                _TR.setAttribute("id", "Maillist_" + Cnt);
                _TR.style.cursor = "pointer";
                _TR.style.fontWeight = p_Read == "0" ? "bold" : "";
                _TR.style.color = p_Importance == "2" ? "red" : "";
                _TR.style.cursor = "pointer";
                _TR.setAttribute("_href", p_Href);
                _TR.setAttribute("_subject", p_Subject);
                _TR.setAttribute("read", p_Read);
                _TR.setAttribute("_contentclass", p_ContentClass);
                _TR.setAttribute("_isdraft", p_IsDraft);
                _TR.setAttribute("draggable", true);
                _TR.ondragstart = function () { drag(event) };
            
                var _TDCheckBox = document.createElement("TD");
                _TDCheckBox.style.width = "22px";
                _TDCheckBox.style.cursor = "default";
                var _TDCheckBox_Sub = document.createElement("INPUT");
                _TDCheckBox_Sub.type = "checkbox";
                if (p_ListorderValue == "GROUPSUBLIST") { _TDCheckBox_Sub.onclick = function () { event_SublistCheckboxclick(this); }; }
                else { _TDCheckBox_Sub.onclick = function () { event_listCheckboxclick(this); }; }
                _TDCheckBox_Sub.style.margin = "0px";
                _TDCheckBox_Sub.style.padding = "0px";
                _TDCheckBox_Sub.style.width = "13px";
                _TDCheckBox_Sub.style.height = "13px";
                _TDCheckBox_Sub.style.cursor = "pointer";
                _TDCheckBox.appendChild(_TDCheckBox_Sub);
                _TR.appendChild(_TDCheckBox);
                XmlHeaderRows = SelectNodes(XmlHeader, "view/column");
                for (var HRows = 0; HRows < XmlHeaderRows.length; HRows++) {

                    var _TDColum = document.createElement("TD");
                    switch (SelectSingleNodeValue(XmlHeaderRows[HRows], "propname")) {
                        case "importance":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.cursor = "default";
                            _TDColum.innerHTML = p_Importance == "0" ? "<IMG style='cursor:default' draggable='false' src='/images/ImgIcon/icon-lowimportance.gif'/>" : p_Importance == "2" ? "<IMG style='cursor:default' src='/images/ImgIcon/icon-highimportance.gif'/>" : "";
                            break;
                        case "status":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.cursor = "default";
                            _TDColum.innerHTML = GetContentClassImg(p_ContentClass, p_Read);
                            break;
                        case "flag":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.cursor = "pointer";
                            _TDColum.innerHTML = p_Flag == "0" ? "<IMG style='cursor:pointer' draggable='false' src='/images/ImgIcon/view-flag.gif'/>" : "<IMG style='cursor:pointer' src='/images/ImgIcon/icon-flag.gif'/>";
                            _TDColum.onclick = function () { event_flag(this); };
                            break;
                        case "attach":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.cursor = "default";
                            _TDColum.innerHTML = p_Attach == "1" ? "<IMG id='imgCol' draggable='false' style='cursor:default' src='/images/newAttach.gif'/>" : "";
                            break;
                        case "sender":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.overflow = "hidden";
                            _TDColum.style.textOverflow = "ellipsis";
                            _TDColum.style.whiteSpace = "nowrap";
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.color = p_Importance == "2" ? importanceColor : "";
                            _TDColum.innerHTML = p_Sender;
                            _TDColum.style.fontWeight = p_Read == "0" ? "bold" : "";
                            _TDColum.onclick = function () { event_listclick(this); };
                            _TDColum.onmouseover = function () { event_listMover(this.parentElement); };
                            _TDColum.onmouseout = function () { event_listMout(this.parentElement); };
                            _TDColum.ondblclick = function () { event_listDBClick(this.parentElement); };
                            _TDColum.onselectstart = function () { return false; };
                            break;
                        case "subject":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.overflow = "hidden";
                            _TDColum.style.textOverflow = "ellipsis";
                            _TDColum.style.whiteSpace = "nowrap";
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.color = p_Importance == "2" ? importanceColor : "";
                            _TDColum.innerHTML = p_Subject;
                            _TDColum.style.fontWeight = p_Read == "0" ? "bold" : "";
                            _TDColum.onclick = function () { event_listclick(this); };
                            _TDColum.onmouseover = function () { event_listMover(this.parentElement); };
                            _TDColum.onmouseout = function () { event_listMout(this.parentElement); };
                            _TDColum.ondblclick = function () { event_listDBClick(this.parentElement); };
                            _TDColum.onselectstart = function () { return false; };
                            break;
                        case "receivedt":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.color = p_Importance == "2" ? importanceColor : "";
                            _TDColum.innerHTML = p_ReceiveDT;
                            _TDColum.style.fontWeight = p_Read == "0" ? "bold" : "";
                            _TDColum.onclick = function () { event_listclick(this); };
                            _TDColum.onmouseover = function () { event_listMover(this.parentElement); };
                            _TDColum.onmouseout = function () { event_listMout(this.parentElement); };
                            _TDColum.ondblclick = function () { event_listDBClick(this.parentElement); };
                            _TDColum.onselectstart = function () { return false; };
                            break;
                        case "size":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.color = p_Importance == "2" ? importanceColor : "";
                            _TDColum.innerHTML = FormatSize(p_Size);
                            _TDColum.style.fontWeight = p_Read == "0" ? "bold" : "";
                            _TDColum.onclick = function () { event_listclick(this); };
                            _TDColum.onmouseover = function () { event_listMover(this.parentElement); };
                            _TDColum.onmouseout = function () { event_listMout(this.parentElement); };
                            _TDColum.ondblclick = function () { event_listDBClick(this.parentElement); };
                            _TDColum.onselectstart = function () { return false; };
                            break;
                    }
                    _TR.appendChild(_TDColum);
                }
                GetListInfo_ContentObject.appendChild(_TR);
            }
            if (p_ListorderValue != "GROUPSUBLIST")
                mf_updatePageInfo(szRangeHeader)
            else
                mf_updatePageInfoGroupList(szRangeHeader)
        } catch (e) {
            alert(e.description);
        }
    }
    else if (p_ListorderValue == "SENT" || p_ListorderValue == "SUBJECT") {
        try {
            var XmlList = GetList_HTTP.responseXML;
            var XmlRows = SelectNodes(XmlList, "multistatus/response");
            var p_TotalCnt = getNodeText(SelectNodes(XmlList, "multistatus/CONTENTRANGE")[0]);
            var szRangeHeader = getNodeText(SelectNodes(XmlList, "multistatus/CONTENTRANGE")[0]);
            GetListInfo_ContentObject.innerHTML = "";
            document.getElementById("contentlist").scrollTop = "0";
            for (var Cnt = 0; Cnt < XmlRows.length; Cnt++) {
                var p_Sender = SelectSingleNodeValue(XmlRows[Cnt], "prop1");
                var p_VisibleCnt = SelectSingleNodeValue(XmlRows[Cnt], "visiblecount");
                var p_UnreadCnt = SelectSingleNodeValue(XmlRows[Cnt], "unreadcount");
                var _TR = document.createElement("TR");
                _TR.setAttribute("id", "MailGroupList_" + Cnt);
                _TR.style.cursor = "pointer";
                _TR.setAttribute("prop", p_Sender);
                _TR.setAttribute("mode", p_ListorderValue);
                _TR.onmouseover = function () { event_listMover(this); };
                _TR.onmouseout = function () { event_listMout(this); };
                _TR.onclick = function () { event_GrouplistDBClick(this); };
                _TR.onselectstart = function () { return false; };
                XmlHeaderRows = SelectNodes(XmlHeader, "view/column");
                
                var _TDExpColum = document.createElement("TD");
                _TDExpColum.style.width = "35px"
                var _TDExpImg = document.createElement("IMG");
                _TDExpImg.src = GroupplusImg;
                _TDExpImg.align = "absmiddle";
                var _TDExpImg2 = document.createElement("IMG");
                p_ListorderValue == "SENT" ? _TDExpImg2.src = GroupSenderImg : _TDExpImg2.src = GroupSubjectImg;
                _TDExpImg2.align = "absmiddle";
                _TDExpColum.appendChild(_TDExpImg);
                _TDExpColum.appendChild(_TDExpImg2);
                _TR.appendChild(_TDExpColum);
                for (var HRows = 0; HRows < XmlHeaderRows.length; HRows++) {
                    var _TDColum = document.createElement("TD");
                    switch (SelectSingleNodeValue(XmlHeaderRows[HRows], "propname")) {
                        case "subject":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.overflow = "hidden";
                            _TDColum.style.textOverflow = "ellipsis";
                            _TDColum.style.whiteSpace = "nowrap";
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.innerHTML = p_Sender + "<span style='color:" + GroupColor + ";'><b>(" + p_VisibleCnt + ")</b></span>";
                            break;
                        case "info":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.color = p_Importance == "2" ? importanceColor : "";
                            _TDColum.innerHTML = "<span >[" + strLang255 + "<span style='color:" + GroupColor + ";'><b>" + p_UnreadCnt + "</b></span> / " + strLang256 + "<span style='color:" + GroupColor + ";'><b>" + p_VisibleCnt + "</b></span>]</span>";
                            break;
                    }
                    _TR.appendChild(_TDColum);
                }
                var _HiddenTR = document.createElement("TR");
                _HiddenTR.setAttribute("id", "MailGroupList_" + Cnt+"sub");
                _HiddenTR.style.display = "none";
                var _HiddenTD = document.createElement("TD");
                _HiddenTD.colSpan = "3";
                _HiddenTR.appendChild(_HiddenTD);
                GetListInfo_ContentObject.appendChild(_TR);
                GetListInfo_ContentObject.appendChild(_HiddenTR);
            }
            mf_updatePageInfo(szRangeHeader)
        } catch (e) {
            alert(e.description);
        }
    }
}
function MakeListInfoHTML_SUB(ConentObject) {
        try {
            var XmlList = GetList_HTTP_SUB.responseXML;
            var XmlRows = SelectNodes(XmlList, "maillist/response");
            var p_TotalCnt = getNodeText(SelectNodes(XmlList, "maillist/CONTENTRANGE")[0]);
            var szRangeHeader = getNodeText(SelectNodes(XmlList, "maillist/CONTENTRANGE")[0]);
            GetListInfo_ContentObject.innerHTML = "";
            if (XmlRows.length == 0) {
                document.getElementById("contentlist").scrollTop = "0";
                try { p_ListorderValue = pGroupListClickObject.getAttribute("mode"); } catch (e) { }
                MailListRefresh();
                return;
            }
            for (var Cnt = 0; Cnt < XmlRows.length; Cnt++) {
                var p_Href = SelectSingleNodeValue(XmlRows[Cnt], "href");
                var p_Importance = SelectSingleNodeValue(XmlRows[Cnt], "importance");
                var p_Flag = SelectSingleNodeValue(XmlRows[Cnt], "flag");
                var p_Attach = SelectSingleNodeValue(XmlRows[Cnt], "attach");
                var p_Sender = SelectSingleNodeValue(XmlRows[Cnt], "sender");
                var p_Subject = SelectSingleNodeValue(XmlRows[Cnt], "subject");
                var p_ReceiveDT = SelectSingleNodeValue(XmlRows[Cnt], "receivedt");
                var p_Size = SelectSingleNodeValue(XmlRows[Cnt], "size");
                var p_Read = SelectSingleNodeValue(XmlRows[Cnt], "read");
                var p_ContentClass = SelectSingleNodeValue(XmlRows[Cnt], "contentclass");
                var _TR = document.createElement("TR");
                _TR.setAttribute("id", "Maillist_" + Cnt);
                _TR.style.cursor = "pointer";
                _TR.style.fontWeight = p_Read == "0" ? "bold" : "";
                _TR.style.color = p_Importance == "2" ? "red" : "";
                _TR.style.verticalAlign = "middle";
                _TR.style.cursor = "pointer";
                _TR.setAttribute("_href", p_Href);
                _TR.setAttribute("_subject", p_Subject);
                _TR.setAttribute("read", p_Read);
                _TR.setAttribute("_contentclass", p_ContentClass);
                _TR.onmouseover = function () { event_SublistMover(this); };
                _TR.onmouseout = function () { event_SublistMout(this); };
                _TR.onclick = function () { event_Sublistclick(this); };
                _TR.ondblclick = function () { event_SublistDBClick(this); };
                _TR.onselectstart = function () { return false; };
                var _TDCheckBox = document.createElement("TD");
                _TDCheckBox.style.width = "22px";
                var _TDCheckBox_Sub = document.createElement("INPUT");
                _TDCheckBox_Sub.type = "checkbox";
                _TDCheckBox_Sub.onclick = function () { event_SublistCheckboxclick(this); };
                _TDCheckBox_Sub.style.margin = "0px";
                _TDCheckBox_Sub.style.padding = "0px";
                _TDCheckBox_Sub.style.width = "13px";
                _TDCheckBox_Sub.style.height = "13px";
                _TDCheckBox.appendChild(_TDCheckBox_Sub);
                _TR.appendChild(_TDCheckBox);
                XmlHeaderRows = SelectNodes(XmlHeader_SUB, "view/column");
                for (var HRows = 0; HRows < XmlHeaderRows.length; HRows++) {

                    var _TDColum = document.createElement("TD");
                    switch (SelectSingleNodeValue(XmlHeaderRows[HRows], "propname")) {
                        case "importance":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.innerHTML = p_Importance == "0" ? "<IMG style='cursor:pointer' draggable='false' src='/images/ImgIcon/icon-lowimportance.gif'/>" : p_Importance == "2" ? "<IMG style='cursor:pointer' src='/images/ImgIcon/icon-highimportance.gif'/>" : "";
                            break;
                        case "status":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.innerHTML = GetContentClassImg(p_ContentClass, p_Read);
                            break;
                        case "flag":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.innerHTML = p_Flag == "0" ? "" : "<IMG style='cursor:pointer' draggable='false' src='/images/ImgIcon/icon-flag.gif'/>";
                            break;
                        case "attach":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.innerHTML = p_Attach == "1" ? "<IMG id='imgCol' style='cursor:pointer' draggable='false' src='/images/ImgIcon/view-paperclip.gif '/>" : "";
                            break;
                        case "sender":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.overflow = "hidden";
                            _TDColum.style.textOverflow = "ellipsis";
                            _TDColum.style.whiteSpace = "nowrap";
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.color = p_Importance == "2" ? importanceColor : "";
                            _TDColum.innerHTML = p_Sender;
                            _TDColum.style.fontWeight = p_Read == "0" ? "bold" : "";
                            break;
                        case "subject":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.overflow = "hidden";
                            _TDColum.style.textOverflow = "ellipsis";
                            _TDColum.style.whiteSpace = "nowrap";
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.color = p_Importance == "2" ? importanceColor : "";
                            _TDColum.innerHTML = p_Subject;
                            _TDColum.style.fontWeight = p_Read == "0" ? "bold" : "";
                            break;
                        case "receivedt":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.color = p_Importance == "2" ? importanceColor : "";
                            _TDColum.innerHTML = p_ReceiveDT;
                            _TDColum.style.fontWeight = p_Read == "0" ? "bold" : "";
                            break;
                        case "size":
                            _TDColum.style.textAlign = SelectSingleNodeValue(XmlHeaderRows[HRows], "align");
                            _TDColum.style.width = SelectSingleNodeValue(XmlHeaderRows[HRows], "width");
                            _TDColum.style.color = p_Importance == "2" ? importanceColor : "";
                            _TDColum.innerHTML = FormatSize(p_Size);
                            _TDColum.style.fontWeight = p_Read == "0" ? "bold" : "";
                            break;
                    }
                    _TR.appendChild(_TDColum);
                }
                GetListInfo_ContentObject.appendChild(_TR);
            }
            mf_updatePageInfoGroupList(szRangeHeader)
        } catch (e) {
            alert(e.description);
        }
}
function MailSelect_One() {
    if (document.getElementById("Maillist_0") != null)
        document.getElementById("Maillist_0").onclick();
}
var pOldSearchKeyword;
function GetListInfo(HeaderObject, ContentObject) {
    listSubContentArry = new Array();
    listContentArry = new Array();
    var xmlpara = createXmlDom();
    var objNode;
    var pageCount = parseInt(document.getElementById("MailList").getAttribute("listpageCount"));
    var curPage =  parseInt(document.getElementById("MailList").getAttribute("curPage"));
    var MaxCount = parseInt(document.getElementById("MailList").getAttribute("MaxCount"));
    var MaxPage = parseInt(document.getElementById("MailList").getAttribute("MaxPage"));
    var pStart;
    var pEnd;
    if (searchMode) {
        if (pOldSearchKeyword != SearchKeyword)
            curPage = 1; MaxCount = 0; MaxPage = 0;
    }
    pStart = (pageCount * (curPage - 1));
    pEnd = ((curPage) * pageCount) - 1;
    if (pEnd > MaxCount && MaxCount != 0)
        pEnd = MaxCount;
        
    if (pStart >= MaxCount && pEnd >= MaxCount && MaxCount != 0) {
        curPage = Math.ceil(MaxCount / pageCount);
        document.getElementById("MailList").setAttribute("curPage", curPage);
        pStart = (pageCount * (curPage - 1));
        pEnd = ((curPage) * pageCount) - 1;
        if (pEnd > MaxCount || MaxCount != 0)
            pend = MaxCount;
    }

    var pOrderyOption = p_ListorderType + " ORDER BY \"" + p_ListOrderby + "\" " + p_ListOrderOption;

    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "FOLDERID", g_moveUrl);
    createNodeAndInsertText(xmlpara, objNode, "SORTTYPE", pOrderyOption);
    if (searchMode) {
        pOldSearchKeyword = SearchKeyword;
        createNodeAndInsertText(xmlpara, objNode, "SEARCH", SearchKeyword);
    }
    else {
        createNodeAndInsertText(xmlpara, objNode, "SEARCH", "");
    }
    createNodeAndInsertText(xmlpara, objNode, "START", pStart);
    if(p_ListorderValue == "GROUPSUBLIST")
        createNodeAndInsertText(xmlpara, objNode, "END", "ALL");
    else
        createNodeAndInsertText(xmlpara, objNode, "END", pEnd);

    createNodeAndInsertText(xmlpara, objNode, "VIEWSELECTINDEX", select.selectedIndex);

    GetList_HTTP = createXMLHttpRequest();
    GetList_HTTP.open("POST", "/ezEmail/mailGetList.do", true);
    GetList_HTTP.onreadystatechange = GetListIevent_ongetxmlcomplete;
    GetList_HTTP.send(xmlpara);
    GetListInfo_HeaderObject = HeaderObject;
    GetListInfo_ContentObject = ContentObject;
    ShowMailProgress();
}
var p_ListorderType_SUB;
var p_ListOrderby_SUB;
var p_ListOrderOption_SUB;
function GetListInfo_SUB(HeaderObject, ContentObject) {
    listSubContentArry = new Array();
    listContentArry = new Array();
    var xmlpara = createXmlDom();
    var objNode;
    var pageCount = parseInt(document.getElementById("MailList").getAttribute("listpageCount"));
    var curPage = parseInt(document.getElementById("MailList").getAttribute("curPage"));
    var MaxCount = parseInt(document.getElementById("MailList").getAttribute("MaxCount"));
    var MaxPage = parseInt(document.getElementById("MailList").getAttribute("MaxPage"));
    var pStart;
    var pEnd;
    pStart = (pageCount * (curPage - 1));
    pEnd = ((curPage) * pageCount) - 1;
    if (pEnd > MaxCount && MaxCount != 0)
        pEnd = MaxCount;

    if (pStart >= MaxCount && pEnd >= MaxCount && MaxCount != 0) {
        curPage = Math.ceil(MaxCount / pageCount);
        document.getElementById("MailList").setAttribute("curPage", curPage);
        pStart = (pageCount * (curPage - 1));
        pEnd = ((curPage) * pageCount) - 1;
        if (pEnd > MaxCount || MaxCount != 0)
            pend = MaxCount;
    }

    var pOrderyOption = p_ListorderType_SUB + " ORDER BY \"" + p_ListOrderby_SUB + "\" " + p_ListOrderOption_SUB;

    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "FOLDERID", g_moveUrl);
    createNodeAndInsertText(xmlpara, objNode, "SORTTYPE", pOrderyOption);
    if (searchMode) {
        createNodeAndInsertText(xmlpara, objNode, "SEARCH", SearchKeyword);
    }
    else {
        createNodeAndInsertText(xmlpara, objNode, "SEARCH", "");
    }
    createNodeAndInsertText(xmlpara, objNode, "START", pStart);
    createNodeAndInsertText(xmlpara, objNode, "END", "ALL");
    
    createNodeAndInsertText(xmlpara, objNode, "VIEWSELECTINDEX", select.selectedIndex);

    GetList_HTTP_SUB = createXMLHttpRequest();
    GetList_HTTP_SUB.open("POST", "/ezEmail/mailGetList.do", true);
    GetList_HTTP_SUB.onreadystatechange = GetListIevent_ongetxmlcomplete_SUB;
    GetList_HTTP_SUB.send(xmlpara);
    GetListInfo_HeaderObject = HeaderObject;
    GetListInfo_ContentObject = ContentObject;
    ShowMailProgress();
}

function GetListIevent_ongetxmlcomplete() {
    if (GetList_HTTP != null && GetList_HTTP.readyState == 4) {
        if (GetList_HTTP.status >= 200 && GetList_HTTP.status < 300) {
            MakeListInfoHTML(GetListInfo_HeaderObject, GetListInfo_ContentObject);
            
            if (GetList_HTTP.responseXML != null) {
                if (SelectNodes(GetList_HTTP.responseXML, "maillist/response").length == 0) {
                    if (parseInt(GetAttribute(document.getElementById("MailList"), "curPage")) > 1) {
                        goToPageByNum(parseInt(GetAttribute(document.getElementById("MailList"), "curPage")) - 1);
                        return;
                    }
                }
                try {
                    if (document.getElementById("HeaderAllCheckBox") != null)
                        document.getElementById("HeaderAllCheckBox").checked = false;
                } catch (e) { }
            } else {
            	parent.frames["left"].reloadRetryCount--;
            	
            	if (parent.frames["left"].reloadRetryCount >= 0) {
            		location.reload(true);
            	} else {
            		parent.frames["left"].reloadRetryCount = 1;
            	}
            }
            
            HiddenMailProgress();
            GetList_HTTP = null;
        }
    }
}
function GetListIevent_ongetxmlcomplete_SUB() {
    if (GetList_HTTP_SUB != null && GetList_HTTP_SUB.readyState == 4) {
        if (GetList_HTTP_SUB.status >= 200 && GetList_HTTP_SUB.status < 300) {
            MakeListInfoHTML_SUB(GetListInfo_HeaderObject, GetListInfo_ContentObject);
            HiddenMailProgress();
            try { p_ListorderValue = pGroupListClickObject.getAttribute("mode"); } catch (e) { }
            GetList_HTTP_SUB = null;
        }
    }
}
function on_changeView(listtypeValue) {
    MailOptionHidden();
    p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile1.xml";
    p_ListOrderby = "urn:schemas:httpmail:datereceived";
    p_ListOrderOption = "DESC";
    switch (listtypeValue) {
        case "BASE":
        case "PREVIEW": 
            p_ListorderType = "";
            p_ListorderValue = "";
            break;
        case "UNREAD":
            p_ListorderType = "WHERE \"http://schemas.microsoft.com/mapi/proptag/0x67aa000b\" = false AND \"DAV:isfolder\" = false AND \"urn:schemas:httpmail:read\" = false";
            p_ListorderValue = "UNREAD";
            break;
        case "SENT":
            p_ListorderType = " WHERE \"http://schemas.microsoft.com/mapi/proptag/0x67aa000b\" = false AND \"DAV:isfolder\" = false " +
                              " GROUP BY \"http://schemas.microsoft.com/mapi/sent_representing_name\" ";
            p_ListorderValue = "SENT";
            p_ListOrderby = "http://schemas.microsoft.com/mapi/sent_representing_name";
            p_ListOrderOption = "ASC";
            p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile3.xml";
            break;
        case "SUBJECT":
            p_ListorderType = " WHERE \"http://schemas.microsoft.com/mapi/proptag/0x67aa000b\" = false AND \"DAV:isfolder\" = false " +
                              " GROUP BY \"http://schemas.microsoft.com/mapi/proptag/x0e1d001f\" ";
            p_ListorderValue = "SUBJECT";
            p_ListOrderby = "http://schemas.microsoft.com/mapi/proptag/x0e1d001f";
            p_ListOrderOption = "ASC";
            p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile4.xml";
            break;
        case "RECEIV":
            p_ListorderType = "WHERE \"http://schemas.microsoft.com/mapi/proptag/0x67aa000b\" = false AND \"DAV:isfolder\" = false ";
            p_ListorderValue = "RECEIV";
            p_ListOrderby = "http://schemas.microsoft.com/exchange/date-iso";
            p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile2.xml";
            break;
    }
    if (p_ListorderValue != "SENT" && p_ListorderValue != "SUBJECT" && p_ListorderValue != "RECEIV") {
        if (pPreviewShow_HOW == "H") {
            if (pMailListWidthH <= parseInt(CurrenWidth * 0.40)) { 
                if (g_foldertype != "sent") {
                    p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile1_1.xml";
                    SmallSizeList = true;
                    OldSmallSizeList = true;
                }
            }
        }
    }
    searchMode = false;
    _RowObject = null;
    _SubRowObject = null;
    pGroupListClickObject = null;
    listContentArry = new Array();
    listSubContentArry = new Array();
    document.getElementsByName('keyword').item(0).value = "";
    document.getElementById("MailList").setAttribute("curPage", "1");
    document.getElementById("MailList").setAttribute("maxcount", "0");
    document.getElementById("MailList").setAttribute("maxpage", "0");
    var HeaderObject = document.getElementById("MailHeader");
    var ContentObject = document.getElementById("MailList");
    HeaderIni(HeaderObject);
    GetListInfo(HeaderObject,ContentObject);
}
function mf_updatePageInfo(szRangeHeader) {
    var pageCount = parseInt(document.getElementById("MailList").getAttribute("listpageCount"));
    var curPage = parseInt(document.getElementById("MailList").getAttribute("curPage"));
    var MaxCount = parseInt(document.getElementById("MailList").getAttribute("MaxCount"));

    var szRangeHeaderArray = szRangeHeader.split(';');
    m_iStartRange = parseInt(szRangeHeaderArray[1]);
    m_imaxRows = parseInt(szRangeHeaderArray[4]);
    document.getElementById("MailList").setAttribute("MaxCount", m_imaxRows);
    m_iMaxPageNumber = Math.ceil(m_imaxRows / pageCount);
    document.getElementById("MailList").setAttribute("MaxPage", m_iMaxPageNumber);
    var num = Math.ceil((m_iStartRange + pageCount) / pageCount);
    document.getElementById("MailList").setAttribute("curPage", num);
    pFolderTotalCount = szRangeHeaderArray[6];
    pFolderUnReadCount = szRangeHeaderArray[8];
    makePageSelPage();
}
function mf_updatePageInfoGroupList(szRangeHeader) {
    var szRangeHeaderArray = szRangeHeader.split(';');
    m_iStartRange = parseInt(szRangeHeaderArray[1]);
    m_imaxRows = parseInt(szRangeHeaderArray[4]);
    document.getElementById("GroupSubList").setAttribute("MaxCount", m_imaxRows);
    document.getElementById("MailList").setAttribute("MaxPage", "1");
    document.getElementById("MailList").setAttribute("curPage", "1");
}

function MailListRefreshByTimeout() {
	setTimeout(function() {
		MailListRefresh();
	}, 500);
}

function MailListRefresh() {
    if (p_ListorderValue != "SENT" && p_ListorderValue != "SUBJECT") {
        goToPageByNum(MailList.getAttribute("curPage"));
    }
    else {
        if (listSubContentArry.length > 0) {
            var pGroupProp = pGroupListClickObject.getAttribute("prop");
            var pGroupMode = pGroupListClickObject.getAttribute("mode");
            p_HeaderViewXML = "Controls_cross/" + g_userLang + "/viewXMLFile1.xml";
            if (pGroupMode == "SENT") {
                p_ListorderType = " WHERE \"http://schemas.microsoft.com/mapi/proptag/0x67aa000b\" = false AND \"DAV:isfolder\" = false " +
                                  " AND \"http://schemas.microsoft.com/mapi/sent_representing_name\" = '" + pGroupProp + "' ";
                p_ListorderValue = "GROUPSUBLIST";
                p_ListOrderby = "urn:schemas:httpmail:datereceived";
                p_ListOrderOption = "DESC";
            }
            else if (pGroupMode == "SUBJECT") {
                p_ListorderType = " WHERE \"http://schemas.microsoft.com/mapi/proptag/0x67aa000b\" = false AND \"DAV:isfolder\" = false " +
                                  " AND \"http://schemas.microsoft.com/mapi/proptag/x0e1d001f\" = '" + pGroupProp + "' ";
                p_ListorderValue = "GROUPSUBLIST";
                p_ListOrderby = "urn:schemas:httpmail:datereceived";
                p_ListOrderOption = "DESC";
            }
            var NewDIV = document.createElement("DIV");
            NewDIV.innerHTML = document.getElementById("GroupSubObject").innerHTML;
            var SubGroupListTarget = document.getElementById(pGroupListClickObject.getAttribute("id") + "sub")
            SubGroupListTarget.style.display = "";
            SubGroupListTarget.childNodes.item(0).appendChild(NewDIV);
            pGroupListClickObject.style.backgroundColor = m_strColorSelect;
            pGroupListClickObject.childNodes.item(0).childNodes.item(0).src = GroupminImg;
            var HeaderObject = document.getElementById("GroupSubHeader");
            var ContentObject = document.getElementById("GroupSubList");
            listSubContentArry = new Array();
            listContentArry = new Array();
            HeaderIni_SUB(HeaderObject);
            GetListInfo_SUB(HeaderObject, ContentObject);
        }
        else {
            on_changeView(document.getElementById("select").value);
        }
    }
    
    refreshUnreadCount();
    
    // commented out to maintain the current preview content when the mail list is refreshed : dhlee
//    prevShow_Clear();
}
function BasicViewHeaderChange(pGubun) {
    if (pGubun) {
        if (p_HeaderViewXML == "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile1_1.xml")
            return;

        p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile1_1.xml";
    } else {
        if (p_HeaderViewXML == "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile1.xml")
            return;

        p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile1.xml";
    }
    listContentArry = new Array();
    listSubContentArry = new Array();
    var HeaderObject = document.getElementById("MailHeader");
    var ContentObject = document.getElementById("MailList");
    HeaderIni(HeaderObject);
    GetListInfo(HeaderObject, ContentObject);
}
function goToPageByNum(szNum) {
    document.getElementById("MailList").setAttribute("curPage", szNum)
    var HeaderObject = document.getElementById("MailHeader");
    var ContentObject = document.getElementById("MailList");
    GetListInfo(HeaderObject,ContentObject);
}
function selbeforeBlock() {
    var pageNum = parseInt(document.getElementById("MailList").getAttribute("curPage"));
    pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
    goToPageByNum(pageNum);
}
function selafterBlock() {
    var pageNum = parseInt(document.getElementById("MailList").getAttribute("curPage"));
    pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
    goToPageByNum(pageNum);
}
function selafterBlock_one() {
    var pageNum = parseInt(document.getElementById("MailList").getAttribute("curPage"));
    var totalPage = parseInt(document.getElementById("MailList").getAttribute("MaxPage"));
    if (parseInt(pageNum + 1) <= totalPage)
        goToPageByNum(parseInt(parseInt(pageNum + 1)));
    else
        return;
}
function selbeforeBlock_one() {
    var pageNum = parseInt(document.getElementById("MailList").getAttribute("curPage"));
    var totalPage = parseInt(document.getElementById("MailList").getAttribute("MaxPage"));
    if (parseInt(pageNum -1) > 0)
        goToPageByNum(parseInt(parseInt(pageNum - 1)));
    else
        return;
}
function td_Create1(strtext) {
    document.getElementById("tblPageRayer").innerHTML = strtext;
}
function makePageSelPage() {
    var strtext;
    var PagingHTML = "";
    document.getElementById("tblPageRayer").innerHTML = "";
    strtext = "<div class=\"pagenavi\">";
    PagingHTML += strtext;
    var totalPage = parseInt(document.getElementById("MailList").getAttribute("MaxPage"));
    var pageNum = parseInt(document.getElementById("MailList").getAttribute("curPage"));
    document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang255 + "<span style='color:#017BEC;'> " + pFolderUnReadCount + " </span>" + strLang257 + " / " + strLang256 + "<span style='color:#017BEC;'> " + pFolderTotalCount + " </span>" + strLang257 + "</b>]";
    if (totalPage > 1 && pageNum != 1) {
        PagingHTML += "<span class=\"btnimg\" onclick= 'return goToPageByNum(1)'><img src=\"/images/kr/cm/btn_p_prev.gif\" width=\"16\" height=\"16\"></span>";
    }
    else {
        PagingHTML += "<span class=\"btnimg\"><img src=\"/images/kr/cm/btn_p_prev01.gif\" width=\"16\" height=\"16\"></span>";
    }
    if (totalPage > BlockSize) {
        if (pageNum > BlockSize) {
            PagingHTML += "<span class=\"btnimg\" onclick= 'return selbeforeBlock()'><img src=\"/images/kr/cm/btn_prev.gif\" width=\"16\" height=\"16\"></span><span class=\"ptxt\" onclick= 'return selbeforeBlock_one()'>" + strLang258 + "</span>";
        }
        else {
            PagingHTML += "<span class=\"btnimg\" ><img src=\"/images/kr/cm/btn_prev01.gif\" width=\"16\" height=\"16\"></span><span class=\"ptxt\" onclick= 'return selbeforeBlock_one()'>" + strLang258 + "</span>";
        }
    }
    else {
        PagingHTML += "<span class=\"btnimg\" ><img src=\"/images/kr/cm/btn_prev01.gif\" width=\"16\" height=\"16\"></span><span class=\"ptxt\" onclick= 'return selbeforeBlock_one()'>" + strLang258 + "</span>";
    }
    var MaxNum;
    var i;
    var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
    if (totalPage >= (startNum + parseInt(BlockSize))) {
        MaxNum = (startNum + parseInt(BlockSize)) - 1;
    }
    else {
        MaxNum = totalPage;
    }
    for (i = startNum; i <= MaxNum; i++) {
        if (i == pageNum) {
            PagingHTML += "<span class=\"on\">" + i + "</span>";
        }
        else {
            PagingHTML += "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
        }
    }
    if (totalPage > BlockSize) {
        if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
            PagingHTML += "<span class=\"ptxt\" onclick='return selafterBlock_one()'>" + strLang259 + "</span><span class=\"btnimg\" onclick='return selafterBlock()'><img src=\"/images/kr/cm/btn_next.gif\" width=\"16\" height=\"16\"></span>";
        }
        else {
            PagingHTML += "<span class=\"ptxt\" onclick='return selafterBlock_one()'>" + strLang259 + "</span><span class=\"btnimg\"><img src=\"/images/kr/cm/btn_next01.gif\" width=\"16\" height=\"16\"></span>";
        }
    }
    else {
        PagingHTML += "<span class=\"ptxt\" onclick='return selafterBlock_one()'>" + strLang259 + "</span><span class=\"btnimg\"><img src=\"/images/kr/cm/btn_next01.gif\" width=\"16\" height=\"16\"></span>";
    }
    if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
        PagingHTML += "<span class=\"btnimg\" onclick='return goToPageByNum(" + totalPage + ")'><img src=\"/images/kr/cm/btn_n_next.gif\" width=\"16\" height=\"16\"></span>";
    }
    else {
        PagingHTML += "<span class=\"btnimg\"><img src=\"/images/kr/cm/btn_n_next01.gif\" width=\"16\" height=\"16\"></span>";
    }
    PagingHTML += "</div>";
    td_Create1(PagingHTML);
}
function event_listContextMenu(event) {
    if (!event) event = window.event;
    var EventMouseX = event.clientX;
    var EventMouseY = event.clientY;

    var listsizeheight = document.documentElement.clientHeight;
    var listsizewidth = document.documentElement.clientWidth;
    var EventDivSize = EventMouseY + 240;
    if (listsizeheight < EventDivSize) {
        var Div_ = EventDivSize - listsizeheight;
        EventMouseY = EventMouseY - Div_;
    }

    EventDivSize = EventMouseX + 140;
    if (listsizewidth < EventDivSize) {
        var Div_ = EventDivSize - listsizewidth;
        EventMouseX = EventMouseX - Div_;
    }

    document.getElementById("mailPanel").style.display = "";
    document.getElementById("ContextMenuDiv").style.left = EventMouseX + "px";
    document.getElementById("ContextMenuDiv").style.top = EventMouseY + "px";
    document.getElementById("ContextMenuDiv").style.display = "";
}
function event_listMover(obj) {
    if (pGroupListClickObject != obj && !obj.childNodes.item(0).childNodes.item(0).checked) {
        obj.style.backgroundColor = m_strColorOver;
    }
}
function event_SublistMover(obj) {
    if (obj != _SubRowObject && !obj.childNodes.item(0).childNodes.item(0).checked) {
        obj.style.backgroundColor = m_strColorOver;
    }
}
function event_listMout(obj) {
    if (pGroupListClickObject != obj && !obj.childNodes.item(0).childNodes.item(0).checked) {
        obj.style.backgroundColor = m_strColorDefault;
    }
}
function event_SublistMout(obj) {
    if (obj != _SubRowObject && !obj.childNodes.item(0).childNodes.item(0).checked) {
        obj.style.backgroundColor = m_strColorDefault;
    }
}
function event_HeaderClick(obj) {
    if (p_ListOrderObject != null) {
        if (p_ListOrderObject.childNodes.length > 1 && p_ListOrderObject.childNodes[1].nodeName == "IMG")
            p_ListOrderObject.childNodes.item(1).outerHTML = "";
    }
    p_ListOrderObject = obj;
    p_ListOrderOption = p_ListOrderObject.getAttribute("orderoption");
    if (p_ListOrderOption == "DESC")
        p_ListOrderOption = "ASC";
    else if (p_ListOrderOption == "ASC")
        p_ListOrderOption = "DESC";
    else
        p_ListOrderOption = "DESC";

    p_ListOrderObject.setAttribute("orderoption", p_ListOrderOption);
    p_ListOrderby = p_ListOrderObject.getAttribute("prop");

    if (p_ListOrderObject.childNodes.length > 1 && p_ListOrderObject.childNodes[1].nodeName == "IMG") {
        if (p_ListOrderOption == "DESC")
            p_ListOrderObject.childNodes[1].setAttribute("src", "/images/etc/view-sortdown.gif");
        else
            p_ListOrderObject.childNodes[1].setAttribute("src", "/images/etc/view-sortup.gif");
    }
    else {
        var _HeaderSpanimg = document.createElement("IMG");
        if (p_ListOrderOption == "DESC")
            _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortdown.gif");
        else
            _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortup.gif");

        _HeaderSpanimg.setAttribute("align", "absmiddle");
        obj.appendChild(_HeaderSpanimg);
    }
    var HeaderObject = document.getElementById("MailHeader");
    var ContentObject = document.getElementById("MailList");
    GetListInfo(HeaderObject, ContentObject);
}
function event_SubHeaderClick(obj) {
    if (p_SubListOrderObject != null) {
        if (p_SubListOrderObject.childNodes.length > 1 && p_SubListOrderObject.childNodes[1].nodeName == "IMG")
            p_SubListOrderObject.childNodes.item(1).outerHTML = "";
    }
    p_SubListOrderObject = obj;
    p_ListOrderOption_SUB = p_SubListOrderObject.getAttribute("orderoption");
    if (p_ListOrderOption_SUB == "DESC")
        p_ListOrderOption_SUB = "ASC";
    else if (p_ListOrderOption_SUB == "ASC")
        p_ListOrderOption_SUB = "DESC";
    else
        p_ListOrderOption_SUB = "DESC";

    p_SubListOrderObject.setAttribute("orderoption", p_ListOrderOption_SUB);
    p_ListOrderby_SUB = p_SubListOrderObject.getAttribute("prop");

    if (p_SubListOrderObject.childNodes.length > 1 && p_SubListOrderObject.childNodes[1].nodeName == "IMG") {
        if (p_ListOrderOption_SUB == "DESC")
            p_SubListOrderObject.childNodes[1].setAttribute("src", "/images/etc/view-sortdown.gif");
        else
            p_SubListOrderObject.childNodes[1].setAttribute("src", "/images/etc/view-sortup.gif");
    }
    else {
        var _HeaderSpanimg = document.createElement("IMG");
        if (p_ListOrderOption_SUB == "DESC")
            _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortdown.gif");
        else
            _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortup.gif");

        _HeaderSpanimg.setAttribute("align", "absmiddle");
        p_SubListOrderObject.appendChild(_HeaderSpanimg);
    }
    var HeaderObject = document.getElementById("GroupSubHeader");
    var ContentObject = document.getElementById("GroupSubList");
    GetListInfo_SUB(HeaderObject, ContentObject);
}
function event_SubHeaderCheckBoxClick(obj) {
    if (obj.checked) {
        for (var i = 0; i < document.getElementById("GroupSubList").childNodes.length; i++) {
            document.getElementById("GroupSubList").childNodes.item(i).childNodes.item(0).childNodes.item(0).checked = true;
            document.getElementById("GroupSubList").childNodes.item(i).style.backgroundColor = m_strColorSelect;
            listSubContentArry[listSubContentArry.length] = document.getElementById("GroupSubList").childNodes.item(i).getAttribute("id");
        }
    }
    else {
        for (var i = 0; i < document.getElementById("GroupSubList").childNodes.length; i++) {
            document.getElementById("GroupSubList").childNodes.item(i).childNodes.item(0).childNodes.item(0).checked = false;
            document.getElementById("GroupSubList").childNodes.item(i).style.backgroundColor = m_strColorDefault;
        }
        listSubContentArry = new Array();
    }
}
function event_HeaderCheckBoxClick(obj) {
    if (obj.checked) {
        for (var i = 0; i < document.getElementById("MailList").childNodes.length; i++) {
            document.getElementById("MailList").childNodes.item(i).childNodes.item(0).childNodes.item(0).checked = true;
            document.getElementById("MailList").childNodes.item(i).style.backgroundColor = m_strColorSelect;
            //TODO: 테스트해보기 2016-06-02
            // dhlee: modified so that existing elements aren't merged with new ones.
            //listContentArry[listContentArry.length] = document.getElementById("MailList").childNodes.item(i).getAttribute("id");
            listContentArry[i] = document.getElementById("MailList").childNodes.item(i).getAttribute("id");
        }
    }
    else {
        for (var i = 0; i < document.getElementById("MailList").childNodes.length; i++) {
            document.getElementById("MailList").childNodes.item(i).childNodes.item(0).childNodes.item(0).checked = false;
            document.getElementById("MailList").childNodes.item(i).style.backgroundColor = m_strColorDefault;
        }
        listContentArry = new Array();
    }
}
var PressShiftKey = false;
var PressCtrlKey = false;
function event_listOnkeyUp(event) {
    if (navigator.userAgent.indexOf('Firefox') != -1) {
        if (!event) event = window.event;
    }
    switch (event.keyCode) {
        case 16: PressShiftKey = false; break;
        case 17: PressCtrlKey = false; break;
        case 46:
            if (event.shiftKey) {
                deleteWork(true);
                PressShiftKey = false;
            }
            else {
                deleteWork(false);
            }
            break;
    }

}
function event_listOnkeyDown(event) {
    if (navigator.userAgent.indexOf('Firefox') != -1) {
        if (!event) event = window.event;
    }
    switch (event.keyCode) {
        case 16: PressShiftKey = true; break;
        case 17: PressCtrlKey = true; break;
    }
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
var listContentArry = new Array();
var listSubContentArry = new Array();
var listEventCheckbox = false;
var listSubEventCheckbox = false;
function event_listclick(obj) {
	if (obj.tagName == "TD") {
        obj = obj.parentElement;
    }
    if (!listEventCheckbox) {
        if (document.getElementById("HeaderAllCheckBox").checked) {
            var TemplistArray = new Array();
            if (obj.childNodes.item(0).childNodes.item(0).checked) {
                for (var i = 0; i < listContentArry.length; i++) {
                    if (obj.getAttribute("id") == listContentArry[i]) {
                        obj.childNodes.item(0).childNodes.item(0).checked = false;
                        obj.style.backgroundColor = m_strColorDefault;
                    }
                    else {
                        TemplistArray[TemplistArray.length] = listContentArry[i];
                    }
                }
                listContentArry = TemplistArray;
            }
            else {
                obj.childNodes.item(0).childNodes.item(0).checked = true;
                obj.style.backgroundColor = m_strColorSelect;
                listContentArry[listContentArry.length] = obj.getAttribute("id");
            }
        }
        else {
            if (!event.shiftKey && !event.ctrlKey && listContentArry.length > 0) {
                for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
                    _RowObject = document.getElementById(listContentArry[Cnt]);
                    _RowObject.style.backgroundColor = m_strColorDefault;
                    _RowObject.childNodes.item(0).childNodes.item(0).checked = false;
                }
                listContentArry = new Array();
            }
            if (event.shiftKey) {
                var SelectedPreObj = null;
                for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
                    _RowObject = document.getElementById(listContentArry[Cnt]);
                    if (Cnt == 0)
                        SelectedPreObj = _RowObject;

                    _RowObject.style.backgroundColor = m_strColorDefault;
                    _RowObject.childNodes.item(0).childNodes.item(0).checked = false;
                }
                listContentArry = new Array();
                _RowObject = obj;
                var PrelistContent;
                if (SelectedPreObj == null)
                    PrelistContent = _RowObject.getAttribute("id");
                else
                    PrelistContent = SelectedPreObj.getAttribute("id");

                var CurlistContent = obj.getAttribute("id");
                var PrePoint = parseInt(PrelistContent.replace("Maillist_", ""));
                var CurPoint = parseInt(CurlistContent.replace("Maillist_", ""));
                if (PrePoint < CurPoint) {

                    for (var Cnt = PrePoint; Cnt <= CurPoint; Cnt++) {
                        _RowObject = document.getElementById("Maillist_" + Cnt);
                        _RowObject.style.backgroundColor = m_strColorSelect;
                        _RowObject.childNodes.item(0).childNodes.item(0).checked = true;
                        listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
                    }

                }
                else if (PrePoint > CurPoint) {
                    for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
                        _RowObject = document.getElementById("Maillist_" + Cnt);
                        _RowObject.style.backgroundColor = m_strColorSelect;
                        _RowObject.childNodes.item(0).childNodes.item(0).checked = true;
                        listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
                    }
                }
                else if (PrePoint == CurPoint) {
                    if (_RowObject.childNodes.item(0).childNodes.item(0).checked) {
                        _RowObject.style.backgroundColor = m_strColorDefault;
                        _RowObject.childNodes.item(0).childNodes.item(0).checked = false;
                        listContentArry = ArrayDelete(listContentArry, _RowObject.id);
                    }
                    else {
                        _RowObject.style.backgroundColor = m_strColorSelect;
                        _RowObject.childNodes.item(0).childNodes.item(0).checked = true;
                        listContentArry[listContentArry.length] = GetAttribute(_RowObject, "id");
                        prevShow();
                    }
                }
                else
                    return;
            }
            else {
                _RowObject = obj;
                if (_RowObject.childNodes.item(0).childNodes.item(0).checked) {
                    _RowObject.style.backgroundColor = m_strColorDefault;
                    _RowObject.childNodes.item(0).childNodes.item(0).checked = false;
                    listContentArry = ArrayDelete(listContentArry, _RowObject.id);
                }
                else {
                    _RowObject.style.backgroundColor = m_strColorSelect;
                    _RowObject.childNodes.item(0).childNodes.item(0).checked = true;
                    listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
                    prevShow();
                }
            }
            document.getElementById("ContextMenuDiv").style.display = "none";
        }
    }
    else
        listEventCheckbox = false;
}
function event_listCheckboxclick(obj) {
    if (obj.checked) {
        obj.parentElement.parentElement.style.backgroundColor = m_strColorSelect;
        listContentArry[listContentArry.length] = obj.parentElement.parentElement.getAttribute("id");
    }
    else {
        var TemplistArray = new Array();
        for (var i = 0; i < listContentArry.length; i++) {
            if (obj.parentElement.parentElement.getAttribute("id") == listContentArry[i]) {
                obj.parentElement.parentElement.style.backgroundColor = m_strColorDefault;
            }
            else {
                TemplistArray[TemplistArray.length] = listContentArry[i];
            }
        }
        listContentArry = TemplistArray;
    }
    listEventCheckbox = true;
}
function event_Sublistclick(obj) {
    if (!listSubEventCheckbox) {
        if (document.getElementById("HeaderAllCheckBox").checked) {
            var TemplistArray = new Array();
            if (obj.childNodes.item(0).childNodes.item(0).checked) {
                for (var i = 0; i < listSubContentArry.length; i++) {
                    if (obj.getAttribute("id") == listSubContentArry[i]) {
                        obj.childNodes.item(0).childNodes.item(0).checked = false;
                        obj.style.backgroundColor = m_strColorDefault;
                    }
                    else {
                        TemplistArray[TemplistArray.length] = listSubContentArry[i];
                    }
                }
                listSubContentArry = TemplistArray;
            }
            else {
                obj.childNodes.item(0).childNodes.item(0).checked = true;
                obj.style.backgroundColor = m_strColorSelect;
                listSubContentArry[listSubContentArry.length] = obj.getAttribute("id");
            }
        }
        else {
            if (!PressShiftKey && !PressCtrlKey && listSubContentArry.length > 0) {
                for (var Cnt = 0 ; Cnt < listSubContentArry.length; Cnt++) {
                    _SubRowObject = document.getElementById(listSubContentArry[Cnt]);
                    _SubRowObject.style.backgroundColor = m_strColorDefault;
                    _SubRowObject.childNodes.item(0).childNodes.item(0).checked = false;
                }
                listSubContentArry = new Array();
            }
            if (PressShiftKey) {
                for (var Cnt = 0 ; Cnt < listSubContentArry.length; Cnt++) {
                    _SubRowObject = document.getElementById(listSubContentArry[Cnt]);
                    _SubRowObject.style.backgroundColor = m_strColorDefault;
                    _SubRowObject.childNodes.item(0).childNodes.item(0).checked = false;
                }
                listSubContentArry = new Array();
                var PrelistContent = _SubRowObject.getAttribute("id");
                _SubRowObject = obj;
                var CurlistContent = obj.getAttribute("id");
                var PrePoint = parseInt(PrelistContent.replace("Maillist_", ""));
                var CurPoint = parseInt(CurlistContent.replace("Maillist_", ""));
                if (PrePoint < CurPoint) {

                    for (var Cnt = PrePoint; Cnt <= CurPoint; Cnt++) {
                        _SubRowObject = document.getElementById("Maillist_" + Cnt);
                        _SubRowObject.style.backgroundColor = m_strColorSelect;
                        _SubRowObject.childNodes.item(0).childNodes.item(0).checked = true;
                        listSubContentArry[listSubContentArry.length] = _SubRowObject.getAttribute("id");
                    }

                }
                else if (PrePoint > CurPoint) {
                    for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
                        _SubRowObject = document.getElementById("Maillist_" + Cnt);
                        _SubRowObject.style.backgroundColor = m_strColorSelect;
                        _SubRowObject.childNodes.item(0).childNodes.item(0).checked = true;
                        listSubContentArry[listSubContentArry.length] = _SubRowObject.getAttribute("id");
                    }
                }
                else
                    return;
            }
            else {
                _SubRowObject = obj;
                if (_SubRowObject.childNodes.item(0).childNodes.item(0).checked) {
                    _SubRowObject.style.backgroundColor = m_strColorDefault;
                    _SubRowObject.childNodes.item(0).childNodes.item(0).checked = false;
                    listSubContentArry = ArrayDelete(listSubContentArry, _SubRowObject.id);
                }
                else {
                    _SubRowObject.style.backgroundColor = m_strColorSelect;
                    _SubRowObject.childNodes.item(0).childNodes.item(0).checked = true;
                    listSubContentArry[listSubContentArry.length] = _SubRowObject.getAttribute("id");
                    prevShow();
                }
            }
            document.getElementById("ContextMenuDiv").style.display = "none";
        }
    }
    else
        listSubEventCheckbox = false;
}
function event_SublistCheckboxclick(obj) {
    if (obj.checked) {
        obj.parentElement.parentElement.style.backgroundColor = m_strColorSelect;
        listSubContentArry[listSubContentArry.length] = obj.parentElement.parentElement.getAttribute("id");
    }
    else {
        var TemplistArray = new Array();
        for (var i = 0; i < listSubContentArry.length; i++) {
            if (obj.parentElement.parentElement.getAttribute("id") == listSubContentArry[i]) {
                obj.parentElement.parentElement.style.backgroundColor = m_strColorDefault;
            }
            else {
                TemplistArray[TemplistArray.length] = listSubContentArry[i];
            }
        }
        listSubContentArry = TemplistArray;
    }
    listSubEventCheckbox = true;
}
function event_listDBClick(obj) {
    callMsgDlg(obj.getAttribute("_contentclass"), obj.getAttribute("_href"), obj.getAttribute("_isdraft"));
    MailList_ChangeStatus(obj);
}
function event_SublistDBClick(obj) {
    _SublistDBClickEvent = true;
    callMsgDlg(obj.getAttribute("_contentclass"), obj.getAttribute("_href"));
    MailList_ChangeStatus(obj);
}
var pGroupListClickObject;
function event_GrouplistDBClick(obj) {
    if (_SublistDBClickEvent) {
        _SublistDBClickEvent = false;
        return;
    }
    if (pGroupListClickObject == obj) {
        pGroupListClickObject.childNodes.item(0).childNodes.item(0).src = GroupplusImg;
        pGroupListClickObject.style.backgroundColor = m_strColorDefault;
        var SubGroupListTarget = document.getElementById(pGroupListClickObject.getAttribute("id") + "sub")
        SubGroupListTarget.style.display = "none";
        SubGroupListTarget.childNodes.item(0).innerHTML = ""
        pGroupListClickObject = null;
        return;
    }
    var pGroupProp = obj.getAttribute("prop");
    var pGroupMode = obj.getAttribute("mode");
    p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile1.xml";
    if (pGroupMode == "SENT") {
        p_ListorderType_SUB = " WHERE \"http://schemas.microsoft.com/mapi/proptag/0x67aa000b\" = false AND \"DAV:isfolder\" = false " +
                          " AND \"http://schemas.microsoft.com/mapi/sent_representing_name\" = '" + pGroupProp + "' ";
        p_ListOrderby_SUB = "urn:schemas:httpmail:datereceived";
        p_ListOrderOption_SUB = "DESC";
    }
    else if (pGroupMode == "SUBJECT") {
        p_ListorderType_SUB = " WHERE \"http://schemas.microsoft.com/mapi/proptag/0x67aa000b\" = false AND \"DAV:isfolder\" = false " +
                          " AND \"http://schemas.microsoft.com/mapi/proptag/x0e1d001f\" = '" + pGroupProp + "' ";
        p_ListOrderby_SUB = "urn:schemas:httpmail:datereceived";
        p_ListOrderOption_SUB = "DESC";
    }
    if (pGroupListClickObject != null) {
        pGroupListClickObject.style.backgroundColor = m_strColorDefault;
        try{
        	var SubGroupListTarget = document.getElementById(pGroupListClickObject.getAttribute("id") + "sub")
            SubGroupListTarget.style.display = "none";
            SubGroupListTarget.childNodes.item(0).innerHTML = ""
        } catch (e) { }
    }
    pGroupListClickObject = obj;
    var NewDIV = document.createElement("DIV");
    NewDIV.innerHTML = document.getElementById("GroupSubObject").innerHTML;
    var SubGroupListTarget = document.getElementById(pGroupListClickObject.getAttribute("id") + "sub")
    SubGroupListTarget.style.display = "";
    SubGroupListTarget.childNodes.item(0).appendChild(NewDIV);
    pGroupListClickObject.style.backgroundColor = m_strColorSelect;
    pGroupListClickObject.childNodes.item(0).childNodes.item(0).src = GroupminImg;
    var HeaderObject = document.getElementById("GroupSubHeader");
    var ContentObject = document.getElementById("GroupSubList");
    listSubContentArry = new Array();
    HeaderIni_SUB(HeaderObject);
    GetListInfo_SUB(HeaderObject, ContentObject);
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
function GetContentClassImg(ContentClass, isRead) {
    var Rvalue = "";
    switch (ContentClass) {
        case "IPM.Note":
            {
                Rvalue = isRead == "1" ? "/images/ImgIcon/icon-msg-read.gif" : "/images/ImgIcon/icon-msg-unread.gif";
                break;
            }
        case "IPM.Note.StorageQuotaWarning":
            {
                Rvalue = isRead == "1" ? "/images/ImgIcon/icon-msg-read.gif" : "/images/ImgIcon/icon-msg-unread.gif";
                break;
            }
        case "IPM.Note.StorageQuotaWarning.Warning":
            {
                Rvalue = isRead == "1" ? "/images/ImgIcon/icon-msg-read.gif" : "/images/ImgIcon/icon-msg-unread.gif";
                break;
            }
        case "REPORT.IPM.Note.IPNRN":
            {
                Rvalue = "/images/ImgIcon/icon-report-ipnrn.gif";
                break;
            }
        case "REPORT.IPM.Note.IPNNRN":
            {
                Rvalue = "/images/ImgIcon/icon-report-ipnnrn.gif";
                break;
            }
        case "IPM.Note.Rules.OofTemplate.Microsoft":
            {
                Rvalue = "/images/ImgIcon/icon-oof.gif";
                break;
            }
        case "REPORT.IPM.Note.NDR":
            {
                Rvalue = "/images/ImgIcon/icon-report-ndr.gif";
                break;
            }
        case "REPORT.IPM.Note.Relayed.DR":
            {
                Rvalue = "/images/ImgIcon/icon-report-dr.gif";
                break
            }
        case "REPORT.IPM.Note.DR":
            {
                Rvalue = "/images/ImgIcon/icon-report-dr.gif";
                break
            }
        case "IPM.Note.Microsoft.Voicemail":
            {
                Rvalue = "/images/ImgIcon/icon-msg-voicemail.gif";
                break
            }
        case "IPM.Note.Microsoft.Voicemail.UM.CA":
            {
                Rvalue = "/images/ImgIcon/icon-msg-voicemail.gif";
                break
            }
        case "IPM.Note.Microsoft.Missed.Voice":
            {
                Rvalue = "/images/ImgIcon/icon-msg-missedvoice.gif";
                break
            }
        case "IPM.Schedule.Meeting.Request":
            {
                Rvalue = "/images/ImgIcon/icon-mtgreq.png";
                break
            }
        case "IPM.Schedule.Meeting.Canceled":
            {
                Rvalue = "/images/ImgIcon/icon-mtgreq-cancel.png";
                break
            }
        case "IPM.Schedule.Meeting.Resp.Pos":
            {
                Rvalue = "/images/ImgIcon/icon-mtgreq-accept.png";
                break
            }
        case "IPM.Schedule.Meeting.Resp.Neg":
            {
                Rvalue = "/images/ImgIcon/icon-mtgreq-decline.png";
                break
            }
        case "IPM.Schedule.Meeting.Resp.Tent":
            {
                Rvalue = "/images/ImgIcon/icon-mtgreq-tentative.png";
                break
            }
        case "REPORT.IPM.Schedule.Meeting.Request.NDR":
            {
                Rvalue = "/images/ImgIcon/icon-report-ndr.png";
                break
            }
        case "IPM.Contact":
            {
                Rvalue = "/images/ImgIcon/icon-mtgreq-tentative.gif";
                break
            }
        case "IPM.Appointment":
            {
                Rvalue = "/images/ImgIcon/icon-mtgreq-decline.gif";
                break
            }
        case "IPM.Sharing":
            {
                Rvalue = "/images/ExchWeb/img/icon-appt.gif";
                break
            }
        case "REPORT.IPM.Note.Delayed.DR":
            {
                Rvalue = "/images/ImgIcon/icon-report-ndr.gif";
                break
            }
        case "REPLY":
            {
                Rvalue = "/images/ImgIcon/icon-msg-read4.gif";
                break
            }
        case "FORWARD":
            {
                Rvalue = "/images/ImgIcon/icon-msg-read2.gif";
                break
            }
        case "IPM.Note.StorageQuotaWarning.SendReceive":
            {
                Rvalue = "/images/ImgIcon/icon-report-ndr.gif";
                break
            }
        default:
            {
                Rvalue = isRead == "1" ? "/images/ImgIcon/icon-msg-read.gif" : "/images/ImgIcon/icon-msg-unread.gif";
                break;
            }
    }
    return "<IMG style='cursor:pointer' draggable='false' src='" + Rvalue + "'/>";
}
