function selSpecialRecInfo_ondblclick() {
    Add_onclick();
}

function selectedSpecialRec_ondblclick() {
    Del_onclick();
}

function Add_onclick() {
    if (selSpecialRecInfo.options.length > 0) {
        var idx = selSpecialRecInfo.selectedIndex;

        if (idx != -1) {
            InsertToMultipleSelBox(selectedSpecialRec, selSpecialRecInfo.item(idx).text, selSpecialRecInfo.item(idx).value);
        }

    }
}

function Del_onclick() {
    DeleteFromMutipleSelBox(selectedSpecialRec);
}

function InsertToMultipleSelBox(objList, szText, szValue) {
    var IsValueInList = false;

    if (szValue != "") {
        if (objList.options.length > 0) {
            for (i = 0; i < objList.options.length; i++) {
                if (objList.options(i).value == szValue) {
                    IsValueInList = true;
                    break;
                }
            }
        }

        if (!IsValueInList) {
            InsertOption(objList, szValue, szText);
        }
    }
}

function DeleteFromMutipleSelBox(objList) {
    if (objList.options.length > 0) {
        var idx = objList.selectedIndex;

        if (idx != -1) {
            DeleteOption(objList, idx);
        }
    }
}

function InsertOption(objList, strValue, strText) {
    var objOption = new Option();
    objOption.value = strValue;
    objOption.text = strText;

    objList.add(objOption);
}

function DeleteOption(objList, idx) {
    objList.remove(idx);
}

function rdoSecType_onclick(Val) {
    if (document.getElementsByName("rdoSecType")[0].checked) {
        document.getElementsByName("selSecLevel1")[0].checked = false;
        document.getElementsByName("selSecLevel2")[0].checked = false;
        document.getElementsByName("selSecLevel3")[0].checked = false;
        document.getElementsByName("selSecLevel4")[0].checked = false;
        document.getElementsByName("selSecLevel5")[0].checked = false;
        document.getElementsByName("selSecLevel6")[0].checked = false;
        document.getElementsByName("selSecLevel7")[0].checked = false;
        document.getElementsByName("selSecLevel8")[0].checked = false;

        document.getElementsByName("selSecLevel1")[0].disabled = true;
        document.getElementsByName("selSecLevel2")[0].disabled = true;
        document.getElementsByName("selSecLevel3")[0].disabled = true;
        document.getElementsByName("selSecLevel4")[0].disabled = true;
        document.getElementsByName("selSecLevel5")[0].disabled = true;
        document.getElementsByName("selSecLevel6")[0].disabled = true;
        document.getElementsByName("selSecLevel7")[0].disabled = true;
        document.getElementsByName("selSecLevel8")[0].disabled = true;
    }
    else {
        document.getElementsByName("selSecLevel1")[0].disabled = false;
        document.getElementsByName("selSecLevel2")[0].disabled = false;
        document.getElementsByName("selSecLevel3")[0].disabled = false;
        document.getElementsByName("selSecLevel4")[0].disabled = false;
        document.getElementsByName("selSecLevel5")[0].disabled = false;
        document.getElementsByName("selSecLevel6")[0].disabled = false;
        document.getElementsByName("selSecLevel7")[0].disabled = false;
        document.getElementsByName("selSecLevel8")[0].disabled = false;
    }
}

function rdoSecType_onclick_Old(Val) {
    if (rdoSecType[0].checked) {
        selSecLevel.disabled = true;
    }
    else {
        selSecLevel.disabled = false;
    }
}


function GetRegisterDate() {
    if (txtRegY.value != "" && txtRegM.value != "" && txtRegD.value != "") {
        return txtRegY.value + "-" + GetTwoDigitNumber(txtRegM.value) + "-" + GetTwoDigitNumber(txtRegD.value) + " " +
				GetTwoDigitNumber(txtRegH.value) + ":" + GetTwoDigitNumber(txtRegMi.value);
    }
    else {
        return "";
    }
}

function GetRegisterYear() {
    if (txtRegY.value != "")
        return txtRegY.value;
    else
        return "";
}

function GetExecuteDate() {
    if (txtExeY.value != "" && txtExeM.value != "" && txtExeD.value != "") {
        return txtRegY.value + "-" + GetTwoDigitNumber(txtRegM.value) + "-" + GetTwoDigitNumber(txtRegD.value);
    }
    else {
        return "";
    }
}

function GetElectronicRecFlag() {
    if (document.getElementsByName("rdoElectronicFlag")[0].checked)
        return "1";
    else if (document.getElementsByName("rdoElectronicFlag")[1].checked)
        return "2";
}


function GetPublicCode() {
    var PublicCode, i;

    if (document.getElementsByName("rdoSecType")[2].checked)
        PublicCode = "3";
    else if (document.getElementsByName("rdoSecType")[1].checked)
        PublicCode = "2";
    else
        PublicCode = "1";

    if (document.getElementsByName("selSecLevel1")[0].checked)
        PublicCode += "Y";
    else
        PublicCode += "N";

    if (document.getElementsByName("selSecLevel2")[0].checked)
        PublicCode += "Y";
    else
        PublicCode += "N";

    if (document.getElementsByName("selSecLevel3")[0].checked)
        PublicCode += "Y";
    else
        PublicCode += "N";

    if (document.getElementsByName("selSecLevel4")[0].checked)
        PublicCode += "Y";
    else
        PublicCode += "N";

    if (document.getElementsByName("selSecLevel5")[0].checked)
        PublicCode += "Y";
    else
        PublicCode += "N";

    if (document.getElementsByName("selSecLevel6")[0].checked)
        PublicCode += "Y";
    else
        PublicCode += "N";

    if (document.getElementsByName("selSecLevel7")[0].checked)
        PublicCode += "Y";
    else
        PublicCode += "N";

    if (document.getElementsByName("selSecLevel8")[0].checked)
        PublicCode += "Y";
    else
        PublicCode += "N";

    return PublicCode;
}


function GetPublicCode_Old() {
    var PublicCode, i;
    var SecLevel = parseInt(document.getElementsByName("selSecLevel").value);
    var Len = document.getElementsByName("selSecLevel").options.length;

    if (document.getElementsByName("rdoSecType")[2].checked)
        PublicCode = "3";
    else if (document.getElementsByName("rdoSecType")[1].checked)
        PublicCode = "2";
    else
        PublicCode = "1";

    if (PublicCode == "1") {
        for (i = 0; i < Len; i++) {
            PublicCode += "N";
        }
    }
    else {
        for (i = 0; i < Len; i++) {
            if (parseInt(SecLevel) - 1 == i)
                PublicCode += "Y";
            else
                PublicCode += "N";
        }
    }

    return PublicCode;
}

function GetSpecialRecInfo() {

    var rtnStr = "";

    if (document.getElementsByName("special1")[0].checked)
        rtnStr += "Y";
    else
        rtnStr += "N";

    if (document.getElementsByName("special2")[0].checked)
        rtnStr += "Y";
    else
        rtnStr += "N";

    if (document.getElementsByName("special3")[0].checked)
        rtnStr += "Y";
    else
        rtnStr += "N";

    if (document.getElementsByName("special4")[0].checked)
        rtnStr += "Y";
    else
        rtnStr += "N";

    if (document.getElementsByName("special5")[0].checked)
        rtnStr += "Y";
    else
        rtnStr += "N";

    return rtnStr;
}

function GetSpecialRecInfo_Old() {
    var len, i, rtnStr;
    var arrTemp = new Array();
    var CodeLen = selSpecialRecInfo.options.length;

    for (i = 0; i < CodeLen; i++)
        arrTemp[i] = "N";


    len = selectedSpecialRec.options.length;

    if (len > 0) {
        for (i = 0; i < len; i++) {
            var iVal = parseInt(selectedSpecialRec.options(i).value);
            arrTemp[iVal - 1] = "Y";
        }
    }

    rtnStr = "";
    for (i = 0; i < CodeLen; i++)
        rtnStr += arrTemp[i];

    return rtnStr;
}