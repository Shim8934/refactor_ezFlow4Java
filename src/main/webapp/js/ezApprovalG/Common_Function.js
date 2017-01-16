var ezapralert_cross_dialogArgument = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "";
    if(CompleteFunction == "OPEN")
        url = "/myoffice/ezApproval/ezAPRALERT_Cross.aspx?type=OPEN";
    else
        url = "/myoffice/ezApproval/ezAPRALERT_Cross.aspx";

    if (CrossYN() || pNoneActiveX == "YES") {
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
    var url = "/myoffice/ezApproval/ezAPRALERT_Cross.aspx";

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

var apropinion_cross_dialogArgument = new Array();
function openOpinionUI(pOpinionFlag) {
    try {
        var parameter = new Array();
        parameter[0] = pDocID;
        parameter[1] = pOpinionFlag;
        parameter[2] = KuyjeType;
        parameter[3] = pDraftFlag;

        var url = "/myoffice/ezApprovalG/ezAPROPINION/AprOpinion.aspx";
        apropinion_cross_dialogArgument[0] = parameter;
        apropinion_cross_dialogArgument[1] = openOpinionUI_Complete;
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
    var url = "/myoffice/ezApproval/ezAPROPINION_Cross.aspx";
    if (CrossYN() || pNoneActiveX == "YES") {
        ezapropinion_cross_dialogArgument[0] = parameter;
        ezapropinion_cross_dialogArgument[1] = OpenInformationUI_Complete;
        ezapropinion_cross_dialogArgument[2] = FunctionName;
        if (Type == undefined) {
            DivPopUpShow(330, 205, url);
        }
        else {
            GetOpenWindow(url + "?type=open", "ezAPROPINION_Cross", 325, 200, "NO");
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
