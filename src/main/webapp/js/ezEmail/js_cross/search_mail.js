var g_searchHttp = null;
var g_progresswin = null;
var minimumWidth = 890;

function showProgress() {
    document.getElementById("progressviewerRayer").style.top = "200px";
    document.getElementById("progressviewerRayer").style.left = (document.documentElement.clientWidth / 2) - 240 + "px";
    document.getElementById("progressviewerRayer").style.display = "";
    document.getElementById("progressviewer").src = "/myoffice/common/show_progress.aspx?fileinfo=" + encodeURIComponent(strLang147);
}

function hideProgress() {
    try {
        document.getElementById("progressviewerRayer").style.display = "none";
    } catch (e) {console.log(e);}
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
//	start_search();
}

//skyblue0o0
var listSize = 100;
var BlockSize = 10;
function makePageSelPage() {
    var strtext;
    var PagingHTML = "";
    document.getElementById("tblPageRayer").innerHTML = "";
    strtext = "<div class=\"pagenavi\">";
    PagingHTML += strtext;
    var totalPage = parseInt(document.getElementById("resultTD").getAttribute("MaxPage"));
    var pageNum = parseInt(document.getElementById("resultTD").getAttribute("curPage"));
    
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
        if (i == pageNum) {
        	PagingHTML += "<span class=\"on\">" + i + "</span>";
        }
        else {
            PagingHTML += "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
        }
    }
    
    if (MaxNum == 0) {
    	PagingHTML += "<span class=\"on\">" + 1 + "</span>";
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
    document.getElementById("tblPageRayer").innerHTML = PagingHTML;
}

function goToPageByNum(num) {
    document.getElementById("resultTD").setAttribute("curPage", num);
    start_search();
}

function selbeforeBlock() {
    var pageNum = parseInt(document.getElementById("resultTD").getAttribute("curPage"));
    pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
    goToPageByNum(pageNum);
}

function selafterBlock() {
    var pageNum = parseInt(document.getElementById("resultTD").getAttribute("curPage"));
    pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
    goToPageByNum(pageNum);
}

function selbeforeBlock_one() {
    var pageNum = parseInt(document.getElementById("resultTD").getAttribute("curPage"));
    var totalPage = parseInt(document.getElementById("resultTD").getAttribute("MaxPage"));
    
    if (parseInt(pageNum - 1) > 0) {
    	goToPageByNum(parseInt(parseInt(pageNum - 1)));
    }
}

function selafterBlock_one() {
    var pageNum = parseInt(document.getElementById("resultTD").getAttribute("curPage"));
    var totalPage = parseInt(document.getElementById("resultTD").getAttribute("MaxPage"));
    
    if (parseInt(pageNum + 1) <= totalPage) {
    	goToPageByNum(parseInt(parseInt(pageNum + 1)));
    }
}
//skyblue0o0 - end

function start_search() {
    searchMode = true;
    listContentArry = new Array();
    listEventCheckbox = false;
    PressShiftKey = false;
    PressCtrlKey = false;
    
    if (!searchKArray) {
        alert(strLang254);
        return;
    }

    if (g_searchHttp != null)
        return;

    resultCount.innerHTML = "";
    recordCount = 0;

    var sYear, sMonth, sDay, eYear, eMonth, eDay, sTime, eTime;
    var i;
    var bError = false;
    //var startDate = "", endDate = "";

    if (usepostDate) {
        startDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";
        endDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";

        var sDate = new Date(startDate.split(' ')[0].split('-')[0], startDate.split(' ')[0].split('-')[1], startDate.split(' ')[0].split('-')[2]);
        var eDate = new Date(endDate.split(' ')[0].split('-')[0], endDate.split(' ')[0].split('-')[1], endDate.split(' ')[0].split('-')[2]);

        if (startDate > endDate) {
            alert(strLang312);
            return;
        }
    }

    var baseURL = document.location.protocol + "//" + g_servername + "/" + g_expath + "/" + g_userID + "/";

    var sMailFolder = TrimText(select2.value);
    ShowMailProgress();
    if(listType == "mailList"){	
    	//searchRecurMail2(sMailFolder, startDate, endDate);
    	searchRecurMail(sMailFolder, startDate, endDate, true);
    } else {
    	searchRecurMail(sMailFolder, startDate, endDate, false);
    }
    
}

function searchRecurMail(sMailFolder, startDate, endDate, isMailList) {
    var pageNum = parseInt(document.getElementById("resultTD").getAttribute("curPage"));
    var startIndex = listSize * (pageNum - 1);
    
    g_searchHttp = createXMLHttpRequest();
    var xmlDOM = createXmlDom();

    var objNode;
    createNodeInsert(xmlDOM, objNode, "DATA");
    createNodeAndInsertText(xmlDOM, objNode, "MAILFOLDER", sMailFolder);

    for (var i = 0 ; i < searchCArray.length; i++ ){
    	searchKArray[i] = ReplaceText(searchKArray[i], "&", "&amp;");
    	searchKArray[i] = ReplaceText(searchKArray[i], "<", "&lt;");
    	searchKArray[i] = ReplaceText(searchKArray[i], ">", "&gt;");
    	searchKArray[i] = ReplaceText(searchKArray[i], "'", "''");
    	createNodeAndInsertText(xmlDOM, objNode, "KEYWORD", searchKArray[i]);
    	createNodeAndInsertText(xmlDOM, objNode, "CATEGORY", searchCArray[i]);
    }
    createNodeAndInsertText(xmlDOM, objNode, "STARTDATE", startDate);
    createNodeAndInsertText(xmlDOM, objNode, "ENDDATE", endDate);
    // attach contain
    var attachStatus = "";
    var andorStatus = "";
    if( $("#moreSearch").css("display") != "none"){
    	if(document.querySelector("input[name=attachment]:checked").value != null ){
    			attachStatus = document.querySelector("input[name=attachment]:checked").value;
    	}
    	
    	if(document.querySelector("input[name=andor]:checked").value != null ){
    		andorStatus = document.querySelector("input[name=andor]:checked").value;
    	}
    }
    createNodeAndInsertText(xmlDOM, objNode, "ATTACHSTATUS", attachStatus);
    createNodeAndInsertText(xmlDOM, objNode, "ANDORSTATUS", andorStatus);
    	
    if (p_ListOrderObject == null) {
        event_HeaderClick(document.getElementById("tofromdate"));
    }
    
    createNodeAndInsertText(xmlDOM, objNode, "PORP", p_ListOrderObject.getAttribute("porp"));
    createNodeAndInsertText(xmlDOM, objNode, "ORDERBY", p_ListOrderObject.getAttribute("orderoption"));
    createNodeAndInsertText(xmlDOM, objNode, "STARTINDEX", startIndex);
    createNodeAndInsertText(xmlDOM, objNode, "LISTCOUNT", listSize);

	if (isMailList && window.tagName) {
		createNodeAndInsertText(xmlDOM, objNode, "TAGNAME", tagName);
	}

    var requestUrl = "/ezEmail/mailSearch.do";
    
    if (shareId != "") {
    	requestUrl += "?shareId=" + encodeURIComponent(shareId);
    }
    
    g_searchHttp.open("POST", requestUrl, true);
    g_searchHttp.onreadystatechange = event_searchRecurMail;
    g_searchHttp.send(xmlDOM);
}
/* 2025-02-17 - searchRecurMail와 TAGNAME 부분 외 동일하기 때문에 불필요한 코드 중복으로 주석처리
function searchRecurMail2(sMailFolder, startDate, endDate) {
	var pageNum = parseInt(document.getElementById("MailList").getAttribute("curPage"));
	var startIndex = listSize * (pageNum - 1);
	
	g_searchHttp = createXMLHttpRequest();
	var xmlDOM = createXmlDom();
	
	var objNode;
	createNodeInsert(xmlDOM, objNode, "DATA");
	createNodeAndInsertText(xmlDOM, objNode, "MAILFOLDER", sMailFolder);
	
	for (var i = 0 ; i < searchCArray.length; i++ ){
		searchKArray[i] = ReplaceText(searchKArray[i], "&", "&amp;");
		searchKArray[i] = ReplaceText(searchKArray[i], "<", "&lt;");
		searchKArray[i] = ReplaceText(searchKArray[i], ">", "&gt;");
		searchKArray[i] = ReplaceText(searchKArray[i], "'", "''");
		createNodeAndInsertText(xmlDOM, objNode, "KEYWORD", searchKArray[i]);
		createNodeAndInsertText(xmlDOM, objNode, "CATEGORY", searchCArray[i]);
	}
	createNodeAndInsertText(xmlDOM, objNode, "STARTDATE", startDate);
	createNodeAndInsertText(xmlDOM, objNode, "ENDDATE", endDate);
	// attach contain
	var attachStatus = "";
	var andorStatus = "";
	if( $("#moreSearch").css("display") != "none"){
		if(document.querySelector("input[name=attachment]:checked").value != null ){
			attachStatus = document.querySelector("input[name=attachment]:checked").value;
		}
		
		if(document.querySelector("input[name=andor]:checked").value != null ){
			andorStatus = document.querySelector("input[name=andor]:checked").value;
		}
	}
	createNodeAndInsertText(xmlDOM, objNode, "ATTACHSTATUS", attachStatus);
	createNodeAndInsertText(xmlDOM, objNode, "ANDORSTATUS", andorStatus);
	
	if (p_ListOrderObject == null) {
		event_HeaderClick(document.getElementById("tofromdate"));
	}
	
	createNodeAndInsertText(xmlDOM, objNode, "PORP", p_ListOrderObject.getAttribute("porp"));
	createNodeAndInsertText(xmlDOM, objNode, "ORDERBY", p_ListOrderObject.getAttribute("orderoption"));
	createNodeAndInsertText(xmlDOM, objNode, "STARTINDEX", startIndex);
	createNodeAndInsertText(xmlDOM, objNode, "LISTCOUNT", listSize);
	
	var requestUrl = "/ezEmail/mailSearch.do";
	
	if (shareId != "") {
		requestUrl += "?shareId=" + encodeURIComponent(shareId);
	}
	
	g_searchHttp.open("POST", requestUrl, true);
	g_searchHttp.onreadystatechange = event_searchRecurMail;
	g_searchHttp.send(xmlDOM);
}*/

var resultTable = null;
var recordCount = 0;

function event_searchRecurMail() {
    if (g_searchHttp == null || g_searchHttp.readyState != 4) {
    	return;
    }
    	
    if (g_searchHttp.status > 199 && g_searchHttp.status < 300) {
    	var curPage = "";
        if(listType == "mailList"){	
        	var list = document.getElementById("MailList");
        	if (list.childNodes.item(0).childNodes.childNodes.item(0).checked) {
        		list.childNodes.item(0).childNodes.childNodes.item(0).checked = false;
        	}
        } else {
        	if (document.getElementById("Checkbox1").checked) {
         	   document.getElementById("Checkbox1").checked = false;
        	}
        }

        var passXml = createXmlDom();
        passXml = loadXMLString(g_searchHttp.responseText);

        resultView(passXml);
        
        g_searchHttp = null;

        HiddenMailProgress();
        
        if (resultTable.rows.length == 0) {
        	var curPage = "";
        	if(listType == "mailList"){
        		curPage = document.getElementById("MailList").getAttribute("curPage");
        	} else {
	        	curPage = document.getElementById("resultTD").getAttribute("curPage");
        	}
        	
        	if (Number(curPage) > 1) {
        		selbeforeBlock_one();
        	} else {
        		tr = resultTable.insertRow();
                tr.height = 20;
                td = tr.insertCell();
                td.innerHTML = strLang155;
                td.style.textAlign  = "center";
        	}
        } else {
            resultCount.innerHTML = " : " + strLang156 + "<b>" + recordCount + "</b> " + strLang157;
        }
        
    } else {
        HiddenMailProgress();
	//  검색 도중 다른곳 선택시 에러가 발생했다는 에러가 뜨지 않도록 주석처리. 
	//	alert(strLang158 + g_searchHttp.status);
        g_searchHttp = null;
    }
}

function resultView(xmlDoc) {
    var i, k;
    var tr, td;
    var tempText;
    var webserver;

    var fromemail, datereceived, parentname, subject, importance, fromname, hasattachment, read, href, displayto, ItemClass, Size, Flag, msgto;

    var ChildCnt = 0;
    
    if (!CrossYN()) {
        ChildCnt = 1;
    }
    
    if (select2.value == strLang64) {
    	
        if (GetChildNodes(tofromname).length > ChildCnt) {
            var temphtml = GetChildNodes(tofromname)[ChildCnt].outerHTML;
            
            tofromname.innerText = strLang11;
            tofromname.innerHTML += temphtml;
        } else {
            tofromname.innerText = strLang11;
        }

        if (GetChildNodes(tofromdate).length > ChildCnt) {
            temphtml = GetChildNodes(tofromdate)[ChildCnt].outerHTML;
            tofromdate.innerText = strLang159;
            tofromdate.innerHTML += temphtml;
        } else {
            tofromdate.innerText = strLang159;
    	}
    } else {
    	
        if (GetChildNodes(tofromname).length > ChildCnt) {
            var temphtml = GetChildNodes(tofromname)[ChildCnt].outerHTML;
            
            tofromname.innerText = strLang160;
            tofromname.innerHTML += temphtml;
        } else {
            tofromname.innerText = strLang160;
        }

        if (GetChildNodes(tofromdate).length > ChildCnt) {
            temphtml = GetChildNodes(tofromdate)[ChildCnt].outerHTML;
            tofromdate.innerText = strLang9;
            tofromdate.innerHTML += temphtml;
        } else {
            tofromdate.innerText = strLang9;
        }
    }
    
    var totalCount = SelectSingleNodeValueNew(xmlDoc, "DATA/TOTALCOUNT");
    
    var maxPage = Math.ceil(Number(totalCount) / listSize);
    
    if (maxPage == 0) {
    	maxPage = 1;
    }
    
    document.getElementById("resultTD").setAttribute("MaxPage", maxPage);
    
    makePageSelPage();
    
    if (resultTable != null) {
        resultTable = null;
    }

    resultTable = document.createElement("TABLE");
    resultTable.style.tableLayout = "fixed";
    resultTable.id = "maillist";
    resultTable.className = "mainlist";
    resultTable.style.width = "100%";
    resultTable.setAttribute("maxcount",totalCount);

    resultTD.innerHTML = "";
    resultTD.appendChild(resultTable);

    var fromNode, dateNode, parentNode, subjectNode, impNode, nameNode, attachNode, readNode, idNode, toNode, ItemClassNode;
    var XmlRows = SelectNodes(xmlDoc, "DATA/ROWS/ROW");
    var loopCount = XmlRows.length;
    recordCount = totalCount;

    for (i = 0; i < loopCount; i++) {
        fromemail = SelectSingleNodeValue(XmlRows[i], "FROMEMAIL");
        datereceived = SelectSingleNodeValue(XmlRows[i], "DATERECEIVED");
        parentname = SelectSingleNodeValue(XmlRows[i], "PARENTNAME");
        subject = SelectSingleNodeValue(XmlRows[i], "SUBJECT");
        importance = SelectSingleNodeValue(XmlRows[i], "IMPORTANCE");
        fromname = SelectSingleNodeValue(XmlRows[i], "FROMNAME");
        hasattachment = SelectSingleNodeValue(XmlRows[i], "HASATTACHMENT");
        read = SelectSingleNodeValue(XmlRows[i], "READ");
        securemail = SelectSingleNodeValue(XmlRows[i], "SECUREMAIL");
        id = SelectSingleNodeValue(XmlRows[i], "ITEMID");
        displayto = SelectSingleNodeValue(XmlRows[i], "DISPLAYTO");
        msgto = SelectSingleNodeValue(XmlRows[i], "MSGTO");
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
        tr.setAttribute("securemail", securemail);
        tr.setAttribute("read", read);
        tr.onmouseover = function () { event_listMover(this); };
        tr.onmouseout = function () { event_listMout(this); };
        tr.onclick = function () { event_listclick(this); };
        tr.ondblclick = view_click;
        tr.valign = "center";

        var tempText = "<div class='custom_checkbox'><input type='checkbox' id = 'checklol" + i + "' name='checklol' onclick='event_listCheckboxclick(this)'></div>";
        preparedTD(tr, "26px", "center", "middle", tempText, "", "", true);

        tempText = "";
        
        if (importance == 2) {
            tempText = "<img src='/images/ImgIcon/icon-highimportance.gif' border=0>";
        } else if (importance == 0) {
            tempText = "<img src='/images/ImgIcon/icon-lowimportance.gif' border=0>";
        }

        preparedTD(tr, "26px", "center", "middle", tempText, "", "", true);

        var readStyle = "font-weight: inherit;";
        
        if (read == "1") {
            tempText = "<img src='/images/ImgIcon/icon-msg-read.gif' border=0>";
        } else {
            tempText = "<img src='/images/ImgIcon/icon-msg-unread.gif' border=0>";
            tr.style.fontWeight = "bold";
        }

        preparedTD(tr, "26px", "center", "middle", tempText, "", "", true);


        tempText = "";
        
        if (Flag == "0") {
            tempText = "<img src='/images/ImgIcon/view-flag.gif' border=0>";
        } else {
            tempText = "<img src='/images/ImgIcon/icon-flag.gif' border=0>";
        }

        preparedTD(tr, "26px", "center", "middle", tempText, "", "", true);


        tempText = "";
        
        if (hasattachment == "1") {
            tempText = "<img src='/images/newAttach.gif' border=0>";
        }

        preparedTD(tr, "26px", "center", "middle", tempText, "", "", true);

        if (tofromname.innerText == strLang160) {
            preparedTD(tr, "100px", "left", "middle", fromname, msgto, 1, false, readStyle);
            tr.recvFrom = fromname;
        } else {
            preparedTD(tr, "100px", "left", "middle", displayto, displayto, 1, false);
            tr.recvFrom = displayto;
        }
        
        preparedTD(tr, "100%", "left", "middle", subject, subject, 1, false, readStyle);

        if (TrimText(datereceived) != "null") {
            datereceived = GetLocalTime(g_timezone, datereceived).substring(0, 16);
        }

        datereceived = datereceived.replace("T", " ");
        preparedTD(tr, "200px", "left", "middle", datereceived, "", "", false, readStyle);


        var foldername = parentname;

        if (g_userLang != "1") {
            foldername = ReplaceText(foldername, strLang63, strLang161);
            foldername = ReplaceText(foldername, strLang64, strLang162);
            foldername = ReplaceText(foldername, strLang65, strLang163);
            foldername = ReplaceText(foldername, strLang66, strLang164);
            foldername = ReplaceText(foldername, strLang67, strLang71);
        }

        preparedTD(tr, "120px", "left", "middle", foldername, foldername, 1, false, readStyle);
        preparedTD(tr, "50px", "left", "middle", FormatSize(Size), "", "", false, readStyle);

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
    } else {
        iSize = Math.round(iSize / 1024);

        if (iSize > 1000) {
            iSize = Math.round(iSize / 1024);
            iSize = String(iSize);
            p_Prop8 = iSize + " MB";
        } else {
            p_Prop8 = iSize + " KB";
        }
    }
    
    return p_Prop8;
}

var _RowObject = null;

function event_listMover(obj) {
    if (!obj.querySelector('input[type="checkbox"]').checked) {
    	obj.style.backgroundColor = m_strColorOver;
    }
}
function event_listMout(obj) {
    if (!obj.querySelector('input[type="checkbox"]').checked) {
    	obj.style.backgroundColor = m_strColorDefault;
    }
}

var listContentArry = new Array();
var listSubContentArry = new Array();
var listEventCheckbox = false;
var listSubEventCheckbox = false;
var PressShiftKey = false;
var PressCtrlKey = false;

function event_listclick(obj) {
    if (listEventCheckbox) {
    	listEventCheckbox = false;
    	return;
    }
    
    var listContentArryLength = listContentArry.length;
    
    if (document.getElementById("Checkbox1").checked) {
        var TemplistArray = new Array();
        
        if (obj.querySelector('input[type="checkbox"]').checked) {
        	
            for (var i = 0; i < listContentArryLength; i++) {
                if (obj.getAttribute("id") == listContentArry[i]) {
                    obj.childNodes.item(0).childNodes.item(0).checked = false;
                    obj.style.backgroundColor = m_strColorDefault;
                } else {
                    TemplistArray[TemplistArray.length] = listContentArry[i];
                }
            }
            
            listContentArry = TemplistArray;
        } else {
            obj.querySelector('input[type="checkbox"]').checked = true;
            obj.style.backgroundColor = m_strColorSelect;
            
            listContentArry[listContentArry.length] = obj.getAttribute("id");
        }
    } else {
    	
        if (!PressShiftKey && !PressCtrlKey && listContentArry.length > 0) {
        	
            for (var Cnt = 0 ; Cnt < listContentArryLength; Cnt++) {
                _RowObject = document.getElementById(listContentArry[Cnt]);
                _RowObject.style.backgroundColor = m_strColorDefault;
                _RowObject.childNodes.item(0).childNodes.item(0).checked = false;
            }
            
            listContentArry = new Array();
        }
        
        if (PressShiftKey) {
        	
            for (var Cnt = 0 ; Cnt < listContentArryLength; Cnt++) {
                _RowObject = document.getElementById(listContentArry[Cnt]);
                _RowObject.style.backgroundColor = m_strColorDefault;
                _RowObject.childNodes.item(0).childNodes.item(0).checked = false;
            }
            
            listContentArry = new Array();
            var prelistContent = _RowObject.getAttribute("id");
            _RowObject = obj;

            var curlistContent = obj.getAttribute("id");
            var prePoint = parseInt(prelistContent.replace("Maillist_", ""));
            var curPoint = parseInt(curlistContent.replace("Maillist_", ""));
            
            if (prePoint > curPoint) {
            	var temp = prePoint;
            	
            	prePoint = curPoint;
            	curPoint = temp;
            }

            for (var Cnt = prePoint; Cnt <= curPoint; Cnt++) {
                _RowObject = document.getElementById("Maillist_" + Cnt);
                _RowObject.style.backgroundColor = m_strColorSelect;
                _RowObject.childNodes.item(0).childNodes.item(0).checked = true;
                
                listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
            }

        } else {
            _RowObject = obj;
            
            if (_RowObject.querySelector('input[type="checkbox"]').checked) {
                _RowObject.style.backgroundColor = m_strColorDefault;
                _RowObject.querySelector('input[type="checkbox"]').checked = false;
                
                listContentArry = ArrayDelete(listContentArry, _RowObject.id);
            } else {
                _RowObject.style.backgroundColor = m_strColorSelect;
                _RowObject.querySelector('input[type="checkbox"]').checked = true;
                
                listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
            }
        }
    }
}

function event_listCheckboxclick(obj) {
    if (obj.checked) {
        obj.closest('tr').style.backgroundColor = m_strColorSelect;
        listContentArry[listContentArry.length] = obj.parentElement.parentElement.getAttribute("itemid");
    } else {
        var TemplistArray = new Array();
        
        for (var i = 0; i < listContentArry.length; i++) {
        	
            if (obj.closest('tr').getAttribute("itemid") == listContentArry[i]) {
                obj.closest('tr').style.backgroundColor = m_strColorDefault;
            } else {
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
        if (TargetArray[i] != DeleteNodeStr) {
            TempArray[TempArray.length] = TargetArray[i];
        }
    }
    
    TargetArray = TempArray;
    return TargetArray;
}

function preparedTD(TR, width, align, valign, innerHTML, title, textmode, nopadding, styleStr) {
    if (navigator.userAgent.indexOf('Firefox') != -1) {
        var td = TR.insertCell(TR.childNodes.length);
    } else if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1) {
        var td = TR.insertCell(TR.childNodes.length);
    } else {
        var td = TR.insertCell();
    }

    if (typeof styleStr != "undefined") {
    	td.style.cssText = styleStr + ( (!td.getAttribute("style")) ? "" : td.getAttribute("style") );
    }
    
    if (width != "") {
        td.style.width = width;
    }

    td.style.overflow = "hidden";
    td.style.textOverflow = "ellipsis";
    td.style.whiteSpace = "nowrap";
    td.align = align;
    td.noWrap = true;
    
    if (innerHTML == "<img src='/images/ImgIcon/view-flag.gif' border=0>" || innerHTML == "<img src='/images/ImgIcon/icon-flag.gif' border=0>") {
    	td.onclick = function (event) { 
    		event.stopPropagation(); 
    		event_flag(this); 
    	};
    }
    if (nopadding) {
        td.style.padding = "0px";
    }

    if (typeof (title) != "undefined") {
        td.title = title;
    }

    if (textmode == "1") {
    	
        if(CrossYN()) {
            td.textContent = innerHTML;
        } else {
            td.innerText = innerHTML;
        }
    } else {
        td.innerHTML = innerHTML;
    }
}

function callback() {
    start_search();
}

function view_click() {
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var conWidth = pwidth * 0.8;
    
    if (conWidth > minimumWidth) {
        conWidth = minimumWidth;
    }
    
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - minimumWidth) / 2;
    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
    
    if (this.parentname == ("/" + strLang65)) {
    	var requestUrl = "/ezEmail/mailWrite.do?URL=" + encodeURIComponent(this.getAttribute("targeturl")) + "&cmd=EDIT";
    	
    	if (shareId != "") {
    		requestUrl += "&shareId=" + encodeURIComponent(shareId);
    	}
    	
    	window.open(requestUrl, "", feature);
    } else {
    	var requestUrl = "/ezEmail/mailRead.do?URL=" + encodeURIComponent(this.getAttribute("targeturl")) + "&SEARCHPAGE=1&CONTENTCLASS=" + this.getAttribute("contentclass");
    	
    	if (shareId != "") {
    		requestUrl += "&shareId=" + encodeURIComponent(shareId);
    	}
    	
    	window.open(requestUrl, "", feature);
    }
    
    if (this.getAttribute("read") == "0") {
    	this.childNodes.item(2).childNodes.item(0).src = "/images/ImgIcon/icon-msg-read.gif";
    	this.setAttribute("read", "1");
    	this.style.fontWeight = "normal";
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
function event_flag(obj) {
    var temp_listContentArry = listContentArry;
    listContentArry = [GetAttribute(obj.parentElement, "id")];
    toggle_flag();
//     listContentArry = temp_listContentArry;
}

var flagXmlHttp;
function toggle_flag() {
    if (listContentArry.length == 0 && listSubContentArry.length == 0 && currentFixingId == null) {
        alert(strLang42);
        return;
    }
    var pSelectItem;
    if (listContentArry.length > 0) {
        if (listContentArry.length > 1) {
            pSelectItem = "";
            for (var i = 1; i <= listContentArry.length; i++) {
                pSelectItem += listContentArry[i];
            }
        }
        else
            pSelectItem = document.getElementById(listContentArry[listContentArry.length - 1]).getAttribute("id") + ";";
	} else if (listSubContentArry.length > 0) {
		pSelectItem = document.getElementById(listSubContentArry[listSubContentArry.length - 1]).getAttribute("id") + ";";
	} else {
		pSelectItem = currentFixingId.getAttribute("id") + ";";;
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

    var url = "/ezEmail/mailSetFlag.do";
    
	if (typeof(shareId) != "undefined" && shareId != "") {
		url += "?shareId=" + encodeURIComponent(shareId);
	}
    
    try {
        flagXmlHttp.open("POST", url, true);
        flagXmlHttp.onreadystatechange = event_toggle_flag_end;
        flagXmlHttp.send(xmlDom);
        
        // 20200428 조진호 - 메일 리스트에서 체크박스를 이용한 행위 뒤 체크박스가 풀리도록 추가
        // if (listContentArry.length > 0) {
        //     for (var i = 1; i <= listContentArry.length; i++) {
        //         document.getElementById(listContentArry[listContentArry.length - i]).children[0].children[0].checked = false;
        //     }
        // }
    }
    catch (e) {console.log(e);}
}
function event_toggle_flag_end() {
    if (flagXmlHttp != null && flagXmlHttp.readyState == 4) {
        if (flagXmlHttp.status < 200 || flagXmlHttp.status > 300) {
            flagXmlHttp = null;
            alert("ERROR");
        }
        else {
        	if (flagXmlHttp.responseText != "NEW" && flagXmlHttp.responseText != "DEL") {
        		alert("ERROR");
        	}
        }
    } else {
    	start_search();
    }
}

function searchedMailExportZip() {
    var ContentObject = document.getElementById("maillist");
    var attachStatus = "all";
	var andorStatus = "and";
	var end = parseInt(ContentObject.getAttribute("maxcount"));
	var maxCount = end;
	socketUserkey = mailbox_getUserKey();

    if(document.querySelector("input[name=attachment]:checked").value != null ){
        attachStatus = document.querySelector("input[name=attachment]:checked").value;
    }

    if(document.querySelector("input[name=andor]:checked").value != null ){
        andorStatus = document.querySelector("input[name=andor]:checked").value;
    }

	for (var i = 0 ; i < searchCArray.length; i++ ){
        searchKArray[i] = ReplaceText(searchKArray[i], "&", "&amp;");
        searchKArray[i] = ReplaceText(searchKArray[i], "<", "&lt;");
        searchKArray[i] = ReplaceText(searchKArray[i], ">", "&gt;");
        searchKArray[i] = ReplaceText(searchKArray[i], "'", "''");
        searchRequiredKeyword.push(searchKArray[i]);
        searchRequiredCategory.push(searchCArray[i]);
    }

	var jsonData = {"MAILFOLDER" : document.getElementById('select2').value,
					"KEYWORD" : searchRequiredKeyword,
					"CATEGORY" : searchRequiredCategory,
					"STARTDATE" : startDate,
					"ENDDATE" : endDate,
					"ATTACHSTATUS" : attachStatus,
					"ANDORSTATUS" : andorStatus,
					"SHAREID" : shareId,
					"MAXCOUNT" : maxCount,
					"USERKEY" : socketUserkey
					};

    var _url = "/ezEmail/searchedMailExportZipForAll.do";

 	ShowMailProgressNew();
	ShowPercent(0);
	mailboxProgressFun(true, socketUserkey, (progress, state, stateDescription) => {
        if (!state) {
            return;
        }

        if (state === "CANCEL") {
            console.log('User Cancel');
        } else if (state !== "") {
            var fullpath = "/ezEmail/downloadMailZip.do?temp=" + stateDescription + "&encryptPw=" + "";

            if (typeof(shareId) != "undefined" && shareId != "") {
                fullpath += "&shareId=" + encodeURIComponent(shareId);
            }

            AttachDownFrame.location.href = fullpath;
            AttachDownFrame.target = "_blank";
        } else {
            alert(strLang104);
        }

        HiddenMailProgressNew();
        mailboxProgressFun(false);
    });

	$.ajax({
		cache: false,
		method: "post",
		url: _url,
		data: JSON.stringify(jsonData),
		contentType : "application/json",
		error: function() {
			alert(strLang321);
		}
	});
}
