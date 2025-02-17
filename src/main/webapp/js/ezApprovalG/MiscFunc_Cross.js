/**
 * XML데이터를 Array에 저장
 * */
function InitCodeSelectBox(nodeXml, objSel) {
    objSel.innerHTML = "";
    var strText, strValue, i;
    var selOption = new Array();

    if (nodeXml) {
        for (i = 0; i < nodeXml.length; i++) {
            strValue = getNodeText(GetChildNodes(nodeXml[i])[0]);
            if (typeof(UserLang) != 'undefined' && UserLang != '1' && getNodeText(GetChildNodes(nodeXml[i])[2]) != null && getNodeText(GetChildNodes(nodeXml[i])[2]) != undefined && getNodeText(GetChildNodes(nodeXml[i])[2]).trim() !== '') {
                strText = getNodeText(GetChildNodes(nodeXml[i])[2]);
            } else {
                strText = getNodeText(GetChildNodes(nodeXml[i])[1]);
            }

            selOption[i] = new Option(strText, strValue);
            selOption[i].id = strValue;
            objSel.options[i] = selOption[i];
        }
    }
}

function InitCodeSelBoxWithNullOpt(nodeXml, objSel) {
    var strText, strValue, i;
    var selOption = new Array();
    var objNullOption = new Option("", "");
    objSel.options[0] = objNullOption;
    if (nodeXml != null) {
        for (i = 0; i < nodeXml.length; i++) {
            var nodes = GetChildNodes(nodeXml[i]);
            strValue = getNodeText(GetChildNodes(nodeXml[i])[0]);
            strText = getNodeText(GetChildNodes(nodeXml[i])[1]);
            selOption[i] = new Option(strText, strValue);
            selOption[i].id = strValue;
            objSel.options[i + 1] = selOption[i];
        }
    }
}

function DelListRow(objListView) {
    var pListView = new ListView();     
    pListView.LoadFromID(objListView);

    var selRow;
    var count1, len;
    var selRows = pListView.GetSelectedRows();

    if (selRows) {
        len = selRows.length;
        if (len > 0) {
            for (count1 = 0; count1 < len; count1++) {
                selRow = GetAttribute(selRows[count1], "id");
                pListView.DeleteRow(selRow);

            }
        }
    }
}

function DelAllRowOfLV(objListView) {
	var pListView = new ListView();
	pListView.LoadFromID(objListView);
	
	var count;
	var rowLength = pListView.GetRowCount();
	
	if (rowLength != 0) {
		for (count = 0; count < rowLength; count++) {
			pListView.DeleteRow(pListView.GetSelectedRowID(0));
		}
	}
	
	setDeleteRow(pListView.GetID());
}

function selectRow(oListView, RowIndex) {
    var DocList = new ListView();
    DocList.LoadFromID(oListView);

    var cnt = DocList.GetRowCount();

    if (cnt - 1 >= RowIndex) {
        DocList.SetSelectedIndex(RowIndex);
        return true;
    }
    else {
        return false;
    }
}

function SelectOption(objSel, szVal) {
    if (szVal != "") {
        SelOptionInSingleSelBox(objSel, szVal);
    }
}

function SelOptionInSingleSelBox(objSelection, strValue) {
    /*if (CrossYN()) {
        if (objSelection.options[strValue])
            objSelection.selectedIndex = objSelection.options[strValue].index;
    }
    else {
        for (var i = 0; i < objSelection.options.length; i++) {
            if (objSelection.options[i].id == strValue)
                objSelection.selectedIndex = i;
        }
    }*/
	for (var i = 0; i < objSelection.options.length; i++) {
        if (objSelection.options[i].id == strValue)
            objSelection.selectedIndex = i;
    }
}

function ValidateYearValue(strYear) {
    if (strYear.length > 0) {
        var strMatch = strYear.match(/^[0-9]+$/);
        if (!strMatch || strYear.length != 4)
            return false;
        else
            return true;
    }
    else {
        return true;
    }
}

/* 2024-06-13 양지혜 - 시, 분은 0 가능. type 추가하여 분기를 나누도록 함 (Y:0체크O, N:0체크X) */
function ValidateNumber(strValue, type) {
    if (strValue.length > 0) {
        var strMatch = strValue.match(/^[0-9]+$/);
        if (!strMatch) {
            return false;
        } else if (strMatch && type == 'Y') {
        	strMatch = strValue.match(/^[0]+$/);
        	if (!strMatch) {
        		return true;
        	} else {
        		return false;
        	}
        } else {
            return true;
        }
    }
    else {
        return true;
    }
}

//등록일자의 분에 00을 입력할 경우, 등록되지 않던 버그 수정. 2019-12-03 홍대표.
function ValidateMinuteNumber(strValue) {
	if (strValue.length > 0) {
		var strMatch = strValue.match(/^[0-9]+$/);
		if (!strMatch) {
			return false;
		} else {
			return true;
		}
	}
	else {
		return true;
	}
}

function GetTwoDigitNumber(szVal) {
    if (szVal.length == 0)
        return "00";
    else if (szVal.length == 1)
        return "0" + szVal;
    else
        return szVal;
}

function GetDisplayEndDate() {
    return txtDisplayEndY.value + GetTwoDigitNumber(txtDisplayEndM.value) + GetTwoDigitNumber(txtDisplayEndD.value);
}

function InsValueIntoTD(objTD, szValue) {
    if (szValue == "") {
        objTD.innerHTML = " ";
    }
    else {
        objTD.innerHTML = szValue;
    }
}

function InsYNIntoTD(objTD, szValue) {
    if (szValue == "0") {
        objTD.innerHTML = "N";
    }
    else if (szValue == "1") {
        objTD.innerHTML = "Y";
    }
    else if (szValue == "") {
        objTD.innerHTML = " ";
    }
}

var printmetainfo_ck_dialogArguments = new Array();
function PrintMetaData(pFlag, pID1, pID2) {
    var para = new Array();
    para[0] = pFlag;
    para[1] = pID1;
    para[2] = pID2;

    var url = "/ezApprovalG/printMetaInfo.do";
        printmetainfo_ck_dialogArguments[0] = para;
        var OpenWin = window.open(url, "PrintMetaInfo_CK", GetOpenWindowfeature(850, 550));
        try { OpenWin.focus(); } catch (e) { }
}

function get_length(chkstr) {
    var length = 0;
    var i;

    for (i = 0; i < chkstr.length; i++)
        if (chkstr.charCodeAt(i) > 256)
            length = length + 2;
        else
            length++;

    return length;
}


function GetFileName(strItemUrl) {
    var indexA;
    indexA = strItemUrl.lastIndexOf("/");
    return strItemUrl.slice(indexA + 1);
}

function GetFileDisplayName(strFileName) {
    var indexA;
    indexA = strFileName.lastIndexOf(".");

    return strFileName.substring(0, indexA);
}

function GetFileExtension(strFileName) {
    var indexA;
    indexA = strFileName.lastIndexOf(".");
    return strFileName.slice(indexA + 1);
}

