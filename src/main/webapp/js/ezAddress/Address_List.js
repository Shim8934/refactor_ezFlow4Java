var xmlHTTPAddressList = null;
var ListXML = null;
function View_Change() {
	alert('1');
    listContentArry = new Array();
    if (document.getElementById("ListViewType").value == "list") {
        document.getElementById("MailList").style.display = "";
        document.getElementById("MailListCard").style.display = "none";
        document.getElementById("DetailList_header").style.display = "";
    }
    else {
        document.getElementById("DetailList_header").style.display = "none";
        document.getElementById("MailList").style.display = "none";
        document.getElementById("MailListCard").style.display = "";
    }
    if (ListXML != null)
        MakeAddressList();
    else {
        if (searchFlag)
            Get_SearchAddressList();
        else
            Get_AddressList();
    }
}
function Get_AddressList() {
    searchFlag = false;
    document.getElementById("CompanyName").style.width = "20%";
    document.getElementById("PhoneNumber").style.width = "20%";

    ListXML = null;
    listContentArry = new Array();
    if (document.getElementById("ListViewType").value == "list") {
        document.getElementById("MailList").style.display = "";
        document.getElementById("MailListCard").style.display = "none";
        document.getElementById("DetailList_header").style.display = "";
    }
    else {
        document.getElementById("DetailList_header").style.display = "none";
        document.getElementById("MailList").style.display = "none";
        document.getElementById("MailListCard").style.display = "";
    }

    xmlHTTPAddressList = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "FOLDERID", pFolderID);
    createNodeAndInsertText(xmlpara, objNode, "FOLDERTYPE", pFolderType);
    createNodeAndInsertText(xmlpara, objNode, "PAGE", pCurrentPage);
    createNodeAndInsertText(xmlpara, objNode, "OWNERID", pOwerID);
    createNodeAndInsertText(xmlpara, objNode, "ORDERBY", pOrderOption);
    
    /*if (pFolderType == "P") {
        createNodeAndInsertText(xmlpara, objNode, "FILTER", pFilter);
        xmlHTTPAddressList.open("POST", "/myoffice/ezAddress/RemoteEWS/address_list.aspx", true);
    }
    else {
        createNodeAndInsertText(xmlpara, objNode, "FILTER", pFilterDB);
        xmlHTTPAddressList.open("POST", "/myoffice/ezAddress/Remote/address_list.aspx", true);
    }*/
    createNodeAndInsertText(xmlpara, objNode, "FILTER", pFilterDB);
    xmlHTTPAddressList.open("POST", "/ezAddress/addressList.do", true);
    
    xmlHTTPAddressList.onreadystatechange = Complete_Get_AddressList;
    xmlHTTPAddressList.send(xmlpara);
    ShowMailProgress();
}
function Get_SearchAddressList() {
    try { HiddenMailProgress(); } catch (e) {}
    ListXML = null;
    listContentArry = new Array();
    if (document.getElementById("ListViewType").value == "list") {
        document.getElementById("MailList").style.display = "";
        document.getElementById("MailListCard").style.display = "none";
        document.getElementById("DetailList_header").style.display = "";
    }
    else {
        document.getElementById("DetailList_header").style.display = "none";
        document.getElementById("MailList").style.display = "none";
        document.getElementById("MailListCard").style.display = "";
    }

    xmlHTTPAddressList = createXMLHttpRequest();
    var xmlDom = createXmlDom();

    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "IDLIST", idlist);
    createNodeAndInsertText(xmlDom, objNode, "ORDERBY", pOrderOption);
    createNodeAndInsertText(xmlDom, objNode, "FILTER", filter);
    createNodeAndInsertText(xmlDom, objNode, "PAGE", pCurrentPage);
    xmlHTTPAddressList.open("POST", "/ezAddress/addressGetSearchList.do", true);
    xmlHTTPAddressList.onreadystatechange = Complete_Get_AddressList;
    xmlHTTPAddressList.send(xmlDom);
    try { ShowMailProgress(); } catch (e) {}
}
function MakeAddressList() {
    var XmlRows = SelectNodes(ListXML, "DATA/ROW");

    pTotalCnt = getNodeText(SelectNodes(ListXML, "DATA/TOTALCNT")[0]);
    pPageSize = getNodeText(SelectNodes(ListXML, "DATA/PAGESIZE")[0]);
    pCurrentPage = getNodeText(SelectNodes(ListXML, "DATA/CURPAGE")[0]);
    pFolderName = getNodeText(SelectNodes(ListXML, "DATA/DISPLAYNAME")[0]);
    while (document.getElementById("MailList").childNodes.length > 0) {
        document.getElementById("MailList").removeChild(document.getElementById("MailList").childNodes.item(0));
    }
    while (document.getElementById("MailListCard").childNodes.length > 0) {
        document.getElementById("MailListCard").removeChild(document.getElementById("MailListCard").childNodes.item(0));
    }
    document.getElementById("contentlist").scrollTop = "0";
    


    for (var Cnt = 0; Cnt < XmlRows.length; Cnt++) {
        var SType = SelectSingleNodeValue(XmlRows[Cnt], "STYPE");
        var AddressID = SelectSingleNodeValue(XmlRows[Cnt], "ADDRESSID");
        var Changekey = SelectSingleNodeValue(XmlRows[Cnt], "CHANGEKEY");
        var HasAttach = SelectSingleNodeValue(XmlRows[Cnt], "HASATTACH");
        var Sname = SelectSingleNodeValue(XmlRows[Cnt], "SNAME");
        var Scompany = SelectSingleNodeValue(XmlRows[Cnt], "SCOMPANY");
        var ScompnayPhone = SelectSingleNodeValue(XmlRows[Cnt], "SCOMPANYPHONE");
        var Smobile = SelectSingleNodeValue(XmlRows[Cnt], "SMOBILE");
        var Semail = SelectSingleNodeValue(XmlRows[Cnt], "SEMAIL");
        var ModifierID = SelectSingleNodeValue(XmlRows[Cnt], "MODIFIERID");
        var CreatorID = SelectSingleNodeValue(XmlRows[Cnt], "CREATORID");
        var FolderType;
        var FolderID;
        if (searchFlag) {
            FolderType = SelectSingleNodeValue(XmlRows[Cnt], "FOLDERTYPE");
            FolderID = SelectSingleNodeValue(XmlRows[Cnt], "FOLDERID");
        }

        if (document.getElementById("ListViewType").value == "list") {
            var _TR = document.createElement("TR");
            _TR.style.verticalAlign = "middle";
            _TR.style.height = "25px";
            _TR.setAttribute("id", "Maillist_" + Cnt);
            _TR.style.cursor = "pointer";
            _TR.setAttribute("_SType", SType);
            _TR.setAttribute("_AddressID", AddressID);
            _TR.setAttribute("_Changekey", Changekey);
            _TR.setAttribute("_ModifierID", ModifierID);
            _TR.setAttribute("_CreatorID", CreatorID);
            _TR.setAttribute("_Sname", Sname);
            _TR.setAttribute("_Semail", Semail);
            if (searchFlag) {
                document.getElementById("FolderType").style.display = "";
                _TR.setAttribute("_FolderType", FolderType);
                _TR.setAttribute("_FolderID", FolderID);
            }
            else
                document.getElementById("FolderType").style.display = "none";

            _TR.onmouseover = function () { event_listMover(this); };
            _TR.onmouseout = function () { event_listMout(this); };
            _TR.onclick = function () { event_listclick(this); };
            if (searchFlag)
                _TR.ondblclick = function () { event_SearchlistDBClick(this); };
            else
                _TR.ondblclick = function () { event_listDBClick(this); };

            var _TD1 = document.createElement("TD");
            _TD1.style.width = "20px";
            //_TD1.style.margin = "0px";
            //_TD1.style.padding = "0px";
            var _TDCheckBox_Sub = document.createElement("INPUT");
            _TDCheckBox_Sub.type = "checkbox";
            _TDCheckBox_Sub.style.margin = "0px";
            _TDCheckBox_Sub.style.padding = "4px 0px 0px 0px";
            _TDCheckBox_Sub.style.height = "13px";
            _TDCheckBox_Sub.style.width = "13px";
            _TDCheckBox_Sub.onclick = function () { event_listCheckboxclick(this); };

            _TDCheckBox_Sub.setAttribute("_SType", SType);
            _TDCheckBox_Sub.setAttribute("_AddressID", AddressID);
            _TDCheckBox_Sub.setAttribute("_Changekey", Changekey);
            _TDCheckBox_Sub.setAttribute("_ModifierID", ModifierID);
            _TDCheckBox_Sub.setAttribute("_CreatorID", CreatorID);
            _TD1.appendChild(_TDCheckBox_Sub);
            _TR.appendChild(_TD1);

            var _TD2 = document.createElement("TD");
            _TD2.style.width = "20px";
            _TD2.style.margin = "0px";
            _TD2.style.padding = "0px";
            var _Img = document.createElement("IMG");
            if (SType == "P")
                _Img.src = "/images/i_individual.gif";
            else
                _Img.src = "/images/i_group.gif";
            _TD2.appendChild(_Img);
            _TR.appendChild(_TD2);

            var _TD3 = document.createElement("TD");
            _TD3.style.width = "20%";
            _TD3.style.margin = "0px";
            _TD3.style.padding = "0px";
            _TD3.style.whiteSpace = "nowrap";
            _TD3.style.textOverflow = "ellipsis";
            _TD3.style.overflow = "hidden";
            if (CrossYN())
                _TD3.textContent = " "+Sname;
            else
                _TD3.innerText = " " + Sname;
            _TR.appendChild(_TD3);

            var _TD4 = document.createElement("TD");
            //if (searchFlag) {
            //    document.getElementById("CompanyName").style.width = "15%";
            //    document.getElementById("PhoneNumber").style.width = "15%";
            //}            
            _TD4.style.width = "20%";
            _TD4.style.margin = "0px";
            _TD4.style.padding = "0px";
            if (CrossYN())
                _TD4.textContent = Scompany;
            else
                _TD4.innerText = Scompany;
            _TR.appendChild(_TD4);

            var _TD5 = document.createElement("TD");
            if (searchFlag) {
                _TD5.style.width = "15%";
            }
            else
                _TD5.style.width = "20%";
            _TD5.style.margin = "0px";
            _TD5.style.padding = "0px";
            if (CrossYN())
                _TD5.textContent = ScompnayPhone;
            else
                _TD5.innerText = ScompnayPhone;
            _TR.appendChild(_TD5);

            var _TD6 = document.createElement("TD");
            _TD6.style.width = "20%";
            _TD6.style.margin = "0px";
            _TD6.style.padding = "0px";
            if (CrossYN())
                _TD6.textContent = Smobile;
            else
                _TD6.innerText = Smobile;
            _TR.appendChild(_TD6);

            var _TD7 = document.createElement("TD");
            _TD7.style.width = "20%";
            _TD7.style.margin = "0px";
            _TD7.style.padding = "0px";
            if (CrossYN())
                _TD7.textContent = Semail;
            else
                _TD7.innerText = Semail;
            _TR.appendChild(_TD7);

            if (searchFlag) {
                var _TD8 = document.createElement("TD");
                _TD8.style.width = "10%";
                _TD8.style.margin = "0px";
                _TD8.style.padding = "0px";

                switch (FolderType) {
                    case "P":
                        if (CrossYN())
                            _TD8.textContent = AddressType;
                        else
                            _TD8.innerText = AddressType;
                        break;
                    case "D":
                        if (CrossYN())
                            _TD8.textContent = AddressType2;
                        else
                            _TD8.innerText = AddressType2;
                        break;
                    case "C":
                        if (CrossYN())
                            _TD8.textContent = AddressType3;
                        else
                            _TD8.innerText = AddressType3;
                        break;
                }

                _TR.appendChild(_TD8);
            }

            document.getElementById("MailList").appendChild(_TR);
        }
        else if (document.getElementById("ListViewType").value == "card") {
            var DivLayer = document.createElement("DIV");
            DivLayer.setAttribute("id", "Cardlist_" + Cnt);
            DivLayer.className = "address_boxlist";
            DivLayer.style.cursor = "pointer";
            DivLayer.style.display = "inline-block";
            DivLayer.style.marginRight = "5px";
            DivLayer.style.marginBottom = "10px";
            DivLayer.setAttribute("_SType", SType);
            DivLayer.setAttribute("_AddressID", AddressID);
            DivLayer.setAttribute("_Changekey", Changekey);
            DivLayer.setAttribute("_ModifierID", ModifierID);
            DivLayer.setAttribute("_CreatorID", CreatorID);
            DivLayer.setAttribute("_Sname", Sname);
            DivLayer.setAttribute("_Semail", Semail);
            if (searchFlag) {
                DivLayer.setAttribute("_FolderType", FolderType);
                DivLayer.setAttribute("_FolderID", FolderID);
            }

            DivLayer.onclick = function () { event_Cardlistclick(this); };
            if (searchFlag)
                DivLayer.ondblclick = function () { event_SearchlistDBClick(this); };
            else
                DivLayer.ondblclick = function () { event_listDBClick(this); };

            DivLayer.onselectstart = function () { return false; };

            var SubDivLayer = document.createElement("DIV");
            SubDivLayer.className = "back";

            var SubPTag = document.createElement("P");
            SubPTag.className = "topinfo";
            if (SType == "P")
                SubPTag.innerHTML = "<img src=\"/images/i_individual.gif\" style=\"vertical-align:middle;margin-top:-4px;\" /> " + Sname;
            else
                SubPTag.innerHTML = "<img src=\"/images/i_group.gif\" style=\"vertical-align:middle;margin-top:-4px;\" /> " + Sname;


            var ULTag = document.createElement("ul");

            var UITag1 = document.createElement("li");
            UITag1.className = "name";
            if (CrossYN())
                UITag1.textContent = Sname;
            else
                UITag1.innerText = Sname;
            var UITag2 = document.createElement("li");
            UITag2.className = "company";
            if (CrossYN())
                UITag2.textContent = Scompany;
            else
                UITag2.innerText = Scompany;
            var UITag3 = document.createElement("li");
            UITag3.innerHTML = CardHeader1 + ":<span class=\"point_txt\">" + ScompnayPhone + "</span>";
            var UITag4 = document.createElement("li");
            UITag4.innerHTML = CardHeader2 + ":<span class=\"point_txt\">" + Smobile + "</span>";
            var UITag5 = document.createElement("li");
            UITag5.innerHTML = CardHeader3 + ":<span class=\"point_txt\">" + Semail + "</span>";

            var EndDiv = document.createElement("DIV");
            EndDiv.className = "shadow";

            DivLayer.appendChild(SubDivLayer);
            DivLayer.appendChild(EndDiv);
            SubDivLayer.appendChild(SubPTag);
            SubDivLayer.appendChild(ULTag);
            ULTag.appendChild(UITag1);
            ULTag.appendChild(UITag2);
            ULTag.appendChild(UITag3);
            ULTag.appendChild(UITag4);
            ULTag.appendChild(UITag5);
            document.getElementById("MailListCard").appendChild(DivLayer);
        }
    }
    if (XmlRows.length == 0) {
        MakeNoDateList();
    }
    makePageSelPage();
    HiddenMailProgress();
    Window_onresize();
}
function Complete_Get_AddressList() {
    if (xmlHTTPAddressList == null || xmlHTTPAddressList.readyState != 4)
        return;
    if (xmlHTTPAddressList.status >= 200 && xmlHTTPAddressList.status < 300) {
        ListXML = xmlHTTPAddressList.responseXML;
        var XmlRows = SelectNodes(ListXML, "DATA/ROW");
        if (XmlRows.length == 0) {
            if (searchFlag) {
                pCurrentPage--;
                if (pCurrentPage < 0) {
                    document.getElementById("mailBoxInfo").style.display = "none";
                    while (document.getElementById("MailList").childNodes.length > 0) {
                        document.getElementById("MailList").removeChild(document.getElementById("MailList").childNodes.item(0));
                    }
                    while (document.getElementById("MailListCard").childNodes.length > 0) {
                        document.getElementById("MailListCard").removeChild(document.getElementById("MailListCard").childNodes.item(0));
                    }
                    MakeNoDateList();
                    HiddenMailProgress();
                    return;
                }
                Get_SearchAddressList();
                return;
            }
        }
        document.getElementById("mailBoxInfo").style.display = "";
        MakeAddressList();
    }
}
function MakeNoDateList() {
    if (document.getElementById("ListViewType").value == "list") {
        document.getElementById("MailList").style.width = "100%";
        var _TR = document.createElement("TR");
        _TR.style.verticalAlign = "middle";
        _TR.style.height = "25px";

        var _TD = document.createElement("TD");
        _TD.style.textAlign = "center";
        _TD.innerHTML = strLang100;
        _TR.appendChild(_TD);
        document.getElementById("MailList").appendChild(_TR);
    }
    else {
        var DivLayer = document.createElement("DIV");
        DivLayer.style.textAlign = "center";
        DivLayer.style.paddingTop = "40px";
        DivLayer.innerHTML = strLang100;
        document.getElementById("MailListCard").appendChild(DivLayer);
    }
}
function OderbyOptionExpression(obj) {
    var OderOpArray = pOrderOption.split(":");
    var Old_OderName = OderOpArray[0];
    var Old_oderOption = OderOpArray[1];
    var OderName = obj.getAttribute("_OrderName");
    var oderOption = obj.getAttribute("_OrderOption");
    pOrderOption = OderName + ":" + oderOption;
    document.getElementById(Old_OderName).innerHTML = "";
    document.getElementById(OderName).innerHTML = oderOption == "0" ? "<img border=\"0\" src=\"/images/view-sortup.gif\">" : "<img border=\"0\" src=\"/images/view-sortdown.gif\">";
    obj.setAttribute("_OrderOption", oderOption == "0" ? "1" : "0");
    pCurrentPage = "1";
    if (searchFlag)
        Get_SearchAddressList();
    else
        Get_AddressList();
}
function goToPageByNum(szNum) {
    pCurrentPage = szNum;
    if(searchFlag)
        Get_SearchAddressList();
    else
        Get_AddressList();
}
function selbeforeBlock() {
    var pageNum = pCurrentPage;
    pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
    goToPageByNum(pageNum);
}
function selafterBlock() {
    var pageNum = pCurrentPage;
    pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
    goToPageByNum(pageNum);
}
function selafterBlock_one() {
    var pageNum = pCurrentPage;
    var totalPage = Math.ceil(pTotalCnt / pPageSize);
    if (parseInt(parseInt(pageNum) + 1) <= totalPage)
        goToPageByNum(parseInt(parseInt(parseInt(pageNum) + 1)));
    else
        return;
}
function selbeforeBlock_one() {
    var pageNum = pCurrentPage;
    var totalPage = Math.ceil(pTotalCnt / pPageSize);
    if (parseInt(parseInt(pageNum) - 1) > 0)
        goToPageByNum(parseInt(parseInt(parseInt(pageNum) - 1)));
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
    totalPage = Math.ceil(pTotalCnt / pPageSize);
    var pageNum = pCurrentPage;
    if (!searchFlag || strLang_1 == "")
        document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang41 + " <span style='color:#017BEC;'>" + pTotalCnt + "</span> " + strLang42 + "]";
    else {
        document.getElementById("mailBoxInfo").className = "h2_dot"; 
        document.getElementById("mailBoxInfo").innerHTML = strLang_1 + "<span class='point'>" + pTotalCnt + "</span> " + strLang_2;
    }
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
function Window_onresize() {
    if (searchFlag) {
        if (document.getElementById("ListViewType").value == "list") {
            document.getElementById("list_Layer").style.height = (document.documentElement.clientHeight - 200) + "px";
            document.getElementById("contentlist").style.height = (document.documentElement.clientHeight - 250) + "px";
        }
        else {
            document.getElementById("list_Layer").style.height = (document.documentElement.clientHeight - 168) + "px";
            document.getElementById("contentlist").style.height = (document.documentElement.clientHeight - 218) + "px";
        }
    }
    else {
        if (document.getElementById("ListViewType").value == "list") {
            document.getElementById("list_Layer").style.height = (document.documentElement.clientHeight - 160) + "px";
            document.getElementById("contentlist").style.height = (document.documentElement.clientHeight - 210) + "px";
        }
        else {
            document.getElementById("list_Layer").style.height = (document.documentElement.clientHeight - 128) + "px";
            document.getElementById("contentlist").style.height = (document.documentElement.clientHeight - 178) + "px";
        }
    }
}
function ShowQuickAddres() {
    document.getElementById("qname").value = "";
    document.getElementById("qcompany").value = "";
    document.getElementById("qcomphone").value = "";
    document.getElementById("qmobile").value = "";
    document.getElementById("qemail").value = "";
    HiddenLayer_Click();
    QuickAddress_Layer();

    document.getElementById("SearchOption").setAttribute("mode", "off");
    document.getElementById("srarchpopup").style.display = "none";
    document.getElementById("addpopup").style.display = "";
}
function QuickAddress_Layer() {
    if (document.getElementById("layer_popup").style.display == "") {
        document.getElementById("layer_popup").style.display = "none";
    }
    else {
        document.getElementById("layer_popup").style.display = "";
    }
}
function HiddenLayer_Click() {
    if (document.getElementById("mailPanel").style.display == "") {
        document.getElementById("mailPanel").style.display = "none";
    }
    else {
        document.getElementById("mailPanel").style.display = "";
    }
}
function ShowMailProgress() {
    document.getElementById("mailPanel").style.display = "";
    document.getElementById("MailProgress").style.top = "400px";
    document.getElementById("MailProgress").style.left = (document.documentElement.clientWidth / 2) - 100 + "px";
    document.getElementById("MailProgress").style.display = "";
}
function HiddenMailProgress() {
    document.getElementById("mailPanel").style.display = "none";
    document.getElementById("MailProgress").style.display = "none";
}
var listContentArry = new Array();
var listEventCheckbox = false;
var _RowObject = null;
function event_listCheckboxclick(obj) {
    if (obj.checked) {
        for (var RowCnt = 0; RowCnt < obj.parentElement.parentElement.childNodes.length; RowCnt++) {
            obj.parentElement.parentElement.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
        }
        listContentArry[listContentArry.length] = obj.parentElement.parentElement.getAttribute("id");
    }
    else {
        var TemplistArray = new Array();
        for (var i = 0; i < listContentArry.length; i++) {
            if (obj.parentElement.parentElement.getAttribute("id") == listContentArry[i]) {
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
function event_HeaderCheckBoxClick(obj) {
    if (obj.checked) {
        for (var i = 0; i < document.getElementById("MailList").childNodes.length; i++) {
            document.getElementById("MailList").childNodes.item(i).childNodes.item(0).childNodes.item(0).checked = true;
            for (var RowCnt = 0; RowCnt < document.getElementById("MailList").childNodes.item(i).childNodes.length; RowCnt++) {
                document.getElementById("MailList").childNodes.item(i).childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
            }
            listContentArry[listContentArry.length] = document.getElementById("MailList").childNodes.item(i).getAttribute("id");
        }
    }
    else {
        for (var i = 0; i < document.getElementById("MailList").childNodes.length; i++) {
            document.getElementById("MailList").childNodes.item(i).childNodes.item(0).childNodes.item(0).checked = false;
            for (var RowCnt = 0; RowCnt < document.getElementById("MailList").childNodes.item(i).childNodes.length; RowCnt++) {
                document.getElementById("MailList").childNodes.item(i).childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
            }
        }
        listContentArry = new Array();
    }
    listEventCheckbox = true;
}
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
var PressShiftKey = false;
var PressCtrlKey = false;
function event_listOnkeyUp(event) {
    if (navigator.userAgent.indexOf('Firefox') != -1) {
        if (!event) event = window.event;
    }
    switch (event.keyCode) {
        case 16: PressShiftKey = false; break;
        case 17: PressCtrlKey = false; break;
        case 46: deleteWork(false); break;
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
function event_Cardlistclick(obj) {
    if (!listEventCheckbox) {
        if (!PressShiftKey && !PressCtrlKey && listContentArry.length > 0) {
            for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
                _RowObject = document.getElementById(listContentArry[Cnt]);
                _RowObject.className = "address_boxlist";
                
            }
            listContentArry = new Array();
        }
        if (PressShiftKey) {
            var SelectedPreObj = null;
            for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
                _RowObject = document.getElementById(listContentArry[Cnt]);
                if (Cnt == 0)
                    SelectedPreObj = _RowObject;
                _RowObject.className = "address_boxlist";
            }
            listContentArry = new Array();

            var PrelistContent;
            if (SelectedPreObj == null)
                PrelistContent = _RowObject.getAttribute("id");
            else
                PrelistContent = SelectedPreObj.getAttribute("id");

            _RowObject = obj;

            var CurlistContent = obj.getAttribute("id");
            var PrePoint = parseInt(PrelistContent.replace("Cardlist_", ""));
            var CurPoint = parseInt(CurlistContent.replace("Cardlist_", ""));
            if (PrePoint < CurPoint) {

                for (var Cnt = PrePoint; Cnt <= CurPoint; Cnt++) {
                    _RowObject = document.getElementById("Cardlist_" + Cnt);
                    _RowObject.className = "address_onboxlist";
                    listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
                }

            }
            else if (PrePoint > CurPoint) {
                for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
                    _RowObject = document.getElementById("Cardlist_" + Cnt);
                    _RowObject.className = "address_onboxlist";
                    listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
                }
            }
            else
                return;
        }
        else {
            _RowObject = obj;
            var insertFlag = true;
            for (var i = 0; i < listContentArry.length; i++) {
                if (listContentArry[i] == _RowObject.getAttribute("id")) {
                    insertFlag = false;
                    if (PressCtrlKey) {
                        listContentArry.splice(i, 1);
                        _RowObject.className = "address_boxlist";
                    }
                }
            }
            if (insertFlag) {
                _RowObject.className = "address_onboxlist";
                listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
            }
        }
    }
    else
        listEventCheckbox = false;
}
function event_listclick(obj) {
    if (!listEventCheckbox) {
        if (document.getElementById("HeaderAllCheckBox").checked) {
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
                var SelectedPreObj = null;
                for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
                    _RowObject = document.getElementById(listContentArry[Cnt]);
                    if (Cnt == 0)
                        SelectedPreObj = _RowObject;
                    for (var RowCnt = 0; RowCnt < _RowObject.childNodes.length; RowCnt++) {
                        _RowObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
                    }
                    _RowObject.childNodes.item(0).childNodes.item(0).checked = false;
                }
                listContentArry = new Array();

                var PrelistContent;
                if (SelectedPreObj == null)
                    PrelistContent = _RowObject.getAttribute("id");
                else
                    PrelistContent = SelectedPreObj.getAttribute("id");

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
function event_listDBClick(obj) {
    var pAddressID = obj.getAttribute("_AddressID");
    var pAddressType = obj.getAttribute("_SType");
    var pheight = window.screen.availHeight;
    var pwidth = window.screen.availWidth;
    if (pAddressType == "P") {
        var conHeight = 500;
        var conWidth = 600;
        var pTop = (pheight - conHeight) / 2;
        var pLeft = (pwidth - conWidth) / 2;
        window.open("/ezAddress/addressRead.do?addressid=" + encodeURIComponent(pAddressID) + "&folderid=" + encodeURIComponent(pFolderID) + "&type=" + pFolderType, "",
            "top=" + pTop.toString() + ", left=" + pLeft.toString() + ",height = 500px, width =600px, status = no, toolbar=no, menubar=no,location=no, resizable=0");
    }
    else {
        var conHeight = 470;
        var conWidth = 370;
        var pTop = (pheight - conHeight) / 2;
        var pLeft = (pwidth - conWidth) / 2;
        window.open("/ezAddress/addressReadGroup.do?addressid=" + encodeURIComponent(pAddressID) + "&type=" + pFolderType, "",
                "top=" + pTop.toString() + ", left=" + pLeft.toString() + ",height = 470px, width = 370px, status = no, toolbar=no, menubar=no,location=no, resizable=0");
    }
}
function event_SearchlistDBClick(obj) {
    var pAddressID = obj.getAttribute("_AddressID");
    var pAddressType = obj.getAttribute("_SType");
    var pFolderType = obj.getAttribute("_FolderType");
    var _PFolderID = obj.getAttribute("_folderid");
    var pheight = window.screen.availHeight;
    var pwidth = window.screen.availWidth;
    if (pAddressType == "P") {
        var conHeight = 500;
        var conWidth = 600;
        var pTop = (pheight - conHeight) / 2;
        var pLeft = (pwidth - conWidth) / 2;
        window.open("/ezAddress/addressRead.do?addressid=" + encodeURIComponent(pAddressID) + "&folderid=" + encodeURIComponent(_PFolderID) + "&type=" + pFolderType, "",
            "top=" + pTop.toString() + ", left=" + pLeft.toString() + ",height = 500px, width =600px, status = no, toolbar=no, menubar=no,location=no, resizable=0");
    }
    else {
        var conHeight = 470;
        var conWidth = 370;
        var pTop = (pheight - conHeight) / 2;
        var pLeft = (pwidth - conWidth) / 2;
        window.open("/ezAddress/addressReadGroup.do?addressid=" + encodeURIComponent(pAddressID) + "&type=" + pFolderType, "",
            "top=" + pTop.toString() + ", left=" + pLeft.toString() + ",height = 470px, width = 370px, status = no, toolbar=no, menubar=no,location=no, resizable=0");
    }
}
function quick_cancel()
{
    ShowQuickAddres();
}
function Get_SameAddressCnt()
{
    var xmlHTTP = createXMLHttpRequest();
    var xmlDom = createXmlDom();
	
    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "IDLIST", pOwerID);
    createNodeAndInsertText(xmlDom, objNode, "FILTER", document.getElementById("qemail").value);
    createNodeAndInsertText(xmlDom, objNode, "FOLDERTYPE", pFolderType);
    createNodeAndInsertText(xmlDom, objNode, "FOLDERID", pFolderID);
        
    xmlHTTP.open("POST", "/ezAddress/addressGetSearchCnt.do", false);
    xmlHTTP.send(xmlDom);

    if (xmlHTTP.status == 200 )
        return xmlHTTP.responseText;
}