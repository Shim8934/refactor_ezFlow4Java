var xmlHTTPAddressList = null;
var ListXML = null;
function View_Change() {
    listContentArry = new Array();
    var listType = "";
    if (document.getElementById("ListViewType").value == "list") {
        document.getElementById("MailList").style.display = "";
        document.getElementById("MailListCard").style.display = "none";
        document.getElementById("DetailList_header").style.display = "";
        listType = "list";
    }
    else {
        document.getElementById("MailList").style.display = "none";
        document.getElementById("MailListCard").style.display = "";
        document.getElementById("DetailList_header").style.display = "none";
        listType = "card";
    }
    if (ListXML != null)
        MakeAddressList();
    /* 2016-12-28 이효민 : 주소록 검색화면에서 검색하기 전 명함/리스트보기 전환하면 에러나는 문제로 주석처리함.
    else {
        if (searchFlag)
            Get_SearchAddressList();
        else
            Get_AddressList();
    }*/
    var xmlDom = createXmlDom();
	var xmlHTTP = createXMLHttpRequest();
	var objRoot;
	createNodeInsert(xmlDom, objRoot, "DATA");
	createNodeAndInsertText(xmlDom, objRoot, "USERID", pOwerID);
	createNodeAndInsertText(xmlDom, objRoot, "LISTCNT", pPageSize);
	createNodeAndInsertText(xmlDom, objRoot, "LISTTYPE", listType);
	xmlHTTP.open("POST", "/ezAddress/addressSaveConfig.do", false);
	xmlHTTP.send(xmlDom);
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
    createNodeAndInsertText(xmlpara, objNode, "ADDRTYPE", pAddrType);
    xmlHTTPAddressList.open("POST", "/ezAddress/addressList.do", true);
    
    xmlHTTPAddressList.onreadystatechange = Complete_Get_AddressList;
    xmlHTTPAddressList.send(xmlpara);
    ShowMailProgress();
}
function Get_SearchAddressList() {
    try { HiddenMailProgress(); } catch (e) {console.log(e);}
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
    createNodeAndInsertText(xmlDom, objNode, "ADDRTYPE", pAddrType);
    xmlHTTPAddressList.open("POST", "/ezAddress/addressGetSearchList.do", true);
    xmlHTTPAddressList.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
    xmlHTTPAddressList.onreadystatechange = Complete_Get_AddressList;
    xmlHTTPAddressList.send(xmlDom);
    try { ShowMailProgress(); } catch (e) {console.log(e);}
    
    document.getElementById("HeaderAllCheckBox").checked = false;
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
            _TR.style.height = "31px";
            _TR.style.width = "100%";
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
                document.getElementById("width1").style.width = "15%";
                document.getElementById("width2").style.width = "15%";
            } else {
                document.getElementById("FolderType").style.display = "none";
                document.getElementById("width1").style.width = "20%";
                document.getElementById("width2").style.width = "20%";
            }
            _TR.onmouseover = function () { event_listMover(this); };
            _TR.onmouseout = function () { event_listMout(this); };
            _TR.onclick = function () { event_listclick(this); };
            
            if (searchFlag)
                _TR.ondblclick = function () { event_SearchlistDBClick(this); };
            else
                _TR.ondblclick = function () { event_listDBClick(this); };

            var _TD1 = document.createElement("TD");
            _TD1.style.width = "20px";
            _TD1.style.margin = "0px";
            _TD1.style.textAlign = "center";
            
            //div 래퍼 생성
            var _divWrapper = document.createElement("div");
            _divWrapper.className = "custom_checkbox";

            //checkbox 생성
            var _TDCheckBox_Sub = document.createElement("INPUT");
            _TDCheckBox_Sub.type = "checkbox";
            _TDCheckBox_Sub.style.margin = "0px";
            _TDCheckBox_Sub.style.padding = "0px";
            _TDCheckBox_Sub.style.height = "13px";
            _TDCheckBox_Sub.style.width = "13px";
            _TDCheckBox_Sub.style.textAlign = "left";
            _TDCheckBox_Sub.onclick = function () { event_listCheckboxclick(this); };
            
            _TDCheckBox_Sub.setAttribute("_SType", SType);
            _TDCheckBox_Sub.setAttribute("_AddressID", AddressID);
            _TDCheckBox_Sub.setAttribute("_Changekey", Changekey);
            _TDCheckBox_Sub.setAttribute("_ModifierID", ModifierID);
            _TDCheckBox_Sub.setAttribute("_CreatorID", CreatorID);
            
            // checkbox → div → td → tr 구조로 삽입
            _divWrapper.appendChild(_TDCheckBox_Sub);
            _TD1.appendChild(_divWrapper);
            _TR.appendChild(_TD1);

            var _TD2 = document.createElement("TD");
            _TD2.style.width = "40px";
            _TD2.style.margin = "0px";
            _TD2.style.padding = "2px 0px 0px 0px";
            _TD2.style.textAlign = "center";
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
            _TD3.style.whiteSpace = "nowrap";
            _TD3.style.overflow = "hidden";
            _TD3.style.textOverflow = "ellipsis";
            
            if (CrossYN())
                _TD3.innerText = Sname
            else
            	_TD3.innerHTML = "&nbsp;" + Sname;
            _TR.appendChild(_TD3);

            var _TD4 = document.createElement("TD");            
            _TD4.style.width = "20%";
            _TD4.style.margin = "0px";
            _TD4.style.padding = "0px";
            _TD4.style.whiteSpace = "nowrap";
            _TD4.style.overflow = "hidden";
            _TD4.style.textOverflow = "ellipsis";
            
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
            _TD5.style.whiteSpace = "nowrap";
            _TD5.style.overflow = "hidden";
            _TD5.style.textOverflow = "ellipsis";
            
            if (CrossYN())
                _TD5.textContent = ScompnayPhone;
            else
                _TD5.innerText = ScompnayPhone;
            _TR.appendChild(_TD5);

            var _TD6 = document.createElement("TD");
            if (searchFlag) {
            	_TD6.style.width = "15%";
            }
            else
            	_TD6.style.width = "20%";
            _TD6.style.margin = "0px";
            _TD6.style.padding = "0px";
            _TD6.style.whiteSpace = "nowrap";
            _TD6.style.overflow = "hidden";
            _TD6.style.textOverflow = "ellipsis";
            
            if (CrossYN())
                _TD6.textContent = Smobile;
            else
                _TD6.innerText = Smobile;
            _TR.appendChild(_TD6);

            var _TD7 = document.createElement("TD");
            _TD7.style.width = "20%";
            _TD7.style.margin = "0px";
            _TD7.style.padding = "0px";
            _TD7.style.whiteSpace = "nowrap";
            _TD7.style.overflow = "hidden";
            _TD7.style.textOverflow = "ellipsis";
            
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
                _TD8.style.whiteSpace = "nowrap";
                _TD8.style.overflow = "hidden";
                _TD8.style.textOverflow = "ellipsis";

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

/*            var SubPTag = document.createElement("p");
            SubPTag.className = "topinfo";

            var pContentSub = document.createElement("span");
            pContentSub.innerText = Sname;*/
            
            var imgType = "";
            
            if (SType == "P"){
            	imgType = "<img src=\"/images/i_individual.gif\" style=\"vertical-align:middle;margin-top:-4px;\" /> ";
            } else {
            	imgType = "<img src=\"/images/i_group.gif\" style=\"vertical-align:middle;margin-top:-4px;\" /> ";
            }
            /*SubPTag.appendChild(pContentSub);*/

            var ULTag = document.createElement("ul");
            /* 2018-04-25 장진혁 - 주소록 카드형식 UI 틀어짐현상때문에 수정 */
            ULTag.style.marginTop = "12px";
            
            Sname = replaceAll(Sname, "&", "&amp;");
            
            var UITag1 = document.createElement("li");
            UITag1.className = "name";            
            UITag1.innerHTML = imgType + Sname;
            
            var UITag2 = document.createElement("li");
            UITag2.className = "company";
            if (CrossYN())
                UITag2.textContent = Scompany;
            else
                UITag2.innerText = Scompany;
            
            var ULTag0 = document.createElement("ul");
            ULTag0.style.margin = "0px";
            ULTag0.style.padding = "11px 10px 4px 10px";
            ULTag0.style.backgroundColor = "#fafafa";
            ULTag0.style.borderRadius = "5px";
            
            var UITag3 = document.createElement("li");
            var span3 = document.createElement("span");
            span3.setAttribute("class", "point_txt");
            span3.innerText = ScompnayPhone;
            UITag3.innerText =  CardHeader1 + ":";
            UITag3.appendChild(span3);
            
            var UITag4 = document.createElement("li");
            var span4 = document.createElement("span");
            span4.setAttribute("class", "point_txt");
            span4.innerText = Smobile;
            UITag4.innerText = CardHeader2 + ":";
            UITag4.appendChild(span4);
            
            var UITag5 = document.createElement("li");
            UITag5.innerHTML = CardHeader3 + ":<span class=\"point_txt\">" + Semail + "</span>";

            /*var EndDiv = document.createElement("DIV");
            EndDiv.className = "shadow";*/

            DivLayer.appendChild(SubDivLayer);
            /*DivLayer.appendChild(EndDiv);*/
            /*SubDivLayer.appendChild(SubPTag);*/
            SubDivLayer.appendChild(ULTag);
            SubDivLayer.appendChild(ULTag0);
            ULTag.appendChild(UITag1);
            ULTag.appendChild(UITag2);
            ULTag0.appendChild(UITag3);
            ULTag0.appendChild(UITag4);
            ULTag0.appendChild(UITag5);
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
        
        if (ListXML == null) {
            HiddenMailProgress();
            return;
        }
        
        var XmlRows = SelectNodes(ListXML, "DATA/ROW");
        if (XmlRows.length == 0) {
            if (searchFlag) {
                pCurrentPage--;
                if (pCurrentPage <= 0) {
                    document.getElementById("mailBoxInfo").style.visibility = "hidden";
                    while (document.getElementById("MailList").childNodes.length > 0) {
                        document.getElementById("MailList").removeChild(document.getElementById("MailList").childNodes.item(0));
                    }
                    while (document.getElementById("MailListCard").childNodes.length > 0) {
                        document.getElementById("MailListCard").removeChild(document.getElementById("MailListCard").childNodes.item(0));
                    }
                    MakeNoDateList();
                    HiddenMailProgress();
                    pTotalCnt = 0;
                    makePageSelPage();
                    return;
                }
                //Get_SearchAddressList();
                return;
            }
        }
        document.getElementById("mailBoxInfo").style.visibility = "visible";
        MakeAddressList();
        
    }
}
function MakeNoDateList() {
    if (document.getElementById("ListViewType").value == "list") {
        document.getElementById("MailList").style.width = "100%";
        var _TR = document.createElement("TR");
        _TR.style.verticalAlign = "middle";
        _TR.style.height = "31px";

        var _TD = document.createElement("TD");
        _TD.style.textAlign = "center";
        _TD.id = "noData";
        _TD.innerHTML = strLang100;
        _TR.appendChild(_TD);
        document.getElementById("MailList").appendChild(_TR);
    }
    else if(searchFlag){
        var DivLayer = document.createElement("DIV");
        DivLayer.style.textAlign = "center";
        DivLayer.className = "emptyDiv";
        /*DivLayer.innerHTML = "<img src='/images/kr/main/nodata_plan.png' /><div style='margin-top:10px'>" + strLang100 + "</div>";*/
        DivLayer.innerHTML = "<dl class='nodata_sIcon'><dt><img src='/images/kr/main/noData_sIcon.png'></dt><dd>" + strLangNoSearchData + "</dd></dl>";
        document.getElementById("MailListCard").appendChild(DivLayer);
    } else{
    	var DivLayer = document.createElement("DIV");
    	DivLayer.style.textAlign = "center";
    	DivLayer.className = "emptyDiv";
    	DivLayer.innerHTML = "<img src='/images/kr/main/nodata_plan.png' /><div style='margin-top:10px'>" + strLang100 + "</div>";
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
    
    document.getElementById("HeaderAllCheckBox").checked = false;
    
    pCurrentPage = "1";
    if (searchFlag)
        Get_SearchAddressList();
    else
        Get_AddressList();
}
function goToPageByNum(szNum) {
    document.getElementById("HeaderAllCheckBox").checked = false;
    
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
        document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + pTotalCnt + "</span>";
    else {
        document.getElementById("mailBoxInfo").className = "h2_dot"; 
        document.getElementById("mailBoxInfo").innerHTML = strLang_1 + "&nbsp;<span class='point'>" + pTotalCnt + "</span> " + strLang_2;
    }
    if (totalPage > 1 && pageNum != 1) {
        PagingHTML += "<span class=\"btnimg first\" onclick= 'return goToPageByNum(1)'></span>";
    }
    else {
        PagingHTML += "<span class=\"btnimg first disabled\"></span>";
    }
    if (totalPage > BlockSize) {
        if (pageNum > BlockSize) {
            PagingHTML += "<span class=\"btnimg prev\" onclick= 'return selbeforeBlock()'></span>";
        }
        else {
            PagingHTML += "<span class=\"btnimg prev disabled\" ></span>";
        }
    }
    else {
        PagingHTML += "<span class=\"btnimg prev disabled\" ></span>";
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
        if (i == pageNum){
            PagingHTML += "<span class=\"on\">" + i + "</span>";
        }
        else {
            PagingHTML += "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
        }
    }
    
    if (pTotalCnt == 0 ){
    	PagingHTML += "<span class=\"on\">" + i + "</span>";
    }
    	
    if (totalPage > BlockSize) {
        if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
            PagingHTML += "<span class=\"btnimg next\" onclick='return selafterBlock()'></span>";
        }
        else {
            PagingHTML += "<span class=\"btnimg next disabled\"></span>";
        }
    }
    else {
        PagingHTML += "<span class=\"btnimg next disabled\"></span>";
    }
    if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
        PagingHTML += "<span class=\"btnimg last\" onclick='return goToPageByNum(" + totalPage + ")'></span>";
    }
    else {
        PagingHTML += "<span class=\"btnimg last disabled\"></span>";
    }
    PagingHTML += "</div>";
    td_Create1(PagingHTML);
}
function Window_onresize() {
    if (searchFlag) {
        if (document.getElementById("ListViewType").value == "list") {
            document.getElementById("list_Layer").style.height = (document.documentElement.clientHeight - 230) + "px";
            document.getElementById("contentlist").style.height = (document.documentElement.clientHeight - 271) + "px";
        }
        else {
            document.getElementById("list_Layer").style.height = (document.documentElement.clientHeight - 243) + "px";
            document.getElementById("contentlist").style.height = (document.documentElement.clientHeight - 263) + "px";
        }
    }
    else {
        if (document.getElementById("ListViewType").value == "list") {
            document.getElementById("list_Layer").style.height = (document.documentElement.clientHeight - 230) + "px";
            document.getElementById("contentlist").style.height = (document.documentElement.clientHeight - 271) + "px";
        }
        else {
            document.getElementById("list_Layer").style.height = (document.documentElement.clientHeight - 243) + "px";
            document.getElementById("contentlist").style.height = (document.documentElement.clientHeight - 263) + "px";
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

var listContentArry = [];
var listEventCheckbox = false;
var _RowObject = null;

function event_listCheckboxclick(obj) {
    const row = obj.closest('tr');
    if (!row) return;

    const isChecked = obj.checked;
    const rowId = row.getAttribute("id");

    // 배경색 변경
    const tds = row.querySelectorAll('td');
    tds.forEach(td => {
        td.style.backgroundColor = isChecked ? m_strColorSelect : m_strColorDefault;
    });

    if (isChecked) {
        if (!listContentArry.includes(rowId)) {
            listContentArry.push(rowId);
        }
    } else {
        listContentArry = listContentArry.filter(id => id !== rowId);
    }

    listEventCheckbox = true;
}

function event_HeaderCheckBoxClick(obj) {
    const mailList = document.getElementById("MailList");

    // 데이터 없는 경우 종료
    if (mailList.childNodes.length === 0 || mailList.querySelector('tr#noData')) return;

    const rows = mailList.querySelectorAll("tr");
    listContentArry = [];

    rows.forEach((row, index) => {
        const checkbox = row.querySelector('td .custom_checkbox input[type="checkbox"]');
        if (!checkbox) return;

        if (obj.checked) {
            checkbox.checked = true;
            listContentArry.push(row.id);

            row.querySelectorAll("td").forEach(td => {
                td.style.backgroundColor = m_strColorSelect;
            });
        } else {
            checkbox.checked = false;

            row.querySelectorAll("td").forEach(td => {
                td.style.backgroundColor = m_strColorDefault;
            });
        }
    });
}

function event_listMover(row) {
    const checkbox = row.querySelector('td .custom_checkbox input[type="checkbox"]');
    if (checkbox && !checkbox.checked) {
        row.querySelectorAll("td").forEach(td => {
            td.style.backgroundColor = m_strColorOver;
        });
    }
}

function event_listMout(row) {
    const checkbox = row.querySelector('td .custom_checkbox input[type="checkbox"]');
    if (checkbox && !checkbox.checked) {
        row.querySelectorAll("td").forEach(td => {
            td.style.backgroundColor = m_strColorDefault;
        });
    }
}

/*
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
	
	if (document.getElementById("MailList").childNodes.item(0).childNodes.item(0).id == 'noData') {
		return;
	}
	
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
    //listEventCheckbox = true;
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
}*/
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

function toggleRowStyle(row, color) {
    row.querySelectorAll("td").forEach(td => td.style.backgroundColor = color);
}

function updateRowSelection(row, select) {
    const checkbox = row.querySelector('input[type="checkbox"]');
    const rowId = row.getAttribute('id');
    checkbox.checked = select;
    toggleRowStyle(row, select ? m_strColorSelect : m_strColorDefault);

    if (select && !listContentArry.includes(rowId)) {
        listContentArry.push(rowId);
    } else if (!select) {
        listContentArry = listContentArry.filter(id => id !== rowId);
    }
}

function clearAllSelections() {
    listContentArry.forEach(id => {
        const row = document.getElementById(id);
        if (row) updateRowSelection(row, false);
    });
    listContentArry = [];
}

function event_listclick(row) {
    if (listEventCheckbox) {
        listEventCheckbox = false;
        return;
    }

    const checkbox = row.querySelector('input[type="checkbox"]');
    const rowId = row.getAttribute('id');
    const isChecked = checkbox.checked;

    const headerCheckbox = document.getElementById("HeaderAllCheckBox");

    if (headerCheckbox && headerCheckbox.checked) {
        updateRowSelection(row, !isChecked);
        return;
    }

    // Ctrl, Shift 없는 일반 클릭이면 기존 선택 해제
    if (!PressCtrlKey && !PressShiftKey && listContentArry.length > 0) {
        clearAllSelections();
    }

    if (PressShiftKey && listContentArry.length > 0) {
        let firstId = listContentArry[0];
        let start = parseInt(firstId.replace("Maillist_", ""), 10);
        let end = parseInt(rowId.replace("Maillist_", ""), 10);

        if (isNaN(start) || isNaN(end)) return;

        if (start > end) [start, end] = [end, start];

        clearAllSelections();

        for (let i = start; i <= end; i++) {
            const targetRow = document.getElementById(`Maillist_${i}`);
            if (targetRow) updateRowSelection(targetRow, true);
        }
    } else {
        updateRowSelection(row, !isChecked);
    }
}
/*
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
                    
                    var TemplistArray = new Array();
                    
                    for (var i = 0; i < listContentArry.length; i++) {
                        if (obj.getAttribute("id") != listContentArry[i]) {
                            TemplistArray[TemplistArray.length] = listContentArry[i];
                        }
                    }
                    
                    listContentArry = TemplistArray;                    
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
}*/

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
            "top=" + pTop.toString() + ", left=" + pLeft.toString() + ",height = 530px, width =600px, status = no, toolbar=no, menubar=no,location=no, resizable=yes");
    }
    else {
        var conHeight = 575;
        var conWidth = 717;
        var pTop = (pheight - conHeight) / 2;
        var pLeft = (pwidth - conWidth) / 2;
        address_group_edit_dialogArguments[0] = edit_group;
        window.open("/ezAddress/addressReadGroup.do?addressid=" + encodeURIComponent(pAddressID) + "&type=" + pFolderType, "",
                "top=" + pTop.toString() + ", left=" + pLeft.toString() + ",height = 575px, width = 717px, status = no, toolbar=no, menubar=no,location=no, resizable=yes");
    }
}
var address_group_edit_dialogArguments = new Array();
function event_SearchlistDBClick(obj) {
    var pAddressID = obj.getAttribute("_AddressID");
    var pAddressType = obj.getAttribute("_SType");
    var pFolderType = obj.getAttribute("_FolderType");
    var _PFolderID = obj.getAttribute("_FolderID");
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
        var conHeight = 575;
        var conWidth = 717;
        var pTop = (pheight - conHeight) / 2;
        var pLeft = (pwidth - conWidth) / 2;
        address_group_edit_dialogArguments[0] = edit_group;
        window.open("/ezAddress/addressReadGroup.do?addressid=" + encodeURIComponent(pAddressID) + "&type=" + pFolderType, "",
            "top=" + pTop.toString() + ", left=" + pLeft.toString() + ",height = 575px, width = 717px, status = no, toolbar=no, menubar=no,location=no, resizable=0");
    }
}

function edit_group(ret) {
	var pheight = window.screen.availHeight;
    var pwidth = window.screen.availWidth;
	var conHeight = 655;
    var conWidth = 970;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - conWidth) / 2;
	
	window.open("/ezAddress/addressWriteGroup.do?addressid=" + encodeURIComponent(ret[0]) + "&foldertype=" + ret[1], "",
			"top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = 655px, width = 970px, status = no, toolbar=no, menubar=no,location=no, resizable=0");
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

// 재은 수정
function replaceAll(str, searchStr, replaceStr) {
	return str.split(searchStr).join(replaceStr);
}