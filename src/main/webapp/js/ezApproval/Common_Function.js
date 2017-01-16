var ezapralert_cross_dialogArgument = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "";
    if(CompleteFunction == "OPEN")
        url = "/admin/ezApproval/ezAprAlert.do?type=OPEN";
    else
        url = "/admin/ezApproval/ezAprAlert.do";

    if (CrossYN()) {
        ezapralert_cross_dialogArgument[0] = parameter;
        ezapralert_cross_dialogArgument[1] = CompleteFunction;

        if (CompleteFunction != undefined) {
            if (CompleteFunction == "OPEN")
            {
                var OpenWin = GetOpenWindow(url, "", 330, 205, "NO");
            }
            else
                DivPopUpShow(330, 205, url);
        }
        else {            
            ezapralert_cross_dialogArgument[1] = OpenAlertUI_Complete;
            DivPopUpShow(330, 205, url);
        }
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
}

function OpenAlertUI_Complete(RtnVal) {
    DivPopUpHidden();
}

function OpenAlertUI_SUB(pAlertContent) {
    var parameter = pAlertContent;
    var url = "/adminj/ezApproval/ezAprAlert.do";

    if (CrossYN() || pNoneActiveX == "YES") {
        ezapralert_cross_dialogArgument[0] = parameter;
        ezapralert_cross_dialogArgument[1] = OpenAlertUI_SUB_Complete;
        ezapralert_cross_dialogArgument[2] = "";
        DivPopUpShow_sub(330, 205, url);
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
}
function OpenAlertUI_SUB_Complete(RtnVal) {
    DivPopUpHidden_sub();   
}

var AprOpinion_dialogArgument = new Array();
function openOpinionUI(pOpinionFlag) {
    try {
        var parameter = new Array();
        parameter[0] = pDocID;

        try {
            rtnValue[0] = pOpinionFlag;
            rtnValue[1] = opinionSend;
            rtnValue[2] = pDraftFlag;
            rtnValue[3] = rtnValue[3] == undefined ? "" : rtnValue[3];
            parameter[1] = rtnValue;
        }
        catch (e) {
            parameter[1] = pOpinionFlag;
        }

        parameter[2] = KuyjeType;
        parameter[3] = pDraftFlag;

        var url = "/myoffice/ezApproval/ezAPROPINION/AprOpinion.aspx";
        AprOpinion_dialogArgument[0] = parameter;
        AprOpinion_dialogArgument[1] = openOpinionUI_Complete;
        DivPopUpShow(530, 520, url);
     
    } catch (e) {
        alert(e.description);
    }
}

var aprattach_dialogArgument = new Array();
function openFileAttachUI() {
    try {
        var parameter = pDocID;
        var url = "/myoffice/ezApproval/ezAPRATTACH/AprAttach2.aspx?pDocID=" + pDocID;
        aprattach_dialogArgument[0] = parameter;
        aprattach_dialogArgument[1] = openFileAttachUI_Complete;
        DivPopUpShow(580, 290, url);
    } catch (e) {
        alert("openFileAttachUI()" + e.description);
    }
}
function openFileAttachUI_Complete(RtnVal)
{
    if (RtnVal != "cancel") {
        setAttachInfo(pDocID, "APR", lstAttachLink);
    }
    DivPopUpHidden();
}

var ezapropinion_cross_dialogArgument = new Array();
function OpenInformationUI(pInformationContent, FunctionName, Type) {
    var parameter = pInformationContent;
    var url = "/admin/ezApproval/ezAprOpinion.do";
    if (CrossYN() || pNoneActiveX == "YES") {
        ezapropinion_cross_dialogArgument[0] = parameter;
        ezapropinion_cross_dialogArgument[1] = OpenInformationUI_Complete;
        ezapropinion_cross_dialogArgument[2] = FunctionName;
        if (Type == undefined) {
            DivPopUpShow(330, 205, url);
        }
        else {
            var result = GetOpenWindow(url + "?type=open", "ezAPROPINION_Cross", 325, 200, "NO");
        }
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
        return RtnVal;
    }
}
function OpenInformationUI_Complete(RtnVal, Complete_Function)
{
    DivPopUpHidden();
    if (RtnVal)
        Complete_Function(RtnVal);    
}


function OpenInformationTFUI(pInformationContent, FunctionName, Type) {
    var parameter = pInformationContent;
    var url = "/admin/ezApproval/ezAprOpinion.do";
    if (CrossYN() || pNoneActiveX == "YES") {
        ezapropinion_cross_dialogArgument[0] = parameter;
        ezapropinion_cross_dialogArgument[1] = OpenInformationTFUI_Complete;
        ezapropinion_cross_dialogArgument[2] = FunctionName;
        if (Type == undefined) {
            DivPopUpShow(330, 205, url);
        }
        else {
            var result = GetOpenWindow(url + "?type=open", "ezAPROPINION_Cross", 325, 200, "NO");
        }
    }
    else {
        var feature = "status:no;dialogWidth:325px;dialogHeight:200px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(325, 200);
        var RtnVal = window.showModalDialog(url, parameter, feature);
        return RtnVal;
    }
}
function OpenInformationTFUI_Complete(RtnVal, Complete_Function) {
    DivPopUpHidden();
    Complete_Function(RtnVal);
}
