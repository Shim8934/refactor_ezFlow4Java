function btnSummaryEdit() {
    try {
        DivPopUpShow(713, 570, "/ezApprovalG/apprGSummaryEdit.do?docID=" + pDocID);
    } catch (e) {
        console.log(e);
        showAlert(strLang199);
    }
}
        
function btnSummaryEdit_Complete(rtn) {
    switch (rtn.status) {
        case "success":
            showAlert(strLangJIH_Summary01);
            pSummery = rtn.summary;
            pSummaryPath = rtn.summaryPath;
            DivPopUpHidden();
            break;
        case "cancel":
            DivPopUpHidden();
            break;
        case "noData":
            showAlert(strLangJIH_Summary02);
            break;
        default:
            showAlert(strLang199);
    }
}

function btnSummaryView() {
    var aprOrEndStr = getAprOrEndStr();
    var openLocation = "/ezApprovalG/apprGSummaryView.do?docID=" + pDocID + "&mode=" + aprOrEndStr;
    DivPopUpShow(713, 570, openLocation);       
}

function getAprOrEndStr() {
    var result = "";
    $.ajax({
        type : "GET",
        dataType : "text",
        async : false,
        url : "/ezApprovalG/getAprOrEndStr.do",
        data : {
            docID : pDocID,
            orgCompanyID : orgCompanyID
        },
        success: function(text){
            result = text;
        }
    });
    return result;
}

function btnSummaryPrint_onclick() {
    var aprOrEndStr = getAprOrEndStr();
    var feature = "width=800, height=500, toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1";
    var url = "/ezApprovalG/printApprGSummary.do?docID=" + pDocID + "&mode=" + aprOrEndStr;
    feature = feature + GetOpenPosition(800, 500);
    window.open(url, "", feature);
}

function copySummaryForReuse(orgDocID, docID) {
     var result = "";
    $.ajax({
        type : "POST",
        dataType : "text",
        async : false,
        url : "/ezApprovalG/apprGCopyForReuse.do",
        data : {
            orgDocID : orgDocID,
            docID : docID
        },
        success: function(text){
            result = text;
        }
    });
    return result;
}