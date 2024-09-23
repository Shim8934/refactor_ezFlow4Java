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
        
        //원문정보공개 관련
        $("#openListFlag").prop("checked", true);
        $(".fileOpenFlagChk").prop("checked", true);
        $(".fileOpenFlagChk").attr("disabled", true);
        $("#reason").hide();
        $(".fileOpenFlag").text("공개");
    }
    else if (document.getElementsByName("rdoSecType")[1].checked) {
    	//부분공개
    	document.getElementById("selSecLevel1").disabled = false;
    	document.getElementById("selSecLevel2").disabled = false;
    	document.getElementById("selSecLevel3").disabled = false;
    	document.getElementById("selSecLevel4").disabled = false;
    	document.getElementById("selSecLevel5").disabled = false;
    	document.getElementById("selSecLevel6").disabled = false;
    	document.getElementById("selSecLevel7").disabled = false;
    	document.getElementById("selSecLevel8").disabled = false;
    	
    	$(".fileOpenFlagChk").attr("disabled", false);
    	$("#reason").show();
    	$("#txt_Reason").show();
    	if ($("#txt_Reason").val() != "") {
        	$("#txt_Reason").val(reason);
        }
    } else {
    	//비공개
    	document.getElementById("selSecLevel1").disabled = false;
    	document.getElementById("selSecLevel2").disabled = false;
    	document.getElementById("selSecLevel3").disabled = false;
    	document.getElementById("selSecLevel4").disabled = false;
    	document.getElementById("selSecLevel5").disabled = false;
    	document.getElementById("selSecLevel6").disabled = false;
    	document.getElementById("selSecLevel7").disabled = false;
    	document.getElementById("selSecLevel8").disabled = false;
    	
    	$(".fileOpenFlagChk").prop("checked", false);
    	$(".fileOpenFlagChk").attr("disabled", true);
    	$("#reason").show();
    	if ($("#txt_Reason").val() != "") {
        	$("#txt_Reason").val(reason);
        }
    	$(".fileOpenFlag").text("비공개");
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
    if (regDate.value != "" && regTime.value != "") {
        return regDate.value + " " + regTime.value;
    } else {
        return "";
    }
}

function GetRegisterYear() {
    if (regDate.value != "")
        return regDate.value.substring(0, 4);
    else
        return "";
}

function GetExecuteDate() {
    if (exeDate.value != "") {
        return exeDate.value;
    } else {
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