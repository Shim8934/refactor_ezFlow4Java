/**
 * 구해안
 */

function viewCommuList() {
    window.open("/ezCommunity/communityMain.do?funCode=5", "main", "");
}

var ezapralert_cross_dialogArguments = new Array();

function OpenAlertUI(NewWinContent, NewWinCallFunction, NewWinName) {
    var parameter = NewWinContent;

    if (CrossYN()) {
        ezapralert_cross_dialogArguments[0] = parameter;

        if (NewWinCallFunction != undefined || NewWinCallFunction != null)
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;

        var windowopenfeature = "height=205px,width=330px,status=no,toolbar=no,menubar=no,location=no,resizable=1";
        windowopenfeature = windowopenfeature + GetOpenPosition(205, 330);

        window.open("/ezCommunity/ezAprAlert.do", NewWinName, windowopenfeature);
    } else {
        var windowshomodalDialogfeature = "status:no;dialogWidth:330px;dialogHeight:207px;help:no;scroll:no;edge:sunken";
        windowshomodalDialogfeature = windowshomodalDialogfeature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog("/ezCommunity/ezAprAlert.do", parameter, windowshomodalDialogfeature);
    }
}

function OpenAlertUI_Complete() {
    //Source Code...
}