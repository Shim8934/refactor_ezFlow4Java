function checkDocinfo() {
    var p_AprDeptTempletName = document.getElementById("txtPageNum").value;
    if (p_AprDeptTempletName.length > 0) {
        var strMatch = p_AprDeptTempletName.match(/^[0-9]+$/);
        if (!strMatch) {
            var pAlertContent = Docalt1;
            OpenAlertUI(pAlertContent);
            return false;
        }
    }
    else {
        var pAlertContent = Docalt2;
        OpenAlertUI(pAlertContent);
        return false;
    }
    if (p_AprDeptTempletName.length > 3) {
        var pAlertContent = Docalt3;
        OpenAlertUI(pAlertContent);
        return false;
    }
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    if (("" + month).length == 1)
        month = "0" + month;
    var day = date.getDate();
    var curDate = new Date(year, month, day);
    var sel = document.getElementById("idDatepicker").value.substring(0, 10);
    var selDate = new Date(sel.substring(0, 4), sel.substring(5,7), sel.substring(8,10));
    
    if (document.getElementById("AprSecurity").checked) {
        if (selDate < curDate) {
            var pAlertContent = Docalt4;
            OpenAlertUI(pAlertContent);
            return false;
        }
    }
    return true;
}
function setPublicFlag(vPublicFlag) {
    switch (vPublicFlag.substring(0, 1)) {
        case "1":
            document.getElementsByName("rdoSecType")[0].checked = true;
            break;
        case "2":
            document.getElementsByName("rdoSecType")[1].checked = true;
            break;
        case "3":
            document.getElementsByName("rdoSecType")[2].checked = true;
            break;
    }
    rdoSecType_onclick(vPublicFlag.substring(0, 1));
    for (var i = 1; i <= 8; i++) {
        if (vPublicFlag.substring(i, i + 1) == "Y") {
            switch (i) {
                case 1:
                    document.getElementById("selSecLevel1").checked = true;
                    break;
                case 2:
                    document.getElementById("selSecLevel2").checked = true;
                    break;
                case 3:
                    document.getElementById("selSecLevel3").checked = true;
                    break;
                case 4:
                    document.getElementById("selSecLevel4").checked = true;
                    break;
                case 5:
                    document.getElementById("selSecLevel5").checked = true;
                    break;
                case 6:
                    document.getElementById("selSecLevel6").checked = true;
                    break;
                case 7:
                    document.getElementById("selSecLevel7").checked = true;
                    break;
                case 8:
                    document.getElementById("selSecLevel8").checked = true;
                    break;
            }
        }
    }
}
function getPublicFlag() {
    var strrtn = "";
    if (document.getElementsByName("rdoSecType")[0].checked)
        strrtn = strrtn + "1";
    else if (document.getElementsByName("rdoSecType")[1].checked)
        strrtn = strrtn + "2";
    else if (document.getElementsByName("rdoSecType")[2].checked)
        strrtn = strrtn + "3";
    if (document.getElementsByName("rdoSecType")[0].checked)
        return strrtn + "NNNNNNNN";
    if (document.getElementById("selSecLevel1").checked)
        strrtn = strrtn + "Y";
    else
        strrtn = strrtn + "N";
    if (document.getElementById("selSecLevel2").checked)
        strrtn = strrtn + "Y";
    else
        strrtn = strrtn + "N";
    if (document.getElementById("selSecLevel3").checked)
        strrtn = strrtn + "Y";
    else
        strrtn = strrtn + "N";
    if (document.getElementById("selSecLevel4").checked)
        strrtn = strrtn + "Y";
    else
        strrtn = strrtn + "N";
    if (document.getElementById("selSecLevel5").checked)
        strrtn = strrtn + "Y";
    else
        strrtn = strrtn + "N";
    if (document.getElementById("selSecLevel6").checked)
        strrtn = strrtn + "Y";
    else
        strrtn = strrtn + "N";
    if (document.getElementById("selSecLevel7").checked)
        strrtn = strrtn + "Y";
    else
        strrtn = strrtn + "N";
    if (document.getElementById("selSecLevel8").checked)
        strrtn = strrtn + "Y";
    else
        strrtn = strrtn + "N";
    return strrtn;
}
function setdocdisplay(vdocdisplay) {
    if (vdocdisplay.substring(0, 1) == "Y")
        document.getElementById("special1").checked = true;
    else
        document.getElementById("special1").checked = false;
    if (vdocdisplay.substring(1, 2) == "Y")
        document.getElementById("special2").checked = true;
    else
        document.getElementById("special2").checked = false;
    if (vdocdisplay.substring(2, 3) == "Y")
        document.getElementById("special3").checked = true;
    else
        document.getElementById("special3").checked = false;
    if (vdocdisplay.substring(3, 4) == "Y")
        document.getElementById("special4").checked = true;
    else
        document.getElementById("special4").checked = false;
    if (vdocdisplay.substring(4, 5) == "Y")
        document.getElementById("special5").checked = true;
    else
        document.getElementById("special5").checked = false;
}
function getdocdisplay() {
    var strrtn = "";
    if (document.getElementById("special1").checked)
        strrtn = strrtn + "Y";
    else
        strrtn = strrtn + "N";
    if (document.getElementById("special2").checked)
        strrtn = strrtn + "Y";
    else
        strrtn = strrtn + "N";
    if (document.getElementById("special3").checked)
        strrtn = strrtn + "Y";
    else
        strrtn = strrtn + "N";
    if (document.getElementById("special4").checked)
        strrtn = strrtn + "Y";
    else
        strrtn = strrtn + "N";
    if (document.getElementById("special5").checked)
        strrtn = strrtn + "Y";
    else
        strrtn = strrtn + "N";
    return strrtn;
}
function setSecurityList() {
    var i;
    var selOption = new Array();
    var xmlhttp = createXMLHttpRequest();
    var xmldoc = createXmlDom();
    xmlhttp.open("POST", "../ezCabinet/aspx/API_GetCodeList.aspx", false);
    xmlhttp.send();
    xmldoc = xmlhttp.responseXML;
    var objNodes = xmldoc.documentElement.selectNodes("SECURITYLEVEL/CODE");
    if (objNodes) {
        for (i = 0; i < objNodes.length; i++) {
            strValue = objNodes.item(i).childNodes(0).text;
            strText = objNodes.item(i).childNodes(1).text;
            selOption[i] = new Option(strText, strValue);
            selOption[i].id = strValue;
            selSecLevel.options[i] = selOption[i];
        }
    }
}
function rdoSecType_onclick(Val) {
    if (document.getElementsByName("rdoSecType")[0].checked) {
        document.getElementById("selSecLevel1").disabled = true;
        document.getElementById("selSecLevel2").disabled = true;
        document.getElementById("selSecLevel3").disabled = true;
        document.getElementById("selSecLevel4").disabled = true;
        document.getElementById("selSecLevel5").disabled = true;
        document.getElementById("selSecLevel6").disabled = true;
        document.getElementById("selSecLevel7").disabled = true;
        document.getElementById("selSecLevel8").disabled = true;
    }
    else {
        document.getElementById("selSecLevel1").disabled = false;
        document.getElementById("selSecLevel2").disabled = false;
        document.getElementById("selSecLevel3").disabled = false;
        document.getElementById("selSecLevel4").disabled = false;
        document.getElementById("selSecLevel5").disabled = false;
        document.getElementById("selSecLevel6").disabled = false;
        document.getElementById("selSecLevel7").disabled = false;
        document.getElementById("selSecLevel8").disabled = false;
    }
}
var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN() || NonActiveX == "YES") {
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

function AprSecurity_onClick() {
    if (document.getElementById("AprSecurity").checked) {
        document.getElementById("idDatepicker").disabled = "";
        document.getElementById("img_Post_D1").style.display = "";
    }
    else {
        document.getElementById("idDatepicker").disabled = "disabled";
        document.getElementById("img_Post_D1").style.display = "none";
    }
}

