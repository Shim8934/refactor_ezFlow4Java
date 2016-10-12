var selecttask_cross_dialogArguments = new Array();
function SelectTask(pDeptCode, pDeptName, pInitFlag, pMultiSelect, opentype, CompleteFunction) {
    var rtn;
    var para = new Array();
    para[0] = pDeptCode;
    para[1] = pDeptName;

    var url = "/ezApprovalG/selectTask.do?initFlag=" + pInitFlag + "&multiSelect=" + pMultiSelect;

    selecttask_cross_dialogArguments[0] = para;
    if (opentype == undefined && CompleteFunction == undefined) {
        selecttask_cross_dialogArguments[1] = SelectTask_Complete;
        DivPopUpShow(725, 430, url);
    }
    else if (opentype == undefined && CompleteFunction != undefined) {
        selecttask_cross_dialogArguments[1] = CompleteFunction;
        DivPopUpShow(725, 430, url);
    }
    else if (opentype != undefined && CompleteFunction == undefined) {
        selecttask_cross_dialogArguments[1] = SelectTask_Complete;
        var OpenWin = window.open(url, "SelectTask_Cross", GetOpenWindowfeature(725, 430));
        try { OpenWin.focus(); } catch (e) { }
    }
    else {
        selecttask_cross_dialogArguments[1] = CompleteFunction;
        var OpenWin = window.open(url, "SelectTask_Cross", GetOpenWindowfeature(725, 430));
        try { OpenWin.focus(); } catch (e) { }
    }
    return rtn;
}

var selectdept_cross_dialogArguments = new Array();
function SelectDept(opentype, CompleteFunction) {
    var rtn;
    var para = new Array();
    var url = "/ezApprovalG/selectDept.do";

    selectdept_cross_dialogArguments[0] = para;

    if (opentype == undefined && CompleteFunction == undefined) {
        selectdept_cross_dialogArguments[1] = SelectDept_Complete;
        DivPopUpShow(330, 350, url);
    }
    else if (opentype == undefined && CompleteFunction != undefined) {
        selectdept_cross_dialogArguments[1] = CompleteFunction;
        DivPopUpShow(330, 350, url);
    }
    else if (opentype != undefined && CompleteFunction == undefined) {
        selectdept_cross_dialogArguments[1] = SelectDept_Complete;
        var OpenWin = window.open(url, "SelectDept_Cross", GetOpenWindowfeature(330, 350));
        try { OpenWin.focus(); } catch (e) { }
    }
    else {
        selectdept_cross_dialogArguments[1] = CompleteFunction;
        var OpenWin = window.open(url, "SelectDept_Cross", GetOpenWindowfeature(330, 350));
        try { OpenWin.focus(); } catch (e) { }
    }
}

function SelectDept_Complete(rtn) {
    DivPopUpHidden();
    if (rtn[0] == "TRUE") {
        g_DeptCode = rtn[1];
        txtDeptName.value = rtn[2];
    }
}

var selectuser_cross_dialogArguments = new Array();
function SelectUser(pCabClassNo, pDeptCode) {
    var rtn;
    var para = new Array();
    para[0] = pCabClassNo;
    para[1] = pDeptCode;

    var url = "/ezApprovalG/selectUser.do";

    if (CrossYN()) {
        selectuser_cross_dialogArguments[0] = para;
        selectuser_cross_dialogArguments[1] = SelectUsert_Complete;

        DivPopUpShow(440, 330, url);
    }
    else {
        var feature = "dialogWidth:512px;dialogHeight:415px;scroll:no;resizable:no;status:no;help:no;edge:sunken ";
        feature = feature + GetShowModalPosition(495, 360);

        if (url != "")
            rtn = window.showModalDialog(url, para, feature);

        if (rtn[0] == "TRUE")
            GetSelUserInfo(rtn[1]);
    }
}

function SelectUsert_Complete(rtn) {
    DivPopUpHidden();
    if (rtn[0] == "TRUE")
        GetSelUserInfo(rtn[1]);
}

var ezapropinion_cross_dialogArguments = new Array();
function OpenInformationUI(pInformationContent, CompleteFunction) {
    var parameter = pInformationContent;
    var url = "/ezApprovalG/ezAprOpinion.do";

    if (CrossYN()) {
        ezapropinion_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapropinion_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;

        var OpenWin = window.open(url, "_blank" , GetOpenWindowfeature(330, 205));
        
        try { OpenWin.focus(); } catch (e) { }
        
        return OpenWin;
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
    return RtnVal;
}

function OpenInformationUI_Complete() {
    DivPopUpHidden();
}

function OpenAlertUI_ezCab(pAlertContent) {
    var parameter = pAlertContent;
    var url = "/myoffice/ezApprovalG/ezCabinet/ezALERTMSG_Cross.aspx";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no";
    feature = feature + GetShowModalPosition(330, 205);
    var RtnVal = window.showModalDialog(url, parameter, feature);
}

function OpenAlertUIWithSize(pAlertContent, pWidth, pHeight, Scroll) {
    var parameter = pAlertContent;
    var url = "/myoffice/ezApprovalG/ezCabinet/ezALERTMSG_Cross.aspx";
    var feature = "status:no;dialogWidth:" + pWidth + "px;dialogHeight:" + pHeight + "px;help:no;scroll:" + Scroll;
    feature = feature + GetShowModalPosition(pWidth, pHeight);
    var RtnVal = window.showModalDialog(url, parameter, feature);
}

