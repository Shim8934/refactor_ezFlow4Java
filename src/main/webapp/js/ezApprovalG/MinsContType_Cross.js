function InitlvDocTypeList() {
    var xmlRtn = createXmlDom();
    
    $.ajax({
    	type : "POST",
    	dataType : "html",
    	url : "/admin/ezApprovalG/apprGMLgetDoctype.do",
    	async : false,
    	data : {comID : P_companyID},
    	success : function(result){
    		xmlRtn = loadXMLString(result);
    	    lvDocTypeList.SetID("lvtDocForm");
    	    lvDocTypeList.SetMulSelectable(false);
    	    lvDocTypeList.DataSource(xmlRtn);
    	    lvDocTypeList.DataBind("lvDocTypeList");
    	}
    });
}

function InitlvContTypeList() {
    var i;
    var xmlRtn = createXmlDom();

    $.ajax({
    	type : "POST",
    	dataType : "html",
    	url : "/admin/ezApprovalG/apprGGetContDocType.do",
    	async : false,
    	data : {comID : P_companyID},
    	success : function(result){
    		document.getElementById("lvContDocList").innerHTML = "";

    	    xmlRtn = loadXMLString(result);
    	    lvContDocList.SetID("lvtContForm");
    	    lvContDocList.SetMulSelectable(false);
    	    lvContDocList.DataSource(xmlRtn);
    	    lvContDocList.DataBind("lvContDocList");
    	    
    	    var Row = xmlRtn.getElementsByTagName("LISTVIEWDATA")[0].getElementsByTagName("ROWS")[0].getElementsByTagName("ROW");

    	    pXML = "<PARAMETER><CONTTYPES>";
    	    
    	    for (i = 0; i <= Row.length - 1; i++) {
    	        pXML = pXML + "<CONTTYPE>";
    	        pXML = pXML + "<STATEID" + i + ">" + SelectSingleNodeValue(Row[i].getElementsByTagName("CELL")[0], "DATA1") + "</STATEID" + i + ">";
    	        pXML = pXML + "<DOCTYPEID" + i + ">" + SelectSingleNodeValue(Row[i].getElementsByTagName("CELL")[1], "DATA1") + "</DOCTYPEID" + i + "></CONTTYPE>";
    	    }
    	    pXML = pXML + "</CONTTYPES></PARAMETER>";
    	}
    });
}

function DocTypeIns() {

    lvDocTypeList.LoadFromID("lvtDocForm");
    lvContDocList.LoadFromID("lvtContForm");
    var ContDocRow, ContDocRow, DocTypeName, DocTypeID;
    var Count1 = lvDocTypeList.GetSelectedRows().length;
    var Count2 = lvContDocList.GetSelectedRows().length;

    if (Count1 <= 0) {
        alert(strLang810);
    }
    else {
        DocTypeRow = lvDocTypeList.GetSelectedRows();
        DocTypeName = DocTypeRow[0].cells[0].innerHTML;
        DocTypeID = DocTypeRow[0].getAttribute("DATA1");
    }

    if (Count2 <= 0) {
        alert(strLang811);
    }
    else {
        for (var i = 0; i <= Count2 - 1; i++) {
            ContDocRow = lvContDocList.GetSelectedRows()[i];

            ContDocRow.cells[1].innerHTML = DocTypeName;

            count = lvContDocList.GetSelectedIndexes().split(",")[i];
            Arr_ContType1[count] = count;
            Arr_ContType2[count] = DocTypeID;
        }
    }
}

function DocTypeDel() {
    var ContDocRow, ContDocRow;

    if (lvContDocList.GetRowCount() > 0) {
        for (var i = 0 ; i < lvContDocList.GetSelectedRows().length ; i++) {
            ContDocRow = lvContDocList.GetSelectedRows()[i];

            ContDocRow.cells[1].innerHTML = " ";


            count = lvContDocList.GetSelectedIndexes().split(",")[i];

            Arr_ContType1[count] = count;
            Arr_ContType2[count] = "";
        }
    }
    else {
        alert(strLang812);
    }
}

function RowDel() {
    var selRow;
    var count1;
    var length = lvContDocList.multiSelects.length;
    var length2 = lvContDocList.rows.length;

    if (length > 0 && length2 > 0) {
        for (count1 = length; count1 > 0; count1--) {
            selRow = lvContDocList.multiSelects.item(count1 - 1);
            selRow.remove();
        }
    }
    else {
        alert(strLang813);
    }
}


function DocStateReg() {
    var rowCount = lvContDocList.rows.length;
    var DocStateCount = lvContDocList.rows.item(0).cells[0].DATA1.length;
    var DocStateID = parseInt(lvContDocList.rows.item(rowCount - 1).cells[0].DATA1) + 1;
    sDocStateID = new String(DocStateID);
    DocStateID = Format(DocStateCount, sDocStateID);
    var row = lvContDocList.rows.add();

    row.cells[0].innerText = DocStateName.value;
    row.cells[0].name = DocStateName.value;
    row.cells[0].id = DocStateID;
}

function ContSave() {
    var i, j, tXML, Flag;
    var xmlpara = createXmlDom();
    var strXML = XMLParse();

    xmlpara.async = false;
    xmlpara = loadXMLString(strXML);
    var xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "/admin/ezApprovalG/apprGUpdateContDoctype.do", false);
    xmlhttp.send(xmlpara);

    Flag = xmlhttp.responseText;

    if (Flag == "TRUE") {
        alert(strLang814);
        InitlvContTypeList();
    } else {
        alert(strLang803);
    }
}

function XMLParse() {
    var flag = false;
    chkVal = false;
    var xmlRtn = createXmlDom();
    xmlRtn = loadXMLString(pXML);
    var Row = xmlRtn.getElementsByTagName("PARAMETER")[0].getElementsByTagName("CONTTYPES")[0].getElementsByTagName("CONTTYPE");
    tXML = "<PARAMETER><CONTTYPES>";

    for (var i = 0; i <= Row.length - 1; i++) {
        tXML = tXML + "<CONTTYPE>";
        tXML = tXML + "<STATEID" + i + ">" + SelectSingleNodeValue(Row[i], "STATEID" + i) + "</STATEID" + i + ">";
        if (Arr_ContType1.length > 0) {
            for (var j = 0; j < Arr_ContType1.length; j++) {
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
        flag = false;
    }

    tXML = tXML + "</CONTTYPES><COMPANYID>" + P_companyID + "</COMPANYID></PARAMETER>";

    return tXML;
}


function Format(pCount, pID) {
    var i = pCount;
    var j = pID.length;
    var k;
    for (k = 1; k == i - j; k++) {
        strID = "0" + pID;
    }
    return strID;
}