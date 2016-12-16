function getDocType(Flag) {
    try {
        var xmlRtn = createXmlDom();
        var Cnt, Cnt2, oOption
        var index, i, j;
        var contID = new Array();
        var name = new Array();
        var deptID = "";

        if (Flag == "SDeptName") {
        	deptID = document.getElementsByName('SDeptName')[0].id;
        } else {
        	deptID = document.getElementsByName('TDeptName')[0].id;
        }
        
        var result = "";
    	
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/admin/ezApproval/MgetDeptUseDocType.do",
    		data : {
    			deptID     : deptID,
    			companyID  : P_CompanyID
    		},
    		success: function(text){
    			result = text;
    		}
    	});

        xmlRtn = loadXMLString(result);
        objNode = xmlRtn.documentElement.childNodes;
        var len = objNode.length;


        if (Flag == "SDeptName") {
            index = document.getElementsByName('selSContName')[0].length;

            if (index > 0) {
                for (i = index ; i > 0 ; i--)
                    document.getElementsByName('selSContName')[0].remove(i - 1);
            }
            if (objNode.length > 0) {
                for (Cnt = 0 ; Cnt < len ; Cnt++) {
                    var nodevalue = xmlRtn.getElementsByTagName("CONTID" + Cnt)[0].childNodes[0].nodeValue;
                    if (nodevalue != null && nodevalue != "" && nodevalue && "undefine") {
                        contID[Cnt] = xmlRtn.getElementsByTagName("CONTID" + Cnt)[0].childNodes[0].nodeValue;
                        name[Cnt] = xmlRtn.getElementsByTagName("NAME" + Cnt)[0].childNodes[0].nodeValue;
                        Add_ContType1(name[Cnt], contID[Cnt]);
                    }
                }
            }
        }
        else {
            index = document.getElementsByName('selTContName')[0].length;

            if (index > 0) {
                for (i = index ; i > 0 ; i--)
                    document.getElementsByName('selTContName')[0].remove(i - 1);
            }
            if (objNode.length > 0) {
                for (Cnt = 0 ; Cnt < len ; Cnt++) {
                    var nodevalue = xmlRtn.getElementsByTagName("CONTID" + Cnt)[0].childNodes[0].nodeValue;
                    if (nodevalue != null && nodevalue != "" && nodevalue && "undefine") {
                        contID[Cnt] = xmlRtn.getElementsByTagName("CONTID" + Cnt)[0].childNodes[0].nodeValue;
                        name[Cnt] = xmlRtn.getElementsByTagName("NAME" + Cnt)[0].childNodes[0].nodeValue;
                        Add_ContType2(name[Cnt], contID[Cnt]);
                    }
                }
            }
        }

    } catch (e) { alert("MoveContainer.js :: getDocType()"); }
}

function Add_ContType1(Name, ID) {
    var oOption = document.createElement("OPTION");
    setNodeText(oOption, Name);
    oOption.value = ID

    var sOption = document.getElementsByName("selSContName")[0];

    if (CrossYN())
        sOption.add(oOption, null);
    else
        sOption.add(oOption);

    oOption = null;
}

function Add_ContType2(Name, ID) {
    var oOption = document.createElement("OPTION");
    setNodeText(oOption, Name);
    oOption.value = ID

    var sOption = document.getElementsByName("selTContName")[0];
    if (CrossYN())
        sOption.add(oOption, null);
    else
        sOption.add(oOption);

    oOption = null;
}

function getDocList() {
    if (CrossYN())
        document.getElementById("PageNum").innerHTML = "";
    else
        setNodeText(document.getElementById("PageNum"),"");
    document.getElementById('lvSDoc').innerHTML = "";
    document.getElementById('lvTDoc').innerHTML = "";

    if (pChackYN == "FALSE") {
        for (i = 0; i < 11; i++)
            SearchCond[i] = "";

        curpage = 1;
        nowblock = 0;
        totalPage = 0;
    }
    else if (pChackYN == "SEARCH") {
        curpage = 1;
        nowblock = 0;
        totalPage = 0;
    }

	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/admin/ezApproval/MgetDocList.do",
		data : {
			node       : ScontID,
			pageNum    : nowblock + 1,
			pageSize   : PageSize,
			companyID  : P_CompanyID,
			docNO      : SearchCond[0],
			docTitle   : SearchCond[1],
			drafter    : SearchCond[2],
			draftFrom  : SearchCond[3],
			draftTo    : SearchCond[4],
			aprFrom    : SearchCond[5],
			aprTo      : SearchCond[6],
			formID     : SearchCond[7],
			deptName   : SearchCond[1]
		},
		success: function(text){
			result = text;
		}
	});
	
    Resultxml = loadXMLString(result);

    if (Resultxml.xml != "") {
        ListView = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA");
        NodeList = SelectNodes(Resultxml, "DOCLIST/LISTVIEWDATA/ROWS/ROW");
        CellList = SelectNodes(Resultxml, "DOCLIST/LISTVIEWDATA/ROWS/ROW/CELL");
        NodeList2 = SelectNodes(Resultxml, "DOCLIST/TOTALCNT");
        Haders = SelectNodes(Resultxml, "DOCLIST/LISTVIEWDATA/HEADERS/HEADER");
        NodeListLen = 0;

        if (NodeList2 != null) {
            if (SelectSingleNodeValueNew(Resultxml, "DOCLIST/TOTALCNT") != "") {
                NodeListLen = SelectSingleNodeValueNew(Resultxml, "DOCLIST/TOTALCNT");
            }
            else
                NodeListLen = 0;

        }
        xmlpara = reBuildXml();
        if (NodeListLen > 10) {
            paging(curpage, nowblock);
            listview2.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));
            listview2.DataBind("lvTDoc");
        }
        else {
            listview.DataSource(xmlpara);
            if (NodeListLen == 0)
                listview.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));
            listview2.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));
            listview.DataBind("lvSDoc");
            listview2.DataBind("lvTDoc");
            pagingCount(curpage, nowblock);
        }
    }
    else {
        if (listview.GetRowCount() > 0) {
            document.getElementById('lvSDoc').innerHTML = "";
            document.getElementById('lvTDoc').innerHTML = "";
            listview.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));
            listview2.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));
            listview.DataBind("lvTDoc");
            listview2.DataBind("lvTDoc");
        }
    }
    pChackYN = "FALSE"
}

function DocMove() {
    var pparsingXML = "";
    var xmlRtn = createXmlDom();
    var selRow = listview.GetSelectedRows();
    var count1;
    var length;
    var objTr;
    var strXML = "";

    listview.LoadFromID("lvSDocForm");
    listview2.LoadFromID("lvTDocForm");

    var select = listview.GetSelectedIndexes();
    var length = listview.GetSelectedIndexes().split(",").length;
    var length2 = listview2.GetRowCount();

    if (select.length <= 0)
        alert(strLang398);
    else {
        lvTDocResize();

        if (length2 > 0)
            if (getNodeText(listview2.GetDataRows()[0].cells[0]) == strLang535)
                listview2.DeleteRow(GetAttribute(listview2.GetDataRows()[0], "id"));

        for (count1 = 0; count1 < length; count1++) {
            var length2 = listview2.GetRowCount();
            var DocID = GetAttribute(selRow[count1], "DATA1");
            var DocName = getNodeText(selRow[count1].cells[1]);
            var DocNum = getNodeText(selRow[count1].cells[0]);

            if (!listview2.ExistRow("DATA1", DocID)) {
                strXML = listAdd(DocNum, DocName, DocID)
                objTr = listview2.AddRow(length2);
                SetAttribute(objTr, "id", "lvTDocForm" + "_TR_" + length2);
                xmlRtn = loadXMLString(strXML);
                listview2.AddDataRow(objTr, xmlRtn);
            }
        }

    }
}

function listAdd(pDocNum, pDocName, pDocID) {
    pparsingXML = "<LISTVIEWDATA><HEADERS>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + text1 + "</NAME><WIDTH>150</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + text2 + "</NAME><WIDTH>300</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "</HEADERS><ROWS><ROW><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(pDocNum) + "</VALUE>";
    pparsingXML = pparsingXML + "<DATA1>" + pDocID + "</DATA1>";
    pparsingXML = pparsingXML + "</CELL><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(pDocName) + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL></ROW>";

    pparsingXML = pparsingXML + "</ROWS></LISTVIEWDATA>";

    return pparsingXML;
}
function MakeXMLString(pOrgString) {
    return ReplaceText(ReplaceText(ReplaceText(pOrgString, "&", "&amp;"), "<", "&lt;"), ">", "&gt;");
}
function ReplaceText(orgStr, findStr, replaceStr) {
    try {
        if (findStr == ".") {
            var a = 0;
            for (a = 0; a < 10; a++)
                orgStr = orgStr.replace(".", replaceStr);
            return orgStr;
        }
        else {
            var re = new RegExp(findStr, "gi");
            return (orgStr.replace(re, replaceStr));
        }
    } catch (e) {
        return orgStr
    }
}
function DocMoveParser() {
    listview2.LoadFromID("lvTDocForm");
    var x_ORGCONTID;
    var count1;
    var length;
    length = listview2.GetRowCount();
    var xmlRtn = createXmlDom();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "ORGCONTID", document.getElementsByName("selSContName")[0].value);
    createNodeAndInsertText(xmlpara, objNode, "CONTID", document.getElementsByName("selTContName")[0].value);
    if (MoveALL.checked == true)
        createNodeAndInsertText(xmlpara, objNode, "MoveALL", "true");
    else
        createNodeAndInsertText(xmlpara, objNode, "MoveALL", "");

    for (count1 = 0; count1 < length; count1++) {
        createNodeAndInsertText(xmlpara, objNode, "DOCID", GetAttribute(listview2.GetDataRows()[count1], "DATA1"));
    }

    return xmlpara;
}

function ContMove() {
    Check = true;
    listview2.LoadFromID("lvTDocForm");
    var length2 = listview2.GetRowCount();
    var count1, selRow;

    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();
    var strXML = DocMoveParser();

    xmlpara = strXML;
    xmlhttp.open("POST", "/admin/ezApproval/moveContainer.do", false);
    xmlhttp.send(xmlpara);

    xmlRtn = createXMLDomFromXmlString(xmlhttp.responseText);

    Flag = xmlRtn.getElementsByTagName("RESULT")[0].childNodes[0].nodeValue;

    if (Flag == "TRUE") {
        alert(strLang415);
        lvTDoc.DataSource = FORMLIST;
    }
    else
        alert(strLang399);

    Check = false;
}

function DocTotalMove() {
    listview.LoadFromID("lvSDocForm");
    listview2.LoadFromID("lvTDocForm");
    var count1;
    var length, length2;
    var strXML = "";
    var objTr;
    var pparsingXML = "";
    var xmlRtn = createXmlDom();

    length = listview.GetRowCount();
    length2 = listview2.GetRowCount();

    var rows = listview.GetDataRows();
    if (length <= 0) {
        alert(strLang400);
    }
    else {
        if (length2 > 0) {
            for (count1 = length2 - 1 ; count1 > -1 ; count1--) {
                listview2.DeleteRow(GetAttribute(listview2.GetDataRows()[count1], "id"));
            }
            for (count1 = 0; count1 < length; count1++) {
                var DocID = GetAttribute(rows[count1], "DATA1");
                var DocName = getNodeText(rows[count1].cells[1]);
                var DocNum = getNodeText(rows[count1].cells[0]);

                strXML = listAdd(DocNum, DocName, DocID)

                objTr = listview2.AddRow(count1);
                SetAttribute(objTr, "id", "lvTDocForm" + "_TR_" + count1);
                xmlRtn = loadXMLString(strXML);
                listview2.AddDataRow(objTr, xmlRtn);
            }
        }
        else {
            for (count1 = 0; count1 < length; count1++) {
                var DocID = GetAttribute(rows[count1], "DATA1");
                var DocName = getNodeText(rows[count1].cells[1]);
                var DocNum = getNodeText(rows[count1].cells[0]);

                strXML = listAdd(DocNum, DocName, DocID)

                objTr = listview2.AddRow(count1);
                SetAttribute(objTr, "id", "lvTDocForm" + "_TR_" + count1);
                xmlRtn = loadXMLString(strXML);
                listview2.AddDataRow(objTr, xmlRtn);
            }
        }
    }
}

function reBuildXml() {
    var xmlpara = createXmlDom();
    var objNode, objRoot, subNode, CellNode, RowsHeader, RowHeader, headerNode;
    objNode = createNodeInsert(xmlpara, objRoot, "LISTVIEWDATA");
    var headersNode = createNodeAndAppandNode(xmlpara, objNode, subNode, "HEADERS");

    for (h = 0; h <= Haders.length - 1; h++) {
        headerNode = createNodeAndAppandNode(xmlpara, headersNode, subNode, "HEADER");

        createNodeAndAppandNodeText(xmlpara, headerNode, subNode, "NAME", SelectSingleNodeValue(Haders[h], "NAME"));
        createNodeAndAppandNodeText(xmlpara, headerNode, subNode, "WIDTH", SelectSingleNodeValue(Haders[h], "WIDTH"));
    }

    RowsHeader = createNodeAndAppandNode(xmlpara, objNode, subNode, "ROWS");

    for (i = 1; i <= NodeListLen; i++) {
        RowHeader = createNodeAndAppandNode(xmlpara, RowsHeader, subNode, "ROW");
        CellNode = createNodeAndAppandNode(xmlpara, RowHeader, subNode, "CELL");
        createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "VALUE", SelectSingleNodeValue(SelectSingleNode(NodeList[i - 1], "CELL"), "VALUE"));
        createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "DATA1", SelectSingleNodeValue(SelectSingleNode(NodeList[i - 1], "CELL"), "DATA1"));
        createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "DATA2", SelectSingleNodeValue(SelectSingleNode(NodeList[i - 1], "CELL"), "DATA2"));

        if (CrossYN() || pNoneActiveX == "YES") {
            var count = 3;
            for (k = 7; k < NodeList[i - 1].childNodes[1].childNodes.length; k++) {
                if (NodeList[i - 1].childNodes[1].childNodes[k].childNodes.length > 0)
                    createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "DATA" + count, NodeList[i - 1].childNodes[1].childNodes[k].childNodes[0].nodeValue);
                else
                    createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "DATA" + count, "");

                k++;
                count++;
            }
        }
        else {
            for (k = 3; k < NodeList[i - 1].childNodes[0].childNodes.length; k++) {
                if (NodeList[i - 1].childNodes[0].childNodes[k].childNodes.length > 0)
                    createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "DATA" + k, NodeList[i - 1].childNodes[0].childNodes[k].childNodes[0].nodeValue);
                else
                    createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "DATA" + k, "");
            }
        }

        var CellNodeSub = new Array();

        if (CrossYN() || pNoneActiveX == "YES") {
            for (k = 3; k < NodeList[i - 1].childNodes.length; k++) {
                if (NodeList[i - 1].childNodes[k].childNodes[1].childNodes.length > 0) {

                    CellNodeSub[k] = createNodeAndAppandNode(xmlpara, RowHeader, subNode, "CELL");
                    var a = SelectSingleNode(NodeList[i - 1], "CELL");
                    createNodeAndAppandNodeText(xmlpara, CellNodeSub[k], subNode, "VALUE", NodeList[i - 1].childNodes[k].childNodes[1].childNodes[0].nodeValue);
                }
                else {
                    CellNodeSub[k] = createNodeAndAppandNode(xmlpara, RowHeader, subNode, "CELL");
                    createNodeAndAppandNodeText(xmlpara, CellNodeSub[k], subNode, "VALUE", "");
                }
                k++;
            }
        }
        else {
            for (k = 1; k < NodeList[i - 1].childNodes.length; k++) {
                if (NodeList[i - 1].childNodes[k].childNodes[0].childNodes.length > 0) {
                    CellNodeSub[k] = createNodeAndAppandNode(xmlpara, RowHeader, subNode, "CELL");
                    var a = SelectSingleNode(NodeList[i - 1], "CELL");
                    createNodeAndAppandNodeText(xmlpara, CellNodeSub[k], subNode, "VALUE", NodeList[i - 1].childNodes[k].childNodes[0].childNodes[0].nodeValue);
                }
                else {
                    CellNodeSub[k] = createNodeAndAppandNode(xmlpara, RowHeader, subNode, "CELL");
                    createNodeAndAppandNodeText(xmlpara, CellNodeSub[k], subNode, "VALUE", "");
                }
            }
        }
    }
    return xmlpara;
}

