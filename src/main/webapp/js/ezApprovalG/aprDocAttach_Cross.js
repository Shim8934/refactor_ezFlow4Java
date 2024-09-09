function getDocType() {
    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();
    var ParaName, ParaValue
    var Cnt, oOption
    var index, i;

    var objRoot, objNode;

    objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "NODE", pDeptID);

    xmlhttp.open("POST", "/ezApprovalG/mgetDeptUseDocType.do?orgCompanyID="+orgCompanyID, false);
    xmlhttp.send(xmlpara);

    xmlRtn = loadXMLString(xmlhttp.responseText);
    objNode = GetChildNodes(xmlRtn.documentElement);
    index = document.getElementById("selSContName").length;

    if (index > 0) {
        for (i = index; i > 0; i--) {
            document.getElementById("selSContName").remove(i - 1);
        }
    }

    for (Cnt = 0; Cnt < objNode.length - 1; Cnt++) {
        Add_ContType(getNodeText(objNode[Cnt + 1]), getNodeText(objNode[Cnt]));
        Cnt = Cnt + 1;
    }
}

function Add_ContType(Name, ID) {
    var oOption = document.createElement("OPTION");
    setNodeText(oOption , Name);
    oOption.value = ID;

    if (CrossYN())
        document.getElementById("selSContName").appendChild(oOption);
    else
        document.getElementById("selSContName").add(oOption);
}

function getDocList() {
    if (pChackYN == "FALSE") {
        curpage = 1;
        nowblock = 0;
        totalPage = 0;
    }

    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();
    var ParaName, ParaValue;
    var Cnt, oOption;
    var objRoot, objNode;

    objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "NODE", selSContName.value);
    createNodeAndInsertText(xmlpara, objNode, "BlockNum", curpage);
    createNodeAndInsertText(xmlpara, objNode, "PageSize", PageSize);
    createNodeAndInsertText(xmlpara, objNode, "SortHeader", SortHeader == null ? "" : SortHeader);
    createNodeAndInsertText(xmlpara, objNode, "sortType", sortType);

    xmlhttp.open("POST", "/ezApprovalG/aprDocAttachList.do?orgCompanyID="+orgCompanyID, false);
    xmlhttp.send(xmlpara);

    Resultxml = loadXMLString(xmlhttp.responseText);
    if (Resultxml != null) {
        ListViewXml = Resultxml.getElementsByTagName("LISTVIEWDATA");
        NodeList = Resultxml.getElementsByTagName("ROW");
        NodeList2 = Resultxml.getElementsByTagName("TOTALCNT");
        Headers = Resultxml.getElementsByTagName("HEADER");
        NodeListLen = 0;

        if (NodeList2 != null) {
            if (NodeList2[0].hasChildNodes())
                NodeListLen = NodeList2[0].childNodes[0].nodeValue;
            else
                NodeListLen = 0;
        }

        document.getElementById("lvSDoc").innerHTML = "";

        var listview = new ListView();
        listview.SetID("lvSDocList");
        listview.SetMulSelectable(false);
        listview.SetWidthFlag(false);
        listview.SetRowOnDblClick("btnIns_onclick");
        listview.SetTableWidth(350 - 14);
        listview.DataSource(ListViewXml[0]);
        listview.DataBind("lvSDoc");

        pagingCount(curpage, nowblock);
        setDatarowSerialNumber();
        setHeaderEventHandler();
    }

    pChackYN = "FALSE"
}

function setHeaderEventHandler() {
    let headRow = document.getElementById("lvSDocList").querySelector("thead");

    setHeaderCursorPointer(headRow);

    headRow.addEventListener("click", (e) => {
        pChackYN = "TRUE";

        sortList(e);
    });
}

function setHeaderCursorPointer(headRow) {
    headRow.style.cursor = "pointer";
}

function sortList(e) {
    let targetID = e.target.id;

    if (SortHeader !== document.getElementById(targetID).getAttribute("colname")) {
        SortHeader = document.getElementById(targetID).getAttribute("colname");
        sortType = "asc";
    } else {
        sortType = sortType === "asc" ? "desc" : "asc";
    }

    if (SortHeader === "SN") {
        return;
    }

    getDocList();
}

function setDatarowSerialNumber() {
    let cnt = 0;
    let sn = 1;
    let documetBuffer;
    let tdBuffer;

    while ((documetBuffer = document.getElementById("lvSDocList_TR_" + cnt++)) != null) {
        let tdCnt = 0;

        while ((tdBuffer = documetBuffer.children[tdCnt++]) != null) {
            if (tdBuffer.getAttribute("headername") === "SN") {
                tdBuffer.innerText = sn++;

                break;
            }
        }
    }
}

function DocMove() {
    var xmlpara = createXmlDom();
    var selRow;
    var count1, pCount;
    var length, SDocID, strAttachList, objRoot, objNode, objChildNode;

    var listview = new ListView();
    listview.LoadFromID("lvSDocList");

    var Doclistview = new ListView();
    Doclistview.LoadFromID("lvTDocList");

    length = listview.GetSelectedRows().length;
    Doclength = Doclistview.GetDataRows().length;

    if (length <= 0) {
    	alert(strLang257);
    }
    else {
    	if (Doclength == 1 && Doclistview.GetDataRows()[0].id == "lvTDocList_TR_noItems") {
            Doclistview.DeleteRow(Doclistview.GetDataRows()[0].id);
            Doclength--;
        }
    	
        DocInfo = listview.GetSelectedRows()[0];

        for (count1 = 0; count1 < length; count1++) {
            selRow = listview.GetSelectedRows()[count1];
            if (selRow && DuplicateCheck(GetAttribute(selRow, "DATA2"))) {
                var row = Doclistview.AddRow(Doclength);
                SDocID = GetAttribute(selRow, "DATA1");
                objRoot = createNodeInsert(xmlpara, objRoot, "ROW");
                objNode = createNodeAndAppandNode(xmlpara, objRoot, objNode, "CELL");
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "VALUE", "【" + GetAttribute(selRow, "DATA99") + "】" + getNodeText(selRow.cells[2]));
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA1", GetAttribute(selRow, "DATA2"));
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA2", "");
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA3", pDocID);
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA4", pUserID);
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA5", arr_userinfo[13]);
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA6", pDeptID);
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA7", arr_userinfo[15]);
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA8", arr_userinfo[11]);
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA9", "N");
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA10", "【" + GetAttribute(selRow, "DATA99") + "】" + getNodeText(selRow.cells[2]));
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA11", arr_userinfo[12]);
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA12", arr_userinfo[14]);
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA13", arr_userinfo[16]);

                Doclistview.AddDataRow(row, xmlpara);
            }
        }
    }
}

function AttachList() {
	var result = "";
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getAttachInfo.do",
		data : {
			docID : pDocID,
			orgCompanyID : orgCompanyID
		},
		success: function(xml){
			result = xml;
		}        			
	});
    document.getElementById("lvTDoc").innerHTML = "";

    var listview = new ListView();
    listview.SetID("lvTDocList");
    listview.SetMulSelectable(false);
    listview.SetWidthFlag(false);
    listview.SetRowOnClick("lvTDoc_onSel_Click");
    listview.SetRowOnDblClick("btndel_onclick");
    listview.SetTableWidth(350 - 14);
    listview.DataSource(loadXMLString(result));
    listview.DataBind("lvTDoc");
}
function orgAttachList(orgDocId) {
	var result = "";
	var returnXml = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getAttachInfo.do",
		data : {
			docID : orgDocId,
			mode : "END"
		},
		success: function(xml){
			result = xml;
		}        			
	});
	
	returnXml = loadXMLString(result);
	return returnXml;
}

function delAttachDoc() {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/delAttachDoc.do",
		data : {
			docID : pDocID
		},
		success: function(text){
			result = text;
		}        			
	});
	
    return result;
}

function DocMoveParser() {
    var count1;
    var length;
    var rtnXML;

    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();
    var objRoot, objNode, objChildNode;

    objRoot = createNodeInsert(xmlpara, objRoot, "ROWS");

    var listview = new ListView();
    listview.LoadFromID("lvTDocList");

    length = listview.GetDataRows().length;
    for (i = 0; i < length; i++) {
        objNode = createNodeAndAppandNode(xmlpara, objRoot, objNode, "ROW");
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA1", GetAttribute(listview.GetDataRows()[i], "DATA1"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA2", GetAttribute(listview.GetDataRows()[i], "DATA2"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA3", GetAttribute(listview.GetDataRows()[i], "DATA3"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA4", GetAttribute(listview.GetDataRows()[i], "DATA4"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA5", GetAttribute(listview.GetDataRows()[i], "DATA5"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA6", GetAttribute(listview.GetDataRows()[i], "DATA6"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA7", GetAttribute(listview.GetDataRows()[i], "DATA7"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA8", GetAttribute(listview.GetDataRows()[i], "DATA8"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA9", GetAttribute(listview.GetDataRows()[i], "DATA9"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA10", GetAttribute(listview.GetDataRows()[i], "DATA10"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA11", GetAttribute(listview.GetDataRows()[i], "DATA11"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA12", GetAttribute(listview.GetDataRows()[i], "DATA12"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA13", GetAttribute(listview.GetDataRows()[i], "DATA13"));
    }

    xmlhttp.open("Post", "/ezApprovalG/updateDocAttach.do?orgCompanyID="+orgCompanyID, false);
    xmlhttp.send(xmlpara);

    var rtnval = xmlhttp.responseText;
    var rtnXML;
    

    if (xmlhttp != null && xmlhttp.readyState == 4) {
		if (xmlhttp.status == 200 && rtnval == "TRUE") {
			rtnXML = getXmlString(xmlpara);
		} else {
			rtnXML = "<ROWS></ROWS>";
		}
	} else {
		rtnXML = "<ROWS></ROWS>";
	}

    return rtnXML;
}

function GetDocSearch() {
    DocListType = "GetDocSearch";
    var pDocstate = "A02011";

    if (pChackYN == "FALSE") {
        curpage = 1;
        nowblock = 0;
        totalPage = 0;
        OrderOption = "";
        OrderCell = "";
    }

    var xmlpara = createXmlDom();
    var objRoot, objNode, i, nodeName;

    objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");

    for (i = 0; i < 12; i++) {
        nodeName = "Param" + i;
        if (typeof (condition[i]) == "undefined")
            createNodeAndInsertText(xmlpara, objNode, nodeName, "");
        else
            createNodeAndInsertText(xmlpara, objNode, nodeName, condition[i]);
    }
    createNodeAndInsertText(xmlpara, objNode, "Param12", selSContName.value);
    createNodeAndInsertText(xmlpara, objNode, "Param13", arr_userinfo[1]);
    createNodeAndInsertText(xmlpara, objNode, "Param14", arr_userinfo[4]);
    createNodeAndInsertText(xmlpara, objNode, "Param15", "DETAIL");
    createNodeAndInsertText(xmlpara, objNode, "PageNum", curpage);
    createNodeAndInsertText(xmlpara, objNode, "PageSize", PageSize);
    createNodeAndInsertText(xmlpara, objNode, "DocState", "");
    createNodeAndInsertText(xmlpara, objNode, "searchStatus", "DOCATT");
    createNodeAndInsertText(xmlpara, objNode, "orderCell", OrderCell);
    createNodeAndInsertText(xmlpara, objNode, "orderOption", OrderOption);
    createNodeAndInsertText(xmlpara, objNode, "pSubQuery", "");
    createNodeAndInsertText(xmlpara, objNode, "SearchQuery", SQLPARADATA);
    
    xmlhttp.open("POST", "/ezApprovalG/getFormSearchDocListS.do", false);
    xmlhttp.onreadystatechange = getsearchDocList_after;
    xmlhttp.send(xmlpara);
}

function getsearchDocList_after() {
    if (xmlhttp == null || xmlhttp.readyState != 4) return;

    try {
        Resultxml = loadXMLString(xmlhttp.responseText);

        if (Resultxml != null) {
            ListViewXml = Resultxml.getElementsByTagName("LISTVIEWDATA");
            NodeList = Resultxml.getElementsByTagName("ROW");
            NodeList2 = Resultxml.getElementsByTagName("TOTALCNT");
            Headers = Resultxml.getElementsByTagName("HEADER");
            NodeListLen = 0;

            if (NodeList2 != null) {
                if (NodeList2[0].hasChildNodes())
                    NodeListLen = NodeList2[0].childNodes[0].nodeValue;
                else
                    NodeListLen = 0;
            }

            document.getElementById("lvSDoc").innerHTML = "";

            var listview = new ListView();
            listview.SetID("lvSDocList");
            listview.SetMulSelectable(false);
            listview.SetWidthFlag(false);
            listview.SetRowOnDblClick("btnIns_onclick");
            listview.SetTableWidth(350 - 14);
            listview.DataSource(ListViewXml[0]);
            listview.DataBind("lvSDoc");

            pagingCount(curpage, nowblock);

            pChackYN = "FALSE"
        }
        else {
            prompt(xmlhttp.responseText, xmlhttp.responseText);
        }
    }
    catch (e) { }
}

function MakeSubCondition() {
    var TYPE = "";
    var DATA = "";

    if (condition[0] != "") {
        TYPE += "DOCNO;"
        DATA += "<DOCNO>" + condition[0] + "</DOCNO>";
    }

    if (condition[1] != "") {
        TYPE += "DOCTITLE;"
        DATA += "<DOCTITLE>" + condition[1] + "</DOCTITLE>";
    }

    if (condition[2] != "") {
        TYPE += "WRITERNAME;"
        DATA += "<WRITERNAME>" + condition[2] + "</WRITERNAME>";
    }


    if (condition[3] != "") {
        TYPE += "STARTDATEAF;"
        DATA += "<STARTDATEAF>" + condition[3] + "</STARTDATEAF>";
    }

    if (condition[4] != "") {
        TYPE += "STARTDATEBF;"
        DATA += "<STARTDATEBF>" + condition[4] + "</STARTDATEBF>";
    }

    if (condition[5] != "") {
        TYPE += "ENDDATEAF;"
        DATA += "<ENDDATEAF>" + condition[5] + "</ENDDATEAF>";
    }

    if (condition[6] != "") {
        TYPE += "ENDDATEBF;"
        DATA += "<ENDDATEBF>" + condition[6] + "</ENDDATEBF>";
    }

    if (condition[9] != "") {
        TYPE += "FORMID;"
        DATA += "<FORMID>" + condition[9] + "</FORMID>";
    }

    if (condition[11] != "") {
        TYPE += "WRITERDEPTNAME;"
        DATA += "<WRITERDEPTNAME>" + condition[11] + "</WRITERDEPTNAME>";
    }

    if (condition[12] != "") {
        TYPE += condition[12];
        DATA += condition[13];
    }

    // 2021-03-15 키워드 검색 추가 - 박기범
    if (condition[24] != "" && condition[24] !== undefined )
    {
        TYPE += condition[24].slice(0,5);
        DATA += "<KEYWORD>" + condition[24].slice(5) + "</KEYWORD>";
    }

    SQLPARADATA = "<ROOT><TYPE>" + TYPE + "</TYPE><DATA>" + DATA + "</DATA></ROOT>";
}

function DuplicateCheck(AttachDocID) {
    var RtnVal = true;
    var listview = new ListView();
    listview.LoadFromID("lvTDocList");
    var selRow = listview.GetDataRows();
    if (selRow.length > 0) {
        for (i = 0; i < selRow.length; i++) {
            if (AttachDocID == trim_Cross(GetAttribute(selRow[i], "DATA1"))) {
                RtnVal = false;
                break;
            }
        }
    }
    listview = null;
    return RtnVal;
}

// START
var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN()) {
        ezapralert_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
        DivPopUpShow(330, 205, url);
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
}

function OpenAlertUI_Complete() {
    DivPopUpHidden();
}
// END

function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
    try {
        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;

        var left = 0;
        var top = 0;

        if (window.screen.width > 800) {
            var pleftpos;

            pleftpos = parseInt(width) - 967;
            heigth = parseInt(heigth) - 30;
            if (CrossYN())
                heigth = parseInt(heigth) - 25;

            if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
                heigth = parseInt(heigth) - 40;
            width = parseInt(width) - pleftpos;
            left = pleftpos / 2;
        }
        else {
            heigth = parseInt(heigth) - 30;
            if (CrossYN())
                heigth = parseInt(heigth) - 25;

            if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
                heigth = parseInt(heigth) - 40;
            width = parseInt(width) - 10;
        }

        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);

    }
    catch (e) {
        alert("openwindow :: " + e.description);
    }
}