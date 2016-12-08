function InitlvDocTypeList() {
    var xmlRtn = createXmlDom();
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/admin/ezApproval/MLgetDoctype.do",
		data : {
			comID  : P_companyID
		},
		success: function(xml){
            xmlRtn = loadXMLString(xml);
		}
	});
    
    document.getElementById('lvDocTypeList').innerHTML = "";

    listview.SetID("lvSDocForm");
    listview.SetMulSelectable(false);
    listview.SetRowOnDblClick("lvDocTypeList_onSel_DBclick");
    listview.DataSource(xmlRtn);
    listview.DataBind("lvDocTypeList");

}

function InitlvContTypeList() {
    document.getElementById('lvContDocList').innerHTML = "";
    var i;
    var xmlRtn = createXmlDom();
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/admin/ezApproval/getContDocType.do",
		data : {
			comID  : P_companyID
		},
		success: function(xml){
            xmlRtn = loadXMLString(xml);
		}
	});

    var Row = xmlRtn.getElementsByTagName("LISTVIEWDATA")[0].getElementsByTagName("ROWS")[0].getElementsByTagName("ROW");
    for (var count = 0; count < Row.length; count++) {
    	stringToXml(count, xmlRtn, Row.length);
    }

    listview2.SetID("lvTDocForm");
    listview2.SetMulSelectable(true);
    listview2.SetRowOnClick("lvContDocList_onSel_Click");
    listview2.SetRowOnDblClick("lvContDocList_onSel_DBclick");
    
    xmlRtn = loadXMLString(pparsingXML);
    listview2.DataSource(xmlRtn);
    listview2.DataBind("lvContDocList");

    pXML = "<PARAMETER><CONTTYPES>";
    	
    for (i = 0; i <= Row.length - 1; i++) {
        pXML = pXML + "<CONTTYPE>";
        pXML = pXML + "<STATEID" + i + ">" + SelectSingleNodeValue(Row[i].getElementsByTagName("CELL")[0], "DATA2") + "</STATEID" + i + ">";
        pXML = pXML + "<DOCTYPEID" + i + ">" + SelectSingleNodeValue(Row[i].getElementsByTagName("CELL")[1], "DATA1") + "</DOCTYPEID" + i + "></CONTTYPE>";
    }
    pXML = pXML + "</CONTTYPES></PARAMETER>";
}

function stringToXml(count, oXmlRtn, lastIdx) {
    var pHeader = oXmlRtn.getElementsByTagName("HEADERS")[0].getElementsByTagName("HEADER");
    var pHeader1 = SelectSingleNodeValue(pHeader[0], "NAME");
    var pHeader2 = SelectSingleNodeValue(pHeader[1], "NAME");
    var Row = oXmlRtn.getElementsByTagName("LISTVIEWDATA")[0].getElementsByTagName("ROWS")[0].getElementsByTagName("ROW");
    
    if (count < 1) {
        pparsingXML = "<LISTVIEWDATA><HEADERS>";
        pparsingXML = pparsingXML + "<HEADER><NAME>" + pHeader1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
        pparsingXML = pparsingXML + "<HEADER><NAME>" + pHeader2 + "</NAME><WIDTH>100</WIDTH></HEADER>";
        pparsingXML = pparsingXML + "</HEADERS><ROWS><ROW><CELL>";
        pparsingXML = pparsingXML + "<VALUE>" + SelectSingleNodeValue(Row[count].getElementsByTagName("CELL")[0], "VALUE") + "</VALUE>";
        pparsingXML = pparsingXML + "<DATA1>" + SelectSingleNodeValue(Row[count].getElementsByTagName("CELL")[0], "DATA1") + "</DATA1>";
        pparsingXML = pparsingXML + "</CELL><CELL>";
        pparsingXML = pparsingXML + "<VALUE>" + SelectSingleNodeValue(Row[count].getElementsByTagName("CELL")[1], "VALUE") + "</VALUE>";
        pparsingXML = pparsingXML + "<DATA1>" + SelectSingleNodeValue(Row[count].getElementsByTagName("CELL")[1], "DATA1") + "</DATA1>";
        pparsingXML = pparsingXML + "</CELL></ROW>";
    } else {
        pparsingXML = pparsingXML + "<ROW><CELL>";
        pparsingXML = pparsingXML + "<VALUE>" + SelectSingleNodeValue(Row[count].getElementsByTagName("CELL")[0], "VALUE") + "</VALUE>";
        pparsingXML = pparsingXML + "<DATA1>" + SelectSingleNodeValue(Row[count].getElementsByTagName("CELL")[0], "DATA1") + "</DATA1>";
        pparsingXML = pparsingXML + "</CELL><CELL>";
        pparsingXML = pparsingXML + "<VALUE>" + SelectSingleNodeValue(Row[count].getElementsByTagName("CELL")[1], "VALUE") + "</VALUE>";
        pparsingXML = pparsingXML + "<DATA1>" + SelectSingleNodeValue(Row[count].getElementsByTagName("CELL")[1], "DATA1") + "</DATA1>";
        pparsingXML = pparsingXML + "</CELL></ROW>";
    }

    if (count == lastIdx - 1)
        pparsingXML = pparsingXML + "</ROWS></LISTVIEWDATA>";

    return pparsingXML;
}

function DocTypeIns() {
    listview.LoadFromID("lvSDocForm");
    listview2.LoadFromID("lvTDocForm");
    var ContDocRow, ContDocRow, DocTypeName, DocTypeID;
    var Count2 = listview2.GetSelectedRows().length;

    if (listview.GetSelectedRows().length <= 0) {
        alert(strLang406);
    }
    else {
        DocTypeRow = listview.GetSelectedRows();
        DocTypeName = DocTypeRow[0].cells[0].innerHTML;
        DocTypeID = GetAttribute(DocTypeRow[0], "DATA1");

    }

    if (Count2 <= 0) {
        alert(strLang407);
    }
    else {
        for (i = 0; i <= Count2 - 1; i++) {
            ContDocRow = listview2.GetSelectedRows()[i];

            ContDocRow.cells[1].innerHTML = DocTypeName;

            count = listview2.GetSelectedIndexes().split(",")[i];
            Arr_ContType1[count] = count;
            Arr_ContType2[count] = DocTypeID;
        }
    }
}

function DocTypeDel() {

    listview.LoadFromID("lvSDocForm");
    listview2.LoadFromID("lvTDocForm");
    var ContDocRow, ContDocRow;

    if (listview2.GetSelectedRows().length > -1) {
        for (var i = 0 ; i < listview2.GetSelectedRows().length ; i++) {
            ContDocRow = listview2.GetSelectedRows()[i];


            ContDocRow.cells[1].innerHTML = " ";


            count = listview2.GetSelectedIndexes().split(",")[i];

            Arr_ContType1[count] = count;
            Arr_ContType2[count] = "";
        }
    }
    else {
        alert(strLang408);
    }
}

function ContSave() {
    var i, j, tXML, Flag;
    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();
    var strXML = XMLParse();

    xmlpara.async = false;
    xmlpara = loadXMLString(strXML);
    var xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "/admin/ezApproval/updateContDoctype.do", false);
    xmlhttp.send(xmlpara);
    xmlRtn = loadXMLString(xmlhttp.responseText);

    Flag = xmlRtn.getElementsByTagName("RESULT")[0].childNodes[0].nodeValue;

    if (Flag == "TRUE") {
        alert(strLang410);
        InitlvContTypeList();
    }
    else
        alert(strLang399);
}

function XMLParse() {
    var flag = false;
    chkVal = false;
    var xmlRtn = createXmlDom();
    xmlRtn = loadXMLString(pXML);
    var Row = xmlRtn.getElementsByTagName("PARAMETER")[0].getElementsByTagName("CONTTYPES")[0].getElementsByTagName("CONTTYPE");
    tXML = "<PARAMETER><CONTTYPES>"

    for (i = 0; i <= Row.length - 1; i++) {
        tXML = tXML + "<CONTTYPE>";
        tXML = tXML + "<STATEID" + i + ">" + SelectSingleNodeValue(Row[i], "STATEID" + i) + "</STATEID" + i + ">";
        if (Arr_ContType1.length > 0) {
            for (j = 0; j < Arr_ContType1.length; j++) {
                if (Arr_ContType1[j] == i) {
                    flag = true;
                    tXML = tXML + "<DOCTYPEID" + i + ">" + Arr_ContType2[i] + "</DOCTYPEID" + i + "></CONTTYPE>";
                }
            }

            if (flag == false) {
                tXML = tXML + "<DOCTYPEID" + i + ">" + SelectSingleNodeValue(Row[i], "DOCTYPEID" + i) + "</DOCTYPEID" + i + "></CONTTYPE>";
            }
        }
        else {
            tXML = tXML + "<DOCTYPEID" + i + ">" + SelectSingleNodeValue(Row[i], "DOCTYPEID" + i) + "</DOCTYPEID" + i + "></CONTTYPE>";
        }
        flag = false
    }

    tXML = tXML + "</CONTTYPES><COMPANYID>" + P_companyID + "</COMPANYID></PARAMETER>"

    return tXML;
}


function Format(pCount, pID) {
    var i = pCount;
    var j = pID.length;
    var k;
    for (k = 1; k == i - j; k++) {
        strID = "0" + pID
    }
    return strID;
}

