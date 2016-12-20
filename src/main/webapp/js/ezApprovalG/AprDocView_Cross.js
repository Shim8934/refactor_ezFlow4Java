var apropinion_cross_dialogArguments = new Array();
function openOpinionViewUI() {
    var parameter = new Array();
    parameter[0] = pDocID;
    parameter[1] = pOpinionType;    
    parameter[2] = "";
    parameter[3] = "";

    apropinion_cross_dialogArguments[0] = parameter;
    apropinion_cross_dialogArguments[1] = openOpinionViewUI_Complete;

    DivPopUpShow(530, 520, "/ezApprovalG/aprOpinion.do");
}

function openOpinionViewUI_Complete() {
    DivPopUpHidden();
}

//Form Processor 문서정보를 Load하는 함수
function LoadpzFormDocInfo() {
    flag = true;

    pDocID = DocID;
    pDocHref = DocHref;
    pOpinionFlag = OpinionFlag;

    pListTypeValue = ListTypeValue;

    if (pListTypeValue == "4")
        pListSusin = ListSusin;

    if (pDocHref != "") {
        message.Set_EditorContentURL(pDocHref);
        setAttachInfo(pDocID, "APR", lstAttachLink);
        GetExchInfo();

        if (pHasOpinion == "Y") {
            var pInformationContent = strLang837 + "<br> " + strLang838;
            var Ans = OpenInformationUI(pInformationContent, LoadpzFormDocInfo_Complete);
        }
    }
}

function LoadpzFormDocInfo_Complete(Ans) {
    DivPopUpHidden();
    if (Ans) {
        openOpinionViewUI();
    }
}

var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN()) {
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
        DivPopUpShow(330, 205, url);
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


function setMenuBar(id, flag) {
    var strCmd, display_Value;

    if (flag) 
        display_Value = "";
    else
        display_Value = "none";

    strCmd = id + ".style.display='" + display_Value + "'";
    eval(strCmd);

    strCmd = id + "1.style.display='" + display_Value + "'";
    eval(strCmd);

    strCmd = id + "2.style.display='" + display_Value + "'";
    eval(strCmd);
}

var ezaprhistory_cross_dialogArguments = new Array();
function getHistory() {
    var URL = "/ezApprovalG/ezAprHistory.do?docID=" + pDocID;

    ezaprhistory_cross_dialogArguments[0] = "";
    ezaprhistory_cross_dialogArguments[1] = getHistory_Complete;

    DivPopUpShow(730, 430, URL);
}

function getHistory_Complete() {
    DivPopUpHidden();
}