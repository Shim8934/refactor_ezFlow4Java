function MailOptionView(obj) {
    if (obj.getAttribute("mode") == "off") {
        document.getElementById("layer_Viewpopup").style.left = document.documentElement.clientWidth - 260 + "px";
        if(pAdminType == "y")
            document.getElementById("layer_Viewpopup").style.top = "50px";
        else
            document.getElementById("layer_Viewpopup").style.top = "100px";
        document.getElementById("layer_Viewpopup").style.display = "";
        obj.setAttribute("src", "/images/kr/cm/btn_arrow_up.gif");
        obj.setAttribute("mode", "on");
    }
    else {
        MailOptionHidden();
    }
}
function MailOptionHidden() {
    document.getElementById("layer_Viewpopup").style.display = "none";
    document.getElementById("maillistoptiondiv").setAttribute("mode", "off");
    document.getElementById("maillistoptiondiv").setAttribute("src", "/images/kr/cm/btn_arrow_down.gif");    
}

function PreviewRayerChange(pGubun) {
    pGubun = pGubun.trim();
    if (selobj != null && pGubun != "NONE" && selobj.childNodes.length != 0)
        ItemPreviewRead(selobj);

    if (pGubun == "OFF")
        pGubun = "NONE";
    if (clickPreviweType == "PHOTO") {
        if (document.documentElement.clientWidth < 1300) {
            PreviewRayerChange_photo("NONE");
        }
        else {
            PreviewRayerChange_photo(pGubun);
        }

        return;
    }
    try {
        if(document.getElementById("previewmail_bar_h") != null)
            document.getElementById("previewmail_bar_h").style.cursor = "w-resize";

        if ((pGubun == "H" || pGubun == "W") && selobj != null) {
            if (selobj.childNodes.length != 0)
                selobj.childNodes[2].style.fontWeight = "normal";
        }

        isPreviewChange = true;
        if (pGubun == "NONE") {
            pPreviewShow_HOW = "OFF";
            document.getElementById("PreviewRayerW").style.display = "none";
            document.getElementById("PreviewRayerH").style.display = "none";
            CurrentHeight = document.documentElement.clientHeight - 125;
            document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
            document.getElementById("MailListRayer").style.width = "100%";
            if (navigator.userAgent.indexOf('Firefox') != -1)
                document.getElementById("divList").style.height = (CurrentHeight - 45) + "px";
            else
                document.getElementById("divList").style.height = (CurrentHeight - 45) + "px";
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
            CurrentHeight = document.documentElement.clientHeight - 110;
            document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
            document.getElementById("ResizeBarW").style.width = (CurrenWidth - 10) + "px";
            pMailListHeightW = parseInt(CurrentHeight * (pMailListDiv / 100));
            pMailPreHeightW = parseInt(CurrentHeight * (pMailPreVDiv / 100));
            //alert(" CurrentHeight : " + CurrentHeight);
            //alert(" pMailPreVDiv : " + pMailPreVDiv);
            //alert(" pMailPreHeightW : " + pMailPreHeightW);
            document.getElementById("MailListRayer").style.width = "100%";
            document.getElementById("PreviewRayerW").style.width = "100%";
            document.getElementById("MailListRayer").style.height = pMailListHeightW + "px";
            if (navigator.userAgent.indexOf('Firefox') != -1)
                document.getElementById("divList").style.height = (pMailListHeightW - 45) + "px";
            else
                document.getElementById("divList").style.height = (pMailListHeightW - 45) + "px";
            document.getElementById("PreviewRayerW").style.height = (pMailPreHeightW + 45) + "px";

            if (window.parent.location.href.indexOf("BoardItemList_Favorite.aspx") > -1)
                document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 35) + "px";
            else
                document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 95) + "px";
            pPreviewShow_HOW = "W";
            pMailListDiv = Math.round((pMailListHeightW / CurrentHeight) * 100);
            pMailPreVDiv = Math.round((pMailPreHeightW / CurrentHeight) * 100);

            if (onclickFlag) {
                document.getElementById("Preview_HeaderW").style.display = "";
                document.getElementById("Preview_HeaderH").style.display = "none";
            }
            g_bPrevShow = true;
        }
        else if (pGubun == "H") {
            if (pMailListDiv_H == 0 || pMailPreVDiv_H == 0) {
                pMailListDiv_H = 50; pMailPreVDiv_H = 50;
            }
            if (onclickFlag) {
            }
            CurrenWidth = document.documentElement.clientWidth - 20;
            CurrentHeight = document.documentElement.clientHeight - 110;
            pMailListWidthH = parseInt(CurrenWidth * (pMailListDiv_H / 100));
            pMailPreWidthH = parseInt(CurrenWidth * (pMailPreVDiv_H / 100)) - 3;

            document.getElementById("MailListRayer").style.display = "inline-block";
            document.getElementById("PreviewRayerW").style.display = "none";
            document.getElementById("PreviewRayerH").style.display = "inline-block";

            if (CurrenWidth < (pMailListWidthH + pMailPreWidthH)) {
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
                document.getElementById("divList").style.height = (CurrentHeight - 45) + "px";
            else
                document.getElementById("divList").style.height = (CurrentHeight - 45) + "px";

            document.getElementById("divList").style.overflow = "auto";
            document.getElementById("PreviewRayerH").style.width = (pMailPreWidthH - 70) + "px";
            document.getElementById("PreContent_RayerH").style.width = (pMailPreWidthH - 10) + "px";
            document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 80) + "px";
            pPreviewShow_HOW = "H";
            pMailListDiv_H = Math.round((pMailListWidthH / CurrenWidth) * 100);
            pMailPreVDiv_H = Math.round((pMailPreWidthH / CurrenWidth) * 100);

            if (onclickFlag) {
                document.getElementById("Preview_HeaderW").style.display = "none";
                document.getElementById("Preview_HeaderH").style.display = "";
            }

            g_bPrevShow = true;
        }
        MailOptionHidden();
        PreviewMode_ChangeBtn();
        if (pAdminType != "y" && firstFlag)
            Set_BoardConfig();
        isPreviewChange = false;
    } catch (e) { }
}
var SetConfig = true;
function PreviewRayerChange_photo(pGubun) {
    try {
        pGubun = pGubun.trim();
        SetConfig = true;
        if (pGubun == "W") {
            SetConfig = false;
            pGubun = "H";
        }
        if (pGubun == "NONE")
            SetConfig = false;

        if (document.getElementById("previewmail_bar_h") != null)
            document.getElementById("previewmail_bar_h").style.cursor = "default";

        isPreviewChange = true;
        if (pGubun == "NONE") {
            pPreviewShow_HOW = "OFF";
            document.getElementById("PreviewRayerW").style.display = "none";
            document.getElementById("PreviewRayerH").style.display = "none";
            CurrentHeight = document.documentElement.clientHeight - 125;
            document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
            document.getElementById("MailListRayer").style.width = "100%";
            if (navigator.userAgent.indexOf('Firefox') != -1)
                document.getElementById("divList").style.height = (CurrentHeight - 45) + "px";
            else
                document.getElementById("divList").style.height = (CurrentHeight - 45) + "px";
            g_bPrevShow = false;
        }
        else if (pGubun == "H") {
            if (pMailListDiv_H == 0 || pMailPreVDiv_H == 0) {
                pMailListDiv_H = 50; pMailPreVDiv_H = 50;
            }

            CurrenWidth = document.documentElement.clientWidth - 20;
            CurrentHeight = document.documentElement.clientHeight - 110;
            pMailListWidthH = parseInt(CurrenWidth * (pMailListDiv_H / 100));
            pMailPreWidthH = parseInt(CurrenWidth * (pMailPreVDiv_H / 100)) - 3;

            document.getElementById("MailListRayer").style.display = "inline-block";
            document.getElementById("PreviewRayerW").style.display = "none";
            document.getElementById("PreviewRayerH").style.display = "inline-block";

            if (CurrenWidth < (pMailListWidthH + pMailPreWidthH)) {
                if (pMailListWidthH > parseInt(CurrenWidth * 0.40)) {
                    pMailListWidthH = pMailListWidthH - ((pMailListWidthH + pMailPreWidthH) - CurrenWidth);
                }
                else {
                    pMailPreWidthH = pMailPreWidthH - ((pMailListWidthH + pMailPreWidthH) - CurrenWidth);
                }
            }
            document.getElementById("PreviewRayerH").style.width = "752px";
            document.getElementById("MailListRayer").style.width = (CurrenWidth - 760) + "px";
            document.getElementById("PreContent_RayerH").style.width = "749px";

            document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
            document.getElementById("ResizeBarW").style.width = CurrenWidth + "px";
            document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
            document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
            if (navigator.userAgent.indexOf('Firefox') != -1)
                document.getElementById("divList").style.height = (CurrentHeight - 45) + "px";
            else
                document.getElementById("divList").style.height = (CurrentHeight - 45) + "px";

            document.getElementById("divList").style.overflow = "auto";
            document.getElementById("ifrmPreViewH_photo").style.height = (CurrentHeight - 60) + "px";
            pPreviewShow_HOW = "H";
            pMailListDiv_H = Math.round((pMailListWidthH / CurrenWidth) * 100);
            pMailPreVDiv_H = Math.round((pMailPreWidthH / CurrenWidth) * 100);

            if (onclickFlag) {
                document.getElementById("Preview_HeaderW").style.display = "none";
                document.getElementById("Preview_HeaderH").style.display = "";
            }

            g_bPrevShow = true;
        }
        isPreviewChange = false;
        MailOptionHidden();
        PreviewMode_ChangeBtn();
        if(SetConfig)
            Set_BoardConfig();

    } catch (e) { }
}

function PreviewMode_ChangeBtn() {
    try {
    document.getElementById("PreViewNone").setAttribute("src", "/images/kr/cm/btn_noframe.gif");
    if (document.getElementById("PreViewBottom") != null)
        document.getElementById("PreViewBottom").setAttribute("src", "/images/kr/cm/btn_bottomframe.gif");
    document.getElementById("PreViewleft").setAttribute("src", "/images/kr/cm/btn_leftframe.gif");
    if (pPreviewShow_HOW.trim() == "H")
        document.getElementById("PreViewleft").setAttribute("src", "/images/kr/cm/btn_onleftframe.gif");
    else if (pPreviewShow_HOW.trim() == "W") {
        if (document.getElementById("PreViewBottom") != null)
            document.getElementById("PreViewBottom").setAttribute("src", "/images/kr/cm/btn_onbottomframe.gif");
    }
    else
        document.getElementById("PreViewNone").setAttribute("src", "/images/kr/cm/btn_onnoframe.gif");
    } catch (e) { }
}

function ItemPreviewRead_click(obj) {
    selobj = document.getElementById(obj);
    onclickFlag = true;
    if (g_bPrevShow) {
        ItemPreviewRead(document.getElementById(obj));
    }
}
var xmlhttp = createXMLHttpRequest();
var xmlhttp2 = createXMLHttpRequest();
function ItemPreviewRead(obj) {
    
    obj.childNodes[2].style.fontWeight = "normal";

    var pboardid = obj.getAttribute("DATA1");
    var pitemid = obj.getAttribute("DATA2");

    if (document.getElementById('spn_title' + obj.id.split('_')[2]) != null) {
        document.getElementById('spn_title' + obj.id.split('_')[2]).style.fontWeight = "normal";
        document.getElementById('spn_content' + obj.id.split('_')[2]).style.fontWeight = "normal";
    }

    if (previewType == "PHOTO" || (obj.getAttribute("DATA10") == "3" || obj.getAttribute("DATA10") == "4")) {
        clickPreviweType = "PHOTO";
        if (document.getElementById("previewmail_bar_h") != null)
            document.getElementById("previewmail_bar_h").style.cursor = "default";

        xmlhttp = createXMLHttpRequest();
        if (location.href.toLowerCase().indexOf('temp') > -1)
            xmlhttp.open("POST", "interASP/GetPreviewItem.aspx?BoardID=" + pboardid + "&ItemID=" + pitemid + "&Mode=" + pMode + "&location=TEMP", true);
        else
            xmlhttp.open("POST", "interASP/GetPreviewItem.aspx?BoardID=" + pboardid + "&ItemID=" + pitemid + "&Mode=" + pMode + "&location=GENERAL", true);

        xmlhttp.onreadystatechange = event_ItemPreviewRead_photo;
        xmlhttp.send();
    }
    else {
        clickPreviweType = "TEXT";
        if (document.getElementById("previewmail_bar_h") != null)
            document.getElementById("previewmail_bar_h").style.cursor = "w-resize";

        xmlhttp = createXMLHttpRequest();
        if (location.href.toLowerCase().indexOf('temp') > -1)
            xmlhttp.open("POST", "interASP/GetPreviewItem.aspx?BoardID=" + pboardid + "&ItemID=" + pitemid + "&Mode=" + pMode + "&location=TEMP", true);
        else
            xmlhttp.open("POST", "interASP/GetPreviewItem.aspx?BoardID=" + pboardid + "&ItemID=" + pitemid + "&Mode=" + pMode + "&location=GENERAL", true);
        xmlhttp.onreadystatechange = event_ItemPreviewRead;
        xmlhttp.send();

        xmlhttp2 = createXMLHttpRequest();
        xmlhttp2.open("POST", "interASP/GetItemAttachments.aspx?ItemID=" + pitemid, true);
        xmlhttp2.onreadystatechange = event_ItemPreviewRead;
        xmlhttp2.send();
    }
}
function event_ItemPreviewRead_photo() {
    if (xmlhttp != null && xmlhttp.readyState == 4) {
        if (xmlhttp.status >= 200 && xmlhttp.status < 300) {
            if (document.getElementById("PreViewBottom") != null)
                document.getElementById("PreViewBottom").style.display = "none";
            if (SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA") == "NO") {
                alert("권한이 없습니다");
                return;
            }
            var WriterID = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/WriterID");
            var WriterName = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/WriterName");
            var WriterDeptName = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/WriterDeptName");
            var WriterCompanyName = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/WriterCompanyName");
            var WriteDate = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/WriteDate");
            var Title = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/Title");
            var ContentLocation = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/ContentLocation");


            if (pPreviewShow_HOW.trim() == "W") {
                PreviewRayerChange_photo("H");
                document.getElementById("Preview_HeaderW").style.display = "none";
                document.getElementById("Preview_HeaderH").style.display = "";
            }
            else if (pPreviewShow_HOW.trim() == "H") {
                PreviewRayerChange_photo("H");
                document.getElementById("Preview_HeaderW").style.display = "none";
                document.getElementById("Preview_HeaderH").style.display = "";
            }
            else {
                document.getElementById("Preview_HeaderW").style.display = "none";
                document.getElementById("Preview_HeaderH").style.display = "none";
            }
            var pOCS = "";
            var pSIPUri = getSIPUri(selobj.getAttribute("DATA3"));
            if (USE_OCS == "YES") {
                pOCS = "<img src='/images/presence/unknown.gif' id='" + GetGUID() + "' onload=\"PresenceControl('" + pSIPUri + "',this);\" style='vertical-align:middle;padding-right:5px;'/>";
            }
            pOCS += "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + WriterName + "' onclick='MemberInfo_onclick(\"" + selobj.getAttribute("DATA3") + "\")'>" + WriterName + "</span>";

            if (document.getElementById('ifrmPreViewH') != null) {
                document.getElementById('ifrmPreViewH_photo').style.display = "";
                document.getElementById('ifrmPreViewW_photo').style.display = "";
                document.getElementById('ifrmPreViewH').style.display = "none";
                document.getElementById('ifrmPreViewW').style.display = "none";
            }


            document.getElementById("PreH_sub_subject").textContent = Title;
            document.getElementById("PreH_MailReceiver").innerHTML = pOCS;
            document.getElementById("PreH_date").textContent = WriteDate;
            var fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(ContentLocation);
            if (location.href.toLowerCase().indexOf('temp') > -1)
                document.getElementById('ifrmPreViewH_photo').src = "BoardItemPreView_PhotoContent.aspx?ShowAdjacent=" + ShowAdjacent + "&ItemID=" + selobj.getAttribute("DATA2") + "&BoardID=" + selobj.getAttribute("DATA1") + "&Mode=" + pMode + "&location=TEMP";
            else
                document.getElementById('ifrmPreViewH_photo').src = "BoardItemPreView_PhotoContent.aspx?ShowAdjacent=" + ShowAdjacent + "&ItemID=" + selobj.getAttribute("DATA2") + "&BoardID=" + selobj.getAttribute("DATA1") + "&Mode=" + pMode + "&location=GENERAL";
            

        }
    }
}
var Title;
var pOCS;
var WriteDate;
var interValue;
function event_ItemPreviewRead() {
    if ((xmlhttp != null && xmlhttp.readyState == 4) && (xmlhttp2 != null && xmlhttp2.readyState == 4)) {
        if ((xmlhttp.status >= 200 && xmlhttp.status < 300) && (xmlhttp2.status >= 200 && xmlhttp2.status < 300)) {
            if (document.getElementById("PreViewBottom") != null)
                document.getElementById("PreViewBottom").style.display = "";

            if (SelectSingleNodeValueNew(xmlhttp.responseXML, "DATA") == "NO") {
                alert("권한이 없습니다");
                return;
            }

            var ItemID = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/ItemID");
            var WriterID = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/writerID");
            var WriterName = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/WriterName");
            var WriterDeptName = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/WriterDeptName");
            var WriterCompanyName = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/WriterCompanyName");
            WriteDate = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/WriteDate");
            Title = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/Title");
            var ContentLocation = SelectSingleNodeValueNew(xmlhttp.responseXML, "NODES/NODE/ContentLocation");

            if (pPreviewShow_HOW.trim() == "W") {
                document.getElementById("Preview_HeaderW").style.display = "";
                document.getElementById("Preview_HeaderH").style.display = "none";
                document.getElementById("ifrmPreViewW").src = "BoardItemPreView_Content.aspx";
            }
            else if (pPreviewShow_HOW.trim() == "H") {
                document.getElementById("Preview_HeaderW").style.display = "none";
                document.getElementById("Preview_HeaderH").style.display = "";
                document.getElementById("ifrmPreViewH").src = "BoardItemPreView_Content.aspx";
            }
            else {
                document.getElementById("Preview_HeaderW").style.display = "none";
                document.getElementById("Preview_HeaderH").style.display = "none";
            }
            pOCS = "";
            var pSIPUri = getSIPUri(selobj.getAttribute("DATA3"));
            if (USE_OCS == "YES") {
                pOCS = "<img src='/images/presence/unknown.gif' id='" + GetGUID() + "' onload=\"PresenceControl('" + pSIPUri + "',this);\" style='vertical-align:middle;padding-right:5px;'/>";
            }
            pOCS += "<span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666'  style='cursor:pointer' title='" + WriterName + "' onclick='MemberInfo_onclick(\"" + selobj.getAttribute("DATA3") + "\")'>" + WriterName + "</span>";


            if (document.getElementById('ifrmPreViewH_photo') != null) {
                document.getElementById('ifrmPreViewH_photo').style.display = "none";
                document.getElementById('ifrmPreViewW_photo').style.display = "none";
                document.getElementById('ifrmPreViewH').style.display = "";
                document.getElementById('ifrmPreViewW').style.display = "";
            }


            if (CrossYN() || pNoneActiveX == "YES") {
                var fullPath;
                if(pMode == "temp")
                    fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/ezCommon_InterFace.aspx&TYPE=BOARDCONTENTTEMP&DOCID=" + escape(ItemID);
                else
                    fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/ezCommon_InterFace.aspx&TYPE=BOARDCONTENT&DOCID=" + escape(ItemID);
                xmlhttp = createXMLHttpRequest();
                xmlhttp.open("POST", "/myoffice/CKEditor/MHTtoHTML_Content.aspx?href=" + fullPath, true);
                xmlhttp.onreadystatechange = event_downContent;
                xmlhttp.send();

                
            }
            else {
                
                document.getElementById("Pre" + pPreviewShow_HOW + "_sub_subject").innerText = Title;
                document.getElementById("Pre" + pPreviewShow_HOW + "_MailReceiver").innerHTML = pOCS;
                document.getElementById("Pre" + pPreviewShow_HOW + "_date").innerText = WriteDate;
                var readHTML = WriteContent(ContentLocation, ItemID);
                //interValue = setInterval(function () { loadsetInterval(readHTML, xmlhttp2.responseText) }, 100);
                var tempText = xmlhttp2.responseText;
                if (xmlhttp2.readyState == 4) {
                    setTimeout(function () {
                        if (pPreviewShow_HOW.trim() == "W") {
                            if (document.getElementById("ifrmPreViewW").contentWindow.makeWriteContent != undefined)
                                document.getElementById("ifrmPreViewW").contentWindow.makeWriteContent(readHTML, tempText);
                        }
                        else if (pPreviewShow_HOW.trim() == "H") {
                            if (document.getElementById("ifrmPreViewH").contentWindow.makeWriteContent != undefined)
                                document.getElementById("ifrmPreViewH").contentWindow.makeWriteContent(readHTML, tempText);
                        }
                    }, 100);
                }
            }
        }
    }
}
function loadsetInterval(readHTML, responseText) {
    try {

        if (pPreviewShow_HOW.trim() == "W") {
            if (document.getElementById("ifrmPreViewW").contentWindow.makeWriteContent != undefined) {
                if (document.getElementById("ifrmPreViewW").contentWindow.document.getElementById("txtContent") != null) {
                    document.getElementById("ifrmPreViewW").contentWindow.makeWriteContent(readHTML, responseText);
                    clearInterval(interValue);
                }
            }
        }
        else if (pPreviewShow_HOW.trim() == "H") {
            if (document.getElementById("ifrmPreViewH").contentWindow.makeWriteContent != undefined) {
                if (document.getElementById("ifrmPreViewH").contentWindow.document.getElementById("txtContent") != null) {
                    document.getElementById("ifrmPreViewH").contentWindow.makeWriteContent(readHTML, responseText);
                    clearInterval(interValue);
                }
            }
        }

    } catch (e) {

    }
}
function event_downContent() {
    if ((xmlhttp != null && xmlhttp.readyState == 4)) {
        if (xmlhttp.status >= 200 && xmlhttp.status < 300) {
            document.getElementById("Pre"+pPreviewShow_HOW.trim() +"_sub_subject").textContent = Title;
            document.getElementById("Pre" + pPreviewShow_HOW.trim() + "_MailReceiver").innerHTML = pOCS;
            document.getElementById("Pre" + pPreviewShow_HOW.trim() + "_date").textContent = WriteDate;
            document.getElementById("ifrmPreView" + pPreviewShow_HOW.trim()).contentWindow.makeWriteContent(xmlhttp.responseText, xmlhttp2.responseText);
        }
    }
}

function PreviewH_onMouserDown(e) {
    if (clickPreviweType == "PHOTO") {
        return;
    }

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
}
function PreviewW_onMouserDown(e) {
    if (clickPreviweType == "PHOTO") {
        return;
    }

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
}

function MailPreviewEnd(e) {
    if (clickPreviweType == "PHOTO")
        return;

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
            document.getElementById("divList").style.height = (CurrentHeight - 45) + "px";
            document.getElementById("PreviewRayerH").style.width = (pMailPreWidthH - 70) + "px";
            document.getElementById("PreContent_RayerH").style.width = (pMailPreWidthH - 10) + "px";
            document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 80) + "px";
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
            document.getElementById("divList").style.height = (pMailListHeightW - 45) + "px";
            document.getElementById("PreviewRayerW").style.height = (pMailPreHeightW + 45) + "px";

            if (window.parent.location.href.indexOf("BoardItemList_Favorite.aspx") > -1)
                document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 35) + "px";
            else
                document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 95) + "px";
            pMailListDiv = (pMailListHeightW / CurrentHeight) * 100;
            pMailPreVDiv = (pMailPreHeightW / CurrentHeight) * 100;
        }
        PreviewH_Move = false;
        PreviewW_Move = false;
    }
}
function MailPreviewResize(e) {
    if (clickPreviweType == "PHOTO")
        return;

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
        var maxSize = parseInt(document.documentElement.clientHeight - 100);

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
function MailReadOpen() {
    var pheight = window.screen.availHeight;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - 720) / 2;
    var pLeft = (pwidth - 765) / 2;
    

    if (previewType == "PHOTO" || (selobj.getAttribute("DATA10") == "3" || selobj.getAttribute("DATA10") == "4")) {
        pTop = (pheight - 780) / 2;
        window.open("BoardItemView_Photo.aspx?ShowAdjacent=" + ShowAdjacent + "&ItemID=" + selobj.getAttribute("DATA2") + "&BoardID=" + selobj.getAttribute("DATA1"), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=780,width=765,top=" + pTop + ",left=" + pLeft, "");
    }
    else {
        if (CrossYN() || pNoneActiveX == "YES")
            window.open("BoardItemView_Cross.aspx?ShowAdjacent=" + ShowAdjacent + "&ItemID=" + selobj.getAttribute("DATA2") + "&BoardID=" + selobj.getAttribute("DATA1"), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
        else
            window.open("BoardItemView.aspx?ShowAdjacent=" + ShowAdjacent + "&ItemID=" + selobj.getAttribute("DATA2") + "&BoardID=" + selobj.getAttribute("DATA1"), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
    }
}
function WriteContent(strContentLocation, ItemID) {
    objMHT = new ActiveXObject("MhtFormat.Convert");
    var ContentHTML = MhtConvert(strContentLocation, ItemID);
    ContentHTML = ReplaceText(ContentHTML, "onmouseover", "");
    ContentHTML = ReplaceText(ContentHTML, "onfocus", "");
    ContentHTML = ReplaceText(ContentHTML, "contentEditable=true", "");
    ContentHTML = ReplaceText(ContentHTML, "contentEditable=\"true\"", "");
    return ContentHTML;
}
function MhtConvert(strContentLocation, ItemID) {
    var fullPath;
    if (pMode == "temp")
        fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/ezCommon_InterFace.aspx?TYPE=BOARDCONTENTTEMP&DOCID=" + escape(ItemID);
    else
        fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/ezCommon_InterFace.aspx?TYPE=BOARDCONTENT&DOCID=" + escape(ItemID);
    //var fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(strContentLocation);
    objMHT.sync = true;
    var strMht = objMHT.DownloadURL(fullPath);
    objMHT.mhtData = strMht;
    objMHT.filterIn();
    var ret = objMHT.htmlData;
    if (window.location.protocol.toLowerCase() == "https:") {
        var idx = 0; var start = 0;
        while (ret.indexOf("src=\"", start) > 0) {
            start = ret.indexOf("src=\"", start);
            var end = ret.indexOf("\"", start + 5);
            var link = ImageUrl(strContentLocation, idx);
            ret = ret.substring(0, start + 5) + link + ret.substring(end);

            idx = idx + 1;
            start = end;
        }
    }
    return ret;
}
function ReplaceText(orgStr, findStr, replaceStr) {
    var re = new RegExp(findStr, "gi");
    return (orgStr.replace(re, replaceStr));
}
function Window_resize() {
    if (clickPreviweType == "PHOTO") {
        Window_resize_photo();
        return;
    }

    try {
        if (!isPreviewChange) {

            if (parseInt(document.documentElement.clientWidth) < 1000) {
                document.getElementById("PreViewleft").style.display = "none";
                if (pPreviewShow_HOW.trim() == "H")
                    pPreviewShow_HOW = "W";
                PreviewMode_ChangeBtn();
            }
            else {
                document.getElementById("PreViewleft").style.display = "";
            }

            if (pPreviewShow_HOW.trim() == "W") {
                if (pMailListDiv == 0 || pMailPreVDiv == 0) {
                    pMailListDiv = 50; pMailPreVDiv = 50;
                }
                document.getElementById("MailListRayer").style.display = "inline-block";
                document.getElementById("PreviewRayerW").style.display = "block";
                document.getElementById("PreviewRayerH").style.display = "none";

                CurrenWidth = document.documentElement.clientWidth - 10;
                CurrentHeight = document.documentElement.clientHeight - 110;
                document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
                document.getElementById("ResizeBarW").style.width = (CurrenWidth - 10) + "px";
                pMailListHeightW = parseInt(CurrentHeight * (pMailListDiv / 100));
                pMailPreHeightW = parseInt(CurrentHeight * (pMailPreVDiv / 100));
                document.getElementById("MailListRayer").style.width = "100%";
                document.getElementById("PreviewRayerW").style.width = "100%";
                document.getElementById("MailListRayer").style.height = pMailListHeightW + "px";
                if (navigator.userAgent.indexOf('Firefox') != -1)
                    document.getElementById("divList").style.height = (pMailListHeightW - 45) + "px";
                else
                    document.getElementById("divList").style.height = (pMailListHeightW - 45) + "px";
                document.getElementById("PreviewRayerW").style.height = (pMailPreHeightW + 45) + "px";

                if (window.parent.location.href.indexOf("BoardItemList_Favorite.aspx") > -1)
                    document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 35) + "px";
                else
                    document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 95) + "px";
                pPreviewShow_HOW = "W";
                pMailListDiv = Math.round((pMailListHeightW / CurrentHeight) * 100);
                pMailPreVDiv = Math.round((pMailPreHeightW / CurrentHeight) * 100);
            }
            else if (pPreviewShow_HOW.trim() == "H") {
                if (pMailListDiv_H == 0 || pMailPreVDiv_H == 0) {
                    pMailListDiv_H = 50; pMailPreVDiv_H = 50;
                }
                document.getElementById("MailListRayer").style.display = "inline-block";
                document.getElementById("PreviewRayerW").style.display = "none";
                document.getElementById("PreviewRayerH").style.display = "inline-block";

                CurrenWidth = document.documentElement.clientWidth - 20;
                CurrentHeight = document.documentElement.clientHeight - 110;
                pMailListWidthH = parseInt(CurrenWidth * (pMailListDiv_H / 100));
                pMailPreWidthH = parseInt(CurrenWidth * (pMailPreVDiv_H / 100)) - 3;

                if (pMailListWidthH <= parseInt(CurrenWidth * 0.40)) {
                    var ChangeListWidthDiv = parseInt(CurrenWidth * 0.40) - pMailListWidthH;
                    pMailListWidthH = parseInt(CurrenWidth * 0.40);
                    pMailPreWidthH = pMailPreWidthH - ChangeListWidthDiv;
                }
                document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
                document.getElementById("ResizeBarW").style.width = CurrenWidth + "px";
                document.getElementById("MailListRayer").style.height = CurrentHeight + 200 + "px";
                document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
                document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
                if (navigator.userAgent.indexOf('Firefox') != -1)
                    document.getElementById("divList").style.height = (CurrentHeight - 33) + "px";
                else
                    document.getElementById("divList").style.height = (CurrentHeight - 33) + "px";

                document.getElementById("divList").style.overflow = "auto";
                document.getElementById("PreviewRayerH").style.width = (pMailPreWidthH - 70) + "px";
                document.getElementById("PreContent_RayerH").style.width = (pMailPreWidthH - 10) + "px";
                document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 80) + "px";
                pPreviewShow_HOW = "H";
                pMailListDiv_H = Math.round((pMailListWidthH / CurrenWidth) * 100);
                pMailPreVDiv_H = Math.round((pMailPreWidthH / CurrenWidth) * 100);
            }
            else if (pPreviewShow_HOW.trim() == "OFF") {
                document.getElementById("PreviewRayerW").style.display = "none";
                document.getElementById("PreviewRayerH").style.display = "none";
                CurrentHeight = document.documentElement.clientHeight - 110;
                document.getElementById("MailListRayer").style.height = CurrentHeight + 200 + "px";
                document.getElementById("MailListRayer").style.width = "100%";
                if (navigator.userAgent.indexOf('Firefox') != -1)
                    document.getElementById("divList").style.height = (CurrentHeight - 33) + "px";
                else
                    document.getElementById("divList").style.height = (CurrentHeight - 33) + "px";
                document.getElementById("divList").style.overflow = "auto";
                if (navigator.userAgent.indexOf('Firefox') != -1)
                    document.getElementById("contentlist").style.height = (CurrentHeight - 70) + "px";
                else
                    document.getElementById("contentlist").style.height = (CurrentHeight - 70) + "px";
            }
        }
    } catch (e) { }
}
function Window_resize_photo() {
    try {
        if (!isPreviewChange) {
            if (parseInt(document.documentElement.clientWidth) < 1000) {
                document.getElementById("PreViewleft").style.display = "none";
                if (pPreviewShow_HOW.trim() == "H")
                    pPreviewShow_HOW = "W";
                PreviewMode_ChangeBtn();
            }
            else {
                document.getElementById("PreViewleft").style.display = "";
            }
            if (document.documentElement.clientWidth < 1300) {
                PreviewRayerChange("NONE");
                document.getElementById("right").style.display = "none";
            }
            else {
                document.getElementById("right").style.display = "";
            }


            if (pPreviewShow_HOW.trim() == "H") {
                if (document.documentElement.clientWidth < 1300) {
                    PreviewRayerChange("NONE");
                    document.getElementById("right").style.display = "none";
                }
                else {
                    document.getElementById("right").style.display = "";
                    PreviewRayerChange("H");
                }
            }
        }
    } catch (e) { }
}

function ListCount(pCount) {
    perCnt = pCount;
    selobj = null;
    MailOptionHidden();
    Set_BoardConfig();
    getBoardList();
    
}

function Set_BoardConfig()
{
    var xmlpara = createXmlDom();
    var xmlhttp = createXMLHttpRequest();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pUserID", SSUserID);
    createNodeAndInsertText(xmlpara, objNode, "pListCount", perCnt);
    createNodeAndInsertText(xmlpara, objNode, "pPreView", pPreviewShow_HOW);
    xmlhttp.open("POST", "aspx/Set_BoardConfig.aspx", true);
    xmlhttp.send(xmlpara);
}